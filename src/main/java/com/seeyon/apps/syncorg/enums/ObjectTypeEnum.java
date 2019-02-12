package com.seeyon.apps.syncorg.enums;

import com.seeyon.ctp.common.code.EnumsCode;

/*
 * 在年度预算中， 用于是否是草稿的标志
 */
public enum ObjectTypeEnum implements EnumsCode  {
	Account(0,"单位"),
	Department(1, "部门"), 
	Member(2, "人员"),
	Post(3, "岗位"),
	Level(4, "职务级别");

	private int key;
	private String text;

	private ObjectTypeEnum(int key, String text) {
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
	
	
	 public static ObjectTypeEnum getEnumByKey(int key)
	 {
	      for (ObjectTypeEnum e : ObjectTypeEnum.values()) {
	        if (e.getKey()==key) {
	          return e;
	        }
	      }
	      return null;
	 }
}


