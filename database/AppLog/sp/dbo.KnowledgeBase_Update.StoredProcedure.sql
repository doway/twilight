/****** Object:  StoredProcedure [dbo].[KnowledgeBase_Update]    Script Date: 05/15/2012 12:07:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase_Update]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[KnowledgeBase_Update]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-02-13
-- Description:	update Knowledge base 
-- =============================================
CREATE PROCEDURE [dbo].[KnowledgeBase_Update]
	@Title	AS VARCHAR(100),
	@Description		AS VARCHAR(1000),
	@Solution		AS text,
	@UpdatedBy		AS int,
	@KnowledgeBaseID as int
AS
BEGIN
	SET NOCOUNT ON;

UPDATE [dbo].[KnowledgeBase]
Set Title=@Title, Description=@Description,Solution=@Solution,
	UpdatedBy=@UpdatedBy, DateUpdated=GETDATE()
Where KnowledgebaseID = @KnowledgeBaseID

EXEC [dbo].[KnowledgeBase_DeleteUnuseFileAttachment]

END
' 
END
GO
