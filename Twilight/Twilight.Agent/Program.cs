using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;

namespace Twilight.Agent
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        static void Main(string[] args)
        {
            GlobalContext.Properties["appname"] = "TwilightAgent";
            if (args.Length > 0 && (args[0].ToLower() == "-c" || args[0].ToLower() == "/c"))
            {
                var service = new AgentService();
                service.Start(args);
                Console.WriteLine("The service[{0}] has been activated.\r\nPlease press [ENTER] to stop it.", GlobalContext.Properties["appname"]);
                Console.ReadLine();
                service.Stop();
            }
            else
            {
                ServiceBase[] ServicesToRun;
                ServicesToRun = new ServiceBase[] 
            { 
                new AgentService() 
            };
                ServiceBase.Run(ServicesToRun);
            }
        }
    }
}
