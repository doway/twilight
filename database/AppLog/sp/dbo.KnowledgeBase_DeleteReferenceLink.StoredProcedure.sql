/****** Object:  StoredProcedure [dbo].[KnowledgeBase_DeleteReferenceLink]    Script Date: 05/15/2012 12:07:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase_DeleteReferenceLink]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[KnowledgeBase_DeleteReferenceLink]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase_DeleteReferenceLink]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-02-14
-- Description:	Delete ReferenceLink 
-- =============================================
CREATE PROCEDURE [dbo].[KnowledgeBase_DeleteReferenceLink]
	@KnowledgeBaseID as int 
AS
BEGIN
	SET NOCOUNT ON;

DELETE FROM [dbo].[ReferenceLink]
Where KnowledgebaseID = @KnowledgeBaseID

END
' 
END
GO
