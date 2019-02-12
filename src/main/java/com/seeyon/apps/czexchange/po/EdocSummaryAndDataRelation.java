package com.seeyon.apps.czexchange.po;

import com.seeyon.ctp.common.po.BasePO;


public class EdocSummaryAndDataRelation extends BasePO {

	/**
	 * 收文、发文、OA 中公文的Id 和消息 msgId 的对应表
	 * 需要特别注意的地方：  一个  msgId 唯一对应这张表中的一条记录， 但是， 一个  edocId 会对应这张表中的多条记录
	 * 为了接收已经发送的公文的回执， 必须一个单位一条记录， 这样， 在收到回执的 msgId 的时候， 就能够区分开是哪个单位发送回来回执了
	 */
	private static final long serialVersionUID = -6900110532039811207L;

	private Integer status;
	
	private String thirdId;

	private Integer app;

	private Long edocId;
	
	private String msgId;
	
	private Long accountId;

	


	public String getThirdId() {
		return thirdId;
	}

	public void setThirdId(String thirdId) {
		this.thirdId = thirdId;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public Integer getApp() {
		return app;
	}

	public void setApp(Integer app) {
		this.app = app;
	}

	public Long getEdocId() {
		return edocId;
	}

	public void setEdocId(Long edocId) {
		this.edocId = edocId;
	}

	public String getMsgId() {
		return msgId;
	}

	public void setMsgId(String msgId) {
		this.msgId = msgId;
	}

	public Long getAccountId() {
		return accountId;
	}

	public void setAccountId(Long accountId) {
		this.accountId = accountId;
	}


}