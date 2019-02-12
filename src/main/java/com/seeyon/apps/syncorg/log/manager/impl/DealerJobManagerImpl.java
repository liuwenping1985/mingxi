package com.seeyon.apps.syncorg.log.manager.impl;

import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.seeyon.apps.syncorg.log.manager.SyncLogManager;
import com.seeyon.apps.syncorg.manager.CzOrgManager;
import com.seeyon.apps.scheduletask.ScheduleTaskJob;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.util.Datetimes;

public class DealerJobManagerImpl extends ScheduleTaskJob{
	private static Log log = LogFactory.getLog(DealerJobManagerImpl.class);

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		log.info("定时任务执行了"+this.getClass().getSimpleName()+"   "+Datetimes.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		SyncLogManager syncLogManager = (SyncLogManager) AppContext.getBean("syncLogManager");
		syncLogManager.syncFailed();
	}


}
