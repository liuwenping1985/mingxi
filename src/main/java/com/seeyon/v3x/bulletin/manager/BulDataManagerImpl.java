package com.seeyon.v3x.bulletin.manager;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.dao.DataAccessException;

import com.seeyon.apps.agent.utils.AgentUtil;
import com.seeyon.apps.bulletin.event.BulletinAddEvent;
import com.seeyon.apps.bulletin.event.BulletinAuditEvent;
import com.seeyon.apps.doc.api.DocApi;
import com.seeyon.apps.doc.bo.DocLibBO;
import com.seeyon.apps.doc.bo.DocResourceBO;
import com.seeyon.apps.doc.constants.DocConstants;
import com.seeyon.apps.index.manager.IndexManager;
import com.seeyon.ctp.cluster.notification.NotificationManager;
import com.seeyon.ctp.cluster.notification.NotificationType;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.ApplicationSubCategoryEnum;
import com.seeyon.ctp.common.content.affair.AffairExtPropEnums;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.AffairUtil;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.content.affair.constants.SubStateEnum;
import com.seeyon.ctp.common.content.affair.constants.TrackEnum;
import com.seeyon.ctp.common.content.mainbody.handler.impl.HtmlMainbodyHandler;
import com.seeyon.ctp.common.dao.paginate.Pagination;
import com.seeyon.ctp.common.excel.DataCell;
import com.seeyon.ctp.common.excel.DataRecord;
import com.seeyon.ctp.common.excel.DataRow;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.idmapper.GuidMapper;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.common.usermessage.MessageContent;
import com.seeyon.ctp.common.usermessage.MessageReceiver;
import com.seeyon.ctp.common.usermessage.UserMessageManager;
import com.seeyon.ctp.event.EventDispatcher;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.bo.MemberPost;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgTeam;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.po.OrgMember;
import com.seeyon.ctp.organization.po.OrgUnit;
import com.seeyon.ctp.portal.po.PortalSpaceFix;
import com.seeyon.ctp.portal.space.manager.PortletEntityPropertyManager;
import com.seeyon.ctp.portal.space.manager.SpaceManager;
import com.seeyon.ctp.portal.util.Constants.SpaceType;
import com.seeyon.ctp.util.CommonTools;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.JDBCAgent;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.SQLWildcardUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.AjaxAccess;
import com.seeyon.ctp.util.cache.ClickDetail;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.v3x.bbs.util.CacheInfo;
import com.seeyon.v3x.bulletin.dao.BulBodyDao;
import com.seeyon.v3x.bulletin.dao.BulDataDao;
import com.seeyon.v3x.bulletin.dao.BulPublishScopeDao;
import com.seeyon.v3x.bulletin.domain.BulBody;
import com.seeyon.v3x.bulletin.domain.BulData;
import com.seeyon.v3x.bulletin.domain.BulPublishScope;
import com.seeyon.v3x.bulletin.domain.BulRead;
import com.seeyon.v3x.bulletin.domain.BulType;
import com.seeyon.v3x.bulletin.domain.BulTypeManagers;
import com.seeyon.v3x.bulletin.util.BulDataCache;
import com.seeyon.v3x.bulletin.util.BulDataLock;
import com.seeyon.v3x.bulletin.util.BulParseStcXmlUtil;
import com.seeyon.v3x.bulletin.util.BulTypeCastUtil;
import com.seeyon.v3x.bulletin.util.BulletinUtils;
import com.seeyon.v3x.bulletin.util.Constants;
import com.seeyon.v3x.bulletin.util.hql.BulletinHqlUtils;
import com.seeyon.v3x.bulletin.util.hql.PageInfo;
import com.seeyon.v3x.bulletin.util.hql.SearchInfo;
import com.seeyon.v3x.bulletin.util.hql.SearchType;
import com.seeyon.v3x.bulletin.util.hql.TypeInfo;
import com.seeyon.v3x.bulletin.util.hql.UserInfo;
import com.seeyon.v3x.bulletin.vo.BulDataVO;
import com.seeyon.v3x.bulletin.vo.BulStcVo;
import com.seeyon.v3x.contentTemplate.domain.ContentTemplate;
import com.seeyon.v3x.contentTemplate.manager.ContentTemplateManager;
import com.seeyon.v3x.isearch.model.ConditionModel;

/**
 * 公告最重要的Manager的实现类。包括了公告发起员、公告审核员、公告管理员、普通用户的操作
 */
public class BulDataManagerImpl implements BulDataManager {

    private static final Log             log = LogFactory.getLog(BulDataManagerImpl.class);

    private BulDataDao                   bulDataDao;
    private BulPublishScopeDao           bulPublishScopeDao;
    private AttachmentManager            attachmentManager;
    private BulBodyDao                   bulBodyDao;
    private FileManager                  fileManager;
    private OrgManager                   orgManager;
    private IndexManager                 indexManager;
    private SpaceManager                 spaceManager;
    private Map<Long, BulDataLock>       buldataLockMap;
    private BulTypeManager               bulTypeManager;
    private BulReadManager               bulReadManager;
    private AffairManager                affairManager;
    private AppLogManager                appLogManager;
    private UserMessageManager           userMessageManager;
    private GuidMapper                   guidMapper;
    private DocApi                       docApi;
    private ContentTemplateManager       contentTemplateManager;
    private PortletEntityPropertyManager portletEntityPropertyManager;

    private BulletinUtils                bulletinUtils;

    public BulletinUtils getBulletinUtils() {
        return bulletinUtils;
    }

    public void setBulletinUtils(BulletinUtils bulletinUtils) {
        this.bulletinUtils = bulletinUtils;
    }

    public void setContentTemplateManager(ContentTemplateManager contentTemplateManager) {
		this.contentTemplateManager = contentTemplateManager;
	}

	public void setDocApi(DocApi docApi) {
        this.docApi = docApi;
    }

    public GuidMapper getGuidMapper() {
        return guidMapper;
    }

    public void setGuidMapper(GuidMapper guidMapper) {
        this.guidMapper = guidMapper;
    }

    public UserMessageManager getUserMessageManager() {
		return userMessageManager;
	}

	public void setUserMessageManager(UserMessageManager userMessageManager) {
		this.userMessageManager = userMessageManager;
	}

	private BulDataCache bulDataCache;
	private final Object readCountLock = new Object();



	public AffairManager getAffairManager() {
		return affairManager;
	}

	public void setAffairManager(AffairManager affairManager) {
		this.affairManager = affairManager;
	}

	public AppLogManager getAppLogManager() {
		return appLogManager;
	}

	public void setAppLogManager(AppLogManager appLogManager) {
		this.appLogManager = appLogManager;
	}

	public BulDataCache getBulDataCache() {
		return this.bulDataCache;
	}

	public void setBulDataCache(BulDataCache bulDataCache) {
		this.bulDataCache = bulDataCache;
	}

	public void setPortletEntityPropertyManager(PortletEntityPropertyManager portletEntityPropertyManager) {
        this.portletEntityPropertyManager = portletEntityPropertyManager;
    }

	public void clickCache(Long dataId, Long userId) {
		this.bulDataCache.getDataCache().click(dataId, new ClickDetail(userId, new Timestamp(System.currentTimeMillis())));
		BulData bean = this.bulDataCache.getDataCache().get(dataId);
		if (bean == null){
		    return;
		}
		synchronized (readCountLock) {
			bean.setReadCount(this.bulDataCache.getDataCache().getClickTotal(dataId));
		}
		// 发送消息
		NotificationManager.getInstance().send(NotificationType.BulDataClickArticle, new CacheInfo(dataId, userId));
	}

	public void syncCache(BulData bean, int clickCount) {
		this.bulDataCache.getDataCache().save(bean.getId(), bean, System.currentTimeMillis(), clickCount);
		// 发送消息
		NotificationManager.getInstance().send(NotificationType.BulDataModifyArticle, new CacheInfo(bean.getId(), clickCount));
	}

	public void removeCache(Long dataId) {
		this.bulDataCache.getDataCache().remove(dataId);
		// 发送消息
		NotificationManager.getInstance().send(NotificationType.BulDeleteArticle, dataId);
	}

    /** 真实删除公告以及对应的Office正文、附件、 正文内容、发布范围、阅读信息  */
    public void deleteReal(Long bulDataId) throws BusinessException {
        // 删除正文
        BulData data = this.getById(bulDataId);
        try {
            if (Constants.getMSAndWPSTypes().contains(data.getDataFormat())) {
                fileManager.deleteFile(data.getId(), data.getCreateDate(), true);
            }
        } catch (BusinessException e) {
            log.error("", e);
            throw e;
        }

        // 删除附件
        try {
            attachmentManager.deleteByReference(data.getId(), data.getId());
        } catch (BusinessException e) {
            log.error("", e);
            throw e;
        }

        // 删除与公告对应的正文内容、发布范围、阅读信息及公告自身
        this.bulBodyDao.delete(new Object[][] { { "bulDataId", bulDataId } });
        this.bulPublishScopeDao.delete(new Object[][] { { "bulDataId", bulDataId } });
        this.bulReadManager.deleteReadByData(data);
        this.bulDataDao.delete(bulDataId.longValue());
        if (AppContext.hasPlugin("index")) {
            indexManager.delete(bulDataId, ApplicationCategoryEnum.bulletin.getKey());
        }
    }

    /** 批量逻辑删除：将删除标识标记为true，并非真实删除   */
    public void deletes(List<Long> ids) {
        this.bulDataDao.delete(ids);
    }

    /**
     * 按主键ID获取公告，并对其进行初始化操作
     */
    public BulData getById(Long id) {
        BulData data = bulDataDao.get(id);
        if (data != null) {
            this.getBulletinUtils().initData(data);
        }
        return data;
    }

    /**
     * 取得对应公告被阅读的次数
     * @param bulDataId 公告ID
     */
    public int getReadCount(long bulDataId) {
        BulData data = bulDataDao.get(bulDataId);
        if (data == null || data.getReadCount() == null)
            return 0;
        else
            return data.getReadCount();
    }

    /**
     * 判断公告是否有效存在
     * @param bulId 公告ID
     */
    public boolean dataExist(Long bulId) {
        return this.getById(bulId) != null;
    }

    /**
     * 查询公告板块下的所有公告
     * @param typeId 公告板块ID
     */
    public List<BulData> searchBulDatas(Long typeId) {
        List<BulData> l = bulDataDao.getBulDatas(typeId);
        return l;
    }

    /**
     * 保存公告，也包括保存正文、公告发布范围等操作
     */
    public BulData save(BulData data, boolean isNew) {
        data.setKeywords("");
        data.setBrief("");
        Long typeId = data.getTypeId();
        BulType type = null;
        if (typeId != null) {
            type = this.bulTypeManager.getById(typeId);
            data.setType(type);
        }

        if (isNew) {
            if (type != null) {
                data.setSpaceType(type.getSpaceType());
                data.setAccountId(type.getAccountId());
            } else {
                data.setAccountId(AppContext.getCurrentUser().getLoginAccount());
            }
            bulDataDao.save(data);
        } else {
            bulDataDao.update(data);
        }

        this.bulBodyDao.saveBody(data, isNew);
        this.bulPublishScopeDao.savePublishScope(data, isNew);
        return data;
    }

    public BulData saveCustomBul(BulData data, boolean isNew) {
        data.setKeywords("");
        data.setBrief("");
        Long typeId = data.getTypeId();
        BulType type = null;
        if (typeId != null) {
            type = this.bulTypeManager.getById(typeId);
            data.setType(type);
        }
        if (isNew) {
            bulDataDao.save(data);
        } else {
            bulDataDao.update(data);
        }
        this.bulBodyDao.saveBody(data, isNew);
        this.bulPublishScopeDao.savePublishScope(data, isNew);
        return data;
    }
    
    public void updatePublishScope(BulData data){
    	this.bulPublishScopeDao.savePublishScope(data, false);
    }

    /** 持久化对公告的修改 */
    public void updateDirect(BulData data) {
        bulDataDao.update(data);
    }

    public void update(Long bulDataId, Map<String, Object> columns) {
        try {
            bulDataDao.update(bulDataId, columns);
        } catch (Exception e) {
            log.error("", e);
        }
    }

    /**
     * 获取用户在某一单位下可以管理的所有公告板块，并设置每个公告板块的公告总数
     */
    public List<BulType> getTypeList(Long managerUserId, boolean isIgnoreUsed) throws Exception {
        List<BulType> list = this.bulTypeManager.getManagerTypeByMember(managerUserId, SpaceType.corporation,
                AppContext.getCurrentUser().getLoginAccount());
        bulTypeManager.setTotalItemsOfType(list);
        return list;
    }

    public List<BulType> getTypeList(Long managerUserId, long spaceId, int spaceType) throws Exception {
        List<BulType> list = this.bulTypeManager.getManagerTypeByMember(managerUserId,
                spaceType == SpaceType.public_custom.ordinal() ? SpaceType.public_custom
                        : SpaceType.public_custom_group, spaceId);
        bulTypeManager.setTotalItemsOfType(list);
        return list;
    }

    /**
     * 获取用户可以管理的所有公告板块
     */
    public List<BulType> getTypeListOnlyByMemberId(Long managerUserId, boolean isIgnoreUsed) throws Exception {
        List<BulType> list = this.bulTypeManager.getManagerTypeByMember(managerUserId, SpaceType.corporation, null);
        return list;
    }

    /**
     * 获取用户可以管理的所有<b>集团</b>公告板块，并设置每个公告板块的公告总数
     */
    public List<BulType> getManagerGroupBulType(Long managerUserId, boolean isIgnoreUsed) throws Exception {
        List<BulType> list = this.bulTypeManager.getManagerTypeByMember(managerUserId, SpaceType.group, null);
        bulTypeManager.setTotalItemsOfType(list);
        return list;
    }

    /**
     * 获取用户具有公告发起权限的所有公告板块
     */
    public List<BulType> getTypeListByWrite(Long writeId, boolean isIgnoreUsed) {
        return this.bulTypeManager.getWriterTypeByMember(writeId, null, null);
    }

    /** 集团空间下待用户审核的公告列表  */
    public List<BulData> getGroupAuditList(Long userId, String property, Object value) throws BusinessException {
        return this.getAuditDataListNew(userId, property, value, SpaceType.group.ordinal());
    }

    /** 单位空间下待用户审核的公告列表，也可用于集团空间下的情况   */
    public List<BulData> getAuditDataListNew(Long userId, String property, Object value, int spaceType)
            throws BusinessException {
        UserInfo userInfo = new UserInfo(Constants.VisitRole.Auditor, userId);
        Long accountId = BulletinUtils.getAccountId(spaceType, orgManager);
        TypeInfo typeInfo = new TypeInfo(null, accountId, Constants.valueOfSpaceType(spaceType));
        SearchInfo searchInfo = BulletinHqlUtils.getSearchInfo(property, value);

        List<BulData> list = BulletinHqlUtils.findBulDatas(userInfo, typeInfo, searchInfo, bulDataDao);
        this.getBulletinUtils().initList(list);
        return list;
    }

    public List<BulData> getAuditDataListNew(Long userId, String property, Object value, int spaceType, long spaceId)
            throws BusinessException {
        UserInfo userInfo = new UserInfo(Constants.VisitRole.Auditor, userId);
        TypeInfo typeInfo = new TypeInfo(null, spaceId, Constants.valueOfSpaceType(spaceType));
        SearchInfo searchInfo = BulletinHqlUtils.getSearchInfo(property, value);
        List<BulData> list = BulletinHqlUtils.findBulDatas(userInfo, typeInfo, searchInfo, bulDataDao);
        this.getBulletinUtils().initList(list);
        return list;
    }

    //**********************2012-11-06 yangwulin Sprint4 begin****************************************************************
    /**
     * yangwlin Sprint4 修改了3.5版本的点击板块管只能查询改板块的审核公告
     * @param userId
     * @param property
     * @param value
     * @param spaceType
     * @param spaceId
     * @param bulTypeId
     * @return
     * @throws BusinessException
     */
    public List<BulData> getAuditDataListNew(Long userId, String property, Object value, int spaceType, long spaceId,
            String bulTypeId) throws BusinessException {
        UserInfo userInfo = new UserInfo(Constants.VisitRole.Auditor, userId);
        TypeInfo typeInfo = new TypeInfo(null, spaceId, Constants.valueOfSpaceType(spaceType));
        SearchInfo searchInfo = BulletinHqlUtils.getSearchInfo(property, value);
        List<BulData> list = BulletinHqlUtils.findBulDatasByTypeId(userInfo, typeInfo, searchInfo, bulDataDao,
                bulTypeId);
        this.getBulletinUtils().initList(list);
        return list;
    }

    /**
     * yangwlin Sprint4 单位空间下待用户审核的公告列表，也可用于集团空间下的情况
     * @param userId
     * @param property
     * @param value
     * @param spaceType
     * @param bulTypeId
     * @return
     * @throws BusinessException
     */
    public List<BulData> getAuditDataListNew(Long userId, String property, Object value, int spaceType, String bulTypeId)
            throws BusinessException {
        UserInfo userInfo = new UserInfo(Constants.VisitRole.Auditor, userId);
        Long accountId = BulletinUtils.getAccountId(spaceType, orgManager);
        TypeInfo typeInfo = new TypeInfo(null, accountId, Constants.valueOfSpaceType(spaceType));
        SearchInfo searchInfo = BulletinHqlUtils.getSearchInfo(property, value);

        List<BulData> list = BulletinHqlUtils.findBulDatasByTypeId(userInfo, typeInfo, searchInfo, bulDataDao,
                bulTypeId);
        this.getBulletinUtils().initList(list);
        return list;
    }

    //客开 start
    /** 集团空间下待用户排版的公告列表  */
    public List<BulData> getGroupTypesettingList(Long userId, String property, Object value) throws BusinessException {
      return this.getTypesettingDataListNew(userId, property, value, SpaceType.group.ordinal());
    }

    /** 单位空间下待用户排版的公告列表，也可用于集团空间下的情况   */
    public List<BulData> getTypesettingDataListNew(Long userId, String property, Object value, int spaceType)
        throws BusinessException {
      UserInfo userInfo = new UserInfo(Constants.VisitRole.Typesetting, userId);
      Long accountId = BulletinUtils.getAccountId(spaceType, orgManager);
      TypeInfo typeInfo = new TypeInfo(null, accountId, Constants.valueOfSpaceType(spaceType));
      SearchInfo searchInfo = BulletinHqlUtils.getSearchInfo(property, value);

      List<BulData> list = BulletinHqlUtils.findBulDatas(userInfo, typeInfo, searchInfo, bulDataDao);
      this.getBulletinUtils().initList(list);
      return list;
    }

    public List<BulData> getTypesettingDataListNew(Long userId, String property, Object value, int spaceType, long spaceId)
        throws BusinessException {
      UserInfo userInfo = new UserInfo(Constants.VisitRole.Typesetting, userId);
      TypeInfo typeInfo = new TypeInfo(null, spaceId, Constants.valueOfSpaceType(spaceType));
      SearchInfo searchInfo = BulletinHqlUtils.getSearchInfo(property, value);
      List<BulData> list = BulletinHqlUtils.findBulDatas(userInfo, typeInfo, searchInfo, bulDataDao);
      this.getBulletinUtils().initList(list);
      return list;
    }

    //**********************2012-11-06 yangwulin Sprint4 begin****************************************************************
    /**
     * yangwlin Sprint4 修改了3.5版本的点击板块管只能查询改板块的审核公告
     * @param userId
     * @param property
     * @param value
     * @param spaceType
     * @param spaceId
     * @param bulTypeId
     * @return
     * @throws BusinessException
     */
    public List<BulData> getTypesettingDataListNew(Long userId, String property, Object value, int spaceType, long spaceId,
        String bulTypeId) throws BusinessException {
      UserInfo userInfo = new UserInfo(Constants.VisitRole.Typesetting, userId);
      TypeInfo typeInfo = new TypeInfo(null, spaceId, Constants.valueOfSpaceType(spaceType));
      SearchInfo searchInfo = BulletinHqlUtils.getSearchInfo(property, value);
      List<BulData> list = BulletinHqlUtils.findBulDatasByTypeId(userInfo, typeInfo, searchInfo, bulDataDao,
          bulTypeId);
      this.getBulletinUtils().initList(list);
      return list;
    }

    /**
     * yangwlin Sprint4 单位空间下待用户排版的公告列表，也可用于集团空间下的情况
     * @param userId
     * @param property
     * @param value
     * @param spaceType
     * @param bulTypeId
     * @return
     * @throws BusinessException
     */
    public List<BulData> getTypesettingDataListNew(Long userId, String property, Object value, int spaceType, String bulTypeId)
        throws BusinessException {
      UserInfo userInfo = new UserInfo(Constants.VisitRole.Typesetting, userId);
      Long accountId = BulletinUtils.getAccountId(spaceType, orgManager);
      TypeInfo typeInfo = new TypeInfo(null, accountId, Constants.valueOfSpaceType(spaceType));
      SearchInfo searchInfo = BulletinHqlUtils.getSearchInfo(property, value);

      List<BulData> list = BulletinHqlUtils.findBulDatasByTypeId(userInfo, typeInfo, searchInfo, bulDataDao,
          bulTypeId);
      this.getBulletinUtils().initList(list);
      return list;
    }
    //客开 end

    /**
     * yangwulin Sprint4  2012-11-15  全文检索
     * 获取在某一段时期内，某一板块下已发布的公告总数
     * @param beginDate
     * @param endDate
     * @return
     */
    public Integer findIndexByDate(Date beginDate, Date endDate) {
        return this.bulDataDao.findIndexByDate(beginDate, endDate);
    }

    /**
     * yangwulin Sprint4 2012-11-15 全文检索
     */
    public List<Long> findDocSourcesList(Date starDate, Date endDate, Integer firstRow, Integer pageSize){
        return this.bulDataDao.findDocSourcesList(starDate, endDate, firstRow, pageSize);
    }

    //**********************2012-11-06 yangwulin Sprint4 end****************************************************************

    /**
     * 此接口<b>不再用于单位最新公告栏目：显示最新发布的8条公告</b>。参考：{@link #findByReadUserForIndex(User)}<br>
     * 此接口保留，以便V3xInterfaceImpl工程对其的调用可以保持，用于获取单位空间中用户可以访问的公告
     * 但<b>存在隐患</b>，只按照用户ID获取domainIds时，未区分内部或外部人员
     * @see com.seeyon.oainterface.impl.exportdata.DataConvertUtils#convertBulletinByRecent
     */
    public List<BulData> findByReadUserForIndex(long currentUserId, long accountId, Boolean needCount)
            throws DataAccessException, BusinessException {
        UserInfo userInfo = BulletinHqlUtils.getUserInfo(currentUserId, orgManager);
        TypeInfo typeInfo = new TypeInfo(null, accountId, SpaceType.corporation);
        PageInfo pageInfo = new PageInfo(needCount);
        List<BulData> list = BulletinHqlUtils.findBulDatas(userInfo, typeInfo, null, pageInfo, bulDataDao);
        this.getBulletinUtils().initList(list);
        return list;
    }

    /**
     * 用于获取各种类型公告栏目所需的最新(配置显示条数)条公告，包括：
     * 单位最新公告、集团最新公告、部门公告、我的公告、单版块单位公告、单版块集团公告栏目
     * @param user			当前用户
     * @param typeId		对应板块ID：仅单版块公告栏目或部门公告栏目此项有效，为板块ID或部门ID
     * @param accountId		单位或集团ID
     * @param spaceType		所属空间类型：部门、单位、集团、无
     * @throws BusinessException 
     */
    private List<BulData> findBulletins4Section(User user, Long typeId, Long accountId, SpaceType spaceType, int count,
            SearchInfo searchInfo) throws BusinessException {
        //单版块公告栏目，区分管理员(无需发布范围匹配)和普通用户(需要发布范围匹配)
        boolean isAdmin = false;
        if (typeId != null) {
            isAdmin = this.bulTypeManager.isManagerOfType(typeId, user.getId());
        }
        UserInfo userInfo = new UserInfo(isAdmin ? Constants.VisitRole.Admin : Constants.VisitRole.User, user.getId(),
                orgManager.getAllUserDomainIDs(user.getId()), isAdmin);
        TypeInfo typeInfo = new TypeInfo(typeId, accountId, spaceType);
        PageInfo pageInfo = new PageInfo(false, 0, count);
        List<BulData> list = BulletinHqlUtils.findBulDatas(userInfo, typeInfo, searchInfo, pageInfo, bulDataDao);
        if (typeId != null || spaceType != SpaceType.department) {
            this.getBulletinUtils().initList(list);
        }
        return list;
    }

    @SuppressWarnings("unchecked")
    public List<BulData> findByReadUserForIndex(User user, int count, List<Long> typeList, SpaceType spaceType,
            SearchInfo searchInfo) throws BusinessException {
        Map<String, Object> params = new HashMap<String, Object>();
        StringBuilder select = new StringBuilder("select " + BulletinHqlUtils.Hql_Selected_Fields);
        StringBuilder from = new StringBuilder(" from ");
        StringBuilder where = new StringBuilder(" where ");
        StringBuilder orderBy = new StringBuilder(" order by ");

        from.append(BulData.class.getName() + " as t_bul_data ");
               /* + " left join t_bul_data.bulReads as t_bul_read with t_bul_read.managerId=:userId ");*/

        if (!spaceType.equals(SpaceType.public_custom_group) && !spaceType.equals(SpaceType.public_custom)) {
            where.append(" t_bul_data.accountId=:accountId and ");
            Long accountId = BulletinUtils.getAccountId(spaceType.ordinal(), orgManager);
            params.put("accountId", accountId);
        }
        where.append(" t_bul_data.id in(select s.bulDataId from " + BulPublishScope.class.getName() + " as s where s.bulDataId=t_bul_data.id ");
        where.append(" and (t_bul_data.createUser=:userId or t_bul_data.auditUserId=:userId or t_bul_data.publishUserId=:userId or s.userId in(:userDomainIds))) ");
        if (typeList != null) {
            where.append(" and t_bul_data.typeId in(:typeList)");
            params.put("typeList", typeList);
        }
        params.put("userId", user.getId());
        where.append(" and t_bul_data.state=:published and t_bul_data.deletedFlag=false ");
        params.put("published", Constants.DATA_STATE_ALREADY_PUBLISH);
        params.put("userDomainIds", orgManager.getAllUserDomainIDs(user.getId()));

        orderBy.append(" t_bul_data.publishDate desc");

        BulletinHqlUtils.handleSearchInfo(searchInfo, from, where, params);

        if (count != -1) {
            Pagination.setNeedCount(false);
            Pagination.setFirstResult(0);
            Pagination.setMaxResults(count);
        }

        List<Object[]> objs = bulDataDao
                .find(select.toString() + from + where + orderBy, "t_bul_data.id", true, params);
        List<BulData> list = BulletinHqlUtils.parseObjArrs2BulDatas(objs, false, bulDataDao, user.getId());
        this.getBulletinUtils().initList(list);
        return list;
    }

    public List<BulData> findByReadUserForIndexContent(User user, int count, List<Long> typeList, SpaceType spaceType,
            SearchInfo searchInfo,long account)
            throws DataAccessException, BusinessException {
        Map<String, Object> params = new HashMap<String, Object>();
        StringBuilder select = new StringBuilder("select " + BulletinHqlUtils.Hql_Selected_Fields);
        StringBuilder from = new StringBuilder(" from ");
        StringBuilder where = new StringBuilder(" where ");
        StringBuilder orderBy = new StringBuilder(" order by ");

        from.append(BulData.class.getName() + " as t_bul_data ");
               /* + " left join t_bul_data.bulReads as t_bul_read with t_bul_read.managerId=:userId ");*/
        if(searchInfo!=null){
        	 where.append(" t_bul_data.accountId=:accountId ");
        	 params.put("accountId", account);
        }else{
        	if (!spaceType.equals(SpaceType.public_custom_group) && !spaceType.equals(SpaceType.public_custom)) {
                where.append(" t_bul_data.accountId=:accountId and ");
                Long accountId = account;//BulletinUtils.getAccountId(spaceType.ordinal(), orgManager);
                params.put("accountId", accountId);
            }
            where.append(" t_bul_data.id in(select s.bulDataId from " + BulPublishScope.class.getName() + " as s where s.bulDataId=t_bul_data.id ");
            where.append(" and (t_bul_data.createUser=:userId or t_bul_data.auditUserId=:userId or t_bul_data.publishUserId=:userId or s.userId in(:userDomainIds))) ");
            if (typeList != null) {
                where.append(" and t_bul_data.typeId in(:typeList)");
                params.put("typeList", typeList);
            }
            params.put("userId", user.getId());
            where.append(" and t_bul_data.state=:published and t_bul_data.deletedFlag=false ");
            
            params.put("published", Constants.DATA_STATE_ALREADY_PUBLISH);
            params.put("userDomainIds", orgManager.getAllUserDomainIDs(user.getId()));
        }

        orderBy.append(" t_bul_data.publishDate desc");

        BulletinHqlUtils.handleSearchInfo(searchInfo, from, where, params);

        if (count != -1) {
            //Pagination.setNeedCount(false);
            //Pagination.setFirstResult(0);
            //Pagination.setMaxResults(count);
        }

        List<Object[]> objs = bulDataDao
                .find(select.toString() + from + where + orderBy, "t_bul_data.id", true, params);
        List<BulData> list = BulletinHqlUtils.parseObjArrs2BulDatas(objs, false, bulDataDao, user.getId());
      List<BulData> resultBulDatas=new ArrayList<BulData>();
      for(BulData bdInfo:list){
      	bdInfo.setContent(getBody(bdInfo.getId()).getContent());
      	resultBulDatas.add(bdInfo);
      }
        this.getBulletinUtils().initList(resultBulDatas);
        return resultBulDatas;
    }

    /**
     * 查找已读/未读/全部(新闻和公告)的总数  --微协同
     * @param userId 当前用户
     * @param countFlag【all,notRead,read】
     * @return
     * @throws BusinessException 
     */
    public int findByReadUserForWechat(long userId, String countFlag) throws BusinessException {
        Map<String, Object> params = new HashMap<String, Object>();
        StringBuilder hql = new StringBuilder("from ");
        hql.append(BulData.class.getName()).append(" as t_bul_data ");
        hql.append("where t_bul_data.id in(select s.bulDataId from ").append(BulPublishScope.class.getName());
        hql.append(" as s where s.bulDataId=t_bul_data.id ");
        hql.append(" and (t_bul_data.createUser=:userId or t_bul_data.auditUserId=:userId");
        hql.append(" or t_bul_data.publishUserId=:userId or s.userId in(:userDomainIds))) ");
        hql.append(" and t_bul_data.state=:published and t_bul_data.deletedFlag = false ");
        if ("notRead".equals(countFlag)) {
            hql.append("and not exists");
            hql.append("(select t_bul_read.bulletinId from ").append(BulRead.class.getName());
            hql.append(" as t_bul_read where t_bul_read.managerId=:userId");
            hql.append(" and t_bul_read.bulletinId = t_bul_data.id) ");
        } else if ("read".equals(countFlag)) {
            hql.append("and exists");
            hql.append("(select t_bul_read.bulletinId from ").append(BulRead.class.getName());
            hql.append(" as t_bul_read where t_bul_read.managerId=:userId");
            hql.append(" and t_bul_read.bulletinId = t_bul_data.id) ");
        }
        params.put("userId", userId);
        params.put("published", Constants.DATA_STATE_ALREADY_PUBLISH);
        params.put("userDomainIds", orgManager.getAllUserDomainIDs(userId));
        return DBAgent.count(hql.toString(), params);
    }

    public List<BulData> findCustomByReadUserForIndex(User user, long spaceId, int spaceType, int count,
            SearchInfo searchInfo) throws BusinessException {
        if (spaceType == 17) {
            return this.findBulletins4Section(user, null, spaceId, SpaceType.public_custom, count, searchInfo);
        } else {
            return this.findBulletins4Section(user, null, spaceId, SpaceType.public_custom_group, count, searchInfo);
        }
    }

    public List<BulData> groupFindByReadUserForIndex(User user, int count) throws DataAccessException, BusinessException {
        Long groupId = BulletinUtils.getAccountId(SpaceType.group.ordinal(), orgManager);
        return this.findBulletins4Section(user, null, groupId, SpaceType.group, count, null);
    }

    /**
     * 首页 - 部门空间 - 部门公告栏目，显示该部门下最新发布的8条部门公告
     */
    public List<BulData> deptFindByReadUserForIndex(long departmentId, User user) throws DataAccessException,
            BusinessException {
        return this.findBulletins4Section(user, departmentId, null, SpaceType.department,
                Constants.SECTION_TABLE_COLUMNS, null);
    }

    /**
     * 首页 - 特定空间 - 特定空间公告栏目，显示该空间下最新发布的8条空间公告
     */
    public List<BulData> spaceFindByReadUserForIndex(long spaceId, User user, int spaceTypespaceType, int count,
            SearchInfo searchInfo) throws DataAccessException, BusinessException {
    	if (SpaceType.custom.ordinal()==spaceTypespaceType) { //自定义团队空间没有板块不需要查根据板块查询
    		 return this.findBulletins4Section(user, spaceId, null, SpaceType.custom, count, searchInfo);
    	} else {
    		//如果是自定义单位空间和集团空间分板块需要更具板块id查询内容
			List<BulType> allTypeListOfCustom = bulTypeManager.customAccBoardAllBySpaceId(spaceId, spaceTypespaceType);
			List<Long> typeIds = new ArrayList<Long>();
			if (allTypeListOfCustom != null && allTypeListOfCustom.size() > 0) {
				for (BulType type : allTypeListOfCustom) {
					if (type !=null) {
						typeIds.add(type.getId());
					}
				}
			}
			SpaceType sapceTypes = SpaceType.public_custom_group;
			if (spaceTypespaceType == SpaceType.public_custom.ordinal()) {
				sapceTypes =  SpaceType.public_custom;
			}
			return this.findByReadUserForIndex(user, count, typeIds, sapceTypes, searchInfo);
    	}
    }

    /**
     * 首页 - 个人空间-单版块公告栏目（获取某一个公告板块作为空间栏目出现），显示该板块下最新8条公告
     */
    public List<BulData> findByReadUser4Section(User user, long typeId, int count) throws DataAccessException,
            BusinessException {
        return this.findBulletins4Section(user, typeId, null, null, count, null);
    }

    /**
     * 获取单位空间下面、按照指定日期区间进行查询的用户可以访问的公告列表
     * 此接口保留，以便V3xInterfaceImpl工程对其的调用可以保持
     * 但<b>存在隐患</b>，只按照用户ID获取domainIds时，未区分内部或外部人员
     * @see com.seeyon.oainterface.impl.exportdata.DataConvertUtils#convertBulletinByDateTime
     */
    public List<BulData> findByReadUserByDateTime(long currentUserId, long accountId, String beginDateTime,
            String endDateTime, Boolean needCount) throws BusinessException {
        UserInfo userInfo = BulletinHqlUtils.getUserInfo(currentUserId, orgManager);
        TypeInfo typeInfo = new TypeInfo(null, accountId, SpaceType.corporation);
        SearchInfo searchInfo = BulletinHqlUtils.getSearchInfo(SearchType.By_Publish_Date.value(), beginDateTime,
                endDateTime);
        PageInfo pageInfo = new PageInfo(needCount);

        List<BulData> list = BulletinHqlUtils.findBulDatas(userInfo, typeInfo, searchInfo, pageInfo, bulDataDao);
        this.getBulletinUtils().initList(list);
        return list;
    }

    /**
     * 单位/集团空间-单位/集团最新公告-更多
     * @param user			当前用户
     * @param accountId 	单位或集团ID
     * @param spaceType 	空间类型：单位、集团
     * @param searchInfo 	搜索信息
     */
    public List<BulData> find4UserInAccount(User user, long accountId, int spaceType, SearchInfo searchInfo)
            throws DataAccessException, BusinessException {
        UserInfo userInfo = BulletinHqlUtils.getUserInfo(user, orgManager);
        TypeInfo typeInfo = new TypeInfo(null, accountId, Constants.valueOfSpaceType(spaceType));
        List<BulData> list = BulletinHqlUtils.findBulDatas(userInfo, typeInfo, searchInfo, bulDataDao);
        this.getBulletinUtils().initList(list);
        return list;
    }

    /**
     * 政务【我的提醒】查【单位公告】总数 (根据find4UserInAccount改造) wangjingjing
     * 单位/集团空间-单位/集团最新公告-更多
     * @param user			当前用户
     * @param accountId 	单位或集团ID
     * @param spaceType 	空间类型：单位、集团
     * @param searchInfo 	搜索信息
     */
    public Long find4UserInAccountCount(User user, long accountId, int spaceType, SearchInfo searchInfo)
            throws DataAccessException, BusinessException {
        UserInfo userInfo = BulletinHqlUtils.getUserInfo(user, orgManager);
        TypeInfo typeInfo = new TypeInfo(null, accountId, Constants.valueOfSpaceType(spaceType));
        return BulletinHqlUtils.findBulDatasCount(userInfo, typeInfo, searchInfo, bulDataDao);
    }

    /**
     * 单击单位/集团公告:首页时执行的方法.查出每个类型下对应的所有公告,只显示前六条.
     * @param typeList 单位或集团全部公告板块，传入时已经进行了校验，不会为空
     */
    public Map<Long, List<BulData>> findByReadUserHome(long userId, List<BulType> typeList) throws DataAccessException,
            BusinessException {
        Map<Long, List<BulData>> result = new HashMap<Long, List<BulData>>();

        UserInfo userInfo = new UserInfo();
        userInfo.setUserId(userId);
        userInfo.setDomainIds(orgManager.getAllUserDomainIDs(userId));

        for (BulType type : typeList) {
            Long typeId = type.getId();
            boolean isManager = this.bulTypeManager.isManagerOfType(typeId, userId);
            userInfo.setAdminAsUser(isManager);
            userInfo.setRole(isManager ? Constants.VisitRole.Admin : Constants.VisitRole.User) ;
            TypeInfo typeInfo = new TypeInfo(typeId);
            PageInfo pageInfo = new PageInfo(false, 0, Constants.BUL_HOMEPAGE_TABLE_COLUMNS);
            List<BulData> bulletins = BulletinHqlUtils.findBulDatas(userInfo, typeInfo, null, pageInfo, bulDataDao);
            this.getBulletinUtils().initList(bulletins);
            result.put(typeId, bulletins);
        }
        return result;
    }

    /**
     * 根据参数查询公告列表
     * @param userId			当前用户id
     * @param accountId 	单位或集团ID
     * @param keyword			搜索条件
     * @param type		 	搜索类型1=按标题,2=按日期,3=按发起者姓名 
     * @param spaceType 	空间类型：单位、集团
     * @param startIndex    查询起始位置
     * @param rowCount 	    每页显示条数
     */
    public List<BulData> searchInfoByUserAccount(long userId, long accountId, String keyword, int type, int spaceType)
            throws DataAccessException, BusinessException {
        UserInfo userInfo = new UserInfo(Constants.VisitRole.User, userId);
        userInfo.setDomainIds(orgManager.getAllUserDomainIDs(userId));

        TypeInfo typeInfo = new TypeInfo(null, accountId, Constants.valueOfSpaceType(spaceType));
        SearchInfo searchInfo = new SearchInfo();
        switch (type) {
            case 1:
                searchInfo.setTitle(keyword);
                break;
            case 2:
                searchInfo.setBeginDate(parseDate(keyword.split(";")[0], "yyyy-MM-dd HH:mm:ss"));
                searchInfo.setEndDate(parseDate(keyword.split(";")[1], "yyyy-MM-dd HH:mm:ss"));
                break;
            case 3:
                searchInfo.setCreatorName(keyword);
                break;
            default:
                searchInfo = null;
        }
        List<BulData> list = BulletinHqlUtils.findBulDatas(userInfo, typeInfo, searchInfo, null, bulDataDao);
        this.getBulletinUtils().initList(list);
        return list;
    }

    /**
     * 获取当前用户可以访问的所有公告
     * @param user	   当前用户
     * @param searchInfo   用户输入的搜索信息
     * @param forSection   是否用于首页栏目显示
     * @throws BusinessException 
     */
    public List<BulData> findMyBulDatas(User user, SearchInfo searchInfo, boolean forSection) throws BusinessException {
        UserInfo userInfo = BulletinHqlUtils.getUserInfo(user, orgManager);
        TypeInfo typeInfo = new TypeInfo(SpaceType.personal);
        PageInfo pageInfo = forSection ? new PageInfo(false, 0, Constants.SECTION_TABLE_COLUMNS) : null;

        List<BulData> list = BulletinHqlUtils.findBulDatas(userInfo, typeInfo, searchInfo, pageInfo, bulDataDao);
        this.getBulletinUtils().initList(list);
        return list;
    }
    
    /**
     * @Description: 获取当前用户可以访问的所有公告,需要根据单位过滤
     * @return
     * @throws BusinessException 
     */
    public List<BulData> findMyBulDatas(Long userId,Long accountId, int firstNum, int pageSize) throws BusinessException {
        UserInfo userInfo = BulletinHqlUtils.getUserInfo(userId, orgManager);
        TypeInfo typeInfo = new TypeInfo(SpaceType.personal);
        if (accountId != null) {
            typeInfo.setAccountId(accountId);
            typeInfo.setTypeId(-1L);//区分是否根据单位过滤
        }
        PageInfo pageInfo = null;
        if (pageSize != -1){
            pageInfo = new PageInfo(false, firstNum, pageSize);
        }
        List<BulData> list = BulletinHqlUtils.findBulDatas(userInfo, typeInfo, null, pageInfo, bulDataDao);
        this.getBulletinUtils().initList(list);
        return list;
    }
    
    /**
     * @Description: 获取当前用户可以访问的所有公告,不需要根据单位过滤
     * @return
     * @throws BusinessException 
     */
    public List<BulData> findMyBulDatas(Long userId, int firstNum, int pageSize) throws BusinessException {
       return findMyBulDatas(userId,null,firstNum,pageSize);
    }

    /**
     * 部门空间-部门公告-更多及对应的查询
     * @param departmentId	部门ID
     * @param userId		用户ID
     * @param searchInfo	搜索信息
     * @throws BusinessException 
     */
    public List<BulData> deptFindByReadUser(long departmentId, long userId, SearchInfo searchInfo) throws BusinessException {
        UserInfo userInfo = new UserInfo(Constants.VisitRole.User, userId);
        TypeInfo typeInfo = new TypeInfo(departmentId, null, SpaceType.department);
        userInfo.setDomainIds(orgManager.getAllUserDomainIDs(userId));
        List<BulData> findBulDatas = BulletinHqlUtils.findBulDatas(userInfo, typeInfo, searchInfo, bulDataDao);
        this.getBulletinUtils().initList(findBulDatas);
        return findBulDatas;
    }

    /**
     * 获取某一个板块下的所有公告，支持按照公告属性进行搜索
     * @param typeId	公告板块ID
     * @param searchInfo	用户输入的搜索信息
     */
    public List<BulData> findByReadUserByType(Long typeId, SearchInfo searchInfo) throws DataAccessException,
            BusinessException {
        User user = AppContext.getCurrentUser();
        boolean isAdmin = this.bulTypeManager.isManagerOfType(typeId, user.getId());
        UserInfo userInfo = new UserInfo(isAdmin ? Constants.VisitRole.Admin : Constants.VisitRole.User, user.getId(),
                orgManager.getAllUserDomainIDs(user.getId()), isAdmin);
        TypeInfo typeInfo = new TypeInfo(typeId);
        List<BulData> findBulDatas = BulletinHqlUtils.findBulDatas(userInfo, typeInfo, searchInfo, bulDataDao);
        this.getBulletinUtils().initList(findBulDatas);
        return findBulDatas;
    }
    
    public List<BulData> findByReadUserByType(Long userId, Long typeId, SearchInfo searchInfo) throws DataAccessException,
            BusinessException {
        boolean isAdmin = this.bulTypeManager.isManagerOfType(typeId, userId);
        UserInfo userInfo = new UserInfo(isAdmin ? Constants.VisitRole.Admin : Constants.VisitRole.User, userId,
                orgManager.getAllUserDomainIDs(userId), isAdmin);
        TypeInfo typeInfo = new TypeInfo(typeId);
        List<BulData> findBulDatas = BulletinHqlUtils.findBulDatas(userInfo, typeInfo, searchInfo, bulDataDao);
        this.getBulletinUtils().initList(findBulDatas);
        return findBulDatas;
}

    public List<BulData> findByReadUserByTypeContent(Long userId, Long typeId, SearchInfo searchInfo) throws DataAccessException,
    BusinessException {
    	boolean isAdmin = this.bulTypeManager.isManagerOfType(typeId, userId);
    	isAdmin=searchInfo!=null?isAdmin:false;
    	
    	UserInfo userInfo = new UserInfo(isAdmin ? Constants.VisitRole.Admin : Constants.VisitRole.User, userId,
    	        orgManager.getAllUserDomainIDs(userId), isAdmin);
    	TypeInfo typeInfo = new TypeInfo(typeId);
    	List<BulData> findBulDatas = BulletinHqlUtils.findBulDatas(userInfo, typeInfo, searchInfo, bulDataDao);
    	List<BulData> resultBulDatas=new ArrayList<BulData>();
    	for(BulData bdInfo:findBulDatas){
    		bdInfo.setContent(getBody(bdInfo.getId()).getContent());
    		resultBulDatas.add(bdInfo);
    		}
    	this.getBulletinUtils().initList(resultBulDatas);
    	return resultBulDatas;
}
    
    /**
     * 公告发起人：从单位公告列表页面点击公告发布按钮进入后看到的列表,也适用于集团公告、部门公告
     */
    public List<BulData> findWriteAll(Long typeId, Long userId) throws BusinessException {
        UserInfo userInfo = new UserInfo(Constants.VisitRole.Poster, userId);
        TypeInfo typeInfo = new TypeInfo(typeId);
        List<BulData> findBulDatas = BulletinHqlUtils.findBulDatas(userInfo, typeInfo, bulDataDao);
        this.getBulletinUtils().initList(findBulDatas);
        return findBulDatas;
    }

    /**
     * 将选中的公告置顶
     */
    public void top(List<Long> ids, Long typeId) throws BusinessException {
        List<BulData> dataList = this.bulDataDao.getTopedBulDatas(typeId);
        int newTop = 0;
        if (Strings.isNotEmpty(dataList)) {
            newTop = dataList.size();
            int alreadyTop = dataList.size();
            for (BulData topData : dataList) {
                topData.setTopOrder((byte) alreadyTop--);
                this.bulDataDao.update(topData);
            }
        }

        for (Long id : ids) {
            BulData data = this.getById(id);
            if (data.getState() != Constants.DATA_STATE_ALREADY_PUBLISH) { // 发布后才能置顶
                continue;
            }

            data.setTopOrder((byte) ++newTop);
            this.bulDataDao.update(data);
        }
    }

    /**
     * 对公告进行取消置顶操作
     * @param ids 要取消置顶的公告列表
     */
    public void cancelTop(List<Long> ids) {
        String hql = "update " + BulData.class.getName() + " as b set b.topOrder=:noTop where b.id in (:ids)";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("noTop", Byte.valueOf("0"));
        params.put("ids", ids);
        this.bulDataDao.bulkUpdate(hql, params);
    }

    public List<BulRead> getReadListByData(Long bulletinId) {
        return this.bulReadManager.getReadListByData(bulletinId);
    }

    @Deprecated
    public List<BulRead> getReadListByData(BulData data, Long userId) throws Exception {
        //		List<BulRead> readList = null;
        //
        //		boolean isManager = false;
        //		if(userId.longValue() == data.getCreateUser().longValue())
        //			isManager = true;
        //		else
        //			isManager = this.bulTypeManager.isManagerOfType(data.getTypeId(), userId);
        //
        //		if (isManager) {
        //			readList = this.bulReadManager.getReadListByData(data);
        //			for (BulRead read : readList) {
        //				if (read.getManagerId() != null) {
        //					read.setManagerName(this.getBulletinUtils().getMemberNameByUserId(read.getManagerId()));
        //				}
        //			}
        //		}
        //		return readList;
        return this.bulReadManager.getReadListByData(data.getId());
    }

    /** 按照不同统计类型，获取公告统计结果  */
    public List<Object[]> statistics(String type, final long bulTypeId) {
        return this.bulDataDao.getStatisticInfo(type, bulTypeId);
    }

    /** 管理员批量归档已发布的公告 */
    public void pigeonhole(List<Long> ids) {
        for (Long id : ids) {
            BulData data = this.getById(id);
            if (data.getState() != Constants.DATA_STATE_ALREADY_PIGEONHOLE) {
                data.setState(Constants.DATA_STATE_ALREADY_PIGEONHOLE);
                data.setTopOrder(Byte.valueOf("0"));
                this.updateDirect(data);

                // 移除缓存中公告,防止通过系统提示信息查看归档后的公告
                this.removeCache(id);
                
                bulTypeManager.updateTypeETagDate(String.valueOf(data.getTypeId()));
            }

            // 删除全文检索
            try {
                if (AppContext.hasPlugin("index")) {
                    indexManager.delete(id, ApplicationCategoryEnum.bulletin.getKey());
                }
            } catch (BusinessException e) {
                log.error("从indexManager删除检索项。", e);
            }
        }
    }

    /**
     * 公告管理员查询所有可管理的公告:板块管理页面点击板块名称进入
     */
    public List<BulData> findAll4Manager(Long typeId, SearchInfo searchInfo) throws BusinessException, Exception {
        UserInfo userInfo = new UserInfo(Constants.VisitRole.Admin);
        TypeInfo typeInfo = new TypeInfo(typeId);
        List<BulData> findBulDatas = BulletinHqlUtils.findBulDatas(userInfo, typeInfo, searchInfo, bulDataDao);
        this.getBulletinUtils().initList(findBulDatas);
        return findBulDatas;
    }

    /**
     * 获得某个公告板块下已经置顶的记录个数
     * @param typeId 公告板块ID
     */
    public int getTopedCount(final long typeId) {
        return this.bulDataDao.getTopedCount(typeId);
    }

    /**
     * 获取某个版块下面已经置顶的公告
     * @param bulTypeId
     */
    public List<BulData> getTopedBulDatas(Long bulTypeId) {
        return this.bulDataDao.getTopedBulDatas(bulTypeId);
    }

    /**
     * 更新某条公告的置顶数目
     * @param bulDataId		公告ID
     * @param newTopOrder	新的置顶数
     */
    public void updateTopOrder(Long bulDataId, Byte newTopOrder) {
        Map<String, Object> columns = new HashMap<String, Object>();
        columns.put("topOrder", newTopOrder);
        this.bulDataDao.update(bulDataId, columns);
    }

    /**
     * 在公告板块的置顶总个数变化之后，对已经置顶的公告进行处理，使其置顶状态与板块的置顶总数保持一致
     * @param oldTopCountStr  旧的板块置顶总数
     * @param newTopCountStr  新的板块置顶总数
     * @param bulTypeId       公告板块ID
     */
    public void updateTopOrder(String oldTopCountStr, String newTopCountStr, Long bulTypeId) {
        if (!oldTopCountStr.equals(newTopCountStr)) {
            int newTopCount = Integer.valueOf(newTopCountStr);
            List<BulData> topedBulDatas = this.getTopedBulDatas(bulTypeId);
            if (topedBulDatas != null && topedBulDatas.size() > 0) {
                int topOrderNum = newTopCount;
                for (int i = 0; i < topedBulDatas.size(); i++) {
                    BulData bulData = topedBulDatas.get(i);

                    if (i <= newTopCount - 1) {
                        this.updateTopOrder(bulData.getId(), Byte.valueOf(topOrderNum + ""));
                        topOrderNum--;
                    } else {
                        this.updateTopOrder(bulData.getId(), Byte.valueOf(0 + ""));
                    }
                }
            }
        }
    }

    /**
     * 单位空间是否显示管理按钮
     */
    public boolean showManagerMenu(long memberId) {
        List<BulType> types = this.bulTypeManager.getAuditUnitBulTypeOnlyByMember(memberId);
        if (CollectionUtils.isNotEmpty(types)) {
            return true;
        } else {
            try {
                types = this.getTypeListOnlyByMemberId(memberId, true);
            } catch (Exception e) {
                log.error("", e);
            }
            return CollectionUtils.isNotEmpty(types);
        }
    }

    /**
     * 在用户所登录的单位空间是否显示管理按钮?
     */
    public boolean showManagerMenuOfLoginAccount(long memberId) {
        List<BulType> types = this.bulTypeManager.getAuditUnitBulType(memberId);
        if (CollectionUtils.isNotEmpty(types)) {
            return true;
        } else {
            try {
                types = this.getTypeList(memberId, true);
            } catch (Exception e) {
                log.error("", e);
            }
            return CollectionUtils.isNotEmpty(types);
        }
    }

    /**
     * 在用户所登录的自定义单位/集团空间是否显示管理按钮
     */
    public boolean showManagerMenuOfCustomSpace(long memberId, long spaceId, int spaceType) {
        List<BulType> types = this.bulTypeManager.getAuditUnitBulType(memberId, spaceId, spaceType);
        if (CollectionUtils.isNotEmpty(types)) {
            return true;
        } else {
            try {
                types = this.getTypeList(memberId, spaceId, spaceType);
            } catch (Exception e) {
                log.error("", e);
            }
            return CollectionUtils.isNotEmpty(types);
        }
    }

    /**
     * 判断某个审核员是否有未审核事项
     */
    public boolean hasPendingOfUser(Long userId, Long... typeIds) {
        List<BulData> list = this.getPendingData(userId, typeIds);
        return CollectionUtils.isNotEmpty(list);
    }
    //客开 start
    /**
     * 判断某个排版员是否有未排版事项
     */
    public boolean hasPending2OfUser(Long userId, Long... typeIds){
      List<BulData> list = this.getPending2Data(userId, typeIds);
      return Strings.isNotEmpty(list);
    }

    private List<BulData> getPending2Data(Long userId, Long... typeIds){
      if(userId == null)
          return null;

      List<BulType> auditTypes = this.bulTypeManager.getPaiBanTypeByMember(userId, null, null);
      Set<Long> idset = null;
      if (Strings.isEmpty(auditTypes)) {
          return new ArrayList<BulData>();
      } else {
          idset = BulletinUtils.getIdSet(auditTypes);
      }

      Set<Long> set = new HashSet<Long>();
      if(typeIds != null && typeIds.length > 0){
          for(Long id : typeIds){
              if(idset.contains(id))
                  set.add(id);
          }
      }else{
          set = idset;
      }
      String hql = "from BulData as t where t.typeId in (:ids) and t.state=:state and deletedFlag = false ";
      Map<String, Object> params = new HashMap<String, Object>();
      params.put("ids", set);
      params.put("state", Constants.DATA_STATE_TYPESETTING_CREATE);
      return this.bulDataDao.find(hql, params);
  }

    //客开end

    /**
     * 得到某个用户需要审核的数据
     */
    @SuppressWarnings("unchecked")
    public List<BulData> getPendingData(Long userId, Long... typeIds) {
        if (userId == null){
            return null;
        }

        List<BulType> auditTypes = this.bulTypeManager.getAuditTypeByMember(userId, null, null);
        Set<Long> idset = null;
        if (Strings.isEmpty(auditTypes)){
            return new ArrayList<BulData>();
        } else{
            idset = BulletinUtils.getIdSet(auditTypes);
        }

        Set<Long> set = new HashSet<Long>();
        if (typeIds != null && typeIds.length > 0) {
            for (Long id : typeIds) {
                if (idset.contains(id)){
                    set.add(id);
                }
            }
        } else {
            set = idset;
        }
        String hql = "from BulData as t where t.typeId in (:ids) and t.state=:state and deletedFlag = false ";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("ids", set);
        params.put("state", Constants.DATA_STATE_ALREADY_CREATE);
        return this.bulDataDao.find(hql, params);
    }

    /**
     * 该板块存在待审核公告，但当时的审核员已不可用，如果随后该板块设定了新的审核员，需要将原先的待审核公告转给新的审核员
     * @param bulTypeId    对应的公告板块ID
     * @param oldAuditorId 旧审核员ID(对应人员已不可用)
     * @param newAuditorId 新审核员ID
     */
    public void transferWait4AuditBulDatas2NewAuditor(Long bulTypeId, Long oldAuditorId, Long newAuditorId) {
        this.bulDataDao.transfer2NewAuditor(bulTypeId, oldAuditorId, newAuditorId);
    }

    //客开 start
    public void transferWait4AuditBulDatas2NewTypesettingStaff(Long newsTypeId, Long oldTypesettingStaff, Long typesettingStaff) {
      this.bulDataDao.transfer2NewTypesettingStaff(newsTypeId, oldTypesettingStaff, typesettingStaff);
    }
    //客开 end

    /**
     * 得到状态
     */
    public int getStateOfData(long id) {
        BulData data = this.getById(id);
        return data == null ? 0 : data.getState();
    }

    /**
     * 判断公告板块审核员是否可用
     * @param typeId
     * @return
     */
    public boolean isAuditUserEnabled(Long typeId) throws Exception {
        BulType type = this.bulTypeManager.getById(typeId);
        V3xOrgMember auditUser = this.orgManager.getMemberById(type.getAuditUser());
        if (auditUser != null) {
            if (!auditUser.getEnabled() || auditUser.getIsDeleted()) {
                return false;
            }
        }else if(type.isAuditFlag()){
        	return false;
        }
        return true;
    }

    /**
     * 客开 判断新闻板块排版员是否可用
     */
    public boolean isTypesettingStaffEnabled(Long typeId) throws Exception {
      BulType type = this.bulTypeManager.getById(typeId);
      V3xOrgMember auditUser = this.orgManager.getMemberById(type.getTypesettingStaff());
      if(auditUser != null){
        if(!auditUser.getEnabled() || auditUser.getIsDeleted()){
          return false;
        }
      }else if(type.isTypesettingFlag()){
        return false;
      }
      return true;
    }
    //客开 end

    public boolean typeExist(long typeId) {
        BulType type = bulTypeManager.getById(typeId);
        if (type == null) {
            try {
                V3xOrgDepartment dept = orgManager.getDepartmentById(typeId);
                if (dept == null) {
                    return false;
                } else {
                    bulTypeManager.createBulTypeByDept(dept.getId(), dept.getName(), SpaceType.department.ordinal());
                    return true;
                }
            } catch (BusinessException e) {
            	log.error("按id取部门异常", e);
                return false;
            }
        } else {
            return type.isUsedFlag();
        }
    }

    /** 综合查询  
     * @throws BusinessException */
    public List<BulData> iSearch(ConditionModel cModel) throws BusinessException {
        UserInfo userInfo = BulletinHqlUtils.getUserInfo(cModel, orgManager);
        SearchInfo searchInfo = BulletinHqlUtils.getSearchInfo(cModel);
        TypeInfo typeInfo = new TypeInfo(SpaceType.personal); //这里使用文化建设使用不到的枚举
        List<BulData> list = BulletinHqlUtils.findBulDatas(userInfo, typeInfo, searchInfo, bulDataDao);
        this.getBulletinUtils().initList(list);
        return list;
    }

    /** 取正文  */
    public BulBody getBody(long bulDataId) {
		BulBody body = this.bulBodyDao.getByDataId(bulDataId);
		String content = HtmlMainbodyHandler.replaceInlineAttachment(body.getContent());
		body.setContent(content);
		return body;
    }

    /** 根据附件ID取正文  */
    public BulBody getBodyByFileId(String fileId) {
        return this.bulBodyDao.getByFileId(fileId);
    }

    /**
     * 协同转公告
     */
    public void saveCollBulletion(BulData data) throws BusinessException {
        //板块类型
        BulType type = data.getType();
        if (type == null) {
            Long typeId = data.getTypeId();
            type = this.bulTypeManager.getById(typeId);
            data.setType(type);
        }
        //状态
        if (data.getState() == null) {
            data.setState(Constants.DATA_STATE_ALREADY_PUBLISH);
        }

        boolean isNew = true;
        if (Strings.isBlank(data.getExt1())) {
        	data.setExt1("1");
        }
        this.save(data, isNew);//保存

        //全文检索
        try {
            if (data.getState() == Constants.DATA_STATE_ALREADY_PUBLISH) {
                if (AppContext.hasPlugin("index")) {
                    indexManager.add(data.getId(), ApplicationCategoryEnum.bulletin.getKey());
                }
            }
        } catch (Exception e) {
            log.error("全文检索：", e);
        }
    }

    /**
     * 更新公告的被点击次数
     */
    public void updateClick(long dataId, int clickNumTotal, Collection<ClickDetail> details) {
        String hql = "update BulData set readCount = ? where id = ?";
        this.bulDataDao.bulkUpdate(hql, null, clickNumTotal, dataId);
    }

    /**
     * 获取公告模块的锁操作信息，用于前端展现、测试之用
     */
    public Map<Long, BulDataLock> getLockInfo4Dump() {
        return this.buldataLockMap;
    }

    /**
     * 编辑或审核时加锁，保证操作同步性
     */
    public BulDataLock lock(Long buldatasid, String action) {
        return this.lock(buldatasid, AppContext.getCurrentUser().getId(), action);
    }

    /**
     * 编辑或审核时加锁，保证操作同步性
     */
    public BulDataLock lock(Long buldatasid, Long currentUserId, String action) {
        //进行文件锁的检查,方件锁是接口中的一个对象是不会抛空指针的
        BulDataLock bullock = null;
        if (this.buldataLockMap == null)
            this.buldataLockMap = new HashMap<Long, BulDataLock>();

        if (this.buldataLockMap.containsKey(buldatasid)) {
            //文件已加锁
            bullock = this.buldataLockMap.get(buldatasid);
            /**
             * 如果操作类型相同，且锁的对象与当前用户相同，也允许用户继续进行同一操作
             * 仅当两种不同操作同时在进行时，锁才确定生效，比如同一人进行编辑和审核操作，或者两人分别进行编辑或审核操作
             */
            if (bullock.getUserid() == currentUserId && action.equals(bullock.getAction()))
                return null;
            return bullock;
        } else {
            //文件没有加锁,对其加锁,继续进行相关的操作
            bullock = new BulDataLock();
            bullock.setNewsid(buldatasid);
            bullock.setUserid(currentUserId);
            bullock.setAction(action);
            this.buldataLockMap.put(buldatasid, bullock);
            //发送通知
            NotificationManager.getInstance().send(NotificationType.BulletinLock, bullock);
            return null;
        }
    }

    /**
     * 编辑或审核操作完成之后进行解锁，让他人可以对该公告继续进行操作
     */
    @AjaxAccess
    public void unlock(Long buldatasid) {
        if (this.buldataLockMap == null) {
            this.buldataLockMap = new HashMap<Long, BulDataLock>();
        }
        if (this.buldataLockMap.containsKey(buldatasid)) {
            this.buldataLockMap.remove(buldatasid);
            // 发送通知
            NotificationManager.getInstance().send(NotificationType.BulletinUnLock, buldatasid);
        }
    }

	/** 获取公告信息，用户AJAX调用 */
	@AjaxAccess
	public Map<String, String> getBulData(String bulTypeId) throws BusinessException {
		BulData bean = new BulData();
		User user = AppContext.getCurrentUser();
		bean.setCreateDate(new Timestamp(System.currentTimeMillis()));
		bean.setCreateUser(user.getId());
		bean.setState(Constants.DATA_STATE_NO_SUBMIT);
		bean.setDataFormat(com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_HTML);
		bean.setReadCount(0);
		BulType type = bulTypeManager.getById(Long.valueOf(bulTypeId));
		bean.setTypeId(Long.valueOf(bulTypeId));
		bean.setType(type);
		bean.setTypeName(type.getTypeName());
		String publisthScopeDep2 = "";
		String publisthScopeDepName = "";
		String deptName = "";
		// 对部门公告的发布范围单独处理,需要加上本部门,部门访问者,
		if (type.getSpaceType().intValue() == SpaceType.department.ordinal()) {
			StringBuilder publisthScopeDep = new StringBuilder();
			publisthScopeDep = publisthScopeDep.append("Department|" + type.getId().toString());
			publisthScopeDepName += orgManager.getDepartmentById(type.getId()).getName() + "、";
			deptName = orgManager.getDepartmentById(type.getId()).getName();
			Long deptSpaceId = type.getId();
			List<PortalSpaceFix> spacePath = this.spaceManager.getAccessSpace(user.getId(), user.getLoginAccount());
			if (spacePath != null && spacePath.size() > 0) {
				for (PortalSpaceFix portalSpaceFix : spacePath) {
					if (Strings.isNotBlank(bulTypeId)
							&& bulTypeId.equals(String.valueOf(portalSpaceFix.getEntityId()))) {
						deptSpaceId = portalSpaceFix.getId();
					}
				}
			}
			List<Object[]> _issueAreas = this.spaceManager.getSecuityOfSpace(deptSpaceId);
			for (Object[] objects : _issueAreas) {
				if (V3xOrgEntity.ORGENT_TYPE_DEPARTMENT.equalsIgnoreCase(objects[0] + "")
						&& type.getId() != ((Long) objects[1]).longValue()) {
					publisthScopeDep = publisthScopeDep.append(",Department|" + objects[1]);
					publisthScopeDepName += orgManager.getDepartmentById(Long.valueOf(objects[1].toString())).getName()
							+ "、";
				} else if (V3xOrgEntity.ORGENT_TYPE_MEMBER.equalsIgnoreCase(objects[0] + "")) {
					// 人员的ID是当前部门的,应该去掉
					if (!orgManager.getMemberById((Long) objects[1]).getOrgDepartmentId().equals(user.getDepartmentId())) {
						publisthScopeDep = publisthScopeDep.append(",Member|" + objects[1]);
						publisthScopeDepName += orgManager.getMemberById(Long.valueOf(objects[1].toString())).getName()
								+ "、";
					}
				} else if (V3xOrgEntity.ORGENT_TYPE_TEAM.equalsIgnoreCase(objects[0] + "")) {
					publisthScopeDep = publisthScopeDep.append(",Team|" + objects[1]);
					publisthScopeDepName += orgManager.getTeamById(Long.valueOf(objects[1].toString())).getName() + "、";
				}
			}
			publisthScopeDep2 = publisthScopeDep.toString();
			String[] arryDepartment = publisthScopeDep2.split("\\|");
			try {
				if ("".equals(publisthScopeDepName)) {
					publisthScopeDepName = orgManager.getDepartmentById(Long.valueOf(arryDepartment[1].split(",")[0]))
							.getName();
				} else {
					publisthScopeDepName = publisthScopeDepName.substring(0, publisthScopeDepName.length() - 1);
				}
			} catch (Exception e) {
				log.error("", e);
			}
		}

		// 设置发布部门
		if (bean.getPublishDepartmentId() == null) {
			// 设置为发起者所在部门
			Long userId = bean.getCreateUser();
			Long depId = this.getBulletinUtils().getMemberById(userId).getOrgDepartmentId();
			bean.setPublishDepartmentId(depId);
		}
		Map<String, String> bulDataNew = new HashMap<String, String>();

		bulDataNew.put("typeId", String.valueOf(type.getId()));
		bulDataNew.put("typeName", type.getTypeName());
		bulDataNew.put("publishDepartmentId", String.valueOf(type.getId()));
		bulDataNew.put("publishDepartmentName", deptName);
		bulDataNew.put("issueArea", publisthScopeDep2);
		bulDataNew.put("issueAreaName", publisthScopeDepName);
		bulDataNew.put("bulTypeId", bulTypeId);
		return bulDataNew;
	}

    /**
     * 查看某个公告板块下是否存在未归档、不是暂存并且没有删除的公告
     * @param typeId
     * @return
     */
    public int findAllWithOutFilterTotal(Long typeId) {
        return this.bulDataDao.findAllWithOutFilterTotal(typeId);
    }

    /**
     * 格式化日期
     * @param dateStr 字符型日期
     * @param format 格式
     * @return 返回日期
     */
    public static java.util.Date parseDate(String dateStr, String format) {
        java.util.Date date = null;
        try {
            String dt = dateStr.replaceAll("-", "/");
            if ((!"".equals(dt)) && (dt.length() < format.length())) {
                dt += format.substring(dt.length()).replaceAll("[YyMmDdHhSs]", "0");
            }
            date = Datetimes.parse(dt, format);
        } catch (Exception e) {
        	log.error("格式化日期异常", e);
        }
        return date;
    }

    public List<BulData> findListBulDatas(User user, int spaceType, SearchInfo searchInfo) throws BusinessException {
        UserInfo userInfo = BulletinHqlUtils.getUserInfo(user, orgManager);
        TypeInfo typeInfo = new TypeInfo(Constants.valueOfSpaceType(spaceType));
        typeInfo.setAccountId(user.getAccountId());
        typeInfo.setTypeId(searchInfo.getBulTypeId());
        List<BulData> list = BulletinHqlUtils.findBulDatas(userInfo, typeInfo, searchInfo, null, bulDataDao);
        this.getBulletinUtils().initList(list);
        return list;
    }

    /**
     * 为M1提供接口：获取指定公告板块中当前登陆用户有权限访问的公告数
     * @param typeId 板块ID，如果isDepartmentSpace=true，表示部门空间，typeId为部门ID；如果isDepartmentSpace=true=false，表示单位或者集团空间。
     * @param isDepartmentSpace true表示部门空间，false表示单位或者集团空间。如果为true，typeId为部门ID；否则，typeId为单位空间或者集团空间的公告板块ID。
     * @return 公告数
     * @throws DataAccessException
     * @throws BusinessException
     */
    public Long getBulDatasCount(Long typeId, boolean isDepartmentSpace) throws BusinessException {
        User user = AppContext.getCurrentUser();
        UserInfo userInfo = null;
        TypeInfo typeInfo = null;
        if (isDepartmentSpace) {
            userInfo = new UserInfo(Constants.VisitRole.User, user.getId());
            typeInfo = new TypeInfo(typeId, null, SpaceType.department);
        } else {
            boolean isAdmin = this.bulTypeManager.isManagerOfType(typeId, user.getId());
            userInfo = new UserInfo(Constants.VisitRole.User, user.getId(), orgManager.getAllUserDomainIDs(user.getId()), isAdmin);
            typeInfo = new TypeInfo(typeId);
        }
        return BulletinHqlUtils.getBulDatasCount(userInfo, typeInfo, bulDataDao);
    }

    private void addAdmins2MsgReceivers(Collection<Long> receivers, BulData bulData) {
        BulType bulType = this.bulTypeManager.getById(bulData.getTypeId());
        this.addAdmins2MsgReceivers(receivers, bulType);
    }

    private void addAdmins2MsgReceivers(Collection<Long> receivers, BulType bulType) {
        String managerIds = bulType.getManagerUserIds();
        if (Strings.isNotBlank(managerIds)) {
            String[] ids = managerIds.split(",");
            for (String id : ids) {
                Long addId = Long.parseLong(id);
                if (receivers != null && !receivers.contains(addId)) {
                    receivers.add(addId);
                }
            }
        }
    }

    public List<BulType> getAllCustomTypes() {
        return bulTypeManager.getAllCustomTypes();
    }

    public boolean messageRemind(String beanId,String remindType,String ids) throws BusinessException{
        Long dataId = NumberUtils.toLong(beanId);
        BulData bean = getBulDataCache().getDataCache().get(dataId);
        if (bean == null){
            bean = getById(dataId);
        }
        Set<Long> receiverIds = new HashSet<Long>();
        if("Member".equals(remindType)){//人员
            receiverIds.addAll(CommonTools.parseStr2Ids(ids, ","));
        }else if("Department".equals(remindType)){//部门
            Set<Long> sendMsgDeptIds = new HashSet<Long>();
            sendMsgDeptIds.addAll(CommonTools.parseStr2Ids(ids, ","));
            //取得已经阅读的所有的人员的列表
            List<BulRead> readList = this.getReadListByData(bean.getId());
            Set<Long> readerSet = new HashSet<Long>();
            for (BulRead bulRead : readList) {
                readerSet.add(bulRead.getManagerId());
            }
            //发布范围内的所有人员
            Set<Long> publishScopeMemberList = this.getAllMembersinPublishScope(bean);
            for (Long memberId : publishScopeMemberList) {
                V3xOrgMember member = orgManager.getMemberById(memberId);
                if (member == null || !member.isValid()) {
                    continue;
                }

                boolean isRead = readerSet.contains(member.getId());
                if (!isRead && sendMsgDeptIds.contains(member.getOrgDepartmentId())) {//未读
                    receiverIds.add(member.getId());
                } else {
                    List<Long> otherDepts = getOtherDepartmentIdList(member.getId()); //处理其他兼职部门
                    for (Long otherDeptId : otherDepts) {
                        if (otherDeptId != null && sendMsgDeptIds.contains(otherDeptId) && !isRead) {
                            receiverIds.add(member.getId());
                        }
                    }
                }
            }
        }
        //发送催办消息，某某请您尽快查看公告《》
        if (!receiverIds.isEmpty()) {
            final String msgKey = "bul.remind.soon.see";
            Object[] msgContents = {AppContext.currentUserName(), bean.getTitle()};
            MessageContent cont = MessageContent.get(msgKey, msgContents);
            Collection<MessageReceiver> receivers = MessageReceiver.get(bean.getId(), receiverIds, "message.link.bulletin.open", com.seeyon.ctp.common.usermessage.Constants.LinkOpenType.open, bean.getId());
            userMessageManager.sendSystemMessage(cont, ApplicationCategoryEnum.bulletin, AppContext.currentUserId(), receivers, bean.getTypeId());
        }
        return true;
    }

    public List<Long> getOtherDepartmentIdList(Long memberId) throws BusinessException {
        List<Long> list = new ArrayList<Long>();
        List<V3xOrgAccount> accountList = orgManager.getConcurrentAccounts(memberId);
        if (accountList != null && !accountList.isEmpty()) {
            for (V3xOrgAccount account : accountList) {
                Map<Long, List<MemberPost>> map = orgManager.getConcurentPostsByMemberId(account.getId(), memberId);
                //Map<Long, List<ConcurrentPost>> map = null;

                Set<Long> set = map.keySet();
                list.addAll(set);
            }
        }
        return list;
    }

    /**
     * 辅助方法：获取公告发布范围内的全部人员ID集合
     */
    private Set<Long> getAllMembersinPublishScope(BulData bean) throws BusinessException {
        String publishScope = bean.getPublishScope();

        Set<V3xOrgMember> membersInScope = this.orgManager.getMembersByTypeAndIds(publishScope);
        Set<Long> memberIdsInScope = new HashSet<Long>();
        if (membersInScope != null && membersInScope.size() > 0) {
            for (V3xOrgMember member : membersInScope) {
                //if(member.isValid() && !member.getIsDeleted().booleanValue())
                // fenghao 去掉外部人员
                if (member.isValid() && !member.getIsDeleted().booleanValue() && member.getIsInternal()) {
                    memberIdsInScope.add(member.getId());
                }
            }
        }
        Long loginAccountId = AppContext.getCurrentUser().getLoginAccount();
        //处理跨单位兼职情况
        String[][] bulAuditIds = Strings.getSelectPeopleElements(publishScope);
        for (String[] typeAndId : bulAuditIds) {
            //发布范围为组时,单位公告不可以给组中外单位人员发送消息
            if(typeAndId[0].equals(V3xOrgEntity.ORGENT_TYPE_TEAM)) {
            	V3xOrgTeam team = orgManager.getTeamById(Long.valueOf(typeAndId[1]));
            	// 剔除非本单位人员
            	boolean needFilterOthers = team != null && bean.getType().getSpaceType() != SpaceType.group.ordinal();
            	if(needFilterOthers){
            		List<V3xOrgMember> teamMember = orgManager.getMembersByTeam(team.getId());
            		for(V3xOrgMember member : teamMember){
            			if(!member.getOrgAccountId().equals(loginAccountId) && orgManager.getConcurentPostsByMemberId(loginAccountId, member.getId()).isEmpty()){
            				memberIdsInScope.remove(member.getId());
            			}
            		}
            	}
            } else if (typeAndId[0].equals(V3xOrgEntity.ORGENT_TYPE_DEPARTMENT)) {
                List<V3xOrgMember> listMember = orgManager.getMembersByDepartment(Long.valueOf(typeAndId[1]), false);
                for (V3xOrgMember member : listMember) {
                    if (!memberIdsInScope.contains(member.getId())) {
                        memberIdsInScope.add(member.getId());
                    }
                }
            } else if (typeAndId[0].equals(V3xOrgEntity.ORGENT_TYPE_ACCOUNT)) {//仅当发送范围为单位时，才将兼职人员悉数加入，在发布范围为其他类型时，兼职人员已包含在范围内
                //考虑到集团公告情况下可以选择的发布范围为多个单位，此处的参数不应限定为只是当前用户登陆的单位
                Map<Long, List<V3xOrgMember>> accJian = orgManager
                        .getConcurentPostByAccount(Long.valueOf(typeAndId[1]));
                Set<Entry<Long, List<V3xOrgMember>>> accSet = accJian.entrySet();
                for (Iterator<Entry<Long, List<V3xOrgMember>>> iter = accSet.iterator(); iter.hasNext();) {
                    Map.Entry<Long, List<V3xOrgMember>> ele = (Entry<Long, List<V3xOrgMember>>) iter.next();
                    for (Iterator<V3xOrgMember> iterator = ele.getValue().iterator(); iterator.hasNext();) {
                        V3xOrgMember mem = (V3xOrgMember) iterator.next();
                        if (!memberIdsInScope.contains(mem.getId())) {
                            memberIdsInScope.add(mem.getId());
                        }
                    }
                }
            }
        }
        return memberIdsInScope;
    }

    public boolean checkScope(Long userId, Long bulDataId) throws BusinessException {
        BulData bulData = this.getById(bulDataId);
        Long createId = bulData.getCreateUser();
        Long publishId = bulData.getPublishUserId();
        Long auditId = bulData.getAuditUserId();
        String scopeId = bulData.getPublishScope();
        //部门空间、自定义团队空间， 空间管理员默认有权限
        if (bulData.getType().getSpaceType() == SpaceType.department.ordinal() || bulData.getType().getSpaceType() == SpaceType.custom.ordinal()) {
            List<Long> managerSpaces = spaceManager.getCanManagerSpace(userId);
            if (CollectionUtils.isNotEmpty(managerSpaces) && managerSpaces.contains(bulData.getType().getId())) {
                return true;
            }
        }
        boolean isManager = this.bulTypeManager.isManagerOfType(bulData.getTypeId(), userId);
        if (userId.equals(createId) || userId.equals(publishId) || userId.equals(auditId) || isManager) {
            return true;
        } else {
            List<Long> scopeIds = CommonTools.parseTypeAndIdStr2Ids(scopeId);
            List<Long> ids = orgManager.getAllUserDomainIDs(userId);

            List<Long> intersectIds = Strings.getIntersection(scopeIds, ids);
            if (Strings.isNotEmpty(intersectIds)) {
                return true;
            }
        }
        return false;
    }

    public void setFileManager(FileManager fileManager) {
        this.fileManager = fileManager;
    }

    public void setBulPublishScopeDao(BulPublishScopeDao bulPublishScopeDao) {
        this.bulPublishScopeDao = bulPublishScopeDao;
    }

    public void setIndexManager(IndexManager indexManager) {
        this.indexManager = indexManager;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void setAttachmentManager(AttachmentManager attachmentManager) {
        this.attachmentManager = attachmentManager;
    }

    public void setBulDataDao(BulDataDao bulDataDao) {
        this.bulDataDao = bulDataDao;
    }

    public void setBulTypeManager(BulTypeManager bulTypeManager) {
        this.bulTypeManager = bulTypeManager;
    }

    public void setBulReadManager(BulReadManager bulReadManager) {
        this.bulReadManager = bulReadManager;
    }

    public void setSpaceManager(SpaceManager spaceManager) {
        this.spaceManager = spaceManager;
    }

    @Override
    @AjaxAccess
    public FlipInfo bulletinStc(FlipInfo fif, Map<String, Object> params) {
        String stcWay = params.get("stcWay").toString();
        FlipInfo fi = new FlipInfo();
        if ("publishNum".equals(stcWay)) {
            return bulletinPublishNumStc(fi, params);
        } else if ("publishMember".equals(stcWay)) {
            return bulletinPublishMemberStc(fi, params);
        } else if ("clickNum".equals(stcWay)) {
            return bulletinClickNumStc(fi, params);
        } else {//state
            return bulletinStateStc(fi, params);
        }
    }

    /**
     * bulletin发布量统计
     */
    public FlipInfo bulletinPublishNumStc(FlipInfo fif, Map<String, Object> params) {
        Map<String, Object> hparam = buildBulParam(params);
        FlipInfo fip = new FlipInfo();
        if ("day".equals(params.get("stcBy"))) {//汇总
            StringBuilder hql = new StringBuilder("from BulData bul where bul.publishDate >= :sDate and bul.publishDate<=:eDate");
            hql.append(" and bul.typeId=:typeId and bul.deletedFlag=:deletedFlag and bul.state in(:state) ");
            Integer count = DBAgent.count(hql.toString(), hparam);
            List<BulStcVo> stcList = new ArrayList<BulStcVo>();
            stcList.add(new BulStcVo(BulTypeCastUtil.toString(params.get("publishDateStart"))
                    + " ~ " + BulTypeCastUtil.toString(params.get("publishDateEnd")), count));
            fip.setData(stcList);
        } else {//按月，年汇总
            hparam.put("dateBetween", 1);
            String stcBy = BulTypeCastUtil.toString(params.get("stcBy"));
            String[] sqlCols = new String[] { stcBy };
            String[] orderBys = new String[] { stcBy + " desc" };
            BulParseStcXmlUtil.DbSql dbsql = BulParseStcXmlUtil.buildDbSql("bul", sqlCols, orderBys, "publishNum", hparam);
            List<Map<String, Object>> dataList = exeQuerySql(dbsql.getSql(), dbsql.getParamList());
            List<BulStcVo> stcList = ParamUtil.mapsToBeans(dataList, BulStcVo.class, false);
            buildNullTime(params,stcList);
            fip.setData(stcList);
        }
        return fip;
    }


    private Map<String, Object> buildBulParam(Map<String, Object> params) {
        //spaceType = TypeCastUtil.toLong(params.get("spaceType")), spaceId = TypeCastUtil.toLong(params.get("spaceId"))
        Map<String, Object> hparam = new HashMap<String, Object>();
        hparam.put("typeId", BulTypeCastUtil.toLong(params.get("typeId")));
            hparam.put("deletedFlag", Boolean.FALSE);
            hparam.put("state", CommonTools.newArrayList(Constants.DATA_STATE_ALREADY_PUBLISH,
                    Constants.DATA_STATE_ALREADY_PIGEONHOLE));

        hparam.put("sDate", BulTypeCastUtil.toSDate(params.get("publishDateStart")));
        hparam.put("eDate", BulTypeCastUtil.toEDate(params.get("publishDateEnd")));
        if (!"day".equals(params.get("stcBy"))) {
            hparam.put("deletedFlag", 0);
        }
        return hparam;
    }

    @SuppressWarnings("unchecked")
    private List<Map<String, Object>> exeQuerySql(String sql, List<Object> params) {
        JDBCAgent queryAgent = new JDBCAgent(true);
        try {
            queryAgent.execute(sql, params);
            return queryAgent.resultSetToList();
        } catch (Exception e) {
            log.error("", e);
        } finally {
            queryAgent.close();
        }
        return Collections.emptyList();
    }

    private void buildNullTime(Map<String, Object> params, List<BulStcVo> stcList) {
        String stcBy = BulTypeCastUtil.toString(params.get("stcBy"));
        if("month".equals(stcBy)){
            Date sDate = BulTypeCastUtil.toDate(params.get("publishDateStart")),
                 eDate = BulTypeCastUtil.toDate(params.get("publishDateEnd"));
            int monthDif = DateUtil.beforeMonths(sDate, eDate) +1 ;
            List<String> stcs = new ArrayList<String>();
            for (BulStcVo stcVo : stcList) {
                stcs.add(stcVo.getStcTime());
            }
            for (int i = 0; i < monthDif; i++) {
                Date cDate = DateUtil.addMonth(eDate, -i);
                String stcTime = DateUtil.format(cDate, "yyyy-MM");
                if (!stcs.contains(stcTime)) {
                	BulStcVo stcVo = new BulStcVo();
                    stcVo.setStcTime(stcTime);
                    stcList.add(stcVo);
                }
            }
        }else if("year".equals(stcBy)){
            int sYear = BulTypeCastUtil.toInteger(params.get("publishDateStart")),
                eYear = BulTypeCastUtil.toInteger(params.get("publishDateEnd"));
            int yearNum = eYear - sYear + 1;
            List<String> stcs = new ArrayList<String>();
            for (BulStcVo stcVo : stcList) {
                stcs.add(stcVo.getStcTime());
            }

            for (int i = 0; i < yearNum; i++) {
                String cyear = String.valueOf(eYear - i);
                if (!stcs.contains(cyear)) {
                	BulStcVo stcVo = new BulStcVo();
                    stcVo.setStcTime(cyear);
                    stcList.add(stcVo);
                }
            }
        }

        if ("month".equals(stcBy) || "year".equals(stcBy)) {
            Collections.sort(stcList, new Comparator<BulStcVo>() {
                @Override
                public int compare(BulStcVo o1, BulStcVo o2) {
                    return (int)((BulTypeCastUtil.toDate(o2.getStcTime()).getTime() - BulTypeCastUtil.toDate(o1.getStcTime()).getTime())/1000);
                }
            });
        }
    }

    /**
     * bulletin发起者统计
     */
    public FlipInfo bulletinPublishMemberStc(FlipInfo fif, Map<String, Object> params) {
        Map<String, Object> hparam = buildBulParam(params);
        FlipInfo fi = new FlipInfo();
        if ("day".equals(params.get("stcBy"))) {//汇总
            String stcTo = BulTypeCastUtil.toString(params.get("stcTo"));
            String select = "m.orgDepartmentId as deptId,bul.publishUserId as memberId,",
                   groupBy = ",m.orgDepartmentId,bul.publishUserId ";
            if ("dept".equals(stcTo)) {
                select = "m.orgDepartmentId as deptId,";
                groupBy = ",m.orgDepartmentId ";
            } else if ("acc".equals(stcTo)) {
                select = "";
                groupBy = " ";
            }

            StringBuilder hql = new StringBuilder("select new map(m.orgAccountId as accId,");
            hql.append(select).append("count(*) as stcNum) ");
            hql.append("from BulData bul,OrgMember m ");
            hql.append("where bul.publishUserId=m.id and bul.publishDate >= :sDate and bul.publishDate<=:eDate ");
            hql.append("and bul.typeId=:typeId and bul.deletedFlag=:deletedFlag and bul.state in(:state) ");
            hql.append("group by m.orgAccountId").append(groupBy);
            hql.append("order by count(*) desc");
            List<Map<String, Object>> dataList = DBAgent.find(hql.toString(), hparam);
            List<BulStcVo> stcList = ParamUtil.mapsToBeans(dataList, BulStcVo.class, false);
            initOrgInfo(stcList,stcTo);
            fi.setData(stcList);
        } else {//按月，年汇总
            hparam.put("dateBetween", 1);
            String stcTo = BulTypeCastUtil.toString(params.get("stcTo"));
            String stcBy = BulTypeCastUtil.toString(params.get("stcBy"));
            List<String> stcTos = CommonTools.newArrayList("acc", stcBy);
            if ("member".equals(stcTo)) {
                stcTos.add("dept");
                stcTos.add("member");
            } else if ("dept".equals(stcTo)) {
                stcTos.add("dept");
            }
            BulParseStcXmlUtil.DbSql dbsql = BulParseStcXmlUtil.buildDbSql("bul",
            stcTos.toArray(new String[] {}), new String[] { stcBy + " desc" }, "publishNum", hparam);
            List<Map<String, Object>> dataList = exeQuerySql(dbsql.getSql(), dbsql.getParamList());
            fi.setData(mergeToMap(dataList));
        }
        return fi;
    }

    private List<Map<String, Object>> mergeToMap(List<Map<String, Object>> dataList) {
        List<BulStcVo> stcList = ParamUtil.mapsToBeans(dataList, BulStcVo.class, false);
        List<BulStcVo> mergeList = new ArrayList<BulStcVo>();
        for (BulStcVo stc : stcList) {
            int index = mergeList.indexOf(stc);
            if (index != -1) {
                mergeList.get(index).mergeToMap(stc);
            } else {
                stc.mergeToMap(stc);
                mergeList.add(stc);
            }
        }
        initOrgInfo(mergeList,null);
        List<Map<String, Object>> mergeMap = new ArrayList<Map<String, Object>>();
        for (BulStcVo stc : mergeList) {
            mergeMap.add(stc.valueOfMap());
        }
        return mergeMap;
    }

    private void initOrgInfo(List<BulStcVo> stcList, String stcTo) {
        try {
            for (BulStcVo stcVo : stcList) {
                if (stcVo.getAccId() != null) {
                    V3xOrgAccount acc = orgManager.getAccountById(stcVo.getAccId());
                    if (acc == null) {
                        PortalSpaceFix spaceFix = spaceManager.getSpaceFix(stcVo.getAccId());
                        if (spaceFix != null) {
                            stcVo.setAccName(spaceFix.getSpacename());
                        }
                    } else {
                        stcVo.setAccName(acc.getName());
                    }
                }
                if (stcVo.getDeptId() != null) {
                    V3xOrgDepartment dept = orgManager.getDepartmentById(stcVo.getDeptId());
                    if (dept == null) {
                        PortalSpaceFix spaceFix = spaceManager.getSpaceFix(stcVo.getDeptId());
                        if (spaceFix != null) {
                            stcVo.setDeptName(spaceFix.getSpacename());
                        }
                    } else {
                        stcVo.setDeptName(dept.getName());
                    }
                }
                if (stcVo.getMemberId() != null) {
                    stcVo.setMemberName(Functions.showMemberName(stcVo.getMemberId()));
                }
            }
        } catch (BusinessException e) {
            log.error("文化建设统计", e);
        }
    }


    /**
     * bulletin点击数
     */
    public FlipInfo bulletinClickNumStc(FlipInfo fif, Map<String, Object> params) {
        StringBuilder hql = new StringBuilder("select new map(bul.title as stcTitle,bul.publishUserId as memberId,bul.readCount as stcNum) ");
        hql.append("from BulData bul where bul.publishDate >= :sDate and bul.publishDate<=:eDate ");
        hql.append("and bul.typeId=:typeId and bul.deletedFlag=:deletedFlag and bul.state in(:state) ");
        hql.append("order by bul.readCount desc");
        Map<String, Object> hparam = buildBulParam(params);
        FlipInfo fi = new FlipInfo();
        List<Map<String, Object>> dataList = DBAgent.find(hql.toString(), hparam);
        List<BulStcVo> stcList = ParamUtil.mapsToBeans(dataList, BulStcVo.class, false);
        initOrgInfo(stcList,null);
        fi.setData(stcList);
        return fi;
    }

    /**
     * bulletin状态
     */
    public FlipInfo bulletinStateStc(FlipInfo fif, Map<String, Object> params) {
        StringBuilder hql = new StringBuilder("select new map(bul.state as state,count(*) as stcNum) ");
        hql.append("from BulData bul where bul.publishDate >= :sDate and bul.publishDate<=:eDate ");
        hql.append("and bul.typeId=:typeId and bul.deletedFlag=:deletedFlag and bul.state in(:state) ");
        hql.append("group by bul.state ");
        hql.append("order by bul.state asc");
        FlipInfo fi = new FlipInfo();
        Map<String, Object> hparam = buildBulParam(params);
        List<Map<String, Object>> dataList = DBAgent.find(hql.toString(), hparam);
        List<BulStcVo> stcList = ParamUtil.mapsToBeans(dataList, BulStcVo.class, false);
        buildNullState(stcList,"bulletin");
        fi.setData(stcList);
        return fi;
    }

    private void buildNullState(List<BulStcVo> stcList, String mode) {
        List<Integer> stcs = new ArrayList<Integer>();
        List<Integer> states = new ArrayList<Integer>();
        for (BulStcVo stcVo : stcList) {
            stcs.add(stcVo.getState());
        }
        if ("bulletin".equals(mode)) {
            states.add(Constants.DATA_STATE_ALREADY_PUBLISH);
            if (AppContext.hasPlugin("doc")) {
                states.add(Constants.DATA_STATE_ALREADY_PIGEONHOLE);
            }
        }

        for (Integer state : states) {
            if (!stcs.contains(state)) {
                BulStcVo stcVo = new BulStcVo();
                stcVo.setState(state);
                stcList.add(stcVo);
            }
        }

        Collections.sort(stcList, new Comparator<BulStcVo>() {
            @Override
            public int compare(BulStcVo o1, BulStcVo o2) {
                return o1.getState() - o2.getState();
            }
        });
    }

	@Override
    public Map<String, Object> getTypeByMode(String mode, String sTypeId) {
        Map<String, Object> show = new HashMap<String, Object>();
        Long typeId = BulTypeCastUtil.toLong(sTypeId);
        if ("bulletin".equals(mode)) {
            BulType type = DBAgent.get(BulType.class, typeId);
            if (type != null) {
                List<Integer> showAccList = CommonTools.newArrayList(3, 4, 17);
                List<Integer> hideDeptList = CommonTools.newArrayList(1);
                show.put("hideAcc", !showAccList.contains(type.getSpaceType()));
                show.put("hideDept", hideDeptList.contains(type.getSpaceType()));
            }
        }
        return show;
    }

	@Override
    public DataRecord expStcToXls(Map<String, Object> params) {
        String mode = BulTypeCastUtil.toString(params.get("mode"));//news,
        DataRecord record = new DataRecord();
        record.setTitle(BulTypeCastUtil.toString(params.get("title")));
        record.setSheetName("sheet1");
        List<?> datas= null;
        if ("bulletin".equals(mode)) {
            datas = bulletinStc(null, params).getData();
        }
        List<String> nameIds = new ArrayList<String>();
        List<String> colNames = new ArrayList<String>();
        initColName2Id(nameIds,colNames,params);
        if (datas != null) {
            for (Object o : datas) {
                if (o instanceof BulStcVo) {
                    record.addDataRow(buildRow(nameIds, ParamUtil.beanToMap(o, new HashMap(), false),mode));
                } else {
                    record.addDataRow(buildRow(nameIds, (Map) o,mode));
                }
            }
        }

        short[] colWidths = new short[nameIds.size()];
        for (int i = 0; i < colWidths.length; i++) {
            colWidths[i] = 30;
        }
        record.setColumnName(colNames.toArray(new String[]{}));
        record.setColumnWith(colWidths);
        return record;
    }

    private void initColName2Id(List<String> nameIds,List<String> colNames,Map<String, Object> params){
        String stcWay = BulTypeCastUtil.toString(params.get("stcWay"));//publishNum,state
        if ("publishNum".equals(stcWay)) {
            nameIds.add("stcTime");
            nameIds.add("stcNum");

            colNames.add(ResourceUtil.getString("news.stc.time.js"));
            colNames.add(ResourceUtil.getString("news.stc.num.js"));
        } else if ("publishMember".equals(stcWay)) {
            nameIds.add("accName");
            nameIds.add("deptName");
            nameIds.add("memberName");
            nameIds.add("stcNum");

            colNames.add(ResourceUtil.getString("news.stc.accName.js"));
            colNames.add(ResourceUtil.getString("news.stc.deptName.js"));
            colNames.add(ResourceUtil.getString("news.stc.memberName.js"));
            colNames.add(ResourceUtil.getString("news.stc.num.js"));
            boolean isGroupStc = "true".equals(BulTypeCastUtil.toString(params.get("isGroupStc")));
            String stcTo = BulTypeCastUtil.toString(params.get("stcTo"));//member,dept,acc
            if (!isGroupStc) {
                nameIds.remove(0);
                colNames.remove(0);
            }
            if("dept".equals(stcTo)){
                nameIds.remove(2);
                colNames.remove(2);
            }else if("acc".equals(stcTo)){
                nameIds.remove(1);
                nameIds.remove(1);
                colNames.remove(1);
                colNames.remove(1);
            }
        }else if("state".equals(stcWay)){
            nameIds.add("state");
            nameIds.add("stcNum");

            colNames.add(ResourceUtil.getString("news.stc.state.js"));
            colNames.add(ResourceUtil.getString("news.stc.num.js"));
        }else{
            nameIds.add("stcTitle");
            nameIds.add("memberName");
            nameIds.add("stcNum");
            colNames.add(ResourceUtil.getString("news.stc.title.js"));
            colNames.add(ResourceUtil.getString("news.stc.publish.user.js"));
            if ("clickNum".equals(stcWay)) {
                colNames.add(ResourceUtil.getString("news.stc.clickNum.js"));
            } else if ("voteNum".equals(stcWay)) {
                colNames.add(ResourceUtil.getString("news.stc.voteNum.js"));
            } else if ("replyNum".equals(stcWay)) {
                colNames.add(ResourceUtil.getString("news.stc.replayNum.js"));
            }else{
                colNames.add(ResourceUtil.getString("news.stc.num.js"));
            }
        }

        if ("publishMember".equals(stcWay)) {
            String stcBy = BulTypeCastUtil.toString(params.get("stcBy"));//day,month,year
            if ("month".equals(stcBy)) {
                nameIds.remove(nameIds.size() - 1);
                colNames.remove(colNames.size() - 1);
                Date sDate = BulTypeCastUtil.toDate(params.get("publishDateStart")),
                     eDate = BulTypeCastUtil.toDate(params.get("publishDateEnd"));
                //计算2个日期间几个月
                int monthDif = DateUtil.beforeMonths(sDate, eDate) + 1;
                for (int i = 0; i < monthDif; i++) {
                    String year = ResourceUtil.getString("news.stc.year.js"),
                           month = ResourceUtil.getString("news.stc.month.js");
                    if ("year".equals(year)) {
                        year = "-";
                        month = "";
                    }
                    Date cDate = DateUtil.addMonth(eDate, -i);
                    colNames.add(DateUtil.format(cDate, "yyyy" + year + "MM" + month));
                    nameIds.add("stcNum" + DateUtil.format(cDate, "yyyyMM"));
                }
            } else if ("year".equals(stcBy)) {
                String year = ResourceUtil.getString("news.stc.year.js");
                if ("year".equals(year)) {
                    year = "";
                }
                nameIds.remove(nameIds.size() - 1);
                colNames.remove(colNames.size() - 1);
                int sYear = BulTypeCastUtil.toInteger(params.get("publishDateStart")),
                    eYear = BulTypeCastUtil.toInteger(params.get("publishDateEnd"));
                int yearNum = eYear - sYear + 1;
                for (int i = 0; i < yearNum; i++) {
                    colNames.add((eYear - i) + year);
                    nameIds.add("stcNum" + (eYear - i));
                }
            }
        }
    }

    private DataRow buildRow(List<String> names, Map<String, Object> row,String mode) {
        DataRow drow = new DataRow();
        for (String name : names) {
            String value = BulTypeCastUtil.toString(row.get(name));
            if (Strings.isBlank(value) && name.indexOf("stcNum") != -1) {
                value = "0";
            }

            if ("state".equals(name) && Strings.isNotBlank(value)) {
                int state = Integer.parseInt(value);
                if ("bulletin".equals(mode)) {
                    value = (state == 100) ? ResourceUtil.getString("news.stc.piged.js") :ResourceUtil.getString("news.stc.published.js");
                }
            }

            drow.addDataCell(value, DataCell.DATA_TYPE_TEXT);
        }
        return drow;
    }

    /******************************6.0******************************/

    //查询字段，顺序不能变，要加只能在最后追加
    //客开 start 增加字段
    private static final String SELECT_FIELD = " t_data.id, t_data.title, t_data.dataFormat, t_data.createDate, t_data.createUser, t_data.updateDate, t_data.updateUser,"
                                                     + " t_data.publishDate, t_data.publishUserId, t_data.publishScope, t_data.publishDepartmentId, t_data.showPublishUserFlag, t_data.auditDate, t_data.auditUserId,"
                                                     + " t_data.typeId, t_data.accountId, t_data.readCount, t_data.topOrder, t_data.state, t_data.deletedFlag, t_data.ext1, t_data.ext2, t_data.ext3, t_data.ext4,"
                                                     + " t_data.ext5, t_data.attachmentsFlag,t_data.publishChoose,t_data.writePublish,t_data.auditDate1,t_data.auditUserId1,t_data.auditAdvice1,t_data.oldId";
    //客开 end

    /**
     * 获取公告列表
     * @param params
     * @return
     * @throws BusinessException
     */
    @AjaxAccess
    public Map<String, Object> findBulDatas(Map<String, Object> params) throws BusinessException {
    	User user = AppContext.getCurrentUser();
        int pageSize = NumberUtils.toInt(params.get("pageSize").toString(), 20);
        int pageNo = NumberUtils.toInt(params.get("pageNo").toString(), 1);
        String spaceType = params.get("spaceType") != null ? params.get("spaceType").toString() : null;
        String spaceId = params.get("spaceId") != null ? params.get("spaceId").toString() : null;
        String typeId = params.get("typeId") != null ? params.get("typeId").toString() : null;
        //我的公告
        String myBul = params.get("myBul") != null ? params.get("myBul").toString() : null;
        //搜索
        String search = params.get("search") != null ? params.get("search").toString() : null;
        String condition = params.get("condition") != null ? params.get("condition").toString() : null;
        String textfield1 = "";
        String textfield2 = "";
        if(Strings.isNotBlank(condition)){
            textfield1 = params.get("textfield1").toString();
            textfield2 = params.get("textfield2").toString();
        }
        int firstResult = (pageNo - 1) * pageSize;
        int maxResult = pageSize;
        Map<String, Object> result = new HashMap<String, Object>();
        List<BulData> list = new ArrayList<BulData>();
		int pagesCheck = 0;
		if (Strings.isNotBlank(typeId)) {
			// 判断是不是管理员
			boolean isAdmin = bulTypeManager.isManagerOfType(Long.valueOf(typeId), user.getId());
			if (isAdmin) {
				list = this.queryListDatas(firstResult, maxResult, Long.valueOf(typeId), user.getId(), null, true,
						user.getId(), condition, textfield1, textfield2);
			} else {
				list = this.queryListDatas(firstResult, maxResult, Long.valueOf(typeId), user.getId(), null, false,
						user.getId(), condition, textfield1, textfield2);
			}
			result.put("typeId", typeId);
			pagesCheck = Pagination.getRowCount();
		} else if (Strings.isNotBlank(myBul)) {
			List<Long> myBulTypeIds = bulTypeManager.getCanSeeBoard(user);
			list = this.queryListDatas(firstResult, maxResult, null, user.getId(), myBulTypeIds, null, user.getId(),
					condition, textfield1, textfield2);
			pagesCheck = Pagination.getRowCount();
		} else {

			// 栏目内容来源选择板块，需要过滤
			List<Long> selectTypeList = null;
			if (params.containsKey("fragmentId")) {
				String fragmentId = params.get("fragmentId").toString();
				String ordinal = params.get("ordinal").toString();
				Map<String, String> preference = portletEntityPropertyManager.getPropertys(Long.parseLong(fragmentId),
						ordinal);
				String panelValue = params.get("panelValue").toString();
				if (Strings.isNotBlank(panelValue)) {
					String designateTypeIds = preference.get(panelValue);
					selectTypeList = CommonTools.parseStr2Ids(designateTypeIds);
				}
			}
			List<Long> myBulTypeIds = new ArrayList<Long>();
			if (selectTypeList != null) {
				myBulTypeIds = selectTypeList;
			} else {
				myBulTypeIds = this.getMyBulTypeIds(NumberUtils.toInt(spaceType), NumberUtils.toLong(spaceId));
			}
			list = this.queryListDatas(firstResult, maxResult, null, user.getId(), myBulTypeIds, null, user.getId(),
					condition, textfield1, textfield2);
			result.put("spaceType", spaceType);
			result.put("spaceId", spaceId);
			pagesCheck = Pagination.getRowCount();
		}

        int pages = (pagesCheck + pageSize - 1) / pageSize;
        if (pages < 1) {
            pages = 1;
        }
        result.put("size", pagesCheck);
        result.put("search", search);
        result.put("pages", pages);
        result.put("pageNo", pageNo);
        result.put("list", this.BulDataToVO(user.getId(), list));
        result.put("currentUserId", user.getId());
        return result;
    }
    
    public List<Long> getMyBulTypeIds(int spaceType, Long spaceId) throws BusinessException {
        User user = AppContext.getCurrentUser();
        boolean isV5Member = AppContext.getCurrentUser().getExternalType() == OrgConstants.ExternalType.Inner.ordinal();
        Long accountId = AppContext.currentAccountId();
        if (!isV5Member) {
            accountId = OrgHelper.getVJoinAllowAccount();
        }
        List<BulType> myBulTypeList = new ArrayList<BulType>();
		if (spaceType == SpaceType.public_custom_group.ordinal()) {// 自定义集团空间
			List<BulType> customNewsTypeList = bulTypeManager.customAccBoardAllBySpaceId(spaceId, spaceType);
			myBulTypeList.addAll(customNewsTypeList);
		} else if (spaceType == SpaceType.public_custom.ordinal()) {// 自定义单位空间
			List<BulType> customNewsTypeList = bulTypeManager.customAccBoardAllBySpaceId(spaceId, spaceType);
			myBulTypeList.addAll(customNewsTypeList);
		} else if (spaceType == SpaceType.custom.ordinal()) {// 自定义团队空间
			BulType bul = bulTypeManager.getById(spaceId);
			myBulTypeList.add(bul);
		} else if (spaceType == SpaceType.department.ordinal()) {
			BulType bul = bulTypeManager.getById(spaceId);
			myBulTypeList.add(bul);
		} else if (spaceType == SpaceType.group.ordinal()) {// 集团板块
			List<BulType> groupNewsTypeList = bulTypeManager.groupFindAll();
			myBulTypeList.addAll(groupNewsTypeList);
		} else if (spaceType == SpaceType.corporation.ordinal()) {// 单位版块
			List<BulType> accountNewsTypeList = bulTypeManager.boardFindAllByAccountId(accountId);
			myBulTypeList.addAll(accountNewsTypeList);
		} else {
			// 集团板块
			List<BulType> groupNewsTypeList = bulTypeManager.groupFindAll();
			myBulTypeList.addAll(groupNewsTypeList);
			// 单位版块
			List<BulType> accountNewsTypeList = bulTypeManager.boardFindAllByAccountId(accountId);
			myBulTypeList.addAll(accountNewsTypeList);
		}

		List<Long> myBulTypeIds = new ArrayList<Long>();
		if (Strings.isNotEmpty(myBulTypeList)) {
			for (BulType bulType : myBulTypeList) {
				myBulTypeIds.add(bulType.getId());
			}
		}
		return myBulTypeIds;
    }

    public List<BulData> queryListDatas(int firstResult, int maxResult, Long typeId, Long userId, List<Long> myNewsTypeIds , Boolean isAdmin, Long memberId, String condition, String textfield1, String textfield2) throws BusinessException {
        Pagination.setFirstResult(firstResult);
        Pagination.setMaxResults(maxResult);
        Map<String, Object> params = new HashMap<String, Object>();
        StringBuilder sb = new StringBuilder();
        StringBuilder hqlStr = new StringBuilder();
        sb.append("select ").append(SELECT_FIELD).append(" from ").append(BulData.class.getName()).append(" t_data ");
        sb.append(" where t_data.state=:state ");
        sb.append(" and deletedFlag = false ");
        params.put("state", Constants.DATA_STATE_ALREADY_PUBLISH);
        List<Long> domainIds = orgManager.getAllUserDomainIDs(userId);
        domainIds.add(-4494177213242261212L); // 查询 中国信达分公司 SZP
        domainIds.add(-3451572810087969062L);// 查询 中国信达子公司  SZP
        domainIds.add(-2329940225728493295L); // 查询 中国信达资产管理股份有限公司 SZP
        if (typeId != null) {//单版块
        	if(isAdmin){
        		sb.append(" and t_data.typeId=:typeId ");
	            params.put("typeId", typeId);
	            hqlStr.append(" order by t_data.topOrder desc,t_data.publishDate desc");
        	}else{
        		sb.append(" and t_data.typeId=:typeId ");
	            params.put("typeId", typeId);
	            sb.append(" and t_data.id in (select t_scope.bulDataId from ").append(BulPublishScope.class.getName())
	      	  	  .append(" t_scope where t_data.id = t_scope.bulDataId and (t_scope.userId in (:domainIds) or t_data.createUser=:userId or t_data.auditUserId=:userId))");
	            params.put("domainIds", domainIds);
	            params.put("userId", userId);
	            hqlStr.append(" order by t_data.topOrder desc,t_data.publishDate desc");
        	}
        } else {
            if (Strings.isEmpty(myNewsTypeIds)) {
                return new ArrayList<BulData>();
            } else {
                sb.append(" and t_data.typeId in (:myNewsTypeIds) ");
                params.put("myNewsTypeIds", myNewsTypeIds);
            }
        	sb.append(" and t_data.id in (select t_scope.bulDataId from ").append(BulPublishScope.class.getName())
        	  .append(" t_scope where t_data.id = t_scope.bulDataId and t_scope.userId in (:domainIds))");
        	params.put("domainIds", domainIds);
        	hqlStr.append(" order by t_data.publishDate desc");
        }
        		
        if(Strings.isNotEmpty(condition)){
            if("title".equals(condition) && Strings.isNotBlank(textfield1)){
                sb.append(" and t_data.title like :textfield1 ");
                params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
            }else if("publishDepartment".equals(condition)){
            	sb.append(" and t_data.publishDepartmentId in ( select m.id from "+ OrgUnit.class.getName() + " as m ");
                sb.append(" where m.name like :textfield1) ");
                params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
            }else if("publishDate".equals(condition)){
                if(!"".equals(textfield1)){
                    sb.append(" and t_data.publishDate >=:textfield1 ");
                    textfield1 = Datetimes.formatNoTimeZone(Datetimes.getFirstTime(Datetimes.parseNoTimeZone(textfield1.toString()+" 00:00:00",Datetimes.datetimeStyle)),Datetimes.datetimeStyle);
                    params.put("textfield1", Datetimes.parseNoTimeZone(SQLWildcardUtil.escape(textfield1),Datetimes.datetimeStyle));
                }
                if(!"".equals(textfield2)){
                    sb.append(" and t_data.publishDate <=:textfield2 ");
                    textfield2 = Datetimes.formatNoTimeZone(Datetimes.getLastTime(Datetimes.parseNoTimeZone(textfield2.toString()+" 00:00:00",Datetimes.datetimeStyle)),Datetimes.datetimeStyle);
                    params.put("textfield2", Datetimes.parseNoTimeZone(SQLWildcardUtil.escape(textfield2),Datetimes.datetimeStyle));
                }
            }else if("publishUser".equals(condition)){
            	sb.append(" and t_data.publishUserId in ( select m.id from " + OrgMember.class.getName() + " as m ");
                sb.append(" where m.name like :textfield1 )");
                params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
            }
        }

        return BulletinUtils.objArr2NewsData((List<Object[]>) bulDataDao.find(sb.toString()+hqlStr.toString(), params));
    }

	/** 公告阅读表别名 */
	private static final String BulRead_Alias = "t_bul_read";
    private List<BulDataVO> BulDataToVO(Long memberId, List<BulData> list) throws BusinessException {
        List<BulDataVO> result = new ArrayList<BulDataVO>();
        Map<Long, BulDataVO> bulDataMap = null;
        if (Strings.isNotEmpty(list)) {
        	bulDataMap = new LinkedHashMap<Long, BulDataVO>();
            for (BulData bulData : list) {
            	//从缓存中查询
                BulData cacheBulData = this.getBulDataCache().getDataCache().get(bulData.getId());
            	BulDataVO bulDataVO = new BulDataVO();
            	bulDataVO.setId(bulData.getId());
            	bulDataVO.setTitle(bulData.getTitle());
            	bulDataVO.setFuTitle(bulData.getFutitle());
            	bulDataVO.setDataFormat(bulData.getDataFormat());
            	bulDataVO.setPublishDate(bulData.getPublishDate());
            	bulDataVO.setPublishDate1(Datetimes.formatDatetimeWithoutSecond(bulData.getPublishDate()));
            	bulDataVO.setPublishUserId(bulData.getPublishUserId());
            	bulDataVO.setShowPublishName(Functions.showDepartmentName(bulData.getPublishDepartmentId()));
            	bulDataVO.setShowPublishUserFlag(bulData.isShowPublishUserFlag());
            	bulDataVO.setTypeId(bulData.getTypeId());
            	bulDataVO.setCreateDate(Datetimes.formatDatetimeWithoutSecond(bulData.getCreateDate()));
            	bulDataVO.setPublishScope(Functions.showOrgEntities(bulData.getPublishScope(),"、"));
            	bulDataVO.setCreateUser(Functions.showMemberName(bulData.getCreateUser()));
            	bulDataVO.setExt5(bulData.getExt5());
            	BulType bulType = bulTypeManager.getById(bulData.getTypeId());
            	//客开 start 增加排版标识
            	if(bulType != null){
            		bulDataVO.setAuditFlag(bulType.isAuditFlag());
            		bulDataVO.setTypesettingFlag(bulType.isTypesettingFlag());
            	}else{
            		bulDataVO.setAuditFlag(false);
            		bulDataVO.setTypesettingFlag(false);
                }
            	if(bulData.getPublishUserId()!=null){
            		bulDataVO.setPublishUserName(Functions.showMemberName(bulData.getPublishUserId()));
            	} else {
            		bulDataVO.setPublishUserName(Functions.showMemberName(bulData.getCreateUser()));
            	}
            	//客开 end
            	Integer state = bulData.getState();
            	switch(state) {
            		case 0  : bulDataVO.setState("bulletin.draft");break;
            		case 10 : bulDataVO.setState("bulletin.pendingAudit");break;
            		case 20 : bulDataVO.setState("bulletin.alreadyExamine");break;
            		case 30 : bulDataVO.setState("bulletin.alreadyPublish");break;
            		case 40 : bulDataVO.setState("bulletin.noPassAudit");break;
            		//客开 start
            		case 25 : bulDataVO.setState("bulletin.typesettingCteate");break;
            		case 26 : bulDataVO.setState("bulletin.typesetting");break;
            		case 27 : bulDataVO.setState("bulletin.noPassTypesetting");break;
            		//客开 end
            	}

                if (bulType != null) {
                	bulDataVO.setTypeName(bulType.getTypeName());
                	bulDataVO.setSpaceType("bulletin.spaceType."+bulType.getSpaceType());
                } else {
                	bulDataVO.setTypeName("");
                }
                if (cacheBulData != null) {
                	bulDataVO.setReadCount(String.valueOf(cacheBulData.getReadCount()));
                } else {
                	bulDataVO.setReadCount(String.valueOf(bulData.getReadCount()));
                }
                if (Strings.isNotBlank(String.valueOf(bulData.getTopOrder()))) {
                   bulDataVO.setTopOrder(String.valueOf(bulData.getTopOrder()));
                }
                bulDataVO.setAttachmentFlag(bulData.getAttachmentsFlag());
                result.add(bulDataVO);
                bulDataMap.put(bulData.getId(), bulDataVO);
            }
                List<Object> objs1 = this.getReadListByIds(bulDataMap.keySet(),memberId);
            for(Object arr : objs1) {
                bulDataMap.get((Long)arr).setReadFlag(true);
            }
        }
        if(bulDataMap != null){
        	result = new ArrayList<BulDataVO>(bulDataMap.values());
        }

        return result;
    }

    /**
     * 公告Ids关联阅读表
     */
    public List<Object> getReadListByIds(Set<Long> set,Long memberId){
        String hql1 = "select " + BulRead_Alias + ".bulletinId"
                + " from " + BulRead.class.getName() + " as " + BulRead_Alias + " where " +BulRead_Alias + ".managerId=:userId and "
                +  BulRead_Alias+".bulletinId in(:ids)";
            Map<String, Object> params1 = new HashMap<String, Object>();
            params1.put("ids", set);
            params1.put("userId", memberId);
            List<Object> objs1 = bulDataDao. find(hql1, -1, -1, params1);
            return objs1;
    }

    /**
     * 获取我发布的个数
     * @param memberId
     * @return
     * @throws BusinessException
     */
    public int getMyIssueCount(Long memberId, List<Long> myBulTypeIds) throws BusinessException {
        if(Strings.isNotEmpty(myBulTypeIds)){
            String hql = " from " + BulData.class.getName() + " a where a.createUser=:memberId and a.state<>:state and a.deletedFlag=false and a.typeId in (:myBulTypeIds)  ";
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("memberId", memberId);
            params.put("state", Constants.DATA_STATE_ALREADY_PIGEONHOLE);
            params.put("myBulTypeIds", myBulTypeIds);
            return bulDataDao.count(hql, params);
        }
        return 0;
    }

    /**
     * 获取我发布的列表
     * @param memberId
     * @return
     * @throws BusinessException
     */
    @AjaxAccess
    public FlipInfo findMyIssue(FlipInfo flipInfo, Map<String, String> query) throws BusinessException {
    	User user = AppContext.getCurrentUser();
    	//String state = query.get("state");
        String condition = query.get("condition");
        String textfield1 = query.get("textfield1");
        String textfield2 = query.get("textfield2");
        int spaceType = NumberUtils.toInt(query.get("spaceType"));
        Long spaceId = NumberUtils.toLong(query.get("spaceId"));
        List<Long> myBulTypeIds = this.getMyBulTypeIds(spaceType, spaceId);
        List<BulDataVO> bulDataVO = new ArrayList<BulDataVO>();
        if(Strings.isNotEmpty(myBulTypeIds)){
            Map<String, Object> params = new HashMap<String, Object>();
            StringBuffer hql = new StringBuffer();
            StringBuffer SELECT = new StringBuffer("select t_data from " + BulData.class.getName() + " t_data ");
            hql.append(" where t_data.createUser =:memberId and t_data.deletedFlag =false and t_data.typeId in (:myBulTypeIds) and t_data.state<>:state  ");
            params.put("state", Constants.DATA_STATE_ALREADY_PIGEONHOLE);
            if(Strings.isNotEmpty(condition)){
                if("title".equals(condition)){
                    hql.append(" and t_data.state<>:state and t_data.title like :textfield1 ");
                    params.put("state", Constants.DATA_STATE_ALREADY_PIGEONHOLE);
                    params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
                }else if("typeName".equals(condition)){
                    SELECT.append(" , " + BulType.class.getName() + " as m ");
                    hql.append(" and m.id = t_data.typeId and m.typeName like :textfield1 ");
                    params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
                }else if("createDate".equals(condition)){
                    if(!"".equals(textfield1)){
                        hql.append(" and t_data.createDate >=:textfield1 ");
                        params.put("textfield1", Datetimes.getTodayFirstTime(SQLWildcardUtil.escape(textfield1)));
                    }
                    if(!"".equals(textfield2)){
                        hql.append(" and t_data.createDate <=:textfield2 ");
                        params.put("textfield2", Datetimes.getTodayLastTime(SQLWildcardUtil.escape(textfield2)));
                    }
                }else if("state".equals(condition)){
                    if(!"all".equals(textfield1)){
                    	//客开 gxy 20180706	通过数据显示待排版 已发布数据 start
                    	if("20".equals(textfield1)){
                    		hql.append(" and (t_data.state=:state2");
                            params.put("state2", NumberUtils.toInt("30"));
                            hql.append(" or t_data.state=:state1)");
                            params.put("state1", NumberUtils.toInt("25"));
                    	}else{
                    		hql.append(" and t_data.state=:state1");
                            params.put("state1", NumberUtils.toInt(textfield1));
                    	}
                    	//客开 gxy 20180706	通过数据显示待排版 已发布数据 end
                    }
                }else if("showPublishName".equals(condition)){
                	SELECT.append(" , " + OrgUnit.class.getName() + " as m ");
                	hql.append(" and m.id = t_data.publishDepartmentId and m.name like :textfield1 ");
                	params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
                }
            }


            //        String hql = "select t_data from " + BulData.class.getName()
            //                + "  t_data where t_data.createUser=:memberId and t_data.state<>:state and t_data.deletedFlag=false "
            //                + " order by t_data.createDate desc";
            params.put("memberId", user.getId());
            params.put("myBulTypeIds", myBulTypeIds);
            hql.append(" order by t_data.createDate desc ");
            List<BulData> bulData = DBAgent.find(SELECT.toString() + hql.toString(), params, flipInfo);
            bulDataVO = BulDataToVO(user.getId(), bulData);
        }
        flipInfo.setData(bulDataVO);
        return flipInfo;
    }

    /**
     * 获取我收藏的个数
     * @param memberId
     * @return
     * @throws BusinessException
     */
    public int getMyCollectCount(Long memberId, List<Long> myBulTypeIds) throws BusinessException {
        DocLibBO lib = docApi.getPersonalLibOfUser(memberId);
        if(lib!=null && Strings.isNotEmpty(myBulTypeIds)){
            String hql = "FROM DocResourcePO t, BulData d WHERE t.favoriteSource=d.id AND t.docLibId=:libId AND t.frType=:frType AND t.favoriteSource IS NOT NULL AND d.typeId in (:myBulTypeIds)";
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("libId", lib.getId());
            params.put("frType", DocConstants.SYSTEM_BULLETIN);
            params.put("myBulTypeIds", myBulTypeIds);
            return bulDataDao.count(hql, params);
        }
        return 0;
    }

    /**
     * 获取我收藏的列表
     * @param params
     * @return
     * @throws BusinessException
     */
    @AjaxAccess
    public FlipInfo findMyCollect(FlipInfo flipInfo , Map<String, String> query) throws BusinessException {
    	User user = AppContext.getCurrentUser();
        String condition = query.get("condition");
        String textfield1 = query.get("textfield1");
        String textfield2 = query.get("textfield2");
    	int spaceType = NumberUtils.toInt(query.get("spaceType"));
        Long spaceId = NumberUtils.toLong(query.get("spaceId"));
        List<Long> myBulTypeIds = this.getMyBulTypeIds(spaceType, spaceId);
    	DocLibBO lib = docApi.getPersonalLibOfUser(AppContext.currentUserId());
    	List<BulDataVO> bulDataVOList = new ArrayList<BulDataVO>();
    	if(lib!=null && Strings.isNotEmpty(myBulTypeIds)){
    		StringBuffer SELECT = new StringBuffer(" SELECT d, t.favoriteSource, t.createTime FROM DocResourcePO t, BulData d ");
    		StringBuffer hql = new StringBuffer(" WHERE t.favoriteSource=d.id AND t.docLibId=:libId AND t.frType=:frType AND t.favoriteSource IS NOT NULL  AND d.typeId in(:myBulTypeIds) ");
    		//String hql = "SELECT d, t.favoriteSource, t.createTime FROM DocResourcePO t, BulData d WHERE t.favoriteSource=d.id AND t.docLibId=:libId AND t.frType=:frType AND t.favoriteSource IS NOT NULL AND d.typeId in (:myBulTypeIds) order by t.createTime desc";
    	    Map<Object, Object> params = new HashMap<Object, Object>();
    	    params.put("libId", lib.getId());
    	    params.put("frType", DocConstants.SYSTEM_BULLETIN);
    	    params.put("myBulTypeIds", myBulTypeIds);
            if(Strings.isNotEmpty(condition)){
                if("title".equals(condition)){
                    hql.append(" and d.title like :textfield1 ");
                    params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
                }else if("typeName".equals(condition)){
                    SELECT.append(" ," + BulType.class.getName() + " as m ");
                    hql.append(" and m.id = d.typeId and m.typeName like :textfield1 ");
                    params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
                }else if("collectDate".equals(condition)){
                    if(!"".equals(textfield1)){
                        hql.append(" and t.createTime >=:textfield1 ");
                        params.put("textfield1", Datetimes.getTodayFirstTime(SQLWildcardUtil.escape(textfield1)));
                    }
                    if(!"".equals(textfield2)){
                        hql.append(" and t.createTime <=:textfield2 ");
                        params.put("textfield2", Datetimes.getTodayLastTime(SQLWildcardUtil.escape(textfield2)));
                    }
                }else if("publishDept".equals(condition)){
                    SELECT.append("," + OrgUnit.class.getName() + " as m " );
                    hql.append(" and d.publishDepartmentId = m.id and m.name like :textfield1 and m.type=:unitType ");
                    params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
                    params.put("unitType", OrgConstants.UnitType.Department.name());
                }else if("createUser".equals(condition)){
                	SELECT.append("," + OrgMember.class.getName() + " as m " );
                    hql.append(" and d.createUser = m.id and m.name like :textfield1 ");
                    params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
                }
            }
            hql.append(" order by t.createTime desc");
    	    List<Object[]> list = DBAgent.find(SELECT.toString()+hql.toString(), params, flipInfo);
    	    List<BulData> bulDataList = new ArrayList<BulData>();
    	    if (Strings.isNotEmpty(list)) {
    	        for (Object[] obj : list) {
    	            BulData data = (BulData) obj[0];
    	            data.setCreateDate((Timestamp)obj [2]);
    	            bulDataList.add(data);
    	        }
    	    }
    	    bulDataVOList = BulDataToVO(user.getId(), bulDataList);
    	}
        flipInfo.setData(bulDataVOList);
        return flipInfo;
    }

    /**
     * 获取公告审核个数
     * @param memberId
     * @return
     * @throws BusinessException
     */
    public int getMyAuditCount(Long memberId, List<Long> myBulTypeIds) throws BusinessException {
        if(Strings.isNotEmpty(myBulTypeIds)){
            String hql = " from " + BulData.class.getName() + " a , " + BulType.class.getName()
                    + " b where a.typeId=b.id and b.auditUser=:memberId and (a.state=:state1 or a.state=:state2 or a.state=:state3 or a.state=:NOPASS_AUDIT) and "//客开 gxy 20180704 添加审核不通过条件
                    + " a.deletedFlag=false and  b.id in (:myBulTypeIds) order by a.createDate desc";
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("memberId", memberId);
            params.put("state1", Constants.DATA_STATE_ALREADY_CREATE);
            params.put("state2", Constants.DATA_STATE_TYPESETTING_CREATE);//审核通过显示待排版数据20180705 gxy 
            params.put("state3", Constants.DATA_STATE_ALREADY_PUBLISH);//审核通过显示已发布数据 20180705 gxy 
            params.put("NOPASS_AUDIT", Constants.DATA_STATE_NOPASS_AUDIT);//客开 gxy 20180704 添加审核不通过条件
            params.put("myBulTypeIds", myBulTypeIds);
            return bulDataDao.count(hql,params);
        }
        return 0;
    }

    //客开 start
    /**
     * 获取公告排版个数
     * @param memberId
     * @return
     * @throws BusinessException
     */
    public int getMyTypesettingCount(Long memberId, List<Long> myBulTypeIds) throws BusinessException {
        if(Strings.isNotEmpty(myBulTypeIds)){
          String hql = " from " + BulData.class.getName() + " a , " + BulType.class.getName()
                  + " b where a.typeId=b.id and b.typesettingStaff=:memberId and (a.state=:state1 or a.state=:state2 or a.state=:TYPESETTING_NOPASS) and "//客开 gxy 20180704  添加排版不通过条件
                  + " a.deletedFlag=false and  b.id in (:myBulTypeIds) order by a.createDate desc";
          Map<String, Object> params = new HashMap<String, Object>();
          params.put("memberId", memberId);
          params.put("state1", Constants.DATA_STATE_TYPESETTING_CREATE);
          params.put("state2", Constants.DATA_STATE_ALREADY_PUBLISH);//排版通过显示已发布数据20180705 gxy 
          params.put("TYPESETTING_NOPASS", Constants.DATA_STATE_TYPESETTING_NOPASS);//客开 gxy 20180704  添加排版不通过条件
          params.put("myBulTypeIds", myBulTypeIds);
          return bulDataDao.count(hql,params);
      }
      return 0;
    }

    /**
     * 获取新闻排版列表
     * @param params
     * @return
     * @throws BusinessException
     */
    @AjaxAccess
    public FlipInfo findMyTypesetting(FlipInfo flipInfo, Map<String, String> query) throws BusinessException {
      User user = AppContext.getCurrentUser();
      String condition = query.get("condition");
      String textfield1 = query.get("textfield1");
      String textfield2 = query.get("textfield2");
      int spaceType = NumberUtils.toInt(query.get("spaceType"));
      Long spaceId = NumberUtils.toLong(query.get("spaceId"));
      List<Long> myBulTypeIds = this.getMyBulTypeIds(spaceType, spaceId);
      List<BulDataVO> bulDataVO = new ArrayList<BulDataVO>();
      if(Strings.isNotEmpty(myBulTypeIds)){
          List<BulData> bulDataList = new ArrayList<BulData>();
          StringBuffer SELECT = new StringBuffer("select t_data from " + BulData.class.getName() + " t_data , "
                                                  + BulType.class.getName() + " t_type ");
          StringBuffer hql = new StringBuffer(" where t_data.typeId = t_type.id and t_type.typesettingStaff=:memberId "
                                            + " and t_data.deletedFlag=false and t_type.id in(:myBulTypeIds) ");
          Map<String , Object> params = new HashMap<String , Object>();
          if(Strings.isNotEmpty(condition)){
              if("title".equals(condition)){
                  hql.append(" and t_data.title like :textfield1 ");
                  params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
              }else if("typeName".equals(condition)){
                  hql.append(" and t_type.id = t_data.typeId and t_type.typeName like :textfield1 ");
                  params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
              }else if("createUser".equals(condition)){
                  SELECT.append(", " + OrgMember.class.getName() + " m ");
                  hql.append(" and m.id = t_data.createUser and m.name like :textfield1 ");
                  params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
              }else if("state".equals(condition)){
                  if(!"all".equals(textfield1)){
                	  //客开 gxy 20180706 通过数据显示已发布数据 start
                	if("26".equals(textfield1)){
                  		hql.append(" and t_data.state=:state");
                        params.put("state", NumberUtils.toInt("30"));
                          
                  	}else{
                  		hql.append(" and t_data.state=:state");
                        params.put("state", NumberUtils.toInt(textfield1));
                  	}
                	  //客开 gxy 20180706 通过数据显示已发布数据 end
                  }
              }else if("createDate".equals(condition)){
                  if(!"".equals(textfield1)){
                      hql.append(" and t_data.createDate >=:textfield1 ");
                      params.put("textfield1", Datetimes.getTodayFirstTime(SQLWildcardUtil.escape(textfield1)));
                  }
                  if(!"".equals(textfield2)){
                      hql.append(" and t_data.createDate <=:textfield2 ");
                      params.put("textfield2", Datetimes.getTodayFirstTime(SQLWildcardUtil.escape(textfield2)));
                  }
              }
          }
          hql.append(" and (t_data.state=:already_create or t_data.state=:already_audit or t_data.state=:TYPESETTING_NOPASS)");//客开 gxy 20180704 添加排版不通过数据
          params.put("memberId", user.getId());
          params.put("already_create", Constants.DATA_STATE_TYPESETTING_CREATE);
          params.put("already_audit", Constants.DATA_STATE_ALREADY_PUBLISH);//排版通过显示已发布数据 20180705 gxy	
          params.put("TYPESETTING_NOPASS", Constants.DATA_STATE_TYPESETTING_NOPASS);//客开 gxy 20180704  添加排版不通过条件
          hql.append(" order by t_data.createDate desc");
          params.put("myBulTypeIds", myBulTypeIds);
          bulDataList = DBAgent.find(SELECT.toString() + hql.toString(), params, flipInfo);
          bulDataVO = BulDataToVO(user.getId(),bulDataList);
      }
      flipInfo.setData(bulDataVO);
      return flipInfo;
    }

    /**
     * 取消排版
     */
    @AjaxAccess
    public String cancelTypesetting(String ids) throws Exception {
      User user = AppContext.getCurrentUser();
      String userName = user.getName();
      if (StringUtils.isBlank(ids)) {
          return null;
      }else{
          String[] idArr = ids.split(",");
          for (String sid : idArr) {
              long dataId = Long.valueOf(sid);
              BulData bean = this.getById(dataId);
              if (bean == null)
                  continue;

              BulType bulType = bean.getType();
              if (bean.getState().intValue() != Constants.DATA_STATE_TYPESETTING_PASS)
                  continue;

              bean.setAuditAdvice(null);
              bean.setState(Constants.DATA_STATE_TYPESETTING_CREATE);
              this.addPendingAffair(bulType, bean);
              //zhangxw 2012-10-30  添加显示更新语句，实现‘取消审核’
              this.updateDirect(bean);

              //取消排版给创建者发送消息
              List<Long> msgReceiverIds = new ArrayList<Long>();
              msgReceiverIds.add(bean.getCreateUser());
              Collection<MessageReceiver> receivers = MessageReceiver.get(bean.getId(), msgReceiverIds);
              userMessageManager.sendSystemMessage(MessageContent.get("bul.cancel.typesetting", bean.getTitle(), userName),
                      ApplicationCategoryEnum.bulletin, user.getId(), receivers);

              //取消审核加日志
              //TODO appLogManager.insertLog(user, AppLogAction.Bulletin_CancelAudit, userName, bean.getTitle());
          }
      }

      return null;
    }

    public BulBodyDao getBulBodyDao() {
      return bulBodyDao;
    }

    public void setBulBodyDao(BulBodyDao bulBodyDao) {
      this.bulBodyDao = bulBodyDao;
    }
    //客开 end

    /**
     * 获取公告审核列表
     * @param params
     * @return
     * @throws BusinessException
     */
    @AjaxAccess
    public FlipInfo findMyAudit(FlipInfo flipInfo , Map<String, String> query) throws BusinessException {
    	User user = AppContext.getCurrentUser();
    	String condition = query.get("condition");
        String textfield1 = query.get("textfield1");
        String textfield2 = query.get("textfield2");
    	int spaceType = NumberUtils.toInt(query.get("spaceType"));
        Long spaceId = NumberUtils.toLong(query.get("spaceId"));
        List<Long> myBulTypeIds = this.getMyBulTypeIds(spaceType, spaceId);
        List<BulDataVO> bulDataVO = new ArrayList<BulDataVO>();
        if(Strings.isNotEmpty(myBulTypeIds)){
        	List<BulData> bulDataList = new ArrayList<BulData>();
            StringBuffer SELECT = new StringBuffer("select t_data from " + BulData.class.getName() + " t_data , "
            										+ BulType.class.getName() + " t_type ");
            StringBuffer hql = new StringBuffer(" where t_data.typeId = t_type.id and t_type.auditUser=:memberId "
            								  + " and t_data.deletedFlag=false and t_type.id in(:myBulTypeIds) ");
            Map<String , Object> params = new HashMap<String , Object>();
            if(Strings.isNotEmpty(condition)){
                if("title".equals(condition)){
                    hql.append(" and t_data.title like :textfield1 ");
                    params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
                }else if("typeName".equals(condition)){
                    hql.append(" and t_type.id = t_data.typeId and t_type.typeName like :textfield1 ");
                    params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
                }else if("createUser".equals(condition)){
                    SELECT.append(", " + OrgMember.class.getName() + " m ");
                    hql.append(" and m.id = t_data.createUser and m.name like :textfield1 ");
                    params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
                }else if("state".equals(condition)){
                    if(!"all".equals(textfield1)){
                    	//客开 gxy 20180706	通过数据显示待排版 已发布数据 start
                    	if("20".equals(textfield1)){
                    		hql.append(" and (t_data.state=:state");
                            params.put("state", NumberUtils.toInt("30"));
                            hql.append(" or t_data.state=:state1)");
                            params.put("state1", NumberUtils.toInt("25"));
                    	}else{
                    		hql.append(" and t_data.state=:state");
                            params.put("state", NumberUtils.toInt(textfield1));
                    	}
                    	//客开 gxy 20180706	通过数据显示待排版 已发布数据 end
                    }
                }else if("createDate".equals(condition)){
                    if(!"".equals(textfield1)){
                        hql.append(" and t_data.createDate >=:textfield1 ");
                        params.put("textfield1", Datetimes.getTodayFirstTime(SQLWildcardUtil.escape(textfield1)));
                    }
                    if(!"".equals(textfield2)){
                        hql.append(" and t_data.createDate <=:textfield2 ");
                        params.put("textfield2", Datetimes.getTodayLastTime(SQLWildcardUtil.escape(textfield2)));
                    }
                }
            }
            hql.append(" and (t_data.state=:already_create or t_data.state=:already_audit or t_data.state=:already_audit1 or t_data.state=:NOPASS_AUDIT)");//客开 gxy 20180704 添加审核不通过数据 or t_data.state=:NOPASS_AUDIT
            params.put("memberId", user.getId());
            params.put("already_create", Constants.DATA_STATE_ALREADY_CREATE);
            params.put("already_audit", Constants.DATA_STATE_TYPESETTING_CREATE);//审核通过显示待排版数据 20180705 gxy 
            params.put("already_audit1", Constants.DATA_STATE_ALREADY_PUBLISH);//审核通过显示已发布数据 20180705 gxy 
            params.put("NOPASS_AUDIT", Constants.DATA_STATE_NOPASS_AUDIT);//客开 gxy 20180704 添加审核不通过条件
            hql.append(" order by t_data.createDate desc");
            params.put("myBulTypeIds", myBulTypeIds);
            bulDataList = DBAgent.find(SELECT.toString() + hql.toString(), params, flipInfo);
            bulDataVO = BulDataToVO(user.getId(),bulDataList);
        }
        flipInfo.setData(bulDataVO);
        return flipInfo;
    }

    /**
     * 设置归档
     * @param param
     * @return
     * @throws BusinessException
     */
    @AjaxAccess
    public String setPigeonhole(Map<String, Object> param) throws BusinessException {
        User user = AppContext.getCurrentUser();
        String userName = user.getName();
        String ids = param.get("bulIds").toString();
        String[] archiveIds = param.get("archiveId") != null ? param.get("archiveId").toString().split(",") : null;
        if (StringUtils.isNotBlank(ids)) {
            String[] idA = ids.split(",");
            List<Long> idList = new ArrayList<Long>();
            for (int i = 0; i < idA.length; i++) {
                if (StringUtils.isNotBlank(idA[i])) {
                    Long _archiveId = Long.valueOf(archiveIds[i]);
                    DocResourceBO res = docApi.getDocResource(_archiveId);
                    //归档记录应用日志
                    if (res != null) {
                        String folderName = docApi.getDocResourceName(res.getParentFrId());
                        appLogManager.insertLog(user, AppLogAction.Bulletin_Pigeonhole, userName, res.getFrName(), folderName);
                    }
                    idList.add(Long.valueOf(idA[i]));
                }
            }
            this.pigeonhole(idList);
        }
        return "";
    }

    /**
     * 设置置顶、取消置顶
     * @param param
     * @return
     * @throws BusinessException
     */
    @AjaxAccess
    public Boolean setTop(Map<String, Object> param) throws BusinessException {
        String type = param.get("type").toString();
        String bulIds = param.get("bulIds").toString();
        String typeId = param.get("typeId").toString();
        List<Long> ids = this.getIdsFromStr(bulIds.split(","));
        for (Long id : ids) {
            BulData buldata = this.getById(id);
            Boolean stateFlag = this.stateFlag(buldata);
            if (!stateFlag) {
                return false;
            }
        }
        if (CollectionUtils.isNotEmpty(ids)) {
            if ("1".equals(type)) {
                this.top(ids, Long.parseLong(typeId));
            } else if ("2".equals(type)) {
                this.cancelTop(ids);
            }

            bulTypeManager.updateTypeETagDate(typeId);
        }
        return true;
    }

    /**
     * 取消发布（支持批量）
     * @param param
     * @return
     * @throws BusinessException
     */
    @AjaxAccess
    public Boolean cancelPublish(Map<String, Object> param) throws BusinessException {
    	User user = AppContext.getCurrentUser();
        Long userId = user.getId();
        String userName = user.getName();
    	String bulIds = param.get("bulIds").toString();
    	Boolean sendMsgWhenCancelPublish = Boolean.valueOf((param.get("sendMsgWhenCancelPublish").toString()));
        List<Long> ids = this.getIdsFromStr(bulIds.split(","));
        for(Long id : ids){
        	BulData buldata = this.getById(id);
        	Boolean stateFlag = this.stateFlag(buldata);
        	if (!stateFlag){
        		return false;
        	}
        }
        if (CollectionUtils.isNotEmpty(ids)) {
        	for(Long bulletinId : ids){
	        	BulData bean= this.getById(bulletinId);
	            //取消发布，回到草稿状态
	            if (bean.getState() != Constants.DATA_STATE_ALREADY_PUBLISH)
	                continue;

	            bean.setState(Constants.DATA_STATE_NO_SUBMIT);
	            bean.setAuditAdvice(null);
	            bean.setPublishDate(null);
	            bean.setPublishUserId(null);
	            bean.setReadCount(0);
	            bean.setUpdateDate(null);
	            bean.setUpdateUser(null);
	            //取消置顶
	            bean.setTopOrder(Byte.valueOf("0"));
	            this.updateDirect(bean);
	            this.removeCache(bulletinId);
	            this.bulReadManager.deleteReadByData(bean);
	            //取消发布加日志
	            appLogManager.insertLog(user, AppLogAction.Bulletin_CancelPublish, userName, bean.getTitle());
	            //从全文检索中是删除
	            try {
	                if (AppContext.hasPlugin("index")) {
	                    indexManager.delete(bean.getId(), ApplicationCategoryEnum.bulletin.getKey());
	                }
	            } catch (Exception e) {
	                log.error("全文检索：", e);
	            }

                //给发起者发送系统消息,当发起者不是管理员的时候会给发起者发送系统消息
                Set<Long> msgReceivers = this.getMsgReceiverWhenCancelPublish(bean, sendMsgWhenCancelPublish);

                //过滤掉非自定义空间中人员(????)
//                if (("true".equals(custom) || Strings.isNotBlank(spaceId)) && sendMsgWhenCancelPublish) {
//                    List<V3xOrgMember> customMembers = spaceManager.getSpaceMemberBySecurity(
//                            Long.parseLong(spaceId), -1);
//
//                    if (CollectionUtils.isNotEmpty(customMembers)) {
//                        List<Long> customList = new ArrayList<Long>();
//                        List<Long> tempList = new ArrayList<Long>();
//                        for (V3xOrgMember m : customMembers) {
//                            customList.add(m.getId());
//                        }
//                        for (Long memberId : msgReceivers) {
//                            if (!customList.contains(memberId)) {
//                                tempList.add(memberId);
//                            }
//                        }
//                        msgReceivers.removeAll(tempList);
//                    }
//                }
                if (CollectionUtils.isNotEmpty(msgReceivers)) {
                    userMessageManager.sendSystemMessage(
                            MessageContent.get("bul.cancel.publish", bean.getTitle(), userName).setBody(
                                    this.getBody(bean.getId()).getContent(), bean.getDataFormat(),
                                    bean.getCreateDate()),
                            ApplicationCategoryEnum.bulletin,
                            userId,
                            MessageReceiver.getReceivers(bean.getId(), msgReceivers, "", "",
                                    new Timestamp(System.currentTimeMillis()) + ""), bean.getType().getId());
                }

                bulTypeManager.updateTypeETagDate(String.valueOf(bean.getTypeId()));
        	}

        }
    	return true;
    }

    /**
     * 公告状态判断
     */
    public Boolean stateFlag(BulData buldata) {
        if (buldata == null
                || !buldata.getType().isUsedFlag()
                || buldata.isDeletedFlag()
                || buldata.getState().intValue() != Constants.DATA_STATE_ALREADY_PUBLISH) {
            return false;
        } else {
            return true;
        }
    }

    /**
	 * 将字符串数组解析为<code>List<Long></code>
	 *
	 * @param articleIds
	 * @return
	 */
	private List<Long> getIdsFromStr(String[] bulIds) {
		if (bulIds != null && bulIds.length > 0) {
			List<Long> ids = new ArrayList<Long>();
			for (String idStr : bulIds) {
				ids.add(Long.parseLong(idStr));
			}
			return ids;
		}
		return null;
	}

	/**
     * 取消发布时，获取消息发送对象ID集合
     * @param bean	被取消发布的公告
     * @param sendMsgWhenCancelPublish	是否需要发送系统消息给发布范围内的人员
     * @throws BusinessException
     */
    private Set<Long> getMsgReceiverWhenCancelPublish(BulData bean, boolean sendMsgWhenCancelPublish)
            throws BusinessException {
        Set<Long> msgReceivers = new HashSet<Long>();
        if (sendMsgWhenCancelPublish) {
            msgReceivers = this.getAllMembersinPublishScope(bean);
            msgReceivers.remove(AppContext.getCurrentUser().getId());
        }
        if (!bean.getCreateUser().equals(AppContext.getCurrentUser().getId()))
            msgReceivers.add(bean.getCreateUser());
        return msgReceivers;
    }

    /**
     * 删除公告
     * @param idStr
     * @return
     * @throws Exception
     */
    @AjaxAccess
    public String deleteBul(String idStr) throws Exception {
        BulData bean = null;
        User user = AppContext.getCurrentUser();
        String userName = user.getName();
        if (StringUtils.isBlank(idStr)) {
            idStr = "";
        } else {
            String[] ids = idStr.split(",");
            boolean isAlert = false;
            for (String id : ids) {
                if (StringUtils.isNotBlank(id)) {
                    bean = this.getById(Long.valueOf(id));
                    if (bean == null) {
                        continue;
                    }
                    if (bean.getTopOrder() > 0 && !bulTypeManager.isManagerOfType(bean.getTypeId(), user.getId())) {
                        isAlert = true;
                    } else {
                        if (bean.getState().intValue() == Constants.DATA_STATE_ALREADY_CREATE) {//已经提交审核的需要发送消息，删除待办
                            //affairManager.deleteByObjectId(ApplicationCategoryEnum.bulletin, bean.getId());
                            userMessageManager.sendSystemMessage(MessageContent.get("bul.delete", bean.getTitle(), userName), ApplicationCategoryEnum.bulletin, user.getId(), MessageReceiver.get(bean.getId(), bean.getType().getAuditUser()), bean.getTypeId());
                        }
                        affairManager.deleteByObjectId(ApplicationCategoryEnum.bulletin, bean.getId());
                        //记录操作日志
                        appLogManager.insertLog(user, AppLogAction.Bulletin_Delete, userName, bean.getTitle());
                        bean.setDeletedFlag(true);
                        bean.setTopOrder(Byte.parseByte("0"));
                        this.updateDirect(bean);
                        this.removeCache(Long.valueOf(id));
                        try {
                            if (AppContext.hasPlugin("index")) {
                                indexManager.delete(Long.valueOf(id), ApplicationCategoryEnum.bulletin.getKey());
                            }
                        } catch (Exception e) {
                            log.error("全文检索：", e);
                        }

                        bulTypeManager.updateTypeETagDate(String.valueOf(bean.getTypeId()));
                    }
                }
            }
            if (isAlert) {
                if (ids.length == 1) {
                    return "Top";
                } else {
                    return "Tops";
                }
            }
        }
        return "success";
    }

    /**
     * 我发起的发布方法
     * @param idStr
     * @return
     * @throws Exception
     */
    @AjaxAccess
    public String myPublish(String idStr) throws Exception {
    	User user = AppContext.getCurrentUser();
        Long userId = user.getId();
        String userName = user.getName();
        BulType type = null;

        if (StringUtils.isBlank(idStr)) {
        	idStr = "";
        }else{
        	String[] ids = idStr.split(",");
        	for (String bulletinId : ids) {
        		Long id=Long.valueOf(bulletinId);
                BulData bean = this.getBulDataCache().getDataCache().get(id);
                if (bean == null){
                	bean = this.getById(id);
                }
                if (bean == null)
                    continue;
                type = bean.getType();
                if (bean.getState() == Constants.DATA_STATE_ALREADY_PUBLISH){
                	continue;
                }
                //客开 start
                //判断是否需要排版后才能发布
                if (type != null && type.isTypesettingFlag() && type.getTypesettingStaff().intValue() != 0) {
                    if (bean.getState().intValue() == Constants.DATA_STATE_TYPESETTING_NOPASS) {
                      return "排版不通过，不能发布";
                    } else if(bean.getState().intValue() == Constants.DATA_STATE_TYPESETTING_CREATE){
                      return "该信息尚未排版，不允许直接发布!";
                    }
                  }
                //判断是否需要审核后才能发布，审核人ID为 0 直接发布。不为 0 给出提示
                if (type != null && type.isAuditFlag() && type.getAuditUser().intValue() != 0) {
                  if (bean.getState().intValue() == Constants.DATA_STATE_NOPASS_AUDIT) {
                      return "审核不通过，不能发布";
                  } else if(bean.getState().intValue() == Constants.DATA_STATE_ALREADY_CREATE){
                      return "该信息尚未审核，不允许直接发布!";
                  }
                }
                if(bean.getState().intValue() ==Constants.DATA_STATE_TYPESETTING_PASS){
                  bean.setState(Constants.DATA_STATE_ALREADY_PUBLISH);
                }else if(bean.getState().intValue() ==Constants.DATA_STATE_ALREADY_AUDIT){
                  if(type != null && type.isTypesettingFlag() && type.getTypesettingStaff().intValue() != 0){
                    bean.setState(Constants.DATA_STATE_TYPESETTING_CREATE);
                  }else{
                    bean.setState(Constants.DATA_STATE_ALREADY_PUBLISH);
                  }
                }else{
                  bean.setState(Constants.DATA_STATE_ALREADY_PUBLISH);
                }
                //客开 end
                //客开 start 判断是否发布的是二次修改后的公告
                boolean hasOldBean = false;
                BulData oldBean = null;
                if(bean.getOldId()!=null &&bean.getOldId().intValue()!=0){
                   oldBean = this.getById(Long.valueOf(bean.getOldId()));
                   hasOldBean = oldBean!=null?true:false;
                }
                if(hasOldBean){
                //如果是二次发布且排版通过并发布，当前公告内容覆盖之前的老公告（除发布时间、发布人、查阅留痕等信息需要保留不变外），删除当前公告
                  List<Attachment> oldAtts = attachmentManager.getByReference(oldBean.getId(), oldBean.getId());
                  List<Long> oldFileUrls = new ArrayList<Long>();
                  Map<Long,Long> oldFileUrlsMap = new HashMap<Long, Long>();
                  if(!CollectionUtils.isEmpty(oldAtts)){
                    for(Attachment att:oldAtts){
                      oldFileUrls.add(att.getFileUrl());
                      oldFileUrlsMap.put(att.getFileUrl(),att.getId());
                    }
                  }
                  List<Attachment> atts = attachmentManager.getByReference(bean.getId(), bean.getId());
                  List<Long> newAtts = new ArrayList<Long>();
                  for(Attachment att:atts){
                    if(oldFileUrls.contains(att.getFileUrl().longValue())){
                      newAtts.add(att.getFileUrl());
                      oldFileUrls.remove(att.getFileUrl().longValue());
                      oldFileUrlsMap.remove(att.getFileUrl());
                    }
                  }
                  //删除老公告的附件
                  for(Map.Entry<Long, Long> entry:oldFileUrlsMap.entrySet()){
                    attachmentManager.deleteById(entry.getValue());
                  }
                  
                  //把新公告的附件指向老公告
                  for(Attachment att:atts){
                    if(newAtts.contains(att.getFileUrl()))continue;
                    att.setReference(oldBean.getId());
                    att.setSubReference(oldBean.getId());
                    attachmentManager.update(att);
                  }
                  BulBody body = bulBodyDao.get(bean.getId());
                  bulBodyDao.delete(oldBean.getId());//删除老公告的内容
                  body.setId(oldBean.getId());//把新公告的内容复制到老公告上
                  body.setBulDataId(oldBean.getId());
                  bulBodyDao.save(body);
                  //更新老公告
                  oldBean.setTitle(bean.getTitle());
                  oldBean.setFutitle(bean.getFutitle());
                  oldBean.setSpaceType(bean.getSpaceType());
                  oldBean.setType(bean.getType());
                  oldBean.setTypeId(bean.getTypeId());
                  oldBean.setTypeName(bean.getTypeName());
                  oldBean.setPublishDepartmentId(bean.getPublishDepartmentId());
                  oldBean.setAttachmentsFlag(bean.getAttachmentsFlag());
                  oldBean.setAuditAdvice(bean.getAuditAdvice());
                  oldBean.setAuditAdvice1(bean.getAuditAdvice1());
                  oldBean.setAuditDate(bean.getAuditDate());
                  oldBean.setAuditDate1(bean.getAuditDate1());
                  oldBean.setAuditUserId(bean.getAuditUserId());
                  oldBean.setAuditUserId1(bean.getAuditUserId1());
                  oldBean.setBrief(bean.getBrief());
                  oldBean.setKeywords(bean.getKeywords());
                  oldBean.setPublishDeptName(bean.getPublishDeptName());
                  oldBean.setPublishScope(bean.getPublishScope());
                  oldBean.setExt1(bean.getExt1());
                  oldBean.setExt2(bean.getExt2());
                  oldBean.setShowPublishName(bean.getShowPublishName());
                  oldBean.setShowPublishUserFlag(bean.isShowPublishUserFlag());
                  this.updateDirect(oldBean);
                  //删除新公告
                  bean.setDeletedFlag(true);
                  this.updateDirect(bean);
                  // 删除待办
                  affairManager.deleteByObjectId(ApplicationCategoryEnum.bulletin, bean.getId());
                  getBulDataCache().getDataCache().remove(oldBean.getId());
                  getBulDataCache().getDataCache().remove(bean.getId());
//                  getBulDataCache().getDataCache().save(oldBean.getId(), oldBean, oldBean.getPublishDate().getTime(),
//                      (oldBean.getReadCount() == null ? 0 : oldBean.getReadCount()));
                  //对新闻文件进行解锁
                  if (idStr != null && !"".equalsIgnoreCase(idStr))
                    this.unlock(Long.valueOf(idStr));
                }else{
                  //客开 end
                  //如果该公告类型无审核员，则其最终审核记录状态设置为"无审核"，否则设置为"审核通过"
                  if (type != null && !type.isAuditFlag()) {
                    //无审核员，设置为"无审核"
                    bean.setExt3(String.valueOf(Constants.AUDIT_RECORD_NO));
                  } else if (type != null && type.isAuditFlag()) {
                    //有审核员，设置为"审核通过"
                    bean.setExt3(String.valueOf(Constants.AUDIT_RECORD_PASS));
                  }
                  //客开 start
                  if(bean.getState().intValue() == Constants.DATA_STATE_ALREADY_PUBLISH){
                    bean.setPublishDate(new Timestamp(new Date().getTime()));
//                    bean.setPublishUserId(AppContext.getCurrentUser().getId());
                    bean.setPublishUserId(bean.getCreateUser());
                  }
                  //客开 end
                  bean.setReadCount(0);
                  bean.setUpdateDate(new Date());
                  bean.setUpdateUser(AppContext.getCurrentUser().getId());
                  this.updateDirect(bean);
                  //客开 start
                  if(bean.getState().intValue() == Constants.DATA_STATE_ALREADY_PUBLISH){
                    //触发发布事件
                    BulletinAddEvent bulletinAddEvent = new BulletinAddEvent(this);
                    bulletinAddEvent.setBulDataBO(BulletinUtils.bulDataPOToBO(bean));
                    EventDispatcher.fireEvent(bulletinAddEvent);
                    //发布公告添加操作日志 added by Meng Yang at 2009-08-20
                    appLogManager.insertLog(user, AppLogAction.Bulletin_Publish, userName, bean.getTitle());
                    this.bulReadManager.deleteReadByData(bean);
                  }

                  //更新数据库再加入全文检索
                  try {

                    //yangwulin 2012-11-13 修改下面的manager
                    //IndexEnable indexEnable = (IndexEnable) bulDataManager;
                    //IndexInfo info = indexEnable.getIndexInfo(bean.getId());
                    //if(AppContext.hasPlugin("index")){
                    //	indexManager.add(info);
                    //}
                    if (AppContext.hasPlugin("index")) {
                      indexManager.add(bean.getId(), ApplicationCategoryEnum.bulletin.getKey());
                    }
                  } catch (Exception e) {
                    log.error("全文检索失败", e);
                  }
                  //发送审核通过的公告消息进行发布
                  if (bean.getState().equals(Constants.DATA_STATE_ALREADY_PUBLISH)) {
                    Set<Long> msgReceiverIds = this.getAllMembersinPublishScope(bean);
                    /*
              		过滤掉非自定义空间中人员
                    if (("true".equals(custom) || Strings.isNotBlank(spaceId)) && sendMsgWhenCancelPublish) {
                        List<V3xOrgMember> customMembers = spaceManager.getSpaceMemberBySecurity(
                                Long.parseLong(spaceId), -1);

                        if (customMembers != null && customMembers.size() > 0) {
                            List<Long> customList = new ArrayList<Long>();
                            List<Long> tempList = new ArrayList<Long>();
                            for (V3xOrgMember m : customMembers) {
                                customList.add(m.getId());
                            }
                            for (Long memberId : msgReceiverIds) {
                                if (!customList.contains(memberId)) {
                                    tempList.add(memberId);
                                }
                            }
                            msgReceiverIds.removeAll(tempList);
                        }
                    }
                     */
                    this.addAdmins2MsgReceivers(msgReceiverIds, bean);
                    this.getBulletinUtils().initDataFlag(bean,true);
                    String deptName = bean.getPublishDeptName();
                    userMessageManager.sendSystemMessage(
                        MessageContent.get("bul.auditing", bean.getTitle(), deptName)
                        .setBody(this.getBody(bean.getId()).getContent(),
                            bean.getDataFormat(), bean.getCreateDate()),
                            ApplicationCategoryEnum.bulletin, userId, MessageReceiver.getReceivers(bean.getId(), msgReceiverIds,
                                "message.link.bul.alreadyaudit", String.valueOf(bean.getId()),
                                new Timestamp(System.currentTimeMillis()) + ""), bean.getTypeId());

                    bulTypeManager.updateTypeETagDate(String.valueOf(bean.getTypeId()));
                  }
                }
                
                //删除待办记录
                affairManager.deleteByObjectId(ApplicationCategoryEnum.bulletin, bean.getId());
            }

        }
    	return null;
    }

    /**
     * 公告审核取消审核
     * @param idStr
     * @return
     * @throws Exception
     */
    @AjaxAccess
    public String cancelAudit(String idStr) throws Exception {
    	User user = AppContext.getCurrentUser();
        String userName = user.getName();
        if (StringUtils.isBlank(idStr)) {
        	return null;
        }else{
        	String[] idArr = idStr.split(",");
            for (String sid : idArr) {
                long dataId = Long.valueOf(sid);
                BulData bean = this.getById(dataId);
                if (bean == null)
                    continue;

                BulType bulType = bean.getType();
                if (bean.getState().intValue() != Constants.DATA_STATE_ALREADY_AUDIT)
                    continue;

                bean.setAuditAdvice(null);
                bean.setState(Constants.DATA_STATE_ALREADY_CREATE);
                //删除待办事项
                affairManager.deleteByObjectId(ApplicationCategoryEnum.bulletin, bean.getId());
                this.addPendingAffair(bulType, bean);
                //zhangxw 2012-10-30  添加显示更新语句，实现‘取消审核’
                this.updateDirect(bean);

                //取消审核给创建者发送消息
                List<Long> msgReceiverIds = new ArrayList<Long>();
                msgReceiverIds.add(bean.getCreateUser());
                Collection<MessageReceiver> receivers = MessageReceiver.get(bean.getId(), msgReceiverIds);
                userMessageManager.sendSystemMessage(MessageContent.get("bul.cancel.audit", bean.getTitle(), userName),
                        ApplicationCategoryEnum.bulletin, user.getId(), receivers);

                //取消审核加日志
                //TODO appLogManager.insertLog(user, AppLogAction.Bulletin_CancelAudit, userName, bean.getTitle());
            }
        }

    	return null;
    }
    /**
     * 为以下几种情况增加待办事项：
     * 1.新建公告，发送待审核，增加一条对应的待办事项记录；
     * 2.已发送的公告，未审核之前修改，再行发送，增加一条待审核记录，同时删除修改之前已有的待办事项记录；
     * 3.已审核且不通过的公告，修改后再次发送待审核，增加一条对应的待办事项记录。
     */
    private void addPendingAffair(BulType bulType, BulData bean) throws BusinessException {
        CtpAffair affair = new CtpAffair();
        affair.setIdIfNew();
        affair.setTrack(TrackEnum.no.ordinal());
        affair.setDelete(false);
        //利用 subjectId 存储空间类型，将来用于进入不同的页面
        affair.setSubObjectId(Long.valueOf(bulType.getSpaceType().toString()));
        affair.setMemberId(bulType.getAuditUser());
        affair.setState(StateEnum.col_pending.key());
        affair.setSubState(SubStateEnum.col_pending_unRead.key());
        affair.setSenderId(bean.getCreateUser());
        affair.setSubject(bean.getTitle());
        affair.setObjectId(bean.getId());
        affair.setApp(ApplicationCategoryEnum.bulletin.key());
        affair.setSubApp(ApplicationSubCategoryEnum.bulletin_audit.key());
        affair.setCreateDate(new Timestamp(bean.getCreateDate().getTime()));
        affair.setReceiveTime((new Timestamp(System.currentTimeMillis())));

        AffairUtil.setHasAttachments(affair, bean.getAttachmentsFlag());

        AffairUtil.addExtProperty(affair, AffairExtPropEnums.spaceType, bulType.getSpaceType());
        AffairUtil.addExtProperty(affair, AffairExtPropEnums.spaceId, bulType.getAccountId());
        AffairUtil.addExtProperty(affair, AffairExtPropEnums.typeId, bulType.getId());

        affairManager.save(affair);
    }

    /**
     * 公告审核操作
     * @param bulId 公告ID
     * 		  form_oper  审核选择的操作
     * @return
     * @throws Exception
     */
    @AjaxAccess
    public String auditOper(Map<String, Object> param) throws Exception {
    	String idStr = param.get("bulId").toString();
    	String form_oper = param.get("type").toString();
    	String auditAdvice = param.get("audit_msg").toString();
        if (StringUtils.isBlank(idStr)) {
            throw new BusinessException("bulletin.not_exists");
        }
        User user = AppContext.getCurrentUser();
        BulData bean = this.getById(Long.valueOf(idStr));
        if(bean.isDeletedFlag()){
        	return "delete";
        }
        //处理审核两次的情况,只有是未审核的状态才允许审核操作
        if (bean.getState().intValue() != Constants.DATA_STATE_ALREADY_CREATE) {
            return "error";
        }
        
        
      //判断是否是二次发布的公告
        boolean hasOldBean = false;
        BulData oldBean = null;
        if(bean.getOldId()!=null &&bean.getOldId().intValue()!=0){
          oldBean = this.getById(Long.valueOf(bean.getOldId()));
         if(oldBean!=null && StringUtils.isNotBlank(form_oper) && form_oper.equals("publish")){
           hasOldBean = true;
         }
        }
        BulType type = this.bulTypeManager.getById(bean.getTypeId());
        boolean hasSettingFlag = type != null && type.isTypesettingFlag() && type.getTypesettingStaff()!=null && type.getTypesettingStaff().intValue() !=0 && type.getTypesettingStaff().intValue()!=1;
        if(hasOldBean && !hasSettingFlag){ // 二次审核且没有排版节点
          //如果是二次发布且排版通过并发布，当前公告内容覆盖之前的老公告（除发布时间、发布人、查阅留痕等信息需要保留不变外），删除当前公告
          List<Attachment> oldAtts = attachmentManager.getByReference(oldBean.getId(), oldBean.getId());
          List<Long> oldFileUrls = new ArrayList<Long>();
          Map<Long,Long> oldFileUrlsMap = new HashMap<Long, Long>();
          if(!CollectionUtils.isEmpty(oldAtts)){
            for(Attachment att:oldAtts){
              oldFileUrls.add(att.getFileUrl());
              oldFileUrlsMap.put(att.getFileUrl(),att.getId());
            }
          }
          List<Attachment> atts = attachmentManager.getByReference(bean.getId(), bean.getId());
          List<Long> newAtts = new ArrayList<Long>();
          for(Attachment att:atts){
            if(oldFileUrls.contains(att.getFileUrl().longValue())){
              newAtts.add(att.getFileUrl());
              oldFileUrls.remove(att.getFileUrl().longValue());
              oldFileUrlsMap.remove(att.getFileUrl());
            }
          }
          //删除老公告的附件
          for(Map.Entry<Long, Long> entry:oldFileUrlsMap.entrySet()){
            attachmentManager.deleteById(entry.getValue());
          }
          
          //把新公告的附件指向老公告
          for(Attachment att:atts){
            if(newAtts.contains(att.getFileUrl()))continue;
            att.setReference(oldBean.getId());
            att.setSubReference(oldBean.getId());
            attachmentManager.update(att);
          }
          BulBody body = bulBodyDao.get(bean.getId());
          bulBodyDao.delete(oldBean.getId());//删除老公告的内容
          body.setId(oldBean.getId());//把新公告的内容复制到老公告上
          body.setBulDataId(oldBean.getId());
          bulBodyDao.save(body);
          //更新老公告
          oldBean.setTitle(bean.getTitle());
          oldBean.setFutitle(bean.getFutitle());
          oldBean.setSpaceType(bean.getSpaceType());
          oldBean.setType(bean.getType());
          oldBean.setTypeId(bean.getTypeId());
          oldBean.setTypeName(bean.getTypeName());
          oldBean.setPublishDepartmentId(bean.getPublishDepartmentId());
          oldBean.setAttachmentsFlag(bean.getAttachmentsFlag());
          oldBean.setAuditAdvice(bean.getAuditAdvice());
          oldBean.setAuditAdvice1(bean.getAuditAdvice1());
          oldBean.setAuditDate(bean.getAuditDate());
          oldBean.setAuditDate1(bean.getAuditDate1());
          oldBean.setAuditUserId(bean.getAuditUserId());
          oldBean.setAuditUserId1(bean.getAuditUserId1());
          oldBean.setBrief(bean.getBrief());
          oldBean.setKeywords(bean.getKeywords());
          oldBean.setPublishDeptName(bean.getPublishDeptName());
          oldBean.setPublishScope(bean.getPublishScope());
          oldBean.setExt1(bean.getExt1());
          oldBean.setExt2(bean.getExt2());
          oldBean.setShowPublishName(bean.getShowPublishName());
          oldBean.setShowPublishUserFlag(bean.isShowPublishUserFlag());
          
          //客开 gxy 公告发布时间可调整 start 20180712
          try {
        	  SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
              String editTime = param.get("editPublishDate").toString();
              if(editTime!=null && !"".equals(editTime)){
            	  Date date = format.parse(editTime);
            	  oldBean.setPublishDate(new Timestamp(date.getTime()));
              }
		  } catch (Exception e) {
			  log.error("发布时间调整异常", e);
		  }
    	  //客开 gxy 公告发布时间可调整 end 20180712
        
          this.updateDirect(oldBean);
          //删除新公告
          bean.setDeletedFlag(true);
          this.updateDirect(bean);
          // 删除待办
          affairManager.deleteByObjectId(ApplicationCategoryEnum.bulletin, bean.getId());
          getBulDataCache().getDataCache().remove(oldBean.getId());
          getBulDataCache().getDataCache().remove(bean.getId());
//          getBulDataCache().getDataCache().save(oldBean.getId(), oldBean, oldBean.getPublishDate().getTime(),
//              (oldBean.getReadCount() == null ? 0 : oldBean.getReadCount()));
          //对新文件进行解锁
          if (idStr != null && !"".equalsIgnoreCase(idStr))
            this.unlock(Long.valueOf(idStr));
        }else{
	        //BulType type = this.bulTypeManager.getById(bean.getTypeId());
	        if (StringUtils.isNotBlank(form_oper)) {
	            if ("audit".equals(form_oper)) {
	                bean.setState(Constants.DATA_STATE_ALREADY_AUDIT);
	            } else if ("publish".equals(form_oper)) {
	                //客开 start 判断是否需要排版
	              if(type != null && type.isTypesettingFlag() && type.getTypesettingStaff()!=null && type.getTypesettingStaff().intValue() !=0 && type.getTypesettingStaff().intValue()!=1){
	                bean.setState(Constants.DATA_STATE_TYPESETTING_CREATE);
	              //客开 gxy 公告发布时间可调整 start
	                try {
	              	  SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	                    String editTime = param.get("editPublishDate").toString();
	                    if(editTime==null || "".equals(editTime)){
	                    	bean.setPublishDate(new Timestamp(new Date().getTime()));
                        }else{
                        	Date date = format.parse(editTime);
    	                    bean.setPublishDate(new Timestamp(date.getTime()));
                        }
		      		  } catch (ParseException e) {
		      			  log.error("发布时间调整异常", e);
		      		  }
		          	  //客开 gxy 公告发布时间可调整 end
	              }else{
	            	//客开 gxy 公告发布时间可调整 start
	                  try {
	                	  SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	                      String editTime = param.get("editPublishDate").toString();
	                      if(editTime==null || "".equals(editTime)){
		                    	bean.setPublishDate(new Timestamp(new Date().getTime()));
	                        }else{
	                        	Date date = format.parse(editTime);
	    	                    bean.setPublishDate(new Timestamp(date.getTime()));
	                        }
	    			  } catch (ParseException e) {
	    				  log.error("发布时间调整异常", e);
	    			  }
	            	  //客开 gxy 公告发布时间可调整 end
	//                bean.setPublishUserId(AppContext.getCurrentUser().getId());
	                bean.setPublishUserId(bean.getCreateUser());
	                bean.setState(Constants.DATA_STATE_ALREADY_PUBLISH);
	              }
	                //客开 end
	                //审核员进行"直接发布"审核操作，该公告发布后，其审核记录设定为"直接发布" added by Meng Yang 2009-06-11
	                bean.setExt3(String.valueOf(Constants.AUDIT_RECORD_PUBLISH));
	            } else if ("noaudit".equals(form_oper)) {
	                bean.setState(Constants.DATA_STATE_NOPASS_AUDIT);
	            } else if ("cancelaudit".equals(form_oper)) {
	                bean.setState(Constants.DATA_STATE_ALREADY_CREATE);
	            }
	        } else{
	        	bean.setState(Constants.DATA_STATE_NO_SUBMIT);
	        }
	
	        bean.setAuditAdvice(auditAdvice);
	        bean.setAuditDate(new Date());
	        bean.setAuditUserId(type.getAuditUser());
	
	        bean.setUpdateDate(new Date());
	        bean.setUpdateUser(AppContext.getCurrentUser().getId());
	
	        Map<String, Object> summ = new HashMap<String, Object>();
	        summ.put("state", bean.getState());
	      //客开 gxy 20180704 修改发布时间 start
	        if(bean.getState().intValue() == Constants.DATA_STATE_TYPESETTING_CREATE){
		          if ("publish".equals(form_oper)) {
		              summ.put("publishDate", bean.getPublishDate());
		          }
	        }
	      //客开 gxy 20180704 修改发布时间 end
	        //客开start
	        if(bean.getState().intValue() == Constants.DATA_STATE_ALREADY_PUBLISH){
	          if ("publish".equals(form_oper)) {
	              summ.put("publishDate", bean.getPublishDate());
	//              summ.put("publishUserId", AppContext.getCurrentUser().getId());
	              summ.put("publishUserId", bean.getCreateUser());
	              summ.put("ext3", bean.getExt3());
	          }
	        }
	        //客开 end
	        summ.put("auditAdvice", bean.getAuditAdvice());
	        summ.put("auditDate", bean.getAuditDate());
	        summ.put("auditUserId", bean.getAuditUserId());
	        summ.put("updateDate", bean.getUpdateDate());
	        summ.put("updateUser", bean.getUpdateUser());
	
	        Long agentId = AgentUtil.getAgentByApp(type.getAuditUser(), ApplicationCategoryEnum.bulletin.getKey());
	        Long senderId = user.getId();
	        String senderName = user.getName();
	        int proxyType = 0;
	        if (agentId != null && agentId.equals(senderId)) {
	            proxyType = 1;
	            senderId = type.getAuditUser();
	            senderName = type.getAuditUserName();
	        }
	
	        //审合公告通过发送系统消息、添加操作日志
	        if (bean.getState().equals(Constants.DATA_STATE_ALREADY_AUDIT)) {
	            userMessageManager.sendSystemMessage(
	                    MessageContent.get("bul.alreadyauditing", bean.getTitle(), senderName, proxyType, user.getName()),
	                    ApplicationCategoryEnum.bulletin,
	                    senderId,
	                    MessageReceiver.get(bean.getId(), bean.getCreateUser(), "message.link.bul.writedetail",
	                            String.valueOf(bean.getId())), bean.getTypeId());
	
	            appLogManager.insertLog(user, AppLogAction.Bulletin_AuditPass, user.getName(), bean.getTitle());
	
	        }
	        //审合公告没有通过发送系统消息、添加操作日志
	        if (bean.getState().equals(Constants.DATA_STATE_NOPASS_AUDIT)) {
	            userMessageManager.sendSystemMessage(
	                    MessageContent.get("bul.notthrougth", bean.getTitle(), senderName, proxyType, user.getName()),
	                    ApplicationCategoryEnum.bulletin,
	                    senderId,
	                    MessageReceiver.get(bean.getId(), bean.getCreateUser(), "message.link.bul.writedetail",
	                            String.valueOf(bean.getId())), bean.getTypeId());
	
	            appLogManager.insertLog(user, AppLogAction.Bulletin_AduitNotPass, user.getName(), bean.getTitle());
	
	        }
	        //审核员直接发布公告
	        if (bean.getState().equals(Constants.DATA_STATE_ALREADY_PUBLISH)) {
	            List<Long> memberList = new ArrayList<Long>();
	            Set<Long> msgReceiverIds = new HashSet<Long>();
	            BulType bulType = bean.getType();
	            boolean customFlag = false;
	            if (bulType.getSpaceType() == 4 || bulType.getSpaceType() == 5 || bulType.getSpaceType() == 6) {
	                customFlag = true;
	                List<V3xOrgMember> customMembers = spaceManager.getSpaceMemberBySecurity(bulType.getAccountId(), -1);
	
	                if (customMembers != null && customMembers.size() > 0) {
	                    String memberIds = bean.getPublishScope();
	                    memberList = CommonTools.getMemberIdsByTypeAndId(memberIds, orgManager);
	
	                    List<Long> customList = new ArrayList<Long>();
	                    List<Long> tempList = new ArrayList<Long>();
	                    for (V3xOrgMember m : customMembers) {
	                        customList.add(m.getId());
	                    }
	                    for (Long memberId : memberList) {
	                        if (!customList.contains(memberId)) {
	                            tempList.add(memberId);
	                        }
	                    }
	                    memberList.removeAll(tempList);
	                }
	            } else {
	                msgReceiverIds = this.getAllMembersinPublishScope(bean);
	            }
	
	            this.addAdmins2MsgReceivers(customFlag ? memberList : msgReceiverIds, bean);
	
	            this.getBulletinUtils().initDataFlag(bean,true);
	            String deptName = bean.getPublishDeptName();
	            userMessageManager.sendSystemMessage(
	                    MessageContent.get("bul.auditing", bean.getTitle(), deptName).setBody(
	                            this.getBody(bean.getId()).getContent(), bean.getDataFormat(),
	                            bean.getCreateDate()), ApplicationCategoryEnum.bulletin, bean.getPublishUserId(),
	                    MessageReceiver.getReceivers(bean.getId(), customFlag ? memberList : msgReceiverIds,
	                            "message.link.bul.alreadyauditing", String.valueOf(bean.getId())), bean.getTypeId());
	
	            //直接发布加日志
	            appLogManager.insertLog(user, AppLogAction.Bulletin_AuditPublish, user.getName(), bean.getTitle());
	            //触发发布事件
	            BulletinAddEvent bulletinAddEvent = new BulletinAddEvent(this);
	            bulletinAddEvent.setBulDataBO(BulletinUtils.bulDataPOToBO(bean));
	            EventDispatcher.fireEvent(bulletinAddEvent);
	
	            bulTypeManager.updateTypeETagDate(String.valueOf(bean.getTypeId()));
	        }
	        this.update(bean.getId(), summ);
	        //触发审核事件
	        BulletinAuditEvent bulletinAuditEvent = new BulletinAuditEvent(this);
	        bulletinAuditEvent.setBulDataBO(BulletinUtils.bulDataPOToBO(bean));
	        EventDispatcher.fireEvent(bulletinAuditEvent);
	        if (bean.getState().equals(Constants.DATA_STATE_ALREADY_PUBLISH)) {
	            //更新数据库后再加入全文检索
	            try {
	                if (AppContext.hasPlugin("index")) {
	                    indexManager.add(bean.getId(), ApplicationCategoryEnum.bulletin.getKey());
	                }
	
	            } catch (Exception e) {
	                log.error("全文检索：", e);
	            }
	        }
	        //删除待办事项
	        affairManager.deleteByObjectId(ApplicationCategoryEnum.bulletin, bean.getId());
	        
	        //如果是审核通过，生成一条待办记录
	        if (bean.getState().equals(Constants.DATA_STATE_ALREADY_AUDIT)) {
	            BulType bulType = this.bulTypeManager.getById(bean.getTypeId());
	        	addPendingAffair(bulType, bean, ApplicationSubCategoryEnum.bulletin_to_publish);
	        }
      }
    	return "success";
    }
    
    /**
     * 为以下几种情况增加待办事项：
     * 1.新建公告，发送待审核，增加一条对应的待办事项记录；
     * 2.已发送的公告，未审核之前修改，再行发送，增加一条待审核记录，同时删除修改之前已有的待办事项记录；
     * 3.已审核且不通过的公告，修改后再次发送待审核，增加一条对应的待办事项记录。
     */
    public void addPendingAffair(BulType bulType, BulData bean,ApplicationSubCategoryEnum subApp) throws BusinessException {
        CtpAffair affair = new CtpAffair();
        affair.setIdIfNew();
        affair.setTrack(TrackEnum.no.ordinal());
        affair.setDelete(false);
        //利用 subjectId 存储空间类型，将来用于进入不同的页面
        affair.setSubObjectId(Long.valueOf(bulType.getSpaceType().toString()));
        int subAppInt = subApp.key();
        if(ApplicationSubCategoryEnum.bulletin_audit.getKey() == subAppInt){
        	affair.setMemberId(bulType.getAuditUser());
        }else{
        	affair.setMemberId(bean.getCreateUser());
        }
        affair.setState(StateEnum.col_pending.key());
        affair.setSubState(SubStateEnum.col_pending_unRead.key());
        affair.setSenderId(bean.getCreateUser());
        affair.setSubject(bean.getTitle());
        affair.setObjectId(bean.getId());
        affair.setApp(ApplicationCategoryEnum.bulletin.key());
        affair.setSubApp(subApp.key());
        affair.setCreateDate(new Timestamp(bean.getCreateDate().getTime()));
        affair.setReceiveTime((new Timestamp(System.currentTimeMillis())));

        AffairUtil.setHasAttachments(affair, bean.getAttachmentsFlag());

        AffairUtil.addExtProperty(affair, AffairExtPropEnums.spaceType, bulType.getSpaceType());
        AffairUtil.addExtProperty(affair, AffairExtPropEnums.spaceId, bulType.getAccountId());
        AffairUtil.addExtProperty(affair, AffairExtPropEnums.typeId, bulType.getId());

        affairManager.save(affair);
    }
	
	
	
    //客开 start
    /**
     * 公告排版审核
     * @param param
     * @return
     * @throws Exception
     */
    @AjaxAccess
    public String auditOper2(Map<String, Object> param) throws Exception {
      String idStr = param.get("bulId").toString();
      String form_oper = param.get("type").toString();
      String auditAdvice = param.get("audit_msg").toString();
      if (StringUtils.isBlank(idStr)) {
        throw new BusinessException("bulletin.not_exists");
      }
      User user = AppContext.getCurrentUser();
      BulData bean = this.getById(Long.valueOf(idStr));
      //处理审核两次的情况,只有是未审核的状态才允许审核操作
      if (bean.getState().intValue() != Constants.DATA_STATE_TYPESETTING_CREATE) {
        return "error";
      }
      //判断是否是二次发布的公告
      boolean hasOldBean = false;
      BulData oldBean = null;
      if(bean.getOldId()!=null &&bean.getOldId().intValue()!=0){
        oldBean = this.getById(Long.valueOf(bean.getOldId()));
       if(oldBean!=null && StringUtils.isNotBlank(form_oper) && form_oper.equals("publish")){
         hasOldBean = true;
       }
      }
      if(hasOldBean){
        //如果是二次发布且排版通过并发布，当前公告内容覆盖之前的老公告（除发布时间、发布人、查阅留痕等信息需要保留不变外），删除当前公告
        List<Attachment> oldAtts = attachmentManager.getByReference(oldBean.getId(), oldBean.getId());
        List<Long> oldFileUrls = new ArrayList<Long>();
        Map<Long,Long> oldFileUrlsMap = new HashMap<Long, Long>();
        if(!CollectionUtils.isEmpty(oldAtts)){
          for(Attachment att:oldAtts){
            oldFileUrls.add(att.getFileUrl());
            oldFileUrlsMap.put(att.getFileUrl(),att.getId());
          }
        }
        List<Attachment> atts = attachmentManager.getByReference(bean.getId(), bean.getId());
        List<Long> newAtts = new ArrayList<Long>();
        for(Attachment att:atts){
          if(oldFileUrls.contains(att.getFileUrl().longValue())){
            newAtts.add(att.getFileUrl());
            oldFileUrls.remove(att.getFileUrl().longValue());
            oldFileUrlsMap.remove(att.getFileUrl());
          }
        }
        //删除老公告的附件
        for(Map.Entry<Long, Long> entry:oldFileUrlsMap.entrySet()){
          attachmentManager.deleteById(entry.getValue());
        }
        
        //把新公告的附件指向老公告
        for(Attachment att:atts){
          if(newAtts.contains(att.getFileUrl()))continue;
          att.setReference(oldBean.getId());
          att.setSubReference(oldBean.getId());
          attachmentManager.update(att);
        }
        BulBody body = bulBodyDao.get(bean.getId());
        bulBodyDao.delete(oldBean.getId());//删除老公告的内容
        body.setId(oldBean.getId());//把新公告的内容复制到老公告上
        body.setBulDataId(oldBean.getId());
        bulBodyDao.save(body);
        //更新老公告
        oldBean.setTitle(bean.getTitle());
        oldBean.setFutitle(bean.getFutitle());
        oldBean.setSpaceType(bean.getSpaceType());
        oldBean.setType(bean.getType());
        oldBean.setTypeId(bean.getTypeId());
        oldBean.setTypeName(bean.getTypeName());
        oldBean.setPublishDepartmentId(bean.getPublishDepartmentId());
        oldBean.setAttachmentsFlag(bean.getAttachmentsFlag());
        oldBean.setAuditAdvice(bean.getAuditAdvice());
        oldBean.setAuditAdvice1(bean.getAuditAdvice1());
        oldBean.setAuditDate(bean.getAuditDate());
        oldBean.setAuditDate1(bean.getAuditDate1());
        oldBean.setAuditUserId(bean.getAuditUserId());
        oldBean.setAuditUserId1(bean.getAuditUserId1());
        oldBean.setBrief(bean.getBrief());
        oldBean.setKeywords(bean.getKeywords());
        oldBean.setPublishDeptName(bean.getPublishDeptName());
        oldBean.setPublishScope(bean.getPublishScope());
        oldBean.setExt1(bean.getExt1());
        oldBean.setExt2(bean.getExt2());
        oldBean.setShowPublishName(bean.getShowPublishName());
        oldBean.setShowPublishUserFlag(bean.isShowPublishUserFlag());
        
      //客开 gxy 公告发布时间可调整 start 20180712
        try {
      	  SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            String editTime = param.get("editPublishDate").toString();
            if(editTime!=null && !"".equals(editTime)){
          	  Date date = format.parse(editTime);
          	  oldBean.setPublishDate(new Timestamp(date.getTime()));
            }
		  } catch (Exception e) {
			  log.error("发布时间调整异常", e);
		  }
  	  //客开 gxy 公告发布时间可调整 end 20180712
      
        this.updateDirect(oldBean);
        //删除新公告
        bean.setDeletedFlag(true);
        this.updateDirect(bean);
        // 删除待办
        affairManager.deleteByObjectId(ApplicationCategoryEnum.bulletin, bean.getId());
        getBulDataCache().getDataCache().remove(oldBean.getId());
        getBulDataCache().getDataCache().remove(bean.getId());
//        getBulDataCache().getDataCache().save(oldBean.getId(), oldBean, oldBean.getPublishDate().getTime(),
//            (oldBean.getReadCount() == null ? 0 : oldBean.getReadCount()));
        //对新闻文件进行解锁
        if (idStr != null && !"".equalsIgnoreCase(idStr))
          this.unlock(Long.valueOf(idStr));
      }else{
        if (StringUtils.isNotBlank(form_oper)) {
          if ("audit".equals(form_oper)) {
            bean.setState(Constants.DATA_STATE_TYPESETTING_PASS);
          } else if ("publish".equals(form_oper)) {
        	//客开 gxy 公告发布时间可调整 start
              try {
            	  SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                  String editTime = param.get("editPublishDate").toString();
 
                  if(editTime==null || "".equals(editTime)){
                  	bean.setPublishDate(new Timestamp(new Date().getTime()));
                  }else{
                  	Date date = format.parse(editTime);
	                bean.setPublishDate(new Timestamp(date.getTime()));
                  }
    		  } catch (ParseException e) {
    			  log.error("发布时间调整异常", e);
    		  }
        	  //客开 gxy 公告发布时间可调整 end
//            bean.setPublishUserId(AppContext.getCurrentUser().getId());
            bean.setPublishUserId(bean.getCreateUser());
            bean.setState(Constants.DATA_STATE_ALREADY_PUBLISH);
            //审核员进行"直接发布"审核操作，该公告发布后，其审核记录设定为"直接发布" added by Meng Yang 2009-06-11
            bean.setExt3(String.valueOf(Constants.AUDIT_RECORD_PUBLISH));
          } else if ("noaudit".equals(form_oper)) {
            bean.setState(Constants.DATA_STATE_TYPESETTING_NOPASS);
          } else if ("cancelaudit".equals(form_oper)) {
            bean.setState(Constants.DATA_STATE_TYPESETTING_CREATE);
          }
        } else{
          bean.setState(Constants.DATA_STATE_NO_SUBMIT);
        }
        BulType type = this.bulTypeManager.getById(bean.getTypeId());

        bean.setAuditAdvice1(auditAdvice);
        bean.setAuditDate1(new Date());
        bean.setAuditUserId1(type.getTypesettingStaff());

        bean.setUpdateDate(new Date());
        bean.setUpdateUser(AppContext.getCurrentUser().getId());

        Map<String, Object> summ = new HashMap<String, Object>();
        summ.put("state", bean.getState());

        if ("publish".equals(form_oper)) {
            summ.put("publishDate", bean.getPublishDate());
//            summ.put("publishUserId", AppContext.getCurrentUser().getId());
            summ.put("publishUserId", bean.getCreateUser());
            summ.put("ext3", bean.getExt3());
        }
        summ.put("auditAdvice1", bean.getAuditAdvice1());
        summ.put("auditDate1", bean.getAuditDate1());
        summ.put("auditUserId1", bean.getAuditUserId1());
        summ.put("updateDate", bean.getUpdateDate());
        summ.put("updateUser", bean.getUpdateUser());

        Long agentId = AgentUtil.getAgentByApp(type.getAuditUser(), ApplicationCategoryEnum.bulletin.getKey());
        Long senderId = user.getId();
        String senderName = user.getName();
        int proxyType = 0;
        if (agentId != null && agentId.equals(senderId)) {
          proxyType = 1;
          senderId = type.getAuditUser();
          senderName = type.getAuditUserName();
        }

        //审合公告通过发送系统消息、添加操作日志
        if (bean.getState().equals(Constants.DATA_STATE_TYPESETTING_PASS)) {
          userMessageManager.sendSystemMessage(
              MessageContent.get("bul.alreadyauditing", bean.getTitle(), senderName, proxyType, user.getName()),
              ApplicationCategoryEnum.bulletin,
              senderId,
              MessageReceiver.get(bean.getId(), bean.getCreateUser(), "message.link.bul.writedetail",
                  String.valueOf(bean.getId())), bean.getTypeId());

          appLogManager.insertLog(user, AppLogAction.Bulletin_AuditPass, user.getName(), bean.getTitle());

        }
        //审合公告没有通过发送系统消息、添加操作日志
        if (bean.getState().equals(Constants.DATA_STATE_TYPESETTING_NOPASS)) {
          userMessageManager.sendSystemMessage(
              MessageContent.get("bul.notthrougth", bean.getTitle(), senderName, proxyType, user.getName()),
              ApplicationCategoryEnum.bulletin,
              senderId,
              MessageReceiver.get(bean.getId(), bean.getCreateUser(), "message.link.bul.writedetail",
                  String.valueOf(bean.getId())), bean.getTypeId());

          appLogManager.insertLog(user, AppLogAction.Bulletin_AduitNotPass, user.getName(), bean.getTitle());

        }
        //审核员直接发布公告
        if (bean.getState().equals(Constants.DATA_STATE_ALREADY_PUBLISH)) {
          List<Long> memberList = new ArrayList<Long>();
          Set<Long> msgReceiverIds = new HashSet<Long>();
          BulType bulType = bean.getType();
          boolean customFlag = false;
          if (bulType.getSpaceType() == 4 || bulType.getSpaceType() == 5 || bulType.getSpaceType() == 6) {
            customFlag = true;
            List<V3xOrgMember> customMembers = spaceManager.getSpaceMemberBySecurity(bulType.getAccountId(), -1);

            if (customMembers != null && customMembers.size() > 0) {
              String memberIds = bean.getPublishScope();
              memberList = CommonTools.getMemberIdsByTypeAndId(memberIds, orgManager);

              List<Long> customList = new ArrayList<Long>();
              List<Long> tempList = new ArrayList<Long>();
              for (V3xOrgMember m : customMembers) {
                customList.add(m.getId());
              }
              for (Long memberId : memberList) {
                if (!customList.contains(memberId)) {
                  tempList.add(memberId);
                }
              }
              memberList.removeAll(tempList);
            }
          } else {
            msgReceiverIds = this.getAllMembersinPublishScope(bean);
          }

          this.addAdmins2MsgReceivers(customFlag ? memberList : msgReceiverIds, bean);

          this.getBulletinUtils().initDataFlag(bean,true);
          String deptName = bean.getPublishDeptName();
          userMessageManager.sendSystemMessage(
              MessageContent.get("bul.auditing", bean.getTitle(), deptName).setBody(
                  this.getBody(bean.getId()).getContent(), bean.getDataFormat(),
                  bean.getCreateDate()), ApplicationCategoryEnum.bulletin, bean.getPublishUserId(),
                  MessageReceiver.getReceivers(bean.getId(), customFlag ? memberList : msgReceiverIds,
                      "message.link.bul.alreadyauditing", String.valueOf(bean.getId())), bean.getTypeId());

          //直接发布加日志
          appLogManager.insertLog(user, AppLogAction.Bulletin_AuditPublish, user.getName(), bean.getTitle());
          //触发发布事件
          BulletinAddEvent bulletinAddEvent = new BulletinAddEvent(this);
          bulletinAddEvent.setBulDataBO(BulletinUtils.bulDataPOToBO(bean));
          EventDispatcher.fireEvent(bulletinAddEvent);

          bulTypeManager.updateTypeETagDate(String.valueOf(bean.getTypeId()));
        }
        this.update(bean.getId(), summ);
        //触发审核事件
        BulletinAuditEvent bulletinAuditEvent = new BulletinAuditEvent(this);
        bulletinAuditEvent.setBulDataBO(BulletinUtils.bulDataPOToBO(bean));
        EventDispatcher.fireEvent(bulletinAuditEvent);
        if (bean.getState().equals(Constants.DATA_STATE_ALREADY_PUBLISH)) {
          //更新数据库后再加入全文检索
          try {
            if (AppContext.hasPlugin("index")) {
              indexManager.add(bean.getId(), ApplicationCategoryEnum.bulletin.getKey());
            }

          } catch (Exception e) {
            log.error("全文检索：", e);
          }
        }
        //删除待办事项
        affairManager.deleteByObjectId(ApplicationCategoryEnum.bulletin, bean.getId());
      }
      return "success";
    }
    //客开 end

    //切换版块获取版块列表
    @AjaxAccess
    public List<BulType> getbulTypeList(Map<String, Object> param) throws Exception {
    	User user = AppContext.getCurrentUser();
    	String spaceId = param.get("spaceId").toString();
    	String spaceType = param.get("bulTypeSpaceType").toString();
    	SpaceType bulTypeSpaceType = Constants.valueOfSpaceType(Integer.valueOf(spaceType));
    	List<BulType> bulTypeList = new ArrayList<BulType>();
        if (Strings.isNotBlank(spaceId)) {
            bulTypeList =  bulTypeManager.getTypesCanCreate(user.getId(), bulTypeSpaceType, Long.parseLong(spaceId));
        } else {
            bulTypeList = bulTypeManager.getTypesCanCreate(user.getId(), bulTypeSpaceType, user.getLoginAccount());
        }
        return bulTypeList;
    }

    public Map<String,Object> changeTypeList(Integer spaceType,Long spaceId) throws Exception{
    	User user = AppContext.getCurrentUser();
    	if(spaceType == null){
    		return null;
    	}
    	Map<String,Object> map = new HashMap<String,Object>();
    	SpaceType bulTypeSpaceType = Constants.valueOfSpaceType(Integer.valueOf(spaceType));
    	List<BulType> bulTypeList = new ArrayList<BulType>();
        if (Strings.isNotBlank(String.valueOf(spaceId))) {
            bulTypeList =  bulTypeManager.getTypesCanCreate(user.getId(), bulTypeSpaceType,spaceId);
        } else {
            bulTypeList = bulTypeManager.getTypesCanCreate(user.getId(), bulTypeSpaceType, user.getLoginAccount());
        }
        map.put("bulTypeList",bulTypeList);
        List<ContentTemplate> bulTemplate = new ArrayList<ContentTemplate>(); 
        if(3 == spaceType){
        	bulTemplate = contentTemplateManager.findGroupTypesByScope(user.getId(), ContentTemplate.BULLETIN_CONTENT_TEMPLATE_TYPE);
        }else if(2 == spaceType){
        	bulTemplate = contentTemplateManager.findAccountTypesByScope(user.getId(), user.getLoginAccount(), ContentTemplate.BULLETIN_CONTENT_TEMPLATE_TYPE);
        }
        map.put("bulTemplate", bulTemplate);
    	return map;
    }
    /**
     * 判断版块默认设置信息
     * @param bulTypeId
     * @return
     * @throws Exception
     */
    public String bulTypeDefault(Long bulTypeId) throws Exception{
    	BulType bul = bulTypeManager.getById(bulTypeId);
    	Boolean printFlag = bul.getPrintFlag();
    	Boolean printDefault = bul.getPrintDefault();
    	Boolean writePermit = bul.getWritePermit() == null ? false:bul.getWritePermit();
    	Boolean defaultPublish = bul.getDefaultPublish() == null ? false:bul.getDefaultPublish();
    	String finalPublish = bul.getFinalPublish() == null ? "0" : String.valueOf(bul.getFinalPublish());
		String typeDefault = "{\"printFlag\": \"" + printFlag + "\"," 
							+ "\"printDefault\": \"" + printDefault + "\","
							+ "\"defaultPublish\": \"" + defaultPublish + "\","
							+ "\"finalPublish\": \"" + finalPublish + "\","
							+ "\"writePermit\": \"" + writePermit + "\","
							+ "}";
    	return typeDefault;
    }
    /**
     * 公告格式列表
     * @param spaceType
     * @return
     * @throws BusinessException
     */
    public String getBulTempl(Integer spaceType) throws BusinessException{
    	Map<String,Object> map = new HashMap<String,Object>();
    	User user  = AppContext.getCurrentUser();
    	List<ContentTemplate> template = new ArrayList<ContentTemplate>();
    	if (spaceType == SpaceType.group.ordinal() || spaceType == SpaceType.public_custom_group.ordinal()) {
            template = contentTemplateManager.findGroupTypesByScope(user.getId(), ContentTemplate.BULLETIN_CONTENT_TEMPLATE_TYPE);
        }else{
            template = contentTemplateManager.findAccountTypesByScope(user.getId(), user.getLoginAccount(), ContentTemplate.BULLETIN_CONTENT_TEMPLATE_TYPE);
        }
    	map.put("template", template);
    	return JSONUtil.toJSONString(map);
    }

    @AjaxAccess
    public String isAuditType(Long id){
    	BulData bean = this.getBulDataCache().getDataCache().get(id);
        if(bean==null){
        	bean = getById(id);
        }
        BulType bulType = bulTypeManager.getById(bean.getTypeId());
        if(bulType.isAuditFlag() && bulType.getAuditUser()!=null){
            return "true";
        }
        return "false";
    }

    //客开 start 判断是否存在排版
    @AjaxAccess
    public String isTypesettingType(Long id){
      BulData bean = this.getBulDataCache().getDataCache().get(id);
      if(bean==null){
          bean = getById(id);
      }
      BulType bulType = bulTypeManager.getById(bean.getTypeId());
      if(bulType.isTypesettingFlag() && bulType.getTypesettingStaff()!=null){
        return "true";
      }
      return "false";
    }
    //客开 end

    /**
     * 修改公告前判断公告状态，版块是否审核，及版块是否允许当前人员修改
     * @param id
     * @return
     * @throws BusinessException
     */
    @AjaxAccess
    public Map<String,Object> checkStateBeforeModify(Map<String, String> params) throws BusinessException{
    	Long id = Long.valueOf(params.get("id"));
    	Map<String,Object> ret = new HashMap<String,Object>();
    	BulData data = this.getBulDataCache().getDataCache().get(id);
        if(data==null){
        	data = getById(id);
        }
    	if(data == null){
    		ret.put("state", null);
    		return ret;
    	} else {
        	//当前公告状态
        	int state = data.getState();
        	ret.put("state", state);
        	//版块是否需要审核
            BulType bulType = bulTypeManager.getById(data.getTypeId());
            boolean isAuditType = false;
            if(bulType !=null && bulType.isAuditFlag() && bulType.getAuditUser()!=null){
            	isAuditType = true;
            }
        	ret.put("isAuditType", isAuditType);
            //判断当前人员是否有发起权限
            User user = AppContext.getCurrentUser();

            boolean hasIssue = false;
            //部门空间管理授权人员发起权限判断
            if(SpaceType.department.ordinal() == bulType.getSpaceType()){
                hasIssue = spaceManager.isManagerOfThisSpace(user.getId(),spaceManager.getDeptSpaceIdByDeptId(bulType.getId()).getId());
            }
            Set<BulTypeManagers> bulTypeManagers = bulType.getBulTypeManagers();
            List<Long> domainIds = orgManager.getAllUserDomainIDs(user.getId());
            for (BulTypeManagers tm : bulTypeManagers) {
                if (Constants.MANAGER_FALG.equals(tm.getExt1())) {
                    if (tm.getManagerId().equals(user.getId())) {
                        hasIssue = true;
                        break;
                    }
                } else if (Constants.WRITE_FALG.equals(tm.getExt1())) {
                    if (domainIds.contains(tm.getManagerId())) {
                        hasIssue = true;
                        break;
                    }
                }
            }

            ret.put("hasIssue", hasIssue);
            return ret;
    	}

    }

    /**
     * 是否有 发起权限/审核权限
     * [0] hasIssue
     * [1] hasAudit
     * @param spaceType
     * @param spaceId
     * @param user
     * @return
     * @throws BusinessException
     */
    public boolean[] hasPermission(int spaceType, Long spaceId, User user) throws BusinessException {
        boolean hasIssue = false;
        boolean hasAudit = false;
        //客开 start  排版权限标识
        boolean hasTypesetting = false;
        //客开 end

        List<BulType> myBulTypeList = new ArrayList<BulType>();
        if (spaceType == SpaceType.public_custom_group.ordinal()) {// 自定义集团空间
            List<BulType> customBulTypeList = bulTypeManager.customAccBoardAllBySpaceId(spaceId, spaceType);
            myBulTypeList.addAll(customBulTypeList);
        } else if (spaceType == SpaceType.public_custom.ordinal()) {// 自定义单位空间
            List<BulType> customBulTypeList = bulTypeManager.customAccBoardAllBySpaceId(spaceId, spaceType);
            myBulTypeList.addAll(customBulTypeList);
        } else if (spaceType == SpaceType.custom.ordinal()) {// 自定义团队空间
            List<BulType> customBulTypeList = bulTypeManager.customAccBoardAllBySpaceId(spaceId, spaceType);
            myBulTypeList.addAll(customBulTypeList);
        } else if (spaceType == SpaceType.department.ordinal()) {// 部门版块
            hasIssue = spaceManager.isManagerOfThisSpace(user.getId(), spaceId);
        } else {
            // 集团版块
            List<BulType> groupBulTypeList = bulTypeManager.groupFindAll();
            myBulTypeList.addAll(groupBulTypeList);
            // 单位版块
            List<BulType> accountBulTypeList = bulTypeManager.boardFindAllByAccountId(user.getLoginAccount());
            myBulTypeList.addAll(accountBulTypeList);
        }

        if (Strings.isNotEmpty(myBulTypeList)) {
            for (BulType bulType : myBulTypeList) {
                List<Long> domainIds = orgManager.getAllUserDomainIDs(user.getId());
                for (BulTypeManagers tm : bulType.getBulTypeManagers()) {
                    if (domainIds.contains(tm.getManagerId())) {
                        if (Constants.MANAGER_FALG.equals(tm.getExt1())) {
                            hasIssue = true;
                        } else if (Constants.WRITE_FALG.equals(tm.getExt1())) {
                            hasIssue = true;
                        }
                    }
                }
                if (bulType.isAuditFlag() && bulType.getAuditUser().longValue() == user.getId()) {
                    hasAudit = true;
                }
              //客开 start
                if ( bulType.isTypesettingFlag() && bulType.getTypesettingStaff().longValue() == user.getId()) {
                  hasTypesetting = true;
              }
                //客开 end

            }
        }
        return new boolean[] { hasIssue, hasAudit,hasTypesetting };
    }

}
