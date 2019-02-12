package com.seeyon.apps.kdXdtzXc.po;

public class SetApprovalEntity {
	private String id;
	private String employeeID;      //员工ID 
	private String approvalNumber; //审批单号
	private String toCity; 			// 到达城市
	private String beginDate;		//预计出发日期
	private String endDate;			//预计返回日期
	private String status; //审批单状态 1  审批的
	private String passengerList;	//乘车人列表，多个以英文逗号隔开
	private String fromCities;      //出发城市，多个以英文逗号隔开
	private String toCities;		//到达城市，多个以英文逗号隔开
	private String hotelPassengerList;  //入住人列表，多个以英文逗号隔开
	private String checkInCities;   //入住城市，多个以英文逗号隔开
	private String isSend; // 是否发送 0 未发送
	public String getEmployeeID() {
		return employeeID;
	}
	public void setEmployeeID(String employeeID) {
		this.employeeID = employeeID;
	}
	public String getApprovalNumber() {
		return approvalNumber;
	}
	public void setApprovalNumber(String approvalNumber) {
		this.approvalNumber = approvalNumber;
	}
	public String getToCity() {
		return toCity;
	}
	public void setToCity(String toCity) {
		this.toCity = toCity;
	}
	public String getBeginDate() {
		return beginDate;
	}
	public void setBeginDate(String beginDate) {
		this.beginDate = beginDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getPassengerList() {
		return passengerList;
	}
	public void setPassengerList(String passengerList) {
		this.passengerList = passengerList;
	}
	public String getFromCities() {
		return fromCities;
	}
	public void setFromCities(String fromCities) {
		this.fromCities = fromCities;
	}
	public String getToCities() {
		return toCities;
	}
	public void setToCities(String toCities) {
		this.toCities = toCities;
	}
	public String getHotelPassengerList() {
		return hotelPassengerList;
	}
	public SetApprovalEntity() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getIsSend() {
		return isSend;
	}
	public void setIsSend(String isSend) {
		this.isSend = isSend;
	}
	public void setHotelPassengerList(String hotelPassengerList) {
		this.hotelPassengerList = hotelPassengerList;
	}
	public String getCheckInCities() {
		return checkInCities;
	}
	public void setCheckInCities(String checkInCities) {
		this.checkInCities = checkInCities;
	}
	public SetApprovalEntity(String id, String employeeID, String approvalNumber, String toCity, String beginDate, String endDate, String status, String passengerList, String fromCities, String toCities, String hotelPassengerList, String checkInCities, String isSend) {
		super();
		this.id = id;
		this.employeeID = employeeID;
		this.approvalNumber = approvalNumber;
		this.toCity = toCity;
		this.beginDate = beginDate;
		this.endDate = endDate;
		this.status = status;
		this.passengerList = passengerList;
		this.fromCities = fromCities;
		this.toCities = toCities;
		this.hotelPassengerList = hotelPassengerList;
		this.checkInCities = checkInCities;
		this.isSend = isSend;
	}
	@Override
	public String toString() {
		return "TiQianShengPiEntity [id=" + id + ", employeeID=" + employeeID + ", approvalNumber=" + approvalNumber + ", toCity=" + toCity + ", beginDate=" + beginDate + ", endDate=" + endDate + ", status=" + status + ", passengerList=" + passengerList + ", fromCities=" + fromCities + ", toCities=" + toCities + ", hotelPassengerList=" + hotelPassengerList + ", checkInCities=" + checkInCities + ", isSend=" + isSend + "]";
	}

	
	

}
