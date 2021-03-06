/****** Object:  StoredProcedure [dbo].[Account_Update]    Script Date: 05/15/2012 12:07:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account_Update]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Account_Update]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-03-08
-- Description:	Insert Account into database
-- =============================================
CREATE PROCEDURE [dbo].[Account_Update]
	@UserID 		AS SMALLINT,
	@Password		AS VARCHAR(50),
	@SessionID		AS VARCHAR(50),
	@LoginAttempt 	AS TINYINT,
	@PositionID		AS INT,	
	@BUID			AS SMALLINT,
	@UserName		AS VARCHAR(50),
	@EMail			AS VARCHAR(128),
	@Remark			AS VARCHAR(256),
	@Status			AS TINYINT,
	@UserType		AS TINYINT,
	@Picture		AS IMAGE,
	@PictureType 	AS VARCHAR(5),
	@UpdatedBy 		AS SMALLINT
AS
BEGIN
	SET NOCOUNT ON;
UPDATE [AdmUser]
   SET [BUID] = @BUID
      ,[UserName] = @UserName
	  ,[EMail]	  = @EMail
      ,[Remark] = @Remark
      ,[Status] = @Status
      ,[UserType] = @UserType
      ,[Picture] = @Picture
      ,[PictureType] = @PictureType
      ,[DateUpdated] = GETDATE()
      ,[UpdatedBy] = @UpdatedBy
 WHERE UserID = @UserID
		   
EXEC [dbo].[Account_PasswordUpdate]	   @UserID, @Password, @SessionID, @LoginAttempt 

EXEC [dbo].[Account_UserPositionUpdate]	  @UserID, @PositionID, @UpdatedBy

END
' 
END
GO
