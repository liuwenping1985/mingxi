package com.seeyon.apps.checkin.domain;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Date;

import com.seeyon.v3x.common.domain.BaseModel;

/**
 * 员工打卡
 * @author administrator
 * @since 2013-06-13
 */
public class InitCheckIn extends BaseModel implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long id;
	
	//上午打卡时间
	private Timestamp checkStartTime;
	
	//下午打卡时间
	private Timestamp checkEndTime;
	
	//打卡日期
	private Date checkdate;
	
	//打卡时间
	private Timestamp checkTime;
	
	//用户id
	private String userId;
	
	//打卡标识（0：正常、1：异常）
	private String flag;
	
	//星期
	private String week;
	
	//请假类型
	private String leaveType;
	
	//请假类型天数
	private double debugday;
	
	//迟到早退标志 1：迟到早退  0：非迟到早退
	private String lateflag;
	
	//迟到早退次数
	private int lateNum;

	//上午打卡有效开始
	private String amstarttime;
	
	//上午打卡有效结束
	private String amendtime;
	
	//下午打卡有效开始
	private String pmstarttime;
	
	//下午打卡有效结束
	private String pmendtime;
	
	// IP
	private String ip;
	
	// mac地址
	private String mac ;
	
	public int getLateNum() {
		return lateNum;
	}

	public void setLateNum(int lateNum) {
		this.lateNum = lateNum;
	}

	public String getAmstarttime() {
		return amstarttime;
	}

	public void setAmstarttime(String amstarttime) {
		this.amstarttime = amstarttime;
	}

	public String getAmendtime() {
		return amendtime;
	}

	public void setAmendtime(String amendtime) {
		this.amendtime = amendtime;
	}

	public String getPmstarttime() {
		return pmstarttime;
	}

	public void setPmstarttime(String pmstarttime) {
		this.pmstarttime = pmstarttime;
	}

	public String getPmendtime() {
		return pmendtime;
	}

	public void setPmendtime(String pmendtime) {
		this.pmendtime = pmendtime;
	}

	public String getLateflag() {
		return lateflag;
	}

	public void setLateflag(String lateflag) {
		this.lateflag = lateflag;
	}

	public double getDebugday() {
		return debugday;
	}

	public void setDebugday(double debugday) {
		this.debugday = debugday;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Timestamp getCheckStartTime() {
		return checkStartTime;
	}

	public void setCheckStartTime(Timestamp checkStartTime) {
		this.checkStartTime = checkStartTime;
	}

	public Timestamp getCheckEndTime() {
		return checkEndTime;
	}

	public void setCheckEndTime(Timestamp checkEndTime) {
		this.checkEndTime = checkEndTime;
	}

	public Date getCheckdate() {
		return checkdate;
	}

	public void setCheckdate(Date checkdate) {
		this.checkdate = checkdate;
	}

	public Timestamp getCheckTime() {
		return checkTime;
	}

	public void setCheckTime(Timestamp checkTime) {
		this.checkTime = checkTime;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getFlag() {
		return flag;
	}

	public void setFlag(String flag) {
		this.flag = flag;
	}

	public String getWeek() {
		return week;
	}

	public void setWeek(String week) {
		this.week = week;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getLeaveType() {
		return leaveType;
	}

	public void setLeaveType(String leaveType) {
		this.leaveType = leaveType;
	}

	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public String getMac() {
		return mac;
	}

	public void setMac(String mac) {
		this.mac = mac;
	}
	
}
