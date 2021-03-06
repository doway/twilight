/****** Object:  Table [dbo].[KnowledgeBase]    Script Date: 05/15/2012 12:08:04 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Knowledge__DateC__286302EC]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[KnowledgeBase] DROP CONSTRAINT [DF__Knowledge__DateC__286302EC]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Knowledge__RECOM__2A4B4B5E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[KnowledgeBase] DROP CONSTRAINT [DF__Knowledge__RECOM__2A4B4B5E]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase]') AND type in (N'U'))
DROP TABLE [dbo].[KnowledgeBase]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[KnowledgeBase](
	[KnowledgebaseID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](1000) NOT NULL,
	[Solution] [nvarchar](max) NOT NULL,
	[CreatedBy] [smallint] NOT NULL,
	[DateCreated] [datetime] NOT NULL CONSTRAINT [DF__Knowledge__DateC__286302EC]  DEFAULT (getdate()),
	[UpdatedBy] [smallint] NULL,
	[DateUpdated] [datetime] NULL,
	[Recommend] [int] NOT NULL CONSTRAINT [DF__Knowledge__RECOM__2A4B4B5E]  DEFAULT ((0)),
 CONSTRAINT [KNOWLEDGEBASE_PK] PRIMARY KEY CLUSTERED 
(
	[KnowledgebaseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
