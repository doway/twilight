/****** Object:  Table [dbo].[ServerBUMapping]    Script Date: 05/15/2012 12:08:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ServerBUMapping]') AND type in (N'U'))
DROP TABLE [dbo].[ServerBUMapping]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ServerBUMapping]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ServerBUMapping](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BUID] [smallint] NOT NULL,
	[ServerIP] [varchar](50) NOT NULL,
	[ServerName] [varchar](50) NULL,
	[Status] [smallint] NULL,
 CONSTRAINT [PK_ServerBUMapping] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
