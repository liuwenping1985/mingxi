package com.seeyon.apps.kdXdtzXc.sso;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Created by taoan on 2017-2-17.
 */
public class SsoPwdDecryption {
    private static final Log log = LogFactory.getLog(SsoPwdDecryption.class);

    public static String getUserName(String nameEncode) {
        String name = "";
        try {
            return nameEncode.replace("_!", "");

        } catch (Exception e) {
            e.printStackTrace();
        }
        return name;
    }

    public static String getTokenStr(String userName) {
        String str = "";
        try {
           char[] c1= userName.toCharArray();
           StringBuffer sb=new StringBuffer();
           for(char c:c1){
               sb.append(c).append("_!");
           }
           return sb.toString();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return str;
    }

    public static void main(String[] args) throws Exception {
      String s=  SsoPwdDecryption.getTokenStr("taoan加密失败");
        System.out.println(s);
      String ss=  SsoPwdDecryption.getUserName(s);
        System.out.println(ss);

    }
}
