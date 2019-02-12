package com.seeyon.apps.kdXdtzXc.dao;

import java.util.List;

import com.seeyon.apps.kdXdtzXc.po.XieChengVipJiuDianPo;
import com.seeyon.apps.kdXdtzXc.po.XieChengXieYiJiuDiangPo;
import com.seeyon.apps.kdXdtzXc.po.XiechengZhusuQx;

public interface XiechengZhusuQxDao {
	public List<XiechengZhusuQx> getAll();

	public List<XiechengZhusuQx> getDataByIds(Long[] ids);

	public XiechengZhusuQx getDataById(Long id);

	public void add(XiechengZhusuQx xiechengZhusuQx);

	public void update(XiechengZhusuQx xiechengZhusuQx);

	public void deleteAll(Long[] ids);

	public void deleteById(Long id);

	public void delete(XiechengZhusuQx xiechengZhusuQx);
	
	//合规会员类型
	public List<XieChengVipJiuDianPo> gethrGui(String carName,String Type,String bigDate,String endDate);
	//合规协议类别
	public List<XieChengXieYiJiuDiangPo> gethrGuiXieYi(String carName,String Type,String jiuDianName,String bigDate,String endDate);
}
