/****** Object:  StoredProcedure [dbo].[KnowledgeBase_InsertComment]    Script Date: 05/15/2012 12:07:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase_InsertComment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[KnowledgeBase_InsertComment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase_InsertComment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-02-10
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[KnowledgeBase_InsertComment]
	@KnowledgebaseId	AS int,
	@Message		AS VARCHAR(1000),
	@CreatedBy		AS int,
	@Status		AS  int
AS
BEGIN
	SET NOCOUNT ON;
INSERT INTO [Comment]
           ([KnowledgebaseId]
           ,[Message]
           ,[CreatedBy]
           ,[DateCreated]
           ,[Status])
     VALUES
           (@KnowledgebaseId
           ,@Message
           ,@CreatedBy
           ,GetDate()
           ,@Status)
END
' 
END
GO
