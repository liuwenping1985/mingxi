package com.seeyon.apps.czexchange.manager;

import java.util.List;

import com.seeyon.apps.sursenExchange.po.MidReceiveSummary;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.filemanager.V3XFile;

public interface CzSursenReceiveManager {

	  public abstract void saveReceiveSummary(MidReceiveSummary paramMidReceiveSummary)
			    throws BusinessException;
			  
			  public abstract void updateReceiveSummary(MidReceiveSummary paramMidReceiveSummary)
			    throws BusinessException;
			  
			  public abstract MidReceiveSummary getReceiveSummaryById(Long paramLong)
			    throws BusinessException;
			  
			  public abstract void getSursenSummary();
			  
			  public abstract void saveFile(List<V3XFile> paramList);
}
