/****** Object:  Table [dbo].[Comment]    Script Date: 02/21/2012 14:49:10 ******/
ALTER TABLE [dbo].[Comment]  WITH CHECK ADD  CONSTRAINT [FK_Comment_KnowledgeBase] FOREIGN KEY([KnowledgebaseId])
REFERENCES [dbo].[KnowledgeBase] ([KnowledgebaseID])
GO
ALTER TABLE [dbo].[Comment] CHECK CONSTRAINT [FK_Comment_KnowledgeBase]
GO
