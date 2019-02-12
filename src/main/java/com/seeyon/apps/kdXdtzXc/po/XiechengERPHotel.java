package com.seeyon.apps.kdXdtzXc.po;

import com.seeyon.apps.kdXdtzXc.base.ann.ColField;

/**
 *财务系统酒店结算明细 :  ERPHotel - ERPHotel
 */
public class XiechengERPHotel {
		//预入住人
		private String clientName;
		//酒店所在城市
		private String cityName;
		//酒店名称
		private String hotelName;
		//酒店类型
		private String hotelType;
		//房间类型
		private String roomName;
		//预入住日期
		private String startTime;
		//预离店日期
		private String endTime;
		//间夜数
		private Integer quantity;
		//单价
		private Double price;
		//费用
		private Double amount;
		//备注
		private String remarks;
		//关联行程单号
		private String hotelRelatedJourneyNo;
		//员工编号
		private String employeeID;
		
		private String createTime;
		@ColField(name = "携程订单号", colCode = "orderID")
		private String orderID;
		@ColField(name = "携程id", colCode = "recordId")
		private String recordId;
		@ColField(name = "携程订单批次号", colCode = "accCheckBatchNo")
		private String accCheckBatchNo;
		
		
		public String getOrderID() {
			return orderID;
		}
		public void setOrderID(String orderID) {
			this.orderID = orderID;
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
		public String getEmployeeID() {
			return employeeID;
		}
		public void setEmployeeID(String employeeID) {
			this.employeeID = employeeID;
		}
		public String getHotelType() {
			return hotelType;
		}
		public void setHotelType(String hotelType) {
			this.hotelType = hotelType;
		}
		public Integer getQuantity() {
			return quantity;
		}
		public void setQuantity(Integer quantity) {
			this.quantity = quantity;
		}
		public Double getPrice() {
			return price;
		}
		public void setPrice(Double price) {
			this.price = price;
		}
		public Double getAmount() {
			return amount;
		}
		public void setAmount(Double amount) {
			this.amount = amount;
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
		public String getRoomName() {
			return roomName;
		}
		public void setRoomName(String roomName) {
			this.roomName = roomName;
		}
		public String getRemarks() {
			return remarks;
		}
		public void setRemarks(String remarks) {
			this.remarks = remarks;
		}
		public String getClientName() {
			return clientName;
		}
		public void setClientName(String clientName) {
			this.clientName = clientName;
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
		
		public String getHotelRelatedJourneyNo() {
			return hotelRelatedJourneyNo;
		}
		public void setHotelRelatedJourneyNo(String hotelRelatedJourneyNo) {
			this.hotelRelatedJourneyNo = hotelRelatedJourneyNo;
		}
		public String getCreateTime() {
			return createTime;
		}
		public void setCreateTime(String createTime) {
			this.createTime = createTime;
		}
		@Override
		public String toString() {
			return "XiechengERPHotel [" + (clientName != null ? "clientName=" + clientName + ", " : "") + (cityName != null ? "cityName=" + cityName + ", " : "") + (hotelName != null ? "hotelName=" + hotelName + ", " : "") + (hotelType != null ? "hotelType=" + hotelType + ", " : "") + (roomName != null ? "roomName=" + roomName + ", " : "") + (startTime != null ? "startTime=" + startTime + ", " : "") + (endTime != null ? "endTime=" + endTime + ", " : "") + (quantity != null ? "quantity=" + quantity + ", " : "") + (price != null ? "price=" + price + ", " : "") + (amount != null ? "amount=" + amount + ", " : "") + (remarks != null ? "remarks=" + remarks + ", " : "") + (hotelRelatedJourneyNo != null ? "hotelRelatedJourneyNo=" + hotelRelatedJourneyNo + ", " : "") + (employeeID != null ? "employeeID=" + employeeID + ", " : "") + (createTime != null ? "createTime=" + createTime + ", " : "") + (orderID != null ? "orderID=" + orderID + ", " : "")
					+ (recordId != null ? "recordId=" + recordId + ", " : "") + (accCheckBatchNo != null ? "accCheckBatchNo=" + accCheckBatchNo : "") + "]";
		}
		
		
		
	
}
