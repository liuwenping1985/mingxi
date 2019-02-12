package com.seeyon.apps.dev.doc.enums;

import com.seeyon.ctp.common.code.EnumsCode;

public enum FIleTypeEnum implements EnumsCode  {

	Edoc_WD(0, "底稿"),
	Edoc_ZW(1, "正文"),
	Edoc_FJ(2, "附件"),
	MY_FORM(3, "表单"),
	MY_EDOC(4, "公文");

	private int key;
	private String text;

	private FIleTypeEnum(int key, String text) {
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
	
	
	 public static FIleTypeEnum getEnumByKey(int key)
	 {
	      for (FIleTypeEnum e : FIleTypeEnum.values()) {
	        if (e.getKey()==key) {
	          return e;
	        }
	      }
	      return null;
	 }
}
