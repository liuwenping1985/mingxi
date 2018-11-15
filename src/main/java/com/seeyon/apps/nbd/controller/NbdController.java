package com.seeyon.apps.nbd.controller;

import com.seeyon.apps.doc.controller.DocController;
import com.seeyon.apps.doc.controller.DocManagerController;
import com.seeyon.apps.nbd.core.service.PluginServiceManager;
import com.seeyon.apps.nbd.core.service.impl.PluginServiceManagerImpl;
import com.seeyon.apps.nbd.core.util.ValidateResult;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.core.vo.NbdResponseEntity;
import com.seeyon.apps.nbd.service.NbdService;
import com.seeyon.apps.nbd.service.ValidatorService;
import com.seeyon.apps.nbd.util.UIUtils;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.portal.controller.PortalController;
import com.seeyon.ctp.portal.space.controller.SpaceController;
import com.seeyon.ctp.portal.space.manager.SpaceManager;
import com.seeyon.ctp.portal.space.manager.SpaceManagerImpl;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
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
    @NeedlessCheckLogin
    public ModelAndView getDataById(HttpServletRequest request, HttpServletResponse response){
        CommonParameter p = CommonParameter.parseParameter(request);
        NbdResponseEntity entity = null;
        entity =  nbdService.getDataById(p);
        PortalController pc;

        UIUtils.responseJSON(entity,response);
        return null;

    }
    @NeedlessCheckLogin
    public ModelAndView goPage(HttpServletRequest request, HttpServletResponse response){
        CommonParameter p = CommonParameter.parseParameter(request);
        String page = p.$("page");
        if(page == null){
            page = "index";
        }
        SpaceManagerImpl spaceManager;
        ModelAndView mav = new ModelAndView("apps/nbd/"+page);

        return mav;

    }
    @NeedlessCheckLogin
    public ModelAndView getDataList(HttpServletRequest request, HttpServletResponse response){
        CommonParameter p = CommonParameter.parseParameter(request);
        NbdResponseEntity entity = null;
        entity =  nbdService.getDataList(p);
        UIUtils.responseJSON(entity,response);
        return null;

    }
    @NeedlessCheckLogin
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
    @NeedlessCheckLogin
    public ModelAndView postUpdate(HttpServletRequest request, HttpServletResponse response){
        CommonParameter p = CommonParameter.parseParameter(request);
        NbdResponseEntity entity = nbdService.postUpdate(p);

        UIUtils.responseJSON(entity,response);

        return null;

    }
    @NeedlessCheckLogin
    public ModelAndView postDelete(HttpServletRequest request, HttpServletResponse response){
        CommonParameter p = CommonParameter.parseParameter(request);
        NbdResponseEntity entity = nbdService.postDelete(p);
        UIUtils.responseJSON(entity,response);
        return null;

    }

    @NeedlessCheckLogin
    public ModelAndView testConnection(HttpServletRequest request, HttpServletResponse response){
        CommonParameter p = CommonParameter.parseParameter(request);
        NbdResponseEntity entity = nbdService.testConnection(p);
        UIUtils.responseJSON(entity,response);
        return null;

    }
    @NeedlessCheckLogin
    public ModelAndView getTemplateNumber(HttpServletRequest request, HttpServletResponse response){
        CommonParameter p = CommonParameter.parseParameter(request);
        NbdResponseEntity entity = nbdService.getCtpTemplateNumber(p);
        UIUtils.responseJSON(entity,response);
        return null;
    }
    @NeedlessCheckLogin
    public ModelAndView getFormByTemplateNumber(HttpServletRequest request, HttpServletResponse response){
        CommonParameter p = CommonParameter.parseParameter(request);
        NbdResponseEntity entity = nbdService.getFormByTemplateNumber(p);
        UIUtils.responseJSON(entity,response);
        return null;
    }

    //testConnection
    @NeedlessCheckLogin
    public ModelAndView dbConsole(HttpServletRequest request, HttpServletResponse response){
        CommonParameter p = CommonParameter.parseParameter(request);
        NbdResponseEntity entity = nbdService.dbConsole(p);
        UIUtils.responseJSON(entity,response);
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView dbConsole2(HttpServletRequest request, HttpServletResponse response){


        DocController docController;
        DocManagerController dmc;
        SpaceController sc;

        return null;
    }



}
