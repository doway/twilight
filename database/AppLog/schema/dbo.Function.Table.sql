/****** Object:  Table [dbo].[Function]    Script Date: 05/15/2012 12:08:02 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Function_NoAccessLevel]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Function] DROP CONSTRAINT [DF_Function_NoAccessLevel]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Function_DescLangMapID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Function] DROP CONSTRAINT [DF_Function_DescLangMapID]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Function_Sequence]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Function] DROP CONSTRAINT [DF_Function_Sequence]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Function]') AND type in (N'U'))
DROP TABLE [dbo].[Function]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Function]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Function](
	[Description] [varchar](50) NULL,
	[FunctionID] [int] IDENTITY(1,1) NOT NULL,
	[FunctionKey] [varchar](15) NULL,
	[FunctionParentID] [int] NULL,
	[NoAccessLevel] [tinyint] NULL CONSTRAINT [DF_Function_NoAccessLevel]  DEFAULT ((4)),
	[DescLangMapID] [int] NOT NULL CONSTRAINT [DF_Function_DescLangMapID]  DEFAULT ((0)),
	[Sequence] [smallint] NOT NULL CONSTRAINT [DF_Function_Sequence]  DEFAULT ((0)),
 CONSTRAINT [PK_Function] PRIMARY KEY CLUSTERED 
(
	[FunctionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
