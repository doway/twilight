using System;
using System.Collections.Generic;
using System.Text;
using log4net;
using Twilight.Common.Enum;
using Twilight.Dao;

namespace Twilight.Models
{
    public sealed class StatisticModel
    {
        private static readonly ILog _logger = LogManager.GetLogger(typeof(StatisticModel));
        public StatisticMode Mode { get; set; }
        internal StatisticModel()
        {
            Trends = new List<StatisticTrend>();
        }
        public void Init(bool useDbTime, byte pastHrs, string level)
        {
            Mode = StatisticMode.ByBU;
            using (var db = new TwilightDataContext())
            {
                DateTime? baseDT = null;

                #region retrieve data by LEVEL
                using (var q = db.state_LogTrendByBU(useDbTime, pastHrs, level, ref baseDT))
                {
                    BaseDateTime = baseDT;
                    int initIdx = 0;
                    StatisticTrend current_trend = new StatisticTrend();
                    Trends.Add(current_trend);
                    foreach (var d in q)
                    {
                        if (0 == initIdx) initIdx = d.OffsetMins.Value;
                        if (string.IsNullOrEmpty(current_trend.CategoryName)) current_trend.CategoryName = d.BU;
                        if (d.BU == current_trend.CategoryName)
                        {
                            if (d.OffsetMins == initIdx)
                            {
                                current_trend.Data.Add(new TrendData() { OffsetMins = d.OffsetMins.Value, Count = d.COUNT.Value });
                            }
                            else
                            {
                                for (int i = initIdx; i < d.OffsetMins; i++)
                                {
                                    current_trend.Data.Add(new TrendData() { OffsetMins = i, Count = 0 });
                                }
                                current_trend.Data.Add(new TrendData() { OffsetMins = d.OffsetMins.Value, Count = d.COUNT.Value });
                                initIdx = d.OffsetMins.Value;
                            }
                            initIdx++;
                        }
                        else
                        {
                            initIdx = d.OffsetMins.Value;
                            // Create a new trend list for different level
                            current_trend = new StatisticTrend();
                            current_trend.CategoryName = d.BU;
                            Trends.Add(current_trend);
                            current_trend.Data.Add(new TrendData() { OffsetMins = d.OffsetMins.Value, Count = d.COUNT.Value });
                            initIdx++;
                        }
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
                using (var q = db.state_LogTrendByLevel(useDbTime, pastHrs, buId, ref baseDT))
                {
                    BaseDateTime = baseDT;
                    int initIdx = 0;
                    StatisticTrend current_trend = new StatisticTrend();
                    Trends.Add(current_trend);
                    foreach (var d in q)
                    {
                        if (0 == initIdx) initIdx = d.OffsetMins.Value;
                        if (string.IsNullOrEmpty(current_trend.CategoryName)) current_trend.CategoryName = d.Level.Trim();
                        if (d.Level.Trim() == current_trend.CategoryName)
                        {
                            if (d.OffsetMins == initIdx)
                            {
                                current_trend.Data.Add(new TrendData() { OffsetMins = d.OffsetMins.Value, Count = d.COUNT.Value });
                            }
                            else
                            {
                                for (int i = initIdx; i < d.OffsetMins; i++)
                                {
                                    current_trend.Data.Add(new TrendData() { OffsetMins = i, Count = 0 });
                                }
                                current_trend.Data.Add(new TrendData() { OffsetMins = d.OffsetMins.Value, Count = d.COUNT.Value });
                                initIdx = d.OffsetMins.Value;
                            }
                            initIdx++;
                        }
                        else
                        {
                            initIdx = d.OffsetMins.Value;
                            // Create a new trend list for different level
                            current_trend = new StatisticTrend();
                            current_trend.CategoryName = d.Level.Trim();
                            Trends.Add(current_trend);
                            current_trend.Data.Add(new TrendData() { OffsetMins = d.OffsetMins.Value, Count = d.COUNT.Value });
                            initIdx++;
                        }
                    }
                }
                #endregion
            }
        }

        public string ToJScriptString()
        {
            StringBuilder sb = new StringBuilder("datasets = {");
            bool first_trend = true;
            foreach (var trend in Trends)
            {
                string group_name = (string.IsNullOrEmpty(trend.CategoryName)) ? string.Empty : trend.CategoryName.Trim();
                if (first_trend)
                {
                    sb.AppendFormat("\"{0}\": {{ label:\"{1}\",data:[", group_name.ToLower(), group_name);
                    first_trend = false;
                }
                else
                {
                    sb.AppendFormat(",\"{0}\": {{ label:\"{1}\",data:[", group_name.ToLower(), group_name);
                }
                bool first_one = true;
                foreach (var d in trend.Data)
                {
                    if (first_one)
                    {
                        sb.AppendFormat("[{0}, {1}]", d.OffsetMins, d.Count);
                        first_one = false;
                    }
                    else
                    {
                        sb.AppendFormat(",[{0}, {1}]", d.OffsetMins, d.Count);
                    }
                }
                sb.Append("]}");
            }
            sb.Append("};");
            string result = sb.ToString();
            _logger.DebugFormat("result jscript={0}", result);
            return result;
        }
        public DateTime? BaseDateTime { get; private set; }
        public string ID { get; internal set; }
        private IList<StatisticTrend> Trends { get; set; }

        private class StatisticTrend
        {
            internal StatisticTrend()
            {
                Data = new List<TrendData>();
            }
            public string CategoryName { get; internal set; }
            public IList<TrendData> Data { get; private set; }
        }

        private class TrendData
        {
            public int OffsetMins { get; set; }
            public int Count { get; set; }
        }
    }
}
