package com.seeyon.v3x.common.security;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.collaboration.enums.ColOpenFrom;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.util.Strings;

/**
 * 协同访问安全控制主程序
 * 
 * @author Mazc 2010-04-01 <br>
 *         合法的权限规则:
 *         <ul>
 *         <li>流程中的人员, 发布范围内的人</li>
 *         <li>代理人</li>
 *         <li>关联文档</li>
 *         <li>归档</li>
 *         <li>督办人</li>
 *         </ul>
 */
public class SecurityCheck {
	private static Log log = LogFactory.getLog(SecurityCheck.class);
	private static AttachmentManager attachmentManager;

	private static AttachmentManager theAttachmentManager() {
		if (attachmentManager == null) {
			attachmentManager = (AttachmentManager) AppContext
					.getBean("attachmentManager");
		}
		return attachmentManager;
	}
	private static Map<ApplicationCategoryEnum, SecurityControl> securityControlMap = new HashMap<ApplicationCategoryEnum, SecurityControl>();
	
	private static boolean inited = false;
	public void setSecurityCheckers(
			Map<String, SecurityControl> securityCheckers) {
		if (securityCheckers != null) {
			for (Iterator<String> iterator = securityCheckers.keySet()
					.iterator(); iterator.hasNext();) {
				String app = (String) iterator.next();
				ApplicationCategoryEnum appEnum = ApplicationCategoryEnum
						.valueOf(Integer.parseInt(app));
				SecurityCheck.securityControlMap.put(appEnum, securityCheckers
						.get(app));
			}
		}
//		init();
	}
	public static void init(){
		Map<String, SecurityControl> beans = AppContext.getBeansOfType(SecurityControl.class);
		for (SecurityControl sc : beans.values()) {
			ApplicationCategoryEnum category = sc.getApplicationCategory();
			if(!SecurityCheck.securityControlMap.containsKey(category)){
				SecurityCheck.securityControlMap.put(category, sc);
			}
		}
		inited = true;
	}
	
	
	/**
     * 安全防护，校验是否有权限查看主题
     * 
     * @param request
     * @param response
     * @param appEnum
     *            应用枚举
     * @param user
     *            CurrentUser
     * @param objectId
     *            主题对象的id
     * @param affair
     *            用于协同和公文，其他应用传null
     * @param preArchiveId
     *            预归档Id，用于协同，其他应用传null
     * @param responseMsg 是否向前台推送消息
     * @return
     */
	public static boolean isLicit(HttpServletRequest request, HttpServletResponse response, ApplicationCategoryEnum appEnum, 
	        User user, Long objectId, CtpAffair affair, Long preArchiveId, boolean responseMsg){

	    SecurityCheckParam param = new SecurityCheckParam(appEnum, user, objectId);
	    //赵辉  添加参数 绕过安全访问检测 start
	    String jump = request.getParameter("jump");
	    if(Strings.isNotBlank(jump)){
	    	return true;
	    }
	  //赵辉  添加参数 绕过安全访问检测 end
        param.setAffair(affair);
        param.addExt("preArchiveId", preArchiveId);
        param.addExt("openFrom", request.getParameter("openFrom"));
        param.addExt("docResId", request.getParameter("docResId"));
        param.addExt("baseObjectId", request.getParameter("baseObjectId"));
        param.addExt("baseApp", request.getParameter("baseApp"));
        param.addExt("fromEditor", request.getParameter("fromEditor"));
        param.addExt("eventId", request.getParameter("eventId"));
        param.addExt("docId", request.getParameter("docId"));
        param.addExt("relativeProcessId", request.getParameter("relativeProcessId"));
        param.addExt("processId", request.getParameter("processId"));
        param.addExt("taskId", request.getParameter("taskId"));
        
        log.info("安全校验入口参数打印日志：openFrom="+request.getParameter("openFrom")
        +",docResId="+request.getParameter("docResId")+",baseObjectId="+request.getParameter("baseObjectId")
        +",docId="+request.getParameter("docId")+",relativeProcessId="+request.getParameter("relativeProcessId")
        +",processId="+request.getParameter("processId")+",taskId="+request.getParameter("taskId"));
        
        return isLicit(param, request, response, responseMsg);
	}
	
	
	/**
	 * 权限校验
	 * 
	 * @param param
	 *
	 * @Since A8-V5 6.1
	 * @Author      : xuqw
	 * @Date        : 2017年2月15日下午9:45:53
	 *
	 */
	public static boolean isLicit(SecurityCheckParam param){
	    return isLicit(param, null, null, false);
	}
	
	/**
	 * 重构  {@link #isLicit(HttpServletRequest, HttpServletResponse, ApplicationCategoryEnum, User, Long, CtpAffair, Long, boolean)}
	 * 
	 * @param appEnum
	 * @param user
	 * @param objectId
	 * @param affair
	 * @param preArchiveId
	 * @param responseMsg 是否推送消息
	 * @return
	 *
	 * @Since A8-V5 6.1
	 * @Author      : xuqw
	 * @Date        : 2017年2月15日下午8:58:20
	 *
	 */
	private static boolean isLicit(SecurityCheckParam param, HttpServletRequest request, HttpServletResponse response, boolean responseMsg){
	    
        if(!inited){
            init();
        }
        
        ApplicationCategoryEnum appEnum = param.getAppEnum();
        User user = param.getUser();
        CtpAffair affair = param.getAffair();
        Long objectId = param.getObjectId();
        String openFrom = param.getExtStringValue("openFrom");
        
        SecurityControl control = SecurityCheck.securityControlMap.get(appEnum);
        if(control == null){
            log.error("未注册实现类的应用:" + appEnum);
            param.setCheckRet(false);
            return false;
        }
        
        //1、缓存中有，直接return
        String cacheKey = String.valueOf(objectId);
        if(appEnum!=ApplicationCategoryEnum.doc && !ColOpenFrom.F8Reprot.name().equals(openFrom) && AccessControlBean.getInstance().isAccess(appEnum, cacheKey, user.getId())){
            param.setCheckRet(true);
            log.info("权限校验通过1");
            return true;
        }
        //2、来自关联文档， 统一校验
        String docResIdStr = param.getExtStringValue("docResId");
        String preObjectIdStr = param.getExtStringValue("baseObjectId");
        
        if(Strings.isNotBlank(preObjectIdStr)){ 
            //检查是否是合法的关联文档，如果是，更新缓存校验前一协同权限， preObjectId 前一主题对象的id，用于关联文档的情况
            ApplicationCategoryEnum preAppEnum = ApplicationCategoryEnum.collaboration;
            String baseApp = param.getExtStringValue("baseApp");
            if(Strings.isNotBlank(baseApp) &&  Strings.isDigits(baseApp)){
                preAppEnum = ApplicationCategoryEnum.valueOf(Integer.parseInt(baseApp));
                if(preAppEnum == ApplicationCategoryEnum.edocRec || preAppEnum == ApplicationCategoryEnum.edocRegister
                        || preAppEnum == ApplicationCategoryEnum.edocSend || preAppEnum == ApplicationCategoryEnum.edocSign
                        || preAppEnum == ApplicationCategoryEnum.exchange || preAppEnum == ApplicationCategoryEnum.exSend
                        || preAppEnum == ApplicationCategoryEnum.exSign){
                    preAppEnum = ApplicationCategoryEnum.edoc;
                }
            }
            Long genesisId = objectId;
            if(Strings.isNotBlank(docResIdStr)){ //如果是从文档中心转入的，优先以文档id判断
                genesisId = Long.parseLong(docResIdStr);
            }
            else if(affair != null && (appEnum == ApplicationCategoryEnum.collaboration || appEnum == ApplicationCategoryEnum.edoc)){
                genesisId = affair.getId();
            }

            //TODO 权限控制后门，后续得想办法为正文编辑器关联插入附件数据
            String fromEditor = param.getExtStringValue("fromEditor");
            if("1".equals(fromEditor)){
                // 对于关联文档，来自编辑器，且引用自内部页面，跳过校验
                if(AccessControlBean.getInstance().isAccess(preAppEnum, preObjectIdStr, user.getId())){
                    AccessControlBean.getInstance().addAccessControl(appEnum, cacheKey, user.getId());
                    if(affair != null){
                        //协同关联文档，关联表单授权校验，OA-105860
                        AccessControlBean.getInstance().addAccessControl(appEnum, String.valueOf(affair.getObjectId()), user.getId());
                    }
                    log.info("权限校验通过2");
                    param.setCheckRet(true);
                    return true;
                }
            }           
            
            
            if(AccessControlBean.getInstance().isAccess(preAppEnum, preObjectIdStr, user.getId())){
                
                AccessControlBean.getInstance().addAccessControl(appEnum, cacheKey, user.getId());
                if(affair != null){
                    //协同关联文档，关联表单授权校验，OA-105860
                    AccessControlBean.getInstance().addAccessControl(appEnum, String.valueOf(affair.getObjectId()), user.getId());
                }
                param.setCheckRet(true);
                log.info("权限校验通过3");
                return true;   
                
            }else if(ApplicationCategoryEnum.form.equals(preAppEnum)
                    && AccessControlBean.getInstance().isAccess(ApplicationCategoryEnum.collaboration, preObjectIdStr, user.getId()) 
                    && theAttachmentManager().checkIsLicitGenesis(Long.parseLong(preObjectIdStr), genesisId)){
                AccessControlBean.getInstance().addAccessControl(appEnum, cacheKey, user.getId());
                if(affair != null){
                    //协同关联文档，关联表单授权校验，OA-105860
                    AccessControlBean.getInstance().addAccessControl(appEnum, String.valueOf(affair.getObjectId()), user.getId());
                }
                log.info("权限校验通过4");
                param.setCheckRet(true);
                return true;    
            }
            else{
                log.warn("非法的关联文档|" + user.getId() + "|" + objectId + "|" + preObjectIdStr);
            }
        }
        //从文档直接打开的其他关联应用，如归档协同，如果文档权限校验通过，则有权访问。
        else if(appEnum!=ApplicationCategoryEnum.doc&&Strings.isNotBlank(docResIdStr) && AccessControlBean.getInstance().isAccess(ApplicationCategoryEnum.doc, docResIdStr, user.getId())){
            AccessControlBean.getInstance().addAccessControl(appEnum, cacheKey, user.getId());
            param.setCheckRet(true);
            log.info("权限校验通过5");
            return true;
        }
        
        //3、各应用的访问权限检查
        
        boolean result = control.check(param);
        
        if(result){
            AccessControlBean.getInstance().addAccessControl(appEnum, cacheKey, user.getId());
            if(affair != null){
                //协同关联文档，关联表单授权校验，OA-105860
                AccessControlBean.getInstance().addAccessControl(appEnum, String.valueOf(affair.getObjectId()), user.getId());
            }
            log.info("权限校验通过6");
            param.setCheckRet(true);
            return true;
        }
        
        //记录非法访问日志
        String msg = printInbreakTrace(request, response, user, appEnum, responseMsg);    
        
        param.setCheckRet(false);
        param.setCheckMsg(msg);
        
        return false;
    }
	
	
	/**
	 * 安全防护，校验是否有权限查看主题
	 * 
	 * @param request
	 * @param response
	 * @param appEnum
	 *            应用枚举
	 * @param user
	 *            CurrentUser
	 * @param objectId
	 *            主题对象的id
	 * @param affair
	 *            用于协同和公文，其他应用传null
	 * @param preArchiveId
	 *            预归档Id，用于协同，其他应用传null
	 * @return
	 */
	public static boolean isLicit(HttpServletRequest request, HttpServletResponse response, 
	        ApplicationCategoryEnum appEnum, User user, Long objectId, CtpAffair affair, Long preArchiveId){
	    return isLicit(request, response, appEnum, user, objectId, affair, preArchiveId, true);
	}
	
	
	/**
	 * 记录非法访问日志
	 * 
	 * @param request
	 * @param user
	 * @param subject
	 * @return
	 */
	public static String printInbreakTrace(HttpServletRequest request,
			HttpServletResponse response, User user,
			ApplicationCategoryEnum appEnum) {
		return printInbreakTrace(request, response, user, appEnum, true);
	}
	
	
	/**
	 * 重构 {@link #printInbreakTrace(HttpServletRequest, HttpServletResponse, User, ApplicationCategoryEnum)}
	 * 
	 * @param request
	 * @param response
	 * @param user
	 * @param appEnum
	 * @param responseMsg 是否向前端推送消息
	 * @return
	 *
	 * @Since A8-V5 6.1
	 * @Author      : xuqw
	 * @Date        : 2017年2月15日下午9:37:39
	 *
	 */
	private static String printInbreakTrace(HttpServletRequest request,
            HttpServletResponse response, User user,
            ApplicationCategoryEnum appEnum, boolean responseMsg){
	    StringBuffer msg = new StringBuffer();
	    
	    String loginName = "";
	    String addr = "";
	    if(user != null){
	        loginName = user.getLoginName();
	        addr = user.getRemoteAddr();
	    }
        msg.append("用户[").append(loginName).append(", ").append(
                addr).append("]试图访问无权查看的主题:");
        
        if(request != null){
            if ("GET".equals(request.getMethod())) {
                msg.append(request.getQueryString());
            } else {
                Enumeration<String> e = request.getParameterNames();
                while (e.hasMoreElements()) {
                    String parName = (String) e.nextElement();
                    msg.append(parName + ":" + request.getParameter(parName) + "|");
                }
            }
        }
        log.warn(msg.toString());
        String alert = "您无权查看该主题!";
        
        if(responseMsg && user != null){
            boolean isM1 = user.isFromM1();
            if(!isM1 && response != null){
                showAlert(response, alert);
            }
        }
        return alert;
	}
	
	

	private static void showAlert(HttpServletResponse response, String msg) {
		try {
		    response.setContentType("text/html;charset=UTF-8");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('" + msg + "');");
			out.println("try{");
			out.println("if(window.parentDialogObj && window.parentDialogObj['dialogDealColl']){");
            out.println(" window.parentDialogObj['dialogDealColl'].close();");
            out.println("}else if(window.dialogArguments){"); //弹出
            out.println("  window.close();");
            out.println("}else{");
            out.println(" window.close();");
            out.println("}");
            out.print("}catch(e){}");
			out.println("</script>");
		} catch (IOException e1) {
			log.error("",e1);
		}
	}

	/*****************************************
	 * 其他应用访问控制辅助方法
	 **************************************** 
	 */

	/****
	 * 是否是流程的督办人
	 * 
	 * @param currentUserId
	 * @param objectId
	 *            summaryId
	 */
	public static boolean isSupervisor(Long currentUserId, Long objectId) {
	    // TODO
//		return theColSuperviseManager().isSupervisor(currentUserId, objectId);
	    return false;
	}

	/**
	 * 文档权限判断
	 * 
	 * @param archiveId
	 * @return
	 */
	public static boolean isDocCanAccess(Long archiveId) {
		if(!inited){
			init();
		}
	    SecurityControl control = SecurityCheck.securityControlMap.get(ApplicationCategoryEnum.doc);
        if(control == null){
            return false;
        }
        SecurityCheckParam params = new SecurityCheckParam(ApplicationCategoryEnum.doc, null, archiveId);
        control.check(params);
		return params.getCheckRet();
	}

	/**
	 * 是否有权限查看统计公文的详细信息 (公文统计的查看为不同的入口，暂且放在此类)<br>
	 * 只有部门收发员或单位收发员才具有此功能菜单
	 * 
	 * @param summary
	 * @param user
	 * @return
	 */
    // TODO        
/*  
	public static boolean isHasAuthorityToStatDetail(
			HttpServletRequest request, HttpServletResponse response,
			EdocSummary summary, User user) {
        return true;
	String accountIds = "";
		try {
			accountIds = EdocRoleHelper.getUserExchangeAccountIds();
		} catch (BusinessException e) {
			log.error("公文统计安全权限判断异常[checkHasAclToStatistics].", e);
		}
		String currentSummaryOrgAccountId = "";
		if (summary.getOrgAccountId() != null)
			currentSummaryOrgAccountId = Long.toString(summary
					.getOrgAccountId().longValue());
		if (accountIds.contains(currentSummaryOrgAccountId)) {
			AccessControlBean.getInstance().addAccessControl(
					ApplicationCategoryEnum.edoc,
					String.valueOf(summary.getId()), user.getId());
			return true;
		}
		String departmentIds = "";
		try {
			departmentIds = EdocRoleHelper.getUserExchangeDepartmentIds();
		} catch (BusinessException e) {
			log.error("公文统计安全权限判断异常[checkHasAclToStatistics].", e);
		}
		String summaryOrgDepartmentId = "";
		if (summary.getOrgDepartmentId() != null) {
			summaryOrgDepartmentId = Long.toString(summary.getOrgDepartmentId()
					.longValue());
		}
		if (departmentIds.contains(summaryOrgDepartmentId)) {
			AccessControlBean.getInstance().addAccessControl(
					ApplicationCategoryEnum.edoc,
					String.valueOf(summary.getId()), user.getId());
			return true;
		}
		printInbreakTrace(request, response, user, ApplicationCategoryEnum.edoc);
		return false;
	}*/

	/**
	 * 是否具有表单查询的权限
	 * 
	 * @param request
	 * @param response
	 * @param user
	 * @return
	 */
	public static boolean hasFormQueryPermission(HttpServletRequest request,
			HttpServletResponse response, User user, Long appId,
			String objectName, String summaryId) {
	       return true;
           // TODO
/*		boolean canAccess = false;
		try {
			canAccess = getIOperBase().checkAccess(user, appId, objectName, 1);
			if (!canAccess) { // 非查询 判断统计
				canAccess = getIOperBase().checkAccess(user, appId, objectName,
						2);
			}
		} catch (DataDefineException e) {
			log.error("访问控制校验DataDefineException:", e);
		} catch (BusinessException e) {
			log.error(e);
		}
		if (canAccess) {
			AccessControlBean.getInstance().addAccessControl(
					ApplicationCategoryEnum.collaboration, summaryId,
					user.getId());
			return true;
		}
		printInbreakTrace(request, response, user, ApplicationCategoryEnum.form);
		return false;*/
	}
}
