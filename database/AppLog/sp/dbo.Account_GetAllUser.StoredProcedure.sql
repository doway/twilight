/****** Object:  StoredProcedure [dbo].[Account_GetALLUser]    Script Date: 05/15/2012 12:07:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account_GetALLUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Account_GetALLUser]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account_GetALLUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-03-27
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Account_GetALLUser]
AS
BEGIN
	SET NOCOUNT ON;

SELECT au.[UserID]
      ,au.[LoginID]
      ,p.PositionName
      ,au.[BUID]
      ,au.[UserName]
      ,au.[Remark]
      ,au.[Status]
      ,au.[UserType]
      ,au.[Picture]
      ,au.[PictureType]
      ,au.[DateCreated]
      ,au.[DateUpdated]
  FROM 
	[AdmUser] au 
	INNER JOIN AdmUserPosition aup ON au.UserID = aup.UserID 
	INNER JOIN Position p ON aup.PositionID = p.PositionID
  ORDER BY LoginID DESC
END
' 
END
GO
