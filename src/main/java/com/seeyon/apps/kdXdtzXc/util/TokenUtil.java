package com.seeyon.apps.kdXdtzXc.util;

 import com.seeyon.apps.kdXdtzXc.KimdeConstant;
 import com.seeyon.apps.kdXdtzXc.base.util.StringUtils;
 import com.seeyon.ctp.common.authenticate.sso.SSOTicketManager;
import com.seeyon.ctp.portal.sso.SSOTicketBean;
import com.seeyon.ctp.util.HttpClientUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by tap-pcng43 on 2017-10-21.
 */
public class TokenUtil {



    public static SSOTicketManager.TicketInfo getDetailToken(String login_name) throws Exception {
        try {
 String from="KIMDE_NO_FOWARD";
                     String realticket="27967312981771"+login_name+"77886543111345";

            SSOTicketManager.TicketInfo ticketInfo = SSOTicketBean.getTicketInfo(login_name);
            if (ticketInfo != null) {
                 return ticketInfo;
            } else {
                String ssoCheckUrl = KimdeConstant.OA_URL + "/seeyon/login/sso?from=" + from + "&ticket=" + realticket;

                HttpClientUtil u = new HttpClientUtil();
                u.open(ssoCheckUrl, "get");
                int res = u.send();
                String resBody = StringUtils.trim(u.getResponseBodyAsString("utf-8") + "").replace("\n", "").replace("\t", "").replace("\r", "");
                u.close();
                // 等待10毫秒
                Thread.sleep(10);
                System.out.println("resBody="+resBody);
                if ("SSOOK".equals(resBody) && (res == 200)) {// 表示单点OK
                    ticketInfo = SSOTicketBean.getTicketInfo(realticket);
                    return ticketInfo;
                } else {
                    System.out.println("产生token失败:"+resBody);
                    ticketInfo = SSOTicketBean.getTicketInfo(realticket);
                    return ticketInfo;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}
