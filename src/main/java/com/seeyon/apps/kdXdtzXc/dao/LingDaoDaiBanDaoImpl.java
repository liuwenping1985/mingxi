package com.seeyon.apps.kdXdtzXc.dao;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.apps.kdXdtzXc.util.PropertiesUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.dao.AbstractHibernateDao;
import com.seeyon.v3x.common.web.login.CurrentUser;

public class LingDaoDaiBanDaoImpl extends AbstractHibernateDao implements  LingDaoDaiBanDao{
	private static final Log LOGGER = LogFactory.getLog(LingDaoDaiBanDaoImpl.class);
	public List<Map<String, Object>> listCtpAffair() {
		JdbcTemplate kimdeJdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
		User user=  CurrentUser.get();
		Long currentUserId = user.getId();
		String lingdaoDaiban_sql = (String)PropertiesUtils.getInstance().get("lingdaoDaiban_sql");
		List<Map<String, Object>> lingdaoIdList = kimdeJdbcTemplate.queryForList(lingdaoDaiban_sql, new Object[]{currentUserId});
		if(lingdaoIdList == null || lingdaoIdList.size() == 0)
			return null;
		String lindaoIds = "";
		for(int i=0; i<lingdaoIdList.size(); i++){
			Map<String, Object> oneData = lingdaoIdList.get(i);
			String LINGDAOID = (String) oneData.get("field0001");
			lindaoIds += LINGDAOID;
			if(i < lingdaoIdList.size() - 1)
				lindaoIds += ",";
		}
		String listLingDaoDaiBan_sql =(String)PropertiesUtils.getInstance().get("ListLingDaoDaiBan_sql");
		listLingDaoDaiBan_sql=listLingDaoDaiBan_sql.replace("${memberids}", lindaoIds);
		LOGGER.info("############@@@@@@@@@@@@"+listLingDaoDaiBan_sql);
		List<Map<String, Object>> dataList = kimdeJdbcTemplate.queryForList(listLingDaoDaiBan_sql);
		LOGGER.info("############@@@@@@@@@@@@"+dataList);
		return dataList;
	}
}
