using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace Twilight.Common.Utility
{
    public class MathUtil
    {
        //generate random number
        public static string GenRandomNumber(int length)
        {
            RNGCryptoServiceProvider _objCrypto = new RNGCryptoServiceProvider();
            string _strCharSet      = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            int _intMaxSize         = length;

            //Getting random non zero bytes from RNGCrypto
            byte[] _aryByte = new byte[_intMaxSize];
            _objCrypto.GetNonZeroBytes(_aryByte);

            //Generating unqiue key
            StringBuilder _objBuilder = new StringBuilder();
            foreach (byte b in _aryByte)
            { _objBuilder.Append(_strCharSet[b % 61]); }
            return _objBuilder.ToString();
        }
    }
}
