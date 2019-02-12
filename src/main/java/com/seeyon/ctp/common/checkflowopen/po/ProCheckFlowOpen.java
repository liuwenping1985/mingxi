package com.seeyon.ctp.common.checkflowopen.po;

import com.seeyon.v3x.common.domain.BaseModel;

public class ProCheckFlowOpen extends BaseModel implements java.io.Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -3336920163223871945L;

	private Long affairId;
	
	private String currentOpenUser;
	
	public ProCheckFlowOpen() {
		   super();
		}

	public ProCheckFlowOpen(Long affairId, String currentOpenUser) {
		super();
		this.affairId = affairId;
		this.currentOpenUser = currentOpenUser;
	}
	

	public Long getAffairId() {
		return affairId;
	}

	public void setAffairId(Long affairId) {
		this.affairId = affairId;
	}

	public String getCurrentOpenUser() {
		return currentOpenUser;
	}

	public void setCurrentOpenUser(String currentOpenUser) {
		this.currentOpenUser = currentOpenUser;
	}

}
