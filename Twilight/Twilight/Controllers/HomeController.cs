using System.Web.Mvc;
using Twilight.Common.Controllers;

namespace Twilight.Controllers
{
    [HandleError]
    public class HomeController : BaseController
    {
        public ActionResult Index()
        {
            EntryLogging();
            ViewData["Message"] = "Welcome to ASP.NET MVC!";

            return View();
        }

        public ActionResult About()
        {
            EntryLogging();
            return View();
        }
    }
}
