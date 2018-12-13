package com.seeyon.apps.nbd.plugin.kingdee.service;


import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.config.ConfigService;
import com.seeyon.apps.nbd.plugin.kingdee.vo.KingDeeBill;
import com.seeyon.apps.nbd.ws.*;
import org.apache.axis.client.Stub;

import java.util.List;

public class KingdeeWebServiceProvider {



    public WSContext login2KingdeeWs(){

        String userName = "新北京数据传输";

        String password = "Pwd12345";

        EASLoginProxyServiceLocator loginLocator = new EASLoginProxyServiceLocator();

        try {


            EASLoginProxy loginProxy =  loginLocator.getEASLogin();
           // WSContext wsContext = loginProxy.login(userName, password, "eas", "G004", "L2", 1);

            WSContext wsContext = loginProxy.login(userName, password, "eas", "G001", "L2", 1);

            System.out.println("------ 登陆成功，SessionID：" + wsContext.getSessionId());
            return wsContext;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String importBill(List<KingDeeBill> billList){
        try {

           // Map<String,String> infoArray = new HashMap<String,String>();
            WSContext context = login2KingdeeWs();
            if(context==null){
                System.out.println("------登陆失败------");
                return "error";
            }
            WSCusSCMWebServiceFacadeSrvProxyServiceLocator locator = new WSCusSCMWebServiceFacadeSrvProxyServiceLocator();
            WSCusSCMWebServiceFacadeSrvProxy proxy = locator.getWSCusSCMWebServiceFacade();
            ((Stub)proxy).setHeader("http://login.webservice.bos.kingdee.com","SessionId", context.getSessionId());
           // proxy.set
            String result = proxy.importBill( JSON.toJSONString(billList), 1);
            System.out.println("result:"+result);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "error";
    }




}