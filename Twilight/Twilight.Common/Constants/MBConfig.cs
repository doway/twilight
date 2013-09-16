using System;
using System.Configuration;

namespace Twilight.Common.Constants
{
    public class MBConfig
    {
        public readonly static int MONITOR_LIVE_AUTOREFRESH_INTERVAL    = int.Parse(ConfigurationManager.AppSettings["Monitor_Live_AutoRefresh_Interval"]);
        public readonly static int PAGE_SIZE                            = int.Parse(ConfigurationManager.AppSettings["PageSize"]);
        public readonly static string JIRA_URL                          = ConfigurationManager.AppSettings["JIRA_URL"];
        public readonly static int FILEUPLOAD_LIMIT = int.Parse(ConfigurationManager.AppSettings["MaxFileUploadLimit"]) * 1024;
        public readonly static int MIN_PASSWORD_LENGTH = ConfigurationManager.AppSettings["MinPasswordLength"] == null ? 4 : int.Parse(ConfigurationManager.AppSettings["MinPasswordLength"].ToString());

        public readonly static String FIRST_PAGE = "FIRST PAGE";
        public readonly static String PREVIOUS_PAGE = "PREVIOUS PAGE";
        public readonly static String NEXT_PAGE = "NEXT PAGE";
        public readonly static String LAST_PAGE = "LAST PAGE";

        //ConnectString
        public readonly static String Monitor_ConnectionString = ConfigurationManager.ConnectionStrings["MonitorLogConnectionString"].ConnectionString;

        //SP 
        public readonly static String SP_LOG_LIVEMONITORING = "log_LiveMonitoring";
    }

}
