/****** Object:  Table [dbo].[KeywordMapping]    Script Date: 02/21/2012 14:49:15 ******/
ALTER TABLE [dbo].[KeywordMapping]  WITH CHECK ADD  CONSTRAINT [FK_KeywordMapping_KnowledgeBase] FOREIGN KEY([KnowledgebaseId])
REFERENCES [dbo].[KnowledgeBase] ([KnowledgebaseID])
GO
ALTER TABLE [dbo].[KeywordMapping] CHECK CONSTRAINT [FK_KeywordMapping_KnowledgeBase]
GO
