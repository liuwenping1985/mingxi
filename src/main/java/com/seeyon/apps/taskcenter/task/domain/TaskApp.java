package com.seeyon.apps.taskcenter.task.domain;

/**
 * TaskApp entity. @author MyEclipse Persistence Tools
 */

public class TaskApp implements java.io.Serializable {

	// Fields

	private String taskAppCode;
	private String ordernum;
	private String taskAppName;

	// Constructors

	/** default constructor */
	public TaskApp() {
	}

	/** full constructor */
	public TaskApp(String ordernum, String taskAppName) {
		this.ordernum = ordernum;
		this.taskAppName = taskAppName;
	}

	// Property accessors

	public String getTaskAppCode() {
		return this.taskAppCode;
	}

	public void setTaskAppCode(String taskAppCode) {
		this.taskAppCode = taskAppCode;
	}

	public String getOrdernum() {
		return this.ordernum;
	}

	public void setOrdernum(String ordernum) {
		this.ordernum = ordernum;
	}

	public String getTaskAppName() {
		return this.taskAppName;
	}

	public void setTaskAppName(String taskAppName) {
		this.taskAppName = taskAppName;
	}

}