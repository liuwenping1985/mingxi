package com.seeyon.apps.nbd.controller;

import com.seeyon.apps.nbd.core.service.PluginServiceManager;
import com.seeyon.apps.nbd.core.service.impl.PluginServiceManagerImpl;
import com.seeyon.apps.nbd.core.util.ValidateResult;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.core.vo.NbdResponseEntity;
import com.seeyon.apps.nbd.service.NbdService;
import com.seeyon.apps.nbd.service.ValidatorService;
import com.seeyon.apps.nbd.util.UIUtils;
import com.seeyon.ctp.common.controller.BaseController;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by liuwenping on 2018/11/3.
 */


public class NbdController extends BaseController{
    private PluginServiceManager nbdPluginServiceManager;
    private NbdService nbdService = new NbdService();

    private PluginServiceManager getNbdPluginServiceManager(){

        if(nbdPluginServiceManager == null){
            try {
                nbdPluginServiceManager =  PluginServiceManagerImpl.getInstance();
            }catch(Exception e){
                e.printStackTrace();
            }catch(Error error){
                error.printStackTrace();
            }
        }
        return nbdPluginServiceManager;
    }

    public ModelAndView getDataById(HttpServletRequest request, HttpServletResponse response){
        CommonParameter p = CommonParameter.parseParameter(request);
        NbdResponseEntity entity = null;
        entity =  nbdService.getDataById(p);

        UIUtils.responseJSON(entity,response);
        return null;

    }

    public ModelAndView getDataList(HttpServletRequest request, HttpServletResponse response){
        CommonParameter p = CommonParameter.parseParameter(request);
        NbdResponseEntity entity = null;
        entity =  nbdService.getDataList(p);
        UIUtils.responseJSON(entity,response);
        return null;

    }

    public ModelAndView postAdd(HttpServletRequest request, HttpServletResponse response){
        CommonParameter p = CommonParameter.parseParameter(request);
        NbdResponseEntity entity = null;
        ValidateResult vr = ValidatorService.validate(p);
        if(!vr.isResult()){
            entity = new NbdResponseEntity();
            entity.setResult(false);
            entity.setMsg(vr.getMsg());
        }else{
            entity = nbdService.postAdd(p);
        }
        UIUtils.responseJSON(entity,response);

        return null;

    }

    public ModelAndView postUpdate(HttpServletRequest request, HttpServletResponse response){
        CommonParameter p = CommonParameter.parseParameter(request);
        NbdResponseEntity entity = nbdService.postUpdate(p);

        UIUtils.responseJSON(entity,response);

        return null;

    }

    public ModelAndView postDelete(HttpServletRequest request, HttpServletResponse response){
        CommonParameter p = CommonParameter.parseParameter(request);
        NbdResponseEntity entity = nbdService.postDelete(p);
        UIUtils.responseJSON(entity,response);
        return null;

    }


    public ModelAndView testConnection(HttpServletRequest request, HttpServletResponse response){
        CommonParameter p = CommonParameter.parseParameter(request);
        NbdResponseEntity entity = nbdService.testConnection(p);
        UIUtils.responseJSON(entity,response);
        return null;

    }

    public ModelAndView getTemplateNumber(HttpServletRequest request, HttpServletResponse response){
        CommonParameter p = CommonParameter.parseParameter(request);
        NbdResponseEntity entity = nbdService.getCtpTemplateNumber(p);
        UIUtils.responseJSON(entity,response);
        return null;
    }

    public ModelAndView getFormByTemplateNumber(HttpServletRequest request, HttpServletResponse response){
        CommonParameter p = CommonParameter.parseParameter(request);
        NbdResponseEntity entity = nbdService.getFormByTemplateNumber(p);
        UIUtils.responseJSON(entity,response);
        return null;
    }

    //testConnection

    public ModelAndView dbConsole(HttpServletRequest request, HttpServletResponse response){
        CommonParameter p = CommonParameter.parseParameter(request);
        NbdResponseEntity entity = nbdService.dbConsole(p);
        UIUtils.responseJSON(entity,response);
        return null;
    }



}
