////
//// Source code recreated from a .class file by IntelliJ IDEA
//// (powered by Fernflower decompiler)
////
//
//package com.seeyon.ctp.rest.resources;
//
//import com.seeyon.cap4.template.service.CAPBatchOperationService;
//import com.seeyon.cap4.template.service.CAPFormDataService;
//import com.seeyon.cap4.template.service.CAPFormToCollService;
//import com.seeyon.cap4.template.service.CAPScreenCaptureService;
//import com.seeyon.cap4.template.util.CAPParamUtil;
//import com.seeyon.ctp.common.AppContext;
//import java.util.HashMap;
//import java.util.Map;
//import javax.servlet.http.HttpServletResponse;
//import javax.ws.rs.Consumes;
//import javax.ws.rs.GET;
//import javax.ws.rs.POST;
//import javax.ws.rs.Path;
//import javax.ws.rs.PathParam;
//import javax.ws.rs.Produces;
//import javax.ws.rs.core.Response;
//
//@Path("cap4/form")
//@Consumes({"application/json"})
//@Produces({"application/json"})
//public class CAP4FormResource extends BaseResource {
//    CAPFormDataService capFormDataService = (CAPFormDataService)AppContext.getBean("capFormDataService");
//    CAPBatchOperationService capBatchOperationService = (CAPBatchOperationService)AppContext.getBean("capBatchOperationService");
//    CAPScreenCaptureService capScreenCaptureService = (CAPScreenCaptureService)AppContext.getBean("capScreenCaptureService");
//    CAPFormToCollService capFormToCollService = (CAPFormToCollService)AppContext.getBean("capFormToCollService");
//
//    public CAP4FormResource() {
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("subDataIsEmpty")
//    public Response subDataIsEmpty(Map<String, Object> params) {
//        return this.success(this.capFormDataService.subDataIsEmpty(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("checkLock")
//    public Response checkLock(Map<String, Object> params) {
//        return this.success(this.capFormDataService.checkLock(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("validUnflowOperation")
//    public Response validUnflowOperation(Map<String, Object> params) {
//        return this.success(this.capFormDataService.validUnflowOperation(params));
//    }
//
//    @GET
//    @Produces({"application/json"})
//    @Path("getExcelSheets/{fileId}")
//    public Response getExcelSheets(@PathParam("fileId") String fileId) {
//        return this.success(this.capBatchOperationService.getExcelSheets(fileId));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("importFormExcelDatas")
//    public Response importFormExcelDatas(Map<String, Object> params) {
//        return this.success(this.capBatchOperationService.importFormExcelDatas(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("updateFormExcelDatas")
//    public Response updateFormExcelDatas(Map<String, Object> params) {
//        return this.success(this.capBatchOperationService.updateFormExcelDatas(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("getFormExcelDatas")
//    public Response getFormExcelDatas(Map<String, Object> params) {
//        return this.success(this.capBatchOperationService.getFormExcelDatas(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("transFormExcelDatas")
//    public Response transFormExcelDatas(Map<String, Object> params) {
//        return this.success(this.capBatchOperationService.transFormExcelDatas(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("transBatchDoTrigger")
//    public Response transBatchDoTrigger(Map<String, Object> params) {
//        return this.success(this.capBatchOperationService.transBatchDoTrigger(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("exportUnflowExcel")
//    public Response exportUnflowExcel(Map<String, Object> params) {
//        return this.success(this.capBatchOperationService.exportUnflowExcel(params, (HttpServletResponse)null));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("deleteBatchOperationData")
//    public Response deleteBatchOperationData(Map<String, Object> params) {
//        return this.success(this.capBatchOperationService.deleteBatchOperationData(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("updateBatchOperationData")
//    public Response updateBatchOperationData(Map<String, Object> params) {
//        return this.success(this.capBatchOperationService.updateBatchOperationData(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("updateBatchRefreshData")
//    public Response updateBatchRefreshData(Map<String, Object> params) {
//        return this.success(this.capBatchOperationService.updateBatchRefreshData(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("deleteTempData")
//    public Response deleteTempData(Map<String, Object> params) {
//        return this.success(this.capBatchOperationService.deleteTempData(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("transDoForward")
//    public Response transDoForward(Map<String, Object> params) {
//        return this.success(this.capFormToCollService.transDoForward(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("deleteAffair")
//    public Response deleteAffair(Map<String, Object> params) {
//        return this.success(this.capFormToCollService.deleteAffair(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("takeBack")
//    public Response takeBack(Map<String, Object> params) {
//        return this.success(this.capFormToCollService.takeBack(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("checkTakeBack")
//    public Response checkTakeBack(Map<String, Object> params) {
//        return this.success(this.capFormToCollService.checkTakeBack(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("transRepeal")
//    public Response transRepeal(Map<String, Object> params) {
//        return this.success(this.capFormToCollService.transRepeal(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("checkTransRepeal")
//    public Response checkTransRepeal(Map<String, Object> params) {
//        return this.success(this.capFormToCollService.checkTransRepeal(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("transSendColl")
//    public Response transSendColl(Map<String, Object> params) {
//        return this.success(this.capFormToCollService.transSendColl(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("checkForwardPermission")
//    public Response checkForwardPermission(Map<String, Object> params) {
//        return this.success(this.capFormToCollService.checkForwardPermission(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("sendFromWait")
//    public Response sendFromWait(Map<String, Object> params) {
//        return this.success(this.capFormToCollService.sendFromWait(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("finishWorkItem")
//    public Response finishWorkItem(Map<String, Object> params) {
//        return this.success(this.capFormToCollService.finishWorkItem(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("transStepBack")
//    public Response transStepBack(Map<String, Object> params) {
//        return this.success(this.capFormToCollService.transStepBack(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("dealSelectedRelationData")
//    public Response dealSelectedRelationData(Map<String, Object> params) {
//        return this.success(this.capFormDataService.dealSelectedRelationData(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("getFormRelationDatas")
//    public Response getFormRelationDatas(Map<String, Object> params) {
//        return this.success(this.capFormDataService.getFormRelationDatas(params));
//    }
//
//    /** @deprecated */
//    @POST
//    @Produces({"application/json"})
//    @Path("getRelationThroughParams")
//    @Deprecated
//    public Response getRelationThroughParams(Map<String, Object> params) {
//        return this.success(this.capFormDataService.getRelationThroughParams(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("delFormData")
//    public Response delFormData(Map<String, Object> params) {
//        return this.success(this.capFormDataService.delFormData(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("setLockOrUnlock")
//    public Response setLockOrUnlock(Map<String, Object> params) {
//        return this.success(this.capFormDataService.setLockOrUnlock(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("createOrEdit")
//    public Response createOrEdit(Map<String, Object> params) {
//        Map<String,Object> result =  this.capFormDataService.createOrEditForm(params);
//        if("2011".equals(result.get("code"))&& "42".equals(CAPParamUtil.getString(params, "moduleType"))){
//            result.put("code", "2000");
//            result.put("message", "this option is success!");
//        }
//        return this.success(result);
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("saveOrUpdate")
//    public Response save(Map<String, Object> params) {
//        return this.success(this.capFormDataService.saveOrUpdateForm(params));
//    }
//
//    @GET
//    @Produces({"application/json"})
//    @Path("removeSessionFormCache/{contentDataId}")
//    public Response removeSessionFormCache(@PathParam("contentDataId") String contentDataId) {
//        return this.success(this.capFormDataService.removeSessionFormCache(contentDataId));
//    }
//
//    @GET
//    @Produces({"application/json"})
//    @Path("getCapBizConfigs")
//    public Response getCapBizConfigs() {
//        return this.success(this.capFormDataService.getCapBizConfigs());
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("calculate")
//    public Response calculate(Map<String, Object> params) {
//        return this.success(this.capFormDataService.calculate(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("addOrDelDataSubBean")
//    public Response addOrDelDataSubBean(Map<String, Object> params) {
//        return this.success(this.capFormDataService.addOrDelDataSubBean(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("addOrDelAttachment")
//    public Response addOrDelAttachment(Map<String, Object> params) {
//        return this.success(this.capFormDataService.addOrDelAttachment(params));
//    }
//
//    @GET
//    @Produces({"application/json"})
//    @Path("getScreenCapture")
//    public Response getScreenCapture() {
//        Map<String, Object> screenParams = new HashMap();
//        screenParams.put("type", Integer.valueOf(6));
//        screenParams.put("width", Integer.valueOf(300));
//        screenParams.put("height", Integer.valueOf(300));
//        String url = "http://localhost:8080/seeyon/cap4/businessTemplateController.do?method=formContent#/browse?rightId=-6629350744509365681&moduleId=6571552404902713764&formTemplateId=-5555892924675043835&moduleType=42";
//        Map<String, Object> params = new HashMap();
//        params.put("url", url);
//        params.put("screenParams", screenParams);
//        return this.success(this.capScreenCaptureService.doScreenCaptureToCache(params));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("doScreenCapture")
//    public Response doScreenCapture(Map<String, Object> params) {
//        return this.success(this.capScreenCaptureService.doScreenCaptureToCache(params));
//    }
//
//    @GET
//    @Produces({"application/json"})
//    @Path("getScreenCaptureImgBase64/{imgBase64Key}")
//    public Response getScreenCaptureImgBase64(@PathParam("imgBase64Key") String imgBase64Key) {
//        return this.success(this.capScreenCaptureService.getScreenCaptureImgBase64(imgBase64Key));
//    }
//
//    @POST
//    @Produces({"application/json"})
//    @Path("doFormScreenCapture")
//    public Response doFormScreenCapture(Map<String, Object> params) {
//        return this.success(this.capScreenCaptureService.doFormDataContentScreenCapture(params));
//    }
//    public static void main(String[] args){
//        System.out.println("TEST");
//    }
//}
