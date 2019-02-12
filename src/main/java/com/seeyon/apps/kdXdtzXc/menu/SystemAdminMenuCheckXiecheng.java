package com.seeyon.apps.kdXdtzXc.menu;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.menu.check.AbstractMenuCheck;
import com.seeyon.ctp.organization.manager.OrgManager;

public class SystemAdminMenuCheckXiecheng extends AbstractMenuCheck  {

	private static final Log LOGGER = LogFactory.getLog(SystemAdminMenuCheckXiecheng.class);
 
    @Override
    public boolean check(long memberId, long loginAccountId) {
        boolean isAdmin =false;
        OrgManager orgManager  =(OrgManager) AppContext.getBean("orgManager");
		   try {
			return  orgManager.hasSpecificRole(memberId,loginAccountId,"携程单点");
		} catch (BusinessException e) {
			e.printStackTrace();
		}
		   return isAdmin;
    }
    
}
