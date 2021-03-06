/****** Object:  StoredProcedure [dbo].[Account_CheckFunctionPermission]    Script Date: 05/15/2012 12:07:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account_CheckFunctionPermission]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Account_CheckFunctionPermission]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account_CheckFunctionPermission]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 01/15/2012
-- Description:	check user permission
-- Revision:
-- 2012-03-22: Revise the typo
-- =============================================
CREATE PROCEDURE [dbo].[Account_CheckFunctionPermission]
	@LoginID VARCHAR(20),
	@FunctionID INT,
	@AccessLevel INT
AS
BEGIN
	SET NOCOUNT ON;

	IF NOT EXISTS(Select AU.LoginID ,PF.FunctionID,PF.AccessLevel 
	  FROM 
		dbo.AdmUser AU INNER JOIN dbo.AdmUserPosition AUP ON AU.UserID = AUP.UserID
		INNER JOIN dbo.Position P ON AUP.PositionID = P.PositionID
		INNER JOIN dbo.PositionFunction PF ON P.PositionID = PF.PositionID
	  WHERE 
		AU.LoginID = @LoginID AND PF.FunctionID = @FunctionID AND PF.AccessLevel >= @AccessLevel)
	RETURN 0
  ELSE
	RETURN 1
END
' 
END
GO
