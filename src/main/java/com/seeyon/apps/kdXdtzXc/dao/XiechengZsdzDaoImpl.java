package com.seeyon.apps.kdXdtzXc.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.apps.kdXdtzXc.po.XiechengZsdz;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.dao.AbstractHibernateDao;
import com.seeyon.ctp.util.DBAgent;

public class XiechengZsdzDaoImpl extends AbstractHibernateDao<XiechengZsdz> implements XiechengZsdzDao {
	
	private static final Log log = LogFactory.getLog(XiechengZsdzDaoImpl.class);
	
	JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");

	/** 查看全部内容 **/
	public List<XiechengZsdz> getAll() {
		String hql = "from XiechengZsdz as xiechengZsdz";
		return DBAgent.find(hql);
	}

	
	/** 根据ids查找多条记录 **/
	public List<XiechengZsdz> getDataByIds(Long[] ids) {
		String hql = "from XiechengZsdz as xiechengZsdz where xiechengZsdz.id in(:ids)";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ids", ids);
		return DBAgent.find(hql, map);
	}

	/** 根据id查找一条记录 **/
	public XiechengZsdz getDataById(Long id) {
		return (XiechengZsdz) DBAgent.get(XiechengZsdz.class, id);
	}

	/** 新增记录 **/
	public void add(XiechengZsdz xiechengZsdz) {
		DBAgent.save(xiechengZsdz);
	}

	/** 修改记录 **/
	public void update(XiechengZsdz xiechengZsdz) {
		DBAgent.update(xiechengZsdz);
	}

	/** 删除多条记录 **/
	public void deleteAll(Long[] ids) {
		String hql = "delete XiechengZsdz as xiechengZsdz where xiechengZsdz.id in (:ids)";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ids", ids);
		DBAgent.bulkUpdate(hql, map);
	}

	/** 根据ID删除 **/
	public void deleteById(Long id) {
		String hql = "delete XiechengZsdz as xiechengZsdz where xiechengZsdz.id = :id";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		DBAgent.bulkUpdate(hql, map); 
	}

	/** 根据对象删除 **/
	public void delete(XiechengZsdz xiechengzsdz) {
		DBAgent.delete(xiechengzsdz);
	}


	@Override
	public List<Map<String, Object>> getOaList(String journeyid,
			String passengername, String takeofftime, String arrivaltime,
			String orderType,String amount) {
		//根据条件，查询OA数据库
		String sql ="SELECT * FROM XIECHENG_ZSDZ where recordId='"+journeyid+"' and accCheckBatchNo='"+passengername+"'";
		List<Map<String, Object>> xiechengjtdzList = jdbcTemplate.queryForList(sql);
		return xiechengjtdzList;
	}


	@Override
	public List<XiechengZsdz> getDataByZhuSuId(Long id,String extAttr3) {
		String hql = "from XiechengZsdz as xiechengZsdz where xiechengZsdz.xiechengFqdzxxZsId =(:id)";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		//map.put("extAttr3", extAttr3);
		return DBAgent.find(hql, map);
	}

}
