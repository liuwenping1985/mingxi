package com.seeyon.apps.kdXdtzXc.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.apps.kdXdtzXc.po.XiechengFqdzxxJt;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.dao.AbstractHibernateDao;
import com.seeyon.ctp.util.DBAgent;

public class XiechengFqdzxxJtDaoImpl extends AbstractHibernateDao<XiechengFqdzxxJt> implements XiechengFqdzxxJtDao {
	
	private static final Log log = LogFactory.getLog(XiechengFqdzxxJtDaoImpl.class);
	
	JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");

	/** 查看全部内容 **/
	public List<XiechengFqdzxxJt> getAll() {
		String hql = "from XiechengFqdzxxJt as xiechengFqdzxxJt";
		return DBAgent.find(hql);
	}

	
	/** 根据ids查找多条记录 **/
	public List<XiechengFqdzxxJt> getDataByIds(Long[] ids) {
		String hql = "from XiechengFqdzxxJt as xiechengFqdzxxJt where xiechengFqdzxxJt.id in(:ids)";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ids", ids);
		return DBAgent.find(hql, map);
	}

	/** 根据id查找一条记录 **/
	public XiechengFqdzxxJt getDataById(Long id) {
		return (XiechengFqdzxxJt) DBAgent.get(XiechengFqdzxxJt.class, id);
	}

	/** 新增记录 **/
	public void add(XiechengFqdzxxJt xiechengFqdzxxJt) {
		DBAgent.save(xiechengFqdzxxJt);
	}

	/** 修改记录 **/
	public void update(XiechengFqdzxxJt xiechengFqdzxxJt) {
		DBAgent.update(xiechengFqdzxxJt);
	}

	/** 删除多条记录 **/
	public void deleteAll(Long[] ids) {
		String hql = "delete XiechengFqdzxxJt as xiechengFqdzxxJt where xiechengFqdzxxJt.id in (:ids)";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ids", ids);
		DBAgent.bulkUpdate(hql, map);
	}

	/** 根据ID删除 **/
	public void deleteById(Long id) {
		String hql = "delete XiechengFqdzxxJt as xiechengFqdzxxJt where xiechengFqdzxxJt.id = :id";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		DBAgent.bulkUpdate(hql, map); 
	}

	/** 根据对象删除 **/
	public void delete(XiechengFqdzxxJt xiechengzsdz) {
		DBAgent.delete(xiechengzsdz);
	}

	/** 查看全部内容 **/
	public List<XiechengFqdzxxJt> getAllByFglyId() {
		String hql = "select distinct xiechengFqdzxxJt.fglyIds2  from XiechengFqdzxxJt as xiechengFqdzxxJt";
		return DBAgent.find(hql);
	}


	@Override
	public List<Map<String, Object>> getByTime(int year, int month) {
		String sql = "SELECT * FROM XIECHENG_FQDZXX_JT WHERE 1=1 AND YEAR="+year+" AND MONTH="+month;
		List<Map<String, Object>> list = jdbcTemplate.queryForList(sql);
		return list;
	}
	
}
