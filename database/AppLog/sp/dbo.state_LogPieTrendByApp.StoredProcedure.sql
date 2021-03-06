/****** Object:  StoredProcedure [dbo].[state_LogPieTrendByLevel]    Script Date: 05/15/2012 12:07:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[state_LogPieTrendByApp]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[state_LogPieTrendByApp]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[state_LogPieTrendByApp]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Tom Tang
-- Create date: 2012-08-08
-- Description:	Provide an overview pie trend statistics
-- Revision:
-- 2012-08-09: Replace null with "NA" in [AppName]
-- =============================================
CREATE PROCEDURE [dbo].[state_LogPieTrendByApp]
@UseDBTime AS BIT = 0,
@PastHrs AS TINYINT = 1,
@BUID AS SMALLINT = 0,
@BaseDateTime AS DATETIME OUT
AS
BEGIN
	SET NOCOUNT ON;
	SET @BaseDateTime = GETDATE();
	SELECT
		[AppName] = ISNULL(d.[AppName], ''NA''),
		[COUNT] = COUNT(1)
	FROM [Log] d(NOLOCK)
	WHERE
		d.DBLoggingDT > DATEADD(hh, -@PastHrs, @BaseDateTime)
		AND (@BUID = 0 OR d.BUID = @BUID)
	GROUP BY
		ISNULL(d.[AppName], ''NA'')
	ORDER BY
		ISNULL(d.[AppName], ''NA'')
END

' 
END
GO
