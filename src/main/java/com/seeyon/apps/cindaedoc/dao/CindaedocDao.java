package com.seeyon.apps.cindaedoc.dao;

import java.sql.Connection;
import java.util.List;

import com.seeyon.apps.cindaedoc.po.EdocDetailMsgid;
import com.seeyon.apps.cindaedoc.po.EdocFileInfo;

public interface CindaedocDao {
	
	public EdocFileInfo getEdocFileInfoByEdocId(Long edocId);
	
	public void saveObject(Object entity);
	
	public List<String[]> getDataBySql(String sql, Connection conn, int length, Object[] param);
	
	public void updateBySql(String sql, Connection connOA, Object[] param);
	
	public EdocDetailMsgid getMsgIdByDetailId(Long detailId);
	
	public EdocDetailMsgid getDetailIdByMsgId(String msgId);
}