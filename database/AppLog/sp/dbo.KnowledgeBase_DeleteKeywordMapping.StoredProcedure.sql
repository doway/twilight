/****** Object:  StoredProcedure [dbo].[KnowledgeBase_DeleteKeywordMapping]    Script Date: 05/15/2012 12:07:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase_DeleteKeywordMapping]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[KnowledgeBase_DeleteKeywordMapping]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase_DeleteKeywordMapping]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-02-13
-- Description:	Delete KeywordMapping 
-- =============================================
CREATE PROCEDURE [dbo].[KnowledgeBase_DeleteKeywordMapping]
	@KnowledgeBaseID as int 
AS
BEGIN
	SET NOCOUNT ON;

DELETE FROM [dbo].[KeywordMapping]
Where KnowledgebaseID = @KnowledgeBaseID

END
' 
END
GO
