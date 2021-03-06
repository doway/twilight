/****** Object:  StoredProcedure [dbo].[Account_PasswordUpdate]    Script Date: 05/15/2012 12:07:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account_PasswordUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Account_PasswordUpdate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account_PasswordUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-03-09
-- Description:	Update password 
-- =============================================
CREATE PROCEDURE [dbo].[Account_PasswordUpdate]
	@UserID  	AS SMALLINT,
	@Password		AS VARCHAR(50),
	@SessionID		AS VARCHAR(50),
	@LoginAttempt AS TINYINT
AS
BEGIN
	SET NOCOUNT ON;
UPDATE [AdmUserPassword]
SET [Password] = @Password
      ,[SessionID] = @SessionID	
      ,[LoginAttempt] = @LoginAttempt
WHERE UserID = @UserID

RETURN @@ROWCOUNT

END
' 
END
GO
