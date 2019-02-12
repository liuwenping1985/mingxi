package com.seeyon.apps.kdXdtzXc.po;

import java.io.Serializable;

/**
 * 财务补助数据实体
 * @author 13161
 *
 */
public class CwBuzhuDateModel implements Serializable {

	public static String className = CwBuzhuDateModel.class.getName();
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String id;
	/**
	 * 业务来源
	 */
	private String source;
	/**
	 * 申请单编号
	 */
	private String applOrderCode;
	/**
	 * 申请人编码
	 */
	private String applUserCode; 
	/**
	 * 出差人编码
	 */
	private String employeeCode;
	/**
	 * 机构编码
	 */
	private String comCode;
	/**
	 * 受益部门编码
	 */
	private String deptCode;
	/**
	 * 成本中心(申请人部门)编码
	 */
	private String costCenter;
	/**
	 * 项目编码
	 */
	private String projectCode;
	/**
	 * 出差日期自	YYYY-MM-DD
	 */
	private String dateFrom;
	/**
	 * 出差日期至 YYYY-MM-DD
	 */
	private String  dateTo;
	/**
	 * 出差天数
	 */
	private String leaveNum;
	/**
	 * 补贴天数
	 */
	private String  allowNum;
	/**
	 * 非补贴天数
	 */
	private String nonAllowNum;
	/**
	 * 出差地点（入住酒店的城市）
	 */
	private String leaveSite;
	/**
	 * 出差地区类型 A(香港)、B(西藏\青海)、C(一般地区) 三种类型
	 */
	private String locationType;
	/**
	 * 币种默认‘CNY’
	 */
	private String  currency;
	/**
	 * 出差地点（目地的城市）
	 */
	private String  leaveSite2;
	/**
	 * 董监事标识 Y(yes); N(no) 
	 */
	private String dsFlag;
	/**
	 * OA主键 申请单编号+出差人员编码+地区类型
	 */
	private String  oaKey;
	/**
	 * 出差性质
	 */
	private String traveldescription;
	/**
	 * 备注
	 */
	private String  description;
	/**
	 * 创建时间
	 */
	private String createDate;
	/**
	 * 扩展字段
	 */
	private String attribute1;
	/**
	 * 扩展字段
	 */
	private String attribute2;
	/**
	 * 扩展字段
	 */
	private String attribute3;
	/**
	 * 扩展字段
	 */
	private String attribute4;
	/**
	 * 扩展字段
	 */
	private String attribute5;
	/**
	 * 扩展字段
	 */
	private String attribute6;
	
	
	
	
	public String getTraveldescription() {
		return traveldescription;
	}
	public void setTraveldescription(String traveldescription) {
		this.traveldescription = traveldescription;
	}
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getSource() {
		return source;
	}
	public void setSource(String source) {
		this.source = source;
	}
	public String getApplOrderCode() {
		return applOrderCode;
	}
	public void setApplOrderCode(String applOrderCode) {
		this.applOrderCode = applOrderCode;
	}
	public String getApplUserCode() {
		return applUserCode;
	}
	public void setApplUserCode(String applUserCode) {
		this.applUserCode = applUserCode;
	}
	public String getEmployeeCode() {
		return employeeCode;
	}
	public void setEmployeeCode(String employeeCode) {
		this.employeeCode = employeeCode;
	}
	public String getComCode() {
		return comCode;
	}
	public void setComCode(String comCode) {
		this.comCode = comCode;
	}
	public String getDeptCode() {
		return deptCode;
	}
	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
	}
	public String getCostCenter() {
		return costCenter;
	}
	public void setCostCenter(String costCenter) {
		this.costCenter = costCenter;
	}
	public String getProjectCode() {
		return projectCode;
	}
	public void setProjectCode(String projectCode) {
		this.projectCode = projectCode;
	}
	public String getDateFrom() {
		return dateFrom;
	}
	public void setDateFrom(String dateFrom) {
		this.dateFrom = dateFrom;
	}
	public String getDateTo() {
		return dateTo;
	}
	public void setDateTo(String dateTo) {
		this.dateTo = dateTo;
	}
	public String getLeaveNum() {
		return leaveNum;
	}
	public void setLeaveNum(String leaveNum) {
		this.leaveNum = leaveNum;
	}
	public String getAllowNum() {
		return allowNum;
	}
	public void setAllowNum(String allowNum) {
		this.allowNum = allowNum;
	}
	public String getNonAllowNum() {
		return nonAllowNum;
	}
	public void setNonAllowNum(String nonAllowNum) {
		this.nonAllowNum = nonAllowNum;
	}
	public String getLeaveSite() {
		return leaveSite;
	}
	public void setLeaveSite(String leaveSite) {
		this.leaveSite = leaveSite;
	}
	public String getLocationType() {
		return locationType;
	}
	public void setLocationType(String locationType) {
		this.locationType = locationType;
	}
	public String getCurrency() {
		return currency;
	}
	public void setCurrency(String currency) {
		this.currency = currency;
	}
	public String getLeaveSite2() {
		return leaveSite2;
	}
	public void setLeaveSite2(String leaveSite2) {
		this.leaveSite2 = leaveSite2;
	}
	public String getDsFlag() {
		return dsFlag;
	}
	public void setDsFlag(String dsFlag) {
		this.dsFlag = dsFlag;
	}
	public String getOaKey() {
		return oaKey;
	}
	public void setOaKey(String oaKey) {
		this.oaKey = oaKey;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getAttribute1() {
		return attribute1;
	}
	public void setAttribute1(String attribute1) {
		this.attribute1 = attribute1;
	}
	public String getAttribute2() {
		return attribute2;
	}
	public void setAttribute2(String attribute2) {
		this.attribute2 = attribute2;
	}
	public String getAttribute3() {
		return attribute3;
	}
	public void setAttribute3(String attribute3) {
		this.attribute3 = attribute3;
	}
	public String getAttribute4() {
		return attribute4;
	}
	public void setAttribute4(String attribute4) {
		this.attribute4 = attribute4;
	}
	public String getAttribute5() {
		return attribute5;
	}
	public void setAttribute5(String attribute5) {
		this.attribute5 = attribute5;
	}
	public String getAttribute6() {
		return attribute6;
	}
	public void setAttribute6(String attribute6) {
		this.attribute6 = attribute6;
	}


	public CwBuzhuDateModel(String id, String source, String applOrderCode, String applUserCode, String employeeCode, String comCode, String deptCode, String costCenter, String projectCode, String dateFrom, String dateTo, String leaveNum, String allowNum, String nonAllowNum, String leaveSite, String locationType, String currency, String leaveSite2, String dsFlag,  String oaKey, String traveldescription,String description, String createDate, String attribute1, String attribute2, String attribute3, String attribute4, String attribute5, String attribute6) {
		super();
		this.id = id;
		this.source = source;
		this.applOrderCode = applOrderCode;
		this.applUserCode = applUserCode;
		this.employeeCode = employeeCode;
		this.comCode = comCode;
		this.deptCode = deptCode;
		this.costCenter = costCenter;
		this.projectCode = projectCode;
		this.dateFrom = dateFrom;
		this.dateTo = dateTo;
		this.leaveNum = leaveNum;
		this.allowNum = allowNum;
		this.nonAllowNum = nonAllowNum;
		this.leaveSite = leaveSite;
		this.locationType = locationType;
		this.currency = currency;
		this.leaveSite2 = leaveSite2;
		this.dsFlag = dsFlag;
		this.oaKey = oaKey;
		this.traveldescription = traveldescription;
		this.description = description;
		this.createDate = createDate;
		this.attribute1 = attribute1;
		this.attribute2 = attribute2;
		this.attribute3 = attribute3;
		this.attribute4 = attribute4;
		this.attribute5 = attribute5;
		this.attribute6 = attribute6;
	}
	public CwBuzhuDateModel() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	
	
}
