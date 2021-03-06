/****** Object:  StoredProcedure [dbo].[KnowledgeBase_DeleteUnuseFileAttachment]    Script Date: 05/15/2012 12:07:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase_DeleteUnuseFileAttachment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[KnowledgeBase_DeleteUnuseFileAttachment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase_DeleteUnuseFileAttachment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-02-12
-- Description:	Delete unuse fileattachment
-- =============================================
CREATE PROCEDURE [dbo].[KnowledgeBase_DeleteUnuseFileAttachment]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Yesterday AS DATETIME;	SET @Yesterday = DATEADD(day,-1,GETDATE())
	
Delete from [dbo].[FileAttachment]
Where Createdby <= @Yesterday and KnowledgebaseId = null

END
' 
END
GO
