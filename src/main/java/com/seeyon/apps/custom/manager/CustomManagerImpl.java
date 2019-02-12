package com.seeyon.apps.custom.manager;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.custom.dao.CustomDao;

public class CustomManagerImpl implements CustomManager{
	
	private static final Log logger = LogFactory.getLog(CustomManagerImpl.class);
	
	private CustomDao customDao;

	public void setCustomDao(CustomDao customDao) {
		this.customDao = customDao;
	}

	@Override
	public Map<String, Object> isSecretary() {
		Map<String, Object> map = new HashMap<String, Object>();
		map = customDao.isSecretary();
		return map;
	}

	@Override
	public List<Long> queryallSecretary() {
		List<Long> lList = customDao.queryallSecretary();
		return lList;
	}
  
}
