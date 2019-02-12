package com.seeyon.apps.custom.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.custom.po.FORMMAIN_2859;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.util.DBAgent;

public class CustomDaoImpl implements CustomDao{
	
	private static final Log logger = LogFactory.getLog(CustomDaoImpl.class);

	@Override
	public Map<String, Object> isSecretary() {
		Map<String, Object> map = new HashMap<String, Object>();
		User user = AppContext.getCurrentUser();
		map.put("flag", true);
		
		Map<String ,Object> params = new HashMap<String, Object>();
		String hql = " from FORMMAIN_2859 where FIELD0002 =:FIELD0002";
		params.put("FIELD0002", user.getId());
		List<FORMMAIN_2859> list = DBAgent.find(hql, params);
		
		for(FORMMAIN_2859 form:list){
			map.put("flag", false);
			map.put("leaderID", form.getField0001());
		}
		
    	/*Connection conn = null;
    	PreparedStatement ps = null;
    	ResultSet rs = null;
    	try {
    		DBService dbService = DBService.getInstence();
     		conn = dbService.connectDatabase();
     		ps = conn.prepareStatement("select field0001 from formmain_2859 where field0002 = '"+user.getId()+"'");
     		rs = ps.executeQuery();
     		while (rs.next()) { 
     			map.put("flag", false);
     			map.put("leaderID", rs.getLong(1));
            }
		} catch (Exception e) {
			logger.error("获取数据异常",e);
		}finally {
			try {
				rs.close();
			} catch (SQLException e) {
				logger.error("连接关闭异常",e);
			}
			try {
				ps.close();
			} catch (SQLException e) {
				logger.error("连接关闭异常",e);
			}
			try {
	            conn.close();
			} catch (SQLException e) {
				logger.error("连接关闭异常",e);
			}
		}*/
		return map;
	}

	@Override
	public List<Long> queryallSecretary() {
		List<Long> lList = new ArrayList<Long>();
		String hql = " from FORMMAIN_2859";
		List<FORMMAIN_2859> list = DBAgent.find(hql);
		for(FORMMAIN_2859 form:list){
			lList.add(Long.valueOf(form.getField0002()));
		}
		return lList;
	}
  
}
