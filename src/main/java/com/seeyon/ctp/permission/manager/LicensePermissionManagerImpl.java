 package com.seeyon.ctp.permission.manager;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang3.math.NumberUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.config.manager.ConfigManager;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.init.MclclzUtil;
import com.seeyon.ctp.common.po.config.ConfigItem;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.permission.bo.LicenseConst;
import com.seeyon.ctp.permission.dao.LicensePerMissionCache;
import com.seeyon.ctp.permission.dao.LicensePerMissionDao;
import com.seeyon.ctp.permission.po.PrivPermission;
import com.seeyon.ctp.util.JDBCAgent;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;
@CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin})
public class LicensePermissionManagerImpl implements LicensePermissionManager {
	private final static Log log = LogFactory.getLog(LicensePermissionManagerImpl.class);
	protected ConfigManager  configManager;
	private static final Class<?> c1 = MclclzUtil.ioiekc("com.seeyon.ctp.permission.bo.LicensePerInfo");
	private static final Class<?> c2 = MclclzUtil.ioiekc("com.seeyon.ctp.product.ProductInfo");
    protected ConfigManager getConfigManager(){
        if(configManager == null){
        	configManager = (ConfigManager)AppContext.getBean("configManager");
        }
        
        return configManager;
    }
    protected OrgManager  orgManager;
    protected OrgManager getOrgManager(){
        if(orgManager == null){
        	orgManager = (OrgManager)AppContext.getBean("orgManager");
        }
        
        return orgManager;
    }
    protected LicensePerMissionDao licensePerMissionDao;
    public void setLicensePerMissionDao(LicensePerMissionDao licensePerMissionDao) {
		this.licensePerMissionDao = licensePerMissionDao;
	}

    protected LicensePerMissionCache licensePerMissionCache;
    public void setLicensePerMissionCache(LicensePerMissionCache licensePerMissionCache) {
        this.licensePerMissionCache = licensePerMissionCache;
    }

    protected AppLogManager appLogManager;
    public void setAppLogManager(AppLogManager appLogManager) {
        this.appLogManager = appLogManager;
    }
    
	@Override
    @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin})
    public void setServerPermissionType(String type) throws BusinessException{
    	ConfigItem item = new ConfigItem();
    	if(getConfigManager().getConfigItem("LIC_SERVER_PERMISSION_TYPE", "LIC_SERVER_PERMISSION_TYPE")==null){
    		getConfigManager().addConfigItem("LIC_SERVER_PERMISSION_TYPE", "LIC_SERVER_PERMISSION_TYPE", type);
    	}else{
    		item = getConfigManager().getConfigItem("LIC_SERVER_PERMISSION_TYPE", "LIC_SERVER_PERMISSION_TYPE");
    		item.setConfigValue(type);
    		getConfigManager().updateConfigItem(item);
    	}
    	
    }
    
    @Override
    @CheckRoleAccess(roleTypes={Role_NAME.SystemAdmin,Role_NAME.GroupAdmin})
    public String getServerPermissionType() throws BusinessException{
    	ConfigItem item = new ConfigItem();
    	item = getConfigManager().getConfigItem("LIC_SERVER_PERMISSION_TYPE", "LIC_SERVER_PERMISSION_TYPE");
    	if(item==null){
    		return "1";
    	}else{
    		return item.getConfigValue();	
    	}
    	
    }
    @Override
    @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin})
    public void setM1PermissionType(String type) throws BusinessException{
    	ConfigItem item = new ConfigItem();
    	if(getConfigManager().getConfigItem("LIC_M1_PERMISSION_TYPE", "LIC_M1_PERMISSION_TYPE")==null){
    		getConfigManager().addConfigItem("LIC_M1_PERMISSION_TYPE", "LIC_M1_PERMISSION_TYPE", type);
    	}else{
    		item = getConfigManager().getConfigItem("LIC_M1_PERMISSION_TYPE", "LIC_M1_PERMISSION_TYPE");
    		item.setConfigValue(type);
    		getConfigManager().updateConfigItem(item);
    	}
        List<PrivPermission> allPrivPerm= licensePerMissionDao.getAllPerMissionPO();
/*        for(PrivPermission privPerm : allPrivPerm){
            List<Map<String, String>> userIdAndname = mobileAuthService.getAuthedUserList(privPerm.getOrgAccountId());
            if(privPerm.getLictype()==2 && userIdAndname!=null && userIdAndname.size()>privPerm.getDistributionnum()){
                mobileAuthService.saveAuthedUserList(null, privPerm.getOrgAccountId(), 0, null);
            }
        }*/
    	
    }
    @Override
    @CheckRoleAccess(roleTypes={Role_NAME.SystemAdmin,Role_NAME.GroupAdmin})
    public String getM1PermissionType() throws BusinessException{
    	ConfigItem item = new ConfigItem();
    	item = getConfigManager().getConfigItem("LIC_M1_PERMISSION_TYPE", "LIC_M1_PERMISSION_TYPE");
    	if(item==null){
    		return "1";
    	}else{
    		return item.getConfigValue();	
    	}
    }
    
    @Override
    @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin})
    public void setZXPermissionType(String type) throws BusinessException{
    	ConfigItem item = new ConfigItem();
    	if(getConfigManager().getConfigItem("LIC_ZX_PERMISSION_TYPE", "LIC_ZX_PERMISSION_TYPE")==null){
    		getConfigManager().addConfigItem("LIC_ZX_PERMISSION_TYPE", "LIC_ZX_PERMISSION_TYPE", type);
    	}else{
    		item = getConfigManager().getConfigItem("LIC_ZX_PERMISSION_TYPE", "LIC_ZX_PERMISSION_TYPE");
    		item.setConfigValue(type);
    		getConfigManager().updateConfigItem(item);
    	}
    }
    
    @Override
    @CheckRoleAccess(roleTypes={Role_NAME.SystemAdmin,Role_NAME.GroupAdmin})
    public String getZXPermissionType() throws BusinessException{
    	ConfigItem item = new ConfigItem();
    	item = getConfigManager().getConfigItem("LIC_ZX_PERMISSION_TYPE", "LIC_ZX_PERMISSION_TYPE");
    	if(item==null){
    		return "1";
    	}else{
    		return item.getConfigValue();	
    	}
    	
    }
    
	@Override
	@CheckRoleAccess(roleTypes={Role_NAME.SystemAdmin,Role_NAME.GroupAdmin})
	public Map<String, String> getPermissionInfo(String accId) throws BusinessException {
		HashMap<String, String> map = new HashMap<String, String>();
		Object serverinfo;
		Object m1info;
		if("1".equals(getServerPermissionType())){
			 serverinfo = MclclzUtil.invoke(c1, "getInstance",new Class[]{String.class},null,new Object[]{""});
		}else{
			 serverinfo = MclclzUtil.invoke(c1, "getInstance",new Class[]{String.class},null,new Object[]{accId});
		}
		if("1".equals(getM1PermissionType())){
			 m1info = MclclzUtil.invoke(c1, "getInstance",new Class[]{String.class},null,new Object[]{""});
		}else{
			 m1info = MclclzUtil.invoke(c1, "getInstance",new Class[]{String.class},null,new Object[]{accId});
		}

		String MxVersion = SystemEnvironment.getMxVersion();
		map.put("MxVersion", MxVersion);
		
        
		map.put("serverversionname", "Server"+ResourceUtil.getString("licensePermission.version")+":");
		map.put("serverversion",String.valueOf(MclclzUtil.invoke(c1, "getServerversion",null,serverinfo,null)));
		map.put("m1versionname", MxVersion+ResourceUtil.getString("licensePermission.version")+":");
		map.put("m1version", String.valueOf(MclclzUtil.invoke(c1, "getM1version",null,m1info,null)));
		
		map.put("totalservernumname", ResourceUtil.getString("licensePermission.have")+"Server"+ResourceUtil.getString("licensePermission.totalnum")+":");
		map.put("totalservernum", getserverTypestr()+String.valueOf(MclclzUtil.invoke(c1, "getTotalservernum",null,serverinfo,null)));
		map.put("totalm1numname", ResourceUtil.getString("licensePermission.have")+MxVersion+ResourceUtil.getString("licensePermission.totalnum")+":");
		map.put("totalm1num", getm1Typestr()+String.valueOf(MclclzUtil.invoke(c1, "getTotalm1num",null,m1info,null)));
		
		map.put("useservernumname", ResourceUtil.getString("licensePermission.all")+ResourceUtil.getString("licensePermission.use")+"Server"+ResourceUtil.getString("licensePermission.num")+":");
		map.put("useservernum", getserverTypestr()+String.valueOf(MclclzUtil.invoke(c1, "getUseservernum",null,serverinfo,null)));
/*		map.put("usem1numname", ResourceUtil.getString("licensePermission.all")+ResourceUtil.getString("licensePermission.use")+MxVersion+ResourceUtil.getString("licensePermission.num")+":");
		map.put("usem1num", getm1Typestr()+String.valueOf(MclclzUtil.invoke(c1, "getUsem1num",null,m1info,null)));*/
		map.put("usem1numname", ResourceUtil.getString("licensePermission.all")+ResourceUtil.getString("licensePermission.distribution")+MxVersion+ResourceUtil.getString("licensePermission.num")+":");
		
		int usem1num = 0;
		if(Strings.isNotBlank(accId) && !OrgConstants.GROUPID.toString().equals(accId)){
			Map<Long,Integer> MAuthedMap = queryAuthedUserCount();
			if(MAuthedMap.containsKey(Long.valueOf(accId))){
				usem1num = MAuthedMap.get(Long.valueOf(accId));
			}
		}else{
			usem1num = queryDistributionCount();
		}
		map.put("usem1num", getm1Typestr()+usem1num);
		
		map.put("unuseservernumname", ResourceUtil.getString("licensePermission.all")+ResourceUtil.getString("licensePermission.unuse")+"Server"+ResourceUtil.getString("licensePermission.num")+":");
		map.put("unuseservernum", getserverTypestr()+String.valueOf(MclclzUtil.invoke(c1, "getUnuseservernum",null,serverinfo,null)));
		map.put("unusem1numname", ResourceUtil.getString("licensePermission.all")+ResourceUtil.getString("licensePermission.undistribution")+MxVersion+ResourceUtil.getString("licensePermission.num")+":");
		map.put("unusem1num", getm1Typestr()+(Integer.valueOf(MclclzUtil.invoke(c1, "getTotalm1num",null,m1info,null).toString())-usem1num));
		
		if(!"".equals(accId)&&!OrgConstants.GROUPID.toString().equals(accId)&&"2".equals(getServerPermissionType())){
			map.put("totalservernumname", ResourceUtil.getString("licensePermission.have")+"Server"+ResourceUtil.getString("licensePermission.num")+":");
			
			map.put("useservernumname", ResourceUtil.getString("licensePermission.use")+"Server"+ResourceUtil.getString("licensePermission.num")+":");
			
			map.put("unuseservernumname", ResourceUtil.getString("licensePermission.unuse")+"Server"+ResourceUtil.getString("licensePermission.num")+":");
			
		}
		if(!"".equals(accId)&&!OrgConstants.GROUPID.toString().equals(accId)&&"2".equals(getM1PermissionType())){
			
			map.put("totalm1numname", ResourceUtil.getString("licensePermission.have")+MxVersion+ResourceUtil.getString("licensePermission.num")+":");
			
			map.put("usem1numname", ResourceUtil.getString("licensePermission.use")+MxVersion+ResourceUtil.getString("licensePermission.num")+":");
			
			map.put("unusem1numname", ResourceUtil.getString("licensePermission.unuse")+MxVersion+ResourceUtil.getString("licensePermission.num")+":");
		}
		
		//如果是私有云环境，就启动授权操作，从加密狗中读相关数据
		String uc_deployment=SystemProperties.getInstance().getProperty("zx.set.development");
		if (SystemEnvironment.hasPlugin("zx") && "private".equals(uc_deployment)) {
			map.put("displayZX", "true");
			//判断选择的是不是根节点或者集团
			if ("".equals(accId) || "-1".equals(accId)) {//第一次进入或者组织结构部署
				accId = OrgConstants.GROUPID.toString();
			}
			boolean isRoot = false;
			V3xOrgAccount selectAccount = getOrgManager().getAccountById(NumberUtils.toLong(accId));
			if (selectAccount != null && selectAccount.isGroup()) {
				isRoot = true;
			}
			//计算致信许可数相关数据
			String totalzxnum = ResourceUtil.getString("licensePermission.res");
			String usezxnum = ResourceUtil.getString("licensePermission.res");
			String unusezxnum = ResourceUtil.getString("licensePermission.res");
			int distributionzxsum;
			//根据是不是根节点赋予不同的值
			if (isRoot) {
				Object mcZX = MclclzUtil.invoke(c2, "getRongCloudRegisterSize");
				distributionzxsum = queryDistributionCount(LicenseConst.PERMISSION_TYPE_ZX,null);
				if (mcZX != null && !mcZX.equals(0)) {
					totalzxnum += (Integer) mcZX;
					unusezxnum += (Integer) mcZX - distributionzxsum;
				} else {//如果客户加密狗中没有授权数，默认给100授权数
					totalzxnum += 100;
					unusezxnum += 100 - distributionzxsum;
				}
				usezxnum += distributionzxsum; 
			} else {
				distributionzxsum = queryDistributionCount(LicenseConst.PERMISSION_TYPE_ZX, accId);
				totalzxnum += distributionzxsum;
				Integer authUserNum = queryZXAuthCount(Long.parseLong(accId));
				usezxnum += authUserNum;
				unusezxnum += distributionzxsum - authUserNum;
			}
			//致信版本号
			map.put("zxversionname", ResourceUtil.getString("licensePermission.zx.title") + ResourceUtil.getString("licensePermission.version") + ":");
			map.put("zxversion", "V3.0");
			//致信总注册数
			map.put("totalzxnumname", ResourceUtil.getString("licensePermission.have") + ResourceUtil.getString("licensePermission.zx.title") + ResourceUtil.getString("licensePermission.totalnum") + ":");
			map.put("totalzxnum", totalzxnum);
			//致信已注册数
			map.put("usezxnumname", ResourceUtil.getString("licensePermission.all") + ResourceUtil.getString("licensePermission.distribution") + ResourceUtil.getString("licensePermission.zx.title") + ResourceUtil.getString("licensePermission.num") + ":");
			map.put("usezxnum", usezxnum);
			//致信未注册数
			map.put("unusezxnumname", ResourceUtil.getString("licensePermission.all") + ResourceUtil.getString("licensePermission.undistribution") + ResourceUtil.getString("licensePermission.zx.title") + ResourceUtil.getString("licensePermission.num") + ":");
			map.put("unusezxnum", unusezxnum);
			//根据是否控制注册数生成不同的文字
			if(!"".equals(accId) && !OrgConstants.GROUPID.toString().equals(accId) && "2".equals(getZXPermissionType())){
				
				map.put("totalzxnumname", ResourceUtil.getString("licensePermission.have") + ResourceUtil.getString("licensePermission.zx.title") + ResourceUtil.getString("licensePermission.num") + ":");
				
				map.put("usezxnumname", ResourceUtil.getString("licensePermission.use") + ResourceUtil.getString("licensePermission.zx.title") + ResourceUtil.getString("licensePermission.num") + ":");
				
				map.put("unusezxnumname", ResourceUtil.getString("licensePermission.unuse") + ResourceUtil.getString("licensePermission.zx.title") + ResourceUtil.getString("licensePermission.num") + ":");
			}
		} else {
			map.put("displayZX", "false");
		}
		
		return map;
	}
	private Integer queryZXAuthCount(long org) {
		Integer count = 0;
		String sql = "select USER_ID from zx_auth_user where ORG_ID = " + org + " and auth_state = 2";
		JDBCAgent agent = new JDBCAgent(false);
		try {
			agent.execute(sql);
			List<Map<String, Object>> list = agent.resultSetToList();
			if(Strings.isNotEmpty(list)){
				count=list.size();
			}
		} catch (Exception e) {
			log.error(e.getMessage(),e);
		} finally {
			agent.close();
	    }
		return count;
	}

	@Override
	@CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin})
	public void savePermissionDisInfo(Map perinfo) throws BusinessException {
		List<PrivPermission> list = new ArrayList<PrivPermission>();
		Set keyset = perinfo.keySet();
		Long totalservernum = Long.valueOf(0);
		Long totalm1num = Long.valueOf(0);
		Long totalzxnum = Long.valueOf(0);
		perinfo.remove("queryacc");
		//部署方式
		String uc_deployment=SystemProperties.getInstance().getProperty("zx.set.development");
		
		Map<Long,Integer> MAuthedMap = queryAuthedUserCount();
		String MxVersion = SystemEnvironment.getMxVersion();
		
		for (Object object : keyset) {
			PrivPermission privPermission = new PrivPermission();
			String[] str = object.toString().split("_");
			privPermission.setIdIfNew();
			privPermission.setLictype(Integer.valueOf(str[0]));
			privPermission.setOrgAccountId(Long.valueOf(str[1]));
			Object info = MclclzUtil.invoke(c1, "getInstance",new Class[]{String.class},null,new Object[]{String.valueOf(privPermission.getOrgAccountId())});
			
			//如果信息类型是3（致信分配数）且客户没有买致信或是公有云环境 就不保存
			if ((!SystemEnvironment.hasPlugin("zx") || "public".equals(uc_deployment)) && privPermission.getLictype().intValue() == 3) {
				continue;
			}
			
			//选择注册方式还是并发方式
			switch(privPermission.getLictype().intValue()) {
				case 1:
					privPermission.setType(Integer.valueOf(MclclzUtil.invoke(c1, "getserverType",null,info,null).toString()));
					break;
				case 2:
					privPermission.setType(Integer.valueOf(MclclzUtil.invoke(c1, "getm1Type",null,info,null).toString()));
					break;
				case 3:
					privPermission.setType(1);
					break;
			}
			
			String num = perinfo.get(object).toString();
			if("".equals(num)){
				num="0";
			}
			
			privPermission.setDistributionnum(Long.valueOf(num));
			if(privPermission.getLictype().equals(LicenseConst.PERMISSION_TYPE_SERVER)&&"2".equals(getServerPermissionType())&&((Long)MclclzUtil.invoke(c1, "getUseservernum",null,info,null)).intValue()>privPermission.getDistributionnum()){
				throw new BusinessException("单位："+getOrgManager().getAccountById(privPermission.getOrgAccountId()).getName()+"的Server的分配许可数小于已用许可数，请调整！");
			}
			
			if("M3".equals(MxVersion)){
				//M3的已使用授权从表中查询
				//移动授权不能小于已经使用的注册数
				if(!MAuthedMap.isEmpty()){
					if(privPermission.getLictype().equals(LicenseConst.PERMISSION_TYPE_M1)&&"2".equals(getM1PermissionType())){
						Integer authedCount = MAuthedMap.get(Long.valueOf(str[1]));
						if(authedCount != null){
							if(authedCount > privPermission.getDistributionnum()){
								throw new BusinessException("单位："+getOrgManager().getAccountById(privPermission.getOrgAccountId()).getName()+"的移动的分配许可数小于单位的已使用注册数，请调整！");
							}
						}
					}
				}
			}else{
				//M1的已使用授权从狗中读取
				if(privPermission.getLictype().equals(LicenseConst.PERMISSION_TYPE_M1)&&"2".equals(getM1PermissionType())&&((Long)MclclzUtil.invoke(c1, "getUsem1num",null,info,null)).intValue()>privPermission.getDistributionnum()){
					throw new BusinessException("单位："+getOrgManager().getAccountById(privPermission.getOrgAccountId()).getName()+"的移动的分配许可数小于已用许可数，请调整！");
				}
			}
			
			//如果是致信，那么判断修改致信当前授权的人数是否不大于已经授权人数
			if (privPermission.getLictype().intValue() == 3 && "2".equals(getZXPermissionType())) {
				Object mcZX = MclclzUtil.invoke(c2, "getRongCloudRegisterSize");
				if (mcZX != null && !mcZX.equals(0)) {
					if (queryZXAuthCount(Long.valueOf(str[1])) > (Integer) mcZX) {
						throw new BusinessException("单位："+getOrgManager().getAccountById(privPermission.getOrgAccountId()).getName()+"的致信的分配许可数小于已用许可数，请调整！");
					}
				} else {//如果客户加密狗中没有授权数，默认给100授权数
					if (queryZXAuthCount(Long.valueOf(str[1])) > 100) {
						throw new BusinessException("单位："+getOrgManager().getAccountById(privPermission.getOrgAccountId()).getName()+"的致信的分配许可数小于已用许可数，请调整！");
					}
				}
			}
			
			list.add(privPermission);
			
			if(privPermission.getLictype().equals(LicenseConst.PERMISSION_TYPE_SERVER)){
				totalservernum+=privPermission.getDistributionnum();
			}
			if(privPermission.getLictype().equals(LicenseConst.PERMISSION_TYPE_M1)){
				totalm1num+=privPermission.getDistributionnum();
			}
			//致信总数
			if(privPermission.getLictype().equals(LicenseConst.PERMISSION_TYPE_ZX)){
				totalzxnum += privPermission.getDistributionnum();
			}
		}
		
		Object info = MclclzUtil.invoke(c1, "getInstance",new Class[]{String.class},null,new Object[]{""});
		if(totalservernum>((Long)MclclzUtil.invoke(c1, "getTotalservernum",null,info,null)).intValue()){
			throw new BusinessException("Server的各单位分配的许可数之和大于许可总数，请调整！");
		}
		if(totalm1num>((Long)MclclzUtil.invoke(c1, "getTotalm1num",null,info,null)).intValue()){
			throw new BusinessException("移动的各单位分配的许可数之和大于许可总数，请调整！");
		}
		//如果大于致信注册总数，抛异常
		if (SystemEnvironment.hasPlugin("zx") && "private".equals(uc_deployment)) {
			if(totalzxnum > (Integer) MclclzUtil.invoke(c2, "getRongCloudRegisterSize")){
				throw new BusinessException("致信的各单位分配的许可数之和大于许可总数，请调整！");
			}
		}
		
		licensePerMissionDao.deleteAllPerMissionPO();
		licensePerMissionDao.savePerMissionPO(list);
		
        //组装应用日志
		User user = AppContext.getCurrentUser();
        for (PrivPermission p : list) {
            V3xOrgAccount account = getOrgManager().getAccountById(p.getOrgAccountId());
            if (p.getLictype().equals(LicenseConst.PERMISSION_TYPE_SERVER)) {
                appLogManager.insertLog(user, AppLogAction.Organization_ChangeServerPermission,user.getName(), account.getName(),
                        String.valueOf(p.getDistributionnum()));
            } else if (p.getLictype().equals(LicenseConst.PERMISSION_TYPE_M1)) {
                appLogManager.insertLog(user, AppLogAction.Organization_ChangeM1Permission,user.getName(), account.getName(),
                        String.valueOf(p.getDistributionnum()));
            } else {
                appLogManager.insertLog(user, AppLogAction.Organization_ChangePermission,user.getName(), account.getName(),
                        String.valueOf(p.getDistributionnum()));
            }
        }
		
	}
	@Override
	@CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin})
	public Map getPermissionDisInfo() throws BusinessException {
		Object info = MclclzUtil.invoke(c1, "getInstance",new Class[]{String.class},null,new Object[]{""});
		
		HashMap map = new HashMap();
		List<PrivPermission> list = licensePerMissionCache.getAllPerMissionPO();
		for (PrivPermission privPermission : list) {
			map.put(privPermission.getLictype()+"_"+privPermission.getOrgAccountId(), privPermission.getDistributionnum());
		}	
		map.put("totalservernum", String.valueOf(MclclzUtil.invoke(c1, "getTotalservernum",null,info,null)));
		map.put("totalm1num", String.valueOf(MclclzUtil.invoke(c1, "getTotalm1num",null,info,null)));
		
		String uc_deployment=SystemProperties.getInstance().getProperty("zx.set.development");
		if (SystemEnvironment.hasPlugin("zx") && "private".equals(uc_deployment)) {
			map.put("displayZX","true");
			//致信总许可数
			Object mcZX = MclclzUtil.invoke(c2, "getRongCloudRegisterSize");
			if (mcZX != null) {
				map.put("totalzxnum", (Integer) mcZX);
			} else {
				map.put("totalzxnum", 0);
			}
		} else {
			map.put("displayZX","false");
		}
		map.put("unuseservernum", String.valueOf(MclclzUtil.invoke(c1, "getUnuseservernum",null,info,null)));
		//map.put("unusem1num", String.valueOf(MclclzUtil.invoke(c1, "getUnusem1num",null,info,null)));
		map.put("unusem1num", getm1Typestr()+(Integer.valueOf(MclclzUtil.invoke(c1, "getTotalm1num",null,info,null).toString())-queryDistributionCount()));
		
		map.put("useservernum", String.valueOf(MclclzUtil.invoke(c1, "getUseservernum",null,info,null)));
		//map.put("usem1num",String.valueOf(MclclzUtil.invoke(c1, "getUsem1num",null,info,null)));
		map.put("usem1num",queryDistributionCount());
		
		String MxVersion = SystemEnvironment.getMxVersion();
		map.put("MxVersion", MxVersion);
		return map;
		
	}
	
	private String getserverTypestr() throws BusinessException{
		Object info = MclclzUtil.invoke(c1, "getInstance",new Class[]{String.class},null,new Object[]{""});
		
			if((Integer.valueOf(MclclzUtil.invoke(c1, "getserverType",null,info,null).toString())).intValue()==1){
				return ResourceUtil.getString("licensePermission.res");
			}else{
				return ResourceUtil.getString("licensePermission.online");
			}
		
		
	}
	private String getm1Typestr() throws BusinessException{
		Object info = MclclzUtil.invoke(c1, "getInstance",new Class[]{String.class},null,new Object[]{""});
		
	
			if((Integer.valueOf(MclclzUtil.invoke(c1, "getm1Type",null,info,null).toString())).intValue()==1){
				return ResourceUtil.getString("licensePermission.res");
			}else{
				return ResourceUtil.getString("licensePermission.online");
			}
		
		
	}
	
	private Map<Long,Integer> queryAuthedUserCount(){
		Map<Long,Integer> result = new HashMap<Long, Integer>();
		String sql = "select ORG_ID,count(*) C from m3_mobile_auth_user group by org_id";
		JDBCAgent agent = new JDBCAgent(false);
		try {
			agent.execute(sql);
			List<Map<String, Object>> list = agent.resultSetToList();
			if(Strings.isNotEmpty(list)){
				if(list.get(0).get("C")!=null){
					String c = list.get(0).get("C").toString();
					if(Strings.isNotBlank(c) && !"null".equals(c)){
						for(Map map : list){
							result.put(Long.valueOf(map.get("ORG_ID").toString()), Integer.valueOf(map.get("C").toString()));
						}
					}
				}
			}
		} catch (BusinessException e) {
			log.error(e.getMessage());
		} catch (SQLException e) {
			log.error(e.getMessage());
		}finally {
			agent.close();
	    }
		return result;
	}
	
	
	/**
	 * 查询已经分配的mx的总数
	 */
	private int queryDistributionCount(){
		int count = 0;
		String sql = "select sum(distributionnum) from priv_permission where lictype=2";
		JDBCAgent agent = new JDBCAgent(false);
		try {
			agent.execute(sql);
			List<Map<String, Object>> list = agent.resultSetToList();
			if(Strings.isNotEmpty(list)){
				if(list.get(0).get("sum(distributionnum)")!=null){
					String c = list.get(0).get("sum(distributionnum)").toString();
					if(Strings.isNotBlank(c) && !"null".equals(c)){
						count = Integer.valueOf(c);
					}
				}
			}
		} catch (BusinessException e) {
			log.error(e.getMessage());
		} catch (SQLException e) {
			log.error(e.getMessage());
		}finally {
			agent.close();
	    }
		return count;
	}
	
	
	
	/**
	 * 查询各单位的分配人数
	 */
	@Override
	public Integer queryDistributionCount(Integer i, String accId){
		Integer count = 0;
		String sql = "select distributionnum from priv_permission where lictype=" + i ;
		if(accId!=null) {
			sql+=" and ORG_ACCOUNT_ID = " + accId;
		}
		JDBCAgent agent = new JDBCAgent(false);
		try {
			agent.execute(sql);
			List<Map<String, Object>> list = agent.resultSetToList();
			if(Strings.isNotEmpty(list)&&list.get(0).get("distributionnum")!=null){
				String c = list.get(0).get("distributionnum").toString();
				if(Strings.isNotBlank(c) && !"null".equals(c)){
					count = Integer.valueOf(c);
				}
				
			}
		} catch (Exception e) {
			log.error(e.getMessage(),e);
		} finally {
			agent.close();
	    }
		return count;
	}
}
