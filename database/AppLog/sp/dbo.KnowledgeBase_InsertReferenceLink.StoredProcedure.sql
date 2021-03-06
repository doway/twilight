/****** Object:  StoredProcedure [dbo].[KnowledgeBase_InsertReferenceLink]    Script Date: 05/15/2012 12:07:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase_InsertReferenceLink]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[KnowledgeBase_InsertReferenceLink]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase_InsertReferenceLink]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-02-10
-- Description:	Insert Keyword Mapping into database
-- =============================================
CREATE PROCEDURE [dbo].[KnowledgeBase_InsertReferenceLink]
	@KnowledgeBaseID 	as int,
	@ReferenceValue		AS VARCHAR(50),
	@ReferenceType  	as smallint

AS
BEGIN
	SET NOCOUNT ON;
INSERT INTO [dbo].[ReferenceLink]
           ([ReferenceType]
           ,[ReferenceValue]
           ,[KnowledgebaseId])
     VALUES
           (@ReferenceType
           ,@ReferenceValue	
           ,@KnowledgeBaseID)

END
' 
END
GO
