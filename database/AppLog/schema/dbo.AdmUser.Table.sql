/****** Object:  Table [dbo].[AdmUser]    Script Date: 05/15/2012 12:07:56 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AdmUser_Status]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AdmUser] DROP CONSTRAINT [DF_AdmUser_Status]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__AdmUser__DateCre__02D256E1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AdmUser] DROP CONSTRAINT [DF__AdmUser__DateCre__02D256E1]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AdmUser_DateUpdated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AdmUser] DROP CONSTRAINT [DF_AdmUser_DateUpdated]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AdmUser_CreatedBy]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AdmUser] DROP CONSTRAINT [DF_AdmUser_CreatedBy]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AdmUser_UpdatedBy]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AdmUser] DROP CONSTRAINT [DF_AdmUser_UpdatedBy]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AdmUser_IsDelete]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AdmUser] DROP CONSTRAINT [DF_AdmUser_IsDelete]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AdmUser]') AND type in (N'U'))
DROP TABLE [dbo].[AdmUser]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AdmUser]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AdmUser](
	[UserID] [smallint] IDENTITY(1,1) NOT NULL,
	[LoginID] [varchar](20) NOT NULL,
	[BUID] [smallint] NULL,
	[UserName] [varchar](50) NOT NULL,
	[EMail] [varchar](128) NOT NULL,
	[Remark] [varchar](256) NULL,
	[Status] [tinyint] NOT NULL CONSTRAINT [DF_AdmUser_Status]  DEFAULT ((1)),
	[UserType] [tinyint] NOT NULL,
	[Picture] [image] NULL,
	[PictureType] [varchar](5) NULL,
	[DateCreated] [datetime] NOT NULL DEFAULT (getdate()),
	[DateUpdated] [datetime] NULL CONSTRAINT [DF_AdmUser_DateUpdated]  DEFAULT (getdate()),
	[CreatedBy] [smallint] NOT NULL CONSTRAINT [DF_AdmUser_CreatedBy]  DEFAULT ((0)),
	[UpdatedBy] [smallint] NULL CONSTRAINT [DF_AdmUser_UpdatedBy]  DEFAULT ((0)),
	[IsDelete] [char](1) NOT NULL CONSTRAINT [DF_AdmUser_IsDelete]  DEFAULT ((0)),
 CONSTRAINT [PK_AdmUser] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_AdmUser] UNIQUE NONCLUSTERED 
(
	[LoginID] ASC,
	[UserType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
