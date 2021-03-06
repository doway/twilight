/****** Object:  StoredProcedure [dbo].[log_DropOldLog]    Script Date: 05/15/2012 12:07:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[log_DropOldLog]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[log_DropOldLog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[log_DropOldLog]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Tom Tang
-- Create date: 2011-05-11
-- Description:	Clean up old log by policy
-- Revision:
-- 2011-05-31: Bug fixing for infinite deleting loop
-- =============================================
CREATE PROCEDURE [dbo].[log_DropOldLog]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @DEBUG_RESERVED_DAYS AS TINYINT;		SET @DEBUG_RESERVED_DAYS = 1;
	DECLARE @INFO_RESERVED_DAYS AS TINYINT;			SET @INFO_RESERVED_DAYS = 7;
	DECLARE @WARN_RESERVED_DAYS AS TINYINT;			SET @WARN_RESERVED_DAYS = 14;
	DECLARE @ERROR_RESERVED_DAYS AS TINYINT;		SET @ERROR_RESERVED_DAYS = 30;
	DECLARE @FATAL_RESERVED_DAYS AS TINYINT;		SET @FATAL_RESERVED_DAYS = 30;
	DECLARE @PurgeDate AS DATETIME;
	DECLARE @ReservedDays AS TINYINT;
	DECLARE @Level AS CHAR(5);
	
	-- Purge debug level
	SET @ReservedDays = @DEBUG_RESERVED_DAYS;	SET @Level = ''DEBUG'';
	SET @PurgeDate = DATEADD(dd, -@ReservedDays, GETDATE());
	WHILE EXISTS(SELECT TOP 1 ID FROM [Log] l (NOLOCK) WHERE l.DBLoggingDT < @PurgeDate AND [Level] = @Level) BEGIN
		DELETE [Log]
		WHERE ID IN (
			SELECT TOP 500 ID
			FROM [Log] l (NOLOCK)
			WHERE 
				l.DBLoggingDT < @PurgeDate
				AND [Level] = @Level
			)
	END

	-- Purge info level
	SET @ReservedDays = @INFO_RESERVED_DAYS;	SET @Level = ''INFO'';
	SET @PurgeDate = DATEADD(dd, -@ReservedDays, GETDATE());
	WHILE EXISTS(SELECT TOP 1 ID FROM [Log] l (NOLOCK) WHERE l.DBLoggingDT < @PurgeDate AND [Level] = @Level) BEGIN
		DELETE [Log]
		WHERE ID IN (
			SELECT TOP 500 ID
			FROM [Log] l (NOLOCK)
			WHERE 
				l.DBLoggingDT < @PurgeDate
				AND [Level] = @Level
			)
	END

	-- Purge warn level
	SET @ReservedDays = @WARN_RESERVED_DAYS;	SET @Level = ''WARN'';
	SET @PurgeDate = DATEADD(dd, -@ReservedDays, GETDATE());
	WHILE EXISTS(SELECT TOP 1 ID FROM [Log] l (NOLOCK) WHERE l.DBLoggingDT < @PurgeDate AND [Level] = @Level) BEGIN
		DELETE [Log]
		WHERE ID IN (
			SELECT TOP 500 ID
			FROM [Log] l (NOLOCK)
			WHERE 
				l.DBLoggingDT < @PurgeDate
				AND [Level] = @Level
			)
	END

	-- Purge error level
	SET @ReservedDays = @ERROR_RESERVED_DAYS;	SET @Level = ''ERROR'';
	SET @PurgeDate = DATEADD(dd, -@ReservedDays, GETDATE());
	WHILE EXISTS(SELECT TOP 1 ID FROM [Log] l (NOLOCK) WHERE l.DBLoggingDT < @PurgeDate AND [Level] = @Level) BEGIN
		DELETE [Log]
		WHERE ID IN (
			SELECT TOP 500 ID
			FROM [Log] l (NOLOCK)
			WHERE 
				l.DBLoggingDT < @PurgeDate
				AND [Level] = @Level
			)
	END
	
	-- Purge fatal level
	SET @ReservedDays = @FATAL_RESERVED_DAYS;	SET @Level = ''FATAL'';
	SET @PurgeDate = DATEADD(dd, -@ReservedDays, GETDATE());
	WHILE EXISTS(SELECT TOP 1 ID FROM [Log] l (NOLOCK) WHERE l.DBLoggingDT < @PurgeDate AND [Level] = @Level) BEGIN
		DELETE [Log]
		WHERE ID IN (
			SELECT TOP 500 ID
			FROM [Log] l (NOLOCK)
			WHERE 
				l.DBLoggingDT < @PurgeDate
				AND [Level] = @Level
			)
	END
END
' 
END
GO
