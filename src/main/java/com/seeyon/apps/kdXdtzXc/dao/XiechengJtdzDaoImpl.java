package com.seeyon.apps.kdXdtzXc.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.apps.kdXdtzXc.po.XiechengJtdz;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.util.DBAgent;

public class XiechengJtdzDaoImpl implements XiechengJtdzDao{

	JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
	
	

	/** 查看全部内容 **/
	public List<XiechengJtdz> getAll() {
		String hql = "from XiechengJtdz as xiechengJtdz";
		return DBAgent.find(hql);
	}

	
	/** 根据ids查找多条记录 **/
	public List<XiechengJtdz> getDataByIds(Long[] ids) {
		String hql = "from XiechengJtdz as xiechengJtdz where xiechengJtdz.id in(:ids)";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ids", ids);
		return DBAgent.find(hql, map);
	}

	/** 根据id查找一条记录 **/
	public XiechengJtdz getDataById(Long id) {
		return (XiechengJtdz) DBAgent.get(XiechengJtdz.class, id);
	}

	/** 修改记录 **/
	public void update(XiechengJtdz xiechengJtdz) {
		DBAgent.update(xiechengJtdz);
	}

	/** 删除多条记录 **/
	public void deleteAll(Long[] ids) {
		String hql = "delete XiechengJtdz as xiechengJtdz where xiechengJtdz.id in (:ids)";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ids", ids);
		DBAgent.bulkUpdate(hql, map);
	}

	/** 根据ID删除 **/
	public void deleteById(Long id) {
		String hql = "delete XiechengJtdz as xiechengJtdz where xiechengJtdz.id = :id";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		DBAgent.bulkUpdate(hql, map); 
	}

	/** 根据对象删除 **/
	public void delete(XiechengJtdz xiechengJtdz) {
		DBAgent.delete(xiechengJtdz);
	}

	
	//往数据库中添加数据
	@Override
	public void add(XiechengJtdz xiechengjtdz){
		DBAgent.save(xiechengjtdz);
		
	}

	@Override
	public List<Map<String, Object>> getOaList(String journeyid, String passengername, String takeofftime, String arrivaltime ,String orderDetailType,String amount) {
		//根据条件，查询OA数据库
		String sql ="SELECT * FROM XIECHENG_JTDZ where recordId='"+journeyid+"' and accCheckBatchNo='"+passengername+"'";
		List<Map<String, Object>> xiechengjtdzList = jdbcTemplate.queryForList(sql);
		return xiechengjtdzList;
	}

	/**
	 * 根据外键id查询关联数据
	 */
	@Override
	public List<XiechengJtdz> getDataByJiaoTongId(Long id,String extAttr3) {
		String hql = "from XiechengJtdz as xiechengJtdz where xiechengJtdz.xiechengFqdzxxJtId =(:id)";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		//map.put("extAttr3", extAttr3);
		return DBAgent.find(hql, map);
	}
	

}
