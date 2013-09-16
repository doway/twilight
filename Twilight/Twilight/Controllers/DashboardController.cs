using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using Twilight.Common.Controllers;
using Twilight.Common.Enum;
using Twilight.Dao;
using Twilight.Models;

namespace Twilight.Controllers
{
    public class DashboardController : BaseController
    {
        [Authorize]
        public ActionResult Index(FormCollection form)
        {
            //check permission
            if (!CheckPermission((int)FunctionID.DASHBOARD, (int)AccessLevel.SELECT))
                return RedirectToAction("NoPermission", "Account");


            EntryLogging();
            try
            {
                int result = 0;
                using (var db = new TwilightDataContext())
                {
                    result = db.Account_CheckFunctionPermission(User.Identity.Name, (int)FunctionID.DASHBOARD, (int)AccessLevel.SELECT);
                }

                if (1 == result)
                {
                    List<SelectListItem> LevelList = new List<SelectListItem>();
                    LevelList.Add(new SelectListItem { Text = "ALL", Value = "" });
                    LevelList.Add(new SelectListItem { Text = "TRACE", Value = "TRACE" });
                    LevelList.Add(new SelectListItem { Text = "WARN", Value = "WARN" });
                    LevelList.Add(new SelectListItem { Text = "DEBUG", Value = "DEBUG" });
                    LevelList.Add(new SelectListItem { Text = "INFO", Value = "INFO" });
                    LevelList.Add(new SelectListItem { Text = "ERROR", Value = "ERROR" });
                    LevelList.Add(new SelectListItem { Text = "FATAL", Value = "FATAL" });
                    ViewData["LEVEL_List"] = new SelectList(LevelList, "VALUE", "TEXT", "");

                    List<SelectListItem> InvervalList = new List<SelectListItem>();
                    for (int i = 1; i <= 12; i++)
                    {
                        InvervalList.Add(new SelectListItem { Text = string.Format("In past {0} mins", i * 5), Value = i.ToString() });
                    }
                    ViewData["Interval_List"] = new SelectList(InvervalList, "VALUE", "TEXT", (null == form["INTERVAL"]) ? "1" : form["INTERVAL"]);
                    ViewData["INTERVAL"] = (byte)((null == form["INTERVAL"]) ? (byte)1 : byte.Parse(form["INTERVAL"]));

                    List<SelectListItem> TimeList = new List<SelectListItem>();
                    TimeList.Add(new SelectListItem { Text = "Query By DBTime", Value = "1" });
                    TimeList.Add(new SelectListItem { Text = "Query By APTime", Value = "2" });
                    ViewData["Time_List"] = new SelectList(TimeList, "VALUE", "TEXT", (null == form["TIMETYPE"]) ? "1" : form["TIMETYPE"]);
                    ViewData["TIMETYPE"] = (null == form["TIMETYPE"]) ? 1 : int.Parse(form["TIMETYPE"]);
                    List<LogModel> lstLogModel = new List<LogModel>();
                    IList<GetAllBUResult> bu_list = null;
                    using (var db = new TwilightDataContext())
                    {
                        string level = string.Empty;
                        byte interval;
                        int timeType = 1;

                        if (form.AllKeys.Length == 0)
                        {
                            interval = 5;
                        }
                        else
                        {
                            level = form["LEVEL"];
                            interval = (byte)(byte.Parse(form["INTERVAL"]) * 5);
                            timeType = int.Parse(form["TIMETYPE"]);
                        }

                        var list = db.log_LiveMonitoring(DateTime.Now, interval, level, timeType).ToList();
                        bu_list = db.GetAllBU().ToList();

                        foreach (var data in list)
                        {
                            LogModel logmodel = new LogModel();
                            logmodel.COUNT = data.COUNT.Value;
                            logmodel.DBPastTime = data.DBPastTime.Value.ToString("yyyy/MM/dd HH:mm:ss.fff");
                            logmodel.DBTime = data.DBTime.Value.ToString("yyyy/MM/dd HH:mm:ss.fff");
                            logmodel.Level = data.Level.Trim();
                            logmodel.AppName = data.AppName;
                            logmodel.BUName = data.BUName;
                            logmodel.BUID = (data.BUID.HasValue) ? (short)data.BUID : (short)0;
                            lstLogModel.Add(logmodel);
                        }
                    }
                    ViewData["BULIST"] = bu_list;
                    return View(lstLogModel);
                }
                else
                {
                    return RedirectToAction("NoPermission", "Account");
                }
            }
            catch (Exception ex)
            {
                HandleException(ex);
            }
            return View();
        }

        [HttpPost]
        public ActionResult Query(FormCollection form)
        {
            //check permission
            if (!CheckPermission((int)FunctionID.DASHBOARD, (int)AccessLevel.SELECT))
                return RedirectToAction("NoPermission", "Account");

            List<LogModel> lstLogModel = new List<LogModel>();
            EntryLogging();
            try
            {
                string level = form["LEVEL"];
                short interval = (short)(short.Parse(form["INTERVAL"]) * 5);
                ViewData["INTERVAL"] = byte.Parse(form["INTERVAL"]);
                int timeType = int.Parse(form["TIMETYPE"]);
                ViewData["TIMETYPE"] = timeType;
                using (var db = new TwilightDataContext())
                {
                    var list = db.log_LiveMonitoring(DateTime.Now, interval, level, timeType).ToList();

                    foreach (var data in list)
                    {
                        LogModel logmodel = new LogModel();
                        logmodel.COUNT = data.COUNT.Value;
                        logmodel.DBPastTime = data.DBPastTime.Value.ToString("yyyy/MM/dd HH:mm:ss.fff");
                        logmodel.DBTime = data.DBTime.Value.ToString("yyyy/MM/dd HH:mm:ss.fff");
                        logmodel.Level = data.Level.Trim();
                        logmodel.AppName = data.AppName;
                        logmodel.BUID = (data.BUID.HasValue) ? (short)data.BUID : (short)0;
                        logmodel.BUName = data.BUName;
                        lstLogModel.Add(logmodel);
                    }
                }
            }
            catch (Exception ex)
            {
                HandleException(ex);
            }
            return Json(lstLogModel);
        }
    }
}
