package com.seeyon.apps.custom.po;

import java.util.Date;

import com.seeyon.ctp.common.po.BasePO;

public class FORMMAIN_2859 extends BasePO{

	private Integer state =0;//审核状态
	private Long start_member_id = 0L;//发起人
	private Date start_date;//发起时间
	private Long approve_member_id = 0L;//审核人
	private Date approve_date;//审核时间
	private Integer finishedflag = 0;//流程状态
	private Integer ratifyflag = 0;//核定状态
	private Long ratify_member_id = 0L;//核定人
	private Date ratify_date;
	private Integer sort = 0;
	private Long modify_member_id = 0L;
	private Date modify_date;
	
	private String field0001;//分公司编码
	private String field0002;//分公司名称
	public Integer getState() {
		return state;
	}
	public void setState(Integer state) {
		this.state = state;
	}
	public Long getStart_member_id() {
		return start_member_id;
	}
	public void setStart_member_id(Long start_member_id) {
		this.start_member_id = start_member_id;
	}
	public Date getStart_date() {
		return start_date;
	}
	public void setStart_date(Date start_date) {
		this.start_date = start_date;
	}
	public Long getApprove_member_id() {
		return approve_member_id;
	}
	public void setApprove_member_id(Long approve_member_id) {
		this.approve_member_id = approve_member_id;
	}
	public Date getApprove_date() {
		return approve_date;
	}
	public void setApprove_date(Date approve_date) {
		this.approve_date = approve_date;
	}
	public Integer getFinishedflag() {
		return finishedflag;
	}
	public void setFinishedflag(Integer finishedflag) {
		this.finishedflag = finishedflag;
	}
	public Integer getRatifyflag() {
		return ratifyflag;
	}
	public void setRatifyflag(Integer ratifyflag) {
		this.ratifyflag = ratifyflag;
	}
	public Long getRatify_member_id() {
		return ratify_member_id;
	}
	public void setRatify_member_id(Long ratify_member_id) {
		this.ratify_member_id = ratify_member_id;
	}
	public Date getRatify_date() {
		return ratify_date;
	}
	public void setRatify_date(Date ratify_date) {
		this.ratify_date = ratify_date;
	}
	public Integer getSort() {
		return sort;
	}
	public void setSort(Integer sort) {
		this.sort = sort;
	}
	public Long getModify_member_id() {
		return modify_member_id;
	}
	public void setModify_member_id(Long modify_member_id) {
		this.modify_member_id = modify_member_id;
	}
	public Date getModify_date() {
		return modify_date;
	}
	public void setModify_date(Date modify_date) {
		this.modify_date = modify_date;
	}
	public String getField0001() {
		return field0001;
	}
	public void setField0001(String field0001) {
		this.field0001 = field0001;
	}
	public String getField0002() {
		return field0002;
	}
	public void setField0002(String field0002) {
		this.field0002 = field0002;
	}
	
	
}
