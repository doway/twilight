/****** Object:  Table [dbo].[AdmUser]    Script Date: 02/21/2012 17:26:02 ******/
SET IDENTITY_INSERT [dbo].[AdmUser] ON
INSERT [dbo].[AdmUser] ([UserID], [LoginID], [BUID], [UserName], [Remark], [Status], [UserType], [Picture], [PictureType], [DateCreated], [DateUpdated], [CreatedBy], [UpdatedBy], [Email]) VALUES (1, N'admuser', 0, N'adm user', N'Admin User', 1, 1, NULL, NULL, CAST(0x00009C8800000000 AS DateTime), CAST(0x00009C8800000000 AS DateTime), 1, 1, 'tom.tang@xuenn.com.tw')
SET IDENTITY_INSERT [dbo].[AdmUser] OFF
