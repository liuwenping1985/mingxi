package com.seeyon.apps.czexchange.manager.impl;

import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import com.seeyon.apps.czexchange.manager.EdocReceiptLogManager;
import com.seeyon.apps.czexchange.po.EdocReceiptLog;
import com.seeyon.apps.scheduletask.ScheduleTaskJob;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.util.Datetimes;

public class DealerJobManagerImpl extends ScheduleTaskJob{
	private static Log log = LogFactory.getLog(DealerJobManagerImpl.class);
	
	private static boolean isRunning = false;

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		log.info("定时任务执行了"+this.getClass().getSimpleName()+"   "+Datetimes.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		if(isRunning) {
			log.info(" 同一时间， 只能有一个定时任务在执行， 程序退出。");
			return;
		}
		isRunning = true;
		try{
			EdocReceiptLogManager edocReceiptLogManager = (EdocReceiptLogManager) AppContext.getBean("edocReceiptLogManager");
			List<EdocReceiptLog> list = edocReceiptLogManager.getUnSuccessRecord(null);
			if(list!=null&&list.size()>0){
				for(EdocReceiptLog edocReceiptLog : list){
					edocReceiptLogManager.sendReceiptLog(edocReceiptLog);
				}
			}
		}catch(Exception e){
			log.error("", e);
		}finally{
			isRunning = false;
		}


	}


}
