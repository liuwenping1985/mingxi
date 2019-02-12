/**
 * $Author$
 * $Rev$
 * $Date::                     $:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */

package com.seeyon.ctp.common.supervise.bo;

import java.util.Date;

/**
 * @author mujun
 *
 */
public class SuperviseWebModel {
    private Long id;
    private String title;
    private long sender;
    private Date sendDate;
    private String caseLogXML;
    private String caseProcessXML;
    private String caseWorkItemLogXML;
    private String processDescBy;
    private String supervisor;
    private Date awakeDate;
    private String description;
    private Integer count;
    private Integer remindModel; // ?
    private Boolean hasWorkflow;
    private Long caseId;
    private String processId;
    private String content;
    private Long summaryId;
    private Integer status;
    private Long deadline= 0L;
    private Date deadlineDatetime;//流程期限时间点
    private String deadlineName;    //经过处理后的流程期限
    private boolean canModify;
    private Integer entityType;
    private Boolean workflowTimeout = false;//流程超期
    private Boolean isRed = false;//督办日期是否超期    
    private Integer importantLevel = 1;      //重要程度
    private Integer appType;
    private Integer newflowType = -1; //新流程类型
    private Integer resendTime ;//重新发起次数
    private String forwardMember;
    private String bodyType;
    private Boolean hasAttachment;
    private String senderName;  //发起人姓名
    private String detailPageUrl; //督办列表中点击某记录在下方显示的详细页面的路径
    private long affairId;      //ctp_affair表id主键，主要用于在督办列表中查看协同或公文的详细页面
    private Boolean isTemplate; //是否为模版流程
    private Long flowPermAccountId;// 节点权限所属单位ID
    private String docType;//公文种类
    private String supervisors;//督办人
    private String deadlineTime;//流程期限时间
    private String appName;
    private boolean finished =false;
    private String currentNodesInfo;//当前处理人信息
    private Long formAppId; // szp 对应使用表单ID
    
    //默认节点id
    private String defaultNodeName = "";
    //默认节点lable
    private String defaultNodeLable = "";
	
    public boolean isFinished() {
		return finished;
	}
	public void setFinished(boolean finished) {
		this.finished = finished;
	}

    public String getAppName() { 
		return appName;
	}
	public void setAppName(String appName) {
		this.appName = appName;
	}
	public String getDocType() {
		return docType;
	}
	public void setDocType(String docType) {
		this.docType = docType;
	}
	public String getSupervisors() {
		return supervisors;
	}
	public void setSupervisors(String supervisors) {
		this.supervisors = supervisors;
	}
	public String getDeadlineTime() {
		return deadlineTime;
	}
	public void setDeadlineTime(String deadlineTime) {
		this.deadlineTime = deadlineTime;
	}
	public Boolean getIsTemplate() {
		return isTemplate;
	}
	public void setIsTemplate(Boolean isTemplate) {
		this.isTemplate = isTemplate;
	}
	public Long getFlowPermAccountId() {
		return flowPermAccountId;
	}
	public void setFlowPermAccountId(Long flowPermAccountId) {
		this.flowPermAccountId = flowPermAccountId;
	}
    public String getProcessId() {
        return processId;
    }
    public void setProcessId(String processId) {
        this.processId = processId;
    }
    public long getAffairId() {
        return affairId;
    }
    public void setAffairId(long affairId) {
        this.affairId = affairId;
    }
    public String getDeadlineName() {
        return deadlineName;
    }
    public void setDeadlineName(String deadlineName) {
        this.deadlineName = deadlineName;
    }
    public String getDetailPageUrl() {
        return detailPageUrl;
    }
    public void setDetailPageUrl(String detailPageUrl) {
        this.detailPageUrl = detailPageUrl;
    }
    public String getSenderName() {
        return senderName;
    }
    public void setSenderName(String senderName) {
        this.senderName = senderName;
    }
    public Boolean getHasAttachment() {
        return hasAttachment;
    }
    public void setHasAttachment(Boolean hasAttachment) {
        this.hasAttachment = hasAttachment;
    }
    public String getBodyType() {
        return bodyType;
    }
    public void setBodyType(String bodyType) {
        this.bodyType = bodyType;
    }
    public Integer getImportantLevel() {
        return importantLevel;
    }
    /**
     * @return the isRed
     */
    public Boolean getIsRed() {
        return isRed;
    }
    /**
     * @param isRed the isRed to set
     */
    public void setIsRed(Boolean isRed) {
        this.isRed = isRed;
    }
    public void setImportantLevel(Integer importantLevel) {
        this.importantLevel = importantLevel;
    }
    public Integer getEntityType() {
        return entityType;
    }
    public void setEntityType(Integer entityType) {
        this.entityType = entityType;
    }
    public boolean isCanModify() {
        return canModify;
    }
    public void setCanModify(boolean canModify) {
        this.canModify = canModify;
    }
    public Date getAwakeDate() {
        return awakeDate;
    }
    public void setAwakeDate(Date awakeDate) {
        this.awakeDate = awakeDate;
    }
    public Long getCaseId() {
        return caseId;
    }
    public void setCaseId(Long caseId) {
        this.caseId = caseId;
    }
    public String getCaseLogXML() {
        return caseLogXML;
    }
    public void setCaseLogXML(String caseLogXML) {
        this.caseLogXML = caseLogXML;
    }
    public String getCaseProcessXML() {
        return caseProcessXML;
    }
    public void setCaseProcessXML(String caseProcessXML) {
        this.caseProcessXML = caseProcessXML;
    }
    public String getCaseWorkItemLogXML() {
        return caseWorkItemLogXML;
    }
    public void setCaseWorkItemLogXML(String caseWorkItemLogXML) {
        this.caseWorkItemLogXML = caseWorkItemLogXML;
    }
    public Long getSummaryId() {
        return summaryId;
    }
    public void setSummaryId(Long summaryId) {
        this.summaryId = summaryId;
    }
    public String getContent() {
        return content;
    }
    public void setContent(String content) {
        this.content = content;
    }
    public Integer getCount() {
        return count;
    }
    public void setCount(Integer count) {
        this.count = count;
    }
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }
    public Boolean getHasWorkflow() {
        return hasWorkflow;
    }
    public void setHasWorkflow(Boolean hasWorkflow) {
        this.hasWorkflow = hasWorkflow;
    }
    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
    }
    public String getProcessDescBy() {
        return processDescBy;
    }
    public void setProcessDescBy(String processDescBy) {
        this.processDescBy = processDescBy;
    }
    public Integer getRemindModel() {
        return remindModel;
    }
    public void setRemindModel(Integer remindModel) {
        this.remindModel = remindModel;
    }
    public long getSender() {
        return sender;
    }
    public void setSender(long sender) {
        this.sender = sender;
    }
    public Integer getStatus() {
        return status;
    }
    public void setStatus(Integer status) {
        this.status = status;
    }
    public String getSupervisor() {
        return supervisor;
    }
    public void setSupervisor(String supervisor) {
        this.supervisor = supervisor;
    }
    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }
    public Date getSendDate() {
        return sendDate;
    }
    public void setSendDate(Date sendDate) {
        this.sendDate = sendDate;
    }
    public Boolean getWorkflowTimeout() {
        return workflowTimeout;
    }
    public void setWorkflowTimeout(Boolean workflowTimeout) {
        this.workflowTimeout = workflowTimeout;
    }
    public Long getDeadline() {
        return deadline;
    }
    public void setDeadline(Long deadline) {
        this.deadline = deadline;
    }
    /**
     * @return the appType
     */
    public Integer getAppType() {
        return appType;
    }
    /**
     * @param appType the appType to set
     */
    public void setAppType(Integer appType) {
        this.appType = appType;
    }
    public Integer getNewflowType() {
        return newflowType;
    }
    public void setNewflowType(Integer newflowType) {
        this.newflowType = newflowType;
    }
    public Integer getResendTime() {
        return resendTime;
    }
    public void setResendTime(Integer resendTime) {
        this.resendTime = resendTime;
    }
    
    public String getForwardMember() {
        return forwardMember;
    }
    
    public void setForwardMember(String forwardMember) {
        this.forwardMember = forwardMember;
    }
	public Date getDeadlineDatetime() {
		return deadlineDatetime;
	}
	public void setDeadlineDatetime(Date deadlineDatetime) {
		this.deadlineDatetime = deadlineDatetime;
	}
	public String getCurrentNodesInfo() {
		return currentNodesInfo;
	}
	public void setCurrentNodesInfo(String currentNodesInfo) {
		this.currentNodesInfo = currentNodesInfo;
	}
	public String getDefaultNodeName() {
		return defaultNodeName;
	}
	public void setDefaultNodeName(String defaultNodeName) {
		this.defaultNodeName = defaultNodeName;
	}
	public String getDefaultNodeLable() {
		return defaultNodeLable;
	}
	public void setDefaultNodeLable(String defaultNodeLable) {
		this.defaultNodeLable = defaultNodeLable;
	}
	public Long getFormAppId() {
		return formAppId;
	}
	public void setFormAppId(Long formAppId) {
		this.formAppId = formAppId;
	}
}
