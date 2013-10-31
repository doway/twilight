using log4net;
using log4net.Config;
using System;
using System.IO;
using System.Reflection;
using System.ServiceModel.Activities;
using System.ServiceModel.Description;
using System.ServiceProcess;
using System.Xaml;

namespace Twilight.Agent
{
    public partial class AgentService : ServiceBase
    {
        private static readonly ILog _logger = LogManager.GetLogger(typeof(AgentService));
        private WorkflowServiceHost host = null;
        public AgentService()
        {
            InitializeComponent();
        }

        public void Start(string[] args)
        {
            OnStart(args);
        }

        protected override void OnStart(string[] args)
        {
            string log4netCfgPath = Path.GetDirectoryName(Assembly.GetEntryAssembly().Location) + @"\log4net.config";
            XmlConfigurator.ConfigureAndWatch(new FileInfo(log4netCfgPath));

            string serviceXmalPath = Path.GetDirectoryName(Assembly.GetEntryAssembly().Location) + @"\DeployService.xamlx";
            WorkflowServiceHost host = new WorkflowServiceHost(XamlServices.Load(serviceXmalPath), new Uri("http://localhost:2209/Services/DeployService"));
            host.Faulted += host_Faulted;
            host.UnknownMessageReceived += host_UnknownMessageReceived;
            host.AddDefaultEndpoints();
            host.Description.Behaviors.Add(new ServiceMetadataBehavior { HttpGetEnabled = true });
            host.Open();
        }

        void host_UnknownMessageReceived(object sender, System.ServiceModel.UnknownMessageReceivedEventArgs e)
        {
            _logger.Warn(e.Message);
        }

        void host_Faulted(object sender, EventArgs e)
        {
            _logger.Fatal(e);
        }

        protected override void OnStop()
        {
            if (null != host) host.Close();
        }
    }
}
