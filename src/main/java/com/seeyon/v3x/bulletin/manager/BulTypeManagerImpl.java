package com.seeyon.v3x.bulletin.manager;

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
import com.seeyon.ctp.common.cache.CacheAccessable;
import com.seeyon.ctp.common.cache.CacheFactory;
import com.seeyon.ctp.common.cache.CacheMap;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.portal.po.PortalSpaceFix;
import com.seeyon.ctp.portal.space.manager.SpaceManager;
import com.seeyon.ctp.portal.util.Constants.SecurityType;
import com.seeyon.ctp.portal.util.Constants.SpaceType;
import com.seeyon.ctp.util.CommonTools;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.Strings;
import com.seeyon.v3x.bulletin.dao.BulDataDao;
import com.seeyon.v3x.bulletin.dao.BulTypeDao;
import com.seeyon.v3x.bulletin.domain.BulType;
import com.seeyon.v3x.bulletin.domain.BulTypeManagers;
import com.seeyon.v3x.bulletin.util.BulletinUtils;
import com.seeyon.v3x.bulletin.util.Constants;

public class BulTypeManagerImpl implements BulTypeManager {

    private static final Log              log              = LogFactory.getLog(BulTypeManagerImpl.class);
    // Map<bulTypeId, BulType>
    private static Map<Long, BulType>     typesMap         = null;
    // Map<memberId, Set<BulTypeId>>
    private static Map<Long, Set<Long>>   writerMap        = null;
    // Map<memberId, Set<BulTypeId>>
    private static Map<Long, Set<Long>>   managerMap       = null;
    // Map<memberId, Set<BulTypeId>>
    private static Map<Long, Set<Long>>   auditMap         = null;
    //客开s
    private static Map<Long, Set<Long>>   typesettingMap   = null;
    //客开e
    // Map<accountId, Set<typeName>> 集团id用 -1 代表， 不包含部门
    public static final Long              GROUP_ACCOUNT_ID = -1L;
    private static Map<Long, Set<String>> nameMap          = null;
    private static boolean                initialized      = false;
    private OrgManager                    orgManager;
    private SpaceManager                  spaceManager;
    private BulletinUtils                 bulletinUtils;

    private static final CacheAccessable  cacheFactory     = CacheFactory.getInstance(BulTypeManagerImpl.class);
    private CacheMap<String, Long>        typeETagDate     = cacheFactory.createMap("typeETagDate");
    private CacheMap<Long, Long>          userETagDate     = cacheFactory.createMap("userETagDate");

    public BulletinUtils getBulletinUtils() {
        return bulletinUtils;
    }

    public void setBulletinUtils(BulletinUtils bulletinUtils) {
        this.bulletinUtils = bulletinUtils;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public Long getTypeETagDate(String key) {
        Long date = typeETagDate.get(key);
        if (date == null) {
            date = System.currentTimeMillis();
            typeETagDate.put(key, date);
        }

        return date;
    }

    public void updateTypeETagDate(String key) {
        typeETagDate.put(key, System.currentTimeMillis());
    }

    public Long getUserETagDate(Long key) {
        Long date = userETagDate.get(key);
        if (date == null) {
            date = System.currentTimeMillis();
            userETagDate.put(key, date);
        }

        return date;
    }

    public void updateUserETagDate(Long key) {
        userETagDate.put(key, System.currentTimeMillis());
    }

    public synchronized void init() {
        long start = System.currentTimeMillis();

        if (initialized) {
            return;
        }

        typesMap = new HashMap<Long, BulType>();
        writerMap = new HashMap<Long, Set<Long>>();
        managerMap = new HashMap<Long, Set<Long>>();
        auditMap = new HashMap<Long, Set<Long>>();
        //客开 s
        typesettingMap = new HashMap<Long, Set<Long>>();
        //客开e
        
        Map<Long, Set<BulTypeManagers>> managers = new HashMap<Long, Set<BulTypeManagers>>();
        List<BulTypeManagers> managerList = bulTypeManagersManager.getAllBulTypeManagers();
        if (Strings.isNotEmpty(managerList)) {
            for (BulTypeManagers manager : managerList) {
                Set<BulTypeManagers> set = managers.get(manager.getTypeId());
                if (set == null) {
                    set = new HashSet<BulTypeManagers>();
                    managers.put(manager.getTypeId(), set);
                }
                set.add(manager);
            }
        }

        List<BulType> typeList = this.bulTypeDao.getAll();
        if (Strings.isNotEmpty(typeList)) {
            for (BulType type : typeList) {
                if (!type.getAccountId().equals(V3xOrgEntity.VIRTUAL_ACCOUNT_ID)) {
                    type.setBulTypeManagers(managers.get(type.getId()));
                    typesMap.put(type.getId(), type);
                    typeETagDate.put(String.valueOf(type.getId()), System.currentTimeMillis());
                    this.addAclOfType(type);
                }
            }
        }
        this.initStaticNoObj();

        initialized = true;

        log.info("加载所有公告板块信息. 耗时: " + (System.currentTimeMillis() - start) + " MS");
    }

    private void addName(BulType type) {
        if (type == null)
            return;
        if (type.isUsedFlag())
            if (type.getSpaceType().intValue() == SpaceType.corporation.ordinal()) {
                this.putStringMap(nameMap, type.getAccountId(), type.getTypeName());
            } else if (type.getSpaceType().intValue() == SpaceType.group.ordinal()) {
                this.putStringMap(nameMap, GROUP_ACCOUNT_ID, type.getTypeName());
            }
    }

    private void putStringMap(Map<Long, Set<String>> map, Long key, String value) {
        if (map == null || key == null || value == null)
            return;

        Set<String> set = map.get(key);
        if (set == null)
            set = new HashSet<String>();
        set.add(value);
        map.put(key, set);
    }

    private void addAclOfType(BulType bt) {
        if (bt == null)
            return;

        long bulTypeId = bt.getId();
        if (bt.getBulTypeManagers() == null)
            bt.setBulTypeManagers(new HashSet<BulTypeManagers>());
        for (BulTypeManagers btm : bt.getBulTypeManagers()) {
            if (Constants.MANAGER_FALG.equals(btm.getExt1())) {
                this.putMap(managerMap, btm.getManagerId(), bulTypeId);
            } else if (Constants.WRITE_FALG.equals(btm.getExt1())) {
                this.putMap(writerMap, btm.getManagerId(), bulTypeId);
            }
        }
        if (bt.isAuditFlag()) {
            this.putMap(auditMap, bt.getAuditUser(), bulTypeId);
        }
        //客开s
        if (bt.isTypesettingFlag()) {
          this.putMap(typesettingMap, bt.getTypesettingStaff(), bulTypeId);
        }
        //客开e
    }

    private void putMap(Map<Long, Set<Long>> map, Long key, Long value) {
        if (map == null || key == null || value == null)
            return;

        Set<Long> set = map.get(key);
        if (set == null)
            set = new HashSet<Long>();
        set.add(value);
        map.put(key, set);
    }

    /**
     * 获取全部板块信息
     * @return
     */
    public Collection<BulType> getAllBulletinTypes() {
        return typesMap.values();
    }

    /**
     * 为了支持集群时双机同步数据，将此方法设为public以便监听程序调用
     * @param bulType
     */
    public synchronized void initPartAdd(BulType bulType) {
        if (bulType == null) {
            return;
        }

        initialized = false;
        typesMap.put(bulType.getId(), bulType);
        this.addAclOfType(bulType);
        this.addName(bulType);
        this.initStaticNoObj();
        initialized = true;

        // 发送通知
        NotificationManager.getInstance().send(NotificationType.BulletinAddType, bulType);
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

    @SuppressWarnings({ "rawtypes", "unchecked" })
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

    /**
     * 为了支持集群时双机同步数据，将此方法设为public以便监听程序调用
     * @param bulType
     */
    public synchronized void initPartEdit(BulType bulType) {
        if (bulType == null) {
            return;
        }
        initialized = false;

        typesMap.put(bulType.getId(), bulType);
        this.deleteAclOfType(bulType.getId());
        this.addAclOfType(bulType);
        this.initStaticNoObj();
        initialized = true;
        // 发送通知
        NotificationManager.getInstance().send(NotificationType.BulletinUpdateType, bulType);
    }

    /**
     * 公告板块删除后来改为逻辑删除，此方法实际已不再使用
     * @deprecated
     * @param bulType
     */
    @SuppressWarnings("unused")
    private synchronized void initPartDelete(BulType bulType) {
        if (bulType == null)
            return;
        initialized = false;
        typesMap.remove(bulType.getId());
        this.deleteAclOfType(bulType.getId());
        this.initStaticNoObj();
        initialized = true;
    }

    private void initStaticNoObj() {
        nameMap = new HashMap<Long, Set<String>>();
        Collection<BulType> values = typesMap.values();
        for (BulType bt : values) {
            this.addName(bt);
            this.setStaticOthers(bt);
        }
    }

    private void setStaticOthers(BulType type) {
        type.setManagerUserIds("");

        List<BulTypeManagers> sortedList = new ArrayList<BulTypeManagers>();
        for (BulTypeManagers tm : type.getBulTypeManagers()) {
            if (!Constants.MANAGER_FALG.equals(tm.getExt1()))
                continue;
            sortedList.add(tm);
        }
        Collections.sort(sortedList);

        //管理员
        String ids = "";
        for (BulTypeManagers tm : sortedList) {
            ids += "," + tm.getManagerId();
        }
        type.setManagerUserIds(ids.length() > 0 ? ids.substring(1) : "");
    }

    private BulTypeDao bulTypeDao;
    private BulDataDao bulDataDao;

    /* (non-Javadoc)
     * @see com.seeyon.v3x.bulletin.manager.BulTypeManager#getBulTypeDao()
     */
    public BulTypeDao getBulTypeDao() {
        return bulTypeDao;
    }

    public void setBulTypeDao(BulTypeDao bulTypeDao) {
        this.bulTypeDao = bulTypeDao;
    }

    BulTypeManagersManager bulTypeManagersManager;

    public BulTypeManagersManager getBulTypeManagersManager() {
        return bulTypeManagersManager;
    }

    public void setBulTypeManagersManager(BulTypeManagersManager bulTypeManagersManager) {
        this.bulTypeManagersManager = bulTypeManagersManager;
    }

    /**
     * 删除部门公告
     */
    public void delDept(Long id) throws BusinessException {
    }

    /**
     * 逻辑删除版块
     */
    public void setTypeDeleted(List<Long> ids) {
        if (Strings.isNotEmpty(ids)) {
            for (Long id : ids) {
                BulType bt = this.getById(id);
                bt.setUsedFlag(false);
                this.bulTypeDao.update(bt);
                this.initPartEdit(bt);
            }
        }
    }

    /* (non-Javadoc)
     * @see com.seeyon.v3x.bulletin.manager.BulTypeManager#findAll()
     */
    public List<BulType> findAll() {
        List<BulType> list = new ArrayList<BulType>();
        this.checkTypesMap();
        for (BulType bt : typesMap.values()) {
            if (bt.getSpaceType().intValue() == SpaceType.corporation.ordinal())
                list.add(bt);
        }

        return list;
    }

    /* 后台单位板块列表查询。
     * @see com.seeyon.v3x.bulletin.manager.BulTypeManager#findAll()
     */
    public List<BulType> boardFindAll() {
        List<BulType> list = new ArrayList<BulType>();//bulTypeDao.find(hql);
        this.checkTypesMap();
        for (BulType bt : typesMap.values()) {
            if (bt.getAccountId().longValue() == AppContext.getCurrentUser().getLoginAccount() && bt.getSpaceType().intValue() == SpaceType.corporation.ordinal() && bt.isUsedFlag())
                list.add(bt);
        }
        this.sortList(list);
        return list;
    }

    /* 后台单位板块列表查询。
     * @see com.seeyon.v3x.bulletin.manager.BulTypeManager#findAll()
     */
    public List<BulType> boardFindAllByAccountId(Long accountId) {
        List<BulType> list = new ArrayList<BulType>();
        this.checkTypesMap();
        for (BulType bt : typesMap.values()) {
            if (bt.getAccountId().longValue() == accountId.longValue() && bt.getSpaceType().intValue() == SpaceType.corporation.ordinal() && bt.isUsedFlag())
                list.add(bt);
        }
        this.sortList(list);
        return list;
    }

    public List<BulType> findAccountBulletinTypes(Long accountId) {
        this.checkTypesMap();

        List<BulType> list = new ArrayList<BulType>();
        for (BulType bt : typesMap.values()) {
            if (bt.isUsedFlag() && bt.getAccountId().equals(accountId) && bt.getSpaceType() != SpaceType.department.ordinal() && bt.getSpaceType() != SpaceType.custom.ordinal()) {
                list.add(bt);
            }
        }

        this.sortList(list);
        return list;
    }

    /* 
     * 后台自定义单位或集团板块列表查询。
     */
    public List<BulType> customAccBoardAllBySpaceId(Long spaceId, int spaceType) {
        List<BulType> list = new ArrayList<BulType>();
        this.checkTypesMap();
        for (BulType bt : typesMap.values()) {
            if (bt.getAccountId().longValue() == spaceId.longValue() && bt.getSpaceType().intValue() == spaceType && bt.isUsedFlag())
                list.add(bt);
        }
        this.sortList(list);
        return list;
    }

    private void checkTypesMap() {
        if (!initialized)
            this.init();
    }

    /**
     * 查询所有自定义单位或集团公告板块类型-- 支持 分页
     */
    public List<BulType> customAccBoardFindAllByPage(long spaceId, int spaceType, boolean isPage) {
        List<BulType> all = this.customAccBoardAllBySpaceId(spaceId, spaceType);
        if (isPage) {
            List<BulType> list = CommonTools.pagenate(all);
            return list;
        }
        return all;
    }

    /**
     * 查询所有的单位公告板块--分页
     */
    public List<BulType> boardFindAllByPage() {
        List<BulType> all = this.boardFindAll();
        List<BulType> list = CommonTools.pagenate(all);
        return list;
    }

    /* (non-Javadoc)
     * @see com.seeyon.v3x.bulletin.manager.BulTypeManager#findAll()
     */
    //	@SuppressWarnings("unchecked")拿到所有集团公告的列表
    public List<BulType> groupFindAll() {
        List<BulType> list = new ArrayList<BulType>();
        this.checkTypesMap();
        for (BulType bt : typesMap.values()) {
            if (bt.getSpaceType().intValue() == SpaceType.group.ordinal() && bt.isUsedFlag())
                list.add(bt);
        }
        this.sortList(list);
        return list;
    }

    //	@SuppressWarnings("unchecked")拿到所有部门公告的列表
    public List<BulType> departmentFindAll() {
        List<BulType> list = new ArrayList<BulType>();
        this.checkTypesMap();
        for (BulType bt : typesMap.values()) {
            if (bt.getSpaceType().intValue() == SpaceType.department.ordinal() && bt.isUsedFlag())
                list.add(bt);
        }

        this.sortList(list);
        return list;
    }

    /**
     * 查询所有的集团公告板块--分页
     */
    public List<BulType> groupFindAllByPage() {
        List<BulType> all = this.groupFindAll();
        List<BulType> list = CommonTools.pagenate(all);
        return list;
    }

    /**
     * 查询所有外单位公告条件
     */
    public List<BulType> otherFindAll() {
        List<BulType> ret = new ArrayList<BulType>();
        List<BulType> src = this.findAll();
        if (src == null)
            return ret;
        for (BulType t : src) {
            if (t.getAccountId().longValue() != AppContext.getCurrentUser().getLoginAccount())
                ret.add(t);
        }
        return ret;
    }

    /* (non-Javadoc)
     * @see com.seeyon.v3x.bulletin.manager.BulTypeManager#findByProperty(java.lang.String, java.lang.Object)
     */
    public List<BulType> findByProperty(String property, Object value) {
        List<BulType> src = this.findByPropertyNoPaging(property, value);
        List<BulType> list = CommonTools.pagenate(src);
        return list;
    }

    // 条件过滤
    private List<BulType> filterByProperty(List<BulType> list, String attribute, Object value) {
        if (list == null || attribute == null || value == null)
            return list;

        List<BulType> ret = new ArrayList<BulType>();
        for (BulType bt : list) {
            Object trueVal = this.getBulletinUtils().getAttributeValue(bt, attribute);
            if (trueVal == null)
                continue;
            boolean passed = false;
            if (value instanceof String) {
                if (trueVal.toString().toLowerCase().indexOf(value.toString().toLowerCase()) != -1)
                    passed = true;
            } else {
                if (value.equals(trueVal))
                    passed = true;
            }
            if (passed)
                ret.add(bt);
        }

        return ret;
    }

    // 
    private void sortList(List<BulType> list) {
        if (list == null)
            return;
        Collections.sort(list);
    }

    public List<BulType> findByPropertyNoPaging(String property, Object value) {
        List<BulType> list = this.boardFindAll();

        list = this.filterByProperty(list, property, value);
        this.sortList(list);
        return list;
    }

    /* (non-Javadoc)
     * @see com.seeyon.v3x.bulletin.manager.BulTypeManager#groupFindByProperty(java.lang.String, java.lang.Object)
     */
    public List<BulType> groupFindByProperty(String property, Object value) {
        List<BulType> src = this.groupFindAll();
        src = this.filterByProperty(src, property, value);
        this.sortList(src);
        List<BulType> list = CommonTools.pagenate(src);

        return list;
    }

    public boolean isGroupBulTypeManager(long memberId) {
        this.checkTypesMap();
        Set<Long> set = managerMap.get(memberId);
        boolean ret = this.spaceTypeChecked(set, SpaceType.group);
        if (ret)
            return true;
        set = auditMap.get(memberId);
        return this.spaceTypeChecked(set, SpaceType.group);
    }

    /**
     * 注意！
     * 此方法不能准确判断用户是否具有某个单位的部门公告管理权限
     * 其业务逻辑是获取用户所能管理的所有公告版块，如发现其中有部门公告版块类型，即判定其具有部门公告管理权限
     * commented by Meng Yang 2009-06-23
     * @deprecated
     */
    public boolean isDepartmentBulTypeManager(long memberId) {
        this.checkTypesMap();
        Set<Long> set = managerMap.get(memberId);
        boolean ret = this.spaceTypeChecked(set, SpaceType.department);
        if (ret)
            return true;
        set = auditMap.get(memberId);
        return this.spaceTypeChecked(set, SpaceType.department);
    }

    /**
     * 判断用户是否当前登陆单位的部门公告管理员,辅助部门公告管理菜单是否出现的权限判断
     * @param memberId  当前用户ID
     * @param loginAccountId   登陆单位ID(用户可跨单位办公)
     * @return 用户是否当前登陆单位的某个部门公告管理员
     * added by Meng Yang 2009-06-23
     */
    public boolean isDepartmentBulTypeManager(long memberId, long loginAccountId) {
        boolean isDepartmentBulTypeManager = false;
        // 获取当前用户所能管理的部门公告版块类型
        List<BulType> types = this.getManagerTypeByMember(memberId, SpaceType.department, null);
        // 遍历判断其中的部门公告版块对应部门是否属于当前登陆单位
        try {
            for (BulType type : types) {
                // 如果部门公告对应部门属于当前单位,即表明当前用户具有当前登陆单位的部门公告管理权			
                if (orgManager.getDepartmentById(type.getId()).getOrgAccountId().longValue() == loginAccountId) {
                    isDepartmentBulTypeManager = true;
                    break;
                }
            }
        } catch (BusinessException e) {
            log.error("判断用户是否当前单位部门公告管理员出现异常", e);
        }
        return isDepartmentBulTypeManager;
    }

    /**
     * 判断用户是否某一特定部门的部门公告管理员，用于跨单位兼职时的权限判断
     * @param memberId 当前用户ID
     * @param deptId   当前部门ID
     * @return 是否为当前部门公告管理员
     * @throws BusinessException 
     */
    public boolean isManagerOfThisDept(long memberId, Long deptId) throws BusinessException {
        List<Long> managerDepartments = new ArrayList<Long>();
        List<PortalSpaceFix> spaceFixs = spaceManager.getCanManagerSpaceByMemberId(memberId);
        for (PortalSpaceFix portalSpaceFix : spaceFixs) {
            managerDepartments.add(portalSpaceFix.getEntityId());
        }
        return CollectionUtils.isNotEmpty(managerDepartments) && managerDepartments.contains(deptId);
    }

    private boolean spaceTypeChecked(Collection<Long> typeIds, SpaceType spaceType) {
        if (typeIds == null || spaceType == null)
            return false;

        for (Long id : typeIds) {
            BulType bt = typesMap.get(id);
            if (bt == null)
                continue;
            if (bt.getSpaceType().intValue() == spaceType.ordinal())
                return true;
        }

        return false;
    }

    public boolean isGroupBulTypeAuth(long memberId) {
        this.checkTypesMap();
        Set<Long> set = auditMap.get(memberId);
        return this.spaceTypeChecked(set, SpaceType.group);
    }

    //取的有我来审核集团公告板块的列表
    public List<BulType> getAuditGroupBulType(long memberId) {
        return this.getAuditTypeByMember(memberId, SpaceType.group, null);

    }

    //取的有我来审核单位公告板块的列表
    public List<BulType> getAuditUnitBulType(long memberId) {
        return this.getAuditTypeByMember(memberId, SpaceType.corporation, AppContext.getCurrentUser().getLoginAccount());

    }

    public List<BulType> getAuditUnitBulType(long memberId, long spaceId, int spaceType) {
        return this.getAuditTypeByMember(memberId, spaceType == SpaceType.public_custom.ordinal() ? SpaceType.public_custom : SpaceType.public_custom_group, spaceId);
    }

    /**
     * 只根据用户，不根据当前单位
     */
    public List<BulType> getAuditUnitBulTypeOnlyByMember(long memberId) {
        return this.getAuditTypeByMember(memberId, SpaceType.corporation, null);
    }

    /**
     * 得到可以审核的版块列表
     * 单位类型时，accountId 为 null 说明不验证单位
     *
     */
    public List<BulType> getAuditTypeByMember(Long memberId, SpaceType spaceType, Long accountId) {
        return this.getAclTypeByMember(memberId, spaceType, accountId, Constants.BulTypeAclType.audit, false);
    }

    /**
     * 得到可以管理的版块列表
     * 单位类型时，accountId 为 null 说明不验证单位
     *
     */
    public List<BulType> getManagerTypeByMember(Long memberId, SpaceType spaceType, Long accountId) {
        return this.getAclTypeByMember(memberId, spaceType, accountId, Constants.BulTypeAclType.manager, false);
    }

    public List<BulType> getWriterTypeByMember(Long memberId, SpaceType spaceType, Long accountId) {
        return this.getAclTypeByMember(memberId, spaceType, accountId, Constants.BulTypeAclType.writer, false);
    }
    
    //客开 start
    public List<BulType> getPaiBanTypeByMember(Long memberId, SpaceType spaceType, Long accountId){
      return this.getAclTypeByMember(memberId, spaceType, accountId, Constants.BulTypeAclType.typesetting,false);
    }
    //客开 end

    private Map<Long, Set<Long>> getAclMap(Constants.BulTypeAclType aclType) {
        this.checkTypesMap();
        int param = aclType.ordinal();
        if (param == Constants.BulTypeAclType.manager.ordinal())
            return managerMap;
        else if (param == Constants.BulTypeAclType.audit.ordinal())
            return auditMap;
        else if (param == Constants.BulTypeAclType.writer.ordinal())
            return writerMap;
        else if(param == Constants.BulTypeAclType.typesetting.ordinal())
          return typesettingMap;
        //客开 e
        return new HashMap<Long, Set<Long>>();
    }

    private List<BulType> getAclTypeByMember(Long memberId, SpaceType spaceType, Long accountId, Constants.BulTypeAclType aclType, boolean isNotGroup) {
        List<BulType> ret = new ArrayList<BulType>();
        if (memberId == null || aclType == null)
            return ret;
        Map<Long, Set<Long>> map = this.getAclMap(aclType);
        Set<Long> set = new HashSet<Long>();
        List<Long> orgIds = null;
        try {
            orgIds = orgManager.getUserDomainIDs(memberId, V3xOrgEntity.VIRTUAL_ACCOUNT_ID, V3xOrgEntity.ORGENT_TYPE_ACCOUNT, V3xOrgEntity.ORGENT_TYPE_DEPARTMENT, V3xOrgEntity.ORGENT_TYPE_TEAM, V3xOrgEntity.ORGENT_TYPE_POST, V3xOrgEntity.ORGENT_TYPE_LEVEL, V3xOrgEntity.ORGENT_TYPE_MEMBER);
        } catch (BusinessException e) {
            log.error("个人组织属性访问：从组织模型获得当前执行人的所有相关组织属性，不包含部门角色 出现异常", e);
        }

        if (orgIds != null) {
            for (long key : map.keySet()) {
                if (orgIds.contains(key))
                    set.addAll(map.get(key));
            }
        }
        Set<BulType> src = this.getTypesByIds(set);
        if (spaceType == null) {
            for (BulType bt : src) {
                if (bt.isUsedFlag()) {
                    if (isNotGroup) {
                        if (bt.getSpaceType() != SpaceType.group.ordinal()) {
                            ret.add(bt);
                        }
                    } else {
                        if (accountId != null && bt.getAccountId().longValue() != accountId.longValue()) {
                            continue;
                        }
                        ret.add(bt);
                    }
                }
            }
        } else if (spaceType.ordinal() == SpaceType.corporation.ordinal()) {
            for (BulType bt : src) {
                if (bt.getSpaceType().intValue() == SpaceType.corporation.ordinal() && bt.isUsedFlag()) {
                    if (accountId != null && bt.getAccountId().longValue() != accountId.longValue()) {
                        continue;
                    }
                    ret.add(bt);
                }
            }
        } else if (spaceType.ordinal() == SpaceType.public_custom.ordinal()) {
            for (BulType bt : src) {
                if (bt.getSpaceType().intValue() == SpaceType.public_custom.ordinal() && bt.isUsedFlag()) {
                    if (accountId != null && bt.getAccountId().longValue() != accountId.longValue()) {
                        continue;
                    }
                    ret.add(bt);
                }
            }
        } else if (spaceType.ordinal() == SpaceType.public_custom_group.ordinal()) {
            for (BulType bt : src) {
                if (bt.getSpaceType().intValue() == SpaceType.public_custom_group.ordinal() && bt.isUsedFlag()) {
                    if (accountId != null && bt.getAccountId().longValue() != accountId.longValue()) {
                        continue;
                    }
                    ret.add(bt);
                }
            }
        } else if (spaceType.ordinal() == SpaceType.group.ordinal()) {
            for (BulType bt : src) {
                if (bt.getSpaceType().intValue() == SpaceType.group.ordinal() && bt.isUsedFlag()) {
                    ret.add(bt);
                }
            }
        } else if (spaceType.ordinal() == SpaceType.department.ordinal()) {
            for (BulType bt : src) {
                if (bt.getSpaceType().intValue() == SpaceType.department.ordinal() && bt.isUsedFlag()) {
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

    private Set<BulType> getTypesByIds(Collection<Long> ids) {
        Set<BulType> set = new HashSet<BulType>();
        if (ids == null)
            return set;
        this.checkTypesMap();
        for (Long id : ids) {
            BulType bt = typesMap.get(id);
            if (bt != null)
                set.add(bt);
        }
        return set;
    }

    public BulType getById(Long id) {
        if (id == null) {
            return null;
        }

        this.checkTypesMap();
        BulType type = typesMap.get(id);

        if (type == null) {
            try {
                V3xOrgDepartment dept = orgManager.getDepartmentById(id);
                if (dept == null) {
                    return null;
                } else {
                    type = this.createBulTypeByDept(dept.getId(), dept.getName(), SpaceType.department.ordinal());
                }
            } catch (BusinessException e) {
                log.error("按id取部门 出现异常", e);
            }
        }
        return type;
    }

    public BulType getByDeptId(Long id) {
        if (id == null)
            return null;
        this.checkTypesMap();
        return typesMap.get(id);
    }

    /* (non-Javadoc)
     * @see com.seeyon.v3x.bulletin.manager.BulTypeManager#save(com.seeyon.v3x.bulletin.domain.BulType)
     */
    public BulType save(BulType type) throws BusinessException {
        if (type == null)
            return null;
        return this.saveBulType(type, type.isNew());
    }

    public BulType saveBulType(BulType type, boolean isNew) {
        if (isNew) {
            type.setIdIfNew();
            if (type.getAccountId() == null) {
                type.setAccountId(AppContext.currentAccountId());
            }
            if (type.getCreateDate() == null) {
                type.setCreateDate(new Date());
            }
            type.setUsedFlag(true);
            bulTypeDao.save(type);
        } else {
            bulTypeDao.update(type);
        }

        //保存公告管理员
        String[][] manages = null;
        if (Strings.isNotBlank(type.getManagerUserIds())) {
            String[] managerUserIds = type.getManagerUserIds().split(",");
            manages = new String[managerUserIds.length][2];
            for (int i = 0; i < managerUserIds.length; i++) {
                manages[i][0] = "Member";
                manages[i][1] = managerUserIds[i];
            }
        }
        bulTypeManagersManager.saveAclByType(type, manages, Constants.MANAGER_FALG);

        // 内存加载
        if (isNew) {
            this.initPartAdd(type);
        } else {
            this.initPartEdit(type);
        }

        return type;
    }

    /* (non-Javadoc)
     * @see com.seeyon.v3x.bulletin.manager.BulTypeManager#saveWriteByType(java.lang.Long, java.lang.Long[])
     */
    public void saveWriteByType(Long typeId, String[][] writeIds) {
        BulType type = this.getById(typeId);
        this.bulTypeManagersManager.saveAclByType(type, writeIds, Constants.WRITE_FALG);//.saveWriteByType(type, writeIds);
        // 内存同步
        this.initPartEdit(type);
    }

    /**
     * 得到 writeFlag 的BulTypeManagers
     * 
     */
    public List<BulTypeManagers> findTypeWriters(BulType bt) {
        List<BulTypeManagers> ret = new ArrayList<BulTypeManagers>();
        if (bt == null)
            return ret;
        Set<BulTypeManagers> set = bt.getBulTypeManagers();//this.getBulTypeManagersManager().findTypeManagerId(typeId);

        if (set != null)
            for (BulTypeManagers btm : set) {
                if (Constants.WRITE_FALG.equals(btm.getExt1()))
                    ret.add(btm);
            }

        return ret;
    }

    public BulDataDao getBulDataDao() {
        return bulDataDao;
    }

    public void setBulDataDao(BulDataDao bulDataDao) {
        this.bulDataDao = bulDataDao;
    }

    /**
     * 初始化类型下总数
     */
    @SuppressWarnings("unchecked")
    public void setTotalItemsOfType(List<BulType> types) {
        if (Strings.isNotEmpty(types)) {
            Map<Long, Integer> countMap = new HashMap<Long, Integer>();
            List<Long> typeIds = new ArrayList<Long>();
            for (BulType t : types) {
                countMap.put(t.getId(), 0);
                typeIds.add(t.getId());
            }

            try {
                final String hqlf = "select data.typeId from BulData as data where data.typeId in (:typeIds) " + " and data.state=:state and data.deletedFlag=false ";
                Map<String, Object> parameterMap = new HashMap<String, Object>();
                parameterMap.put("typeIds", typeIds);
                parameterMap.put("state", Constants.DATA_STATE_ALREADY_PUBLISH);
                List<Object> list = bulTypeDao.find(hqlf, -1, -1, parameterMap);

                for (Object o : list) {
                    Long typeId = (Long) o;
                    countMap.put(typeId, countMap.get(typeId) + 1);
                }

                for (BulType t : types) {
                    Integer total = countMap.get(t.getId());
                    if (total == null) {
                        continue;
                    }
                    t.setTotalItems(total);
                }
            } catch (Exception e) {
                log.error("", e);
            }
        }
    }

    /**
     * 用于新建单位时初始化公告板块
     */
    public void initBulType(long accountId) {
        int count = bulTypeDao.getAccountSystemType(accountId);
        if (count > 0) {
            return;
        }

        List<BulType> types = bulTypeDao.getSystemType();
        if (types != null) {
            Date today = new Date();
            for (BulType type : types) {
                today = Datetimes.addMinute(today, 1);
                BulType newType = new BulType();
                newType.setAccountId(accountId);
                newType.setAuditFlag(type.isAuditFlag());
                newType.setAuditUser(type.getAuditUser());
                newType.setCreateDate(today);
                newType.setCreateUser(type.getCreateUser());
                newType.setSpaceType(type.getSpaceType());
                newType.setTopCount(type.getTopCount());
                newType.setPrintFlag(type.getPrintFlag());
                newType.setPrintDefault(type.getPrintDefault());
                newType.setTypeName(type.getTypeName());
                newType.setUpdateDate(today);
                newType.setUsedFlag(true);
                newType.setExt1("0");
                //客开 start
                newType.setTypesettingFlag(type.isTypesettingFlag());
                newType.setTypesettingStaff(type.getTypesettingStaff());
                //客开 end
                try {
                    this.save(newType);
                } catch (BusinessException e) {
                    log.error("保存公告类型,同时保存公告管理员列表 出现异常", e);
                }
            }
        }
    }

    /**
     * 判断用户是否管理员
     */
    public boolean isManagerOfType(long typeId, long userId) {
        this.checkTypesMap();
        Set<Long> set = managerMap.get(userId);
        if (set == null)
            return false;
        return set.contains(typeId);

    }

    /**
     * 用于更新公告板块的排序顺序
     */
    public void updateBulTypeOrder(String[] bulTypeIds) {
        if (bulTypeIds == null) {
            return;
        }
        int i = 0;
        for (String bulTypeId : bulTypeIds) {
            i++;
            BulType type = this.getById(Long.valueOf(bulTypeId));
            type.setSortNum(i);
            this.initPartEdit(type);
            bulTypeDao.update(type);
        }
    }

    /**
     * 取得某个用户有新建权限的所有版块
     */
    public List<BulType> getTypesCanNew(Long memberId, SpaceType spaceType, Long accountId) {
        List<BulType> list2 = new ArrayList<BulType>();
        if (memberId == null)
            return list2;
        Set<BulType> list1 = new HashSet<BulType>();
        list1.addAll(this.getManagerTypeByMember(memberId, spaceType, accountId));
        list1.addAll(this.getWriterTypeByMember(memberId, spaceType, accountId));
        list1.addAll(this.getAuditTypeByMember(memberId, spaceType, accountId));
        list2.addAll(list1);
        this.sortList(list2);
        return list2;
    }

    /**
     * 判断用户是否有新建权限
     */
    public boolean hasAuth(Long memberId, Long accountId) {
        return CollectionUtils.isNotEmpty(getTypesCanCreate(memberId, null, accountId));
    }

    /**
     * 取得某个用户有新建权限的所有版块
     */
    public List<BulType> getTypesCanCreate(Long memberId, SpaceType spaceType, Long accountId) {
        List<BulType> list2 = new ArrayList<BulType>();
        if (memberId == null)
            return list2;
        Set<BulType> list1 = new HashSet<BulType>();
        list1.addAll(this.getManagerTypeByMember(memberId, spaceType, accountId));
        list1.addAll(this.getWriterTypeByMember(memberId, spaceType, accountId));
        list2.addAll(list1);
        this.sortList(list2);
        return list2;
    }

    public List<BulType> getBulByTypeName(Long memberID, String bulTypeName, boolean isIgnoreUsed, int spaceType) {

        List<BulType> list = new ArrayList<BulType>();
        try {
            if (bulTypeName == null || "".equals(bulTypeName)) {
                if (spaceType == SpaceType.corporation.ordinal()) {
                    list = this.getManagerTypeByMember(memberID, SpaceType.corporation, AppContext.getCurrentUser().getLoginAccount());
                } else if (spaceType == SpaceType.group.ordinal()) {
                    list = this.getManagerTypeByMember(memberID, SpaceType.group, AppContext.getCurrentUser().getLoginAccount());
                } else if (spaceType == SpaceType.department.ordinal()) {
                    list = this.getManagerTypeByMember(memberID, SpaceType.department, AppContext.getCurrentUser().getLoginAccount());
                }

            } else { //查询得到所有的满足该名字的公告模块
                List<BulType> typeList = this.bulTypeDao.getAllBulType(memberID, bulTypeName);
                Set<Long> set = new HashSet<Long>();
                for (BulType t : typeList) {
                    if (t.getSpaceType().intValue() == spaceType && t.isUsedFlag()) { //判断此模块是不是属于此空间
                        Set<BulTypeManagers> bulTypeManagers = t.getBulTypeManagers(); //得到该模块的管理员的集合
                        for (BulTypeManagers bt : bulTypeManagers) {
                            if (bt.getManagerId().intValue() == memberID.intValue()) { //判断此人是不是该模块的管理员
                                set.add(t.getId());
                            }
                        }
                    }
                }
                Set<BulType> src = this.getTypesByIds(set);
                list.addAll(src);
            }

        } catch (Exception e) {
            log.error("", e);
        }
        this.sortList(list);
        this.setTotalItemsOfType(list);
        return list;
    }

    /**
     * 按公告数量的查询
     * @param 
     */
    public List<BulType> getBulByTol(Long memberID, String totals, String matches, boolean isIgnoreUsed, int spaceType) {
        List<BulType> list = new ArrayList<BulType>();

        try {
            //查询得到所有的公告信息列表
            List<BulType> typeList = new ArrayList<BulType>();
            if (spaceType == SpaceType.corporation.ordinal()) {
                typeList = this.getManagerTypeByMember(memberID, SpaceType.corporation, AppContext.getCurrentUser().getLoginAccount());
            } else if (spaceType == SpaceType.group.ordinal()) {
                typeList = this.getManagerTypeByMember(memberID, SpaceType.group, AppContext.getCurrentUser().getLoginAccount());
            } else if (spaceType == SpaceType.department.ordinal()) {
                typeList = this.getManagerTypeByMember(memberID, SpaceType.department, AppContext.getCurrentUser().getLoginAccount());
            }

            //判断写入的数字是不是空的
            if (!"".equals(totals)) {
                int total = Integer.parseInt(totals);
                if ("equal".equals(matches)) { //选择的是等于
                    for (BulType t : typeList) {
                        if (t.getTotalItems() == total && t.getSpaceType().intValue() == spaceType) {
                            list.add(t);
                        }
                    }
                } else if ("more".equals(matches)) { //选择的是大于
                    for (BulType t : typeList) {
                        if (t.getTotalItems() > total && t.getSpaceType().intValue() == spaceType) {
                            list.add(t);
                        }
                    }
                } else if ("less".equals(matches)) { //选择的是小于
                    for (BulType t : typeList) {
                        if (t.getTotalItems() < total && t.getSpaceType().intValue() == spaceType) {
                            list.add(t);
                        }
                    }
                } else {
                    for (BulType t : typeList) {
                        list.add(t);
                    }
                }
            } else {
                //为空
                for (BulType t : typeList) {
                    list.add(t);
                }
            }
        } catch (Exception e) {
            log.error("", e);
        }
        this.setTotalItemsOfType(list);
        return list;
    }

    /**
     * 按公告是否需要审核查询
     */
    public List<BulType> findByAuditFlag(Long memberId, String flag, boolean isIgnoreUsed, int spaceType) {
        List<BulType> list = new ArrayList<BulType>();

        try {
            //查询得到所有的公告信息列表
            List<BulType> typeList = new ArrayList<BulType>();
            if (spaceType == SpaceType.corporation.ordinal()) {
                typeList = this.getManagerTypeByMember(memberId, SpaceType.corporation, AppContext.getCurrentUser().getLoginAccount());
            } else if (spaceType == SpaceType.group.ordinal()) {
                typeList = this.getManagerTypeByMember(memberId, SpaceType.group, AppContext.getCurrentUser().getLoginAccount());
            } else if (spaceType == SpaceType.department.ordinal()) {
                typeList = this.getManagerTypeByMember(memberId, SpaceType.department, AppContext.getCurrentUser().getLoginAccount());
            }
            //判断标记的值	
            if ("".equals(flag)) {
                list.addAll(typeList);
            } else {
                if ("false".equals(flag)) { //不需要验证
                    for (BulType t : typeList) {
                        if (!t.isAuditFlag() && t.getSpaceType().intValue() == spaceType) {
                            list.add(t);
                        }
                    }
                } else if ("true".equals(flag)) { //需要验证
                    for (BulType t : typeList) {
                        if (t.isAuditFlag() && t.getSpaceType().intValue() == spaceType) {
                            list.add(t);
                        }
                    }
                } else {
                    list.addAll(typeList);
                }
            }
        } catch (Exception e) {
            log.error("", e);
        }
        this.setTotalItemsOfType(list);
        return list;
    }

    /**
     * 按公告审核员的名字查询
     */
    public List<BulType> findByAuditUserName(Long memberId, String username, boolean isIgnoreUsed, int spaceType) {
        List<BulType> list = new ArrayList<BulType>();

        try {
            //用户输入的名字为空
            if (username == null || "".equals(username)) {
                if (spaceType == SpaceType.corporation.ordinal()) { //得到单位公告
                    list = this.getManagerTypeByMember(memberId, SpaceType.corporation, AppContext.getCurrentUser().getLoginAccount());
                } else if (spaceType == SpaceType.group.ordinal()) {//得到集团公告
                    list = this.getManagerTypeByMember(memberId, SpaceType.group, AppContext.getCurrentUser().getLoginAccount());
                } else if (spaceType == SpaceType.department.ordinal()) { //得到部门公告
                    list = this.getManagerTypeByMember(memberId, SpaceType.department, AppContext.getCurrentUser().getLoginAccount());
                }
            } else {
                List<BulType> typeList = this.bulTypeDao.getAllBulTypeByMember(memberId, username);
                Set<Long> set = new HashSet<Long>();
                for (BulType bt : typeList) {
                    if (bt.getSpaceType().intValue() == spaceType && bt.isUsedFlag()) {
                        Set<BulTypeManagers> bulTypeManagers = bt.getBulTypeManagers(); //得到该模块的管理员的集合
                        for (BulTypeManagers btm : bulTypeManagers) {
                            if (btm.getManagerId().intValue() == memberId.intValue()) { //判断此人是不是该模块的管理员
                                set.add(bt.getId());
                            }
                        }
                    }
                }
                Set<BulType> src = this.getTypesByIds(set);
                list.addAll(src);
            }

        } catch (Exception e) {
            log.error("", e);
        }
        this.sortList(list);
        this.setTotalItemsOfType(list);
        return list;
    }

    public void setSpaceManager(SpaceManager spaceManager) {
        this.spaceManager = spaceManager;
    }

    public boolean isAuditorOfBul(Long memberId) {
        List<BulType> auditTypes = this.getAclTypeByMember(memberId, null, null, Constants.BulTypeAclType.audit, false);
        if (auditTypes != null && auditTypes.size() > 0) {
            return true;
        } else {
            return false;
        }
    }

    public void delMember(Long id, boolean isNotGroup) throws BusinessException {
        List<BulType> managerTypes = this.getAclTypeByMember(id, null, null, Constants.BulTypeAclType.manager, isNotGroup);
        List<BulType> auditTypes = this.getAclTypeByMember(id, null, null, Constants.BulTypeAclType.audit, isNotGroup);
        List<BulType> writeTypes = this.getAclTypeByMember(id, null, null, Constants.BulTypeAclType.writer, isNotGroup);
        List<BulType> types = Strings.getSumCollection(managerTypes, Strings.getSumCollection(auditTypes, writeTypes));
        if (types != null) {
            for (BulType bean : types) {
                //重新设置管理员、审核员
                String oldIds = bean.getManagerUserIds();
                String oldNames = bean.getManagerUserNames();
                String newIds = "";
                String newNames = "";
                if (StringUtils.isNotBlank(oldIds)) {
                    String[] oldId = oldIds.split(",");
                    for (int i = 0; i < oldId.length; i++) {
                        if (!oldId[i].equals(String.valueOf(id))) {
                            newIds += oldId[i] + ",";
                        }
                    }
                    if (newIds.length() > 0) {
                        newIds = newIds.substring(0, newIds.length() - 1);
                    }
                }
                if (StringUtils.isNotBlank(oldNames)) {
                    String[] oldName = oldNames.split("、");
                    for (int i = 0; i < oldName.length; i++) {
                        if (!oldName[i].equals(orgManager.getMemberById(id).getName())) {
                            newNames += oldName[i] + "、";
                        }
                    }
                    if (newNames.length() > 0) {
                        newNames = newNames.substring(0, newNames.length() - 1);
                    }
                }
                boolean flag = false;
                if (!oldIds.equals(newIds)) {
                    bean.setManagerUserIds(newIds);
                    bean.setManagerUserNames(newNames);
                    flag = true;
                }
                //人员离职时不去掉审核员记录
                if (id.equals(bean.getAuditUser())) {
                    bean.setAuditUser(-1L);
                    flag = true;
                }
                if (flag) {
                    this.save(bean);
                }

                //重新设置授权人员
                Set<BulTypeManagers> oldSet = bean.getBulTypeManagers();
                if (oldSet != null && oldSet.size() > 0) {
                    Set<BulTypeManagers> newSet = new HashSet<BulTypeManagers>();
                    for (BulTypeManagers btm : oldSet) {
                        if (Constants.WRITE_FALG.equals(btm.getExt1()) && !id.equals(btm.getManagerId())) {
                            newSet.add(btm);
                        }
                    }
                    String[][] writeIds = new String[newSet.size()][2];
                    int j = 0;
                    for (BulTypeManagers btm : newSet) {
                        writeIds[j][0] = btm.getExt2();
                        writeIds[j][1] = String.valueOf(btm.getManagerId());
                        j++;
                    }
                    this.saveWriteByType(bean.getId(), writeIds);
                }
            }
        }
    }

    public BulType createBulTypeByDept(Long spaceId, String spaceName, int spaceType) {
        BulType type = this.getByDeptId(spaceId);
        boolean isNew = type == null;
        if (isNew) {
            type = new BulType();
            type.setId(spaceId);
            type.setCreateUser(AppContext.currentUserId());
            type.setCreateDate(new Date());
            type.setUpdateUser(AppContext.currentUserId());
            type.setUpdateDate(new Date());
        } else {
            type.setUpdateUser(AppContext.currentUserId());
            type.setUpdateDate(new Date());
        }
        type.setTypeName(spaceName);
        type.setTopCount(Constants.BUL_DEPT_DEFAULT_TOP_COUNT);
        type.setAuditFlag(false);
        type.setAuditUser(0L);
        type.setAccountId(spaceId);
        type.setSpaceType(spaceType);
        type.setExt1("0");
        type.setIsAuditorModify(false);

        List<Long> managerIds = new ArrayList<Long>();
        if (spaceType == SpaceType.department.ordinal()) {
            try {
                List<V3xOrgMember> members = orgManager.getMembersByRole(spaceId, Role_NAME.DepManager.name());
                managerIds = new ArrayList<Long>(OrgHelper.getEntityIds(members));
            } catch (Exception e) {
                log.error("读取部门主管出现异常：", e);
            }
        } else {
            try {
                List<V3xOrgMember> members = spaceManager.getSpaceMemberBySecurity(spaceId, SecurityType.manager.ordinal());
                managerIds = new ArrayList<Long>(OrgHelper.getEntityIds(members));
            } catch (Exception e) {
                log.error("读取空间管理员出现异常：", e);
            }
        }

        type.setManagerUserIds(StringUtils.join(managerIds, ","));
        this.saveBulType(type, isNew);
        return type;
    }

    public List<BulType> getAllCustomTypes() {
        List<BulType> list = new ArrayList<BulType>();
        this.checkTypesMap();
        for (BulType type : typesMap.values()) {
            if (type.isUsedFlag() && (type.getSpaceType().intValue() == SpaceType.department.ordinal() || type.getSpaceType().intValue() == SpaceType.custom.ordinal() || type.getSpaceType().intValue() == SpaceType.public_custom.ordinal()
                    || type.getSpaceType().intValue() == SpaceType.public_custom_group.ordinal())) {
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
        for (BulType type : typesMap.values()) {
            int _spaceType = type.getSpaceType();
            Long _boardId = type.getId();
            
            if(_spaceType == SpaceType.group.ordinal()){//集团
                typeList.add(_boardId);
            }else if(_spaceType==SpaceType.corporation.ordinal()){//单位
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