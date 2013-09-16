/****** Object:  Table [dbo].[AdmUserPosition]    Script Date: 02/21/2012 14:49:08 ******/
ALTER TABLE [dbo].[AdmUserPosition]  WITH CHECK ADD  CONSTRAINT [FK_AdmUserPosition_AdmUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[AdmUser] ([UserID])
GO
ALTER TABLE [dbo].[AdmUserPosition] CHECK CONSTRAINT [FK_AdmUserPosition_AdmUser]
GO
ALTER TABLE [dbo].[AdmUserPosition]  WITH CHECK ADD  CONSTRAINT [FK_AdmUserPosition_Position] FOREIGN KEY([PositionID])
REFERENCES [dbo].[Position] ([PositionID])
GO
ALTER TABLE [dbo].[AdmUserPosition] CHECK CONSTRAINT [FK_AdmUserPosition_Position]
GO
