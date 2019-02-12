package com.seeyon.v3x.services.plugin.synchorg;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.syncorg.czdomain.CzAccount;
import com.seeyon.apps.syncorg.czdomain.CzDepartment;
import com.seeyon.apps.syncorg.czdomain.CzLevel;
import com.seeyon.apps.syncorg.czdomain.CzMember;
import com.seeyon.apps.syncorg.czdomain.CzPost;
import com.seeyon.apps.syncorg.czdomain.CzReturn;
import com.seeyon.apps.syncorg.enums.ActionTypeEnum;
import com.seeyon.apps.syncorg.enums.ObjectTypeEnum;
import com.seeyon.apps.syncorg.exception.CzOrgException;
import com.seeyon.apps.syncorg.log.manager.SyncLogManager;
import com.seeyon.apps.syncorg.manager.CzOrgManager;
import com.seeyon.apps.syncorg.po.log.SyncLog;
import com.seeyon.apps.syncorg.util.CzOrgCheckUtil;
import com.seeyon.apps.syncorg.util.CzXmlUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.services.ErrorServiceMessage;
import com.seeyon.ctp.services.ServiceTokenCheck;
import com.seeyon.ctp.util.Strings;
import com.seeyon.oainterface.common.OAInterfaceException;


public class SyncOrgServicesImpl implements SyncOrgServices {

	private static Log log = LogFactory.getLog(SyncOrgServicesImpl.class);
	
	private static CzOrgManager czOrgManager = (CzOrgManager) AppContext.getBean("czOrgManager");
	private static SyncLogManager syncLogManager = (SyncLogManager) AppContext.getBean("syncLogManager");
	@Override
	public String syncOrg(String token, String objectType, String action, String xmlString) {
		log.info("第三方调用了接口: syncOrg, 参数： token =" + token+"，objectType =" + objectType+"，action=" + action);
		log.info("第三方调用了接口: syncOrg, 参数： xmlString = " + xmlString);
		
		/*xmlString = this.removeNeedlessSpaces(xmlString);
		CzReturn czReturn;
		// 检查 token 的有效性
		//验证token的有效性
		try {
            ServiceTokenCheck.active(token);
        } catch (Exception e) {
        	if(e instanceof OAInterfaceException){
        		log.warn("token验证失败："+e.getMessage());
        		return CzXmlUtil.toXml(new CzReturn(false, "100001"));
        	}
        }

		// token 检查完毕
		
		// 检验输入数据的正确性
		try {
			czReturn = checkParameters(token, objectType, action, xmlString);
		} catch (CzOrgException e) {
			czReturn = new CzReturn(false, e.getErrorCode(), e.getExtMessage());
			String xml = CzXmlUtil.toXml(czReturn);
			log.info("返回接口接口信息xml="+xml);
			return xml;
		}
		if("false".equals(czReturn.getSuccess())){
			String xml = CzXmlUtil.toXml(czReturn);
			log.info("返回接口接口信息xml="+xml);
			return xml;
		}
		
		// 通过了数据格式检查

		
		// 只有数据进入了处理环节， 才记录日志信息
		czReturn = processData(token, objectType, action, xmlString);
		String xml = CzXmlUtil.toXml(czReturn);
		log.info("返回接口接口信息xml="+xml);
		return xml;*/

		return "";
	}
	
	private CzReturn checkParameters(String token, String objectType, String action, String xmlString) throws CzOrgException{
		// 检查同步的对象是否正确
		ObjectTypeEnum objectTypeEnum;
		ActionTypeEnum actionTypeEnum;
		
		try{
			objectTypeEnum = Enum.valueOf(ObjectTypeEnum.class, objectType);			
		}catch(Exception e){
			return new CzReturn(false, "200002", objectType);
		}
		// 同步操作检查
		try{
			actionTypeEnum = Enum.valueOf(ActionTypeEnum.class, action);			
		}catch(Exception e){
			return new CzReturn(false, "300002", action);
		}
		
		// 检验 xml 格式是否正确
		switch(objectTypeEnum){
		case Account:
			CzAccount czAccount = null;
			try{
				czAccount = CzXmlUtil.toBean(xmlString, CzAccount.class);

			}catch(Exception e){
				return new CzReturn(false, "400001", xmlString , e.getMessage());
			}
			CzOrgCheckUtil.checkCode(czAccount.getCode());
			break;
		case Department:
			CzDepartment czDepartment = null;
			try{
				czDepartment = CzXmlUtil.toBean(xmlString, CzDepartment.class);
				// 部门的编码不能为空
				CzOrgCheckUtil.checkCode(czDepartment.getDepartmentCode());
			}catch(Exception e){
				return new CzReturn(false, "400002", xmlString ,  e.getMessage());
			}
			CzOrgCheckUtil.checkCode(czDepartment.getAccountCode());
			break;
		case Member:
			CzMember czMember = null;
			try{
				czMember = CzXmlUtil.toBean(xmlString, CzMember.class);
				// 人员的编码不能为空
				CzOrgCheckUtil.checkCode(czMember.getCode());
			}catch(Exception e){
				return new CzReturn(false, "400004", xmlString , e.getMessage());
			}
			CzOrgCheckUtil.checkCode(czMember.getAccountCode());
			break;
		case Post:
			CzPost czPost = null;
			try{
				czPost = CzXmlUtil.toBean(xmlString, CzPost.class);
				// 岗位的编码不能为空
				CzOrgCheckUtil.checkCode(czPost.getCode());
			}catch(Exception e){
				return new CzReturn(false, "400005",  xmlString , e.getMessage());
			}
			CzOrgCheckUtil.checkCode(czPost.getAccountCode());
			break;
		case Level:
			CzLevel czLevel = null;
			try{
				czLevel = CzXmlUtil.toBean(xmlString, CzLevel.class);
				// 职务级别的编码不能为空
				if(Strings.isBlank(czLevel.getCode())){
					return new CzReturn(false, "900001", xmlString);
				}
			}catch(Exception e){
				return new CzReturn(false, "400003",  xmlString , e.getMessage());
			}
			CzOrgCheckUtil.checkAccountCode(czLevel.getAccountCode());
			break;
		}

		return new CzReturn(true, "");
	}
	private String removeNeedlessSpaces(String xml){

		xml = xml.replaceAll("[\\s&&[^\r\n]]*(?:[\r\n][\\s&&[^\r\n]]*)+", "");
		return xml;
	}
	private CzReturn processData(String token, String objectType, String action, String xmlString) {
		ObjectTypeEnum objectTypeEnum = Enum.valueOf(ObjectTypeEnum.class, objectType);
		ActionTypeEnum actionTypeEnum = Enum.valueOf(ActionTypeEnum.class, action);
		// 程序执行到这里的时候, 应该是已经通过了数据格式有效性的检查， 可以记录数据库了
		SyncLog syncLog = new SyncLog(objectTypeEnum, actionTypeEnum, xmlString);
		syncLogManager.insert(syncLog);
		return czOrgManager.processData(objectTypeEnum, actionTypeEnum, xmlString, syncLog);
	}

}
