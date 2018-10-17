package com.seeyon.apps.nbd.platform.oa;


import com.seeyon.apps.nbd.core.config.ConfigService;
import com.seeyon.apps.nbd.ws.*;
import org.apache.axis.client.Stub;

import javax.xml.rpc.ServiceException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

public class KingdeeWebServiceProvider {



    public WSContext login2KingdeeWs(){

        String userName = ConfigService.getPropertyByName("eas_user_name","user");

        String password = ConfigService.getPropertyByName("eas_user_password","");

        EASLoginProxyServiceLocator loginLocator = new EASLoginProxyServiceLocator();

        try {


            EASLoginProxy loginProxy =  loginLocator.getEASLogin();

            WSContext wsContext = loginProxy.login(userName, password, "eas", "G004", "L2", 1);

            System.out.println("------ 登陆成功，SessionID：" + wsContext.getSessionId());
            return wsContext;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String importBill(Map<String,String> infoArray){
        try {
           // Map<String,String> infoArray = new HashMap<String,String>();
            WSContext context = login2KingdeeWs();
            if(context==null){
                System.out.println("------登陆失败------");
                return "error";
            }

           // WSWSCusBDWebServiceFacadeSrvProxyServiceLocator locator =  new WSWSCusBDWebServiceFacadeSrvProxyServiceLocator();
            WSWSCusSCMWebServiceFacadeSrvProxy proxyWS= new WSWSCusSCMWebServiceFacadeSrvProxyServiceLocator().getWSWSCusSCMWebServiceFacade();
            ((Stub) proxyWS).setHeader("http://login.webservice.bos.kingdee.com","SessionId", context.getSessionId());

            String result = proxyWS.importBill("CUSTOMER", infoArray.toString(), 1);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "error";
    }




}