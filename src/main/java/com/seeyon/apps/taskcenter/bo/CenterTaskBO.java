package com.seeyon.apps.taskcenter.bo;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

public class CenterTaskBO implements Serializable{
	private String taskId;//'a'},
	private String flowName;//', mapping: 'b'},
    private String flowNode;//', mapping: 'c'},
    private String subject;//', mapping: 'd'},
    private String assignerTime;//',mapping: 'e'},
    private String designator;//',mapping: 'f'},
    private String type;//',mapping:'j'},
    private String linkPath;//',mapping: 'g'},
    private String appvar1;//',mapping:'h'},
    private String detailPath;//',mapping:'i'},
    private String linkPath2;//',mapping:'k'}
    private String taskBatchName;//所处任务环节
    private String submitTime;	//提交时间
    private String batchName;
	public String getBatchName() {
		return batchName;
	}
	public void setBatchName(String batchName) {
		this.batchName = batchName;
	}
	public String getSubmitTime() {
		return submitTime;
	}
	public void setSubmitTime(String submitTime) {
		this.submitTime = submitTime;
	}
	public String getTaskBatchName() {
		return taskBatchName;
	}
	public void setTaskBatchName(String taskBatchName) {
		this.taskBatchName = taskBatchName;
	}
	public String getTaskId() {
		return taskId;
	}
	public void setTaskId(String taskId) {
		this.taskId = taskId;
	}
	public String getFlowName() {
		return flowName;
	}
	public void setFlowName(String flowName) {
		this.flowName = flowName;
	}
	public String getFlowNode() {
		return flowNode;
	}
	public void setFlowNode(String flowNode) {
		this.flowNode = flowNode;
	}
	public String getSubject() {
		return subject;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	public String getAssignerTime() {
		return assignerTime;
	}
	public void setAssignerTime(String assignerTime) {
		this.assignerTime = assignerTime;
	}
	public String getDesignator() {
		return designator;
	}
	public void setDesignator(String designator) {
		this.designator = designator;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getLinkPath() {
		return linkPath;
	}
	public void setLinkPath(String linkPath) {
		this.linkPath = linkPath;
	}
	public String getAppvar1() {
		return appvar1;
	}
	public void setAppvar1(String appvar1) {
		this.appvar1 = appvar1;
	}
	public String getDetailPath() {
		return detailPath;
	}
	public void setDetailPath(String detailPath) {
		this.detailPath = detailPath;
	}
	public String getLinkPath2() {
		return linkPath2;
	}
	public void setLinkPath2(String linkPath2) {
		this.linkPath2 = linkPath2;
	}
	

}
