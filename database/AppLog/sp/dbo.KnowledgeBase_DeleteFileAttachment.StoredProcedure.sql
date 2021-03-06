/****** Object:  StoredProcedure [dbo].[KnowledgeBase_DeleteFileAttachment]    Script Date: 05/15/2012 12:07:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase_DeleteFileAttachment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[KnowledgeBase_DeleteFileAttachment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase_DeleteFileAttachment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-02-16
-- Description:	Delete fileattachment
-- =============================================
CREATE PROCEDURE [dbo].[KnowledgeBase_DeleteFileAttachment]
	@RowGuid 			as uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;
Delete from [dbo].[FileAttachment]
Where RowGuid=@RowGuid

END
' 
END
GO
