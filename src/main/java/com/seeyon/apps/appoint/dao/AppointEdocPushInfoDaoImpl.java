package com.seeyon.apps.appoint.dao;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.apps.appoint.po.AppoinEdocPushInfo;
import com.seeyon.ctp.common.dao.BaseDao;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.AjaxAccess;

public class AppointEdocPushInfoDaoImpl extends BaseDao implements AppointEdocPushInfoDao {

	@Override
	public void saveOrUpdate(AppoinEdocPushInfo dataInfo) {
		DBAgent.saveOrUpdate(dataInfo);
		
	}


	@Override
	public List getUnSuccessLog(){
		StringBuffer hql =new StringBuffer();
		hql.append(" from "+AppoinEdocPushInfo.class.getSimpleName() + " t where  t.successflag =:successflag");
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("successflag", Boolean.FALSE);
		return DBAgent.find(hql.toString(), params);
		
	}
	@Override
	public List<AppoinEdocPushInfo> getAllUnsuccessLogByOutDay(int outDay) {
		StringBuffer hql =new StringBuffer();
		hql.append(" from "+AppoinEdocPushInfo.class.getSimpleName() + " t where  t.successflag =:successflag and t.createDate > :outDate");
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("outDate", Datetimes.addDate(new Date(), -outDay));
		params.put("successflag", Boolean.FALSE);
		return DBAgent.find(hql.toString(), params);
	}

	@Override
	public AppoinEdocPushInfo getById(Long id) {
		return DBAgent.get(AppoinEdocPushInfo.class, id);
		
	}
	@Override
	public List<AppoinEdocPushInfo> getLogListByInfoId(String infoId) {
		StringBuffer hql =new StringBuffer();
		hql.append(" from "+AppoinEdocPushInfo.class.getSimpleName() + " t where  t.infoId =:infoId");
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("infoId",infoId);
		return DBAgent.find(hql.toString(), params);
	}

	@Override
	public List<AppoinEdocPushInfo> getLogListBySummaryId(Long summaryId) {
		StringBuffer hql =new StringBuffer();
		hql.append(" from "+AppoinEdocPushInfo.class.getSimpleName() + " t where  t.summaryId =:summaryId");
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("summaryId", summaryId);
		return DBAgent.find(hql.toString(), params);
	}

	@AjaxAccess
	@Override
	public FlipInfo queryByCondition(FlipInfo flipInfo,
			Map<String, String> params) throws BusinessException {
		    StringBuffer hql = new StringBuffer();
		    Map<String,Object> param = new HashMap<String,Object>();
		    hql.append(" from "+AppoinEdocPushInfo.class.getSimpleName()+" tmp where 1=1");
		    String title = params.get("title");
		    if (Strings.isNotBlank(title)) {
		    	hql.append(" and tmp.title like :title");
		        param.put("title", "%" + title + "%");
		        
		    }else if (Strings.isNotBlank(params.get("template"))) {
		    	hql.append(" and tmp.templateNumber like :templateNumber");
		        param.put("templateNumber", "%" + params.get("template") + "%");
		        
		    }else if (Strings.isNotBlank(params.get("info"))) {
		    	hql.append(" and tmp.infoName = :infoName");
		        param.put("infoName", params.get("info"));
		    }
		    if(Strings.isNotBlank(params.get("flag"))){
		    	hql.append(" and tmp.successflag =:successflag");
		        param.put("successflag", Boolean.valueOf(params.get("flag")));
		    }
		    hql.append(" order by tmp.createDate,tmp.title asc");
		    DBAgent.find(hql.toString(), param, flipInfo);
		    return flipInfo;
		}
	

}
