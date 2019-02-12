package com.seeyon.apps.kdXdtzXc.manager;

import java.util.List;
import java.util.Map;

import com.seeyon.apps.kdXdtzXc.po.XieChengVipJiuDianPo;
import com.seeyon.apps.kdXdtzXc.po.XieChengXieYiJiuDiangPo;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.annotation.AjaxAccess;

public interface XieChengHeGuiManager {
	//查出 vip酒店的所有董高监，员工，部门
	public List<Map<String,Object>>getDgjVipJiuDian(String type);
	//根据id查
	public List<Map<String,Object>>getVipJiuDianId(String id);
	//根据id 更新
	public void getUpdateVipJiuDianId(Map<String,String> mapup);
	//删除
	public void deleteVipJiuDianId(String id);
	//添加
	public void InsertHeGui(Map<String,String> map);
	
	//查出 协议酒店的所有董高监，员工，部门
	public List<Map<String,Object>>getXieYiJiuDian(String type);
	//根据id查
	public List<Map<String,Object>>getXieYiDianId(String id);
	//根据id 更新
	public void getUpdateXieYiJiuDianId(Map<String,String> mapup);
	//删除
	public void deleteXieYiJiuDianId(String id);
	//添加
	public void InsertXieYiHeGui(Map<String,String> map);
	
	//查出 交通的所有董高监，员工，部门
	public List<Map<String,Object>>getJiaoTong(String type);
	//根据id查
	public List<Map<String,Object>>getJiaoTongId(String id);
	//根据id 更新
	public void getUpdateJiaoTongId(Map<String,String> mapup);
	//删除
	public void deleteJiaoTongId(String id);
	//添加
	public void InsertJiaoTong(Map<String,String> map);
	@AjaxAccess
	public abstract FlipInfo  getAllVipJiuDian(FlipInfo fi, Map<String, Object> params)throws BusinessException;
	
 	//对账数据维护查询所有
  	public List<XieChengVipJiuDianPo> getAllVipJiuDian();
  	public List<XieChengXieYiJiuDiangPo> getXieChengXieYiJiuDiangPo();
  	//对账数据维护更新所有日期
  	public void updateVip(String id,String bigDate,String endDate);
  	
	public void updateXieYi(String id,String bigDate,String endDate);

}
