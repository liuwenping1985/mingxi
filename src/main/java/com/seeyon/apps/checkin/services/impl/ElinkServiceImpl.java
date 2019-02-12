package com.seeyon.apps.checkin.services.impl;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.seeyon.apps.checkin.client.CheckUtils;
import com.seeyon.apps.checkin.domain.InitCheckIn;
import com.seeyon.apps.checkin.manager.InitCheckInManager;
import com.seeyon.apps.checkin.services.ElinkService;
import com.seeyon.ctp.common.AppContext;

public class ElinkServiceImpl implements ElinkService{

//	private InitCheckInManager checkinmanager;

	public ElinkServiceImpl()
	{
		System.out.println("=============1111");
	}
	
//	public InitCheckInManager getCheckinmanager() {
//		return checkinmanager;
//	}
//
//	public void setCheckinmanager(InitCheckInManager checkinmanager) {
//		this.checkinmanager = checkinmanager;
//	}

	// E-Link打卡
	public String elinkCheckin(String loginName, String userIp) {
		System.out.println("====22222");
		InitCheckInManager checkinmanager = (InitCheckInManager) AppContext.getBean("checkinmanager");
	    String userid = checkinmanager.findUserIdbyloginName(loginName);
	    boolean flg = checkinmanager.chenkIp(userIp);
	    String str ="打卡成功！";
		if(flg){
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date = new Date();
			String time = df.format(date);
			//打卡时间
			Timestamp checkTime = Timestamp.valueOf(time);
			String tempWeek = CheckUtils.getWeekCodeOfDate(date);
			
			InitCheckIn checkIn = new InitCheckIn();
			//用户id
			checkIn.setUserId(userid);
			//打卡时间
			checkIn.setCheckTime(checkTime);
			//打卡标识（0:正常 1：异常）
			//checkIn.setFlag("0");
			//星期
			checkIn.setWeek(tempWeek);
			//请假类型
			//0：不显示;1：病假;2：事假;3：年休假;4：婚假;5：丧假;6：产假;7：其它;8：出差;9:外出培训
			checkIn.setLeaveType("0");
			//返回打卡状态
			String checkStatus = checkinmanager.saveInit(checkIn);
			//打卡完成后，设置打卡状态
			//            -1:打卡失败
			//             0:正常打卡
			//             1:异常打卡
			//             2:不打卡部门
			//             3:不打卡人
			//             4:休息日无需打卡
			if(checkStatus.equals("-1")){
				str = "打卡失败！";
			}else if(checkStatus.equals("0")){
				str = "打卡成功！\n"+time.toString();
			}else if(checkStatus.equals("2")){
				str = "不打卡部门！";
			}else if(checkStatus.equals("3")){
				str = "不打卡人！";
			}else if(checkStatus.equals("4")){
				str = "休息日无需打卡！";
			}else{
				str = "打卡失败！";
			}
		}else{
			str = "该IP地址不在打卡范围内";  
		}
		System.out.println("====+++"+str);
		return str;
	}
}
