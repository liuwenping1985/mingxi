package com.seeyon.apps.checkin.manager;

import java.util.HashMap;
import java.util.List;

import com.seeyon.apps.checkin.dao.InitCheckInDao;
import com.seeyon.apps.checkin.domain.InitCheckIn;

public class InitCheckInManagerImpl implements InitCheckInManager {

	private InitCheckInDao checkdao;

	public InitCheckInDao getCheckdao() {
		return checkdao;
	}

	public void setCheckdao(InitCheckInDao checkdao) {
		this.checkdao = checkdao;
	}

	/**
	 * 保存打卡记录
	 * 
	 * @param check
	 * @return String
	 *               -1:打卡失败
	 *               0:正常打卡
	 *               1:异常打卡
	 *               2:不打卡部门
	 *               3:不打卡人
	 *               4:休息日，无需打卡
	 */
	public String saveInit(InitCheckIn check) {
		return this.checkdao.savecheck(check);
	}

	/**
	 * 查看所有的原始记录
	 * 
	 * @return
	 */
	public List<InitCheckIn> findInitAll(String userid) {
		return this.checkdao.findCheckInAll(userid);
	}

	/**
	 * 查询当天打卡的详细信息
	 * 
	 * @param checkdate
	 * @return
	 */
	public List<InitCheckIn> findDetail(String checkdate, String userid) {
		return this.checkdao.findDetail(checkdate, userid);
	}

	/**
	 * 根据条件，查询用户的打卡记录
	 */
	public List<InitCheckIn> findInitAll(String stime, String etime, String flag, String userid, String leaveType) {
		return this.checkdao.findCheckInAll(stime, etime, flag, userid, leaveType);
	}
	/**
	 * 查询请假类别
	 * @return
	 */
	public HashMap<String, String> findLeaveType() {
		return this.checkdao.findLeaveType();
	}

	@Override
	public boolean chenkIp(String ip) {
		return this.checkdao.chenkIp(ip);
	}

	@Override
	public String findUserIdbyloginName(String loginName) {
		return this.checkdao.findUserIdbyloginName(loginName);
	}
}
