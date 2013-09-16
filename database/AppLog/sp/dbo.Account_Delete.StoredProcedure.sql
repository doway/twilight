/****** Object:  StoredProcedure [dbo].[Account_Delete]    Script Date: 05/15/2012 12:07:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account_Delete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Account_Delete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-03-09
-- Description:	Account_Delete
-- =============================================
CREATE PROCEDURE [dbo].[Account_Delete]
@UserID AS SMALLINT
AS
BEGIN
	SET NOCOUNT ON;

UPDATE AdmUser SET IsDelete = 1
WHERE UserID = @UserID
	
END
' 
END
GO
