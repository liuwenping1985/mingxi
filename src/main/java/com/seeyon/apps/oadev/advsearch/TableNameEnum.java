package com.seeyon.apps.oadev.advsearch;

import com.seeyon.ctp.common.code.EnumsCode;

public enum TableNameEnum implements EnumsCode  {
	SyncLog("SyncLog", "同步日志表");

	private String key;
	private String text;

	private TableNameEnum(String key, String text) {
		this.key = key;
		this.text = text;
		
		com.seeyon.ctp.common.supervise.controller.SuperviseController c;
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
	
    public static TableNameEnum getEnumByKey(String key)
    {
      for (TableNameEnum e : TableNameEnum.values()) {
        if (e.getKey().equals(key)) {
          return e;
        }
      }
      return null;
    }
}

