/****** Object:  StoredProcedure [dbo].[Account_PasswordInsert]    Script Date: 05/15/2012 12:07:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account_PasswordInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Account_PasswordInsert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account_PasswordInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-03-08
-- Description:	Insert password into database
-- =============================================
CREATE PROCEDURE [dbo].[Account_PasswordInsert]
	@UserID  		AS SMALLINT,
	@Password		AS VARCHAR(50),
	@SessionID		AS VARCHAR(50),
	@LoginAttempt 	AS TINYINT
AS
BEGIN
	SET NOCOUNT ON;
INSERT INTO [AdmUserPassword]
           ([UserID]
           ,[Password]
           ,[SessionID]
           ,[LoginAttempt])
     VALUES
           (@UserID
           ,@Password
           ,@SessionID	
           ,@LoginAttempt)
END
' 
END
GO
