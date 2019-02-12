package com.seeyon.apps.kdXdtzXc.po;

import com.seeyon.apps.kdXdtzXc.base.ann.XmlField;

import java.io.Serializable;
import java.util.Date;
/**
 * 财务项目信息接口
 */
public class CwProject implements Serializable {
    public static String className = CwProject.class.getName();
    private Long id;
    
    @XmlField("PROJECT_NAME")
    private String projectName; //VARCHAR2(240) N 项目名称
    
    @XmlField("PROJECT_CODE")
    private String projectCode; //VARCHAR2(100) N 项目编码
    
    @XmlField("COM_CODE")
    private String comCode; //VARCHAR2(150) N 机构编码（财务的）
    
    @XmlField("COM_DESC")
    private String comDesc; //VARCHAR2(150) N 机构名称（财务的）

    private Date insertTime;
    private Date updateTime;
    
    
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getProjectName() {
		return projectName;
	}
	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}
	public String getProjectCode() {
		return projectCode;
	}
	public void setProjectCode(String projectCode) {
		this.projectCode = projectCode;
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
