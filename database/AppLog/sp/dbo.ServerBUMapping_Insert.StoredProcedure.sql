/****** Object:  StoredProcedure [dbo].[ServerBUMapping_Insert]    Script Date: 05/15/2012 12:07:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ServerBUMapping_Insert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ServerBUMapping_Insert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ServerBUMapping_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Austin Chen
-- Create date: 2012-03-30
-- Description:	Insert ServerBUMapping
-- =============================================
CREATE PROCEDURE [dbo].[ServerBUMapping_Insert]
	@BUID			AS smallint,
	@ServerIP 		AS varchar(50),
	@ServerName		AS varchar(50),
	@Status			AS smallint
AS
BEGIN
	SET NOCOUNT ON;
INSERT INTO [ServerBUMapping]
           ([BUID]
           ,[ServerIP]
           ,[ServerName]
           ,[Status])
     VALUES
           (@BUID
           ,@ServerIP 
           ,@ServerName	
           ,@Status	)
		 
END
' 
END
GO
