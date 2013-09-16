using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Twilight.Common.Enum
{
    public class ErrorCode
    {
        public const string DB_DUPLICATED = "2601";
        public const string DB_TIMEOUT = "-2";
        public const string DB_ERROR = "DB_UNKNOWN";
        public const string UNKNOWN_ERROR = "APP_UNKNOWN";
    }
}
