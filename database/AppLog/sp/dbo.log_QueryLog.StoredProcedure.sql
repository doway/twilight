/****** Object:  StoredProcedure [dbo].[log_QueryLog]    Script Date: 05/15/2012 12:07:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[log_QueryLog]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[log_QueryLog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[log_QueryLog]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-02-14
-- Description:	
-- Revision:
-- 2012-05-28: Add new parameter [AppName]
-- =============================================
CREATE PROCEDURE [dbo].[log_QueryLog]
	@Src			AS VARCHAR(20) = NULL,
	@AppBeginDate	AS DATETIME,
	@AppEndDate		AS DATETIME,
	@Thread			AS VARCHAR(20) = NULL,
	@Level			AS CHAR(5) = NULL,
	@Logger			AS VARCHAR(100),
	@BUID			AS SMALLINT = 0,
	@AppName		AS VARCHAR(20) = NULL,
	@ExKey1			AS VARCHAR(20) = NULL,
	@ExKey2			AS VARCHAR(20) = NULL,
	@ExKey3			AS VARCHAR(20) = NULL,
	@ExKey4			AS VARCHAR(20) = NULL,
	@ExKey5			AS VARCHAR(20) = NULL,
	@ExKey6			AS VARCHAR(20) = NULL,
	@ExKey7			AS VARCHAR(20) = NULL,
	@ExKey8			AS VARCHAR(20) = NULL,
	@ExKey9			AS VARCHAR(20) = NULL,
	@ExKey10		AS VARCHAR(20) = NULL,
	@ErrorCode		AS CHAR(10) = NULL,
	@Message		AS VARCHAR(100) = NULL,
	@pageNum AS INT,
	@pageSize AS INT,
    @VirtualRowsCount AS INT OUTPUT
AS
BEGIN
	
	SELECT @VirtualRowsCount = COUNT(1)
	FROM [Log](NOLOCK)
	WHERE
		(@AppBeginDate IS NULL OR DBLoggingDT >= @AppBeginDate)
		AND (@AppEndDate IS NULL OR DBLoggingDT <= @AppEndDate)
		AND (@Src IS NULL OR @Src = '''' OR Src = @Src)
		AND (@Thread IS NULL OR @Thread = '''' OR Thread = @Thread)
		AND (@Level IS NULL OR @Level = '''' OR [Level] = @Level)
		AND (@Logger IS NULL OR @Logger = '''' OR Logger LIKE @Logger)
		AND (@BUID = 0 OR BUID = @BUID)
		AND (@AppName IS NULL OR @AppName = '''' OR AppName LIKE @AppName)
		AND (@ExKey1 IS NULL OR @ExKey1 = '''' OR ExKey1 LIKE @ExKey1)
		AND (@ExKey2 IS NULL OR @ExKey2 = '''' OR ExKey2 LIKE @ExKey2)
		AND (@ExKey3 IS NULL OR @ExKey3 = '''' OR ExKey3 LIKE @ExKey3)
		AND (@ExKey4 IS NULL OR @ExKey4 = '''' OR ExKey4 LIKE @ExKey4)
		AND (@ExKey5 IS NULL OR @ExKey5 = '''' OR ExKey5 LIKE @ExKey5)
		AND (@ExKey6 IS NULL OR @ExKey6 = '''' OR ExKey6 LIKE @ExKey6)
		AND (@ExKey7 IS NULL OR @ExKey7 = '''' OR ExKey7 LIKE @ExKey7)
		AND (@ExKey8 IS NULL OR @ExKey8 = '''' OR ExKey8 LIKE @ExKey8)
		AND (@ExKey9 IS NULL OR @ExKey9 = '''' OR ExKey9 LIKE @ExKey9)
		AND (@ExKey10 IS NULL OR @ExKey10 = '''' OR ExKey10 LIKE @ExKey10)
		AND (@ErrorCode IS NULL OR @ErrorCode = '''' OR ErrorCode = @ErrorCode)
		AND (@Message IS NULL OR @Message = '''' OR [Message] LIKE ''%'' + @Message + ''%'' )		
		
	DECLARE @ROW_NO_B AS INT
	DECLARE @ROW_NO_E AS INT

	IF(@pageSize = 0)	
		SET  @PageSize = @VirtualRowsCount
	
	SET @ROW_NO_B = 1 + (@pageNum - 1) * @pageSize
	SET @ROW_NO_E = @pageNum * @pageSize
		
	SELECT t.*
	FROM
	(SELECT ROW_NUMBER() OVER (ORDER BY AppLoggingDT DESC) AS ROW_NO, l.*, b.BUName 
		FROM [Log](NOLOCK) l LEFT JOIN dbo.[BU] b ON b.BUID = l.BUID
	WHERE
		(@AppBeginDate IS NULL OR DBLoggingDT >= @AppBeginDate)
		AND (@AppEndDate IS NULL OR DBLoggingDT <= @AppEndDate)
		AND (@Src IS NULL OR @Src = '''' OR Src = @Src)
		AND (@Thread IS NULL OR @Thread = '''' OR Thread= @Thread)
		AND (@Level IS NULL OR @Level = '''' OR [Level] = @Level)
		AND (@Logger IS NULL OR @Logger = '''' OR Logger LIKE @Logger)
		AND (@BUID = 0 OR l.BUID = @BUID)
		AND (@AppName IS NULL OR @AppName = '''' OR AppName LIKE @AppName)
		AND (@ExKey1 IS NULL OR @ExKey1 = '''' OR ExKey1 LIKE @ExKey1)
		AND (@ExKey2 IS NULL OR @ExKey2 = '''' OR ExKey2 LIKE @ExKey2)
		AND (@ExKey3 IS NULL OR @ExKey3 = '''' OR ExKey3 LIKE @ExKey3)
		AND (@ExKey4 IS NULL OR @ExKey4 = '''' OR ExKey4 LIKE @ExKey4)
		AND (@ExKey5 IS NULL OR @ExKey5 = '''' OR ExKey5 LIKE @ExKey5)
		AND (@ExKey6 IS NULL OR @ExKey6 = '''' OR ExKey6 LIKE @ExKey6)
		AND (@ExKey7 IS NULL OR @ExKey7 = '''' OR ExKey7 LIKE @ExKey7)
		AND (@ExKey8 IS NULL OR @ExKey8 = '''' OR ExKey8 LIKE @ExKey8)
		AND (@ExKey9 IS NULL OR @ExKey9 = '''' OR ExKey9 LIKE @ExKey9)
		AND (@ErrorCode IS NULL OR @ErrorCode = '''' OR ErrorCode = @ErrorCode)	
		AND (@Message IS NULL OR @Message = '''' OR [Message] Like ''%'' + @Message + ''%'' )		
		) t
	WHERE ROW_NO BETWEEN @ROW_NO_B AND @ROW_NO_E
END
' 
END
GO
