package com.seeyon.apps.oadev.advsearch;

import com.seeyon.ctp.common.code.EnumsCode;

public enum FieldTypeEnum implements EnumsCode  {
	Subject("Subject", "文本"), 
	ObjectTypeEnum("ObjectTypeEnum","同步对象"),
	ActionTypeEnum("ActionTypeEnum","同步操作"),
	SyncStatusEnum("SyncStatusEnum","同步状态");
	
	private String key;
	private String text;

	private FieldTypeEnum(String key, String text) {
		this.key = key;
		this.text = text;
	}

	public String getValue() {
		return String.valueOf(this.key);
	}

	public String getKey() {
		return this.key;
	}

	public String getText() {
		return this.text;
	}
	
    public static FieldTypeEnum getEnumByKey(String key)
    {
      for (FieldTypeEnum e : FieldTypeEnum.values()) {
        if (e.getKey().equals(key)) {
          return e;
        }
      }
      return null;
    }
}

