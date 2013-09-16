using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using Twilight.Dao;

namespace Twilight.Models
{
    public class ServerBUMappingModel
    {
        [DisplayName("ID")]
        public int ID { get; set; }

        [Required]
        [DisplayName("BUID")]
        public short BUID { get; set; }

        [DisplayName("BUName")]
        public string BUName { get; set; }

        [Required]
        [DisplayName("ServerIP")]
        [StringLength(50, ErrorMessage = "Must be under 50 characters")]
        public string ServerIP { get; set; }

        [Required]
        [DisplayName("ServerName")]
        [StringLength(50, ErrorMessage = "Must be under 50 characters")]
        public string ServerName { get; set; }

        public short Status { get; set; }
    }

    public class ServerBUMappingService
    {
        public List<ServerBUMappingModel> ServerBuMapping_Search(string Keyword, short? buid, int pageNum, int pageSize, ref int? rowCount)
        {
            List<ServerBUMappingModel> lstServerBUMapping = new List<ServerBUMappingModel>();
            using (var db = new TwilightDataContext())
            {
                var lstserverbuMapping = db.ServerBUMapping_Search(Keyword, buid, pageNum, pageSize, ref rowCount);
                foreach (var _serverbu in lstserverbuMapping)
                {
                    lstServerBUMapping.Add(new ServerBUMappingModel()
                    {
                        BUID = _serverbu.BUID,
                        ServerIP = _serverbu.ServerIP,
                        ServerName = _serverbu.ServerName,
                        Status = _serverbu.Status.Value,
                        BUName = _serverbu.BUNAME,
                        ID = _serverbu.ID
                    });
                }
            }

            return lstServerBUMapping;
        }

        public ServerBUMappingModel GetServerMapping(int id)
        {
            ServerBUMappingModel _model = null;
            using (var db = new TwilightDataContext())
            {
                var result = db.GetServerBUMapping(id).ToList();
                if (result.Count() > 0)
                {
                    _model = new ServerBUMappingModel()
                    {
                        ID = result[0].ID,
                        BUID = result[0].BUID,
                        ServerIP = result[0].ServerIP,
                        ServerName = result[0].ServerName,
                        Status = result[0].Status.Value,
                        BUName = result[0].BUName
                    };
                }
            }
            return _model;
        }
    }
}
