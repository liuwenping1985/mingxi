package com.seeyon.apps.checkin.manager;

import java.util.List;

import com.seeyon.apps.checkin.dao.CheckInInstallDao;
import com.seeyon.apps.checkin.domain.CheckInInstall;
import com.seeyon.apps.checkin.domain.NoCheckinDepart;
import com.seeyon.apps.checkin.domain.NoCheckinUser;

public class CheckInInstallManagerImpl implements CheckInInstallManager {

	private CheckInInstallDao installdao;

	public CheckInInstallDao getInstalldao() {
		return installdao;
	}

	public void setInstalldao(CheckInInstallDao installdao) {
		this.installdao = installdao;
	}
	// 保存或更新考勤设置信息
	public void saveUpdateCheckinSet(CheckInInstall install){
		this.installdao.saveUpdateCheckinSet(install);
	}
	// 查询考勤设置信息
	public CheckInInstall searchCheckinSet(){
		return this.installdao.searchCheckinSet();
	}
	// 查询不打卡人信息
	public List<NoCheckinUser> searchNoCheckinUsers(){
		return this.installdao.searchNoCheckinUsers();
	}
	// 删除不打卡人信息
	public void deleteNoCheckinUsers(String uids){
		 this.installdao.deleteNoCheckinUsers(uids);
	}
	// 查询不打卡部门信息
	public List<NoCheckinDepart> searchNoCheckinDepartments(){
		return this.installdao.searchNoCheckinDepartments();
	}
	// 删除不打卡部门信息
	public void deleteNoCheckinDepartments(String dids){
		this.installdao.deleteNoCheckInDepartments(dids);
	}
	// 检查前一天的考勤信息
//	public void checkYesterdayCheckin(String ydate) {
//		this.installdao.checkYesterdayCheckin(ydate);
//	}
	public void checkYesterdayCheckin() {
		this.installdao.checkYesterdayCheckin();
	}

	public int updatecheckabnormal(String userid, String checkdate) {
		return this.installdao.updatecheckabnormal(userid, checkdate);
	}

	public List<CheckInInstall> selectffectivect() {
		return this.installdao.selectffectivect();
	}

	// 监听发起表单
	public void startUpForm() {
		this.installdao.startUpForm();
	}

	// 返回单位id
	public String getAccountId(String userId){
		return this.installdao.getAccountId(userId);
	}

}
