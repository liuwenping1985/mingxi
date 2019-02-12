package com.seeyon.apps.kdXdtzXc.po;

import java.io.Serializable;

import com.seeyon.apps.kdXdtzXc.base.ann.ColField;
import com.seeyon.apps.kdXdtzXc.base.ann.POJO;

@POJO(desc = "住宿权限", tableName = "XIECHENG_ZHUSU_QX")
public class XiechengZhusuQx implements Serializable {

	@ColField(name = "ID", colCode = "ID")
	private Long id;
	@ColField(name = "序号", colCode = "NUMBERS")
	private Long numbers;
	@ColField(name = "职级", colCode = "LEVEL_NAME;")
	private String levelName;
	@ColField(name = "酒店类型", colCode = "HOTEL_TYPE;")
	private String hotelType;
	@ColField(name = "费用", colCode = "AMOUNT;")
	private Double amount;
	@ColField(name = "创建时间", colCode = "CREATE_TIME;")
	private String createTime;
	@ColField(name = "修改时间", colCode = "UPDATE_TIME;")
	private String updateTime;
	//预留字段
	@ColField(name = "预留字段1", colCode = "EXT_ATTR_1;")
	private String extAttr1;
	@ColField(name = "预留字段2", colCode = "EXT_ATTR_2;")
	private String extAttr2;
	@ColField(name = "预留字段3", colCode = "EXT_ATTR_3;")
	private String extAttr3;
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getNumbers() {
		return numbers;
	}
	public void setNumbers(Long numbers) {
		this.numbers = numbers;
	}
	public String getLevelName() {
		return levelName;
	}
	public void setLevelName(String levelName) {
		this.levelName = levelName;
	}
	public String getHotelType() {
		return hotelType;
	}
	public void setHotelType(String hotelType) {
		this.hotelType = hotelType;
	}
	public Double getAmount() {
		return amount;
	}
	public void setAmount(Double amount) {
		this.amount = amount;
	}
	public String getCreateTime() {
		return createTime;
	}
	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}
	public String getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(String updateTime) {
		this.updateTime = updateTime;
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
