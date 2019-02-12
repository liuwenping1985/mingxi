package com.seeyon.apps.kdXdtzXc.po;

import com.seeyon.apps.kdXdtzXc.base.ann.ColField;

/**
 *财务系统机票结算明细 :  ERPFlight - ERPFlight
 */
public class XiechengERPFlight  {

		//订单号
		private String journeyID;
		//乘客姓名
		private String passengerName;
		//起飞时间
		private String takeoffTime;
		//到达时间
		private String arrivalTime;
		//出发城市
		private String dCityName;
		//到达城市
		private String aCityName;
		//航班号
		private String flight;
		//费用类型
		private String feeType;
		//备注
		private String remark;
		//舱位
		private String className;
		//费用
		private Double amount;
		//改签服务费
		private Double reBookingServiceFee;
		//改签费
		private Double rebookQueryFee;
		//退票费
		private Double refund;
		
		//退票服务费
		private Double refundServiceFee;
		
		//退改签
		private String orderDetailType;
		
		//员工编号
		private String employeeID;
		
		private String createTime;
		
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
		public String getEmployeeID() {
			return employeeID;
		}
		public void setEmployeeID(String employeeID) {
			this.employeeID = employeeID;
		}
		public Double getRebookQueryFee() {
			return rebookQueryFee;
		}
		public void setRebookQueryFee(Double rebookQueryFee) {
			this.rebookQueryFee = rebookQueryFee;
		}
		public Double getRefund() {
			return refund;
		}
		public void setRefund(Double refund) {
			this.refund = refund;
		}
		public Double getRefundServiceFee() {
			return refundServiceFee;
		}
		public void setRefundServiceFee(Double refundServiceFee) {
			this.refundServiceFee = refundServiceFee;
		}
		public Double getReBookingServiceFee() {
			return reBookingServiceFee;
		}
		public void setReBookingServiceFee(Double reBookingServiceFee) {
			this.reBookingServiceFee = reBookingServiceFee;
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
		public String getdCityName() {
			return dCityName;
		}
		public void setdCityName(String dCityName) {
			this.dCityName = dCityName;
		}
		public String getaCityName() {
			return aCityName;
		}
		public void setaCityName(String aCityName) {
			this.aCityName = aCityName;
		}
		public String getFlight() {
			return flight;
		}
		public void setFlight(String flight) {
			this.flight = flight;
		}
		public String getRemark() {
			return remark;
		}
		public void setRemark(String remark) {
			this.remark = remark;
		}
		public String getClassName() {
			return className;
		}
		public void setClassName(String className) {
			this.className = className;
		}
		public Double getAmount() {
			return amount;
		}
		public void setAmount(Double amount) {
			this.amount = amount;
		}
		public String getJourneyID() {
			return journeyID;
		}
		public void setJourneyID(String journeyID) {
			this.journeyID = journeyID;
		}
		public String getFeeType() {
			return feeType;
		}
		public void setFeeType(String feeType) {
			this.feeType = feeType;
		}
		public String getOrderDetailType() {
			return orderDetailType;
		}
		public void setOrderDetailType(String orderDetailType) {
			this.orderDetailType = orderDetailType;
		}
		public String getCreateTime() {
			return createTime;
		}
		public void setCreateTime(String createTime) {
			this.createTime = createTime;
		}
		@Override
		public String toString() {
			return "XiechengERPFlight [" + (journeyID != null ? "journeyID=" + journeyID + ", " : "") + (passengerName != null ? "passengerName=" + passengerName + ", " : "") + (takeoffTime != null ? "takeoffTime=" + takeoffTime + ", " : "") + (arrivalTime != null ? "arrivalTime=" + arrivalTime + ", " : "") + (dCityName != null ? "dCityName=" + dCityName + ", " : "") + (aCityName != null ? "aCityName=" + aCityName + ", " : "") + (flight != null ? "flight=" + flight + ", " : "") + (feeType != null ? "feeType=" + feeType + ", " : "") + (remark != null ? "remark=" + remark + ", " : "") + (className != null ? "className=" + className + ", " : "") + (amount != null ? "amount=" + amount + ", " : "") + (reBookingServiceFee != null ? "reBookingServiceFee=" + reBookingServiceFee + ", " : "") + (rebookQueryFee != null ? "rebookQueryFee=" + rebookQueryFee + ", " : "") + (refund != null ? "refund=" + refund + ", " : "")
					+ (refundServiceFee != null ? "refundServiceFee=" + refundServiceFee + ", " : "") + (orderDetailType != null ? "orderDetailType=" + orderDetailType + ", " : "") + (employeeID != null ? "employeeID=" + employeeID + ", " : "") + (createTime != null ? "createTime=" + createTime : "") + "]";
		}
		
		
}
