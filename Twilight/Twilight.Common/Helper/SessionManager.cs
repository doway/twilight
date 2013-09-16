using System.Web;
using System.Web.SessionState;
using Twilight.Common.Enum;

namespace Twilight.Common.Helper
{
    public static class SessionManager
    {
        private static HttpSessionState Session
        {
            get
            {
                return (null == HttpContext.Current) ? null : HttpContext.Current.Session;
            }
        }

        private static bool _isLogin = false;

        public static string UserCode
        {
            get { return (null == Session["UserCode"]) ? null : (string)Session["UserCode"]; }
            set { Session["UserCode"] = value; }
        }
        public static int UserID
        {
            get { return (null == Session["UserID"]) ? 0 : (int)Session["UserID"]; }
            set { Session["UserID"] = value; }
        }

        public static short BUID
        {
            get { return (null == Session["BUID"]) ? (short)0 : (short)Session["BUID"]; }
            set { Session["BUID"] = value; }
        }

        public static Position PositionID
        {
            get { return (null == Session["PositionID"]) ? Position.None : (Position)Session["PositionID"]; }
            set { Session["PositionID"] = value; }
        }

        public static bool isLogin
        {
            get
            {
                return (null == Session["UserID"]) ? false : true;
            }
        }

        /// <summary>
        /// IP information for this session
        /// </summary>
        public static string IPAddress
        {
            get
            {
                var Request = (null == HttpContext.Current) ? null : HttpContext.Current.Request;
                if (null != Request)
                {
                    if (!string.IsNullOrEmpty(Request.ServerVariables["HTTP_X_FORWARDED_FOR"]))
                    {
                        foreach (string ip in Request.ServerVariables["HTTP_X_FORWARDED_FOR"].Split(new char[] { ',' }))
                        {
                            if (!string.IsNullOrEmpty(ip.Trim()))
                            {
                                return ip;
                            }
                        }
                    }
                    if (!string.IsNullOrEmpty(Request.ServerVariables["HTTP_CLIENT_IP"]))
                    {
                        return Request.ServerVariables["HTTP_CLIENT_IP"];
                    }
                    if (!string.IsNullOrEmpty(Request.ServerVariables["HTTP_X_FORWARDED"]))
                    {
                        return Request.ServerVariables["HTTP_X_FORWARDED"];
                    }
                    if (!string.IsNullOrEmpty(Request.ServerVariables["HTTP_X_CLUSTER_CLIENT_IP"]))
                    {
                        return Request.ServerVariables["HTTP_X_CLUSTER_CLIENT_IP"];
                    }
                    if (!string.IsNullOrEmpty(Request.ServerVariables["HTTP_FORWARDED_FOR"]))
                    {
                        return Request.ServerVariables["HTTP_FORWARDED_FOR"];
                    }
                    if (!string.IsNullOrEmpty(Request.ServerVariables["HTTP_FORWARDED"]))
                    {
                        return Request.ServerVariables["HTTP_FORWARDED"];
                    }
                    return Request.UserHostAddress;
                }
                else
                {
                    return null;
                }
            }
        }
    }
}
