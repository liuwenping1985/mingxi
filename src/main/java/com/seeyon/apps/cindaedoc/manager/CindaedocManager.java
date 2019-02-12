package com.seeyon.apps.cindaedoc.manager;

import java.sql.Connection;
import java.util.List;

import com.seeyon.apps.cindaedoc.po.EdocDetailMsgid;
import com.seeyon.apps.cindaedoc.po.EdocFileInfo;

public interface CindaedocManager {
	
	public EdocFileInfo getEdocFileInfoByEdocId(Long edocId);
	
	public void saveObject(Object entity);
	
	public List<String[]> getDataBySql(String sql, Connection conn, int length, Object[] param);
	
	public void updateBySql(String sql, Connection connOA, Object[] param);
	
	public String getCodeByDeptName(String deptName, boolean isread);

	public boolean isQianbao(String templateId, String affairId);
	
	public String getTeamName(String teamIds);
	
	public EdocDetailMsgid getMsgIdByDetailId(Long detailId);
	
	public EdocDetailMsgid getDetailIdByMsgId(String msgId);
	
	// SZP
	public String getCodeByserialNumberName(String serialNumberName, boolean isread);
	
	public boolean isFarenshouquangang(String strPostId);
	
	public boolean isFengonsiQianbao(String formId, String affairId);
	
	public String getFengongsiData(String formId, String key);
	
	public String getCodeByTemplateId(String formId, boolean isread);
	
}