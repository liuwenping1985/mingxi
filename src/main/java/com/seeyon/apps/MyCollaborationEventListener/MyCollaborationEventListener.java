package com.seeyon.apps.MyCollaborationEventListener;

import java.net.URL;
import java.sql.SQLException;

import javax.xml.namespace.QName;

import org.apache.axis.client.Call;
import org.apache.axis.client.Service;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.collaboration.event.CollaborationFinishEvent;
import com.seeyon.apps.collaboration.event.CollaborationStartEvent;
import com.seeyon.apps.collaboration.manager.ColManager;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.template.CtpTemplate;
import com.seeyon.ctp.common.template.manager.TemplateManager;
import com.seeyon.ctp.event.EventTriggerMode;
import com.seeyon.ctp.form.bean.FormDataMasterBean;
import com.seeyon.ctp.form.service.FormService;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.annotation.ListenEvent;
import com.seeyon.v3x.dee.util.rest.CTPRestClient;
import com.seeyon.v3x.dee.util.rest.CTPServiceClientManager;
import com.seeyon.v3x.services.V3XLocator;

public class MyCollaborationEventListener
{
  private static final Log log = LogFactory.getLog(MyCollaborationEventListener.class);
  private Long summaryId;
  private ColManager colManager;

  public ColManager getColManager()
  {
    return this.colManager;
  }

  public void setColManager(ColManager colManager) {
    this.colManager = colManager;
  }

  public Long getSummaryId()
  {
    return this.summaryId;
  }

  public void setSummaryId(Long summaryId) {
    this.summaryId = summaryId;
  }

  private String getTempleteNumberBySummaryId(Long summaryId) {
    try {
      ColManager colManager = (ColManager)
        AppContext.getBean("colManager");
      TemplateManager templeteManager = (TemplateManager)V3XLocator.getInstance().lookup(
        TemplateManager.class);
      ColSummary summary = colManager.getColSummaryById(summaryId);
      if ((summary != null) && (summary.getTempleteId() != null)) {
        CtpTemplate template = templeteManager.getCtpTemplate(summary
          .getTempleteId());
        if (template != null) {
          String temNumber = template.getTempleteNumber();
          log.info("获得流程:" + summaryId + "对应的模板编号为：" + temNumber);
          return temNumber;
        }	
      }
    } catch (Exception e) {
      log.error("获得流程:'：" + summaryId + "'对应的模版名称时发生异常", e);
    }
    return null;
  }

  @ListenEvent(event=CollaborationStartEvent.class, mode=EventTriggerMode.afterCommit)
  public void CollaborationStartEvent(CollaborationStartEvent event) throws BusinessException, SQLException {
    
    
	 log.info("进去表单发起！");
    String url = "";
    Long summaryId = event.getSummaryId();
    ColSummary summaryById = this.colManager.getSummaryById(summaryId);
    Long startMemberId = summaryById.getStartMemberId();
    OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
    V3xOrgMember memberById = orgManager.getMemberById(startMemberId);
    String loginName = memberById.getLoginName();
   /// startMemberId
    Boolean re = Boolean.valueOf(false);
    int c = 0;
    String TemplateNumber = AppContext.getSystemProperty("BDJT.templateNumber");
    if (TemplateNumber.indexOf("|") > -1) {
      String[] split = TemplateNumber.split("\\|");
      for (int i = 0; i < split.length; i++) {
        if (split[i].equals(event.getTemplateCode())) {
          re = Boolean.valueOf(true);
          c = i;
        }
      }
    }
    else if (TemplateNumber.equals(event.getTemplateCode())) {
      re = Boolean.valueOf(true);
    }

    if (re.booleanValue()) {
      url = AppContext.getSystemProperty("BDJT.Address") + "/seeyon/ssooa.jsp?from=1&ticket="+loginName+"&app=1&affairId=" + event.getAffair().getId();
      log.info("表单发起获取已办链接：" + url);

      FormDataMasterBean findDataById = FormService.findDataById(summaryById.getFormRecordid().longValue(), summaryById.getFormAppid().longValue());

      Object fieldValue = null;
      if ((TemplateNumber.split("\\|")[c].equals("UserApply")) || (TemplateNumber.split("\\|")[c].equals("UserRecovery")))
        fieldValue = findDataById.getFieldValue(AppContext.getSystemProperty("BDJT.FormData").split("\\|")[0]);
      else if (TemplateNumber.split("\\|")[c].equals("cinda_UserRecovery"))
        fieldValue = findDataById.getFieldValue(AppContext.getSystemProperty("BDJT.FormData").split("\\|")[2]);
      else {
        fieldValue = findDataById.getFieldValue(AppContext.getSystemProperty("BDJT.FormData").split("\\|")[1]);
      }
      log.info("调用第三方接口：第三方审批编号:" + fieldValue.toString());
      testAuditServ(url, fieldValue.toString(), "noticeAuditUrl");      										
    }
  }

  @ListenEvent(event=CollaborationFinishEvent.class,mode=EventTriggerMode.afterCommit)
  public void CollaborationFinishEvent(CollaborationFinishEvent event) throws BusinessException, SQLException
  {
    log.info("进去表单结束！");

    Boolean re = Boolean.valueOf(false);
    int c = 0;
    String TemplateNumber = AppContext.getSystemProperty("BDJT.templateNumber");
    if (TemplateNumber.indexOf("|") > -1) {
      String[] split = TemplateNumber.split("\\|");
      for (int i = 0; i < split.length; i++) {
        if (split[i].equals(event.getTemplateCode())) {
          re = Boolean.valueOf(true);
          c = i;
        }
      }
    }
    else if (TemplateNumber.equals(event.getTemplateCode())) {
      re = Boolean.valueOf(true);
    }

    if (re.booleanValue()) {
      ColSummary summaryById = this.colManager.getSummaryById(event.getSummaryId());
      CTPServiceClientManager manager = CTPServiceClientManager.getInstance(AppContext.getSystemProperty("BDJT.Address"));
      CTPRestClient restClient = manager.getRestClient();
      restClient.authenticate(AppContext.getSystemProperty("BDJT.UserName"), AppContext.getSystemProperty("BDJT.PassWord"));
      Long summaryId = event.getSummaryId();

      String url = "/flow/state/";
      String state = (String)restClient.get(url + summaryId, String.class);
      log.info("++state+++" + state);

      if (state.equals("0"))
        state = "1";
      else {
        state = "0";
      }

      FormDataMasterBean findDataById = FormService.findDataById(summaryById.getFormRecordid().longValue(), summaryById.getFormAppid().longValue());

      Object fieldValue = null;
      if ((TemplateNumber.split("\\|")[c].equals("UserApply")) || (TemplateNumber.split("\\|")[c].equals("UserRecovery")))
        fieldValue = findDataById.getFieldValue(AppContext.getSystemProperty("BDJT.FormData").split("\\|")[0]);
      else if (TemplateNumber.split("\\|")[c].equals("cinda_UserRecovery"))
        fieldValue = findDataById.getFieldValue(AppContext.getSystemProperty("BDJT.FormData").split("\\|")[2]);
      else {
        fieldValue = findDataById.getFieldValue(AppContext.getSystemProperty("BDJT.FormData").split("\\|")[1]);
      }
      log.info("调用第三方接口：第三方审批编号:" + fieldValue.toString() + "返回状态值：" + state);
      testAuditServ(state, fieldValue.toString(), "noticeAuditResult");
    }
  }


  @ListenEvent(event=com.seeyon.apps.collaboration.event.CollaborationStopEvent.class,mode=EventTriggerMode.afterCommit)
  public void CollaborationStopEvent(com.seeyon.apps.collaboration.event.CollaborationStopEvent event) throws BusinessException, SQLException
  {
    log.info("流程终止！");

    Boolean re = Boolean.valueOf(false);
    int c = 0;
    String TemplateNumber = AppContext.getSystemProperty("BDJT.templateNumber");
    if (TemplateNumber.indexOf("|") > -1) {
      String[] split = TemplateNumber.split("\\|");
      for (int i = 0; i < split.length; i++) {
        if (split[i].equals(event.getTemplateCode())) {
          re = Boolean.valueOf(true);
          c = i;
        }
      }
    }
    else if (TemplateNumber.equals(event.getTemplateCode())) {
      re = Boolean.valueOf(true);
    }

    if (re.booleanValue()) {
      ColSummary summaryById = this.colManager.getSummaryById(event.getSummaryId());
    //  log.info("++state+++" + state);

       String  state = "0";
  
      FormDataMasterBean findDataById = FormService.findDataById(summaryById.getFormRecordid().longValue(), summaryById.getFormAppid().longValue());

      Object fieldValue = null;
      if ((TemplateNumber.split("\\|")[c].equals("UserApply")) || (TemplateNumber.split("\\|")[c].equals("UserRecovery")))
        fieldValue = findDataById.getFieldValue(AppContext.getSystemProperty("BDJT.FormData").split("\\|")[0]);
      else if (TemplateNumber.split("\\|")[c].equals("cinda_UserRecovery"))
        fieldValue = findDataById.getFieldValue(AppContext.getSystemProperty("BDJT.FormData").split("\\|")[2]);
      else {
        fieldValue = findDataById.getFieldValue(AppContext.getSystemProperty("BDJT.FormData").split("\\|")[1]);
      }
      log.info("调用第三方接口：第三方审批编号:" + fieldValue.toString() + "返回状态值：" + state);
      testAuditServ(state, fieldValue.toString(), "noticeAuditResult");
    }
  }
  
  @ListenEvent(event=com.seeyon.apps.collaboration.event.CollaborationCancelEvent.class,mode=EventTriggerMode.afterCommit)
  public void CollaborationCancelEvent(com.seeyon.apps.collaboration.event.CollaborationCancelEvent event) throws BusinessException, SQLException
  {
    log.info("流程撤销！");//流程处理事件

    Boolean re = Boolean.valueOf(false);
    int c = 0;
    String TemplateNumber = AppContext.getSystemProperty("BDJT.templateNumber");
    if (TemplateNumber.indexOf("|") > -1) {
      String[] split = TemplateNumber.split("\\|");
      for (int i = 0; i < split.length; i++) {
        if (split[i].equals(event.getTemplateCode())) {
          re = Boolean.valueOf(true);
          c = i;
        }
      }
    }
    else if (TemplateNumber.equals(event.getTemplateCode())) {
      re = Boolean.valueOf(true);
    }

    if (re.booleanValue()) {
      ColSummary summaryById = this.colManager.getSummaryById(event.getSummaryId());
      CTPServiceClientManager manager = CTPServiceClientManager.getInstance(AppContext.getSystemProperty("BDJT.Address"));
      CTPRestClient restClient = manager.getRestClient();
      restClient.authenticate(AppContext.getSystemProperty("BDJT.UserName"), AppContext.getSystemProperty("BDJT.PassWord"));
      Long summaryId = event.getSummaryId();

      String url = "/flow/state/";
      String state = (String)restClient.get(url + summaryId, String.class);
      log.info("++state+++" + state);
      if(state.equals("5")||state.equals("15")){
	       state = "0";
	  
	      FormDataMasterBean findDataById = FormService.findDataById(summaryById.getFormRecordid().longValue(), summaryById.getFormAppid().longValue());
	
	      Object fieldValue = null;
	      if ((TemplateNumber.split("\\|")[c].equals("UserApply")) || (TemplateNumber.split("\\|")[c].equals("UserRecovery")))
	        fieldValue = findDataById.getFieldValue(AppContext.getSystemProperty("BDJT.FormData").split("\\|")[0]);
	      else if (TemplateNumber.split("\\|")[c].equals("cinda_UserRecovery"))
	        fieldValue = findDataById.getFieldValue(AppContext.getSystemProperty("BDJT.FormData").split("\\|")[2]);
	      else {
	        fieldValue = findDataById.getFieldValue(AppContext.getSystemProperty("BDJT.FormData").split("\\|")[1]);
	      }
	      log.info("调用第三方接口：第三方审批编号:" + fieldValue.toString() + "返回状态值：" + state);
	      testAuditServ(state, fieldValue.toString(), "noticeAuditResult");
      }
    }
  }
  
  
  
  public static void testAuditServ(String state, String spID, String Methoed) {
	    Object invoke = null;
	    try
	    {
	      String wsdlUrl = AppContext.getSystemProperty("BDJT.URL") + "?wsdl";
	      String nameSpaceUri = AppContext.getSystemProperty("BDJT.URL");

	      Service service = new Service();
	      Call call = (Call)service.createCall();

	      call.setTargetEndpointAddress(new URL(wsdlUrl));
	      call.setOperationName(new QName(nameSpaceUri, Methoed));

	      if (Methoed.equals("noticeAuditResult"))
	      {
	        invoke = call.invoke(new Object[] { spID, state });
	      }
	      else invoke = call.invoke(new Object[] { state, spID });

	      log.info("++++++" + invoke.toString());
	    } catch (Exception e) {
	      log.error("MyCollaborationEventListener--监听返回异常 : ", e);
	      e.printStackTrace();
	    }
	  }
  
  
  /*
  @ListenEvent(event=CollaborationFinishEvent.class,mode=EventTriggerMode.afterCommit)
  public void CollaborationStepBackEvent (CollaborationFinishEvent event) throws BusinessException, SQLException
  {
    log.info("！");

    Boolean re = Boolean.valueOf(false);
    int c = 0;
    String TemplateNumber = AppContext.getSystemProperty("BDJT.templateNumber");
    if (TemplateNumber.indexOf("|") > -1) {
      String[] split = TemplateNumber.split("\\|");
      for (int i = 0; i < split.length; i++) {
        if (split[i].equals(event.getTemplateCode())) {
          re = Boolean.valueOf(true);
          c = i;
        }
      }
    }
    else if (TemplateNumber.equals(event.getTemplateCode())) {
      re = Boolean.valueOf(true);
    }

    if (re.booleanValue()) {
      ColSummary summaryById = this.colManager.getSummaryById(event.getSummaryId());
      String state;
    //  log.info("++state+++" + state);

        state = "0";
  
      FormDataMasterBean findDataById = FormService.findDataById(summaryById.getFormRecordid().longValue(), summaryById.getFormAppid().longValue());

      Object fieldValue = null;
      if ((TemplateNumber.split("\\|")[c].equals("UserApply")) || (TemplateNumber.split("\\|")[c].equals("UserRecovery")))
        fieldValue = findDataById.getFieldValue(AppContext.getSystemProperty("BDJT.FormData").split("\\|")[0]);
      else if (TemplateNumber.split("\\|")[c].equals("cinda_UserRecovery"))
        fieldValue = findDataById.getFieldValue(AppContext.getSystemProperty("BDJT.FormData").split("\\|")[2]);
      else {
        fieldValue = findDataById.getFieldValue(AppContext.getSystemProperty("BDJT.FormData").split("\\|")[1]);
      }
      log.info("调用第三方接口：第三方审批编号:" + fieldValue.toString() + "返回状态值：" + state);
      testAuditServ(state, fieldValue.toString(), "noticeAuditResult");
    }
  }
  */
  
  
  
  
}