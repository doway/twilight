/****** Object:  StoredProcedure [dbo].[KnowledgeBase_UpdateFileAttachment]    Script Date: 05/15/2012 12:07:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase_UpdateFileAttachment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[KnowledgeBase_UpdateFileAttachment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase_UpdateFileAttachment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-02-16
-- Description:	Update fileattachment
-- =============================================
CREATE PROCEDURE [dbo].[KnowledgeBase_UpdateFileAttachment]
	@KnowledgebaseId	AS int,
	@RowGuid 			as uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;
Update [dbo].[FileAttachment]
Set  KnowledgebaseId = @KnowledgebaseId
Where RowGuid=@RowGuid

END
' 
END
GO
