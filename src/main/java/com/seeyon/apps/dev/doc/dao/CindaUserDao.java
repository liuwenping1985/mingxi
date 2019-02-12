package com.seeyon.apps.dev.doc.dao;

import com.seeyon.apps.cinda.authority.domain.UmOrganization;
import com.seeyon.apps.cinda.authority.domain.UmUser;


public abstract interface CindaUserDao {
	public UmOrganization getOrgByName(String name);
	public UmOrganization getOrgById(String Id);
	public UmUser getbyLoginNane(String loginName);
}
