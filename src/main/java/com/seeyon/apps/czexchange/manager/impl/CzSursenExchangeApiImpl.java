package com.seeyon.apps.czexchange.manager.impl;

import com.seeyon.apps.czexchange.manager.CzSursenReceiveManager;
import com.seeyon.apps.czexchange.manager.CzSursenSendManager;
import com.seeyon.apps.sursenexchange.api.SendToSursenParam;
import com.seeyon.apps.sursenexchange.api.SursenExchangeApi;
import com.seeyon.ctp.common.exceptions.BusinessException;

public class CzSursenExchangeApiImpl implements SursenExchangeApi {

	private CzSursenReceiveManager czSursenReceiveManager;
	private CzSursenSendManager czSursenSendManager;
	
	
	public CzSursenReceiveManager getCzSursenReceiveManager() {
		return czSursenReceiveManager;
	}

	public void setCzSursenReceiveManager(
			CzSursenReceiveManager czSursenReceiveManager) {
		this.czSursenReceiveManager = czSursenReceiveManager;
	}

	public CzSursenSendManager getCzSursenSendManager() {
		return czSursenSendManager;
	}

	public void setCzSursenSendManager(CzSursenSendManager czSursenSendManager) {
		this.czSursenSendManager = czSursenSendManager;
	}

	@Override
	public void exeReceiveEdoc() throws BusinessException {
		 czSursenReceiveManager.getSursenSummary();
		
	}

	@Override
	public boolean sendToSursen(SendToSursenParam param)
			throws BusinessException {
		return czSursenSendManager.sendToSursen(param);
	}

}
