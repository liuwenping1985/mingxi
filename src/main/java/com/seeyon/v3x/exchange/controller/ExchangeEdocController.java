package com.seeyon.v3x.exchange.controller;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.util.CollectionUtils;
import org.springframework.web.servlet.ModelAndView;

import www.seeyon.com.utils.UUIDUtil;

import com.seeyon.apps.agent.bo.AgentModel;
import com.seeyon.apps.agent.bo.MemberAgentBean;
import com.seeyon.apps.cindaedoc.manager.CindaedocManager;
import com.seeyon.apps.cindaedoc.po.EdocDetailMsgid;
import com.seeyon.apps.cindaedoc.po.EdocFileInfo;
import com.seeyon.apps.cindaedoc.untils.EdocExClient;
import com.seeyon.apps.cindaedoc.untils.TransPDF;
import com.seeyon.apps.collaboration.util.ColUtil;
import com.seeyon.apps.edoc.enums.EdocEnum;
import com.seeyon.apps.sursenexchange.api.SursenExchangeApi;
import com.seeyon.apps.xc.client.AuthorityServiceStub;
import com.seeyon.client.CTPRestClient;
import com.seeyon.client.CTPServiceClientManager;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.config.manager.ConfigManager;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.AffairUtil;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.content.affair.constants.SubStateEnum;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.ctpenumnew.EnumNameEnum;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.filemanager.manager.Util;
import com.seeyon.ctp.common.flag.BrowserFlag;
import com.seeyon.ctp.common.i18n.ResourceBundleUtil;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.operationlog.manager.OperationlogManager;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumBean;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.common.usermessage.Constants.LinkOpenType;
import com.seeyon.ctp.common.usermessage.MessageContent;
import com.seeyon.ctp.common.usermessage.MessageReceiver;
import com.seeyon.ctp.common.usermessage.UserMessageManager;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.util.ZipUtil;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;
import com.seeyon.v3x.common.exceptions.MessageException;
import com.seeyon.v3x.common.taglibs.functions.Functions;
import com.seeyon.v3x.common.web.login.CurrentUser;
import com.seeyon.v3x.edoc.constants.EdocNavigationEnum;
import com.seeyon.v3x.edoc.domain.EdocBody;
import com.seeyon.v3x.edoc.domain.EdocMarkDefinition;
import com.seeyon.v3x.edoc.domain.EdocObjTeam;
import com.seeyon.v3x.edoc.domain.EdocObjTeamMember;
import com.seeyon.v3x.edoc.domain.EdocRegister;
import com.seeyon.v3x.edoc.domain.EdocSubjectWrapRecord;
import com.seeyon.v3x.edoc.domain.EdocSummary;
import com.seeyon.v3x.edoc.domain.RegisterBody;
import com.seeyon.v3x.edoc.enums.EdocMessageFilterParamEnum;
import com.seeyon.v3x.edoc.exception.EdocException;
import com.seeyon.v3x.edoc.manager.EdocHelper;
import com.seeyon.v3x.edoc.manager.EdocLockManager;
import com.seeyon.v3x.edoc.manager.EdocManager;
import com.seeyon.v3x.edoc.manager.EdocMarkDefinitionManager;
import com.seeyon.v3x.edoc.manager.EdocRegisterManager;
import com.seeyon.v3x.edoc.manager.EdocRoleHelper;
import com.seeyon.v3x.edoc.manager.EdocSummaryManager;
import com.seeyon.v3x.edoc.manager.EdocSummaryRelationManager;
import com.seeyon.v3x.edoc.manager.EdocSwitchHelper;
import com.seeyon.v3x.edoc.util.EactionType;
import com.seeyon.v3x.edoc.util.EdocUtil;
import com.seeyon.v3x.edoc.webmodel.EdocMarkModel;
import com.seeyon.v3x.exchange.dao.EdocSendDetailDao;
import com.seeyon.v3x.exchange.domain.EdocExchangeTurnRec;
import com.seeyon.v3x.exchange.domain.EdocRecieveRecord;
import com.seeyon.v3x.exchange.domain.EdocSendDetail;
import com.seeyon.v3x.exchange.domain.EdocSendRecord;
import com.seeyon.v3x.exchange.domain.ExchangeAccount;
import com.seeyon.v3x.exchange.enums.EdocExchangeMode.EdocExchangeModeEnum;
import com.seeyon.v3x.exchange.manager.EdocExchangeManager;
import com.seeyon.v3x.exchange.manager.EdocExchangeTurnRecManager;
import com.seeyon.v3x.exchange.manager.ExchangeAccountManager;
import com.seeyon.v3x.exchange.manager.RecieveEdocManager;
import com.seeyon.v3x.exchange.manager.SendEdocManager;
import com.seeyon.v3x.exchange.util.Constants;
import com.seeyon.v3x.exchange.util.ExchangeUtil;

@CheckRoleAccess(roleTypes={Role_NAME.AccountAdministrator,Role_NAME.EdocManagement,Role_NAME.Accountexchange,Role_NAME.Departmentexchange})
public class ExchangeEdocController extends BaseController {
	
	private static final Log LOGGER = LogFactory.getLog(ExchangeEdocController.class);
	
	private SursenExchangeApi sursenExchangeApi;
	private ExchangeAccountManager exchangeAccountManager;
	private EdocExchangeManager edocExchangeManager;
	private SendEdocManager sendEdocManager;
	private EnumManager enumManagerNew;
	private EdocSummaryManager edocSummaryManager;
	private OrgManager orgManager;
	private AffairManager affairManager;
	private UserMessageManager userMessageManager;
	private OperationlogManager operationlogManager;
	private AppLogManager appLogManager;
	private EdocSummaryRelationManager edocSummaryRelationManager;
	private ConfigManager configManager;
	private RecieveEdocManager recieveEdocManager;
	private EdocRegisterManager edocRegisterManager;
	private EdocMarkDefinitionManager edocMarkDefinitionManager;
	private EdocLockManager edocLockManager;	
	private AttachmentManager attachmentManager;
	private EdocManager edocManager;
	private EdocExchangeTurnRecManager edocExchangeTurnRecManager;
	
	public void setEdocExchangeTurnRecManager(EdocExchangeTurnRecManager edocExchangeTurnRecManager) {
		this.edocExchangeTurnRecManager = edocExchangeTurnRecManager;
	}

	public void setEdocManager(EdocManager edocManager) {
		this.edocManager = edocManager;
	}

	public void setAttachmentManager(AttachmentManager attachmentManager) {
		this.attachmentManager = attachmentManager;
	}

	public void setRecieveEdocManager(RecieveEdocManager recieveEdocManager) {
		this.recieveEdocManager = recieveEdocManager;
	}

	public void setEdocLockManager(EdocLockManager edocLockManager) {
		this.edocLockManager = edocLockManager;
	}

	public void setSursenExchangeApi(SursenExchangeApi sursenExchangeApi) {
        this.sursenExchangeApi = sursenExchangeApi;
    }
	
    public void setEdocMarkDefinitionManager(
			EdocMarkDefinitionManager edocMarkDefinitionManager) {
		this.edocMarkDefinitionManager = edocMarkDefinitionManager;
	}

	public void setEdocSummaryRelationManager(
			EdocSummaryRelationManager edocSummaryRelationManager) {
		this.edocSummaryRelationManager = edocSummaryRelationManager;
	}

    public ConfigManager getConfigManager() {
        return configManager;
    }

    public void setConfigManager(ConfigManager configManager) {
        this.configManager = configManager;
    }
    
	public EdocRegisterManager getEdocRegisterManager() {
		return edocRegisterManager;
	}

	public void setEdocRegisterManager(EdocRegisterManager edocRegisterManager) {
		this.edocRegisterManager = edocRegisterManager;
	}

	public void setAppLogManager(AppLogManager appLogManager) {
        this.appLogManager = appLogManager;
    }

    /**
	 * @return the sendEdocManager
	 */
	public SendEdocManager getSendEdocManager() {
		return sendEdocManager;
	}

	/**
	 * @param sendEdocManager the sendEdocManager to set
	 */
	public void setSendEdocManager(SendEdocManager sendEdocManager) {
		this.sendEdocManager = sendEdocManager;
	}

	public OperationlogManager getOperationlogManager() {
		return operationlogManager;
	}

	public void setOperationlogManager(OperationlogManager operationlogManager) {
		this.operationlogManager = operationlogManager;
	}

	public UserMessageManager getUserMessageManager() {
		return userMessageManager;
	}

	public void setUserMessageManager(UserMessageManager userMessageManager) {
		this.userMessageManager = userMessageManager;
	}

	public AffairManager getAffairManager() {
		return affairManager;
	}

	public EdocSummaryManager getEdocSummaryManager() {
		return edocSummaryManager;
	}

	public void setEdocSummaryManager(EdocSummaryManager edocSummaryManager) {
		this.edocSummaryManager = edocSummaryManager;
	}

	public EdocExchangeManager getEdocExchangeManager() {
		return edocExchangeManager;
	}

	public void setEdocExchangeManager(EdocExchangeManager edocExchangeManager) {
		this.edocExchangeManager = edocExchangeManager;
	}

	public void create(String accountId, String name, int accountType, String description, boolean isInternalAccount, long internalOrgId, long internalDeptId, long internalUserId, String exchangeServerId, int status) throws Exception {
		exchangeAccountManager.create(accountId, name, accountType, description, isInternalAccount, internalOrgId, internalDeptId, internalUserId, exchangeServerId, status);
	}

	public void create(String name, String description) throws Exception {
		exchangeAccountManager.create(name, description);
	}

	public void delete(long id) throws Exception {
		exchangeAccountManager.delete(id);
	}

	public ExchangeAccount getExchangeAccount(long id) {
		return exchangeAccountManager.getExchangeAccount(id);
	}

	public ExchangeAccount getExchangeAccountByAccountId(String accountId) {
		return exchangeAccountManager.getExchangeAccountByAccountId(accountId);
	}

	public List<ExchangeAccount> getExternalAccounts(Long domainId) {
		return exchangeAccountManager.getExternalAccounts(domainId);
	}

	public List<ExchangeAccount> getExternalOrgs(Long domainId) {
		return exchangeAccountManager.getExternalOrgs(domainId);
	}

	public List<ExchangeAccount> getInternalAccounts(Long domainId) {
		return exchangeAccountManager.getInternalAccounts(domainId);
	}

	public void update(ExchangeAccount exchangeAccount) throws Exception {
		exchangeAccountManager.update(exchangeAccount);
	}

	public ExchangeAccountManager getExchangeAccountManager() {
		return exchangeAccountManager;
	}

	public void setExchangeAccountManager(
			ExchangeAccountManager exchangeAccountManager) {
		this.exchangeAccountManager = exchangeAccountManager;
	}

	// 客开 start
	private String[] comp_names = AppContext.getSystemProperty("edoc.comp_names").split(",");
	private HashMap<String, String> hmComps = new HashMap<String, String>();
	
	private String[] edoc_jjcd_s = AppContext.getSystemProperty("edoc.edoc_jjcd").split(",");
	private String[] edoc_danx_s = AppContext.getSystemProperty("edoc.edoc_danx").split(",");
	private String[] edoc_miji_s = AppContext.getSystemProperty("edoc.edoc_mj").split(",");
	private String[] form_jjcd_s = AppContext.getSystemProperty("edoc.form_jjcd").split(",");
	private String[] form_danx_s = AppContext.getSystemProperty("edoc.form_danx").split(",");
	
	private HashMap<String, String> hm_edoc_jjcd = new HashMap<String, String>();
	private HashMap<String, String> hm_edoc_danx = new HashMap<String, String>();
	private HashMap<String, String> hm_edoc_miji = new HashMap<String, String>();
	private HashMap<String, String> hm_form_jjcd = new HashMap<String, String>();
	private HashMap<String, String> hm_form_danx = new HashMap<String, String>();
	
	{
		for (String comp : comp_names) {
			String[] t = comp.split("\\|");
			hmComps.put(t[1], t[0]);
		}
		
		for (String s : edoc_jjcd_s) {
			String[] t = s.split(":");
			hm_edoc_jjcd.put(t[0], t[1]);
		}
		
		for (String s : edoc_danx_s) {
			String[] t = s.split(":");
			hm_edoc_danx.put(t[0], t[1]);
		}
		
		for (String s : edoc_miji_s) {
			String[] t = s.split(":");
			hm_edoc_miji.put(t[0], t[1]);
		}
		
		for (String s : form_jjcd_s) {
			String[] t = s.split(":");
			hm_form_jjcd.put(t[1], t[0]);
		}
		
		for (String s : form_danx_s) {
			String[] t = s.split(":");
			hm_form_danx.put(t[1], t[0]);
		}
	}
	
//	private ColManager colManager;
//	
//	public void setColManager(ColManager colManager) {
//		this.colManager = colManager;
//	}
	
	private CindaedocManager cindaedocManager;
	
	public void setCindaedocManager(CindaedocManager cindaedocManager) {
		this.cindaedocManager = cindaedocManager;
	}
	
	private FileManager fileManager;

	public void setFileManager(FileManager fileManager) {
		this.fileManager = fileManager;
	}
	
	private EdocSendDetailDao edocSendDetailDao;
	
	public void setEdocSendDetailDao(EdocSendDetailDao edocSendDetailDao) {
		this.edocSendDetailDao = edocSendDetailDao;
	}
	// 客开 end

	@Override
	public ModelAndView index(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		return null;
	}
	
	/*------------------------------------ 外部单位管理 Start ---------------------------------------*/
	@CheckRoleAccess(roleTypes={Role_NAME.AccountAdministrator,Role_NAME.EdocManagement})
	public ModelAndView addExchangeAccountPage(HttpServletRequest request,HttpServletResponse response)
		throws Exception {		
		ModelAndView mav = new ModelAndView("exchange/account/addExchangeAccount");	
		return mav;
	}
	
	@CheckRoleAccess(roleTypes={Role_NAME.AccountAdministrator,Role_NAME.EdocManagement})
	public ModelAndView addExchangeAccount(HttpServletRequest request,HttpServletResponse response)
		throws Exception {

		String name = request.getParameter("name");
		String description = request.getParameter("description");
		User user = AppContext.getCurrentUser();
		Long domainId = AppContext.getCurrentUser().getLoginAccount();
		boolean flag = exchangeAccountManager.containExternalAccount(name, domainId);
		if (flag) {
			response.setContentType("text/html;charset=UTF-8");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert(parent.v3x.getMessage('ExchangeLang.outter_unit_name_used'));");
			out.println("history.go(-1);");
			out.println("</script>");
			return null;
		}
		exchangeAccountManager.create(name, description);	
		//记录应用 日志
		appLogManager.insertLog(user, AppLogAction.Edoc_OutAccount_Create, user.getName(),name);
		return new ModelAndView("edoc/refreshWindow").addObject("windowObj","parent");
	}	
	
	@CheckRoleAccess(roleTypes={Role_NAME.AccountAdministrator,Role_NAME.EdocManagement})
	public ModelAndView editExchangeAccountPage(HttpServletRequest request,HttpServletResponse response)
		throws Exception {
		ModelAndView mav = new ModelAndView("exchange/account/editExchangeAccount");
		Long id = Long.valueOf(request.getParameter("id"));
		ExchangeAccount account = exchangeAccountManager.getExchangeAccount(id);
		if(null != account) {
			mav.addObject("account", account);
		}
		return mav;
	}
	
	public ModelAndView getSursenSummary(HttpServletRequest request,HttpServletResponse response){
		//ModelAndView mav = new ModelAndView("exchange/account/editExchangeAccount");
		
	    try {
	        if(AppContext.hasPlugin("sursenExchange")){
	            sursenExchangeApi.exeReceiveEdoc();
	        }
        } catch (BusinessException e) {
            LOGGER.error("接受书生公文数据失败", e);
        }
	    
		return null;
		
	}
	@CheckRoleAccess(roleTypes={Role_NAME.AccountAdministrator,Role_NAME.EdocManagement})
	public ModelAndView updateExchangeAccount(HttpServletRequest request,HttpServletResponse response)
		throws Exception {
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter out = response.getWriter();
		Long id = Long.valueOf(request.getParameter("id"));
		String name = request.getParameter("name");
		String description = request.getParameter("description");
		Long domainId = AppContext.getCurrentUser().getLoginAccount();
		boolean flag = exchangeAccountManager.containExternalAccount(id, name, domainId);
		if (flag) {			
			out.println("<script>");
			out.println("alert(parent.v3x.getMessage('ExchangeLang.outter_unit_name_used'));");
			out.println("history.go(-1);");
			out.println("</script>");
			return null;
		}

		ExchangeAccount account = exchangeAccountManager.getExchangeAccount(id);
		account.setName(name);
		account.setDescription(description);
		exchangeAccountManager.update(account);
	    //记录应用 日志
		User user = AppContext.getCurrentUser();
        appLogManager.insertLog(user, AppLogAction.Edoc_OutAccount_Update, user.getName(),name);
		out.print("<script>");
		out.print("parent.parent.location.reload(true)");
		out.print("</script>");
		return null;
	}
	
	/**
	 * 删除外部单位。
	 */
	@CheckRoleAccess(roleTypes={Role_NAME.AccountAdministrator,Role_NAME.EdocManagement})
	public ModelAndView deleteExchangeAccount(HttpServletRequest request,HttpServletResponse response)
		throws Exception {
		
		String id = request.getParameter("id");
	
		String[] ids = id.split(",");
		User user = AppContext.getCurrentUser();
		for(int i=0;i<ids.length;i++){
		    ExchangeAccount account = exchangeAccountManager.getExchangeAccount(Long.valueOf(ids[i]));
		    if(account!=null){
		    	//记录应用 日志
		    	appLogManager.insertLog(user, AppLogAction.Edoc_OutAccount_Delete, user.getName(),account.getName());
		    	exchangeAccountManager.delete(Long.valueOf(ids[i]));
		    }
		}
	
		return new ModelAndView("edoc/refreshWindow").addObject("windowObj","parent");
	}
	
	private String getListTypeByModelType(String modelType) {
	    
	    String ret = EdocNavigationEnum.EdocV5ListTypeEnum.listExchangeToSend.getKey();
	    
			if("toSend".equals(modelType)) {
		    ret = EdocNavigationEnum.EdocV5ListTypeEnum.listExchangeToSend.getKey();
			} else if("sent".equals(modelType)) {
		    ret = EdocNavigationEnum.EdocV5ListTypeEnum.listExchangeSent.getKey();
			} else if("toReceive".equals(modelType)) {
		    ret = EdocNavigationEnum.EdocV5ListTypeEnum.listExchangeToRecieve.getKey();
			} else if("received".equals(modelType)) {
		    ret = EdocNavigationEnum.EdocV5ListTypeEnum.listExchangeReceived.getKey();
			}
		
		return ret;
		}
		
	public String getModelTypeByExchangeParam(String modelType) {
		String resCode = "F07_edocExchange";
		
		if(Strings.isNotBlank(modelType)){
		    if(CurrentUser.get().hasResourceCode(resCode)){
				return modelType;
			}
		    if("toSend".equals(modelType)) {
	            resCode = "F07_exWaitSend";
	            if(!CurrentUser.get().hasResourceCode(resCode)) {
	                modelType = "toReceive";
	            }
	        }
		    
	        if("toReceive".equals(modelType)) {
	            resCode = "F07_exToReceive";
	            if(!CurrentUser.get().hasResourceCode(resCode)) {
	                modelType = "sent";
	            }
	        }
	        
	        if("sent".equals(modelType)) {
	            resCode = "F07_exSent";
	            if(!CurrentUser.get().hasResourceCode(resCode)) {
	                modelType = "received";
	            }
	        } 
	        
	        if("received".equals(modelType)) {
	            resCode = "F07_exReceived";
	            if(!CurrentUser.get().hasResourceCode(resCode)) {
	                modelType = "";
	            }
	        }
	       
		}
	        
		return modelType;
	}
	
	/*------------------------------------ 外部单位管理 End ---------------------------------------*/
	@CheckRoleAccess(roleTypes={Role_NAME.Accountexchange,Role_NAME.Departmentexchange})
	public ModelAndView listMainEntry(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String modelType = request.getParameter("modelType");
		String listType = request.getParameter("listType");
		if(Strings.isBlank(modelType)) {
			modelType = "toSend";
		}
		if(Strings.isBlank(listType)) {
			listType = getListTypeByModelType(modelType);
		}
		ModelAndView mav = new ModelAndView("exchange/edoc/edoc_list_mainEntry").addObject("modelType", modelType).addObject("listType", listType);
		return mav;
	}
	
	@CheckRoleAccess(roleTypes={Role_NAME.AccountAdministrator,Role_NAME.EdocManagement,Role_NAME.Accountexchange,Role_NAME.Departmentexchange})
	public ModelAndView listMain(HttpServletRequest request,HttpServletResponse response)throws Exception{
		ModelAndView mav = null;
		String modelType = request.getParameter("modelType");
		if(Strings.isNotBlank(modelType)) {
			mav = new ModelAndView("exchange/edoc/edoc_list_main");
			mav.addObject("modelType", modelType);
		} else {
			mav = new ModelAndView("exchange/account/account_list_main");
		}		
		if(Strings.isNotBlank(request.getParameter("id"))) {
			mav.addObject("id", request.getParameter("id"));
		}
		return mav;
	}
	
	@CheckRoleAccess(roleTypes={Role_NAME.AccountAdministrator,Role_NAME.EdocManagement})
	public ModelAndView listOuterAccount(HttpServletRequest request,HttpServletResponse response)throws Exception{
		ModelAndView mav = new ModelAndView("exchange/account/account_list_iframe");
		User user = AppContext.getCurrentUser();
		String condition = request.getParameter("condition");//查询条件
		String textfield = request.getParameter("textfield");
		
		List<ExchangeAccount> list =  exchangeAccountManager.getExternalAccountsforPage(user.getLoginAccount(),condition,textfield);
		mav.addObject("list", list);
		mav.addObject("condition", condition);
		return mav;
	}
	
	
	@SuppressWarnings("rawtypes")
	@CheckRoleAccess(roleTypes={Role_NAME.Accountexchange,Role_NAME.Departmentexchange})
	public ModelAndView list(HttpServletRequest request, HttpServletResponse response)throws Exception{
		ModelAndView mav = null; 
		User user = AppContext.getCurrentUser();
		String modelType = request.getParameter("modelType");//待发送、已发送、待签收、已签收列表区分
		String listType = request.getParameter("listType"); //时间类型参数，本日，昨日，本周等->区分不同列表
		String isFenfa = request.getParameter("isFenfa");  //是否为发文分发列表 1是，null：否  
		
		int sendUnitType = 0;
		if(Strings.isNotBlank(listType)) {//listType不应该是Integer类型，不知道是谁写的代码，理解错误了，先注释
			//sendUnitType = Integer.parseInt(listType);
		}  
		if(isFenfa!=null && "1".equals(isFenfa)) {
			if(Strings.isBlank(modelType)) {
				modelType = "toSend";
			}
		}
		modelType = getModelTypeByExchangeParam(modelType);
		if(Strings.isBlank(listType)) {
			listType = getListTypeByModelType(modelType);
		}
		int type = EdocNavigationEnum.EdocV5ListTypeEnum.getTypeName(listType);
		int state = Integer.parseInt(EdocNavigationEnum.EdocV5ListTypeEnum.getStateName(listType));
		Map<String, Object> condition = new HashMap<String, Object>();
		condition.put("conditionKey", request.getParameter("condition"));
		condition.put("textfield", request.getParameter("textfield"));
		condition.put("textfield1", request.getParameter("textfield1"));
		condition.put("sendUnitType", sendUnitType);
		condition.put("listType", listType);
		condition.put("modelType", modelType);
		condition.put("isFenfa", isFenfa);
		condition.put("state", state);
		condition.put("type", type);
		condition.put("user", user);
		List list =  edocExchangeManager.findEdocExchangeRecordList(type, condition);

		//交换已发送列表
		if(Strings.isNotBlank(modelType) && "sent".equals(modelType)) { 
			mav = new ModelAndView("exchange/edoc/edoc_list_send_iframe");
			mav.addObject("exchangelabel", "exchange.edoc.sent");
		}
		//交换待发送列表
		else if(Strings.isNotBlank(modelType) && "toSend".equals(modelType)) {
			mav = new ModelAndView("exchange/edoc/edoc_list_presend_iframe");
			boolean hasSubjectWrap = this.edocSummaryManager.hasSubjectWrapRecordByCurrentUser(user.getAccountId(), user.getId(), EdocSubjectWrapRecord.Edoc_Send_Fenfa, 0);
			mav.addObject("hasSubjectWrap", hasSubjectWrap);
    		mav.addObject("exchangelabel", "exchange.edoc.presend");	
		}
		//交换已签收列表
		else if(Strings.isNotBlank(modelType) && "received".equals(modelType)) {
			mav = new ModelAndView("exchange/edoc/edoc_list_sign_iframe");
    		mav.addObject("exchangelabel", "exchange.edoc.sign");
		}
		//交换待签收列表
		else if(Strings.isNotBlank(modelType) && "toReceive".equals(modelType)) {
			mav = new ModelAndView("exchange/edoc/edoc_list_presign_iframe");
    		mav.addObject("exchangelabel", "exchange.edoc.presign");
		}
		//签收退件箱
		/*else if(null!=modelType && !"".equals(modelType) && "retreat".equals(modelType)) {
			mav = new ModelAndView("exchange/edoc/edoc_list_presign_iframe");
			Set<Integer> statusSet = new HashSet<Integer>();
			statusSet.add(EdocRecieveRecord.Exchange_iStatus_Receive_StepBacked);
			List<EdocRecieveRecord> list = edocExchangeManager.getRecieveEdocs(user.getId(), user.getLoginAccount(), statusSet,condition,value);	
			
			mav.addObject("list", list);
    		mav.addObject("exchangelabel", "edoc.receive.retreat_box");
		}
		*/
		Map<String, CtpEnumBean> colMetadata = enumManagerNew.getEnumsMap(ApplicationCategoryEnum.edoc);

		mav.addObject("colMetadata", colMetadata);
		mav.addObject("condition", request.getParameter("condition"));	
		mav.addObject("modelType", modelType);
		mav.addObject("listType", listType);
		mav.addObject("list", list);
		if(isFenfa!=null && "1".equals(isFenfa)) {
			mav.addObject("isFenfa", "1");
		}
		
		if(EdocHelper.isG6Version()&&!EdocSwitchHelper.isOpenRegister()){
			mav.addObject("displayDistributeState", "true");
		}
		return mav;
	}
	
	
	/** 登记列表 */
	@CheckRoleAccess(roleTypes={Role_NAME.Accountexchange,Role_NAME.Departmentexchange,Role_NAME.RecEdoc})
    public ModelAndView listV5Register(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("exchange/edoc/listV5Register");  
        User user = AppContext.getCurrentUser();
        String condition = request.getParameter("condition");
        String[] value = new String[2];
        value[0] = request.getParameter("textfield");
        value[1] = request.getParameter("textfield1"); 
        
        Map<String, CtpEnumBean> colMetadata = enumManagerNew.getEnumsMap(ApplicationCategoryEnum.edoc);
        String listType = Strings.isBlank(request.getParameter("listType")) ? EdocNavigationEnum.EdocV5ListTypeEnum.listExchangeToRecieve.getKey() : request.getParameter("listType");
        String modelType = EdocNavigationEnum.RecieveModelListType.getDisplayName(listType);
        Map<String, Object> conditionParams = new HashMap<String, Object>();
        if("toReceive".equals(modelType)) {
        	boolean hasSubjectWrap = this.edocSummaryManager.hasSubjectWrapRecordByCurrentUser(user.getAccountId(), user.getId(), EdocSubjectWrapRecord.Edoc_Receive_Signin, 1);
        	mav.addObject("hasSubjectWrap", hasSubjectWrap);
        	mav.addObject("exchangelabel", "exchange.edoc.presign");
        } else if("retreat".equals(modelType)){
        	mav.addObject("exchangelabel", "edoc.receive.retreat_box");
        } else {
        	mav.addObject("exchangelabel", "exchange.edoc.sign");
        }
        conditionParams.put("modelType", modelType);
        conditionParams.put("userId",user.getId());
        conditionParams.put("affairState", EdocNavigationEnum.EdocV5ListTypeEnum.getStateName(listType));
        conditionParams.put("listValue", EdocNavigationEnum.EdocV5ListTypeEnum.getTypeName(listType));
        
        List<EdocRegister> pendingList = edocRegisterManager.findRegisterByState(condition,value,EdocNavigationEnum.RegisterState.Registed.ordinal(),user);
        mav.addObject("colMetadata", colMetadata);
        mav.addObject("list", pendingList);
        mav.addObject("listType", listType);
        mav.addObject("condition", condition);  
        mav.addObject("modelType", modelType);
        //OA-30463  应用检查：待登记小查询，去掉条件：成文单位，此条件为G6的条件  
        String isG6=SystemProperties.getInstance().getProperty("edoc.isG6");
        mav.addObject("isG6", isG6);
        mav.addObject("showBanwenYuewen", EdocSwitchHelper.showBanwenYuewen(user.getLoginAccount()));//是否开启区分阅文、办文开关
        mav.addObject("canSelfCreateFlow", EdocSwitchHelper.canSelfCreateFlow());//是否允许自建流程
        
        return mav;
    }

	/** 签收列表 */
	@CheckRoleAccess(roleTypes={Role_NAME.Accountexchange,Role_NAME.Departmentexchange})
    public ModelAndView listRecieve(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("exchange/edoc/listRecieve");  
        User user = CurrentUser.get();
        String condition = request.getParameter("condition");
        String[] value = new String[2];
        value[0] = request.getParameter("textfield");
        value[1] = request.getParameter("textfield1");
        Map<String, CtpEnumBean> colMetadata = enumManagerNew.getEnumsMap(ApplicationCategoryEnum.edoc);
        List<EdocRecieveRecord> list = null;
        Set<Integer> statusSet = new HashSet<Integer>();
        String listType = Strings.isBlank(request.getParameter("listType")) ? EdocNavigationEnum.RecieveFromListType.toReceive.getKey() : request.getParameter("listType");
        String modelType = EdocNavigationEnum.RecieveModelListType.getDisplayName(listType);
        int type = EdocNavigationEnum.RecieveFromListType.getDisplayName(listType); 
        int dateType = EdocNavigationEnum.RecieveDateListType.getDisplayName(listType);
        Map<String, Object> conditionParams = new HashMap<String, Object>();
        if("toReceive".equals(modelType)) {
        	/* xiangfan 添加 判断当前用户是否设置了 收文-签收 的标题多行显示 start */
        	boolean hasSubjectWrap = false;
        	hasSubjectWrap = this.edocSummaryManager.hasSubjectWrapRecordByCurrentUser(user.getAccountId(), user.getId(), EdocSubjectWrapRecord.Edoc_Receive_Signin, 1);
        	mav.addObject("hasSubjectWrap", hasSubjectWrap);
        	/* xiangfan 添加 判断当前用户是否设置了 收文-签收 的标题多行显示 end */
        	mav.addObject("exchangelabel", "exchange.edoc.presign");
            statusSet.add(Constants.C_iStatus_Torecieve);
        } else if("retreat".equals(modelType)){
        	mav.addObject("exchangelabel", "edoc.receive.retreat_box");
        	statusSet.add(Constants.C_iStatus_Retreat);
        	conditionParams.put("modelType", modelType);
            conditionParams.put("userId", user.getId());
        } else {
        	mav.addObject("exchangelabel", "exchange.edoc.sign");
            statusSet.add(Constants.C_iStatus_Recieved);
            statusSet.add(Constants.C_iStatus_Registered);
        }
        //GOV-4885 【公文管理】-【收文管理】-【签收】-【已签收】列表里可以看到其他收发员签收的记录
        conditionParams.put("userId",user.getId());
        list = edocExchangeManager.getRecieveEdocs(user.getId(), user.getLoginAccount(), statusSet,condition, value, type, dateType, conditionParams);        
        mav.addObject("colMetadata", colMetadata);
        mav.addObject("list", list);
        mav.addObject("listType", listType);
        /**
         * 使用orgManager获取登记人的姓名,返回前台
         */
        if(!"toReceive".equals(modelType) && list != null) {
            for(EdocRecieveRecord record : list){
                V3xOrgMember register = orgManager.getEntityById(V3xOrgMember.class, record.getRegisterUserId());
                record.setRegisterName(register==null? null : register.getName());
            }
        }
        mav.addObject("condition", condition);  
        mav.addObject("modelType", modelType);
        return mav;
    }
	
	/**
	 * 公文交换批量删除
	 * @param request
	 * @param resonse
	 * @return
	 * @throws Exception
	 */
	@CheckRoleAccess(roleTypes={Role_NAME.Accountexchange,Role_NAME.Departmentexchange})
	public ModelAndView edocDelete(HttpServletRequest request,HttpServletResponse resonse) throws Exception {
		//获取参数
		String listType = request.getParameter("listType");
		String[] sendRecordIds = request.getParameterValues("sendRecordId");
		String[] receiveRecordIds = request.getParameterValues("receiveRecordId");
		String[] subjects = request.getParameterValues("subject");
		Map<Long, String> map = new HashMap<Long, String>();
		if(sendRecordIds!=null && subjects!=null) {
			for(int i=0; i<sendRecordIds.length; i++) {
				map.put(Long.parseLong(sendRecordIds[i]), subjects[i]);
			}
		}
		if(receiveRecordIds!=null && subjects!=null) {
			for(int i=0; i<receiveRecordIds.length; i++) {
				map.put(Long.parseLong(receiveRecordIds[i]), subjects[i]);
			}
		}
		//删除交换数据
		edocExchangeManager.deleteExchangeDataByType(listType, map);
		//页面跳转  OA-94292 出现重复提交
		/*PrintWriter out = resonse.getWriter();
		out.println("<script>");
		out.println("location.reload();");
		out.println("</script>");*/
		return new ModelAndView("edoc/refreshWindow").addObject("windowObj","parent");
	}
	
	
	
	/**
	 * 公文交换发送、签收、登记页面
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@CheckRoleAccess(roleTypes={Role_NAME.NULL})
	public ModelAndView change(HttpServletRequest request,HttpServletResponse response)throws Exception{
		LOGGER.info("执行公文交换开始......");
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter out = response.getWriter();    
		User user = AppContext.getCurrentUser();
		String reSend = request.getParameter("reSend");
		String[] exchangeModeValues = request.getParameterValues("exchangeMode");
		String  internalExchange = "";
		String  sursenExchange = ""; 
		if(exchangeModeValues != null){
			for(String exchangeModeValue :exchangeModeValues){
				if(String.valueOf(EdocExchangeModeEnum.internal.getKey()).equals(exchangeModeValue)){
					internalExchange = String.valueOf(EdocExchangeModeEnum.internal.getKey());
				}else if(String.valueOf(EdocExchangeModeEnum.sursen.getKey()).equals(exchangeModeValue)){
					sursenExchange = String.valueOf(EdocExchangeModeEnum.sursen.getKey());
				}
			}
		}
		
		String sendKey = "exchange.sent";
		String userName = "";
		if(null!=user){
			userName = user.getName();
		}
		String id = request.getParameter("id");
		String affairId = request.getParameter("affairId");
		if(Strings.isBlank(id)){
			return null;
		}
		//判断是否有公文交换的权限
		boolean isExchangeRole = false;

		//公文交换权
		isExchangeRole = EdocRoleHelper.isExchangeRole();
		if(!isExchangeRole) {
			long userId = CurrentUser.get().getId();
			List<Long> agentIdList = MemberAgentBean.getInstance().getAgentToMemberId(ApplicationCategoryEnum.edoc.key(), userId);
			if(!CollectionUtils.isEmpty(agentIdList)) {
				boolean agentIsExchangeRole = false;
				for(int i=0; i<agentIdList.size(); i++) {
					V3xOrgMember agentMember=orgManager.getMemberById(agentIdList.get(i).longValue());
					if(agentMember==null){
						continue;
					}
					Long accountIdOfagentId = agentMember.getOrgAccountId();
					agentIsExchangeRole = EdocRoleHelper.isExchangeRole(agentIdList.get(i).longValue(),accountIdOfagentId);
					if(agentIsExchangeRole) {
						break;
					}
				}
				isExchangeRole = agentIsExchangeRole;
			}
		}
		
		if(!isExchangeRole) {
			try {
				String alertNote = ResourceUtil.getString("exchange.notRole");
				Boolean f = (Boolean)(BrowserFlag.PageBreak.getFlag(request));
				out.println("<script>");
				out.println("	alert('" + alertNote + "');");
				if (f.booleanValue()) {
					out.println("parent.doEndSign_exchange('','"+affairId+"');"); 
				} else {
					out.println("window.getA8Top().close();");
				}
				out.println("</script>");
				return null;
			} catch (Exception e) {
			    LOGGER.error("", e);
			}
		}
		
		Long agentToId = null;//被代理人ID
		String agentToName = "";
		if(Strings.isNotBlank(affairId)){
			CtpAffair affair = affairManager.get(Long.valueOf(affairId));
			if(!affair.getMemberId().equals(user.getId())){
				boolean isTrue = ColUtil.checkAgent(affair.getMemberId(), affair.getSubject(), ModuleType.edoc, true, request);
				if(!isTrue){
					return null;
				}
				agentToId = affair.getMemberId();
				V3xOrgMember member = orgManager.getMemberById(agentToId);
				agentToName = member.getName();
			}
		}
		
		boolean isResend = false; 

		String modelType = request.getParameter("modelType");
		
		/***********************发文分发*********************/		
 		if(null!=modelType && !"".equals(modelType) && "toSend".equals(modelType)){
			
			//公文交换时候,发送公文,给发送的detail表插入数据,同时给待签收表插入数据
			//String sendUserId = request.getParameter("sendUserId");
			//String sender = request.getParameter("sender");
			//读取发送时重新选择的发送单位
			String typeAndIds=request.getParameter("grantedDepartId");
			String sendedNames = request.getParameter("depart");
			// 客开 start
			String typeAndIds_yuewen=request.getParameter("grantedDepartId_yuewen");
			String sendedNames_yuewen = request.getParameter("depart_yuewen");
			
			String typeAndIds_nbfs=request.getParameter("grantedDepartId_nbfs");
			String sendedNames_nbfs = request.getParameter("depart_nbfs");
			// 客开 end
			
			EdocSendRecord record = edocExchangeManager.getSendRecordById(Long.valueOf(id));
			
			/**
			 * 1. 补发的数据不做验证
			 * 2. 待发的数据，如果发文被取消，不让发送成功
			 */
			if(!"true".equals(reSend) && !checkEdocSendRecord(response, record, true)) {
				return null;
			}
			
			/*****
                                     这段代码保留，怕需求又变动回来：OA-78471

			EdocExchangeTurnRec turnRec = null;
			if(null != record.getIsTurnRec() &&  record.getIsTurnRec() == 1){
				turnRec = edocExchangeTurnRecManager.findEdocExchangeTurnRecByEdocId(record.getEdocId());
			}
			
			******************/
			
            try {
				//分发人员点击公文被退回的提示消息打开被退回的公文，在页面上点击'发送'再次发送给相同单位，这个单位下的其他人员或者上一次的签收人员回退，
				//分发人员在已分发里打开公文查看交换信息里回退附言还是第一次回退时的附言，新的附言没有被记录 
				if(!"true".equals(reSend)){
					record.setStepBackInfo("");
					//OA-22284  在公文交换中将带发送的公文发送出去，然后去发文登记簿去查询，在结果中看不到在交换时才选择的主送单位  
					//在发文登记簿中查询时，是按照该字段查询主送单位的
					record.setSendedTypeIds(typeAndIds);
					record.setSendedNames(sendedNames);
					// 客开 start
					record.setSendedTypeIds_yuewen(typeAndIds_yuewen);
					record.setSendedNames_yuewen(sendedNames_yuewen);
					
					record.setSendedTypeIds_nbfs(typeAndIds_nbfs);
					record.setSendedNames_nbfs(sendedNames_nbfs);
					// 客开 end
					
					/*****
					 这段代码保留，怕需求又变动回来：OA-78471
					
					//需要修改转收文信息中的 主送单位（因为在发送时，只有有交换员的单位才能发送）
					if(turnRec != null){
						turnRec.setTypeAndIds(typeAndIds);
						edocExchangeTurnRecManager.updateTurnRec(turnRec);
					}
					
					******/
				}
				if("true".equals(reSend)){
					isResend = true;
					EdocSendRecord reRecord = new EdocSendRecord();
					reRecord.setIdIfNew();
					reRecord.setContentNo(record.getContentNo());
					reRecord.setCopies(record.getCopies());
					reRecord.setCreateTime(new Timestamp(new Date().getTime()));
					reRecord.setDocMark(record.getDocMark());
					reRecord.setDocType(record.getDocType());
					reRecord.setEdocId(record.getEdocId());
					reRecord.setExchangeOrgId(record.getExchangeOrgId());
					reRecord.setExchangeAccountId(record.getExchangeAccountId());
					reRecord.setExchangeOrgName(record.getExchangeOrgName());
					reRecord.setExchangeType(record.getExchangeType());
					reRecord.setIssueDate(record.getIssueDate());
					reRecord.setIssuer(record.getIssuer());
					reRecord.setSecretLevel(record.getSecretLevel());
					reRecord.setSendDetailList(new ArrayList<EdocSendDetail>());
					reRecord.setSendDetails(new HashSet<EdocSendDetail>());
					reRecord.setSendNames(userName);
					reRecord.setSendTime(new Timestamp(System.currentTimeMillis()));
					reRecord.setSendUnit(record.getSendUnit());
					reRecord.setSendUserId(user.getId());
					reRecord.setAssignType(EdocSendRecord.Exchange_Assign_To_Member);//补发表示，指定交换，交换人为user.getId()
					reRecord.setIsBase(EdocSendRecord.Exchange_Base_NO);//补发表示：非原发文
					reRecord.setSendUserNames(user.getName());
					reRecord.setStatus(record.getStatus());
					reRecord.setSubject(record.getSubject());
					reRecord.setUrgentLevel(record.getUrgentLevel());
					reRecord.setSendedTypeIds(typeAndIds);
					reRecord.setSendedNames(sendedNames);
					//设置是否为转收文类型
					reRecord.setIsTurnRec(record.getIsTurnRec());
					// 客开 start
					reRecord.setSendedTypeIds_yuewen(typeAndIds_yuewen);
					reRecord.setSendedNames_yuewen(sendedNames_yuewen);
					
					reRecord.setSendedTypeIds_nbfs(typeAndIds_nbfs);
					reRecord.setSendedNames_nbfs(sendedNames_nbfs);
					// 客开 end
					
					/*****
	                                                 这段代码保留，怕需求又变动回来：OA-78471
					
					//修改转收文信息的 主送单位
					if(turnRec != null){
						if(Strings.isNotBlank(turnRec.getTypeAndIds())){
							turnRec.setTypeAndIds(turnRec.getTypeAndIds()+","+typeAndIds);
						}else{
							turnRec.setTypeAndIds(typeAndIds);
						}
						edocExchangeTurnRecManager.updateTurnRec(turnRec);
					}
					
					**************/
					
	
					record = reRecord; //对象指向新对象
					sendKey = "exchange.resend";
					modelType = "sent";
				}
				
				// 客开 start
				EdocSummary summary = edocSummaryManager.getEdocSummaryById(record.getEdocId(), true, true);
				
				// 过滤外部单位和子单位
				StringBuffer sb_typeAndIds = new StringBuffer("");
				StringBuffer sb_typeAndIds_yuewen = new StringBuffer("");
				StringBuffer sb_typeAndIds_pt = new StringBuffer("");
				StringBuffer sb_typeAndIds_pt_ids = new StringBuffer("");
				StringBuffer sb_typeAndIds_pt_names = new StringBuffer("");
				
				String[] a_ids = typeAndIds.split(",");
				for (String s : a_ids) {
					
					String[] data = s.split("[|]");
					if (("ExchangeAccount").equalsIgnoreCase(data[0])){
						continue;
					}
					String sendName = OrgHelper.showOrgEntities(s, "");
					if(EdocObjTeam.ENTITY_TYPE_OrgTeam.equalsIgnoreCase(data[0])) {
						EdocObjTeam et = this.sendEdocManager.getEdocObjTeamManager().getById(Long.parseLong(data[1]));
						Set <EdocObjTeamMember> mems = et.getEdocObjTeamMembers();
						boolean ptExchange = false;//是否包含交换
						for(EdocObjTeamMember mem : mems) {
							ptExchange = false;
							String strTemp = mem.getTeamType()+"|"+mem.getMemberId();
							String name = OrgHelper.showOrgEntities(strTemp, "");
							String pt_id  = hmComps.get(name);

							// 交换子公司
							if(pt_id != null && sb_typeAndIds_pt.indexOf(strTemp) == -1){
								ptExchange = true;
								sb_typeAndIds_pt.append(strTemp).append(",");
								sb_typeAndIds_pt_ids.append(pt_id).append(",");
								
								// 只记录机构组名
								if(sb_typeAndIds_pt_names.indexOf(sendName) == -1){
									sb_typeAndIds_pt_names.append(sendName).append(",");
								}
							}
							//客开 赵辉 与外部机构不匹配则默认内部交换 start
							if(!ptExchange){//不包含子交换机构的作为内部交换
								sb_typeAndIds.append(strTemp).append(",");
							}
							//客开 赵辉 与外部机构不匹配则默认内部交换 end
						}
						/*if(!ptExchange){//不包含子交换机构的作为内部交换
							sb_typeAndIds.append(s).append(",");
						}*/
						continue;
					} 
					
					// 非机构组，即单位或部门
					String pt_id  = hmComps.get(sendName);
					if (pt_id != null) {
						sb_typeAndIds_pt.append(s).append(",");
						sb_typeAndIds_pt_ids.append(pt_id).append(",");
						sb_typeAndIds_pt_names.append(sendName).append(",");
					} else {
						sb_typeAndIds.append(s).append(",");
					}
				}
				
				if (typeAndIds_yuewen != null && !"".equals(typeAndIds_yuewen)) {
					String[] a_ids_yuewen = typeAndIds_yuewen.split(",");
					for (String s : a_ids_yuewen) {
						
						String[] data = s.split("[|]");
						if (("ExchangeAccount").equalsIgnoreCase(data[0])){
							continue;
						}
						String sendName = OrgHelper.showOrgEntities(s, "");
						if(EdocObjTeam.ENTITY_TYPE_OrgTeam.equalsIgnoreCase(data[0])) {
							EdocObjTeam et = this.sendEdocManager.getEdocObjTeamManager().getById(Long.parseLong(data[1]));
							Set <EdocObjTeamMember> mems = et.getEdocObjTeamMembers();
							boolean ptExchange = false;//是否包含交换
							for(EdocObjTeamMember mem : mems) {
								String strTemp = mem.getTeamType()+"|"+mem.getMemberId();
								String name = OrgHelper.showOrgEntities(strTemp, "");
								String pt_id  = hmComps.get(name);

								// 交换子公司
								if(pt_id != null && sb_typeAndIds_pt.indexOf(strTemp) == -1){
									ptExchange = true;
									sb_typeAndIds_pt.append(strTemp).append(",");
									sb_typeAndIds_pt_ids.append(pt_id).append(",");
									
									// 只记录机构组名
									if(sb_typeAndIds_pt_names.indexOf(sendName) == -1){
										sb_typeAndIds_pt_names.append(sendName).append(",");
									}
								}
							}
							if(!ptExchange){//不包含子交换机构的作为内部交换
								sb_typeAndIds_yuewen.append(s).append(",");
							}
							continue;
						} 
						
						// 非机构组，即单位或部门
						String pt_id  = hmComps.get(sendName);
						if (pt_id != null) {
							sb_typeAndIds_pt.append(s).append(",");
							sb_typeAndIds_pt_ids.append(pt_id).append(",");
							sb_typeAndIds_pt_names.append(sendName).append(",");
						} else {
							sb_typeAndIds_yuewen.append(s).append(",");
						}
					}
				}
				
				if (sb_typeAndIds.length() > 0) {
					sb_typeAndIds.setLength(sb_typeAndIds.length() - 1);
				}
				if (sb_typeAndIds_yuewen.length() > 0) {
					sb_typeAndIds_yuewen.setLength(sb_typeAndIds_yuewen.length() - 1);
				}
				if (sb_typeAndIds_pt.length() > 0) {
					sb_typeAndIds_pt.setLength(sb_typeAndIds_pt.length() - 1);
					sb_typeAndIds_pt_ids.setLength(sb_typeAndIds_pt_ids.length() - 1);
					sb_typeAndIds_pt_names.setLength(sb_typeAndIds_pt_names.length() - 1);
				}
				// 客开 end
				
				boolean hasPlugin = AppContext.hasPlugin("sursenExchange");
				//没有书生插件的时候、有书生插件并且选择了内部交互 需要记录内部交换应用日志。
				if(!hasPlugin || (hasPlugin && String.valueOf(EdocExchangeModeEnum.internal.getKey()).equals(internalExchange))){
					//内部交换应用日志记录
					appLogManager.insertLog(AppContext.getCurrentUser(), AppLogAction.Edoc_Send_Exchange, AppContext.getCurrentUser().getName(),record.getSubject());
				}
				// 客开 start
				//List<EdocSendDetail> details=edocExchangeManager.createSendRecord(record.getId(), typeAndIds);
				List<EdocSendDetail> details_all = new ArrayList<EdocSendDetail>();
				List<EdocSendDetail> details = new ArrayList<EdocSendDetail>();
				if (sb_typeAndIds.length() > 0) {
					details=sendEdocManager.createSendRecord_forCinda(record.getId(), sb_typeAndIds.toString(), null);
					for (EdocSendDetail es : details) {
						es.setType("办件");//主送
					}
				}
				List<EdocSendDetail> details_yuewen = new ArrayList<EdocSendDetail>();
				if (sb_typeAndIds_yuewen.length() > 0) {
					details_yuewen=sendEdocManager.createSendRecord_forCinda(record.getId(), sb_typeAndIds_yuewen.toString(), null);
					for (EdocSendDetail es : details_yuewen) {
						es.setType("阅件");
					}
				}
				List<EdocSendDetail> details_pt = new ArrayList<EdocSendDetail>();
				if (sb_typeAndIds_pt.length() > 0) {
					details_pt=sendEdocManager.createSendRecord_forCinda(record.getId(), sb_typeAndIds_pt.toString(), null);
					for (EdocSendDetail es : details_pt) {
						es.setType("交换平台");
					}
				}
				// 传阅不做记录
//				List<EdocSendDetail> details_nbfs = new ArrayList<EdocSendDetail>();
//				if (typeAndIds_nbfs != null && !"".equals(typeAndIds_nbfs)) {
//					details_nbfs=edocExchangeManager.createSendRecord(record.getId(), typeAndIds_nbfs);
//					for (EdocSendDetail es : details_nbfs) {
//						es.setType("传阅");
//					}
//				}
				
				details_all.addAll(details);
				details_all.addAll(details_yuewen);
				details_all.addAll(details_pt);
//				details_all.addAll(details_nbfs);
				// 客开 end
				
				// 如果是回退的公文再次发送，设置此公文的发文记录的状态为未发送
				if (ExchangeUtil.isEdocExchangeSentStepBacked(record.getStatus())) {
					record.setStatus(EdocSendRecord.Exchange_iStatus_Tosend);
				}
				
				// 客开 start
				//Set<EdocSendDetail> sendDetails = new HashSet<EdocSendDetail>(details);
				Set<EdocSendDetail> sendDetails = new HashSet<EdocSendDetail>(details_all);
				// 客开 end
				record.setSendDetails(sendDetails);
				// 在已发中和待签收产生数据
				// 客开 start
				//Map<String, String> sendEdoc = edocExchangeManager.sendEdoc(record, user.getId() ,user.getName(),agentToId,isResend,exchangeModeValues);
				EdocFileInfo efi = cindaedocManager.getEdocFileInfoByEdocId(summary.getId());
				//EdocBody edocBody = summary.getFirstBody();
				//EdocBody edocBody = summary.getBodyByMaxContentNo();//客开
				EdocBody edocBody = summary.getBody(EdocBody.EDOC_BODY_PDF_ONE);
				if (edocBody == null){
					edocBody = summary.getFirstBody();
				}
				String edoc_fileId = edocBody.getContent();
				if (efi == null) {

					if ("OfficeWord".equalsIgnoreCase(edocBody.getContentType())) {
						// 导出正文
						File eFile = fileManager.getFile(Long.parseLong(edocBody.getContent()));
						if (eFile != null) {
							String sysTemp = SystemEnvironment.getSystemTempFolder() + "/exportedoc/sendEdoc/";
							String edocDoc = getFileName(summary.getSubject()) + "（正文）.doc";
							String doc = summary.getId() + ".doc";
							String docPath = sysTemp + "doc/";
							File docFile = new File(docPath);
							docFile.mkdirs();
							Util.jinge2StandardOffice(eFile.getAbsolutePath(), docPath + doc);
							
							// 转pdf
							String pdfPath = sysTemp + "pdf/";
							File pdfFile = new File(pdfPath);
							pdfFile.mkdirs();
							String edocPdf = getFileName(summary.getSubject()) + "（正文）.pdf";
							String pdf = summary.getId() + ".pdf";
							try {
								TransPDF trans = new TransPDF(SystemProperties.getInstance().getProperty("exportdoc.transpdf.serverAddress", "100.16.14.146"),
										SystemProperties.getInstance().getIntegerProperty("exportdoc.transpdf.serverport", 5801));
								trans.transFile(docPath + doc, pdfPath + pdf);
							} catch (Exception e) {
								LOGGER.error("转PDF文件失败", e);
							}
							File pFile = new File(pdfPath + pdf);
							boolean ispdf = false;
							if (pFile.exists() && pFile.length() > 0) {
								ispdf = true;
							}
							
							String token = getToken();
							if (token != null) {
								Long fid = null;
								if (ispdf) {
									fid = upLoadFile(FileUtils.openInputStream(pFile), edocPdf, user.getLoginName(), token);
									if (fid != null) {
										V3XFile vfzw = fileManager.getV3XFile(fid);
										vfzw.setCategory(2);
										vfzw.setMimeType("application/pdf");
										fileManager.update(vfzw);
									}
								} else {
									fid = upLoadFile(FileUtils.openInputStream(new File(docPath + doc)), edocDoc, user.getLoginName(), token);
								}
								if (fid != null) {
									edoc_fileId = String.valueOf(fid);
								}
							}
						}
					}
					efi = new EdocFileInfo();
					efi.setIdIfNew();
					efi.setEdocId(summary.getId());
					efi.setFileId(Long.valueOf(edoc_fileId));
					cindaedocManager.saveObject(efi);
				} else {
					edoc_fileId = String.valueOf(efi.getFileId());
				}
				
				Map<String, String> sendEdoc = edocExchangeManager.sendEdoc_forCinda(record, user.getId() ,user.getName(),agentToId,isResend,exchangeModeValues);
				// 客开 end
				String sendFailed = sendEdoc.get("sendFailed");
				// 书生交换失败，弹出提示框
				String  send = ResourceUtil.getString("edoc.exchangeMode.sursenfailed"); // 书生公文交换发送失败，请重新发送
				if("failed".equals(sendFailed)){
					out.println("<script>");
					out.println("	alert('" + send + "');");
					out.println("parent.location.reload(true);");
					out.println("</script>");
					return null;
				}
				// 客开 start
				try{
					// 传阅
					if (typeAndIds_nbfs != null && !"".equals(typeAndIds_nbfs)) {
						CTPServiceClientManager clientManager = CTPServiceClientManager.getInstance("http://127.0.0.1:" + AppContext.getSystemProperty("edoc.oa_port"));
						CTPRestClient client = clientManager.getRestClient();
						client.authenticate(AppContext.getSystemProperty("edoc.rest_user"), AppContext.getSystemProperty("edoc.rest_password"));
						
						String[] teams = typeAndIds_nbfs.split(",");
						List<V3xOrgMember> listAll = new ArrayList<V3xOrgMember>();
						for (String t : teams) {
							String[] ts = t.split("\\|");
							List<V3xOrgMember> listMem = orgManager.getMembersByTeam(Long.valueOf(ts[1]));
							listAll.addAll(listMem);
						}
						
						String jjcd = hm_edoc_jjcd.get(summary.getList6());
						if (jjcd == null || "".equals(jjcd)) {
							jjcd = "";
						} else {
							jjcd = hm_form_jjcd.get(jjcd);
						}
						String danx = hm_edoc_danx.get(summary.getList3());
						if (danx == null || "".equals(danx)) {
							danx = "";
						} else {
							danx = hm_form_danx.get(danx);
						}
						
						Long accountId = Functions.getMember(record.getSendUserId()).getOrgAccountId();
						String docMark = summary.getDocMark();
						String rec_date = Datetimes.format(new Date(), "yyyy-MM-dd");
						String subject = summary.getSubject();
						final String yuewen_subject = "传阅-" + summary.getSubject();
						
						// 文单又不要了 ，靠！
//						String sysTemp = SystemEnvironment.getSystemTempFolder() + "/expedoc_temp/";
//						String[] oem = service.exportOfflineEdocModel(summary.getId());
//						Document document = Dom4jxmlUtils.paseXMLToDoc(oem[0]);
//						String xslFile = oem[1];
//						int index = xslFile.indexOf("\r\n");
//						if (index == 0) {
//							xslFile = xslFile.substring(2, xslFile.length());
//						}
//						String htmlPath = sysTemp + "html/";
//						File fpf = new File(htmlPath);
//						fpf.mkdirs();
//						String edocHtml = getFileName(summary.getSubject()) + "（文单）.html";
//						File htmlFile = new File(htmlPath + edocHtml);
//						FileUtils.writeStringToFile(htmlFile, transform(document, xslFile), "UTF-8");
//						
//						String token = getToken();
//						Long zwId = null;
//						if (token != null) {
//							zwId = upLoadFile(FileUtils.openInputStream(htmlFile), edocHtml, user.getLoginName(), token);
//						}
						
						FileManager fileManager = (FileManager)AppContext.getBean("fileManager");
						
						List<Attachment> listAttas = attachmentManager.getByReference(summary.getId(), summary.getId());
						
						HashMap<Long, Long> memids = new HashMap<Long, Long>();
						for (V3xOrgMember vom : listAll) {
							if (memids.get(vom.getId()) != null) {
								continue;
							}
							
							// 一级部门
							long depId = vom.getOrgDepartmentId();
							try {
								if (orgManager.getParentDepartment(depId) != null) {
									depId = orgManager.getParentDepartment(depId).getId();
								}
							} catch (Exception e) {
							}

							final StringBuffer sb = new StringBuffer("");
							sb.append("<formExport version=\"2.0\">");
							sb.append("<summary id=\"" + UUIDUtil.getUUIDLong() + "\" name=\"" + AppContext.getSystemProperty("edoc.yuewen_table_name") + "\"/>");
							sb.append("<definitions/><values>");
							sb.append("<column name=\"一级部门\"><value>" + depId + "</value></column>");
							sb.append("<column name=\"紧急程度\"><value>" + jjcd + "</value></column>");
							sb.append("<column name=\"档案年限\"><value>" + danx + "</value></column>");
							
							sb.append("<column name=\"编号\"><value></value></column>");
							
							sb.append("<column name=\"来文单位\"><value>" + accountId + "</value></column>");
							sb.append("<column name=\"文号\"><value>" + docMark + "</value></column>");
							sb.append("<column name=\"收文日期\"><value>" + rec_date + "</value></column>");
							sb.append("<column name=\"标题\"><value>" + subject + "</value></column>");
							Long zwwd = UUIDUtil.getUUIDLong();
							sb.append("<column name=\"正文\"><value>" + zwwd + "</value></column>");
							Long fileId = UUIDUtil.getUUIDLong();
							sb.append("<column name=\"附件\"><value>" + fileId + "</value></column>");
							
							sb.append("<column name=\"收文部门办理意见\"><value></value></column>");
							sb.append("<column name=\"是否督办\"><value></value></column>");
							sb.append("<column name=\"督办日期\"><value></value></column>");
							sb.append("<column name=\"办理日期\"><value></value></column>");
							sb.append("<column name=\"办理人\"><value></value></column>");
							sb.append("<column name=\"实际办结日期\"><value></value></column>");
							sb.append("<column name=\"领导批示意见\"><value></value></column>");
							sb.append("<column name=\"承办部门办理意见\"><value></value></column>");
							sb.append("<column name=\"协办部门意见\"><value></value></column>");
							sb.append("<column name=\"联系人\"><value></value></column>");
							sb.append("<column name=\"联系电话\"><value></value></column>");
							sb.append("<column name=\"传阅意见\"><value></value></column>");
							sb.append("</values><subForms/></formExport>");
							
							final String loginName = vom.getLoginName();
							
							Map data = new HashMap() {
								{
					            	put("templateCode", AppContext.getSystemProperty("edoc.yuewen_tmp_no"));
					                put("senderLoginName", loginName);
					                put("subject", yuewen_subject);
					                put("data", sb.toString());
					                put("attachments",new Long[] {});
					                put("param", "0");
					            }
					        };
					        
							Long flowid = client.post("flow/" + AppContext.getSystemProperty("edoc.yuewen_tmp_no"), data, Long.class);
							
							List<Attachment> listAttNew = new ArrayList<Attachment>();
							// 正文要作为附件挂到文单上，靠！
//							if (zwId != null) {
//								V3XFile vfzw = fileManager.getV3XFile(zwId);
							if (edoc_fileId != null && !"".equals(edoc_fileId)) {
								V3XFile vfzw = fileManager.getV3XFile(Long.valueOf(edoc_fileId));
								Attachment att_zw = new Attachment();
								att_zw.setIdIfNew();
								att_zw.setReference(flowid);
								att_zw.setSubReference(zwwd);
								att_zw.setCategory(2);
								att_zw.setType(0);
								if ("application/msword".equals(vfzw.getMimeType())) {
									att_zw.setFilename(getFileName(summary.getSubject()) + "（正文）.doc");
								} else {
									att_zw.setFilename(getFileName(summary.getSubject()) + "（正文）.pdf");
								}
								att_zw.setFileUrl(vfzw.getId());
								att_zw.setMimeType(vfzw.getMimeType());
								att_zw.setCreatedate(vfzw.getCreateDate());
								att_zw.setSize(vfzw.getSize());
								att_zw.setSort(0);
								
								listAttNew.add(att_zw);
							}
							
							if (listAttas != null && listAttas.size() > 0) {
								for (int i = 0; i < listAttas.size(); i++) {
									if(listAttas.get(i).getCategory() == 501){//背景资料不作为附件交换
										continue;
									}
									V3XFile vf = fileManager.getV3XFile(listAttas.get(i).getFileUrl());
									Attachment att = new Attachment();
									att.setIdIfNew();
									att.setReference(flowid);
									att.setSubReference(fileId);
									att.setCategory(2);
									att.setType(0);
									att.setFilename(vf.getFilename());
									att.setFileUrl(vf.getId());
									att.setMimeType(vf.getMimeType());
									att.setCreatedate(vf.getCreateDate());
									att.setSize(vf.getSize());
									att.setSort(i + 1);
									
									listAttNew.add(att);
								}
							}
							
							// 正文不关联文单正文了，靠！
//							ColSummary col = colManager.getColSummaryById(flowid);
//							col.setBodyType(String.valueOf(c_type));
//							colManager.updateColSummary(col);
							
//							List<Long> mids = new ArrayList<Long>();
//							mids.add(flowid);
//							List<CtpContentAll> listCca = ctpMainbodyManager.getContentListByModuleIdAndModuleType(ModuleType.collaboration, mids);
//							if (listCca != null && listCca.size() > 0) {
//								CtpContentAll cca = listCca.get(0);
//								cca.setContentType(c_type);
//								String cont = String.valueOf(UUIDUtil.getUUIDLong());
//								cca.setContent(cont);
//								cca.setContentDataId(col.getFormRecordid());
//								cca.setContentTemplateId(col.getFormAppid());
//								
//								ctpMainbodyManager.saveOrUpdateContentAll(cca);
//								
//								V3XFile vf = fileManager.getV3XFile(Long.valueOf(edoc_fileId));
//								Attachment att = new Attachment();
//								att.setIdIfNew();
//								att.setReference(col.getFormRecordid());
//								att.setSubReference(Long.valueOf(cont));
//								att.setCategory(2);
//								att.setType(0);
//								if (c_type == 20) {
//									att.setFilename("[正文].doc");
//								} else {
//									att.setFilename("[正文].pdf");
//								}
//								att.setFileUrl(vf.getId());
//								att.setMimeType(vf.getMimeType());
//								att.setCreatedate(vf.getCreateDate());
//								att.setSize(0l);
//								att.setSort(0);
//								
//								listAttNew.add(att);
//							}
							
							if (listAttNew.size() > 0) {
								attachmentManager.create(listAttNew);
							}
							
							memids.put(vom.getId(), vom.getId());
						}
					}
				} catch (Exception e) {
					LOGGER.error("内部传阅失败", e);
				}
				
				String [] msgIds = null;
				try {
					// 平台交换
					if (sb_typeAndIds_pt_ids.length() > 0) {
						LOGGER.info("执行公文 平台 交换开始......");
						String enter = "\r\n";
						StringBuffer xml = new StringBuffer("<?xml version=\"1.0\" encoding=\"GBK\"?>").append(enter);
						xml.append("<elecdocument>").append(enter);
						xml.append("<exchange>").append(enter);
						xml.append("<sendcode>").append(AppContext.getSystemProperty("edoc.exc_from")).append("</sendcode>").append(enter);
						xml.append("<sender>信达资产</sender>").append(enter);
						xml.append("<sendtime>").append(Datetimes.format(new Date(), "yyyy-MM-dd HH:mm:ss")).append("</sendtime>").append(enter);
						xml.append("<receivecode>").append(sb_typeAndIds_pt_ids).append("</receivecode>").append(enter);
						xml.append("<receive>").append(sb_typeAndIds_pt_names).append("</receive>").append(enter);
						String edocid = String.valueOf(summary.getId());
						Date st = summary.getStartTime();
						String thirdId = Datetimes.format(st, "yyMMdd") + edocid.substring(edocid.length() - 3);//
						xml.append("<gwcode>").append(thirdId).append("</gwcode>").append(enter);
						xml.append("<flag>true</flag>").append(enter);
						xml.append("</exchange>").append(enter);
						xml.append("<gwelement>").append(enter);
						xml.append("<title>").append(repStr(summary.getSubject().replaceAll("<br>", ""))).append("</title>").append(enter);
						xml.append("<wenhao>").append(repStr(summary.getDocMark())).append("</wenhao>").append(enter);
						
						String jinji = hm_edoc_jjcd.get(summary.getUrgentLevel());
						jinji = jinji == null?"":jinji;
						xml.append("<jinji>").append(jinji).append("</jinji>").append(enter);
						
						//xml.append("<miji>").append(hm_edoc_miji.get(summary.getList1())).append("</miji>").append(enter);
						String miji = summary.getVarchar29()==null?"否":summary.getVarchar29();
						xml.append("<miji>").append(miji).append("</miji>").append(enter);
						//xml.append("<baosonguser>").append(user.getId()).append("</baosonguser>").append(enter);
						
						String baosonguser = "11031406";//默认孙光明CODE码
						V3xOrgMember member = orgManager.getMemberById(user.getId());
						if(member != null && Strings.isNotBlank(member.getCode())){
							baosonguser = member.getCode();
						}
						xml.append("<baosonguser>").append(baosonguser).append("</baosonguser>").append(enter);
						xml.append("<baosongname>").append(user.getName()).append("</baosongname>").append(enter);
						xml.append("<nianxian>").append(hm_edoc_danx.get(summary.getList3())).append("</nianxian>").append(enter);
						xml.append("<person_liable>").append(Functions.showDepartmentName(user.getDepartmentId())).append("</person_liable>").append(enter);
						xml.append("</gwelement>").append(enter);
						xml.append("<text>").append(enter);
						//String sysTemp = SystemEnvironment.getSystemTempFolder() + "/expedoc_temp/zip/" + summary.getId() + "/";
						String sysTemp = SystemEnvironment.getBaseFolder() + "/exportedoc/sendEdoc/zip/" + summary.getId() + "/";
						String zipPath = sysTemp + summary.getId() + ".zip";
						File zipFile = new File(zipPath);
						zipFile.getParentFile().mkdirs();
						List<File> listFiles = new ArrayList<File>();
						V3XFile vfzw = fileManager.getV3XFile(Long.valueOf(edoc_fileId));
						String px = ".pdf";
						if ("application/msword".equals(vfzw.getMimeType())) {
							px = ".doc";
						}
						String zwPath = sysTemp + edoc_fileId + px;
						File zwFile = new File(zwPath);
						FileUtils.writeByteArrayToFile(zwFile, fileManager.getFileBytes(Long.valueOf(edoc_fileId)));
						listFiles.add(zwFile);
						xml.append("<file attachname=\"").append(repStr(summary.getSubject() + "（正文）")).append("\">").append(edoc_fileId).append(px).append("</file>").append(enter);
						xml.append("</text>").append(enter);
						xml.append("<attach>").append(enter);
						List<Attachment> listAtt = attachmentManager.getByReference(summary.getId(), summary.getId());
						if (listAtt != null && listAtt.size() > 0) {
							for (Attachment ae : listAtt) {
								if(ae.getCategory() == 501){//背景资料不作为附件交换
									continue;
								}
								try{
									String fname = ae.getFilename();
									String pix = "";
									int stt = fname.lastIndexOf(".");
									if(stt > -1){
										pix = fname.substring(stt);
										fname = fname.substring(0, stt);
									}
									File tFile = new File(sysTemp + ae.getFileUrl() + pix);
									FileUtils.writeByteArrayToFile(tFile, fileManager.getFileBytes(ae.getFileUrl()));
									listFiles.add(tFile);
									xml.append("<attachfile attachname=\"" + repStr(fname) + "\">" + ae.getFileUrl() + pix + "</attachfile>").append(enter);
								
								}catch(Exception e){
									LOGGER.error("公文交换附件导出异常：", e);
								}
							}
						}
						xml.append("</attach>").append(enter);
						xml.append("</elecdocument>");
						File xmlFile = new File(sysTemp + "element.xml");
						FileUtils.writeStringToFile(xmlFile, xml.toString(), "GBK");
						listFiles.add(xmlFile);
						
						ZipUtil.zip(listFiles, zipFile);
						// 删除交换文
						/*
						for (File ff : listFiles) {
							ff.delete();
						}
						*/
						LOGGER.info("公文 平台 交换数据文件......");
						EdocExClient edocExClient = new EdocExClient(AppContext.getSystemProperty("edoc.exc_url"), Integer.valueOf(AppContext.getSystemProperty("edoc.exc_port")));
						msgIds = edocExClient.sendData(AppContext.getSystemProperty("edoc.exc_from"), sb_typeAndIds_pt_ids.toString(), zipFile.getAbsolutePath());
						if (msgIds != null && msgIds.length > 0) {
							
							for (int i = 0; i < details_pt.size(); i++) {
								EdocSendDetail esd = details_pt.get(i);
								if(msgIds.length <= i){
									esd.setContent("发送成功");
									esd.setRecUserName("公文管理员");
									continue;
								}
								esd.setContent("");//等待签收
								esd.setStatus(EdocSendDetail.Exchange_iStatus_SendDetail_Torecieve);
								EdocDetailMsgid edm = new EdocDetailMsgid();
								edm.setIdIfNew();
								edm.setDetailId(esd.getId());
								edm.setMsgId(msgIds[i]);
								edm.setRecordId(esd.getSendRecordId());
								cindaedocManager.saveObject(edm);
							}
						} else {
							LOGGER.info("公文 平台 交换数据文件失败。");
							for (EdocSendDetail esd : details_pt) {
								esd.setContent("");//发送失败
								esd.setRecUserName("公文管理员");
							}
						}
					}
				} catch (Exception e) {
					LOGGER.error("公文交换异常：", e);
					for (EdocSendDetail esd : details_pt) {
						esd.setContent("");
						LOGGER.error("公文交换异常：" + e.getMessage());
						esd.setRecUserName("公文管理员");
					}
				}
				if (!details_pt.isEmpty()) {
					edocSendDetailDao.updatePatchAll(details_pt);
				}
				// 客开 end
				
				//affair = affairManager.getBySubObject(ApplicationCategoryEnum.exSend, record.getId());
	
				Map<String, Object> conditions = new HashMap<String, Object>();
				conditions.put("app", ApplicationCategoryEnum.exSend.key());
	            conditions.put("objectId", record.getEdocId());
	            conditions.put("subObjectId", record.getId());
	            //OA-51995客户bug：重要A8-V5BUG_V5.0sp2_工银安盛人寿保险有限公司 _公文已经签收后，待办事项中仍显示待发送的公文_20140110022392
	            List<CtpAffair> affairList =affairManager.getByConditions(null,conditions);//(5.0sprint3)
	        	List<MessageReceiver> receivers = new ArrayList<MessageReceiver>();
	        	long memberId = agentToId==null ? user.getId() : agentToId;
	        	CtpAffair currentAffair = null;
	        	CtpAffair cloneAffair = null;
				if(null!=affairList && affairList.size()>0){
					for(CtpAffair af : affairList) {
						if(memberId == af.getMemberId()) {
							currentAffair = af;
						}
	            		if(af.getMemberId().longValue() != user.getId() && (af.isDelete()!= true)){
	            			receivers.add(new MessageReceiver(af.getId(), af.getMemberId()));
	            		}
						af.setState(StateEnum.edoc_exchange_sent.getKey());
						af.setDelete(true);
						af.setFinish(true);
						cloneAffair = (CtpAffair)af.clone();
						affairManager.updateAffair(af);
					}
				}
				if(currentAffair==null && cloneAffair!=null) {
					currentAffair = cloneAffair;
					currentAffair.setId(UUIDLong.longUUID());
					currentAffair.setMemberId(memberId);
					currentAffair.setState(StateEnum.edoc_exchange_sent.getKey());
					currentAffair.setSubState(SubStateEnum.col_pending_unRead.getKey());
					currentAffair.setDelete(true);
					currentAffair.setFinish(true);
					affairManager.save(currentAffair);
				}
	        	if(null!=receivers && receivers.size()>0){
	        		if(agentToId!=null){
	        			// 客开 start
	        			//userMessageManager.sendSystemMessage(new MessageContent(sendKey, affairList.get(0).getSubject(), agentToName,affairList.get(0).getApp()).add("edoc.agent.deal", user.getName()), ApplicationCategoryEnum.edocSend,agentToId, receivers,EdocMessageFilterParamEnum.exchange.key);
	        			// 客开 end
	        		}else{
	        			// 客开 start
	        			//userMessageManager.sendSystemMessage(new MessageContent(sendKey, affairList.get(0).getSubject(), userName,affairList.get(0).getApp()), ApplicationCategoryEnum.edocSend, user.getId(), receivers,EdocMessageFilterParamEnum.exchange.key);
	        			// 客开 end
	        		}
	        	}
	        	if(isResend){
	        		// 客开 start
	        		//operationlogManager.insertOplog(record.getId(), ApplicationCategoryEnum.exchange, EactionType.LOG_EXCHANGE_RDSEND, EactionType.LOG_EXCHANGE_RDSENDD_DESCRIPTION,user.getName(), record.getSubject());
	        		// 客开 end
	        	}else{
	        		// 客开 start
	        		//operationlogManager.insertOplog(record.getId(), ApplicationCategoryEnum.exchange, EactionType.LOG_EXCHANGE_SEND, EactionType.LOG_EXCHANGE_SEND_DESCRIPTION,user.getName(), record.getSubject());
	        		// 客开 end
	        	}
            } catch(Exception e) {
            	LOGGER.error("公文发送出错", e);
            } finally {
            	edocLockManager.unlock(Long.parseLong(id));
            }
        /***********************收文签收*********************/
		}else if(null!=modelType && !"".equals(modelType) && ("toReceive".equals(modelType) || "retreat".equals(modelType))){
			//签收公文,签收时候,更新发送状态;
			
		    //真实的签收单位收单位
		    String exchangeAccountId = request.getParameter("exchangeAccountId");
		    boolean isOpenRegister = true;
		    if(Strings.isNotBlank(exchangeAccountId)){
		        isOpenRegister = EdocSwitchHelper.isOpenRegister(Long.parseLong(exchangeAccountId));
		    }else {
		        isOpenRegister = EdocSwitchHelper.isOpenRegister(user.getAccountId());
            }
		    
			String recUserId = request.getParameter("recUserId"); 
			String registerUserId = request.getParameter("registerUserId");
			String recNo = request.getParameter("recNo");
			String remark = request.getParameter("remark");
			String keepperiod = request.getParameter("keepperiod");
			
			EdocRecieveRecord record = edocExchangeManager.getReceivedRecord(Long.valueOf(id));
			if(!checkEdocRecieveRecord(response, record, true)) {
				return null;
			}
			
			try {
			
				//G6 V1.0 SP1后续功能_自定义签收编号start
				String mark = "";
				if(Strings.isNotBlank(recNo)){
					EdocMarkModel em=EdocMarkModel.parse(recNo);
					Long markDefinitionId = em.getMarkDefinitionId();
					if(em.getDocMarkCreateMode()==com.seeyon.v3x.edoc.util.Constants.EDOC_MARK_EDIT_SELECT_NEW){
						edocMarkDefinitionManager.setEdocMarkCategoryIncrement(markDefinitionId);
					}
					mark = em.getMark();
				}
				
				//G6 V1.0 SP1后续功能_自定义签收编号end
				edocExchangeManager.recEdoc(Long.valueOf(id), Long.valueOf(recUserId), Long.valueOf(registerUserId), mark, remark,keepperiod,agentToId);
				//affair = affairManager.getBySubObject(ApplicationCategoryEnum.exSign, record.getId());
				
				Map<String, Object> conditions = new HashMap<String, Object>();
				conditions.put("app", ApplicationCategoryEnum.exSign.key());
	            conditions.put("objectId", record.getEdocId());
	            conditions.put("subObjectId", record.getId());
	            List<CtpAffair> affairList =affairManager.getByConditions(null,conditions);   
	            
	            if(null!=affairList && affairList.size()>0){
	            	List<MessageReceiver> receivers = new ArrayList<MessageReceiver>();
	            	for(CtpAffair af: affairList){
	            		if(af.getMemberId().longValue() != user.getId() && af.isDelete()!= true){
	            			receivers.add(new MessageReceiver(af.getId(), af.getMemberId()));
	            		}
	            		af.setState(StateEnum.edoc_exchange_received.getKey());
	            		//af.setSubObjectId(Long.valueOf(id));
	            		af.setFinish(true);
	            		af.setDelete(true);
	            		affairManager.updateAffair(af);
	            	}
	    	        /*
	    	         *发消息给其他公文收发员，公文已签收 
	    	         */
	            	if(null!=receivers && receivers.size()>0){
	            		if(agentToId != null){
	            			userMessageManager.sendSystemMessage(new MessageContent("exchange.signed", affairList.get(0).getSubject(), agentToName,affairList.get(0).getApp()).add("edoc.agent.deal", user.getName()), ApplicationCategoryEnum.edocRec, agentToId, receivers,EdocMessageFilterParamEnum.exchange.key);
	            		}else{
	            			userMessageManager.sendSystemMessage(new MessageContent("exchange.signed", affairList.get(0).getSubject(), userName,affairList.get(0).getApp()), ApplicationCategoryEnum.edocRec, user.getId(), receivers,EdocMessageFilterParamEnum.exchange.key);
	            		}
	            	}
	            }
	            //修改了record对象后，再次获得最新的,不然从record中取登记人id就不对了
	            record = edocExchangeManager.getReceivedRecord(Long.valueOf(id));
				
	            
	          //每个版本都需要录入登记日志
				operationlogManager.insertOplog(record.getId(), ApplicationCategoryEnum.exchange, EactionType.LOG_EXCHANGE_REC, 
						EactionType.LOG_EXCHANGE_RECD_DESCRIPTION, user.getName(), record.getSubject());	        
				//xiangfan 添加日志GOV-1206
		        appLogManager.insertLog(user, AppLogAction.Edoc_Sing_Exchange, user.getName(), record.getSubject());
	            
		        RecieveEdocManager recieveEdocManager = (RecieveEdocManager)AppContext.getBean("recieveEdocManager");
	            //当是V5-A8版本或G6开启登记开关时，那么签收时就按照以前逻辑，生成待登记affair
				if(!EdocHelper.isG6Version()||isOpenRegister){
		            CtpAffair reAffair = new CtpAffair();  // 登记人代办事项
		            EdocSummary summary = edocSummaryManager.findById(record.getEdocId());
		            ExchangeUtil.createRegisterAffair(reAffair, user, record, summary,StateEnum.edoc_exchange_register.getKey());
		            affairManager.save(reAffair);
			        
		            /*
			         * 发消息给待登记人
			         */
			        sendMessageToRegister(user, agentToId, reAffair);
		            
			        //A8签收时也生成登记数据 
			        if(!EdocHelper.isG6Version()){
			        	EdocRegister register = ExchangeUtil.createAutoRegisterData(record, summary, record.getRegisterUserId(), orgManager);
				        edocRegisterManager.createEdocRegister(register);
				    }
				}
				//当G6版本关闭登记开关时，那么签收时，还要生成登记数据，并生成待分发affair
				else{
					CtpAffair reAffair = new CtpAffair();  // 登记人已办事项
					EdocSummary summary = edocSummaryManager.findById(record.getEdocId());
					ExchangeUtil.createRegisterAffair(reAffair, user, record,summary, StateEnum.edoc_exchange_registered.getKey());
			        affairManager.save(reAffair);
			        
			        //原来G6自动登记中有这个
			        appLogManager.insertLog(user, AppLogAction.Edoc_RegEdoc, user.getName(),record.getSubject());
			        
			        //分发人(当登记开关关闭时，在签收时就可直接选择分发人了)
			        long distributerId = Long.parseLong(registerUserId);
			        
			        //生成登记数据 
			        EdocRegister register = ExchangeUtil.createAutoRegisterData(record, summary, distributerId, orgManager);
			        edocRegisterManager.createEdocRegister(register);
			        
			        if(record!=null) {
			        	record.setStatus(EdocRecieveRecord.Exchange_iStatus_Registered);
			        	record.setRegisterName(register.getRegisterUserName());
			        	recieveEdocManager.update(record);
				    }
			        
			        Integer urgentLevel = null;
			        if(Strings.isNotBlank(register.getUrgentLevel()) && NumberUtils.isNumber(register.getUrgentLevel())){
			        	urgentLevel = Integer.parseInt(register.getUrgentLevel());
			        }
			      //v3x_affair表中增加待分发事项
			        distributeAffair(register.getSubject(),register.getRegisterUserId(),register.getDistributerId(),register.getId(),
			        		register.getDistributeEdocId(),"create",urgentLevel,register.getRegisterBody().getContentType());
			        
	//		        String key = "edoc.registered"; //成功登记 (这个消息是  已成功登记，请分发，需要改为下面这个)
			        String key = "edoc.auto.registered"; //这个消息是  已成功签收，请分发
					long registerId = register.getId();
					distributerId = register.getDistributerId();
					String subject = register.getSubject();
					String url = "message.link.exchange.distribute"; 
					com.seeyon.ctp.common.usermessage.Constants.LinkOpenType linkOpenType = com.seeyon.ctp.common.usermessage.Constants.LinkOpenType.href;
					String agentApp = "agent";
					
					agentToName = "";
	//				String registerName = member.getName();//登记人
					//
					String recieverName = orgManager.getMemberById(record.getRecUserId()).getName();
	
					//给分发人的代理人发消息
					sendRegisterMessage(key , subject, recieverName, agentToName, register.getRegisterUserId(), registerId, distributerId,
			        			"", "", url, linkOpenType, registerId, "");
					
					Long agentMemberId =  MemberAgentBean.getInstance().getAgentMemberId(ApplicationCategoryEnum.edoc.key(), register.getDistributerId()); 
					if(agentMemberId != null){
						sendRegisterMessage(key , subject, recieverName, agentToName, register.getRegisterUserId(), registerId, agentMemberId, 
								"col.agent", "", url, linkOpenType, registerId, agentApp);
					}
				}
			} catch(Exception e) {
				LOGGER.error("公文签收出错", e);
			} finally {
				edocLockManager.unlock(Long.parseLong(id));
			}
	    }
		
		Boolean f = (Boolean)(BrowserFlag.PageBreak.getFlag(request));
		out.println("<script>");
		if (f.booleanValue()) {
			out.println("parent.doEndSign_exchange('','"+affairId+"');"); 
		} else {
			out.println("window.getA8Top().close();");
		}
		out.println("</script>");
		
		return null;
	}
	
	// 客开 start
	private String repStr(String name) {
		if (name == null || name.length() == 0) {
			return name;
		}
		name = name.replaceAll("&", "&amp;");
		name = name.replaceAll(">", "&gt;");
		name = name.replaceAll("<", "&lt;");
		name = name.replaceAll("\"", "&quot;");
		name = name.replaceAll("\'", "&apos;");
		name = name.replaceAll("\r\n", "");
		name = name.replaceAll("\r", "");
		name = name.replaceAll("\n", "");
		return name;
	}
	
//	private String transform(Document document, String xslFile) {
//		String head = "<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><title></title></head><BODY>";
//		String end = "</BODY></HTML>";
//		try {
//			TransformerFactory factory = TransformerFactory.newInstance();
//			InputStream inputStream = new ByteArrayInputStream(xslFile.getBytes("utf-8"));
//			StreamSource xsl = new StreamSource(inputStream);
//			Transformer transformer = factory.newTransformer(xsl);
//
//			Properties props = transformer.getOutputProperties();
//			props.setProperty(OutputKeys.ENCODING, "UTF-8");
//			props.setProperty(OutputKeys.METHOD, "html");
//			props.setProperty(OutputKeys.VERSION, "4.0");
//			transformer.setOutputProperties(props);
//
//			DocumentSource docSource = new DocumentSource(document);
//			StringWriter strWriter = new StringWriter();
//			StreamResult docResult = new StreamResult(strWriter);
//			transformer.transform(docSource, docResult);
//			
//			String html = strWriter.toString();
//			return head + html + end;
//		} catch (Exception e) {
//			return head + "公文文单生成失败：" + e.getMessage() + end;
//		}
//	}
	
	private String getFileName(String name) {
		return name.replaceAll("<", "《").replaceAll(">", "》").replaceAll(":", "：").replaceAll("\r\n", "").replaceAll("\r", "").replaceAll("\n", "");
	}
	
	private String getToken() {
		AuthorityServiceStub.Authenticate req = new AuthorityServiceStub.Authenticate();
		req.setUserName("service-admin");
		req.setPassword(AppContext.getSystemProperty("webservice.password"));
		
		AuthorityServiceStub stub;
		try {
			stub = new AuthorityServiceStub("http://127.0.0.1:" + AppContext.getSystemProperty("edoc.oa_port") + "/seeyon/services/authorityService?wsdl");
			AuthorityServiceStub.AuthenticateResponse resp = stub.authenticate(req);
			AuthorityServiceStub.UserToken token = resp.get_return();
			if(token.getId() != null && !"".equals(token.getId())) {
				return token.getId();
			}
		} catch (Exception e) {
			return null;
		}
		return null;
	}
    
    private Long upLoadFile(InputStream finput, String filename, String loginName, String token) throws Exception{
		URL preUrl = null;
		URLConnection uc = null;
		// Ip地址可变
		preUrl = new URL("http://127.0.0.1:" + AppContext.getSystemProperty("edoc.oa_port") 
				+"/seeyon/uploadService.do?method=processUploadService&senderLoginName=" 
		        + loginName + "&token=" + token);
		uc = preUrl.openConnection();
		HttpURLConnection hc = (HttpURLConnection) uc;
		hc.setDoOutput(true);
		hc.setUseCaches(false);
		hc.setRequestProperty("contentType", "charset=utf-8");
		hc.setRequestMethod("POST");
		
		//根据文件真实路径获取文件
		BufferedInputStream input = new BufferedInputStream(finput);
		
		String BOUNDARY = "---------------------------7d4a6d158c9";
		//真实的文件名称
		StringBuffer sb = new StringBuffer();
		sb.append("--");
		sb.append(BOUNDARY);
		sb.append("\r\n");
		sb.append("Content-Disposition: form-data; \r\n name=\"1\"; filename=\""
				+ filename + "\"\r\n");
		sb.append("Content-Type: application/msword\r\n\r\n");
		hc.setRequestProperty("Content-Type", "multipart/form-data;boundary="
				+ "---------------------------7d4a6d158c9");
		byte[] end_data = ("\r\n--" + BOUNDARY + "--\r\n").getBytes();
		DataOutputStream dos = new DataOutputStream(hc.getOutputStream());
		dos.write(sb.toString().getBytes("utf-8"));
		int cc = 0;
		while ((cc = input.read()) != -1) {
			dos.write(cc);
		}
		dos.write(end_data);
		dos.flush();
		dos.close();
		input.close();
		finput.close();
		InputStream is = hc.getInputStream();
		if (is != null) {
			StringBuilder resultBuffer = new StringBuilder();
			String line = "";
			BufferedReader reader = new BufferedReader(new InputStreamReader(is, "utf-8"));
			while ((line = reader.readLine()) != null) {
				resultBuffer.append(line);
			}
			reader.close();
			is.close();
			if(resultBuffer.toString().length() > 0){
				return Long.parseLong(resultBuffer.toString());
			}
		}
		return null;
	}
	// 客开 end
	
	/**
	 * G6 V1.0 SP1后续功能_签收时自动登记功能  changyi
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView changeAutoRegister(HttpServletRequest request,HttpServletResponse response)throws Exception{
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter out = response.getWriter();    
		User user = AppContext.getCurrentUser();
		String id = request.getParameter("id");
		String affairId = request.getParameter("affairId");
		if(Strings.isBlank(id)){
			return null;
		}
		
		//xiangfan添加  实时判断是否取消了收文自动登记的开关
		if(!EdocSwitchHelper.allowAutoRegister()){
			String msg = "alert('"+ResourceUtil.getString("edoc.error.close.autoRegister")+"');parent.location.reload();";//公文管理员已经关闭了收文自动登记的功能！
			this.rendJavaScript(response, msg);
			return null;
		}
		String userName = "";
		if(null!=user){
			userName = user.getName();
		}
		
		Long agentToId = null;//被代理人ID
		String agentToName = "";
		if(Strings.isNotBlank(affairId)){
			CtpAffair affair = affairManager.get(Long.valueOf(affairId));
			if(!affair.getMemberId().equals(user.getId())){
				agentToId = affair.getMemberId();
				V3xOrgMember member = orgManager.getMemberById(agentToId);
				agentToName = member.getName();
			}
		}
		
		//签收公文,签收时候,更新发送状态;
		
		String recUserId = request.getParameter("recUserId");
		String registerUserId = request.getParameter("registerUserId");
		String recNo = request.getParameter("recNo");
		String remark = request.getParameter("remark");
		String keepperiod = request.getParameter("keepperiod");
		EdocRecieveRecord record = edocExchangeManager.getReceivedRecord(Long.valueOf(id));
		if(!checkEdocRecieveRecord(response, record, false)) {
			return null;
		}
		//G6 V1.0 SP1后续功能_自定义签收编号start
		EdocMarkModel em=EdocMarkModel.parse(recNo);
		Long markDefinitionId = em.getMarkDefinitionId();
		if(em.getDocMarkCreateMode()==com.seeyon.v3x.edoc.util.Constants.EDOC_MARK_EDIT_SELECT_NEW){
			edocMarkDefinitionManager.setEdocMarkCategoryIncrement(markDefinitionId);
		}
		//G6 V1.0 SP1后续功能_自定义签收编号end
		edocExchangeManager.recEdoc(Long.valueOf(id), Long.valueOf(recUserId), Long.valueOf(registerUserId), em.getMark(), remark,keepperiod,agentToId);
		//affair = affairManager.getBySubObject(ApplicationCategoryEnum.exSign, record.getId());
		//修改了record对象后，再次获得最新的
		record = edocExchangeManager.getReceivedRecord(Long.valueOf(id));
		Map<String, Object> conditions = new HashMap<String, Object>();
		conditions.put("app", ApplicationCategoryEnum.exSign.key());
        conditions.put("objectId", record.getEdocId());
        conditions.put("subObjectId", record.getId());
        List<CtpAffair> affairList =affairManager.getByConditions(null,conditions);  
        
        if(null!=affairList && affairList.size()>0){
        	List<MessageReceiver> receivers = new ArrayList<MessageReceiver>();
        	for(CtpAffair af: affairList){
        		if(!user.getId().equals(af.getMemberId()) && !af.isDelete()){
        			receivers.add(new MessageReceiver(af.getId(), af.getMemberId()));
        		}
        		af.setState(StateEnum.edoc_exchange_received.getKey());
        		af.setSubObjectId(Long.valueOf(id));
        		af.setFinish(true);
        		af.setDelete(true);
        		affairManager.updateAffair(af);
        	}
	        /*
	         *发消息给其他公文收发员，公文已签收 
	         */
        	if(null!=receivers && receivers.size()>0){
        		if(agentToId != null){
        			userMessageManager.sendSystemMessage(new MessageContent("exchange.signed", affairList.get(0).getSubject(), agentToName,affairList.get(0).getApp()).add("edoc.agent.deal", user.getName()), ApplicationCategoryEnum.edocRec, agentToId, receivers,EdocMessageFilterParamEnum.exchange.key);
        		}else{
        			userMessageManager.sendSystemMessage(new MessageContent("exchange.signed", affairList.get(0).getSubject(), userName,affairList.get(0).getApp()), ApplicationCategoryEnum.edocRec, user.getId(), receivers,EdocMessageFilterParamEnum.exchange.key);
        		}
        	}
        }

		CtpAffair reAffair = new CtpAffair();  // 登记人已办事项
		reAffair.setIdIfNew();
		reAffair.setApp(ApplicationCategoryEnum.edocRegister.getKey());
		reAffair.setSubject(record.getSubject());
		reAffair.setCreateDate(new Timestamp(System.currentTimeMillis()));
		reAffair.setReceiveTime(new Timestamp(System.currentTimeMillis()));
		reAffair.setMemberId(record.getRegisterUserId());
		reAffair.setSenderId(user.getId());
		reAffair.setObjectId(record.getEdocId());
		reAffair.setSubObjectId(record.getId());
		reAffair.setSenderId(user.getId());
		reAffair.setState(StateEnum.edoc_exchange_registered.getKey());
		reAffair.setTrack(null);	
		//wangjinging 待办事项 待登记 匹配条件 begin
		reAffair.setAddition("sendUnitId="+record.getExchangeOrgId());
		//wangjinging 待办事项 待登记 匹配条件 end
		if(record.getUrgentLevel()!=null && !"".equals(record.getUrgentLevel()))
			reAffair.setImportantLevel(Integer.parseInt(record.getUrgentLevel()));
		
		reAffair.setCompleteTime(new Timestamp(new Date().getTime()));
		
		//首页栏目的扩展字段设置--公文文号、发文单位等--start
		EdocSummary summary = edocSummaryManager.findById(record.getEdocId());
		Map<String, Object> extParam=EdocUtil.createExtParam(record.getDocMark(),record.getSendUnit(),summary.getSendUnitId());
		if(null != extParam)  AffairUtil.setExtProperty(reAffair, extParam);
		//首页栏目的扩展字段设置--公文文号、发文单位等--end
		
        affairManager.save(reAffair);
        
        operationlogManager.insertOplog(record.getId(), ApplicationCategoryEnum.exchange, EactionType.LOG_EXCHANGE_REC, EactionType.LOG_EXCHANGE_RECD_DESCRIPTION, user.getName(), record.getSubject());
        appLogManager.insertLog(user, AppLogAction.Edoc_RegEdoc, user.getName(),record.getSubject());
        /*
         * 发消息给待登记人
         */
//		sendMessageToRegister(user, agentToId, reAffair);//待登记人不需要消息了
		//xiangfan 添加日志GOV-1206
     
        appLogManager.insertLog(user, AppLogAction.Edoc_Sing_Exchange, user.getName(), record.getSubject());
          
        
        //签收完了，就登记
        EdocRegister register = new EdocRegister();
        register.setNewId();
        register.setRecTime(record.getRecTime());
        register.setRecieveId(record.getId());
        register.setSubject(record.getSubject());
        register.setRegisterType(EdocNavigationEnum.RegisterType.ByAutomatic.ordinal());//电子登记
        register.setRegisterUserId(record.getRegisterUserId());
        register.setCreateUserId(record.getRegisterUserId());
        V3xOrgMember member = orgManager.getMemberById(record.getRegisterUserId());
        register.setCreateUserName(member.getName());
        
        register.setRegisterUserName(member.getName());
        register.setDistributeEdocId(-1l);
        
        //单位id就是登记人所在单位id
        long accountId = member.getOrgAccountId();
        
        register.setUrgentLevel(record.getUrgentLevel());
        register.setSendTo(record.getSendTo());
        register.setState(2);//已登记
        register.setEdocType(1);//收文
        register.setEdocId(record.getEdocId());
        register.setDocType(record.getDocType());
        register.setDocMark(record.getDocMark());
        register.setCreateTime(new java.sql.Timestamp(new Date().getTime()));
        register.setUpdateTime(new java.sql.Timestamp(new Date().getTime()));
        register.setRegisterDate(new java.sql.Date(new Date().getTime()));
        register.setIsRetreat(EdocNavigationEnum.RegisterRetreatState.NotRetreat.ordinal());//非退回
        register.setDistributeState(EdocNavigationEnum.EdocDistributeState.WaitDistribute.ordinal());//待分发状态
        
        V3xOrgAccount account = orgManager.getAccountById(accountId);
        register.setSendUnit(account==null?"":account.getName());
        register.setSendUnitId(account.getId());
        register.setSendUnitType(record==null? 1 : record.getSendUnitType());
        register.setSecretLevel(record==null? "1" : record.getSecretLevel());
        register.setUrgentLevel(record==null? "1" : record.getUrgentLevel());
        
        /* xiangfan G6 V1.0 SP1后续功能_签收时自动登记功能  修复文单没有保密期限时 存入的值为‘null’字符串 导致 分发时报错 Start*/
        String summarykeepPeriod = null;
        if(null != summary.getKeepPeriod()){
        	summarykeepPeriod = String.valueOf(summary.getKeepPeriod());
        }
        /* xiangfan G6 V1.0 SP1后续功能_签收时自动登记功能  修复文单没有保密期限时 存入的值为‘null’字符串 导致 分发时报错 End*/
        register.setKeepPeriod(summary==null? record==null?"":record.getKeepPeriod() : summarykeepPeriod);
        register.setSendType(summary==null? "1" : summary.getSendType());
        register.setKeywords(summary==null? "" : summary.getKeywords());
        register.setIssuerId(-1l);
        register.setIssuer(summary==null? "" : summary.getIssuer());
        register.setEdocDate(summary==null? null : summary.getSigningDate());
        /*if(register.getEdocDate()==null) {//如果没有签发时间，则显示为封发时间
        	register.setEdocDate(summary==null ? null : new java.sql.Date(summary.getPackTime().getTime()));
        }
        */
        
        String sendTo = summary==null? "" : summary.getSendTo();
        String recordSendTo = record==null? "" : record.getSendTo();
        String copyTo = summary==null? "" : summary.getCopyTo();
        String recordCopyTo = record==null? "" : record.getCopyTo();
        register.setSendTo(Strings.isBlank(sendTo)?recordSendTo:sendTo);
        register.setSendToId(summary==null?"":summary.getSendToId());
        register.setCopyTo(Strings.isBlank(copyTo)?recordCopyTo:copyTo);
        register.setCopyToId(summary==null?"":summary.getCopyToId());
        
        List<Attachment> attachmentList = new ArrayList<Attachment>();
      //附件信息
        if(summary != null) {
        	attachmentList = attachmentManager.getByReference(summary.getId(), summary.getId());
        }
        register.setIdentifier("00000000000000000000");
        register.setAttachmentList(attachmentList);
        register.setHasAttachments(attachmentList.size()>0);
        
        
        register.setEdocUnit(record.getSendTo());
        register.setEdocUnitId(String.valueOf(accountId));
        
        
        /**---------- 获得分发人--------------**/
        //获得签收类型
        long exchangeOrgId = record.getExchangeOrgId();
		int exchangeType = record.getExchangeType();
		V3xOrgEntity entity = null;
		long recAccountId = 0L;
		//签收单位为部门时
		if(exchangeType == EdocRecieveRecord.Exchange_Receive_iAccountType_Dept){
			recAccountId = orgManager.getDepartmentById(exchangeOrgId).getOrgAccountId();
		}
		//签收单位为单位时
		else if(exchangeType == EdocRecieveRecord.Exchange_Receive_iAccountType_Org){
			entity=orgManager.getGlobalEntity(V3xOrgEntity.ORGENT_TYPE_ACCOUNT, exchangeOrgId);
			recAccountId = entity.getId();
		}
        /**获得分发人id,传递参数(登记人id,签收单位id(可能为兼职单位))**/
        long distributerId = this.edocExchangeManager.getDistributeUser(configManager,register.getRegisterUserId(),recAccountId);
        register.setDistributerId(distributerId);
        //分发人名称
        register.setDistributer(orgManager.getMemberById(distributerId).getName());
        
        register.setOrgAccountId(member.getOrgAccountId());
        register.setIdentifier("00000000000000000000");
        
        RegisterBody registerBody = null;
      //装载公文正文
        if(summary !=null && record!=null) {
        	EdocBody edocBody = summary.getBody(record.getContentNo().intValue());
        	registerBody = new RegisterBody();
        	edocBody = edocBody==null?summary.getFirstBody() : edocBody;
			if(null != edocBody){
				registerBody.setIdIfNew();
				registerBody.setContent(edocBody.getContent());
				registerBody.setContentNo(edocBody.getContentNo());
				registerBody.setContentType(edocBody.getContentType());
				registerBody.setCreateTime(edocBody.getLastUpdate());
				register.setRegisterBody(registerBody);	
			}
        } else {
        	registerBody = new RegisterBody();
        	String bodyContentType=com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_OFFICE_WORD;
            if(com.seeyon.ctp.common.SystemEnvironment.hasPlugin("officeOcx")==false) {
            	bodyContentType = com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_HTML;
            }
            registerBody.setIdIfNew();
        	registerBody.setContentType(bodyContentType);
        	registerBody.setCreateTime(new java.sql.Timestamp(new java.util.Date().getTime()));
        	register.setRegisterBody(registerBody);
        }
        if(summary!=null && !Strings.isBlank(summary.getSendUnit()) && !Strings.isBlank(summary.getSendUnitId())) {
        	register.setEdocUnit(summary.getSendUnit());
        	register.setEdocUnitId(summary.getSendUnitId());
        }else{//lijl添加else，如果来文单位为空,则取record里的来文单位
        	register.setEdocUnit(record==null?"":record.getSendUnit());
        }
        if(registerBody!=null){
        	registerBody.setEdocRegister(register);
        }
        
        register.setSerialNo("");
        //保存登记对象
        edocRegisterManager.createEdocRegister(register);
        
        
        if(record!=null) {
        	record.setStatus(EdocRecieveRecord.Exchange_iStatus_Registered);
//        	record.setRegisterTime(new java.sql.Timestamp(register.getRegisterDate().getTime()));
        	record.setRegisterName(register.getRegisterUserName());
        	recieveEdocManager.update(record);
	    }
        //给登记人发送消息
        //收文《XX》已自动登记，记录在您的已登记列表中，请知晓
        String url = "message.link.exchange.autoregistered.GOV"; 
        com.seeyon.ctp.common.usermessage.Constants.LinkOpenType linkOpenType = com.seeyon.ctp.common.usermessage.Constants.LinkOpenType.open;
        //给登记人员已登记消息，创建登记人员的接收实例
        List<MessageReceiver> receivers = new ArrayList<MessageReceiver>(1);
        receivers.add(new MessageReceiver(reAffair.getId(),reAffair.getMemberId(),url, linkOpenType,register.getId()));
        MessageContent messageContent = new MessageContent("auto.recieved", summary.getSubject());
        messageContent.setResource("com.seeyon.v3x.exchange.resources.i18n.ExchangeResource");
        userMessageManager.sendSystemMessage(messageContent, ApplicationCategoryEnum.edocRec, register.getRegisterUserId(), receivers,EdocMessageFilterParamEnum.exchange.key);
        /* xiangfan G6 V1.0 SP1后续功能_签收时自动登记功能 修复 '紧急程度'为空时报红三角的错误GOV-5180 Start*/
        Integer urgentLevel = null;
        if(Strings.isNotBlank(register.getUrgentLevel()) && NumberUtils.isNumber(register.getUrgentLevel())){
        	urgentLevel = Integer.parseInt(register.getUrgentLevel());
        }
        /* xiangfan G6 V1.0 SP1后续功能_签收时自动登记功能 修复 '紧急程度'为空时报红三角的错误GOV-5180 End*/
        //v3x_affair表中增加待分发事项
        distributeAffair(register.getSubject(),register.getRegisterUserId(),register.getDistributerId(),register.getId(),summary.getId(),
        		"create",urgentLevel,registerBody.getContentType());
        
        String key = "edoc.registered"; //成功登记
		long registerId = register.getId();
		distributerId = register.getDistributerId();
		String subject = register.getSubject();
		//url = "message.link.exchange.registered.GOV"; 
		url = "message.link.exchange.distribute";
		linkOpenType = com.seeyon.ctp.common.usermessage.Constants.LinkOpenType.href;
		String agentApp = "agent";
		
		agentToName = "";
		String registerName = member.getName();//登记人

		//给分发人的代理人发消息
		sendRegisterMessage(key , subject, registerName, agentToName, register.getRegisterUserId(), registerId, distributerId,
        			"", "", url, linkOpenType, registerId, "");
		
		Long agentMemberId =  MemberAgentBean.getInstance().getAgentMemberId(ApplicationCategoryEnum.edoc.key(), register.getDistributerId()); 
		if(agentMemberId != null){
			sendRegisterMessage(key , subject, registerName, agentToName, register.getRegisterUserId(), registerId, agentMemberId, 
					"col.agent", "", url, linkOpenType, registerId, agentApp);
		}		
        
        Boolean f = (Boolean)(BrowserFlag.PageBreak.getFlag(request));
		out.println("<script>");
		if (f.booleanValue()) {
			out.println("parent.doEndSign_exchange('','"+affairId+"');"); 
		} else {
			out.println("window.getA8Top().close();");
		}
		out.println("</script>");
        
		return null;
	}
	

	
	/**
	 * G6 V1.0 SP1后续功能_签收时自动登记功能  --- 待分发事项存入v3x_affair表
	 * @param subject
	 * @param senderId
	 * @param memberId
	 * @param objectId
	 * @param subObjectId
	 * @param comm
	 * @param importantLevel
	 * @param bodyType
	 * @throws BusinessException 
	 */
	 private void distributeAffair(String subject, long senderId, long memberId, Long objectId, Long subObjectId, String comm, Integer importantLevel, String...bodyType) throws BusinessException {
	    	CtpAffair reAffair = null;
	    	if("delete".equals(comm)) {
	    		affairManager.deleteByObjectId(ApplicationCategoryEnum.edocRegister, objectId);
	    	} else if("create".equals(comm)) {//这里注意，登记ojbectId, subState  分发：subObjectId, state
	    		reAffair = new CtpAffair();
	    		reAffair.setIdIfNew();
	    		reAffair.setDelete(false);
	    		reAffair.setSubject(subject);
	    		reAffair.setMemberId(memberId);
	    		reAffair.setSenderId(senderId);    		
	    		reAffair.setCreateDate(new Timestamp(System.currentTimeMillis()));
	    		reAffair.setReceiveTime(new Timestamp(System.currentTimeMillis()));
	    		reAffair.setObjectId(objectId);//登记的id
	    		reAffair.setSubObjectId(subObjectId);//分发的id
	    		// wangjingjing begin 发文分发 等于 交换中心的 待发送，所以这里的分发一定是 收文分发
	    		reAffair.setApp(ApplicationCategoryEnum.edocRecDistribute.getKey());
	    		//reAffair.setApp(31);
	    		// wangjingjing end
	        	reAffair.setState(3);//分发的状态
	        	
	        	//-------------待分发列表没有显示word图标bug 修复  changyi add
	        	if(bodyType !=null && bodyType.length == 1)
	        		reAffair.setBodyType(bodyType[0]);
	        	reAffair.setImportantLevel(importantLevel);
	    		affairManager.save(reAffair);
	    	}
	    }
	
	 /**
	  * G6 V1.0 SP1后续功能_签收时自动登记功能  --- 向待分发人员发送消息
	  * @param key
	  * @param subject
	  * @param userName
	  * @param agentName
	  * @param fromUserId
	  * @param registerId
	  * @param toUserId
	  * @param colAgent
	  * @param agentDeal
	  * @param url
	  * @param linkType
	  * @param param
	  * @param agentApp
	  * @throws Exception
	  */
	 private void sendRegisterMessage(String key, String subject, String userName, String agentName, long fromUserId, long registerId,
			 long toUserId, String colAgent, String agentDeal, String url, com.seeyon.ctp.common.usermessage.Constants.LinkOpenType linkType, 
			 long param, String agentApp) throws Exception { 
			MessageReceiver receiver = new MessageReceiver(registerId, toUserId, url, linkType, EdocEnum.edocType.recEdoc.ordinal(),
					String.valueOf(registerId), agentApp);
			MessageContent messageContent = new MessageContent(key, subject, userName);
			messageContent.setResource("com.seeyon.v3x.edoc.resources.i18n.EdocResource");
			messageContent.add(colAgent);
			messageContent.add(agentDeal, agentName);
			userMessageManager.sendSystemMessage(messageContent, ApplicationCategoryEnum.edocRecDistribute, fromUserId, receiver,EdocMessageFilterParamEnum.exchange.key);
			//XX已成功登记公文《XX》，请速进行分发处理’点击消息提醒链接到收文分发页面（用户在个人设置-消息提示设置里关闭收文的提示消息后不弹出该消息）
//			userMessageManager.sendSystemMessage(messageContent, ApplicationCategoryEnum.edocRec, fromUserId, receiver);
	    }
	
	
	private void sendMessageToRegister(User user, Long agentToId, CtpAffair reAffair) throws MessageException {
		String url = "message.link.exchange.register.pending"+Functions.suffix();
		List<String> messageParam = new ArrayList<String>();
		if(EdocHelper.isG6Version()){
			url = "message.link.exchange.register.govpending";
			/**
			 * G6点登记消息，转到登记页面地址
			 * http://localhost:8088/seeyon/edocController.do?method=newEdocRegister&comm=create&edocType=1&registerType=1
			 * &recieveId=179946784204145713&edocId=6526010927409218030&sendUnitId=8958087796226541112&listType=registerPending
			 */
			
			messageParam.add(reAffair.getSubObjectId().toString());
			messageParam.add(reAffair.getObjectId().toString());
			try {
				EdocSummary summary = edocManager.getEdocSummaryById(reAffair.getObjectId(), false);
				//设置来文单位id
				messageParam.add(String.valueOf(summary.getOrgAccountId()));
			} catch (EdocException e) {
				LOGGER.error("根据id获取公文summary对象报错",e);
			}
			
		}else{
			/**
			 * A8点登记消息，转到收文新建页面地址
			 * /edocController.do?method=entryManager&amp;entry=recManager&amp;listType=newEdoc&amp;comm=register&amp;
			 * edocType={0}&amp;recieveId={1}&amp;edocId={2}
			 * 
			 */
			messageParam.add(String.valueOf(EdocEnum.edocType.recEdoc.ordinal()));
			messageParam.add(reAffair.getSubObjectId().toString());
			messageParam.add(reAffair.getObjectId().toString());
		}
		
		String key = "edoc.register";
		String userName = user.getName();
		//代理
		LinkOpenType linkOpenType = com.seeyon.ctp.common.usermessage.Constants.LinkOpenType.href;
		if(agentToId!=null){
			String agentToName= "";
			try{
				agentToName = orgManager.getMemberById(agentToId).getName();
			}catch(Exception e){
				LOGGER.error("获取代理人名字抛出异常", e);
			}
			MessageReceiver receiver = new MessageReceiver(reAffair.getId(), reAffair.getMemberId(),url, linkOpenType, messageParam.get(0),messageParam.get(1),messageParam.get(2), "" , reAffair.getAddition());
			try {
                userMessageManager.sendSystemMessage(new MessageContent(key,reAffair.getSubject(),agentToName).add("edoc.agent.deal", user.getName()), 
                		ApplicationCategoryEnum.edocRegister, agentToId, receiver,EdocMessageFilterParamEnum.exchange.key);
            } catch (BusinessException e) {
                LOGGER.error("", e);
            }
			
			Long agentMemberId =  MemberAgentBean.getInstance().getAgentMemberId(ApplicationCategoryEnum.edoc.key(), reAffair.getMemberId()); 
			if(agentMemberId != null){
				MessageReceiver agentReceiver = new MessageReceiver(reAffair.getId(), agentMemberId,url, linkOpenType, messageParam.get(0),messageParam.get(1),messageParam.get(2), "agent", reAffair.getAddition());
				try {
                    userMessageManager.sendSystemMessage(new MessageContent(key,reAffair.getSubject(),agentToName).add("edoc.agent.deal", user.getName()).add("col.agent")
                    		, ApplicationCategoryEnum.edocRegister, agentToId, agentReceiver,EdocMessageFilterParamEnum.exchange.key);
                } catch (BusinessException e) {
                    LOGGER.error("", e);
                }
			}
		}else{
			//非代理
			MessageReceiver receiver = new MessageReceiver(reAffair.getId(), reAffair.getMemberId(),url, linkOpenType, messageParam.get(0),messageParam.get(1),messageParam.get(2), "", reAffair.getAddition());
			try {
                userMessageManager.sendSystemMessage(new MessageContent(key,reAffair.getSubject(),userName)
                	, ApplicationCategoryEnum.edocRegister, user.getId(), receiver,EdocMessageFilterParamEnum.exchange.key);
            } catch (BusinessException e) {
                LOGGER.error("", e);
            }
			
			Long agentMemberId =  MemberAgentBean.getInstance().getAgentMemberId(ApplicationCategoryEnum.edoc.key(), reAffair.getMemberId()); 
			if(agentMemberId != null){
				MessageReceiver agentReceiver = new MessageReceiver(reAffair.getId(), agentMemberId,url, linkOpenType, messageParam.get(0),messageParam.get(1),messageParam.get(2), "agent", reAffair.getAddition());
				try {
                    userMessageManager.sendSystemMessage(new MessageContent(key,reAffair.getSubject(),userName).add("col.agent")
                    		, ApplicationCategoryEnum.edocRegister, user.getId(), agentReceiver,EdocMessageFilterParamEnum.exchange.key);
                } catch (BusinessException e) {
                    LOGGER.error("", e);
                }
			}
		}
		
	}	
	
	
	
	public boolean isExchangeEdoc(String modelType,String id) throws BusinessException{
		/**
		 * 判断当前处理人 是否有交换权限
		 */
		User user = AppContext.getCurrentUser();
		long accountId = 0L;
		long departmentId = 0L;
		int exchangeType = 0;
		List<Long> exchangeUsers = new ArrayList<Long>();
		exchangeUsers.add(user.getId());
		
		/**
		 * 获得我代理的人，他有交换权限依然可以打开
		 */
		List<Long> agentToList = EdocHelper.getAgentToList(user.getId());
		if(Strings.isNotEmpty(agentToList)){
			exchangeUsers.addAll(agentToList);
		}
		
		boolean flag = false;
		EdocRecieveRecord recieve2 = null;
		if("sent".equals(modelType)||"toSend".equals(modelType) ){
			//发文分发记录
			EdocSendRecord send = edocExchangeManager.getSendRecordById(Long.valueOf(id));
			departmentId = send.getExchangeOrgId();
			exchangeType = send.getExchangeType();
		}else{
			//签收记录
			EdocRecieveRecord recieve = edocExchangeManager.getReceivedRecord(Long.valueOf(id));
			departmentId = recieve.getExchangeOrgId();
			exchangeType = recieve.getExchangeType();
			recieve2 = recieve;
		}
		if("sent".equals(modelType)||"toSend".equals(modelType) ){
			//这样下面好统一处理   2 表示部门交换 (主要分发 和 签收时 部门交换的值不一致)
			if(exchangeType == 0){
				exchangeType = 2;
			}
		}
		
		for(Long userId : exchangeUsers){
			//部门交换
			if(exchangeType == 2){
				V3xOrgDepartment dep = orgManager.getDepartmentById(departmentId);
				accountId = dep.getOrgAccountId();
				flag = EdocRoleHelper.isDepartmentExchange(accountId,departmentId,userId);
			}
			//单位交换
			else{
				accountId = departmentId;
				flag = EdocRoleHelper.isAccountExchange(userId,accountId);//用户是否为单位公文收发员
			}
			if(flag)break;
		}
		
		//从待登记下打开签收单，判断当前处理人 是否为签收单中的待登记人
		if(!flag && recieve2 != null){
			if(user.getId().equals(Long.valueOf(recieve2.getRegisterUserId()))){
				flag = true;
			}
			//竞争执行
			if(Long.valueOf(0l).equals(recieve2.getRegisterUserId())){
				flag = true;
			}
			//判断登录人代理的人，其中是否有 该签收单的登记人
			if(!flag){
				for(int k = 0;k<exchangeUsers.size();k++){
					Long agentToId = exchangeUsers.get(k);
					if(agentToId.equals(Long.valueOf(recieve2.getRegisterUserId()))){
						flag = true;
						break;
					}
				}
			}
		}
		
		return flag;
	}
	
	
	/**
	 * 公文交换列表页面
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@CheckRoleAccess(roleTypes={Role_NAME.NULL})
	public ModelAndView edit(HttpServletRequest request,HttpServletResponse response)throws Exception{
		
		ModelAndView mav = null; 

		String id = request.getParameter("id");
		String modelType = request.getParameter("modelType");
		
		Map<String, CtpEnumBean> colMetadata = enumManagerNew.getEnumsMap(ApplicationCategoryEnum.edoc);
		Map<String, CtpEnumBean> exMetadata =enumManagerNew.getEnumsMap(ApplicationCategoryEnum.exchange);
		
		CtpEnumBean exchangeEdocKeepperiodMetadata= enumManagerNew.getEnum(EnumNameEnum.exchange_edoc_keepperiod.name());
		 if(exchangeEdocKeepperiodMetadata!=null){
	        	List<CtpEnumItem> etm=exchangeEdocKeepperiodMetadata.getItems();
	        	for(CtpEnumItem me:etm){
	        		me.setLabel(Functions.toHTML(me.getLabel()));
	        	}
	    }
		EdocSummary summary = null; 
		String affairId = request.getParameter("affairId");   
		affairId = Functions.toHTML(affairId);
		User user = AppContext.getCurrentUser();
		
		if(!isExchangeEdoc(modelType,id)){
			StringBuffer jsBuffer =new StringBuffer();
			String hasNoRoleAlert = ResourceUtil.getString("exchange.notRole");//您没有公文交换的权限
			jsBuffer.append("if(parent.doEndSign_exchange){");
			jsBuffer.append("    parent.doEndSign_exchange('"+hasNoRoleAlert+"','"+affairId+"');");
			jsBuffer.append("}else{");
			jsBuffer.append("    alert('"+hasNoRoleAlert+"');");
			jsBuffer.append("    window.close();");
			jsBuffer.append("}");
			super.rendJavaScript(response, jsBuffer.toString());
			return null;
		}
		
		int detailListHeight = 130;//回执信息列表高度
		/***********************发文已分发*********************/		
		if("sent".equals(modelType)){
			mav = new ModelAndView("exchange/edoc/edoc_list_modify_send");
			EdocSendRecord bean = edocExchangeManager.getSendRecordById(Long.valueOf(id));
			
			// 对EdocSendRecord的sendDetail进行排序
			/*
			Set<EdocSendDetail> sendDetails = bean.getSendDetails();
			List<EdocSendDetail> sendDetailList = new ArrayList<EdocSendDetail>();
			sendDetailList.addAll(sendDetails);
			Collections.sort(sendDetailList);
			*/
			List<EdocSendDetail> sendDetailList = sendEdocManager.getDetailBySendId(bean.getId());
			if(sendDetailList != null){
				int size = sendDetailList.size();
				if(size > 3){
					detailListHeight += size * 36;
				}
			}
			bean.setSendDetailList(sendDetailList);
			
			// excchangeOrgName
			String exName = "";
			int exType = bean.getExchangeType();
			long exId = bean.getExchangeOrgId();
			if(exType == EdocSendRecord.Exchange_Send_iExchangeType_Dept) {
				V3xOrgDepartment dept = orgManager.getDepartmentById(exId);
				if(dept != null) {
					exName = dept.getName();
				}
			} else if(exType == EdocSendRecord.Exchange_Send_iExchangeType_Org) {
				V3xOrgAccount account = orgManager.getAccountById(exId);
				if(account != null) {
					exName = account.getName();
				}
			} else if(exType == EdocSendRecord.Exchange_Send_iExchangeType_ExternalOrg) {
				ExchangeAccount exA = exchangeAccountManager.getExchangeAccount(exId);
				if(exA != null) {
					exName = exA.getName();
				}
			}
			bean.setExchangeOrgName(exName);
			
			// 客开 start
			//summary = edocSummaryManager.findById(bean.getEdocId());
			summary = edocSummaryManager.getEdocSummaryById(bean.getEdocId(), true, true);
			// 客开 end
			mav.addObject("summary", summary);
			mav.addObject("elements", bean.getSendedTypeIds());
			mav.addObject("sendEntityName",bean.getSendEntityNames());
			// 客开 start
			mav.addObject("elements_yuewen", bean.getSendedTypeIds_yuewen());
			mav.addObject("sendEntityName_yuewen",bean.getSendEntityNames_yuewen());
			
			mav.addObject("elements_nbfs", bean.getSendedTypeIds_nbfs());
			mav.addObject("sendEntityName_nbfs",bean.getSendEntityNames_nbfs());
			// 客开 end
			
			if(null!=summary) {
				bean.setKeywords(summary.getKeywords());
			}
			
			long undertakerId = bean.getSendUserId();
			V3xOrgMember member = orgManager.getMemberById(undertakerId);
			if(null!=member){
				bean.setSendUserNames(member.getName());
			} else {
				bean.setSendUserNames("");
			}
			if(summary != null){
				Integer currentNo = bean.getContentNo();
				if(null!=currentNo && (currentNo.intValue() == Constants.EDOC_EXCHANGE_UNION_FIRST 
					|| currentNo.intValue() == Constants.EDOC_EXCHANGE_UNION_NORMAL
					|| currentNo.intValue() == Constants.EDOC_EXCHANGE_UNION_PDF_FIRST)){
					bean.setSendNames(summary.getSendTo());
				} else if(null!=currentNo && (currentNo.intValue() == Constants.EDOC_EXCHANGE_UNION_SECOND
					||currentNo.intValue() == Constants.EDOC_EXCHANGE_UNION_PDF_SECOND)){
					bean.setSendNames(summary.getSendTo2());
				}
			}
			// 如果份数等于0，显示为空
			String copies = bean.getCopies() == null ? "" : String.valueOf(bean.getCopies());

			mav.addObject("bean",bean);
			bean.getSendDetailList();
			mav.addObject("detailListHeight",detailListHeight);
			mav.addObject("copies",copies);
			Long exchangeAccountId=getAccountIdOfSendByOrgIdAndOrgType(bean.getExchangeOrgId(),bean.getExchangeType());
			mav.addObject("allowShowEdocInSend", EdocSwitchHelper.allowShowEdocInSend(exchangeAccountId));
			
		/***********************发文分发*********************/
		}else if(null!=modelType && !"".equals(modelType) && "toSend".equals(modelType)){
			mav = new ModelAndView("exchange/edoc/edoc_list_modify_send");
			EdocSendRecord bean = edocExchangeManager.getSendRecordById(Long.valueOf(id));
			List<EdocSendDetail> sendDetailList = sendEdocManager.getDetailBySendId(bean.getId());
			
			String stepBackInfo = bean.getStepBackInfo(); 
			if((bean.getStatus() == EdocSendRecord.Exchange_iStatus_Send_New_Cancel || bean.getStatus() == EdocSendRecord.Exchange_iStatus_Send_New_StepBacked) && Strings.isNotBlank(stepBackInfo)){//被回退的数据要显示回执信息
				String[] backInfos = stepBackInfo.split("\\^");
				List<EdocSendDetail> oldSendDetailList =  new ArrayList<EdocSendDetail>();
				String recUnitID = "";
				if(backInfos[0].indexOf("SendRecordID=") == 0){
					String[] strArray = backInfos[0].split(",");
					if(strArray.length > 1){
						String recordId = strArray[0].replace("SendRecordID=", "");
						oldSendDetailList = sendEdocManager.getDetailBySendId(Long.valueOf(recordId));  
						recUnitID = strArray[1].replace("RecOrgID=", "");
					}
				}
				List<EdocSendDetail> newDetailList = new ArrayList<EdocSendDetail>();
				for(EdocSendDetail detailRecord : oldSendDetailList){
					if(!detailRecord.getRecOrgId().equals(recUnitID)){
						newDetailList.add(detailRecord);
					}
				}
				oldSendDetailList.removeAll(newDetailList);
				bean.setSendDetailList(oldSendDetailList);
			}else if(bean.getStatus() == EdocSendRecord.Exchange_iStatus_Sent && Strings.isNotBlank(stepBackInfo) ){//兼容补发打开，显示撤销的回执信息
				if (sendDetailList != null && sendDetailList.size() > 0) {
					bean.setSendDetailList(sendDetailList);
				}
			}else if (bean.getStatus() == EdocSendRecord.Exchange_iStatus_Send_StepBacked) {
				// 回退到待发送的公文
//				List<EdocSendDetail> sendDetailList = sendEdocManager.getDetailBySendId(bean.getId());
				if (sendDetailList != null && sendDetailList.size() > 0) {
					bean.setSendDetailList(sendDetailList);
				}
				
				
				// excchangeOrgName
				String exName = "";
				int exType = bean.getExchangeType();
				long exId = bean.getExchangeOrgId();
				if (exType == EdocSendRecord.Exchange_Send_iExchangeType_Dept) {
					V3xOrgDepartment dept = orgManager.getDepartmentById(exId);
					if (dept != null) {
						exName = dept.getName();
					}
				} else if (exType == EdocSendRecord.Exchange_Send_iExchangeType_Org) {
					V3xOrgAccount account = orgManager.getAccountById(exId);
					if (account != null) {
						exName = account.getName();
					}
				} else if (exType == EdocSendRecord.Exchange_Send_iExchangeType_ExternalOrg) {
					ExchangeAccount exA = exchangeAccountManager.getExchangeAccount(exId);
					if (exA != null) {
						exName = exA.getName();
					}
				}
				bean.setExchangeOrgName(exName);
			}
			
			// 客开 start
			//summary = edocSummaryManager.findById(bean.getEdocId());
			summary = edocSummaryManager.getEdocSummaryById(bean.getEdocId(), true, true);
			// 客开 end
			mav.addObject("summary", summary);
			int isunion = bean.getContentNo();
			
			String _sq = "、";
			
			if(isunion == Constants.EDOC_EXCHANGE_UNION_FIRST 
				|| isunion == Constants.EDOC_EXCHANGE_UNION_NORMAL
				|| isunion == Constants.EDOC_EXCHANGE_UNION_PDF_FIRST){
				
				StringBuilder elements = new StringBuilder();
				String sendToNames = null;
				// 客开 start
				StringBuilder elements_yuewen = new StringBuilder();
				String sendToNames_yuewen = null;
				StringBuilder elements_nbfs = new StringBuilder();
				String sendToNames_nbfs = null;
				// 客开 end
				//如果是收文交换类型
				String reSend = request.getParameter("reSend");
				/**
				 * 当是转收文类型，并且不是补发的时候，从转收文表中获得送往单位
				 */
				if(!"true".equals(reSend)&& bean.getIsTurnRec()!=null && bean.getIsTurnRec()==1 
						//而且签收回退的 是走以前的逻辑
						&& bean.getStatus() != EdocSendRecord.Exchange_iStatus_Send_New_StepBacked){
					EdocExchangeTurnRec turnRec = edocExchangeTurnRecManager.findEdocExchangeTurnRecByEdocId(bean.getEdocId());
					if(turnRec != null){
						elements =new StringBuilder(turnRec.getTypeAndIds());
						String sendToUnitNames = turnRec.getSendUnitNames(orgManager);
						sendToNames = sendToUnitNames.replaceAll(",", _sq);
						mav.addObject("sendToUnitNames",sendToUnitNames);
					}
				}
				/**
				 * 补发的转收文类型的 送往单位也从summary中获得
				 */
				//以前的逻辑
				else{
					// 客开 start
					//elements =new StringBuilder(Strings.joinDelNull(V3xOrgEntity.ORG_ID_DELIMITER,summary.getSendToId(),summary.getCopyToId(),summary.getReportToId()));
					//sendToNames = Strings.joinDelNull(_sq, summary.getSendTo(),summary.getCopyTo(),summary.getReportTo());
					elements =new StringBuilder(Strings.joinDelNull(V3xOrgEntity.ORG_ID_DELIMITER,summary.getSendToId()));
					sendToNames = Strings.joinDelNull(_sq, summary.getSendTo());
					
					elements_yuewen =new StringBuilder(Strings.joinDelNull(V3xOrgEntity.ORG_ID_DELIMITER,summary.getCopyToId(), summary.getCopyToId2(), summary.getReportToId()));
					sendToNames_yuewen = Strings.joinDelNull(_sq, summary.getCopyTo(), summary.getCopyTo2(), summary.getReportTo());
					
					elements_nbfs =new StringBuilder(Strings.joinDelNull(V3xOrgEntity.ORG_ID_DELIMITER,summary.getText9()));
					sendToNames_nbfs = Strings.joinDelNull(_sq, summary.getText10());
					// 客开 end
					
					//当文单中全是填的B类的主送单位，抄送单位时
					if(Strings.isBlank(elements.toString())){
						elements =new StringBuilder(Strings.joinDelNull(V3xOrgEntity.ORG_ID_DELIMITER,summary.getSendToId2(),summary.getCopyToId2(),summary.getReportToId2()));
						String sendTo2Names = Strings.joinDelNull(_sq,summary.getSendTo2(),summary.getCopyTo2(),summary.getReportTo2());
						sendToNames = Strings.joinDelNull(_sq, sendToNames, sendTo2Names);
						
						// 客开 start
						elements_yuewen =new StringBuilder(Strings.joinDelNull(V3xOrgEntity.ORG_ID_DELIMITER,summary.getCopyToId(), summary.getCopyToId2(), summary.getReportToId()));
						sendToNames_yuewen = Strings.joinDelNull(_sq, summary.getCopyTo(), summary.getCopyTo2(), summary.getReportTo());
						
						elements_nbfs =new StringBuilder(Strings.joinDelNull(V3xOrgEntity.ORG_ID_DELIMITER,summary.getText9()));
						sendToNames_nbfs = Strings.joinDelNull(_sq, summary.getText10());
						// 客开 end
					}
					
					if(Strings.isNotBlank(bean.getSendedTypeIds()) || Strings.isNotBlank(bean.getSendEntityNames())) {
					    elements = new StringBuilder();
					    if(Strings.isNotBlank(bean.getSendedTypeIds())){
					        elements.append(bean.getSendedTypeIds());
					    }
						sendToNames = bean.getSendEntityNames();
			    	} else {
					    // OA-19692  单击待发送的数据（从待签收回退的），发送的单位没有保持上次发送的记录  
					    if(Strings.isBlank(elements.toString())){
				            for(EdocSendDetail detail : sendDetailList){
				            	// 客开 start
				            	if (!"办件".equals(detail.getType())) {
				            		continue;
				            	}
				            	// 客开 end
				                int type = detail.getRecOrgType();
				                if(type == EdocSendRecord.Exchange_Send_iExchangeType_Dept){
				                    elements.append("Department|");
				                    elements.append(detail.getRecOrgId());
				                    elements.append(",");
				                }else if( type == EdocSendRecord.Exchange_Send_iExchangeType_Org ||  type == EdocSendRecord.Exchange_Send_iExchangeType_Org){
				                    elements.append( "Account|");
				                    elements.append(detail.getRecOrgId());
				                    elements.append(",");
				                }
				                sendToNames = Strings.joinDelNull(_sq, sendToNames, detail.getRecOrgName()); 
				            }
				            if(elements.length()>0 && elements.toString().endsWith(",")){
				            	elements.setLength(elements.length() - 1);
				                //elements.deleteCharAt(elements.length()-1);
				            }
					    }
			    	}
					
					// 客开 start
					if(Strings.isNotBlank(bean.getSendedTypeIds_yuewen())) {
						elements_yuewen = new StringBuilder(bean.getSendedTypeIds_yuewen());
						sendToNames_yuewen = bean.getSendEntityNames_yuewen();
			    	} else {
					    // OA-19692  单击待发送的数据（从待签收回退的），发送的单位没有保持上次发送的记录  
					    if(Strings.isBlank(elements_yuewen.toString())){
				            for(EdocSendDetail detail : sendDetailList){
				            	if (!"阅件".equals(detail.getType())) {
				            		continue;
				            	}
				                int type = detail.getRecOrgType();
				                if(type == EdocSendRecord.Exchange_Send_iExchangeType_Dept){
				                    elements_yuewen.append("Department|");
				                    elements_yuewen.append(detail.getRecOrgId());
				                    elements_yuewen.append(",");
				                }else if( type == EdocSendRecord.Exchange_Send_iExchangeType_Org ||  type == EdocSendRecord.Exchange_Send_iExchangeType_Org){
				                	elements_yuewen.append( "Account|");
				                	elements_yuewen.append(detail.getRecOrgId());
				                	elements_yuewen.append(",");
				                }
				                sendToNames_yuewen = Strings.joinDelNull(_sq, sendToNames_yuewen, detail.getRecOrgName()); 
				            }
				            if(elements_yuewen.length()>0 && elements_yuewen.toString().endsWith(",")){
				            	elements_yuewen.setLength(elements_yuewen.length() - 1);
				            	//elements_yuewen.deleteCharAt(elements_yuewen.length()-1);
				            }
					    }
			    	}
					
					if(Strings.isNotBlank(bean.getSendedTypeIds_nbfs())) {
						elements_nbfs = new StringBuilder(bean.getSendedTypeIds_nbfs());
						sendToNames_nbfs = bean.getSendEntityNames_nbfs();
					}
					// 客开 end
				}
			    mav.addObject("elements", elements.toString());	
			    mav.addObject("sendEntityName", sendToNames);
			    
			    // 客开 start
			    mav.addObject("elements_yuewen", elements_yuewen.toString());	
			    mav.addObject("sendEntityName_yuewen", sendToNames_yuewen);
			    
			    mav.addObject("elements_nbfs", elements_nbfs.toString());	
			    mav.addObject("sendEntityName_nbfs", sendToNames_nbfs);
			    // 客开 end
				
			}else if(isunion == Constants.EDOC_EXCHANGE_UNION_SECOND
				||isunion == Constants.EDOC_EXCHANGE_UNION_PDF_SECOND){
			    
				mav.addObject("elements", Strings.joinDelNull(V3xOrgEntity.ORG_ID_DELIMITER,summary.getSendToId2(),summary.getCopyToId2(),summary.getReportToId2()));
				mav.addObject("sendEntityName", Strings.joinDelNull(_sq, summary.getSendTo2(),summary.getCopyTo2(),summary.getReportTo2()));
			}
			
			if(null!=summary){
				bean.setKeywords(summary.getKeywords());
			}
			// 如果份数等于0，显示为空
			String copies = bean.getCopies() == null ? "" : String.valueOf(bean.getCopies());
			bean.setSendUserNames(AppContext.getCurrentUser().getName());
			mav.addObject("bean",bean);
			mav.addObject("detailListHeight",130);//待发送文单回执信息最多一条
			mav.addObject("copies",copies);
			//获取签收单位或者签收部门所在的单位。
			Long exchangeAccountId=getAccountIdOfSendByOrgIdAndOrgType(bean.getExchangeOrgId(),bean.getExchangeType());
			mav.addObject("allowShowEdocInSend", EdocSwitchHelper.allowShowEdocInSend(exchangeAccountId));
			mav.addObject("contentType", null!=summary.getFirstBody() ? summary.getFirstBody().getContentType():"" );
			mav.addObject("subjectWords", bean.getSubject().length());
		/***********************收文已签收*********************/
		}else if(null!=modelType && !"".equals(modelType) && "received".equals(modelType)){
			mav = new ModelAndView("exchange/edoc/edoc_list_modify_receive");
			EdocRecieveRecord bean = edocExchangeManager.getReceivedRecord(Long.valueOf(id));
			/*********puyc 关联发文 * 收文的Id,收文的Type*********/
	        String relSends = "haveNot";
//	        List<EdocSummary> newEdocList = this.edocSummaryRelationManager.findNewEdoc(bean.getEdocId(), user.getId(), 1);
	        //待登记，关联新发文用的是签收id
	        List<EdocSummary> newEdocList = this.edocSummaryRelationManager.findNewEdoc(bean.getId(), user.getId(), 1);
	        if(newEdocList != null){
	        	 relSends = "haveMany";
//	        	 mav.addObject("recEdocId",bean.getEdocId());
	        	 mav.addObject("recEdocId",bean.getId());
	        	 mav.addObject("recType",1);
	        	 mav.addObject("relSends",relSends);
	        	 
	        } 
	        /***********puyc end************/
	        
	        V3xOrgMember register = orgManager.getEntityById(V3xOrgMember.class, bean.getRegisterUserId());
			/**
	         * 已签收页面  是否能够修改登记人或者分发人逻辑
	         */
	        if(EdocHelper.isG6Version()){
	        	mav.addObject("registerName",null==register ? "" : register.getName());
	        	if(bean.getStatus() == EdocRecieveRecord.Exchange_iStatus_Registered){
	        		EdocRegister registerObj = edocRegisterManager.findRegisterByRecieveId(bean.getId());
	        		//已签收是 显示登记人或分发人，根据是否自动登记来确定
	        		mav.addObject("isAutoRegister", Integer.valueOf(EdocRegister.AUTO_REGISTER).equals(registerObj.getAutoRegister()) ? "true" : "false");
	        		
	        		/*if(registerObj!=null){
	        			mav.addObject("registerName",registerObj.getDistributer());//登记人设置了两遍，且以下设置成了分发人，注释掉
	        		}*/
	        		//当手动登记时，则需要设置已登记标志，那么前台就不能修改登记人了
	        		if(registerObj!=null && (!Integer.valueOf(EdocRegister.AUTO_REGISTER).equals(registerObj.getAutoRegister()))){
	        			mav.addObject("isBeRegistered", bean.getStatus());
	        		}
	        		//签收自动登记
	        		if(registerObj!=null && Integer.valueOf(EdocRegister.AUTO_REGISTER).equals(registerObj.getAutoRegister())){
	        			//又进行了分发,那么前台就不能修改分发人了
	        			if(registerObj.getDistributeEdocId()!=-1){
	        				mav.addObject("isBeRegistered", bean.getStatus());
	        			}else{
	        				mav.addObject("edoeRegisterId4ChgDrcUser", registerObj.getId());
	        				//显示分发人
	        				mav.addObject("registerName",registerObj.getDistributer());
	        			}
	        		}
	        	}else{
	        		mav.addObject("isAutoRegister","false");
	        	}
	        }else{
	        	mav.addObject("isBeRegistered", bean.getStatus());
	        	mav.addObject("registerName",null==register ? "" : register.getName());
	        }
	        
			
			String nodeAction=request.getParameter("nodeAction");
			//lijl添加,GOV-3631.公文管理-收文管理-登记-待登记页面，单击打开公文，【选择人员】按钮要屏蔽掉.
			if("swWaitRegister".equals(nodeAction)){
				mav.addObject("isBeRegistered",2);
			}
			mav.addObject("edocRecieveRecordID4ChgRegUser", id);
			EdocRecieveRecord newBean =  (EdocRecieveRecord)bean.clone();
			newBean.setRemark(Strings.escapeJavascript(bean.getRemark()));
			newBean.setRecNo(Strings.escapeJavascript(bean.getRecNo()));
			newBean.setId(bean.getId());//xiangfan 添加，修复GOV-5008， ID为-1 所导致。
			V3xOrgMember recUser = orgManager.getEntityById(V3xOrgMember.class, bean.getRecUserId());
			// 客开 start
			//summary = edocSummaryManager.findById(bean.getEdocId());
			summary = edocSummaryManager.getEdocSummaryById(bean.getEdocId(), true, true);
			// 客开 end
			// 如果份数等于0，显示为空
			String copies = summary.getCopies() == null ? "" : String.valueOf(summary.getCopies());
			mav.addObject("copies", copies);
			mav.addObject("summary", summary);
			mav.addObject("contentType", null!=summary.getFirstBody() ? summary.getFirstBody().getContentType():"" );
			mav.addObject("bean",newBean);
			
			mav.addObject("recUser", null==recUser ? "" : recUser.getName());
			String signedName = this.getSignedDep(bean);
			mav.addObject("signedName", signedName);
			EdocSendRecord beanSend = edocExchangeManager.getEdocSendRecordByDetailId(Long.parseLong(bean.getReplyId()));
			if(beanSend!=null) {	
				// 客开 start
				//mav.addObject("sendEntityName", beanSend.getSendEntityNames());
				if (beanSend.getSendEntityNames_yuewen() != null && !"".equals(beanSend.getSendEntityNames_yuewen())) {
					mav.addObject("sendEntityName", beanSend.getSendEntityNames() + "、" + beanSend.getSendEntityNames_yuewen());
				} else {
					mav.addObject("sendEntityName", beanSend.getSendEntityNames());
				}
				// 客开 end
			} else {
				mav.addObject("sendEntityName", bean.getSendTo());
			}
			
			// 客开 start
			//if(beanSend!=null){mav.addObject("elements", beanSend.getSendedTypeIds());}
			if(beanSend!=null){
				if (beanSend.getSendedTypeIds_yuewen() != null && !"".equals(beanSend.getSendedTypeIds_yuewen())) {
					mav.addObject("elements", beanSend.getSendedTypeIds() + "," + beanSend.getSendedTypeIds_yuewen());
				} else {
					mav.addObject("elements", beanSend.getSendedTypeIds());
				}
			}
			// 客开 end
			//获取签收单位或者签收部门所在的单位。
			Long exchangeAccountId = ExchangeUtil.getAccountIdOfRegisterByOrgIdAndOrgType(bean.getExchangeOrgId(),bean.getExchangeType());
			mav.addObject("exchangeAccountId",exchangeAccountId);

			mav.addObject("allowShowEdocInRec", EdocSwitchHelper.allowShowEdocInRec(exchangeAccountId));
			
			//***********开发：苗永锋*****************需求：公文盖章封发后转pdf格式交换 **************开始*****Begin***************//
			mav.addObject("contentNo", bean.getContentNo());
			//***********开发：苗永锋*****************需求：公文盖章封发后转pdf格式交换 ***************结束*****End****************//
			
		/***********************收文签收*********************/			
		}else if(null!=modelType && !"".equals(modelType) && ("toReceive".equals(modelType)||"retreat".equals(modelType))){
			mav = new ModelAndView("exchange/edoc/edoc_list_modify_receive");
			EdocRecieveRecord bean = edocExchangeManager.getReceivedRecord(Long.valueOf(id));
			if(bean==null) {
				String infoMsg=ResourceUtil.getString("exchange.send.withdrawed");
				response.setContentType("text/html;charset=UTF-8");
				super.infoCloseOrFresh(request, response, infoMsg);
				return null;
			}
			if(bean.getStatus()!=EdocRecieveRecord.Exchange_iStatus_Torecieve && bean.getStatus()!=EdocRecieveRecord.Exchange_iStatus_Receive_Retreat) {
				String infoMsg=ResourceUtil.getString("exchange.send.hasSign");
				response.setContentType("text/html;charset=UTF-8");
				super.infoCloseOrFresh(request, response, infoMsg);
				return null;
			}
			//查询本单位的签收编号,G6 V1.0 SP1后续功能_自定义签收编号start
			List<EdocMarkDefinition> def = new ArrayList<EdocMarkDefinition>();
				if(Strings.isNotBlank(bean.getRecNo())) {
					EdocMarkDefinition d = new EdocMarkDefinition();
					d.setSelectV("0|" + bean.getRecNo() + "||3");
					d.setWordNo(bean.getRecNo());
					def.add(d);
				}
			
			/**
             * 签收是否显示 被代理人的判断
             * 当rec_user_id 不为0时，就表示只有这个人进行签收，那么直接显示这个人就行
             * 当rec_user_id 为0时，表示竞争执行，那么当前登录人 如果不在竞争列表中时，就需要判断他是谁的代理，就显示这个人
             */
            String recUserName = user.getName();
            long recUserId = user.getId();
            if(bean.getRecUserId() != 0){
                recUserName = orgManager.getMemberById(bean.getRecUserId()).getName();
                recUserId = bean.getRecUserId();
            }else{
                int type = bean.getExchangeType();
                if(type == EdocRecieveRecord.Exchange_Receive_iAccountType_Org){
                    if(!EdocRoleHelper.isAccountExchange()){
                        //所有单位收发员
                        List<V3xOrgMember> members = EdocRoleHelper.getAccountExchangeUsers();
                        //获得我代理的人
                        Map<String,Object> recUserMap = getAgentExchangeUserName(members);
                        recUserName = String.valueOf(recUserMap.get("recUserName"));
                        recUserId = Long.parseLong(String.valueOf(recUserMap.get("recUserId")));
                    }
                }else if(type == EdocRecieveRecord.Exchange_Receive_iAccountType_Dept){
                    if(!EdocRoleHelper.isDepartmentExchange(user.getLoginAccount(),bean.getExchangeOrgId(),user.getId())){
                        List<V3xOrgMember> members = EdocRoleHelper.getDepartmentExchangeUsers(bean.getExchangeOrgId());
                        Map<String,Object> recUserMap = getAgentExchangeUserName(members);
                        recUserName = String.valueOf(recUserMap.get("recUserName"));
                        recUserId = Long.parseLong(String.valueOf(recUserMap.get("recUserId")));
                    }
                }
            }
            bean.setRecUser(recUserName);
            mav.addObject("recUserId", recUserId);
			
            //登记人
            V3xOrgMember registerMember = orgManager.getMemberById(recUserId);
			
			if(Strings.isEmpty(def)) {
				def = edocExchangeManager.getMarkList(user.getLoginAccount(),user.getDepartmentId());
			}
			if(Strings.isNotEmpty(def)) {
				mav.addObject("def", def);
			}
			
			mav.addObject("accountId", user.getLoginAccount());
			mav.addObject("depId", user.getDepartmentId());
			
			
			//G6 V1.0 SP1后续功能_自定义签收编号end
			// 客开 start 
			//summary = edocSummaryManager.findById(bean.getEdocId());
			summary = edocSummaryManager.getEdocSummaryById(bean.getEdocId(), true, true);
			// 客开 end
			mav.addObject("summary", summary);
			
			//***********开发：苗永锋*****************需求：公文盖章封发后转pdf格式交换 **************开始*****Begin***************//
			mav.addObject("contentNo", bean.getContentNo());
			//***********开发：苗永锋*****************需求：公文盖章封发后转pdf格式交换 ***************结束*****End****************//
			
			mav.addObject("contentType", null!=summary.getFirstBody() ? summary.getFirstBody().getContentType() : "" );

			
			long l = System.currentTimeMillis();
			bean.setRecTime(new Timestamp(l));
			V3xOrgDepartment department = orgManager.getEntityById(V3xOrgDepartment.class, registerMember.getOrgDepartmentId());
			bean.setRecAccountName(department.getName());

			/* xiangfan 添加SP1新需求项，公文自动登记 start */
			boolean allowAutoRegister = EdocSwitchHelper.allowAutoRegister();
			mav.addObject("allowAutoRegister", allowAutoRegister);
			/* xiangfan 添加SP1新需求项，公文自动登记 end */
			
			
			//OA-33921,登记人默认取当前用户, 代理人取代理人的
			mav.addObject("registerName", registerMember.getName());
			mav.addObject("registerId", registerMember.getId());
			mav.addObject("bean",bean);
			String signedName = this.getSignedDep(bean);
			mav.addObject("signedName", signedName);
			// 如果份数等于0，显示为空
			String copies = bean.getCopies() == null ? "" : String.valueOf(bean.getCopies());
			//  -- 签收时间效果未实现
			if(bean.getRecTime()!=null){
				String recTime = DateUtil.format(bean.getRecTime(), "yyyy-MM-dd HH:mm");
				mav.addObject("recTime", recTime);
			}
			
			mav.addObject("copies",copies);
			EdocSendRecord beanSend=null;
			if(null!=bean.getReplyId() && bean.getFromInternal()) {
				beanSend = edocExchangeManager.getEdocSendRecordByDetailId(Long.parseLong(bean.getReplyId()));
			}
			
			if(null!=beanSend) {
				mav.addObject("sendEntityName", beanSend.getSendEntityNames());
				mav.addObject("elements", beanSend.getSendedTypeIds());
			} else {
				mav.addObject("sendEntityName", bean.getSendTo());
				mav.addObject("elements", "");
			}
			//待签收列表中打开签收单是有 发送，退回等按钮的
			mav.addObject("hasButton", "true");
			
			
			//获取签收单位或者签收部门所在的单位。
			Long exchangeAccountId = ExchangeUtil.getAccountIdOfRegisterByOrgIdAndOrgType(bean.getExchangeOrgId(),bean.getExchangeType());
			mav.addObject("exchangeAccountId", exchangeAccountId);
			mav.addObject("allowShowEdocInRec", EdocSwitchHelper.allowShowEdocInRec(exchangeAccountId));
			
			if(EdocHelper.isG6Version()){
				boolean isOpenRegister = EdocSwitchHelper.isOpenRegister(exchangeAccountId);
				mav.addObject("isAutoRegister", isOpenRegister?"false":"true");
			}
		}
		

		if(null!=modelType && !"".equals(modelType)){
			mav.addObject("modelType", modelType);
			mav.addObject("colMetadata", colMetadata);
			mav.addObject("exMetadata", exMetadata);
			mav.addObject("exchangeEdocKeepperiodMetadata",exchangeEdocKeepperiodMetadata );
		}
		mav.addObject("affairId", Strings.isBlank(affairId) ? "" : affairId);
		mav.addObject("operType", "change");

		return mav;
	}
	
	/**
	 * 获得被代理的公文签收员名字
	 * @return
	 */
	private Map<String,Object> getAgentExchangeUserName(List<V3xOrgMember> members){
		Map<String,Object> map = new HashMap<String,Object>();
		Map<Long,String> memMap = new HashMap<Long,String>();
		for(V3xOrgMember m : members){
			memMap.put(m.getId(), "");
		}
		
		User user = AppContext.getCurrentUser();
		long recUserId = user.getId();
		String recUserName = user.getName();
		List<AgentModel> agentModelList = MemberAgentBean.getInstance().getAgentModelList(user.getId());
		for(AgentModel agent : agentModelList){
			if(agentModelList!=null && agentModelList.size()>0){
				long agentId = agent.getAgentToId();
				if(memMap.get(agentId)!=null){
					try {
						V3xOrgMember recUser = orgManager.getMemberById(agentId);
						recUserName = recUser.getName();
						recUserId = recUser.getId();
					} catch (BusinessException e) {
						LOGGER.error("打开签收页面时，获得人员名称失败!",e);
					}
					break;
				}
			}
		}
		map.put("recUserName", recUserName);
		map.put("recUserId", recUserId);
		return map;
	}
	
	
	   
	   
	   /**
	    * 查找发文部门所属单位或者发文单位
	    * @param exchangeOrgId 发文ID（单位ID|部门ID）
	    * @param exchangeOrgType  发文类型（部门|单位）
	    * @return
	    */
	   private Long getAccountIdOfSendByOrgIdAndOrgType(Long exchangeOrgId,int exchangeOrgType){
	   	    if(EdocSendRecord.Exchange_Send_iExchangeType_Dept==exchangeOrgType){
				V3xOrgDepartment dept;
				try {
					dept = orgManager.getDepartmentById(exchangeOrgId);
					return dept.getOrgAccountId();
				} catch (BusinessException e) {
					LOGGER.error("查找部门异常:",e);
				}
			}else {
				return exchangeOrgId;	
			}
	   	return 0L;
	   }
	private String getSignedDep(EdocRecieveRecord bean ){
		long exchangeOrgId = bean.getExchangeOrgId();
		int exchangeType = bean.getExchangeType();
		V3xOrgEntity entity = null;
		try{
		if(exchangeType == EdocRecieveRecord.Exchange_Receive_iAccountType_Dept){
			entity=orgManager.getGlobalEntity(V3xOrgEntity.ORGENT_TYPE_DEPARTMENT, exchangeOrgId);
		}else if(exchangeType == EdocRecieveRecord.Exchange_Receive_iAccountType_Org){
			entity=orgManager.getGlobalEntity(V3xOrgEntity.ORGENT_TYPE_ACCOUNT, exchangeOrgId);
		}
		}catch(Exception e){
			LOGGER.error("得到交换单位异常 : ", e);
		}
		if(null!=entity){
			return entity.getName();
		}		
		return "";
	}
	
	@CheckRoleAccess(roleTypes={Role_NAME.NULL})
	public ModelAndView sendDetail(HttpServletRequest request,HttpServletResponse response) throws NumberFormatException, BusinessException{
		String id = request.getParameter("id");
		String modelType = request.getParameter("modelType");
		String reSend = request.getParameter("reSend");
		String affairId =request.getParameter("affairId");
		CtpAffair affairforcheck = null;
		Long orgAccountId = AppContext.getCurrentUser().getLoginAccount();
		//老数据的这个参数是确实的，传到后台的数据是{1}
		if(Strings.isNotBlank(affairId) && Strings.isDigits(affairId)){
			affairforcheck = affairManager.get(Long.valueOf(affairId));
			if(null != affairforcheck){
				Long objectId = affairforcheck.getObjectId();
				affairforcheck.setSubState(SubStateEnum.col_pending_read.getKey());
				if(null != objectId){
					EdocSummary findById = edocSummaryManager.findById(objectId);
					if(null != findById){
						orgAccountId = findById.getOrgAccountId();
					}
				}
				affairManager.updateAffair(affairforcheck);//更改未读状态为已读
			}
			
		}
		ModelAndView mav = new ModelAndView("exchange/edoc/show_detail_modify");
		mav.addObject("modelType", modelType);
		mav.addObject("id", id);
		mav.addObject("reSend", reSend);
		mav.addObject("affairId", affairId);
		if(affairforcheck != null){
			mav.addObject("affairState",affairforcheck.getState());
		}
		
		if(!Strings.isBlank(reSend) && "true".equals(reSend)){
			return mav;
		}
		EdocSendRecord record = edocExchangeManager.getSendRecordById(Long.valueOf(id));
		//判断是否有公文交换的权限
		boolean isExchangeRole = false;
		try {
			//公文交换权
			isExchangeRole = EdocRoleHelper.isExchangeRole();
			if(!isExchangeRole) {
				long userId = CurrentUser.get().getId();
				List<Long> agentIdList = MemberAgentBean.getInstance().getAgentToMemberId(ApplicationCategoryEnum.edoc.key(), userId);
				if(!CollectionUtils.isEmpty(agentIdList)) {
					boolean agentIsExchangeRole = false;
					for(int i=0; i<agentIdList.size(); i++) {
						if(null != orgAccountId){
							agentIsExchangeRole = EdocRoleHelper.isExchangeRole(agentIdList.get(i).longValue(),orgAccountId);
						}else{
							agentIsExchangeRole = EdocRoleHelper.isExchangeRole(agentIdList.get(i).longValue());
						}
						if(agentIsExchangeRole) {
							break;
						}
					}
					isExchangeRole = agentIsExchangeRole;
				}
			}
			if (null != record
					&& ExchangeUtil.isEdocExchangeToSendRecord(record.getStatus())
						&& !ExchangeUtil.isEdocExchangeSentStepBacked(record.getStatus())) {
				if(!isExchangeRole) {
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("app", ApplicationCategoryEnum.exSend.key());
					params.put("objectId", record.getEdocId());
					params.put("subObjectId", record.getId());
					params.put("delete", Boolean.FALSE);
					List<CtpAffair> list = affairManager.getByConditions(null, params);
					if(Strings.isNotEmpty(list)) {
						User user = CurrentUser.get();
						for(CtpAffair affair : list) {
							if(affair.getMemberId().longValue() == user.getId()) {
								isExchangeRole = true;
								break;
							}
						}
					}
				}
			}
		} catch (BusinessException e1) {
		    LOGGER.error("", e1);
		}
		if(!isExchangeRole) {
			try {
				String alertNote = ResourceUtil.getString("exchange.notRole");
				super.rendJavaScript(response, doEndSign_exchange_Java(alertNote));
				return null;
			} catch (Exception e) {
			    LOGGER.error("", e);
			}
		}
		if(affairforcheck !=null &&  Integer.valueOf(StateEnum.edoc_exchange_received.getKey()).equals(affairforcheck.getState())){
			try {
				String alertNote = ResourceUtil.getString( "exchange.sendRecord.send.already");
				if(Strings.isNotBlank(alertNote)) {
					StringBuffer jsBuffer = new StringBuffer();
					jsBuffer.append("if(parent.doEndSign_exchange) {");
					jsBuffer.append("	parent.doEndSign_exchange('"+alertNote+"','');");
					jsBuffer.append("} else {");
					jsBuffer.append(	doEndSign_exchange_Java(alertNote));
					jsBuffer.append("}");
					super.rendJavaScript(response, jsBuffer.toString());
					return null;
				}
			} catch(Exception be) {
				return null;
			}
		}
		if(!checkEdocSendRecord(response, record, false)) {
			return null;
		}
		return mav;
	}

	@CheckRoleAccess(roleTypes={Role_NAME.NULL})
	public ModelAndView receiveDetail(HttpServletRequest request,HttpServletResponse response) throws Exception{
		response.setContentType("text/html;charset=UTF-8");
		String id = request.getParameter("id"); 
		String modelType = request.getParameter("modelType");
		ModelAndView mav = new ModelAndView("exchange/edoc/show_detail_modify");
		mav.addObject("id", id);
		EdocRecieveRecord record = edocExchangeManager.getReceivedRecord(Long.valueOf(id));
		User user = AppContext.getCurrentUser();
		String affairIdStr = request.getParameter("affairId");
		
		//如果是从首页打开，更新状态为“已读”
		if(Strings.isNotBlank(affairIdStr)){
			CtpAffair affair=affairManager.get(Long.valueOf(affairIdStr));
			if(affair != null){
				affair.setSubState(SubStateEnum.col_pending_read.getKey());
				affairManager.updateAffair(affair);
			}
		}
		
		Long checkAclMemberId = user.getId();
		if(Strings.isNotBlank(affairIdStr)){
			CtpAffair affair = affairManager.get(Long.valueOf(affairIdStr));
			boolean isTrue = ColUtil.checkAgent(affair.getMemberId(), affair.getSubject(),ModuleType.edoc, true, request);
			if(!isTrue){
				return null;
			}
			checkAclMemberId = affair.getMemberId();
		}
		boolean falg=EdocRoleHelper.isExchangeRole(checkAclMemberId);
		if(!falg){
			List<AgentModel> _agentModelList = MemberAgentBean.getInstance().getAgentModelList(user.getId());//我代理谁
			if(_agentModelList!=null && _agentModelList.size()>0){
				boolean agentIsExchangeRole = false;
				for(AgentModel agent : _agentModelList){
					long agentMemberId = agent.getAgentToId();//被我代理的人
					
					V3xOrgMember agentMember=orgManager.getMemberById(agentMemberId);
					if(agentMember==null){
						continue;
					}
					Long accountIdOfagentId = agentMember.getOrgAccountId();
					agentIsExchangeRole = EdocRoleHelper.isExchangeRole(agentMemberId,accountIdOfagentId);
					//需要检查被我代理的人 是否有公文交换的权限，有的话就可以打开
					if(agentIsExchangeRole){
						falg = true;
						break;
					}
				}
			}
		}
		if(!falg){
			//兼职判断
			if(user.getLoginAccount().longValue() != user.getAccountId().longValue()) {
				falg=EdocRoleHelper.isExchangeRole(user.getId(),user.getAccountId());
			}
		}
		
		//判断当前人是否还有公文交换的权限，如果没有，点击历史消息不可以进行发送和签收处理，包括回退后的数据
		if(falg){
			boolean isCanDeal = true;
			String _isModalDialog = request.getParameter("_isModalDialog");
			if("true".equals(_isModalDialog)){
				isCanDeal = false;
			}
			if(Strings.isNotBlank(request.getParameter("hastenMember"))) {//如果来自催办消息，可以处理
				isCanDeal = true;
			}
		    //OA-50355 公文进行单位交换，主送单位收发员收到待签收数据和消息，此时发送人员撤销送文，签收单位点击消息报错
		    //当发送人撤销后，record为null了，需要先进行校验
		    if(!checkEdocRecieveRecord(response, record,false,isCanDeal,false)) { 
                return null;
            }
		    
			//如果是代签收状态,已签收状态，或者是登记退回状态且签收人是自己或者自己的代理人时，才能进行签收处理
		    boolean isCanSign=false;
		    List<AgentModel> _agentModelList = MemberAgentBean.getInstance().getAgentModelList(user.getId());//我代理谁
			if(_agentModelList!=null && _agentModelList.size()>0){
				for(AgentModel agent : _agentModelList){
					if(agent.getAgentToId().equals(record.getRecUserId())){//被我代理的人是签收人
						isCanSign=true;
					}
				}
			}
			if( user.getId().equals(record.getRecUserId())){//签收人是自己
				isCanSign=true;
			}
			if (record.getStatus() == EdocRecieveRecord.Exchange_iStatus_Torecieve
					|| record.getStatus() == EdocRecieveRecord.Exchange_iStatus_Recieved
					||
					// 当A签收后，签收表中recUserId会记录为A的id,然后签收员由A变B后，登记时退回该公文，那么recUserId为变为0了
					((isCanSign || record.getRecUserId() == 0) && record.getStatus() == EdocRecieveRecord.Exchange_iStatus_Receive_Retreat)) {
				String affairId = request.getParameter("affairId");
				mav.addObject("affairId", affairId);
				mav.addObject("modelType", modelType);
			} else if (record.getStatus() == EdocRecieveRecord.Exchange_iStatus_Receive_Retreat) { // 登记回退状态
				String msg = ResourceUtil.getString("exchange.recieve.exchangeRole");
				this.webAlertAndClose(response, msg);
				return null;
			}
		}else{
	         String msg = ResourceUtil.getString( "exchange.recieve.alert");
			this.webAlertAndClose(response, msg);
		    return null;
		}
		mav.addObject("modelType", modelType);
		return mav;
	}
	
	/**
	 * 提供公文增加用户的页面
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@CheckRoleAccess(roleTypes={Role_NAME.NULL})//向凡 修改 修复GOV-4316 添加外部单位不需要权限控制
	public ModelAndView addExchangeAccountFromEodc(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView(
				"exchange/account/addExternalAccountFromEdocDlg");
		mav.addObject("domainId", AppContext.getCurrentUser().getLoginAccount());
		mav.addObject("currentMemberId", AppContext.getCurrentUser().getId());
		return mav;
	}
	
//	private <T> List<T> pagenate(List<T> list) {
//		if (null == list || list.size() == 0)
//			return new ArrayList<T>();
//		Integer first = Pagination.getFirstResult();
//		Integer pageSize = Pagination.getMaxResults();
//		Pagination.setRowCount(list.size());
//		List<T> subList = null;
//		if(first>=list.size()) return Collections.emptyList();
//		if (first + pageSize > list.size()) {
//			subList = list.subList(first, list.size());
//		} else {
//			subList = list.subList(first, first + pageSize);
//		}
//		return subList;
//	}

	/**
	 * 已发送公文打开撤销框
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@CheckRoleAccess(roleTypes={Role_NAME.Accountexchange,Role_NAME.Departmentexchange})
	public ModelAndView openEdocSendRecordCancelDialog(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("exchange/edoc/edoc_send_cancel_dialog");
		long sendRecordId = Strings.isBlank(request.getParameter("sendRecordId"))?-1:Long.parseLong(request.getParameter("sendRecordId"));
		long detailId = Strings.isBlank(request.getParameter("detailId"))?-1:Long.parseLong(request.getParameter("detailId"));
		String readOnly = request.getParameter("readOnly");   
		String accountId = request.getParameter("accountId"); 
		if (!Strings.isBlank(readOnly) && "1".equals(readOnly)) {//查看
			EdocSendRecord edocSendRecord = edocExchangeManager.getSendRecordById(Long.valueOf(sendRecordId));
			mav.addObject("sendRecordId", sendRecordId);
			mav.addObject("readOnly", readOnly);
			
			String sendCancelInfo = "";
			String stepBackInfo = edocSendRecord.getStepBackInfo(); 
			//User user = CurrentUser.get();
			if(Strings.isNotBlank(stepBackInfo)){
				String[] backInfos = stepBackInfo.split("\\^");
				for(int i=0;i<backInfos.length;i++){
					if(backInfos[i].indexOf(accountId)>0) {
						String[] infos = backInfos[i].split("\\|");
						if(infos.length > 1) {
							String[] entitys = infos[0].split("\\*");
							if(entitys.length>1) {// && entitys[0].indexOf(String.valueOf(user.getId()))==0
								sendCancelInfo = infos[1];//包括单位ID+"*"+撤销人ID
								break;
							}
						}
					}
				}
			}
			mav.addObject("sendCancelInfo", sendCancelInfo);
		} else {
			EdocSendDetail edocSendDetail = sendEdocManager.getSendRecordDetail(detailId);
			if(!checkEdocSendDetail(response, edocSendDetail, true)) {
				return null;
			}
			mav.addObject("sendRecordId", sendRecordId);
			mav.addObject("readOnly", readOnly);
		}
		return mav;
	}
	
	@CheckRoleAccess(roleTypes={Role_NAME.Accountexchange,Role_NAME.Departmentexchange})
	public ModelAndView openStepBackDlg(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("exchange/edoc/stepBackInfo");
		String exchangeSendEdocId = request.getParameter("exchangeSendEdocId");
		String readOnlysString = request.getParameter("readOnly");   
		String accountId = request.getParameter("accountId"); 
		if (!Strings.isBlank(readOnlysString) && "1".equals(readOnlysString)) {
			EdocSendRecord edocSendRecord = edocExchangeManager.getSendRecordById(Long.valueOf(Long.parseLong(exchangeSendEdocId)));
			mav.addObject("stepBackSendEdocId", exchangeSendEdocId);
			mav.addObject("readOnly", readOnlysString);
			
			String backInfo = "";
			String stepBackInfo = edocSendRecord.getStepBackInfo(); 
			if(Strings.isNotBlank(stepBackInfo)){
				String[] backInfos = stepBackInfo.split("\\^");
				for(int i=0;i<backInfos.length;i++){
					if(backInfos[i].indexOf(accountId)==0 && backInfos[i].indexOf("SendRecordID=") == -1){
						backInfo = backInfos[i].substring(accountId.length()+1);
						break;
					}
				}
			}
			mav.addObject("stepBackInfo", backInfo);
		} else {
			EdocRecieveRecord edocRecieveRecord = edocExchangeManager.getReceivedRecord(Long.valueOf(Long.parseLong(exchangeSendEdocId)));
			if(!checkEdocRecieveRecord(response, edocRecieveRecord, true, false)) {
				return null;
			}
			
			//EdocSendRecord edocSendRecord = edocExchangeManager.getSendRecordById(edocRecieveRecord.getReplyId());
			mav.addObject("stepBackSendEdocId", exchangeSendEdocId);
			mav.addObject("stepBackEdocId", edocRecieveRecord.getEdocId());
			mav.addObject("readOnly", readOnlysString);
		}
		mav.addObject("isResgistering", "0");
		return mav;
	}

	/**
	 * 打开退回弹出框
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@CheckRoleAccess(roleTypes={Role_NAME.NULL})
	public ModelAndView openStepBackDlg4Resgistering(HttpServletRequest request, HttpServletResponse response) throws Exception { 
		ModelAndView mav = new ModelAndView("exchange/edoc/stepBackInfo");
		String resgisteringEdocId = request.getParameter("resgisteringEdocId");
		String readOnlysString = request.getParameter("readOnly");
		EdocRecieveRecord edocRecieveRecord = edocExchangeManager.getReceivedRecord(Long.valueOf(Long.parseLong(resgisteringEdocId)));
		mav.addObject("stepBackSendEdocId", resgisteringEdocId);  
		if (!Strings.isBlank(readOnlysString) && "1".equals(readOnlysString)) {
			mav.addObject("readOnly", readOnlysString);
			mav.addObject("stepBackInfo", edocRecieveRecord  == null ? "" : edocRecieveRecord.getStepBackInfo());
		} else {
			mav.addObject("stepBackSendEdocId", resgisteringEdocId);
			mav.addObject("stepBackInfo", edocRecieveRecord  == null ? "" : edocRecieveRecord.getStepBackInfo());
			mav.addObject("readOnly", readOnlysString);
		}
		mav.addObject("isResgistering", "1");
		return mav;
	}
	
	@CheckRoleAccess(roleTypes={Role_NAME.NULL})
	public ModelAndView openStepBackDistribute(
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		ModelAndView mav = new ModelAndView("exchange/edoc/stepBackInfo");
		return mav;
	}

	/**
	 * 签收回退
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@CheckRoleAccess(roleTypes={Role_NAME.Accountexchange,Role_NAME.Departmentexchange})
	public ModelAndView stepBack(HttpServletRequest request, HttpServletResponse response) throws Exception {
		response.setContentType("text/html;charset=UTF-8");
		/** 1、获取前台参数 */
		String stepBackSendEdocId = request.getParameter("stepBackSendEdocId");
		String stepBackInfo = request.getParameter("stepBackInfo");
		String stepBackEdocIdString = request.getParameter("stepBackEdocId");
		boolean oneself = Strings.isBlank(request.getParameter("oneself")) ? true : Boolean.valueOf(request.getParameter("oneself"));
		PrintWriter out = response.getWriter();  
		User user = AppContext.getCurrentUser();
		
		/** 2、验证签收状态 */
		if (Strings.isBlank(stepBackSendEdocId)) {
			LOGGER.error("ID为空");
			return null;
		}
		EdocRecieveRecord record = edocExchangeManager.getReceivedRecord(Long.valueOf(Long.parseLong(stepBackSendEdocId)));
		if(!checkEdocRecieveRecord(response, record, true, true)) {
			return null;
		}
		
		/** 3、上锁 */
		//boolean isRelieveLock = true;
		try {

			/** 4、签收回退到待发送  */
			EdocSummary stepBackEdocSummary = edocSummaryManager.findById(Long.valueOf(Long.parseLong(stepBackEdocIdString)));
			boolean flag = edocExchangeManager.stepBackEdoc(Long.valueOf(Long.parseLong(stepBackSendEdocId)), stepBackInfo, oneself);
			if(!flag) {
				out.println("<script>");
				out.println("if(parent.listFrame) {alert('"+ResourceUtil.getString("edoc.alert.register.stepback2")+"');parent.listFrame.doEndSign();}");//该公文不允许退回
				out.println("else if(window.dialogArguments) {alert('"+ResourceUtil.getString("edoc.alert.register.stepback2")+"');window.returnValue='true'; window.close();}");
				out.println("else if(getA8Top && getA8Top().window) { alert('"+ResourceUtil.getString("edoc.alert.register.stepback2")+"');getA8Top().window.close();getA8Top().close();}");
				out.println("else {alert('"+ResourceUtil.getString("edoc.alert.register.stepback2")+"');parent.location.reload();}");
				out.println("</script>");
				return null;
			}
			
			/** 5、签收回退应用日志  */
			appLogManager.insertLog(user, AppLogAction.Edoc_SingReturn_Exchange, user.getName(), stepBackEdocSummary.getSubject());
			
			/** 6、页面跳转  */
			Boolean f = (Boolean)(BrowserFlag.PageBreak.getFlag(request));
			out.println("<script>");
			if (f.booleanValue()) {
				out.println("parent.doEndSign_exchange();"); 
			} else {
				out.println("window.getA8Top().close();");
			}
			out.println("</script>");
			
		} catch (Exception e) {
			LOGGER.error("", e);
		} finally {
			edocLockManager.unlock(record.getId());
		}
		return null;
	}

	/**
	 * 公文收文登记退回到收文签收
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@CheckRoleAccess(roleTypes={Role_NAME.NULL})
	public ModelAndView stepBackRecievedEdoc(HttpServletRequest request, HttpServletResponse response) throws Exception {
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter out = response.getWriter();
		User user = AppContext.getCurrentUser();
		// 待登记公文ID
		long registerId = Strings.isBlank(request.getParameter("registerId"))?-1:Long.parseLong(request.getParameter("registerId"));
		long recieveId = Strings.isBlank(request.getParameter("recieveId"))?-1:Long.parseLong(request.getParameter("recieveId"));
		if (recieveId == -1) {
			LOGGER.error("ID为空");
			return null;
		}
		// 回退说明
		String stepBackInfo = request.getParameter("stepBackInfo");
		//竞争执行
		String competitionAction=request.getParameter("competitionAction");
		
		EdocRecieveRecord record = edocExchangeManager.getReceivedRecord(recieveId);
		
		// 删除登记对象
		EdocRegister edocRegister = null;
		boolean returnFlag = true;
		if(registerId != -1) {
			edocRegister = edocRegisterManager.getEdocRegister(registerId);
			if(edocRegister!=null && (edocRegister.getState()==EdocNavigationEnum.RegisterState.retreat.ordinal()
			        || edocRegister.getState()==EdocNavigationEnum.RegisterState.DraftBox.ordinal())) {
				returnFlag = false;
			}
		}
		if(edocRegister == null){
			edocRegister = edocRegisterManager.findRegisterByRecieveId(recieveId);
		}
		
		String alertNote = "";
		// 检查已经被登记，退件箱中登记进行退回
		if (null != record && record.getStatus()==EdocRecieveRecord.Exchange_iStatus_Registered && returnFlag) {
			alertNote = ResourceUtil.getString("exchange.registerRecord.register.already");
			try {
				out.println("<script>");
				out.println("alert('" + alertNote + "');");
				out.println("if(window.dialogArguments){window.returnValue='true';window.close();}else{");
				out.println("parent.parent.location.reload(true)");
				out.println("}");
				out.println("</script>");
				return null;
			} catch (Exception e) {
			    LOGGER.error("", e);
			}
		}
		// 检查是否已经被回退
		else if (null != record && (record.getStatus() == EdocRecieveRecord.Exchange_iStatus_Torecieve 
                                     || record.getIsRetreat() == EdocRecieveRecord.Receive_Retreat_Yes)) {
		    
			alertNote = ResourceUtil.getString("exchange.registerRecord.stepback.already");
			try {
				out.println("<script>");
				out.println("alert('" + alertNote + "');");
				out.println("if(window.dialogArguments){window.returnValue='true';window.close();}else{");
				out.println("parent.parent.location.reload(true)");
				out.println("}");
				out.println("</script>");
				return null;
			} catch (Exception e) {	
			    LOGGER.error("", e);
			}
		}
		// 检查是否被撤销
		else if (null == record) {
			alertNote = ResourceUtil.getString("exchange.send.withdrawed");
			out.println("<script>");
			out.println("alert('" + alertNote + "');");
			out.println("if(window.dialogArguments){");
			out.println("window.returnValue='true';window.close();}else{");
			out.println("parent.parent.location.reload(true)");
			out.println("}");
			out.println("</script>");
			return null;
		}
		try {
			//登记退回到签收退件箱
			edocExchangeManager.stepBackRegisterEdoc(edocRegister, recieveId, recieveId, stepBackInfo,competitionAction);
			
			//记录操作日志
			Integer logAction = 338;
			if(edocRegister == null || edocRegister.getState() == EdocNavigationEnum.RegisterState.retreat.ordinal()
					|| (!EdocHelper.isG6Version() 
			        && EdocNavigationEnum.EdocDistributeState.WaitDistribute.ordinal() == edocRegister.getDistributeState())){
			    
			    //待登记或回退到待登记的操作日志,A8待登记回退
			    logAction = 337;
			}else {
              //默认的
            }
			
			this.appLogManager.insertLog(user, logAction, user.getName() , record.getSubject()) ;
			
			out.println("<script>");
			out.println("parent.parent.location.reload(true);");
			out.println("</script>");
		} catch (Exception e) {
			LOGGER.error("", e);
		} finally {
		    
		}
		return null;
	}
	
	/**
	 * 公文交换,批量分发
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	//@CheckRoleAccess(roleTypes={Role_NAME.Accountexchange,Role_NAME.Departmentexchange})
	public ModelAndView batchFenfa(HttpServletRequest request,HttpServletResponse response)throws Exception{
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter out = response.getWriter();
		User user = AppContext.getCurrentUser();
		//String reSend = request.getParameter("reSend");
		String sendKey = "exchange.sent";
		String userName = "";
		Boolean f = (Boolean)(BrowserFlag.PageBreak.getFlag(request));
		if(null!=user){
			userName = user.getName();
		}
		String[] ids = request.getParameterValues("id");
		if(ids==null){
			out.println("<script>");
			out.println("parent.location.reload()");
			out.println("</script>");
			return null;
		}
		String affairId = request.getParameter("affairId");
		Long agentToId = null;//被代理人ID
		String agentToName = "";
		if(Strings.isNotBlank(affairId)){
			CtpAffair affair = affairManager.get(Long.valueOf(affairId));
			if(!affair.getMemberId().equals(user.getId())){
				agentToId = affair.getMemberId();
				V3xOrgMember member = orgManager.getMemberById(agentToId);
				agentToName = member.getName();
			}
		}
		StringBuilder msgNull = new StringBuilder();
		StringBuilder msg = new StringBuilder();
		List<Long> idList = new ArrayList<Long>(0);
		for(int i=0;i<ids.length;i++){ 
			
			String id=ids[i];
			if(Strings.isBlank(id)){
				return null;
			}
			
			//公文交换时候,发送公文,给发送的detail表插入数据,同时给待签收表插入数据
			//String sendUserId = request.getParameter("sendUserId");
			//String sender = request.getParameter("sender");
			//读取发送时重新选择的发送单位
			String typeAndIds="";
			
			EdocSendRecord record = edocExchangeManager.getSendRecordById(Long.valueOf(id));
			
			EdocSummary summary = edocSummaryManager.findById(record.getEdocId());
			int isunion = record.getContentNo();
			if(isunion == Constants.EDOC_EXCHANGE_UNION_FIRST 
				|| isunion == Constants.EDOC_EXCHANGE_UNION_NORMAL
				|| isunion == Constants.EDOC_EXCHANGE_UNION_PDF_FIRST){
				typeAndIds=Strings.joinDelNull(V3xOrgEntity.ORG_ID_DELIMITER,summary.getSendToId(),summary.getCopyToId(),summary.getReportToId());				
			}else if(isunion == Constants.EDOC_EXCHANGE_UNION_SECOND
				||isunion == Constants.EDOC_EXCHANGE_UNION_PDF_SECOND){
				typeAndIds=Strings.joinDelNull(V3xOrgEntity.ORG_ID_DELIMITER,summary.getSendToId2(),summary.getCopyToId2(),summary.getReportToId2());
			}
			
			if(Strings.isBlank(typeAndIds)) {
				msgNull.append(ResourceUtil.getString("edoc.symbol.opening.chevron")+summary.getSubject()+ResourceUtil.getString("edoc.symbol.closing.chevron")+",");
			} else {
				String info = edocExchangeManager.checkExchangeRole(typeAndIds);
				if(!"check ok".equals(info)) {
					if("unknow err".equals(info)) {
						msg.append(ResourceUtil.getString("edoc.symbol.opening.chevron")+summary.getSubject()+ResourceUtil.getString("edoc.symbol.closing.chevron")+ResourceUtil.getString("edoc.error.send.no.gwsfy",0)+"\\n");//送往单位没有设置公文收发员，不能发送。
					} else {
						msg.append(ResourceUtil.getString("edoc.symbol.opening.chevron")+summary.getSubject()+ResourceUtil.getString("edoc.symbol.closing.chevron")+ResourceUtil.getString("edoc.error.send.no.gwsfy",1,info)+"\\n");//"送往单位"+info+"没有设置公文收发员，不能发送。
					}
				} else {
					idList.add(Long.valueOf(id));
				}
			}
			
			String alertNote = "";
			if (null != record
					&& !(ExchangeUtil.isEdocExchangeToSendRecord(record.getStatus()) 
						|| ExchangeUtil.isEdocExchangeSentStepBacked(record.getStatus()))) {
				alertNote = ResourceUtil.getString("exchange.sendRecord.send.already");
				try{
					out.println("<script>");
					out.println("alert('"+alertNote+"');");
					out.println("if(window.dialogArguments){window.returnValue='true';window.close();}else{");
					out.println("	parent.location.reload()");
					out.println("}");
					//out.println("history.go(-1);");
					out.println("</script>");
					return null;
				}catch(Exception e){
				    LOGGER.error("", e);
				}
			}
		}
		if(Strings.isNotBlank(msgNull.toString())) {
			msgNull = new StringBuilder(msgNull.substring(0, msgNull.length()-1));
			msgNull.append(ResourceUtil.getString("edoc.error.send.no.swdw")+"\\n");//没有送往单位，请设置后再发送。
		}

		for(int i=0;i<idList.size();i++){ 
			
			Long id = idList.get(i);
			boolean isResend = false;
			
			//公文交换时候,发送公文,给发送的detail表插入数据,同时给待签收表插入数据
			//String sendUserId = request.getParameter("sendUserId");
			//String sender = request.getParameter("sender");
			//读取发送时重新选择的发送单位
			String typeAndIds="";
			
			EdocSendRecord record = edocExchangeManager.getSendRecordById(Long.valueOf(id));
			/**puyc 添加日志**/
    		appLogManager.insertLog(AppContext.getCurrentUser(), AppLogAction.Edoc_send_distribute, AppContext.getCurrentUser().getName(),record.getSubject());
			
			EdocSummary summary = edocSummaryManager.findById(record.getEdocId());
			int isunion = record.getContentNo();
			if(isunion == Constants.EDOC_EXCHANGE_UNION_FIRST 
				|| isunion == Constants.EDOC_EXCHANGE_UNION_NORMAL
				|| isunion == Constants.EDOC_EXCHANGE_UNION_PDF_FIRST){
				typeAndIds=Strings.joinDelNull(V3xOrgEntity.ORG_ID_DELIMITER,summary.getSendToId(),summary.getCopyToId(),summary.getReportToId());				
			}else if(isunion == Constants.EDOC_EXCHANGE_UNION_SECOND
				||isunion == Constants.EDOC_EXCHANGE_UNION_PDF_SECOND){
				typeAndIds=Strings.joinDelNull(V3xOrgEntity.ORG_ID_DELIMITER,summary.getSendToId2(),summary.getCopyToId2(),summary.getReportToId2());
			}

			List <EdocSendDetail> details=edocExchangeManager.createSendRecord(record.getId(), typeAndIds);
			
			// 如果是回退的公文再次发送，设置此公文的发文记录的状态为未发送
			if (ExchangeUtil.isEdocExchangeSentStepBacked(record.getStatus())) {
				record.setStatus(EdocSendRecord.Exchange_iStatus_Tosend);
			}
			List<EdocSendDetail> tempDetail = sendEdocManager.getDetailBySendId(record.getId());
			details.addAll(tempDetail);//将已经签收的记录增加到detail中
			Set<EdocSendDetail> sendDetails = new HashSet<EdocSendDetail>(details);
			record.setSendDetails(sendDetails);
			edocExchangeManager.sendEdoc(record, user.getId() ,user.getName(),agentToId,isResend,null);
			//affair = affairManager.getBySubObject(ApplicationCategoryEnum.exSend, record.getId());

			Map<String, Object> conditions = new HashMap<String, Object>();
			conditions.put("app", ApplicationCategoryEnum.exSend.key());
            conditions.put("objectId", record.getEdocId());
            conditions.put("subObjectId", record.getId());
            List<CtpAffair> affairList =affairManager.getByConditions(null,conditions);
        	List<MessageReceiver> receivers = new ArrayList<MessageReceiver>();
			if(null!=affairList && affairList.size()>0){
				for(CtpAffair af: affairList){
            		if(!user.getId().equals(af.getMemberId()) && !af.isDelete()){
            			receivers.add(new MessageReceiver(af.getId(), af.getMemberId()));
            		}
					af.setState(StateEnum.edoc_exchange_sent.getKey());
					af.setDelete(true);
					af.setFinish(true);
					affairManager.updateAffair(af);
				}
			}
        	if(null!=receivers && receivers.size()>0){
        		if(agentToId!=null){
        			userMessageManager.sendSystemMessage(new MessageContent(sendKey, affairList.get(0).getSubject(), agentToName,affairList.get(0).getApp()).add("edoc.agent.deal", user.getName()), ApplicationCategoryEnum.edocSend,agentToId, receivers,EdocMessageFilterParamEnum.exchange.key);
        		}else{
        			userMessageManager.sendSystemMessage(new MessageContent(sendKey, affairList.get(0).getSubject(), userName,affairList.get(0).getApp()), ApplicationCategoryEnum.edocSend, user.getId(), receivers,EdocMessageFilterParamEnum.exchange.key);
        		}
        	}
        	if(isResend){
        		operationlogManager.insertOplog(record.getId(), ApplicationCategoryEnum.exchange, EactionType.LOG_EXCHANGE_RDSEND, EactionType.LOG_EXCHANGE_RDSENDD_DESCRIPTION,user.getName(), record.getSubject());
        	}else{
        		operationlogManager.insertOplog(record.getId(), ApplicationCategoryEnum.exchange, EactionType.LOG_EXCHANGE_SEND, EactionType.LOG_EXCHANGE_SEND_DESCRIPTION,user.getName(), record.getSubject());        		
        	}
		}
		
		if(Strings.isNotBlank(msgNull.toString()) || Strings.isNotBlank(msg.toString())) {
			out.println("<script>");
			out.println("alert('\\n"+msgNull.toString()+msg.toString()+"');");
			out.println("if(window.dialogArguments){window.returnValue='true';window.close();}else{");
			out.println("	parent.location.reload()");
			out.println("}");
			out.println("</script>");
		} else {
			out.println("<script>");
			if (f.booleanValue()) {
				out.println("parent.doEndSign_exchange('','"+affairId+"');"); 
			} else {
				out.println("window.getA8Top().close();");
			}
			out.println("</script>");
		}
		return null;
	}
	
	
	
	/**
	 * 发文交换后取回
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@CheckRoleAccess(roleTypes={Role_NAME.Accountexchange,Role_NAME.Departmentexchange})
	public ModelAndView takeBack(HttpServletRequest request, HttpServletResponse response) throws Exception {
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter out = response.getWriter(); 
		User user = AppContext.getCurrentUser();
		String userName = "";
		if (null != user) {
			userName = user.getName();
		}
		String takeBackSendEdocId = request.getParameter("takeBackSendEdocId");
		if (Strings.isBlank(takeBackSendEdocId)) {
			LOGGER.error("ID为空");
			return null;
		}
		// 取得待取回公文的recode
		EdocSendRecord edocSendRecord = sendEdocManager.getEdocSendRecord(Long.valueOf(Long.parseLong(takeBackSendEdocId)));
		
		EdocRecieveRecord record = edocExchangeManager.getReceivedRecordByEdocId(edocSendRecord.getEdocId());
		String alertNote = "";
		if (null != record && record.getStatus()!=EdocRecieveRecord.Exchange_iStatus_Torecieve) { 
			alertNote = ResourceUtil.getString( "exchange.fenfa.receive.already", edocSendRecord.getSubject());
			try {
				out.println("<script>");
				out.println("alert('" + alertNote + "');");
				out.println("if(window.dialogArguments){window.returnValue='true';window.close();");
				out.println("}else{");
				out.println("window.location.href='exchangeEdoc.do?method=list&listType=listFenfa&modleType=sent';");
				out.println("}");
				// out.println("history.go(-1);");
				out.println("</script>");
				return null;
			} catch (Exception e) {
			    LOGGER.error("", e);
			}
		} else if (null == record) {
			alertNote = ResourceUtil.getString("exchange.send.withdrawed");
			out.println("<script>");
			out.println("alert('" + alertNote + "');");
			out.println("if(window.dialogArguments){");
			out.println("window.returnValue='true';window.close();}else{");
			out.println("parent.location.reload();");
			out.println("}");
			// out.println("history.go(-1);");
			out.println("</script>");
			return null;
		}
		//String stepBackInfo = request.getParameter("stepBackInfo");
		//String stepBackEdocIdString = request.getParameter("stepBackEdocId");

		try {

		EdocSummary stepBackEdocSummary = edocSummaryManager.findById(edocSendRecord.getEdocId());
		edocExchangeManager.takeBackEdoc(edocSendRecord.getEdocId(),
				user.getId(), userName, stepBackEdocSummary);

		Map<String, Object> conditions = new HashMap<String, Object>();
		conditions.put("app", ApplicationCategoryEnum.exSign.key());
		conditions.put("objectId", record.getEdocId());
		conditions.put("subObjectId", record.getId());
		List<CtpAffair> affairList = affairManager.getByConditions(null,conditions);

		if (null != affairList && affairList.size() > 0) {
			List<MessageReceiver> receivers = new ArrayList<MessageReceiver>();
			for (CtpAffair af : affairList) {
				if ( !user.getId().equals(af.getMemberId())
						&& !af.isDelete()) {
					receivers.add(new MessageReceiver(af.getId(), af
							.getMemberId()));
				}
			}
			// 批量更新,待签收公文变成已经发送
			Map<String, Object> columns = new Hashtable<String, Object>();
			columns.put("isFinish", true);
			columns.put("isDelete", true);
			columns.put("state", StateEnum.edoc_exchange_sent.getKey());
			affairManager.update(columns, new Object[][] {
					{ "app", ApplicationCategoryEnum.exSign.key() },
					{ "objectId", record.getEdocId() },
					{ "subObjectId", record.getId() } });
			/*
			 * （代签收的人员）发消息给其他公文收发员，公文已回退
			 */
			if (null != receivers && receivers.size() > 0) {
				userMessageManager.sendSystemMessage(new MessageContent(
							"exchange.stepback",
							affairList.get(0).getSubject(), userName,
							""),
						ApplicationCategoryEnum.edocRec, user.getId(),
						receivers,EdocMessageFilterParamEnum.exchange.key);
			}
		}
			out.println("<script>");
			out.println("parent.location.reload();");
			out.println("</script>");
		} catch (Exception e) {
			LOGGER.error("", e);
			return null;
		} finally {
		}
		return null;
	}
	
	/**
	 * 校验签收数据
	 * @param response
	 * @param record
	 * @return
	 * @throws Exception
	 */
	public boolean checkEdocRecieveRecord(HttpServletResponse response, EdocRecieveRecord record, boolean isLock) {
		return checkEdocRecieveRecord(response, record, false, isLock);
	}
	
	/**
	 * 校验签收数据
	 * @param response
	 * @param record
	 * @return
	 * @throws Exception
	 */
	public boolean checkEdocSendRecord(HttpServletResponse response, EdocSendRecord record, boolean isLock) {
		return checkEdocSendRecord(response, record, false, isLock);
	}	
	
	/**
	 * 
	 * @param response
	 * @param detail
	 * @return
	 */
	public boolean checkEdocSendDetail(HttpServletResponse response, EdocSendDetail detail) {
		return checkEdocSendDetail(response, detail, false);
	}
	/**
	 * 
	 * @param alertMsg
	 * @return
	 */
	private String doEndSign_exchange_Java(String alertMsg) {
		return doEndSign_exchange_Java(alertMsg, false);
	}
	
	/**
	 * 校验发送数据
	 * @param response
	 * @param record
	 * @return
	 * @throws Exception
	 */
	public boolean checkEdocSendRecord(HttpServletResponse response, EdocSendRecord record, boolean isDialogArguments, boolean isLock) {
		try {
			User user = CurrentUser.get();
			String alertNote = "";
			if(null==record) {
				alertNote = ResourceUtil.getString( "exchange.send.withdrawed");
			} else if(record.getStatus() == EdocSendRecord.Exchange_iStatus_Send_Delete
					|| record.getStatus() == EdocSendRecord.Exchange_iStatus_ToSend_Delete) {//已删除
				alertNote = ResourceUtil.getString("exchange.sendRecord.send.deleted");
			} else if(record.getStatus() == EdocSendRecord.Exchange_iStatus_Sent || (!user.getId().equals(record.getSendUserId()) &&  record.getStatus() == EdocSendRecord.Exchange_iStatus_Send_StepBacked)) {//已发送
				alertNote = ResourceUtil.getString( "exchange.sendRecord.send.already");
			}
			if(Strings.isBlank(alertNote) && isLock) {
				Long lockUserId = edocLockManager.canGetLock(record.getId(), AppContext.currentUserId());
				if(lockUserId != null && lockUserId.longValue()!=AppContext.currentUserId()) {
					V3xOrgMember member = orgManager.getMemberById(lockUserId);
					if(member != null) {
						alertNote =  ResourceUtil.getString("edoc.lock.finishWorkItem", member.getName());	
					}
				}
			}
			if(Strings.isNotBlank(alertNote)) {
				StringBuffer jsBuffer = new StringBuffer();
				jsBuffer.append("if(parent.doEndSign_exchange) {");
				jsBuffer.append("	parent.doEndSign_exchange('"+alertNote+"','');");
				jsBuffer.append("} else {");
				jsBuffer.append(	doEndSign_exchange_Java(alertNote));
				jsBuffer.append("}");
				super.rendJavaScript(response, jsBuffer.toString());
				return false;
			}
		} catch(Exception be) {
			return false;
		}
		return true;
	}
	
	
	
	public boolean checkEdocRecieveRecord(HttpServletResponse response, EdocRecieveRecord record, boolean isDialogArguments,boolean isCanDeal, boolean isLock) {
		try {
			String alertNote = "";
			if(null==record){
				alertNote = ResourceUtil.getString("exchange.send.withdrawed");
			} else if(record.getStatus() == EdocRecieveRecord.Exchange_iStatus_Receive_StepBacked) {//退回到待发送
				alertNote = ResourceUtil.getString("exchange.receiveRecord.receive.stepbacked");
			} else if((record.getStatus() == EdocRecieveRecord.Exchange_iStatus_Recieved || record.getStatus() == EdocRecieveRecord.Exchange_iStatus_Registered) //已签收
			    || (!isCanDeal && record.getStatus() == EdocRecieveRecord.Exchange_iStatus_Receive_Retreat)) {//退回到待发送
				alertNote = ResourceUtil.getString( "exchange.receiveRecord.receive.already");
			}
			if(Strings.isBlank(alertNote) && isLock) {
				Long lockUserId = edocLockManager.canGetLock(record.getId(), AppContext.currentUserId());
				if(lockUserId != null && lockUserId.longValue()!=AppContext.currentUserId()) {
					V3xOrgMember member = orgManager.getMemberById(lockUserId);
					if(member != null) {
						alertNote =  ResourceUtil.getString("edoc.lock.finishWorkItem", member.getName());	
					}
				}
			}
			if(Strings.isNotBlank(alertNote)) {
				StringBuffer jsBuffer = new StringBuffer();
				jsBuffer.append("var currentWindow = window;");
//				if(isDialogArguments) {
//					jsBuffer.append("if(window.dialogArguments) {");
//					jsBuffer.append("	currentWindow = window.dialogArguments;");
//					jsBuffer.append("	window.close();");
//					jsBuffer.append("}");
//				}
				jsBuffer.append("if(parent.doEndSign_exchange) {");
				jsBuffer.append("	parent.doEndSign_exchange('"+alertNote+"');");
				jsBuffer.append("} else {");
				jsBuffer.append(	doEndSign_exchange_Java(alertNote, isDialogArguments));
				jsBuffer.append("}");
				//如果从首页打开的，需要刷新首页
				jsBuffer.append("try{");
				jsBuffer.append("window.opener.document.getElementById('main').contentWindow.sectionHandler.reload('pendingSection', true)");
				jsBuffer.append("}catch(e){}");
				super.rendJavaScript(response, jsBuffer.toString());
				return false;
			}
		} catch(Exception e) {
		    LOGGER.error("", e);
			return false;
		}
		return true;
	}
	
	
	/**
	 * 校验签收数据
	 * @param response
	 * @param record
	 * @return
	 * @throws Exception
	 */
	public boolean checkEdocRecieveRecord(HttpServletResponse response, EdocRecieveRecord record, boolean isDialogArguments, boolean isLock) {
		return checkEdocRecieveRecord(response,record,isDialogArguments,true,isLock);
	}
	
	/**
	 * 校验签收数据
	 * @param response
	 * @param record
	 * @return
	 * @throws Exception
	 */
	public boolean checkEdocSendDetail(HttpServletResponse response, EdocSendDetail detail, boolean isDialogArguments) {
		try {
			String alertNote = "";
			if(null==detail){
				alertNote = ResourceUtil.getString("exchange.send.withdrawed");
			} else if(detail.getStatus() == EdocSendDetail.Exchange_iStatus_SendDetail_StepBacked) {//退回到待发送
				alertNote = ResourceUtil.getString("exchange.receiveRecord.receive.stepbacked");
			} else if(detail.getStatus() == EdocSendDetail.Exchange_iStatus_SendDetail_Cancel) {//已撤销
				alertNote = ResourceUtil.getString("exchange.send.withdrawed");
			} else if(detail.getStatus() == EdocSendDetail.Exchange_iStatus_SendDetail_Recieved) {//已签收
				alertNote = ResourceUtil.getString( "exchange.receiveRecord.receive.already");
			}
			if(Strings.isNotBlank(alertNote)) {
				StringBuffer jsBuffer = new StringBuffer();
				jsBuffer.append("	var currentWindow = window;");
				if(isDialogArguments) {
					jsBuffer.append("if(window.dialogArguments) {");
					jsBuffer.append("	currentWindow = window.dialogArguments;");
					jsBuffer.append("	alert('" + alertNote + "');");
					jsBuffer.append("	window.close();");
					jsBuffer.append("}");
				}
				jsBuffer.append("	var url = currentWindow.location.href;");
				jsBuffer.append("	currentWindow.location.href = url;");
				super.rendJavaScript(response, jsBuffer.toString());
				return false;
			}
		} catch(Exception e) {
			return false;
		}
		return true;
	}
	
	/**
	 * 
	 * @param alertMsg
	 * @param isDialogArguments
	 * @return
	 */
	private String doEndSign_exchange_Java(String alertMsg, boolean isDialogArguments) {
		StringBuilder jsBuffer = new StringBuilder();
		jsBuffer.append("var currentWindow = window;");
		if(isDialogArguments) {
			jsBuffer.append("currentWindow = window.dialogArguments;");
			jsBuffer.append("window.close();");
		}
		jsBuffer.append("function doEndSign_exchange_java(alertMsg) {");
		jsBuffer.append("	if(alertMsg) {");
		jsBuffer.append("		alert(alertMsg);");
		jsBuffer.append("	}");
		jsBuffer.append("	var openerWindow = window.opener;");
		jsBuffer.append("	var detailWindow = window;");
		jsBuffer.append("	if(openerWindow) {");
		jsBuffer.append("		try {");
		jsBuffer.append("			var url = openerWindow.location.href;");
		jsBuffer.append("			if(url!='' && (url.indexOf('modelType=toSend')>=0 || url.indexOf('modelType=toReceive')>=0 || url.indexOf('modelType=sent')>=0)) {");
		jsBuffer.append("				openerWindow.location.reload();");
		jsBuffer.append("			}");
		jsBuffer.append("		} catch(e) {}");
		jsBuffer.append("		detailWindow.close();");
		jsBuffer.append("	} else {");
		jsBuffer.append("		var parentWindow = window.dialogArguments;");
		jsBuffer.append("		var isModel = true;");
		jsBuffer.append("		if(parentWindow == undefined) {");
		jsBuffer.append("			parentWindow = parent.window.dialogArguments;");
		jsBuffer.append("			isModel = false;");
		jsBuffer.append("		}");
		jsBuffer.append("		if(parentWindow) {");
		jsBuffer.append("			if(parentWindow.diaClose!=null && typeof(parentWindow.diaClose)=='function') {");
		jsBuffer.append("				try {");
		jsBuffer.append("					parentWindow.diaClose();");
		jsBuffer.append("				} catch(e) {}");
		jsBuffer.append("				if(parentWindow.window && parentWindow.window.dialogDealColl) {");
		jsBuffer.append("					parentWindow.window.dialogDealColl.close();");
		jsBuffer.append("				}");
		jsBuffer.append("			} else {");
		jsBuffer.append("				if(parentWindow.callbackOfPendingSection != null && parentWindow.callbackOfPendingSection) {");
		jsBuffer.append("					parentWindow.callbackOfPendingSection();");
		jsBuffer.append("				} else {");
		jsBuffer.append("					if(isModel) {");
		jsBuffer.append("						window.returnValue = 'true';");
		jsBuffer.append("						detailWindow.close();");
		jsBuffer.append("					}");
		jsBuffer.append("				}");
		jsBuffer.append("			}");
		jsBuffer.append("		} else {");
		jsBuffer.append("			var parentListFrame = parent.listFrame;");
		jsBuffer.append("			if(parentListFrame) {");
		jsBuffer.append("				parentListFrame.location.reload();");
		jsBuffer.append("			} else {");
		jsBuffer.append("				if(typeof(getA8Top)!='undefined' && getA8Top().window.dialogArguments){");
		jsBuffer.append("					detailWindow.close();");
		jsBuffer.append("				} else if(typeof(getA8Top)!='undefined' && getA8Top().window.opener){");
		jsBuffer.append("					detailWindow.close();");
		jsBuffer.append("				}else{");
		jsBuffer.append("					detailWindow.close();");
		jsBuffer.append("				}");
		jsBuffer.append("			}");
		jsBuffer.append("		}");
		jsBuffer.append("	}");
		jsBuffer.append("}");
		jsBuffer.append("if(currentWindow.doEndSign_exchange_java) {");
		jsBuffer.append("	currentWindow.doEndSign_exchange_java('"+alertMsg+"');");
		jsBuffer.append("}");
		return jsBuffer.toString();
	}
	
	public ModelAndView openCuiban(HttpServletRequest request, HttpServletResponse response) throws Exception {
	    ModelAndView model = new ModelAndView("exchange/edoc/edocCuiban");
	    String detailId = request.getParameter("detailId");
	    EdocSendDetail detail = sendEdocManager.getSendRecordDetail(Long.parseLong(detailId));
        if(detail.getStatus() != EdocSendDetail.Exchange_iStatus_SendDetail_Torecieve){
            String alertNote = "";
            if(detail.getStatus() == EdocSendDetail.Exchange_iStatus_SendDetail_StepBacked) {//退回到待发送
                alertNote = ResourceUtil.getString("exchange.receiveRecord.receive.stepbacked");
            } else if(detail.getStatus() == EdocSendDetail.Exchange_iStatus_SendDetail_Cancel) {//已撤销
                alertNote = ResourceUtil.getString( "exchange.send.withdrawed");
            } else if(detail.getStatus() == EdocSendDetail.Exchange_iStatus_SendDetail_Recieved) {//已签收
                alertNote = ResourceUtil.getString("exchange.receiveRecord.receive.already");
            }
            StringBuffer jsContent = new StringBuffer();
            jsContent.append("alert('"+alertNote+"');");
            jsContent.append("window.close();");
            jsContent.append("parent.location.reload();");
            super.rendJavaScript(response, jsContent.toString());
            return null;
        }
	    return model;
	}
	private void webAlertAndClose(HttpServletResponse response,String msg) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<script>");
        out.println("alert('"+ StringEscapeUtils.escapeJavaScript(msg)+"');");
        out.println("if(window.parentDialogObj && window.parentDialogObj['dialogDealColl']){");
        out.println(" window.parentDialogObj['dialogDealColl'].close();");
        out.println("}else if(window.dialogArguments){"); //弹出
        out.println("  window.close();");
        out.println("}else{");
        out.println(" window.close();");
        out.println("}");
        out.println("</script>");
    }
	
	@CheckRoleAccess(roleTypes={Role_NAME.NULL})
	public ModelAndView openTurnRec(HttpServletRequest request,HttpServletResponse response) throws Exception{
		ModelAndView mav = new ModelAndView("exchange/edoc/turnRec");
		EdocManager edocManager = (EdocManager)AppContext.getBean("edocManager");
		String edocId = request.getParameter("summaryId");
		EdocExchangeTurnRecManager edocExchangeTurnRecManager = (EdocExchangeTurnRecManager)AppContext.getBean("edocExchangeTurnRecManager");
		EdocExchangeTurnRec turnRec = edocExchangeTurnRecManager.findEdocExchangeTurnRecByEdocId(Long.parseLong(edocId));
		EdocSummary summary = edocManager.getEdocSummaryById(Long.parseLong(edocId), false);
		V3xOrgMember sender = summary.getStartMember();
		mav.addObject("sendUserDepartmentId", sender.getOrgDepartmentId());
		mav.addObject("sendUserAccountId", sender.getOrgAccountId());
		if(turnRec!=null){
			mav.addObject("turnRec", turnRec);
			mav.addObject("hasTurnRec", "true");
			mav.addObject("sendUnitNames", turnRec.getSendUnitNames(orgManager));
		} 
		
		/**
		 * 获取默认交换类型
		 */
		int defaultType = EdocSwitchHelper.getDefaultExchangeType();
		mav.addObject("defaultType", defaultType);
		
		/************获得单位交换人员以及收文登记人 部门(需要把父岗取出来)***************/
		Map<String,Object> map = EdocHelper.getOrgExchangeMembersAndDeptSenders(summary);
		mav.addObject("deptSenderList", map.get("deptSenderList"));
		mav.addObject("memberList", map.get("memberList"));
		return mav;
	}
	
	@CheckRoleAccess(roleTypes={Role_NAME.NULL})
	public ModelAndView openTurnRecInfo(HttpServletRequest request,HttpServletResponse response) throws Exception{
		ModelAndView mav = new ModelAndView("exchange/edoc/turnRecInfo");
		String edocId = request.getParameter("summaryId");
		String type = request.getParameter("type");
		
		if("newedoc".equals(type)){
			EdocExchangeTurnRec turnRec = edocExchangeTurnRecManager.findEdocExchangeTurnRecByEdocId(Long.parseLong(edocId));
			if(turnRec!=null){
				mav.addObject("supOpinion", turnRec.getOpinion());
				mav.addObject("hasSupOpinion", "true");
			}
		}else{
			//对下级单位的 办理意见
			EdocExchangeTurnRec turnRec = edocExchangeTurnRecManager.findEdocExchangeTurnRecByEdocId(Long.parseLong(edocId));
			if(turnRec!=null){
				String createTurnRecUserName = turnRec.getUserName();
				String opinion = turnRec.getOpinion();
				String sendUnitNames = turnRec.getSendUnitNames(orgManager);
				mav.addObject("createTurnRecUserName", createTurnRecUserName);
				mav.addObject("opinion", opinion);
				mav.addObject("sendUnitNames", sendUnitNames);
				mav.addObject("createTime", turnRec.getCreateTime());
				mav.addObject("hasToSubOpinion", "true");
			}
			
			
			/**
			 * 上级单位的办理意见
			 */
			//需要先获得下级单位公文 关联的上级单位公文id
			Long supEdocId = edocExchangeTurnRecManager.findSupEdocId(Long.parseLong(edocId));
			if(supEdocId != null){
				EdocExchangeTurnRec supTurnRec = edocExchangeTurnRecManager.findEdocExchangeTurnRecByEdocId(supEdocId);
				mav.addObject("supOpinion", supTurnRec.getOpinion());
				mav.addObject("hasSupOpinion", "true");
			}
		}
		return mav;
	}
	
	/**
	 * 转收文提交
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@CheckRoleAccess(roleTypes={Role_NAME.NULL})
	public ModelAndView turnRecExcute(HttpServletRequest request,HttpServletResponse response) throws Exception{
		String grantedDepartId = request.getParameter("grantedDepartId");
		String opinion = request.getParameter("opinion");
		String exchangeType = request.getParameter("exchangeType");
		String summaryId = request.getParameter("summaryId");
		String exchangeMemberId = request.getParameter("memberList");//单位交换员选的具体人 或 全部
		//指定某个部门
		String returnDeptId = request.getParameter("returnDeptId");
		User user = AppContext.getCurrentUser();
		String msg = edocExchangeTurnRecManager.transCreateSendDataByTurnRec(user, Long.parseLong(summaryId), Integer.parseInt(exchangeType), grantedDepartId,
				opinion,exchangeMemberId,returnDeptId);
		StringBuffer jsContent = new StringBuffer();
		if("success".equals(msg)){
			String alertStr=ResourceBundleUtil.getString("com.seeyon.v3x.exchange.resources.i18n.ExchangeResource","exchange.receiveRecord.receive.already.label");
			jsContent.append("alert('"+alertStr+"!');");
		}else{
			String alertStr=ResourceUtil.getString("system.manager.fail");
			jsContent.append("alert('"+alertStr+"!');");
		}
		jsContent.append("parent.parent.getCtpTop().turnRecDialog.close();");
		super.rendJavaScript(response, jsContent.toString());
		return null;
	}
	
	
	public EnumManager getEnumManagerNew() {
		return enumManagerNew;
	}

	public void setEnumManagerNew(EnumManager enumManager) {
		this.enumManagerNew = enumManager;
	}

	public OrgManager getOrgManager() {
		return orgManager;
	}
	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}

	public void setAffairManager(AffairManager affairManager) {
		this.affairManager = affairManager;
	}
	
}