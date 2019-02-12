package com.seeyon.apps.checkin.manager;

import java.util.HashMap;
import java.util.List;

import com.seeyon.apps.checkin.domain.InitCheckIn;

public interface InitCheckInManager {

	 /**
	  * 
	  * @param check
	  * @return String
	  *         -1:打卡失败
	  *         0:正常打卡
	  *         1:异常打卡
	  *         2:不打卡部门
	  *         3:不打卡人
	  */
	public String saveInit(InitCheckIn check);
	
	public List<InitCheckIn> findInitAll(String userid);
	
	public List<InitCheckIn> findInitAll(String stime,String etime,String flag,String userid,String leaveType);
	
	public List<InitCheckIn> findDetail(String checkdate,String userid);
	
	public HashMap<String, String> findLeaveType() ;
	
	public boolean chenkIp(String ip);

	public String findUserIdbyloginName(String loginName);

}
