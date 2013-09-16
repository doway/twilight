using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using log4net;
using Twilight.Common.Constants;

namespace Twilight.Models
{
    public class KnowledgeBaseDAOImpl : KnowledgeBaseDAO
    {
        //LOGGER
        private static readonly ILog Logger = LogManager.GetLogger(typeof(KnowledgeBaseDAOImpl));

        private static string connstr = MBConfig.Monitor_ConnectionString;

        #region KnowledgeBaseDAO Members

        public KnowledgeBaseModel GetKnowledgeBase(int? id)
        {
            Logger.Info("[CreateToken] Start to Get KMinfo from DB");
            KnowledgeBaseModel _knowledgeBaseModel = new KnowledgeBaseModel();
            try
            {
                using (SqlConnection con = new SqlConnection(connstr))
                {
                    using (SqlCommand cmd = con.CreateCommand())
                    {
                        cmd.CommandText = MBSP.KNOWLEDGEBASE_GETKMINFO;
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.Add("@ID", SqlDbType.VarChar).Value = id;
                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            DataSet ds = new DataSet();
                            sda.Fill(ds);

                            if (ds.Tables.Count >= 5)
                            {
                                if (ds.Tables[0].Rows.Count > 0)
                                {
                                    DataRow _dr = ds.Tables[0].Rows[0];
                                    KnowledgeBase _knowledgebase = new KnowledgeBase();
                                    _knowledgebase.KnowledgeBaseID = int.Parse(_dr["KnowledgeBaseID"].ToString());
                                    _knowledgebase.Title = _dr["Title"].ToString();
                                    _knowledgebase.Solution = _dr["Solution"].ToString();
                                    _knowledgebase.Description = _dr["Description"].ToString();
                                    _knowledgebase.Recommend = int.Parse(_dr["KnowledgeBaseID"].ToString());
                                    _knowledgebase.CreatedBy = _dr["UserName"].ToString();
                                    _knowledgebase.DateCreated = DateTime.Parse(_dr["DateCreated"].ToString());
                                    _knowledgebase.UpdatedBy = _dr["UpdatedBy"].ToString();
                                    _knowledgebase.DateUpdated = _dr["DateUpdated"].ToString() == "" ? DateTime.MinValue : DateTime.Parse(_dr["DateUpdated"].ToString());
                                    _knowledgeBaseModel.KnowledgeBase = _knowledgebase;

                                    List<Comment> _lstComment = new List<Comment>();
                                    foreach (DataRow datarow in ds.Tables[1].Rows)
                                    {
                                        Comment _comment = new Comment();
                                        _comment.KnowledgeBaseID = int.Parse(datarow["KnowledgeBaseID"].ToString());
                                        _comment.Message = datarow["Message"].ToString();
                                        _comment.Status = int.Parse(datarow["Status"].ToString());
                                        _comment.CommentID = int.Parse(datarow["CommentID"].ToString());
                                        _comment.CreatedBy = datarow["UserName"].ToString();
                                        _comment.DateCreated = DateTime.Parse(datarow["DateCreated"].ToString());
                                        _lstComment.Add(_comment);
                                    }
                                    _knowledgeBaseModel.Comments = _lstComment;

                                    List<FileAttachment> _lstFileAttachment = new List<FileAttachment>();
                                    foreach (DataRow datarow in ds.Tables[2].Rows)
                                    {
                                        FileAttachment _file = new FileAttachment();
                                        _file.KnowledgeBaseID = int.Parse(datarow["KnowledgeBaseID"].ToString());
                                        _file.FileSize = int.Parse(datarow["FileSize"].ToString());
                                        _file.FileID = int.Parse(datarow["FileID"].ToString());
                                        _file.FileName = datarow["FileName"].ToString();
                                        _file.FileType = datarow["FileType"].ToString();
                                        _file.RowGuid = new Guid(datarow["RowGuid"].ToString());
                                        _file.CreatedBy = datarow["UserName"].ToString();
                                        _file.DateCreated = DateTime.Parse(datarow["DateCreated"].ToString());
                                        _file.Status = char.Parse(datarow["Status"].ToString());
                                        _lstFileAttachment.Add(_file);
                                    }
                                    _knowledgeBaseModel.FileAttachements = _lstFileAttachment;

                                    List<KeywordMapping> _lstKeywordMapping = new List<KeywordMapping>();
                                    foreach (DataRow datarow in ds.Tables[3].Rows)
                                    {
                                        KeywordMapping _keyword = new KeywordMapping();
                                        _keyword.KeywordMappingID = int.Parse(datarow["KeywordMappingID"].ToString());
                                        _keyword.KnowledgeBaseID = int.Parse(datarow["KnowledgeBaseID"].ToString());
                                        _keyword.Keyword = datarow["Keyword"].ToString();
                                        _lstKeywordMapping.Add(_keyword);
                                    }
                                    _knowledgeBaseModel.Keywords = _lstKeywordMapping;

                                    List<ReferenceLink> _lstReferenceLink = new List<ReferenceLink>();
                                    foreach (DataRow datarow in ds.Tables[4].Rows)
                                    {
                                        ReferenceLink _link = new ReferenceLink();
                                        _link.KnowledgeBaseID = int.Parse(datarow["KnowledgeBaseID"].ToString());
                                        _link.ReferenceLinkId = int.Parse(datarow["ReferenceLinkId"].ToString());
                                        _link.ReferenceType = int.Parse(datarow["ReferenceType"].ToString());
                                        _link.ReferenceValue = datarow["ReferenceValue"].ToString();
                                        _lstReferenceLink.Add(_link);
                                    }
                                    _knowledgeBaseModel.ReferenceLink = _lstReferenceLink;
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Error("[GetKnowledgeBase] Error.", ex);
            }
            return _knowledgeBaseModel;
        }

        #endregion
    }
}
