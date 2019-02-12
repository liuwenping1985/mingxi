package com.seeyon.apps.checkin.domain;

/**
 * 告知请假
 * @author webrx
 *
 */
public class LeaveJournal {
	//发起人id
	private String start_member_id;
	//发起时间
	private String start_date;
	//请假类型
	private String field0006;
	//签字日期
	private String field0010;
	
	public String getStart_member_id() {
		return start_member_id;
	}
	public void setStart_member_id(String start_member_id) {
		this.start_member_id = start_member_id;
	}
	public String getStart_date() {
		return start_date;
	}
	public void setStart_date(String start_date) {
		this.start_date = start_date;
	}
	public String getField0006() {
		return field0006;
	}
	public void setField0006(String field0006) {
		this.field0006 = field0006;
	}
	public String getField0010() {
		return field0010;
	}
	public void setField0010(String field0010) {
		this.field0010 = field0010;
	}
	
}
