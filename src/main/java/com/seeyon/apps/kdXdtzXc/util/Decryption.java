package com.seeyon.apps.kdXdtzXc.util;


import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import sun.misc.BASE64Encoder;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Created by taoan on 2017-2-17.
 */
public class Decryption {
    private static final Log log = LogFactory.getLog(Decryption.class);

    public static String getMD5(String s) {
        MessageDigest md5 = null;
        try {
            md5 = MessageDigest.getInstance("MD5");
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        BASE64Encoder base64en = new BASE64Encoder();
        //加密后的字符串
        try {
            String newstr = base64en.encode(md5.digest(s.getBytes("utf-8")));
            return newstr;
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static String getUserName(String nameEncode) {
        String name = "";
        try {
            String nameStr = new Base64Encrypt().decode2String(nameEncode);
            System.out.println("加密的字符：" + nameEncode + "解密码的字符：" + nameStr);
            int index = nameStr.indexOf("|");
            if (index > 0) {
                name = nameStr.substring(0, index);
            }


        } catch (Exception e) {
            e.printStackTrace();
        }

        return name;
    }


    public static String getTokenStr(String userName) {
        String test = userName;
//        String test = userName + "|" + ToolkitUtil.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss");
        try {
            String str = new Base64Encrypt().encodeString(test);
            log.info("原始字符串：" + test + "，加密后：" + str);

            return str;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;

    }

    public static void main(String[] args) {
        getTokenStr("陶安平");
        getTokenStr("li.song");
        getTokenStr("2323@3sd.com");
        getTokenStr("abc");
        getTokenStr("QW@#$!12");
    }
}
