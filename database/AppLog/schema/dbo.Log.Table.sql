/****** Object:  Table [dbo].[Log]    Script Date: 05/15/2012 12:08:05 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Log_DBLoggingDT]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Log] DROP CONSTRAINT [DF_Log_DBLoggingDT]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Log_BU]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Log] DROP CONSTRAINT [DF_Log_BU]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Log]') AND type in (N'U'))
DROP TABLE [dbo].[Log]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Log]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Log](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[AppLoggingDT] [datetime] NOT NULL,
	[Thread] [varchar](20) NOT NULL,
	[Level] [char](5) NOT NULL,
	[Logger] [varchar](100) NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
	[DBLoggingDT] [datetime] NOT NULL CONSTRAINT [DF_Log_DBLoggingDT]  DEFAULT (getdate()),
	[BUID] [smallint] NOT NULL CONSTRAINT [DF_Log_BU]  DEFAULT ((0)),
	[AppName] [varchar](20) NULL,
	[ExKey1] [varchar](20) NULL,
	[ExKey2] [varchar](20) NULL,
	[ExKey3] [varchar](20) NULL,
	[ExKey4] [varchar](20) NULL,
	[ExKey5] [varchar](20) NULL,
	[ExKey6] [varchar](20) NULL,
	[ExKey7] [varchar](20) NULL,
	[ExKey8] [varchar](20) NULL,
	[ExKey9] [varchar](20) NULL,
	[ExKey10] [varchar](20) NULL,
	[Src] [varchar](20) NULL,
	[Exception] [nvarchar](max) NULL,
	[ErrorCode] [varchar](20) NULL,
 CONSTRAINT [PK_Log] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Log]') AND name = N'IX_Log')
CREATE NONCLUSTERED INDEX [IX_Log] ON [dbo].[Log] 
(
	[DBLoggingDT] DESC,
	[AppLoggingDT] DESC,
	[Level] ASC,
	[Logger] ASC
)
INCLUDE ( [BUID],
[AppName]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
