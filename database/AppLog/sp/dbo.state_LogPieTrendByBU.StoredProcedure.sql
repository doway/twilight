/****** Object:  StoredProcedure [dbo].[state_LogPieTrendByBU]    Script Date: 05/15/2012 12:07:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[state_LogPieTrendByBU]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[state_LogPieTrendByBU]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[state_LogPieTrendByBU]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Tom Tang
-- Create date: 2012-03-06
-- Description:	Provide an overview pie trend statistics
-- Revision:
-- =============================================
CREATE PROCEDURE [dbo].[state_LogPieTrendByBU]
@UseDBTime AS BIT = 0,
@PastHrs AS TINYINT = 1,
@Level AS CHAR(5) = '''',
@BaseDateTime AS DATETIME OUT
AS
BEGIN
	SET NOCOUNT ON;
	SET @BaseDateTime = GETDATE();
	SELECT
		[BU] = ISNULL(b.[BUName], ''NA''),
		[COUNT] = COUNT(1)
	FROM [Log] d(NOLOCK)
		LEFT JOIN [BU] b ON d.BUID = b.BUID
	WHERE
		d.DBLoggingDT > DATEADD(hh, -@PastHrs, @BaseDateTime)
		AND (@Level IS NULL OR @Level = '''' OR d.[Level] = @Level)
	GROUP BY
		ISNULL(b.[BUName], ''NA'')
	ORDER BY
		ISNULL(b.[BUName], ''NA'')
END

' 
END
GO
