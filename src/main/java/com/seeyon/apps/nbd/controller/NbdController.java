package com.seeyon.apps.nbd.controller;

import com.seeyon.apps.doc.po.DocLibPO;
import com.seeyon.apps.doc.po.DocResourcePO;
import com.seeyon.apps.nbd.core.service.PluginServiceManager;
import com.seeyon.apps.nbd.core.service.impl.PluginServiceManagerImpl;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.core.util.ValidateResult;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.core.vo.NbdResponseEntity;
import com.seeyon.apps.nbd.service.NbdService;
import com.seeyon.apps.nbd.service.ValidatorService;
import com.seeyon.apps.nbd.util.UIUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.common.po.template.CtpTemplate;
import com.seeyon.ctp.util.LightWeightEncoder;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * Created by liuwenping on 2018/11/3.
 */


public class NbdController extends BaseController {
    private PluginServiceManager nbdPluginServiceManager;
    private FileManager fileManager;
    private NbdService nbdService;

    public NbdService getNbdService() {
        return nbdService;
    }

    public void setNbdService(NbdService nbdService) {
        this.nbdService = nbdService;
    }

    private PluginServiceManager getNbdPluginServiceManager() {

        if (nbdPluginServiceManager == null) {
            try {
                nbdPluginServiceManager = PluginServiceManagerImpl.getInstance();
            } catch (Exception e) {
                e.printStackTrace();
            } catch (Error error) {
                error.printStackTrace();
            }
        }
        return nbdPluginServiceManager;
    }

    private FileManager getFileManager() {
        if (fileManager == null) {
            fileManager = (FileManager) AppContext.getBean("fileManager");
        }
        Collection coll;
        return fileManager;
    }

    @NeedlessCheckLogin
    public ModelAndView getDataById(HttpServletRequest request, HttpServletResponse response) {
        CommonParameter p = CommonParameter.parseParameter(request);
        NbdResponseEntity entity = null;
        entity = nbdService.getDataById(p);
        UIUtils.responseJSON(entity, response);
        return null;

    }

    @NeedlessCheckLogin
    public ModelAndView goPage(HttpServletRequest request, HttpServletResponse response) {
        CommonParameter p = CommonParameter.parseParameter(request);
        String page = p.$("page");
        if (page == null) {
            page = "index";
        }

        ModelAndView mav = new ModelAndView("apps/nbd/" + page);

        return mav;

    }

    @NeedlessCheckLogin
    public ModelAndView getDataList(HttpServletRequest request, HttpServletResponse response) {
        CommonParameter p = CommonParameter.parseParameter(request);
        NbdResponseEntity entity = null;
        entity = nbdService.getDataList(p);
        UIUtils.responseJSON(entity, response);
        return null;

    }

    @NeedlessCheckLogin
    public ModelAndView postAdd(HttpServletRequest request, HttpServletResponse response) {
        try {
            CommonParameter p = CommonParameter.parseParameter(request);
            NbdResponseEntity entity = null;
            ValidateResult vr = ValidatorService.validate(p);
            if (!vr.isResult()) {
                entity = new NbdResponseEntity();
                entity.setResult(false);
                entity.setMsg(vr.getMsg());

            } else {

                entity = nbdService.postAdd(p);

            }
            UIUtils.responseJSON(entity, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;

    }

    @NeedlessCheckLogin
    public ModelAndView postUpdate(HttpServletRequest request, HttpServletResponse response) {
        CommonParameter p = CommonParameter.parseParameter(request);
        try {
            NbdResponseEntity entity = nbdService.postUpdate(p);
            UIUtils.responseJSON(entity, response);
        } catch (Exception e) {
            e.printStackTrace();
        }


        return null;

    }

    @NeedlessCheckLogin
    public ModelAndView postDelete(HttpServletRequest request, HttpServletResponse response) {
        CommonParameter p = CommonParameter.parseParameter(request);
        try {
            NbdResponseEntity entity = nbdService.postDelete(p);
            UIUtils.responseJSON(entity, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;

    }

    @NeedlessCheckLogin
    public ModelAndView testConnection(HttpServletRequest request, HttpServletResponse response) {
        CommonParameter p = CommonParameter.parseParameter(request);
        NbdResponseEntity entity = nbdService.testConnection(p);
        UIUtils.responseJSON(entity, response);
        return null;

    }

    @NeedlessCheckLogin
    public ModelAndView getTemplateNumber(HttpServletRequest request, HttpServletResponse response) {
        CommonParameter p = CommonParameter.parseParameter(request);
        NbdResponseEntity entity = nbdService.getCtpTemplateNumber(p);
        UIUtils.responseJSON(entity, response);
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView getFormByTemplateNumber(HttpServletRequest request, HttpServletResponse response) {
        CommonParameter p = CommonParameter.parseParameter(request);
        NbdResponseEntity entity = nbdService.getFormByTemplateNumber(p);
        UIUtils.responseJSON(entity, response);
        return null;
    }

    //testConnection
    @NeedlessCheckLogin
    public ModelAndView dbConsole(HttpServletRequest request, HttpServletResponse response) {
        CommonParameter p = CommonParameter.parseParameter(request);
        NbdResponseEntity entity = nbdService.dbConsole(p);
        UIUtils.responseJSON(entity, response);
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView download(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String fileId = request.getParameter("file_id");
        if (CommonUtils.isEmpty(fileId)) {

            return null;

        }
        InputStream fis = null;
        OutputStream toClient = null;
        try {
            V3XFile v3xfile = getFileManager().getV3XFile(Long.parseLong(fileId));
            File file = getFileManager().getFile(Long.parseLong(fileId), v3xfile.getCreateDate());
            String filename = v3xfile.getFilename();

            // 取得文件名。
            // 取得文件的后缀名。
            //String ext = filename.substring(filename.lastIndexOf(".") + 1).toUpperCase();
            // 以流的形式下载文件。
            fis = new BufferedInputStream(new FileInputStream(file));
            byte[] buffer = new byte[fis.available()];
            fis.read(buffer);

            // 清空response
            response.reset();
            // 设置response的Header
            response.addHeader("Content-Disposition", "attachment;filename=" + new String(filename.getBytes()));
            response.addHeader("Content-Length", "" + file.length());
            toClient = new BufferedOutputStream(response.getOutputStream());
            response.setContentType("application/octet-stream");
            toClient.write(buffer);
            toClient.flush();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (fis != null) {
                try {
                    fis.close();
                } catch (Exception e) {

                }
            }
            if (toClient != null) {
                try {
                    toClient.close();
                } catch (Exception e) {

                }

            }

        }

        return null;

    }

    @NeedlessCheckLogin
    public ModelAndView getMyCtpTemplateList(HttpServletRequest request, HttpServletResponse response){
        preHandleRequest(request,response);
        User user = AppContext.getCurrentUser();
        List<CtpTemplate> templateList = new ArrayList<CtpTemplate>();
        String category = "-1,1,2,4,19,20,21,32";
        CommonParameter p = CommonParameter.parseParameter(request);
        String limitStr = p.$("limit");
        if(limitStr == null){
            limitStr = "20";
        }
        String ofssetStr = p.$("offset");
        if(ofssetStr == null){
            ofssetStr = "0";
        }
        int limit = Integer.parseInt(limitStr);
        int offset = Integer.parseInt(ofssetStr);
        if(user == null){

            templateList =  nbdService.findConfigTemplates(category,offset,limit,8180340772611837618L,670869647114347l);
        }else{

            templateList = nbdService.findConfigTemplates(category,offset,limit,user.getId(),user.getAccountId());
        }
        NbdResponseEntity<CtpTemplate> entity = new NbdResponseEntity<CtpTemplate>();
        entity.setResult(true);
        entity.setItems(templateList);
        UIUtils.responseJSON(entity,response);

        return null;
    }
    private void preHandleRequest(HttpServletRequest request, HttpServletResponse response){

        nbdService.setRequest(request);
        nbdService.setResponse(response);

    }
    public static void main(String[] args) {

        String codde = LightWeightEncoder.decodeString("YmVuam8yMzQi");
        System.out.println(codde);
    }

}
