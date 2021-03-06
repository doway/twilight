/****** Object:  StoredProcedure [dbo].[ServerBUMapping_Search]    Script Date: 05/15/2012 12:07:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ServerBUMapping_Search]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ServerBUMapping_Search]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ServerBUMapping_Search]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 03/30/2012
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[ServerBUMapping_Search]
	@Keyword			AS VARCHAR(1000) = NULL,
	@BUID				AS smallint = NULL,
	@pageNum 			AS INT,
	@pageSize 			AS INT,
    @VirtualRowsCount 	AS INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

SELECT @VirtualRowsCount = COUNT(1)
FROM 
	[ServerBUMapping] Sbu 
	INNER JOIN BU ON Sbu.BUID = BU.BUID
WHERE (@Keyword IS NULL OR ServerIP LIKE ''%'' + @Keyword + ''%'' 
		OR ServerName LIKE ''%'' + @Keyword + ''%'') AND
		(@BUID IS NULL OR Sbu.BUID = @BUID)

	DECLARE @ROW_NO_B AS INT
	DECLARE @ROW_NO_E AS INT

	if(@pageSize = 0)	
		SET  @PageSize = @VirtualRowsCount
	
	SET @ROW_NO_B = 1 + (@pageNum - 1) * @pageSize
	SET @ROW_NO_E = @pageNum * @pageSize		
	
    -- Insert statements for procedure here
	SELECT t.*
	FROM
		(SELECT ROW_NUMBER() OVER (ORDER BY Sbu.BUID DESC) AS ROW_NO, Sbu.[ID], Sbu.[BUID], BU.BUNAME
      ,[ServerIP]
      ,[ServerName]
      ,[Status]
		FROM [ServerBUMapping] Sbu INNER JOIN BU ON Sbu.BUID=BU.BUID
		WHERE (@Keyword IS NULL OR ServerIP Like ''%'' + @Keyword + ''%'' 
			OR ServerName Like ''%'' + @Keyword + ''%'') AND
			(@BUID IS NULL OR Sbu.BUID=@BUID)
		) t
	Where ROW_NO BETWEEN @ROW_NO_B AND @ROW_NO_E				
	
END
' 
END
GO
