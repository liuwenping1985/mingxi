package com.seeyon.apps.datakit.controller;
import com.seeyon.apps.datakit.service.RikazeService;
import com.seeyon.apps.datakit.util.DataKitSupporter;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.springframework.web.servlet.ModelAndView;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;
/**
 * Created by liuwenping on 2018/5/31.
 */
public class RikazeController extends BaseController {
    private RikazeService rikazeService;

    public RikazeService getRikazeService() {
        return rikazeService;
    }

    public void setRikazeService(RikazeService rikazeService) {
        this.rikazeService = rikazeService;
    }

    public RikazeController(){

    }

    @NeedlessCheckLogin
    public ModelAndView checkLogin(HttpServletRequest request, HttpServletResponse response){
       User user =  AppContext.getCurrentUser();
       Map<String,String> data = new HashMap<String,String>();
        String userName ="no-body";
       if(user!=null){
           userName = user.getName();
       }
       data.put("user",userName);
       DataKitSupporter.responseJSON(data,response);
       return null;
    }





}
