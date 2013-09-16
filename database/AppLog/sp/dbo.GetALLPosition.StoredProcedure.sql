/****** Object:  StoredProcedure [dbo].[GetAllPosition]    Script Date: 05/15/2012 12:07:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetAllPosition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetAllPosition]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetAllPosition]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-03-09
-- Description:	Update user position 
-- =============================================
CREATE PROCEDURE [dbo].[GetAllPosition]
AS
BEGIN
	SET NOCOUNT ON;
SELECT [PositionID]
      ,[BUID]
      ,[PositionName]
      ,[AccessType]
      ,[Status]
      ,[DateCreated]
      ,[DateUpdated]
      ,[CreatedBy]
      ,[UpdatedBy]
  FROM [Position] NOLOCK
  Order by PositionID

END
' 
END
GO
