package com.seeyon.apps.cindafundform.po;

import com.seeyon.v3x.common.domain.BaseModel;

/**
 * CindaFundFormErrorInfo generated by hbm2java
 */
public class CindaFundFormErrorInfo extends BaseModel implements java.io.Serializable {

    /**
	 *
	 */
	private static final long serialVersionUID = 1L;
	private Long id;
	private String idnum;
	private String xmlData;

	public CindaFundFormErrorInfo() {
	   super();
	}

	public CindaFundFormErrorInfo(String idnum, String xmlData) {
		super();
		this.setIdnum(idnum);
		this.xmlData = xmlData;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getXmlData() {
		return xmlData;
 	}
	public void setXmlData(String xmlData) {
		this.xmlData = xmlData;
	}

	public String getIdnum() {
		return idnum;
	}

	public void setIdnum(String idnum) {
		this.idnum = idnum;
	}
}
