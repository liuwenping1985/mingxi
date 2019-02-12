package com.seeyon.apps.syncorg.exception;

import com.seeyon.ctp.common.exceptions.BusinessException;

public class CzOrgException extends BusinessException{


	private static final long serialVersionUID = 1L;
	
	public CzOrgException(String errorCode){
		this.errorCode = errorCode;
		this.extMessage = "";
	}
	
	public CzOrgException(String errorCode, String extMessage){
		this.errorCode = errorCode;
		this.extMessage = extMessage;
	}
	public String getErrorCode() {
		return errorCode;
	}
	public void setErrorCode(String errorCode) {
		this.errorCode = errorCode;
	}
	public String getExtMessage() {
		return extMessage;
	}
	public void setExtMessage(String extMessage) {
		this.extMessage = extMessage;
	}
	private String errorCode;
	private String extMessage;
}
