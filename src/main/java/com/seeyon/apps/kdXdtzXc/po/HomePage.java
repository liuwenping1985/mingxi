package com.seeyon.apps.kdXdtzXc.po;

import java.util.Date;

public class HomePage implements Comparable<Date> {//首页待办
	private Long afficID;
	private String name;
	private Integer app;
	private String subject;
	private Date createDate;
	public Long getAfficID() {
		return afficID;
	}
	public void setAfficID(Long afficID) {
		this.afficID = afficID;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Integer getApp() {
		return app;
	}
	public void setApp(Integer app) {
		this.app = app;
	}
	public String getSubject() {
		return subject;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	public HomePage(Long afficID, String name, Integer app, String subject, Date createDate) {
		super();
		this.afficID = afficID;
		this.name = name;
		this.app = app;
		this.subject = subject;
		this.createDate = createDate;
	}
	public HomePage() {	// TODO Auto-generated constructor stub
	}
	@Override
	public int compareTo(Date o) {
	
		return 0;
	}
	
	

}
