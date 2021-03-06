/****** Object:  Table [dbo].[ReferenceLink]    Script Date: 05/15/2012 12:08:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReferenceLink]') AND type in (N'U'))
DROP TABLE [dbo].[ReferenceLink]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReferenceLink]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ReferenceLink](
	[ReferenceLinkId] [int] IDENTITY(1,1) NOT NULL,
	[ReferenceType] [smallint] NOT NULL,
	[ReferenceValue] [varchar](50) NOT NULL,
	[KnowledgebaseId] [int] NOT NULL,
 CONSTRAINT [PK_ReferenceLink] PRIMARY KEY CLUSTERED 
(
	[ReferenceLinkId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
