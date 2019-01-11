package com.seeyon.apps.nbd.controller;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.constant.PageResourceConstant;
import com.seeyon.apps.nbd.core.service.PluginServiceManager;
import com.seeyon.apps.nbd.core.service.impl.PluginServiceManagerImpl;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.core.util.ValidateResult;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.core.vo.NbdResponseEntity;
import com.seeyon.apps.nbd.service.NbdService;
import com.seeyon.apps.nbd.service.ValidatorService;
import com.seeyon.apps.nbd.util.UIUtils;
import com.seeyon.apps.nbd.vo.PageResourceVo;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.customize.manager.CustomizeManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.common.po.template.CtpTemplate;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgPost;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.principal.PrincipalManagerImpl;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import com.seeyon.v3x.bulletin.controller.BulDataController;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.*;

/**
 * Created by liuwenping on 2018/11/3.
 */


public class NbdController extends BaseController {
    private PluginServiceManager nbdPluginServiceManager;
    private FileManager fileManager;
    private NbdService nbdService;

    private CustomizeManager customizeManager;

    public CustomizeManager getCustomizeManager() {
        if(customizeManager == null){
            customizeManager = (CustomizeManager)AppContext.getBean("customizeManager");
        }
        return customizeManager;
    }

    public void setCustomizeManager(CustomizeManager customizeManager) {
        this.customizeManager = customizeManager;
    }

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


    
    public ModelAndView goPage(HttpServletRequest request, HttpServletResponse response) {
        CommonParameter p = CommonParameter.parseParameter(request);
        String page = p.$("page");
        if (page == null) {
            page = "index";
        }
        ModelAndView mav = new ModelAndView("apps/nbd/" + page);
        User user = AppContext.getCurrentUser();
        if (user != null) {
            //userLogoImage
            //${userName}
            OrgManager orgManager = (OrgManager) AppContext.getBean("orgManager");
            mav.addObject("userName", user.getName());//加的。

            mav.addObject("userDepartId", user.getDepartmentId());
            mav.addObject("userLevel", user.getLevelId());
            V3xOrgDepartment department = null;
            try {
                department = orgManager.getDepartmentById(user.getDepartmentId());
            } catch (BusinessException e) {

            }
            if (department != null) {
                mav.addObject("userDepartment", department.getName());
            } else {
                mav.addObject("userDepartment", "中日中心");
            }
            V3xOrgPost post = null;
            try {
                post = orgManager.getPostById(user.getPostId());
                mav.addObject("userType", post.getName());
            } catch (BusinessException e) {
                e.printStackTrace();
            }

            try {
                String logo = getAvatarImageUrl(orgManager.getMemberById(user.getId()));
                mav.addObject("userLogoImage", logo);
                mav.addObject("userId",user.getId());
            } catch (BusinessException e) {
                e.printStackTrace();
                mav.addObject("userLogoImage", "/seeyon/apps_res/nbd/images/logoUser.jpg");
            }
            mav.addObject("pagePrivileges", PageResourceConstant.hasZRYQPrivilege(user)?"YES":"NO");
            mav.addObject("pagePrivileges_huiyi", PageResourceConstant.hasHuiYiAllPrivilege(user)?"YES":"NO");
            mav.addObject("pagePrivileges_richeng", PageResourceConstant.hasRiChenPrivilege(user)?"YES":"NO");

            //${userDepartment}
            //${userType}

        } else {
            try {
                response.sendRedirect("/seeyon/main.do?method=main");
                return null;
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return mav;

    }
    public String getAvatarImageUrl(V3xOrgMember member) {
        String contextPath = SystemEnvironment.getContextPath();
        return getAvatarImageUrl(member, contextPath);
    }
    private String getAvatarImageUrl(V3xOrgMember member, String contextPath) {
        String imageSrc = contextPath + "/apps_res/v3xmain/images/personal/pic.gif";
        String isUseDefaultAvatar = "enable";
        try {
            if (member != null) {
                Object property = member.getProperty("imageid");
                if (property != null) {
                    String imageId = member.getProperty("imageid").toString();
                    if (Strings.isNotBlank(imageId)) {
                        imageSrc = contextPath + imageId;
                        return imageSrc;
                    }
                } else {
                    return imageSrc;
                }
            }
            String fileName = getCustomizeManager().getCustomizeValue(member.getId(), "avatar");
            if (fileName != null && !Strings.equals("pic.gif", fileName)) {
                fileName = fileName.replaceAll(" on", " son");
                if (fileName.startsWith("fileId")) {
                    imageSrc = contextPath + "/fileUpload.do?method=showRTE&" + fileName + "&type=image";
                } else {
                    imageSrc = contextPath + "/apps_res/v3xmain/images/personal/" + fileName;
                }
            } else if (Strings.equals("enable", isUseDefaultAvatar)) {

            }
            //GovDocController

        } catch (Exception var8) {
            var8.printStackTrace();
        }
        return imageSrc;
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
    public ModelAndView getMyCtpTemplateList(HttpServletRequest request, HttpServletResponse response) {
        preHandleRequest(request, response);
        User user = AppContext.getCurrentUser();
        List<CtpTemplate> templateList = new ArrayList<CtpTemplate>();
        String category = "-1,1,2,4,19,20,21,32";
        CommonParameter p = CommonParameter.parseParameter(request);
        String limitStr = p.$("limit");
        if (limitStr == null) {
            limitStr = "20";
        }
        String ofssetStr = p.$("offset");
        if (ofssetStr == null) {
            ofssetStr = "0";
        }
        int limit = Integer.parseInt(limitStr);
        int offset = Integer.parseInt(ofssetStr);
        if (user == null) {

            templateList = nbdService.findConfigTemplates(category, offset, limit, 8180340772611837618L, 670869647114347l);
        } else {
            templateList = nbdService.findConfigTemplates(category, offset, limit, user.getId(), user.getAccountId());
        }
        NbdResponseEntity<CtpTemplate> entity = new NbdResponseEntity<CtpTemplate>();
        entity.setResult(true);
        List<Map> retList = new ArrayList<Map>();
        for (CtpTemplate template : templateList) {
            String jsonMapString = JSON.toJSONString(template);
            Map map = JSON.parseObject(jsonMapString, HashMap.class);
            map.put("id", String.valueOf(map.get("id")));
            map.put("link","/seeyon/menhu.do?method=openLink&linkType=template&id="+template.getId()+"&templateType="+template.getType());
            retList.add(map);
        }

        entity.setItems(retList);
        UIUtils.responseJSON(entity, response);

        return null;
    }
    public ModelAndView getReportResourceList(HttpServletRequest request, HttpServletResponse response) {
        User user =  AppContext.getCurrentUser();
        Collection<PageResourceVo> voList = PageResourceConstant.getUserReportPrivileges(user);
        NbdResponseEntity<PageResourceVo> entity = new NbdResponseEntity<PageResourceVo>();
        entity.setResult(true);
        List list = new ArrayList();
        list.addAll(voList);
        entity.setItems(list);;
        UIUtils.responseJSON(entity,response);
        return null;
    }
    private void preHandleRequest(HttpServletRequest request, HttpServletResponse response) {

        nbdService.setRequest(request);
        nbdService.setResponse(response);

    }

    public static void main(String[] args) {


        //6wmVh2CifkRdCLY36FoY1x3UlWQ=

        //String codde = LightWeightEncoder.decodeString("YmVuam8yMzQi");
        //System.out.println(codde);
    }

}
