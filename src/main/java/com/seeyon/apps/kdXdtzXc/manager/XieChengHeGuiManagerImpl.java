package com.seeyon.apps.kdXdtzXc.manager;

import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.apps.kdXdtzXc.po.XieChengVipJiuDianPo;
import com.seeyon.apps.kdXdtzXc.po.XieChengXieYiJiuDiangPo;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.UUIDLong;

public class XieChengHeGuiManagerImpl implements XieChengHeGuiManager{
	private static JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
	@Override
	public List<Map<String, Object>> getDgjVipJiuDian(String type) {
		String sql="SELECT * FROM pro_vipjiudian WHERE type='"+type+"'";
		List<Map<String, Object>> VipJiuDianList = jdbcTemplate.queryForList(sql);
		return VipJiuDianList;
	}
	@Override
	public List<Map<String, Object>> getVipJiuDianId(String id) {
		String sql="SELECT * FROM pro_vipjiudian WHERE id='"+id+"'";
		List<Map<String, Object>> VipJiuDianid = jdbcTemplate.queryForList(sql);
		return VipJiuDianid;
	}
	@Override
	public void getUpdateVipJiuDianId(Map<String,String> mapup) {
		String updateSql="UPDATE pro_vipjiudian SET carName='"+mapup.get("carName")+"',room="+mapup.get("room")+" ,roomType='"+mapup.get("roomtype")+"',bigDate='"+mapup.get("bigDate")+"',endDate='"+mapup.get("endDate")+"',type='"+mapup.get("type")+"' WHERE id='"+mapup.get("id")+"'";
		jdbcTemplate.update(updateSql);
		
	}
	@Override
	public void deleteVipJiuDianId(String id) {
		String delSql="DELETE FROM pro_vipjiudian WHERE id='"+id+"'";
		jdbcTemplate.update(delSql);
		
	}
	@Override
	public void InsertHeGui(Map<String, String> map) {
		String sqlInsert="INSERT INTO pro_vipjiudian VALUES ('"+String.valueOf(UUIDLong.longUUID())+"','"+map.get("carName")+"',"+map.get("room")+",'"+map.get("roomtype")+"','"+map.get("bigDate")+"','"+map.get("endDate")+"','"+map.get("type")+"')";
		jdbcTemplate.update(sqlInsert);
	}
	@Override
	public List<Map<String, Object>> getXieYiJiuDian(String type) {
		String sql="SELECT * FROM pro_xieyijiudian WHERE type='"+type+"'";
		List<Map<String, Object>> xieYiJiuDianList = jdbcTemplate.queryForList(sql);
		return xieYiJiuDianList;
	}
	@Override
	public List<Map<String, Object>> getXieYiDianId(String id) {
		String sql="SELECT * FROM pro_xieyijiudian WHERE id='"+id+"'";
		List<Map<String, Object>> xieYiJiuDianid = jdbcTemplate.queryForList(sql);
		return xieYiJiuDianid;
	}
	@Override
	public void getUpdateXieYiJiuDianId(Map<String, String> mapup) {
		String updateSql="UPDATE pro_xieyijiudian SET carName='"+mapup.get("carName")+"',jiudianmincheng='"+mapup.get("jiudianmingcheng")+"',room="+mapup.get("room")+" ,roomType='"+mapup.get("roomtype")+"',bigDate='"+mapup.get("bigDate")+"',endDate='"+mapup.get("endDate")+"',type='"+mapup.get("type")+"' WHERE id='"+mapup.get("id")+"'";
		jdbcTemplate.update(updateSql);
		
	}
	@Override
	public void deleteXieYiJiuDianId(String id) {
		String delSql="DELETE FROM pro_xieyijiudian WHERE id='"+id+"'";
		jdbcTemplate.update(delSql);
		
	}
	@Override
	public void InsertXieYiHeGui(Map<String, String> map) {
		String sqlInsert="INSERT INTO pro_xieyijiudian VALUES ('"+String.valueOf(UUIDLong.longUUID())+"','"+map.get("carName")+"','"+map.get("jiudianmingcheng")+"',"+map.get("room")+",'"+map.get("roomtype")+"','"+map.get("bigDate")+"','"+map.get("endDate")+"','"+map.get("type")+"')";
		jdbcTemplate.update(sqlInsert);
		
	}
	
	@Override
	public List<Map<String, Object>> getJiaoTong(String type) {
		String sql="SELECT * FROM pro_xiechengjiaotong WHERE type='"+type+"'";
		List<Map<String, Object>> JiaoTongTypeList = jdbcTemplate.queryForList(sql);
		return JiaoTongTypeList;
	}
	@Override
	public List<Map<String, Object>> getJiaoTongId(String id) {
		String sql="SELECT * FROM pro_xiechengjiaotong WHERE id='"+id+"'";
		List<Map<String, Object>> JiaoTongidList = jdbcTemplate.queryForList(sql);
		return JiaoTongidList;
	}
	@Override
	public void getUpdateJiaoTongId(Map<String, String> mapup) {
		String updateSql="UPDATE pro_xiechengjiaotong SET position='"+mapup.get("position")+"',type='"+mapup.get("type")+"' WHERE id='"+mapup.get("id")+"'";
		jdbcTemplate.update(updateSql);
		
	}
	@Override
	public void deleteJiaoTongId(String id) {
		String delSql="DELETE FROM pro_xiechengjiaotong WHERE id='"+id+"'";
		jdbcTemplate.update(delSql);
		
	}
	
	@Override
	public void InsertJiaoTong(Map<String, String> map) {
		String sqlInsert="INSERT INTO pro_xiechengjiaotong VALUES ('"+String.valueOf(UUIDLong.longUUID())+"','"+map.get("position")+"','"+map.get("type")+"')";
		jdbcTemplate.update(sqlInsert);
		
	}
	
	public FlipInfo getAllVipJiuDian(FlipInfo fi, Map<String, Object> params)throws BusinessException {
		try {
			String hql="from XieChengVipJiuDianPo";
			List<XieChengVipJiuDianPo> find = DBAgent.find(hql,params,fi);
			fi.setData(find);
			return fi;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	@Override
	public List<XieChengVipJiuDianPo> getAllVipJiuDian(){
		try {
			String hql="from XieChengVipJiuDianPo";
			List<XieChengVipJiuDianPo> find = DBAgent.find(hql);
			return find;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public List<XieChengXieYiJiuDiangPo> getXieChengXieYiJiuDiangPo() {
		try {
			String hql="from XieChengXieYiJiuDiangPo";
			List<XieChengXieYiJiuDiangPo> finds = DBAgent.find(hql);
			return finds;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public void updateVip(String id, String bigDate, String endDate) {
		String updateSql="UPDATE pro_vipjiudian SET bigDate='"+bigDate+"',endDate='"+endDate+"' WHERE id='"+id+"'";
		jdbcTemplate.update(updateSql);
		
	}

	@Override
	public void updateXieYi(String id, String bigDate, String endDate) {
		String updateSql="UPDATE pro_xieyijiudian SET bigDate='"+bigDate+"',endDate='"+endDate+"' WHERE id='"+id+"'";
		jdbcTemplate.update(updateSql);
		
	}
}
