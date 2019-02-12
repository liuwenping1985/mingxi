package com.seeyon.apps.checkin.domain;

import java.io.Serializable;
import java.util.Date;

import com.seeyon.v3x.common.domain.BaseModel;

/**
 * 考勤查询
 * @author yangli
 *
 */
public class depCheckIn extends BaseModel implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Long id;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	// 姓名
	private String name ;
	
	//性别
	private String  gender;
	
	//员工编号
	private String usercode;
	
	// 员工id
	private String userid;
	
	//职务级别
	private String postionlevel;
	
	// 部门
	private String department ;	
	
	//二级部门
	private String cdepartment;
	
	
	// 异常次数
	private String bugNum ;	
	
	// 迟到早退次数
	private String lateNum ;	
	
	// 病假
	private String sickNum ;	
	
	// 事假
	private String absenceNum ;	
	
	// 年休假
	private String annualNum ;	
	
	// 公假
	private String publicNum ;	
	
	// 婚丧假
	private String funeralNum ;	
	
	// 探亲假
	private String travelNum ;	
	
	// 产假
	private String maternityNum ;	
	
	//探亲假
	private String gohomenum ;
	
	// 是否完成流程填报
	private String isFinish ;
	
	// 打卡日期
	private Date checkDate ;
	
	private String path ;

	public Date getCheckDate() {
		return checkDate;
	}

	public void setCheckDate(Date checkDate) {
		this.checkDate = checkDate;
	}

	public String getGohomenum() {
		return gohomenum;
	}
	
	public void setGohomenum(String gohomenum) {
		this.gohomenum = gohomenum;
	}
	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public String getCdepartment() {
		return cdepartment;
	}

	public void setCdepartment(String cdepartment) {
		this.cdepartment = cdepartment;
	}

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	public String getUsercode() {
		return usercode;
	}

	public void setUsercode(String usercode) {
		this.usercode = usercode;
	}

	public String getPostionlevel() {
		return postionlevel;
	}

	public void setPostionlevel(String postionlevel) {
		this.postionlevel = postionlevel;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getBugNum() {
		return bugNum;
	}

	public void setBugNum(String bugNum) {
		this.bugNum = bugNum;
	}

	public String getLateNum() {
		return lateNum;
	}

	public void setLateNum(String lateNum) {
		this.lateNum = lateNum;
	}

	public String getSickNum() {
		return sickNum;
	}

	public void setSickNum(String sickNum) {
		this.sickNum = sickNum;
	}

	public String getAbsenceNum() {
		return absenceNum;
	}

	public void setAbsenceNum(String absenceNum) {
		this.absenceNum = absenceNum;
	}

	public String getAnnualNum() {
		return annualNum;
	}

	public void setAnnualNum(String annualNum) {
		this.annualNum = annualNum;
	}

	public String getPublicNum() {
		return publicNum;
	}

	public void setPublicNum(String publicNum) {
		this.publicNum = publicNum;
	}

	public String getFuneralNum() {
		return funeralNum;
	}

	public void setFuneralNum(String funeralNum) {
		this.funeralNum = funeralNum;
	}

	public String getTravelNum() {
		return travelNum;
	}

	public void setTravelNum(String travelNum) {
		this.travelNum = travelNum;
	}

	public String getMaternityNum() {
		return maternityNum;
	}

	public void setMaternityNum(String maternityNum) {
		this.maternityNum = maternityNum;
	}

	public String getDepartment() {
		return department;
	}

	public void setDepartment(String department) {
		this.department = department;
	}

	public String getIsFinish() {
		return isFinish;
	}

	public void setIsFinish(String isFinish) {
		this.isFinish = isFinish;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}	
		
}
