package com.seeyon.apps.cindaedoc.manager;

import java.sql.Connection;
import java.util.HashMap;
import java.util.List;

import com.seeyon.apps.cindaedoc.dao.CindaedocDao;
import com.seeyon.apps.cindaedoc.po.EdocDetailMsgid;
import com.seeyon.apps.cindaedoc.po.EdocFileInfo;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.template.CtpTemplate;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.common.template.manager.TemplateManager;
import com.seeyon.ctp.form.modules.serialNumber.SerialNumberManager;
import com.seeyon.ctp.organization.bo.MemberPost;
import com.seeyon.ctp.organization.dao.OrgHelper;

public class CindaedocManagerImpl implements CindaedocManager {
	
	private CindaedocDao cindaedocDao;
	private static String[] cinda_number = AppContext.getSystemProperty("cindaedoc.cinda_number").split(",");
	private static HashMap<String, String> hmDepts = new HashMap<String, String>();
	{
		for (String number : cinda_number) {
			String[] str = number.split("\\|");
			hmDepts.put(str[0], str[1]);
		}
	}
	
	private static String[] cinda_fengongsi = AppContext.getSystemProperty("cindaedoc.cinda_fengongsi").split(",");
	private static HashMap<String, HashMap<String, String>> hmFengongsis = new HashMap<String, HashMap<String, String>>();
	{
		//try{
		for (String number : cinda_fengongsi) {
			String[] str = number.split("\\|");
			HashMap<String, String> tmp = new HashMap<String, String>();
			tmp.put(str[0], str[1]); // 分公司ID ：分公司名称
			tmp.put(str[5], str[4]); // 'serialNumber'：签报流水号ID
			tmp.put(str[7], str[6]); // 'serialNumberFieldId'：编号字段ID
			tmp.put(str[9], str[8]); // 'serialNumberNodeName'：编号节点名称
			hmFengongsis.put(str[2], tmp);
		}
		//}catch (Exception e) {
		//	System.out.print(e.getMessage());
		//}
	}
	
	private SerialNumberManager serialNumberManager;
	private TemplateManager templateManager;
	private AffairManager affairManager;
	
	public void setAffairManager(AffairManager affairManager) {
		this.affairManager = affairManager;
	}

	public void setTemplateManager(TemplateManager templateManager) {
		this.templateManager = templateManager;
	}

	public void setSerialNumberManager(SerialNumberManager serialNumberManager) {
		this.serialNumberManager = serialNumberManager;
	}

	public EdocFileInfo getEdocFileInfoByEdocId(Long edocId) {
		return cindaedocDao.getEdocFileInfoByEdocId(edocId);
	}

	public void setCindaedocDao(CindaedocDao cindaedocDao) {
		this.cindaedocDao = cindaedocDao;
	}
	
	public void saveObject(Object entity) {
		cindaedocDao.saveObject(entity);
	}
	
	public List<String[]> getDataBySql(String sql, Connection conn, int length, Object[] param) {
		return cindaedocDao.getDataBySql(sql, conn, length, param);
	}
	
	public void updateBySql(String sql, Connection connOA, Object[] param) {
		cindaedocDao.updateBySql(sql, connOA, param);
	}
	
	public String getCodeByDeptName(String deptName, boolean isread) {
		String flowNumber = hmDepts.get(deptName);
		String ret = "";
		if (flowNumber != null) {
			try {
				if (isread) {
					ret = serialNumberManager.getSerialNumberValue(flowNumber, isread);
				} else {
					ret = serialNumberManager.getSerialNumberValue(flowNumber);
				}
			} catch (Exception e) {
				ret = "";
			}
		}
		return ret;
	}
	
	public boolean isQianbao(String templateId, String affairId) {
		try {
			CtpTemplate ct = templateManager.getCtpTemplate(Long.valueOf(templateId));
			String cinda_qianbao = AppContext.getSystemProperty("cindaedoc.cinda_qianbao");
			if (cinda_qianbao.equals(ct.getTempleteNumber())) {
				CtpAffair ca = affairManager.get(Long.valueOf(affairId));
				if (AppContext.getSystemProperty("cindaedoc.cinda_bianhao").equals(ca.getNodePolicy())) {
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		} catch (Exception e) {
		}
		return false;
	}
	
	public String getTeamName(String teamIds) {
		String[] temp = teamIds.split("\\|");
		return Functions.getTeamName(Long.valueOf(temp[1]));
	}
	
	public EdocDetailMsgid getMsgIdByDetailId(Long detailId) {
		return cindaedocDao.getMsgIdByDetailId(detailId);
	}
	
	public EdocDetailMsgid getDetailIdByMsgId(String msgId) {
		return cindaedocDao.getDetailIdByMsgId(msgId);
	}
	
	// SZP
	public String getCodeByserialNumberName(String serialNumberName, boolean isread){
		String ret = "";
		if (serialNumberName != null && !serialNumberName.equals("")) {
			try {
				if (isread) {
					ret = serialNumberManager.getSerialNumberValue(serialNumberName, isread);
				} else {
					ret = serialNumberManager.getSerialNumberValue(serialNumberName);
				}
			} catch (Exception e) {
				ret = "";
			}
		}
		return ret;
	}
	
	public boolean isFarenshouquangang(String strPostId){
		try{
			User user  = AppContext.getCurrentUser();
			List<MemberPost> list = OrgHelper.getOrgManager().getMemberPosts(user.getLoginAccount() ,user.getId());
			for (MemberPost memberPost : list) {
				if (memberPost != null && memberPost.getPostId() != null && 
						memberPost.getPostId().toString().equals(strPostId)){
					return true;
				}
			}
		} catch (BusinessException e) {

		}
		
		return false;
	}
	
	public boolean isFengonsiQianbao(String formId, String affairId) {
		try {
			if (hmFengongsis.containsKey(formId)) {
				CtpAffair ca = affairManager.get(Long.valueOf(affairId));
				if (hmFengongsis.get(formId).get("serialNumberNodeName").equals(ca.getNodePolicy())) {
					return true;
				} 
			}
		} catch (Exception e) {
		}
		return false;
	}
	
	// KEY 可以是     分公司ID值 、'serialNumber'、'serialNumberFieldId'、'serialNumberNodeName'
	public String getFengongsiData(String formId, String key){
		String ret = "";
		try {
			if (hmFengongsis.containsKey(formId)) {
				if (hmFengongsis.get(formId).containsKey(key)) {
					ret = hmFengongsis.get(formId).get(key);
				} 
			} 
		} catch (Exception e) {
		}
		return ret.toString();
	}
	
	public String getCodeByTemplateId(String formId, boolean isread) {
		
		String ret = "";
		try {
			if (hmFengongsis.containsKey(formId)) {
				String flowNumber = hmFengongsis.get(formId).get("serialNumber");
				if (flowNumber != null) {
					if (isread) {
						ret = serialNumberManager.getSerialNumberValue(flowNumber, isread);
					} else {
						ret = serialNumberManager.getSerialNumberValue(flowNumber);
					}
				}
			}
		} catch (Exception e) {
			ret = "";
		}

		return ret;
	}
}