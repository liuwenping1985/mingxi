package com.seeyon.apps.nbd.controller;

import com.seeyon.apps.nbd.util.UIUtils;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.organization.manager.MemberManagerImpl;
import com.seeyon.ctp.util.Base64;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by liuwenping on 2018/9/3.
 */
public class SsoController extends BaseController {


    @NeedlessCheckLogin
    public ModelAndView sso(HttpServletRequest request, HttpServletResponse response){


         String ticket = request.getParameter("ticket");

       // com.seeyon.ctp.permission.bo.LicensePerInfo info;

         if(StringUtils.isEmpty(ticket)){

             try {
                 byte[] bytes = Base64.decodeBase64(ticket.getBytes("UTF-8"));
                 String loginName = new String(bytes,"UTF-8");

                 Map data = new HashMap();
                 data.put("result",true);
                 Map header = new HashMap();
                 header.put("LoginName",loginName);
                 UIUtils.responseJSON(data,header,response);
             } catch (UnsupportedEncodingException e) {
                 e.printStackTrace();
             }

         }



        return null;

    }
}
