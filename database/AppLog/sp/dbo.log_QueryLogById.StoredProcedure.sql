/****** Object:  StoredProcedure [dbo].[log_QueryLogById]    Script Date: 05/15/2012 12:07:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[log_QueryLogById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[log_QueryLogById]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[log_QueryLogById]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-02-14
-- Description:	
-- Revision:
-- 2012-05-28: Add new field [AppName]
-- =============================================
CREATE PROCEDURE [dbo].[log_QueryLogById]
	@ID			AS BIGINT
AS
BEGIN
	SELECT [ID]
      ,[AppLoggingDT]
      ,[Thread]
      ,[Level]
      ,[Logger]
      ,[Message]
      ,[DBLoggingDT]
      ,l.[BUID]
      ,b.BUName
	  ,l.[AppName]
      ,[ExKey1]
      ,[ExKey2]
      ,[ExKey3]
      ,[ExKey4]
      ,[ExKey5]
      ,[ExKey6]
      ,[ExKey7]
      ,[ExKey8]
      ,[ExKey9]
      ,[ExKey10]
      ,[Src]
      ,[Exception]
      ,[ErrorCode]
  FROM [Log] l LEFT JOIN BU b ON b.BUID = l.BUID
  WHERE ID = @ID
END
' 
END
GO
