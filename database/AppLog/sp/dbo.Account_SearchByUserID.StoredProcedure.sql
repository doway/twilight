/****** Object:  StoredProcedure [dbo].[Account_SearchByUserID]    Script Date: 05/15/2012 12:07:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account_SearchByUserID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Account_SearchByUserID]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account_SearchByUserID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 03/28/2012
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Account_SearchByUserID]
@UserID AS SMALLINT
AS
BEGIN
	SET NOCOUNT ON;

SELECT au.[UserID]
      ,au.[LoginID]
	  ,aup1.Password
      ,aup2.PositionID
      ,au.[BUID]
      ,au.[UserName]
	  ,au.[Email]
      ,au.[Remark]
      ,au.[Status]
      ,au.[UserType]
      ,au.[Picture]
      ,au.[PictureType]
      ,au.[DateCreated]
      ,au.[DateUpdated]
  FROM 
	[AdmUser] au 
	INNER JOIN AdmUserPassword aup1 ON au.UserID = aup1.UserID 
	INNER JOIN AdmUserPosition aup2 on au.UserID = aup2.UserID 
	INNER JOIN Position p on aup2.PositionID = p.PositionID
  WHERE au.UserID = @UserID
	
END
' 
END
GO
