/****** Object:  Table [dbo].[AdmUserPassword]    Script Date: 02/21/2012 14:49:07 ******/
ALTER TABLE [dbo].[AdmUserPassword]  WITH CHECK ADD  CONSTRAINT [FK_AdmUserPassword_AdmUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[AdmUser] ([UserID])
GO
ALTER TABLE [dbo].[AdmUserPassword] CHECK CONSTRAINT [FK_AdmUserPassword_AdmUser]
GO
