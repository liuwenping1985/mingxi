package com.seeyon.apps.kdXdtzXc.sso;


import com.seeyon.ctp.portal.sso.SSOLoginHandshakeAbstract;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Created by taoan on 2017-1-21.
 */
public class KimdeLoginHandleDetailSso extends SSOLoginHandshakeAbstract {
    private static Log log = LogFactory.getLog(KimdeLoginHandleDetailSso.class);


    public String handshake(String ticket) {
//		System.out.println("进入handshake token验证:"+ticket);

//        ticket = ticket.replace("27967312981771", "");
//        ticket = ticket.replace("77886543111345", "");
//		System.out.println("进入handshake realuser:"+ticket);
        ticket=  SsoPwdDecryption.getUserName(ticket);
        return ticket;
    }

    public void logoutNotify(String ticket) {
        log.info("单点登录---退出");
    }

}
