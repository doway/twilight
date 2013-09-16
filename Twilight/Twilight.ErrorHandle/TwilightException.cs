using System;

namespace Twilight
{
    /// <summary>
    /// Represents a general exception class that occur during application execution for Twilight to recognize.
    /// </summary>
    public class TwilightException : ApplicationException
    {
        /// <summary>
        /// Define TwilightException severity level
        /// </summary>
        public enum SeverityLevelEnum
        {
            /// <summary>
            /// Represent severity is warning
            /// </summary>
            WARN,
            /// <summary>
            /// Represent the severity eror
            /// </summary>
            ERROR,
            /// <summary>
            /// Represent the severity fatal
            /// </summary>
            FATAL
        }
        /// <summary>
        /// Initializes a new instance of the System.Exception class with a specified
        /// error message and a reference to the inner exception that is the cause of
        /// this exception.
        /// </summary>
        /// <param name="message">The error message that explains the reason for the exception.</param>
        /// <param name="errorCode">The error identity that could be look up in knowledge base</param>
        /// <param name="innerException">The exception that is the cause of the current exception, or a null reference(Nothing in Visual Basic) if no inner exception is specified.</param>
        /// <param name="level">Specify the severity level</param>
        public TwilightException(string message, string errorCode, Exception innerException, SeverityLevelEnum level)
            : base(message, innerException)
        {
            ErrorCode = errorCode;
            SeverityLevel = level;
        }
        /// <summary>
        /// Initializes a new instance of the System.Exception class with a specified
        /// error message and a reference to the inner exception that is the cause of
        /// this exception. (Default severity level is WARN)
        /// </summary>
        /// <param name="message">The error message that explains the reason for the exception.</param>
        /// <param name="errorCode">The error identity that could be look up in knowledge base</param>
        /// <param name="innerException">The exception that is the cause of the current exception, or a null reference(Nothing in Visual Basic) if no inner exception is specified.</param>
        public TwilightException(string message, string errorCode, Exception innerException)
            : this(message, errorCode, innerException, SeverityLevelEnum.WARN) { }
        /// <summary>
        /// Initializes a new instance of the System.Exception class with a specified
        /// error message and a reference to the inner exception that is the cause of
        /// this exception. (Default severity level is WARN)
        /// </summary>
        /// <param name="message">The error message that explains the reason for the exception.</param>
        /// <param name="errorCode">The error identity that could be look up in knowledge base</param>
        public TwilightException(string message, string errorCode)
            : this(message, errorCode, null) { }
        /// <summary>
        /// Initializes a new instance of the System.Exception class with a specified
        /// error message and a reference to the inner exception that is the cause of
        /// this exception.
        /// </summary>
        /// <param name="message">The error message that explains the reason for the exception.</param>
        /// <param name="errorCode">The error identity that could be look up in knowledge base</param>
        /// <param name="level">Specify the severity level</param>
        public TwilightException(string message, string errorCode, SeverityLevelEnum level) 
            : this(message, errorCode, null, level) { }
        /// <summary>
        /// The error identity that could be look up in knowledge base
        /// </summary>
        public string ErrorCode { get; private set; }
        /// <summary>
        /// Indicate the exception severity level, default is WARN
        /// </summary>
        public SeverityLevelEnum SeverityLevel { get; private set; }
    }
}