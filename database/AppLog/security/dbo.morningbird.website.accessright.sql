/****** Object:  User [morningbird.website]    Script Date: 02/23/2012 14:28:12 ******/
IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N'morning.bird')
DROP USER [morningbird.website]
GO
CREATE USER [morningbird.website] FOR LOGIN [morningbird.website] WITH DEFAULT_SCHEMA=[dbo]
GO
GRANT EXECUTE ON [Account_CheckFunctionPermission] TO [morningbird.website]
GRANT EXECUTE ON [Account_CheckLoginIDExist] TO [morningbird.website]
GRANT EXECUTE ON [Account_Delete] TO [morningbird.website]
GRANT EXECUTE ON [Account_GetALLUser] TO [morningbird.website]
GRANT EXECUTE ON [Account_Insert] TO [morningbird.website]
GRANT EXECUTE ON [Account_PasswordInsert] TO [morningbird.website]
GRANT EXECUTE ON [Account_PasswordUpdate] TO [morningbird.website]
GRANT EXECUTE ON [Account_Search] TO [morningbird.website]
GRANT EXECUTE ON [Account_SearchByUserID] TO [morningbird.website]
GRANT EXECUTE ON [Account_Update] TO [morningbird.website]
GRANT EXECUTE ON [Account_UserPositionInsert] TO [morningbird.website]
GRANT EXECUTE ON [Account_UserPositionUpdate] TO [morningbird.website]
GRANT EXECUTE ON [Account_ValidateUser] TO [morningbird.website]
GRANT EXECUTE ON [BU_Delete] TO [morningbird.website]
GRANT EXECUTE ON [BU_Insert] TO [morningbird.website]
GRANT EXECUTE ON [BU_Update] TO [morningbird.website]
GRANT EXECUTE ON [GetAllBU] TO [morningbird.website]
GRANT EXECUTE ON [GetAllPosition] TO [morningbird.website]
GRANT EXECUTE ON [GetBUByID] TO [morningbird.website]
GRANT EXECUTE ON [GetServerBUMapping] TO [morningbird.website]
GRANT EXECUTE ON [KnowledgeBase_DeleteFileAttachment] TO [morningbird.website]
GRANT EXECUTE ON [KnowledgeBase_DeleteKeywordMapping] TO [morningbird.website]
GRANT EXECUTE ON [KnowledgeBase_DeleteReferenceLink] TO [morningbird.website]
GRANT EXECUTE ON [KnowledgeBase_DeleteUnuseFileAttachment] TO [morningbird.website]
GRANT EXECUTE ON [KnowledgeBase_GetFileAttachment] TO [morningbird.website]
GRANT EXECUTE ON [KnowledgeBase_GetKMInfo] TO [morningbird.website]
GRANT EXECUTE ON [KnowledgeBase_Insert] TO [morningbird.website]
GRANT EXECUTE ON [KnowledgeBase_InsertComment] TO [morningbird.website]
GRANT EXECUTE ON [KnowledgeBase_InsertFileAttachment] TO [morningbird.website]
GRANT EXECUTE ON [KnowledgeBase_InsertKeywordMapping] TO [morningbird.website]
GRANT EXECUTE ON [KnowledgeBase_InsertReferenceLink] TO [morningbird.website]
GRANT EXECUTE ON [KnowledgeBase_Search] TO [morningbird.website]
GRANT EXECUTE ON [KnowledgeBase_Update] TO [morningbird.website]
GRANT EXECUTE ON [KnowledgeBase_UpdateFileAttachment] TO [morningbird.website]
GRANT EXECUTE ON [log_DropOldLog] TO [morningbird.website]
GRANT EXECUTE ON [log_LiveMonitoring] TO [morningbird.website]
GRANT EXECUTE ON [log_QueryLog] TO [morningbird.website]
GRANT EXECUTE ON [log_QueryLogById] TO [morningbird.website]
GRANT EXECUTE ON [ServerBUMapping_Delete] TO [morningbird.website]
GRANT EXECUTE ON [ServerBUMapping_Insert] TO [morningbird.website]
GRANT EXECUTE ON [ServerBUMapping_Search] TO [morningbird.website]
GRANT EXECUTE ON [ServerBUMapping_Update] TO [morningbird.website]
GRANT EXECUTE ON [state_LogPieTrendByBU] TO [morningbird.website]
GRANT EXECUTE ON [state_LogPieTrendByLevel] TO [morningbird.website]
GRANT EXECUTE ON [state_LogPieTrendByApp] TO [morningbird.website]
GRANT EXECUTE ON [state_LogTrendByBU] TO [morningbird.website]
GRANT EXECUTE ON [state_LogTrendByLevel] TO [morningbird.website]
GO

