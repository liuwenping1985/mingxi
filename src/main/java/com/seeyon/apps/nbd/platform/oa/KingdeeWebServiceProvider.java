package com.seeyon.apps.nbd.platform.oa;


import com.seeyon.apps.nbd.core.config.ConfigService;
import com.seeyon.apps.nbd.ws.*;

import javax.xml.rpc.ServiceException;
import java.net.URL;

public class KingdeeWebServiceProvider {



    public void login2KingdeeWs(String userName,String password){

        String urlString = ConfigService.getPropertyByName("eas_ws_endpoint","");

        EASLoginProxyServiceLocator loginLocator = new EASLoginProxyServiceLocator();

        try {
            URL url = new URL(urlString);

            EASLoginProxy loginProxy =  loginLocator.getEASLogin(url);

            WSContext wsContext = loginProxy.login(userName, password, "eas", "001", "L2", 0);

            System.out.println("------ 登陆成功，SessionID：" + wsContext.getSessionId());

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void importBill(){

        String urlString = ConfigService.getPropertyByName("eas_ws_endpoint","");

        try {
            URL url = new URL(urlString);
            WSWSCusBDWebServiceFacadeSrvProxyServiceLocator locator =  new WSWSCusBDWebServiceFacadeSrvProxyServiceLocator();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }




}