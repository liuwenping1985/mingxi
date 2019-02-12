package com.seeyon.apps.syncorg.manager.impl;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.syncorg.exception.CzOrgException;
import com.seeyon.apps.syncorg.manager.CzOrgOperator;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.bo.OrganizationMessage;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManagerDirect;

public class CzOrgOperatorImpl implements CzOrgOperator{

	private OrgManagerDirect orgManagerDirect;
	private static final Log log = LogFactory.getLog(CzOrgOperatorImpl.class);
	public OrgManagerDirect getOrgManagerDirect() {
		return orgManagerDirect;
	}

	public void setOrgManagerDirect(OrgManagerDirect orgManagerDirect) {
		this.orgManagerDirect = orgManagerDirect;
	}

	@Override
	public OrganizationMessage addAccount(V3xOrgAccount account, V3xOrgMember member) throws CzOrgException {
		try {
			OrganizationMessage message = orgManagerDirect.addAccount(account, member);
			return message;
		} catch (BusinessException e) {
			log.error("", e);
			throw new CzOrgException("500009");
		}
	}

	@Override
	public OrganizationMessage addDepartment(V3xOrgDepartment department) throws CzOrgException {
		try {
			OrganizationMessage message = orgManagerDirect.addDepartment(department);
			return message;
		} catch (BusinessException e) {
			log.error("", e);
			throw new CzOrgException("500009");
		}
		
	}

}
