package com.seeyon.apps.cindafundform.listener;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.JSONArray;

import com.alibaba.fastjson.JSONObject;
import com.iss.itreasury.wsService.approvalinfoimport.ApprovalImportServiceImplServiceLocator;
import com.iss.itreasury.wsService.approvalinfoimport.ApprovalImportServiceImplServiceSoapBindingStub;
import com.seeyon.apps.cindafundform.dao.CindaFundFormErrorInfoDao;
import com.seeyon.apps.cindafundform.po.CindaFundFormErrorInfo;
import com.seeyon.apps.cindafundform.utils.XmlExercise;
import com.seeyon.apps.collaboration.event.AbstractCollaborationEvent;
import com.seeyon.apps.collaboration.event.CollaborationFinishEvent;
import com.seeyon.apps.collaboration.event.CollaborationProcessEvent;
import com.seeyon.apps.collaboration.event.CollaborationStepBackEvent;
import com.seeyon.apps.collaboration.event.CollaborationStopEvent;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.po.comment.CtpCommentAll;
import com.seeyon.ctp.event.EventTriggerMode;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.HttpClientUtil;
import com.seeyon.ctp.util.annotation.ListenEvent;
import com.seeyon.v3x.services.ServiceException;
import com.seeyon.v3x.services.document.DocumentFactory;
import com.seeyon.v3x.services.flow.bean.FlowExport;
import com.seeyon.v3x.services.flow.bean.TextExport;
import com.seeyon.v3x.services.form.bean.FormExport;
import com.seeyon.v3x.services.form.bean.ValueExport;

/**
 * 流程审批结束或过程中点击回退，OA平台调用应答接口，返回审批结果及审批意见
 *
 * @author 范晓雷
 * @date 2017年07月03日
 *
 */
public class MyCollaborationEventListener {

  private final static Log log = LogFactory.getLog(MyCollaborationEventListener.class);

  private DocumentFactory documentFactory;

  private OrgManager orgManager;

  private CindaFundFormErrorInfoDao cindaFundFormErrorInfoDao;

  public CindaFundFormErrorInfoDao getCindaFundFormErrorInfoDao() {
	return cindaFundFormErrorInfoDao;
  }

  public void setCindaFundFormErrorInfoDao(CindaFundFormErrorInfoDao cindaFundFormErrorInfoDao) {
	this.cindaFundFormErrorInfoDao = cindaFundFormErrorInfoDao;
  }

  // fanxl delete 2017-09-05 start
  /*// 监听协同回退事件
  @ListenEvent(event = CollaborationStepBackEvent.class, async = true)
  public void onStepBack(CollaborationStepBackEvent event) {

		// gelb add  2017-8-2 17:55:18 异步提交，需要等一会儿再从数据库取值。
		ScheduledExecutorService scheduledThreadPool = Executors.newScheduledThreadPool(5);
		scheduledThreadPool.schedule(new Runnable() {
			  public void run() {
				  String postXmlData = "";
			      try {
				      String templateCode = event != null ? event.getTemplateCode() : null;
				      log.info("模板编号：" + event.getTemplateCode());
						String fundFormId = AppContext.getSystemProperty("cindafundform.fundFormId");
				      if (StringUtils.isNotEmpty(templateCode) && fundFormId.equals(templateCode))
				      {
					      postXmlData = getXmlInfo(getResultMap(event));
					      log.info("回调XML：" + postXmlData);

				 		  log.info("调用资金系统webService接口- start");
							ApprovalImportServiceImplServiceLocator service = new ApprovalImportServiceImplServiceLocator();
							ApprovalImportServiceImplServiceSoapBindingStub stub = (ApprovalImportServiceImplServiceSoapBindingStub) service.getApprovalImportServiceImplPort();
					      String result = stub.importApprovalService(postXmlData);
							log.info("调用资金系统webService接口- end: " + result);

							result = XmlExercise.xml2json(result);
					      JSONObject resultStr = JSONObject.parseObject(result);
					      if ("2".equals(resultStr.get("RACSTATE")))
					      {
				 	        log.warn("调用资金系统webService接口 未返回预期值！记录数据");
					          CindaFundFormErrorInfo record = new CindaFundFormErrorInfo();
					          record.setIdnum(resultStr.getString("APPLYCODE"));
					          record.setXmlData(postXmlData);
					          cindaFundFormErrorInfoDao.save(record);
					      } else {
				 	        	log.info("调用资金系统webService接口 成功！");
				 	        }
				      }
			      } catch (Exception e) {
			    	  log.warn("<协同流程处理事件监听发送内容失败，记录失败数据>" + e);
				      if (StringUtils.isNotEmpty(postXmlData)) {
					      CindaFundFormErrorInfo record = new CindaFundFormErrorInfo();
					      record.setXmlData(postXmlData);
					      cindaFundFormErrorInfoDao.save(record);
				      } else {
				    	  log.warn("postXmlData 为空！");
				      }
			      }
			  }
		  }, 2, TimeUnit.SECONDS);
  }*/
  // fanxl delete 2017-09-05 end
  
  //监听流程终止事件
  @ListenEvent(event = CollaborationStopEvent.class, async = true)
  public void onStepBack(final CollaborationStopEvent event) {

		// gelb add  2017-8-2 17:55:18 异步提交，需要等一会儿再从数据库取值。
		ScheduledExecutorService scheduledThreadPool = Executors.newScheduledThreadPool(5);
		scheduledThreadPool.schedule(new Runnable() {
			  public void run() {
				  String postXmlData = "";
			      try {
				      String templateCode = event != null ? event.getTemplateCode() : null;
				      log.info("模板编号：" + event.getTemplateCode());
						String fundFormId = AppContext.getSystemProperty("cindafundform.fundFormId");
				      if (StringUtils.isNotEmpty(templateCode) && fundFormId.equals(templateCode))
				      {
					      postXmlData = getXmlInfo(getResultMap(event));
					      log.info("回调XML：" + postXmlData);

				 		  log.info("调用资金系统webService接口- start");
							ApprovalImportServiceImplServiceLocator service = new ApprovalImportServiceImplServiceLocator();
							ApprovalImportServiceImplServiceSoapBindingStub stub = (ApprovalImportServiceImplServiceSoapBindingStub) service.getApprovalImportServiceImplPort();
					      String result = stub.importApprovalService(postXmlData);
							log.info("调用资金系统webService接口- end: " + result);

							result = XmlExercise.xml2json(result);
					      JSONObject resultStr = JSONObject.parseObject(result);
					      if ("2".equals(resultStr.get("RACSTATE")))
					      {
				 	        log.warn("调用资金系统webService接口 未返回预期值！记录数据");
					          CindaFundFormErrorInfo record = new CindaFundFormErrorInfo();
					          record.setIdnum(resultStr.getString("APPLYCODE"));
					          record.setXmlData(postXmlData);
					          cindaFundFormErrorInfoDao.save(record);
					      } else {
				 	        	log.info("调用资金系统webService接口 成功！");
				 	        }
				      }
			      } catch (Exception e) {
			    	  log.warn("<协同流程处理事件监听发送内容失败，记录失败数据>" + e);
				      if (StringUtils.isNotEmpty(postXmlData)) {
					      CindaFundFormErrorInfo record = new CindaFundFormErrorInfo();
					      record.setXmlData(postXmlData);
					      cindaFundFormErrorInfoDao.save(record);
				      } else {
				    	  log.warn("postXmlData 为空！");
				      }
			      }
			  }
		  }, 2, TimeUnit.SECONDS);
  }
  
  
  
  // 监听协同结束事件
  @ListenEvent(event = CollaborationFinishEvent.class, mode = EventTriggerMode.afterCommit)
  public void onFinish(final CollaborationFinishEvent event) {

		// gelb add  2017-8-2 17:55:18 异步提交，需要等一会儿再从数据库取值。
		ScheduledExecutorService scheduledThreadPool = Executors.newScheduledThreadPool(5);
		scheduledThreadPool.schedule(new Runnable() {
			  public void run() {
			    String postXmlData = "";
			    try {
			 	   String templateCode = event != null ? event.getTemplateCode() : null;
			 	   log.info("模板编号：" + event.getTemplateCode());
					String fundFormId = AppContext.getSystemProperty("cindafundform.fundFormId");
			 	   if (StringUtils.isNotEmpty(templateCode) && fundFormId.equals(templateCode))
			 	   {
			 		   postXmlData = getXmlInfo(getResultMap(event));
			 		   log.info("回调XML：" + postXmlData);

			 		  log.info("调用资金系统webService接口- start");
						ApprovalImportServiceImplServiceLocator service = new ApprovalImportServiceImplServiceLocator();
						ApprovalImportServiceImplServiceSoapBindingStub stub = (ApprovalImportServiceImplServiceSoapBindingStub) service.getApprovalImportServiceImplPort();
					   String result = stub.importApprovalService(postXmlData);
						log.info("调用资金系统webService接口- end: " + result);

						result = XmlExercise.xml2json(result);
				       JSONObject resultStr = JSONObject.parseObject(result);
				       if ("2".equals(resultStr.get("RACSTATE")))
				       {
				 	       log.warn("调用资金系统webService接口 未返回预期值！记录数据");
				           CindaFundFormErrorInfo record = new CindaFundFormErrorInfo();
				           record.setIdnum(resultStr.getString("APPLYCODE"));
				           record.setXmlData(postXmlData);
				           cindaFundFormErrorInfoDao.save(record);
				       } else {
			 	        	log.info("调用资金系统webService接口 成功！");
			 	        }
			 	   }
			    } catch (Exception e) {
			    	log.warn("<协同流程处理事件监听发送内容失败，记录失败数据>" + e);
				      if (StringUtils.isNotEmpty(postXmlData)) {
					      CindaFundFormErrorInfo record = new CindaFundFormErrorInfo();
					      record.setXmlData(postXmlData);
					      cindaFundFormErrorInfoDao.save(record);
				      } else {
				    	  log.warn("postXmlData 为空！");
				      }
			    }
			  }
		  }, 2, TimeUnit.SECONDS);
  }

  // 监听协同处理事件
  @ListenEvent(event = CollaborationProcessEvent.class, async = true)
  public void onProcess(final CollaborationProcessEvent event) {

	// gelb add  2017-8-2 17:55:18 异步提交，需要等一会儿再从数据库取值。
	ScheduledExecutorService scheduledThreadPool = Executors.newScheduledThreadPool(5);
	scheduledThreadPool.schedule(new Runnable() {
		  public void run() {
			  List<CtpCommentAll> comments = (List<CtpCommentAll>) DBAgent.find("from CtpCommentAll where moduleId = " + event.getSummaryId()
		        + " order by createDate desc");
			  log.info("获取的comments.size(): " + comments.size());
			  String postXmlData = "";
			    try {
			 	   String templateCode = event != null ? event.getTemplateCode() : null;
			 	   log.info("模板编号：" + event.getTemplateCode());
				   String fundFormId = AppContext.getSystemProperty("cindafundform.fundFormId");
			 	   if (StringUtils.isNotEmpty(templateCode) && fundFormId.equals(templateCode)
			 			   && StringUtils.equalsIgnoreCase(comments.get(0).getExtAtt1(), "collaboration.dealAttitude.disagree"))
			 	   {
			 		   log.info("审核不通过事件回调测试。");
			 		   postXmlData = getXmlInfo(getResultMap(event));
			 		   log.info("回调XML：" + postXmlData);

				 		  log.info("调用资金系统webService接口- start");
						ApprovalImportServiceImplServiceLocator service = new ApprovalImportServiceImplServiceLocator();
						ApprovalImportServiceImplServiceSoapBindingStub stub = (ApprovalImportServiceImplServiceSoapBindingStub) service.getApprovalImportServiceImplPort();
					   String result = stub.importApprovalService(postXmlData);
						log.info("调用资金系统webService接口- end: " + result);

						result = XmlExercise.xml2json(result);
				       JSONObject resultStr = JSONObject.parseObject(result);
				       if ("2".equals(resultStr.get("RACSTATE")))
				       {
				 	       log.warn("调用资金系统webService接口 未返回预期值！记录数据");
				           CindaFundFormErrorInfo record = new CindaFundFormErrorInfo();
				           record.setIdnum(resultStr.getString("APPLYCODE"));
				           record.setXmlData(postXmlData);
				           cindaFundFormErrorInfoDao.save(record);
				       } else {
			 	        	log.info("调用资金系统webService接口 成功！");
			 	        }
			 	   }
			    } catch (Exception e) {
			      log.warn("<协同流程处理事件监听发送内容失败，记录失败数据>" + e);
			      if (StringUtils.isNotEmpty(postXmlData)) {
				      CindaFundFormErrorInfo record = new CindaFundFormErrorInfo();
				      record.setXmlData(postXmlData);
				      cindaFundFormErrorInfoDao.save(record);
			      } else {
			    	  log.warn("postXmlData 为空！");
			      }
			    }
		  }
	  }, 2, TimeUnit.SECONDS);
  }

  private Boolean agreeOrRollback(CtpCommentAll entity) {
	  // 回退的情况，不管选择同意还是不同意。都是不同意
	  Boolean ret = Boolean.FALSE;
	  if (StringUtils.equalsIgnoreCase(entity.getExtAtt3(), "collaboration.dealAttitude.termination")) {
		  ret = Boolean.FALSE;
	  } else {
		  if (StringUtils.equalsIgnoreCase(entity.getExtAtt1(), "collaboration.dealAttitude.disagree")) {
			  ret = Boolean.FALSE;
		  } else {
			  ret = Boolean.TRUE;
		  }
	  }
	return ret;
  }

  private Map<String, Object> getResultMap(AbstractCollaborationEvent event) {
    log.info("<监听内容：>" + JSONObject.toJSONString(event));
    List<CtpCommentAll> comments =
        (List<CtpCommentAll>) DBAgent.find("from CtpCommentAll where moduleId = " + event.getSummaryId()
            + " order by createDate desc");
    log.info("<处理意见：>" + JSONObject.toJSONString(comments));
    Map<String, Object> result = new HashMap<String, Object>();
    result.put("summaryId", event.getSummaryId());

    // 最终审批状态
    result.put("laststatus",agreeOrRollback(comments.get(0)) ? "S" : "F");
    result.put("lastcontent", comments.get(0).getContent() ==null ?"":comments.get(0).getContent());
    result.put("comments", comments);
    // 取得申领单编号
    String declarationNum = "";
    try {
	    if (documentFactory == null) {
	      documentFactory = (DocumentFactory) AppContext.getBean("documentFactory");
	    }
	    FlowExport flowExport = documentFactory.exportFlow2("REST", event.getSummaryId());
	    TextExport content = flowExport.getFlowContent();
	    if (content instanceof FormExport) {
	      FormExport fe = (FormExport) content;
	      if (fe != null && CollectionUtils.isNotEmpty(fe.getValues()))
	      {
	    	 for (ValueExport valueExport : fe.getValues())
	    	 {
	    		 if ("申领单编号".equals(valueExport.getDisplayName()))
	    		 {
	    			 declarationNum = valueExport.getValue();
	    			 break;
	    		 }
	    	 }
	      }
	    }
	} catch (ServiceException e) {
		log.error("documentFactory.exportFlow2 异常：" + e);
	    e.printStackTrace();
	} catch (Exception e) {
		log.error("Exception：" + e);
	    e.printStackTrace();
	}
    result.put("declarationNum", declarationNum);

    log.info("<返回的处理结果>" + result);
    return result;
  }

  /**
   * 调用资金系统提供的接口进行信息传递。
   *
   * @param result
   */
  private void saveResultToFoudSystem(Map<String, Object> result) throws BusinessException {

    String response = HttpClientUtil.getContent(AppContext.getSystemProperty("cindafundform.getTokenUrl"));
    log.info("<资金系统获取token>" + response);
    String token = JSONObject.parseObject(response).getString("data");
    String eipId = result.get("summaryId").toString();
    int status = Integer.parseInt(result.get("status").toString());

    log.info("资金系统回传表单参数<token><eipId><status><content>" + token + "," + eipId + "," + status + ","
        + result.get("content"));
    HttpClientUtil client = new HttpClientUtil();
    try {
      client.open(AppContext.getSystemProperty("cindafundform.callbackUrl"), "post");
      client.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");
      client.addParameter("token", token);
      client.addParameter("eipId", eipId);
      client.addParameter("status", String.valueOf(status));
      client.addParameter("content", result.get("content")==null?"":result.get("content").toString());
      client.send();
      response = client.getResponseBodyAsString("utf8");
      log.info("<资金系统回传表单审批结果>" + response);
      JSONObject json = JSONObject.parseObject(response);
      // 1=接收成功,2=接收失败
      if (!json.getBoolean("success")) {
        log.info("<资金系统回传表单审批结果失败>");
        throw new BusinessException("资金系统回传表单审批结果失败");
      }
    } catch (Exception e) {
      throw new BusinessException("资金系统回传表单审批结果失败:调用接口失败");
    } finally {
      client.close();
    }
  }

  /**
   * 拼接传送XML报文。
   *
   * @param result
 * @throws Exception
   */
  private String getXmlInfo(Map<String, Object> result) throws Exception {

	  String declarationNum = result.get("declarationNum") != null ? result.get("declarationNum").toString() : "";
	  String laststutas = result.get("laststatus") != null ? result.get("laststatus").toString() : "";
	  List<CtpCommentAll> comments = (List<CtpCommentAll>)result.get("comments");
	  List<Map<String, Object>> files = new ArrayList<>();

      StringBuilder sb = new StringBuilder();
      sb.append("<?xml version='1.0' encoding='UTF-8'?>");
      sb.append("<ApprovalStatus>");
      // <!--申领单编号-->
      sb.append("<APPLYCODE>");
      sb.append(declarationNum);
      sb.append("</APPLYCODE>");
      // <!--最终审批状态-->
      sb.append("<LASTSTATE>");
      sb.append(laststutas);
      sb.append("</LASTSTATE>");
      // 审批状态审批人Start*******
      sb.append("<APPSTATES>");
      for (CtpCommentAll ctpComment : comments)
      {
          sb.append("<APPSTATE>");
          // <!--审批状态-->
          sb.append("<APPSTATE>");
          sb.append(agreeOrRollback(ctpComment) ? 1 : 2);
          sb.append("</APPSTATE>");
          // <!--审批人-->
          sb.append("<APPUSER>");
          if (orgManager == null) {
        	  orgManager = (OrgManager) AppContext.getBean("orgManager");
          }
          V3xOrgMember member= orgManager.getMemberById(ctpComment.getCreateId());
          String appuser = "";
          if (member != null) {
        	  appuser = member.getName();
          }
          sb.append(appuser);
          sb.append("</APPUSER>");
          // <!--审批意见-->
          sb.append("<APPMESS>");
          sb.append(ctpComment.getContent() == null ? "" : ctpComment.getContent());
          sb.append("</APPMESS>");
          // <!--审批时间-->
          sb.append("<APPTIME>");
          sb.append(ctpComment.getCreateDate());
          sb.append("</APPTIME>");
          sb.append("</APPSTATE>");

          String relateAttr = String.valueOf(ctpComment.getRelateInfo());
          if (StringUtils.isNotEmpty(relateAttr) && !"[]".equals(relateAttr)|| !"null".equals(relateAttr)){
        	  JSONArray array = new JSONArray(relateAttr);
              org.json.JSONObject object = null;
              for (int i = 0; i < array.length(); i++) {
            	  Map<String, Object> file = new HashMap<String, Object>();
                  object = array.getJSONObject(i);

                  // gelb 2017-8-3 19:09:11 返回 文件名和fieldId。提供下载服务，以供资金表单去下载。
                  /*
                  String[] urls = new String[1];
                  urls[0] = object.getString("fileUrl");

                  String[] createDates = new String[1];
                  createDates[0] = object.getString("createdate");

                  String[] mimeTypes = new String[1];
                  mimeTypes[0] = object.getString("mimeType");
                  String[] names = new String[1];
                  names[0] = object.getString("filename");

                  String filePath = getDirectory(urls, createDates, mimeTypes, names);
                  log.info(filePath);
                  */

                  file.put("filename", object.getString("filename"));
                  //file.put("filePath", filePath);
                  file.put("filePath", object.getString("fileUrl"));
                  files.add(file);
              }
          }
      }
      sb.append("</APPSTATES>");
      // 审批状态审批人End*******
      // 附件Start*******
      sb.append("<APPFILES>");
      if (files != null && files.size() > 0)
      {
          for (Map<String, Object> file : files)
          {
              sb.append("<FILE>");
              // <!--附件名称-->
              sb.append("<APPFILENAME>");
              sb.append(file.get("filename"));
              sb.append("</APPFILENAME>");
              // <!--附件地址-->
              sb.append("<APPFILEADD>");
              sb.append(file.get("filePath"));
              sb.append("</APPFILEADD>");
              sb.append("</FILE>");
          }
      }
      sb.append("</APPFILES>");
      // 附件End*******
      sb.append("</ApprovalStatus>");
      return sb.toString();
  }

  /**
   * 获取附件的物理路径
   *
   * @param urls
   * @param createDates
   * @param mimeTypes
   * @param names
   * @return
   * @throws Exception
   */
  private static String getDirectory(String[] urls, String[] createDates, String[] mimeTypes, String[] names)
          throws Exception {

      File file = null;
      try {
          for (int i = 0; i < urls.length; i++) {
              Long fileId = Long.parseLong(urls[i]);

              Date createDate = null;
              if (createDates[i].length() > 10)
                  createDate = Datetimes.parseDatetime(createDates[i]);
              else
                  createDate = Datetimes.parseDate(createDates[i]);

              FileManager fileManager = (FileManager) AppContext.getBean("fileManager");
              file = fileManager.getFile(fileId, createDate);
              if (null == file)
                  return "";
          }
      } catch (Exception e) {
    	  log.error("获取附件路径出错", e);
          return "";
      }

      return file.getPath();
  }
}
