/****** Object:  User [morning.bird]    Script Date: 02/23/2012 14:28:12 ******/
IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N'morning.bird')
DROP USER [morning.bird]
GO
CREATE USER [morning.bird] FOR LOGIN [morning.bird] WITH DEFAULT_SCHEMA=[dbo]
GO
GRANT EXECUTE ON [log_InsertNewMessage] TO [morning.bird]
GO

