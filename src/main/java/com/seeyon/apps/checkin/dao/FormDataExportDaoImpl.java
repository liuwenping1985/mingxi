package com.seeyon.apps.checkin.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import org.hibernate.Hibernate;
import org.hibernate.SQLQuery;
import org.hibernate.Session;

import com.seeyon.ctp.common.dao.BaseHibernateDao;

public class FormDataExportDaoImpl  extends BaseHibernateDao implements FormDataExportDao {
	Connection conn = null;

	PreparedStatement ps = null;

	ResultSet rs = null;

	
	/**
	 * 判断是否为配置文件对应的请假单,且为审批通过，同意的请假单
	 * @param summary_id
	 * @param templateCode 模板编号
	 */
	public boolean isSyncFormData(Long summary_id, String templateCode) {
		List<Integer> lo = null;
		Session session = super.getSession();
		int cnt = 0;
		try{
			// 根据模板ID 与summary_id 查询
			// state为2的请假单
			String sql = "select count(1) as cnt from col_summary a, v3x_templete b, form_data_state c where a.templete_id = b.id and a.id=c.summary_id and c.state='2' and b.templete_number=:templateCode and a.id=:summary_id";
			SQLQuery query = session.createSQLQuery(sql);
			query.addScalar("cnt", Hibernate.INTEGER);
			query.setParameter("templateCode", templateCode);
			query.setParameter("summary_id", summary_id);
			lo = query.list();
			if(lo.get(0) != null) {
				cnt = lo.get(0);
				if(cnt > 0) {
					return true;
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return false;
	}
	
	/**
	 * 根据summary_id获取用户编码
	 * @param summary_id
	 */
	public String getUserCode(Long summary_id) {
		Session session = super.getSession();
		
		List<String> lo = null;
		String resultList = "";
		try{
			// 查询用户编码
			String sql = "select a.code from org_member a , col_summary b where a.id = b.start_member_id and b.id=:summary_id";
			SQLQuery query = session.createSQLQuery(sql);
			query.setParameter("summary_id", summary_id);
			lo = query.list();
			if(lo.get(0) != null) {
				resultList = lo.get(0);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return resultList;
	}
}

