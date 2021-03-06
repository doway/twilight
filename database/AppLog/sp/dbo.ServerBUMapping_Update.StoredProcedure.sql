/****** Object:  StoredProcedure [dbo].[ServerBUMapping_Update]    Script Date: 05/15/2012 12:07:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ServerBUMapping_Update]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ServerBUMapping_Update]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ServerBUMapping_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-03-30
-- Description:	Update ServerBUMapping
-- =============================================
CREATE PROCEDURE [dbo].[ServerBUMapping_Update]
	@ID				AS int,
	@BUID			AS smallint,
	@ServerIP 		AS varchar(50),
	@ServerName		AS varchar(50),
	@Status			AS smallint
AS
BEGIN
	SET NOCOUNT ON;
UPDATE [ServerBUMapping]
SET BUID = @BUID, ServerIP = @ServerIP, ServerName = @ServerName, Status = @status
WHERE ID = @ID
END
' 
END
GO
