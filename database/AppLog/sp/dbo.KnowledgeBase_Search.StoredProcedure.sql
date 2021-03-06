/****** Object:  StoredProcedure [dbo].[KnowledgeBase_Search]    Script Date: 05/15/2012 12:07:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase_Search]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[KnowledgeBase_Search]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KnowledgeBase_Search]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-02-10
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[KnowledgeBase_Search]
	@Keyword			AS VARCHAR(1000) = NULL,
	@pageNum 			AS INT,
	@pageSize 			AS INT,
    @VirtualRowsCount 	AS INT OUTPUT
AS
BEGIN
	
	SELECT @VirtualRowsCount = COUNT(1) 
	From 
	(Select distinct KnowledgebaseID 
	 From KeywordMapping Where Keyword Like ''%'' + @Keyword + ''%'') t
		
	DECLARE @ROW_NO_B AS INT
	DECLARE @ROW_NO_E AS INT

	SET @ROW_NO_B = 1 + (@pageNum - 1) * @pageSize
	SET @ROW_NO_E = @pageNum * @pageSize
		
	SELECT t.*
	FROM
	(SELECT ROW_NUMBER() OVER (ORDER BY k.Recommend DESC) AS ROW_NO, k.*
      , COUNT(c.CommentID) as Comments
		FROM KnowledgeBase k (NOLOCK) Left Join Comment c On k.KnowledgebaseID = c.KnowledgebaseId Inner Join KeywordMapping k2 (NOLOCK) On k.KnowledgebaseId = k2.KnowledgebaseID
	WHERE k2.Keyword Like ''%'' + @Keyword + ''%''
	GROUP BY k.KnowledgebaseID
		  ,k.[Title]
		  ,k.[Description]
		  ,k.[Solution]
		  ,k.[Createdby]
		  ,k.[DateCreated]
		  ,k.[UpdatedBy]
		  ,k.[DateUpdated]
		  ,k.[Recommend]		
	) t
	Where ROW_NO BETWEEN @ROW_NO_B AND @ROW_NO_E
	ORDER BY Recommend DESC
		
END
' 
END
GO
