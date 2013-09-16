using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Twilight.Models
{
    public class KnowledgeBaseModel
    {
        public KnowledgeBase KnowledgeBase { get; set; }

        public List<Comment> Comments { get; set; }

        public List<FileAttachment> FileAttachements { get; set; }

        public List<ReferenceLink> ReferenceLink { get; set; }

        public List<KeywordMapping> Keywords { get; set; }

    }

    public class KnowledgeBase
    {
        public int KnowledgeBaseID { get; set; }

        [Required(ErrorMessage= "Title Required")]
        [StringLength(100, ErrorMessage="Must be under 50 characters")]
        public string Title { get; set; }

        [Required(ErrorMessage = "Descrption Required")]
        [StringLength(1000, ErrorMessage = "Must be under 1000 characters")]
        public string Description { get; set; }


        public string Solution { get; set; }

        public string CreatedBy { get; set; }

        public DateTime DateCreated { get; set; }

        public string UpdatedBy { get; set; }

        public DateTime? DateUpdated { get; set; }

        public int Recommend { get; set; }

        public string JIRA { get; set; }

        public string Keyword { get; set; }

        public string RowGuids { get; set; }
    }

    public class Comment
    {
        public int CommentID{ get; set; }

        public int KnowledgeBaseID { get; set; }

        public string Message { get; set; }

        public string CreatedBy { get; set; }

        public DateTime DateCreated { get; set; }

        public int Status { get; set; }
    }

    public class KeywordMapping
    {
        public int KeywordMappingID { get; set; }

        public int KnowledgeBaseID { get; set; }

        public string Keyword { get; set; }
    }

    public class FileAttachment
    {
        public Guid RowGuid { get; set; }

        public int FileID { get; set; }

        public string FileName { get; set; }

        public int FileSize { get; set; }

        public int KnowledgeBaseID { get; set; }

        public byte[] Attachment { get; set; }

        public string FileType { get; set; }

        public string CreatedBy { get; set; }

        public DateTime DateCreated { get; set; }

        public char Status { get; set; }
    }

    public class ReferenceLink
    {
        public int ReferenceLinkId { get; set; }

        public int ReferenceType { get; set; }

        public string ReferenceValue { get; set; }

        public int KnowledgeBaseID { get; set; }
    }
}
