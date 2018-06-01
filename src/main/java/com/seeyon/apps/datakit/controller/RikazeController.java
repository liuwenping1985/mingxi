package com.seeyon.apps.datakit.controller;

import com.seeyon.apps.datakit.po.BulDataItem;
import com.seeyon.apps.datakit.po.NewsDataItem;
import com.seeyon.apps.datakit.service.RikazeService;
import com.seeyon.apps.datakit.util.DataKitSupporter;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import com.seeyon.v3x.bulletin.domain.BulData;
import com.seeyon.v3x.news.domain.NewsData;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
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
    @NeedlessCheckLogin
    public ModelAndView getNews(HttpServletRequest request, HttpServletResponse response) throws Exception {

        Map<String,Object> data = new HashMap<String,Object>();
        try {
            List<NewsDataItem> newsDataList = DBAgent.find("from NewsDataItem");
            data.put("news",newsDataList);
            DataKitSupporter.responseJSON(data,response);
            return null;
        }catch(Exception e){
            e.printStackTrace();
        }catch(Error e){
            e.printStackTrace();
        }
        data.put("news","error");
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView getBulData(HttpServletRequest request, HttpServletResponse response) throws Exception {

        Map<String,Object> data = new HashMap<String,Object>();
        try {
            List<BulDataItem> dataList = DBAgent.find("from BulDataItem");
            data.put("buls",dataList);
            DataKitSupporter.responseJSON(data,response);
            return null;
        }catch(Exception e){
            e.printStackTrace();
        }catch(Error e){
            e.printStackTrace();
        }
        data.put("buls","error");
        return null;
    }



}
