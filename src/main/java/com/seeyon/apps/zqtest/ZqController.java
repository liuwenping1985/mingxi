package com.seeyon.apps.zqtest;

import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.core.vo.NbdResponseEntity;
import com.seeyon.apps.nbd.util.UIUtils;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.portal.controller.PortalController;
import com.seeyon.ctp.portal.space.manager.SpaceManagerImpl;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ZqController extends BaseController {
    public static void main(String []args){

        System.out.println();
    }
    @NeedlessCheckLogin
    public ModelAndView getDataById(HttpServletRequest request, HttpServletResponse response){
        CommonParameter p = CommonParameter.parseParameter(request);
       // NbdResponseEntity entity = null;

       String sql = (String)p.get("ddd");
     //   PortalController pc;

        UIUtils.responseJSON(sql,response);
        return null;

    }
    @NeedlessCheckLogin
    public ModelAndView goPage(HttpServletRequest request, HttpServletResponse response){
        CommonParameter p = CommonParameter.parseParameter(request);
        String page = p.$("page");
        if(page == null){
            page = "hello";
        }

        ModelAndView mav = new ModelAndView("/apps/zqtest/"+page);

        return mav;

    }
}
