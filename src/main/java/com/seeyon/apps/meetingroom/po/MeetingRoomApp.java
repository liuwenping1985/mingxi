package com.seeyon.apps.meetingroom.po;

import java.util.Date;

import com.seeyon.ctp.common.po.BasePO;

/**
 * 唐桂林
 * @author Administrator
 *
 */
public class MeetingRoomApp extends BasePO implements java.io.Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -7889117136357249812L;
	
	/** 数据库主键UUID */
    private Long id;
    
    /** 会议室id */
    private Long roomId;
    
    /** 会 议id */
    private Long meetingId;
    
    /** 会议模板id */
    private Long templateId;
    
    /** 周期设置id */
    private Long periodicityId;
    
    /** 开始使用时间 */
    private Date startDatetime;
    
    /** 结束使用时间 */
    private Date endDatetime;
    
    /** 申请说明，用途 */
    private String description;

    /** 申请状态 */
    private Integer status;
    
    /** 使用状态 0正常 1提前结束 */
    private Integer usedStatus;
     
    /** 申请时间 */
    private Date appDatetime;
    
    /** 申请部门 */
    private Long departmentId;
    
    /** 申请人 */
    private Long perId;
    
    /** 审批人 */
    private Long auditingId;
    
    ////////////////////////////////////
    
    private boolean proxy;
    
    private Long proxyId;
    
    /** proxyName */
    private String proxyName;
    
    private boolean isFirstNotDisplay = false; //是否首页不显示(周期性会议只显示其中最近的一次会议)
   //项目  信达资产   公司  kimde  修改人  msg  修改时间    2017-11-09   修改功能   申请会议室页面添加申请人数量 和申请设备  start
   private  Integer peopleNumber;//人数
   private String shebei;//设备
   private String meetingType;//状态
   private String meetingmiaoshu;//描述
   //项目  信达资产   公司  kimde  修改人   msg  修改时间    2017-11-09   修改功能   申请会议室页面添加申请人数量 和申请设备  end

   public Long getId() {
	return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getRoomId() {
		return roomId;
	}
	public void setRoomId(Long roomId) {
		this.roomId = roomId;
	}
	public Long getMeetingId() {
		return meetingId;
	}
	public void setMeetingId(Long meetingId) {
		this.meetingId = meetingId;
	}
	public Long getTemplateId() {
		return templateId;
	}
	public void setTemplateId(Long templateId) {
		this.templateId = templateId;
	}
	public Long getPeriodicityId() {
		return periodicityId;
	}
	public void setPeriodicityId(Long periodicityId) {
		this.periodicityId = periodicityId;
	}
	public Date getStartDatetime() {
		return startDatetime;
	}
	public void setStartDatetime(Date startDatetime) {
		this.startDatetime = startDatetime;
	}
	public Date getEndDatetime() {
		return endDatetime;
	}
	public void setEndDatetime(Date endDatetime) {
		this.endDatetime = endDatetime;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	public Integer getUsedStatus() {
		return usedStatus;
	}
	public void setUsedStatus(Integer usedStatus) {
		this.usedStatus = usedStatus;
	}
	public Date getAppDatetime() {
		return appDatetime;
	}
	public void setAppDatetime(Date appDatetime) {
		this.appDatetime = appDatetime;
	}
	public Long getDepartmentId() {
		return departmentId;
	}
	public void setDepartmentId(Long departmentId) {
		this.departmentId = departmentId;
	}
	public Long getPerId() {
		return perId;
	}
	public void setPerId(Long perId) {
		this.perId = perId;
	}
	public Long getAuditingId() {
		return auditingId;
	}
	public void setAuditingId(Long auditingId) {
		this.auditingId = auditingId;
	}
	public boolean isProxy() {
		return proxy;
	}
	public void setProxy(boolean proxy) {
		this.proxy = proxy;
	}
	public Long getProxyId() {
		return proxyId;
	}
	public void setProxyId(Long proxyId) {
		this.proxyId = proxyId;
	}
	public String getProxyName() {
		return proxyName;
	}
	public void setProxyName(String proxyName) {
		this.proxyName = proxyName;
	}
	public boolean isFirstNotDisplay() {
		return isFirstNotDisplay;
	}
	public void setFirstNotDisplay(boolean isFirstNotDisplay) {
		this.isFirstNotDisplay = isFirstNotDisplay;
	}
	public Integer getPeopleNumber() {
		return peopleNumber;
	}
	public void setPeopleNumber(Integer peopleNumber) {
		this.peopleNumber = peopleNumber;
	}
	public String getShebei() {
		return shebei;
	}
	public void setShebei(String shebei) {
		this.shebei = shebei;
	}
	public String getMeetingType() {
		return meetingType;
	}
	public void setMeetingType(String meetingType) {
		this.meetingType = meetingType;
	}
	public String getMeetingmiaoshu() {
		return meetingmiaoshu;
	}
	public void setMeetingmiaoshu(String meetingmiaoshu) {
		this.meetingmiaoshu = meetingmiaoshu;
	}

   
 }