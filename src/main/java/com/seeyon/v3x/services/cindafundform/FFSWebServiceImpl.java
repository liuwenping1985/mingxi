package com.seeyon.v3x.services.cindafundform;

import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.v3x.services.cindafundform.manager.FFSManager;
import com.seeyon.v3x.services.cindafundform.po.CindaFundForm;

public class FFSWebServiceImpl implements FFSWebService {
	private static final Log log = LogFactory.getLog(FFSWebServiceImpl.class);
	private FFSManager ffsManager;

	public FFSManager getFfsManager() {
		return ffsManager;
	}


	public void setFfsManager(FFSManager ffsManager) {
		this.ffsManager = ffsManager;
	}

	public String getFFS(String xml) {
		try {

			log.info("调用自动发起资金表单的XML："+xml);
			Map<String,Object> map = ffsManager.conversionXml(xml);
			if (map != null)
			{
				CindaFundForm form = (CindaFundForm)map.get("fundForm");

				return ffsManager.getFFSWS(form);
			}
			else
			{
				log.error("转换XML信息出错。");
				return "ERROR";
			}

		} catch (Exception e) {
			log.error("", e);
			return "ERROR";
		}
	}
}
