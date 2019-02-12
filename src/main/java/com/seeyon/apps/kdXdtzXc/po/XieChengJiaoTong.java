package com.seeyon.apps.kdXdtzXc.po;

import java.io.Serializable;

public class XieChengJiaoTong implements Serializable{
	private String id;
	private String position; //交通舱位
	private String type;	 //类型
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPosition() {
		return position;
	}
	public void setPosition(String position) {
		this.position = position;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public XieChengJiaoTong() {
		super();
		// TODO Auto-generated constructor stub
	}
	public XieChengJiaoTong(String id, String position, String type) {
		super();
		this.id = id;
		this.position = position;
		this.type = type;
	}
	@Override
	public String toString() {
		return "XieChengJiaoTong [id=" + id + ", position=" + position + ", type=" + type + "]";
	}
	
}
