using log4net;
using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Data.SqlClient;
using System.Transactions;

namespace Twilight.Error
{
    /// <summary>
    /// A general error handling by Twilight policy facility.
    /// </summary>
    public sealed class TwilightErrorHandler
    {
        private static readonly ILog _logger = LogManager.GetLogger(typeof(TwilightErrorHandler));
        /// <summary>
        /// Represent the unique index violation error number
        /// </summary>
        private const int UNIQUE_INDEX_DUPLICATED = 2601;
        /// <summary>
        /// Represent database execution timeout
        /// </summary>
        private const int EXECUTION_TIMEOUT = -2;
        /// <summary>
        /// Represent the unique index violation error number
        /// </summary>
        private const int ERROR_NUM_UNIQUE_VIOLATION = 2627;

        private const string CONST_UNKNOWN = "UNKNOWN";
        private const string CONST_BIZ_UNKNOWN = "BIZUNKNOWN";
        private TwilightErrorHandler() { }
        /// <summary>
        /// Set ot get the indicated application name. This data will be kept going within this thread.
        /// Each thread has different this property context.
        /// </summary>
        public static string AppName
        {
            get
            {
                return (string)GlobalContext.Properties["appname"];
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                    GlobalContext.Properties.Remove("appname");
                else
                    GlobalContext.Properties["appname"] = value;
            }
        }
        /// <summary>
        /// Regular exception handle process -
        /// Log the exception message, then wrap it as TwilightException and return
        /// </summary>
        /// <param name="ex">Any exception</param>
        /// <param name="log">The delegated logger that would be used to log the error message</param>
        /// <returns>Any exception will be wrapped as TwilightException</returns>
        /// <param name="exkeys">You can pass less than 10 extension keys for correlation and search purpose.</param>
        public static TwilightException HandleException(Exception ex, ILog log, params string[] exkeys)
        {
            return HandleException(null, ex, log, exkeys);
        }
        /// <summary>
        /// Regular exception handle process -
        /// Log the exception message, then wrap it as TwilightException and return
        /// </summary>
        /// <param name="ex">Any exception</param>
        /// <param name="log">The delegated logger that would be used to log the error message</param>
        /// <returns>Any exception will be wrapped as TwilightException</returns>
        /// <param name="appName">
        /// Pass the application name to indicate which application output this message.
        /// It's meaningless within null or empty value.
        /// If you want to remove this data, please assign the AppName property as null or empty.
        /// </param>
        /// <param name="exkeys">You can pass less than 10 extension keys for correlation and search purpose.</param>
        public static TwilightException HandleException(string appName, Exception ex, ILog log, params string[] exkeys)
        {
            // Suppress from joining any exist transaction scope
            using (new TransactionScope(TransactionScopeOption.Suppress))
            {
                ILog logger = (null == log) ? _logger : log;
                TwilightException exception = null;
                try
                {
                    if (ex is TwilightException)
                    {
                        exception = (TwilightException)ex;
                    }
                    else if (ex is ApplicationException)
                    {
                        exception = new TwilightException(ex.Message, CONST_BIZ_UNKNOWN, ex);
                    }
                    else if (ex.GetType().IsSubclassOf(typeof(ApplicationException)))
                    {
                        exception = new TwilightException(ex.Message, CONST_BIZ_UNKNOWN, ex);
                    }
                    else if (ex is DbException)
                    {
                        if (ex is SqlException)
                        {
                            SqlException sqlEx = (SqlException)ex;
                            switch (sqlEx.Number)
                            {
                                case ERROR_NUM_UNIQUE_VIOLATION:
                                case UNIQUE_INDEX_DUPLICATED:
                                    exception = new TwilightException(ex.Message, "SQLDB2601", ex);
                                    break;
                                case EXECUTION_TIMEOUT:
                                    exception = new TwilightException(
                                        string.Format("SQL Exception's errNumber={0} / ErrCode={1}\r\nMessage:{2}",
                                            sqlEx.Number, sqlEx.ErrorCode, sqlEx.Message), "SQLDB" + sqlEx.ErrorCode, ex, TwilightException.SeverityLevelEnum.ERROR);
                                    break;
                                default:
                                    exception = new TwilightException(
                                        string.Format("SQL Exception's errNumber={0} / ErrCode={1}\r\nMessage:{2}",
                                            sqlEx.Number, sqlEx.ErrorCode, sqlEx.Message), "SQLDB" + sqlEx.ErrorCode, ex, TwilightException.SeverityLevelEnum.ERROR);
                                    break;
                            }
                        }
                        else
                        {
                            exception = new TwilightException(ex.Message, "DB00" + ((DbException)ex).ErrorCode, ex, TwilightException.SeverityLevelEnum.ERROR);
                        }
                    }
                    else
                    {
                        ex = ex.GetBaseException();
                        exception = new TwilightException(ex.Message, CONST_UNKNOWN, ex, TwilightException.SeverityLevelEnum.ERROR);
                    }
                }
                catch { }

                if (null == exception) exception = new TwilightException(ex.Message, CONST_UNKNOWN, ex, TwilightException.SeverityLevelEnum.ERROR);

                const int max_extension_key_length = 10;

                #region add extra informations
                try
                {
                    if (!string.IsNullOrEmpty(appName)) AppName = appName;

                    // threadContextValues is prepared for AsyncForwardAppender to proceed extension keys and values.
                    // It won't be used if application is using AdoNetAppender directly.
                    List<KeyValuePair<string, string>> threadContextValues = new List<KeyValuePair<string, string>>();
                    ThreadContext.Properties["errorcode"] = exception.ErrorCode;
                    threadContextValues.Add(new KeyValuePair<string, string>("errorcode", exception.ErrorCode));
                    for (int i = 0; i < exkeys.Length && i < max_extension_key_length; i++)
                    {
                        ThreadContext.Properties[string.Format("exKey{0}", i)] = exkeys[i];
                        threadContextValues.Add(new KeyValuePair<string, string>(string.Format("exKey{0}", i), exkeys[i]));
                    }
                    // The key-"LOGPACK_THREADCONTEXT" is a constant as a deal(contract) for AsyncForwardAppender to retrieve it.
                    ThreadContext.Properties["LOGPACK_THREADCONTEXT"] = threadContextValues;
                }
                catch (Exception logEx)
                {
                    _logger.Warn("[LOG4NET] ThreadContext.Properties adding error:" + logEx.Message, logEx);
                }
                #endregion

                switch (exception.SeverityLevel)
                {
                    case TwilightException.SeverityLevelEnum.WARN:
                        logger.Warn(exception.Message, ex);
                        break;
                    case TwilightException.SeverityLevelEnum.ERROR:
                        logger.Error(exception.Message, ex);
                        break;
                    case TwilightException.SeverityLevelEnum.FATAL:
                        logger.Fatal(exception.Message, ex);
                        break;
                }

                #region remove extra informations
                try
                {
                    ThreadContext.Properties.Remove("errorcode");
                    for (int i = 0; i < exkeys.Length && i < max_extension_key_length; i++)
                        ThreadContext.Properties.Remove("exKey{0}");
                }
                catch (Exception logEx)
                {
                    _logger.Warn("[LOG4NET] ThreadContext.Properties removing error:" + logEx.Message, logEx);
                }
                #endregion

                return exception;
            }
        }
    }
}