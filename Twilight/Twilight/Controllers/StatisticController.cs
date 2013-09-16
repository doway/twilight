using System;
using System.Collections.Generic;
using System.Reflection;
using System.Web.Mvc;
using Twilight.Common.Constants;
using Twilight.Common.Controllers;
using Twilight.Common.Enum;
using Twilight.Models;

namespace Twilight.Controllers
{
    public class StatisticController : BaseController
    {
        private static readonly Dictionary<string, CacheResult> _resultCache = new Dictionary<string, CacheResult>();
        [Authorize]
        public ActionResult StatisticByLevel(string devID, bool useDbTime, byte pastHrs, short buId, string buName)
        {
            EntryLogging();
            StatisticModel model = new StatisticModel() { ID = devID };
            try
            {
                Log.DebugFormat("StatisticByLevel-devID={0} / useDbTime={1} / pastHrs={2} / buId={3} / buName={4} ",
                    devID,
                    useDbTime,
                    pastHrs,
                    buId,
                    buName);
                ViewData["INTERVAL"] = pastHrs;
                ViewData["TIMETYPE"] = (int)((useDbTime) ? 1 : 2);
                ViewData["BUID"] = buId;
                ViewData["BUNAME"] = buName;
                ViewData["MODE"] = StatisticMode.ByLevel;
                ViewData["CHART_OPTION"] = "null";
            }
            catch (Exception ex)
            {
                HandleException(ex);
            }
            return PartialView("StatisticControl", model);
        }
        [Authorize]
        public ActionResult StatisticByBU(string devID, bool useDbTime, byte pastHrs, string level, string chartOption)
        {
            EntryLogging();
            StatisticModel model = new StatisticModel() { ID = devID };
            try
            {
                Log.DebugFormat("StatisticByBU-devID={0} / useDbTime={1} / pastHrs={2} / level={3} / width={4} / height={5}",
                    devID,
                    useDbTime,
                    pastHrs,
                    level);
                ViewData["LEVEL"] = level;
                ViewData["MODE"] = StatisticMode.ByBU;
                ViewData["INTERVAL"] = pastHrs;
                ViewData["TIMETYPE"] = (int)((useDbTime) ? 1 : 2);
                ViewData["CHART_OPTION"] = string.IsNullOrEmpty(chartOption) ? "null" : chartOption;
            }
            catch (Exception ex)
            {
                HandleException(ex);
            }
            return PartialView("StatisticControl", model);
        }
        [Authorize]
        public ActionResult StatisticDataByLevel(bool useDbTime, byte pastHrs, short buId)
        {
            EntryLogging();
            JavaScriptResult result = null;
            try
            {
                string cacheKey = string.Format("{0}\t{1}\t{2}\t{3}", 
                    MethodInfo.GetCurrentMethod().Name, 
                    useDbTime, 
                    pastHrs, 
                    buId);
                if (_resultCache.ContainsKey(cacheKey) && _resultCache[cacheKey].Expired > DateTime.Now)
                {
                    CacheResult cacheData = _resultCache[cacheKey];
                    result = cacheData.Result;
                }
                else
                {
                    result = new JavaScriptResult();
                    StatisticModel model = new StatisticModel();
                    model.Init(useDbTime, pastHrs, buId);
                    result.Script = model.ToJScriptString();
                    lock (_resultCache)
                    {
                        _resultCache[cacheKey] = new CacheResult(
                            DateTime.Now.AddMilliseconds(MBConfig.MONITOR_LIVE_AUTOREFRESH_INTERVAL),
                            result);
                    }
                    Log.DebugFormat("_resultCache.Count={0}", _resultCache.Count);
                }
            }
            catch (Exception ex)
            {
                HandleException(ex);
            }
            return result;
        }
        [Authorize]
        public ActionResult StatisticDataByBU(bool useDbTime, byte pastHrs, string level)
        {
            EntryLogging();
            JavaScriptResult result = null;
            try
            {
                string cacheKey = string.Format("{0}\t{1}\t{2}\t{3}",
                    MethodInfo.GetCurrentMethod().Name,
                    useDbTime,
                    pastHrs,
                    level);
                if (_resultCache.ContainsKey(cacheKey) && _resultCache[cacheKey].Expired > DateTime.Now)
                {
                    CacheResult cacheData = _resultCache[cacheKey];
                    result = cacheData.Result;
                }
                else
                {
                    result = new JavaScriptResult();
                    StatisticModel model = new StatisticModel();
                    model.Init(useDbTime, pastHrs, level);
                    result.Script = model.ToJScriptString();
                    lock (_resultCache)
                    {
                        _resultCache[cacheKey] = new CacheResult(
                            DateTime.Now.AddMilliseconds(MBConfig.MONITOR_LIVE_AUTOREFRESH_INTERVAL),
                            result);
                    }
                    Log.DebugFormat("_resultCache.Count={0}", _resultCache.Count);
                }
            }
            catch (Exception ex)
            {
                HandleException(ex);
            }
            return result;
        }
        [Authorize]
        public ActionResult PieByLevel(string devID, bool useDbTime, byte pastHrs, short buId, string buName)
        {
            EntryLogging();
            PieStatisticModel model = new PieStatisticModel() { ID = devID };
            try
            {
                Log.DebugFormat("PieByLevel-devID={0} / useDbTime={1} / pastHrs={2} / buId={3} / buName={4}",
                    devID,
                    useDbTime,
                    pastHrs,
                    buId,
                    buName);
                ViewData["INTERVAL"] = pastHrs;
                ViewData["TIMETYPE"] = (int)((useDbTime) ? 1 : 2);
                ViewData["BUID"] = buId;
                ViewData["BUNAME"] = buName;
                ViewData["MODE"] = StatisticMode.ByLevel;
                ViewData["CHART_OPTION"] = "null";
            }
            catch (Exception ex)
            {
                HandleException(ex);
            }
            return PartialView("PieChartControl", model);
        }
        [Authorize]
        public ActionResult PieByApp(string devID, bool useDbTime, byte pastHrs, short buId, string buName)
        {
            EntryLogging();
            PieStatisticModel model = new PieStatisticModel() { ID = devID };
            try
            {
                Log.DebugFormat("PieByApp-devID={0} / useDbTime={1} / pastHrs={2} / buId={3} / buName={4}",
                    devID,
                    useDbTime,
                    pastHrs,
                    buId,
                    buName);
                ViewData["INTERVAL"] = pastHrs;
                ViewData["TIMETYPE"] = (int)((useDbTime) ? 1 : 2);
                ViewData["BUID"] = buId;
                ViewData["BUNAME"] = buName;
                ViewData["MODE"] = StatisticMode.ByApp;
                ViewData["CHART_OPTION"] = "null";
            }
            catch (Exception ex)
            {
                HandleException(ex);
            }
            return PartialView("PieChartControl", model);
        }
        [Authorize]
        public ActionResult PieByBU(string devID, bool useDbTime, byte pastHrs, string level, string buName, string chartOption)
        {
            EntryLogging();
            PieStatisticModel model = new PieStatisticModel() { ID = devID };
            try
            {
                Log.DebugFormat("PieByBU-devID={0} / useDbTime={1} / pastHrs={2} / level={3} / buName={4}",
                    devID,
                    useDbTime,
                    pastHrs,
                    level,
                    buName);
                ViewData["LEVEL"] = level;
                ViewData["BUNAME"] = buName;
                ViewData["MODE"] = StatisticMode.ByBU;
                ViewData["INTERVAL"] = pastHrs;
                ViewData["TIMETYPE"] = (int)((useDbTime) ? 1 : 2);
                ViewData["CHART_OPTION"] = string.IsNullOrEmpty(chartOption) ? "null" : chartOption;
            }
            catch (Exception ex)
            {
                HandleException(ex);
            }
            return PartialView("PieChartControl", model);
        }
        [Authorize]
        public ActionResult PieDataByBU(bool useDbTime, byte pastHrs, string level)
        {
            EntryLogging();
            JavaScriptResult result = null;
            try
            {
                string cacheKey = string.Format("{0}\t{1}\t{2}\t{3}",
                    MethodInfo.GetCurrentMethod().Name,
                    useDbTime,
                    pastHrs,
                    level);
                if (_resultCache.ContainsKey(cacheKey) && _resultCache[cacheKey].Expired > DateTime.Now)
                {
                    CacheResult cacheData = _resultCache[cacheKey];
                    result = cacheData.Result;
                }
                else
                {
                    result = new JavaScriptResult();
                    PieStatisticModel model = new PieStatisticModel();
                    model.Init(useDbTime, pastHrs, level);
                    result.Script = model.ToJScriptString();
                    lock (_resultCache)
                    {
                        _resultCache[cacheKey] = new CacheResult(
                            DateTime.Now.AddMilliseconds(MBConfig.MONITOR_LIVE_AUTOREFRESH_INTERVAL),
                            result);
                    }
                }
            }
            catch (Exception ex)
            {
                HandleException(ex);
            }
            return result;
        }
        [Authorize]
        public ActionResult PieDataByLevel(bool useDbTime, byte pastHrs, short buId)
        {
            EntryLogging();
            JavaScriptResult result = null;
            try
            {
                string cacheKey = string.Format("{0}\t{1}\t{2}\t{3}",
                    MethodInfo.GetCurrentMethod().Name,
                    useDbTime,
                    pastHrs,
                    buId);
                if (_resultCache.ContainsKey(cacheKey) && _resultCache[cacheKey].Expired > DateTime.Now)
                {
                    CacheResult cacheData = _resultCache[cacheKey];
                    result = cacheData.Result;
                }
                else
                {
                    result = new JavaScriptResult();
                    PieStatisticModel model = new PieStatisticModel();
                    model.Init(useDbTime, pastHrs, buId);
                    result.Script = model.ToJScriptString();
                    lock (_resultCache)
                    {
                        _resultCache[cacheKey] = new CacheResult(
                            DateTime.Now.AddMilliseconds(MBConfig.MONITOR_LIVE_AUTOREFRESH_INTERVAL),
                            result);
                    }
                    Log.DebugFormat("_resultCache.Count={0}", _resultCache.Count);
                }
            }
            catch (Exception ex)
            {
                HandleException(ex);
            }
            return result;
        }
        [Authorize]
        public ActionResult PieDataByApp(bool useDbTime, byte pastHrs, short buId)
        {
            EntryLogging();
            JavaScriptResult result = null;
            try
            {
                string cacheKey = string.Format("{0}\t{1}\t{2}\t{3}",
                    MethodInfo.GetCurrentMethod().Name,
                    useDbTime,
                    pastHrs,
                    buId);
                if (_resultCache.ContainsKey(cacheKey) && _resultCache[cacheKey].Expired > DateTime.Now)
                {
                    CacheResult cacheData = _resultCache[cacheKey];
                    result = cacheData.Result;
                }
                else
                {
                    result = new JavaScriptResult();
                    PieStatisticModel model = new PieStatisticModel();
                    model.InitApp(useDbTime, pastHrs, buId);
                    result.Script = model.ToJScriptString();
                    lock (_resultCache)
                    {
                        _resultCache[cacheKey] = new CacheResult(
                            DateTime.Now.AddMilliseconds(MBConfig.MONITOR_LIVE_AUTOREFRESH_INTERVAL),
                            result);
                    }
                    Log.DebugFormat("_resultCache.Count={0}", _resultCache.Count);
                }
            }
            catch (Exception ex)
            {
                HandleException(ex);
            }
            return result;
        }
        /// <summary>
        /// Provide a cached result data container
        /// </summary>
        private class CacheResult
        {
            /// <summary>
            /// Cached data container initializer
            /// </summary>
            /// <param name="expired">Indicate the avaliable date time before the cached data expired</param>
            /// <param name="result">The data you want to keep in this cache container</param>
            internal CacheResult(DateTime expired, JavaScriptResult result)
            {
                Expired = expired;
                Result = result;
            }
            internal DateTime Expired { get; private set; }
            internal JavaScriptResult Result { get; private set; }
        }
    }
}