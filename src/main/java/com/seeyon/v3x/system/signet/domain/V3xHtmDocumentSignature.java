package com.seeyon.v3x.system.signet.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;

import com.seeyon.v3x.common.domain.BaseModel;
import com.seeyon.v3x.system.signet.enums.V3xHtmSignatureEnum;

public class V3xHtmDocumentSignature extends BaseModel {
	
	private static final long serialVersionUID = 1L;
	private java.sql.Timestamp dateTime;	// 签章时间
	private String fieldName;				// 字段名称
	private String fieldValue;				// 签章数据
	private String hostName;				// 签名主机
	private long summaryId;					// 文单ID
	private String userName;				// 用户名称
	private Long affairId;					// 文单ID
	private Integer signetType = V3xHtmSignatureEnum.HTML_SIGNATURE_DOCUMENT.getKey();// 签名类型, 默认网页签批

    public Long getAffairId() {
		return affairId;
	}

	public void setAffairId(Long affairId) {
		this.affairId = affairId;
	}

	public V3xHtmDocumentSignature() {
    }

	public java.sql.Timestamp getDateTime() {
		return this.dateTime;
	}
	public void setDateTime(java.sql.Timestamp dateTime) {
		this.dateTime = dateTime;
	}

	public String getFieldName() {
		return this.fieldName;
	}
	public void setFieldName(String fieldName) {
		this.fieldName = fieldName;
	}

	public String getFieldValue() {
		return this.fieldValue;
	}
	public void setFieldValue(String fieldValue) {
		this.fieldValue = fieldValue;
	}

	public String getHostName() {
		return this.hostName;
	}
	public void setHostName(String hostName) {
		this.hostName = hostName;
	}

	public long getSummaryId() {
		return this.summaryId;
	}
	public void setSummaryId(long summaryId) {
		this.summaryId = summaryId;
	}

	public String getUserName() {
		return this.userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String toString() {
		return new ToStringBuilder(this)
			.append("id", getId())
			.toString();
	}

    public Integer getSignetType() {
        return signetType;
    }

    public void setSignetType(Integer signetType) {
        this.signetType = signetType;
    }

}
