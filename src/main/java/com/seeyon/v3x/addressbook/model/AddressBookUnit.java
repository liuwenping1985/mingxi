package com.seeyon.v3x.addressbook.model;

import com.seeyon.ctp.util.Strings;


/**
 * 通用的单位，部门 对象
 * @author wf
 *
 */
public class AddressBookUnit {
	/**
	 * id
	 */
	private Long I;
	/**
	 * 所属单位id
	 */
	private Long AId;
	/**
	 * 名称
	 */
	private String N;
	/**
	 * 简称
	 */
	private String Sn;
	/**
	 * 父单位/部门Id
	 */
	private Long PId;
	/**
	 * 总人数
	 * 只统计部门下的总人数
	 */
	private Integer Nm;
	/**
	 * 类型
	 * @return
	 */
	private String T;
	/**
	 * 编码
	 * @return
	 */
	private String C;
	/**
	 * 企业logo，只是集团或者企业版单位有
	 * @return
	 */
	private String L;
	/**
	 * 当前path
	 */
	private String ph;
	/**
	 * 父path
	 */
	private String pph;
	/**
	 * 是否内部部门 1：内部部门，0：外部部门
	 */
	private String in;
	public Long getI() {
		return I;
	}
	public void setI(Long i) {
		I = i;
	}
	public Long getAId() {
		return AId;
	}
	public void setAId(Long aId) {
		AId = aId;
	}
	public String getN() {
		return N;
	}
	public void setN(String n) {
		N = n;
	}
	public Long getPId() {
		return PId;
	}
	public void setPId(Long pId) {
		PId = pId;
	}
	public Integer getNm() {
		return Nm;
	}
	public void setNm(Integer nm) {
		Nm = nm;
	}
	public String getSn() {
		return Sn;
	}
	public void setSn(String sn) {
		Sn = sn;
	}
	public String getT() {
		return T;
	}
	public void setT(String t) {
		T = t;
	}
	public String getC() {
		return C;
	}
	public void setC(String c) {
		C = c;
	}
	public String getL() {
		return L;
	}
	public void setL(String l) {
		L = l;
	}
	public String getPh() {
		return ph;
	}
	public void setPh(String ph) {
		this.ph = ph;
	}
	public String getPph() {
		return pph;
	}
	public void setPph(String pph) {
		this.pph = pph;
	}
	public String getIn() {
		if(Strings.isBlank(in)){
			in = "1";
		}
		return in;
	}
	public void setIn(Boolean isInternal) {
		this.in = "1";
		if(!isInternal){
			this.in = "0";
		}
	}

}
