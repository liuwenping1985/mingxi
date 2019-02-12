package com.seeyon.apps.kdXdtzXc.manager;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;

public class XieChenXinXiQueRenManagerImpl implements XieChenXinXiQueRenManager {

	JdbcTemplate kimdeJdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");

	/**
	 * 功能 ：携程 “人事对接 ”所需数据 查询org_member表中的人员信息与org_principal表中的登录名称
	 * test账号测试
	 * @return
	 * @throws BusinessException
	 */
	@Override
	public List<Map<String, Object>> getDataByMemberWhole(String AccountId) throws BusinessException {
		String sql = "SELECT t.id , t1.LOGIN_NAME ,t.IS_DGJ, t.NAME , t.ORG_ACCOUNT_ID , t.ORG_DEPARTMENT_ID , t.EXT_ATTR_2 , t.IS_DELETED ";
		sql += " FROM org_member t LEFT JOIN org_principal t1 ";
		sql += " ON t.ID = t1.MEMBER_ID ";
		sql += " where 1 = 1 AND t.IS_DELETED = '0' "; //过滤掉被删除数据
		sql += " and t.IS_ENABLE = '1' ";			   //过滤掉被禁用数据
	    sql += " AND t.ORG_ACCOUNT_ID = '"+AccountId+"'";//where条件  后续根据条件进行明确修改 
	   // sql += " AND t.ORG_ACCOUNT_ID = '"+AccountId+"' and t.id IN (3275605228333517015,6669189526313846580)";//where条件  后续根据条件进行明确修改 
		List<Map<String, Object>> MemberList = kimdeJdbcTemplate.queryForList(sql);
		return MemberList;
	}

	@Override
	public List<Map<String, Object>> getDataByMemberTime(String AccountId) throws BusinessException {
		try {
			String sql = "SELECT t.id , t1.LOGIN_NAME , t.NAME , t.ORG_ACCOUNT_ID , t.ORG_DEPARTMENT_ID , t.EXT_ATTR_2 , t.IS_DELETED ";
			sql += " FROM org_member t LEFT JOIN org_principal t1 ";
			sql += " ON t.ID = t1.MEMBER_ID ";
			sql += " where 1 = 1 AND t.IS_DELETED = '0' AND t.ORG_ACCOUNT_ID ='"+AccountId+"'"; //过滤掉被删除数据
			sql += " and t.IS_ENABLE = '1' ";			   //过滤掉被禁用数据    
			sql += " AND TO_CHAR(t.CREATE_TIME,'yyyy-MM-dd') = TO_CHAR(SYSDATE,'yyyy-MM-dd') ";//查询创建时间是当天的数据
			sql += " OR TO_CHAR(t.UPDATE_TIME,'yyyy-MM-dd') = TO_CHAR(SYSDATE,'yyyy-MM-dd') AND t.IS_DELETED = '0' AND t.IS_ENABLE = '1' "; //查询修改时间是当天的数据
			List<Map<String, Object>> MemberList = kimdeJdbcTemplate.queryForList(sql);
			return MemberList;
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

}
