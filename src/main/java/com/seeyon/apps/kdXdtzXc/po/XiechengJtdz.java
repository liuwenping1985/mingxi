package com.seeyon.apps.kdXdtzXc.po;

import java.io.Serializable;

import com.seeyon.apps.kdXdtzXc.base.ann.ColField;
import com.seeyon.apps.kdXdtzXc.base.ann.POJO;

@POJO(desc = "携程交通对账", tableName = "XIECHENG_JTDZ")
public class XiechengJtdz implements Serializable {

	@ColField(name = "ID", colCode = "ID")
	private Long id;
	
	@ColField(name = "外键ID", colCode = "XIECHENG_FQDZXX_JT_ID")
	private Long xiechengFqdzxxJtId;
	
	//申请单编号
	@ColField(name = "申请单编号", colCode = "JOURNEY_ID")
	private String journeyId;
	//乘机人姓名
	@ColField(name = "乘机人姓名", colCode = "PASSENGER_NAME")
	private String passengerName;
	//起飞时间
	@ColField(name = "起飞时间", colCode = "TAKEOFF_TIME")
	private String takeoffTime;
	//到达时间
	@ColField(name = "到达时间", colCode = "ARRIVAL_TIME")
	private String arrivalTime;
	//出发城市
	@ColField(name = "出发城市", colCode = "DCITY_NAME")
	private String dcityName;
	//到达城市
	@ColField(name = "到达城市", colCode = "ACITY_NAME")
	private String acityName;
	//航班号
	@ColField(name = "航班号", colCode = "FLIGHT")
	private String flight;
	//航位
	@ColField(name = "航位", colCode = "CLASS_NAME")
	private String className;
	//费用
	@ColField(name = "费用", colCode = "AMOUNT")
	private String amount;
	//费用类型
	@ColField(name = "费用类型", colCode = "FEE_TYPE")
	private String feeType;
	//备注
	@ColField(name = "备注", colCode = "REMARK")
	private String remark;
	//创建时间
	@ColField(name = "创建时间", colCode = "CREATE_TIME")
	private String createTime;
	
	@ColField(name = "预留字段1", colCode = "EXT_ATTR_1")
    private String extAttr1;
	
	@ColField(name = "员工编号", colCode = "EMPLOYEEID")
    private String employeeID;
	
	@ColField(name = "预留字段3", colCode = "EXT_ATTR_3")
    private String extAttr3;//机构类别
	
	@ColField(name = "携程订单号", colCode = "orderId")
	private String orderId;
	@ColField(name = "携程id", colCode = "recordId")
	private String recordId;
	@ColField(name = "携程订单批次号", colCode = "accCheckBatchNo")
	private String accCheckBatchNo;
	

	
	
	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public String getRecordId() {
		return recordId;
	}

	public void setRecordId(String recordId) {
		this.recordId = recordId;
	}

	public String getAccCheckBatchNo() {
		return accCheckBatchNo;
	}

	public void setAccCheckBatchNo(String accCheckBatchNo) {
		this.accCheckBatchNo = accCheckBatchNo;
	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}
	public Long getXiechengFqdzxxJtId() {
		return xiechengFqdzxxJtId;
	}

	public void setXiechengFqdzxxJtId(Long xiechengFqdzxxJtId) {
		this.xiechengFqdzxxJtId = xiechengFqdzxxJtId;
	}

	public String getJourneyId() {
		return journeyId;
	}

	public void setJourneyId(String journeyId) {
		this.journeyId = journeyId;
	}

	public String getPassengerName() {
		return passengerName;
	}

	public void setPassengerName(String passengerName) {
		this.passengerName = passengerName;
	}

	public String getTakeoffTime() {
		return takeoffTime;
	}

	public void setTakeoffTime(String takeoffTime) {
		this.takeoffTime = takeoffTime;
	}

	public String getArrivalTime() {
		return arrivalTime;
	}

	public void setArrivalTime(String arrivalTime) {
		this.arrivalTime = arrivalTime;
	}

	public String getDcityName() {
		return dcityName;
	}

	public void setDcityName(String dcityName) {
		this.dcityName = dcityName;
	}

	public String getAcityName() {
		return acityName;
	}

	public void setAcityName(String acityName) {
		this.acityName = acityName;
	}

	public String getFlight() {
		return flight;
	}

	public void setFlight(String flight) {
		this.flight = flight;
	}

	public String getClassName() {
		return className;
	}

	public void setClassName(String className) {
		this.className = className;
	}

	public String getAmount() {
		return amount;
	}

	public void setAmount(String amount) {
		this.amount = amount;
	}

	public String getFeeType() {
		return feeType;
	}

	public void setFeeType(String feeType) {
		this.feeType = feeType;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getCreateTime() {
		return createTime;
	}

	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}

	public String getExtAttr1() {
		return extAttr1;
	}

	public void setExtAttr1(String extAttr1) {
		this.extAttr1 = extAttr1;
	}

	public String getEmployeeID() {
		return employeeID;
	}

	public void setEmployeeID(String employeeID) {
		this.employeeID = employeeID;
	}

	public String getExtAttr3() {
		return extAttr3;
	}

	public void setExtAttr3(String extAttr3) {
		this.extAttr3 = extAttr3;
	}

}
