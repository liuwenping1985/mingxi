package com.seeyon.apps.taskcenter.util;

import java.util.Comparator;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.taskcenter.bo.CenterTaskBO;
import com.seeyon.ctp.util.Datetimes;

public class DoneListSortUtils implements Comparator{
	private static final Log log = LogFactory.getLog(DoneListSortUtils.class);
	@Override
	public int compare(Object arg0, Object arg1) {
		try{
			CenterTaskBO bo0 = (CenterTaskBO) arg0;
			CenterTaskBO bo1 = (CenterTaskBO) arg1;
			if(Datetimes.parse(bo0.getSubmitTime()).before(Datetimes.parse(bo1.getSubmitTime()))){
				return 1;
			}else if(Datetimes.parse(bo0.getSubmitTime()).after(Datetimes.parse(bo1.getSubmitTime()))){
				return -1;
			}
		}catch(Exception e){
			log.error("DoneListSortUtils compare 出错: ",e);
		}
		return 0;
		
	}

}
