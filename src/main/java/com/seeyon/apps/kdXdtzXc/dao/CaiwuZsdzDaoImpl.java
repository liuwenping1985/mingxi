package com.seeyon.apps.kdXdtzXc.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.kdXdtzXc.po.CaiwuZsdz;
import com.seeyon.ctp.common.dao.AbstractHibernateDao;
import com.seeyon.ctp.util.DBAgent;

public class CaiwuZsdzDaoImpl extends AbstractHibernateDao<CaiwuZsdz> implements CaiwuZsdzDao {
	
	private static final Log log = LogFactory.getLog(CaiwuZsdzDaoImpl.class);

	/** 查看全部内容 **/
	public List<CaiwuZsdz> getAll() {
		String hql = "from CaiwuZsdz as caiwuZsdz";
		return DBAgent.find(hql);
	}

	
	/** 根据ids查找多条记录 **/
	public List<CaiwuZsdz> getDataByIds(Long[] ids) {
		String hql = "from CaiwuZsdz as caiwuZsdz where caiwuZsdz.id in(:ids)";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ids", ids);
		return DBAgent.find(hql, map);
	}

	/** 根据id查找一条记录 **/
	public CaiwuZsdz getDataById(Long id) {
		return (CaiwuZsdz) DBAgent.get(CaiwuZsdz.class, id);
	}

	/** 新增记录 **/
	public void add(CaiwuZsdz caiwuZsdz) {
		DBAgent.save(caiwuZsdz);
	}

	/** 修改记录 **/
	public void update(CaiwuZsdz caiwuZsdz) {
		DBAgent.update(caiwuZsdz);
	}

	/** 删除多条记录 **/
	public void deleteAll(Long[] ids) {
		String hql = "delete CaiwuZsdz as caiwuZsdz where caiwuZsdz.id in (:ids)";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ids", ids);
		DBAgent.bulkUpdate(hql, map);
	}

	/** 根据ID删除 **/
	public void deleteById(Long id) {
		String hql = "delete CaiwuZsdz as caiwuZsdz where caiwuZsdz.id = :id";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		DBAgent.bulkUpdate(hql, map); 
	}

	/** 根据对象删除 **/
	public void delete(CaiwuZsdz caiwuZsdz) {
		DBAgent.delete(caiwuZsdz);
	}

}
