using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Twilight.Models
{
    interface KnowledgeBaseDAO
    {
        KnowledgeBaseModel GetKnowledgeBase(int? id);
    }
}
