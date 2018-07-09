//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.apps.casso;

import com.seeyon.ctp.common.constants.LoginResult;
import com.seeyon.ctp.login.LoginAuthenticationException;
import com.seeyon.ctp.login.controller.MainController;
import com.seeyon.ctp.portal.sso.SSOLoginContext;
import com.seeyon.ctp.portal.sso.SSOLoginHandshakeInterface;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.codec.binary.Base64;

public class CassoLoginImpl implements SSOLoginHandshakeInterface {
    public CassoLoginImpl() {
    }

    public String handshake(String token) {
        String ticket = "";
        try {
            ticket = token.substring(3);
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
        MainController.class;
        return null;
    }

    public  String getToUrl(HttpServletRequest paramHttpServletRequest, SSOLoginContext paramSSOLoginContext, String paramString){
        System.out.print("paramString");
        return "main.do?method=main";

    }
    public static void main(String[] args) throws Exception {
        Base64 base64 = new Base64();
        String ss = "sso123";
        System.out.println(ss.substring(3));
    }
}
