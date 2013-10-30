using System;
using System.Diagnostics;
using System.Threading;
using System.Web.Mvc;
using System.Web.Security;
using log4net;
using Twilight.Common.Helper;
using Twilight.Dao;
using Twilight.Error;

namespace Twilight.Common.Controllers
{
    /// <summary>
    /// Provide a controller skeleton and necessary facilities.
    /// </summary>
    public abstract class BaseController : Controller
    {
        protected readonly ILog _logger = null;
        /// <summary>
        ///  Initialize the instance and built-in logger within the subclass type.
        /// </summary>
        protected BaseController()
            : base()
        {
            _logger = LogManager.GetLogger(GetType());
        }
        /// <summary>
        /// Provide a logging infra device.
        /// </summary>
        protected ILog Log
        {
            get { return _logger; }
        }
        /// <summary>
        /// Regular exception handle process -
        /// Log the exception message, then wrap it as ApplicationException and re-throw out
        /// </summary>
        /// <param name="ex">Any exception</param>
        /// <exception cref="ApplicationException">Any exception will be wrapped as ApplicationException and re-throw out</exception>
        protected void HandleException(Exception ex)
        {
            throw TwilightErrorHandler.HandleException(
                ex, 
                _logger, 
                null, 
                SessionManager.IPAddress, 
                SessionManager.UserCode);
        }
        /// <summary>
        /// Log SPI invocation in debug level.
        /// </summary>
        /// <returns>SPI name of invocation</returns>
        protected virtual string EntryLogging()
        {
            StackTrace trace = new StackTrace(false);
            string spi_name = null;
            int frameIndex = 1;
            do
            {
                spi_name = trace.GetFrame(frameIndex).GetMethod().Name;
                frameIndex++;
            } while ("EntryLogging" == spi_name);

            _logger.DebugFormat("[{0}]", spi_name);

            return spi_name;
        }
        /// <summary>
        /// check user permission
        /// </summary>
        /// <returns>bool</returns>
        protected virtual bool CheckPermission(int _functionID, int _accessLevel)
        {
            try
            {
                _logger.DebugFormat("[CheckPermission] functionID:{0}, accessLevel:{1}", _functionID, _accessLevel);
                if (Session["UserCode"] == null)
                {
                    Session.Abandon();
                    FormsAuthentication.SignOut();
                    FormsAuthentication.RedirectToLoginPage();
                }

                using (TwilightDataContext db = new TwilightDataContext())
                {
                    int result = db.Account_CheckFunctionPermission(User.Identity.Name, _functionID, _accessLevel);
                    if (result == 1)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
            }
            catch (Exception ex)
            {
                HandleException(ex);
                return false;
            }
        }
    }
}
