package com.seeyon.apps.scheduletask.util;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.scheduletask.ScheduleTaskJob;
import com.seeyon.apps.scheduletask.manager.ScheduleTaskManager;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.organization.bo.OrganizationMessage;
import com.seeyon.ctp.organization.bo.OrganizationMessage.OrgMessage;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.principal.NoSuchPrincipalException;
import com.seeyon.ctp.organization.principal.PrincipalManager;
public class SDTaskUtil {
    private static final Log log = LogFactory.getLog(SDTaskUtil.class);
    private static ScheduleTaskManager scheduleTaskManager = getScheduleTaskManager();
    public static ScheduleTaskManager getScheduleTaskManager(){
    	if(scheduleTaskManager==null){
    		scheduleTaskManager = (ScheduleTaskManager) AppContext.getBean("scheduleTaskManager");
    	}
		return scheduleTaskManager;
    }
    public static ScheduleTaskJob getScheduleTask(String beanName){
    	return scheduleTaskManager.getScheduleTask(beanName);
    }
    public static void saveOrUpdataConfig(ScheduleTaskJob task){
    	scheduleTaskManager.saveOrUpdataConfig(task);
    }
    /**
	 * 处理组织模型接口抛出的业务异常编码，保证不在核心Manager抛出业务异常
	 * TODO 异常显示的国际化
	 * @param m
	 * @throws BusinessException
	 */
	public static String showBusinessExceptionMessage(OrganizationMessage m) {
		List<OrgMessage> mErrorList = m.getErrorMsgs();
		String msg = ""; 
		if(!(mErrorList.size() > 0)) {
			return "";
		}
    	for (OrgMessage o : mErrorList) {
    		
			switch (o.getCode().ordinal()) {
			case 1:
				msg = (ResourceUtil.getString("MessageStatus.ACCOUNT_REPEAT_NAME"));
				break;
			case 2:
				msg = (ResourceUtil.getString("MessageStatus.ACCOUNT_REPEAT_SHORT_NAME"));
				break;
			case 3:
				msg = (ResourceUtil.getString("MessageStatus.ACCOUNT_REPEAT_CODE"));
				break;
			case 4:
				msg = (ResourceUtil.getString("MessageStatus.ACCOUNT_REPEAT_ADMIN_NAME"));
				break;
			case 5:
				msg = (ResourceUtil.getString("MessageStatus.ACCOUNT_EXIST_ENTITY"));
				break;
			case 6:
				msg = (ResourceUtil.getString("MessageStatus.ACCOUNT_EXIST_DEPARTMENT_ENABLE"));
				break;
			case 7:
				msg = (ResourceUtil.getString("MessageStatus.ACCOUNT_EXIST_ROLE_ENABLE"));
				break;
			case 8:
				msg = (ResourceUtil.getString("MessageStatus.ACCOUNT_EXIST_POST_ENABLE"));
				break;
			case 9:
				msg = (ResourceUtil.getString("MessageStatus.ACCOUNT_EXIST_LEVEL_ENABLE"));
				break;
			case 10:
				msg = (ResourceUtil.getString("MessageStatus.ACCOUNT_EXIST_CHILDACCOUNT"));
				break;
			case 11:
				msg = (ResourceUtil.getString("MessageStatus.ACCOUNT_EXIST_TEAM_ENABLE"));
			case 12:
				msg = (ResourceUtil.getString("MessageStatus.ACCOUNT_EXIST_MEMBER_ENABLE", o.getEnt().getName()));
				break;
			case 13:
				msg = (ResourceUtil.getString("MessageStatus.DEPARTMENT_REPEAT_NAME", o.getEnt().getName()));
				break;
			case 14:
				msg = (ResourceUtil.getString("MessageStatus.DEPARTMENT_EXIST_MEMBER", o.getEnt().getName()));
				break;
			case 15:
				msg = (ResourceUtil.getString("MessageStatus.DEPARTMENT_EXIST_TEAM", o.getEnt().getName()));
				break;
			case 16:
				msg = (ResourceUtil.getString("MessageStatus.DEPARTMENT_PARENTID_NULL"));
				break;
			case 17:
				msg = (ResourceUtil.getString("MessageStatus.DEPARTMENT_PARENTDEPT_DISABLED"));
				break;
			case 18:
				msg = (ResourceUtil.getString("MessageStatus.DEPARTMENT_PARENTDEPT_SAME"));
				break;
			case 19:
				msg = (ResourceUtil.getString("MessageStatus.DEPARTMENT_PARENTDEPT_ISCHILD"));
				break;
			case 20:
				msg = (ResourceUtil.getString("MessageStatus.POST_REPEAT_NAME", o.getEnt().getName()));
				break;
			case 21:
				msg = (ResourceUtil.getString("MessageStatus.POST_EXIST_MEMBER"));
				break;
			case 22:
				msg = (ResourceUtil.getString("MessageStatus.LEVEL_EXIST_MEMBER", o.getEnt().getName()));
				break;
			case 23:
				msg = (ResourceUtil.getString("MessageStatus.LEVEL_EXIST_MAPPING", o.getEnt().getName()));
				break;
			case 24:
				msg = (ResourceUtil.getString("MessageStatus.MEMBER_DEPARTMENT_DISABLED"));
				break;
			case 25:
				msg = (ResourceUtil.getString("MessageStatus.MEMBER_POST_DISABLED"));
				break;
			case 26:
				msg = (ResourceUtil.getString("MessageStatus.MEMBER_LEVEL_DISABLED"));
				break;
			case 27:
				msg = (ResourceUtil.getString("MessageStatus.MEMBER_REPEAT_POST"));
				break;
			case 28:
				msg = (ResourceUtil.getString("MessageStatus.MEMBER_EXIST_SIGNET"));
				break;
			case 29:
				msg = (ResourceUtil.getString("MessageStatus.MEMBER_NOT_EXIST"));
				break;
			case 30:
                try {
                	PrincipalManager principalManager = (PrincipalManager) AppContext.getBean("principalManager");
                    V3xOrgMember dupLoginNameMember = OrgHelper.getOrgManager().getMemberById(principalManager.getMemberIdByLoginName(((V3xOrgMember) o.getEnt()).getV3xOrgPrincipal().getLoginName()));
                    String dupAccountName = Functions.showOrgAccountName(dupLoginNameMember.getOrgAccountId());
                    msg = (ResourceUtil.getString("MessageStatus.PRINCIPAL_REPEAT_NAME", dupAccountName, dupLoginNameMember.getName()));
                    break;
                }catch (BusinessException e) {
                    log.error("根据人员登录名获取人员id异常"+e.getLocalizedMessage(), e);
                    msg = (ResourceUtil.getString("MessageStatus.PRINCIPAL_REPEAT_NAME"));
                    break;
				}catch (NoSuchPrincipalException e) {
                    log.error("根据人员登录名获取人员id异常"+e.getLocalizedMessage(), e);
                    msg = (ResourceUtil.getString("MessageStatus.PRINCIPAL_REPEAT_NAME"));
                    break;
                }
			case 31:
				msg = (ResourceUtil.getString("MessageStatus.LEVEL_EXIST_MEMBER"));
				break;
			case 32:
				msg = (ResourceUtil.getString("MessageStatus.REPEAT_PATH"));
				break;
			case 33:
				msg = (ResourceUtil.getString("MessageStatus.PRINCIPAL_NOT_EXIST"));
				break;
			case 34:
				msg = (ResourceUtil.getString("MessageStatus.ROLE_NOT_EXIST"));
				break;
			case 35:
				msg = (ResourceUtil.getString("MessageStatus.POST_EXIST_BENCHMARK"));
				break;
			case 36:
				msg = (ResourceUtil.getString("MessageStatus.OUT_PER_NUM"));	
				break;
			case 37:
				msg = (ResourceUtil.getString("MessageStatus.LEVEL_REPEAT_NAME"));
				break;
			case 38:
                msg = (ResourceUtil.getString("MessageStatus.ACCOUNT_EXIST_MEMBER_ENABLE", o.getEnt().getName()));
                break;
			case 39:
                msg = (ResourceUtil.getString("MessageStatus.ACCOUNT_EXIST_DEPARTMENT_ENABLE"));
                break;
			case 40:
                msg = (ResourceUtil.getString("MessageStatus.ACCOUNT_EXIST_ROLE_ENABLE"));
                break;
			case 41:
                msg = (ResourceUtil.getString("MessageStatus.ACCOUNT_EXIST_POST_ENABLE"));
                break;
			case 42:
                msg = (ResourceUtil.getString("MessageStatus.ACCOUNT_EXIST_LEVEL_ENABLE"));
                break;
			case 43:
                msg = (ResourceUtil.getString("MessageStatus.ACCOUNT_EXIST_CHILDACCOUNT_ENABLE"));
                break;
			case 44:
                msg = (ResourceUtil.getString("MessageStatus.ACCOUNT_EXIST_TEAM_ENABLE"));
                break;
			case 45:
                msg = (ResourceUtil.getString("MessageStatus.MEMBER_REPEAT_CODE"));
                break;
			case 46:
                msg = (ResourceUtil.getString("MessageStatus.DEPARTMENT_REPEAT_CODE"));
                break;
			case 47:
                msg = (ResourceUtil.getString("MessageStatus.MEMBER_CANNOT_DELETE", o.getEnt().getName()));
                break;
			case 48:
                msg = (ResourceUtil.getString("MessageStatus.ACCOUNT_CUSTOM_LOGIN_URL_DUPLICATED"));
                break;
			case 49:
                msg = (ResourceUtil.getString("MessageStatus.DEPARTMENT_EXIST_DEPARTMENT_ENABLE"));
                break;
			default:
				msg = (ResourceUtil.getString("MessageStatus.ERROR"));
			}
		}
		return msg;
    }
}

