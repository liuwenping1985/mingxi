package com.seeyon.apps.checkin.domain;

import java.io.Serializable;

import com.seeyon.v3x.common.domain.BaseModel;

public class WorkDaySet extends BaseModel implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = -4516803256787175683L;
	private String org_account_id;//单位id
	private String is_work;//是否工作0:休息1:工作
	private String is_rest;//0:工作  1:休息  2:法定休息
	private String date_num;//日期2013/06/24
	private String week_num;////周几0,1,2,3,4,5,6
	private String year ;
	private String month;//
	public String getOrg_account_id() {
		return org_account_id;
	}
	public void setOrg_account_id(String org_account_id) {
		this.org_account_id = org_account_id;
	}
	public String getIs_work() {
		return is_work;
	}
	public void setIs_work(String is_work) {
		this.is_work = is_work;
	}
	public String getIs_rest() {
		return is_rest;
	}
	public void setIs_rest(String is_rest) {
		this.is_rest = is_rest;
	}
	public String getDate_num() {
		return date_num;
	}
	public void setDate_num(String date_num) {
		this.date_num = date_num;
	}
	public String getWeek_num() {
		return week_num;
	}
	public void setWeek_num(String week_num) {
		this.week_num = week_num;
	}
	public String getYear() {
		return year;
	}
	public void setYear(String year) {
		this.year = year;
	}
	public String getMonth() {
		return month;
	}
	public void setMonth(String month) {
		this.month = month;
	}
	
}
