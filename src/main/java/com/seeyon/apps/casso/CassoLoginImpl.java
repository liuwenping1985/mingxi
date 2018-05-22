//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.apps.casso;

import com.seeyon.ctp.common.constants.LoginResult;
import com.seeyon.ctp.login.LoginAuthenticationException;
import com.seeyon.ctp.portal.sso.SSOLoginContext;
import com.seeyon.ctp.portal.sso.SSOLoginHandshakeInterface;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.codec.binary.Base64;

public class CassoLoginImpl implements SSOLoginHandshakeInterface {
    public CassoLoginImpl() {
    }

    public String handshake(String token) {
        String ticket = "";
        System.out.println("0 token=" + token);
        Base64 base64 = new Base64();
        System.out.println();

        try {
            ticket = new String(base64.decode(token), "GB2312");
        } catch (Exception var5) {
            var5.printStackTrace();
        }

        System.out.println("1 ticket=" + ticket);
        return ticket;
    }

    public void logoutNotify(String s) {
        System.out.println("exist");
    }

    public LoginResult dogCheck(String arg0, String arg1, HttpServletRequest arg2) throws LoginAuthenticationException {
        System.out.print("dog");
        return null;
    }

    public  String getToUrl(HttpServletRequest paramHttpServletRequest, SSOLoginContext paramSSOLoginContext, String paramString){

        return paramString;

    }
    public static void main(String[] args) throws Exception {
        Base64 base64 = new Base64();
        String ss = "amlnc2h3Y2g=";
        System.out.println(new String(base64.decode(ss), "GB2312"));
    }
}
