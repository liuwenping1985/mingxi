package com.seeyon.apps.kdXdtzXc.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.apps.kdXdtzXc.po.XieChengJiaoTong;
import com.seeyon.apps.kdXdtzXc.po.XiechengJiaotongQx;
import com.seeyon.apps.kdXdtzXc.util.PropertiesUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.dao.AbstractHibernateDao;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.UUIDLong;

public class XiechengJiaotongQxDaoImpl extends AbstractHibernateDao<XiechengJiaotongQx> implements XiechengJiaotongQxDao {
	
	private static final Log log = LogFactory.getLog(XiechengJiaotongQxDaoImpl.class);
	JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");

	/** 查看全部内容 **/
	public List<XiechengJiaotongQx> getAll() {
		String hql = "from XiechengJiaotongQx as xiechengJiaotongQx";
		return DBAgent.find(hql);
	}

	/** 根据ids查找多条记录 **/
	public List<XiechengJiaotongQx> getDataByIds(Long[] ids) {
		String hql = "from XiechengJiaotongQx as xiechengJiaotongQx where xiechengJiaotongQx.id in(:ids)";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ids", ids);
		return DBAgent.find(hql, map);
	}
	
	/** 根据id查找多条记录 **/
	public List<XiechengJiaotongQx> getDataByJiaoTongId(Long id) {
		String hql = "from XiechengJiaotongQx as xiechengJiaotongQx where xiechengJiaotongQx.id =(:ids)";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ids", id);
		return DBAgent.find(hql, map);
	}

	/** 根据id查找一条记录 **/
	public XiechengJiaotongQx getDataById(Long id) {
		return (XiechengJiaotongQx) DBAgent.get(XiechengJiaotongQx.class, id);
	}

	/** 新增记录 **/
	public void add(XiechengJiaotongQx xiechengJiaotongQx) {
		DBAgent.save(xiechengJiaotongQx);
	}

	/** 修改记录 **/
	public void update(XiechengJiaotongQx xiechengJiaotongQx) {
		DBAgent.update(xiechengJiaotongQx);
	}

	/** 删除多条记录 **/
	public void deleteAll(Long[] ids) {
		String hql = "delete XiechengJiaotongQx as xiechengJiaotongQx where xiechengJiaotongQx.id in (:ids)";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ids", ids);
		DBAgent.bulkUpdate(hql, map);
	}

	/** 根据ID删除 **/
	public void deleteById(Long id) {
		String hql = "delete XiechengJiaotongQx as xiechengJiaotongQx where xiechengJiaotongQx.id = :id";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		DBAgent.bulkUpdate(hql, map); 
	}

	/** 根据对象删除 **/
	public void delete(XiechengJiaotongQx xiechengJiaotongQx) {
		DBAgent.delete(xiechengJiaotongQx);
	}
	
	
	public void saveShijiXinxin(String memberIds,String approvalNumber,Long mainId,String formshiji){
		// (2)获取出差人数据
		String[] memberAry = memberIds.split(","); // 出差人
		int members = memberAry.length; // 出差人数
		if (members > 0) {
			for (int m = 1; m <= memberAry.length; m++) {
				Long memberId = Long.valueOf(memberAry[m - 1] + "");
				if (memberId != null && !memberId.equals("")) {
					// 携程详细信息访问地址
					String chuchaixiangqing = (String) PropertiesUtils.getInstance().get("chuchaixiangqing");
					String url = chuchaixiangqing + "&name=" + memberId + "&bianhao=" + approvalNumber;

					// 主表id（formmain_id）、排序（sort）、序号（field0033）、出差人（field0034）、开始时间（field0028）、结束时间（field0029）、总天数（field0030）、详细信息(field0036)
					String querysql = "select id from " + formshiji + " where 1=1 and formmain_id =" + mainId + " and field0034=" + memberId;
					List<Map<String, Object>> shijiList = jdbcTemplate.queryForList(querysql);
					if (shijiList != null && shijiList.size() == 0) {
						// 添加实际信息
						String insertxc = "INSERT INTO " + formshiji + " (id,formmain_id,sort,field0033,field0034,field0036) " + "VALUES (" + UUIDLong.longUUID() + "," + mainId + "," + (m) + "," + (m) + "," + memberId + ",'" + url + "')";
						int update = jdbcTemplate.update(insertxc);
						System.out.println("####" + update);
					}
				}
			}
		}
	}

	@Override
	public List<XieChengJiaoTong> getHeGuiJiaoTong(String userDgj) {
		String hql="from XieChengJiaoTong where type= :userDgj";
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("userDgj", userDgj);
		List<XieChengJiaoTong> find = DBAgent.find(hql, map);
		return find;
	}
}
