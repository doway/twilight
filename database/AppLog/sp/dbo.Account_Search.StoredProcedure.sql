/****** Object:  StoredProcedure [dbo].[Account_Search]    Script Date: 05/15/2012 12:07:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account_Search]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Account_Search]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account_Search]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 03/27/2012
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Account_Search]
	@Keyword			AS VARCHAR(1000) = NULL,
	@Status				AS INT = NULL,
	@BUID				AS SMALLINT = NULL,
	@pageNum 			AS INT,
	@pageSize 			AS INT,
    @VirtualRowsCount 	AS INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT @VirtualRowsCount = COUNT(1)
	FROM 
		[AdmUser] (NOLOCK) au 
		INNER JOIN AdmUserPosition (NOLOCK) aup ON au.UserID = aup.UserID 
		INNER JOIN Position (NOLOCK) p ON aup.PositionID = p.PositionID 
		LEFT JOIN BU b ON au.BUID = b.BUID
	WHERE	
		(@Keyword IS NULL OR LoginID LIKE ''%'' + @Keyword + ''%'')
		AND (@Status IS NULL OR @Status = au.Status)
		AND (@BUID IS NULL OR au.BUID = @BUID)
		AND au.IsDelete = 0

	DECLARE @ROW_NO_B AS INT
	DECLARE @ROW_NO_E AS INT

	if(@pageSize = 0)	
		SET  @PageSize = @VirtualRowsCount
	
	SET @ROW_NO_B = 1 + (@pageNum - 1) * @pageSize
	SET @ROW_NO_E = @pageNum * @pageSize	
	
	SELECT t.*
	FROM
		(SELECT ROW_NUMBER() OVER (ORDER BY LoginID DESC) AS ROW_NO, au.[UserID]
		  ,au.[LoginID]
		  ,p.PositionName
		  ,p.PositionID
		  ,au.[BUID]
		  ,b.[BUName]
		  ,au.[UserName]
		  ,au.[EMail]		  
		  ,au.[Remark]
		  ,au.[Status]
		  ,au.[UserType]
		  ,au.[Picture]
		  ,au.[PictureType]
		  ,au.[DateCreated]
		  ,au.[DateUpdated]
		FROM 
			[AdmUser] au 
			INNER JOIN AdmUserPosition aup ON au.UserID = aup.UserID 
			INNER JOIN Position p ON aup.PositionID = p.PositionID 
			LEFT JOIN BU b ON au.BUID = b.BUID
		WHERE	
			(@Keyword IS NULL OR LoginID Like ''%'' + @Keyword + ''%'')
			And (@Status IS NULL OR @Status = au.Status)  
			AND (@BUID IS NULL OR au.BUID = @BUID)			
			AND au.IsDelete = 0			
		) t
	WHERE ROW_NO BETWEEN @ROW_NO_B AND @ROW_NO_E	
END
' 
END
GO
