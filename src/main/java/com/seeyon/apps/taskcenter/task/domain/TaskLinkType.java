package com.seeyon.apps.taskcenter.task.domain;

/**
 * TaskLinkTypeId entity. @author MyEclipse Persistence Tools
 */

public class TaskLinkType implements java.io.Serializable {

	// Fields

	private String taskLinktypeCode;
	private String taskLinkStatus;
	private String taskLinkFormat;
	
	// Constructors

	public String getTaskLinkFormat() {
		return taskLinkFormat;
	}

	public void setTaskLinkFormat(String taskLinkFormat) {
		this.taskLinkFormat = taskLinkFormat;
	}

	/** default constructor */
	public TaskLinkType() {
	}

	/** full constructor */
	public TaskLinkType(String taskLinktypeCode, String taskLinkStatus) {
		this.taskLinktypeCode = taskLinktypeCode;
		this.taskLinkStatus = taskLinkStatus;
	}

	// Property accessors

	public String getTaskLinktypeCode() {
		return this.taskLinktypeCode;
	}

	public void setTaskLinktypeCode(String taskLinktypeCode) {
		this.taskLinktypeCode = taskLinktypeCode;
	}

	public String getTaskLinkStatus() {
		return this.taskLinkStatus;
	}

	public void setTaskLinkStatus(String taskLinkStatus) {
		this.taskLinkStatus = taskLinkStatus;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof TaskLinkType))
			return false;
		TaskLinkType castOther = (TaskLinkType) other;

		return ((this.getTaskLinktypeCode() == castOther.getTaskLinktypeCode()) || (this
				.getTaskLinktypeCode() != null
				&& castOther.getTaskLinktypeCode() != null && this
				.getTaskLinktypeCode().equals(castOther.getTaskLinktypeCode())))
				&& ((this.getTaskLinkStatus() == castOther.getTaskLinkStatus()) || (this
						.getTaskLinkStatus() != null
						&& castOther.getTaskLinkStatus() != null && this
						.getTaskLinkStatus().equals(
								castOther.getTaskLinkStatus())));
	}

	public int hashCode() {
		int result = 17;

		result = 37
				* result
				+ (getTaskLinktypeCode() == null ? 0 : this
						.getTaskLinktypeCode().hashCode());
		result = 37
				* result
				+ (getTaskLinkStatus() == null ? 0 : this.getTaskLinkStatus()
						.hashCode());
		return result;
	}

}