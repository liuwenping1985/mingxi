package com.seeyon.apps.kdXdtzXc.po;

import com.seeyon.apps.kdXdtzXc.base.ann.XmlField;
import com.seeyon.apps.kdXdtzXc.base.po.BasePOJO;

import java.util.Date;

/**
 * 财务部门接口PO
 */
public class CwOrgInfo implements BasePOJO {
    public static String className = CwOrgInfo.class.getName();
    private Long id;
    @XmlField("COM_CODE")
    private String comCode; //VARCHAR2(150) N 机构编码（财务的）
    
    @XmlField("COM_DESC")
    private String comDesc; //VARCHAR2(150) N 机构名称（财务的）

    @XmlField("COM_CODE_OA")
    private String comCodeOa; //VARCHAR2(150) N 机构编码（OA的）
    
    @XmlField("COM_DESC_OA")
    private String comDescOa; //VARCHAR2(150) N 机构名称（OA的）

    private Date insertTime;
    private Date updateTime;
    
    
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getComCode() {
		return comCode;
	}
	public void setComCode(String comCode) {
		this.comCode = comCode;
	}
	public String getComDesc() {
		return comDesc;
	}
	public void setComDesc(String comDesc) {
		this.comDesc = comDesc;
	}
	public String getComCodeOa() {
		return comCodeOa;
	}
	public void setComCodeOa(String comCodeOa) {
		this.comCodeOa = comCodeOa;
	}
	public String getComDescOa() {
		return comDescOa;
	}
	public void setComDescOa(String comDescOa) {
		this.comDescOa = comDescOa;
	}
	public Date getInsertTime() {
		return insertTime;
	}
	public void setInsertTime(Date insertTime) {
		this.insertTime = insertTime;
	}
	public Date getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}
    
	
}
