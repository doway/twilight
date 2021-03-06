/****** Object:  Table [dbo].[Position]    Script Date: 05/15/2012 12:08:06 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Position_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Position] DROP CONSTRAINT [DF_Position_DateCreated]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Position]') AND type in (N'U'))
DROP TABLE [dbo].[Position]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Position]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Position](
	[PositionID] [int] IDENTITY(1,1) NOT NULL,
	[BUID] [smallint] NULL,
	[PositionName] [varchar](20) NOT NULL,
	[AccessType] [tinyint] NULL,
	[Status] [tinyint] NOT NULL,
	[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_Position_DateCreated]  DEFAULT (getdate()),
	[DateUpdated] [datetime] NULL,
	[CreatedBy] [smallint] NOT NULL,
	[UpdatedBy] [smallint] NULL,
 CONSTRAINT [PK_Position] PRIMARY KEY CLUSTERED 
(
	[PositionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_Position] UNIQUE NONCLUSTERED 
(
	[PositionName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
