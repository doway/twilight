/****** Object:  Table [dbo].[KnowledgeBase]    Script Date: 02/21/2012 17:26:02 ******/
SET IDENTITY_INSERT [dbo].[KnowledgeBase] ON
INSERT [dbo].[KnowledgeBase] ([KnowledgebaseID], [Title], [Description], [Solution], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated], [Recommend]) VALUES (1, N'Java KM-1', N'JNDI Connection Management', N'Restart JNDI Service', 1, CAST(0x00009FD600ACD59C AS DateTime), NULL, NULL, 19)
INSERT [dbo].[KnowledgeBase] ([KnowledgebaseID], [Title], [Description], [Solution], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated], [Recommend]) VALUES (2, N'.net framework MVC KM-1', N'.net framework MVC with exception', N'.net framework MVC update patch', 1, CAST(0x00009FD600AD52C6 AS DateTime), NULL, NULL, 6)
INSERT [dbo].[KnowledgeBase] ([KnowledgebaseID], [Title], [Description], [Solution], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated], [Recommend]) VALUES (3, N'Oracle database KM-1', N'Oracle database index missing', N'Rebuild index', 1, CAST(0x00009FD600AD8683 AS DateTime), NULL, NULL, 8)
SET IDENTITY_INSERT [dbo].[KnowledgeBase] OFF
