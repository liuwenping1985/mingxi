package com.seeyon.apps.taskcenter.task.domain;

import java.math.BigDecimal;

/**
 * TaskTodolist entity. @author MyEclipse Persistence Tools
 */

public class TaskTodolist implements java.io.Serializable {

	// Fields

	private String taskId;
	private BigDecimal taskKind;
	private String taskBatchId;
	private String taskStageName;
	private String taskBatchName;
	private String taskSubject;
	private String taskContent;
	private String taskStatus;
	private String taskCreator;
	private String taskDesignator;
	private String taskAssigneer;
	private String taskAssigneeRule;
	private String taskCc;
	private BigDecimal taskAllowDeliver;
	private String taskConfirmor;
	private String taskSubmit;
	private String taskCreateTime;
	private String taskAssigneeTime;
	private String taskConfirmTime;
	private String taskSubmitTime;
	private String taskResultCode;
	private String deptCode;
	private String taskComments;
	private String taskAppSrc;
	private String taskAppMoudle;
	private String appVar1;
	private String appVar2;
	private String appVar3;
	private String appVar4;
	private String appVar5;
	private String appVar6;
	private String appVar7;
	private String appVar8;
	private String appVar9;
	private String taskMsgId;
	private BigDecimal taskMsgStatus;
	private String taskLinkType;
	private String taskLink2Name;
	private String taskLink2Type;
	private String taskLink3Name;
	private String taskLink3Type;
	private String taskLink4Name;
	private String taskLink4Type;
	private String taskLink5Name;
	private String taskLink5Type;
	private BigDecimal delflag;
	private String taskExecutor;
	private String taskAppState;

	// Constructors

	/** default constructor */
	public TaskTodolist() {
	}

	/** full constructor */
	public TaskTodolist(BigDecimal taskKind, String taskBatchId,
			String taskStageName, String taskBatchName, String taskSubject,
			String taskContent, String taskStatus, String taskCreator,
			String taskDesignator, String taskAssigneer,
			String taskAssigneeRule, String taskCc,
			BigDecimal taskAllowDeliver, String taskConfirmor,
			String taskSubmit, String taskCreateTime, String taskAssigneeTime,
			String taskConfirmTime, String taskSubmitTime,
			String taskResultCode, String deptCode, String taskComments,
			String taskAppSrc, String taskAppMoudle, String appVar1,
			String appVar2, String appVar3, String appVar4, String appVar5,
			String appVar6, String appVar7, String appVar8, String appVar9,
			String taskMsgId, BigDecimal taskMsgStatus, String taskLinkType,
			String taskLink2Name, String taskLink2Type, String taskLink3Name,
			String taskLink3Type, String taskLink4Name, String taskLink4Type,
			String taskLink5Name, String taskLink5Type, BigDecimal delflag,
			String taskExecutor, String taskAppState) {
		this.taskKind = taskKind;
		this.taskBatchId = taskBatchId;
		this.taskStageName = taskStageName;
		this.taskBatchName = taskBatchName;
		this.taskSubject = taskSubject;
		this.taskContent = taskContent;
		this.taskStatus = taskStatus;
		this.taskCreator = taskCreator;
		this.taskDesignator = taskDesignator;
		this.taskAssigneer = taskAssigneer;
		this.taskAssigneeRule = taskAssigneeRule;
		this.taskCc = taskCc;
		this.taskAllowDeliver = taskAllowDeliver;
		this.taskConfirmor = taskConfirmor;
		this.taskSubmit = taskSubmit;
		this.taskCreateTime = taskCreateTime;
		this.taskAssigneeTime = taskAssigneeTime;
		this.taskConfirmTime = taskConfirmTime;
		this.taskSubmitTime = taskSubmitTime;
		this.taskResultCode = taskResultCode;
		this.deptCode = deptCode;
		this.taskComments = taskComments;
		this.taskAppSrc = taskAppSrc;
		this.taskAppMoudle = taskAppMoudle;
		this.appVar1 = appVar1;
		this.appVar2 = appVar2;
		this.appVar3 = appVar3;
		this.appVar4 = appVar4;
		this.appVar5 = appVar5;
		this.appVar6 = appVar6;
		this.appVar7 = appVar7;
		this.appVar8 = appVar8;
		this.appVar9 = appVar9;
		this.taskMsgId = taskMsgId;
		this.taskMsgStatus = taskMsgStatus;
		this.taskLinkType = taskLinkType;
		this.taskLink2Name = taskLink2Name;
		this.taskLink2Type = taskLink2Type;
		this.taskLink3Name = taskLink3Name;
		this.taskLink3Type = taskLink3Type;
		this.taskLink4Name = taskLink4Name;
		this.taskLink4Type = taskLink4Type;
		this.taskLink5Name = taskLink5Name;
		this.taskLink5Type = taskLink5Type;
		this.delflag = delflag;
		this.taskExecutor = taskExecutor;
		this.taskAppState = taskAppState;
	}

	// Property accessors

	public String getTaskId() {
		return this.taskId;
	}

	public void setTaskId(String taskId) {
		this.taskId = taskId;
	}

	public BigDecimal getTaskKind() {
		return this.taskKind;
	}

	public void setTaskKind(BigDecimal taskKind) {
		this.taskKind = taskKind;
	}

	public String getTaskBatchId() {
		return this.taskBatchId;
	}

	public void setTaskBatchId(String taskBatchId) {
		this.taskBatchId = taskBatchId;
	}

	public String getTaskStageName() {
		return this.taskStageName;
	}

	public void setTaskStageName(String taskStageName) {
		this.taskStageName = taskStageName;
	}

	public String getTaskBatchName() {
		return this.taskBatchName;
	}

	public void setTaskBatchName(String taskBatchName) {
		this.taskBatchName = taskBatchName;
	}

	public String getTaskSubject() {
		return this.taskSubject;
	}

	public void setTaskSubject(String taskSubject) {
		this.taskSubject = taskSubject;
	}

	public String getTaskContent() {
		return this.taskContent;
	}

	public void setTaskContent(String taskContent) {
		this.taskContent = taskContent;
	}

	public String getTaskStatus() {
		return this.taskStatus;
	}

	public void setTaskStatus(String taskStatus) {
		this.taskStatus = taskStatus;
	}

	public String getTaskCreator() {
		return this.taskCreator;
	}

	public void setTaskCreator(String taskCreator) {
		this.taskCreator = taskCreator;
	}

	public String getTaskDesignator() {
		return this.taskDesignator;
	}

	public void setTaskDesignator(String taskDesignator) {
		this.taskDesignator = taskDesignator;
	}

	public String getTaskAssigneer() {
		return this.taskAssigneer;
	}

	public void setTaskAssigneer(String taskAssigneer) {
		this.taskAssigneer = taskAssigneer;
	}

	public String getTaskAssigneeRule() {
		return this.taskAssigneeRule;
	}

	public void setTaskAssigneeRule(String taskAssigneeRule) {
		this.taskAssigneeRule = taskAssigneeRule;
	}

	public String getTaskCc() {
		return this.taskCc;
	}

	public void setTaskCc(String taskCc) {
		this.taskCc = taskCc;
	}

	public BigDecimal getTaskAllowDeliver() {
		return this.taskAllowDeliver;
	}

	public void setTaskAllowDeliver(BigDecimal taskAllowDeliver) {
		this.taskAllowDeliver = taskAllowDeliver;
	}

	public String getTaskConfirmor() {
		return this.taskConfirmor;
	}

	public void setTaskConfirmor(String taskConfirmor) {
		this.taskConfirmor = taskConfirmor;
	}

	public String getTaskSubmit() {
		return this.taskSubmit;
	}

	public void setTaskSubmit(String taskSubmit) {
		this.taskSubmit = taskSubmit;
	}

	public String getTaskCreateTime() {
		return this.taskCreateTime;
	}

	public void setTaskCreateTime(String taskCreateTime) {
		this.taskCreateTime = taskCreateTime;
	}

	public String getTaskAssigneeTime() {
		return this.taskAssigneeTime;
	}

	public void setTaskAssigneeTime(String taskAssigneeTime) {
		this.taskAssigneeTime = taskAssigneeTime;
	}

	public String getTaskConfirmTime() {
		return this.taskConfirmTime;
	}

	public void setTaskConfirmTime(String taskConfirmTime) {
		this.taskConfirmTime = taskConfirmTime;
	}

	public String getTaskSubmitTime() {
		return this.taskSubmitTime;
	}

	public void setTaskSubmitTime(String taskSubmitTime) {
		this.taskSubmitTime = taskSubmitTime;
	}

	public String getTaskResultCode() {
		return this.taskResultCode;
	}

	public void setTaskResultCode(String taskResultCode) {
		this.taskResultCode = taskResultCode;
	}

	public String getDeptCode() {
		return this.deptCode;
	}

	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
	}

	public String getTaskComments() {
		return this.taskComments;
	}

	public void setTaskComments(String taskComments) {
		this.taskComments = taskComments;
	}

	public String getTaskAppSrc() {
		return this.taskAppSrc;
	}

	public void setTaskAppSrc(String taskAppSrc) {
		this.taskAppSrc = taskAppSrc;
	}

	public String getTaskAppMoudle() {
		return this.taskAppMoudle;
	}

	public void setTaskAppMoudle(String taskAppMoudle) {
		this.taskAppMoudle = taskAppMoudle;
	}

	public String getAppVar1() {
		return this.appVar1;
	}

	public void setAppVar1(String appVar1) {
		this.appVar1 = appVar1;
	}

	public String getAppVar2() {
		return this.appVar2;
	}

	public void setAppVar2(String appVar2) {
		this.appVar2 = appVar2;
	}

	public String getAppVar3() {
		return this.appVar3;
	}

	public void setAppVar3(String appVar3) {
		this.appVar3 = appVar3;
	}

	public String getAppVar4() {
		return this.appVar4;
	}

	public void setAppVar4(String appVar4) {
		this.appVar4 = appVar4;
	}

	public String getAppVar5() {
		return this.appVar5;
	}

	public void setAppVar5(String appVar5) {
		this.appVar5 = appVar5;
	}

	public String getAppVar6() {
		return this.appVar6;
	}

	public void setAppVar6(String appVar6) {
		this.appVar6 = appVar6;
	}

	public String getAppVar7() {
		return this.appVar7;
	}

	public void setAppVar7(String appVar7) {
		this.appVar7 = appVar7;
	}

	public String getAppVar8() {
		return this.appVar8;
	}

	public void setAppVar8(String appVar8) {
		this.appVar8 = appVar8;
	}

	public String getAppVar9() {
		return this.appVar9;
	}

	public void setAppVar9(String appVar9) {
		this.appVar9 = appVar9;
	}

	public String getTaskMsgId() {
		return this.taskMsgId;
	}

	public void setTaskMsgId(String taskMsgId) {
		this.taskMsgId = taskMsgId;
	}

	public BigDecimal getTaskMsgStatus() {
		return this.taskMsgStatus;
	}

	public void setTaskMsgStatus(BigDecimal taskMsgStatus) {
		this.taskMsgStatus = taskMsgStatus;
	}

	public String getTaskLinkType() {
		return this.taskLinkType;
	}

	public void setTaskLinkType(String taskLinkType) {
		this.taskLinkType = taskLinkType;
	}

	public String getTaskLink2Name() {
		return this.taskLink2Name;
	}

	public void setTaskLink2Name(String taskLink2Name) {
		this.taskLink2Name = taskLink2Name;
	}

	public String getTaskLink2Type() {
		return this.taskLink2Type;
	}

	public void setTaskLink2Type(String taskLink2Type) {
		this.taskLink2Type = taskLink2Type;
	}

	public String getTaskLink3Name() {
		return this.taskLink3Name;
	}

	public void setTaskLink3Name(String taskLink3Name) {
		this.taskLink3Name = taskLink3Name;
	}

	public String getTaskLink3Type() {
		return this.taskLink3Type;
	}

	public void setTaskLink3Type(String taskLink3Type) {
		this.taskLink3Type = taskLink3Type;
	}

	public String getTaskLink4Name() {
		return this.taskLink4Name;
	}

	public void setTaskLink4Name(String taskLink4Name) {
		this.taskLink4Name = taskLink4Name;
	}

	public String getTaskLink4Type() {
		return this.taskLink4Type;
	}

	public void setTaskLink4Type(String taskLink4Type) {
		this.taskLink4Type = taskLink4Type;
	}

	public String getTaskLink5Name() {
		return this.taskLink5Name;
	}

	public void setTaskLink5Name(String taskLink5Name) {
		this.taskLink5Name = taskLink5Name;
	}

	public String getTaskLink5Type() {
		return this.taskLink5Type;
	}

	public void setTaskLink5Type(String taskLink5Type) {
		this.taskLink5Type = taskLink5Type;
	}

	public BigDecimal getDelflag() {
		return this.delflag;
	}

	public void setDelflag(BigDecimal delflag) {
		this.delflag = delflag;
	}

	public String getTaskExecutor() {
		return this.taskExecutor;
	}

	public void setTaskExecutor(String taskExecutor) {
		this.taskExecutor = taskExecutor;
	}

	public String getTaskAppState() {
		return this.taskAppState;
	}

	public void setTaskAppState(String taskAppState) {
		this.taskAppState = taskAppState;
	}
}