/****** Object:  StoredProcedure [dbo].[state_LogTrendByBU]    Script Date: 05/15/2012 12:07:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[state_LogTrendByBU]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[state_LogTrendByBU]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[state_LogTrendByBU]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Tom Tang
-- Create date: 2012-02-14
-- Description:	Provide an overview trend statistics
-- Revision:
-- 2012-2-15: Involve BU name as output field.
-- =============================================
CREATE PROCEDURE [dbo].[state_LogTrendByBU]
@UseDBTime AS BIT = 0,
@PastHrs AS TINYINT = 1,
@Level AS CHAR(5) = '''',
@BaseDateTime AS DATETIME OUT
AS
BEGIN
	SET NOCOUNT ON;
	SET @BaseDateTime = GETDATE();
	SELECT
		OffsetMins = DATEDIFF(mi, @BaseDateTime, CASE WHEN @UseDBTime = 1 THEN d.DBLoggingDT ELSE d.AppLoggingDT END),
		[BU] = b.[BUName],
		[COUNT] = COUNT(1)
	FROM [Log] d(NOLOCK)
		LEFT JOIN [BU] b ON d.BUID = b.BUID
	WHERE
		d.DBLoggingDT > DATEADD(hh, -@PastHrs, @BaseDateTime)
		AND (@Level IS NULL OR @Level = '''' OR d.[Level] = @Level)
	GROUP BY
		b.[BUName],
		DATEDIFF(mi, @BaseDateTime, CASE WHEN @UseDBTime = 1 THEN d.DBLoggingDT ELSE d.AppLoggingDT END)
	ORDER BY
		b.[BUName],
		DATEDIFF(mi, @BaseDateTime, CASE WHEN @UseDBTime = 1 THEN d.DBLoggingDT ELSE d.AppLoggingDT END) ASC
END
' 
END
GO
