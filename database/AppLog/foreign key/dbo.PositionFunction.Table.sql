/****** Object:  Table [dbo].[PositionFunction]    Script Date: 02/21/2012 14:49:19 ******/
ALTER TABLE [dbo].[PositionFunction]  WITH CHECK ADD  CONSTRAINT [FK_PositionFunction_Function] FOREIGN KEY([FunctionID])
REFERENCES [dbo].[Function] ([FunctionID])
GO
ALTER TABLE [dbo].[PositionFunction] CHECK CONSTRAINT [FK_PositionFunction_Function]
GO
ALTER TABLE [dbo].[PositionFunction]  WITH CHECK ADD  CONSTRAINT [FK_PositionFunction_Position] FOREIGN KEY([PositionID])
REFERENCES [dbo].[Position] ([PositionID])
GO
ALTER TABLE [dbo].[PositionFunction] CHECK CONSTRAINT [FK_PositionFunction_Position]
GO
