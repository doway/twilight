/****** Object:  Table [dbo].[ReferenceLink]    Script Date: 02/21/2012 14:49:20 ******/
ALTER TABLE [dbo].[ReferenceLink]  WITH CHECK ADD  CONSTRAINT [FK_ReferenceLink_KnowledgeBase] FOREIGN KEY([KnowledgebaseId])
REFERENCES [dbo].[KnowledgeBase] ([KnowledgebaseID])
GO
ALTER TABLE [dbo].[ReferenceLink] CHECK CONSTRAINT [FK_ReferenceLink_KnowledgeBase]
GO
