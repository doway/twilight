/****** Object:  StoredProcedure [dbo].[log_LiveMonitoring]    Script Date: 05/15/2012 12:07:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[log_LiveMonitoring]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[log_LiveMonitoring]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[log_LiveMonitoring]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Tom Tang
-- Create date: 2011-03-29
-- Modify By Austin 2012-01-19
-- Description:	Query statistic for live monitoring
-- Revision:
-- 2012-02-25: Add BUName in output result and sort result by severity in [Level]
-- 2012-06-15: Replace [Logger] with [AppName]
-- 2012-08-08: Add [BUID] column in result
-- 2012-11-05: Enhance query performance by using index hint
-- =============================================
CREATE PROCEDURE [dbo].[log_LiveMonitoring]
	@APTime AS DATETIME = NULL,
	@TimeSpanInMins AS SMALLINT = 5,
	@Level AS CHAR(5) = NULL,
	@TimeType AS INT = 1
AS
BEGIN
	DECLARE @DBTime AS DATETIME;        SET @DBTime		= GETDATE();
	DECLARE @DBPastTime AS DATETIME;	SET @DBPastTime = DATEADD(mi, -@TimeSpanInMins, @DBTime);
	DECLARE @APPastTime AS DATETIME;	SET @APPastTime = DATEADD(mi, -@TimeSpanInMins, @APTime);
	DECLARE @MinID AS BIGINT;
	
	SET NOCOUNT ON;
	SELECT
		[Level],
		b.BUID,
		b.BUName,
		AppName,
		@DBTime DBTime,
		@DBPastTime DBPastTime,
		[COUNT] = COUNT(1)
	FROM
		[Log] l WITH(INDEX([IX_Log]), NOLOCK)
		LEFT JOIN [BU] b(NOLOCK) ON l.BUID = b.BUID
	WHERE
		((@TimeType = 1 AND DBLoggingDT >= @DBPastTime AND DBLoggingDT <= @DBTime)
		OR ( @TimeType = 2 AND AppLoggingDT >= @APPastTime AND AppLoggingDT <= @APTime))
		AND (@Level IS NULL OR @Level = '''' OR [Level] = @Level)
	GROUP BY
		[Level],
		b.BUID,
		b.BUName,
		AppName
	ORDER BY
		(CASE WHEN [Level]=''DEBUG'' THEN 0 WHEN [Level]=''INFO'' THEN 1 WHEN [Level]=''WARN'' THEN 2 WHEN [Level]=''ERROR'' THEN 3 WHEN [Level]=''FATAL'' THEN 4 END) DESC,
		AppName
END
' 
END
GO
