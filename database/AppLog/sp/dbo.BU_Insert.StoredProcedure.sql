/****** Object:  StoredProcedure [dbo].[BU_Insert]    Script Date: 05/15/2012 12:07:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BU_Insert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[BU_Insert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BU_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-03-30
-- Description:	Insert BU
-- =============================================
CREATE PROCEDURE [dbo].[BU_Insert]
	@BUName		AS VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
INSERT INTO [BU]
           ([BUName])
     VALUES
           (@BUName) 
		 
END
' 
END
GO
