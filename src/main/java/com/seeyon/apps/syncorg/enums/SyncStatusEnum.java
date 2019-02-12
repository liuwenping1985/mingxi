package com.seeyon.apps.syncorg.enums;

import com.seeyon.ctp.common.code.EnumsCode;

/*
 * 在年度预算中， 用于是否是草稿的标志
 */
public enum SyncStatusEnum implements EnumsCode  {
	None(0, "未同步"),
	Failed(2, "失败"),
	Success(3, "成功"),
	UnSync(4, "不同步");
	
	private int key;
	private String text;

	private SyncStatusEnum(int key, String text) {
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
	
	
	 public static SyncStatusEnum getEnumByKey(int key)
	 {
	      for (SyncStatusEnum e : SyncStatusEnum.values()) {
	        if (e.getKey()==key) {
	          return e;
	        }
	      }
	      return null;
	 }
}


