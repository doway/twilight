/****** Object:  Table [dbo].[Position]    Script Date: 02/21/2012 17:26:02 ******/
SET IDENTITY_INSERT [dbo].[Position] ON
INSERT [dbo].[Position] ([PositionID], [BUID], [PositionName], [AccessType], [Status], [DateCreated], [DateUpdated], [CreatedBy], [UpdatedBy]) VALUES (1, 0, N'SuperAdmin', NULL, 1, CAST(0x00009C8800000000 AS DateTime), CAST(0x00009C8800000000 AS DateTime), 1, NULL)
INSERT [dbo].[Position] ([PositionID], [BUID], [PositionName], [AccessType], [Status], [DateCreated], [DateUpdated], [CreatedBy], [UpdatedBy]) VALUES (2, 0,'USER',null,1,GETDATE(),GETDATE(),1,null)
SET IDENTITY_INSERT [dbo].[Position] OFF
