/****** Object:  StoredProcedure [dbo].[KnowledgeBase_InsertKeywordMapping]    Script Date: 05/15/2012 12:07:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase_InsertKeywordMapping]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[KnowledgeBase_InsertKeywordMapping]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase_InsertKeywordMapping]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-02-10
-- Description:	Insert Keyword Mapping into database
-- =============================================
CREATE PROCEDURE [dbo].[KnowledgeBase_InsertKeywordMapping]
	@KnowledgeBaseID as int,
	@Keyword		AS VARCHAR(1000)

AS
BEGIN
	SET NOCOUNT ON;
INSERT INTO [dbo].[KeywordMapping]
           ([KnowledgebaseId]
           ,[Keyword])
     VALUES
           (@KnowledgeBaseID
           ,@Keyword	)

END
' 
END
GO
