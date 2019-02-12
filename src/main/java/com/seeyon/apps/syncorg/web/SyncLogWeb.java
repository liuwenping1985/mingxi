package com.seeyon.apps.syncorg.web;

import java.text.SimpleDateFormat;

import com.seeyon.apps.syncorg.po.log.SyncLog;


public class SyncLogWeb {
	
	public SyncLogWeb(SyncLog po){
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		this.id = po.getId();
		this.actionTypeEnum = po.getActionTypeEnum().getText();
		this.createTime = sdf.format(po.getCreateTime());
		this.updateTime = sdf.format(po.getUpdateTime());
		this.errorMessage = po.getErrorMessage();
		this.modifyProperty = po.getModifyProperty();
		this.objectTypeEnum = po.getObjectTypeEnum().getText();
		this.retryTimes = po.getRetryTimes();
		this.syncStatusEnum = po.getSyncStatusEnum().getText();
		this.xmlString = po.getXmlString();
		this.actionTypeEnum = po.getActionTypeEnum().getText();
	}

	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getObjectTypeEnum() {
		return objectTypeEnum;
	}
	public void setObjectTypeEnum(String objectTypeEnum) {
		this.objectTypeEnum = objectTypeEnum;
	}
	public String getActionTypeEnum() {
		return actionTypeEnum;
	}
	public void setActionTypeEnum(String actionTypeEnum) {
		this.actionTypeEnum = actionTypeEnum;
	}
	public String getErrorMessage() {
		return errorMessage;
	}
	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}
	public int getRetryTimes() {
		return retryTimes;
	}
	public void setRetryTimes(int retryTimes) {
		this.retryTimes = retryTimes;
	}
	public String getSyncStatusEnum() {
		return syncStatusEnum;
	}
	public void setSyncStatusEnum(String syncStatusEnum) {
		this.syncStatusEnum = syncStatusEnum;
	}
	public String getCreateTime() {
		return createTime;
	}
	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}
	public String getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(String updateTime) {
		this.updateTime = updateTime;
	}
	public String getXmlString() {
		return xmlString;
	}
	public void setXmlString(String xmlString) {
		this.xmlString = xmlString;
	}
	public String getModifyProperty() {
		return modifyProperty;
	}
	public void setModifyProperty(String modifyProperty) {
		this.modifyProperty = modifyProperty;
	}
	private Long id;
	private String objectTypeEnum;
	private String actionTypeEnum;
	private String errorMessage;
	private int retryTimes;
	private String syncStatusEnum;
	private String createTime;
	private String updateTime;
	private String xmlString;
	private String modifyProperty;
}
