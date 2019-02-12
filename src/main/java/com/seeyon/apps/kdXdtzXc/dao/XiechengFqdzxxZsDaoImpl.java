package com.seeyon.apps.kdXdtzXc.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.apps.kdXdtzXc.po.XiechengFqdzxxZs;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.dao.AbstractHibernateDao;
import com.seeyon.ctp.util.DBAgent;

public class XiechengFqdzxxZsDaoImpl extends AbstractHibernateDao<XiechengFqdzxxZs> implements XiechengFqdzxxZsDao {
	
	private static final Log log = LogFactory.getLog(XiechengFqdzxxZsDaoImpl.class);
	
	JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");

	/** 查看全部内容 **/
	public List<XiechengFqdzxxZs> getAll() {
		String hql = "from XiechengFqdzxxZs as xiechengFqdzxxZs";
		return DBAgent.find(hql);
	}

	
	/** 根据ids查找多条记录 **/
	public List<XiechengFqdzxxZs> getDataByIds(Long[] ids) {
		String hql = "from XiechengFqdzxxZs as xiechengFqdzxxZs where xiechengFqdzxxZs.id in(:ids)";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ids", ids);
		return DBAgent.find(hql, map);
	}

	/** 根据id查找一条记录 **/
	public XiechengFqdzxxZs getDataById(Long id) {
		return (XiechengFqdzxxZs) DBAgent.get(XiechengFqdzxxZs.class, id);
	}

	/** 新增记录 **/
	public void add(XiechengFqdzxxZs xiechengFqdzxxZs) {
		DBAgent.save(xiechengFqdzxxZs);
	}

	/** 修改记录 **/
	public void update(XiechengFqdzxxZs xiechengFqdzxxZs) {
		DBAgent.update(xiechengFqdzxxZs);
	}

	/** 删除多条记录 **/
	public void deleteAll(Long[] ids) {
		String hql = "delete XiechengFqdzxxZs as xiechengFqdzxxZs where xiechengFqdzxxZs.id in (:ids)";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ids", ids);
		DBAgent.bulkUpdate(hql, map);
	}

	/** 根据ID删除 **/
	public void deleteById(Long id) {
		String hql = "delete XiechengFqdzxxZs as xiechengFqdzxxZs where xiechengFqdzxxZs.id = :id";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		DBAgent.bulkUpdate(hql, map); 
	}

	/** 根据对象删除 **/
	public void delete(XiechengFqdzxxZs xiechengzsdz) {
		DBAgent.delete(xiechengzsdz);
	}

	/** 查看全部内容 **/
	public List<XiechengFqdzxxZs> getAllByFglyId() {
		String hql = "select distinct xiechengFqdzxxZs.fglyIds2  from XiechengFqdzxxZs as xiechengFqdzxxZs";
		return DBAgent.find(hql);
	}


	@Override
	public List<Map<String, Object>> getByTime(int year, int month) {
		String sql = "SELECT * FROM XIECHENG_FQDZXX_ZS WHERE 1=1 AND YEAR="+year+" AND MONTH="+month;
		List<Map<String, Object>> list = jdbcTemplate.queryForList(sql);
		return list;
	}
	
}
