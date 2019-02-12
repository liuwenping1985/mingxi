package com.seeyon.apps.checkin.domain;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Date;

import com.seeyon.v3x.common.domain.BaseModel;

/**
 * 考勤设置
 * @author administrator
 * @since 2013-06-13
 */
public class CheckInInstall extends BaseModel implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long id ;
	
	//上午打卡开始时间
	private String amStartTime;
	
	//上午打卡结束时间
	private String amEndTime;
	
	//下午打卡开始时间
	private String pmStartTime;
	
	//下午打卡结束时间
	private String pmEndTime;
	
	//打卡网段开始
	private String scheckinIp;
	
	//打卡网段结束 
	private String echeckinIp;
	
	//异常处理时间
	private String errorTime;
	
	//流程发起时间
	private String processStartTime;
	
	//流程审批时间
	private String approvalTime;
	
	//不打卡部门(名称字符串)
	private String notCheckInDepartment;
	
	//不打卡部门(id字符串)
	private String notCheckInDepartmentId;
	
	//不打卡人员(名称字符串)
	private String notCheckInPerson;
	
	//不打卡人员(名称字符串)
	private String notCheckInPersonId;
	
	
	
		//[notstatic]打卡部门(名称字符串)
		private String notStaticCheckInDepartment;
		
		//[notstatic]打卡部门(id字符串)
		private String notStaticCheckInDepartmentId;
		
		public String getNotStaticCheckInDepartment() {
			return notStaticCheckInDepartment;
		}

		public void setNotStaticCheckInDepartment(String notStaticCheckInDepartment) {
			this.notStaticCheckInDepartment = notStaticCheckInDepartment;
		}

		public String getNotStaticCheckInDepartmentId() {
			return notStaticCheckInDepartmentId;
		}

		public void setNotStaticCheckInDepartmentId(String notStaticCheckInDepartmentId) {
			this.notStaticCheckInDepartmentId = notStaticCheckInDepartmentId;
		}

		public String getNotStaticCheckInPerson() {
			return notStaticCheckInPerson;
		}

		public void setNotStaticCheckInPerson(String notStaticCheckInPerson) {
			this.notStaticCheckInPerson = notStaticCheckInPerson;
		}

		public String getNotStaticCheckInPersonId() {
			return notStaticCheckInPersonId;
		}

		public void setNotStaticCheckInPersonId(String notStaticCheckInPersonId) {
			this.notStaticCheckInPersonId = notStaticCheckInPersonId;
		}

		//[notstatic]打卡人员(名称字符串)
		private String notStaticCheckInPerson;
		
		//[notstatic]打卡人员(名称字符串)
		private String notStaticCheckInPersonId;
		
	// 员工id
	private String userId;
	
	// 员工姓名
	private String userName;
	
	// 员工编号
	private String userCode;
	
	// 部门名称
	private String orgName;
	
	// 异常创建时间
	private Timestamp createTime;
	
	// 打卡日期
	private Date checkDate ;
	
	//上午打卡时间
	private Timestamp checkStartTime;
	
	//下午打卡时间
	private Timestamp checkEndTime;
	
	// 审批标志
	private String appFlg;
	
	public String getAppFlg() {
		return appFlg;
	}

	public void setAppFlg(String appFlg) {
		this.appFlg = appFlg;
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

	public String getUserCode() {
		return userCode;
	}

	public void setUserCode(String userCode) {
		this.userCode = userCode;
	}

	public Date getCheckDate() {
		return checkDate;
	}

	public void setCheckDate(Date checkDate) {
		this.checkDate = checkDate;
	}

	public Timestamp getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Timestamp createTime) {
		this.createTime = createTime;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
	
	public String getAmStartTime() {
		return amStartTime;
	}
	
	public void setAmStartTime(String amStartTime) {
		this.amStartTime = amStartTime;
	}
	
	public String getAmEndTime() {
		return amEndTime;
	}
	
	public void setAmEndTime(String amEndTime) {
		this.amEndTime = amEndTime;
	}

	public String getPmStartTime() {
		return pmStartTime;
	}

	public void setPmStartTime(String pmStartTime) {
		this.pmStartTime = pmStartTime;
	}

	public String getPmEndTime() {
		return pmEndTime;
	}

	public void setPmEndTime(String pmEndTime) {
		this.pmEndTime = pmEndTime;
	}

	public String getScheckinIp() {
		return scheckinIp;
	}

	public void setScheckinIp(String scheckinIp) {
		this.scheckinIp = scheckinIp;
	}

	public String getEcheckinIp() {
		return echeckinIp;
	}

	public void setEcheckinIp(String echeckinIp) {
		this.echeckinIp = echeckinIp;
	}

	public String getErrorTime() {
		return errorTime;
	}

	public void setErrorTime(String errorTime) {
		this.errorTime = errorTime;
	}

	public String getProcessStartTime() {
		return processStartTime;
	}

	public void setProcessStartTime(String processStartTime) {
		this.processStartTime = processStartTime;
	}

	public String getApprovalTime() {
		return approvalTime;
	}

	public void setApprovalTime(String approvalTime) {
		this.approvalTime = approvalTime;
	}

	public String getNotCheckInDepartment() {
		return notCheckInDepartment;
	}

	public void setNotCheckInDepartment(String notCheckInDepartment) {
		this.notCheckInDepartment = notCheckInDepartment;
	}

	public String getNotCheckInPerson() {
		return notCheckInPerson;
	}

	public void setNotCheckInPerson(String notCheckInPerson) {
		this.notCheckInPerson = notCheckInPerson;
	}

	public String getNotCheckInDepartmentId() {
		return notCheckInDepartmentId;
	}


	public void setNotCheckInDepartmentId(String notCheckInDepartmentId) {
		this.notCheckInDepartmentId = notCheckInDepartmentId;
	}

	public String getNotCheckInPersonId() {
		return notCheckInPersonId;
	}

	public void setNotCheckInPersonId(String notCheckInPersonId) {
		this.notCheckInPersonId = notCheckInPersonId;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
}
