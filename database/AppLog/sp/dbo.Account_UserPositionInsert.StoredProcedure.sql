/****** Object:  StoredProcedure [dbo].[Account_UserPositionInsert]    Script Date: 05/15/2012 12:07:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account_UserPositionInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Account_UserPositionInsert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account_UserPositionInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-03-08
-- Description:	Insert user position into database
-- =============================================
CREATE PROCEDURE [dbo].[Account_UserPositionInsert]
	@UserID			AS smallint,
	@PositionID	AS int,
	@CreatedBy		AS int
AS
BEGIN
	SET NOCOUNT ON;
INSERT INTO [AdmUserPosition]
           ([UserID]
           ,[PositionID]
           ,[DateCreated]
           ,[DateUpdated]
           ,[CreatedBy]
           ,[UpdatedBy])
     VALUES
           (@UserID
           ,@PositionID
           ,GETDATE()
           ,GETDATE()
           ,@CreatedBy
           ,NULL)
END
' 
END
GO
