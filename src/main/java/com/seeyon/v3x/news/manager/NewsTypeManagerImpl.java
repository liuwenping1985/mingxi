package com.seeyon.v3x.news.manager;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.cluster.notification.NotificationManager;
import com.seeyon.ctp.cluster.notification.NotificationType;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.portal.po.PortalSpaceFix;
import com.seeyon.ctp.portal.space.manager.SpaceManager;
import com.seeyon.ctp.portal.util.Constants.SecurityType;
import com.seeyon.ctp.portal.util.Constants.SpaceType;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.Strings;
import com.seeyon.v3x.news.dao.NewsTypeDao;
import com.seeyon.v3x.news.domain.NewsType;
import com.seeyon.v3x.news.domain.NewsTypeManagers;
import com.seeyon.v3x.news.util.Constants;
import com.seeyon.v3x.news.util.NewsUtils;

public class NewsTypeManagerImpl implements NewsTypeManager {

    private static final Log              log              = LogFactory.getLog(NewsTypeManagerImpl.class);
    // Map<bulTypeId, BulType>
    private static Map<Long, NewsType>    typesMap         = null;
    // Map<memberId, Set<BulTypeId>>
    private static Map<Long, Set<Long>>   writerMap        = null;
    // Map<memberId, Set<BulTypeId>>
    private static Map<Long, Set<Long>>   managerMap       = null;
    // Map<memberId, Set<BulTypeId>>
    private static Map<Long, Set<Long>>   auditMap         = null;
    //客开start
    private static Map<Long, Set<Long>>   typesettingMap   = null;
    //客开end
    // Map<accountId, Set<typeName>> 集团id用 -1 代表， 不包含部门
    public static final Long              GROUP_ACCOUNT_ID = -1L;
    private static Map<Long, Set<String>> nameMap          = null;
    private static boolean                initialized      = false;
    private OrgManager                    orgManager;
    private SpaceManager                  spaceManager;
    private NewsUtils                     newsUtils;
    NewsTypeManagersManager               newsTypeManagersManager;
    private NewsTypeDao                   newsTypeDao;

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void setSpaceManager(SpaceManager spaceManager) {
        this.spaceManager = spaceManager;
    }

    public NewsUtils getNewsUtils() {
        return newsUtils;
    }

    public void setNewsUtils(NewsUtils newsUtils) {
        this.newsUtils = newsUtils;
    }

    public void setNewsTypeManagersManager(NewsTypeManagersManager newsTypeManagersManager) {
        this.newsTypeManagersManager = newsTypeManagersManager;
    }

    public void setNewsTypeDao(NewsTypeDao newsTypeDao) {
        this.newsTypeDao = newsTypeDao;
    }

    public synchronized void init() {
        long start = System.currentTimeMillis();

        if (initialized) {
            return;
        }

        typesMap = new HashMap<Long, NewsType>();
        writerMap = new HashMap<Long, Set<Long>>();
        managerMap = new HashMap<Long, Set<Long>>();
        auditMap = new HashMap<Long, Set<Long>>();
        //客开 s
        typesettingMap = new HashMap<Long, Set<Long>>();
        //客开e
        Map<Long, Set<NewsTypeManagers>> managers = new HashMap<Long, Set<NewsTypeManagers>>();
        List<NewsTypeManagers> managerList = newsTypeManagersManager.getAllNewsTypeManagers();
        if (Strings.isNotEmpty(managerList)) {
            for (NewsTypeManagers manager : managerList) {
                Set<NewsTypeManagers> set = managers.get(manager.getTypeId());
                if (set == null) {
                    set = new HashSet<NewsTypeManagers>();
                    managers.put(manager.getTypeId(), set);
                }
                set.add(manager);
            }
        }

        List<NewsType> typeList = this.newsTypeDao.getAll();
        if (Strings.isNotEmpty(typeList)) {
            for (NewsType type : typeList) {
                type.setNewsTypeManagers(managers.get(type.getId()));
                typesMap.put(type.getId(), type);
                this.addAclOfType(type);
            }
        }
        this.initStaticNoObj();

        initialized = true;

        log.info("加载所有新闻板块信息. 耗时: " + (System.currentTimeMillis() - start) + " MS");
    }

    /**
     * 获取全部板块信息
     * @return
     */
    public Collection<NewsType> getAllNewsTypes() {
        return typesMap.values();
    }

    private void addName(NewsType type) {
        if (type == null) {
            return;
        }
        if (type.isUsedFlag()) {
            if (type.getSpaceType().intValue() == SpaceType.corporation.ordinal()) {
                this.putStringMap(nameMap, type.getAccountId(), type.getTypeName());
            } else if (type.getSpaceType().intValue() == SpaceType.group.ordinal()) {
                this.putStringMap(nameMap, GROUP_ACCOUNT_ID, type.getTypeName());
            }
        }
    }

    private void putStringMap(Map<Long, Set<String>> map, Long key, String value) {
        if (map == null || key == null || value == null) {
            return;
        }

        Set<String> set = map.get(key);
        if (set == null) {
            set = new HashSet<String>();
        }
        set.add(value);
        map.put(key, set);
    }

    private void addAclOfType(NewsType type) {
        if (type == null) {
            return;
        }

        long newsTypeId = type.getId();
        if (type.getNewsTypeManagers() == null) {
            type.setNewsTypeManagers(new HashSet<NewsTypeManagers>());
        }
        for (NewsTypeManagers ntm : type.getNewsTypeManagers()) {
            if (Constants.MANAGER_FALG.equals(ntm.getExt1())) {
                this.putMap(managerMap, ntm.getManagerId(), newsTypeId);
            } else if (Constants.WRITE_FALG.equals(ntm.getExt1())) {
                this.putMap(writerMap, ntm.getManagerId(), newsTypeId);
            }
        }
        if (type.isAuditFlag()) {
            this.putMap(auditMap, type.getAuditUser(), newsTypeId);
        }
        //客开s
        if (type.isTypesettingFlag()) {
          this.putMap(typesettingMap, type.getTypesettingStaff(), newsTypeId);
        }
        //客开e
    }

    private void putMap(Map<Long, Set<Long>> map, Long key, Long value) {
        if (map == null || key == null || value == null) {
            return;
        }

        Set<Long> set = map.get(key);
        if (set == null) {
            set = new HashSet<Long>();
        }
        set.add(value);
        map.put(key, set);
    }

    public synchronized void initPartAdd(NewsType newsType) {
        if (newsType == null) {
            return;
        }
        initialized = false;
        typesMap.put(newsType.getId(), newsType);
        this.addAclOfType(newsType);
        this.addName(newsType);
        this.initStaticNoObj();
        initialized = true;
        // 发送通知
        NotificationManager.getInstance().send(NotificationType.NewsAddType, newsType);
    }

    private void deleteAclOfType(Long typeId) {
        if (typeId == null) {
            return;
        }
        this.deleteFromMap(writerMap, typeId);
        this.deleteFromMap(managerMap, typeId);
        this.deleteFromMap(auditMap, typeId);
        //客开s
        this.deleteFromMap(typesettingMap, typeId);
        //客开e
    }

    @SuppressWarnings({ "unchecked", "rawtypes" })
    private void deleteFromMap(Map<Long, Set<Long>> map, Long typeId) {
        if (map == null) {
            map = new HashMap<Long, Set<Long>>();
        }
        Set<Map.Entry<Long, Set<Long>>> mapSet = map.entrySet();
        for (Iterator iter = mapSet.iterator(); iter.hasNext();) {
            Map.Entry<Long, Set<Long>> element = (Map.Entry<Long, Set<Long>>) iter.next();
            if (element.getValue() != null) {
                element.getValue().remove(typeId);
            }
        }
    }

    public synchronized void initPartEdit(NewsType newsType) {
        if (newsType == null) {
            return;
        }
        initialized = false;
        typesMap.put(newsType.getId(), newsType);
        this.deleteAclOfType(newsType.getId());
        this.addAclOfType(newsType);
        this.initStaticNoObj();
        initialized = true;
        // 发送通知
        NotificationManager.getInstance().send(NotificationType.NewsUpdateType, newsType);
    }

    private void initStaticNoObj() {
        nameMap = new HashMap<Long, Set<String>>();
        Collection<NewsType> values = typesMap.values();
        for (NewsType bt : values) {
            this.addName(bt);
            this.setStaticOthers(bt);
        }
    }

    private void setStaticOthers(NewsType type) {
        type.setManagerUserIds("");
        //管理员
        String ids = "";

        List<NewsTypeManagers> sortedList = new ArrayList<NewsTypeManagers>();
        for (NewsTypeManagers tm : type.getNewsTypeManagers()) {
            if (!Constants.MANAGER_FALG.equals(tm.getExt1())) {
                continue;
            }
            sortedList.add(tm);
        }
        Collections.sort(sortedList);

        for (NewsTypeManagers tm : sortedList) {
            ids = ids + "," + tm.getManagerId();
        }
        type.setManagerUserIds(ids.length() > 0 ? ids.substring(1) : "");
    }

	public List<NewsType> findAll(long loginAccount) {
		List<NewsType> list = new ArrayList<NewsType>();
		this.checkTypesMap();
		for(NewsType bt : typesMap.values()){
			if(bt.getAccountId().longValue() == loginAccount
					&& bt.getSpaceType().intValue() == SpaceType.corporation.ordinal()
					&& bt.isUsedFlag())
				list.add(bt);
		}
		
		this.sortList(list);
		return list;
	}

    public List<NewsType> findAccountNewsTypes(Long accountId) {
        this.checkTypesMap();

        List<NewsType> list = new ArrayList<NewsType>();
        for (NewsType bt : typesMap.values()) {
            if (bt.isUsedFlag() && bt.getAccountId().equals(accountId) 
                    && bt.getSpaceType() != SpaceType.custom.ordinal()) {
                list.add(bt);
            }
        }

        this.sortList(list);
        return list;
    }

	/**
	 * 获取自定义单位/集团所有的新闻板块
	 * @param spaceId
	 * @param spaceType
	 * @return
	 */
	public List<NewsType> findAllOfCustomAcc(long spaceId, int spaceType) {
		List<NewsType> list = new ArrayList<NewsType>();
		this.checkTypesMap();
		for(NewsType bt : typesMap.values()){
			if(bt.getAccountId().longValue() == spaceId
					&& bt.getSpaceType().intValue() == spaceType
					&& bt.isUsedFlag())
				list.add(bt);
		}
		
		this.sortList(list);
		return list;
	}
	
	public List<NewsType> findAllOfCustom(long spaceId, String spaceType) {
		List<NewsType> list = new ArrayList<NewsType>();
		this.checkTypesMap();
		if ("custom".equals(spaceType)) {
			for(NewsType bt : typesMap.values()){
				if(bt.getAccountId().longValue() == spaceId
						&& bt.getSpaceType().intValue() ==SpaceType.custom.ordinal()
						&& bt.isUsedFlag()){
				    Set<NewsTypeManagers> manager = new HashSet<NewsTypeManagers>();
				    List<V3xOrgMember> managerUser;
                    try {
                        managerUser = spaceManager.getSpaceMemberBySecurity(bt.getId(), 1);
                        for(V3xOrgMember org : managerUser){
                            NewsTypeManagers nt = new NewsTypeManagers();
                            nt.setExt1("manager");
                            nt.setExt2("Member");
                            nt.setManagerId(org.getId());
                            manager.add(nt);
                        }
                    } catch (BusinessException e) {
                        log.error("", e);
                    }
				    bt.setNewsTypeManagers(manager);
				    list.add(bt);
				}
			}
		} else if ("publicCustom".equals(spaceType)) {
			for(NewsType bt : typesMap.values()){
				if(bt.getAccountId().longValue() == spaceId
						&& bt.getSpaceType().intValue() == SpaceType.public_custom.ordinal()
						&& bt.isUsedFlag())
					list.add(bt);
			}
		} else if ("publicCustomGroup".equals(spaceType)) {
			for(NewsType bt : typesMap.values()){
				if(bt.getAccountId().longValue() == spaceId
						&& bt.getSpaceType().intValue() == SpaceType.public_custom_group.ordinal()
						&& bt.isUsedFlag())
					list.add(bt);
			}
		}
		this.sortList(list);
		return list;
	}
	
	public List<NewsType> findCustomNewsTypeByUnitId(long unitId) {
	    List<NewsType> list = new ArrayList<NewsType>();
        this.checkTypesMap();
        for(NewsType newsType : typesMap.values()){
            PortalSpaceFix space = spaceManager.getSpaceFix(newsType.getAccountId());
            boolean custom = newsType.getSpaceType() == SpaceType.custom.ordinal() || newsType.getSpaceType() == SpaceType.public_custom.ordinal() || newsType.getSpaceType() == SpaceType.public_custom_group.ordinal();
            if (space != null && space.getEntityId() == unitId && newsType.isUsedFlag() && custom) {
                list.add(newsType);
            }
        }
        this.sortList(list);
        return list;
	}
	
	/**
	 * 这个是为了保留以前的方法,将来会删除的
	 * @return
	 */
	public List<NewsType> findAll() {
		List<NewsType> list = new ArrayList<NewsType>();
		this.checkTypesMap();
		for(NewsType bt : typesMap.values()){
			if(bt.getAccountId().longValue() == AppContext.getCurrentUser().getLoginAccount()
					&& bt.getSpaceType().intValue() == SpaceType.corporation.ordinal()
					&& bt.isUsedFlag())
				list.add(bt);
		}
		
		this.sortList(list);
		return list;
	}
	
	
	/**
	 * 
	 * 查询所有的单位新闻板块---分页
	 * 
	 */
	public List<NewsType> findAllByPage(long loginAccount) {
		List<NewsType> list = this.findAll(loginAccount);
		List<NewsType> subList = this.getNewsUtils().paginate(list);		
		return subList;
	}
	
	/**
	 * 查询所有的自定义单位新闻板块
	 */
	public List<NewsType> findAllByCustomAccId(long spaceId, int spaceType, boolean isPage) {
		List<NewsType> list = this.findAllOfCustomAcc(spaceId, spaceType);
		if (isPage) {
			List<NewsType> subList = this.getNewsUtils().paginate(list);
			return subList;
		}
		return list;
	}
	
	public List<NewsType> groupFindAll() {
		List<NewsType> list = new ArrayList<NewsType>();
		this.checkTypesMap();
		for(NewsType bt : typesMap.values()){
			if(bt.getSpaceType().intValue() == SpaceType.group.ordinal()
					&& bt.isUsedFlag())
				list.add(bt);
		}
		
		this.sortList(list);
		return list;
	}
	
	

	/**
	 * 
	 * 查询所有的集团新闻板块--分页
	 * 
	 */
	public List<NewsType> groupFindAllByPage() {
		List<NewsType> all = this.groupFindAll();
		List<NewsType> list = this.getNewsUtils().paginate(all);		
		return list;
	}
	
	/* (non-Javadoc)
	 * @see com.seeyon.v3x.news.manager.NewsTypeManager#findByProperty(java.lang.String, java.lang.Object)
	 */
	public List<NewsType> findByProperty(String property, Object value,long loginAccount) {
		List<NewsType> all = this.findByPropertyNoPaging(property, value,loginAccount);
		return this.getNewsUtils().paginate(all);
	}
	public List<NewsType> findByPropertyNoPaging(String property, Object value,long loginAccount) {
		List<NewsType> list = this.findAll(loginAccount);
		list = this.filterByProperty(list, property, value);
		return list;
	}
	
	public List<NewsType> groupFindByProperty(String property, Object value) {
		List<NewsType> src = this.groupFindAll();
		src = this.filterByProperty(src, property, value);
		List<NewsType> list = this.getNewsUtils().paginate(src);
		return list;
	}

	/* (non-Javadoc)
	 * @see com.seeyon.v3x.news.manager.NewsTypeManager#getById(java.lang.Long)
	 */
	public NewsType getById(Long id) {
		this.checkTypesMap();
		NewsType type = typesMap.get(id);
		if(type == null){
			return null;
		}
		return type;
	}

    public NewsType save(NewsType type, boolean isNewParam) throws BusinessException {
        boolean isNew = false;
        if (isNewParam || type.isNew()) {
            isNew = true;
            type.setIdIfNew();
            if (type.getAccountId() == null) {
                type.setAccountId(AppContext.currentAccountId());
            }
            if (type.getCreateDate() == null) {
                type.setCreateDate(new Date());
            }
            type.setUsedFlag(true);
            newsTypeDao.save(type);
        } else {
            newsTypeDao.update(type);
        }

        // 保存新闻管理员
        String[] manages = new String[0];
        if (Strings.isNotBlank(type.getManagerUserIds())) {
            manages = type.getManagerUserIds().split(",");
        }
        newsTypeManagersManager.saveAclByTypeManager(type, manages, Constants.MANAGER_FALG);

        // 内存加载
        if (isNew) {
            this.initPartAdd(type);
        } else {
            this.initPartEdit(type);
        }
        return type;
    }

	/* (non-Javadoc)
	 * @see com.seeyon.v3x.news.manager.NewsTypeManager#saveWriteByType(java.lang.Long, java.lang.Long[])
	 */
	public void saveWriteByType(Long typeId,String[][] writeIds){
		NewsType type=this.getById(typeId);
		newsTypeManagersManager.saveAclByType(type, writeIds, Constants.WRITE_FALG);//.saveWriteByType(type, writeIds);
		
		// 内存同步
		this.initPartEdit(type);
	}

	public boolean isGroupNewsTypeManager(long memberId){
		this.checkTypesMap();
		Set<Long> set = managerMap.get(memberId);
		return this.spaceTypeChecked(set, SpaceType.group);
	}
	private boolean spaceTypeChecked(Collection<Long> typeIds, SpaceType spaceType){
		if(typeIds == null || spaceType == null)
			return false;		
		
		for(Long id : typeIds){
			NewsType bt = typesMap.get(id);
			if(bt == null)
				continue;
			if(bt.getSpaceType().intValue() == spaceType.ordinal())
				return true;
		}
		
		return false;
	}
	
	public boolean isGroupNewsTypeAuth(long memberId){
		this.checkTypesMap();
		Set<Long> set = auditMap.get(memberId);
		return this.spaceTypeChecked(set, SpaceType.group);
	}
	
	public List<NewsType> getAuditGroupNewsTypeNoPaging(long memberId){
		return this.getAclTypeByMember(memberId, SpaceType.group, null, Constants.NewsTypeAclType.audit);
	}
	//取的有我来审核的集团新闻板块
	public List<NewsType> getAuditUnitNewsTypeNoPaging(long memberId){
		return this.getAclTypeByMember(memberId, SpaceType.corporation, AppContext.getCurrentUser().getLoginAccount(), Constants.NewsTypeAclType.audit);
	}
	
	public List<NewsType> getCustomAuditUnitNewsTypeNoPaging(long userId, long spaceId, int spaceType) {
		if (spaceType == SpaceType.public_custom.ordinal()) {
			return this.getAclTypeByMember(userId, SpaceType.public_custom, spaceId, Constants.NewsTypeAclType.audit);
		} else {
			return this.getAclTypeByMember(userId, SpaceType.public_custom_group, spaceId, Constants.NewsTypeAclType.audit);
		}
	}
	
	public List<NewsType> getAuditUnitNewsTypeOnlyByMember(long memberId){
		return this.getAclTypeByMember(memberId, SpaceType.corporation, null, Constants.NewsTypeAclType.audit);
	}
	
	/**
	 * 初始化类型下总数
	 */
	@SuppressWarnings("rawtypes")
	public void setTotalItemsOfType(List<NewsType> types){
		if(Strings.isNotEmpty(types)){
		    return;
		}
		
		List<Long> typeIds = new ArrayList<Long>();
		Map<Long, Integer> countMap = new HashMap<Long, Integer>();
		for(NewsType t : types){
			typeIds.add(t.getId());
			countMap.put(t.getId(), 0);
		}
		
		try{
			
		    Map<String,Object> parameter = new HashMap<String,Object>();
			final String hqlf = "select data.typeId from NewsData as data where data.typeId in (:typeId) "
				+ " and data.state=:state" 
				+ " and data.deletedFlag=false ";
			parameter.put("typeId", typeIds);
            parameter.put("state", Constants.DATA_STATE_ALREADY_PUBLISH);
            
			List list = newsTypeDao.find(hqlf, -1, -1, parameter);
			/*List list = (List)newsTypeDao.getHibernateTemplate().execute(new HibernateCallback(){
				public Object doInHibernate(Session session) throws HibernateException, SQLException {
					return session.createQuery(hqlf).list();
				}
	    	});*/
						
			for(Object o : list){
				Long typeId = (Long)o;
				countMap.put(typeId, countMap.get(typeId) + 1);
			}
	
			for(NewsType t : types){
				Integer total = countMap.get(t.getId());
				if(total == null)
					continue;
				t.setTotalItems(total);
			}
		}catch(Exception e){
		}
	}
	
	/**
	 * 逻辑删除版块
	 */
	public void setTypeDeleted(List<Long> ids){
		if(Strings.isEmpty(ids)){
		    return;
		}
		
        for (Long id : ids) {
            NewsType bt = this.getById(id);
            bt.setUsedFlag(false);
            this.newsTypeDao.update(bt);
            this.initPartEdit(bt);
        }
	}

    /**
     * 用于新建单位时初始化新闻版块
     */
    public void initNewsType(long accountId) {
        int count = newsTypeDao.getAccountSystemType(accountId);
        if (count > 0) {
            return;
        }

        List<NewsType> types = newsTypeDao.getSystemType();
        if (types != null) {
            Date today = new Date();
            for (NewsType type : types) {
                today = Datetimes.addMinute(today, 1);
                NewsType newType = new NewsType();
                newType.setAccountId(accountId);
                newType.setAuditFlag(type.isAuditFlag());
                newType.setAuditUser(type.getAuditUser());
                newType.setCreateDate(today);
                newType.setCreateUser(type.getCreateUser());
                newType.setSpaceType(type.getSpaceType());
                newType.setTopCount(type.getTopCount());
                newType.setTypeName(type.getTypeName());
                newType.setUpdateDate(today);
                newType.setUsedFlag(true);
                newType.setOutterPermit(type.getOutterPermit());
                newType.setCommentPermit(type.getCommentPermit());
                //客开 start
                newType.setTypesettingFlag(type.isTypesettingFlag());
                newType.setTypesettingStaff(type.getTypesettingStaff());
                //客开 end
                try {
                    this.save(newType, true);
                } catch (BusinessException e) {
                }
            }
        }
    }

    private List<NewsType> getAclTypeByMember(Long memberId, SpaceType spaceType, Long accountId,
            Constants.NewsTypeAclType aclType) {
        List<NewsType> ret = new ArrayList<NewsType>();
        if (memberId == null || aclType == null) {
            return ret;
        }
        Map<Long, Set<Long>> map = this.getAclMap(aclType);
        Set<Long> set = new HashSet<Long>();

        List<Long> orgIds = null;
        try {
            orgIds = orgManager.getUserDomainIDs(memberId, V3xOrgEntity.VIRTUAL_ACCOUNT_ID,
                    V3xOrgEntity.ORGENT_TYPE_ACCOUNT, V3xOrgEntity.ORGENT_TYPE_DEPARTMENT,
                    V3xOrgEntity.ORGENT_TYPE_TEAM, V3xOrgEntity.ORGENT_TYPE_POST, V3xOrgEntity.ORGENT_TYPE_LEVEL,
                    V3xOrgEntity.ORGENT_TYPE_MEMBER);
        } catch (BusinessException e) {

        }

        if (orgIds != null) {
            for (long key : map.keySet()) {
                if (orgIds.contains(key))
                    set.addAll(map.get(key));

            }
        }
        Set<NewsType> src = this.getTypesByIds(set);
        if (spaceType == null) {
            for (NewsType bt : src) {
                if (bt.isUsedFlag()) {
                    if (accountId != null && bt.getAccountId().longValue() != accountId.longValue()) {
                        continue;
                    }
                    ret.add(bt);
                }
            }
        } else if (spaceType.ordinal() == SpaceType.corporation.ordinal()) {
            for (NewsType bt : src) {
                if (bt.getSpaceType().intValue() == SpaceType.corporation.ordinal() && bt.isUsedFlag()) {
                    if (accountId != null && bt.getAccountId().longValue() != accountId.longValue()) {
                        continue;
                    }
                    ret.add(bt);
                }
            }
        } else if (spaceType.ordinal() == SpaceType.group.ordinal()) {
            for (NewsType bt : src) {
                if (bt.getSpaceType().intValue() == SpaceType.group.ordinal() && bt.isUsedFlag()) {
                    ret.add(bt);
                }
            }
        } else if (spaceType.ordinal() == SpaceType.public_custom.ordinal()) {
            for (NewsType bt : src) {
                if (bt.getSpaceType().intValue() == SpaceType.public_custom.ordinal() && bt.isUsedFlag()) {
                    if (accountId != null && bt.getAccountId().longValue() != accountId.longValue()) {
                        continue;
                    }
                    ret.add(bt);
                }
            }
        } else if (spaceType.ordinal() == SpaceType.public_custom_group.ordinal()) {
            for (NewsType bt : src) {
                if (bt.getSpaceType().intValue() == SpaceType.public_custom_group.ordinal() && bt.isUsedFlag()) {
                    if (accountId != null && bt.getAccountId().longValue() != accountId.longValue()) {
                        continue;
                    }
                    ret.add(bt);
                }
            }
        }

        this.sortList(ret);

        return ret;
    }

	private List<NewsType> getAclTypeByMemberNotGroup(Long memberId, SpaceType spaceType, 
            Long accountId, Constants.NewsTypeAclType aclType){
        List<NewsType> ret = new ArrayList<NewsType>();
        if(memberId == null || aclType == null)
            return ret;
        Map<Long, Set<Long>> map = this.getAclMap(aclType);     
//      Set<Long> set = map.get(memberId);
        Set<Long> set = new HashSet<Long>();
        
        List<Long> orgIds=null;
        try {
            orgIds = orgManager.getUserDomainIDs(memberId, V3xOrgEntity.VIRTUAL_ACCOUNT_ID,
                    V3xOrgEntity.ORGENT_TYPE_ACCOUNT,
                    V3xOrgEntity.ORGENT_TYPE_DEPARTMENT,
                    V3xOrgEntity.ORGENT_TYPE_TEAM,
                    V3xOrgEntity.ORGENT_TYPE_POST,
                    V3xOrgEntity.ORGENT_TYPE_LEVEL,
                    V3xOrgEntity.ORGENT_TYPE_MEMBER);
        } catch (BusinessException e) {
            
        }
        
        if(orgIds != null){
            for(long key : map.keySet()){
                if(orgIds.contains(key))
                    set.addAll(map.get(key));
                
            }
        }
        Set<NewsType> src = this.getTypesByIds(set);
        if(spaceType == null){
            for(NewsType bt : src){
                if(bt.isUsedFlag() && bt.getSpaceType() != SpaceType.group.ordinal()){
                    ret.add(bt);
                }
            }
        }else if(spaceType.ordinal() == SpaceType.corporation.ordinal()){
            for(NewsType bt : src){
                if(bt.getSpaceType().intValue() == SpaceType.corporation.ordinal() && bt.isUsedFlag()){
                    if(accountId != null && bt.getAccountId().longValue() != accountId.longValue())
                        continue;
                    ret.add(bt);
                }
            }
        }else if(spaceType.ordinal() == SpaceType.group.ordinal()){
            for(NewsType bt : src){
                if(bt.getSpaceType().intValue() == SpaceType.group.ordinal() && bt.isUsedFlag()){
                    ret.add(bt);
                }
            }
        }else if(spaceType.ordinal() == SpaceType.public_custom.ordinal()){
            for(NewsType bt : src){
                if(bt.getSpaceType().intValue() == SpaceType.public_custom.ordinal() && bt.isUsedFlag()){
                    if(accountId != null && bt.getAccountId().longValue() != accountId.longValue())
                        continue;
                    ret.add(bt);
                }
            }
        }else if(spaceType.ordinal() == SpaceType.public_custom_group.ordinal()){
            for(NewsType bt : src){
                if(bt.getSpaceType().intValue() == SpaceType.public_custom_group.ordinal() && bt.isUsedFlag()){
                    if (accountId != null && bt.getAccountId().longValue() != accountId.longValue()) {
                        continue;
                    }
                    ret.add(bt);
                }
            }
        }
        
        this.sortList(ret);
        
        return ret;
    }
	private Map<Long, Set<Long>>  getAclMap(Constants.NewsTypeAclType aclType){
		this.checkTypesMap();
		int param = aclType.ordinal();
		if(param == Constants.NewsTypeAclType.manager.ordinal())
			return managerMap;
		else if(param == Constants.NewsTypeAclType.audit.ordinal())
			return auditMap;
		else if(param == Constants.NewsTypeAclType.writer.ordinal())
			return writerMap;
		else if(param == Constants.NewsTypeAclType.typesetting.ordinal())
          return typesettingMap;
		//客开 e
		return new HashMap<Long, Set<Long>>();
	}
	// 
	private Set<NewsType> getTypesByIds(Collection<Long> ids){
		Set<NewsType> set = new HashSet<NewsType>();
		if(ids == null)
			return set;
		this.checkTypesMap();
		for(Long id : ids){
			NewsType bt = typesMap.get(id);
			if(bt != null)
				set.add(bt);
		}
		return set;
	}
	private void checkTypesMap(){
		if(!initialized)
			this.init();
	}
	// 条件过滤
	private List<NewsType> filterByProperty(List<NewsType> list, String attribute, Object value){
		if(list == null || attribute == null || value == null)
			return list;
		
		List<NewsType> ret = new ArrayList<NewsType>();
		for(NewsType bt : list){
			Object trueVal = this.getNewsUtils().getAttributeValue(bt, attribute);
			if(trueVal == null)
				continue;
			boolean passed = false;
			if(value instanceof String){
				if(trueVal.toString().toLowerCase().indexOf(value.toString().toLowerCase()) != -1)
					passed = true;
			}else{
				if(value.equals(trueVal))
					passed = true;
			}
			if(passed)
				ret.add(bt);
		}
		
		return ret;
	}
	// 
	private void sortList(List<NewsType> list){
		if(list == null)
			return;
		Collections.sort(list);
	}
	
	
	/**
	 * 得到 writeFlag 的NewsTypeManagers
	 * 
	 */
	public List<NewsTypeManagers> findTypeWriters(NewsType bt) {
		List<NewsTypeManagers> ret = new ArrayList<NewsTypeManagers>();
		if(bt == null)
			return ret;
		Set<NewsTypeManagers> set = bt.getNewsTypeManagers();
		
		if(set != null)
			for(NewsTypeManagers btm : set){
				if(Constants.WRITE_FALG.equals(btm.getExt1()))
						ret.add(btm);
			}
		
		return ret;
	}
	
	/**
	 * 得到可以审核的版块列表
	 * 单位类型时，accountId 为 null 说明不验证单位
	 *
	 */
	public List<NewsType> getAuditTypeByMember(Long memberId, SpaceType spaceType, Long accountId){
		return this.getAclTypeByMember(memberId, spaceType, accountId, Constants.NewsTypeAclType.audit);
	}
	public List<NewsType> getManagerTypeByMember(Long memberId, SpaceType spaceType, Long accountId){
		return this.getAclTypeByMember(memberId, spaceType, accountId, Constants.NewsTypeAclType.manager);
	}
	public List<NewsType> getWriterTypeByMember(Long memberId, SpaceType spaceType, Long accountId){
		return this.getAclTypeByMember(memberId, spaceType, accountId, Constants.NewsTypeAclType.writer);
	}
	
	//客开 start
	public List<NewsType> getPaiBanTypeByMember(Long memberId, SpaceType spaceType, Long accountId){
      return this.getAclTypeByMember(memberId, spaceType, accountId, Constants.NewsTypeAclType.typesetting);
    }
	//客开 end
	
	/**
	 * 判断用户是否管理员
	 */
	public boolean isManagerOfType(long typeId, long userId){
		this.checkTypesMap();
		Set<Long> set = managerMap.get(userId);
		if(set == null)
			return false;
		return set.contains(typeId);
		
	}
	
	/**
	 * 用于更新新闻板块的排序顺序
	 */
	public void updateNewsTypeOrder(String[] newsTypeIds) {
		if (newsTypeIds == null) {
			return;
		}
		int i = 0;
		for (String newsTypeId : newsTypeIds) {
			i++;
			NewsType type = this.getById(Long.valueOf(newsTypeId));
			type.setSortNum(i);
			this.initPartEdit(type);
			newsTypeDao.update(type);
		}
	}
	
	/**
	 * 取得某个用户有新建权限的所有版块
	 */
	public List<NewsType> getTypesCanNew(Long memberId, SpaceType spaceType, Long accountId){
		List<NewsType> list2= new ArrayList<NewsType>();
		if(memberId == null)
			return list2;
		Set<NewsType> list1 = new HashSet<NewsType>();
		list1.addAll(this.getManagerTypeByMember(memberId, spaceType, accountId));
		list1.addAll(this.getWriterTypeByMember(memberId, spaceType, accountId));
		list1.addAll(this.getAuditTypeByMember(memberId, spaceType, accountId));
		list2.addAll(list1);
		return list2;
	}
	
	/**
	 * 判断用户是否有新建权限
	 */
	public boolean hasAuth(Long memberId, Long accountId){
		return CollectionUtils.isNotEmpty(getTypesCanNew(memberId, null, accountId));
	}
	
	public List<NewsType> getTypesCanNewByMember(Long memberId, SpaceType spaceType, Long accountId){
		List<NewsType> list2= new ArrayList<NewsType>();
		if(memberId == null)
			return list2;
		Set<NewsType> list1 = new HashSet<NewsType>();
		list1.addAll(this.getManagerTypeByMember(memberId, spaceType, accountId));
		list1.addAll(this.getWriterTypeByMember(memberId, spaceType, accountId));
		list2.addAll(list1);
		this.sortList(list2);
		return list2;
	}
	
	/**
	 * 按模块名称查询某用户有管理权限的模块
	 */
	public List<NewsType> getNewsTypeList(Long memberId ,String typename , boolean isIgnoreUsed ,int spaceType) {	
		 List<NewsType> newsTypeList = new ArrayList<NewsType>() ;
		 
		 try{
			 if(typename != null && "".equals(typename)){
				 if(spaceType == SpaceType.group.ordinal()){
					 newsTypeList = this.getManagerTypeByMember(memberId ,SpaceType.group, AppContext.getCurrentUser().getLoginAccount()) ;
				 }else if(spaceType == SpaceType.corporation.ordinal()){
					 newsTypeList = this.getManagerTypeByMember(memberId, SpaceType.corporation, AppContext.getCurrentUser().getLoginAccount()) ;
				 }else{
					 newsTypeList = this.getManagerTypeByMember(memberId, SpaceType.department, AppContext.getCurrentUser().getLoginAccount()) ;
				 }
			 }else{
				 List<NewsType> tmpList = this.newsTypeDao.getAllNewsType(memberId, typename) ;
				 Set<Long> newsTypeIds = new HashSet<Long>() ;
				 for(NewsType newstype : tmpList) {
					 if(newstype.isUsedFlag() && newstype.getSpaceType().intValue() == spaceType){
						 if(this.isManagerOfType(newstype.getId(), memberId)){
							 newsTypeIds.add(newstype.getId()) ;
						 }
					 }
				 }
				 newsTypeList.addAll(this.getTypesByIds(newsTypeIds)) ;
			 }
		 }catch(Exception e){
			 log.error("", e) ;
		 }
		 this.sortList(newsTypeList);
		 this.setTotalItemsOfType(newsTypeList) ;
		 return newsTypeList ;
	}
   /**
    * 按总数的查询
    */
	public List<NewsType> getNewsTypeList(Long memberId ,String num , String match, boolean isIgnoreUsed ,int spaceType) {
		
		List<NewsType> list = new ArrayList<NewsType>() ;
		try{
			List<NewsType> allList = new ArrayList<NewsType>() ;	
			//得到所有的列表
			 if(spaceType == SpaceType.group.ordinal()){
				 allList = this.getManagerTypeByMember(memberId ,SpaceType.group, AppContext.getCurrentUser().getLoginAccount()) ;
			 }else if(spaceType == SpaceType.corporation.ordinal()){
				 allList = this.getManagerTypeByMember(memberId, SpaceType.corporation, AppContext.getCurrentUser().getLoginAccount()) ;
			 }else{
				 allList = this.getManagerTypeByMember(memberId, SpaceType.department, AppContext.getCurrentUser().getLoginAccount()) ;
			 }
			 //数字为空
			 if(num !=null && "".equals(num)){
				 list.addAll(allList) ;
			 }else{
				 if(match != null && "equal".equals(match)){  //等于
					 for(NewsType newstype : allList){
						 if(newstype.getTotalItems() == Integer.parseInt(num))
							 list.add(newstype) ;
					 }
				 }else if(match != null && "more".equals(match)){  //大于
					 for(NewsType newstype : allList){
						 if(newstype.getTotalItems() > Integer.parseInt(num))
							 list.add(newstype) ;
					 }
				 }else if(match != null && "less".equals(match)){//小于
					 for(NewsType newstype : allList){
						 if(newstype.getTotalItems() < Integer.parseInt(num))
							 list.add(newstype) ;
					 }	 
				 }else{
					 list.addAll(allList) ;
				 }					 
			 }
	
		}catch(Exception e){
			log.error("", e) ;
		}	
		return list ;		
	}
	/* (non-Javadoc)
	 * @see com.seeyon.v3x.news.manager.NewsTypeManager#getNewsTypeList(java.lang.Long, boolean, boolean, int)
	 * 按是否审核进行查询
	 */
	public List<NewsType> getNewsTypeListByAuditFlag(Long memberId ,String flag , boolean isIgnoreUsed ,int spaceType) {	
		List<NewsType> list = new ArrayList<NewsType>() ;
		try{
			List<NewsType> allList = new ArrayList<NewsType>() ;	
			//得到所有的列表
			 if(spaceType == SpaceType.group.ordinal()){
				 allList = this.getManagerTypeByMember(memberId ,SpaceType.group, AppContext.getCurrentUser().getLoginAccount()) ;
			 }else if(spaceType == SpaceType.corporation.ordinal()){
				 allList = this.getManagerTypeByMember(memberId, SpaceType.corporation, AppContext.getCurrentUser().getLoginAccount()) ;
			 }else{
				 allList = this.getManagerTypeByMember(memberId, SpaceType.department, AppContext.getCurrentUser().getLoginAccount()) ;
			 }
			 
			 //判断传入的值的内容，得到符合条件的newstype
			 if(flag != null && "".equals(flag)){
				 list.addAll(allList) ;
			 }else {
				 if(flag != null && "true".equals(flag)){   //需要审核
					 for( NewsType newstype: allList){
						 if(newstype.isAuditFlag()&&newstype.isUsedFlag())
							 list.add(newstype) ;
					 }
				 }else if(flag != null && "false".equals(flag)){   //不需要审核
					 for( NewsType newstype: allList){
						 if(!newstype.isAuditFlag()&&newstype.isUsedFlag())
							 list.add(newstype) ;
					 }
				 }else{
					 list.addAll(allList) ;
				 }
			 }			 
		}catch(Exception e){
			log.error("", e) ;
		}
		return list ;
	}
	
	/**
	 * 按审核员名字进行查询
	 */
	public List<NewsType> getNewsTypeListByAuditUsername(Long memberId ,String username , boolean isIgnoreUsed ,int spaceType) {
		List<NewsType> list = new ArrayList<NewsType>() ;
		
		try{
			 List<NewsType> allList = new ArrayList<NewsType>() ; 
			 //用户名为空
			 if(Strings.isBlank(username)){
				 if(spaceType == SpaceType.group.ordinal()){
					 allList = this.getManagerTypeByMember(memberId ,SpaceType.group, AppContext.getCurrentUser().getLoginAccount()) ;
				 }else if(spaceType == SpaceType.corporation.ordinal()){
					 allList = this.getManagerTypeByMember(memberId, SpaceType.corporation, AppContext.getCurrentUser().getLoginAccount()) ;
				 }else{
					 allList = this.getManagerTypeByMember(memberId, SpaceType.department, AppContext.getCurrentUser().getLoginAccount()) ;
				 }
				 list.addAll(allList) ;
			 }else{
				 allList = this.newsTypeDao.getAllNewsType(username) ;
				 Set<Long> newsTypeIds = new HashSet<Long>() ;
				 for(NewsType newstype : allList) {
					 if(newstype.isUsedFlag() && newstype.getSpaceType().intValue() == spaceType){
						 if(this.isManagerOfType(newstype.getId(), memberId)){
							 newsTypeIds.add(newstype.getId()) ;
						 }
					 }
				 }
				 list.addAll(this.getTypesByIds(newsTypeIds)) ;
			 }		
		}catch(Exception e){
			log.error("" ,e) ;
		}
		
		return list ;
	}
	
	public boolean isAuditorOfNews(Long memberId) {
		List<NewsType> auditTypes = this.getAclTypeByMember(memberId, null, null, Constants.NewsTypeAclType.audit);
		if (auditTypes != null && auditTypes.size() > 0) {
			return true;
		} else {
			return false;
		}
	}
	
	public void delMember(Long id) throws BusinessException {
		List<NewsType> managerTypes = this.getAclTypeByMember(id, null, null, Constants.NewsTypeAclType.manager);
		List<NewsType> auditTypes = this.getAclTypeByMember(id, null, null, Constants.NewsTypeAclType.audit);
		List<NewsType> writeTypes = this.getAclTypeByMember(id, null, null, Constants.NewsTypeAclType.writer);
		List<NewsType> types = Strings.getSumCollection(managerTypes, Strings.getSumCollection(auditTypes, writeTypes));
		if(types != null){
			for(NewsType bean : types){
				//重新设置管理员、审核员
				String oldIds=bean.getManagerUserIds();
				String newIds="";
				if(StringUtils.isNotBlank(oldIds)){
					String[] oldId = oldIds.split(",");
					for (int i = 0; i < oldId.length; i ++) {
						if(!oldId[i].equals(String.valueOf(id))){
							newIds += oldId[i] + ",";
						}
					}
					newIds=StringUtils.removeEnd(newIds, ",");
				}
				boolean flag=false;
				if(!oldIds.equals(newIds)){
					bean.setManagerUserIds(newIds);
					flag=true;
				}
				//人员离职不删除审核员记录
				if(id.equals(bean.getAuditUser())){
					bean.setAuditUser(-1L);
					flag=true;
				}
				if(flag){
					this.save(bean, false);
				}
			
				//重新设置授权人员
				Set<NewsTypeManagers> oldSet = bean.getNewsTypeManagers();
				if(oldSet != null && oldSet.size() > 0){
					Set<NewsTypeManagers> newSet=new HashSet<NewsTypeManagers>();
					for(NewsTypeManagers btm : oldSet){
						if(Constants.WRITE_FALG.equals(btm.getExt1()) && !id.equals(btm.getManagerId())){
							newSet.add(btm);
						}
					}
					String[][] writeIds=new String[newSet.size()][2];
					int j = 0;
					for(NewsTypeManagers btm : newSet){
						writeIds[j][0] = btm.getExt2();
						writeIds[j][1] = String.valueOf(btm.getManagerId());
						j ++;
					}
					this.saveWriteByType(bean.getId(), writeIds);
				}
			}
		}
	}
	public void delMemberNotGroup(Long id) throws BusinessException {
        List<NewsType> managerTypes = this.getAclTypeByMemberNotGroup(id, null, null, Constants.NewsTypeAclType.manager);
        List<NewsType> auditTypes = this.getAclTypeByMemberNotGroup(id, null, null, Constants.NewsTypeAclType.audit);
        List<NewsType> writeTypes = this.getAclTypeByMemberNotGroup(id, null, null, Constants.NewsTypeAclType.writer);
        List<NewsType> types = Strings.getSumCollection(managerTypes, Strings.getSumCollection(auditTypes, writeTypes));
        if(types != null){
            for(NewsType bean : types){
                //重新设置管理员、审核员
                String oldIds=bean.getManagerUserIds();
                String newIds="";
                if(StringUtils.isNotBlank(oldIds)){
                    String[] oldId = oldIds.split(",");
                    for (int i = 0; i < oldId.length; i ++) {
                        if(!oldId[i].equals(String.valueOf(id))){
                            newIds += oldId[i] + ",";
                        }
                    }
                    newIds=StringUtils.removeEnd(newIds, ",");
                }
                boolean flag=false;
                if(!oldIds.equals(newIds)){
                    bean.setManagerUserIds(newIds);
                    flag=true;
                }
                //人员离职不删除审核员记录
                if(id.equals(bean.getAuditUser())){
                    bean.setAuditUser(-1L);
                    flag=true;
                }
                if(flag){
                    this.save(bean, false);
                }
            
                //重新设置授权人员
                Set<NewsTypeManagers> oldSet = bean.getNewsTypeManagers();
                if(oldSet != null && oldSet.size() > 0){
                    Set<NewsTypeManagers> newSet=new HashSet<NewsTypeManagers>();
                    for(NewsTypeManagers btm : oldSet){
                        if(Constants.WRITE_FALG.equals(btm.getExt1()) && !id.equals(btm.getManagerId())){
                            newSet.add(btm);
                        }
                    }
                    String[][] writeIds=new String[newSet.size()][2];
                    int j = 0;
                    for(NewsTypeManagers btm : newSet){
                        writeIds[j][0] = btm.getExt2();
                        writeIds[j][1] = String.valueOf(btm.getManagerId());
                        j ++;
                    }
                    this.saveWriteByType(bean.getId(), writeIds);
                }
            }
        }
    }

    public NewsType saveCustomNewsType(Long spaceId, String spaceName, int spaceType) {
        NewsType type = this.getById(spaceId);
        boolean isNew = type == null;
        if (isNew) {
            type = new NewsType();
            type.setId(spaceId);
            type.setCreateDate(new Date());
            type.setCreateUser(AppContext.currentUserId());
            type.setUpdateDate(new Date());
            type.setUpdateUser(AppContext.currentUserId());
        } else {
            type.setUpdateDate(new Date());
            type.setUpdateUser(AppContext.currentUserId());
        }
        type.setTypeName(spaceName);
        type.setTopCount((byte) 3);
        type.setAuditFlag(false);
        type.setAuditUser(0L);
        type.setAccountId(spaceId);
        type.setSpaceType(spaceType);
        type.setOutterPermit(false);
        type.setIsAuditorModify(false);
        type.setCommentPermit(true);

        List<Long> managerIds = new ArrayList<Long>();
        try {
            List<V3xOrgMember> members = spaceManager.getSpaceMemberBySecurity(spaceId, SecurityType.manager.ordinal());
            managerIds = new ArrayList<Long>(OrgHelper.getEntityIds(members));
        } catch (Exception e) {
            log.error("读取空间管理员出现异常：", e);
        }

        type.setManagerUserIds(StringUtils.join(managerIds, ","));

        try {
            type = this.save(type, isNew);
        } catch (Exception e) {
            log.error("", e);
        }
        return type;
    }

    public List<NewsType> getAllCustomTypes() {
        List<NewsType> list = new ArrayList<NewsType>();
        this.checkTypesMap();
        for (NewsType type : typesMap.values()) {
            if (type.isUsedFlag()
                    && (type.getSpaceType().intValue() == SpaceType.department.ordinal() || 
                            type.getSpaceType().intValue() == SpaceType.custom.ordinal() || 
                            type.getSpaceType().intValue() == SpaceType.public_custom.ordinal() || 
                            type.getSpaceType().intValue() == SpaceType.public_custom_group.ordinal())) {
                list.add(type);
            }
        }
        return list;
    }
    
    public List<Long> getCanSeeBoard(User user) throws BusinessException {
        List<Long> typeList = new ArrayList<Long>();
        List<PortalSpaceFix> fixList = spaceManager.getAccessSpace(user.getId(), user.getLoginAccount());
        List<Long> fixIds = new ArrayList<Long>();
        for(PortalSpaceFix psf : fixList){
            if(psf.getType() == SpaceType.department.ordinal()){
                fixIds.add(psf.getEntityId());
            }else{
                fixIds.add(psf.getId());
            }
        }
        for (NewsType type : typesMap.values()) {
            int _spaceType = type.getSpaceType();
            Long _boardId = type.getId();
            
            if(user.isInternal() && _spaceType == SpaceType.group.ordinal()){//集团
                typeList.add(_boardId);
            }else if(user.getLoginAccount().equals(type.getAccountId()) && _spaceType==SpaceType.corporation.ordinal()){//单位
                typeList.add(_boardId);
            }else if(_spaceType==SpaceType.department.ordinal() || _spaceType==SpaceType.custom.ordinal()){
                if (Strings.isNotEmpty(fixIds) && fixIds.contains(_boardId)) {
                    typeList.add(_boardId);
                }
            }else if(_spaceType==SpaceType.public_custom.ordinal()
                    || _spaceType==SpaceType.public_custom_group.ordinal()){
                if (Strings.isNotEmpty(fixIds) && fixIds.contains(type.getAccountId())) {
                    typeList.add(_boardId);
                }
            }
        }
        return typeList;
    }

}