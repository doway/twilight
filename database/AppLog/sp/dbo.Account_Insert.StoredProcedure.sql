/****** Object:  StoredProcedure [dbo].[Account_Insert]    Script Date: 05/15/2012 12:07:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account_Insert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Account_Insert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-03-08
-- Description:	Insert Account into database
-- =============================================
CREATE PROCEDURE [dbo].[Account_Insert]
	@LoginID		AS VARCHAR(20),
	@Password		AS VARCHAR(50),
	@SessionID		AS VARCHAR(50),
	@LoginAttempt 	AS TINYINT,
	@PositionID		AS INT,	
	@BUID			AS SMALLINT,
	@UserName		AS VARCHAR(50),
	@EMail			AS VARCHAR(128),
	@Remark			AS VARCHAR(256),
	@Status			AS INT,
	@UserType		AS INT,
	@Picture		AS IMAGE,
	@PictureType 	AS VARCHAR(5),
	@CreatedBy 		AS SMALLINT,
	@UserID 		AS SMALLINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
INSERT INTO [AdmUser]
           ([LoginID]
           ,[BUID]
           ,[UserName]
		   ,[EMail]
           ,[Remark]
           ,[Status]
           ,[UserType]
           ,[Picture]
           ,[PictureType]
           ,[DateCreated]
           ,[DateUpdated]
           ,[CreatedBy]
           ,[UpdatedBy])
     VALUES
           (@LoginID
           ,@BUID
           ,@UserName
		   ,@Email
           ,@Remark
           ,@Status
           ,@UserType
           ,@Picture
           ,@PictureType
           ,GetDate()
           ,GetDate()
           ,@CreatedBy
           ,NULL)


SELECT @UserID = @@IDENTITY;   
		   
EXEC [dbo].[Account_PasswordInsert]	   @UserID, @Password, @SessionID, @LoginAttempt 

EXEC [dbo].[Account_UserPositionInsert]	  @UserID, @PositionID, @CreatedBy
		  

END
' 
END
GO
