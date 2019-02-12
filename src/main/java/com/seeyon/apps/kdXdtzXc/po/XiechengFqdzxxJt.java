package com.seeyon.apps.kdXdtzXc.po;

import java.io.Serializable;

import com.seeyon.apps.kdXdtzXc.base.ann.ColField;
import com.seeyon.apps.kdXdtzXc.base.ann.POJO;

@POJO(desc = "携程发起对帐信息交通", tableName = "XIECHENG_FQDZXX_JT")
public class XiechengFqdzxxJt implements Serializable{
	
	@ColField(name = "ID", colCode = "ID")
    private Long id;
	
	@ColField(name = "年份", colCode = "YEAR")
    private String year;
	
	@ColField(name = "月份", colCode = "MONTH")
    private String month;
	
	@ColField(name = "提取时间", colCode = "TQ_TIME")
    private String tqTime;
	
	@ColField(name = "对账时间", colCode = "DZ_TIME")
    private String dzTime;
	
	@ColField(name = "预留字段1", colCode = "EXT_ATTR_1")
    private String extAttr1;
	
	@ColField(name = "预留字段2", colCode = "EXT_ATTR_2")
    private String extAttr2;
	
	@ColField(name = "预留字段3", colCode = "EXT_ATTR_3")
    private String extAttr3;
	//携程交通
	private String xcJT;
	//携程住宿
	private String xcZS;
	//携程总计
	private String xcZJ;
	//对账交通
	private String dzJT;
	//对账住宿
	private String dzZS;
	//对账总计
	private String dzZJ;
	//北京分公司
	private String bfType;
	//湖北
	private String hbType;
	//江苏
	private String jsType;
	//总部财务
	private String zbcw;
	//北分
	private String bfcw;
	//湖北
	private String hbcw;
	//江苏
	private String jscw;
	

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getYear() {
		return year;
	}

	public void setYear(String year) {
		this.year = year;
	}

	public String getMonth() {
		return month;
	}

	public void setMonth(String month) {
		this.month = month;
	}

	public String getTqTime() {
		return tqTime;
	}

	public void setTqTime(String tqTime) {
		this.tqTime = tqTime;
	}

	public String getDzTime() {
		return dzTime;
	}

	public void setDzTime(String dzTime) {
		this.dzTime = dzTime;
	}

	public String getExtAttr1() {
		return extAttr1;
	}

	public void setExtAttr1(String extAttr1) {
		this.extAttr1 = extAttr1;
	}

	public String getExtAttr2() {
		return extAttr2;
	}

	public void setExtAttr2(String extAttr2) {
		this.extAttr2 = extAttr2;
	}

	public String getExtAttr3() {
		return extAttr3;
	}

	public void setExtAttr3(String extAttr3) {
		this.extAttr3 = extAttr3;
	}

	public String getXcJT() {
		return xcJT;
	}

	public void setXcJT(String xcJT) {
		this.xcJT = xcJT;
	}

	public String getXcZS() {
		return xcZS;
	}

	public void setXcZS(String xcZS) {
		this.xcZS = xcZS;
	}

	public String getXcZJ() {
		return xcZJ;
	}

	public void setXcZJ(String xcZJ) {
		this.xcZJ = xcZJ;
	}

	public String getDzJT() {
		return dzJT;
	}

	public void setDzJT(String dzJT) {
		this.dzJT = dzJT;
	}

	public String getDzZS() {
		return dzZS;
	}

	public void setDzZS(String dzZS) {
		this.dzZS = dzZS;
	}

	public String getDzZJ() {
		return dzZJ;
	}

	public void setDzZJ(String dzZJ) {
		this.dzZJ = dzZJ;
	}

	public String getBfType() {
		return bfType;
	}

	public void setBfType(String bfType) {
		this.bfType = bfType;
	}

	public String getHbType() {
		return hbType;
	}

	public void setHbType(String hbType) {
		this.hbType = hbType;
	}

	public String getJsType() {
		return jsType;
	}

	public void setJsType(String jsType) {
		this.jsType = jsType;
	}

	public String getZbcw() {
		return zbcw;
	}

	public void setZbcw(String zbcw) {
		this.zbcw = zbcw;
	}

	public String getBfcw() {
		return bfcw;
	}

	public void setBfcw(String bfcw) {
		this.bfcw = bfcw;
	}

	public String getHbcw() {
		return hbcw;
	}

	public void setHbcw(String hbcw) {
		this.hbcw = hbcw;
	}

	public String getJscw() {
		return jscw;
	}

	public void setJscw(String jscw) {
		this.jscw = jscw;
	}
	
	
	
}
