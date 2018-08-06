//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.ctp.login.auth;

import com.seeyon.apps.datakit.service.RikazeService;
import com.seeyon.apps.datakit.util.DataKitSupporter;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.login.AbstractLoginAuthentication;
import com.seeyon.ctp.login.LoginAuthenticationException;
import com.seeyon.ctp.organization.principal.PrincipalManager;
import org.apache.log4j.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DefaultLoginAuthentication extends AbstractLoginAuthentication {
    private static final Logger LOGGER = Logger.getLogger(DefaultLoginAuthentication.class);
    private PrincipalManager principalManager = null;

    public DefaultLoginAuthentication() {
        if (this.principalManager == null) {
            this.principalManager = (PrincipalManager)AppContext.getBean("principalManager");
        }

    }

    public String[] authenticate(HttpServletRequest request, HttpServletResponse response) throws LoginAuthenticationException {
        String username = request.getParameter("login_username");
        String password = request.getParameter("login_password");
        if (username != null && password != null) {
            if (AppContext.isRunningModeDevelop()) {
                return new String[]{username, password};
            } else {
                try {
                    if (this.principalManager.authenticate(username, password)) {
                        Long userId =  this.principalManager.getMemberIdByLoginName(username);
                        RikazeService.loginRecord(userId,username);
                        return new String[]{username, "~`@%^*#?"};
                    }
                } catch (Exception var6) {
                    LOGGER.error("", var6);
                }

                return null;
            }
        } else {
            return null;
        }
    }
}
