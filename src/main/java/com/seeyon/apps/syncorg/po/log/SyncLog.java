package com.seeyon.apps.syncorg.po.log;

import java.util.Date;

import com.seeyon.apps.syncorg.enums.ActionTypeEnum;
import com.seeyon.apps.syncorg.enums.ObjectTypeEnum;
import com.seeyon.apps.syncorg.enums.SyncStatusEnum;
import com.seeyon.ctp.common.po.BasePO;

public class SyncLog extends BasePO {


	public SyncLog(){
		super();
	}
	public SyncLog(ObjectTypeEnum objectTypeEnum, ActionTypeEnum actionTypeEnum, String xmlString){

		this.objectTypeEnum = objectTypeEnum;
		this.actionTypeEnum = actionTypeEnum;
		this.xmlString = xmlString;
		this.syncStatusEnum = SyncStatusEnum.None;
		this.createTime = new Date();
		this.updateTime = new Date();
		this.retryTimes = 0;
		this.modifyProperty = "";
	}

	public ObjectTypeEnum getObjectTypeEnum() {
		return objectTypeEnum;
	}
	public void setObjectTypeEnum(ObjectTypeEnum objectTypeEnum) {
		this.objectTypeEnum = objectTypeEnum;
	}
	public ActionTypeEnum getActionTypeEnum() {
		return actionTypeEnum;
	}
	public void setActionTypeEnum(ActionTypeEnum actionTypeEnum) {
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
	public SyncStatusEnum getSyncStatusEnum() {
		return syncStatusEnum;
	}
	public void setSyncStatusEnum(SyncStatusEnum syncStatusEnum) {
		this.syncStatusEnum = syncStatusEnum;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public Date getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}
	public String getXmlString() {
		return xmlString;
	}
	public void setXmlString(String xmlString) {
		this.xmlString = xmlString;
	}

	private ObjectTypeEnum objectTypeEnum;
	private ActionTypeEnum actionTypeEnum;
	private String errorMessage;
	private int retryTimes;
	private SyncStatusEnum syncStatusEnum;
	private Date createTime;
	private Date updateTime;
	private String xmlString;
	private String modifyProperty;
	public String getModifyProperty() {
		return modifyProperty;
	}
	public void setModifyProperty(String modifyProperty) {
		this.modifyProperty = modifyProperty;
	}
	
}
