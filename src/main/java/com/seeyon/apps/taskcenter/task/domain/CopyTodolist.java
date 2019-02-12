package com.seeyon.apps.taskcenter.task.domain;

/**
 * CopyTodolistId entity. @author MyEclipse Persistence Tools
 */

public class CopyTodolist implements java.io.Serializable {

	// Fields

	private String taskId;
	private String taskAssigneer;

	// Constructors

	/** default constructor */
	public CopyTodolist() {
	}

	/** full constructor */
	public CopyTodolist(String taskId, String taskAssigneer) {
		this.taskId = taskId;
		this.taskAssigneer = taskAssigneer;
	}

	// Property accessors

	public String getTaskId() {
		return this.taskId;
	}

	public void setTaskId(String taskId) {
		this.taskId = taskId;
	}

	public String getTaskAssigneer() {
		return this.taskAssigneer;
	}

	public void setTaskAssigneer(String taskAssigneer) {
		this.taskAssigneer = taskAssigneer;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof CopyTodolist))
			return false;
		CopyTodolist castOther = (CopyTodolist) other;

		return ((this.getTaskId() == castOther.getTaskId()) || (this
				.getTaskId() != null && castOther.getTaskId() != null && this
				.getTaskId().equals(castOther.getTaskId())))
				&& ((this.getTaskAssigneer() == castOther.getTaskAssigneer()) || (this
						.getTaskAssigneer() != null
						&& castOther.getTaskAssigneer() != null && this
						.getTaskAssigneer()
						.equals(castOther.getTaskAssigneer())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result
				+ (getTaskId() == null ? 0 : this.getTaskId().hashCode());
		result = 37
				* result
				+ (getTaskAssigneer() == null ? 0 : this.getTaskAssigneer()
						.hashCode());
		return result;
	}

}