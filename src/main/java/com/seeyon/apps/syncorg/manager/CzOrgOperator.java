package com.seeyon.apps.syncorg.manager;

import com.seeyon.apps.syncorg.exception.CzOrgException;
import com.seeyon.ctp.organization.bo.OrganizationMessage;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;

public interface CzOrgOperator {

	
	public OrganizationMessage addAccount(V3xOrgAccount account, V3xOrgMember member)  throws CzOrgException;
	
	public OrganizationMessage addDepartment(V3xOrgDepartment department)  throws CzOrgException;
	
}
