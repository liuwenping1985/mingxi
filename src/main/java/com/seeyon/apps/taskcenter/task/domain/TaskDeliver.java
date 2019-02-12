package com.seeyon.apps.taskcenter.task.domain;

/**
 * TaskDeliver entity. @author MyEclipse Persistence Tools
 */

public class TaskDeliver implements java.io.Serializable {

	// Fields

	private String taskDeliverNum;
	private String taskId;
	private String taskDeliver;
	private String taskAssigneer;
	private String taskDeliverTime;
	private String taskConfimTime;

	// Constructors

	/** default constructor */
	public TaskDeliver() {
	}

	/** full constructor */
	public TaskDeliver(String taskId, String taskDeliver, String taskAssigneer,
			String taskDeliverTime, String taskConfimTime) {
		this.taskId = taskId;
		this.taskDeliver = taskDeliver;
		this.taskAssigneer = taskAssigneer;
		this.taskDeliverTime = taskDeliverTime;
		this.taskConfimTime = taskConfimTime;
	}

	// Property accessors

	public String getTaskDeliverNum() {
		return this.taskDeliverNum;
	}

	public void setTaskDeliverNum(String taskDeliverNum) {
		this.taskDeliverNum = taskDeliverNum;
	}

	public String getTaskId() {
		return this.taskId;
	}

	public void setTaskId(String taskId) {
		this.taskId = taskId;
	}

	public String getTaskDeliver() {
		return this.taskDeliver;
	}

	public void setTaskDeliver(String taskDeliver) {
		this.taskDeliver = taskDeliver;
	}

	public String getTaskAssigneer() {
		return this.taskAssigneer;
	}

	public void setTaskAssigneer(String taskAssigneer) {
		this.taskAssigneer = taskAssigneer;
	}

	public String getTaskDeliverTime() {
		return this.taskDeliverTime;
	}

	public void setTaskDeliverTime(String taskDeliverTime) {
		this.taskDeliverTime = taskDeliverTime;
	}

	public String getTaskConfimTime() {
		return this.taskConfimTime;
	}

	public void setTaskConfimTime(String taskConfimTime) {
		this.taskConfimTime = taskConfimTime;
	}

}