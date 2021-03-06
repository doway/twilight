/****** Object:  Table [dbo].[AdmUserPosition]    Script Date: 05/15/2012 12:07:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AdmUserPosition]') AND type in (N'U'))
DROP TABLE [dbo].[AdmUserPosition]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AdmUserPosition]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AdmUserPosition](
	[UserID] [smallint] NOT NULL,
	[PositionID] [int] NULL,
	[DateCreated] [datetime] NULL,
	[DateUpdated] [datetime] NULL,
	[CreatedBy] [smallint] NULL,
	[UpdatedBy] [smallint] NULL,
 CONSTRAINT [PK_AdmUserPosition] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
