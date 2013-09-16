/****** Object:  StoredProcedure [dbo].[ServerBUMapping_Delete]    Script Date: 05/15/2012 12:07:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ServerBUMapping_Delete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ServerBUMapping_Delete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ServerBUMapping_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-03-30
-- Description:	Delete ServerBUMapping
-- =============================================
CREATE PROCEDURE [dbo].[ServerBUMapping_Delete]
	@ID			AS int
AS
BEGIN
	SET NOCOUNT ON;
DELETE ServerBUMapping
WHERE ID=@ID
		 
END
' 
END
GO
