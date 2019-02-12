package com.seeyon.apps.czexchange.po;

import java.util.Date;

import com.seeyon.ctp.common.po.BasePO;


public class EdocReceiptLog extends BasePO {

	private Date createDate;
	private String msgId;
	private String status;
	private Integer tryTimes;
	private boolean success;
	
	



	public Date getCreateDate() {
		return createDate;
	}



	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}



	public String getMsgId() {
		return msgId;
	}



	public void setMsgId(String msgId) {
		this.msgId = msgId;
	}



	public String getStatus() {
		return status;
	}



	public void setStatus(String status) {
		this.status = status;
	}



	public Integer getTryTimes() {
		return tryTimes;
	}



	public void setTryTimes(Integer tryTimes) {
		this.tryTimes = tryTimes;
	}



	public boolean getSuccess() {
		return success;
	}



	public void setSuccess(boolean success) {
		this.success = success;
	}

	public EdocReceiptLog(){
		this.success = false;
		this.setIdIfNew();
		this.tryTimes = 1;
		this.createDate = new Date();
	}

	public EdocReceiptLog(String msgId, String status){
		this.msgId = msgId;
		this.status = status;
		this.success = false;
		this.setIdIfNew();
		this.tryTimes = 1;
		this.createDate = new Date();
	}
	
}
