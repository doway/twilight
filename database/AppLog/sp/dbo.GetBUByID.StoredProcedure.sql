/****** Object:  StoredProcedure [dbo].[GetBUByID]    Script Date: 05/15/2012 12:07:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetBUByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetBUByID]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetBUByID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-03-30
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[GetBUByID]
@BUID AS SMALLINT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT BUID, BUName
	FROM BU(NOLOCK)
	WHERE BUID = @BUID
	
END
' 
END
GO
