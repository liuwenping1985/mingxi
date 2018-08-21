package com.seeyon.apps.nbd.core.resource;

import com.seeyon.apps.nbd.core.service.ServiceForwardHandler;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.core.vo.NbdResponseEntity;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.Constants;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.filemanager.manager.FileManagerImpl;
import com.seeyon.ctp.common.log.CtpLogFactory;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.rest.resources.BaseResource;
import com.seeyon.ctp.util.EnumUtil;
import com.seeyon.ctp.util.annotation.RestInterfaceAnnotation;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.v3x.services.ServiceException;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.Response;
import java.util.*;

/**
 * Created by liuwenping on 2018/8/20.
 */

@Path("/affair")
public class NbdAffairResource  extends BaseResource {
    private Log log = CtpLogFactory.getLog(NbdAffairResource.class);

    private ServiceForwardHandler handler = new ServiceForwardHandler();
    @Context
    private HttpServletRequest request;

    @Context
    private HttpServletResponse response;

    private AttachmentManager attachmentManager;
    private FileManager fileManager;

    public NbdAffairResource() {
    }

    public AttachmentManager getAttachmentManager() {
        if(this.attachmentManager == null) {
            this.attachmentManager = (AttachmentManager)AppContext.getBean("attachmentManager");
        }

        return this.attachmentManager;
    }

    public FileManager getFileManager() {
        if(this.fileManager == null) {
            this.fileManager = (FileManager)AppContext.getBean("fileManager");
        }

        return this.fileManager;
    }

    @POST
    @Consumes({"application/xml", "application/json", "text/plain", "application/x-www-form-urlencoded","multipart/form-data"})
    @Path("/receive")
    @Produces({"application/json","text/html"})
    @RestInterfaceAnnotation
    public Response receiveAffair() throws ServiceException {

        List<Attachment> list = null;
        boolean isMultipart = ServletFileUpload.isMultipartContent(request);
        if(isMultipart){
            try {
               list = this.uploadFiles(this.request);
            } catch (BusinessException e) {
                e.printStackTrace();
            }
        }
        CommonParameter parameter = CommonParameter.parseParameter(request);
        parameter.setAttachmentList(list);
        NbdResponseEntity entity =  handler.receive(parameter,request,response);
        return  responseJson(entity);

    }

    @GET
    @Consumes({"application/xml", "application/json","multipart/form-data"})
    @Path("/find")
    @Produces({"application/json","text/html"})
    @RestInterfaceAnnotation
    public Response findAffair() throws ServiceException {

        //AppContext.getCurrentUser();
        CommonParameter parameter = CommonParameter.parseParameter(request);
        NbdResponseEntity entity =  handler.find(parameter,request,response);
        return  responseJson(entity);


    }

    private Response responseJson(Object entity){
        return Response.status(200).entity(entity).type("application/json").build();

    }

    private List<Attachment> uploadFiles(HttpServletRequest request) throws BusinessException {
        Long maxSize = Long.valueOf(Long.parseLong(SystemProperties.getInstance().getProperty("fileUpload.maxSize")));
        Map v3xFiles = null;
        CommonsMultipartResolver resolver = (CommonsMultipartResolver) AppContext.getBean("multipartResolver");
        HttpServletRequest req = resolver.resolveMultipart(request);
        v3xFiles = this.getFileManager().uploadFiles(req, "", maxSize);
        Constants.ATTACHMENT_TYPE type = Constants.ATTACHMENT_TYPE.FILE;
        ApplicationCategoryEnum  category = ApplicationCategoryEnum.global;
        if(v3xFiles != null) {
            List<String> keys = new ArrayList(v3xFiles.keySet());
            List<Attachment> atts = new ArrayList();
            Iterator v3xFilesIterator = keys.iterator();
            while(v3xFilesIterator.hasNext()) {
                String key = (String)v3xFilesIterator.next();
                V3XFile file = (V3XFile)v3xFiles.get(key);
                Attachment att = new Attachment(file, category, type);
                atts.add(att);
                this.getFileManager().save(file);
            }
            return atts;

        }
        return new ArrayList<Attachment>();
    }

    @POST
    @Produces({"text/html", "application/json"})
    @Consumes({"multipart/form-data"})
    public Response upload() {
        String extensions = this.request.getParameter("extensions");
        String applicationCategory = this.request.getParameter("applicationCategory");
        String typeStr = this.request.getParameter("type");
        String firstSave = this.request.getParameter("firstSave") == null?"":this.request.getParameter("firstSave");
        String maxSizeStr = this.request.getParameter("maxSize");
        String ucFlag = this.request.getParameter("ucFlag");
        String reference = this.request.getParameter("reference");
        Constants.ATTACHMENT_TYPE type = null;
        if(StringUtils.isNotBlank(typeStr)) {
            type = (Constants.ATTACHMENT_TYPE) EnumUtil.getEnumByOrdinal(Constants.ATTACHMENT_TYPE.class, Integer.valueOf(typeStr).intValue());
        } else {
            type = Constants.ATTACHMENT_TYPE.FILE;
        }

        if(StringUtils.isBlank(firstSave)) {
            firstSave = "false";
        }

        ApplicationCategoryEnum category = null;
        if(StringUtils.isNotBlank(applicationCategory)) {
            category = ApplicationCategoryEnum.valueOf(Integer.valueOf(applicationCategory).intValue());
        } else {
            category = ApplicationCategoryEnum.global;
            this.log.warn("上传文件：v3x:fileUpload没有设定applicationCategory属性，将设置为‘全局’。");
        }

        Long maxSize = Long.valueOf(Long.parseLong(SystemProperties.getInstance().getProperty("fileUpload.maxSize")));
        if(StringUtils.isNotBlank(maxSizeStr)) {
            maxSize = Long.valueOf(maxSizeStr);
        }

        Map v3xFiles = null;

        try {
            CommonsMultipartResolver resolver = (CommonsMultipartResolver) AppContext.getBean("multipartResolver");
            HttpServletRequest req = resolver.resolveMultipart(this.request);
            v3xFiles = this.getFileManager().uploadFiles(req, extensions, maxSize);
            if(v3xFiles != null) {
                List<String> keys = new ArrayList(v3xFiles.keySet());
                List<Attachment> atts = new ArrayList();
                Iterator var16 = keys.iterator();
                FileManagerImpl impl;
                while(var16.hasNext()) {
                    String key = (String)var16.next();
                    V3XFile file = (V3XFile)v3xFiles.get(key);
                    Attachment att = new Attachment(file, category, type);
                    if("yes".equals(ucFlag) && StringUtils.isNotBlank(reference)) {
                        try {
                            Long referenceLong = Long.valueOf(reference);
                            att.setSubReference(Long.valueOf((long)type.ordinal()));
                            att.setReference(referenceLong);
                        } catch (Exception var21) {
                            this.log.error("致信端传入的reference不符合要求", var21);
                        }
                    }

                    atts.add(att);
                    this.getFileManager().save(file);
                }

                if("true".equalsIgnoreCase(firstSave)) {
                    this.getAttachmentManager().create(atts);
                }

                Map<String, Object> map = new HashMap();
                map.put("n_a_s", Integer.valueOf(1));
                map.put("atts", atts);
                return this.ok(JSONUtil.toJSONString4Ajax(map));
            } else {
                return this.ok((Object)null);
            }
        } catch (Exception var22) {
            return this.error(var22);
        }
    }
}
