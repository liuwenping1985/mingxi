package com.seeyon.apps.checkin.domain;

import java.io.Serializable;

import com.seeyon.v3x.common.domain.BaseModel;

public class NoStaticCheckinUser extends BaseModel implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1146285988768101232L;

	private String uid ;
	
	private String usercode;
	
	private String username;

	public String getUid() {
		return uid;
	}

	public void setUid(String uid) {
		this.uid = uid;
	}

	public String getUsercode() {
		return usercode;
	}

	public void setUsercode(String usercode) {
		this.usercode = usercode;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}
	
	
}
