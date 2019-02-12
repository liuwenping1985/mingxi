package com.seeyon.apps.checkin.domain;

/**
 * 考勤异常
 * @author yangli
 *
 */
public class CheckJournal {

	//userid
	private String  userid;
	//发起时间
	private String start_date;
	//考勤日期
	private String  checkdate;
	//考勤异常类型
	private String leavetype;
	//上午上班
	private String amtime;
	//下午下班
	private String pmtime;
	
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getStart_date() {
		return start_date;
	}
	public void setStart_date(String start_date) {
		this.start_date = start_date;
	}
	public String getCheckdate() {
		return checkdate;
	}
	public void setCheckdate(String checkdate) {
		this.checkdate = checkdate;
	}
	public String getLeavetype() {
		return leavetype;
	}
	public void setLeavetype(String leavetype) {
		this.leavetype = leavetype;
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

}
