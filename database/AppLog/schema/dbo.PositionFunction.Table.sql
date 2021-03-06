/****** Object:  Table [dbo].[PositionFunction]    Script Date: 05/15/2012 12:08:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PositionFunction]') AND type in (N'U'))
DROP TABLE [dbo].[PositionFunction]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PositionFunction]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PositionFunction](
	[PositionFunctionID] [int] IDENTITY(1,1) NOT NULL,
	[PositionID] [int] NOT NULL,
	[FunctionID] [int] NOT NULL,
	[AccessLevel] [tinyint] NOT NULL,
 CONSTRAINT [PK_PositionFunction] PRIMARY KEY CLUSTERED 
(
	[PositionFunctionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_PositionFunction] UNIQUE NONCLUSTERED 
(
	[PositionID] ASC,
	[FunctionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
