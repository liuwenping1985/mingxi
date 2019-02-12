
package com.seeyon.apps.custom.manager;

import java.util.List;
import java.util.Map;

public interface CustomManager {
	
	/**
	 * 是否为秘书
	 */
	public Map<String,Object> isSecretary();
	
	/**
	 * 查询所有秘书
	 */
	public List<Long> queryallSecretary();
	
}
