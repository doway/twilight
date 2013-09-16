using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Twilight.Common.Constants;
using Twilight.Common.Controllers;
using Twilight.Common.Enum;
using Twilight.Common.Helper;
using Twilight.Common.Paging;
using Twilight.Dao;
using Twilight.Models;

namespace Twilight.Controllers
{
    public class KnowLedgeBaseController : BaseController
    {
        //DAO===========================================================================
        KnowledgeBaseDAO _KMBaseDao = new KnowledgeBaseDAOImpl();
        //
        // GET: /KnowLedgeBase/

        [Authorize]
        public ActionResult Search(string Keyword)
        {
            //check permission
            if (!CheckPermission((int)FunctionID.KNOWLEDGEBASE, (int)AccessLevel.SELECT))
                return RedirectToAction("NoPermission", "Account");

            EntryLogging();

            Log.DebugFormat("[Search] Start search km by keyword {0} ", Keyword);
            if (Keyword == null || Keyword.Trim() == "")
                return View();
            ViewData["Keyword"] = Keyword;
            int? rowcount = 0;
            try
            {
                using (var db = new TwilightDataContext())
                {
                    db.KnowledgeBase_Search(Keyword, 1, 10, ref rowcount).ToList();
                }
            }
            catch (Exception ex)
            {
                Log.Error("[SolutionPageContent] Error ", ex);
            }
            if (rowcount.Value > 0)
            {
                return View();
            }
            // if no records return then redirect to add page
            else
            {
                ViewData["RereictToAdd"] = true;
                return View();
                // return RedirectToAction("Add", "KnowledgeBase");
            }
        }

        [Authorize]
        public ActionResult Browse(int? id)
        {
            //check permission
            if (!CheckPermission((int)FunctionID.KNOWLEDGEBASE, (int)AccessLevel.SELECT))
                return RedirectToAction("NoPermission", "Account");

            EntryLogging();
            Log.DebugFormat("[Browse] id {0} ", id);
            KnowledgeBaseModel _knowledgebase = new KnowledgeBaseModel();
            _knowledgebase = _KMBaseDao.GetKnowledgeBase(id);

            return View(_knowledgebase);
        }

        [Authorize]
        public ActionResult AddComment(FormCollection form)
        {
            //check permission
            if (!CheckPermission((int)FunctionID.KNOWLEDGEBASE, (int)AccessLevel.SELECT))
                return RedirectToAction("NoPermission", "Account");

            EntryLogging();
            string comments = form["txtComent"].ToString();
            Log.DebugFormat("[AddComment] Message {0}", comments);
            int id = int.Parse(form["ID"].ToString());
            try
            {
                using (var db = new TwilightDataContext())
                {
                    db.KnowledgeBase_InsertComment(id, comments, SessionManager.UserID, 1);
                }
            }
            catch (Exception ex)
            {
                HandleException(ex);
            }
            return RedirectToAction("Browse", "KnowledgeBase", new { id = id });
        }

        [Authorize]
        public ActionResult Add(string Keyword)
        {
            //check permission
            if (!CheckPermission((int)FunctionID.KNOWLEDGEBASE, (int)AccessLevel.CREATE))
                return RedirectToAction("NoPermission", "Account");

            EntryLogging();

            KnowledgeBase _knowledgebase = new KnowledgeBase();
            if (Keyword != null && Keyword != "")
            {
                _knowledgebase.Keyword = Keyword;
            }
            return View(_knowledgebase);
        }

        [HttpPost]
        [Authorize]
        [ValidateInput(false)]
        public ActionResult Add(KnowledgeBase knowledgebase)
        {
            //check permission
            if (!CheckPermission((int)FunctionID.KNOWLEDGEBASE, (int)AccessLevel.CREATE))
                return RedirectToAction("NoPermission", "Account");

            EntryLogging();
            if (ModelState.IsValid)
            {
                List<string> _lstkeyword = new List<string>();
                if (knowledgebase.Keyword != null && knowledgebase.Keyword != "")
                    _lstkeyword = knowledgebase.Keyword.Split(',').ToList();
                List<string> _lstlink = new List<string>();
                if (knowledgebase.JIRA != null && knowledgebase.JIRA != "")
                    _lstlink = knowledgebase.JIRA.Split(',').ToList();
                List<string> _lstGuid = new List<string>();
                if (knowledgebase.RowGuids != null && knowledgebase.RowGuids != "")
                    _lstGuid = knowledgebase.RowGuids.Split(',').ToList();
                Log.DebugFormat("[Add] Message:{0},description:{1},solution:{2},Keyword:{3},JIRA:{4}, RowGuids{5}", knowledgebase.Title, knowledgebase.Description, knowledgebase.Solution, knowledgebase.Keyword, knowledgebase.JIRA, knowledgebase.RowGuids);
                int? _knowledgeBaseID = 0;
                try
                {
                    using (var db = new TwilightDataContext())
                    {
                        db.KnowledgeBase_Insert(knowledgebase.Title, knowledgebase.Description, knowledgebase.Solution, SessionManager.UserID, ref _knowledgeBaseID);
                        if (_knowledgeBaseID.HasValue)
                        {
                            //insert keyword to db
                            foreach (string keyword in _lstkeyword)
                            {
                                db.KnowledgeBase_InsertKeywordMapping(_knowledgeBaseID, keyword);
                            }
                            //insert jira number to db
                            foreach (string link in _lstlink)
                            {
                                db.KnowledgeBase_InsertReferenceLink(_knowledgeBaseID, link, 1);
                            }

                            //update fileAttachment
                            foreach (string guid in _lstGuid)
                            {
                                Guid _guid = new Guid(guid);
                                db.KnowledgeBase_UpdateFileAttachment(_knowledgeBaseID, _guid);
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    HandleException(ex);
                }
                if (_knowledgeBaseID != 0)
                    return RedirectToAction("Browse", "KnowledgeBase", new { id = _knowledgeBaseID });

            }
            return View(knowledgebase);
        }

        [Authorize]
        public ActionResult Edit(int? id)
        {
            //check permission
            if (!CheckPermission((int)FunctionID.KNOWLEDGEBASE, (int)AccessLevel.UPDATE))
                return RedirectToAction("NoPermission", "Account");

            EntryLogging();

            if (id.HasValue)
            {
                KnowledgeBaseModel _knowledgebaseModel = new KnowledgeBaseModel();
                _knowledgebaseModel = _KMBaseDao.GetKnowledgeBase(id);

                string _keyword = string.Empty;
                foreach (KeywordMapping keyword in _knowledgebaseModel.Keywords)
                {
                    if (_keyword == string.Empty)
                        _keyword += keyword.Keyword;
                    else
                        _keyword += string.Format(",{0}", keyword.Keyword);
                }
                _knowledgebaseModel.KnowledgeBase.Keyword = _keyword;

                string _jira = string.Empty;
                foreach (ReferenceLink link in _knowledgebaseModel.ReferenceLink)
                {
                    if (_jira == string.Empty)
                        _jira += link.ReferenceValue;
                    else
                        _jira += string.Format(",{0}", link.ReferenceValue);
                }
                ViewData["FileAttachment"] = _knowledgebaseModel.FileAttachements;
                _knowledgebaseModel.KnowledgeBase.JIRA = _jira;
                return View(_knowledgebaseModel.KnowledgeBase);

            }
            else
            {
                return View(new KnowledgeBase());
            }
        }

        [HttpPost]
        [Authorize]
        [ValidateInput(false)]
        public ActionResult Edit(KnowledgeBase knowledgebase)
        {
            //check permission
            if (!CheckPermission((int)FunctionID.KNOWLEDGEBASE, (int)AccessLevel.UPDATE))
                return RedirectToAction("NoPermission", "Account");

            EntryLogging();

            try
            {
                List<string> _lstkeyword = new List<string>();
                if (knowledgebase.Keyword != null && knowledgebase.Keyword != "")
                    _lstkeyword = knowledgebase.Keyword.Split(',').ToList();
                List<string> _lstlink = new List<string>();
                if (knowledgebase.JIRA != null && knowledgebase.JIRA != "")
                    _lstlink = knowledgebase.JIRA.Split(',').ToList();
                List<string> _lstGuid = new List<string>();
                if (knowledgebase.RowGuids != null && knowledgebase.RowGuids != "")
                    _lstGuid = knowledgebase.RowGuids.Split(',').ToList();
                using (var db = new TwilightDataContext())
                {
                    //update knowledgeBase
                    int result = db.KnowledgeBase_Update(knowledgebase.Title, knowledgebase.Description, knowledgebase.Solution, SessionManager.UserID, knowledgebase.KnowledgeBaseID);
                    // delete all keyword related knowledgebase
                    db.KnowledgeBase_DeleteKeywordMapping(knowledgebase.KnowledgeBaseID);
                    // insert keywords to db
                    foreach (string keyword in _lstkeyword)
                    {
                        db.KnowledgeBase_InsertKeywordMapping(knowledgebase.KnowledgeBaseID, keyword);
                    }
                    // delete all link related knowledge
                    db.KnowledgeBase_DeleteReferenceLink(knowledgebase.KnowledgeBaseID);
                    //insert jira number to db
                    foreach (string link in _lstlink)
                    {
                        db.KnowledgeBase_InsertReferenceLink(knowledgebase.KnowledgeBaseID, link, 1);
                    }
                    //update fileAttachment
                    foreach (string guid in _lstGuid)
                    {
                        Guid _guid = new Guid(guid);
                        db.KnowledgeBase_UpdateFileAttachment(knowledgebase.KnowledgeBaseID, _guid);
                    }

                }
            }
            catch (Exception ex)
            {
                HandleException(ex);
            }

            return RedirectToAction("Browse", "KnowledgeBase", new { id = knowledgebase.KnowledgeBaseID });
        }

        [Authorize]
        public ActionResult SolutionPageContent(int? page, FormCollection form)
        {
            //check permission
            if (!CheckPermission((int)FunctionID.KNOWLEDGEBASE, (int)AccessLevel.SELECT))
                return RedirectToAction("NoPermission", "Account");

            EntryLogging();

            Log.Debug("[Query] Start SolutionPageContent");

            if (form.AllKeys.Length == 0)
            {
                return View();
            }
            else
            {
                IList<KnowledgeBase_SearchResult> datagrid = null;
                try
                {
                    String _keyword = form["Keyword"].ToString();
                    int? rowcount = 0;
                    page = (page == null) ? 1 : page;
                    using (var db = new TwilightDataContext())
                    {
                        List<KnowledgeBase_SearchResult> _lstKM = db.KnowledgeBase_Search(_keyword, page, MBConfig.PAGE_SIZE, ref rowcount).ToList();
                        int currentPageIndex = page.HasValue ? page.Value - 1 : 0;
                        ViewData["CurrentPage"] = currentPageIndex;
                        datagrid = _lstKM.ToPagedList(currentPageIndex, MBConfig.PAGE_SIZE, rowcount);
                        Log.DebugFormat("[SolutionPageContent] CurrentPageIndex {0}, page size {1}, rowcount {2}", currentPageIndex, MBConfig.PAGE_SIZE, rowcount);
                    }
                }
                catch (Exception ex)
                {
                    HandleException(ex);
                }
                return View(datagrid);
            }
        }

        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Upload(string qqFileName, HttpPostedFileBase qqFile)
        {
            //check permission
            if (!CheckPermission((int)FunctionID.KNOWLEDGEBASE, (int)AccessLevel.CREATE))
                return RedirectToAction("NoPermission", "Account");

            EntryLogging();

            try
            {
                Stream stream = null;
                string _filename = string.Empty;
                string _filetype = string.Empty;
                Guid? _Guid = Guid.Empty;
                if (Request.Files.Count > 0)
                {
                    stream = Request.Files[0].InputStream;
                    _filename = Request.Files[0].FileName.Substring(Request.Files[0].FileName.LastIndexOf('\\') + 1);
                    _filetype = Request.Files[0].ContentType;
                }
                else
                {
                    stream = Request.InputStream;
                }
                var buffer = new byte[stream.Length];
                // if file size exceed max limit
                if (buffer.Length > MBConfig.FILEUPLOAD_LIMIT)
                {
                    throw new Exception(string.Format("{0} is too large, maximum file size is {1}.", _filename, MBConfig.FILEUPLOAD_LIMIT));
                }

                stream.Read(buffer, 0, buffer.Length);
                using (var db = new TwilightDataContext())
                {
                    db.KnowledgeBase_InsertFileAttachment(_filename, buffer.Length, null, buffer, _filetype, SessionManager.UserID, '1', ref _Guid);
                }
                //System.IO.File.WriteAllBytes(filePath, buffer);
                return Json(new { success = true, guid = _Guid }, "text/html");
            }
            catch (Exception ex)
            {
                HandleException(ex);
                return Json(new { success = false, error = ex.Message }, "text/html");
            }
        }

        [Authorize]
        public ActionResult Download(Guid? RowGuid)
        {
            //check permission
            if (!CheckPermission((int)FunctionID.KNOWLEDGEBASE, (int)AccessLevel.SELECT))
                return RedirectToAction("NoPermission", "Account");

            EntryLogging();

            try
            {
                using (var db = new TwilightDataContext())
                {
                    var lstFile = db.KnowledgeBase_GetFileAttachment(RowGuid).ToList();
                    if (lstFile.Count > 0)
                        return File(lstFile[0].Attachment.ToArray(), lstFile[0].FileType, lstFile[0].FileName);
                }
            }
            catch (Exception ex)
            {
                HandleException(ex);
            }
            return new EmptyResult();
        }

        [Authorize]
        [HttpPost]
        public ActionResult DeleteFile(Guid? RowGuid)
        {
            //check permission
            if (!CheckPermission((int)FunctionID.KNOWLEDGEBASE, (int)AccessLevel.UPDATE))
                return Json(new { success = false, message = "no permission to delete" });

            EntryLogging();
            int result = -1;
            try
            {
                using (var db = new TwilightDataContext())
                {
                    result = db.KnowledgeBase_DeleteFileAttachment(RowGuid);
                }
            }
            catch (Exception ex)
            {
                HandleException(ex);
            }
            if (result != 0)
                return Json(new { success = false });
            else
                return Json(new { success = true });
        }
    }
}
