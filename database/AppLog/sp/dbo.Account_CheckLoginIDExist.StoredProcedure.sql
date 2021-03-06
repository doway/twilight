/****** Object:  StoredProcedure [dbo].[Account_CheckLoginIDExist]    Script Date: 05/17/2012 14:50:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account_CheckLoginIDExist]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Account_CheckLoginIDExist]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account_CheckLoginIDExist]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-03-29
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Account_CheckLoginIDExist]
@LoginID AS VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;

	IF EXISTS(SELECT LoginID
			FROM [AdmUser]
			WHERE LoginID = @LoginID)
		RETURN 1
	ELSE 
		RETURN 0
END
' 
END
GO
