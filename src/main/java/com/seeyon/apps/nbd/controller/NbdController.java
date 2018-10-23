package com.seeyon.apps.nbd.controller;

import com.seeyon.apps.nbd.core.service.PluginServiceManager;
import com.seeyon.apps.nbd.core.service.ServicePlugin;
import com.seeyon.apps.nbd.core.service.impl.PluginServiceManagerImpl;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.core.vo.CommonDataVo;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.core.vo.NbdResponseEntity;
import com.seeyon.apps.nbd.plugin.als.po.A8OutputVo;
import com.seeyon.apps.nbd.util.UIUtils;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2018/8/17.
 */

public class NbdController extends BaseController{

    private PluginServiceManager nbdPluginServiceManager;


    private PluginServiceManager getNbdPluginServiceManager(){

        if(nbdPluginServiceManager == null){
            try {
                nbdPluginServiceManager = new PluginServiceManagerImpl();
            }catch(Exception e){
                e.printStackTrace();
            }catch(Error error){
                error.printStackTrace();
            }
        }
        return nbdPluginServiceManager;
    }
    @NeedlessCheckLogin
    public ModelAndView index(HttpServletRequest request, HttpServletResponse response){

        Map data = new HashMap();
      //  DBAgent.saveAll(formTableDefinitions);
        data.put("items","1234567890");
        NbdResponseEntity entity = new NbdResponseEntity();
        entity.setResult(true);
        entity.setData(data);
        UIUtils.responseJSON(entity,response);
        return null;

    }
    @NeedlessCheckLogin
    public ModelAndView selectA8(HttpServletRequest request, HttpServletResponse response){

        Map data = new HashMap();
        List<A8OutputVo> list =  DBAgent.find("from A8OutputVo");
        data.put("items",list);
        NbdResponseEntity entity = new NbdResponseEntity();
        entity.setResult(true);
        entity.setData(data);
        UIUtils.responseJSON(entity,response);
        return null;

    }
    @NeedlessCheckLogin
    public ModelAndView syncData(HttpServletRequest request, HttpServletResponse response){

        String type = request.getParameter("affairType");

        try {
            ServicePlugin sp = this.getNbdPluginServiceManager().getServicePluginsByAffairType(type);

            List<A8OutputVo> formTableDefinitions = sp.exportData(type);
            Map data = new HashMap();
            DBAgent.saveAll(formTableDefinitions);
            data.put("items", formTableDefinitions);
            NbdResponseEntity entity = new NbdResponseEntity();
            entity.setResult(true);
            entity.setData(data);
            UIUtils.responseJSON(entity, response);

            return null;
        }catch(Exception e){
            e.printStackTrace();
        }
        UIUtils.responseJSON("error", response);
        return null;

    }

    @NeedlessCheckLogin
    public ModelAndView syncDataAll(HttpServletRequest request, HttpServletResponse response){

        List<ServicePlugin> spList = nbdPluginServiceManager.getServicePlugins();
        
        if(!CommonUtils.isEmpty(spList)){
            for(ServicePlugin sp:spList){
                sp.exportAllData();
            }
        }
        return null;

    }
    @NeedlessCheckLogin
    public ModelAndView receive(HttpServletRequest request, HttpServletResponse response){


        CommonParameter parameter = CommonParameter.parseParameter(request);
        List<ServicePlugin> spList = nbdPluginServiceManager.getServicePlugins();
        String affairType = parameter.$("affairType");
        if(!CommonUtils.isEmpty(spList)){
            for(ServicePlugin sp:spList){
               if(sp.containAffairType(affairType)){
                  CommonDataVo cdv =  sp.receiveAffair(parameter);
                   UIUtils.responseJSON(cdv,response);
                   break;
               }
            }
        }


        return null;

    }
    @NeedlessCheckLogin
    public ModelAndView find(HttpServletRequest request, HttpServletResponse response){



        return null;

    }
    @NeedlessCheckLogin
    public ModelAndView update(HttpServletRequest request, HttpServletResponse response){



        return null;

    }
    @NeedlessCheckLogin
    public ModelAndView delete(HttpServletRequest request, HttpServletResponse response){



        return null;

    }
    @NeedlessCheckLogin
    public ModelAndView selectQueryTable(HttpServletRequest request, HttpServletResponse response){






        return null;

    }


    @NeedlessCheckLogin
    public ModelAndView selectCommdityMall(HttpServletRequest request, HttpServletResponse response){






        return null;

    }

}
