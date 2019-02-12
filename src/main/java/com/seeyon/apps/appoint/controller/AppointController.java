package com.seeyon.apps.appoint.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.Date;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

import cn.com.cinda.taskcenter.util.StringUtils;
import www.seeyon.com.utils.URLUtil;

import com.seeyon.apps.appoint.util.CZFromTemplateToSendEdocImpl;
import com.seeyon.apps.cinda.sso.SSOLoginHandShakeCinda;
import com.seeyon.apps.edoc.enums.EdocEnum;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.authenticate.sso.SSOTicketManager.TicketInfo;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.ctpenumnew.EnumNameEnum;
import com.seeyon.ctp.common.customize.manager.CustomizeManager;
import com.seeyon.ctp.common.i18n.ResourceBundleUtil;
import com.seeyon.ctp.common.permission.manager.PermissionManager;
import com.seeyon.ctp.common.permission.vo.PermissionVO;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.template.CtpTemplate;
import com.seeyon.ctp.common.template.manager.TemplateManager;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.portal.sso.SSOTicketBean;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.HttpClientUtil;
import com.seeyon.ctp.util.ReqUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import com.seeyon.v3x.edoc.controller.newedoc.A8RegisterEdocImpl;
import com.seeyon.v3x.edoc.controller.newedoc.CreateNewEdocImpl;
import com.seeyon.v3x.edoc.controller.newedoc.DistributeToSendEdocImpl;
import com.seeyon.v3x.edoc.controller.newedoc.ForwordtosendEdocImpl;
import com.seeyon.v3x.edoc.controller.newedoc.NewEdocHandle;
import com.seeyon.v3x.edoc.controller.newedoc.TransmitSendEdocImpl;
import com.seeyon.v3x.edoc.controller.newedoc.WaitForSendEdocImpl;
import com.seeyon.v3x.edoc.domain.EdocSummary;
import com.seeyon.v3x.edoc.enums.EdocOpenFrom;
import com.seeyon.v3x.edoc.manager.EdocHelper;
import com.seeyon.v3x.edoc.manager.EdocManager;
import com.seeyon.v3x.edoc.manager.EdocRoleHelper;
import com.seeyon.v3x.edoc.manager.EdocSwitchHelper;

public class AppointController extends BaseController{
	private static final Log log = LogFactory.getLog(AppointController.class);
	private static final String deftempateId = SystemProperties.getInstance().getProperty("appoint.templateId");
	private EdocManager edocManager;
	private AffairManager affairManager;
	private PermissionManager permissionManager;
	private TemplateManager templateManager;
	private CustomizeManager customizeManager;
	
	
	public void setCustomizeManager(CustomizeManager customizeManager) {
		this.customizeManager = customizeManager;
	}


	public void setTemplateManager(TemplateManager templateManager) {
		this.templateManager = templateManager;
	}


	public void setPermissionManager(PermissionManager permissionManager)
	  {
	    this.permissionManager = permissionManager;
	  }
	public void setAffairManager(AffairManager affairManager) {
		this.affairManager = affairManager;
	}

	public void setEdocManager(EdocManager edocManager) {
		this.edocManager = edocManager;
	}
	/**
	 * 获得A8V5的http地址，例如：http://192.168.1.45:80/seeyon
	 */
	
	public String getURLPrefix(HttpServletRequest request){
		String baseurl = SystemProperties.getInstance().getProperty("internet.site.url");

		if(Strings.isBlank(baseurl)){
			baseurl = request.getLocalAddr()+":"+request.getLocalPort();
			if(testUrl("http://"+baseurl)){
				baseurl = "http://"+baseurl;
			}else if(testUrl("https://"+baseurl)){
				baseurl = "https://"+baseurl;
			}
			if(Strings.isNotBlank(baseurl)){
				
				SystemProperties.getInstance().put("internet.site.url", baseurl);
			}
		}
		String contextPath = SystemEnvironment.getContextPath();
		if(Strings.isBlank(contextPath)){
			contextPath = request.getContextPath();
		}
		return baseurl+contextPath;
	}
	private static boolean testUrl(String url){
		HttpClientUtil u = new HttpClientUtil();
		u.open(url, "post");
		try {
			u.send();
			u.close();
		} catch (Exception e1) {
			log.error(e1);
			return false;
		}
		Map<String,String> map = u.getResponseHeader();

		return map!=null;
	}
	@NeedlessCheckLogin
	public ModelAndView index(HttpServletRequest request, HttpServletResponse response) throws Exception{
		Long summaryid = ReqUtil.getLong(request, "id");
		
		EdocSummary summary = edocManager.getEdocSummaryById(summaryid, true);
		if(summary!=null){
			CtpAffair affair = affairManager.getSenderAffair(summaryid);
			String userName = OrgHelper.getMember(affair.getMemberId()).getLoginName();
			String ticket = SSOLoginHandShakeCinda.makeTicket(userName);
			String v5path4Url = getURLPrefix(request)+"/login/sso";;
			HttpClientUtil u = new HttpClientUtil();
				u.open(v5path4Url, "post");
				u.addParameter("ticket", ticket);
				u.addParameter("from", "cindasso");
				try {
					u.send();
				} catch (IOException e1) {
					log.error("",e1);
				}
			if(u.getResponseHeader().containsKey("SSOError")){
				u.close();
			}else{
				u.close();
				TicketInfo ticketInfo = com.seeyon.ctp.portal.sso.SSOTicketBean.getTicketInfo(ticket);
				if(ticketInfo != null) {
					String url=getURLPrefix(request)+"/edocController.do?method=summary&summaryId="+summaryid+"&affairId="+affair.getId();
					String openurl = SSOTicketBean.makeURLOfSSOTicket(ticket, url);
					log.info("openurl="+openurl);
					response.sendRedirect(openurl);
				}else{
						rendJavaScript(response, "alert('您要打开的流程已经被删除！');window.close();");
				}
			}
		
		}else{
				rendJavaScript(response, "alert('您要打开的流程已经被删除！');window.close();");
		}
		return null;
		
	}
	//portalUser=75B016CA2A93D74AAD14975ACC1B1D2E33BDB98BB1B94FB1E2127931B83F2692
	@NeedlessCheckLogin
	public ModelAndView ssonewEdoc (HttpServletRequest request, HttpServletResponse response) throws Exception{
//		http://idpserver10.zc.cinda.ccb/idpServer/login?service=
//			http://portal11.zc.cinda.ccb:80/oastA/interface/login_hdy.jsp?otherIdp=1&portalUser=F0301779C563A4E9FD46A718B9A9A816DA5DB61126AE84A33D401697EDD39838
//		&urlpath=../gongwen/gwFrame.jsp?ENTITY_ID=3||SELECT_MODEL=1||fromothersys=
//			syscode=ghr||sysflowid=f7692ae0f5bf479693cce8ac60585826||systitle=关于张东辉的;&renew=false
		String tempateId = ReqUtil.getString(request, "templeteId");
		if(Strings.isBlank(tempateId)){
			tempateId = deftempateId;
		}
		String title = ReqUtil.getString(request, "systitle");
		String sysflowid = ReqUtil.getString(request, "sysflowid");
		String loginname = "";
		Date time = new Date(System.currentTimeMillis()); 
		String portalUser = ReqUtil.getString(request, "portalUser");
		if(Strings.isBlank(loginname) && Strings.isNotBlank(portalUser)){
			String[] usertiket = StringUtils.decrypt(request.getParameter("portalUser")).split(",");
			loginname = usertiket[0];
			time = Datetimes.parse(usertiket[1]); 
		}
		Object cindauser = request.getSession().getAttribute("cn.com.hkgt.idp.client.filter.user");
		cindauser = cindauser==null?request.getSession().getAttribute("PORTALUSER_LOGINID"):cindauser;
		if(Strings.isBlank(loginname) && cindauser!=null && Strings.isBlank(String.valueOf(cindauser))){
			loginname = String.valueOf(cindauser);
		}
		String ticket = SSOLoginHandShakeCinda.makeTicket(loginname);
		String v5path4Url = getURLPrefix(request)+"/login/sso";;
		HttpClientUtil u = new HttpClientUtil();
			u.open(v5path4Url, "post");
			u.addParameter("ticket", ticket);
			u.addParameter("from", "cindasso");
			try {
				u.send();
			} catch (IOException e1) {
				log.error("",e1);
			}
		if(u.getResponseHeader().containsKey("SSOError")){
			u.close();
		}else{
			u.close();
			TicketInfo ticketInfo = com.seeyon.ctp.portal.sso.SSOTicketBean.getTicketInfo(ticket);
			if(ticketInfo != null) {
				///cindaappoint.do?method=newEdoc&edocType=0&listType=newEdoc&templeteId=-2945971174859062762
//				String url=getURLPrefix(request)+"/cindaappoint.do?method=newEdoc&edocType=0&listType=newEdoc&templeteId="+tempateId;
				//String url=getURLPrefix(request)+"/cindaappoint.do?method=edocSend&toFrom=newEdoc&templeteId="+tempateId+"&title="+title+"&sysflowid="+sysflowid;
				String url=getURLPrefix(request)+"/cindaappoint.do?method=edocSend&toFrom=newEdoc&templeteId="+tempateId+"&title="+URLUtil.encode(title)+"&sysflowid="+sysflowid;
				String openurl = SSOTicketBean.makeURLOfSSOTicket(ticket, url);
				log.info("openurl="+openurl);
				response.sendRedirect(openurl);
			}else{
					rendJavaScript(response, "alert('OA系统中没有找到用户名为！"+loginname+"的用户！');window.close();");
			}
		}
		return null;
		
	}

	  public ModelAndView edocSend(HttpServletRequest request, HttpServletResponse response)
			    throws Exception
			  {
			    ModelAndView modelAndView = new ModelAndView("plugin/appoint/edocFrameEntry");
			    modelAndView.addObject("entry", request.getParameter("entry"));
			    modelAndView.addObject("openFrom", request.getParameter("openFrom"));
//			    modelAndView.addObject("templeteId", request.getParameter("templeteId"));
//			    modelAndView.addObject("title", request.getParameter("title")); 
//			    modelAndView.addObject("sysflowid", request.getParameter("sysflowid"));
			    
			    String templeteId = request.getParameter("templeteId");
			    modelAndView.addObject("templeteId", templeteId);
			    modelAndView.addObject("title", request.getParameter("title")); 
			    modelAndView.addObject("sysflowid", request.getParameter("sysflowid"));
			    String title =  request.getParameter("title");
			    modelAndView.addObject("title", title); 
			    String sysflowid = request.getParameter("sysflowid");
			    modelAndView.addObject("sysflowid", sysflowid);
			    String redirectURL = "/seeyon/cindaappoint.do?method=newEdoc&edocType=0&listType=newEdoc&templeteId="+templeteId+"&title="+URLUtil.encode(title)+"&sysflowid="+sysflowid;
			    modelAndView.addObject("redirectURL", redirectURL);
			    
			    String toFrom = request.getParameter("toFrom");
			    modelAndView.addObject("registerType", request.getParameter("registerType"));
			    if ((Strings.isNotBlank(toFrom)) && ("newEdoc".equals(toFrom)) && (Strings.isNotBlank(request.getParameter("templeteId"))))
			    {
			      int edocType = Strings.isBlank(request.getParameter("edocType")) ? 0 : Integer.parseInt(request.getParameter("edocType"));
			      
			      int roleEdocType = edocType == 1 ? 3 : edocType;
			      boolean isEdocCreateRole = EdocRoleHelper.isEdocCreateRole(AppContext.getCurrentUser().getLoginAccount(), AppContext.getCurrentUser().getId(), roleEdocType);
			      if ((!isEdocCreateRole) && (!"agent".equals(request.getParameter("app"))))
			      {
			        StringBuffer sb = new StringBuffer();
			        String errMsg = ResourceBundleUtil.getString("com.seeyon.v3x.edoc.resources.i18n.EdocResource", "alert_not_edoccreate", new Object[0]);
			        if (edocType == EdocEnum.edocType.recEdoc.ordinal())
			        {
			          String msgKey = "alert_not_edocregister";
			          if (EdocHelper.isG6Version()) {
			            msgKey = "alert_not_edoc_fenfa";
			          }
			          errMsg = ResourceBundleUtil.getString("com.seeyon.v3x.edoc.resources.i18n.EdocResource", msgKey, new Object[0]);
			        }
			        sb.append("alert('" + errMsg + "');");
			        sb.append("if(window.dialogArguments) {");
			        sb.append("   window.returnValue = \"true\";");
			        sb.append("   window.close();");
			        sb.append("} else {");
			        if (Strings.isNotBlank(request.getParameter("templeteId"))) {
			          sb.append("  history.back();");
			        } else if (edocType == EdocEnum.edocType.recEdoc.ordinal()) {
			          sb.append("  location.href='edocController.do?method=entryManager&entry=recManager';");
			        } else if (edocType == EdocEnum.edocType.signReport.ordinal()) {
			          sb.append("  location.href='edocController.do?method=entryManager&entry=signReport';");
			        } else {
			          sb.append("  location.href='edocController.do?method=entryManager&entry=sendManager';");
			        }
			        sb.append("}");
			        rendJavaScript(response, sb.toString());
			        return null;
			      }
			    }
			    else if ((Strings.isNotBlank(toFrom)) && ("newEdocRegister".equals(toFrom)) && (!EdocHelper.isG6Version()))
			    {}
			    String comm = request.getParameter("comm");
			    if (("register".equals(comm)) && ("1".equals(request.getParameter("edocType"))))
			    {}
			    return modelAndView;
			  }
	
	public ModelAndView newEdoc(HttpServletRequest request, HttpServletResponse response)
	    throws Exception
	  {
	    ModelAndView modelAndView = new ModelAndView("plugin/appoint/newEdoc");
	    User user = AppContext.getCurrentUser();
	    if ("true".equals(request.getParameter("quickView"))) {
	      modelAndView = new ModelAndView("edoc/newEdoc_quickview");
	    }
	    

	    String register = request.getParameter("register");
	    String meetingSummaryId = request.getParameter("meetingSummaryId");
	    String comm = request.getParameter("comm");
	    String from = request.getParameter("from");
	    String s_summaryId = request.getParameter("summaryId");
	    String templeteId = request.getParameter("templeteId");
	    String oldtempleteId = request.getParameter("oldtempleteId");
	    String edocType = request.getParameter("edocType");
	    boolean hasDoc = AppContext.hasPlugin("doc");
	    
	    modelAndView.addObject("hasDoc", Boolean.valueOf(hasDoc));
	    modelAndView.addObject("pageview", request.getParameter("pageview"));
	    modelAndView.addObject("source", request.getParameter("source"));
	    

	    String configCategory = EnumNameEnum.edoc_send_permission_policy.name();
	    if (String.valueOf(EdocEnum.edocType.sendEdoc.ordinal()).equals(edocType)) {
	      configCategory = EnumNameEnum.edoc_send_permission_policy.name();
	    } else if (String.valueOf(EdocEnum.edocType.recEdoc.ordinal()).equals(edocType)) {
	      configCategory = EnumNameEnum.edoc_rec_permission_policy.name();
	    } else if (String.valueOf(EdocEnum.edocType.signReport.ordinal()).equals(edocType)) {
	      configCategory = EnumNameEnum.edoc_qianbao_permission_policy.name();
	    }
	    PermissionVO permission = permissionManager.getDefaultPermissionByConfigCategory(configCategory, user.getLoginAccount());
	    modelAndView.addObject("defaultNodeName", permission.getName());
	    modelAndView.addObject("defaultNodeLable", permission.getLabel());
	    
	    String subTypeStr = request.getParameter("subType");
	    String registerIdStr = request.getParameter("registerId");
	    



	    String checkOption = "";
	    String openForm = "";
	    

	    setReadEdocIsView(modelAndView);
	    
	    NewEdocHandle handle = null;
	    if ("transmitSend".equals(comm))
	    {
	      handle = new TransmitSendEdocImpl();
	    }
	    else if ("distribute".equals(comm))
	    {
	      handle = new DistributeToSendEdocImpl();
	    }
	    else if (Strings.isNotBlank(templeteId))
	    {
	      modelAndView.addObject("fromTemplateFlag", "true");
	      CtpTemplate ctpTemplate = templateManager.getCtpTemplate(Long.valueOf(templeteId));
	      if ((null != ctpTemplate) && 
	        (!ctpTemplate.isSystem().booleanValue())) {
	        modelAndView.addObject("personalTemplateFlag", "1");
	      }
//	      handle = new FromTemplateToSendEdocImpl();
	      handle = new  CZFromTemplateToSendEdocImpl();
	    }
	    else if (Strings.isNotBlank(s_summaryId))
	    {
	      handle = new WaitForSendEdocImpl();
	      openForm = EdocOpenFrom.glwd.name();
	    }
	    else if ("forwordtosend".equals(comm))
	    {
	      handle = new ForwordtosendEdocImpl();
	    }
	    else if ("register".equals(comm))
	    {
	      handle = new A8RegisterEdocImpl();
	    }
	    else
	    {
	      handle = new CreateNewEdocImpl();
	    }
	    handle.setParams(register, meetingSummaryId, comm, from, s_summaryId, templeteId, oldtempleteId, edocType, subTypeStr, registerIdStr, checkOption, openForm);

	    modelAndView = handle.execute(request, response, modelAndView);
	    if (modelAndView == null) {
	      return null;
	    }
	    if ((Strings.isNotBlank(templeteId)) && (Strings.isBlank(s_summaryId)))
	    {
	      String docMarkByTemplateJs = EdocHelper.exeTemplateMarkJs(null, null, null);
	      modelAndView.addObject("docMarkByTemplateJs", docMarkByTemplateJs);
	    }
	    if (modelAndView != null) {
	      modelAndView.addObject("isG6", Boolean.valueOf(EdocHelper.isG6Version()));
	    }
	    String _trackValue = customizeManager.getCustomizeValue(AppContext.getCurrentUser().getId().longValue(), "track_send");
	    if (Strings.isBlank(_trackValue)) {
	      modelAndView.addObject("customSetTrack", "true");
	    } else {
	      modelAndView.addObject("customSetTrack", _trackValue);
	    }
	    boolean taohongriqiSwitch = EdocSwitchHelper.taohongriqiSwitch(AppContext.currentAccountId());
	    modelAndView.addObject("taohongriqiSwitch", Boolean.valueOf(taohongriqiSwitch));
	    return modelAndView;
	  }

	private void setReadEdocIsView(ModelAndView modelAndView)
	    throws Exception
	  {
	    boolean readFlag = EdocSwitchHelper.showBanwenYuewen(AppContext.getCurrentUser().getLoginAccount());
	    modelAndView.addObject("readFlag", String.valueOf(readFlag));
	  }
	public static void main1(String[] args) throws IOException {
		String v5path4Url = "http://192.168.0.42/seeyon/index.jsp";;

		System.out.println(testUrl(v5path4Url));
	}
	public static void main(String[] args) throws Exception {
		String usertiket = StringUtils.encrypt("jsbfkq,"+Datetimes.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		System.out.println("portalUser="+usertiket);
		System.out.println(URLEncoder.encode("测试公文123123123", "utf-8"));
	}
}
