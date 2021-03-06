/****** Object:  StoredProcedure [dbo].[KnowledgeBase_InsertFileAttachment]    Script Date: 05/15/2012 12:07:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase_InsertFileAttachment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[KnowledgeBase_InsertFileAttachment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase_InsertFileAttachment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-02-16
-- Description:	Insert file attachement into database
-- =============================================
CREATE PROCEDURE [dbo].[KnowledgeBase_InsertFileAttachment]
	@FileName			AS VARCHAR(250),
	@FileSize			AS int,
	@KnowledgebaseId	AS int,
	@Attachment			AS varbinary(max),
	@FileType			AS varchar(50),
	@Createdby			As int,
	@Status				AS char(1),
	@RowGuid 			as uniqueidentifier OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
INSERT INTO [dbo].[FileAttachment]
           ([FileName]
           ,[FileSize]
           ,[KnowledgebaseId]
           ,[Attachment]
           ,[FileType]
           ,[Createdby]
           ,[DateCreated]
           ,[Status])
     VALUES
           (@FileName
           ,@FileSize
           ,@KnowledgebaseId
           ,@Attachment
           ,@FileType
           ,@Createdby
           ,GetDate()
           ,@Status)


Select @RowGuid = RowGuid From [dbo].[FileAttachment]
Where FileID= (Select MAX(FileID) from [dbo].[FileAttachment])

END
' 
END
GO
