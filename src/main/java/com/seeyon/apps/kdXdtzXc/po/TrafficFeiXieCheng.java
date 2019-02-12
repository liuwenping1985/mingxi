package com.seeyon.apps.kdXdtzXc.po;

import java.math.BigDecimal;

public class TrafficFeiXieCheng {
	 private String id;    			//id   
	 private String xuhao;          //序号    
	 private String baoxiaofangshi ;//报销方式      
	 private String shifoupaiche;   //是否派车      
	 private String jine ;          //金额  
	 private String beizhu;         //备注    
	 private String  danhao ;       //单号       
	 private BigDecimal zheji;      //合计 小计   
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getXuhao() {
		return xuhao;
	}
	public void setXuhao(String xuhao) {
		this.xuhao = xuhao;
	}
	public String getBaoxiaofangshi() {
		return baoxiaofangshi;
	}
	public void setBaoxiaofangshi(String baoxiaofangshi) {
		this.baoxiaofangshi = baoxiaofangshi;
	}
	public String getShifoupaiche() {
		return shifoupaiche;
	}
	public void setShifoupaiche(String shifoupaiche) {
		this.shifoupaiche = shifoupaiche;
	}
	public String getJine() {
		return jine;
	}
	public void setJine(String jine) {
		this.jine = jine;
	}
	public String getBeizhu() {
		return beizhu;
	}
	public void setBeizhu(String beizhu) {
		this.beizhu = beizhu;
	}
	public String getDanhao() {
		return danhao;
	}
	public void setDanhao(String danhao) {
		this.danhao = danhao;
	}
	public BigDecimal getZheji() {
		return zheji;
	}
	public void setZheji(BigDecimal zheji) {
		this.zheji = zheji;
	}
	public TrafficFeiXieCheng() {
		super();
		// TODO Auto-generated constructor stub
	}
	public TrafficFeiXieCheng(String id, String xuhao, String baoxiaofangshi, String shifoupaiche, String jine, String beizhu, String danhao, BigDecimal zheji) {
		super();
		this.id = id;
		this.xuhao = xuhao;
		this.baoxiaofangshi = baoxiaofangshi;
		this.shifoupaiche = shifoupaiche;
		this.jine = jine;
		this.beizhu = beizhu;
		this.danhao = danhao;
		this.zheji = zheji;
	}
	@Override
	public String toString() {
		return "TrafficFeiXieCheng [id=" + id + ", xuhao=" + xuhao + ", baoxiaofangshi=" + baoxiaofangshi + ", shifoupaiche=" + shifoupaiche + ", jine=" + jine + ", beizhu=" + beizhu + ", danhao=" + danhao + ", zheji=" + zheji + "]";
	}
	 
}
