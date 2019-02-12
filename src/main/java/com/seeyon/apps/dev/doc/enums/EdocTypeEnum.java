package com.seeyon.apps.dev.doc.enums;

import com.seeyon.ctp.common.code.EnumsCode;


public enum EdocTypeEnum implements EnumsCode  {
	sendEdoc(0, "发文"),
	recEdoc(1, "收文"),
	signEdoc(2, "签报");

	private int key;
	private String text;

	private EdocTypeEnum(int key, String text) {
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
	
	
	 public static EdocTypeEnum getEnumByKey(int key)
	 {
	      for (EdocTypeEnum e : EdocTypeEnum.values()) {
	        if (e.getKey()==key) {
	          return e;
	        }
	      }
	      return null;
	 }
}

