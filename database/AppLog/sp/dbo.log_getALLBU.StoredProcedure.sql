/****** Object:  StoredProcedure [dbo].[log_getALLBU]    Script Date: 05/15/2012 12:07:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[log_getALLBU]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[log_getALLBU]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[log_getALLBU]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 02/14/2012
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[log_getALLBU]
AS
BEGIN
	SET NOCOUNT ON;

Select BUID,BUName
From BU
Order by BUID

END
' 
END
GO
