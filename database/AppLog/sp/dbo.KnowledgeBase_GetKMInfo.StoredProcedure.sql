/****** Object:  StoredProcedure [dbo].[KnowledgeBase_GetKMInfo]    Script Date: 05/15/2012 12:07:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase_GetKMInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[KnowledgeBase_GetKMInfo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase_GetKMInfo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-02-10
-- Description:
-- =============================================
CREATE procedure [dbo].[KnowledgeBase_GetKMInfo]
	@ID			AS int
as
Begin
SELECT  k.KnowledgebaseID, k.Title, k.Solution, k.Description, k.Recommend, a.UserName ,k.DateCreated, a2.UserName as UpdatedBy, k.DateUpdated
FROM KnowledgeBase (NOLOCK) k Inner Join AdmUser a On a.UserID = k.CreatedBy
Left Join AdmUser a2 On a2.UserID = k.UpdatedBy
Where KnowledgebaseID=@ID

SELECT  c.*,a.UserName
FROM Comment (NOLOCK) c
Inner join AdmUser a On a.UserID=c.CreatedBy
Where KnowledgebaseID=@ID

SELECT  f.[RowGuid] 
	   ,f.[FileID]
      ,f.[FileName]
      ,f.[FileSize]
      ,f.[FileType]
      ,f.[Createdby]
      ,f.[DateCreated]	  
	  ,f.[Status]	  
      ,f.[KnowledgebaseId],a.UserName
FROM FileAttachment (NOLOCK) f
Inner join AdmUser a On a.UserID=f.CreatedBy
Where KnowledgebaseID=@ID

SELECT  *
FROM KeywordMapping (NOLOCK) 
Where KnowledgebaseID=@ID

SELECT *
FROM ReferenceLink (NOLOCK) r
Where KnowledgebaseID=@ID

End
' 
END
GO
