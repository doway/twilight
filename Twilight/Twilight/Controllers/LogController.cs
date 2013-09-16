using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web.Mvc;
using System.Web.UI;
using System.Web.UI.WebControls;
using Twilight.Common.Constants;
using Twilight.Common.Controllers;
using Twilight.Common.Enum;
using Twilight.Common.Paging;
using Twilight.Dao;

namespace Twilight.Controllers
{
    public class LogController : BaseController
    {
        [Authorize]
        public ActionResult Query(string DBStartDT, string DBEndDT, string Level, string AppName, short? BUID)
        {
            EntryLogging();

            if (CheckPermission((int)FunctionID.LOGENQUIRY, (int)AccessLevel.SELECT))
            {
                List<SelectListItem> LevelList = new List<SelectListItem>();
                LevelList.Add(new SelectListItem { Text = "ALL", Value = "" });
                LevelList.Add(new SelectListItem { Text = "TRACE", Value = "TRACE" });
                LevelList.Add(new SelectListItem { Text = "WARN", Value = "WARN" });
                LevelList.Add(new SelectListItem { Text = "DEBUG", Value = "DEBUG" });
                LevelList.Add(new SelectListItem { Text = "INFO", Value = "INFO" });
                LevelList.Add(new SelectListItem { Text = "ERROR", Value = "ERROR" });
                LevelList.Add(new SelectListItem { Text = "FATAL", Value = "FATAL" });
                ViewData["LEVEL_List"] = new SelectList(LevelList, "VALUE", "TEXT", Level == null ? "WARN" : Level);

                List<SelectListItem> BuList = new List<SelectListItem>();
                BuList.Add(new SelectListItem { Text = "ALL", Value = "0" });
                using (var db = new TwilightDataContext())
                {
                    var _lstBU = db.GetAllBU().ToList();
                    foreach (GetAllBUResult _bu in _lstBU)
                    {
                        BuList.Add(new SelectListItem { Text = _bu.BUName, Value = _bu.BUID.ToString() });
                    }
                }
                ViewData["BU_List"] = new SelectList(BuList, "VALUE", "TEXT", BUID);

                //int? rowcount = 0;
                DateTime _dbStartDT = (DBStartDT == string.Empty | DBStartDT == null) ? DateTime.Now.AddHours(-1) : DateTime.Parse(DBStartDT);
                DateTime _dbEndDT = (DBEndDT == string.Empty | DBEndDT == null) ? DateTime.Now : DateTime.Parse(DBEndDT);
                ViewData["StartDateTime"] = _dbStartDT.ToString("MM/dd/yyyy HH:mm:ss.fff");
                ViewData["EndDateTime"] = _dbEndDT.ToString("MM/dd/yyyy HH:mm:ss.fff");
                ViewData["AppName"] = AppName;
            }
            else
            {
                return RedirectToAction("NoPermission", "Account");
            }

            return View();
        }

        [Authorize]
        public ActionResult LogPageContent(int? page, FormCollection form)
        {
            EntryLogging();

            if (CheckPermission((int)FunctionID.LOGENQUIRY, (int)AccessLevel.SELECT))
            {
                if (form.AllKeys.Length == 0)
                {
                    return View();
                }
                else
                {
                    IList<log_QueryLogResult> datagrid = null;
                    try
                    {
                        DateTime startDateTime = DateTime.Parse(form["StartDateTime"]);
                        DateTime endDateTime = DateTime.Parse(form["EndDateTime"]);
                        string level = form["LEVEL"];
                        string logger = form["Logger"];
                        short bU = short.Parse(form["BUID"]);
                        string errorCode = form["ErrorCode"];
                        string message = form["Message"];
                        string app_name = form["AppName"];
                        string exkey1 = form["ExKey1"];
                        string exkey2 = form["ExKey2"];
                        string exkey3 = form["ExKey3"];
                        string exkey4 = form["ExKey4"];
                        string exkey5 = form["ExKey5"];
                        string exkey6 = form["ExKey6"];
                        string exkey7 = form["ExKey7"];
                        string exkey8 = form["ExKey8"];
                        string exkey9 = form["ExKey9"];
                        string exkey10 = form["ExKey10"];

                        _logger.DebugFormat("startDateTime={0} / endDateTime={1} \r\nlevel={2} / logger={3}\r\nbU={4} / errorCode={5}\r\nmessage={6} / app_name={7}\r\nexkey1={8} / exkey2={9}\r\nexkey3={10} / exkey4={11}\r\nexkey5={12} / exkey6={13}\r\nexkey7={14} / exkey8={15}\r\nexkey9={16} / exkey10={17}",
                            startDateTime, endDateTime, 
                            level, logger, 
                            bU, errorCode, 
                            message, app_name, 
                            exkey1, exkey2,
                            exkey3, exkey4,
                            exkey5, exkey6,
                            exkey7, exkey8,
                            exkey9, exkey10);

                        int? rowcount = 0;
                        page = (page == null) ? 1 : page;
                        using (var db = new TwilightDataContext())
                        {
                            var result = db.log_QueryLog(
                                null, 
                                startDateTime, 
                                endDateTime, null, 
                                level, 
                                logger,
                                bU,
                                app_name,
                                exkey1,
                                exkey2,
                                exkey3,
                                exkey4,
                                exkey5,
                                exkey6,
                                exkey7,
                                exkey8,
                                exkey9,
                                exkey10, 
                                errorCode, 
                                message, 
                                page, 
                                MBConfig.PAGE_SIZE, 
                                ref rowcount).ToList();

                            int currentPageIndex = page.HasValue ? page.Value - 1 : 0;
                            ViewData["CurrentPage"] = currentPageIndex;
                            datagrid = result.ToPagedList(currentPageIndex, MBConfig.PAGE_SIZE, rowcount);
                            Log.DebugFormat("[LogPageContent] CurrentPageIndex {0}, page size {1}, rowcount {2}", currentPageIndex, MBConfig.PAGE_SIZE, rowcount);
                        }
                    }
                    catch (Exception ex)
                    {
                        HandleException(ex);
                        return new EmptyResult();
                    }
                    return View(datagrid);
                }
            }
            else
            {
                return new EmptyResult();
            }
        }

        [Authorize]
        public ActionResult FileExport(FormCollection form)
        {
            EntryLogging();
            if (CheckPermission((int)FunctionID.LOGENQUIRY, (int)AccessLevel.SELECT))
            {
                try
                {
                    DateTime _startDateTime = DateTime.Parse(form["StartDateTime"].ToString());
                    DateTime _endDateTime = DateTime.Parse(form["EndDateTime"].ToString());
                    String _level = form["LEVEL"].ToString();
                    String _logger = form["Logger"].ToString();
                    short _bU = short.Parse(form["BU"].ToString());
                    String _errorCode = form["ErrorCode"].ToString();
                    String _message = form["Message"].ToString();
                    int? rowcount = 0;
                    //Create gridview object - Make sure you have added reference to Syster.Web.UI.ServerControls
                    GridView gv = new GridView();
                    //Call Method to apply style to gridview - This is optional part and can be avoided 
                    StyleGrid(ref gv);
                    IList<log_QueryLogResult> list = null;
                    using (var db = new TwilightDataContext())
                    {
                        list = db.log_QueryLog(
                            null, 
                            _startDateTime, 
                            _endDateTime, 
                            null, 
                            _level, 
                            _logger, 
                            _bU,
                            null,
                            null, 
                            null, 
                            null, 
                            null, 
                            null, 
                            null, 
                            null, 
                            null, 
                            null, 
                            null, 
                            _errorCode, 
                            _message, 
                            1, 
                            0, 
                            ref rowcount).ToList();
                    }
                    gv.DataSource = list;
                    gv.DataBind();
                    //We have gridview object ready in memory. Follow normal "export gridview to excel" code
                    Response.ClearContent();
                    Response.AddHeader("content-disposition", "attachment; filename=log.xls");
                    Response.ContentType = "application/excel";
                    //Ccreate string writer object and pass it to HtmlTextWriter object
                    StringWriter sw = new StringWriter();
                    HtmlTextWriter htw = new HtmlTextWriter(sw);
                    //Call gridiview objects RenderControl method to output gridview content to HtmlTextWriter
                    gv.RenderControl(htw);
                    //Pass rendered string to Response object which would be presented to user for download
                    Response.Write(sw.ToString());
                    Response.End();
                    Log.DebugFormat("[FileExport] export to log.xls row count:{0}", list.Count);
                }
                catch (Exception ex)
                {
                    HandleException(ex);
                }
                return View("Query");
            }
            else
            {
                return RedirectToAction("NoPermission", "Account");
            }
        }

        [Authorize]
        public ActionResult GetLogDetail(int? id)
        {
            EntryLogging();

            if (CheckPermission((int)FunctionID.LOGENQUIRY, (int)AccessLevel.SELECT))
            {
                IList<log_QueryLogByIdResult> log = null;
                Log.DebugFormat("[GetLogDetail] id:{0}", id.Value);
                try
                {
                    using (var db = new TwilightDataContext())
                    {
                        log = db.log_QueryLogById(id).ToList();
                    }
                }
                catch (Exception ex)
                {
                    HandleException(ex);
                }

                return Json(log);
            }
            else
            {
                return new EmptyResult();
            }
        }

        [Authorize]
        public ActionResult LogDetail(int? id)
        {
            EntryLogging();

            if (CheckPermission((int)FunctionID.LOGENQUIRY, (int)AccessLevel.SELECT))
            {
                log_QueryLogByIdResult log = null;
                Log.DebugFormat("[LogDetail] id:{0}", id.Value);
                try
                {
                    using (var db = new TwilightDataContext())
                    {
                        var lstlog = db.log_QueryLogById(id).ToList();
                        if (lstlog.Count > 0)
                            log = lstlog[0];
                        else
                            return new EmptyResult();
                    }
                }
                catch (Exception ex)
                {
                    HandleException(ex);
                }

                return View(log);
            }
            else
            {
                return new EmptyResult();
            }
        }

        private void StyleGrid(ref GridView gv)
        {
            gv.HeaderStyle.BackColor = System.Drawing.Color.FromName("#507CD1");
            gv.HeaderStyle.Font.Bold = true;
            gv.HeaderStyle.ForeColor = System.Drawing.Color.White;
            gv.RowStyle.BackColor = System.Drawing.Color.FromName("EFF3FB");
            gv.AlternatingRowStyle.BackColor = System.Drawing.Color.Silver;
        }
    }
}
