/****** Object:  Table [dbo].[KeywordMapping]    Script Date: 05/15/2012 12:08:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KeywordMapping]') AND type in (N'U'))
DROP TABLE [dbo].[KeywordMapping]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KeywordMapping]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[KeywordMapping](
	[KeywordMappingID] [int] IDENTITY(1,1) NOT NULL,
	[KnowledgebaseId] [int] NOT NULL,
	[Keyword] [nvarchar](1000) NOT NULL,
 CONSTRAINT [PK_KeywordMapping] PRIMARY KEY CLUSTERED 
(
	[KeywordMappingID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
