package com.seeyon.apps.czexchange.dao;

public interface CzThirdPartOrgDao {

	public String getThridAccountIdByName(String thirdAccountName);
	
	public String getThirdAccountCodeByThirdId(String thirdId);
	
	public String getThridAccountIdByCode(String thirdAccountCode);
}
