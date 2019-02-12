package com.seeyon.apps.kdXdtzXc.po;

import java.io.Serializable;

import com.seeyon.apps.kdXdtzXc.base.ann.ColField;
import com.seeyon.apps.kdXdtzXc.base.ann.POJO;

@POJO(desc = "财务交通对账", tableName = "CAIWU_JTDZ")
public class CaiwuJtdz implements Serializable{
	
	@ColField(name = "ID", colCode = "ID")
    private Long id;
	
	@ColField(name = "申请单编号", colCode = "JOURNEY_ID")
    private String journeyId;
	
	@ColField(name = "部门", colCode = "DEPT")
    private String dept;
	
	@ColField(name = "乘机人姓名", colCode = "PASSENGER_NAME")
    private String passengerName;
	
	@ColField(name = "职务", colCode = "ZW")
    private String zw;
	
	@ColField(name = "起飞时间", colCode = "TAKEOFF_TIME")
    private String takeoffTime;
	
	@ColField(name = "到达时间", colCode = "ARRIVAL_TIME")
    private String arrivalTime;
	
	@ColField(name = "出发城市", colCode = "DCITY_NAME")
    private String dcityName;
	
	@ColField(name = "到达城市", colCode = "ACITY_NAME")
    private String acityName;
	
	@ColField(name = "航班号", colCode = "FLIGHT")
    private String flight;
	
	@ColField(name = "航位", colCode = "CLASS_NAME")
    private String className;
	
	@ColField(name = "费用", colCode = "AMOUNT")
    private String amount;
	
	@ColField(name = "费用类型", colCode = "FEE_TYPE")
    private String feeType;
	
	@ColField(name = "备注", colCode = "REMARK")
    private String remark;
	
	@ColField(name = "员工行程确认", colCode = "YGXC_QR")
    private String ygxcQr;
	
	@ColField(name = "支付确认", colCode = "ZF_QR")
    private String zfQr;
	
	@ColField(name = "合规校验", colCode = "HGJX")
    private String hgjx;
	
	@ColField(name = "手动合规校验", colCode = "SGhgjx")
    private String sGhgjx;
	
	@ColField(name = "创建时间", colCode = "CREATE_TIME")
    private String createTime;
	
	@ColField(name = "预留字段1", colCode = "EXT_ATTR_1")
    private String extAttr1;
	
	@ColField(name = "预留字段2", colCode = "EXT_ATTR_2")
    private String extAttr2;
	
	@ColField(name = "预留字段3", colCode = "EXT_ATTR_3")
    private String extAttr3; //机构编码
	
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

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getJourneyId() {
		return journeyId;
	}

	public void setJourneyId(String journeyId) {
		this.journeyId = journeyId;
	}

	public String getDept() {
		return dept;
	}

	public void setDept(String dept) {
		this.dept = dept;
	}

	public String getPassengerName() {
		return passengerName;
	}

	public void setPassengerName(String passengerName) {
		this.passengerName = passengerName;
	}

	public String getZw() {
		return zw;
	}

	public void setZw(String zw) {
		this.zw = zw;
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

	public String getYgxcQr() {
		return ygxcQr;
	}

	public void setYgxcQr(String ygxcQr) {
		this.ygxcQr = ygxcQr;
	}

	public String getZfQr() {
		return zfQr;
	}

	public void setZfQr(String zfQr) {
		this.zfQr = zfQr;
	}

	public String getHgjx() {
		return hgjx;
	}

	public void setHgjx(String hgjx) {
		this.hgjx = hgjx;
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

	public String getExtAttr2() {
		return extAttr2;
	}

	public void setExtAttr2(String extAttr2) {
		this.extAttr2 = extAttr2;
	}

	public String getExtAttr3() {
		return extAttr3;
	}

	public void setExtAttr3(String extAttr3) {
		this.extAttr3 = extAttr3;
	}

	public String getsGhgjx() {
		return sGhgjx;
	}

	public void setsGhgjx(String sGhgjx) {
		this.sGhgjx = sGhgjx;
	}

}
