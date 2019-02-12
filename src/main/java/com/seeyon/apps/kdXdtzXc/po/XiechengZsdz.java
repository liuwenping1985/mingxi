package com.seeyon.apps.kdXdtzXc.po;

import java.io.Serializable;

import com.seeyon.apps.kdXdtzXc.base.ann.ColField;
import com.seeyon.apps.kdXdtzXc.base.ann.POJO;

@POJO(desc = "携程住宿对账", tableName = "XIECHENG_ZSDZ")
public class XiechengZsdz implements Serializable{
	
	@ColField(name = "ID", colCode = "ID")
    private Long id;
	
	@ColField(name = "携程发起对帐信息住宿ID", colCode = "XIECHENG_FQDZXX_ZS_ID")
    private Long xiechengFqdzxxZsId;
	
	@ColField(name = "申请单编号", colCode = "JOURNEY_ID")
    private String journeyId;
	
	@ColField(name = "预住人姓名", colCode = "CLIENT_NAME")
    private String clientName;
	
	@ColField(name = "酒店所在城市", colCode = "CITY_NAME")
    private String cityName;
	
	@ColField(name = "酒店名称", colCode = "HOTEL_NAME")
    private String hotelName;
	
	@ColField(name = "酒店类型", colCode = "HOTEL_TYPE")
    private String hotelType;
	
	@ColField(name = "房间类型", colCode = "ROOM_NAME")
    private String roomName;
	
	@ColField(name = "预入住日期", colCode = "START_TIME")
    private String startTime;
	
	@ColField(name = "预离店日期", colCode = "END_TIME")
    private String endTime;
	
	@ColField(name = "夜间数", colCode = "QUANTITY")
    private String quantity;
	
	@ColField(name = "单价", colCode = "PRICE")
    private String price;
	
	@ColField(name = "费用", colCode = "AMOUNT")
    private String amount;
	
	@ColField(name = "费用类型", colCode = "FEE_TYPE")
    private String feeType;
	
	@ColField(name = "备注", colCode = "REMARKS")
    private String remarks;
	
	@ColField(name = "创建时间", colCode = "CREATE_TIME")
    private String createTime;
	
	@ColField(name = "预留字段1", colCode = "EXT_ATTR_1")
    private String extAttr1;
	
	@ColField(name = "员工编号", colCode = "EMPLOYEEID")
    private String employeeID;
	
	@ColField(name = "预留字段3", colCode = "EXT_ATTR_3")
    private String extAttr3;
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

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getXiechengFqdzxxZsId() {
		return xiechengFqdzxxZsId;
	}

	public void setXiechengFqdzxxZsId(Long xiechengFqdzxxZsId) {
		this.xiechengFqdzxxZsId = xiechengFqdzxxZsId;
	}

	public String getJourneyId() {
		return journeyId;
	}

	public void setJourneyId(String journeyId) {
		this.journeyId = journeyId;
	}

	public String getClientName() {
		return clientName;
	}

	public void setClientName(String clientName) {
		this.clientName = clientName;
	}

	public String getCityName() {
		return cityName;
	}

	public void setCityName(String cityName) {
		this.cityName = cityName;
	}

	public String getHotelName() {
		return hotelName;
	}

	public void setHotelName(String hotelName) {
		this.hotelName = hotelName;
	}

	public String getHotelType() {
		return hotelType;
	}

	public void setHotelType(String hotelType) {
		this.hotelType = hotelType;
	}

	public String getRoomName() {
		return roomName;
	}

	public void setRoomName(String roomName) {
		this.roomName = roomName;
	}

	public String getStartTime() {
		return startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public String getQuantity() {
		return quantity;
	}

	public void setQuantity(String quantity) {
		this.quantity = quantity;
	}

	public String getPrice() {
		return price;
	}

	public void setPrice(String price) {
		this.price = price;
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

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
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
