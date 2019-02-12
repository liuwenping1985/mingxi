package com.seeyon.ctp.organization.manager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.bo.OrganizationMessage;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgLevel;
import com.seeyon.ctp.organization.dao.OrgCache;
import com.seeyon.ctp.organization.dao.OrgDao;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.po.OrgLevel;
import com.seeyon.ctp.organization.principal.PrincipalManager;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;

public class LevelManagerImpl implements LevelManager {
	private final static Log logger = LogFactory
			.getLog(LevelManagerImpl.class);
	protected OrgCache orgCache;
	protected OrgDao orgDao;
	protected OrgManagerDirect orgManagerDirect;
	protected OrgManager orgManager;
	protected PrincipalManager principalManager;
	protected AppLogManager       appLogManager;

	public void setOrgDao(OrgDao orgDao) {
		this.orgDao = orgDao;
	}

	public void setPrincipalManager(PrincipalManager principalManager) {
		this.principalManager = principalManager;
	}

	public void setOrgCache(OrgCache orgCache) {
		this.orgCache = orgCache;
	}

	public void setOrgManagerDirect(OrgManagerDirect orgManagerDirect) {
		this.orgManagerDirect = orgManagerDirect;
	}

	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}

	public void setAppLogManager(AppLogManager appLogManager) {
        this.appLogManager = appLogManager;
    }

	@Override
	//客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
	public Long saveLevel(String accountId, Map level) throws BusinessException {
	    Long accId = Long.parseLong(accountId);
	    User user = AppContext.getCurrentUser();
		V3xOrgLevel newlevel = new V3xOrgLevel();

		ParamUtil.mapToBean(level, newlevel, false);
		//映射到集团职务级别的序号不能小于最小序号
		Integer groupLevelId = V3xOrgEntity.MAX_LEVEL_NUM;
		if(null != newlevel.getGroupLevelId()){
			groupLevelId = orgManager.getLevelById(newlevel.getGroupLevelId()).getLevelId();
		}
		boolean isMapRight = orgManager.isGroupLevelMapRight(accId, newlevel.getLevelId(), groupLevelId);
        if (!isMapRight) {
            V3xOrgLevel errorLevel = orgManager.getErrorMapLevel(accId, newlevel.getLevelId(),
                    groupLevelId);
            if (errorLevel.getLevelId().intValue() > newlevel.getLevelId().intValue()) {
                throw new BusinessException(ResourceUtil.getString("level.map.group.low", errorLevel.getName()));
            } else {
                throw new BusinessException(ResourceUtil.getString("level.map.group.up", errorLevel.getName()));
            }
        }
        //被映射的集团职务级别别的序号不能小于最小序号
        if(OrgConstants.GROUPID.equals(newlevel.getOrgAccountId())){
        	List<V3xOrgAccount> acclist = orgManager.getAllAccounts();
        	for (V3xOrgAccount v3xOrgAccount : acclist) {
				List<V3xOrgLevel> allLevels = orgManager.getAllLevels(v3xOrgAccount.getId());
				for (V3xOrgLevel v3xOrgLevel : allLevels) {
					if(v3xOrgLevel.getGroupLevelId()!=null&&v3xOrgLevel.getGroupLevelId().equals(newlevel.getId())){
						boolean isGroupMapRight = orgManager.isGroupLevelMapRight(v3xOrgAccount.getId(), v3xOrgLevel.getLevelId(), newlevel.getLevelId());
						if (!isGroupMapRight) {
				            V3xOrgLevel errorLevel = orgManager.getErrorMapLevel(v3xOrgAccount.getId(), v3xOrgLevel.getLevelId(), newlevel.getLevelId());
				            if (errorLevel.getLevelId().intValue() > newlevel.getLevelId().intValue()) {
				                throw new BusinessException(ResourceUtil.getString("level.map.update.group.down", errorLevel.getName(),v3xOrgLevel.getName(),orgManager.getAccountById(v3xOrgLevel.getOrgAccountId()).getShortName()));
				            } else {
				                throw new BusinessException(ResourceUtil.getString("level.map.update.group.down", errorLevel.getName(),v3xOrgLevel.getName(),orgManager.getAccountById(v3xOrgLevel.getOrgAccountId()).getShortName()));
				            }
				        }
					}
				}
			}
        }
        if (newlevel.getId() == null) {
            newlevel.setIdIfNew();
            newlevel.setOrgAccountId(accId);
            OrganizationMessage m = orgManagerDirect.addLevel(newlevel);
            OrgHelper.throwBusinessExceptionTools(m);
            //记录日志
            appLogManager.insertLog4Account(user, accId, AppLogAction.Organization_NewLevel, user.getName(), newlevel.getName());
        } else {
            OrganizationMessage m = orgManagerDirect.updateLevel(newlevel);
            OrgHelper.throwBusinessExceptionTools(m);
            //记录日志
            appLogManager.insertLog4Account(user, accId, AppLogAction.Organization_UpdateLevel, user.getName(), newlevel.getName());
        }
		return newlevel.getId();
	}

	@Override
	//客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
	public String deleteLevel(List<Map<String,Object>> level) throws BusinessException {
        List<V3xOrgLevel> levellist = new ArrayList<V3xOrgLevel>();
        levellist = ParamUtil.mapsToBeans(level, V3xOrgLevel.class, false);
        OrganizationMessage m = orgManagerDirect.deleteLevels(levellist);
        OrgHelper.throwBusinessExceptionTools(m);

        //日志信息                
        List<String[]> appLogs = new ArrayList<String[]>();
        User user = AppContext.getCurrentUser();
        for (V3xOrgLevel l : levellist) {
            String[] appLog = new String[2];
            appLog[0] = user.getName();
            appLog[1] = l.getName();
            appLogs.add(appLog);
        }
        //记录日志
        appLogManager.insertLogs4Account(user, levellist.get(0).getOrgAccountId(), AppLogAction.Organization_DeleteLevel, appLogs);
        return "";
	}

    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
    public HashMap viewLevel(Long levelId) throws BusinessException {
        HashMap map = new HashMap();

        ParamUtil.beanToMap(orgManager.getLevelById(levelId), map, false);
        //		beanToMap(orgManager.getDepartmentById(deptId), map, false,
        //				DateUtil.YEAR_MONTH_DAY_PATTERN, -1, false);
        if(!map.containsKey("groupLevelId")){
        	map.put("groupLevelId", null);
        }
        return map;
    }

	@Override
	//客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
	public FlipInfo showLevelList(FlipInfo fi, Map params)
			throws BusinessException {
	    Long accountId = Long.valueOf(params.get("accountId").toString());
		if(params.size()==0){
			orgDao.getAllLevelPO(accountId, null, null, null, fi);
			
		}else{
			orgDao.getAllLevelPO(accountId, null, String.valueOf(params.get("condition")), params.get("value"), fi);
			
		}
		List list = fi.getData();
		List rellist = new ArrayList();
		for (Object object : list) {
			HashMap m = new HashMap();
			ParamUtil.beanToMap((OrgLevel)object, m, true);
			if(OrgConstants.ORGENT_STATUS.DISABLED.ordinal() == Integer.parseInt(String.valueOf(m.get("status")))) {
			        m.put("name", String.valueOf(m.get("name"))+"("+ ResourceUtil.getString("org.entity.disabled") +")");
	            }
			if(((OrgLevel)object).getGroupLevelId()!=null 
			        && !((OrgLevel)object).getGroupLevelId().equals(0L)){//兼容升级上来的老数据增加判断
				m.put("groupLevelId", orgManager.getLevelById(((OrgLevel)object).getGroupLevelId()).getLevelId());
			}else{
				m.put("groupLevelId", "");
			}
			rellist.add(m);
			
		}
		fi.setData(rellist);
	
		return fi;
	}

	
	

}
