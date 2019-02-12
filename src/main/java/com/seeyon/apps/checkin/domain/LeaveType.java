package com.seeyon.apps.checkin.domain;

import java.io.Serializable;

import com.seeyon.v3x.common.domain.BaseModel;
/**
 * 不打卡类别
 * @author administrator
 * @since 2013-06-15
 */
public class LeaveType  extends BaseModel implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	//请假类别id
	public String leaveId ;
	//请假类别名称
	public String leaveType ;
	
	public String getLeaveId() {
		return leaveId;
	}
	public void setLeaveId(String leaveId) {
		this.leaveId = leaveId;
	}
	public String getLeaveType() {
		return leaveType;
	}
	public void setLeaveType(String leaveType) {
		this.leaveType = leaveType;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
}
