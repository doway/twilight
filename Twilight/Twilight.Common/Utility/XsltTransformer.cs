using System.IO;
using System.Xml;
using System.Xml.Xsl;

namespace Twilight.Common.Utility
{
    public sealed class XsltTransformer
    {
        private XsltTransformer() { }
        public static string GetTransformedContent(FileInfo xsltFile, string xml)
        {
            string xslt = null;
            using (var sr = xsltFile.OpenText()) { xslt = sr.ReadToEnd(); }
            return GetTransformedContent(xslt, xml);
        }
        public static string GetTransformedContent(string xslt, string xml)
        {
            string result = null;
            using (var str = new StringReader(xslt))
            {
                using (XmlTextReader xsltReader = new XmlTextReader(str))
                {
                    XmlDocument doc = new XmlDocument();
                    doc.LoadXml(xml);
                    XslTransform trans = new XslTransform();
                    trans.Load(xsltReader);
                    using (StreamWriter sw = new StreamWriter(new MemoryStream(1024)))
                    {
                        trans.Transform(doc.CreateNavigator(), null, sw);
                        sw.Flush();
                        sw.BaseStream.Position = 0;
                        using (StreamReader sr = new StreamReader(sw.BaseStream))
                        {
                            result = sr.ReadToEnd();
                        }
                    }
                }
            }
            return result;
        }
    }
}
