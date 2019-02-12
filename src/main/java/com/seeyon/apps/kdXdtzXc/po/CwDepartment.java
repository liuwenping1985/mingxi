package com.seeyon.apps.kdXdtzXc.po;

import com.seeyon.apps.kdXdtzXc.base.ann.XmlField;
import com.seeyon.apps.kdXdtzXc.base.po.BasePOJO;

import java.io.Serializable;
import java.util.Date;

/**
  * 财务部门接口PO
 */
public class CwDepartment implements Serializable {
	public static String className = CwDepartment.class.getName();

	private Long id;

	@XmlField("DEP_CODE")
	private String depCode; // VARCHAR2(150) N 机构编码（财务的）

	@XmlField("DEP_DESC")
	private String depDesc; // VARCHAR2(150) N 机构名称（财务的）

	@XmlField("DEP_CODE_OA")
	private String depCodeOa; // VARCHAR2(150) N 机构编码（OA的）

	@XmlField("DEP_DESC_OA")
	private String depDescOa; // VARCHAR2(150) N 机构名称（OA的）

	private Date insertTime;
	private Date updateTime;
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getDepCode() {
		return depCode;
	}
	public void setDepCode(String depCode) {
		this.depCode = depCode;
	}
	public String getDepDesc() {
		return depDesc;
	}
	public void setDepDesc(String depDesc) {
		this.depDesc = depDesc;
	}
	public String getDepCodeOa() {
		return depCodeOa;
	}
	public void setDepCodeOa(String depCodeOa) {
		this.depCodeOa = depCodeOa;
	}
	public String getDepDescOa() {
		return depDescOa;
	}
	public void setDepDescOa(String depDescOa) {
		this.depDescOa = depDescOa;
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
