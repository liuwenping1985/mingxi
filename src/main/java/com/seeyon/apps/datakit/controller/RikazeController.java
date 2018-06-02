package com.seeyon.apps.datakit.controller;

import com.seeyon.apps.collaboration.manager.PendingManager;
import com.seeyon.apps.collaboration.manager.PendingManagerImpl;
import com.seeyon.apps.datakit.po.BulDataItem;
import com.seeyon.apps.datakit.po.NewsDataItem;
import com.seeyon.apps.datakit.service.RikazeService;
import com.seeyon.apps.datakit.util.DataKitSupporter;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.portal.section.PendingController;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import com.seeyon.v3x.addressbook.controller.AddressBookController;
import com.seeyon.v3x.bulletin.domain.BulData;
import com.seeyon.v3x.edoc.controller.EdocController;
import com.seeyon.v3x.edoc.manager.EdocStatManager;
import com.seeyon.v3x.edoc.manager.EdocSummaryManager;
import com.seeyon.v3x.news.controller.NewsDataController;
import com.seeyon.v3x.news.domain.NewsData;
import org.apache.axis.utils.StringUtils;
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
    private PendingManager pendingManager;

    public RikazeService getRikazeService() {
        return rikazeService;
    }

    public void setRikazeService(RikazeService rikazeService) {
        this.rikazeService = rikazeService;
    }


    public PendingManager getPendingManager() {
        return pendingManager;
    }

    public void setPendingManager(PendingManager pendingManager) {
        this.pendingManager = pendingManager;
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
            NewsDataController controller;
            return null;
        }catch(Exception e){
            e.printStackTrace();
        }catch(Error e){
            e.printStackTrace();
        }
        data.put("buls","error");
        return null;
    }

    public ModelAndView getBanwenCount(HttpServletRequest request, HttpServletResponse response){
       User  user = AppContext.getCurrentUser();
       Long memberId =  user.getId();
       String fragementId = request.getParameter("fragmentId");
       if(StringUtils.isEmpty(fragementId)){
           fragementId = "-7771288622128478783";
       }
        String ord = "0";
        Long fgId = Long.parseLong(fragementId);
        int count =  pendingManager.getPendingCount(memberId,fgId,ord);
        Map<String,Object> data = new HashMap<String, Object>();
        data.put("count",count);
        DataKitSupporter.responseJSON(data,response);
        return null;
    }

    public ModelAndView getYuewenCount(HttpServletRequest request, HttpServletResponse response){
        User  user = AppContext.getCurrentUser();
        Long memberId =  user.getId();
        String fragementId = request.getParameter("fragmentId");
        if(StringUtils.isEmpty(fragementId)){
            fragementId = "-7771288622128478783";
        }
        String ord = "1";
        Long fgId = Long.parseLong(fragementId);
        int count =  pendingManager.getPendingCount(memberId,fgId,ord);
        Map<String,Object> data = new HashMap<String, Object>();
        data.put("count",count);
        DataKitSupporter.responseJSON(data,response);

        return null;
    }



}
