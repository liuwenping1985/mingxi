package com.seeyon.apps.checkin.manager;

import java.util.List;

import com.seeyon.apps.checkin.domain.CheckInInstall;
import com.seeyon.apps.checkin.domain.NoCheckinDepart;
import com.seeyon.apps.checkin.domain.NoCheckinUser;

public interface CheckInInstallManager {
	// 保存或更新考勤设置信息
	public void saveUpdateCheckinSet(CheckInInstall install);
	// 查询考勤设置信息
	public CheckInInstall searchCheckinSet();
	// 查询不打卡人信息
	public List<NoCheckinUser> searchNoCheckinUsers();
	// 删除不打卡人信息
	public void deleteNoCheckinUsers(String uids);
	// 查询不打卡部门信息
	public List<NoCheckinDepart> searchNoCheckinDepartments();
	// 删除不打卡部门
	public void deleteNoCheckinDepartments(String dids);
	// 检查前一天的考勤信息
//	public void checkYesterdayCheckin(String ydate);
	public void checkYesterdayCheckin();
	// 监听发起表单
	public void startUpForm();
	
	public int updatecheckabnormal(String userid,String checkdate);
	
	public List<CheckInInstall> selectffectivect();
	// 返回单位id
	public String getAccountId(String userId);
}
