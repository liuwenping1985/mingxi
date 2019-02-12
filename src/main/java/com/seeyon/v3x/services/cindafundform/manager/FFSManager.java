package com.seeyon.v3x.services.cindafundform.manager;

import java.util.Map;

import com.seeyon.v3x.services.cindafundform.po.CindaFundForm;


public interface FFSManager {
	String getFFSWS(CindaFundForm cindaFundForm);
	Map<String,Object> conversionXml(String crmXml);
}
