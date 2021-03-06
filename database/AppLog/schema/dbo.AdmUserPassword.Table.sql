/****** Object:  Table [dbo].[AdmUserPassword]    Script Date: 05/15/2012 12:07:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AdmUserPassword]') AND type in (N'U'))
DROP TABLE [dbo].[AdmUserPassword]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AdmUserPassword]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AdmUserPassword](
	[UserID] [smallint] NOT NULL,
	[Password] [varchar](50) NULL,
	[SessionID] [varchar](50) NULL,
	[LoginAttempt] [tinyint] NULL,
 CONSTRAINT [PK_AdmUserPassword] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
