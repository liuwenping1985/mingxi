package com.seeyon.apps.cindaedoc.po;

import com.seeyon.v3x.common.domain.BaseModel;

public class EdocDetailMsgid extends BaseModel {

	private static final long serialVersionUID = 4262833950671613750L;
	private Long detailId;
	private String msgId;
	private Long recordId;
	public Long getRecordId() {
		return recordId;
	}
	public void setRecordId(Long recordId) {
		this.recordId = recordId;
	}
	public Long getDetailId() {
		return detailId;
	}
	public void setDetailId(Long detailId) {
		this.detailId = detailId;
	}
	public String getMsgId() {
		return msgId;
	}
	public void setMsgId(String msgId) {
		this.msgId = msgId;
	}
}