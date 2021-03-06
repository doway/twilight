/****** Object:  StoredProcedure [dbo].[Account_ValidateUser]    Script Date: 05/15/2012 12:07:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account_ValidateUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Account_ValidateUser]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account_ValidateUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-02-10
-- Description:
-- =============================================
CREATE PROCEDURE [dbo].[Account_ValidateUser]
	@LoginID Varchar(20),
	@Password Varchar(50),
	@UserID AS INT OUTPUT,
	@BUID As smallint OUTPUT,
	@PositionID As int OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	Declare @UserStatus int;
	Declare @LoginAttempt int;
	Declare @IsDelete char;

	--RETURN CODE
	--  1 success
	-- -1 account isn''t exist
	-- -2 password isn''t correct
	-- -3 account disable
	-- -4 account lock
	-- -5 account was deleted
	
    -- Insert statements for procedure here
    	IF NOT EXISTS(select * from [MonitorLog].[dbo].[AdmUser] where  LoginID = @LoginID) 
    		RETURN -1
    	ELSE
		BEGIN
			SELECT @UserStatus = A.Status, @UserID = A.UserID, @LoginAttempt = aup.LoginAttempt, @IsDelete= A.IsDelete, @BUID=A.BUID, @PositionID=aup2.PositionID
			FROM 
				[AdmUser] A 
				INNER JOIN [dbo].[AdmUserPassword] aup ON a.USERID = aup.USERID 
				INNER JOIN [dbo].[AdmUserPosition] aup2 ON a.UserID = aup2.UserID
			WHERE A.LoginID = @LoginID		
			
			if(@IsDelete = 1)
				RETURN -5;
			
			-- check loginAttempt 
			IF(@LoginAttempt = 3)
				RETURN -4
			
    		-- password incorrect
    		IF NOT EXISTS(SELECT A.LoginID, A.Status , A.UserID, A.UserName, A.UserType
						 FROM [dbo].[AdmUser] A 
						 INNER JOIN [dbo].[AdmUserPassword] P ON A.UserID = P.UserID
						 WHERE A.LoginID = @LoginID and P.Password = @Password)
			BEGIN
				-- add loginattempt count
				UPDATE [AdmUserPassword] SET LoginAttempt = LoginAttempt + 1 WHERE UserID=@UserID		 
				RETURN -2
			END
			ELSE
			BEGIN
				-- reset loginattempt count
				UPDATE [AdmUserPassword] SET LoginAttempt = 0 WHERE UserID=@UserID
				-- User disable
				IF @UserStatus <> 1
					RETURN -3
				-- SUCCESS
				ELSE
					RETURN 1
			END
		END
END
' 
END
GO
