package com.seeyon.apps.oadev.advsearch.manager;

import java.util.List;

import com.seeyon.ctp.common.exceptions.BusinessException;

public interface CzComponentManager {

	public abstract List<String[]> getFormConditionHTML(String tableBeanName,
			List<String> fieldNames, List<String> operations,
			List<Object> values);
}
