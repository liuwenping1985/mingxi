package com.seeyon.ctp.common.encrypt;

import com.seeyon.ctp.common.exceptions.BusinessException;

public class CoderException extends BusinessException {

	private static final long serialVersionUID = 1L;

	public CoderException() {
		super();
	}
	
	public CoderException(Throwable cause) {
		super(cause);
	}

	public CoderException(String errorCode, Object... errorArgs) {
		super(errorCode, errorArgs);
	}

	public CoderException(Throwable cause, String errorCode,
			Object... errorArgs) {
		super(cause, errorCode, errorArgs);
	}
}