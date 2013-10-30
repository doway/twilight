using System;
using System.Web.Mvc;
using System.Web.Routing;
using System.Web.Security;
using Twilight.Common.Controllers;
using Twilight.Common.Enum;
using Twilight.Common.Helper;
using Twilight.Models;

namespace Twilight.Controllers
{

    [HandleError]
    public class AccountController : BaseController
    {
        public IFormsAuthenticationService FormsService { get; set; }
        public IMembershipService MembershipService { get; set; }

        protected override void Initialize(RequestContext requestContext)
        {
            if (FormsService == null) { FormsService = new FormsAuthenticationService(); }
            if (MembershipService == null) { MembershipService = new AccountMembershipService(); }

            base.Initialize(requestContext);
        }

        public ActionResult LogOn()
        {
            EntryLogging();
            return View();
        }

        [HttpPost]
        public ActionResult LogOn(LogOnModel model, string returnUrl)
        {
            EntryLogging();
            try
            {
                if (ModelState.IsValid)
                {
                    int? userid = 0;
                    short? buid = 0;
                    int? positionID = 0;
                    int result = MembershipService.ValidateUser(model.UserName, model.Password, ref userid, ref buid, ref positionID);
                    if (result == (int)LoginReturnCode.SUCCESS)
                    {
                        FormsService.SignIn(model.UserName, model.RememberMe);
                        SessionManager.UserCode = model.UserName;
                        SessionManager.UserID = userid.HasValue ? userid.Value : 0;
                        SessionManager.BUID = buid.Value;
                        SessionManager.PositionID = positionID.HasValue ?(Position) Enum.Parse(typeof(Position), positionID.Value.ToString()) : Position.User;
                        
                        if (!String.IsNullOrEmpty(returnUrl))
                        {
                            return Redirect(returnUrl);
                        }
                        else
                        {
                            return RedirectToAction("Index", "Home");
                        }
                    }
                    else
                    {
                        if (result == (int)LoginReturnCode.ACCOUNT_NOT_EXIST)
                            ModelState.AddModelError("UserName", "Account is not exist");
                        else if (result == (int)LoginReturnCode.PASSWORD_NOT_CORRECT)
                            ModelState.AddModelError("Password", "Password is not correct");
                        else if (result == (int)LoginReturnCode.ACCOUNT_DISABLE)
                            ModelState.AddModelError("UserName", "Account disable");
                        else if (result == (int)LoginReturnCode.ACCOUNT_LOCKED)
                            ModelState.AddModelError("UserName", "Account locked");
                        else if (result == (int)LoginReturnCode.ACCOUNT_DELETED)
                            ModelState.AddModelError("UserName", "Account has been deleted");
                        else
                            ModelState.AddModelError("", "The user name or password provided is incorrect.");
                    }
                }
            }
            catch (Exception ex)
            {
                HandleException(ex);
            }
            // If we got this far, something failed, redisplay form
            return View(model);
        }

        // **************************************
        // URL: /Account/LogOff
        // **************************************

        public ActionResult LogOff()
        {
            FormsService.SignOut();
            Session.Abandon();

            return RedirectToAction("Index", "Home");
        }

        // **************************************
        // URL: /Account/Register
        // **************************************

        public ActionResult Register()
        {
            ViewData["PasswordLength"] = MembershipService.MinPasswordLength;
            return View();
        }

        [HttpPost]
        public ActionResult Register(RegisterModel model)
        {
            if (ModelState.IsValid)
            {
                // Attempt to register the user
                MembershipCreateStatus createStatus = MembershipService.CreateUser(model.UserName, model.Password, model.Email);

                if (createStatus == MembershipCreateStatus.Success)
                {
                    FormsService.SignIn(model.UserName, false /* createPersistentCookie */);
                    return RedirectToAction("Index", "Home");
                }
                else
                {
                    ModelState.AddModelError("", AccountValidation.ErrorCodeToString(createStatus));
                }
            }

            // If we got this far, something failed, redisplay form
            ViewData["PasswordLength"] = MembershipService.MinPasswordLength;
            return View(model);
        }

        // **************************************
        // URL: /Account/ChangePassword
        // **************************************

        [Authorize]
        public ActionResult ChangePassword()
        {
            ViewData["PasswordLength"] = MembershipService.MinPasswordLength;
            return View();
        }

        [Authorize]
        [HttpPost]
        public ActionResult ChangePassword(ChangePasswordModel model)
        {
            if (ModelState.IsValid)
            {
                if (MembershipService.ChangePassword(short.Parse(SessionManager.UserID.ToString()), model.OldPassword, model.NewPassword))
                {
                    return RedirectToAction("ChangePasswordSuccess");
                }
                else
                {
                    ModelState.AddModelError("", "The current password is incorrect or the new password is invalid.");
                }
            }

            // If we got this far, something failed, redisplay form
            ViewData["PasswordLength"] = MembershipService.MinPasswordLength;
            return View(model);
        }

        // **************************************
        // URL: /Account/ChangePasswordSuccess
        // **************************************

        public ActionResult ChangePasswordSuccess()
        {
            return View();
        }

        public ActionResult NoPermission()
        {
            return View();
        }
    }
}
