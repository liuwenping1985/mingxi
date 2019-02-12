package com.seeyon.apps.appoint.util;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.appoint.dao.AppointEdocPushInfoDao;
import com.seeyon.apps.appoint.po.AppoinEdocPushInfo;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.util.ReqUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.v3x.edoc.controller.newedoc.FromTemplateToSendEdocImpl;

public class CZFromTemplateToSendEdocImpl extends FromTemplateToSendEdocImpl{
	private static AppointEdocPushInfoDao appointEdocPushInfoDao = (AppointEdocPushInfoDao) AppContext.getBean("appointEdocPushInfoDao");
	public  void createEdocSummary(HttpServletRequest request, ModelAndView modelAndView)
		    throws Exception {
		super.createEdocSummary(request, modelAndView);
		String title = request.getParameter("title");
		String sysflowid = ReqUtil.getString(request, "sysflowid");
		if(Strings.isNotBlank(sysflowid)&&Strings.isNotBlank(title)){
			
			summary.setSubject(title);
			summary.setIdIfNew();
			AppoinEdocPushInfo info = new AppoinEdocPushInfo();
			info.setIdIfNew();
			List<AppoinEdocPushInfo> list = appointEdocPushInfoDao.getLogListByInfoId(sysflowid);
			if(list!=null && list.size()>0){
				info = list.get(0);
			}
			if(info!=null){
				info.setSummaryId(summary.getId());
				info.setInfoId(sysflowid);
				info.setInfo(summary);
				info.setCreateDate(new Date(System.currentTimeMillis()));
				appointEdocPushInfoDao.saveOrUpdate(info);
			}
		
		}
	}
}
