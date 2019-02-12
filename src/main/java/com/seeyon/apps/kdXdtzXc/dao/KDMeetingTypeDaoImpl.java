package com.seeyon.apps.kdXdtzXc.dao;

import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.ctp.common.AppContext;

public class KDMeetingTypeDaoImpl  implements KDMeetingTypeDao{

	@Override
	public List<Map<String, Object>> getAllMeetingType() {
		JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
		String sql ="SELECT m.name FROM  meeting_type m where m.STATE=1 AND (m.SORT_ID =1 OR m.SORT_ID=2 or m.SORT_ID=100) GROUP BY  m.name";
		List<Map<String, Object>> queryMeetingType = jdbcTemplate.queryForList(sql);
		System.out.println("dao ----"+queryMeetingType);
		return queryMeetingType;
	}

}
