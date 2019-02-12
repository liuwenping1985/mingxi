package com.seeyon.ctp.common.checkflowopen.dao;

public interface CheckFlowOpenDao {
	
	public String checkFlowOpen(Long affairId,String currentUserName);
	
	public void removeOpenUser(Long affairId,String currentUserName);

}
