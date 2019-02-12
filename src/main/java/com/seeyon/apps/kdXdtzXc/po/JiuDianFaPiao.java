package com.seeyon.apps.kdXdtzXc.po;

import java.math.BigDecimal;

public class JiuDianFaPiao {
	private String id;
	private String xuhao;
	private String zhuanpiao;//是否专票
	private BigDecimal jsheji;//价税合计
	private BigDecimal jine;//金额
	private BigDecimal shuie;//税额
	private String shuil;//税率
	private String fapiaohao;//发票编号
	private BigDecimal heji;//小计
	private String formid;//订单号
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getZhuanpiao() {
		return zhuanpiao;
	}
	public void setZhuanpiao(String zhuanpiao) {
		this.zhuanpiao = zhuanpiao;
	}
	public BigDecimal getJsheji() {
		return jsheji;
	}
	public void setJsheji(BigDecimal jsheji) {
		this.jsheji = jsheji;
	}
	public BigDecimal getJine() {
		return jine;
	}
	public void setJine(BigDecimal jine) {
		this.jine = jine;
	}
	public BigDecimal getShuie() {
		return shuie;
	}
	public void setShuie(BigDecimal shuie) {
		this.shuie = shuie;
	}
	public String getShuil() {
		return shuil;
	}
	public void setShuil(String shuil) {
		this.shuil = shuil;
	}
	public String getFapiaohao() {
		return fapiaohao;
	}
	public void setFapiaohao(String fapiaohao) {
		this.fapiaohao = fapiaohao;
	}
	public BigDecimal getHeji() {
		return heji;
	}
	public void setHeji(BigDecimal heji) {
		this.heji = heji;
	}
	public String getXuhao() {
		return xuhao;
	}
	public void setXuhao(String xuhao) {
		this.xuhao = xuhao;
	}
	
	public String getFormid() {
		return formid;
	}
	public void setFormid(String formid) {
		this.formid = formid;
	}
	public JiuDianFaPiao() {
		super();
		// TODO Auto-generated constructor stub
	}
	public JiuDianFaPiao(String id, String xuhao, String zhuanpiao, BigDecimal jsheji, BigDecimal jine, BigDecimal shuie, String shuil, String fapiaohao, BigDecimal heji, String formid) {
		super();
		this.id = id;
		this.xuhao = xuhao;
		this.zhuanpiao = zhuanpiao;
		this.jsheji = jsheji;
		this.jine = jine;
		this.shuie = shuie;
		this.shuil = shuil;
		this.fapiaohao = fapiaohao;
		this.heji = heji;
		this.formid = formid;
	}
	@Override
	public String toString() {
		return "JiuDianFaPiao [id=" + id + ", xuhao=" + xuhao + ", zhuanpiao=" + zhuanpiao + ", jsheji=" + jsheji + ", jine=" + jine + ", shuie=" + shuie + ", shuil=" + shuil + ", fapiaohao=" + fapiaohao + ", heji=" + heji + ", formid=" + formid + "]";
	}
	
	

}
