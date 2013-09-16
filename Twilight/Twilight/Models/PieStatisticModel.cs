using System;
using System.Collections.Generic;
using System.Text;
using log4net;
using Twilight.Common.Enum;
using Twilight.Dao;

namespace Twilight.Models
{
    public sealed class PieStatisticModel
    {
        private static readonly ILog _logger = LogManager.GetLogger(typeof(PieStatisticModel));
        public StatisticMode Mode { get; set; }
        internal PieStatisticModel()
        {
            Trends = new List<PieTrend>();
        }
        public void Init(bool useDbTime, byte pastHrs, string level)
        {
            Mode = StatisticMode.ByBU;
            using (var db = new TwilightDataContext())
            {
                DateTime? baseDT = null;

                #region retrieve data by LEVEL
                using (var q = db.state_LogPieTrendByBU(useDbTime, pastHrs, level, ref baseDT))
                {
                    BaseDateTime = baseDT;
                    foreach (var d in q)
                    {
                        Trends.Add(new PieTrend()
                        {
                            CategoryName = d.BU,
                            Data = d.COUNT.Value
                        });
                    }
                }
                #endregion
            }
        }
        public void Init(bool useDbTime, byte pastHrs, short buId)
        {
            Mode = StatisticMode.ByLevel;
            using (var db = new TwilightDataContext())
            {
                DateTime? baseDT = null;

                #region retrieve data by LEVEL
                using (var q = db.state_LogPieTrendByLevel(useDbTime, pastHrs, buId, ref baseDT))
                {
                    BaseDateTime = baseDT;
                    foreach (var d in q)
                    {
                        Trends.Add(new PieTrend()
                        {
                            CategoryName = d.Level,
                            Data = d.COUNT.Value
                        });
                    }
                }
                #endregion
            }
        }
        public void InitApp(bool useDbTime, byte pastHrs, short buId)
        {
            Mode = StatisticMode.ByApp;
            using (var db = new TwilightDataContext())
            {
                DateTime? baseDT = null;

                #region retrieve data by LEVEL
                using (var q = db.state_LogPieTrendByApp(useDbTime, pastHrs, buId, ref baseDT))
                {
                    BaseDateTime = baseDT;
                    foreach (var d in q)
                    {
                        Trends.Add(new PieTrend()
                        {
                            CategoryName = d.AppName,
                            Data = d.COUNT.Value
                        });
                    }
                }
                #endregion
            }
        }

        public string ToJScriptString()
        {
            StringBuilder sb = new StringBuilder("datasets = [");
            bool first_trend = true;
            foreach (var trend in Trends)
            {
                if (first_trend)
                {
                    sb.AppendFormat("{{ label:\"{0}\",data:{1}}}", trend.CategoryName.ToUpper(), trend.Data);
                    first_trend = false;
                }
                else
                {
                    sb.AppendFormat(",{{ label:\"{0}\",data:{1}}}", trend.CategoryName.ToUpper(), trend.Data);
                }
            }
            sb.Append("];");
            string result = sb.ToString();
            _logger.DebugFormat("result jscript={0}", result);
            return result;
        }
        public DateTime? BaseDateTime { get; private set; }
        public string ID { get; internal set; }
        private IList<PieTrend> Trends { get; set; }

        private class PieTrend
        {
            public string CategoryName { get; internal set; }
            public int Data { get; internal set; }
        }
    }
}
