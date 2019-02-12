package com.seeyon.apps.appoint.dao;

import java.util.List;
import java.util.Map;

import com.seeyon.apps.appoint.po.AppoinEdocPushInfo;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.FlipInfo;

public interface AppointEdocPushInfoDao {
	public Object getById(Long id);
	public void saveOrUpdate (AppoinEdocPushInfo dataInfo);
	public List getAllUnsuccessLogByOutDay(int outDay);
	public List getUnSuccessLog();
	public List getLogListByInfoId(String infoId);
	public List getLogListBySummaryId(Long summaryId);
	public FlipInfo queryByCondition(FlipInfo flipInfo, Map<String, String> query)throws BusinessException;


}
