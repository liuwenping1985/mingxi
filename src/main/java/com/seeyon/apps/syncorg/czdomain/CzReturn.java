package com.seeyon.apps.syncorg.czdomain;

import com.seeyon.apps.syncorg.constants.ErrorMessageMap;
import com.thoughtworks.xstream.annotations.XStreamAlias;
@XStreamAlias("Return")
public class CzReturn {

	
	public CzReturn(boolean isSuccess, String errorCode){
		success = isSuccess ? "true":"false";
		errorMessage = ErrorMessageMap.getErrorMessage(errorCode);
	}
	
	public CzReturn(boolean isSuccess, String errorCode, String message, String extMessage){
		success = isSuccess ? "true":"false";
		errorMessage = ErrorMessageMap.getErrorMessage(errorCode) + " " + message + " " + extMessage;
	}
	
	public CzReturn(boolean isSuccess, String errorCode, String extMessage){
		success = isSuccess ? "true":"false";
		errorMessage = ErrorMessageMap.getErrorMessage(errorCode) + " " + extMessage;
	}
	public String getSuccess() {
		return success;
	}
	public void setSuccess(String success) {
		this.success = success;
	}
	public String getErrorMessage() {
		return errorMessage;
	}
	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}
	private String success;
	private String errorMessage;
}
