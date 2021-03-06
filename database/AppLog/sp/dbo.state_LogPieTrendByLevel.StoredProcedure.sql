/****** Object:  StoredProcedure [dbo].[state_LogPieTrendByLevel]    Script Date: 05/15/2012 12:07:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[state_LogPieTrendByLevel]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[state_LogPieTrendByLevel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[state_LogPieTrendByLevel]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Tom Tang
-- Create date: 2012-03-06
-- Description:	Provide an overview pie trend statistics
-- Revision:
-- =============================================
CREATE PROCEDURE [dbo].[state_LogPieTrendByLevel]
@UseDBTime AS BIT = 0,
@PastHrs AS TINYINT = 1,
@BUID AS SMALLINT = 0,
@BaseDateTime AS DATETIME OUT
AS
BEGIN
	SET NOCOUNT ON;
	SET @BaseDateTime = GETDATE();
	SELECT
		[Level] = d.[Level],
		[COUNT] = COUNT(1)
	FROM [Log] d(NOLOCK)
	WHERE
		d.DBLoggingDT > DATEADD(hh, -@PastHrs, @BaseDateTime)
		AND (@BUID = 0 OR d.BUID = @BUID)
	GROUP BY
		d.[Level]
	ORDER BY
		d.[Level]
END

' 
END
GO
