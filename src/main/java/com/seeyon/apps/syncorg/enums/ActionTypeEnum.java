package com.seeyon.apps.syncorg.enums;

import com.seeyon.ctp.common.code.EnumsCode;

/*
 * 在年度预算中， 用于是否是草稿的标志
 */
public enum ActionTypeEnum implements EnumsCode  {
	Add(0,"新增"),
	Update(1, "更新"), 
	Delete(2, "删除"),
	Enable(3, "启用"),
	Disable(4, "停用"),
	AddOrUpdate(5, "新增或者修改");

	private int key;
	private String text;

	private ActionTypeEnum(int key, String text) {
		this.key = key;
		this.text = text;
	}

	public String getValue() {
		return String.valueOf(this.key);
	}

	public int getKey() {
		return this.key;
	}

	public String getText() {
		return this.text;
	}
	
	
	 public static ActionTypeEnum getEnumByKey(int key)
	 {
	      for (ActionTypeEnum e : ActionTypeEnum.values()) {
	        if (e.getKey()==key) {
	          return e;
	        }
	      }
	      return null;
	 }
}


