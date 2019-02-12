package com.seeyon.apps.kdXdtzXc.po;

import java.io.Serializable;

public class XieChengVipJiuDianPo implements Serializable{
	private String id;
	private String carName; //城市名称
	private Double room;	//酒店费用
	private String roomType;//酒店类型
	private String bigDate; //开始时间
	private String endDate;	//结束时间
	private String Type;	//类型
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getCarName() {
		return carName;
	}
	public void setCarName(String carName) {
		this.carName = carName;
	}
	public Double getRoom() {
		return room;
	}
	public void setRoom(Double room) {
		this.room = room;
	}
	public String getRoomType() {
		return roomType;
	}
	public void setRoomType(String roomType) {
		this.roomType = roomType;
	}
	public String getBigDate() {
		return bigDate;
	}
	public void setBigDate(String bigDate) {
		this.bigDate = bigDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getType() {
		return Type;
	}
	public void setType(String type) {
		Type = type;
	}
	public XieChengVipJiuDianPo() {
		super();
		// TODO Auto-generated constructor stub
	}
	public XieChengVipJiuDianPo(String id, String carName, Double room, String roomType, String bigDate, String endDate, String type) {
		super();
		this.id = id;
		this.carName = carName;
		this.room = room;
		this.roomType = roomType;
		this.bigDate = bigDate;
		this.endDate = endDate;
		Type = type;
	}
	@Override
	public String toString() {
		return "XieChengVipJiuDianPo [id=" + id + ", carName=" + carName + ", room=" + room + ", roomType=" + roomType + ", bigDate=" + bigDate + ", endDate=" + endDate + ", Type=" + Type + "]";
	}
	
}
