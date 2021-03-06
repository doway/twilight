/****** Object:  StoredProcedure [dbo].[log_InsertNewMessage]    Script Date: 05/15/2012 12:07:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[log_InsertNewMessage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[log_InsertNewMessage]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[log_InsertNewMessage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Tom Tang
-- Create date: 2011-03-28
-- Description:	Insert logging message into database
-- Revision:
-- 2011-05-04: Extend more fields for storing information.
-- 2011-05-31: Write BU into field.
-- 2012-02-13: Map BUID by @Src
-- 2012-05-28: Add new [appName] parameter
-- =============================================
CREATE PROCEDURE [dbo].[log_InsertNewMessage]
	@AppDate	AS DATETIME,
	@Thread		AS VARCHAR(20),
	@Level		AS CHAR(5),
	@Logger		AS VARCHAR(100),
	@Message	AS NVARCHAR(MAX),
	@AppName	AS VARCHAR(20) = NULL,
	@ExKey1		AS VARCHAR(20) = NULL,
	@ExKey2		AS VARCHAR(20) = NULL,
	@ExKey3		AS VARCHAR(20) = NULL,
	@ExKey4		AS VARCHAR(20) = NULL,
	@ExKey5		AS VARCHAR(20) = NULL,
	@ExKey6		AS VARCHAR(20) = NULL,
	@ExKey7		AS VARCHAR(20) = NULL,
	@ExKey8		AS VARCHAR(20) = NULL,
	@ExKey9		AS VARCHAR(20) = NULL,
	@ExKey10	AS VARCHAR(20) = NULL,
	@Exception	AS NVARCHAR(MAX) = NULL,
	@ErrorCode	AS CHAR(10) = NULL,
	@Src		AS VARCHAR(20) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @BUID SMALLINT;
	
	SET @BUID = (
		SELECT TOP 1 BUID 
		FROM ServerBUMapping sbm(NOLOCK) 
		WHERE ServerIP = @Src OR ServerName = @Src);
		
	IF @BUID IS NULL SET @BUID = 0;
	INSERT INTO [Log](
		AppLoggingDT,
		Thread,
		[Level],
		Logger,
		[Message],
		BUID,
		AppName,
		ExKey1,
		ExKey2,
		ExKey3,
		ExKey4,
		ExKey5,
		ExKey6,
		ExKey7,
		ExKey8,
		ExKey9,
		ExKey10,
		Src,
		Exception,
		ErrorCode
	) VALUES(
		@AppDate,
		@Thread,
		@Level,
		@Logger,
		@Message,
		@BUID,
		@AppName,
		@ExKey1,
		@ExKey2,
		@ExKey3,
		@ExKey4,
		@ExKey5,
		@ExKey6,
		@ExKey7,
		@ExKey8,
		@ExKey9,
		@ExKey10,
		@Src,
		@Exception,
		@ErrorCode
	)
END
' 
END
GO
