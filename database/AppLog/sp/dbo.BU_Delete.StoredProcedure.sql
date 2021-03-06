/****** Object:  StoredProcedure [dbo].[BU_Delete]    Script Date: 05/15/2012 12:07:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BU_Delete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[BU_Delete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BU_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-03-30
-- Description:	Delete BU
-- =============================================
CREATE PROCEDURE [dbo].[BU_Delete]
	@BUID 		AS smallint
AS
BEGIN
	SET NOCOUNT ON;
	DELETE [BU]
	WHERE BUID = @BUID
END
' 
END
GO
