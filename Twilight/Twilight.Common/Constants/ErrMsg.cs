using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Twilight.Common.Constants
{
    public class ErrMsg
    {
        public readonly static string NOPERMISSION = "you don't have permission to entry this page!!!";
    }

    public enum ERROR_LEVEL
    {
        WARN,
        DEBUG,
        INFO,
        ERROR,
        FATAL
    }
}
