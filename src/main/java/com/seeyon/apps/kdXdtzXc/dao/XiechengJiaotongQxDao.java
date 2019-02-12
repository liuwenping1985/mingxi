package com.seeyon.apps.kdXdtzXc.dao;

import java.util.List;

import com.seeyon.apps.kdXdtzXc.po.XieChengJiaoTong;
import com.seeyon.apps.kdXdtzXc.po.XiechengJiaotongQx;

public interface XiechengJiaotongQxDao {
	public List<XiechengJiaotongQx> getAll();

	public List<XiechengJiaotongQx> getDataByIds(Long[] ids);

	public XiechengJiaotongQx getDataById(Long id);

	public void add(XiechengJiaotongQx xiechengJiaotongQx);

	public void update(XiechengJiaotongQx xiechengJiaotongQx);

	public void deleteAll(Long[] ids);

	public void deleteById(Long id);

	public void delete(XiechengJiaotongQx xiechengJiaotongQx);
	
	/**
	 * 根据id 查询全部数据
	 * @param id
	 * @return
	 */
	public List<XiechengJiaotongQx> getDataByJiaoTongId(Long id);
	
	/*
	 * 保存出差人员时间信息
	 */
	public void saveShijiXinxin(String memberIds,String approvalNumber,Long mainId,String formshiji);
	
	
	public List<XieChengJiaoTong> getHeGuiJiaoTong(String userDgj);
}
