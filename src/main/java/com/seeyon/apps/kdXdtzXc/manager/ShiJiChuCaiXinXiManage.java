package com.seeyon.apps.kdXdtzXc.manager;

import java.util.List;

import com.seeyon.apps.kdXdtzXc.po.CwBuzhuDateModel;

public interface ShiJiChuCaiXinXiManage { 
	/**
	 * 功能：财务系统获取补助信息表数据
	 * @param kbigingDate
	 * @return
	 */
	public List<CwBuzhuDateModel> getBuZhuXinXi(String kbigingDate);
	
	/**
	 * 功能：拼接报文
	 * @param kbigingDate
	 * @return
	 */
	public String getBuZhuXinXis(String kbigingDate);
}
