package com.seeyon.apps.kdXdtzXc.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.kdXdtzXc.po.CaiwuJtdz;
import com.seeyon.ctp.common.dao.AbstractHibernateDao;
import com.seeyon.ctp.util.DBAgent;

public class CaiwuJtdzDaoImpl extends AbstractHibernateDao<CaiwuJtdz> implements CaiwuJtdzDao {
	
	private static final Log log = LogFactory.getLog(CaiwuJtdzDaoImpl.class);

	/** 查看全部内容 **/
	public List<CaiwuJtdz> getAll() {
		String hql = "from CaiwuJtdz as caiwuJtdz";
		return DBAgent.find(hql);
	}

	
	/** 根据ids查找多条记录 **/
	public List<CaiwuJtdz> getDataByIds(Long[] ids) {
		String hql = "from CaiwuJtdz as caiwuJtdz where caiwuJtdz.id in(:ids)";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ids", ids);
		return DBAgent.find(hql, map);
	}

	/** 根据id查找一条记录 **/
	public CaiwuJtdz getDataById(Long id) {
		return (CaiwuJtdz) DBAgent.get(CaiwuJtdz.class, id);
	}

	/** 新增记录 **/
	public void add(CaiwuJtdz caiwuJtdz) {
		DBAgent.save(caiwuJtdz);
	}

	/** 修改记录 **/
	public void update(CaiwuJtdz caiwuJtdz) {
		DBAgent.update(caiwuJtdz);
	}

	/** 删除多条记录 **/
	public void deleteAll(Long[] ids) {
		String hql = "delete CaiwuJtdz as caiwuJtdz where caiwuJtdz.id in (:ids)";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ids", ids);
		DBAgent.bulkUpdate(hql, map);
	}

	/** 根据ID删除 **/
	public void deleteById(Long id) {
		String hql = "delete CaiwuJtdz as caiwuJtdz where caiwuJtdz.id = :id";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		DBAgent.bulkUpdate(hql, map); 
	}

	/** 根据对象删除 **/
	public void delete(CaiwuJtdz caiwuJtdz) {
		DBAgent.delete(caiwuJtdz);
	}

}
