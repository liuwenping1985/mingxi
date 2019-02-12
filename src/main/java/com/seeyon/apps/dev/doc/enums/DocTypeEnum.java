package com.seeyon.apps.dev.doc.enums;

import com.seeyon.ctp.common.code.EnumsCode;


public enum DocTypeEnum implements EnumsCode  {
	form(0, "表单"),
	edoc(1, "公文"),
	doc(2, "文档");

	private int key;
	private String text;

	private DocTypeEnum(int key, String text) {
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
	
	
	 public static DocTypeEnum getEnumByKey(int key)
	 {
	      for (DocTypeEnum e : DocTypeEnum.values()) {
	        if (e.getKey()==key) {
	          return e;
	        }
	      }
	      return null;
	 }
}

