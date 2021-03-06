/****** Object:  Table [dbo].[FileAttachment]    Script Date: 05/15/2012 12:08:01 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_FileAttachment_RowGuid]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[FileAttachment] DROP CONSTRAINT [DF_FileAttachment_RowGuid]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FileAttachment]') AND type in (N'U'))
DROP TABLE [dbo].[FileAttachment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FileAttachment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[FileAttachment](
	[RowGuid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_FileAttachment_RowGuid]  DEFAULT (newid()),
	[FileID] [int] IDENTITY(1,1) NOT NULL,
	[FileName] [nvarchar](250) NOT NULL,
	[FileSize] [int] NOT NULL,
	[KnowledgebaseId] [int] NULL,
	[Attachment] [varbinary](max) NOT NULL,
	[FileType] [nvarchar](50) NULL,
	[Createdby] [smallint] NULL,
	[DateCreated] [datetime] NULL,
	[Status] [char](1) NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
