/****** Object:  Table [dbo].[FileAttachment]    Script Date: 02/21/2012 14:49:13 ******/
ALTER TABLE [dbo].[FileAttachment]  WITH CHECK ADD  CONSTRAINT [FK_FileAttachment_KnowledgeBase] FOREIGN KEY([KnowledgebaseId])
REFERENCES [dbo].[KnowledgeBase] ([KnowledgebaseID])
GO
ALTER TABLE [dbo].[FileAttachment] CHECK CONSTRAINT [FK_FileAttachment_KnowledgeBase]
GO
