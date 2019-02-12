package com.seeyon.apps.kdXdtzXc.po;

import java.math.BigDecimal;

public class CarAndShip {
	private String id;
	private String XHnumber;//序号
	private String JTType;//交通工具类型
	private BigDecimal cjFee;//车船机票费
	private BigDecimal QTfee;//其他差旅费
	private String FeeType;//费用类型
	private String beizhu;//备注
	private BigDecimal cczong;//车船总
	private BigDecimal qtzong;//其它总
	private String formrecid;//主表订单号
	
	public String getFormrecid() {
		return formrecid;
	}
	public void setFormrecid(String formrecid) {
		this.formrecid = formrecid;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getXHnumber() {
		return XHnumber;
	}
	public void setXHnumber(String xHnumber) {
		XHnumber = xHnumber;
	}
	public String getJTType() {
		return JTType;
	}
	public void setJTType(String jTType) {
		JTType = jTType;
	}
	public BigDecimal getCjFee() {
		return cjFee;
	}
	public void setCjFee(BigDecimal cjFee) {
		this.cjFee = cjFee;
	}
	public BigDecimal getQTfee() {
		return QTfee;
	}
	public void setQTfee(BigDecimal qTfee) {
		QTfee = qTfee;
	}
	public String getFeeType() {
		return FeeType;
	}
	public void setFeeType(String feeType) {
		FeeType = feeType;
	}
	public String getBeizhu() {
		return beizhu;
	}
	public void setBeizhu(String beizhu) {
		this.beizhu = beizhu;
	}
	public BigDecimal getCczong() {
		return cczong;
	}
	public void setCczong(BigDecimal cczong) {
		this.cczong = cczong;
	}
	public BigDecimal getQtzong() {
		return qtzong;
	}
	public void setQtzong(BigDecimal qtzong) {
		this.qtzong = qtzong;
	}
	public CarAndShip() {
		super();
		// TODO Auto-generated constructor stub
	}
	public CarAndShip(String id, String xHnumber, String jTType, BigDecimal cjFee, BigDecimal qTfee, String feeType, String beizhu, BigDecimal cczong, BigDecimal qtzong, String formrecid) {
		super();
		this.id = id;
		XHnumber = xHnumber;
		JTType = jTType;
		this.cjFee = cjFee;
		QTfee = qTfee;
		FeeType = feeType;
		this.beizhu = beizhu;
		this.cczong = cczong;
		this.qtzong = qtzong;
		this.formrecid = formrecid;
	}
	
	

}
