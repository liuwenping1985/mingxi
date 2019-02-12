package com.seeyon.apps.oadev.advsearch;

import com.seeyon.ctp.common.code.EnumsCode;

public enum FieldNameEnum implements EnumsCode  {
	

	Subject("Subject","内容"), 
	SyncStatusEnum("SyncStatusEnum","同步状态"),
	ObjectTypeEnum("ObjectTypeEnum","同步对象"),
	ActionTypeEnum("ActionTypeEnum","同步操作");
	
	private String key;
	private String text;

	private FieldNameEnum(String key, String text) {
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
	
    public static FieldNameEnum getEnumByKey(String key)
    {
      for (FieldNameEnum e : FieldNameEnum.values()) {
        if (e.getKey().equals(key)) {
          return e;
        }
      }
      return null;
    }
    
    public static FieldNameEnum getEnumByText(String text)
    {
      for (FieldNameEnum e : FieldNameEnum.values()) {
        if (e.getText().equals(text)) {
          return e;
        }
      }
      return null;
    }
}

