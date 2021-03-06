/****** Object:  StoredProcedure [dbo].[KnowledgeBase_Insert]    Script Date: 05/15/2012 12:07:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase_Insert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[KnowledgeBase_Insert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-02-10
-- Description:	Insert Knowledge base into database
-- =============================================
CREATE PROCEDURE [dbo].[KnowledgeBase_Insert]
	@Title	AS VARCHAR(100),
	@Description		AS VARCHAR(1000),
	@Solution		AS text,
	@CreatedBy		AS int,
	@KnowledgeBaseID as int OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
INSERT INTO [dbo].[KnowledgeBase]
           ([Title]
           ,[Description]
           ,[Solution]
           ,[CreatedBy]
           ,[DateCreated]
           ,[UpdatedBy]
           ,[DateUpdated]
           ,[Recommend])
     VALUES
           (@Title
           ,@Description
           ,@Solution
           ,@CreatedBy
           ,GetDate()
           ,NULL
           ,NULL
           ,0)


EXEC [dbo].[KnowledgeBase_DeleteUnuseFileAttachment]		   
		   
Select @KnowledgeBaseID = MAX(knowledgeBaseID) from [dbo].[KnowledgeBase]

END
' 
END
GO
