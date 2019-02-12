package com.seeyon.apps.taskcenter.task.domain;

/**
 * TaskResult entity. @author MyEclipse Persistence Tools
 */

public class TaskResult implements java.io.Serializable {

	// Fields

	private String taskResultCode;
	private String taskResultName;

	// Constructors

	/** default constructor */
	public TaskResult() {
	}

	/** full constructor */
	public TaskResult(String taskResultName) {
		this.taskResultName = taskResultName;
	}

	// Property accessors

	public String getTaskResultCode() {
		return this.taskResultCode;
	}

	public void setTaskResultCode(String taskResultCode) {
		this.taskResultCode = taskResultCode;
	}

	public String getTaskResultName() {
		return this.taskResultName;
	}

	public void setTaskResultName(String taskResultName) {
		this.taskResultName = taskResultName;
	}

}