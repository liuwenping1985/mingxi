package com.seeyon.apps.czexchange.enums;

import com.seeyon.ctp.common.code.EnumsCode;

/*
 * 在年度预算中， 用于是否是草稿的标志
 */
public enum EdocSendOrReceiveStatusEnum implements EnumsCode  {
	unsend(0,"未发送"),
	send(1, "已经发送"), 
	sendReceived(2, "已经送达"),
	unReceived(3, "未接收"),
	Received(4, "已经接收"),
	sendReceipt(5, "成功发送回执");
	private int key;
	private String text;

	private EdocSendOrReceiveStatusEnum(int key, String text) {
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
	
	
	 public static EdocSendOrReceiveStatusEnum getEnumByKey(int key)
	 {
	      for (EdocSendOrReceiveStatusEnum e : EdocSendOrReceiveStatusEnum.values()) {
	        if (e.getKey()==key) {
	          return e;
	        }
	      }
	      return null;
	 }
}


