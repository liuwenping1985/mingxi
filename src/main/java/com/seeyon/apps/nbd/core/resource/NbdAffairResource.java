//package com.seeyon.apps.nbd.core.resource;
//
//import com.seeyon.apps.collaboration.controller.CollaborationController;
//import com.seeyon.apps.collaboration.manager.ColManager;
//import com.seeyon.apps.collaboration.manager.ColManagerImpl;
//import com.seeyon.apps.collaboration.po.ColSummary;
//import com.seeyon.apps.nbd.core.service.ServiceForwardHandler;
//import com.seeyon.apps.nbd.core.vo.CommonParameter;
//import com.seeyon.apps.nbd.core.vo.NbdResponseEntity;
//import com.seeyon.ctp.common.AppContext;
//import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
//import com.seeyon.ctp.common.constants.SystemProperties;
//import com.seeyon.ctp.common.content.affair.AffairManager;
//import com.seeyon.ctp.common.content.dao.ContentDaoImpl;
//import com.seeyon.ctp.common.content.mainbody.MainbodyController;
//import com.seeyon.ctp.common.content.mainbody.MainbodyManagerImpl;
//import com.seeyon.ctp.common.exceptions.BusinessException;
//import com.seeyon.ctp.common.filemanager.Constants;
//import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
//import com.seeyon.ctp.common.filemanager.manager.FileManager;
//import com.seeyon.ctp.common.filemanager.manager.NbdFileUtils;
//import com.seeyon.ctp.common.log.CtpLogFactory;
//import com.seeyon.ctp.common.po.affair.CtpAffair;
//import com.seeyon.ctp.common.po.filemanager.Attachment;
//import com.seeyon.ctp.common.po.filemanager.V3XFile;
//import com.seeyon.ctp.form.bean.FormBean;
//import com.seeyon.ctp.form.bean.FormDataMasterBean;
//import com.seeyon.ctp.form.modules.engin.base.formData.FormDataDAOImpl;
//import com.seeyon.ctp.form.modules.engin.base.formData.FormDataManagerImpl;
//import com.seeyon.ctp.form.service.FormDataController;
//import com.seeyon.ctp.form.service.FormMainbodyHandler;
//import com.seeyon.ctp.form.service.FormManager;
//import com.seeyon.ctp.organization.bo.V3xOrgMember;
//import com.seeyon.ctp.organization.manager.OrgManager;
//import com.seeyon.ctp.rest.resources.BaseResource;
//import com.seeyon.ctp.util.UUIDLong;
//import com.seeyon.ctp.util.annotation.RestInterfaceAnnotation;
//import com.seeyon.ctp.util.json.JSONUtil;
//import com.seeyon.v3x.services.ServiceException;
//import com.seeyon.v3x.services.flow.impl.FlowFactoryImpl;
//import org.apache.commons.fileupload.servlet.ServletFileUpload;
//import org.apache.commons.lang.StringUtils;
//import org.apache.commons.logging.Log;
//import org.springframework.util.CollectionUtils;
//import org.springframework.web.multipart.commons.CommonsMultipartResolver;
//
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import javax.ws.rs.*;
//import javax.ws.rs.core.Context;
//import javax.ws.rs.core.Response;
//import java.util.*;
//
///**
// * Created by liuwenping on 2018/8/20.
// */
//
//@Path("/form")
//@Produces({"application/json"})
//public class NbdAffairResource extends BaseResource {
//    private Log log = CtpLogFactory.getLog(NbdAffairResource.class);
//    private AffairManager affairManager = (AffairManager)AppContext.getBean("affairManager");
//    private ColManager colManager = (ColManager)AppContext.getBean("colManager");
//    private FormManager formManager;
////
////    private static FormCacheManager formCacheManager = (FormCacheManager)AppContext.getBean("formCacheManager");
////    private static FormDefinitionDAO formDefinitionDAO = (FormDefinitionDAO)AppContext.getBean("formDefinitionDAO");
////    private static FormDataDAO formDataDAO = (FormDataDAO)AppContext.getBean("formDataDAO");
////    private static FormAuthModuleDAO formAuthModuleDAO = (FormAuthModuleDAO)AppContext.getBean("formAuthModuleDAO");
////    private static FormRelationManager formRelationManager = (FormRelationManager)AppContext.getBean("formRelationManager");
////    private static FormAuthManager formAuthManager = (FormAuthManager)AppContext.getBean("formAuthManager");
////    private static FormManager formManager = (FormManager)AppContext.getBean("formManager");
////    private static EnumManager enumManagerNew = (EnumManager)AppContext.getBean("enumManagerNew");
////    private static FormOperationEventBindDao formOperationEventBindDao = (FormOperationEventBindDao)AppContext.getBean("formOperationEventBindDao");
////    private static CollaborationApi collaborationApi = (CollaborationApi)AppContext.getBean("collaborationApi");
////    private static SeeyonreportApi seeyonreportApi = (SeeyonreportApi)AppContext.getBean("seeyonreportApi");
//
//    private ServiceForwardHandler handler = new ServiceForwardHandler();
//    @Context
//    private HttpServletRequest request;
//
//    @Context
//    private HttpServletResponse response;
//
//    private AttachmentManager attachmentManager;
//    private FileManager fileManager;
//
//    public NbdAffairResource() {
//    }
//
//    public AttachmentManager getAttachmentManager() {
//        if (this.attachmentManager == null) {
//            this.attachmentManager = (AttachmentManager) AppContext.getBean("attachmentManager");
//        }
//
//        return this.attachmentManager;
//    }
//
//
//    public FileManager getFileManager() {
//        if (this.fileManager == null) {
//            this.fileManager = (FileManager) AppContext.getBean("fileManager");
//        }
//
//        return this.fileManager;
//    }
//
//    public FormManager getFormManager(){
//        if(formManager == null){
//            formManager = (FormManager) AppContext.getBean("formManager");
//        }
//        return formManager;
//    }
//
//    @POST
//    @Consumes({"application/xml", "application/json", "text/plain", "application/x-www-form-urlencoded", "multipart/form-data"})
//    @Path("/receive")
//    @Produces({"application/json", "text/html"})
//    @RestInterfaceAnnotation
//    public Response receiveAffair() throws ServiceException {
//
//        List<Attachment> list = null;
//        boolean isMultipart = ServletFileUpload.isMultipartContent(request);
//        if (isMultipart) {
//            try {
//                System.out.println("is isMultipart");
//                Map data = new HashMap();
//                list = this.uploadFiles(this.request, data);
//                Object obj = data.get("req");
//                if (obj != null) {
//                    this.request = (HttpServletRequest) obj;
//                }
//            } catch (BusinessException e) {
//                e.printStackTrace();
//            }
//        }
//        CommonParameter parameter = CommonParameter.parseParameter(request);
//        if (!CollectionUtils.isEmpty(list)) {
//            System.out.println("FILE UPLOAD SUCCESS");
//            for (Attachment att : list) {
//                System.out.println("att:" + att.getFilename());
//            }
//        } else {
//            System.out.println("NO FILE INPUT DATA STREAM");
//        }
//        parameter.setAttachmentList(list);
//       // NbdResponseEntity entity = handler.receive(parameter, request, response);
//        return responseJson(parameter);
//
//    }
//
//    @GET
//    @Consumes({"application/xml", "application/json", "multipart/form-data"})
//    @Path("/find")
//    @Produces({"application/json", "text/html"})
//    @RestInterfaceAnnotation
//    public Response findAffair() throws ServiceException {
//
//        //AppContext.getCurrentUser();
//        CommonParameter parameter = CommonParameter.parseParameter(request);
//        NbdResponseEntity entity = handler.find(parameter, request, response);
//        return responseJson(entity);
//
//
//    }
//    @GET
//    @Consumes({"application/xml", "application/json", "multipart/form-data"})
//    @Path("/findForm")
//    @Produces({"application/json", "text/html"})
//    @RestInterfaceAnnotation
//    public Response findFormAffair() throws ServiceException, BusinessException {
//        MainbodyController mc;
//        MainbodyManagerImpl impl;
//        FormMainbodyHandler impl2;
//        ContentDaoImpl contentDao;
//        FormDataController fdc;
//        CollaborationController ccll;
//        //transShowSummary
//        ColManagerImpl colManagerImpl;
//        FormManager fm;
//        FlowFactoryImpl flowFactoryImplimpl;
//
//        FormDataDAOImpl daoImpl;
//
//        FormDataManagerImpl fdmi;
//       // FormExport formExport
//
//        //AppContext.getCurrentUser();
//        CommonParameter parameter = CommonParameter.parseParameter(request);
//       // String param=、、
//        String affId = parameter.$("affair_id");
//        Long summaryIdAdnAffairId = Long.valueOf(affId);
//        FormDataMasterBean data = null;
//        Map mData = new HashMap();
//        Long formRecordId = null;
//        Long formId = null;
//        ColSummary summary = null;
//        NbdResponseEntity entity = new NbdResponseEntity();
//        if(null != summaryIdAdnAffairId) {
//            summary = this.colManager.getSummaryById(summaryIdAdnAffairId);
//            if(null != summary) {
//                formRecordId = summary.getFormRecordid();
//                formId = summary.getFormAppid();
//            } else {
//                CtpAffair ctpAffair = this.affairManager.get(summaryIdAdnAffairId);
//                if(null != ctpAffair) {
//                    summary = this.colManager.getSummaryById(ctpAffair.getObjectId());
//                    if(null != summary) {
//                        formRecordId = summary.getFormRecordid();
//                        formId = summary.getFormAppid();
//                    }
//                }
//            }
//        }
//        try {
//
//         //   FormDataMasterBean sessionMasterData = getFormManager().getSessioMasterDataBean(Long.valueOf(formRecordId));
//            FormBean fb = getFormManager().getForm(formId);
//            System.out.println("fb---index::::"+fb.getMasterTableBean().toXML());
//          //  FormDataMasterBean fdmb =  getFormManager().getFormDataDAO().insertData()
//          //  getFormManager().getFormDataManager().getform
//           // mData.put("sessionMasterDataJSON",fdmb.toJSON(10));
//
//          //  mData.put("sessionMasterDataXML",fdmb.toXML());
//            //data = FormService.findDataById(formRecordId.longValue(), formId.longValue());
//            mData.put("formDataMasterBean",null);
//            entity.setData(mData);
//        } catch (Exception e) {
//            e.printStackTrace();
//            entity.setMsg(e.getMessage());
//            entity.setResult(false);
//            StackTraceElement[] stes =  e.getStackTrace();
//            Map stesMap = new HashMap();
//            StringBuilder stb = new StringBuilder();
//            stb.append(e.getCause().toString());
//            for(StackTraceElement ste:stes){
//                stb.append(ste.toString()).append("\r\n");
//            }
//            stesMap.put("trace",stb.toString());
//            entity.setData(stesMap);
//        }
//
//
//        //NbdResponseEntity entity = handler.find(parameter, request, response);
//        return responseJson(entity);
//
//
//    }
//
//    private Response responseJson(Object entity) {
//        return Response.status(200).entity(entity).type("application/json").build();
//
//    }
//
//    private List<Attachment> uploadFiles(HttpServletRequest request, Map requestHolder) throws BusinessException {
//        //  Long maxSize = Long.valueOf(Long.parseLong(SystemProperties.getInstance().getProperty("fileUpload.maxSize")));
//        Map v3xFiles = null;
//        CommonsMultipartResolver resolver = (CommonsMultipartResolver) AppContext.getBean("multipartResolver");
//        HttpServletRequest req = resolver.resolveMultipart(request);
//        requestHolder.put("req", req);
//        String sender = req.getParameter("sender");
//        System.out.println("upload--files-sender:"+sender);
//        if (StringUtils.isEmpty(sender)) {
//            return null;
//        }
//        OrgManager orgManager = (OrgManager) AppContext.getBean("orgManager");
//        V3xOrgMember member = orgManager.getMemberByLoginName(sender);
//
//        v3xFiles = NbdFileUtils.uploadFiles(req, member);
//        Constants.ATTACHMENT_TYPE type = Constants.ATTACHMENT_TYPE.FILE;
//        ApplicationCategoryEnum category = ApplicationCategoryEnum.form;
//        if (v3xFiles != null) {
//            List<String> keys = new ArrayList(v3xFiles.keySet());
//            List<Attachment> atts = new ArrayList();
//            Iterator v3xFilesIterator = keys.iterator();
//            while (v3xFilesIterator.hasNext()) {
//                String key = (String) v3xFilesIterator.next();
//                V3XFile file = (V3XFile) v3xFiles.get(key);
//                Attachment att = new Attachment(file, category, type);
//                //att.setReference();
//                att.setSubReference(UUIDLong.longUUID());
//                att.setCategory(2);
//                att.setType(0);
//                atts.add(att);
//
//                this.getFileManager().save(file);
//            }
//            if(!CollectionUtils.isEmpty(atts)){
//
//                this.getAttachmentManager().create(atts);
//            }
//            return atts;
//
//        }
//        return new ArrayList<Attachment>();
//    }
//
//    @POST
//    @Produces({"text/html", "application/json"})
//    @Consumes({"multipart/form-data"})
//    @Path("/upload")
//    public Response upload() {
//
//        Constants.ATTACHMENT_TYPE type = Constants.ATTACHMENT_TYPE.FILE;
//        String firstSave = "true";
//        ApplicationCategoryEnum  category = ApplicationCategoryEnum.form;
//        //this.log.warn("上传文件：v3x:fileUpload没有设定applicationCategory属性，将设置为‘全局’。");
//        Long maxSize = Long.valueOf(Long.parseLong(SystemProperties.getInstance().getProperty("fileUpload.maxSize")));
//        //Map v3xFiles = null;
//
//        try {
//            //OrgManager orgManager = (OrgManager) AppContext.getBean("orgManager");
//           // V3xOrgMember member = orgManager.getMemberByLoginName(sender);
//            Map reqHolder = new HashMap();
//            List<Attachment> attList = this.uploadFiles(this.request,reqHolder);
//            Object obj = reqHolder.get("req");
//            if (obj != null) {
//                this.request = (HttpServletRequest) obj;
//            }
//            CommonParameter parameter = CommonParameter.parseParameter(request);
//
//            if (!CollectionUtils.isEmpty(attList)) {
//
//                Map<String, Object> map = new HashMap();
//                map.put("n_a_s", Integer.valueOf(1));
//                map.put("atts", attList);
//                map.put("parameter",parameter);
//                return this.ok(JSONUtil.toJSONString4Ajax(map));
//            } else {
//                return this.ok((Object) null);
//            }
//        } catch (Exception var22) {
//            return this.error(var22);
//        }
//    }
//
//    public static void main(String[] at){
//        System.out.println("000000");
//    }
//}
