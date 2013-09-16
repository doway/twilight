using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Twilight.Common.Enum
{
    public enum LoginReturnCode
    {
        SUCCESS                 = 1,
        ACCOUNT_NOT_EXIST       = -1,
        PASSWORD_NOT_CORRECT    = -2,
        ACCOUNT_DISABLE         = -3,
        ACCOUNT_LOCKED          = -4,
        ACCOUNT_DELETED         = -5
    }
}
