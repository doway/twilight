/****** Object:  StoredProcedure [dbo].[GetAllBU]    Script Date: 05/15/2012 12:07:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetAllBU]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetAllBU]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetAllBU]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 02/14/2012
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[GetAllBU]
AS
BEGIN
	SET NOCOUNT ON;

	Select BUID, BUName
	From BU (NOLOCK)
	Order by BUID
	
END
' 
END
GO
