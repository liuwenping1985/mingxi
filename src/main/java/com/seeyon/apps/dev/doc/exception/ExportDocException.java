package com.seeyon.apps.dev.doc.exception;

import com.seeyon.ctp.common.exceptions.BusinessException;

public class ExportDocException extends BusinessException{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8021349007149417342L;
	  public ExportDocException() {}
	  
	  public ExportDocException(String message){
		  super(message);
	  }
	  public ExportDocException(Throwable cause){
		  super(cause);
	  }
	  public ExportDocException(String message, Throwable cause){
		  super(message, cause);
	  }
	  
}
