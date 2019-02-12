package com.seeyon.ctp.common.checkflowopen.manager;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.calendar.manager.CalEventManagerImpl;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.checkflowopen.dao.CheckFlowOpenDao;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.po.affair.CtpAffair;

public class CheckFlowOpenManagerImpl implements CheckFlowOpenManager{
	
	private static final Log logger = LogFactory.getLog(CheckFlowOpenManager.class);
	
	private CheckFlowOpenDao checkFlowOpenDao;
	
	public void setCheckFlowOpenDao(CheckFlowOpenDao checkFlowOpenDao) {
		this.checkFlowOpenDao = checkFlowOpenDao;
	}

	@Override
	public String getCurrentOpenFlowUser(Long affairId, String currentUserName) {
		
		try{
			AffairManager affairManager = (AffairManager)AppContext.getBean("affairManager");
			CtpAffair affair = affairManager.get(affairId);
			
			if (affair == null || affair.getState() != StateEnum.col_pending.key()){
				return "null";
			}
			String userName = this.checkFlowOpenDao.checkFlowOpen(affair.getObjectId(), currentUserName);
			return userName;
			
		}catch(Exception e){
			logger.error("getCurrentOpenFlowUser ",e);
		}
		
		return "null";
	}

	@Override
	public void removeFlowOpenUser(Long affairId, String currentUserName) {
		try{
			AffairManager affairManager = (AffairManager)AppContext.getBean("affairManager");
			CtpAffair affair = affairManager.get(affairId);
			if (affair == null || affair.getState() != StateEnum.col_pending.key()){
				return;
			}
			
			this.checkFlowOpenDao.removeOpenUser(affair.getObjectId(), currentUserName);
			
		}catch(Exception e){
			logger.error("removeFlowOpenUser ",e);
		}
	}

	

	 
}
