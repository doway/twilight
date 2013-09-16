using System;
using System.Collections.Generic;
using System.Web.Mvc;
using Twilight.Common.Constants;
using Twilight.Common.Controllers;
using Twilight.Common.Enum;
using Twilight.Common.Helper;
using Twilight.Common.Paging;
using Twilight.Models;
//using Twilight.RemoteAgent;
using System.IO;

namespace Twilight.Controllers
{
    public class LogFileController : BaseController
    {
        [Authorize]
        public ActionResult Query()
        {
            //check permission
            if (!CheckPermission((int)FunctionID.DOWNLOAD_LOG, (int)AccessLevel.SELECT))
                return RedirectToAction("NoPermission", "Account");

            return View();
        }
        [Authorize]
        public ActionResult ServerBUMappingpageContent(int? page, FormCollection form)
        {
            EntryLogging();
            if (CheckPermission((int)FunctionID.DOWNLOAD_LOG, (int)AccessLevel.SELECT))
            {
                IPagedList<ServerBUMappingModel> datagrid = null;
                short? buid = null;

                //PositionID 1 is Admin, can query all serverBUMapping 
                if (SessionManager.PositionID != Position.Admin)
                    buid = (short)SessionManager.BUID;

                if (form.AllKeys.Length == 0)
                {
                    try
                    {
                        int? rowcount = 0;
                        var _lst = new ServerBUMappingService().ServerBuMapping_Search(null, buid, 1, MBConfig.PAGE_SIZE, ref rowcount);
                        int currentPageIndex = page.HasValue ? page.Value - 1 : 0;
                        ViewData["CurrentPage"] = currentPageIndex;
                        datagrid = _lst.ToPagedList(currentPageIndex, MBConfig.PAGE_SIZE, rowcount);
                        Log.DebugFormat("[ServerBUMappingpageContent] CurrentPageIndex {0}, page size {1}, rowcount {2}", currentPageIndex, MBConfig.PAGE_SIZE, rowcount);
                    }
                    catch (Exception ex)
                    {
                        HandleException(ex);
                        return new EmptyResult();
                    }

                }
                else
                {
                    string keyword = form["keyword"];
                    int? rowcount = 0;
                    page = (page == null) ? 1 : page;
                    try
                    {
                        var _lst = new ServerBUMappingService().ServerBuMapping_Search(keyword, buid, page.Value, MBConfig.PAGE_SIZE, ref rowcount);
                        int currentPageIndex = page.HasValue ? page.Value - 1 : 0;
                        ViewData["CurrentPage"] = currentPageIndex;
                        datagrid = _lst.ToPagedList(currentPageIndex, MBConfig.PAGE_SIZE, rowcount);
                        Log.DebugFormat("[ServerBUMappingpageContent] keyword:{0}, CurrentPageIndex {1}, page size {2}, rowcount {3}", keyword, currentPageIndex, MBConfig.PAGE_SIZE, rowcount);

                    }
                    catch (Exception ex)
                    {
                        HandleException(ex);
                        return new EmptyResult();
                    }
                }
                return View(datagrid);
            }
            else
            {
                return RedirectToAction("NoPermission", "Account");
            }
        }
        [Authorize]
        public ActionResult LookUp(string serverName)
        {
            //check permission
            if (!CheckPermission((int)FunctionID.DOWNLOAD_LOG, (int)AccessLevel.SELECT))
                return RedirectToAction("NoPermission", "Account");
            const string URL_PATTERN = "http://{0}:8731/Design_Time_Addresses/Twilight.Agent/ServiceController/";
            string address = string.Format(URL_PATTERN, serverName);
            List<FileLocation> file_list = new List<FileLocation>();
            //IServiceController remote = new ServiceControllerClient("WSHttpBinding_IServiceController", address);
            //foreach (var s in remote.GetArchievedLogList())
            //{
            //    file_list.Add(new FileLocation() { FileName = s, ServerName = serverName });
            //}
            //foreach (var s in remote.GetLogList())
            //{
            //    file_list.Add(new FileLocation() { FileName = s, ServerName = serverName });
            //}
            return View(file_list);
        }

        public ActionResult Download(string serverName, string fileName)
        {
            //const string URL_PATTERN = "http://{0}:8731/Design_Time_Addresses/Twilight.Agent/ServiceController/";
            //string address = string.Format(URL_PATTERN, serverName);
            //IServiceController remote = new ServiceControllerClient("WSHttpBinding_IServiceController", address);
            //byte[] content = remote.GetFileContent(fileName);
            //Response.ClearContent();
            //Response.AddHeader("content-disposition", "attachment; filename=" + new FileInfo(fileName).Name);
            //Response.ContentType = "application/octet-stream";
            //Response.BinaryWrite(content);
            //Response.End();
            return View("Query");
        }
    }

    public class FileLocation
    {
        public string FileName { get; set; }
        public string ServerName { get; set; }
    }
}