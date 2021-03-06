/****** Object:  StoredProcedure [dbo].[BU_Update]    Script Date: 05/15/2012 12:07:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BU_Update]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[BU_Update]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BU_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-03-30
-- Description:	Update BU
-- =============================================
CREATE PROCEDURE [dbo].[BU_Update]
	@BUName		AS VARCHAR(50),
	@BUID 		AS SMALLINT
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE [BU]
	SET BUName = @BUName
	WHERE BUID = @BUID
		 
END
' 
END
GO
