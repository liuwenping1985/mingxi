package com.seeyon.apps.syncorg.manager;

import com.seeyon.apps.syncorg.czdomain.CzAccount;
import com.seeyon.apps.syncorg.czdomain.CzDepartment;
import com.seeyon.apps.syncorg.czdomain.CzLevel;
import com.seeyon.apps.syncorg.czdomain.CzMember;
import com.seeyon.apps.syncorg.czdomain.CzPost;
import com.seeyon.apps.syncorg.czdomain.CzReturn;
import com.seeyon.apps.syncorg.enums.ActionTypeEnum;
import com.seeyon.apps.syncorg.enums.ObjectTypeEnum;
import com.seeyon.apps.syncorg.exception.CzOrgException;
import com.seeyon.apps.syncorg.po.log.SyncLog;

public interface CzOrgManager {

	public CzReturn SyncMember(ActionTypeEnum actionTypeEnum, CzMember czMember, SyncLog syncLog)  throws CzOrgException;
	public CzReturn SyncAccount(ActionTypeEnum actionTypeEnum, CzAccount czAccount,  SyncLog syncLog)  throws CzOrgException;
	public CzReturn SyncPost(ActionTypeEnum actionTypeEnum, CzPost czPost,  SyncLog syncLog) throws CzOrgException;
	public CzReturn SyncLevel(ActionTypeEnum actionTypeEnum, CzLevel czLevel,  SyncLog syncLog) throws CzOrgException;
	public CzReturn SyncDepartment(ActionTypeEnum actionTypeEnum, CzDepartment czDepartment,  SyncLog syncLog) throws CzOrgException;
	public String SyncOne(SyncLog syncLog);
	public CzReturn processData(ObjectTypeEnum objectTypeEnum, ActionTypeEnum actionTypeEnum, String xmlString, SyncLog stncLog);

}
