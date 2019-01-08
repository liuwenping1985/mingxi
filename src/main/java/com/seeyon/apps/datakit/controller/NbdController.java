package com.seeyon.apps.datakit.controller;

import com.seeyon.apps.datakit.service.NbdService;
import com.seeyon.apps.datakit.service.ValidatorService;
import com.seeyon.apps.datakit.util.CommonUtils;
import com.seeyon.apps.datakit.util.UIUtils;
import com.seeyon.apps.datakit.util.ValidateResult;
import com.seeyon.apps.datakit.vo.CommonParameter;
import com.seeyon.apps.datakit.vo.NbdResponseEntity;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.customize.manager.CustomizeManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgPost;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;

/**
 * Created by liuwenping on 2018/11/3.
 */


public class NbdController extends BaseController {

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
            //${userDepartment}
            //${userType}

        }
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







    public static void main(String[] args) {


        //6wmVh2CifkRdCLY36FoY1x3UlWQ=


        //String codde = LightWeightEncoder.decodeString("YmVuam8yMzQi");
        //System.out.println(codde);
    }

}
