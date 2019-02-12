package com.seeyon.apps.kdXdtzXc.po;

import java.io.Serializable;

import com.seeyon.apps.kdXdtzXc.base.ann.ColField;
import com.seeyon.apps.kdXdtzXc.base.ann.POJO;

@POJO(desc = "携程发起对帐信息住宿", tableName = "XIECHENG_FQDZXX_ZS")
public class XiechengFqdzxxZs implements Serializable{
	
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
	
}
