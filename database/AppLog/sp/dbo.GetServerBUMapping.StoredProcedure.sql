/****** Object:  StoredProcedure [dbo].[GetServerBUMapping]    Script Date: 05/15/2012 12:07:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetServerBUMapping]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetServerBUMapping]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetServerBUMapping]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-04-2
-- Description:	Get ServerBUMapping
-- =============================================
CREATE PROCEDURE [dbo].[GetServerBUMapping]
	@ID as int
AS
BEGIN
	SET NOCOUNT ON;
Select     ID
		   ,sbu.[BUID]
		   ,b.BUName
           ,[ServerIP]
           ,[ServerName]
           ,[Status]
From 
	ServerBUMapping sbu 
	inner Join BU b On sbu.BUID= b.BUID	   
Where	ID=@ID
END
' 
END
GO
