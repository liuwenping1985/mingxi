package com.seeyon.apps.kdXdtzXc.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Query;

import com.seeyon.apps.kdXdtzXc.po.XieChengVipJiuDianPo;
import com.seeyon.apps.kdXdtzXc.po.XieChengXieYiJiuDiangPo;
import com.seeyon.apps.kdXdtzXc.po.XiechengZhusuQx;
import com.seeyon.ctp.common.dao.AbstractHibernateDao;
import com.seeyon.ctp.util.DBAgent;

public class XiechengZhusuQxDaoImpl extends AbstractHibernateDao<XiechengZhusuQx> implements XiechengZhusuQxDao {
	
	private static final Log log = LogFactory.getLog(XiechengZhusuQxDaoImpl.class);

	/** 查看全部内容 **/
	public List<XiechengZhusuQx> getAll() {
		String hql = "from XiechengZhusuQx as xiechengZhusuQx";
		return DBAgent.find(hql);
	}

	/** 根据ids查找多条记录 **/
	public List<XiechengZhusuQx> getDataByIds(Long[] ids) {
		String hql = "from XiechengZhusuQx as xiechengZhusuQx where xiechengZhusuQx.id in(:ids)";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ids", ids);
		return DBAgent.find(hql, map);
	}

	/** 根据id查找一条记录 **/
	public XiechengZhusuQx getDataById(Long id) {
		return (XiechengZhusuQx) DBAgent.get(XiechengZhusuQx.class, id);
	}

	/** 新增记录 **/
	public void add(XiechengZhusuQx xiechengZhusuQx) {
		DBAgent.save(xiechengZhusuQx);
	}

	/** 修改记录 **/
	public void update(XiechengZhusuQx xiechengZhusuQx) {
		DBAgent.update(xiechengZhusuQx);
	}

	/** 删除多条记录 **/
	public void deleteAll(Long[] ids) {
		String hql = "delete XiechengZhusuQx as xiechengZhusuQx where xiechengZhusuQx.id in (:ids)";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ids", ids);
		DBAgent.bulkUpdate(hql, map);
	}

	/** 根据ID删除 **/
	public void deleteById(Long id) {
		String hql = "delete XiechengZhusuQx as xiechengZhusuQx where xiechengZhusuQx.id = :id";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		DBAgent.bulkUpdate(hql, map); 
	}

	/** 根据对象删除 **/
	public void delete(XiechengZhusuQx xiechengZhusuQx) {
		DBAgent.delete(xiechengZhusuQx);
	}
	
	public List<XieChengVipJiuDianPo> gethrGui(String carName,String Type,String bigDate,String endDate){ //select * from PRO_VIPJIUDIAN t where '2018-03-02' between t.BIGDATE and t.ENDDATE
		String hql ="from XieChengVipJiuDianPo s where s.carName=? and s.Type=? and ? between ? and ?";
		Map<String,Object>map=new HashMap<String, Object>();
		//map.put("carName", carName);
		//map.put("Type", Type);
		Query setString = this.getSession().createQuery(hql).setString(0, carName).setString(1, Type).setString(2, bigDate).setString(3, bigDate).setString(4, endDate);
		List<XieChengVipJiuDianPo> vips=setString.list();

		if(null == vips && vips.size() == 0){
			String hql1 ="from XieChengVipJiuDianPo s where s.carName=? and s.Type=? and ? between ? and ?";
			Query setString2 = this.getSession().createQuery(hql).setString(0, "其他").setString(1, Type).setString(2, bigDate).setString(3, bigDate).setString(4, endDate);
			vips=setString2.list();
			
		}
		return vips;
	}

	@Override
	public List<XieChengXieYiJiuDiangPo> gethrGuiXieYi(String carName, String Type,String jiuDianName,String bigDate,String endDate) {
		String hqls="from XieChengXieYiJiuDiangPo where carName=? and Type=? and jiudianmincheng=? and ? between ? and ?";
		Query setString2 = this.getSession().createQuery(hqls).setString(0, carName).setString(1, Type).setString(2, jiuDianName).setString(3, bigDate).setString(4, bigDate).setString(5, endDate);
		List<XieChengXieYiJiuDiangPo> lisst=setString2.list();

		if(null == lisst && lisst.size() == 0){
			String hql1 ="from XieChengXieYiJiuDiangPo where carName=? and Type=? and jiudianmincheng=? and ? between ? and ?";
			Query setString1 = this.getSession().createQuery(hql1).setString(0, "其它").setString(1, Type).setString(2, jiuDianName).setString(3, bigDate).setString(4, bigDate).setString(5, endDate);
			lisst=setString1.list();
		}
		return lisst;
	}

}
