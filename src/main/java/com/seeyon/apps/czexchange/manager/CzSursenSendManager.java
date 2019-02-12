package com.seeyon.apps.czexchange.manager;

import com.seeyon.apps.sursenexchange.api.SendToSursenParam;
import com.seeyon.ctp.common.exceptions.BusinessException;

public interface CzSursenSendManager {

	
	  public abstract boolean sendToSursen(SendToSursenParam paramSendToSursenParam)
			    throws BusinessException;
}
