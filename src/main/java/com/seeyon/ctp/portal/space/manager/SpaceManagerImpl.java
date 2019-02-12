/**
 * $Author: wangchw $
 * $Rev: 51023 $
 * $Date:: 2015-08-05 10:15:36 +#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
package com.seeyon.ctp.portal.space.manager;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.TypeReference;
import com.seeyon.apps.project.api.ProjectApi;
import com.seeyon.apps.project.bo.ProjectBO;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.authenticate.domain.UserCustomizeCache;
import com.seeyon.ctp.common.authenticate.domain.UserHelper;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.CustomizeConstants;
import com.seeyon.ctp.common.constants.ProductEditionEnum;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.customize.manager.CustomizeManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.flag.SysFlag;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.po.customize.CtpCustomize;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.common.usermessage.MessageContent;
import com.seeyon.ctp.common.usermessage.MessageReceiver;
import com.seeyon.ctp.common.usermessage.UserMessageManager;
import com.seeyon.ctp.event.EventDispatcher;
import com.seeyon.ctp.login.bo.MenuBO;
import com.seeyon.ctp.menu.manager.MenuManager;
import com.seeyon.ctp.menu.manager.PortalMenuManager;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.manager.OrgManagerDirect;
import com.seeyon.ctp.organization.manager.RoleManager;
import com.seeyon.ctp.portal.link.manager.LinkSpaceManager;
import com.seeyon.ctp.portal.link.manager.LinkSystemManager;
import com.seeyon.ctp.portal.manager.PortalCacheManager;
import com.seeyon.ctp.portal.manager.PortalSYSMenuManager;
import com.seeyon.ctp.portal.po.PortalLinkSpace;
import com.seeyon.ctp.portal.po.PortalPagePortlet;
import com.seeyon.ctp.portal.po.PortalSpaceFix;
import com.seeyon.ctp.portal.po.PortalSpaceMenu;
import com.seeyon.ctp.portal.po.PortalSpacePage;
import com.seeyon.ctp.portal.po.PortalSpaceSecurity;
import com.seeyon.ctp.portal.space.bo.DefaultSpaceSetting;
import com.seeyon.ctp.portal.space.bo.MenuTreeNode;
import com.seeyon.ctp.portal.space.dao.SpaceDao;
import com.seeyon.ctp.portal.space.event.AddSpaceEvent;
import com.seeyon.ctp.portal.space.event.DeleteSpaceEvent;
import com.seeyon.ctp.portal.space.event.UpdateSpaceEvent;
import com.seeyon.ctp.portal.sso.thirdpartyintegration.ThirdpartySpace;
import com.seeyon.ctp.portal.sso.thirdpartyintegration.manager.ThirdpartySpaceManager;
import com.seeyon.ctp.portal.util.Constants;
import com.seeyon.ctp.portal.util.Constants.SecurityType;
import com.seeyon.ctp.portal.util.Constants.SpaceState;
import com.seeyon.ctp.portal.util.Constants.SpaceType;
import com.seeyon.ctp.portal.util.PortletPropertyContants;
import com.seeyon.ctp.portal.util.PortletPropertyContants.PropertyName;
import com.seeyon.ctp.portal.util.SpaceFixUtil;
import com.seeyon.ctp.privilege.bo.PrivMenuBO;
import com.seeyon.ctp.privilege.dao.PrivilegeCache;
import com.seeyon.ctp.privilege.manager.PrivilegeManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.EnumUtil;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;
import com.seeyon.ctp.util.json.JSONUtil;

/**
 * <p>Title: 首页空间管理实现类</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @since CTP2.0
 */
public class SpaceManagerImpl implements SpaceManager {
    private static final Log             log = LogFactory.getLog(SpaceManagerImpl.class);

    private PageManager                  pageManager;

    private PortletEntityPropertyManager portletEntityPropertyManager;

    private SpaceDao                     spaceDao;

    private SpaceSecurityManager         spaceSecurityManager;

    private OrgManager                   orgManager;

    private OrgManagerDirect         orgManagerDirect;

    private RoleManager                  roleManager;

    private CustomizeManager customizeManager;

    private PrivilegeManager  privilegeManager;

    private PrivilegeCache   privilegeCache;

    private LinkSpaceManager linkSpaceManager;

    private ProjectApi projectApi;
    //插件菜单
    private MenuManager menuManager;

    private PortalSYSMenuManager portalSYSMenuManager;

    private UserMessageManager userMessageManager;

    private PortalCacheManager portalCacheManager;
    
    private PortalMenuManager portalMenuManager;
    
    private FileManager fileManager;
    
    private LinkSystemManager   linkSystemManager;
    
    private AppLogManager                appLogManager;
    
	public void setLinkSystemManager(LinkSystemManager linkSystemManager) {
		this.linkSystemManager = linkSystemManager;
	}
	public void setFileManager(FileManager fileManager) {
		this.fileManager = fileManager;
	}
	public void setPortalCacheManager(PortalCacheManager portalCacheManager) {
        this.portalCacheManager = portalCacheManager;
    }
	public void setMenuManager(MenuManager menuManager) {
		this.menuManager = menuManager;
	}

	public void setPrivilegeManager(PrivilegeManager privilegeManager) {
        this.privilegeManager = privilegeManager;
    }

    public void setPrivilegeCache(PrivilegeCache privilegeCache) {
        this.privilegeCache = privilegeCache;
    }

    public void setCustomizeManager(CustomizeManager customizeManager) {
        this.customizeManager = customizeManager;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void setOrgManagerDirect(OrgManagerDirect orgManagerDirect) {
        this.orgManagerDirect = orgManagerDirect;
    }

    public void setSpaceSecurityManager(SpaceSecurityManager spaceSecurityManager) {
        this.spaceSecurityManager = spaceSecurityManager;
    }

    public void setSpaceDao(SpaceDao spaceDao) {
        this.spaceDao = spaceDao;
    }

    public void setPortletEntityPropertyManager(PortletEntityPropertyManager portletEntityPropertyManager) {
        this.portletEntityPropertyManager = portletEntityPropertyManager;
    }

    public void setPageManager(PageManager pageManager) {
        this.pageManager = pageManager;
    }

    public void setLinkSpaceManager(LinkSpaceManager linkSpaceManager) {
        this.linkSpaceManager = linkSpaceManager;
    }

    public void setProjectApi(ProjectApi projectApi) {
        this.projectApi = projectApi;
    }

    public void setRoleManager(RoleManager roleManager) {
        this.roleManager = roleManager;
    }

    public void setPortalSYSMenuManager(PortalSYSMenuManager portalSYSMenuManager) {
        this.portalSYSMenuManager = portalSYSMenuManager;
    }

    public void setUserMessageManager(UserMessageManager userMessageManager) {
		this.userMessageManager = userMessageManager;
	}
    
    public void setAppLogManager(AppLogManager appLogManager) {
        this.appLogManager = appLogManager;
    }
	
	/**
	 * 刷新单个缓存对象
	 * @param pageFix
	 */
    public void putPageFixToCache(PortalSpaceFix pageFix){
		portalCacheManager.putPageFixPathCache(pageFix.getPath(), pageFix);
		portalCacheManager.putPageFixIdCache(pageFix.getId(), pageFix);
	}
	
	/**
	 * 删除单个缓存对象
	 * @param pageFix
	 */
	private void deletePageFixFromCache(PortalSpaceFix pageFix){
		portalCacheManager.removePageFixPathCache(pageFix.getPath());
		portalCacheManager.removePageFixIdCache(pageFix.getId());
	}

	@Override
	public void transRestoreSpaceData() throws BusinessException{
		boolean isGroupVer = (Boolean)(SysFlag.sys_isGroupVer.getFlag());
		int productId =  SystemProperties.getInstance().getIntegerProperty("system.ProductId");
		if(isGroupVer){
			transCreateGroupSpace(OrgConstants.GROUPID);
		}
		List<V3xOrgAccount> accounts = orgManager.getAllAccounts();
		if(accounts != null && accounts.size() > 0){
			Iterator<V3xOrgAccount> itr = accounts.iterator();
			while(itr.hasNext()){
				V3xOrgAccount account = itr.next();
				Long accountId = account.getId();
				if(accountId.longValue() == OrgConstants.GROUPID.longValue()){
					itr.remove();
					continue;
				}
				String pagePath = Constants.PERSONAL_FOLDER + accountId + "_D" + Constants.DOCUMENT_TYPE;
	            PortalSpaceFix spaceFix = getSpaceFix(pagePath);
	            //单位空间初始化容错
	            if(spaceFix == null){
	            	transCreateDefaultPersonalSpace(accountId);
		            transCreateDefaultOuterSpace(accountId);
		            if(ProductEditionEnum.a6p.ordinal() != productId && ProductEditionEnum.a6.ordinal() != productId && ProductEditionEnum.a6s.ordinal() != productId){
		                transCreateDefaultLeaderSpace(accountId);
		            }
		            transCreateCorporationSpace(accountId);

		            transCreateCooperationSpace(accountId);
		            if(AppContext.hasPlugin("edoc")){
		                transCreateEdocSpace(accountId);
		            }
		            transCreateMeetingSpace(accountId);
		            transCreateObjectiveSpace(accountId);
		            //政务版不显示绩效分析
		    		if(ProductEditionEnum.government.ordinal() != productId && ProductEditionEnum.governmentgroup.ordinal() != productId){
		    			transCreatePerformanceSpace(accountId);
		    		}
		            transCreateFormBizSpace(accountId);
	            }
			}
		}
	}

    @Override
    public Map selectSpaceById(long spaceId) {
        Map space = spaceDao.selectSpaceById(spaceId);
        if (space != null) {
            String isAllowedDefineStr = (String) space.get("extAttributes");
            if (!Strings.isBlank(isAllowedDefineStr)) {
                SpaceFixUtil fixUtil = new SpaceFixUtil(isAllowedDefineStr);
                space.put("isAllowDefined", fixUtil.isAllowdefined());
                space.put("isAllowpushed", fixUtil.isAllowpushed());
            } else {
                space.put("isAllowDefined", false);
                space.put("isAllowpushed", false);
            }
            space.put("spacename", ResourceUtil.getString(space.get("spacename").toString()));
            PortalSpacePage page = pageManager.getPage((String) space.get("path"));
            if (page != null) {
                space.put("decoration", page.getDefaultLayoutDecorator());
            }
            if(space.get("path")!=null&&space.get("path").toString().indexOf("/department/")>-1){
            	try {
            		List<V3xOrgMember> manager=this.orgManager.getMembersByRole(Long.parseLong(space.get("entityId").toString()),Role_NAME.DepManager.name());
            		if(manager!=null&&manager.size()>0){
            			space.put("hasDepManager","1");
            		}else{
            			space.put("hasDepManager","0");
            		}
				} catch (BusinessException e) {
					this.log.error(e);
				}
            }
        }
        return space;
    }

    @Override
    @SuppressWarnings("rawtypes")
    public long selectMaxSort() {
        List result = DBAgent.find("select max(sortId) from PortalSpaceFix");
        Long maxSort = (Long) result.get(0);
        if (maxSort == null) {
            return 0;
        } else {
            return maxSort;
        }
    }

    @Override
    public Long getMaxSort() throws BusinessException {
        StringBuffer sql = new StringBuffer();
        Map p = new HashMap();
        p.put("accountId", AppContext.currentAccountId());
        sql.insert(0, "select max(psf.sortId) from PortalSpaceFix psf, PortalSpacePage psp where psf.path = psp.path and psf.accountId = :accountId and psf.parentId is null");
        if(!AppContext.hasPlugin("edoc")){
            sql.append(" and psf.type != "+SpaceType.edoc_manage.ordinal());
        }
        if(!AppContext.hasPlugin("meeting")){
            sql.append(" and psf.type != "+SpaceType.meeting_manage.ordinal());
        }
        List data = DBAgent.find(sql.toString(),p);
        if(CollectionUtils.isNotEmpty(data)){
            Long maxSort = (Long) data.get(0);
            return maxSort;
        }else{
            return Long.valueOf(0);
        }
    }

    @SuppressWarnings("rawtypes")
    private boolean isDuplicateSort(Long sort, Long id){
    	StringBuffer sql = new StringBuffer();
        sql.append("select count(id) from PortalSpaceFix where sortId = :sort and id != :id");
        Map params = new HashMap();
        params.put("sort", sort);
        params.put("id", id);
        List list = DBAgent.find(sql.toString(), params);
        Long count = (Long) list.get(0);
        return count > 0;
    }

    /**
     * 个人类型的空间停用后，如果空间导航设置里不存在已选的个人类型的空间，则把默认的个人类型的空间放入已选
     * @param space 停用的个人空间
     * @param accountId 单位Id
     */
    @SuppressWarnings("unchecked")
    private void spaceCustomSortForDisableSpace(PortalSpaceFix space, Long accountId) throws BusinessException {
        int spaceType = space.getType();
        int state = space.getState().intValue();
        if(Constants.isPersonalStyleSpace(spaceType) && state == Constants.SpaceState.invalidation.ordinal()){
            //如果是个人类型空间被停用
            if(spaceType == Constants.SpaceType.default_leader.ordinal()){
                //如果是默认领导空间被停用
                this.spaceCustomSortForAuthChange(space, null, accountId);
                return;
            }
            //要更新的集合
            List<CtpCustomize> listForUpdate = new ArrayList<CtpCustomize>();
            List<CtpCustomize> ctpCustomizeList = this.getSpaceOrderCustomize();
            if(ctpCustomizeList != null && ctpCustomizeList.size() > 0){
                for(CtpCustomize ctpCustomize : ctpCustomizeList){
                    if(ctpCustomize != null){
                        //Long userId = ctpCustomize.getUserId();
                        //是否某人在该单位下所有的个人类型空间都在备选里面
                        boolean isAllPersonalSpaceUnSelected = true;
                        //要放入已选的个人类型空间
                        Map<String, Object> personalSpace = null;
                        Map<String, Map<String, Map<String, Object>>> cvalueMap = (Map<String, Map<String, Map<String, Object>>>)JSONUtil.parseJSONString(ctpCustomize.getCvalue());
                        if(cvalueMap != null && cvalueMap.size() > 0){
                            Map<String, Map<String, Object>> currentSpaceMap = (Map<String, Map<String, Object>>) cvalueMap.get(String.valueOf(accountId));
                            if(currentSpaceMap != null){
                                for(Map<String, Object> spaceEntry : currentSpaceMap.values()){
                                    String spaceEntryId = spaceEntry.get(CustomizeConstants.SPACE_ID).toString();
                                    int spaceEntryType = Integer.valueOf(spaceEntry.get(CustomizeConstants.SPACE_TYPE).toString());
                                    //是否备选
                                    String isUnSelected = spaceEntry.get(CustomizeConstants.SPACE_ISDELETED).toString();
                                    if(spaceEntryId.equals(space.getId().toString())){
                                        //跳过此停用空间
                                        continue;
                                    }
                                    if(Constants.isPersonalStyleSpace(Integer.valueOf(spaceEntryType))){
                                        if(("0").equals(isUnSelected)){
                                            //有已选
                                            isAllPersonalSpaceUnSelected = false;
                                        } else if(spaceEntryType == Constants.SpaceType.Default_personal.ordinal()
                                        		|| spaceEntryType == Constants.SpaceType.personal.ordinal()
                                        		|| spaceEntryType == Constants.SpaceType.Default_out_personal.ordinal()
                                        		|| spaceEntryType == Constants.SpaceType.outer.ordinal()){
                                            //备选的默认个人空间或默认外部人员空间
                                            if(personalSpace == null){
                                                personalSpace = spaceEntry;
                                            }
                                        }
                                    }
                                }
                                if(isAllPersonalSpaceUnSelected){
                                    //如果都在备选里面，则把找到的默认个人类型空间置为已选
                                    personalSpace.put(CustomizeConstants.SPACE_ISDELETED, 0);
                                    ctpCustomize.setCvalue(JSONUtil.toJSONString(cvalueMap));
                                    listForUpdate.add(ctpCustomize);
                                }
                            }
                        }
                    }
                }
                if(listForUpdate.size() > 0){
                    this.customizeManager.updateAllCustomizeInfo(listForUpdate);
                }
            }
        }
    }

    /**
     * 空间变更授权范围
     * 领导空间变更授权范围后，不在授权范围的人员的默认个人类型空间取代该领导空间的位置
     * @param space 变更授权范围的空间
     * @param members 授权范围
     * @param accountId 单位Id
     */
    @SuppressWarnings("unchecked")
    public void spaceCustomSortForAuthChange(PortalSpaceFix space, String canshare, Long accountId) throws BusinessException {
        List<V3xOrgMember> members = getSpaceUsingAuthRange(canshare);
		List<V3xOrgMember> allMembers = orgManager.getAllMembers(accountId);
		// 没有被授权的人员
		List<V3xOrgMember> membersWithoutAuth = (List<V3xOrgMember>) CollectionUtils
				.subtract(allMembers, members);
		List<Long> memberIdsWithoutAuth = new ArrayList<Long>();
		for (V3xOrgMember member : membersWithoutAuth) {
			memberIdsWithoutAuth.add(member.getId());
		}
		if (memberIdsWithoutAuth.size() > 0) {
			// 要更新的集合
			List<CtpCustomize> listForUpdate = new ArrayList<CtpCustomize>();
			List<CtpCustomize> ctpCustomizeList = customizeManager.getCustomizeInfo(memberIdsWithoutAuth,CustomizeConstants.SPACE_ORDER);
			if (ctpCustomizeList != null && ctpCustomizeList.size() > 0) {
				for (CtpCustomize ctpCustomize : ctpCustomizeList) {
					if (ctpCustomize != null) {
						// 要取消授权的空间
						Map<String, Object> targetSpace = null;
						// 要放入已选的个人类型空间
						Map<String, Object> personalSpace = null;
						Map<String, Map<String, Map<String, Object>>> cvalueMap = (Map<String, Map<String, Map<String, Object>>>) JSONUtil.parseJSONString(ctpCustomize.getCvalue());
						if (cvalueMap != null && cvalueMap.size() > 0) {
							Map<String, Map<String, Object>> currentSpaceMap = (Map<String, Map<String, Object>>) cvalueMap.get(String.valueOf(accountId));
							if (currentSpaceMap != null) {
								for (Map<String, Object> spaceEntry : currentSpaceMap.values()) {
									String spaceEntryId = spaceEntry.get(CustomizeConstants.SPACE_ID).toString();
									int spaceEntryType = Integer.valueOf(spaceEntry.get(CustomizeConstants.SPACE_TYPE).toString());
									// 是否备选
									String isUnSelected =  spaceEntry.get(CustomizeConstants.SPACE_ISDELETED).toString();
									if (spaceEntryId.equals(space.getId().toString())) {
										if (targetSpace == null) {
											targetSpace = spaceEntry;
										}
									}
									if (spaceEntryType == Constants.SpaceType.Default_personal.ordinal()
											|| spaceEntryType == Constants.SpaceType.personal.ordinal()
											|| spaceEntryType == Constants.SpaceType.Default_out_personal.ordinal()
											|| spaceEntryType == Constants.SpaceType.outer.ordinal()) {
										if ("1".equals(isUnSelected)) {
											// 默认个人类型空间在备选
											if (personalSpace == null) {
												personalSpace = spaceEntry;
											}
										}
									}
								}
								if(targetSpace != null){
									int targetSpaceType = Integer.valueOf(targetSpace.get(CustomizeConstants.SPACE_TYPE).toString());
									String targetSpaceSort =  targetSpace.get(CustomizeConstants.SPACE_SORT).toString();
									String isTargetSpaceUnSelected =  targetSpace.get(CustomizeConstants.SPACE_ISDELETED).toString();
									if((targetSpaceType == Constants.SpaceType.default_leader.ordinal() || targetSpaceType == Constants.SpaceType.leader.ordinal()) && "0".equals(isTargetSpaceUnSelected) && personalSpace != null) {
										// 领导空间在已选，默认个人类型空间取代该领导空间的位置
										String personalSpaceSort = personalSpace.get(CustomizeConstants.SPACE_SORT).toString();
										personalSpace.put(CustomizeConstants.SPACE_SORT, targetSpaceSort);
										personalSpace.put(CustomizeConstants.SPACE_ISDELETED, 0);
										currentSpaceMap.put(targetSpaceSort, personalSpace);
										currentSpaceMap.remove(personalSpaceSort);
									} else {
										currentSpaceMap.remove(targetSpaceSort);
									}
									ctpCustomize.setCvalue(JSONUtil.toJSONString(cvalueMap));
									listForUpdate.add(ctpCustomize);
								}
							}
						}
					}
				}
				if (listForUpdate.size() > 0) {
					this.customizeManager.updateAllCustomizeInfo(listForUpdate);
				}
			}
		}
    }

    /**
     * 从空间列表里找出默认空间
     * @param list
     * @param accountId
     * @return 如果找出，则返回默认空间在该列表中的索引。未找到返回-1
     * @throws BusinessException
     */
    private int findDefaultSpaceIndexFromList(LinkedList<String[]> list, Long accountId, DefaultSpaceSetting setting) throws BusinessException {
		int index = -1;
    	if(list == null || list.size() == 0){
    		return index;
    	}
    	if(setting == null){
    		setting = DefaultSpaceSetting.getDefaultSpaceSettingForAccount(accountId);
    	}
        String defaultSpaceId = setting.getDefaultSpace();
		String defaultSpaceType = setting.getSpaceType();
		if(defaultSpaceId.length() > 0){
			//设置的默认空间是一个具体的空间
			for(int i = 0; i < list.size(); i++){
	        	String[] spaceInfo = list.get(i);
	        	String spaceId = null;
	        	if(spaceInfo[1] == null){
	            	spaceId = spaceInfo[0];
	        	} else {
	        		spaceId = spaceInfo[1];
	        	}
	        	if(defaultSpaceId.equals(spaceId)){
					index = i;
					break;
				}
			}
		} else {
			//设置的默认空间是一种默认的空间类型
			String[] defaultSpaceTypeStringArray = defaultSpaceType.split("_");
			for(String spaceTypeTmp : defaultSpaceTypeStringArray){
				for(int i = 0; i < list.size(); i++){
		        	String[] spaceInfo = list.get(i);
		        	String spaceType = spaceInfo[6];
		        	if(spaceType.equals(spaceTypeTmp) && (spaceInfo[9].equals(OrgConstants.GROUPID.toString()) || accountId.toString().equals(spaceInfo[9]))){
						index = i;
						return index;
					}
				}
			}
		}
        return index;
    }

    /**
     * 如果用户没有调整过空间排序，或者管理员不允许用户设置默认空间，并且空间列表里存在管理员设置的默认空间，则把默认空间放到第1的位置
     * @param list 空间列表
     * @param accountId 单位id
     * @throws BusinessException
     */
    private void putDefaultSpaceToFirst(LinkedList<String[]> selectedSpaces, LinkedList<String[]> unselectedSpaces, Long accountId,boolean isSpaceResorted) throws BusinessException {
    	if(!isSpaceResorted){
    		isSpaceResorted = isSpaceResorted(AppContext.currentUserId(), accountId);
    	}
    	DefaultSpaceSetting accountSetting = DefaultSpaceSetting.getDefaultSpaceSettingForAccount(accountId);
    	if("0".equals(accountSetting.getAllowChangeDefaultSpace()) || isSpaceResorted == false){
    		//如果用户没有调整过空间排序，或者管理员不允许用户设置默认空间
        	int index = findDefaultSpaceIndexFromList(selectedSpaces, accountId, accountSetting);
        	if(index == -1){
        		//已选里没找到从备选里找
        		index = findDefaultSpaceIndexFromList(unselectedSpaces, accountId, accountSetting);
        		if(index != -1){
        			//备选里找到
        			String[] defaultSpaceInfo = unselectedSpaces.remove(index);
        			selectedSpaces.addFirst(defaultSpaceInfo);
        		} else {
        			//单位的设置里没有找到，那就用集团的设置再找一次
        	    	DefaultSpaceSetting groupSetting = DefaultSpaceSetting.getDefaultSpaceSettingForGroup();
        	    	if("0".equals(groupSetting.getAllowChangeDefaultSpace()) || isSpaceResorted == false){
            			index = findDefaultSpaceIndexFromList(selectedSpaces, accountId, groupSetting);
            			if(index != -1){
            				//已选里找到
            				String[] defaultSpaceInfo = selectedSpaces.remove(index);
                    		selectedSpaces.addFirst(defaultSpaceInfo);
            			} else {
            				//已选里没找到从备选里找
            				index = findDefaultSpaceIndexFromList(unselectedSpaces, accountId, groupSetting);
            				if(index != -1){
                    			//备选里找到
            					String[] defaultSpaceInfo = unselectedSpaces.remove(index);
                    			selectedSpaces.addFirst(defaultSpaceInfo);
                    		}
            			}
        	    	}
        		}
        	} else {
        		//已选里找到
        		String[] defaultSpaceInfo = selectedSpaces.remove(index);
        		selectedSpaces.addFirst(defaultSpaceInfo);
        	}
    	}
    }

    /**
     * 获取空间使用授权范围
     * @param canshare 空间使用授权字符串
     * @return 被授权的人员（V3xOrgMember）集合
     */
    public List<V3xOrgMember> getSpaceUsingAuthRange(String canshare) throws BusinessException {
        List<V3xOrgMember> members = new ArrayList<V3xOrgMember>();
        if(canshare != null && canshare.trim().length() > 0){
            String[] shareAuths = canshare.split(",");
            for(int i = 0; i < shareAuths.length; i++){
                String[] security = shareAuths[i].split("[|]");
                Long id = Long.valueOf(security[1]);
                List<V3xOrgMember> accountMembers = null;
                if("Account".equals(security[0])){
                    accountMembers = orgManager.getAllMembers(id);
                    if(CollectionUtils.isNotEmpty(accountMembers)){
                        members.addAll(accountMembers);
                    }
                }
                else if("Department".equals(security[0])){
                    accountMembers = orgManager.getMembersByDepartment(id, false);
                    if(CollectionUtils.isNotEmpty(accountMembers)){
                        members.addAll(accountMembers);
                    }
                }
                else if("Post".equals(security[0])){
                    accountMembers = orgManager.getMembersByPost(id);
                    if(CollectionUtils.isNotEmpty(accountMembers)){
                        members.addAll(accountMembers);
                    }
                }
                else if("Level".equals(security[0])){
                    accountMembers = orgManager.getMembersByLevel(id);
                    if(CollectionUtils.isNotEmpty(accountMembers)){
                        members.addAll(accountMembers);
                    }
                }
                else if("Team".equals(security[0])){
                    accountMembers = orgManager.getMembersByTeam(id);
                    if(CollectionUtils.isNotEmpty(accountMembers)){
                        members.addAll(accountMembers);
                    }
                }
                else if("Member".equals(security[0])){
                    V3xOrgMember  member = orgManager.getMemberById(id);
                    members.add(member);
                }
            }
        }
        return members;
    }
    private String getDefaultSpaceNameKey(String spaceName){
    	Map<String,String> nameMap = new HashMap<String,String>();
    	nameMap.put(ResourceUtil.getString("space.default.performance.label"), "space.default.performance.label");
    	nameMap.put(ResourceUtil.getString("space.default.department.label"), "space.default.department.label");
    	nameMap.put(ResourceUtil.getString("space.default.personal_custom.label"), "space.default.personal_custom.label");
    	nameMap.put(ResourceUtil.getString("space.default.public_custom.label"), "space.default.public_custom.label");
    	nameMap.put(ResourceUtil.getString("space.default.personal.label"), "space.default.personal.label");
    	nameMap.put(ResourceUtil.getString("space.default.meeting.label"), "space.default.meeting.label");
    	nameMap.put(ResourceUtil.getString("space.default.leader.label"), "space.default.leader.label");
    	nameMap.put(ResourceUtil.getString("space.default.corporation.label"), "space.default.corporation.label");
    	nameMap.put(ResourceUtil.getString("space.default.custom.label"), "space.default.custom.label");
    	nameMap.put(ResourceUtil.getString("space.default.public_custom_group.label"), "space.default.public_custom_group.label");
    	nameMap.put(ResourceUtil.getString("space.default.group.label"), "space.default.group.label");
    	nameMap.put(ResourceUtil.getString("space.default.outer.label"), "space.default.outer.label");
    	nameMap.put(ResourceUtil.getString("space.default.formbiz.label"), "space.default.formbiz.label");
    	nameMap.put(ResourceUtil.getString("space.default.cooperation.label"), "space.default.cooperation.label");
    	nameMap.put(ResourceUtil.getString("space.default.edoc.label"), "space.default.edoc.label");
    	nameMap.put(ResourceUtil.getString("space.default.group.label"), "space.default.group.label");
    	return nameMap.get(spaceName);
    }
    @Override
    public void transSaveSpace(Map params) throws BusinessException {
        String spaceId = params.get("id").toString();
        String defaultspace = (String) params.get("defaultspace");
        String spacename = (String) params.get("spacename");
        String accountType = (String) params.get("accountType");
        User user = AppContext.getCurrentUser();
        Long accountId = user.getLoginAccount();
        Long entityId = user.getLoginAccount();
        if (!"group".equals(accountType)) {
            accountId = user.getLoginAccount();
        }else{
            V3xOrgAccount group = this.orgManager.getRootAccount();
            accountId = group.getId();
        }
        /**
         * TODO:增加当前角色为部门管理员的判断
         */
        boolean isDuplicateName = spaceDao.checkDuplicateName(spacename, Long.valueOf(spaceId), accountId);
        if (isDuplicateName) {
            throw new BusinessException(ResourceUtil.getString("space.label.name.duplicate"));
        }
        if(Strings.isNotBlank(this.getDefaultSpaceNameKey(spacename))){
            spacename = this.getDefaultSpaceNameKey(spacename);
        }
        String path = (String) params.get("path");
        //使用授权
        String canshare = (String) params.get("canshare");
        //管理授权
        String canmanage = (String) params.get("canmanage");
        String canpush = (String) params.get("canpush");
        String canpersonal = (String) params.get("canpersonal");

        String state = (String) params.get("state");
        String spaceMenuEnable = (String) params.get("spaceMenuEnable");
        String spacePubinfoEnable = (String) params.get("spacePubinfoEnable");
        String editKeyId = (String) params.get("editKeyId");
        String decoration = (String) params.get("decoration");
        String spaceIcon = (String) params.get("spaceIcon");

        if (spaceMenuEnable == null){
            spaceMenuEnable = "0";
        }
        if (spacePubinfoEnable == null){
            spacePubinfoEnable = "0";
        }
        String sortId = (String) params.get("sortId");
        PortalSpaceFix space = new PortalSpaceFix();

        boolean isInsert = false;

        if ("0".equals(spaceId)) {
            //新建空间
            isInsert = true;
            long newId = UUIDLong.longUUID();

            EnumMap<PropertyName, String> typeMap = this.getPortletEntityProperty(path);
            String typeStr = typeMap.get(PropertyName.spaceType);
            SpaceType spaceType = SpaceType.valueOf(typeStr);
            String pathFolder = Constants.getCustomPagePath(spaceType);
            String newPath = pathFolder + newId + Constants.DOCUMENT_TYPE;
            space.setId(newId);
            space.setDefaultspace(Integer.valueOf(defaultspace));
            space.setSpacename(spacename);
            space.setPath(newPath);
            space.setType(spaceType.ordinal());
            space.setState(Integer.valueOf(state));
            space.setEntityId(entityId);
            space.setAccountId(accountId);
            space.setSpaceMenuEnable(Integer.valueOf(spaceMenuEnable));
            space.setSpacePubinfoEnable(Integer.valueOf(spacePubinfoEnable));
            space.setSpaceIcon(spaceIcon);

            /*if(isDuplicateSort(Long.valueOf(sortId), Long.valueOf(spaceId))){
                throw new BusinessException("空间排序号重复，保存失败！");
            }*/
            if(Strings.isNotBlank(sortId)){
                space.setSortId(Long.valueOf(sortId));
            }else{
                space.setSortId(selectMaxSort() + 1);
            }
            if(space.getType()==Constants.SpaceType.related_project_space.ordinal()){
            	space.setSortId(0l);
            }
            //空间个性化
            String extProperties = "";
            SpaceFixUtil fixUtil = new SpaceFixUtil(extProperties);
            if(Strings.isBlank(canpersonal)){
                fixUtil.setAllowdefined(false);
            }else{
                fixUtil.setAllowdefined(true);
            }
            if(Strings.isNotBlank(canpush) && "0".equals(canpush)){
            	fixUtil.setAllowpushed(true);
        	}else{
        		fixUtil.setAllowpushed(false);
        	}
            extProperties = fixUtil.getExtAttributes();
            space.setExtAttributes(extProperties);

            pageManager.transCopyPage(path, newPath);

            pageManager.saveFragmentFromCache(Long.valueOf(editKeyId), user.getId(), newPath, decoration);

            insertSpace(space);
            //TODO还需复制2张表
            spaceId = String.valueOf(newId);
        } else {
            //修改空间
            space = this.getSpaceFix(Long.valueOf(spaceId));
            space.setSpacename(spacename);
            space.setPath(path);
            space.setState(Integer.valueOf(state));
            space.setSpaceIcon(spaceIcon);

            spaceCustomSortForDisableSpace(space, accountId);
            String canshareAndCanManage=canshare;
            if(canshareAndCanManage!=null&&!"".equals(canshareAndCanManage)){
            	if(canmanage!=null&&!"".equals(canmanage)){
            		canshareAndCanManage=canshareAndCanManage+","+canmanage;
            	}
            }else{
            	canshareAndCanManage=canmanage;
            }
            spaceCustomSortForAuthChange(space, canshareAndCanManage, accountId);

            if(space.getType() == SpaceType.Default_department.ordinal() || space.getType() == SpaceType.department.ordinal()){
            	log.info("部门空间状态修改记录:"+AppContext.getCurrentUser().getName()+" | "+AppContext.getCurrentUser().getId()+ " 修改部门空间 ["+space.getSpacename()+"]的状态为"+(space.getState()==0?"启用":"停用"));
            }


            //同步修改本空间个性化空间的状态
            this.spaceDao.updateSpaceStateByParentId(Long.valueOf(spaceId), Integer.valueOf(state));

            space.setSpaceMenuEnable(Integer.valueOf(spaceMenuEnable));
            space.setSpacePubinfoEnable(Integer.valueOf(spacePubinfoEnable));
            space.setUpdateTime(DateUtil.currentDate());
            //空间个性化
            String extProperties = space.getExtAttributes();
            SpaceFixUtil fixUtil = new SpaceFixUtil(extProperties);

            if(Strings.isBlank(canpersonal)){
                fixUtil.setAllowdefined(false);
            }else{
                fixUtil.setAllowdefined(true);
            }
            if(Strings.isNotBlank(canpush) && "0".equals(canpush)){
            	fixUtil.setAllowpushed(true);
        	}else{
        		fixUtil.setAllowpushed(false);
        	}
            extProperties = fixUtil.getExtAttributes();
            space.setExtAttributes(extProperties);

            if(Strings.isNotBlank(sortId)){
                space.setSortId(Long.valueOf(sortId));
            }else{
                space.setSortId(selectMaxSort() + 1);
            }
            if(space.getType()==Constants.SpaceType.related_project_space.ordinal()){
            	space.setSortId(0l);
            }

            pageManager.saveFragmentFromCache(Long.valueOf(editKeyId), user.getId(), path, decoration);

            /**
             * 删除个性化空间
             */
            if(!fixUtil.isAllowdefined()){
                List<PortalSpaceFix> spaces = this.spaceDao.getSpacesByParentId(Long.valueOf(spaceId));
                if(CollectionUtils.isNotEmpty(spaces)){
                    for(PortalSpaceFix spaceFix : spaces){
                        this.deleteSpace(spaceFix);
                        deletePageFixFromCache(spaceFix);
                    }
                }
            } else {
            	List<PortalSpaceFix> spaces = this.spaceDao.getSpacesByParentId(Long.valueOf(spaceId));
            	if(spaces != null && spaces.size() > 0){
            		for(PortalSpaceFix fix : spaces){
            			fix.setExtAttributes(extProperties);
            			fix.setSpaceIcon(space.getSpaceIcon());
            			putPageFixToCache(fix);
            		}
            	}
            	DBAgent.updateAll(spaces);
            }
            putPageFixToCache(space);
            DBAgent.update(space);
        }
        if(Strings.isNotBlank(canpush) && SpaceState.normal.ordinal() == space.getState()){
            /**
             * TODO:空间推送逻辑,根据授权范围获取所有人
             */
            List<V3xOrgMember> members = getSpaceUsingAuthRange(canshare);
            this.pushLeaderSpace(space, members, accountId);
        }
        String exitSecuritySave = params.get("exitSecuritySave") == null ? null : (String)params.get("exitSecuritySave");
        if(Strings.isBlank(exitSecuritySave) || !"true".equals(exitSecuritySave)){
	        spaceSecurityManager.deleteSecurityBySpaceId(Long.valueOf(spaceId));
	        List<PortalSpaceSecurity> spaceSecuritys = new ArrayList();
	        if (canshare != null && canshare.trim().length() > 0) {
	            String[] shareAuths = canshare.split(",");
	            for (int i = 0; i < shareAuths.length; i++) {
	                String[] share = shareAuths[i].split("[|]");
	                PortalSpaceSecurity spaceSecurity = new PortalSpaceSecurity();
	                spaceSecurity.setNewId();
	                spaceSecurity.setSpaceId(Long.valueOf(spaceId));
	                spaceSecurity.setSecurityType(Constants.SecurityType.used.ordinal());
	                spaceSecurity.setEntityType(share[0]);
	                spaceSecurity.setEntityId(Long.valueOf(share[1]));
	                spaceSecuritys.add(spaceSecurity);
	            }
	        }
	        if (canmanage != null && canmanage.trim().length() > 0) {
	            String[] manageAuths = canmanage.split(",");
	            for (int i = 0; i < manageAuths.length; i++) {
	                String[] manage = manageAuths[i].split("[|]");
	                PortalSpaceSecurity spaceSecurity = new PortalSpaceSecurity();
	                spaceSecurity.setNewId();
	                spaceSecurity.setSpaceId(Long.valueOf(spaceId));
	                spaceSecurity.setSecurityType(Constants.SecurityType.manager.ordinal());
	                spaceSecurity.setEntityType(manage[0]);
	                spaceSecurity.setEntityId(Long.valueOf(manage[1]));
	                spaceSecuritys.add(spaceSecurity);
	            }
	        }


	        DBAgent.saveAll(spaceSecuritys);

	        //生成部门空间时同时生成部门讨论、公告的菜单权限
	        if(SpaceType.department.ordinal() == space.getType()){
	            Long departmentId = space.getEntityId();
	            V3xOrgDepartment dept = orgManager.getDepartmentById(departmentId);
	            if(SpaceState.normal.ordinal() == space.getState()){
	                List<Object[]> securities = this.getSecuityOfDepartment(departmentId);
	                if(CollectionUtils.isNotEmpty(spaceSecuritys)){
	                    String securityStr = "";
	                    for(PortalSpaceSecurity sec : spaceSecuritys){
	                        securityStr += sec.getEntityType()+"|"+sec.getEntityId()+",";
	                    }
	                    roleManager.batchRole2Entity(orgManager.getRoleByName(OrgConstants.Role_NAME.DeptSpace.name(), dept != null ? dept.getOrgAccountId() : null).getId(), securityStr+"^"+departmentId);
	                }
	            }else{
	                roleManager.batchRole2Entity(orgManager.getRoleByName(OrgConstants.Role_NAME.DeptSpace.name(), dept != null ? dept.getOrgAccountId() : null).getId(), "^"+departmentId);
	            }
	        }

	        PortalSpaceFix fix=null;
	        try {
				fix=(PortalSpaceFix) space.clone();
				fix.setId(space.getId());
				fix.setSpacename(ResourceUtil.getString(fix.getSpacename()));
				if(isInsert){
		            AddSpaceEvent event = new AddSpaceEvent(this);
		            event.setSpaceFix(fix);
		            event.setSpaceSecurities(spaceSecuritys);
		            EventDispatcher.fireEvent(event);
		        }else{
		            UpdateSpaceEvent event = new UpdateSpaceEvent(this);
		            event.setSpaceFix(fix);
		            event.setSpaceSecurities(spaceSecuritys);
		            EventDispatcher.fireEvent(event);
		        }
			} catch (Exception e) {
				log.info(e);
			}
        }
        if("1".equals(spaceMenuEnable)){
            String sysMenuTree = (String)params.get("sysMenuTree");
            if(Strings.isNotBlank(sysMenuTree)){
                List<Map<String,Object>> menus = JSONUtil.parseJSONString(sysMenuTree, List.class);
                this.saveSpaceMenu(Long.valueOf(spaceId), menus);
            }
        }else{
            List<Map<String,Object>> menus = new ArrayList<Map<String,Object>>();
            this.saveSpaceMenu(Long.valueOf(spaceId), menus);
        }
    }

    @Override
    public long insertSpace(PortalSpaceFix space) {
    	putPageFixToCache(space);
        return (Long) DBAgent.save(space);
    }

    @Override
    @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator})
    public void deleteSpaceByIds(List<String> spaceIds) throws BusinessException {
        User user = AppContext.getCurrentUser();
        for (String spaceId : spaceIds) {
            PortalSpaceFix space = (PortalSpaceFix) DBAgent.get(PortalSpaceFix.class, Long.valueOf(spaceId));
            if (space.getDefaultspace() == 1) {
                throw new BusinessException(ResourceUtil.getString("space.delete.prompt1"));
            }
            if (space.getState() == 0) {
                throw new BusinessException(ResourceUtil.getString("space.delete.prompt2"));
            }
            Map params = new HashMap();
            params.put("parentId", space.getId());
            List<PortalSpaceFix> spaces = DBAgent.findByNamedQuery("space_findSpaceByParentId", params);
            if (CollectionUtils.isNotEmpty(spaces)) {
                for (PortalSpaceFix fix : spaces) {
                	deletePageFixFromCache(fix);
                    this.deleteSpace(fix);
                }
            }
            deletePageFixFromCache(space);
            this.deleteSpace(space);
            
            //微协同操作日志
            if (Constants.SpaceType.weixinmobile.ordinal() == space.getType() || Constants.SpaceType.weixinmobile_custom.ordinal() == space.getType()
                    || Constants.SpaceType.weixinmobile_leader.ordinal() == space.getType() || Constants.SpaceType.weixinmobile_leader_custom.ordinal() == space.getType()) {
                appLogManager.insertLog(user, 8311, user.getName());
            }
        }
    }

    private void deleteSpace(PortalSpaceFix space) throws BusinessException {
        if (space == null) {
            return;
        }
        Map params = new HashMap();
        params.put("spaceId", space.getId());
        List<PortalSpaceSecurity> securites = DBAgent.findByNamedQuery("space_findSpaceSecuritesBySpaceId", params);

        DeleteSpaceEvent event = new DeleteSpaceEvent(this);
        event.setSpaceFix(space);

        if (CollectionUtils.isNotEmpty(securites)) {
            DBAgent.deleteAll(securites);
            event.setSpaceSecurities(securites);
        }

        this.pageManager.deletePage(space.getPath());
        DBAgent.delete(space);
        
        deletePageFixFromCache(space);
        EventDispatcher.fireEvent(event);
    }
//    private long getIconFileId(PortalSpaceFix space){
//    	if(space==null){
//    		return 0;
//    	}
//    	if(space.getSpaceIcon()==null||"".equals(space.getSpaceIcon())){
//    		return 0;
//    	}
//    	String url=space.getSpaceIcon();
//    	if(url.indexOf("fileId=")>-1){
//    		String fileId=url.substring(url.indexOf("fileId=")).split("&")[0];
//    		fileId=fileId.substring(fileId.indexOf("=")+1);
//    		if(fileId!=null&&!"".equals(fileId)){
//    			try {
//					return Long.parseLong(fileId);
//				} catch (Exception e) {
//					this.log.error("解析附件ID失败!",e);
//					return 0;
//				}
//    		}else{
//    			return 0;
//    		}
//    	}else{
//    		return 0;
//    	}
//    }
    @Override
    public long updateSpace(PortalSpaceFix space) {
    	putPageFixToCache(space);
        DBAgent.update(space);
        List<PortalSpaceSecurity> securities = spaceSecurityManager.selectSecurityBySpaceId(space.getId());
        //space.setSpacename(ResourceUtil.getString(space.getSpacename()));
        UpdateSpaceEvent event = new UpdateSpaceEvent(this);
        event.setSpaceFix(space);
        event.setSpaceSecurities(securities);
        EventDispatcher.fireEvent(event);
        return space.getId();
    }

    @Override
    public FlipInfo selectSpace(FlipInfo fi, Map params) throws BusinessException {
        return spaceDao.selectSpace(fi, params);
    }

    @Override
    public PortalSpacePage getSpacePage(String pagePath) {
        return this.pageManager.getPage(pagePath);
    }

    @Override
    public String[] getLayoutType(String pagePath) throws BusinessException {
        PortalSpacePage page = this.pageManager.getPage(pagePath);
        PortalPagePortlet root = (PortalPagePortlet) page.getExtraAttr("RootPagePortlet");

        String fragment = root.getName();
        String decorator = page.getDefaultLayoutDecorator();

        return new String[] { fragment, decorator };
    }

    @Override
    public PortalSpaceFix getSpaceFix(String pagePath) {
    	return portalCacheManager.getPageFixPathCacheByKey(pagePath);
        //return spaceDao.selectSpaceFix(pagePath);
    }

    @Override
    public EnumMap<PortletPropertyContants.PropertyName, String> getPortletEntityProperty(String pagePath) {
        EnumMap<PortletPropertyContants.PropertyName, String> result = new EnumMap<PortletPropertyContants.PropertyName, String>(
                PortletPropertyContants.PropertyName.class);
        String[] re = new String[] { "", "", "" };
        int pos = pagePath.indexOf(Constants.SEEYON_FOLDER);
        if (pos > -1) {
            re[0] = pagePath.substring(pos);

            String[] a = re[0].split("/");
            if (a == null || a.length != 4) {
                log.error("空间地址不正确，标准格式为[/seeyon/personal/***.psml]。当前URI : " + re[0]);
                return null;
            }

            re[1] = a[2];
            re[2] = a[3].substring(0, a[3].lastIndexOf("."));

            User user = AppContext.getCurrentUser();

            if ("default-page".equalsIgnoreCase(re[2])) {
                if ("objective".equals(re[1])){
                    re[1] = "objective_manage";
                } else if ("cooperation".equals(re[1])){
                    re[1] = "cooperation_work";
                } else if ("edoc".equals(re[1])){
                    re[1] = "edoc_manage";
                } else if ("meeting".equals(re[1])){
                    re[1] = "meeting_manage";
                } else if ("performance".equals(re[1])){
                    re[1] = "performance_analysis";
                } else if ("formbiz".equals(re[1])){
                    re[1] = "form_application";
                }
                    re[2] = "";

                /*if (Constants.SpaceType.personal.name().equals(re[1])
                        || Constants.SpaceType.Default_personal.name().equals(re[1])) {
                    re[2] = String.valueOf(user.getId());
                } else if (Constants.SpaceType.corporation.name().equals(re[1])) {
                    re[2] = String.valueOf(user.getLoginAccount());
                } else {*/
                /*}*/
            } else if (re[2].endsWith(Constants.DEFAULT_SPACE_SUBFIX)) {
                re[2] = re[2].substring(0, re[2].length() - Constants.DEFAULT_SPACE_SUBFIX.length());
            } else if (re[2].endsWith("_Out")) {
                re[2] = re[2].substring(0, re[2].length() - 4);
            }

            result.put(PortletPropertyContants.PropertyName.spaceType, re[1]);
            result.put(PortletPropertyContants.PropertyName.ownerId, re[2]);
        }

        return result;
    }

    @Override
    public List<String[]> getAccessSpaceSort(Long memberId, Long accountId, Locale userLocale, boolean isDefault,
            List<PortalSpaceFix> accessSpaces) throws BusinessException {
        if (memberId == null) {
            return new ArrayList<String[]>(0);
        }
        V3xOrgMember member = orgManager.getMemberById(memberId);

        if(member.getIsAdmin()){
            return new ArrayList<String[]>(0);
        }

        if (accountId == null) {
            accountId = member.getOrgAccountId();
        }

        if (CollectionUtils.isEmpty(accessSpaces)) {
            accessSpaces = this.getAccessSpace(memberId, accountId);
            if (CollectionUtils.isEmpty(accessSpaces)) {
                return new ArrayList<String[]>(0);
            }
        }
        //要返回的空间结果集
        LinkedList<String[]> resultList = new LinkedList<String[]>();
        //去除被个性化的空间-start
        Map<Long, PortalSpaceFix> spaceMap = new LinkedHashMap<Long, PortalSpaceFix>();
        for (PortalSpaceFix space : accessSpaces) {
            spaceMap.put(space.getId(), space);
        }
        for (PortalSpaceFix space : accessSpaces) {
            Long parentSpaceId = space.getParentId();
            if (parentSpaceId != null) {
            	if(spaceMap.containsKey(parentSpaceId)){
            	    //如果父空间在可访问空间中，则去掉父空间
            	    spaceMap.remove(parentSpaceId);
            	}else{
                    //如果父空间不在可访问空间中，则去掉该空间的访问
            	    spaceMap.remove(space.getId());
            	}
            }
        }
        //去除被个性化的空间-end
        Iterator<PortalSpaceFix> itr = spaceMap.values().iterator();
        while (itr.hasNext()) {
            PortalSpaceFix space = itr.next();
            Long currentSpaceAccountId = space.getAccountId();
            Long sortId = space.getSortId();
            String sort = "0";
            if (sortId != null) {
                sort = String.valueOf(sortId);
            }
            String spaceName = ResourceUtil.getString(space.getSpacename());
            String parentId = null;
            if(space.getParentId()!=null){
                parentId = String.valueOf(space.getParentId());
                String _name = getParentSpaceName(space.getParentId());
                if(null != _name){
                    spaceName = _name;
                }
            }

            SpaceType s_Type = EnumUtil.getEnumByOrdinal(SpaceType.class, space.getType());
            SpaceType spaceType = Constants.parseDefaultSpaceType(s_Type);
            String spaceIcon = null;
            switch(spaceType){
                case personal:
                    if(!currentSpaceAccountId.equals(accountId)){
                        continue;
                    }
                    spaceIcon = "menu_personal.png";
                    break;
                case leader:
                    if(!currentSpaceAccountId.equals(accountId)){
                        continue;
                    }
                    spaceIcon = "menu_leader.png";
                    break;
                case outer:
                    if(!currentSpaceAccountId.equals(accountId)){
                        continue;
                    }
                    spaceIcon = "menu_outer.png";
                    break;
                case personal_custom:
                    if(!currentSpaceAccountId.equals(accountId)){
                        spaceName += "(" + Functions.getAccountShortName(currentSpaceAccountId) + ")";
                    }
                    spaceIcon = "menu_personal_custom.png";
                    break;
                case department:
                    if(!currentSpaceAccountId.equals(accountId)){
                        continue;
                        //spaceName += "(" + Functions.getAccountShortName(currentSpaceAccountId) + ")";
                    }
                    spaceIcon = "menu_department.png";
                    break;
                case custom:
                    if(!currentSpaceAccountId.equals(accountId)){
                        spaceName += "(" + Functions.getAccountShortName(currentSpaceAccountId) + ")";
                    }
                    spaceIcon = "menu_custom.png";
                    break;
                case corporation:
                    if(!currentSpaceAccountId.equals(accountId)){
                        continue;
                        //spaceName += "(" + Functions.getAccountShortName(currentSpaceAccountId) + ")";
                    }
                    spaceIcon = "menu_corporation.png";
                    break;
                case public_custom:
                    if(!currentSpaceAccountId.equals(accountId)){
                        spaceName += "(" + Functions.getAccountShortName(currentSpaceAccountId) + ")";
                    }
                    spaceIcon = "menu_public_custom.png";
                    break;
                case group:
                    spaceIcon = "menu_group.png";
                    break;
                case public_custom_group:
                    spaceIcon = "menu_public_custom_group.png";
                    break;
                default:
                    break;

            }
            if(space.getSpaceIcon()!=null&&!"".equals(space.getSpaceIcon())){//如果有空间icon则用上传的icon
            	spaceIcon = space.getSpaceIcon();
            }
            String[] objStr = { String.valueOf(space.getId()), parentId, space.getPath(), spaceName, String.valueOf(SpaceState.normal.ordinal()), sort, String.valueOf(space.getType()), "2", spaceIcon, space.getAccountId().toString()};
            resultList.add(objStr);
        }
        return resultList;
    }

    private String getParentSpaceName(Long parentId){
        if(null != parentId){
            PortalSpaceFix  f = this.getSpaceFix(Long.valueOf(parentId));
            if(null != f){
                return ResourceUtil.getString(f.getSpacename());
            }
        }
        return null;
    }

    @Override
    public List<String[]> getAccessedLinkSystemSpace(Long memberId) throws BusinessException {
        List<String[]> linkSpaces = new ArrayList<String[]>();
        List<PortalLinkSpace> linkSpaceList = linkSpaceManager.findLinkSpacesCanAccess(memberId);
        if (CollectionUtils.isNotEmpty(linkSpaceList)) {
            for (PortalLinkSpace pls : linkSpaceList) {
            	String icon=linkSystemManager.getLinkSytemIconById(pls.getLinkSystemId());
                String[] objStr = { String.valueOf(pls.getId()), null,
                        "/seeyon/portal/linkSystemController.do?method=linkConnect&linkId=" + pls.getId(),
                        pls.getSpaceName(), String.valueOf(SpaceState.normal.ordinal()), String.valueOf(SpaceType.related_system.ordinal()),
                        String.valueOf(SpaceType.related_system.ordinal()), pls.getOpenType() == 1 ? "1" : "2",
                        		(icon==null||"".equals(icon))?"menu_linksystem.png":icon};
                linkSpaces.add(objStr);
            }
        }
        return linkSpaces;
    }

    @Override
    public List<String[]> getAccessedThirdpartySpace(Long memberId, Long accountId, Locale userLocale) throws BusinessException {
        List<String[]> thirdPartySpaces = new ArrayList<String[]>();
        List<ThirdpartySpace> thirdPartySpacesList = ThirdpartySpaceManager.getInstance().getAccessSpaces(orgManager, memberId, null, null);
        if (CollectionUtils.isNotEmpty(thirdPartySpacesList)) {
            int type = Constants.SpaceType.thirdparty.ordinal();
            for (ThirdpartySpace thirdParty : thirdPartySpacesList) {
                String pageUrl = thirdParty.getPageURL(memberId, accountId);
                String openType = thirdParty.getOpenType();
                if ("workspace".equals(openType)) {
                    openType = "2";
                } else {
                    openType = "1";
                }
                String[] s = { thirdParty.getId(), null,
                        "/thirdpartyController.do?method=show&id=" + thirdParty.getId() + "&pageUrl=" + pageUrl,
                        thirdParty.getNameOfResouceBundle(userLocale), String.valueOf(SpaceState.normal.ordinal()),
                        null, String.valueOf(type), openType, "menu_thridpartyspace.png" };
                thirdPartySpaces.add(s);
            }
        }
        return thirdPartySpaces;
    }

    @Override
    public List<String[]> getAccessedRelatedProjectSpace(Long memberId) throws BusinessException {
        List<String[]> relatedProjectSpaces = new ArrayList<String[]>();
        if(projectApi != null){
            List<ProjectBO> relatedProjectList = null;
            if (AppContext.hasPlugin("project")) {
                relatedProjectList = projectApi.findProjects4MemberId(memberId);
            } else {
                relatedProjectList = new ArrayList<ProjectBO>();
            }
            if (CollectionUtils.isNotEmpty(relatedProjectList)) {
                for (ProjectBO rpj : relatedProjectList) {
                    String[] objStr = { String.valueOf(rpj.getId()), null,
                            "/project/project.do?method=projectSpace&from=fromSpace&projectId=" + rpj.getId(), rpj.getProjectName(),
                            String.valueOf(SpaceState.normal.ordinal()), String.valueOf(SpaceType.related_project_space.ordinal()),
                            String.valueOf(SpaceType.related_project.ordinal()), "2", "menu_relateproject.png" };
                    relatedProjectSpaces.add(objStr);
                }
            }
        }
        return relatedProjectSpaces;
    }

    @SuppressWarnings({ "unchecked" })
	public void screeningSpaces(List<String[]> accessedPortalSpaceFixList, List<String[]> accessedThirdpartySpaces, List<String[]> accessedLinkSpaces, List<String[]> accessedRelatedProjects, List<String[]> unSelectedSpaces, List<String[]> unSelectedLinkSpaces, List<String[]> unSelectedRelatedProjects, List<String[]> selectedSpaces) throws BusinessException {
        //获取自定义空间导航排序数据
        User user = AppContext.getCurrentUser();
        //更新缓存
        UserCustomizeCache.reloadCustomize(CustomizeConstants.SPACE_ORDER);
        Map<String, Map<String, Map<String, Object>>> spaceOrder = user.getCustomizeJson(CustomizeConstants.SPACE_ORDER, Map.class);
        sortSpace(spaceOrder);//xx重新排序
        Map<String, Map<String, Object>> spaceSortMap = null;
        if(spaceOrder != null){
            spaceSortMap = (Map<String, Map<String, Object>>) spaceOrder.get(String.valueOf(AppContext.currentAccountId()));
        }
        if(spaceOrder == null || spaceOrder.size() == 0 || spaceSortMap == null){
            //没有自定义空间导航排序
            selectedSpaces.addAll(accessedPortalSpaceFixList);
            selectedSpaces.addAll(accessedThirdpartySpaces);
            //unSelectedLinkSpaces.addAll(accessedLinkSpaces);
            selectedSpaces.addAll(accessedLinkSpaces);
            unSelectedRelatedProjects.addAll(accessedRelatedProjects);
            sortSpace(selectedSpaces);
            putDefaultSpaceToFirst((LinkedList<String[]>)selectedSpaces, null, AppContext.currentAccountId(),false);
        } else {
            //有自定义空间导航排序
            Map<String, String[]> spaceMap = new LinkedHashMap<String, String[]>();
            for(String[] space : accessedPortalSpaceFixList){
            	if(space[1] == null){
                    spaceMap.put(space[0], space);
            	} else {
                    spaceMap.put(space[1], space);
            	}
            }
            for(String[] space : accessedThirdpartySpaces){
                spaceMap.put(space[0], space);
            }
            for(String[] space : accessedLinkSpaces){
                spaceMap.put(space[0], space);
            }
            for(String[] space : accessedRelatedProjects){
                spaceMap.put(space[0], space);
            }
            Iterator<Map<String, Object>> itr = spaceSortMap.values().iterator();
            while(itr.hasNext()){
                Map<String, Object> spaceEntry = itr.next();
                String spaceId = spaceEntry.get(CustomizeConstants.SPACE_ID).toString();
                int spaceType = Integer.valueOf(spaceEntry.get(CustomizeConstants.SPACE_TYPE).toString());
                String isUnSelected = spaceEntry.get(CustomizeConstants.SPACE_ISDELETED).toString();
                String[] space = spaceMap.get(spaceId);
                if(space != null){
                    if(spaceType == SpaceType.related_system.ordinal()){
                        if("1".equals(isUnSelected)){
                            unSelectedLinkSpaces.add(space);
                        } else {
                            selectedSpaces.add(space);
                        }
                    } else if(spaceType == SpaceType.thirdparty.ordinal()){
                        if("1".equals(isUnSelected)){
                            unSelectedSpaces.add(space);
                        } else {
                            selectedSpaces.add(space);
                        }
                    } else if(spaceType == SpaceType.related_project.ordinal()){
                        if("1".equals(isUnSelected)){
                            unSelectedRelatedProjects.add(space);
                        } else {
                            selectedSpaces.add(space);
                        }
                    } else {
                        if("1".equals(isUnSelected)){
                            unSelectedSpaces.add(space);
                        } else {
                            selectedSpaces.add(space);
                        }
                    }
                    spaceMap.remove(spaceId);
                }
            }
            Collection<String[]> leftSpaces = spaceMap.values();
            if(leftSpaces != null && leftSpaces.size() > 0){
            	for(String[] space : leftSpaces){
            		int spaceType = Integer.valueOf(space[6]);
                	if(spaceType == SpaceType.related_system.ordinal()){
                		//unSelectedLinkSpaces.add(space);
                		selectedSpaces.add(space);
                	} else if(spaceType == SpaceType.related_project.ordinal()){
                		unSelectedRelatedProjects.add(space);
                	} else {
                        selectedSpaces.add(space);
                	}
            	}
            }
            putDefaultSpaceToFirst((LinkedList<String[]>) selectedSpaces, (LinkedList<String[]>) unSelectedSpaces, AppContext.currentAccountId(),true);
        }
    }
    /**
     * 空间排序方法,修复fastjson转换中没按数字排序
     * @param map
     */
    private void sortSpace(Map<String, Map<String, Map<String, Object>>> map) {
    	if(map==null||map.size()<1)return;
		for (Entry<String, Map<String, Map<String, Object>>> entry : map.entrySet()) {
			Map<String, Map<String, Object>>mm=entry.getValue();
			Object [] sd=mm.keySet().toArray();
			Map<String, Map<String, Object>> lm = new LinkedHashMap<String, Map<String, Object>>();
			Arrays.sort(sd,new Comparator<Object>() {
				public int compare(Object o1, Object o2) {
					if(o1==null||o2==null){
						return -1;
					}
					if(Integer.valueOf(o1.toString())>Integer.valueOf(o2.toString())){
						return 1;
					}else if(Integer.valueOf(o1.toString())<Integer.valueOf(o2.toString())){
						return -1;
					}else{
						return 0;
					}
				}
			});
			for(Object key:sd){
				String k=key.toString();
				lm.put(k, mm.get(k));
			}
			map.put(entry.getKey(), lm);
		}
	}
    /**
     * 未自定义空间排序方法
     */
    private void sortSpace(List<String[]> finalList){
    	 //排序号为null的空间往后排
        Collections.sort(finalList, new Comparator<String[]>(){
            @Override
            public int compare(String[] space0, String[] space1) {
                String sort0 = space0[5];
                String sort1 = space1[5];
                if(Strings.isBlank(sort1) || "null".equals(sort1)){
                    return -1;
                }else if((Strings.isBlank(sort0) || "null".equals(sort0)) && !(Strings.isBlank(sort1) || "null".equals(sort1))){
                    return 1;
                }else{
                    return Integer.parseInt(sort0) - Integer.parseInt(sort1);
                }
            }
        });
    }
    /**
     * 获取所有有权限访问的空间结果集并按照sortId排序，包括portal_space_fix、关联系统扩展空间、第3方系统空间、关联项目空间（其中的元素转换为String[]）
     * @param memberId
     * @return
     * @throws BusinessException
     */
    public List<String[]> getAllAccessedSpace(Long memberId, Long accountId, Locale userLocale, boolean isDefault, List<PortalSpaceFix> accessSpaces) throws BusinessException {
        //要返回的结果集
    	LinkedList<String[]> finalList = new LinkedList<String[]>();
        //系统本身的portal_space_fix表的空间集合
        List<String[]> portalSpaceFixList = getAccessSpaceSort(memberId, accountId, userLocale, isDefault, accessSpaces);
        //关联系统扩展空间
        List<String[]> linkSpaces = getAccessedLinkSystemSpace(memberId);
        //第3方系统空间
        List<String[]> thirdPartySpaces = getAccessedThirdpartySpace(memberId, accountId, userLocale);
        //关联项目空间
        List<String[]> relatedProjectSpaces = getAccessedRelatedProjectSpace(memberId);
        //要返回的空间结果集
        finalList.addAll(portalSpaceFixList);
        finalList.addAll(linkSpaces);
        finalList.addAll(thirdPartySpaces);
        finalList.addAll(relatedProjectSpaces);
        sortSpace(finalList);
        return finalList;
    }

    @SuppressWarnings({ "unchecked", "rawtypes" })
    @Override
    public List<String[]> getSpaceSort(Long memberId, Long accountId, Locale userLocale, boolean isDefault, List<PortalSpaceFix> accessSpaces) throws BusinessException {
        //要返回的空间结果集
        LinkedList<String[]> finalList = (LinkedList)getAllAccessedSpace(memberId, accountId, userLocale, isDefault, accessSpaces);
        /**
         * 获取自定义空间导航排序数据
         */
        User user = AppContext.getCurrentUser();
        //更新缓存
        UserCustomizeCache.reloadCustomize(CustomizeConstants.SPACE_ORDER);
        Map<String, Map<String, Map<String, Object>>> spaceOrder = user.getCustomizeJson(CustomizeConstants.SPACE_ORDER, Map.class);
        sortSpace(spaceOrder);//xx重新排序
        Map<String, Map<String, Object>> spaceSortMap = null;
        if(spaceOrder != null){
        	spaceSortMap = (Map<String, Map<String, Object>>) spaceOrder.get(String.valueOf(accountId));
        }
        if(spaceOrder == null || spaceOrder.size() == 0 || spaceSortMap == null){
            //没有自定义空间导航排序
        	Iterator itr = finalList.iterator();
        	while(itr.hasNext()){
        		String[] spaceInfo = (String[]) itr.next();
        		int spaceType = Integer.valueOf(spaceInfo[6]);
            	if(spaceType == SpaceType.related_system.ordinal()){
            		//itr.remove();
            	} else if(spaceType == SpaceType.related_project.ordinal()){
            		itr.remove();
            	}
        	}
        	putDefaultSpaceToFirst((LinkedList<String[]>)finalList, null, accountId,false);
            return finalList;
        } else {
            //有自定义空间导航排序
            Map<String, String[]> finalListMap = new LinkedHashMap<String, String[]>();
            for(String[] space : finalList){
            	if(space[1] == null){
                    finalListMap.put(space[0], space);
            	} else {
            		finalListMap.put(space[1], space);
            	}
            }
            finalList.clear();
            Iterator<Map<String, Object>> itr = spaceSortMap.values().iterator();
            LinkedList<String[]> unSelectedSpaceList = new LinkedList<String[]>();
            while(itr.hasNext()){
                Map<String, Object> spaceEntry = itr.next();
                String spaceId = String.valueOf(spaceEntry.get(CustomizeConstants.SPACE_ID));
                String isUnSelected = spaceEntry.get(CustomizeConstants.SPACE_ISDELETED).toString();
                if("1".equals(isUnSelected)){
                	String[] space = finalListMap.get(spaceId);
                    if(space != null){
                    	unSelectedSpaceList.add(space);
                    }
                } else {
                    String[] space = finalListMap.get(spaceId);
                    if(space != null){
                        finalList.add(space);
                    }
                }
                finalListMap.remove(spaceId);
            }
            Collection<String[]> leftSpaces = finalListMap.values();
            if(leftSpaces != null && leftSpaces.size() > 0){
            	for(String[] space : leftSpaces){
            		int spaceType = Integer.valueOf(space[6]);
                	if(spaceType == SpaceType.related_system.ordinal()){
                		//unSelectedSpaceList.add(space);
                		finalList.add(space);
                	} else if(spaceType == SpaceType.related_project.ordinal()){
                		unSelectedSpaceList.add(space);
                	} else {
                		finalList.add(space);
                	}
            	}
            }
            putDefaultSpaceToFirst((LinkedList<String[]>)finalList, unSelectedSpaceList, accountId,true);
            return finalList;
        }
    }
    @SuppressWarnings({ "unchecked", "rawtypes" })
    @Override
    public List<String[]> getAllSpaceSort(Long memberId, Long accountId, Locale userLocale, boolean isDefault, List<PortalSpaceFix> accessSpaces) throws BusinessException {
        //要返回的空间结果集
        LinkedList<String[]> finalList = (LinkedList)getAllAccessedSpace(memberId, accountId, userLocale, isDefault, accessSpaces);
        /**
         * 获取自定义空间导航排序数据
         */
        User user = AppContext.getCurrentUser();
        //更新缓存
        UserCustomizeCache.reloadCustomize(CustomizeConstants.SPACE_ORDER);
        Map<String, Map<String, Map<String, Object>>> spaceOrder = user.getCustomizeJson(CustomizeConstants.SPACE_ORDER, Map.class);
        sortSpace(spaceOrder);//xx重新排序
        Map<String, Map<String, Object>> spaceSortMap = null;
        if(spaceOrder != null){
        	spaceSortMap = (Map<String, Map<String, Object>>) spaceOrder.get(String.valueOf(accountId));
        }
        if(spaceOrder == null || spaceOrder.size() == 0 || spaceSortMap == null){
        	putDefaultSpaceToFirst((LinkedList<String[]>)finalList, null, accountId,false);
            return finalList;
        } else {
            //有自定义空间导航排序
            Map<String, String[]> finalListMap = new LinkedHashMap<String, String[]>();
            for(String[] space : finalList){
            	if(space[1] == null){
                    finalListMap.put(space[0], space);
            	} else {
            		finalListMap.put(space[1], space);
            	}
            }
            finalList.clear();
            Iterator<Map<String, Object>> itr = spaceSortMap.values().iterator();
            LinkedList<String[]> unSelectedSpaceList = new LinkedList<String[]>();
            while(itr.hasNext()){
                Map<String, Object> spaceEntry = itr.next();
                String spaceId = String.valueOf(spaceEntry.get(CustomizeConstants.SPACE_ID));
                String[] space = finalListMap.get(spaceId);
                if(space != null){
                    finalList.add(space);
                }
                finalListMap.remove(spaceId);
            }
            Collection<String[]> leftSpaces = finalListMap.values();
            if(leftSpaces != null && leftSpaces.size() > 0){
            	for(String[] space : leftSpaces){
            		finalList.add(space);
            	}
            }
            putDefaultSpaceToFirst((LinkedList<String[]>)finalList, unSelectedSpaceList, accountId,true);
            return finalList;
        }
    }

    @Override
    public List<PortalSpaceFix> getAccessSpace(Long memberId, Long accountId) throws BusinessException {
        if (memberId == null) {
            return null;
        }
        V3xOrgMember member = orgManager.getMemberById(memberId);
        List<Long> domainIds = new ArrayList<Long>();
        /**
         * 1、空间只有授权给外部人员本身或者外部人员所在外部单位的情况下才能看到该空间；
         * 2、外部人员默认拥有外部人员空间权限。
         */
        if(member.getIsInternal()){
            domainIds = orgManager.getAllUserDomainIDs(memberId);
        }else{
            domainIds = orgManager.getUserDomainIDs(memberId, accountId, V3xOrgEntity.ORGENT_TYPE_MEMBER,V3xOrgEntity.ORGENT_TYPE_DEPARTMENT,V3xOrgEntity.ORGENT_TYPE_TEAM);
        }
        List<Long> departmentIds = this.getDeptsByManager(memberId, accountId);// 我是主管的部门
        StringBuffer hql = new StringBuffer(
                "select distinct fix from PortalSpaceFix as fix, PortalSpaceSecurity as sec where fix.id = sec.spaceId and fix.state = :state and fix.type < 19 ");

        if(member.getIsInternal()){
            hql.append(" and fix.type != 14 and fix.type != 16");
        }else{
            hql.append(" and fix.type !=0 and fix.type !=5 ");
        }
        Map params = new HashMap();
        params.put("state", Constants.SpaceState.normal.ordinal());
        
        StringBuilder sb = new StringBuilder();
        this.getHqlByRecursion(domainIds, "domainIds","sec.entityId", sb, params, 0);
        String domainIdsSql= sb.toString();
        
        StringBuilder sb2 = new StringBuilder();
        this.getHqlByRecursion(departmentIds,"departmentIds", "fix.entityId", sb2, params, 0);
        String departmentIdsSql= sb2.toString();
        
        if(Strings.isNotBlank(domainIdsSql) && Strings.isNotBlank(departmentIdsSql)){
        	hql.append(" and (");
            hql.append(domainIdsSql);
            hql.append(" or ");
            hql.append(departmentIdsSql);
            hql.append(" )");
        }else if(Strings.isNotBlank(domainIdsSql)){
        	hql.append(" and (");
            hql.append(domainIdsSql);
            hql.append(" )");
        }else if(Strings.isNotBlank(departmentIdsSql)){
        	hql.append(" and (");
            hql.append(departmentIdsSql);
            hql.append(" )");
        }
        hql.append(" order by fix.sortId ");

        List<PortalSpaceFix> spaces = DBAgent.find(hql.toString(), params);

        if(!member.getIsInternal()){
            PortalSpaceFix outerSpace = this.transCreateDefaultOuterSpace(accountId);
            if(null != outerSpace && SpaceState.normal.ordinal() == outerSpace.getState()){
                spaces.add(outerSpace);
            }
        }

        //当部门空间使用授权和管理授权全部清空时，部门主管看不到部门空间，这里进行容错
        StringBuffer findDepartmentSpaces = new StringBuffer("select fix from PortalSpaceFix as fix where fix.id not in ( select sec.spaceId from PortalSpaceSecurity as sec) and fix.state = :state and ( fix.type = 1 or fix.type = 6 ) and fix.entityId in (:departmentIds)");

        if(CollectionUtils.isNotEmpty(departmentIds)){
        	 Map param = new HashMap();
        	 param.put("state", Constants.SpaceState.normal.ordinal());
        	 param.put("departmentIds", departmentIds);

        	 List<PortalSpaceFix> departmentSpaces = DBAgent.find(findDepartmentSpaces.toString(),param);

        	 if(CollectionUtils.isNotEmpty(departmentSpaces)){
        		 spaces.addAll(departmentSpaces);
        	 }
        }

        if (CollectionUtils.isEmpty(spaces)) {
            return null;
        } else {
            return spaces;
        }
    }
    
    /**
     * 防止查询时参数过多，递归 拼写查询参数
     * @param li
     * @param argPrefix
     * @param field
     * @param sb
     * @param params
     * @param index
     * @return
     */
    private String getHqlByRecursion(List<Long> li,String argPrefix,String field,StringBuilder sb,Map params,int index){
    	if(Strings.isNotEmpty(li) && li.size() < 1000){
    		String arg = argPrefix + index;
    		if(Strings.isNotBlank(sb.toString())){
    			sb.append(" or ");
    		}else{
    			sb.append(" ");
    		}
    		sb.append(field);
    		sb.append(" in (:");
    		sb.append(arg).append(") ");
    		params.put(arg, li);
    	}else if(Strings.isNotEmpty(li) && li.size() >= 1000){
    		List<Long> li1 = li.subList(0, 999);
    		this.getHqlByRecursion(li1, argPrefix,field, sb, params, index++);
    		List<Long> li2 = li.subList(999,li.size());
    		this.getHqlByRecursion(li2, argPrefix,field, sb, params, index++);
    	}
    	
    	return sb.toString();
    }

    public List<CtpCustomize> getUserCustomize(Long memberId)throws BusinessException {
    	if (memberId == null) {
            return null;
        }
    	StringBuffer hql = new StringBuffer("select cctm from CtpCustomize cctm where cctm.userId = :memberId and cctm.ckey = 'space_order'");
    	Map params = new HashMap();
    	params.put("memberId", memberId);
    	List<CtpCustomize> list = DBAgent.find(hql.toString(),params);
    	if (!list.isEmpty()) {
			String space_sort = (String)list.get(0).getCvalue();
			Map map = JSONUtil.parseJSONString(space_sort,Map.class);
		}
    	return list;
    }

    @SuppressWarnings("unchecked")
    public List<CtpCustomize> getSpaceOrderCustomize()throws BusinessException {
    	return customizeManager.getCustomizeByKey("space_order");
/*        StringBuffer hql = new StringBuffer("select cctm from CtpCustomize cctm where cctm.ckey = 'space_order'");
        List<CtpCustomize> list = DBAgent.find(hql.toString());
        return list;*/
    }

    /**
     * 我是主管的部门
     *
     * @param memberId
     * @return
     * @throws BusinessException
     */
    private List<Long> getDeptsByManager(Long memberId, Long accountId) throws BusinessException {
        List<Long> departmentIds = new ArrayList<Long>();

        List<V3xOrgDepartment> dm = this.orgManager.getDeptsByManager(memberId, accountId);
        if (dm != null && !dm.isEmpty()) {
            for (V3xOrgDepartment department : dm) {
                departmentIds.add(department.getId());
            }
        }

        return departmentIds;
    }

    @Override
    public void updateProperty(Long entityId, Map<String, String> properties, String tabIndex, Long editKeyId,
            Long memberId) throws CloneNotSupportedException {
        Map<String, String> portletProperties = this.portletEntityPropertyManager.getPropertys(entityId);
        Set<String> keys = portletProperties.keySet();
        List<String> removeKeys = new ArrayList<String>();
        for (String key : keys) {
            if (key.endsWith(":" + tabIndex)) {
                removeKeys.add(key);
            }
        }
        
//        for (Map.Entry<String, String> entry : portletProperties.entrySet()) {  
//	       	 if (entry.getKey().endsWith(":" + tabIndex)&& entry.getValue().equals("A___30")||
//	       			("panel:0".equals(entry.getKey())&& "Policy".equals(entry.getValue()))) {
//	       		 continue;
//	       	 }else{
//	       		removeKeys.add(entry.getKey());
//	       	 }
//        } 
        for (String key : removeKeys) {
            portletProperties.remove(key);
        }
        Set<Map.Entry<String, String>> entitis = properties.entrySet();
        for (Map.Entry<String, String> entry : entitis) {
            if (java.util.regex.Pattern.matches(PortletPropertyContants.PropertyName_No_Save_Pattern, entry.getKey())) {
                continue;
            }
            if("panel:0".equals(entry.getKey())&& StringUtils.isBlank(entry.getValue())){
            	continue;
            }
            portletProperties.put(entry.getKey(), entry.getValue());
        }
        portalCacheManager.putPortletcache(entityId, (HashMap<String, String>) portletProperties);
    }

    @Override
    public void addEditKeyCache(Long editKeyId, String pagePath, Long memberId) {
        this.pageManager.addEditKeyCache(editKeyId, pagePath, memberId);

    }

    @Override
    public void removeEditKeyCache(Long memberId) {
        this.pageManager.removeEditKeyCache(memberId);
    }

    @Override
    public Map<String, Map<String, PortalPagePortlet>> getFragments(String pagePath) throws BusinessException {
        // TODO Auto-generated method stub
        return this.pageManager.getFragments(pagePath);
    }

    @Override
    public Map<String, Map<String, PortalPagePortlet>> getFragments(String pagePath, Long editKeyId, Long memberId)
            throws BusinessException {
        return this.pageManager.getFragments(pagePath, editKeyId, memberId);
    }

    /**
     * 空间推送逻辑(V5.6 领导空间推送，替换预制个人空间或外部人员空间)
     * @param space 被推送的空间
     * @param members 推送范围
     * @param accountId 推送单位
     * @throws BusinessException
     */
    @SuppressWarnings("unchecked")
    public void pushLeaderSpace(PortalSpaceFix space, List<V3xOrgMember> members, Long accountId) throws BusinessException{
        Long spaceId = space.getId();
        if(spaceId==null||accountId==null){
            return;
        }
        if(CollectionUtils.isEmpty(members)){
            return;
        }
        Locale locale = AppContext.getCurrentUser().getLocale();
        List<Long> memberIds = new ArrayList<Long>();
        for(V3xOrgMember member:members){
            memberIds.add(member.getId());
        }
        Map<Long, CtpCustomize> customizeInfo = this.getSpaceSortByMemberId(memberIds, accountId);
        //待新建的用户个性化信息队列
        List<CtpCustomize> saveCustomizes = new ArrayList<CtpCustomize>();
        //待更新的用户个性化信息队列
        List<CtpCustomize> updateCustomizes = new ArrayList<CtpCustomize>();
        Date now = DateUtil.currentDate();
        for(V3xOrgMember member : members){
            Long memberId = member.getId();
            //是否内部人员
            boolean isInternal = member.getIsInternal();
            //获取该user的space_order对应的CtpCustomize
            CtpCustomize ctpCustomizeForUserSpaceOrder = customizeInfo.get(memberId);
            Map<String, LinkedHashMap<String,Map<String,Object>>> cvalueMap = null;
            if(ctpCustomizeForUserSpaceOrder == null){
                //如果该user没有自定义过排序
                ctpCustomizeForUserSpaceOrder = new CtpCustomize();
                ctpCustomizeForUserSpaceOrder.setIdIfNew();
                ctpCustomizeForUserSpaceOrder.setCkey(CustomizeConstants.SPACE_ORDER);
                ctpCustomizeForUserSpaceOrder.setUserId(memberId);
                ctpCustomizeForUserSpaceOrder.setCreateDate(now);
                ctpCustomizeForUserSpaceOrder.setUpdateDate(now);
                cvalueMap = new HashMap<String, LinkedHashMap<String,Map<String,Object>>>();
            } else {
            	Map map = JSON.parseObject(ctpCustomizeForUserSpaceOrder.getCvalue(),new TypeReference<Map<String, LinkedHashMap>>() {});
            	cvalueMap=map;//不这么转一下报错- -!
            }
            //获取所有有权限访问的空间结果集并按照sortId排序
            LinkedList<String[]> spaceList = (LinkedList<String[]>)this.getAllAccessedSpace(memberId, accountId, locale, false, null);
            //已选空间里是否含有默认个人空间或默认外部人员空间
            boolean hasPersonalSpace = false;
            //找到的默认个人空间或默认外部人员空间
            String[] personalSpace = null;
            Map<String, Map<String,Object>> spaceSortEntrys = new LinkedHashMap<String, Map<String,Object>>();
            int customizeSortSize = cvalueMap.size();
            if(customizeSortSize > 0){
                //如果用户自定义过空间导航排序，则先做一个merge重排
                Map<String, String[]> spaceListMap = new LinkedHashMap<String, String[]>();
                for(String[] spaceTmp : spaceList){
                	if(spaceTmp[1] == null){
                        spaceListMap.put(spaceTmp[0], spaceTmp);
                	} else {
                		spaceListMap.put(spaceTmp[1], spaceTmp);
                	}
                }
                spaceList.clear();
                Map<String, Map<String, Object>> currentSpaceMap = (Map<String, Map<String, Object>>) cvalueMap.get(String.valueOf(accountId));
                if(currentSpaceMap != null && currentSpaceMap.size() > 0){
                    Iterator<Map<String, Object>> itr = currentSpaceMap.values().iterator();
                    while(itr.hasNext()){
                        Map<String, Object> spaceEntry = itr.next();
                        String spaceTmpIdForCustomize = (String) spaceEntry.get(CustomizeConstants.SPACE_ID);
                        String isUnSelectedForCustomize = spaceEntry.get(CustomizeConstants.SPACE_ISDELETED).toString();
                        String[] spaceTmp = spaceListMap.get(spaceTmpIdForCustomize);
                        if(spaceTmp != null){
                            //把已选|备选存入spaceTmp[4]，后续要用
                            spaceTmp[4] = isUnSelectedForCustomize;
                            spaceList.add(spaceTmp);
                            spaceListMap.remove(spaceTmpIdForCustomize);
                        }
                    }
                }
                Collection<String[]> leftSpaces = spaceListMap.values();
                if(leftSpaces != null && leftSpaces.size() > 0){
                    spaceList.addAll(leftSpaces);
                }
            }
            Iterator<String[]> itr = spaceList.iterator();
            while(itr.hasNext()){
                String[] spaceTmp = itr.next();
                if(customizeSortSize == 0){
                    //如果没有自定义空间导航排序,把该space设置为已选择状态，0:已选择，1:未选择
                    spaceTmp[4] = "0";
                }
                int spaceType = Integer.valueOf(spaceTmp[6]);
                if(spaceType == Constants.SpaceType.default_leader.ordinal() || spaceType == Constants.SpaceType.leader.ordinal()){
                	spaceTmp[4] = "0";
                	continue;
                }
                if(isInternal){
                    //如果不是外部人员，则用领导空间替换已选的默认个人空间
                    if((spaceType == Constants.SpaceType.Default_personal.ordinal() || spaceType == Constants.SpaceType.personal.ordinal()) && "0".equals(spaceTmp[4])){
                        hasPersonalSpace = true;
                        personalSpace = spaceTmp.clone();
                        spaceTmp[0] = spaceId.toString();
                        spaceTmp[1] = null;
                        spaceTmp[6] = space.getType().toString();
                    }
                } else {
                    //如果是外部人员，则用领导空间替换已选的默认外部人员空间
                    if((spaceType == Constants.SpaceType.Default_out_personal.ordinal() || spaceType == Constants.SpaceType.outer.ordinal()) && "0".equals(spaceTmp[4])){
                        hasPersonalSpace = true;
                        personalSpace = spaceTmp.clone();
                        spaceTmp[0] = spaceId.toString();
                        spaceTmp[1] = null;
                        spaceTmp[6] = space.getType().toString();
                    }
                }
            }
            if(hasPersonalSpace){
                //已选空间里含有默认个人空间或默认外部人员空间，则放入备选
                Map<String, Object> personalSpaceEntry = new HashMap<String,Object>();
                if(personalSpace[1] == null){
                    personalSpaceEntry.put(CustomizeConstants.SPACE_ID, personalSpace[0]);
                } else {
                    personalSpaceEntry.put(CustomizeConstants.SPACE_ID, personalSpace[1]);
                }
                personalSpaceEntry.put(CustomizeConstants.SPACE_ISDELETED, 1);
                personalSpaceEntry.put(CustomizeConstants.SPACE_TYPE, personalSpace[6]);
                personalSpaceEntry.put(CustomizeConstants.SPACE_SORT, 1);
                spaceSortEntrys.put("1", personalSpaceEntry);
                int beginSortId = 2;
                for(String[] spaceTmp : spaceList){
                    Map<String,Object> entry = new HashMap<String,Object>();
                    if(spaceTmp[1] == null){
                        entry.put(CustomizeConstants.SPACE_ID, spaceTmp[0]);
                    } else {
                        entry.put(CustomizeConstants.SPACE_ID, spaceTmp[1]);
                    }
                    entry.put(CustomizeConstants.SPACE_ISDELETED, Integer.valueOf(spaceTmp[4]));
                    entry.put(CustomizeConstants.SPACE_TYPE, spaceTmp[6]);
                    entry.put(CustomizeConstants.SPACE_SORT, String.valueOf(beginSortId));
                    spaceSortEntrys.put(String.valueOf(beginSortId), entry);
                    beginSortId++;
                }
            } else {
            	int beginSortId = 1;
                for(String[] spaceTmp : spaceList){
                    Map<String,Object> entry = new HashMap<String,Object>();
                    if(spaceTmp[1] == null){
                        entry.put(CustomizeConstants.SPACE_ID, spaceTmp[0]);
                    } else {
                        entry.put(CustomizeConstants.SPACE_ID, spaceTmp[1]);
                    }
                    entry.put(CustomizeConstants.SPACE_ISDELETED, Integer.valueOf(spaceTmp[4]));
                    entry.put(CustomizeConstants.SPACE_TYPE, spaceTmp[6]);
                    entry.put(CustomizeConstants.SPACE_SORT, String.valueOf(beginSortId));
                    spaceSortEntrys.put(String.valueOf(beginSortId), entry);
                    beginSortId++;
                }
            }
            cvalueMap.put(String.valueOf(accountId), (LinkedHashMap<String, Map<String, Object>>) spaceSortEntrys);
            ctpCustomizeForUserSpaceOrder.setCvalue(JSONUtil.toJSONString(cvalueMap));
            if(customizeSortSize == 0){
                saveCustomizes.add(ctpCustomizeForUserSpaceOrder);
            } else {
                updateCustomizes.add(ctpCustomizeForUserSpaceOrder);
            }
        }
        if(!CollectionUtils.isEmpty(saveCustomizes)){
            customizeManager.saveAllCustomizeInfo(saveCustomizes);
        }
        if(!CollectionUtils.isEmpty(updateCustomizes)){
            customizeManager.updateAllCustomizeInfo(updateCustomizes);
        }
    }

    /**
     * 空间推送逻辑
     * @param space 被推送的空间
     * @param members 推送范围
     * @param accountId 推送单位
     * @throws BusinessException
     */
    public void updateSpaceSortForPersonalCustom(PortalSpaceFix space, List<Long> memberIds,Long accountId) throws BusinessException{
        Long spaceId = space.getId();
        if(spaceId==null||accountId==null){
            return;
        }
        if(CollectionUtils.isEmpty(memberIds)){
            return;
        }
        Locale locale = AppContext.getCurrentUser().getLocale();
        Map<Long,CtpCustomize> customizeInfo = this.getSpaceSortByMemberId(memberIds, accountId);
        //待新建的用户个性化信息队列
        List<CtpCustomize> saveCustomizes = new ArrayList<CtpCustomize>();
        //待更新的用户个性化信息队列
        List<CtpCustomize> updateCustomizes = new ArrayList<CtpCustomize>();

        for(Long memberId : memberIds){
            Map<String,Object> sort = new HashMap<String,Object>();
            sort.put(CustomizeConstants.SPACE_ID, spaceId);
            sort.put(CustomizeConstants.SPACE_ISDELETED, 0);
            sort.put(CustomizeConstants.SPACE_TYPE, space.getType());
            sort.put(CustomizeConstants.SPACE_SORT, 1);

            CtpCustomize ctpCustomize = customizeInfo.get(memberId);
            Map<String,Map<String,Map<String,Object>>> cvalueMap = null;
            if(ctpCustomize != null){
                cvalueMap = (Map<String,Map<String,Map<String,Object>>>)JSONUtil.parseJSONString(ctpCustomize.getCvalue());
                if(cvalueMap == null){
                    cvalueMap = new HashMap<String, Map<String,Map<String,Object>>>();
                }
            } else {
                cvalueMap = new HashMap<String, Map<String,Map<String,Object>>>();
            }
            Map<String,Map<String,Object>> accountSpaceSort = null;
            if(ctpCustomize == null || (ctpCustomize != null && cvalueMap.size() == 0)){
                accountSpaceSort = new LinkedHashMap<String, Map<String,Object>>();
                List<String[]> spaceSortList = this.getSpaceSort(memberId, accountId, locale, false, null);
                for(int i = 0; i < spaceSortList.size(); i++){
                    String[] spaceSort = spaceSortList.get(i);
                    Map<String,Object> sortMap = new HashMap<String,Object>();
                    sortMap.put(CustomizeConstants.SPACE_ID, spaceSort[0]);
                    sortMap.put(CustomizeConstants.SPACE_ISDELETED, 0);
                    sortMap.put(CustomizeConstants.SPACE_TYPE, spaceSort[6]);
                    sortMap.put(CustomizeConstants.SPACE_SORT, String.valueOf((i + 1)));
                    accountSpaceSort.put(String.valueOf((i + 1)), sortMap);
                }
                cvalueMap.put(String.valueOf(accountId), accountSpaceSort);
                String cvalue = JSONUtil.toJSONString(cvalueMap);
                ctpCustomize = new CtpCustomize();
                ctpCustomize.setIdIfNew();
                ctpCustomize.setCkey(CustomizeConstants.SPACE_ORDER);
                ctpCustomize.setCvalue(cvalue);
                ctpCustomize.setUserId(memberId);
                ctpCustomize.setCreateDate(DateUtil.currentDate());
                ctpCustomize.setUpdateDate(DateUtil.currentDate());
                saveCustomizes.add(ctpCustomize);
            }
            accountSpaceSort = cvalueMap.get(String.valueOf(accountId));
            if(accountSpaceSort==null || accountSpaceSort.size() == 0){
                accountSpaceSort = new LinkedHashMap<String, Map<String,Object>>();
                accountSpaceSort.put(String.valueOf(1), sort);
                cvalueMap.put(String.valueOf(accountId), accountSpaceSort);
                String cvalue = JSONUtil.toJSONString(cvalueMap);
                ctpCustomize.setCvalue(cvalue);
                ctpCustomize.setUpdateDate(DateUtil.currentDate());
                updateCustomizes.add(ctpCustomize);
            } else {
                Map<String,Object> firstSort = accountSpaceSort.get(String.valueOf(1));
                Map<String, Object> currentSpaceSort = null;
                for(Map<String, Object> tmpSort : accountSpaceSort.values()){
                    if(tmpSort.get(CustomizeConstants.SPACE_ID).equals(String.valueOf(spaceId))){
                        currentSpaceSort = tmpSort;
                        break;
                    }
                }
                if(currentSpaceSort == null){
                    //把排第1的空间移到最后，置为删除状态，放入备选里
                    Integer lastSortId = accountSpaceSort.size() + 1;
                    firstSort.put(CustomizeConstants.SPACE_SORT, String.valueOf(lastSortId));
                    firstSort.put(CustomizeConstants.SPACE_ISDELETED, 1);
                    accountSpaceSort.put(String.valueOf(lastSortId), firstSort);
                    accountSpaceSort.put(String.valueOf(1), sort);
                } else {
                    String currentSort = currentSpaceSort.get(CustomizeConstants.SPACE_SORT).toString();
                    if("1".equals(currentSort)){
                        currentSpaceSort.put(CustomizeConstants.SPACE_ISDELETED, 0);
                    } else {
                        //把排第1的空间移到最后，置为删除状态，放入备选里
                        Integer lastSortId = accountSpaceSort.size();
                        firstSort.put(CustomizeConstants.SPACE_SORT, String.valueOf(lastSortId));
                        firstSort.put(CustomizeConstants.SPACE_ISDELETED, 1);
                        accountSpaceSort.remove("1");
                        accountSpaceSort.remove(currentSort);
                        Map<String, Map<String,Object>> accountSpaceSortNew = new LinkedHashMap<String, Map<String,Object>>();
                        currentSpaceSort.put(CustomizeConstants.SPACE_ISDELETED, 0);
                        currentSpaceSort.put(CustomizeConstants.SPACE_SORT, "1");
                        accountSpaceSortNew.put(String.valueOf(1), currentSpaceSort);
                        for(Map<String, Object> tmpSort : accountSpaceSort.values()){
                            String tmpSpaceSort = (String) tmpSort.get(CustomizeConstants.SPACE_SORT);
                            if(Integer.valueOf(tmpSpaceSort).intValue() > Integer.valueOf(currentSort).intValue()){
                                tmpSpaceSort = String.valueOf(Integer.valueOf(tmpSpaceSort) - 1);
                                tmpSort.put(CustomizeConstants.SPACE_SORT, tmpSpaceSort);
                            }
                            accountSpaceSortNew.put(String.valueOf(tmpSpaceSort), tmpSort);
                        }
                        accountSpaceSortNew.put(String.valueOf(lastSortId), firstSort);
                        accountSpaceSort = accountSpaceSortNew;
                    }
                }
                cvalueMap.put(String.valueOf(accountId), accountSpaceSort);
                String cvalue = JSONUtil.toJSONString(cvalueMap);
                ctpCustomize.setCvalue(cvalue);
                ctpCustomize.setUpdateDate(DateUtil.currentDate());
                updateCustomizes.add(ctpCustomize);
            }
        }
        if(!CollectionUtils.isEmpty(saveCustomizes)){
            customizeManager.saveAllCustomizeInfo(saveCustomizes);
        }
        if(!CollectionUtils.isEmpty(updateCustomizes)){
            customizeManager.updateAllCustomizeInfo(updateCustomizes);
        }

    }
    /**
     * 获取用户在当前单位的空间排序信息
     * @param memberIds 用户ID列表
     * @param accountId 当前单位ID
     * @return Map<用户ID,Map<单位ID,Map<排序号,Map<String,Object>>>>
     * @throws BusinessException
     */
    public Map<Long,CtpCustomize> getSpaceSortByMemberId(List<Long> memberIds,Long accountId) throws BusinessException{
        List<CtpCustomize> resultList = new ArrayList<CtpCustomize>();
        if(Strings.isNotEmpty(memberIds)){
            List<Long>[] arrSplited = Strings.splitList(memberIds, 1000);
            for(List<Long> idList : arrSplited){
                resultList.addAll(customizeManager.getCustomizeInfo(idList, CustomizeConstants.SPACE_ORDER));
            }
        }
        Map<Long,CtpCustomize> customizeInfo = new HashMap<Long,CtpCustomize>();
        for(CtpCustomize customize : resultList){
            if(customize!=null){
                customizeInfo.put(customize.getUserId(), customize);
            }
           /* String value = customize.getCvalue();
            if(Strings.isBlank(value)){
                continue;
            }*/
        }
        return customizeInfo;
    }

    @Override
	public List<String[]> getUnselectSpace(Long memberId, Long accountId,Locale userLocale, List<PortalSpaceFix> accessSpaces) throws BusinessException {
        if (CollectionUtils.isEmpty(accessSpaces)) {
            accessSpaces = this.getAccessSpace(memberId, accountId);
        }
        List<String[]> accessSpaceSort = this.getAccessSpaceSort(memberId, accountId, userLocale, false, accessSpaces);

        List<String> needDeleteData = getDisplayProjectOrSpaceIds();
        /*//关联系统
        List<PortalLinkSpace> linkSpaces = linkSpaceManager.findLinkSpacesCanAccess(memberId);
        if (CollectionUtils.isNotEmpty(linkSpaces)) {
            for (PortalLinkSpace pls : linkSpaces) {
                String[] objStr = {String.valueOf(pls.getId()),null,"/seeyon/portal/linkSystemController.do?method=linkConnect&linkId=" + pls.getLinkSystemId(),pls.getSpaceName(),
                        String.valueOf(SpaceState.normal.ordinal()),null,String.valueOf(SpaceType.related_system.ordinal()), pls.getOpenType() == 1l?"1":"2", "menu_linksystem.png"};
                if (needDeleteData.contains(String.valueOf(pls.getId()))) {
                	accessSpaceSort.add(objStr);
                }
            }
        }
        //关联项目
        //备选关联项目：当前用户可访问的所有已启用、进行中的项目
        if(projectManager!=null){
            List<ProjectSummary> relatedProjects = projectManager.getIndexProjectListOnly(memberId, -1);
            if (CollectionUtils.isNotEmpty(relatedProjects)) {
                for (ProjectSummary rpj : relatedProjects) {
                    String[] objStr = {String.valueOf(rpj.getId()),null, "/project.do?method=projectInfo&projectId=" + rpj.getId(),rpj.getProjectName(),
                            String.valueOf(SpaceState.normal.ordinal()),null,String.valueOf(SpaceType.related_project.ordinal()), "2","menu_relateproject.png"};
                    if (needDeleteData.contains(String.valueOf(String.valueOf(rpj.getId())))) {
                    	accessSpaceSort.add(objStr);
                    }
                }
            }
        }*/


        // 集成第三方系统
        List<ThirdpartySpace> thirdpartySpaces = ThirdpartySpaceManager.getInstance().getAccessSpaces(orgManager, memberId);
        if (CollectionUtils.isNotEmpty(thirdpartySpaces)) {
            int type = Constants.SpaceType.thirdparty.ordinal();
            for (ThirdpartySpace thirdParty : thirdpartySpaces) {
                    String pageUrl = thirdParty.getPageURL(memberId, accountId);
                    String[] s = { thirdParty.getId(), null, "/thirdpartyController.do?method=show&id="+thirdParty.getId()+"&pageUrl="+pageUrl,thirdParty.getNameOfResouceBundle(userLocale),String.valueOf(SpaceState.normal.ordinal()),null,String.valueOf(type), "2","menu_thridpartyspace.png"};
                    if (!needDeleteData.contains(String.valueOf(thirdParty.getId()))) {
                    	accessSpaceSort.add(s);
                    }
            }
        }

        User user = AppContext.getCurrentUser();

        List<String[]> selectedList = this.getSpaceSort(memberId, accountId, user.getLocale(), false, accessSpaces);
        List<String> selectedIds = new ArrayList<String>();
        for(String[] s : selectedList){
            selectedIds.add(s[0]);
        }
        List<String[]> unselectSpace = new ArrayList<String[]>();
        for(String[] space : accessSpaceSort){
            if(!selectedIds.contains(space[0])){
                unselectSpace.add(space);
            }
        }

        return unselectSpace;
    }

    /**
     * 设置用户是否调整过空间导航排序
     */
    private void setSpaceNavReSortState(String isReSort, Long userId, Long accountId){
    	if("1".equals(isReSort)){

//    		String hql = "from CtpCustomize cctm where cctm.ckey = :ckey and userId = :userId";
//            Map<String, Object> params = new HashMap<String, Object>();
//            params.put("ckey", CustomizeConstants.SPACE_IS_RESORT + "_" + accountId.toString());
//            params.put("userId", userId);
//            List<CtpCustomize> list = DBAgent.find(hql, params);
            CtpCustomize cc = customizeManager.getCustomizeInfo(userId, CustomizeConstants.SPACE_IS_RESORT + "_" + accountId.toString());
//            if(list != null && list.size() > 0){
            if(cc!=null) {
//            	cc = list.get(0);
            	cc.setCvalue(isReSort);
            	customizeManager.updateCustomize(cc);
            } else {
            	Date now = new Date();
        		cc = new CtpCustomize();
        		cc.setIdIfNew();
        		cc.setCkey(CustomizeConstants.SPACE_IS_RESORT + "_" + accountId.toString());
        		cc.setUserId(userId);
        		cc.setCreateDate(now);
        		cc.setUpdateDate(now);
            	cc.setCvalue(isReSort);
            	customizeManager.saveCustomize(cc);
            }
    	}
    }

    @Override
    public void saveSpaceSort(Map params) throws BusinessException {
        User user = AppContext.getCurrentUser();
        Long memberId = user.getId();
        Long accountId = user.getLoginAccount();
        String spaceSourceSelectInput = (String)params.get("spaceSourceSelectInput");
        String systemSourceSelectInput = (String)params.get("systemSourceSelectInput");
        String projectSourceSelectInput = (String)params.get("projectSourceSelectInput");
        String spaceTargetSelectInput = (String)params.get("spaceTargetSelectInput");
        String isReSort = (String)params.get("isReSort");
        setSpaceNavReSortState(isReSort, memberId, accountId);

        List<String> systemSpaceIds = JSONUtil.parseJSONString(systemSourceSelectInput, List.class);
        List<String> projectSpaceIds = JSONUtil.parseJSONString(projectSourceSelectInput, List.class);
        List<String> unSelectedSpaceIds = JSONUtil.parseJSONString(spaceSourceSelectInput, List.class);
        unSelectedSpaceIds.addAll(systemSpaceIds);
        unSelectedSpaceIds.addAll(projectSpaceIds);
        List<String> selectedSpaceIds = JSONUtil.parseJSONString(spaceTargetSelectInput,List.class);

        if(memberId==null||accountId==null){
            return;
        }
        /**
         * 构造空间排序数据
         */
        Map<Integer,Map<String,Object>> saveSort = new LinkedHashMap<Integer,Map<String,Object>>();
        if(!CollectionUtils.isEmpty(selectedSpaceIds)){
            for(int i=0; i< selectedSpaceIds.size(); i++){
                String selectedSpaceStr = selectedSpaceIds.get(i);
                String selectedSpaceId = selectedSpaceStr.split(",")[1];
                String selectedSpaceType = selectedSpaceStr.split(",")[0];
                Map<String,Object> sort = new HashMap<String,Object>();
                sort.put(CustomizeConstants.SPACE_ID, selectedSpaceId);
                sort.put(CustomizeConstants.SPACE_ISDELETED, 0);
                sort.put(CustomizeConstants.SPACE_SORT, i+1);
                sort.put("space_type", selectedSpaceType);
                saveSort.put(i+1, sort);
            }
        }
        if(!CollectionUtils.isEmpty(unSelectedSpaceIds)){
            int k = selectedSpaceIds.size();
            for(int j=0; j< unSelectedSpaceIds.size(); j++){
                String unSelectedSpaceStr = unSelectedSpaceIds.get(j);
                String unSelectedSpaceId = unSelectedSpaceStr.split(",")[1];
                String unSelectedSpaceType = unSelectedSpaceStr.split(",")[0];
                Map<String,Object> sort = new HashMap<String,Object>();
                sort.put(CustomizeConstants.SPACE_ID, unSelectedSpaceId);
                sort.put(CustomizeConstants.SPACE_ISDELETED, 1);
                sort.put(CustomizeConstants.SPACE_SORT, j+k+1);
                sort.put("space_type", unSelectedSpaceType);
                saveSort.put(j+k+1, sort);
            }
        }

        List<Long> memberIds = new ArrayList<Long>();
        memberIds.add(memberId);
        Map<Long,CtpCustomize> customizeInfo = this.getSpaceSortByMemberId(memberIds, accountId);

        CtpCustomize ctpcustomize = customizeInfo.get(memberId);

        if(ctpcustomize==null){
            Map<String,Map<Integer,Map<String,Object>>> customize = new HashMap<String, Map<Integer,Map<String,Object>>>();
            customize.put(String.valueOf(accountId), saveSort);
            String cvalue = JSONUtil.toJSONString(customize);
            UserCustomizeCache.setCustomize(CustomizeConstants.SPACE_ORDER, cvalue);
        }else{
            Map<String,Map<Integer,Map<String,Object>>> customize = (Map<String,Map<Integer,Map<String,Object>>>)JSONUtil.parseJSONString(ctpcustomize.getCvalue());
            if(customize == null){
                customize = new HashMap<String, Map<Integer,Map<String,Object>>>();
            }
            customize.put(String.valueOf(accountId), saveSort);
            String cvalue = JSONUtil.toJSONString(customize);
            UserCustomizeCache.setCustomize(CustomizeConstants.SPACE_ORDER, cvalue);
        }
        //刷新用户控件列表缓存
        List<String[]> spaces = this.getSpaceSort(user.getId(), user.getLoginAccount(), user.getLocale(), false, null);
        if (spaces != null) {
        	 UserHelper.setSpaces(spaces);
        }
    }

    @Override
    @Deprecated
    public List<MenuBO> getMenusOfMember(User user) throws BusinessException {
      
        return portalMenuManager.getMenusOfMember(user);
    }

    @Override
    public List<MenuBO> getCustomizeMenusOfMember(User user,List<MenuBO> menus) throws BusinessException {
       
        return portalMenuManager.getCustomizeMenusOfMember(user,menus,false);
    }

    @Override
    public List<MenuBO> getUnselectedMenusOfMember(User user, List<MenuBO> allMenus, List<MenuBO> customizeMenus)
            throws BusinessException {   
        return portalMenuManager.getUnselectedMenusOfMember(user, allMenus, customizeMenus);
    }

    @Override
    public void saveMenuSort(String selectedMenusString) throws BusinessException {
    	portalMenuManager.saveMenuSort(selectedMenusString);
    }

    @Override
    public PortalSpaceFix transCreatePersonalDefineSpace(Long memberId,Long accountId, Long spaceId) throws BusinessException {
        PortalSpaceFix spaceFix = spaceDao.getSpaceFixById(spaceId);
        if(spaceFix==null){
            return null;
        }
        if(spaceFix.getParentId()!=null){
            return spaceFix;
        }
        List<PortalSpaceFix> spaces = this.spaceDao.getSpacesByParentId(spaceId);
        if(CollectionUtils.isNotEmpty(spaces)){
            for(PortalSpaceFix space : spaces){
                if(memberId.equals(space.getEntityId())){
                    return space;
                }
            }
        }
        String pagePath = spaceFix.getPath();
        Long uuid = UUIDLong.longUUID();
        SpaceType type = EnumUtil.getEnumByOrdinal(SpaceType.class, spaceFix.getType());

        //个性化空间前缀
        String folderPath = Constants.getCustomPagePath(type);
        //个性化空间类型
        SpaceType customedType = Constants.parseDefaultSpaceType(type);

        //String spaceName = Constants.getDefaultSpaceName(type);

        String personalPath = folderPath+uuid+Constants.DOCUMENT_TYPE;
        this.copyPage(pagePath, personalPath);
        PortalSpaceFix newSpaceFix = new PortalSpaceFix();
        newSpaceFix.setId(uuid);
        newSpaceFix.setAccountId(spaceFix.getAccountId());
        newSpaceFix.setDefaultspace(0);
        newSpaceFix.setEntityId(memberId);
        newSpaceFix.setExtAttributes(spaceFix.getExtAttributes());
        newSpaceFix.setParentId(spaceId);
        newSpaceFix.setPath(personalPath);
        newSpaceFix.setSortId(spaceFix.getSortId());
        newSpaceFix.setSpaceMenuEnable(spaceFix.getSpaceMenuEnable());
        newSpaceFix.setSpacePubinfoEnable(spaceFix.getSpacePubinfoEnable());
        newSpaceFix.setSpacename(spaceFix.getSpacename());
        newSpaceFix.setState(spaceFix.getState());
        newSpaceFix.setType(customedType.ordinal());
        newSpaceFix.setUpdateTime(DateUtil.currentDate());
        newSpaceFix.setSpaceIcon(spaceFix.getSpaceIcon());//20161014创建个性化个人空间时要把父空间的spaceicon弄过来
        
        putPageFixToCache(newSpaceFix);
        DBAgent.save(newSpaceFix);

        PortalSpaceSecurity security = new PortalSpaceSecurity();
        security.setIdIfNew();
        security.setSpaceId(newSpaceFix.getId());
        security.setEntityType(V3xOrgEntity.ORGENT_TYPE_MEMBER);
        security.setEntityId(memberId);
        security.setSecurityType(1);
        
        DBAgent.save(security);

        return newSpaceFix;
    }
    private PortalSpacePage copyPage(String srcPagePath, String destPagePath)
            throws BusinessException {
        try {
            PortalSpacePage page = pageManager.getPage(destPagePath);
            if (page != null) {
                return page;
            }
        } catch (Exception e1) {
            log.error(e1.getMessage(), e1);
        }

        PortalSpacePage template = pageManager.getPage(srcPagePath);
        PortalSpacePage copy = pageManager.transCopyPage(srcPagePath, destPagePath);
        if(template == null){
        	throw new BusinessException("拷贝空间模版数据出错,template为空,srcPagePath:" + srcPagePath);
        }
        PortalPagePortlet templateRoot = (PortalPagePortlet)template.getExtraAttr("RootPagePortlet");
        List<PortalPagePortlet> templateFragments = (List<PortalPagePortlet>) templateRoot.getExtraAttr("ChildrenPortlets");

        PortalPagePortlet copyRoot = (PortalPagePortlet)copy.getExtraAttr("RootPagePortlet");
        List<PortalPagePortlet> copyFragments = (List<PortalPagePortlet>) copyRoot.getExtraAttr("ChildrenPortlets");

        for (int i = 0; i < templateFragments.size(); i++) {
            PortalPagePortlet templateFragment = templateFragments.get(i);
            PortalPagePortlet copyFragment = copyFragments.get(i);

            this.portletEntityPropertyManager.transCopyPropertys(templateFragment.getId(), copyFragment.getId());
        }
            return copy;
    }

    @Override
    public PortalSpaceFix getSpaceFix(Long spaceId) {
    	return portalCacheManager.getPageFixIdCacheByKey(spaceId);
        //return DBAgent.get(PortalSpaceFix.class, spaceId);
    }

    @Override
    public void saveSpaceMenu(Long spaceId, List<Map<String,Object>> menus) {
    	portalMenuManager.saveSpaceMenu(spaceId, menus);
    }

    @Override
    public void deleteSpaceMenu(Long spaceId) {
       portalMenuManager.deleteSpaceMenu(spaceId);
    }

    @Override
    public List<MenuTreeNode> getSpaceMenuIds(Long spaceId) throws BusinessException {
        
        return portalMenuManager.getSpaceMenuIds(spaceId);
    }

    @Override
    public List<MenuTreeNode> getAllUseAbleMenus() throws BusinessException {
        return portalMenuManager.getAllUseAbleMenus();
    }

    @Override
    public boolean isCreateDepartmentSpace(Long departmentId) {
        String pagePath = Constants.DEPARTMENT_FOLDER + departmentId + Constants.DOCUMENT_TYPE;
        PortalSpaceFix spaceFix = this.getSpaceFix(pagePath);
        return spaceFix!=null&&Integer.valueOf(Constants.SpaceState.normal.ordinal()).equals(spaceFix.getState());
    }

    @Override
    public List<Long> getCanManagerSpace(Long memberId) throws BusinessException {
        List<Long> result = new ArrayList<Long>();
        List<PortalSpaceFix> list = this.getCanManagerSpaceByMemberId(memberId);
        if (list != null) {
            for (PortalSpaceFix fix : list) {
                if (fix.getState() == Constants.SpaceState.normal.ordinal()) {
                    result.add(fix.getId());
                    int type = fix.getType();
                    if (type == Constants.SpaceType.department.ordinal() || type == Constants.SpaceType.corporation.ordinal() || type == Constants.SpaceType.group.ordinal()) {
                        result.add(fix.getEntityId());
                    }
                }
            }
        }
        return result;
    }

    @Override
    public List<PortalSpaceFix> getCanManagerSpaceByMemberId(Long memberId) throws BusinessException{
        List<PortalSpaceFix> result = (List<PortalSpaceFix>)AppContext.getThreadContext("CanManagerSpaceByMemberId" + memberId);
        if(result != null){
            return result;
        }
        
        result = new ArrayList<PortalSpaceFix>();
        
        List<Long> departmentIds = this.getDeptsByManager(memberId);// 我是部门主管，可以管理部门空间
        if (CollectionUtils.isNotEmpty(departmentIds)) {
            for(Long departmentId : departmentIds){
                String deptPath = Constants.DEPARTMENT_FOLDER + departmentId + Constants.DOCUMENT_TYPE;
                PortalSpaceFix  fix = this.getSpaceFix(deptPath);
                if(fix!=null){
                    result.add(fix);
                }
            }
        }

        List<Long> domainIds = this.orgManager.getUserDomainIDs(memberId,
                V3xOrgEntity.ORGENT_TYPE_ACCOUNT, V3xOrgEntity.ORGENT_TYPE_DEPARTMENT,
                V3xOrgEntity.ORGENT_TYPE_POST, V3xOrgEntity.ORGENT_TYPE_LEVEL, V3xOrgEntity.ORGENT_TYPE_TEAM,
                V3xOrgEntity.ORGENT_TYPE_MEMBER);

        if (CollectionUtils.isNotEmpty(domainIds)) {
            StringBuffer hql = new StringBuffer();
            hql.append("select space from ");
            hql.append(PortalSpaceFix.class.getName()).append(" as space, ").append(PortalSpaceSecurity.class.getName()).append(" as security ");
            hql.append(" where space.id=security.spaceId ");
            hql.append(" and security.securityType=:securityType and space.type in (:spaceTypes) and security.entityId in (:mEntityIds)");

            Map<String, Object> nameParameters = new HashMap<String, Object>();
            nameParameters.put("securityType", Constants.SecurityType.manager.ordinal());
            /**
             * TODO:
             * 根据空间类型获取管理员
             */
            nameParameters.put("spaceTypes", new Integer[] {
                    Constants.SpaceType.department.ordinal(),
                    Constants.SpaceType.corporation.ordinal(),
                    Constants.SpaceType.group.ordinal(), Constants.SpaceType.custom.ordinal(),
                    Constants.SpaceType.public_custom.ordinal(),
                    Constants.SpaceType.public_custom_group.ordinal() });
            nameParameters.put("mEntityIds", domainIds);

            List<PortalSpaceFix> list = DBAgent.find(hql.toString(), nameParameters);
            if (list != null) {
            	for(PortalSpaceFix fix : list){
            		fix.setSpacename(ResourceUtil.getString(fix.getSpacename()));
            	}
                result.addAll(list);
            }
        }
        
        AppContext.putThreadContext("CanManagerSpaceByMemberId" + memberId, result);
        
        return result;
    }

    @Override
    public List<Object[]> getSecuityOfSpace(Long spaceId) {
        StringBuffer hql = new StringBuffer("");
        Map<String, Object> params = new HashMap<String, Object>();
        hql.append(" select sec.entityType, sec.entityId from "+ PortalSpaceFix.class.getName() + " as space, " + PortalSpaceSecurity.class.getName() + " as sec ");
        hql.append(" where (space.id=sec.spaceId) and (sec.spaceId=:spaceId) ");
        params.put("spaceId", spaceId);
        hql.append(" order by sec.sort ");

        List<Object[]> result = DBAgent.find(hql.toString(), params);
        List<Object[]> retResult = new ArrayList<Object[]>();
        Map checkDuplicateMap = new HashMap();
        for(Object[] data : result){
            if(checkDuplicateMap.containsKey(data[1].toString())){
                continue;
            } else {
                checkDuplicateMap.put(data[1].toString(), null);
                retResult.add(data);
            }
        }
        return retResult;
    }

    @Override
    public List<Object[]> getSecuityOfDepartment(Long departmentId) {
        return this.getSecuityOfDepartment(departmentId, -1);
    }

    @Override
    public List<V3xOrgMember> getSpaceMemberBySecurity(Long spaceId, int securityType) throws BusinessException {
        StringBuffer hql = new StringBuffer("");
        Set<V3xOrgMember> members = new HashSet<V3xOrgMember>();
        Map<String, Object> params = new HashMap<String, Object>();

        hql.append(" select sec.entityType,sec.entityId from " + PortalSpaceFix.class.getName() + " as space, " + PortalSpaceSecurity.class.getName() + " as sec");
        hql.append(" where (space.id=sec.spaceId) and (sec.spaceId=:spaceId) ");
        params.put("spaceId", spaceId);
        if (securityType != -1) {
            hql.append(" and (sec.securityType=:securityType) )");
            params.put("securityType", securityType);
        }
        hql.append(" order by sec.sort ");

        List<Object[]> result = DBAgent.find(hql.toString(),params);
        StringBuffer entityInfos = new StringBuffer();
        try {
            if(result != null && result.size() > 0) {
                for(Object[] arr : result) {
                    entityInfos.append(StringUtils.join(arr, "|") + ",");
                }
                members = this.orgManager.getMembersByTypeAndIds(entityInfos.substring(0, entityInfos.length() - 1));
            }
        } catch (BusinessException e) {
            log.error("获取空间访问权限类型为" + securityType + "的组织模型实体信息异常", e);
        }
        return new ArrayList<V3xOrgMember>(members);
    }

    @Override
    public List<Long> getSpaceAdminIdsOfDepartment(Long departmentId) {
        List<Object[]> typeAndIds = this
                .getSpaceAdminsOfDepartment(departmentId);
        List<Long> memeberIds = new ArrayList<Long>();
        if(CollectionUtils.isNotEmpty(typeAndIds)){
            for(Object[] obj : typeAndIds){
                memeberIds.add((Long)obj[1]);
            }
        }
        return memeberIds;
    }

    /**
     * 我是主管的部门
     *
     * @param memberId
     * @return
     */
    private List<Long> getDeptsByManager(Long memberId) {
        List<Long> departmentIds = new ArrayList<Long>();
        try {
            List<V3xOrgDepartment> dm = this.orgManager
                    .getDeptsByManager(memberId,AppContext.currentAccountId());
            if (dm != null && !dm.isEmpty()) {
                for (V3xOrgDepartment department : dm) {
                    departmentIds.add(department.getId());
                }
            }
        } catch (Exception e) {
            log.error(e.getMessage(), e);
        }

        return departmentIds;
    }

    @SuppressWarnings("unchecked")
    public List<Object[]> getSecuityOfDepartment(Long departmentId, int securityType) {
        StringBuffer hql = new StringBuffer("");
        Map<String, Object> params = new HashMap<String, Object>();
        hql.append(" select sec.entityType,sec.entityId from " + PortalSpaceFix.class.getName() + " as space, " + PortalSpaceSecurity.class.getName() + " as sec ");
        hql.append(" where (space.id=sec.spaceId) and (space.entityId=:departmentId) and (sec.entityId<>:departmentId) ");
        params.put("departmentId", departmentId);

        if (securityType != -1) {
            hql.append(" and (sec.securityType=:securityType) )");
            params.put("securityType", securityType);
        }

        hql.append(" order by sec.sort ");

        List<Object[]> result = DBAgent.find(hql.toString(), params);

        if (securityType != Constants.SecurityType.manager.ordinal()) {
            result.add(new Object[] { V3xOrgEntity.ORGENT_TYPE_DEPARTMENT, departmentId });
        }

        return result;
    }

    @Override
    public List<Object[]> getSpaceAdminsOfDepartment(Long departmentId) {
        return this.getSecuityOfDepartment(departmentId,
                Constants.SecurityType.manager.ordinal());
    }
    /**
     * 判断用户是否某一特定空间的空间管理员
     * @param memberId 当前用户ID
     * @param spaceId   当前空间ID
     * @return 是否为当前空间管理员
     * @throws BusinessException
     */
    @Override
    public boolean isManagerOfThisSpace(Long memberId, Long spaceId) throws BusinessException {
        List<Long> managerSpaces = getCanManagerSpace(memberId);
        return CollectionUtils.isNotEmpty(managerSpaces) && managerSpaces.contains(spaceId);
    }
    /**
     * 判断当前用户是否可编辑某一空间
     * @param spaceId   当前空间ID
     * @return 是否可编辑当前空间
     * @throws BusinessException 
     */
    @Override
    public boolean canEditThisSpace(Long spaceId) throws BusinessException {
    	User user = AppContext.getCurrentUser();
    	PortalSpaceFix fix=getSpaceFix(spaceId);
    	if(Constants.SpaceType.related_project_space.ordinal()==fix.getType().intValue()){
    		if(projectApi.isManager(user.getId(), fix.getEntityId())){
    			return true;
    		}
    	}
    	if(user.isGroupAdmin()||user.isAdministrator()){
    		//空间entityId和登录人的单位ID相等则判断这个人可以修改此空间
    		if((fix.getEntityId().longValue()==user.getAccountId().longValue())||(fix.getAccountId().longValue()==user.getAccountId().longValue())||isManagerOfThisSpace(user.getId(),spaceId))
    			return true;
    	}else{
    		//针对前端个性化后的个人空间,空间entity_id等于登录人的ID则判断这个人可以修改此空间
    		if((fix.getEntityId().longValue()==user.getId().longValue())||isManagerOfThisSpace(user.getId(),spaceId)){
    			return true;
    		}else{
    			//防止其他单位的人修改本单位的空间,必须登录人的单位和空间的所属单位相等
    			if((fix.getEntityId().longValue()==user.getLoginAccount().longValue())){
    				//是否允许前段自定义
	    			SpaceFixUtil util = new SpaceFixUtil(fix.getExtAttributes());
	    			if(util.isAllowdefined() && fix.getState() == Constants.SpaceState.normal.ordinal()){
	    				return true;
	    			}else{
	    				return false;
	    			}
    			}else{
    				return false;
    			}
    		}
    	}
        
        return false;
    }

    @Override
    public String transToDefaultPersonalSpace(Long memberId, Long accountId, Long spaceId, String spaceType)
            throws BusinessException {
        PortalSpaceFix spaceFix = this.getSpaceFix(spaceId);
        Long parentId = spaceFix.getParentId();
        if(parentId!=null){
            PortalSpaceFix newSpaceFix = this.getSpaceFix(parentId);
            String decoration = pageManager.transToDefautlPersonalSpace(memberId, newSpaceFix.getPath());
            return decoration;
        }else{
            return null;
        }
    }

    @Override
    public String updateSpaceByCache(Long editKeyId, Long memberId, Long spaceId, String decoration, String toDefault)
            throws BusinessException {
        boolean isCurrentEdit = pageManager.isCurrentEdit(editKeyId, memberId);
        PortalSpaceFix spaceFix = this.getSpaceFix(spaceId);
        if(isCurrentEdit){
            /**
             * TODO:
             * 1、cacheSave缓存Fragment替换原有Fragment
             * 2、更新properties，循环removeFragments，删除properties，循环saveFragments，保存properties
             * 3、更新rootFragment，保存布局样式decoration
             * 4、如果存在页面个性化，先创建个性化页面；如果存在页面还原则只走页面还原逻辑
             * 5、清空当前member编辑缓存，丢失editKeyId
             */
            Long accountId = spaceFix.getAccountId();
            String pagePath = spaceFix.getPath();
            int spaceType = spaceFix.getType();

            // 恢复默认逻辑
            if("toDefault".equals(toDefault)){
                Long parentId = spaceFix.getParentId();
                //更新排序表，删除旧空间
                if(parentId!=null){
                    /*// 更新排序表
                    SpaceSort sort = spaceSortManager.getSpaceSort(memberId, spaceId);
                    if(sort!=null){
                        sort.setSpacePath(newSpaceFix.getId().toString());
                        spaceSortManager.updateSpaceSort(sort);
                    }
                    // 更新userFix表
                    String defaultSpaceId = userFixManager.getFixValue(memberId, "spaceId");
                    if(Strings.isNotBlank(defaultSpaceId)&&Long.valueOf(defaultSpaceId)==spaceId){
                        userFixManager.saveOrUpdate(memberId, "spaceId", newSpaceFix.getId().toString());
                    }*/
                    //删除旧空间
                    this.deleteSpace(spaceFix);
                    PortalSpaceFix newSpaceFix = this.getSpaceFix(parentId);
                    return newSpaceFix.getId().toString();
                }
            }else{
                // 编辑逻辑
                /**
                 * TODO:空间类型判断
                 */
                //if(spaceType==Constants.SpaceType.Default_personal.ordinal()||spaceType==Constants.SpaceType.default_leader.ordinal()||spaceType==Constants.SpaceType.Default_out_personal.ordinal()||spaceType==Constants.SpaceType.Default_personal_custom.ordinal()){
                    //个性化逻辑
                    spaceFix = this.transCreatePersonalDefineSpace(memberId, accountId, spaceId);
                    pagePath = spaceFix.getPath();
                //}
                    pageManager.savePageByCache(memberId, pagePath, decoration);
            }
        }
        return spaceFix.getId().toString();
    }

    @Override
    public List<MenuTreeNode> getShortcutsOfMember(User user) throws BusinessException {
        List<MenuTreeNode> menuTree = new ArrayList<MenuTreeNode>();
        List<PrivMenuBO> allMenus = privilegeManager.getShortCutMenusOfMember(user.getId(),user.getLoginAccount());
        MenuTreeNode node = null;
        if(CollectionUtils.isEmpty(allMenus)){
            return menuTree;
        }
        for (PrivMenuBO pm : allMenus) {
            node = new MenuTreeNode(pm);
            menuTree.add(node);
            node.setUrlKey(pm.getResourceNavurl());
            /*Long resId = pm.getEnterResourceId();
            if (resId != null) {
                PrivResource res = privilegeManager.findResourceById(resId);
                if (res != null){
                    node.setUrlKey(res.getNavurl());
                }
            }*/
        }
        return menuTree;
    }

    @Override
    public List<MenuTreeNode> getCustomizeShortcutsOfMember(User user, List<MenuTreeNode> shortcuts) throws BusinessException {
        if(CollectionUtils.isEmpty(shortcuts)){
            shortcuts = this.getShortcutsOfMember(user);
        }
        if(CollectionUtils.isEmpty(shortcuts)){
            return null;
        }

        Map<String,MenuTreeNode> defaultNodes = new HashMap<String, MenuTreeNode>();
        for(MenuTreeNode defaultNode : shortcuts){
            defaultNodes.put(defaultNode.getIdKey(), defaultNode);
        }
        Map<String,String> shortCutsMap = user.getCustomizeJson(CustomizeConstants.SHORTCUT, Map.class);
        if(shortCutsMap == null){
            shortCutsMap = new HashMap<String, String>();
        }
        String loginAccountId = String.valueOf(user.getLoginAccount());
        String customizeShortcuts = shortCutsMap.get(loginAccountId);

        final List<Map<String,Object>> cShortcuts = JSONUtil.parseJSONString(customizeShortcuts, List.class);

        Map<String,MenuTreeNode> cShortcutsMap = new HashMap<String,MenuTreeNode>();
        if(CollectionUtils.isEmpty(cShortcuts)){
            if(!CollectionUtils.isEmpty(shortcuts)){
                for(MenuTreeNode node : shortcuts){
                    if(node.getChecked()){
                        cShortcutsMap.put(node.getIdKey(), node);
                    }
                }
            }
        }else{
            //List<String> cShortcutsIds = new ArrayList<String>();
            for(Map<String,Object> shortCut : cShortcuts){
                String id = String.valueOf(shortCut.get("id"));
                String parentId = String.valueOf(shortCut.get("parentId"));
                String sort = shortCut.get("sort")!=null?shortCut.get("sort").toString():"";
                boolean checked = shortCut.get("checked")!=null?(Boolean)shortCut.get("checked"):false;

                //cShortcutsIds.add(id);

                if(checked){
                    MenuTreeNode thisNode_default = defaultNodes.get(id);
                    if(thisNode_default==null){
                        log.warn(user.getName()+"\t"+user.getId()+"\t"+user.getLoginAccountName()+"\t"+user.getLoginAccount()+"\t 快捷菜单匹配异常：显示快捷ID-"+id);
                        continue;
                    }
                    MenuTreeNode treeNode = new MenuTreeNode();
                    treeNode.setIdKey(id);
                    treeNode.setpIdKey(parentId);
                    treeNode.setNameKey(thisNode_default.getNameKey());
                    treeNode.setUrlKey(thisNode_default.getUrlKey());
                    treeNode.setIconKey(thisNode_default.getIconKey());
                    treeNode.setTarget(thisNode_default.getTarget());
                    treeNode.setSort(sort);
                    cShortcutsMap.put(id,treeNode);
                }
            }
            //补充未在个人设置中设置的快捷
            /*for(MenuTreeNode node : shortcuts){
                if(!cShortcutsIds.contains(node.getIdKey()) && node.getChecked()){
                    cShortcutsMap.put(node.getIdKey(), node);
                }
            }*/
        }
        List<MenuTreeNode> shortcutList = new ArrayList<MenuTreeNode>();
        for (String shortcutId : cShortcutsMap.keySet()) {
            MenuTreeNode node = cShortcutsMap.get(shortcutId);
            String parentId = node.getpIdKey();
            //if ("menu_0".equals(parentId)) {
                if (!shortcutList.contains(node)) {
                    shortcutList.add(node);
                }
           // } else {
            	//原逻辑用于进行新建二级快捷验证，孩子你先歇会儿
               /* MenuTreeNode parentNode = cShortcutsMap.get(parentId);
                if (parentNode == null) {
                    break;
                }

                if ("menu_0".equals(parentNode.getpIdKey())) {
                    if (!shortcutList.contains(parentNode)) {
                        shortcutList.add(parentNode);
                    }
                }

                if (!parentNode.containsItem(node)) {
                    parentNode.addItem(node);
                }*/

           // }
        }

        Comparator<MenuTreeNode> comparator = new Comparator<MenuTreeNode>() {
            @Override
            public int compare(final MenuTreeNode o1, final MenuTreeNode o2) {
                if(Strings.isBlank(o1.getSort())||Strings.isBlank(o2.getSort())){
                    return 0;
                }else{
                    return Integer.parseInt(o1.getSort())-Integer.parseInt(o2.getSort());
                }
            }
        };
        Collections.sort(shortcutList, comparator);
        return shortcutList;
    }

    @Override
    public void saveShortcutsSortOfMember(String shortcutsSortString) {
        User user = AppContext.getCurrentUser();
        Map<String,String> customShortcuts = user.getCustomizeJson(CustomizeConstants.SHORTCUT, Map.class);
        if(customShortcuts == null){
            customShortcuts = new HashMap<String, String>();
        }
        String loginAccountId = String.valueOf(user.getLoginAccount());
        customShortcuts.put(loginAccountId, shortcutsSortString);
        UserCustomizeCache.setCustomize(CustomizeConstants.SHORTCUT, JSONUtil.toJSONString(customShortcuts));
        //刷新用户快捷缓存
        try{
        	List<MenuTreeNode> shortcuts = this.getCustomizeShortcutsOfMember(user, null);
            if (shortcuts != null) {
            	UserHelper.setShortcuts(shortcuts);
            }
        }catch(Throwable e){
        	log.warn("刷新用户快捷缓存",e);
        }
    }

    @Override
    public List<MenuTreeNode> getCustomizeShortcuts(User user,List<MenuTreeNode> shortcuts) throws BusinessException {
        if(CollectionUtils.isEmpty(shortcuts)){
            shortcuts = this.getShortcutsOfMember(user);
        }
        if(CollectionUtils.isEmpty(shortcuts)){
            return null;
        }
        Map<String,MenuTreeNode> defaultNodes = new HashMap<String, MenuTreeNode>();
        for(MenuTreeNode defaultNode : shortcuts){
            defaultNodes.put(defaultNode.getIdKey(), defaultNode);
        }
        Map<String,String> shortCutsMap = user.getCustomizeJson(CustomizeConstants.SHORTCUT, Map.class);
        if(shortCutsMap == null){
            shortCutsMap = new HashMap<String, String>();
        }
        String loginAccountId = String.valueOf(user.getLoginAccount());
        String customizeShortcuts = shortCutsMap.get(loginAccountId);

        final List<Map<String,Object>> cShortcuts = JSONUtil.parseJSONString(customizeShortcuts, List.class);
        List<MenuTreeNode> shortcutList = new ArrayList<MenuTreeNode>();
        if(!CollectionUtils.isEmpty(cShortcuts)){
            Map<String,MenuTreeNode> customizeNodes = new HashMap<String, MenuTreeNode>();
            for(Map<String,Object> shortCut : cShortcuts){
                String id = shortCut.get("id").toString();
                String parentId = shortCut.get("parentId").toString();
                String sort = shortCut.get("sort")!=null?shortCut.get("sort").toString():"";
                boolean checked = shortCut.get("checked")!=null?(Boolean)shortCut.get("checked"):false;

                MenuTreeNode thisNode_default = defaultNodes.get(id);
                if(thisNode_default==null){
                    log.error(user.getName()+"\t"+user.getId()+"\t"+user.getLoginAccountName()+"\t"+user.getLoginAccount()+"\t 快捷菜单匹配异常：显示快捷ID-"+id);
                    continue;
                }

                MenuTreeNode treeNode = new MenuTreeNode();
                treeNode.setIdKey(id);
                treeNode.setpIdKey(parentId);
                treeNode.setNameKey(thisNode_default.getNameKey());
                treeNode.setUrlKey(thisNode_default.getUrlKey());
                treeNode.setIconKey(thisNode_default.getIconKey());
                treeNode.setTarget(thisNode_default.getTarget());
                treeNode.setSort(sort);
                treeNode.setChecked(checked);
                shortcutList.add(treeNode);
                customizeNodes.put(id, treeNode);
            }
            for(MenuTreeNode node : shortcuts){
                if(customizeNodes.get(node.getIdKey()) == null){
                    node.setChecked(false);
                    shortcutList.add(node);
                }
            }
        }
        Comparator<MenuTreeNode> comparator = new Comparator<MenuTreeNode>() {
            @Override
            public int compare(final MenuTreeNode o1, final MenuTreeNode o2) {
                if(Strings.isBlank(o1.getSort())||Strings.isBlank(o2.getSort())){
                    return 0;
                }else{
                    return Integer.parseInt(o1.getSort())-Integer.parseInt(o2.getSort());
                }
            }
        };
        Collections.sort(shortcutList, comparator);
        return shortcutList;
    }

    @Override
    public PortalSpaceFix transCreatePersonalSpace(Long memberId, Long accountId) throws BusinessException {
        return null;
    }

    @Override
    public PortalSpaceFix transCreateDefaultPersonalSpace(Long accountId) throws BusinessException {
        String pagePath = Constants.PERSONAL_FOLDER + accountId + "_D" + Constants.DOCUMENT_TYPE;
        PortalSpaceFix spaceFix = this.getSpaceFix(pagePath);
        if (spaceFix != null) {
            return spaceFix;
        } else {
            String srcPagePath = Constants.DEFAULT_PERSONAL_PAGE_PATH;
            spaceFix = transCreateDefaultSpace(Constants.SpaceType.Default_personal, true, true, accountId, srcPagePath, pagePath, null, accountId);
            spaceFix.setDefaultspace(1);
            //默认开启个性化
            String extProperties = spaceFix.getExtAttributes();
            SpaceFixUtil fixUtil = new SpaceFixUtil(extProperties);
            fixUtil.setAllowdefined(true);
            extProperties = fixUtil.getExtAttributes();
            spaceFix.setExtAttributes(extProperties);
            this.updateSpace(spaceFix);

            PortalSpaceSecurity spaceSecurity = new PortalSpaceSecurity();
            spaceSecurity.setNewId();
            spaceSecurity.setSpaceId(spaceFix.getId());
            spaceSecurity.setSecurityType(Constants.SecurityType.used.ordinal());
            spaceSecurity.setEntityType(V3xOrgEntity.ORGENT_TYPE_ACCOUNT);
            spaceSecurity.setEntityId(accountId);
            DBAgent.save(spaceSecurity);

            List<PortalSpaceSecurity> securities = new ArrayList<PortalSpaceSecurity>();
            securities.add(spaceSecurity);
            fireCreateSpaceEvent(this, spaceFix, securities);
        }
        return spaceFix;
    }

    @Override
    public PortalSpaceFix transCreateDefaultLeaderSpace(Long accountId) throws BusinessException {
        Integer productId = SystemProperties.getInstance().getIntegerProperty("system.ProductId");
        if (ProductEditionEnum.a6p.ordinal() == productId || ProductEditionEnum.a6.ordinal() == productId || ProductEditionEnum.a6s.ordinal() == productId) {
            return null;
        }
        String pagePath = Constants.LEADER_FOLDER + accountId + "_Leader" + Constants.DOCUMENT_TYPE;
        PortalSpaceFix spaceFix = this.getSpaceFix(pagePath);
        if (spaceFix != null) {
            return spaceFix;
        } else {
            String srcPagePath = Constants.DEFAULT_LEADER_PAGE_PATH;
            spaceFix = transCreateDefaultSpace(Constants.SpaceType.default_leader, true, true, accountId, srcPagePath, pagePath, null, accountId);
            spaceFix.setDefaultspace(1);
            //默认开启个性化
            String extProperties = spaceFix.getExtAttributes();
            SpaceFixUtil fixUtil = new SpaceFixUtil(extProperties);
            fixUtil.setAllowdefined(true);
            extProperties = fixUtil.getExtAttributes();
            spaceFix.setExtAttributes(extProperties);
            this.updateSpace(spaceFix);
            fireCreateSpaceEvent(this, spaceFix, null);
        }
        return spaceFix;
    }

    @Override
    public PortalSpaceFix transCreateDefaultOuterSpace(Long accountId) throws BusinessException {
        String pagePath = Constants.OUTER_FOLDER + accountId + "_Out" + Constants.DOCUMENT_TYPE;
        PortalSpaceFix spaceFix = this.getSpaceFix(pagePath);
        if (spaceFix != null) {
            return spaceFix;
        } else {
            String srcPagePath = Constants.DEFAULT_OUT_PERSONAL_PAGE_PATH;
            spaceFix = transCreateDefaultSpace(Constants.SpaceType.Default_out_personal, true, true, accountId, srcPagePath, pagePath, null, accountId);
            spaceFix.setDefaultspace(1);
            //默认开启个性化
            String extProperties = spaceFix.getExtAttributes();
            SpaceFixUtil fixUtil = new SpaceFixUtil(extProperties);
            fixUtil.setAllowdefined(true);
            extProperties = fixUtil.getExtAttributes();
            spaceFix.setExtAttributes(extProperties);
            this.updateSpace(spaceFix);

            PortalSpaceSecurity spaceSecurity = new PortalSpaceSecurity();
            spaceSecurity.setNewId();
            spaceSecurity.setSpaceId(spaceFix.getId());
            spaceSecurity.setSecurityType(Constants.SecurityType.used.ordinal());
            spaceSecurity.setEntityType(V3xOrgEntity.ORGENT_TYPE_ACCOUNT);
            spaceSecurity.setEntityId(accountId);
            DBAgent.save(spaceSecurity);

            List<PortalSpaceSecurity> securities = new ArrayList<PortalSpaceSecurity>();
            securities.add(spaceSecurity);
            fireCreateSpaceEvent(this, spaceFix, null);
        }
        return spaceFix;
    }

    @Override
    public PortalSpaceFix transCreateDepartmentSpace(V3xOrgDepartment dept)
            throws BusinessException {
        String pagePath = Constants.DEPARTMENT_FOLDER + dept.getId() + Constants.DOCUMENT_TYPE;
        PortalSpaceFix spaceFix = this.getSpaceFix(pagePath);
        if(spaceFix!=null){
            if(spaceFix.getState() != Constants.SpaceState.normal.ordinal()){
                updateDepartmentSpaceState(dept.getId(), true);
            }
            /*List<Object[]> securitys = this.getSecuityOfSpace(spaceFix.getId());
            List<Long> securityEntityIds = new ArrayList<Long>();
            if(CollectionUtils.isNotEmpty(securitys)){
            	for(Object[] obj : securitys){
            		Long entityId = (Long)obj[1];
            		securityEntityIds.add(entityId);
            	}
            }
            //数据容错，去除冗余数据
            //部门主管
            String deptManagerStr = dept.getDepManager();
            if(deptManagerStr != null && deptManagerStr.trim().length() > 0){
                List<V3xOrgEntity> deptManagerEntityList =orgManager.getEntities(deptManagerStr);
                if(CollectionUtils.isNotEmpty(deptManagerEntityList)){
                    for(V3xOrgEntity entity : deptManagerEntityList){
                    	if(!securityEntityIds.contains(entity.getId())){
	                        PortalSpaceSecurity sec = new PortalSpaceSecurity();
	                        sec.setNewId();
	                        sec.setSpaceId(spaceFix.getId());
	                        sec.setSecurityType(Constants.SecurityType.manager.ordinal());
	                        sec.setEntityType(V3xOrgEntity.ORGENT_TYPE_MEMBER);
	                        sec.setEntityId(entity.getId());
	                        DBAgent.save(sec);
	                        securityEntityIds.add(entity.getId());
                    	}
                    }
                }
            }
            //部门管理员
            String deptAdminStr = dept.getDepAdmin();
            if(deptAdminStr != null && deptAdminStr.trim().length() > 0){
                List<V3xOrgEntity> deptAdminEntityList =orgManager.getEntities(deptAdminStr);
                if(CollectionUtils.isNotEmpty(deptAdminEntityList)){
                    for(V3xOrgEntity entity : deptAdminEntityList){
                    	if(!securityEntityIds.contains(entity.getId())){
	                        PortalSpaceSecurity sec = new PortalSpaceSecurity();
	                        sec.setNewId();
	                        sec.setSpaceId(spaceFix.getId());
	                        sec.setSecurityType(Constants.SecurityType.manager.ordinal());
	                        sec.setEntityType(V3xOrgEntity.ORGENT_TYPE_MEMBER);
	                        sec.setEntityId(entity.getId());
	                        DBAgent.save(sec);
	                        securityEntityIds.add(entity.getId());
                    	}
                    }
                }
            }*/
            return spaceFix;
        }else{
            String srcPagePath = Constants.DEFAULT_DEPARTMENT_PAGE_PATH;
            //String deptSpaceName = ResourceUtil.getString("seeyon.top.department.space.label")+"("+dept.getName()+")";
            String deptSpaceName = dept.getName();
            spaceFix = transCreateDefaultSpace(Constants.SpaceType.department,false,false, dept.getOrgAccountId(), srcPagePath, pagePath, deptSpaceName, dept.getId());
            spaceFix.setDefaultspace(1);
            this.updateSpace(spaceFix);

            List<PortalSpaceSecurity> securities = new ArrayList<PortalSpaceSecurity>();

            PortalSpaceSecurity spaceSecurity = new PortalSpaceSecurity();
            spaceSecurity.setNewId();
            spaceSecurity.setSpaceId(spaceFix.getId());
            spaceSecurity.setSecurityType(Constants.SecurityType.used.ordinal());
            spaceSecurity.setEntityType(V3xOrgEntity.ORGENT_TYPE_DEPARTMENT);
            spaceSecurity.setEntityId(dept.getId());
            securities.add(spaceSecurity);

            /*//数据容错，去除冗余数据
            List<Long> securityEntityIds = new ArrayList<Long>();

            //部门主管
            String deptManagerStr = dept.getDepManager();
            if(deptManagerStr != null && deptManagerStr.trim().length() > 0){
                List<V3xOrgEntity> deptManagerEntityList =orgManager.getEntities(deptManagerStr);
                if(CollectionUtils.isNotEmpty(deptManagerEntityList)){
                    for(V3xOrgEntity entity : deptManagerEntityList){
                    	if(!securityEntityIds.contains(entity.getId())){
	                        PortalSpaceSecurity sec = new PortalSpaceSecurity();
	                        sec.setNewId();
	                        sec.setSpaceId(spaceFix.getId());
	                        sec.setSecurityType(Constants.SecurityType.manager.ordinal());
	                        sec.setEntityType(V3xOrgEntity.ORGENT_TYPE_MEMBER);
	                        sec.setEntityId(entity.getId());
	                        securities.add(sec);

	                        securityEntityIds.add(entity.getId());
                    	}
                    }
                }
            }
            //部门管理员
            String deptAdminStr = dept.getDepAdmin();
            if(deptAdminStr != null && deptAdminStr.trim().length() > 0){
                List<V3xOrgEntity> deptAdminEntityList =orgManager.getEntities(deptAdminStr);
                if(CollectionUtils.isNotEmpty(deptAdminEntityList)){
                    for(V3xOrgEntity entity : deptAdminEntityList){
                    	if(!securityEntityIds.contains(entity.getId())){
	                        PortalSpaceSecurity sec = new PortalSpaceSecurity();
	                        sec.setNewId();
	                        sec.setSpaceId(spaceFix.getId());
	                        sec.setSecurityType(Constants.SecurityType.manager.ordinal());
	                        sec.setEntityType(V3xOrgEntity.ORGENT_TYPE_MEMBER);
	                        sec.setEntityId(entity.getId());
	                        securities.add(sec);

	                        securityEntityIds.add(entity.getId());
                    	}
                    }
                }
            }*/

            DBAgent.saveAll(securities);

            //生成部门空间时同时生成部门讨论、公告的菜单权限
            roleManager.batchRole2Entity(orgManager.getRoleByName(OrgConstants.Role_NAME.DeptSpace.name(), dept.getOrgAccountId()).getId(), V3xOrgEntity.ORGENT_TYPE_DEPARTMENT+"|"+dept.getId()+"^"+dept.getId());

            fireCreateSpaceEvent(this,spaceFix,securities);
        }
        return spaceFix;
    }

    @Override
    public void deleteDepartmentSpace(Long departmentId) throws BusinessException {
        String pagePath = Constants.DEPARTMENT_FOLDER + departmentId + Constants.DOCUMENT_TYPE;
        PortalSpaceFix spaceFix = this.getSpaceFix(pagePath);
        if(spaceFix!=null){
        	spaceSecurityManager.deleteSecurityBySpaceId(spaceFix.getId());
            this.deleteSpace(spaceFix);
        }
    }

    @Override
    public void updateDepartmentSpaceState(Long departmentId, boolean isEnabled) throws BusinessException {
        String pagePath = Constants.DEPARTMENT_FOLDER + departmentId + Constants.DOCUMENT_TYPE;
        PortalSpaceFix spaceFix = this.getSpaceFix(pagePath);
        if(spaceFix!=null){
            spaceFix.setState(isEnabled?Constants.SpaceState.normal.ordinal():Constants.SpaceState.invalidation.ordinal());
            log.info("部门空间状态修改记录:"+AppContext.getCurrentUser().getName()+" | "+AppContext.getCurrentUser().getId()+ " 修改部门空间 ["+spaceFix.getSpacename()+"]的状态为"+(spaceFix.getState()==0?"启用":"停用"));
            this.updateSpace(spaceFix);
            V3xOrgDepartment dept = orgManager.getDepartmentById(departmentId);
            if(isEnabled){
                List<Object[]> securities = this.getSecuityOfDepartment(departmentId);
                if(CollectionUtils.isNotEmpty(securities)){
                    String securityStr = "";
                    for(Object[] sec : securities){
                        securityStr += sec[0]+"|"+sec[1]+",";
                    }
                    roleManager.batchRole2Entity(orgManager.getRoleByName(OrgConstants.Role_NAME.DeptSpace.name(), dept != null ? dept.getOrgAccountId() : null).getId(), securityStr+"^"+departmentId);
                }
            }else{
              //生成部门空间时同时生成部门讨论、公告的菜单权限
                roleManager.batchRole2Entity(orgManager.getRoleByName(OrgConstants.Role_NAME.DeptSpace.name(), dept != null ? dept.getOrgAccountId() : null).getId(), "^"+departmentId);
            }
        }
    }

    @Override
    public PortalSpaceFix transCreateCorporationSpace(Long accountId) throws BusinessException {
        String pagePath = Constants.CORPORATION_FOLDER + accountId + Constants.DOCUMENT_TYPE;
        PortalSpaceFix spaceFix = this.getSpaceFix(pagePath);
        if (spaceFix != null) {
            return spaceFix;
        } else {
            String srcPagePath = Constants.DEFAULT_CORPORATION_PAGE_PATH;
            spaceFix = transCreateDefaultSpace(Constants.SpaceType.corporation, false, false, accountId, srcPagePath, pagePath, null, accountId);
            spaceFix.setDefaultspace(1);
            this.updateSpace(spaceFix);

            PortalSpaceSecurity spaceSecurity = new PortalSpaceSecurity();
            spaceSecurity.setNewId();
            spaceSecurity.setSpaceId(spaceFix.getId());
            spaceSecurity.setSecurityType(Constants.SecurityType.used.ordinal());
            spaceSecurity.setEntityType(V3xOrgEntity.ORGENT_TYPE_ACCOUNT);
            spaceSecurity.setEntityId(accountId);
            DBAgent.save(spaceSecurity);

            List<PortalSpaceSecurity> securities = new ArrayList<PortalSpaceSecurity>();
            securities.add(spaceSecurity);
            fireCreateSpaceEvent(this, spaceFix, securities);
        }
        return spaceFix;
    }

    @Override
    public PortalSpaceFix transCreateGroupSpace(Long groupId) throws BusinessException {
        if (groupId == null) {
            groupId = orgManager.getRootAccount().getId();
        }
        String pagePath = Constants.GROUP_FOLDER + groupId + Constants.DOCUMENT_TYPE;
        PortalSpaceFix spaceFix = this.getSpaceFix(pagePath);
        if (spaceFix != null) {
            return spaceFix;
        } else {
            String srcPagePath = Constants.DEFAULT_GROUP_PAGE_PATH;
            spaceFix = transCreateDefaultSpace(Constants.SpaceType.group, false, false, groupId, srcPagePath, pagePath, null, groupId);
            spaceFix.setDefaultspace(1);
            this.updateSpace(spaceFix);

            PortalSpaceSecurity spaceSecurity = new PortalSpaceSecurity();
            spaceSecurity.setNewId();
            spaceSecurity.setSpaceId(spaceFix.getId());
            spaceSecurity.setSecurityType(Constants.SecurityType.used.ordinal());
            spaceSecurity.setEntityType(V3xOrgEntity.ORGENT_TYPE_ACCOUNT);
            spaceSecurity.setEntityId(orgManager.getRootAccount().getId());
            DBAgent.save(spaceSecurity);

            List<PortalSpaceSecurity> securities = new ArrayList<PortalSpaceSecurity>();
            securities.add(spaceSecurity);
            fireCreateSpaceEvent(this, spaceFix, securities);
        }
        return spaceFix;
    }

    @Override
    public PortalSpaceFix transCreateCooperationSpace(Long accountId) throws BusinessException {
        // 协同工作主题空间
        String path = Constants.COOPERATION_FOLDER + accountId + Constants.DOCUMENT_TYPE;
        PortalSpaceFix spaceFix = this.getSpaceFix(path);
        if (spaceFix != null) {
            return spaceFix;
        } else {
            String srcPagePath = Constants.DEFAULT_COOPERATION_PAGE_PATH;
            //版本区隔，没有二级首页的版本不进行初始化
            PortalSpacePage page = pageManager.getPage(srcPagePath);
            if (page == null) {
                return null;
            }
            spaceFix = transCreateDefaultSpace(Constants.SpaceType.cooperation_work, true, false, accountId, srcPagePath, path, null, accountId);
            spaceFix.setDefaultspace(1);
            this.updateSpace(spaceFix);

            PortalSpaceSecurity spaceSecurity = new PortalSpaceSecurity();
            spaceSecurity.setNewId();
            spaceSecurity.setSpaceId(spaceFix.getId());
            spaceSecurity.setSecurityType(Constants.SecurityType.used.ordinal());
            spaceSecurity.setEntityType(V3xOrgEntity.ORGENT_TYPE_ACCOUNT);
            spaceSecurity.setEntityId(accountId);
            DBAgent.save(spaceSecurity);

            List<PortalSpaceSecurity> securities = new ArrayList<PortalSpaceSecurity>();
            securities.add(spaceSecurity);
            fireCreateSpaceEvent(this, spaceFix, securities);
        }
        return spaceFix;
    }

    @Override
    public PortalSpaceFix transCreateFormBizSpace(Long accountId) throws BusinessException {
        //表单应用主题空间
        String path = Constants.FORMBIZ_FOLDER + accountId + Constants.DOCUMENT_TYPE;
        PortalSpaceFix spaceFix = this.getSpaceFix(path);
        if (spaceFix != null) {
            return spaceFix;
        } else {
            String srcPagePath = Constants.DEFAULT_FORMBIZ_PAGE_PATH;
            //版本区隔，没有二级首页的版本不进行初始化
            PortalSpacePage page = pageManager.getPage(srcPagePath);
            if (page == null) {
                return null;
            }
            spaceFix = transCreateDefaultSpace(Constants.SpaceType.form_application, true, false, accountId, srcPagePath, path, null, accountId);
            spaceFix.setDefaultspace(1);
            this.updateSpace(spaceFix);

            PortalSpaceSecurity spaceSecurity = new PortalSpaceSecurity();
            spaceSecurity.setNewId();
            spaceSecurity.setSpaceId(spaceFix.getId());
            spaceSecurity.setSecurityType(Constants.SecurityType.used.ordinal());
            spaceSecurity.setEntityType(V3xOrgEntity.ORGENT_TYPE_ACCOUNT);
            spaceSecurity.setEntityId(accountId);
            DBAgent.save(spaceSecurity);

            List<PortalSpaceSecurity> securities = new ArrayList<PortalSpaceSecurity>();
            securities.add(spaceSecurity);
            fireCreateSpaceEvent(this, spaceFix, securities);
        }
        return spaceFix;
    }

    @Override
    public PortalSpaceFix transCreateEdocSpace(Long accountId) throws BusinessException {
        //公文管理主题空间
        String path = Constants.EDOC_FOLDER + accountId + Constants.DOCUMENT_TYPE;
        PortalSpaceFix spaceFix = this.getSpaceFix(path);
        if (spaceFix != null) {
            return spaceFix;
        } else {
            String srcPagePath = Constants.DEFAULT_EDOC_PAGE_PATH;
            //版本区隔，没有二级首页的版本不进行初始化
            PortalSpacePage page = pageManager.getPage(srcPagePath);
            if (page == null) {
                return null;
            }
            spaceFix = transCreateDefaultSpace(Constants.SpaceType.edoc_manage, true, false, accountId, srcPagePath, path, null, accountId);
            spaceFix.setDefaultspace(1);
            this.updateSpace(spaceFix);

            PortalSpaceSecurity spaceSecurity = new PortalSpaceSecurity();
            spaceSecurity.setNewId();
            spaceSecurity.setSpaceId(spaceFix.getId());
            spaceSecurity.setSecurityType(Constants.SecurityType.used.ordinal());
            spaceSecurity.setEntityType(V3xOrgEntity.ORGENT_TYPE_ACCOUNT);
            spaceSecurity.setEntityId(accountId);
            DBAgent.save(spaceSecurity);

            List<PortalSpaceSecurity> securities = new ArrayList<PortalSpaceSecurity>();
            securities.add(spaceSecurity);
            fireCreateSpaceEvent(this, spaceFix, securities);
        }
        return spaceFix;
    }

    @Override
    public PortalSpaceFix transCreateObjectiveSpace(Long accountId) throws BusinessException {
        //目标管理主题空间
        String path = Constants.OBJECTIVE_FOLDER + accountId + Constants.DOCUMENT_TYPE;
        PortalSpaceFix spaceFix = this.getSpaceFix(path);
        if (spaceFix != null) {
            return spaceFix;
        } else {
            String srcPagePath = Constants.DEFAULT_OBJECTIVE_PAGE_PATH;
            //版本区隔，没有二级首页的版本不进行初始化
            PortalSpacePage page = pageManager.getPage(srcPagePath);
            if (page == null) {
                return null;
            }
            spaceFix = transCreateDefaultSpace(Constants.SpaceType.objective_manage, true, false, accountId, srcPagePath, path, null, accountId);
            spaceFix.setDefaultspace(1);
            this.updateSpace(spaceFix);

            PortalSpaceSecurity spaceSecurity = new PortalSpaceSecurity();
            spaceSecurity.setNewId();
            spaceSecurity.setSpaceId(spaceFix.getId());
            spaceSecurity.setSecurityType(Constants.SecurityType.used.ordinal());
            spaceSecurity.setEntityType(V3xOrgEntity.ORGENT_TYPE_ACCOUNT);
            spaceSecurity.setEntityId(accountId);
            DBAgent.save(spaceSecurity);

            List<PortalSpaceSecurity> securities = new ArrayList<PortalSpaceSecurity>();
            securities.add(spaceSecurity);
            fireCreateSpaceEvent(this, spaceFix, securities);
        }
        return spaceFix;
    }

    @Override
    public PortalSpaceFix transCreateMeetingSpace(Long accountId) throws BusinessException {
        //会议管理主题空间
        String path = Constants.MEETING_FOLDER + accountId + Constants.DOCUMENT_TYPE;
        PortalSpaceFix spaceFix = this.getSpaceFix(path);
        if (spaceFix != null) {
            return spaceFix;
        } else {
            String srcPagePath = Constants.DEFAULT_MEETING_PAGE_PATH;
            //版本区隔，没有二级首页的版本不进行初始化
            PortalSpacePage page = pageManager.getPage(srcPagePath);
            if (page == null) {
                return null;
            }
            spaceFix = transCreateDefaultSpace(Constants.SpaceType.meeting_manage, true, false, accountId, srcPagePath, path, null, accountId);
            spaceFix.setDefaultspace(1);
            this.updateSpace(spaceFix);

            PortalSpaceSecurity spaceSecurity = new PortalSpaceSecurity();
            spaceSecurity.setNewId();
            spaceSecurity.setSpaceId(spaceFix.getId());
            spaceSecurity.setSecurityType(Constants.SecurityType.used.ordinal());
            spaceSecurity.setEntityType(V3xOrgEntity.ORGENT_TYPE_ACCOUNT);
            spaceSecurity.setEntityId(accountId);
            DBAgent.save(spaceSecurity);

            List<PortalSpaceSecurity> securities = new ArrayList<PortalSpaceSecurity>();
            securities.add(spaceSecurity);
            fireCreateSpaceEvent(this, spaceFix, securities);
        }
        return spaceFix;
    }

    @Override
    public PortalSpaceFix transCreatePerformanceSpace(Long accountId) throws BusinessException {
        //协同驾驶舱主题空间
        String path = Constants.PERFORMANCE_FOLDER + accountId + Constants.DOCUMENT_TYPE;
        PortalSpaceFix spaceFix = this.getSpaceFix(path);
        if (spaceFix != null) {
            return spaceFix;
        } else {
            String srcPagePath = Constants.DEFAULT_PERFORMANCE_PAGE_PATH;
            //版本区隔，没有二级首页的版本不进行初始化
            PortalSpacePage page = pageManager.getPage(srcPagePath);
            if (page == null) {
                return null;
            }
            spaceFix = transCreateDefaultSpace(Constants.SpaceType.performance_analysis, true, false, accountId, srcPagePath, path, null, accountId);
            spaceFix.setDefaultspace(1);
            this.updateSpace(spaceFix);

            PortalSpaceSecurity spaceSecurity = new PortalSpaceSecurity();
            spaceSecurity.setNewId();
            spaceSecurity.setSpaceId(spaceFix.getId());
            spaceSecurity.setSecurityType(Constants.SecurityType.used.ordinal());
            spaceSecurity.setEntityType(V3xOrgEntity.ORGENT_TYPE_ACCOUNT);
            spaceSecurity.setEntityId(accountId);
            DBAgent.save(spaceSecurity);

            List<PortalSpaceSecurity> securities = new ArrayList<PortalSpaceSecurity>();
            securities.add(spaceSecurity);
            fireCreateSpaceEvent(this, spaceFix, securities);
        }
        return spaceFix;
    }

    public PortalSpaceFix transCreateVjoinpcSpace(Long accountId) throws BusinessException {
        //V-Join-PC空间
        String path = Constants.VJOINPC_FOLDER + accountId + Constants.DOCUMENT_TYPE;
        PortalSpaceFix spaceFix = this.getSpaceFix(path);
        if (spaceFix != null) {
            return spaceFix;
        } else {
            String srcPagePath = Constants.DEFAULT_VJOINPC_PAGE_PATH;
            PortalSpacePage page = pageManager.getPage(srcPagePath);
            if (page == null) {
                return null;
            }
            spaceFix = transCreateDefaultSpace(Constants.SpaceType.vjoinpc, false, false, accountId, srcPagePath, path, null, accountId);
            spaceFix.setDefaultspace(1);
            this.updateSpace(spaceFix);

            PortalSpaceSecurity spaceSecurity = new PortalSpaceSecurity();
            spaceSecurity.setNewId();
            spaceSecurity.setSpaceId(spaceFix.getId());
            spaceSecurity.setSecurityType(Constants.SecurityType.used.ordinal());
            spaceSecurity.setEntityType(V3xOrgEntity.ORGENT_TYPE_ACCOUNT);
            spaceSecurity.setEntityId(accountId);
            DBAgent.save(spaceSecurity);

            List<PortalSpaceSecurity> securities = new ArrayList<PortalSpaceSecurity>();
            securities.add(spaceSecurity);
            //fireCreateSpaceEvent(this, spaceFix, securities);
        }
        return spaceFix;
    }

    public PortalSpaceFix transCreateVjoinmobileSpace(Long accountId) throws BusinessException {
        //V-Join-移动空间
        String path = Constants.VJOINMOBILE_FOLDER + accountId + Constants.DOCUMENT_TYPE;
        PortalSpaceFix spaceFix = this.getSpaceFix(path);
        if (spaceFix != null) {
            return spaceFix;
        } else {
            String srcPagePath = Constants.DEFAULT_VJOINMOBILE_PAGE_PATH;
            PortalSpacePage page = pageManager.getPage(srcPagePath);
            if (page == null) {
                return null;
            }
            spaceFix = transCreateDefaultSpace(Constants.SpaceType.vjoinmobile, false, false, accountId, srcPagePath, path, null, accountId);
            spaceFix.setDefaultspace(1);
            this.updateSpace(spaceFix);

            PortalSpaceSecurity spaceSecurity = new PortalSpaceSecurity();
            spaceSecurity.setNewId();
            spaceSecurity.setSpaceId(spaceFix.getId());
            spaceSecurity.setSecurityType(Constants.SecurityType.used.ordinal());
            spaceSecurity.setEntityType(V3xOrgEntity.ORGENT_TYPE_ACCOUNT);
            spaceSecurity.setEntityId(accountId);
            DBAgent.save(spaceSecurity);

            List<PortalSpaceSecurity> securities = new ArrayList<PortalSpaceSecurity>();
            securities.add(spaceSecurity);
            //fireCreateSpaceEvent(this, spaceFix, securities);
        }
        return spaceFix;
    }

    private PortalSpaceFix transCreateDefaultSpace(Constants.SpaceType type,boolean isAllowedUserDefined,boolean isShowBanner,
            Long accountId, String srcPagePath, String destPagePath, String spaceName,Long entityId)
            throws BusinessException {
        this.copyPage(srcPagePath, destPagePath);
        PortalSpacePage destPage =  pageManager.getPage(destPagePath);
        PortalSpacePage srcPage = pageManager.getPage(srcPagePath);
        PortalSpaceFix fix = new PortalSpaceFix();
        fix.setIdIfNew();
        if (spaceName != null) {
            fix.setSpacename(spaceName);
        }else{
            fix.setSpacename(destPage.getPageName());
        }
        fix.setPath(destPagePath);
        fix.setAccountId(accountId);
        fix.setEntityId(entityId);
        fix.setState(Constants.SpaceState.normal.ordinal());
        fix.setSortId(srcPage.getSort());
        fix.setType(type.ordinal());

        String extProperties = "";
        SpaceFixUtil fixUtil = new SpaceFixUtil(extProperties);
        if(isAllowedUserDefined){
            fixUtil.setAllowdefined(Constants.DEFAULT_Allowdefined);
        }else{
            fixUtil.setAllowdefined(isAllowedUserDefined);
        }
        if(isShowBanner){
            fixUtil.setSlogan(Constants.getSloganKey());
            fixUtil.setBanner(Constants.DEFAULT_BANNER);
        }
        extProperties = fixUtil.getExtAttributes();
        fix.setExtAttributes(extProperties);

        this.insertSpace(fix);

        return fix;
    }

    @Override
    public PortalSpaceFix transSelectThemSpace(int themType, Long accountId, Long memberId) throws BusinessException {
        if(accountId==null){
            accountId = AppContext.currentAccountId();
        }
        if(memberId == null){
            memberId = AppContext.currentUserId();
        }

        PortalSpaceFix spaceFix = null;
        Constants.SpaceType type = EnumUtil.getEnumByOrdinal(Constants.SpaceType.class, themType);
        switch(type){
            case cooperation_work:
                spaceFix = this.transSelectCooperationSpace(accountId, memberId);
                break;
            case objective_manage:
                spaceFix = this.transSelectObjectiveSpace(accountId, memberId);
                break;
            case edoc_manage:
                spaceFix = this.transSelectEdocSpace(accountId, memberId);
                break;
            case meeting_manage:
                spaceFix = this.transSelectMeetingSpace(accountId, memberId);
                break;
            case performance_analysis:
                spaceFix = this.transSelectPerformanceSpace(accountId, memberId);
                break;
            case form_application:
                spaceFix = this.transSelectFormBizSpace(accountId, memberId);
                break;
            default:
                break;
        }
        return spaceFix;
    }

    @Override
    public PortalSpaceFix transSelectCooperationSpace(Long accountId, Long memberId) throws BusinessException {
        PortalSpaceFix spaceFix = this.selectPersonalCustomSpace(Constants.SpaceType.cooperation_work.ordinal(),accountId,memberId);
        if(spaceFix==null){
            String path = Constants.COOPERATION_FOLDER + accountId + Constants.DOCUMENT_TYPE;
            spaceFix = this.getSpaceFix(path);
            if(spaceFix == null){
               spaceFix = this.transCreateCooperationSpace(accountId);
            }
        }
        return spaceFix;
    }

    @Override
    public PortalSpaceFix transSelectObjectiveSpace(Long accountId, Long memberId) throws BusinessException {
        PortalSpaceFix spaceFix = this.selectPersonalCustomSpace(Constants.SpaceType.objective_manage.ordinal(),accountId,memberId);
        if(spaceFix==null){
            String path = Constants.OBJECTIVE_FOLDER + accountId + Constants.DOCUMENT_TYPE;
            spaceFix = this.getSpaceFix(path);
            if(spaceFix == null){
                spaceFix = this.transCreateObjectiveSpace(accountId);
             }
        }
        return spaceFix;
    }

    @Override
    public PortalSpaceFix transSelectEdocSpace(Long accountId, Long memberId) throws BusinessException {
        PortalSpaceFix spaceFix = this.selectPersonalCustomSpace(Constants.SpaceType.edoc_manage.ordinal(),accountId,memberId);
        if(spaceFix==null){
            String path = Constants.EDOC_FOLDER + accountId + Constants.DOCUMENT_TYPE;
            spaceFix = this.getSpaceFix(path);
            if(spaceFix == null){
                spaceFix = this.transCreateEdocSpace(accountId);
            }
        }
        return spaceFix;
    }

    @Override
    public PortalSpaceFix transSelectMeetingSpace(Long accountId, Long memberId) throws BusinessException {
        PortalSpaceFix spaceFix = this.selectPersonalCustomSpace(Constants.SpaceType.meeting_manage.ordinal(),accountId,memberId);
        if(spaceFix==null){
            String path = Constants.MEETING_FOLDER + accountId + Constants.DOCUMENT_TYPE;
            spaceFix = this.getSpaceFix(path);
            if(spaceFix == null){
                spaceFix = this.transCreateMeetingSpace(accountId);
            }
        }
        return spaceFix;
    }

    @Override
    public PortalSpaceFix transSelectPerformanceSpace(Long accountId, Long memberId) throws BusinessException {
        PortalSpaceFix spaceFix = this.selectPersonalCustomSpace(Constants.SpaceType.performance_analysis.ordinal(),accountId,memberId);
        if(spaceFix==null){
            String path = Constants.PERFORMANCE_FOLDER + accountId + Constants.DOCUMENT_TYPE;
            spaceFix = this.getSpaceFix(path);
            if(spaceFix == null){
                spaceFix = this.transCreatePerformanceSpace(accountId);
            }
        }
        return spaceFix;
    }
    @Override
    public PortalSpaceFix transSelectFormBizSpace(Long accountId, Long memberId) throws BusinessException {
        PortalSpaceFix spaceFix = this.selectPersonalCustomSpace(Constants.SpaceType.form_application.ordinal(),accountId,memberId);
        if(spaceFix==null){
            String path = Constants.FORMBIZ_FOLDER + accountId + Constants.DOCUMENT_TYPE;
            spaceFix = this.getSpaceFix(path);
            if(spaceFix == null){
                spaceFix = this.transCreateFormBizSpace(accountId);
            }
        }
        return spaceFix;
    }

    @Override
    public PortalSpaceFix selectPersonalCustomSpace(int type, Long accountId, Long memberId) throws BusinessException {
        String hql = " from PortalSpaceFix where type = :type and accountId = :accountId and entityId = :entityId";
        Map params = new HashMap();
        params.put("type", type);
        params.put("accountId", accountId);
        params.put("entityId", memberId);
        List<PortalSpaceFix> spaces = DBAgent.find(hql, params);
        if(CollectionUtils.isEmpty(spaces)){
            return null;
        }else{
            return spaces.get(0);
        }
    }

    @Override
    public List<PortalSpaceFix> getSpacesOfSection(String sectionId, Long memberId, Long accountId)
            throws BusinessException {
        List<PortalSpaceFix> result = new ArrayList<PortalSpaceFix>();

        List<PortalSpaceFix> spaces = this.getAccessSpace(memberId, accountId);

        for (PortalSpaceFix space : spaces) {
            PortalSpacePage page = this.pageManager.getPage(space.getPath());
            if(page==null){
                continue;
            }
            PortalPagePortlet root = (PortalPagePortlet) page.getExtraAttr("RootPagePortlet");
            if(root==null){
                continue;
            }
            List<PortalPagePortlet> portlets = (List<PortalPagePortlet>) root.getExtraAttr("ChildrenPortlets");
            if(CollectionUtils.isEmpty(portlets)){
                continue;
            }

            for (PortalPagePortlet portlet : portlets) {
                Map<String, String> props = portletEntityPropertyManager.getPropertys(portlet.getId());
                String sections = props.get(PortletPropertyContants.PropertyName.sections.name());
                if(Strings.isNotBlank(sections)){
                    String[] _sections = sections.split(",");
                    for(int i = 0; i < _sections.length; i++) {
                        if(sectionId.equalsIgnoreCase(_sections[i])) {
                            result.add(space);
                        }
                    }
                }
            }
        }
        return result;
    }

    @Override
    public List<String[]> getThemSpaceSort(Long memberId, Long accountId, Locale userLocale) throws BusinessException {
        /*List<Integer> themTypes = new ArrayList<Integer>();
        themTypes.add(SpaceType.cooperation_work.ordinal());
        themTypes.add(SpaceType.performance_analysis.ordinal());
        themTypes.add(SpaceType.edoc_manage.ordinal());
        themTypes.add(SpaceType.form_application.ordinal());
        themTypes.add(SpaceType.meeting_manage.ordinal());
        themTypes.add(SpaceType.objective_manage.ordinal());*/


        List<Long> entityIds = new ArrayList<Long>();
        entityIds.add(memberId);
        entityIds.add(accountId);

        String hql = " from "+PortalSpaceFix.class.getName() + " where accountId = :accountId and state = :state and type >= 19 and entityId in (:entityIds) order by sortId";

        Map params = new HashMap();
        params.put("accountId", accountId);
        //params.put("themTypes", themTypes);
        params.put("state", SpaceState.normal.ordinal());
        params.put("entityIds", entityIds);

        List<PortalSpaceFix> themSpaces = DBAgent.find(hql,params);

        List<String[]> resultList = new ArrayList<String[]>();
        if (CollectionUtils.isEmpty(themSpaces)) {
            return resultList;
        }
        /**
         * 找出被个性化的空间
         */
        List<Long> removeSpaceIds = new ArrayList<Long>();
        for (PortalSpaceFix space : themSpaces) {
            Long parentSpaceId = space.getParentId();
            if (parentSpaceId != null) {
                removeSpaceIds.add(parentSpaceId);
            }
        }
        /**
         * 去除被个性化的空间
         */
        for (PortalSpaceFix space : themSpaces) {
            if (!removeSpaceIds.contains(space.getId())) {
                Long sortId = space.getSortId();
                String sort = "0";
                if (sortId != null) {
                    sort = String.valueOf(sortId);
                }
                String spaceName = ResourceUtil.getString(space.getSpacename());
                String parentId = null;
                if(space.getParentId()!=null){
                    parentId = String.valueOf(space.getParentId());
                    String _name = this.getParentSpaceName(space.getParentId());
                    if(null != _name){
                        spaceName = _name;
                    }
                }
                String[] objStr = { String.valueOf(space.getId()),parentId,space.getPath(), spaceName, String.valueOf(SpaceState.normal.ordinal()), sort,String.valueOf(space.getType())};
                resultList.add(objStr);
            }
        }
        return resultList;
    }
    private void fireCreateSpaceEvent(Object source,PortalSpaceFix spaceFix,List<PortalSpaceSecurity> securities){
        AddSpaceEvent event = new AddSpaceEvent(source);
        //spaceFix.setSpacename(ResourceUtil.getString(spaceFix.getSpacename()));
        event.setSpaceFix(spaceFix);
        event.setSpaceSecurities(securities);
        EventDispatcher.fireEvent(event);
    }

    @Override
    public List<PortalSpaceFix> IsPublishedFormBizSection(Long singleBoardId, String sectionId, Long memberId, Long accountId)
            throws BusinessException {
        List<PortalSpaceFix> result = new ArrayList<PortalSpaceFix>();

        List<PortalSpaceFix> spaces = this.getAccessSpace(memberId, accountId);

        for (PortalSpaceFix space : spaces) {
            String type = String.valueOf(space.getType());
            //个人、领导、外部人员、自定义个人、部门、自定义团队
            if("0".equals(type)||"10".equals(type)||"15".equals(type)||"16".equals(type)||"4".equals(type)||"1".equals(type)){
                PortalSpacePage page = this.pageManager.getPage(space.getPath());
                if(page==null){
                    continue;
                }
                PortalPagePortlet root = (PortalPagePortlet) page.getExtraAttr("RootPagePortlet");
                if(root==null){
                    continue;
                }
                List<PortalPagePortlet> portlets = (List<PortalPagePortlet>) root.getExtraAttr("ChildrenPortlets");
                if(CollectionUtils.isEmpty(portlets)){
                    continue;
                }

                for (PortalPagePortlet portlet : portlets) {
                    Map<String, String> props = portletEntityPropertyManager.getPropertys(portlet.getId());
                    String sections = props.get(PortletPropertyContants.PropertyName.sections.name());
                    if(Strings.isNotBlank(sections)){
                        String[] _sections = sections.split(",");
                        for(int i = 0; i < _sections.length; i++) {
                            if(sectionId.equalsIgnoreCase(_sections[i])) {
                                String singleId = props.get(PropertyName.singleBoardId.name()+":"+i);
                                if(String.valueOf(singleBoardId).equals(singleId)){
                                    if(!result.contains(space)){
                                        result.add(space);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return result;
    }
    @Override
    public boolean deletePersonalSpaceSection(Long memberId, Long accountId,
            String sectionId, String singleBoardId) throws BusinessException {
        if (Strings.isBlank(sectionId)
                || (sectionId.startsWith("singleBoard") && Strings
                        .isBlank(singleBoardId))) {
            return false;
        }
        boolean result = false;
        V3xOrgMember member = orgManager.getMemberById(memberId);
        List<String[]> spaceSorts = this.getSpaceSort(memberId, accountId, orgManagerDirect.getMemberLocaleById(member.getId()), false, null);
        if(CollectionUtils.isNotEmpty(spaceSorts)){
            for(String[] sort : spaceSorts){
                String type = sort[6];
                String spaceId = sort[0];
                String isDelete = sort[4];
                //个人、领导、外部人员、个人自定义、自定义团队、部门
                if("0".equals(isDelete)&&Strings.isNotBlank(spaceId)&&(("0").equals(type)|| ("5").equals(type) || ("9").equals(type) || ("10").equals(type)
                        || (Integer.parseInt(type) >=13  && Integer.parseInt(type) != 17 && Integer.parseInt(type) != 18))){
                    PortalSpaceFix fix = this.getSpaceFix(Long.valueOf(spaceId));
                    String pagePath = fix.getPath();
                    PortalSpacePage page = this.pageManager.getPage(pagePath);
                    if (page != null) {
                        PortalPagePortlet root = (PortalPagePortlet) page.getExtraAttr("RootPagePortlet");
                        if(root==null){
                            continue;
                        }
                        List<PortalPagePortlet> portlets = (List<PortalPagePortlet>) root.getExtraAttr("ChildrenPortlets");
                        if(CollectionUtils.isEmpty(portlets)){
                            continue;
                        }
                        Map<Long,ArrayList<Integer>> removeFragment = new HashMap<Long,ArrayList<Integer>>();
                        if(CollectionUtils.isNotEmpty(portlets)){
                            for(PortalPagePortlet fragment : portlets){
                                Long entityId = fragment.getId();
                                Map<String,String> properties = this.portletEntityPropertyManager.getPropertys(entityId);
                                if(properties!=null&&properties.size()>0){
                                    String sectionName = properties.get(PropertyName.sections.name());
                                    if(Strings.isNotBlank(sectionName)){
                                        String[] sections = sectionName.split(",");
                                        for(int i=0; i<sections.length; i++){
                                            if(sections[i].equals(sectionId)){
                                                String value = properties.get("singleBoardId:"+i);
                                                if(Strings.isNotBlank(value)&&value.equals(singleBoardId)){
                                                    ArrayList<Integer> list= removeFragment.get(entityId);
                                                    if(CollectionUtils.isEmpty(list)){
                                                        list = new ArrayList<Integer>();
                                                    }
                                                    list.add(i);
                                                    removeFragment.put(entityId, list);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if(removeFragment!=null&&removeFragment.size()>0){
                            Set<Long> removeEntityIds = removeFragment.keySet();
                            for(Long removeEntityId : removeEntityIds){
                                List<Integer> indexs = removeFragment.get(removeEntityId);
                                Collections.sort(indexs);
                                for(int i=indexs.size()-1;i>=0;i--){
                                     this.pageManager.deleteFragment(removeEntityId, pagePath, indexs.get(i));
                                }
                            }
                        }
                    }
                }
            }
            return true;
        }
        return result;
    }

    @Override
    public String transAddPortletToSectionByFront(Long spaceId, Long entityId, String sectionIds,
            String[] sectionNames, String[] singleBoards, String[] entityIds, String[] ordinals,
            List<Map<String, String>> properties) throws BusinessException {
        User user = AppContext.getCurrentUser();
        PortalSpaceFix spaceFix = this.transCreatePersonalDefineSpace(user.getId(), user.getLoginAccount(), Long.valueOf(spaceId));
        if(spaceId.equals(spaceFix.getId())){
            pageManager.addPortletToSectionsByFront(entityId, sectionIds, sectionNames, singleBoards, entityIds, ordinals, properties);
        }else{
            //定位添加的频道坐标
            PortalSpaceFix parentSpace = this.getSpaceFix(spaceId);
            PortalSpacePage parentpage = pageManager.getPage(parentSpace.getPath());
            PortalPagePortlet portlet = pageManager.getFragmentById(parentpage, entityId);

            Map<String,Map<String,PortalPagePortlet>> portlets = pageManager.getFragments(spaceFix.getPath());
            if(portlets!=null&&portlets.size()>0){
                Map<String,PortalPagePortlet> columnPortlets = portlets.get(String.valueOf(portlet.getLayoutColumn()));
                if(columnPortlets!=null&&columnPortlets.size()>0){
                    PortalPagePortlet tgtportlet = columnPortlets.get(String.valueOf(portlet.getLayoutRow()));
                    if(tgtportlet!=null){
                        if(Strings.isBlank(sectionIds)){
                            //删除栏目

                        }else{
                            //更新栏目
                            pageManager.addPortletToSectionsByFront(tgtportlet.getId(), sectionIds, sectionNames, singleBoards, entityIds, ordinals, properties);
                        }
                    }else{
                        log.error("空间["+spaceFix.getSpacename()+"]|["+spaceFix.getPath()+"]的["+portlet.getLayoutColumn()+"]列["+portlet.getLayoutRow()+"]行栏目复制数据为空");
                    }
                }else{
                    log.error("空间["+spaceFix.getSpacename()+"]|["+spaceFix.getPath()+"]的["+portlet.getLayoutColumn()+"]列栏目复制数据为空");
                }
            }else{
                log.error("空间["+spaceFix.getSpacename()+"]|["+spaceFix.getPath()+"]的栏目复制数据为空");
            }
        }
        return spaceFix.getPath();
    }

	@Override
	public Map<String,List<String[]>> getListHasAcl(List<PortalSpaceFix> accessSpaces,
			Map<String, Map<String, Map<String, Object>>> ctpCustomize)
			throws BusinessException {
		Map<String,List<String[]>> map = new HashMap<String, List<String[]>>();
		//如果没有自定义的空间
		List<String[]> listHasAcl = this.gsList(accessSpaces);
		if (ctpCustomize.isEmpty()) {
			map.put("allSortSpaces", listHasAcl);
			map.put("cusSortSpaces", new ArrayList<String[]>());
			return map;
		}
		//获取自定义空间中有权限的集合
		List<String[]> cusSortSpaces = new ArrayList<String[]>();
		//获取有权限看到，但没有在自定义空间出现的，将来要追加到已选里面
		List<PortalSpaceFix> allSortSpaces = new ArrayList<PortalSpaceFix>(accessSpaces);

			//开始遍历-->
		for (PortalSpaceFix psf : accessSpaces) {
			Long id = psf.getId();
			Map<String,Map<String,Object>> currentAccountSpaceSort = ctpCustomize.get(String.valueOf(AppContext.currentAccountId()));
			List<String> keyList = new ArrayList<String>(currentAccountSpaceSort.keySet());
			Collections.sort(keyList);
	        for(String key : keyList){
	            String spaceId = currentAccountSpaceSort.get(key).get(CustomizeConstants.SPACE_ID).toString();
	            if (String.valueOf(id).equals(spaceId)) {
	            	String[] str = {String.valueOf(psf.getId()),String.valueOf(psf.getParentId()),
			    					psf.getPath(), psf.getSpacename(), String.valueOf(SpaceState.normal.ordinal()),
			    					String.valueOf(psf.getSortId()),String.valueOf(psf.getType()),
			    					String.valueOf(currentAccountSpaceSort.get(key).get("isDeleted"))};
	            	cusSortSpaces.add(str);

	            	allSortSpaces.remove(psf);
				}
	        }
		}
			//-->遍历结束

		//将sortSpaces 格式化
		List<String[]> sortSpacesStr = this.gsList(allSortSpaces);

		Map<String,List<String[]>> allCus = this.getLeftCus(sortSpacesStr);

		map.put("cusSortSpaces", cusSortSpaces);
		map.put("allSortSpaces", sortSpacesStr);
		map.put("leftCus", allCus.get("leftCus"));
		map.put("rightCus", allCus.get("rightCus"));
		return map;
	}

	private List<String[]> gsList(List<PortalSpaceFix> accessSpaces){
		List<String[]> sortSpacesStr = new ArrayList<String[]>();
		for (PortalSpaceFix psf:accessSpaces) {
			String[] str = {String.valueOf(psf.getId()),String.valueOf(psf.getParentId()),
					psf.getPath(), psf.getSpacename(), String.valueOf(SpaceState.normal.ordinal()), String.valueOf(psf.getSortId()),String.valueOf(psf.getType())};
			sortSpacesStr.add(str);
		}
		return sortSpacesStr;
	}

	private Map<String,List<String[]>> getLeftCus(List<String[]> cusSortSpaces){
		Map<String,List<String[]>> map = new HashMap<String, List<String[]>>();
		List<String[]> leftCus = new ArrayList<String[]>();
		List<String[]> rightCus = new ArrayList<String[]>();

		for (String[] strings : cusSortSpaces) {
			if ("0".equals(strings[6])) {
				leftCus.add(strings);
			}else {
				rightCus.add(strings);
			}
		}
		map.put("leftCus", leftCus);
		map.put("rightCus", rightCus);
		return map;
	}

	@Override
	public List<String[]> getLinkSpceSys(List<PortalLinkSpace> linkSpaces,
			List<String[]> listAllCus) throws BusinessException {
		for (PortalLinkSpace pls : linkSpaces) {
			for (String[] strings : listAllCus) {
				if (String.valueOf(pls.getId()).equals(strings[0])) {
					linkSpaces.remove(pls);
				}
			}
		}
		List<String[]> linkSpaceSys = new ArrayList<String[]>();
		for (PortalLinkSpace pls : linkSpaces) {
			String[] str = {String.valueOf(pls.getId()),null,
					null, pls.getSpaceName(), String.valueOf(SpaceState.normal.ordinal()),"0","11"};
			linkSpaceSys.add(str);
		}
		return linkSpaceSys;
	}

	@Override
	public List<String[]> getRelatedProjectStr(
			List<ProjectBO> relatedProjects, List<String[]> listAllCus)
			throws BusinessException {
		for (ProjectBO pjs : relatedProjects) {
			for (String[] strings : listAllCus) {
				if (String.valueOf(pjs.getId()).equals(strings[0])) {
					relatedProjects.remove(pjs);
				}
			}
		}
		List<String[]> relatedProjectStr = new ArrayList<String[]>();
		for (ProjectBO pjs : relatedProjects) {
			String[] str = {String.valueOf(pjs.getId()),null,
					null, pjs.getProjectName(), String.valueOf(SpaceState.normal.ordinal()),"0","12"};
			relatedProjectStr.add(str);
		}
		return relatedProjectStr;
	}

	@Override
	public List<PortalLinkSpace> getLinkSpacesFiltered(
			List<PortalLinkSpace> linkSpacesUnFilter,
			List<String[]> selectedSpaces) throws BusinessException {
		//List<String> sortList = getDisplayProjectOrSpaceIds();
		List<PortalLinkSpace> removeList1 = new ArrayList<PortalLinkSpace>();
		for (String[] strings : selectedSpaces) {
			for (PortalLinkSpace pls : linkSpacesUnFilter) {
				if (strings[0].equals(pls.getId().toString())) {
					removeList1.add(pls);
				}
			}
		}
		linkSpacesUnFilter.removeAll(removeList1);
		return linkSpacesUnFilter;
	}
	//拿到个性化中  选中的的id  string
	private List<String> getDisplayProjectOrSpaceIds(){
		List<String> sortList = new ArrayList<String>();
		Map<String,Map<String,Object>> currentAccountSpaceSort = getUserCustomizeProjectAndSpaceIds();
		if(currentAccountSpaceSort == null){
			return sortList;
		}else{
	    	List<String> keyList = new ArrayList<String>(currentAccountSpaceSort.keySet());
	        Collections.sort(keyList);
			//已排序列表
			for(String key : keyList){
				String spaceId = currentAccountSpaceSort.get(key).get(CustomizeConstants.SPACE_ID).toString();
				String isHidden = currentAccountSpaceSort.get(key).get(CustomizeConstants.SPACE_ISDELETED).toString();
				//0为显示
				if ("0".equals(isHidden)) {
					sortList.add(spaceId);
				}
			}
		}

		return sortList;
	}
	private List<String> getDisplayProjectOrSpaceTypes(){
		List<String> typeList = new ArrayList<String>();
		Map<String,Map<String,Object>> currentAccountSpaceSort = getUserCustomizeProjectAndSpaceIds();
		if(currentAccountSpaceSort == null){
			return typeList;
		}else{
	    	List<String> keyList = new ArrayList<String>(currentAccountSpaceSort.keySet());
	        Collections.sort(keyList);
			//已排序列表
			for(String key : keyList){
				String spaceType = currentAccountSpaceSort.get(key).get(CustomizeConstants.SPACE_TYPE).toString();
				String isHidden = currentAccountSpaceSort.get(key).get(CustomizeConstants.SPACE_ISDELETED).toString();
				//0为显示
				if ("0".equals(isHidden) && !typeList.contains(spaceType)) {
					typeList.add(spaceType);
				}
			}
		}

		return typeList;
	}

	/**
	 * 获取用户当前登录单位显示及隐藏的空间导航数据
	 */
	private Map<String, Map<String, Object>> getUserCustomizeProjectAndSpaceIds(){
		User user = AppContext.getCurrentUser();
		Long accountId = AppContext.currentAccountId();
		Map<String, Map<String, Map<String, Object>>> spaceOrder = user.getCustomizeJson(CustomizeConstants.SPACE_ORDER, Map.class);
		sortSpace(spaceOrder);//xx重新排序
		if(spaceOrder == null){
			return null;
		}
		Map<String, Map<String, Object>> currentAccountSpaceSort = spaceOrder.get(String.valueOf(accountId));
		return currentAccountSpaceSort;
	}

	@Override
	public List<ProjectBO> getRelatedProjectsFiltered(
			List<ProjectBO> relatedProjectsUnFilter,
			List<String[]> selectedSpaces) throws BusinessException {
		List<String> sortList = getDisplayProjectOrSpaceIds();
		List<ProjectBO> removeList1 = new ArrayList<ProjectBO>();
		for (String[] strings : selectedSpaces) {
			for (ProjectBO pls : relatedProjectsUnFilter) {
				if (strings[0].equals(pls.getId().toString())&&sortList.contains(pls.getId().toString())) {
					removeList1.add(pls);
				}
			}
		}
		relatedProjectsUnFilter.removeAll(removeList1);
		return relatedProjectsUnFilter;
	}

    @Override
    public boolean isGroupSpaceManager(Long userId) throws BusinessException {
        Long groupId = orgManager.getRootAccount().getId();
        String pagePath = Constants.GROUP_FOLDER + groupId + Constants.DOCUMENT_TYPE;
        PortalSpaceFix fix = this.getSpaceFix(pagePath);
        if(fix == null){
            return false;
        }
        return this.isManagerOfThisSpace(userId, fix.getId());
    }

    @Override
    public boolean isAccountSpaceManager(Long userId, Long accountId) throws BusinessException {
        String pagePath = Constants.CORPORATION_FOLDER + accountId + Constants.DOCUMENT_TYPE;
        PortalSpaceFix fix = this.getSpaceFix(pagePath);
        if(fix == null){
            return false;
        }
        return this.isManagerOfThisSpace(userId, fix.getId());
    }

    @Override
    public boolean isDeptSpaceManager(Long userId, Long departmentId) throws BusinessException {
        String pagePath = Constants.DEPARTMENT_FOLDER + departmentId + Constants.DOCUMENT_TYPE;
        PortalSpaceFix fix = this.getSpaceFix(pagePath);
        if(fix == null){
            return false;
        }
        return this.isManagerOfThisSpace(userId, fix.getId());
    }

    @Override
    public List<Long> getDeptsByManagerSpace(Long userId) throws BusinessException {
        List<Long> result = new ArrayList<Long>();
        List<PortalSpaceFix> list = this.getCanManagerSpaceByMemberId(userId);
        if (CollectionUtils.isNotEmpty(list)) {
            for (PortalSpaceFix fix : list) {
                int type = fix.getType();
                if (type == Constants.SpaceType.department.ordinal()) {
                    result.add(fix.getEntityId());
                }
            }
        }
        return result;
    }

    @Override
    public void deleteCorporationSpaceSecurity(Long deptId,Long accountId) throws BusinessException {
        PortalSpaceFix corporationSpace = this.transCreateCorporationSpace(accountId);
        if(corporationSpace == null){
            return;
        }
        List<V3xOrgMember> deptMemebers = orgManager.getMembersByDepartment(deptId, false);
        if(CollectionUtils.isEmpty(deptMemebers)){
            return;
        }
        List<Long> members = new ArrayList<Long>();
        for(V3xOrgMember member : deptMemebers){
            members.add(member.getId());
        }

        Long corporationSpaceId = corporationSpace.getId();
        List<PortalSpaceSecurity> securities = spaceSecurityManager.selectSecurityBySpaceId(corporationSpaceId);
        if(CollectionUtils.isEmpty(securities)){
            return;
        }
        List<PortalSpaceSecurity> removeSecurities = new ArrayList<PortalSpaceSecurity>();
        for(PortalSpaceSecurity security : securities){
            if(Integer.valueOf(SecurityType.manager.ordinal()).equals(security.getSecurityType())&&members.contains(security.getEntityId())){
                removeSecurities.add(security);
            }
        }
        if(CollectionUtils.isNotEmpty(removeSecurities)){
            DBAgent.deleteAll(removeSecurities);
        }
    }

    @Override
    public List<String[]> getSettingThemSpace() throws BusinessException {
        User user = AppContext.getCurrentUser();
        Long userId = user.getId();
        Long loginAccountId = user.getLoginAccount();

        List<String[]> list = new ArrayList<String[]>();
        //个人主题空间设置
        List<String[]> spaceList = this.getThemSpaceSort(userId, loginAccountId, user.getLocale());

        String[] cooperation_work_space = null;
        String[] form_application_space = null;
        String[] edoc_manage_space = null;
        String[] objective_manage_space = null;
        String[] meeting_manage_space = null;
        String[] performance_analysis_space = null;

        for (String[] space : spaceList) {
            String[] sp = new String[6];
            sp[0] = space[0];
            sp[1] = space[1];
            sp[2] = space[3];
            String spaceId = space[0];
            PortalSpaceFix _space = this.getSpaceFix(Long.valueOf(spaceId));
            if (_space != null) {
                SpaceFixUtil fixUtil = new SpaceFixUtil(_space.getExtAttributes());
                boolean isAllowdefined = fixUtil.isAllowdefined();
                if (isAllowdefined) {
                    sp[4] = "true";
                } else {
                    sp[4] = "false";
                }
                boolean canAccess = _space.getState() != Constants.SpaceState.invalidation.ordinal();
                if (canAccess) {
                    String pagePath = _space.getPath();
                    sp[3] = pagePath;
                    PortalSpacePage page = pageManager.getPage(pagePath);
                    if (page != null) {
                        sp[5] = page.getDefaultLayoutDecorator();
                    }
                    String spaceType = space[6];
                    if (String.valueOf(SpaceType.cooperation_work.ordinal()).equals(spaceType) && user.hasResourceCode("T03_cooperation_work")) {
                        cooperation_work_space = sp;
                    } else if (String.valueOf(SpaceType.form_application.ordinal()).equals(spaceType) && user.hasResourceCode("T03_form_application")) {
                        form_application_space = sp;
                    } else if (AppContext.hasPlugin("edoc") && String.valueOf(SpaceType.edoc_manage.ordinal()).equals(spaceType) && user.hasResourceCode("T03_edoc_manage")) {
                        edoc_manage_space = sp;
                    } else if (String.valueOf(SpaceType.objective_manage.ordinal()).equals(spaceType) && user.hasResourceCode("T03_objective_manage")) {
                        objective_manage_space = sp;
                    } else if (AppContext.hasPlugin("meeting") && String.valueOf(SpaceType.meeting_manage.ordinal()).equals(spaceType) && user.hasResourceCode("T03_meeting_manage")) {
                        meeting_manage_space = sp;
                    } else if (String.valueOf(SpaceType.performance_analysis.ordinal()).equals(spaceType) && user.hasResourceCode("T03_performance_analysis")) {
                        performance_analysis_space = sp;
                    }
                }
            }
        }
        if (cooperation_work_space != null) {
            list.add(cooperation_work_space);
        }
        if (form_application_space != null) {
            list.add(form_application_space);
        }
        if (edoc_manage_space != null) {
            list.add(edoc_manage_space);
        }
        if (objective_manage_space != null) {
            list.add(objective_manage_space);
        }
        if (meeting_manage_space != null) {
            list.add(meeting_manage_space);
        }
        if (performance_analysis_space != null) {
            list.add(performance_analysis_space);
        }
        return list;
    }

	@Override
	public PortalSpaceFix getDeptSpaceIdByDeptId(Long departmentId) throws BusinessException {
		if(departmentId == null){
			return null;
		}
		String pagePath = Constants.DEPARTMENT_FOLDER + departmentId + Constants.DOCUMENT_TYPE;
        PortalSpaceFix spaceFix = this.getSpaceFix(pagePath);
		return spaceFix;
	}

	@Override
	public PortalSpaceFix transSelectDeskTopSpace(int spaceType, Long spaceId,
			Long accountId, Long memberId) throws BusinessException {
		if(accountId==null){
            accountId = AppContext.currentAccountId();
        }
        if(memberId == null){
            memberId = AppContext.currentUserId();
        }

        PortalSpaceFix spaceFix = null;
        Constants.SpaceType type = EnumUtil.getEnumByOrdinal(Constants.SpaceType.class, spaceType);
        switch(type){
            case Default_personal:
                spaceFix = this.transSelectPersonalSpace(accountId, memberId);
                break;
            case personal:
                spaceFix = this.transSelectPersonalSpace(accountId, memberId);
                break;
            case default_leader:
                spaceFix = this.transSelectLeaderSpace(accountId, memberId);
                break;
            case leader:
                spaceFix = this.transSelectLeaderSpace(accountId, memberId);
                break;
            case personal_custom:
                spaceFix = this.transSelectPersonalCustomSpace(accountId, memberId,spaceId);
                break;
            default:
                break;
        }
        return spaceFix;
	}

	@Override
	public PortalSpaceFix transSelectPersonalSpace(Long accountId,
			Long memberId) throws BusinessException {
		PortalSpaceFix spaceFix = this.selectPersonalCustomSpace(Constants.SpaceType.personal.ordinal(),accountId,memberId);
        if(spaceFix==null){
            spaceFix = this.transCreateDefaultPersonalSpace(accountId);
        }
        return spaceFix;
	}

	@Override
	public PortalSpaceFix transSelectLeaderSpace(Long accountId, Long memberId)
			throws BusinessException {
		PortalSpaceFix spaceFix = this.selectPersonalCustomSpace(Constants.SpaceType.leader.ordinal(),accountId,memberId);
        if(spaceFix==null){
           spaceFix = this.transCreateDefaultLeaderSpace(accountId);
        }
        return spaceFix;
	}

	@Override
	public PortalSpaceFix transSelectPersonalCustomSpace(Long accountId,
			Long memberId, Long parentSpaceId) throws BusinessException {
		 	String hql = " from PortalSpaceFix where type = :type and accountId = :accountId and entityId = :entityId and parentId = :parentId";
	        Map params = new HashMap();
	        params.put("type", SpaceType.personal_custom.ordinal());
	        params.put("accountId", accountId);
	        params.put("entityId", memberId);
	        params.put("parentId", parentSpaceId);
	        List<PortalSpaceFix> spaces = DBAgent.find(hql, params);
	        if(CollectionUtils.isEmpty(spaces)){
	        	PortalSpaceFix spaceFix = this.getSpaceFix(parentSpaceId);
	            return spaceFix;
	        }else{
	            return spaces.get(0);
	        }
	}

	@Override
	public List<PortalSpaceFix> getPortalSpaceFixByType(List<Integer> types, Long accountId) throws BusinessException {
        if (Strings.isEmpty(types)) {
            return null;
        }
		String hql = null;
		Map params = new HashMap();
		if(accountId == null){
			hql = "from PortalSpaceFix where type in(:types) and parentId is null and state = " + SpaceState.normal.ordinal() + " order by type asc";
			params.put("types", types);
		} else {
			hql = "from PortalSpaceFix where accountId = :accountId and parentId is null and type in(:types) and state = " + SpaceState.normal.ordinal() + " order by type asc";
			params.put("accountId", accountId);
			params.put("types", types);
		}
		return DBAgent.find(hql, params);
	}

	@Override
	public DefaultSpaceSetting getDefaultSpaceSettingForGroup(){
		return DefaultSpaceSetting.getDefaultSpaceSettingForGroup();
    }

	@Override
	public DefaultSpaceSetting getDefaultSpaceSettingForAccount(Long accountId){
		return DefaultSpaceSetting.getDefaultSpaceSettingForAccount(accountId);
    }

	@Override
    public void transSetDefaultSpace(DefaultSpaceSetting setting) throws BusinessException {
		if(setting != null){
			setting.save();
			Long userId = setting.getUserId();
			String allowChangeDefaultSpace = setting.getAllowChangeDefaultSpace();
			if(userId.longValue() == OrgConstants.GROUPID.longValue() && "0".equals(allowChangeDefaultSpace)){
				//如果集团管理员不允许单位设置默认空间
				DefaultSpaceSetting.deleteAllAccountSetting();
			}
			setSpaceNavReSortForDefaultSpaceSetting(setting);
			transSendMsgForSetDefaultSpace(setting);
		}
	}

	/**
	 * 判断某人在某单位下是否调整过空间排序
	 * @param userId
	 * @param accountId
	 * @return
	 */
	private boolean isSpaceResorted(Long userId, Long accountId){
//		String hql = "select userId from CtpCustomize where userId = :userId and ckey = :ckey";
//		Map<String, Object> params = new HashMap<String, Object>();
//		params.put("userId", userId);
//		params.put("ckey", CustomizeConstants.SPACE_IS_RESORT + "_" + accountId);
//		List<Long> list = DBAgent.find(hql, params);
//		if(list != null && list.size() > 0){
//			return true;
//		}

		CtpCustomize cc = customizeManager.getCustomizeInfo(userId, CustomizeConstants.SPACE_IS_RESORT + "_" + accountId);
		if(cc!=null) {
			return true;
		}
		return false;
	}

	/**
	 * 管理员不允许个人设置默认空间，把个人调整过空间导航顺序置为"否"
	 * @throws BusinessException
	 */
	private void setSpaceNavReSortForDefaultSpaceSetting(DefaultSpaceSetting setting) throws BusinessException{
		String allowChangeDefaultSpace = setting.getAllowChangeDefaultSpace();
		if("0".equals(allowChangeDefaultSpace)){
			Long groupOrAccountId = setting.getUserId();
			String hql = null;
            Map<String, Object> params = new HashMap<String, Object>();
            List<CtpCustomize> customizes;
            if(groupOrAccountId.longValue() == OrgConstants.GROUPID.longValue()){
            	//集团管理员不允许
                customizes = customizeManager.getCustomizeStartWithKey(CustomizeConstants.SPACE_IS_RESORT + "_");
            } else {
            	customizes = customizeManager.getCustomizeByKey(CustomizeConstants.SPACE_IS_RESORT + "_" + groupOrAccountId);
            }
            try {
            	customizeManager.deleteAllCustomize(customizes);
            } catch (BusinessException e) {
            	log.error(e.getLocalizedMessage(),e);
            	throw e;
            }

		}
	}

	/**
	 * 管理员设置默认空间后，给跟随变化的人员发消息
	 */
	private void transSendMsgForSetDefaultSpace(DefaultSpaceSetting setting) throws BusinessException {
		String defaultSpaceId = setting.getDefaultSpace();
		String defaultSpaceType = setting.getSpaceType();
		String spaceName = null;
		Long referenceId = null;
		if(defaultSpaceId.length() > 0){
			//设置的默认空间是一个具体的空间
			Long spaceId = Long.valueOf(defaultSpaceId);
			PortalSpaceFix spaceFix = DBAgent.get(PortalSpaceFix.class, spaceId);
			spaceName = spaceFix.getSpacename();
			referenceId = spaceId;
		} else {
			//设置的默认空间是一种默认的空间类型
			if(DefaultSpaceSetting.Default_Space_Personal_Type.equals(defaultSpaceType)){
				spaceName = "space.default.personal.label";
				referenceId = 5l;
			} else if(DefaultSpaceSetting.Default_Space_Corporation_Type.equals(defaultSpaceType)){
				spaceName = "space.default.corporation.label";
				referenceId = 2l;
			} else if(DefaultSpaceSetting.Default_Space_Group_Type.equals(defaultSpaceType)){
				if(ProductEditionEnum.getCurrentProductEditionEnum() == ProductEditionEnum.entgroup){
					spaceName = "space.default.group.label";
		        } else if(ProductEditionEnum.getCurrentProductEditionEnum() == ProductEditionEnum.governmentgroup){
		        	spaceName = "seeyon.top.group.space.label.GOV";
		        }
				referenceId = 3l;
			}
		}
		Long groupOrAccountId = setting.getUserId();
		//该集团/单位下所有的人
		List<V3xOrgMember> allMembers = orgManager.getAllMembersWithOuter(groupOrAccountId);
		List<Long> allMemberIds = new ArrayList<Long>();
		String hql = null;
        Map<String, Object> params = new HashMap<String, Object>();
        List<CtpCustomize> customizes;
		if(groupOrAccountId.longValue() == OrgConstants.GROUPID.longValue()){
        	//集团管理员
			List<V3xOrgAccount> allAccounts = orgManager.getAllAccounts();
			List<Long> allAccountIds = new ArrayList<Long>();
			for(V3xOrgAccount account : allAccounts){
				allAccountIds.add(account.getId());
			}
			//找出设置了默认空间的单位
			Map<Long, Boolean> accountsHasSettingMap = DefaultSpaceSetting.getAccountsHasSetting(allAccountIds);
			//去掉设置了默认空间的单位下的人员
			for(V3xOrgMember member : allMembers){
				if(accountsHasSettingMap.get(member.getOrgAccountId()) == null){
					allMemberIds.add(member.getId());
				}
			}
//			hql = "select userId from CtpCustomize where ckey like :ckey";
//			params.put("ckey", CustomizeConstants.SPACE_IS_RESORT + "_" + "%");
			customizes = customizeManager.getCustomizeStartWithKey(CustomizeConstants.SPACE_IS_RESORT + "_");
        } else {
        	//单位管理员
    		for(V3xOrgMember member : allMembers){
    			allMemberIds.add(member.getId());
    		}
//        	hql = "select userId from CtpCustomize where ckey = :ckey";
//			params.put("ckey", CustomizeConstants.SPACE_IS_RESORT + "_" + groupOrAccountId);
			customizes = customizeManager.getCustomizeByKey(CustomizeConstants.SPACE_IS_RESORT + "_" + groupOrAccountId);
        }
		//该集团/单位下调整过空间导航排序的人
		if(customizes==null) {
			customizes = Collections.emptyList();
		}

		List<Long> reSortSpaceNavMembers = new ArrayList<Long>(customizes.size());
		for (CtpCustomize cc : customizes) {
			Long userId = cc.getUserId();
			if(userId==null) {
				continue;
			}
			reSortSpaceNavMembers.add(userId);
		}
//		List<Long> reSortSpaceNavMembers = DBAgent.find(hql, params);
		//该集团/单位下没有调整过空间导航排序的人
		List<Long> targetMembers = (List<Long>) CollectionUtils.subtract(allMemberIds, reSortSpaceNavMembers);
		if(targetMembers != null && targetMembers.size() > 0){
            MessageContent content = MessageContent.get("portal.defaultspace.setting", ResourceUtil.getString(spaceName));
            Collection<MessageReceiver> receivers = MessageReceiver.get(referenceId, targetMembers);
            userMessageManager.sendSystemMessage(content, ApplicationCategoryEnum.organization, AppContext.currentUserId(), receivers);
        }
	}

	/**
	 * 判断上级设置的默认空间是否能被该用户在该单位下访问（判断用户是否有上级设置的默认空间的使用权限）
	 * @param setting
	 * @param userId
	 * @param accountId
	 * @return
	 */
	private boolean isDefaultSpaceCanAccessed(DefaultSpaceSetting setting, Long userId, Long accountId) throws BusinessException {
		boolean canAccessed = false;
		String defaultSpaceId = setting.getDefaultSpace();
		String defaultSpaceType = setting.getSpaceType();
		List<PortalSpaceFix> spaceFixList = getAccessSpace(userId, accountId);
		if(defaultSpaceId.length() > 0){
			//设置的默认空间是一个具体的空间
			for(PortalSpaceFix spaceFix : spaceFixList){
				Long spaceFixId = spaceFix.getId();
				if(defaultSpaceId.equals(spaceFixId.toString())){
					canAccessed = true;
					break;
				}
			}
		} else {
			//设置的默认空间是一种默认的空间类型
			String[] defaultSpaceTypeStringArray = defaultSpaceType.split("_");
			for(String spaceTypeTmp : defaultSpaceTypeStringArray){
				for(PortalSpaceFix spaceFix : spaceFixList){
					Integer spaceFixType = spaceFix.getType();
					Long spaceFixAccountId = spaceFix.getAccountId();
		        	if(spaceTypeTmp.equals(String.valueOf(spaceFixType)) && (spaceFixAccountId.longValue() == OrgConstants.GROUPID || accountId.longValue() == spaceFixAccountId.longValue())){
		        		canAccessed = true;
						return canAccessed;
					}
				}
			}
		}
		return canAccessed;
	}

	@Override
	public boolean canSetDefaultSpace() throws BusinessException {
		boolean canSet = true;
		long currentUserId = AppContext.currentUserId();
		long currentAccountId = AppContext.currentAccountId();
		DefaultSpaceSetting setting = DefaultSpaceSetting.getDefaultSpaceSettingForAccount(AppContext.currentAccountId());
		String allowChangeDefaultSpace = setting.getAllowChangeDefaultSpace();
		if("0".equals(allowChangeDefaultSpace)){
			//管理员不允许用户设置默认空间
			if(setting.getUserId().longValue() != OrgConstants.GROUPID.longValue()){
				if(!isDefaultSpaceCanAccessed(setting, currentUserId, currentAccountId)){
					//用户没有单位设置的默认空间的使用权限
					DefaultSpaceSetting groupSetting = DefaultSpaceSetting.getDefaultSpaceSettingForGroup();
					if("0".equals(groupSetting.getAllowChangeDefaultSpace()) && isDefaultSpaceCanAccessed(groupSetting, currentUserId, currentAccountId)){
						//用户有集团设置的默认空间的使用权限
						canSet = false;
					}
				} else {
					//用户有单位设置的默认空间的使用权限
					canSet = false;
				}
			} else {
				if(isDefaultSpaceCanAccessed(setting, currentUserId, currentAccountId)){
					//用户有集团设置的默认空间的使用权限
					canSet = false;
				}
			}
		}
		return canSet;
	}

	@Override
	public PortalSpaceFix transCreateRelateProjectSpace(Long accountId,Long projectId) throws BusinessException {
		String pagePath = Constants.PROJECT_FOLDER + projectId + Constants.DOCUMENT_TYPE;
        PortalSpaceFix spaceFix = this.getSpaceFix(pagePath);
        if(spaceFix!=null){
            return spaceFix;
        }else{
            String srcPagePath = Constants.DEFAULT_PROJECT_PAGE_PATH;
            spaceFix = transCreateDefaultSpace(Constants.SpaceType.related_project_space,false,true, accountId, srcPagePath, pagePath, null, projectId);
            //关联项目空间设置为非系统默认空间
            spaceFix.setDefaultspace(0);

            this.updateSpace(spaceFix);

            fireCreateSpaceEvent(this,spaceFix,null);
        }
        return spaceFix;
	}

	@Override
	public void transSavePorjectSecurity(List<PortalSpaceSecurity> spaceSecurities) throws BusinessException {
		if(CollectionUtils.isNotEmpty(spaceSecurities)){
			DBAgent.saveAll(spaceSecurities);
		}
	}

	@Override
	public PortalSpaceFix selectProjectSpace(Long projectId) throws BusinessException {
		String pagePath = Constants.PROJECT_FOLDER + projectId + Constants.DOCUMENT_TYPE;
		PortalSpaceFix spaceFix = this.getSpaceFix(pagePath);
		return spaceFix;
	}

	@Override
	public List<PortalSpaceSecurity> selectSecurityByProjectSpaceId(Long spaceId) throws BusinessException {
		if(spaceId == null){
			return null;
		}
		return spaceSecurityManager.selectSecurityBySpaceId(spaceId);
	}

	@Override
	public void deletePorjectSpaceByProjectId(Long projectId) throws BusinessException {
		PortalSpaceFix spaceFix = this.selectProjectSpace(projectId);
		if(spaceFix != null){
			this.deleteSpace(spaceFix);
		}
	}

	@Override
	public boolean isCanVisitThisSpace(Long spaceId, Long memberId) throws BusinessException {
		V3xOrgMember member = orgManager.getMemberById(memberId);
        List<Long> domainIds = new ArrayList<Long>();
        /**
         * 1、空间只有授权给外部人员本身或者外部人员所在外部单位的情况下才能看到该空间；
         * 2、外部人员默认拥有外部人员空间权限。
         */
        if(member.getIsInternal()){
            domainIds = orgManager.getAllUserDomainIDs(memberId);
        }else{
            domainIds = orgManager.getUserDomainIDs(memberId, AppContext.currentAccountId(), V3xOrgEntity.ORGENT_TYPE_MEMBER,V3xOrgEntity.ORGENT_TYPE_DEPARTMENT,V3xOrgEntity.ORGENT_TYPE_TEAM);
        }
		return spaceSecurityManager.isExitInSecurity(spaceId, domainIds);
	}

	@Override
	public List<PortalSpaceMenu> findSpaceMenusBySpaceId(Long spaceId) {
		return portalCacheManager.getPortalSpaceMenuCacheByKey(spaceId);
	}
	public void setPortalMenuManager(PortalMenuManager portalMenuManager) {
		this.portalMenuManager = portalMenuManager;
	}
	@Override
	public PortalSpaceFix transCreateDefaultWeiXinPersonalSpace(Long accountId) throws BusinessException {
        String pagePath = Constants.WEIXINMOBILE_FOLDER + accountId + "_D" + Constants.DOCUMENT_TYPE;
        PortalSpaceFix spaceFix = this.getSpaceFix(pagePath);
        if (spaceFix != null) {
            return spaceFix;
        } else {
            String srcPagePath = Constants.DEFAULT_WEIXINMOBILE_PAGE_PATH;
            spaceFix = transCreateDefaultSpace(Constants.SpaceType.weixinmobile, true, true, accountId, srcPagePath, pagePath, null, accountId);
            spaceFix.setDefaultspace(1);
            //默认开启个性化
            String extProperties = spaceFix.getExtAttributes();
            SpaceFixUtil fixUtil = new SpaceFixUtil(extProperties);
            fixUtil.setAllowdefined(true);
            extProperties = fixUtil.getExtAttributes();
            spaceFix.setExtAttributes(extProperties);
            this.updateSpace(spaceFix);

            PortalSpaceSecurity spaceSecurity = new PortalSpaceSecurity();
            spaceSecurity.setNewId();
            spaceSecurity.setSpaceId(spaceFix.getId());
            spaceSecurity.setSecurityType(Constants.SecurityType.used.ordinal());
            spaceSecurity.setEntityType(V3xOrgEntity.ORGENT_TYPE_ACCOUNT);
            spaceSecurity.setEntityId(accountId);
            DBAgent.save(spaceSecurity);

            List<PortalSpaceSecurity> securities = new ArrayList<PortalSpaceSecurity>();
            securities.add(spaceSecurity);
            fireCreateSpaceEvent(this, spaceFix, securities);
        }
        return spaceFix;
    }
	@Override
	public PortalSpaceFix transCreateDefaultWeiXinLeaderSpace(Long accountId) throws BusinessException {
        String pagePath = Constants.WEIXINMOBILE_LEADER_FOLDER + accountId + "_Leader" + Constants.DOCUMENT_TYPE;
        PortalSpaceFix spaceFix = this.getSpaceFix(pagePath);
        if (spaceFix != null) {
            return spaceFix;
        } else {
            String srcPagePath = Constants.DEFAULT_WEIXINMOBILE_LEADER_PAGE_PATH;
            spaceFix = transCreateDefaultSpace(Constants.SpaceType.weixinmobile_leader, true, true, accountId, srcPagePath, pagePath, null, accountId);
            spaceFix.setDefaultspace(1);
            //默认开启个性化
            String extProperties = spaceFix.getExtAttributes();
            SpaceFixUtil fixUtil = new SpaceFixUtil(extProperties);
            fixUtil.setAllowdefined(true);
            extProperties = fixUtil.getExtAttributes();
            spaceFix.setExtAttributes(extProperties);
            this.updateSpace(spaceFix);
            fireCreateSpaceEvent(this, spaceFix, null);
        }
        return spaceFix;
    }
	@Override
	public PortalSpaceFix transCreateDefaultM3PersonalSpace(Long accountId) throws BusinessException {
		String pagePath = Constants.M3MOBILE_FOLDER + accountId + "_D" + Constants.DOCUMENT_TYPE;
        PortalSpaceFix spaceFix = this.getSpaceFix(pagePath);
        if (spaceFix != null) {
            return spaceFix;
        } else {
            String srcPagePath = Constants.DEFAULT_M3MOBILE_PAGE_PATH;
            spaceFix = transCreateDefaultSpace(Constants.SpaceType.m3mobile, true, true, accountId, srcPagePath, pagePath, null, accountId);
            spaceFix.setDefaultspace(1);
            //默认开启个性化
            String extProperties = spaceFix.getExtAttributes();
            SpaceFixUtil fixUtil = new SpaceFixUtil(extProperties);
            fixUtil.setAllowdefined(true);
            extProperties = fixUtil.getExtAttributes();
            spaceFix.setExtAttributes(extProperties);
            this.updateSpace(spaceFix);

            PortalSpaceSecurity spaceSecurity = new PortalSpaceSecurity();
            spaceSecurity.setNewId();
            spaceSecurity.setSpaceId(spaceFix.getId());
            spaceSecurity.setSecurityType(Constants.SecurityType.used.ordinal());
            spaceSecurity.setEntityType(V3xOrgEntity.ORGENT_TYPE_ACCOUNT);
            spaceSecurity.setEntityId(accountId);
            DBAgent.save(spaceSecurity);

            List<PortalSpaceSecurity> securities = new ArrayList<PortalSpaceSecurity>();
            securities.add(spaceSecurity);
            fireCreateSpaceEvent(this, spaceFix, securities);
        }
        return spaceFix;
	}
	@Override
	public PortalSpaceFix transCreateDefaultM3LeaderSpace(Long accountId) throws BusinessException {
        String pagePath = Constants.M3MOBILE_LEADER_FOLDER + accountId + "_Leader" + Constants.DOCUMENT_TYPE;
        PortalSpaceFix spaceFix = this.getSpaceFix(pagePath);
        if (spaceFix != null) {
            return spaceFix;
        } else {
            String srcPagePath = Constants.DEFAULT_M3MOBILE_LEADER_PAGE_PATH;
            spaceFix = transCreateDefaultSpace(Constants.SpaceType.m3mobile_leader, true, true, accountId, srcPagePath, pagePath, null, accountId);
            spaceFix.setDefaultspace(1);
            //默认开启个性化
            String extProperties = spaceFix.getExtAttributes();
            SpaceFixUtil fixUtil = new SpaceFixUtil(extProperties);
            fixUtil.setAllowdefined(true);
            extProperties = fixUtil.getExtAttributes();
            spaceFix.setExtAttributes(extProperties);
            this.updateSpace(spaceFix);
            fireCreateSpaceEvent(this, spaceFix, null);
        }
        return spaceFix;
    }
    public List<String[]> getMobileSpace(User user) throws BusinessException {
    	Long accountId = user.getLoginAccount();
    	
        if(user.isAdmin()){
            return new ArrayList<String[]>(0);
        }
        List<Long> domainIds = new ArrayList<Long>();
        /**
         * 1、空间只有授权给外部人员本身或者外部人员所在外部单位的情况下才能看到该空间；
         * 2、外部人员默认拥有外部人员空间权限。
         */
        if(user.isInternal()){
            domainIds = orgManager.getAllUserDomainIDs(user.getId());
        }else{
            domainIds = orgManager.getUserDomainIDs(user.getId(), accountId, V3xOrgEntity.ORGENT_TYPE_MEMBER,V3xOrgEntity.ORGENT_TYPE_DEPARTMENT,V3xOrgEntity.ORGENT_TYPE_TEAM);
        }
        
        List<PortalSpaceFix> accessSpaces = spaceDao.getMobileSpace(accountId, domainIds);
        if (!user.isInternal()) {
            PortalSpaceFix weixinmobile = this.getSpaceFix(Constants.WEIXINMOBILE_FOLDER + accountId + "_D" + Constants.DOCUMENT_TYPE);
            PortalSpaceFix m3mobile = this.getSpaceFix(Constants.M3MOBILE_FOLDER + accountId + "_D" + Constants.DOCUMENT_TYPE);

            if (CollectionUtils.isEmpty(accessSpaces)) {
                accessSpaces = new ArrayList<PortalSpaceFix>();
            }
            if (weixinmobile != null) {
                accessSpaces.add(weixinmobile);
            }
            if (m3mobile != null) {
                accessSpaces.add(m3mobile);
            }
        }
        if (CollectionUtils.isEmpty(accessSpaces)) {
            return new ArrayList<String[]>(0);
        }
        Collections.sort(accessSpaces, new Comparator<PortalSpaceFix>() {
            @Override
            public int compare(PortalSpaceFix o1, PortalSpaceFix o2) {
                if (o1 == null || o2 == null) {
                    return -1;
                }
                long id1 = o1.getSortId();
                long id2 = o2.getSortId();
                if (id1 > id2) {
                    return 1;
                } else if (id1 < id2) {
                    return -1;
                } else {
                    return o1.getId() > o2.getId() ? 1 : -1;
                }
            }
        });
        //要返回的空间结果集
        LinkedList<String[]> resultList = new LinkedList<String[]>();
        //去除被个性化的空间-start
        Map<Long, PortalSpaceFix> spaceMap = new LinkedHashMap<Long, PortalSpaceFix>();
        for (PortalSpaceFix space : accessSpaces) {
            spaceMap.put(space.getId(), space);
        }
        for (PortalSpaceFix space : accessSpaces) {
            Long parentSpaceId = space.getParentId();
            if (parentSpaceId != null) {
            	if(spaceMap.containsKey(parentSpaceId)){
            	    //如果父空间在可访问空间中，则去掉父空间
            	    spaceMap.remove(parentSpaceId);
            	}else{
                    //如果父空间不在可访问空间中，则去掉该空间的访问
            	    spaceMap.remove(space.getId());
            	}
            }
        }
        //去除被个性化的空间-end
        
        Iterator<PortalSpaceFix> itr = spaceMap.values().iterator();
        while (itr.hasNext()) {
            PortalSpaceFix space = itr.next();
            Long currentSpaceAccountId = space.getAccountId();
            if (!currentSpaceAccountId.equals(accountId)) {
                continue;
            }
            Long sortId = space.getSortId();
            String sort = "0";
            if (sortId != null) {
                sort = String.valueOf(sortId);
            }
            String spaceName = ResourceUtil.getString(space.getSpacename());
            String parentId = null;
            if(space.getParentId()!=null){
                parentId = String.valueOf(space.getParentId());
                String _name = getParentSpaceName(space.getParentId());
                if(null != _name){
                    spaceName = _name;
                }
            }

            SpaceType s_Type = EnumUtil.getEnumByOrdinal(SpaceType.class, space.getType());
            SpaceType spaceType = Constants.parseDefaultSpaceType(s_Type);
            String spaceIcon="";//移动先不用空间图标
            String[] objStr = { String.valueOf(space.getId()), parentId, space.getPath(), spaceName, String.valueOf(SpaceState.normal.ordinal()), sort, String.valueOf(space.getType()), "2", spaceIcon, space.getAccountId().toString()};
            resultList.add(objStr);
        }
        return resultList;
    }
    /**
     * 获取用户移动空间排序信息
     * @param memberIds 用户ID列表
     * @param spaceCategory 空间分类
     * @return Map<用户ID,Map<单位ID,Map<排序号,Map<String,Object>>>>
     * @throws BusinessException
     */
    private Map<Long,CtpCustomize> getMobileSpaceSortByMemberId(List<Long> memberIds,String spaceCategory) throws BusinessException{
        List<CtpCustomize> resultList = new ArrayList<CtpCustomize>();
        if(Strings.isNotEmpty(memberIds)){
            List<Long>[] arrSplited = Strings.splitList(memberIds, 1000);
            for(List<Long> idList : arrSplited){
                resultList.addAll(customizeManager.getCustomizeInfo(idList, spaceCategory+"_leader_space"));
            }
        }
        Map<Long,CtpCustomize> customizeInfo = new HashMap<Long,CtpCustomize>();
        for(CtpCustomize customize : resultList){
            if(customize!=null){
                customizeInfo.put(customize.getUserId(), customize);
            }
        }
        return customizeInfo;
    }
    /**
     * 推送移动领导空间
     * @param space
     * @param members
     * @param accountId
     * @throws BusinessException
     */
    @Override
    public void pushMobileLeaderSpace(PortalSpaceFix space, List<V3xOrgMember> members, Long accountId, String spaceCategory) throws BusinessException{
    	Long spaceId = space.getId();
        if(spaceId==null||accountId==null){
            return;
        }
        if(CollectionUtils.isEmpty(members)){
            return;
        }
        List<Long> memberIds = new ArrayList<Long>();
        for(V3xOrgMember member:members){
            memberIds.add(member.getId());
        }
        Map<Long, CtpCustomize> customizeInfo = this.getMobileSpaceSortByMemberId(memberIds,spaceCategory);
        //待新建的用户个性化信息队列
        List<CtpCustomize> saveCustomizes = new ArrayList<CtpCustomize>();
        Date now = DateUtil.currentDate();
        for(V3xOrgMember member : members){
            Long memberId = member.getId();
            //获取该user的spaceCategory+"_leader_space"对应的CtpCustomize
            CtpCustomize ctpCustomizeForUserSpaceOrder = customizeInfo.get(memberId);
            if(ctpCustomizeForUserSpaceOrder == null){//已推送过的不再推
                //如果该user没有自定义过排序
                ctpCustomizeForUserSpaceOrder = new CtpCustomize();
                ctpCustomizeForUserSpaceOrder.setIdIfNew();
                ctpCustomizeForUserSpaceOrder.setCkey(spaceCategory+"_leader_space");
                ctpCustomizeForUserSpaceOrder.setCvalue("1");//表示已推送移动领导空间
                ctpCustomizeForUserSpaceOrder.setUserId(memberId);
                ctpCustomizeForUserSpaceOrder.setCreateDate(now);
                ctpCustomizeForUserSpaceOrder.setUpdateDate(now);
                saveCustomizes.add(ctpCustomizeForUserSpaceOrder);
            }
        }
        if(!CollectionUtils.isEmpty(saveCustomizes)){
            customizeManager.saveAllCustomizeInfo(saveCustomizes);
        }
    }
}