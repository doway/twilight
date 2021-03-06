/****** Object:  StoredProcedure [dbo].[Account_UserPositionUpdate]    Script Date: 05/15/2012 12:07:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account_UserPositionUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Account_UserPositionUpdate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account_UserPositionUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-03-09
-- Description:	Update user position 
-- =============================================
CREATE PROCEDURE [dbo].[Account_UserPositionUpdate]
	@UserID			AS SMALLINT,
	@PositionID	AS INT,
	@UpdatedBy		AS INT
AS
BEGIN
	SET NOCOUNT ON;
UPDATE [AdmUserPosition]
   SET [PositionID] = @PositionID
      ,[DateUpdated] = GETDATE()
      ,[UpdatedBy] = @UpdatedBy
WHERE UserID = @UserID

END
' 
END
GO
