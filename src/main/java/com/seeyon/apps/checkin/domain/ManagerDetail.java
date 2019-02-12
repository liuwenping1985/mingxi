package com.seeyon.apps.checkin.domain;

import java.io.Serializable;

import com.seeyon.v3x.common.domain.BaseModel;

/**
 * 查询查询明细
 * @author tianpengfei
 *
 */
public class ManagerDetail extends BaseModel implements Serializable {

	// 考勤管理 详细信息id
	private  String detid;
	// 上午打卡时间
	private String amtime;
	// 下午打卡时间
	private String pmtime;
	// 当天日期
	private String currentdate;
	//星期
	private String currentweek;
	//请假事由
	private String message;
	
	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public String getCurrentweek() {
		return currentweek;
	}

	public void setCurrentweek(String currentweek) {
		this.currentweek = currentweek;
	}

	public String getDetid() {
		return detid;
	}

	public void setDetid(String detid) {
		this.detid = detid;
	}

	public String getAmtime() {
		return amtime;
	}

	public void setAmtime(String amtime) {
		this.amtime = amtime;
	}

	public String getPmtime() {
		return pmtime;
	}

	public void setPmtime(String pmtime) {
		this.pmtime = pmtime;
	}

	public String getCurrentdate() {
		return currentdate;
	}

	public void setCurrentdate(String currentdate) {
		this.currentdate = currentdate;
	}
	
	
}
