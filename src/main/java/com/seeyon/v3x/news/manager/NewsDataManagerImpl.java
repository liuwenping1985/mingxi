package com.seeyon.v3x.news.manager;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.dao.DataAccessException;

import com.seeyon.apps.agent.utils.AgentUtil;
import com.seeyon.apps.doc.api.DocApi;
import com.seeyon.apps.doc.bo.DocLibBO;
import com.seeyon.apps.doc.bo.DocResourceBO;
import com.seeyon.apps.doc.constants.DocConstants;
import com.seeyon.apps.index.bo.AuthorizationInfo;
import com.seeyon.apps.index.bo.IndexInfo;
import com.seeyon.apps.index.manager.IndexManager;
import com.seeyon.apps.index.util.IndexUtil;
import com.seeyon.apps.news.event.NewsAddEvent;
import com.seeyon.apps.news.event.NewsAuditEvent;
import com.seeyon.ctp.cluster.notification.NotificationManager;
import com.seeyon.ctp.cluster.notification.NotificationType;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.SystemEnvironment;
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
import com.seeyon.ctp.common.filemanager.manager.PartitionManager;
import com.seeyon.ctp.common.i18n.ResourceBundleUtil;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.idmapper.GuidMapper;
import com.seeyon.ctp.common.parser.StrExtractor;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.po.filemanager.Partition;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.common.usermessage.MessageContent;
import com.seeyon.ctp.common.usermessage.MessageReceiver;
import com.seeyon.ctp.common.usermessage.UserMessageManager;
import com.seeyon.ctp.event.EventDispatcher;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
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
import com.seeyon.ctp.util.cache.DataCache;
import com.seeyon.v3x.bbs.util.CacheInfo;
import com.seeyon.v3x.isearch.model.ConditionModel;
import com.seeyon.v3x.news.dao.NewsBodyDao;
import com.seeyon.v3x.news.dao.NewsDataDao;
import com.seeyon.v3x.news.domain.NewsBody;
import com.seeyon.v3x.news.domain.NewsData;
import com.seeyon.v3x.news.domain.NewsRead;
import com.seeyon.v3x.news.domain.NewsReply;
import com.seeyon.v3x.news.domain.NewsType;
import com.seeyon.v3x.news.domain.NewsTypeManagers;
import com.seeyon.v3x.news.util.Constants;
import com.seeyon.v3x.news.util.NewsDataLock;
import com.seeyon.v3x.news.util.NewsUtils;
import com.seeyon.v3x.news.util.ParseStcXmlUtil;
import com.seeyon.v3x.news.util.TypeCastUtil;
import com.seeyon.v3x.news.vo.NewsDataVO;
import com.seeyon.v3x.news.vo.NewsReplyVO;
import com.seeyon.v3x.news.vo.StcVo;

/**
 * 新闻最重要的Manager的实现类。包括了新闻发起员、新闻审核员、新闻管理员、普通用户的操作getAllTypeListExcludeDept。
 * @author wolf
 *	对新闻基本信息加上一个文件锁
 */
public class NewsDataManagerImpl implements NewsDataManager {

    private static final Log             log           = LogFactory.getLog(NewsDataManagerImpl.class);
    private NewsDataDao                  newsDataDao;
    private AttachmentManager            attachmentManager;
    private FileManager                  fileManager;

    private NewsBodyDao                  newsBodyDao;
    private DocApi                       docApi;
    private IndexManager                 indexManager;
    private PartitionManager             partitionManager;
    //对新闻基本信息加上一个文件锁
    private Map<Long, NewsDataLock>      newsdataLockMap;
    private OrgManager                   orgManager;
    private GuidMapper                   guidMapper;
    private NewsUtils                    newsUtils;

    private NewsReplyManager             newsReplyManager;

    private DataCache<NewsData>          dataCache;
    private UserMessageManager           userMessageManager;
    private AffairManager                affairManager;
    private AppLogManager                appLogManager;
    private PortletEntityPropertyManager portletEntityPropertyManager;

    private SpaceManager                 spaceManager;

    private final Object                 readCountLock = new Object();

    public void setDocApi(DocApi docApi) {
        this.docApi = docApi;
    }

    public GuidMapper getGuidMapper() {
        return guidMapper;
    }

    public void setGuidMapper(GuidMapper guidMapper) {
        this.guidMapper = guidMapper;
    }

    public NewsUtils getNewsUtils() {
		return newsUtils;
	}

	public void setNewsUtils(NewsUtils newsUtils) {
		this.newsUtils = newsUtils;
	}

	public AffairManager getAffairManager() {
		return affairManager;
	}

	public void setAffairManager(AffairManager affairManager) {
		this.affairManager = affairManager;
	}
	
	public void setNewsReplyManager(NewsReplyManager newsReplyManager) {
        this.newsReplyManager = newsReplyManager;
    }

	public UserMessageManager getUserMessageManager() {
		return userMessageManager;
	}

	public void setUserMessageManager(UserMessageManager userMessageManager) {
		this.userMessageManager = userMessageManager;
	}

	public AppLogManager getAppLogManager() {
		return appLogManager;
	}

	public void setAppLogManager(AppLogManager appLogManager) {
		this.appLogManager = appLogManager;
	}

	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}
	
	public void setIndexManager(IndexManager indexManager) {
		this.indexManager = indexManager;
	}

	public void setAttachmentManager(AttachmentManager attachmentManager) {
		this.attachmentManager = attachmentManager;
	}

	public NewsDataDao getNewsDataDao() {
		return newsDataDao;
	}
	
	public void setNewsDataDao(NewsDataDao newsDataDao) {
		this.newsDataDao = newsDataDao;
	}
	
	NewsTypeManager newsTypeManager;

	public NewsTypeManager getNewsTypeManager() {
		return newsTypeManager;
	}
	
	public void setNewsTypeManager(NewsTypeManager newsTypeManager) {
		this.newsTypeManager = newsTypeManager;
	}
	
	NewsReadManager newsReadManager;

	public NewsReadManager getNewsReadManager() {
		return newsReadManager;
	}

	public void setNewsReadManager(NewsReadManager newsReadManager) {
		this.newsReadManager = newsReadManager;
	}
	
	private NewsTypeManagersManager newsTypeManagersManager; 
	
	public void setSpaceManager(SpaceManager spaceManager) {
		this.spaceManager = spaceManager;
	}
	
	public SpaceManager getSpaceManager() {
		return spaceManager;
	}

	public void setPortletEntityPropertyManager(PortletEntityPropertyManager portletEntityPropertyManager) {
        this.portletEntityPropertyManager = portletEntityPropertyManager;
    }

    /**
     * 初始化新闻 1、初始化发起者姓名 2、初始化新闻是否存在附件标志 3、初始化新闻发布部门的中文名称
     * @param data
     */
    @Override
    public void initDataFlag(NewsData data, boolean isSpace) {
        //创建者
        User user = AppContext.getCurrentUser();
        data.setCreateUserName(this.getNewsUtils().getMemberNameByUserId(data.getCreateUser()));

        if (data.getPublishDepartmentId() == null) {
            //设置为发起者所在部门
            Long userId = data.getCreateUser();
            Long depId = this.getNewsUtils().getMemberById(userId).getOrgDepartmentId();
            data.setPublishDepartmentId(depId);
        }

        NewsType theType = this.newsTypeManager.getById(data.getTypeId());
        data.setType(theType);
        data.setCreateUserName("");
        boolean groupType = false;
        if (theType.getSpaceType().intValue() == SpaceType.group.ordinal() || theType.getSpaceType().intValue() == SpaceType.public_custom_group.ordinal() || theType.getSpaceType().intValue() == SpaceType.public_custom.ordinal() || theType.getSpaceType().intValue() == SpaceType.custom.ordinal()) {
            groupType = true;
        }
        data.setPublishDepartmentName(this.getNewsUtils().getDepartmentNameByIdOld(data.getPublishDepartmentId(), groupType, isSpace));
        String showPlushName = data.getPublishDepartmentName();
        String memberNameAndDeptName = "";
        Long pigeonholeUserId = data.getPublishUserId();
        try {
            V3xOrgMember member = null;
            V3xOrgAccount account = null;
            if (orgManager == null) {
                orgManager = (OrgManager) AppContext.getBean("orgManager");
            }
            if (pigeonholeUserId != null && orgManager.getMemberById(pigeonholeUserId) != null) {
                member = orgManager.getMemberById(pigeonholeUserId);
                if (member != null) {
                    if (user != null && user.getLoginAccount() != null && !user.getLoginAccount().equals(member.getOrgAccountId())) {
                        account = orgManager.getAccountById(member.getOrgAccountId());
                        data.setCreateUserName(account != null ? member.getName() + "(" + account.getShortName() + ")" : member.getName());
                    } else {
                        data.setCreateUserName(member.getName());
                    }
                }
            } else {
                member = orgManager.getMemberById(data.getCreateUser());
            }
            if (member != null) {
                if (user != null && user.getLoginAccount() != null && !user.getLoginAccount().equals(member.getOrgAccountId())) {
                    if (account == null) {
                        account = orgManager.getAccountById(member.getOrgAccountId());
                    }
                }
                memberNameAndDeptName = account != null ? member.getName() + "(" + account.getShortName() + ")" + "/" + data.getPublishDepartmentName() : member.getName() + "/" + data.getPublishDepartmentName();
            }
        } catch (BusinessException e) {
            log.info("获取发布人异常:" + pigeonholeUserId + e);
        }
        if (data.isShowPublishUserFlag()) {
            showPlushName = memberNameAndDeptName;
        }
        
     // SZP 客开 START
        /*
        if (showPlushName.equals("-2329940225728493295")){
        	data.setPublishDepartmentName("中国信达资产管理股份有限公司");
        	showPlushName = "中国信达资产管理股份有限公司";
        }
        */
        Map<String,String> accounts = orgManager.getAccountIdAndNames();
    	if(accounts.containsKey(showPlushName)){
    		showPlushName = accounts.get(showPlushName);
    		data.setPublishDepartmentName(showPlushName);
    	}else if (showPlushName.equals("-1010101010101010101")){
	    	data.setPublishDepartmentName("");
	    	showPlushName = "";
	    }
	    // SZP 客开 END
        
        data.setShowPublishName(showPlushName);
        data.setTypeName(data.getType().getTypeName());
        // 设置[New]标记
        if ((data.getState().intValue() == Constants.DATA_STATE_ALREADY_PUBLISH)) {
            int top = data.getType().getTopCount();
            Calendar cal = Calendar.getInstance();
            if (data.getPublishDate() != null) {
                cal.setTime(data.getPublishDate());
                cal.add(Calendar.DAY_OF_MONTH, top);
                if (((new Date()).after(cal.getTime()))) {
                    data.setTopOrder(Byte.valueOf("0"));
                } else {
                    data.setTopOrder(Byte.valueOf("1"));
                }
            }
        }

        int state = data.getState();
        //客开 start
        if (state == Constants.DATA_STATE_ALREADY_CREATE || state == Constants.DATA_STATE_TYPESETTING_CREATE) {
            data.setNoDelete(true);
            data.setNoEdit(true);
        } else if (state == Constants.DATA_STATE_ALREADY_AUDIT || state == Constants.DATA_STATE_TYPESETTING_PASS) {
            data.setNoEdit(true);
        }
         //客开end
        if (Strings.isNotBlank(data.getBrief())) {
            data.setShowBriefArea(true);
        }
        if (Strings.isNotBlank(data.getKeywords())) {
            data.setShowKeywordsArea(true);
        }

        if (data.getReadCount() == null) {
            data.setReadCount(0);
        }
        if (data.getReadFlag() == null) {
            data.setReadFlag(false);
        }
    }

	/**
	 * 初始化新闻列表
	 * @param list
	 */
	private void initList(List<NewsData> list){
		for(NewsData data:list){
			initData(data);
		}
	}
	
	/* (non-Javadoc)
	 * @see com.seeyon.v3x.news.manager.NewsDataManager#deleteReal(java.lang.Long)
	 */
	public void deleteReal(Long id) throws BusinessException{
		//删除正文
		NewsData data=this.getById(id);
		//如果是已经发布的就提示不能删除
//		if (data.getState() > Constants.DATA_STATE_ALREADY_CREATE) {
//			throw new BusinessException("news_type_delAlreadyUsed");
//		}
			
		if(com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_OFFICE_EXCEL.equals(data.getDataFormat())
				|| com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_OFFICE_WORD.equals(data.getDataFormat())	
				|| com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_WPS_WORD.equals(data.getDataFormat())
				|| com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_WPS_EXCEL.equals(data.getDataFormat())
		){				
			try {
				fileManager.deleteFile(data.getId(), data.getCreateDate(), true);
			} catch (BusinessException e) {
				log.error(e.getMessage(),e);
				throw e;
			}
		}
		
		//删除附件
		
		this.newsBodyDao.deleteByDataId(id);
		
		try {
			attachmentManager.deleteByReference(data.getId(), data.getId());
		} catch (BusinessException e) {
			log.error(e.getMessage(),e);
			throw e;
		}
		
		// 
		newsReadManager.deleteReadByData(data.getId());
		
		newsDataDao.delete(id.longValue());
	}
	
	/**
	 * 删除一个类型下的所有新闻
	 */
	public void deleteRealOfType(long typeId) throws BusinessException{
		String hql = " from NewsData where typeId = ?";
		List<NewsData> list = newsDataDao.findVarargs(hql, typeId);
		if(list != null && list.size() > 0)
			for(NewsData data : list)
				this.deleteReal(data.getId());
	}

	public void delete(Long id) {
		NewsData data=this.getById(id);
		data.setDeletedFlag(true);
		this.updateDirect(data);
	}

	public void deletes(List<Long> ids) {
		for(Long id:ids){
			delete(id);
		}
	}

	/**
	 * 得到hql
	 * hql目的：查询当前用户创建的未删除的新闻列表
	 * @return [0] " select t_data "
	 *  	   [1] " from NewsData t_data where "
	 *         [2] " state... createUser... deletedFlag... " 当前用户创建、未删除
	 *         [3] " order by t_data.createDate desc "
	 * 可以在[1][2]之间加入 " xxx... and " 
	 * 或者在[2][3]之间加入 " and xxx... "
	 * 以配合索引进行查询
	 */	
	private Object[] filterByManagerGetHql(String property,Object value) throws BusinessException{
		StringBuffer sb = new StringBuffer();
		sb.append(" select t_data2.id, t_data2.title, t_data2.publishScope, t_data2.publishDepartmentId, t_data2.dataFormat, " +
				"t_data2.createDate, t_data2.createUser, t_data2.publishDate, t_data2.publishUserId, t_data2.readCount, " +
				"t_data2.topOrder, t_data2.accountId, t_data2.typeId, t_data2.state, t_data2.attachmentsFlag, t_data2.auditUserId ");
		sb.append(" from NewsData t_data2 where t_data2.id in ( select distinct t_data.id from NewsData as t_data,"+ V3xOrgMember.class.getName() + " as m  where ");//联合人员表查询	
	
		List<NewsType> inList = this.newsTypeManager.getManagerTypeByMember( AppContext.getCurrentUser().getId(), null, null);
		HashMap<String,Object> parameterMap = new HashMap<String,Object>();
		List<Long> typeIds = new ArrayList<Long>();
        if (Strings.isEmpty(inList)) {
            typeIds.add(1l);
        } else {
            for (NewsType t : inList) {
                typeIds.add(t.getId());
            }
        }
		parameterMap.put("typeIds", typeIds);
		
		String hqlType = "";
		String hqlOther = "";
		if (StringUtils.isNotBlank(property) && value != null) {
			if (value instanceof String && Strings.isNotBlank(value.toString())){
				if ("type".equals(property)) {
					hqlType = "  t_data.typeId = :typeId and ";
					parameterMap.put("typeId", Long.parseLong(value.toString()));
				}else if("publishUserId".equals(property)){
					hqlOther = " and t_data.createUser=m.id and m.name like :name )";
					parameterMap.put("name", "%"+SQLWildcardUtil.escape(value.toString())+"%");
				} else {
					hqlOther = " and t_data." + property + " like :property )";
					parameterMap.put("property", "%"+SQLWildcardUtil.escape(value.toString())+"%");
				}
			}
			else{
				hqlOther = " and t_data." + property + " = :property )";
				parameterMap.put("property", value);
			}
		}
		sb.append(hqlType);
		sb.append(" t_data.typeId in (:typeIds) and t_data.state in (:state) and t_data.deletedFlag = false ");
		sb.append(hqlOther);
		parameterMap.put("state", Constants.getDataStatesCanManage());
		sb.append(" order by t_data2.state, t_data2.updateDate desc ");
		return new Object[]{sb.toString(),parameterMap};
	}

	@SuppressWarnings("unchecked")
	public List<NewsData> findAll() throws Exception {
		User user =  AppContext.getCurrentUser();
		if(user == null || (!user.isInternal()))
			return new ArrayList<NewsData>();

		List<NewsType> inList = this.newsTypeManager.getManagerTypeByMember( AppContext.getCurrentUser().getId(), null, null);
		List<Long> typeIds = new ArrayList<Long>();
		
		StringBuffer hqlSb = new StringBuffer(NewsUtils.SELECT_FIELDS +
			" where t_data.typeId in (:typeIds) and t_data.state in (:state) " +
			"and t_data.deletedFlag = false order by t_data.state, t_data.updateDate desc ");
			
		Map<String,Object> parameterMap = new HashMap<String,Object>();
        if (Strings.isEmpty(inList)) {
            typeIds.add(1l);
        } else {
            for (NewsType t : inList) {
                typeIds.add(t.getId());
            }
        }
		parameterMap.put("typeIds", typeIds);
		parameterMap.put("state", Constants.getDataStatesCanManage());
		List<NewsData> list = NewsUtils.objArr2News((List<Object[]>)newsDataDao.find(hqlSb.toString(), parameterMap));
		if (list != null && !list.isEmpty()) {
			newsReadManager.getReadState(list, user.getId());
		}
		initList(list);
		return list;
	}

	@SuppressWarnings("unchecked")
	public List<NewsData> findByProperty(String property, Object value) throws Exception {
		// 外部人员guolv
		User user =  AppContext.getCurrentUser();
		if(user == null || (!user.isInternal()))
			return new ArrayList<NewsData>();		
		Object[] hqlArr = this.filterByManagerGetHql(property, value);
		List<NewsData> list = newsDataDao.find(hqlArr[0].toString(), (HashMap)hqlArr[1],new ArrayList());
		initList(list);
		return list;
	}

	public NewsData getById(Long id) {
		 NewsData data=newsDataDao.get(id);
		if(data==null){
			return data;
		}else{
			initData(data);		
			return data;
		}
	}
	
	/**
	 * 判斷某條數據是否存在
	 */
	public boolean dataExist(Long bulId){
		NewsData data = this.getById(bulId);
		if(data == null)
			return false;
		else
			return true;
	}
	
	public NewsData getById(Long id,Long userId) {
		NewsData data=newsDataDao.get(id);
		if(data!=null){
			initData(data);		
		}
		return data;
	}

	public NewsData save(NewsData data, boolean isNew) {
        if (data.getTypeId() != null) {
            NewsType type = newsTypeManager.getById(data.getTypeId());
            data.setType(type);
            if (type != null) {
                data.setSpaceType(type.getSpaceType());
                data.setAccountId(type.getAccountId());
            }
        }
        if (isNew) {
            newsDataDao.save(data);
        } else {
            newsDataDao.update(data);
        }
        this.saveBody(data, isNew);
        return data;
	}
	
	public NewsData saveCustomNews(NewsData data, boolean isNew) {
		if(data.getTypeId()!=null)
			data.setType(newsTypeManager.getById(data.getTypeId()));
		if(isNew){
			newsDataDao.save(data);
		}else{
			newsDataDao.update(data);
		}
		this.saveBody(data, isNew);
		return data;
	}
	
	public void saveBody(NewsData data, boolean isNew){
		NewsBody body = new NewsBody();
		body.setBodyType(data.getDataFormat());
		body.setId(data.getId());
		body.setContent(data.getContent());
		body.setCreateDate(data.getCreateDate());
		if(isNew){
			this.newsBodyDao.save(body);
		}else{
			this.newsBodyDao.update(body);
		}
	}
	
	public void updateDirect(NewsData data){
		newsDataDao.update(data);
	}
	
	public int readOneTime(long dataId){
		String hql = "update NewsData set readCount = readCount + 1 where id = :nid";
		Map<String, Object> amap = new HashMap<String, Object>();
		amap.put("nid", dataId);
		this.newsDataDao.bulkUpdate(hql, amap);
		
		String hql2 = "select readCount from NewsData where id = ?";
		List list = this.newsDataDao.findVarargs(hql2, dataId);
        if (Strings.isEmpty(list)) {
            return 1;
        } else {
            return (Integer) (list.get(0));
        }
	}
	
	public void update(Long Id, Map<String, Object> columns) {
		try{
			newsDataDao.update(Id, columns);
		}catch(Exception e){
			log.error(e.getMessage(),e);
		}
		
	}
	
	public List<NewsType> getTypeList(Long managerUserId, int spaceType, long spaceId) throws Exception {
		List<NewsType> list = new ArrayList<NewsType>();
		if (spaceType == SpaceType.public_custom.ordinal()) {
			list = this.newsTypeManager.getManagerTypeByMember(managerUserId, SpaceType.public_custom, spaceId);
		} else {
			list = this.newsTypeManager.getManagerTypeByMember(managerUserId, SpaceType.public_custom_group, spaceId);
		}
		this.newsTypeManager.setTotalItemsOfType(list);
		return list;
	}
	
	public List<NewsType> getTypeList(Long managerUserId,boolean isIgnoreUsed,long loginAccount) throws Exception{
		List<NewsType> list=this.newsTypeManager.getManagerTypeByMember(managerUserId,
				SpaceType.corporation, loginAccount);//new ArrayList<NewsType>();
		this.newsTypeManager.setTotalItemsOfType(list);
		return list;
	}
	
	public List<NewsType> getTypeListOnlyByMember(Long managerUserId,boolean isIgnoreUsed) throws Exception{
		List<NewsType> list=this.newsTypeManager.getManagerTypeByMember(managerUserId,  SpaceType.corporation, null);
		return list;
	}
	/**
	 * 取得有我来管理的集团新闻板块
	 */
	public List<NewsType> getManagerGroupBulType(Long managerUserId, boolean isIgnoreUsed) throws Exception {		
		List<NewsType> list=this.newsTypeManager.getManagerTypeByMember(managerUserId, SpaceType.group, null);
		this.newsTypeManager.setTotalItemsOfType(list);
		return list;
	}
	
	public List<NewsType> getTypeListByWrite(Long writeId,boolean isIgnoreUsed){
		return this.newsTypeManager.getWriterTypeByMember(writeId, null, null);
	}

	public List<NewsData> getAuditList(Long userId,String property,Object value,long loginAccount) throws BusinessException{
		User user =  AppContext.getCurrentUser();
		if(user == null || (!user.isInternal()))
			return new ArrayList<NewsData>();
		DetachedCriteria dc=DetachedCriteria.forClass(NewsData.class);		
		dc.add(Restrictions.in("state", new Integer[]{Constants.DATA_STATE_ALREADY_CREATE,Constants.DATA_STATE_ALREADY_AUDIT}));
		if(StringUtils.isNotBlank(property) && value!=null){
			if("type".equals(property)){
				Long typeId = Long.valueOf(value.toString());
				dc.add(Restrictions.eq("typeId", typeId ));
			}else{				
				dc.add(Restrictions.eq(property, value));				
				List<NewsType> typeList=this.newsTypeManager.findByPropertyNoPaging("auditUser", userId,loginAccount);
				if(typeList.size()==0) 
					throw new BusinessException("news_no_purview");					
				dc.add(Restrictions.in("typeId", this.getIdSet(typeList)));
			}
		}else{
			List<NewsType> typeList=this.newsTypeManager.findByPropertyNoPaging("auditUser", userId,loginAccount);
			if(typeList.size()==0) 
				throw new BusinessException("news_no_purview");				
			dc.add(Restrictions.in("typeId", this.getIdSet(typeList)));
		}
		
		dc.addOrder(Order.desc("createDate"));		
		List<NewsData> list=this.newsDataDao.executeCriteria(dc);		
		initList(list);
		return list;
	}
	
	/**
	 * 点击板块管理后,再点击新闻审核后所看到的列表
	 */
	public List<NewsData> getAuditDataListNew(Long userId,String property,Object value, int spaceType) throws BusinessException{
		List<NewsType> auditTypeList = this.newsTypeManager.getAuditTypeByMember(userId, 
				Constants.valueOfSpaceType(spaceType), null);
		if(Strings.isEmpty(auditTypeList)){
		    return Collections.EMPTY_LIST;
		}
		List<NewsData> list=newsDataDao.getAuditDataListNewDAO(userId, property, value,auditTypeList);
		initList(list);
		return list;
	}
	
	/**
     * 点击板块管理后,再点击新闻审核后所看到的列表,2012-11-5 yangwulin 根据当前的板块查询当前板块需要审核的新闻。
     * @param userId 用户Id
     * @param property 查询类型
     * @param value   查询值
     * @param newsTypeId 当前板块的Id
     * @return
     * @throws BusinessException
     */
    public List<NewsData> getAuditDataListNew(Long userId,String property,Object value,int spaceType,String newsTypeId) throws BusinessException{
        List<NewsData> list=newsDataDao.getAuditDataListNewInfo(userId, property, value,newsTypeId);
        initList(list);
        return list;
    }
	
	public NewsTypeManagersManager getNewsTypeManagersManager() {
		return newsTypeManagersManager;
	}

	public void setNewsTypeManagersManager(
			NewsTypeManagersManager newsTypeManagersManager) {
		this.newsTypeManagersManager = newsTypeManagersManager;
	}
	
	/**
	 * 得到hql
	 * hql目的：查询当前用户可以看到的所有已发布、未删除的公告
	 * @return [0] " select t_data "
	 *  	   [1] " from NewsData t_data where "
	 *         [2] " state... deletedFlag... " 已发布的，未删除的 条件过滤
	 *         [3] " order by t_data.topOrder desc, t_data.publishDate desc "
	 * 可以在[1][2]之间加入 " xxx... and " 
	 * 或者在[2][3]之间加入 " and xxx... "
	 * 以配合索引进行查询
	 */	
	private DetachedCriteria filterByReadGetHql(){
		DetachedCriteria criteria = DetachedCriteria.forClass(NewsData.class);
		criteria.add(Restrictions.eq("state", Constants.DATA_STATE_ALREADY_PUBLISH));
		criteria.add(Restrictions.eq("deletedFlag", false));
		criteria.addOrder(Order.desc("publishDate"));		
		return criteria;
	}

	public List<NewsData> findByReadUserContent(long id, List<NewsType> typeList,long loginAccount, Integer imageOrFocus) throws DataAccessException, BusinessException {
		List<NewsData> list;
		
		//集团化处理，排除部门新闻
		if(typeList == null)
			typeList=getNewsTypeManager().findAll(loginAccount);
		List<NewsType> inList=new ArrayList<NewsType>();
		for(NewsType type:typeList){
			if( type.getSpaceType().intValue() == 2 || type.getSpaceType().intValue() == 4
					|| type.getSpaceType().intValue() == 17 || type.getSpaceType().intValue() == 18){
				inList.add(type);
			}
		}
    	list = newsDataDao.findByReadUserDAO(id, inList, imageOrFocus);
        List<NewsData> resultBulDatas=new ArrayList<NewsData>();
        for(NewsData bdInfo:list){
        	bdInfo.setContent(getBody(bdInfo.getId()).getContent());
        	resultBulDatas.add(bdInfo);
        }
		initList(resultBulDatas);
		return resultBulDatas;
	}
	
	public Map<Long, List<NewsData>> findByReadUserHome_(long id, List<NewsType> typeList) throws DataAccessException,
			BusinessException {
		List<NewsData> list = new ArrayList<NewsData>();		
		List<NewsType> inList = typeList;		
		List<Long> types = new ArrayList<Long>();
		if (inList == null || inList.isEmpty()) {
			return new HashMap<Long, List<NewsData>>();
		}else{
			for(NewsType t : inList){
				types.add(t.getId());
			}
		}
		DetachedCriteria criteria = this.filterByReadGetHql();		
		criteria.add(Restrictions.in("typeId", types));
		final int count = Constants.NEWS_HOMEPAGE_TABLE_COLUMNS;
		final int getCounts = count * typeList.size();// * 3;
		long start = System.currentTimeMillis();
		int dbConnTime = 1;
		list = newsDataDao.executeCriteria(criteria,0,getCounts);		
		
		Map<Long, List<NewsData>> amap = new HashMap<Long, List<NewsData>>();

		for(NewsType bt : typeList){
			List<NewsData> alist = new ArrayList<NewsData>();
			amap.put(bt.getId(), alist);

		}
		for(NewsData bd : list){
			List<NewsData> alist = amap.get(bd.getTypeId());
			if(alist == null)
				alist = new ArrayList<NewsData>();
			if(alist.size() >= count)
				continue;
			alist.add(bd);
		}
		
		List<NewsType> typeList2 = new ArrayList<NewsType>();
		for(NewsType t : typeList){
			int size = amap.get(t.getId()).size();
			if(size < count)
				typeList2.add(t);
		}
		if(typeList2.size() > 0){
			this.getNewsTypeManager().setTotalItemsOfType(typeList2);
			List<NewsType> typeList3 = new ArrayList<NewsType>();
			for(NewsType t2 : typeList2){
				int asize = amap.get(t2.getId()).size();
				if(asize < t2.getTotalItems()){
					typeList3.add(t2);
				}
			}
			if(typeList3.size() > 0){
				//
				List<Long> types2 = new ArrayList<Long> ();
				//String typeStr2 = "";
				for(NewsType t : typeList3){
					types2.add(t.getId());
					amap.put(t.getId(), new ArrayList<NewsData>());
				}			
				criteria.add(Restrictions.in("typeId", types2));
				list = newsDataDao.executeCriteria(criteria,0,getCounts);
				dbConnTime++;
				for(NewsData bd : list){
					List<NewsData> alist = amap.get(bd.getTypeId());
					if(alist == null)
						alist = new ArrayList<NewsData>();
					if(alist.size() >= count)
						continue;
					alist.add(bd);
				}
				for(;;){				
					List<NewsType> typeList22 = new ArrayList<NewsType>();
					for(NewsType t : typeList){
						int size = amap.get(t.getId()).size();
						if(size < count)
							typeList22.add(t);
					}
					if(typeList22.isEmpty())
						break;
					List<NewsType> typeList32 = new ArrayList<NewsType>();
					for(NewsType t2 : typeList22){
						int asize = amap.get(t2.getId()).size();
						if(asize < t2.getTotalItems()){
							typeList32.add(t2);
						}
					}
					if(typeList32.isEmpty())
						break;					
					
					
					List<Long> types3 = new ArrayList<Long> ();
					for(NewsType t : typeList32){
						types3.add(t.getId());
						
						amap.put(t.getId(), new ArrayList<NewsData>());
					}			
					criteria.add(Restrictions.in("typeId", types3));
					list = newsDataDao.executeCriteria(criteria,0,getCounts);
					dbConnTime++;
					
					for(NewsData bd : list){
						List<NewsData> alist = amap.get(bd.getTypeId());
						if(alist == null)
							alist = new ArrayList<NewsData>();
						if(alist.size() >= count)
							continue;
						alist.add(bd);
					}		
				}
			}
				
		}
			
		log.info("非遍历版块算法时间：" + (System.currentTimeMillis() - start) + "   数据库连接：" + dbConnTime);
		for(NewsType btt : typeList){
			initList(amap.get(btt.getId()));
		}		
		return amap;
	}
	
	//进入新闻首页要先查出所有的新闻的类型,然后查出每个新闻类型里面所有的新闻
	public Map<Long, List<NewsData>> findByReadUserHome(long id, List<NewsType> typeList) throws DataAccessException,
			BusinessException {
		Map<Long, List<NewsData>> amap = newsDataDao.findByReadUserHomeDAO(id, typeList);
		for(NewsType btt : typeList){
			initList(amap.get(btt.getId()));
		}
		return amap;
	}
	
	//集团,集团页面点击更多,查询出所有类型的新闻
	public List<NewsData> groupFindByReadUser(long id, List<NewsType> typeList, Integer imageOrFocus) throws DataAccessException, BusinessException {
		List<NewsData> list = newsDataDao.findByReadUserDAO(id, typeList, imageOrFocus);
		initList(list);			
		return list;
	}
	
	@SuppressWarnings("unchecked")
	private List<NewsData> findByReadUser(Long userId, long loginAccount,boolean isInternal, Integer imageOrFocus, int spaceType, List<Long> typeIds) throws DataAccessException, BusinessException {
		List<NewsType> typeList = new ArrayList<NewsType>();
		if(spaceType == SpaceType.group.ordinal()){
			typeList.addAll(getNewsTypeManager().groupFindAll());
		} else if(spaceType == SpaceType.corporation.ordinal()) {
			typeList.addAll(getNewsTypeManager().findAll(loginAccount));
		} else if (spaceType == SpaceType.custom.ordinal()) {
			typeList.addAll(getNewsTypeManager().findAllOfCustom(loginAccount, "custom"));
		} else if (spaceType == SpaceType.public_custom.ordinal()) {
			typeList.addAll(getNewsTypeManager().findAllOfCustom(loginAccount, "publicCustom"));
		} else if (spaceType == SpaceType.public_custom_group.ordinal()) {
			typeList.addAll(getNewsTypeManager().findAllOfCustom(loginAccount, "publicCustomGroup"));
		}
		
		List<NewsType> inList = typeList;
		if (typeList == null || typeList.isEmpty()) {
			return new ArrayList<NewsData>();
		} else if (!isInternal) {
			inList = new ArrayList<NewsType>();
			for (NewsType t : typeList) {
				if (t.getOutterPermit()) {
					inList.add(t);
				}
			}
		}
		List<Long> types = new ArrayList<Long>();
		if (inList == null || inList.isEmpty()) {
			return new ArrayList<NewsData>();
		} else {
			for (NewsType t : inList) {
				if (typeIds != null) {
					if (typeIds.contains(t.getId())) {
						types.add(t.getId());
					}
				} else {
					types.add(t.getId());
				}
			}
		}
		
		//新闻左外联新闻阅读信息表
		StringBuilder hql = new StringBuilder();
		hql.append(NewsUtils.SELECT_FIELDS + " where t_data.state=:state and t_data.deletedFlag=false ");
		if(imageOrFocus != null){
			if(imageOrFocus.intValue() == Constants.ImageNews){
				hql.append(" and t_data.imageNews=true ");
			} else {
				hql.append(" and t_data.focusNews=true ");
			}
		}
		hql.append(" and t_data.typeId in (:types) order by t_data.publishDate desc");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("state", Constants.DATA_STATE_ALREADY_PUBLISH);
		params.put("types", types);
		List<NewsData> list = NewsUtils.objArr2News((List<Object[]>)newsDataDao.find(hql.toString(), params));
		if (list != null && !list.isEmpty()) {
			newsReadManager.getReadState(list, userId);
		}
		initList(list);
		return list;
	}
	
	public List<NewsData> findByReadUser4ImageNews(User user, Integer imageOrFocus, int spaceType, List<Long> typeIds) throws DataAccessException, BusinessException {
		return findByReadUser(user.getId(), user.getLoginAccount(), user.isInternal(), imageOrFocus, spaceType, typeIds);
	}
	
	//图片新闻栏目或焦点新闻栏目
	public List<NewsData> findByReadUser4ImageNews(Long userId, long loginAccount,boolean isInternal, Integer imageOrFocus, int spaceType)
			throws DataAccessException, BusinessException {
		return findByReadUser(userId, loginAccount, isInternal, imageOrFocus, spaceType, null);
	}
	
	public List<NewsData> findByReadUserForIndex(Long userId, long loginAccount, boolean isInternal) throws DataAccessException, BusinessException {
		return this.findByReadUserForIndex(userId, loginAccount, isInternal, null);
	}

	@SuppressWarnings("unchecked")
	public List<NewsData> findByReadUserForIndex(Long userId, long loginAccount, boolean isInternal, List<Long> typeIds) throws DataAccessException, BusinessException {
		List<NewsType> typeList = this.newsTypeManager.findAll(loginAccount);
		List<NewsType> inList = typeList;
		if (typeList == null || typeList.isEmpty()) {
			return new ArrayList<NewsData>();
		} else if (!isInternal) {
			inList = new ArrayList<NewsType>();
			for (NewsType t : typeList) {
				if (t.getOutterPermit()) {
					inList.add(t);
				}
			}
		}

		List<Long> types = new ArrayList<Long>();
		if (inList == null || inList.isEmpty()) {
			return new ArrayList<NewsData>();
		} else {
			for (NewsType t : inList) {
				if (typeIds != null) {
					if (typeIds.contains(t.getId())) {
						types.add(t.getId());
					}
				} else {
					types.add(t.getId());
				}
			}
		}

		// 新闻左外联新闻阅读信息表
		StringBuffer hql = new StringBuffer();
		Map<String, Object> params = new HashMap<String, Object>();
		hql.append(NewsUtils.SELECT_FIELDS + " where t_data.state=:state and t_data.deletedFlag=false ");
		if (types.size() > 0) {
		    hql.append( " and t_data.typeId in (:types) order by t_data.publishDate desc");
		    params.put("types", types);
		} else {
		    hql.append( " order by t_data.publishDate desc");
		}
		params.put("state", Constants.DATA_STATE_ALREADY_PUBLISH);
		List<NewsData> list = NewsUtils.objArr2News((List<Object[]>) newsDataDao.find(hql.toString(), params));
		if (list != null && !list.isEmpty()) {
			newsReadManager.getReadState(list, userId);
		}
		initList(list);
		return list;
	}
	
	/**
     * 查找已读/未读/全部(新闻和公告)的总数  --微协同
     * @param userId 当前用户
     * @param countFlag【all,notRead,read】
     * @return
	 * @throws BusinessException 
     */
    public int findByReadUserForWechat(long userId, String countFlag) throws BusinessException {
        long accountId = orgManager.getMemberById(userId).getOrgAccountId();
        Map<String, Object> params = new HashMap<String, Object>();
        StringBuffer hql = new StringBuffer();
        hql.append(" from NewsData as news where ");
        hql.append(" news.state=:state and news.deletedFlag=false ");
        hql.append(" and news.typeId in (:typeIds) ");
        List<Long> typeIds = newsTypeManager.getCanSeeBoard(AppContext.getCurrentUser());
        if ("notRead".equals(countFlag)) {
            hql.append("and not exists");
            hql.append("(select reads.id from ").append(NewsRead.class.getName());
            hql.append(" as reads where reads.managerId=:currentUserId");
            hql.append(" and reads.newsId = news.id) ");
            params.put("currentUserId", userId);
        } else if ("read".equals(countFlag)) {
            hql.append("and exists");
            hql.append("(select reads.id from ").append(NewsRead.class.getName());
            hql.append(" as reads where reads.managerId=:currentUserId");
            hql.append(" and reads.newsId = news.id) ");
            params.put("currentUserId", userId);
        }
        params.put("typeIds", typeIds);
        params.put("state", Constants.DATA_STATE_ALREADY_PUBLISH);
        return DBAgent.count(hql.toString(), params);
    }
	
	@SuppressWarnings("unchecked")
    public List<NewsData> findNewsByUserId(Long userId, int firstNum, int pageSize) {
        // 新闻左外联新闻阅读信息表
        StringBuffer hql = new StringBuffer();
        Map<String, Object> params = new HashMap<String, Object>();
        hql.append(NewsUtils.SELECT_FIELDS + " where t_data.state=:state and t_data.deletedFlag=false ");
        hql.append( " and t_data.accountId=:accountId ");
        hql.append( " order by t_data.publishDate desc");
        try {
			params.put("accountId", orgManager.getMemberById(userId).getOrgAccountId());
		} catch (BusinessException e) {
			log.error("",e);
		}
        params.put("state", Constants.DATA_STATE_ALREADY_PUBLISH);
        if (pageSize != -1) {
            Pagination.setNeedCount(false);
            Pagination.setFirstResult(firstNum);
            Pagination.setMaxResults(pageSize);
        }
        List<NewsData> list = NewsUtils.objArr2News((List<Object[]>) newsDataDao.find(hql.toString(), params));
		if (list != null && !list.isEmpty()) {
			newsReadManager.getReadState(list, userId);
		}
        initList(list); 
        return list;
    }
	
	/**
	 * 获取当前人员所有的新闻
	 * M1调用
	 */
	@SuppressWarnings("unchecked")
    public List<NewsData> findNewsByUserIdNew(Long userId, Long loginAccount,List<NewsType> typeList1,boolean isInternal) {
		List<NewsType> typeList = this.newsTypeManager.findAll(loginAccount);
		List<NewsType> typeList2 = this.newsTypeManager.groupFindAll();
		if(typeList1 != null && !typeList1.isEmpty()){
			typeList.addAll(typeList1);
		}
		if(typeList2 != null && !typeList2.isEmpty()){
			typeList.addAll(typeList2);
		}
		List<NewsType> inList = typeList;
		if (typeList == null || typeList.isEmpty()) {
			return new ArrayList<NewsData>();
		} else if (!isInternal) {
			inList = new ArrayList<NewsType>();
			for (NewsType t : typeList) {
				if (t.getOutterPermit()) {
					inList.add(t);
				}
			}
		}

		List<Long> types = new ArrayList<Long>();
		if (inList == null || inList.isEmpty()) {
			return new ArrayList<NewsData>();
		} else {
			for (NewsType t : inList) {
				types.add(t.getId());
			}
		}

        // 新闻左外联新闻阅读信息表
        StringBuffer hql = new StringBuffer();
        Map<String, Object> params = new HashMap<String, Object>();
        hql.append(NewsUtils.SELECT_FIELDS + " where t_data.state=:state and t_data.deletedFlag=false ");
        if (types.size() > 0) {
		    hql.append( " and t_data.typeId in (:types) order by t_data.publishDate desc");
		    params.put("types", types);
		} else {
		    hql.append( " order by t_data.publishDate desc");
		}
        params.put("state", Constants.DATA_STATE_ALREADY_PUBLISH);
       
        List<NewsData> list = NewsUtils.objArr2News((List<Object[]>) newsDataDao.find(hql.toString(), params));
		if (list != null && !list.isEmpty()) {
			newsReadManager.getReadState(list, userId);
		}
        initList(list);
        return list;
    }
	
	public List<NewsData> findCustomByReadUserForIndex(Long userId, long loginAccount, int spaceType, boolean isInternal) throws DataAccessException, BusinessException {
		List<NewsType> typeList = this.newsTypeManager.findAllOfCustomAcc(loginAccount, spaceType);
		List<NewsType> inList=typeList;
		if(typeList == null)
			return new ArrayList<NewsData>();
		else if(!isInternal){
			inList = new ArrayList<NewsType>();
			for(NewsType t : typeList){
				if(t.getOutterPermit())
					inList.add(t);
			}
		}

		List<Long> types = new ArrayList<Long>();
		if (inList == null || inList.isEmpty()) {
			return new ArrayList<NewsData>();
		}else{
			for(NewsType t : inList){
				types.add(t.getId());
			}
		}
		
		//新闻左外联新闻阅读信息表
		String hql = NewsUtils.SELECT_FIELDS + " where t_data.state=:state and t_data.deletedFlag=false" +
					 " and t_data.typeId in (:types) order by t_data.publishDate desc";
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("state", Constants.DATA_STATE_ALREADY_PUBLISH);
		params.put("types", types);
		List<NewsData> list = NewsUtils.objArr2News((List<Object[]>)newsDataDao.find(hql, params));
		if (list != null && !list.isEmpty()) {
			newsReadManager.getReadState(list, userId);
		}
		initList(list);			
		return list;		
	}
	
	public List<NewsData> groupFindByReadUserForIndex(long id, boolean isInternal) throws DataAccessException, BusinessException {
		return this.groupFindByReadUserForIndex(id, isInternal, null);
	}

	@SuppressWarnings("unchecked")
	public List<NewsData> groupFindByReadUserForIndex(long id, boolean isInternal, List<Long> typeIds) throws DataAccessException, BusinessException {
		if (!isInternal) {
			return new ArrayList<NewsData>();
		}

		List<NewsType> typeList = this.newsTypeManager.groupFindAll();
		List<Long> types = new ArrayList<Long>();
		if (typeList == null || typeList.isEmpty()) {
			return new ArrayList<NewsData>();
		} else {
			for (NewsType t : typeList) {
				if (typeIds != null) {
					if (typeIds.contains(t.getId())) {
						types.add(t.getId());
					}
				} else {
					types.add(t.getId());
				}
			}
		}
		
		// 新闻左外联新闻阅读信息表
		String hql = NewsUtils.SELECT_FIELDS + " where t_data.state=:state and t_data.deletedFlag=false "
				+ " and t_data.typeId in (:types) order by t_data.publishDate desc";
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("state", Constants.DATA_STATE_ALREADY_PUBLISH);
		params.put("types", types);
		List<NewsData> list = NewsUtils.objArr2News((List<Object[]>) newsDataDao.find(hql, params));
		if (list != null && !list.isEmpty()) {
			newsReadManager.getReadState(list, id);
		}
		initList(list);
		return list;
	}
	
	@SuppressWarnings("unchecked")
	public List<NewsData> findByReadUser(long id,String property,Object value, Object value1, List<NewsType> typeList,long loginAccount) throws Exception {
		List<NewsType> inList = new ArrayList<NewsType>();
		if(typeList == null)
			typeList = getNewsTypeManager().findAll(loginAccount);
		//property,是属性,value是字段		
		//集团化处理，排除部门公告
		//把单位新闻的类型加到列表里面
		for (NewsType type : typeList) {
			if (type.getSpaceType().intValue() == 2 || type.getSpaceType().intValue() == 4) {
				inList.add(type);
			}
		}
		List<NewsData> list=newsDataDao.findByReadUserDAO(id, property, value, value1, inList);			
		initList(list);
		return list;
	}
	
	public List<NewsData> findByReadUser(long id, String property, Object value, Object value1, List<NewsType> typeList,long loginAccount, String spaceType) throws Exception {
		List<NewsType> inList = new ArrayList<NewsType>();
		if(typeList == null)
			typeList = getNewsTypeManager().findAllOfCustom(loginAccount, spaceType);
		//property,是属性,value是字段		
		for (NewsType type : typeList) {
			if (type.getSpaceType().intValue() == 4 || type.getSpaceType().intValue() == 17 || type.getSpaceType().intValue() == 18) {
				inList.add(type);
			}
		}
		List<NewsData> list=newsDataDao.findByReadUserDAO(id, property, value, value1, inList);			
		initList(list);
		return list;
	}
	
	public List<NewsData> findByReadUser4Mobile(long id,String property,Object value,long loginAccount) throws DataAccessException, BusinessException {
		// 外部人员guolv
		User user =  AppContext.getCurrentUser();
		if(user == null || (!user.isInternal()))
			return new ArrayList<NewsData>();
		
		List<NewsData> list;

		DetachedCriteria criteria = DetachedCriteria.forClass(NewsData.class);
		criteria.add(Restrictions.eq("state", Constants.DATA_STATE_ALREADY_PUBLISH));
		criteria.add(Restrictions.eq("deletedFlag", false));
		criteria.addOrder(Order.desc("publishDate"));
		List<NewsType> inList = getNewsTypeManager().findAll(loginAccount);
		if(inList == null)
			inList = new ArrayList<NewsType>();
		List<NewsType> types2 = getNewsTypeManager().groupFindAll();
		if(types2 != null)
			inList.addAll(types2);
		
		List<Long> types = new ArrayList<Long>();
		if (inList == null || inList.isEmpty()) {
			return new ArrayList<NewsData>();
		}else{
			for(NewsType t : inList){
				types.add(t.getId());
			}
		}
		criteria.add(Restrictions.in("typeId", types));
		if(value != null && Strings.isNotBlank(value.toString())){
			criteria.add(Restrictions.like(property, "%"+SQLWildcardUtil.escape(value.toString())+"%"));
		}
		list = newsDataDao.executeCriteria(criteria);				
		initList(list);
		return list;
	}
	/**
	 * 此方法作为备用,将来要可能会删除,
	 * hql 优化 dongyj
	 */
	public List<NewsData> findByReadUser4Mobile(long id,String property,Object value) throws DataAccessException, BusinessException {
		// 外部人员guolv
		User user =  AppContext.getCurrentUser();
		if(user == null || (!user.isInternal()))
			return new ArrayList<NewsData>();
		
		List<NewsData> list;		
		DetachedCriteria criteria = this.filterByReadGetHql();		
		List<NewsType> inList = getNewsTypeManager().findAll();
		if(inList == null)
			inList = new ArrayList<NewsType>();
		List<NewsType> types2 = getNewsTypeManager().groupFindAll();
		if(types2 != null)
			inList.addAll(types2);
		
		List<Long> types = new ArrayList<Long>();
		if (inList == null || inList.isEmpty()) {
			return new ArrayList<NewsData>();
		}else{
			for(NewsType t : inList){
				types.add(t.getId());
			}
		}
		criteria.add(Restrictions.in("typeId", types));
		if(value != null && Strings.isNotBlank(value.toString())){
			criteria.add(Restrictions.like(property, "%"+SQLWildcardUtil.escape(value.toString())+"%"));
		}
		list = newsDataDao.executeCriteria(criteria);				
		initList(list);
		return list;		
	}
	
	//在单位新闻列表页面右上角的查询功能
	@SuppressWarnings("unchecked")
	public List<NewsData> groupFindByReadUser(long id,String property,Object value,Object value1,List<NewsType> typeList) throws Exception {
		List<NewsType> inList=new ArrayList<NewsType>();
		if(typeList != null)
		{
			for(NewsType type:typeList){
				if(type.getSpaceType().intValue()==3 ){
					inList.add(type);
				}
			}
		}
		List list=newsDataDao.findByReadUserDAO(id, property, value,value1, inList);
		initList(list);
		return list;
	}

	/**
	 * 得到hql
	 * hql目的：查询当前用户创建的未删除的新闻列表
	 * @return [0] " select t_data "
	 *  	   [1] " from NewsData t_data where "
	 *         [2] " state... createUser... deletedFlag... " 当前用户创建、未删除
	 *         [3] " order by t_data.createDate desc "
	 * 可以在[1][2]之间加入 " xxx... and " 
	 * 或者在[2][3]之间加入 " and xxx... "
	 * 以配合索引进行查询
	 */	
	private DetachedCriteria filterByWriteGetHql(){
		Set<Integer> sset = Constants.getDataStatesNoPublish();
		DetachedCriteria criteria = DetachedCriteria.forClass(NewsData.class);
		criteria.add(Restrictions.in("state", sset));
		criteria.add(Restrictions.eq("createUser",  AppContext.getCurrentUser().getId()));
		criteria.add(Restrictions.eq("deletedFlag", false));
		criteria.addOrder(Order.desc("createDate"));
		
		
		return criteria;
	}

	/**
	 * 得到hql
	 * hql目的：查询当前用户创建的未删除的新闻列表
	 * @return [0] " select t_data "
	 *  	   [1] " from NewsData t_data where "
	 *         [2] " state... createUser... deletedFlag... " 当前用户创建、未删除
	 *         [3] " order by t_data.createDate desc "
	 * 可以在[1][2]之间加入 " xxx... and " 
	 * 或者在[2][3]之间加入 " and xxx... "
	 * 以配合索引进行查询
	 */	
	private DetachedCriteria filterByWriteGetHql(String property,Object value) throws BusinessException{
		Set<Integer> sset = Constants.getDataStatesNoPublish();
		
		DetachedCriteria criteria = DetachedCriteria.forClass(NewsData.class);
		criteria.add(Restrictions.in("state", sset));
		criteria.add(Restrictions.eq("createrUser",  AppContext.getCurrentUser().getId()));
		criteria.add(Restrictions.eq("deletedFlag", false));
		criteria.addOrder(Order.desc("createDate"));

		if (StringUtils.isNotBlank(property) && value != null) {
			if (value instanceof String && Strings.isNotBlank(value.toString()))
				if ("type".equals(property)) {
					criteria.add(Restrictions.eq("typeId", Long.parseLong(value.toString())));
				} else {
					criteria.add(Restrictions.like(property, "%"+SQLWildcardUtil.escape(value.toString())+"%"));
				}
			else{
				criteria.add(Restrictions.eq(property, value));
			}
		}		
		return criteria;
	}
	
	@SuppressWarnings("unchecked")
	public List<NewsData> findWriteAll() throws BusinessException {
		// 外部人员guolv
		User user =  AppContext.getCurrentUser();
		if(user == null || (!user.isInternal()))
			return new ArrayList<NewsData>();
		//hql 优化
		DetachedCriteria criteria = this.filterByWriteGetHql();
		List<NewsData> list = newsDataDao.executeCriteria(criteria);
		initList(list);
		return list;
	}

	@SuppressWarnings("unchecked")
	public List<NewsData> findWriteByProperty(String property, Object value) throws BusinessException {
		// 外部人员guolv
		User user =  AppContext.getCurrentUser();
		if(user == null || (!user.isInternal()))
			return new ArrayList<NewsData>();
		DetachedCriteria criteria = this.filterByWriteGetHql(property,value);
		List<NewsData> list = newsDataDao.executeCriteria(criteria);
		initList(list);
		return list;
	}
	
	@SuppressWarnings("static-access")
	public List<NewsRead> getReadListByData(NewsData data,Long userId) throws Exception{
		List<NewsRead> readList=null;
		
		boolean isManager = false;
		if(userId.longValue() == data.getCreateUser().longValue()
				|| userId.longValue() == data.getPublishUserId().longValue()
				|| userId.longValue() == data.getType().getAuditUser().longValue())
			isManager = true;
		else
			isManager = this.newsTypeManager.isManagerOfType(data.getTypeId(), userId);
		
		if(isManager){
			readList=this.getNewsReadManager().getReadListByData(data.getId());
			for(NewsRead read:readList){
				if(read.getManagerId()!=null){
					read.setManagerName(this.getNewsUtils().getMemberNameByUserId(read.getManagerId()));
				}
			}
		}
		
		return readList;
	}
	
	public List statistics(String type ,final long newsTypeId) {
		List list = new ArrayList();
		
		if ("byRead".equals(type)) {
			List<Object> parameter = new ArrayList<Object>();
			parameter.add(Constants.DATA_STATE_ALREADY_PUBLISH );
		    parameter.add(Constants.DATA_STATE_ALREADY_PIGEONHOLE);
		    parameter.add(newsTypeId);
		    
			String hqlCount = "select news_data.typeId,news_type.typeName,news_data.id,news_data.title,news_data.publishUserId,org_member.name,news_data.readCount from NewsData news_data, NewsType news_type, OrgMember org_member ";
				hqlCount += "where news_data.typeId=news_type.id  and   (news_data.state=? or news_data.state=?) ";
				hqlCount += "and news_data.publishUserId=org_member.id ";
				hqlCount += " and news_data.deletedFlag = false ";
				hqlCount += " and news_type.id = ? ";
				hqlCount += "order by read_count desc";
			list = newsDataDao.find(hqlCount,null, parameter);
			
			List<Object[]> arrs = (List<Object[]>)list;
			List<Object[]> todeal = new ArrayList<Object[]>();
			List<Object[]> keep = new ArrayList<Object[]>();
			for(Object[] objs : arrs){
				if(objs[6] == null)
					todeal.add(objs);
				else
					keep.add(objs);
			}
			for(Object[] objs : todeal){
				objs[6] = Integer.valueOf(0);
			}
			keep.addAll(keep.size(), todeal);
			
			return keep;
		} else if ("byWrite".equals(type)) {
			List<Object> parameter = new ArrayList<Object>();
			parameter.add(Constants.DATA_STATE_ALREADY_PUBLISH );
		    parameter.add(Constants.DATA_STATE_ALREADY_PIGEONHOLE);
		    parameter.add(newsTypeId);
			String sql = "select news_data.publishUserId from NewsData news_data where (news_data.state=? or  news_data.state=? ) and news_data.deletedFlag = false ";
			
		    sql += " and news_data.typeId = ? " ;			
			int count = 0;
			List lista = newsDataDao.find(sql, -1,-1,null,parameter);			
			
			Map<String, Integer> map = new HashMap<String, Integer>();			
			if(lista != null){				
				for(Object obj : lista){
					String cu = obj.toString();
					Integer tot = map.get(cu);
					if(tot == null){
						map.put(cu, 1);						
					}else
						map.put(cu, tot + 1);		
				}
				count = map.size();
			}
			Pagination.setRowCount(count);	
			
			NewsType theType = newsTypeManager.getById(newsTypeId);
			boolean isGroup = (theType != null && (theType.getSpaceType().intValue() == SpaceType.group.ordinal()));
			Set<String> keyset = map.keySet();
			for(String bi : keyset){
				Object[] arr = new Object[3];
				arr[0] = bi;
				String name = this.getNewsUtils().getOrgEntityName(V3xOrgEntity.ORGENT_TYPE_MEMBER, Long.valueOf(bi.toString()), isGroup);
				arr[1] = name;
				arr[2] = map.get(bi);	
				
				list.add(arr);
			}
			
			return list;
		} else if ("byPublishDate".equals(type)) {
			Calendar cal = Calendar.getInstance();
			cal.add(Calendar.MONTH, 1);
			for (int i = 0; i < 12; i++) {

				cal.set(cal.get(Calendar.YEAR), cal.get(Calendar.MONTH), 1, 0,
						0, 0);
				final Date endDate = cal.getTime();

				cal.add(Calendar.MONTH, -1);
				cal.set(cal.get(Calendar.YEAR), cal.get(Calendar.MONTH), 1, 0,
						0, 0);
				final Date beginDate = cal.getTime();
				List<Object> parameter = new ArrayList<Object>();
				parameter.add(Constants.DATA_STATE_ALREADY_PUBLISH );
			    parameter.add(Constants.DATA_STATE_ALREADY_PIGEONHOLE);
			    parameter.add(endDate);
			    parameter.add(beginDate);
			    parameter.add(newsTypeId);
			    
			    String hql = " select count(*) from NewsData as newsdata, NewsType as newstype where newsdata.typeId = newstype.id ";
				hql += " and (newsdata.state = ? or newsdata.state = ?) ";
				hql += " and newsdata.publishDate <=? and newsdata.publishDate >=? ";
				hql += " and newsdata.deletedFlag = false and newstype.id = ? ";
				
				Number num = (Number) newsDataDao.findUnique(hql, null, parameter);
				Integer total = num.intValue();
				list.add(new Object[] { beginDate, total });
			}
			return list;
		} else if ("byState".equals(type)) {
			List<Object> parameter = new ArrayList<Object>();
			parameter.add(Constants.DATA_STATE_ALREADY_PUBLISH );
		    parameter.add(Constants.DATA_STATE_ALREADY_PIGEONHOLE);
		    parameter.add(newsTypeId);
			String sql = "select news_data.state "
					+ "from NewsData news_data  where  (news_data.state=? or  news_data.state=? )  and news_data.deletedFlag = false ";
			 
			sql += " and news_data.typeId = ? " ;
			List lista = newsDataDao.find(sql, -1,-1,null,parameter);
			Map<String, Integer> map = new HashMap<String, Integer>();
			if(lista != null){				
				for(Object obj : lista){
					String sta = obj.toString();
					Integer tot = map.get(sta);
					if(tot == null){
						map.put(sta, 1);						
					}else
						map.put(sta, tot + 1);		
				}
			}
			
			Set<String> keyset = map.keySet();
			for(String sta : keyset){
				Object[] arr = new Object[2];
				arr[0] = sta;
				arr[1] = map.get(sta);
				list.add(arr);
			}
			
			if(list.isEmpty()){
				Object[] pub = new Object[2];
				pub[0] = Constants.DATA_STATE_ALREADY_PUBLISH;
				pub[1] = 0;
				list.add(pub);
				
				Object[] pig = new Object[2];
				pig[0] = Constants.DATA_STATE_ALREADY_PIGEONHOLE;
				pig[1] = 0;
				list.add(pig);
			}else if(list.size() == 1){
				Object[] cur = (Object[])list.get(0);
				if(cur[0].toString().equals(Constants.DATA_STATE_ALREADY_PUBLISH + "")){
					Object[] pig = new Object[2];
					pig[0] = Constants.DATA_STATE_ALREADY_PIGEONHOLE;
					pig[1] = 0;
					list.add(pig);
				}else{
					list = new ArrayList();					
					Object[] pub = new Object[2];
					pub[0] = Constants.DATA_STATE_ALREADY_PUBLISH;
					pub[1] = 0;					
					list.add(pub);
					list.add(cur);						
				}
			}	
			return list;
		}

		return list;
	}

	public void setFileManager(FileManager fileManager) {
		this.fileManager = fileManager;
	}
	
	public void pigeonhole(List<Long> ids){
		for(Long id:ids){
			NewsData data=this.getById(id);
			if(data.getState()!=Constants.DATA_STATE_ALREADY_PIGEONHOLE){
				data.setState(Constants.DATA_STATE_ALREADY_PIGEONHOLE);
				this.updateDirect(data);
			}
            // 删除全文检索
            if (AppContext.hasPlugin("index")) {
                try {
                    IndexManager indexManager = (IndexManager) AppContext.getBean("indexManager");
                    indexManager.delete(id, ApplicationCategoryEnum.news.getKey());
                } catch (BusinessException e) {
                    log.error("从indexManager删除检索项。", e);
                }
            }
		}
	}
	/**
	 * 用户模块管理页面什么也不输入的时候进行的查询
	 */
	@SuppressWarnings("unchecked")
	public List<NewsData> findAll(Long typeId,long userid) throws Exception {
		List<NewsType> inList = this.newsTypeManager.getManagerTypeByMember(userid, null, null);
		List<NewsData> list=null;
		if (Strings.isEmpty(inList)){
		    return Collections.EMPTY_LIST;
		}else{
		    list=newsDataDao.findAllDAO(userid, typeId,inList);
		}
		initList(list);
		return list;
	}
	
	@SuppressWarnings("unchecked")
	public List<NewsData> findAllWithOutFilter(Long typeId) throws Exception{
		// 外部人员guolv
		User user =  AppContext.getCurrentUser();
		if(user == null || (!user.isInternal()))
			return new ArrayList<NewsData>();
		
		List<NewsData> list = null;
		DetachedCriteria dc=DetachedCriteria.forClass(NewsData.class);
		dc.add(Restrictions.eq("typeId", typeId));
		dc.add(Restrictions.eq("deletedFlag", false));
		list=newsDataDao.executeCriteria(dc);
		return list;
	}
	
	public int findAllWithOutFilterTotal(final Long typeId) throws Exception{
		int ret = 0;
		String hql = " select count(*) from NewsData where typeId = ? " 
		+ " and deletedFlag = false and state != ? "
			+ " and state != ? ";
		List<Object> parameter = new ArrayList<Object>();
		parameter.add(typeId);
		parameter.add(Constants.DATA_STATE_ALREADY_PIGEONHOLE);
		parameter.add(Constants.DATA_STATE_NO_SUBMIT);
		ret = (Integer)newsDataDao.findUnique(hql, null, parameter);		
		return ret;
	}
	
	@SuppressWarnings("unchecked")
	public List<NewsData> getNewsByTypeId(final Long typeId) throws Exception {
		List<NewsData> newsList = new ArrayList<NewsData>();
		String hql = "from NewsData where typeId = ? " + " and deletedFlag = false and state != ? ";
		List<Object> parameter = new ArrayList<Object>();
		parameter.add(typeId);
		parameter.add(Constants.DATA_STATE_ALREADY_PIGEONHOLE);
		newsList = newsDataDao.find(hql, -1,-1,null,parameter);
		return newsList;
	}
	
	//用户在模块管理页面输入相关的查询条件
	@SuppressWarnings("unchecked")
	public List<NewsData> findByProperty(Long typeId, String condition, Object value, Object value1,long userid) throws Exception {
		List<NewsType> inList = this.newsTypeManager.getManagerTypeByMember(userid, null, null);
		List list=newsDataDao.findByPropertyDAO(userid, typeId, condition, value, value1,inList);
		initList(list);
		return list;
	}
	
	
	//H5用户获取所有新闻（可查询）
	@SuppressWarnings("unchecked")
	public List<NewsData> findByUserProperty(String condition, Object value, Object value1,List<Long> typesIds,Long userId) throws Exception {
		List list=newsDataDao.findByUserPropertyDAO(typesIds, condition, value, value1,userId);
		initList(list);
		return list;
	}
	
	/**
	 * 这是从集团新闻首页新闻板块下点击"更多"按钮
	 */
	public List<NewsData> findByReadUser(Long userId, Long typeId,long loginAccount) throws BusinessException {
		List<NewsData> list=newsDataDao.findByReadUserDAO(userId, typeId,loginAccount);
		if (Strings.isNotEmpty(list)) {
            newsReadManager.getReadState(list, userId);
        }
		initList(list);
		return list;
	}
	
	public List<NewsData> findByReadUser(Long userId, Long typeId) throws BusinessException {
		List<NewsData> list=newsDataDao.findByReadUserDAO(userId, typeId, AppContext.getCurrentUser().getLoginAccount());
		if (Strings.isNotEmpty(list)) {
            newsReadManager.getReadState(list, userId);
        }
		initList(list);
		return list;
	}

	public List<NewsData> findByReadUserContent(Long userId, Long typeId) throws BusinessException {
		List<NewsData> list=newsDataDao.findByReadUserDAO(userId, typeId, AppContext.getCurrentUser()!=null?AppContext.getCurrentUser().getLoginAccount():0L);
		List<NewsData> resultBulDatas=new ArrayList<NewsData>();   
		for(NewsData bdInfo:list){
	        	bdInfo.setContent(getBody(bdInfo.getId()).getContent());
	        	resultBulDatas.add(bdInfo);
	        }
		initList(resultBulDatas);
		return resultBulDatas;
	}
	
	public List<NewsData> findByReadUser4Section(Long userId, Long typeId) throws BusinessException {
		NewsType type = this.newsTypeManager.getById(typeId);
		User user =  AppContext.getCurrentUser();
        //其它单位的人员，没有单位类型板块的权限
        if (type.getSpaceType().intValue() == SpaceType.corporation.ordinal() && !type.getAccountId().equals(user.getLoginAccount())) {
            return new ArrayList<NewsData>();
        }
		//外部人员，没有该板块的权限
		if(!user.isInternal() && !type.getOutterPermit()){
			return new ArrayList<NewsData>();
		}
		
		String hql = NewsUtils.SELECT_FIELDS +  " where t_data.state=:state and t_data.deletedFlag=false and t_data.typeId=:typeId order by t_data.publishDate desc";
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("state", Constants.DATA_STATE_ALREADY_PUBLISH);
		params.put("typeId", typeId);
		
		List<NewsData> list = NewsUtils.objArr2News((List<Object[]>)newsDataDao.find(hql, params));
		if (list != null && !list.isEmpty()) {
			newsReadManager.getReadState(list, userId);
		}
		initList(list);
		return list;
	}

	@SuppressWarnings("unchecked")
	public List<NewsData> findWriteAll(Long typeId,long userId) throws BusinessException {
		List list=newsDataDao.findWriteAllDAO(typeId,userId);
		initList(list);
		return list;
	}

	@SuppressWarnings("unchecked")
	public List<NewsData> findWriteByProperty(Long typeId, String condition, Object value) throws BusinessException {
		// 外部人员guolv
		User user =  AppContext.getCurrentUser();
		if(user == null || (!user.isInternal()))
			return new ArrayList<NewsData>();
		DetachedCriteria criteria = this.filterByWriteGetHql(condition, value);
		criteria.add(Restrictions.eq("typeId", typeId));
		List<NewsData> list = newsDataDao.executeCriteria(criteria);
		initList(list);
		return list;
	}
	
	/**
	 * 初始化
	 */
	public void init(){	
		DataCache<NewsData> dc = new DataCache<NewsData>(this);
        this.dataCache = dc;
	}
	
	/**
	 * 判断某个审核员是否有未审核事项
	 */
	public boolean hasPendingOfUser(Long userId, Long... typeIds){
		List<NewsData> list = this.getPendingData(userId, typeIds);
		return Strings.isNotEmpty(list);
	}
	
		//客开 start
	/**
	 * 判断某个排版员是否有未排版事项
	 */
	public boolean hasPending2OfUser(Long userId, Long... typeIds){
	  List<NewsData> list = this.getPending2Data(userId, typeIds);
	  return Strings.isNotEmpty(list);
	}

	private List<NewsData> getPending2Data(Long userId, Long... typeIds){
      if(userId == null)
          return null;

      List<NewsType> auditTypes = this.newsTypeManager.getPaiBanTypeByMember(userId, null, null);
      Set<Long> idset = null;
      if (Strings.isEmpty(auditTypes)) {
          return new ArrayList<NewsData>();
      } else {
          idset = this.getIdSet(auditTypes);
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
      DetachedCriteria criteria = DetachedCriteria.forClass(NewsData.class);

      if(set.size() > 0)
          criteria.add(Restrictions.in("typeId", set));
      else
          return null;
      criteria.add(Restrictions.eq("state", Constants.DATA_STATE_TYPESETTING_CREATE));
      criteria.add(Restrictions.eq("deletedFlag", false));
      List<NewsData> list = newsDataDao.executeCriteria(criteria,-1,-1);
      return list;
  }

	//客开end
	
	/**
	 * 得到某个用户需要审核的数据
	 */
	private List<NewsData> getPendingData(Long userId, Long... typeIds){
		if(userId == null)
			return null;
		
		List<NewsType> auditTypes = this.newsTypeManager.getAuditTypeByMember(userId, null, null);
		Set<Long> idset = null;
        if (Strings.isEmpty(auditTypes)) {
            return new ArrayList<NewsData>();
        } else {
            idset = this.getIdSet(auditTypes);
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
		DetachedCriteria criteria = DetachedCriteria.forClass(NewsData.class);
		
		if(set.size() > 0)
			criteria.add(Restrictions.in("typeId", set));
		else
			return null;
        criteria.add(Restrictions.eq("state", Constants.DATA_STATE_ALREADY_CREATE));
        criteria.add(Restrictions.eq("deletedFlag", false));
		List<NewsData> list = newsDataDao.executeCriteria(criteria,-1,-1);		
		return list;
	}
	
	/**
	 * 审核员对某个类型的待办总数
	 */
	public int getPendingCountOfUser(Long userId, int spaceType){
		if(userId == null)
			return 0;	
		
		List<NewsType> auditList = this.newsTypeManager.getAuditTypeByMember(userId, 
				Constants.valueOfSpaceType(spaceType), null);
		if(Strings.isEmpty(auditList)){
		    return 0;
		}
		List list = newsDataDao.getPendingCountOfUserDAO(auditList);		
		return (list == null ? 0 : list.size());
	}
	
	/**
	 * 得到状态
	 */
	@AjaxAccess
	public int getStateOfData(long id){
		NewsData data = this.getById(id);
		if(data == null)
			return 0;
		else
			return data.getState();
	}
	
	/**
	 * 判断新闻板块审核员是否可用
	 * @param typeId
	 * @return
	 */
	public boolean isAuditUserEnabled(Long typeId) throws Exception {
		NewsType type = this.newsTypeManager.getById(typeId);
		V3xOrgMember auditUser = this.orgManager.getMemberById(type.getAuditUser());
		if(auditUser != null){
			if(!auditUser.getEnabled() || auditUser.getIsDeleted()){
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
	  NewsType type = this.newsTypeManager.getById(typeId);
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

	public boolean typeExist(long typeId){
		NewsType type = this.getNewsTypeManager().getById(typeId);
		return (type != null && type.isUsedFlag());
	}
	
	public boolean isManagerOfType(long typeId, long userId){
		NewsType type = this.newsTypeManager.getById(typeId);
		if(type == null)
			return false;
		else{
			Set<NewsTypeManagers> set = type.getNewsTypeManagers();
			for(NewsTypeManagers t : set){
				if(t.getManagerId().longValue() == userId && t.getExt1().equals(Constants.MANAGER_FALG))
					return true;
			}
			return false;
		}
	}
	
	/**
	 * 综合查询
	 */
	public List<NewsData> iSearch(ConditionModel cModel,long loginAccount){
		List<NewsType> inList= new ArrayList<NewsType>();
		List<NewsType> customTypeList = newsTypeManager.findCustomNewsTypeByUnitId(loginAccount);
		List<NewsType> typeList2 = getNewsTypeManager().findAll(loginAccount);			
		List<NewsType> typeList3 = getNewsTypeManager().groupFindAll();
		if(customTypeList != null){
            inList.addAll(customTypeList);
        }
		if(typeList2 != null){
		    inList.addAll(typeList2);
		}
		if(typeList3 != null) {
		    inList.addAll(typeList3);
		}
		List<NewsData> list = null;
		List<Long> typeIds = new ArrayList<Long>();
		Map<String,Object> parameter = new HashMap<String,Object>();
		if (inList.isEmpty()) {
			return new ArrayList<NewsData>();
		}else{
			for(NewsType t : inList){
				typeIds.add(t.getId());
			}
		}
		DetachedCriteria criteria = this.filterByReadGetHql();
		criteria.add(Restrictions.in("typeId", typeIds));
		
		String title = cModel.getTitle();
		final Date beginDate = cModel.getBeginDate();
		final Date endDate = cModel.getEndDate();
		Long fromUserId = cModel.getFromUserId();
		
		StringBuffer sb = new StringBuffer();
		if(Strings.isNotBlank(title)){
			criteria.add(Restrictions.like("title", "%"+SQLWildcardUtil.escape(title)+"%"));
		}
		if(fromUserId != null ){
			criteria.add(Restrictions.eq("publishUserId", fromUserId));
		}
		if(beginDate != null){
			criteria.add(Restrictions.ge("publishDate", beginDate));
		}
		if(endDate != null){
			criteria.add(Restrictions.le("publishDate", endDate));
		}
		
		list = newsDataDao.executeCriteria(criteria);	
		this.initList(list);
		return list;
	}
	private Set<Long> getIdSet(Collection<NewsType> coll){
		Set<Long> set = new HashSet<Long>();
		if(Strings.isEmpty(coll)){
		    return set;
		}
		for(NewsType bt : coll){
			set.add(bt.getId());
		}
		return set;
	}
	
	public void auditNews (String objectId, String formOper,String auditAdvice) throws Exception{
        User user = AppContext.getCurrentUser();
        String idStr = objectId;
        if (StringUtils.isBlank(idStr)) {
            return ;
        }
        NewsData bean = this.getById(Long.valueOf(idStr));
        //处理审核两次的情况,只有是未审核的状态才允许审核操作
        if (bean.getState().intValue() != Constants.DATA_STATE_ALREADY_CREATE) {
            return ;
        }
        String form_oper = formOper;
        boolean hasOldBean = false;

        NewsData oldBean = null;
        if(bean.getOldId()!=null &&bean.getOldId().intValue()!=0){
        	oldBean = this.getById(Long.valueOf(bean.getOldId()));
        	if(oldBean!=null && StringUtils.isNotBlank(form_oper) && form_oper.equals("publish")){
        		hasOldBean = true;
        	}
        }
        NewsType type = this.getNewsTypeManager().getById(bean.getTypeId());
        boolean hasTypesetting = type != null && type.isTypesettingFlag() && type.getTypesettingStaff()!=null && type.getTypesettingStaff().intValue() !=0 && type.getTypesettingStaff().intValue()!=1;
  	  
  	  if(hasOldBean && !hasTypesetting){
  	    //如果是二次发布且排版通过并发布，当前新闻内容覆盖之前的老新闻（除发布时间、发布人、查阅留痕等信息需要保留不变外），删除当前新闻
  	    //title SPACETYPE  TYPE_ID
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
  	    //删除老新闻的附件
  	    for(Map.Entry<Long, Long> entry:oldFileUrlsMap.entrySet()){
  	      attachmentManager.deleteById(entry.getValue());
  	    }
  	    
  	    //把新新闻的附件指向老新闻
  	    for(Attachment att:atts){
  	      if(newAtts.contains(att.getFileUrl()))continue;
  	      att.setReference(oldBean.getId());
  	      att.setSubReference(oldBean.getId());
  	      attachmentManager.update(att);
  	    }
  	    NewsBody body = newsBodyDao.get(bean.getId());
  	    newsBodyDao.deleteByDataId(oldBean.getId());//删除老新闻的内容
  	    body.setId(oldBean.getId());//把新新闻的内容复制到老新闻上
  	    newsBodyDao.save(body);
  	    //更新老新闻
  	    oldBean.setTitle(bean.getTitle());
  	    oldBean.setFutitle(bean.getFutitle());
  	    oldBean.setSpaceType(bean.getSpaceType());
  	    oldBean.setType(bean.getType());
  	    oldBean.setTypeId(bean.getTypeId());
  	    oldBean.setTypeName(bean.getTypeName());
  	    oldBean.setPublishDepartmentId(bean.getPublishDepartmentId());
  	    oldBean.setPublishDepartmentName(bean.getPublishDepartmentName());
  	    oldBean.setBrief(bean.getBrief());
  	    oldBean.setKeywords(bean.getKeywords());
  	    oldBean.setShowPublishUserFlag(bean.isShowPublishUserFlag());
  	    oldBean.setImgUrl(bean.getImgUrl());
  	    oldBean.setImageId(bean.getImageId());
  	    oldBean.setImageNews(bean.isImageNews());
  	    oldBean.setShareWeixin(bean.getShareWeixin());
  	    oldBean.setAttachmentsFlag(bean.getAttachmentsFlag());
  	    oldBean.setAuditAdvice(bean.getAuditAdvice());
          oldBean.setAuditAdvice1(bean.getAuditAdvice1());
          oldBean.setAuditDate(bean.getAuditDate());
          oldBean.setAuditDate1(bean.getAuditDate1());
          oldBean.setAuditUserId(bean.getAuditUserId());
          oldBean.setAuditUserId1(bean.getAuditUserId1());
  	    this.updateDirect(oldBean);
  	    //删除新新闻
  	    this.delete(bean.getId());
          // 删除待办
          affairManager.deleteByObjectId(ApplicationCategoryEnum.news, bean.getId());
          getNewsData().remove(oldBean.getId());
          getNewsData().remove(bean.getId());
//          getNewsData().save(oldBean.getId(), oldBean, oldBean.getPublishDate().getTime(), (oldBean.getReadCount() == null ? 0 : oldBean.getReadCount()));
          //对新闻文件进行解锁
          if (idStr != null && !"".equalsIgnoreCase(idStr))
            this.unlock(Long.valueOf(idStr));
  	  }else{
        
        if (StringUtils.isNotBlank(form_oper)) {
            if ("audit".equals(form_oper)) {
                //审核通过,但是没有发布,用记点的是通过
                bean.setState(Constants.DATA_STATE_ALREADY_AUDIT);
            } else if ("publish".equals(form_oper)) {
              //客开 start  如果有排版节点，则设置状态为待排版
                //直接发布,用户点的是直接发布
              if(type != null && type.isTypesettingFlag() && type.getTypesettingStaff()!=null && type.getTypesettingStaff().intValue() !=0 && type.getTypesettingStaff().intValue()!=1){
                bean.setState(Constants.DATA_STATE_TYPESETTING_CREATE);
              }else{
                bean.setPublishDate(new Date());
//                bean.setPublishUserId(AppContext.getCurrentUser().getId());
                bean.setPublishUserId(bean.getCreateUser());
                bean.setState(Constants.DATA_STATE_ALREADY_PUBLISH);
                bean.setTopOrder(Byte.parseByte("1"));
              }
                //客开 end
                bean.setExt3(String.valueOf(Constants.AUDIT_RECORD_PUBLISH));
            } else if ("noaudit".equals(form_oper)) {
                //审核不通过
                bean.setState(Constants.DATA_STATE_NOPASS_AUDIT);
            } else if ("cancelaudit".equals(form_oper)) {
                //用户点取消按钮了
                bean.setState(Constants.DATA_STATE_ALREADY_CREATE);
            }
        } else {
            //尚末提交,也就是暂存
            bean.setState(Constants.DATA_STATE_NO_SUBMIT);
        }


        bean.setAuditAdvice(auditAdvice);
        bean.setAuditDate(new Date());
        bean.setAuditUserId(type.getAuditUser());

        bean.setUpdateDate(new Date());
        bean.setUpdateUser(AppContext.getCurrentUser().getId());

        Map<String, Object> summ = new HashMap<String, Object>();
        summ.put("state", bean.getState());
        //客开start
        if(bean.getState().intValue() == Constants.DATA_STATE_ALREADY_PUBLISH){
          if ("publish".equals(form_oper)) {
            summ.put("publishDate", bean.getPublishDate());
//            summ.put("publishUserId", AppContext.getCurrentUser().getId());
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

        Long agentId = AgentUtil.getAgentByApp(type.getAuditUser(), ApplicationCategoryEnum.news.getKey());
        Long senderId = user.getId();
        String senderName = user.getName();
        int proxyType = 0;
        if (agentId != null && agentId.equals(senderId)) {
            proxyType = 1;
            senderId = type.getAuditUser();
            senderName = type.getAuditUserName();
        }
        // 发送审合通过消息消息
        if (bean.getState().equals(Constants.DATA_STATE_ALREADY_AUDIT)) {
            userMessageManager.sendSystemMessage(
                    MessageContent.get("news.alreadyauditing", bean.getTitle(), senderName, proxyType, user.getName()),
                    ApplicationCategoryEnum.news,
                    senderId,
                    MessageReceiver.get(bean.getId(), bean.getCreateUser(), "message.link.news.writedetail",
                            String.valueOf(bean.getId())), bean.getTypeId());

            // 审合新闻通过加日志
            appLogManager.insertLog(user, AppLogAction.News_AuditPass, user.getName(), bean.getTitle());
        }
        // 发送审合没有通过消息消息
        if (bean.getState().equals(Constants.DATA_STATE_NOPASS_AUDIT)) {
            userMessageManager.sendSystemMessage(
                    MessageContent.get("news.not.alreadyauditing", bean.getTitle(), senderName, proxyType,
                            user.getName()),
                    ApplicationCategoryEnum.news,
                    senderId,
                    MessageReceiver.get(bean.getId(), bean.getCreateUser(), "message.link.news.writedetail",
                            String.valueOf(bean.getId())), bean.getTypeId());

            // 审合新闻没有通过加日志
            appLogManager.insertLog(user, AppLogAction.News_AduitNotPass, user.getName(), bean.getTitle());
        }

        //yangwulin 2012-11-13 修改管理员直接发布的不能全文检索。（这句代码3.5在下面if条件后面。这里应该是逻辑错误。）
        this.update(bean.getId(), summ);
        if (bean.getState() == Constants.DATA_STATE_ALREADY_PUBLISH) {
            //触发发布事件
            NewsAddEvent newsAddEvent = new NewsAddEvent(this);
            newsAddEvent.setNewsDataBO(NewsUtils.newsDataPOToBO(bean));
            EventDispatcher.fireEvent(newsAddEvent);
        }
        //触发审核事件
        NewsAuditEvent newsAuditEvent = new NewsAuditEvent(this);
        newsAuditEvent.setNewsDataBO(NewsUtils.newsDataPOToBO(bean));
        EventDispatcher.fireEvent(newsAuditEvent);
        // 审核员直接发送发送消息
        if (bean.getState().equals(Constants.DATA_STATE_ALREADY_PUBLISH)) {
            Long publishDeptId = bean.getPublishDepartmentId();
            V3xOrgDepartment publishDept = orgManager.getDepartmentById(publishDeptId);
            Long publishAccountId = publishDept.getOrgAccountId();

            List<Long> resultIds = new ArrayList<Long>();

            List<V3xOrgMember> listMemberId = this.newsUtils.getScopeMembers(bean.getType().getSpaceType(),
                    publishAccountId, bean.getType().getOutterPermit());

            for (V3xOrgMember member : listMemberId) {
                resultIds.add(member.getId());
            }
            V3xOrgMember vom = orgManager.getMemberById(bean.getCreateUser());
            this.initDataFlag(bean,true);
            String deptName = bean.getPublishDepartmentName();
            userMessageManager.sendSystemMessage(
                    MessageContent.get("news.auditing", bean.getTitle(), deptName).setBody(
                            this.getBody(bean.getId()).getContent(), bean.getDataFormat(),
                            bean.getCreateDate()), ApplicationCategoryEnum.news, bean.getPublishUserId(),
                    MessageReceiver.getReceivers(bean.getId(), resultIds, "message.link.news.assessor.auditing",
                    //0表示用户从系统消息,网页等途径进行读取新闻(除在归档页面)
                            String.valueOf(bean.getId())), bean.getTypeId());

            // 这里加入全文检索

            try {
                //IndexEnable indexEnable = (IndexEnable) newsDataManager;
                //IndexInfo info = indexEnable.getIndexInfo(bean.getId());
                if (AppContext.hasPlugin("index")) {
                    indexManager.add(bean.getId(), ApplicationCategoryEnum.news.getKey());
                }
            } catch (Exception e) {
                log.error("全文检索: ", e);
            }

            // 直接发布加日志
            appLogManager.insertLog(user, AppLogAction.News_AuditPublish, user.getName(), bean.getTitle());

        }

        // 删除待办
        affairManager.deleteByObjectId(ApplicationCategoryEnum.news, bean.getId());
        //对新闻文件进行解锁
        if (idStr != null && !"".equalsIgnoreCase(idStr))
            this.unlock(Long.valueOf(idStr));
  	  }
	}
	//客开 start
	/**
	 * 新闻排版审核
	 * @param objectId
	 * @param formOper
	 * @param auditAdvice
	 * @throws Exception
	 */
	public void auditNews2 (String objectId, String formOper,String auditAdvice) throws Exception{
	  User user = AppContext.getCurrentUser();
	  String idStr = objectId;
	  if (StringUtils.isBlank(idStr)) {
	    return ;
	  }
	  NewsData bean = this.getById(Long.valueOf(idStr));
	  //处理排版两次的情况,只有是未排版的状态才允许排版操作
	  if (bean.getState().intValue() != Constants.DATA_STATE_TYPESETTING_CREATE) {
	    return ;
	  }
	  boolean hasOldBean = false;
	  String form_oper = formOper;
	  NewsData oldBean = null;
	  if(bean.getOldId()!=null &&bean.getOldId().intValue()!=0){
	     oldBean = this.getById(Long.valueOf(bean.getOldId()));
	    if(oldBean!=null && StringUtils.isNotBlank(form_oper) && form_oper.equals("publish")){
	      hasOldBean = true;
	    }
	  }
	  if(hasOldBean){
	    //如果是二次发布且排版通过并发布，当前新闻内容覆盖之前的老新闻（除发布时间、发布人、查阅留痕等信息需要保留不变外），删除当前新闻
	    //title SPACETYPE  TYPE_ID
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
	    //删除老新闻的附件
	    for(Map.Entry<Long, Long> entry:oldFileUrlsMap.entrySet()){
	      attachmentManager.deleteById(entry.getValue());
	    }
	    
	    //把新新闻的附件指向老新闻
	    for(Attachment att:atts){
	      if(newAtts.contains(att.getFileUrl()))continue;
	      att.setReference(oldBean.getId());
	      att.setSubReference(oldBean.getId());
	      attachmentManager.update(att);
	    }
	    NewsBody body = newsBodyDao.get(bean.getId());
	    newsBodyDao.deleteByDataId(oldBean.getId());//删除老新闻的内容
	    body.setId(oldBean.getId());//把新新闻的内容复制到老新闻上
	    newsBodyDao.save(body);
	    //更新老新闻
	    oldBean.setTitle(bean.getTitle());
	    oldBean.setFutitle(bean.getFutitle());
	    oldBean.setSpaceType(bean.getSpaceType());
	    oldBean.setType(bean.getType());
	    oldBean.setTypeId(bean.getTypeId());
	    oldBean.setTypeName(bean.getTypeName());
	    oldBean.setPublishDepartmentId(bean.getPublishDepartmentId());
	    oldBean.setPublishDepartmentName(bean.getPublishDepartmentName());
	    oldBean.setBrief(bean.getBrief());
	    oldBean.setKeywords(bean.getKeywords());
	    oldBean.setShowPublishUserFlag(bean.isShowPublishUserFlag());
	    oldBean.setImgUrl(bean.getImgUrl());
	    oldBean.setImageId(bean.getImageId());
	    oldBean.setImageNews(bean.isImageNews());
	    oldBean.setShareWeixin(bean.getShareWeixin());
	    oldBean.setAttachmentsFlag(bean.getAttachmentsFlag());
	    oldBean.setAuditAdvice(bean.getAuditAdvice());
        oldBean.setAuditAdvice1(bean.getAuditAdvice1());
        oldBean.setAuditDate(bean.getAuditDate());
        oldBean.setAuditDate1(bean.getAuditDate1());
        oldBean.setAuditUserId(bean.getAuditUserId());
        oldBean.setAuditUserId1(bean.getAuditUserId1());
	    this.updateDirect(oldBean);
	    //删除新新闻
	    this.delete(bean.getId());
        // 删除待办
        affairManager.deleteByObjectId(ApplicationCategoryEnum.news, bean.getId());
        getNewsData().remove(oldBean.getId());
        getNewsData().remove(bean.getId());
//        getNewsData().save(oldBean.getId(), oldBean, oldBean.getPublishDate().getTime(), (oldBean.getReadCount() == null ? 0 : oldBean.getReadCount()));
        //对新闻文件进行解锁
        if (idStr != null && !"".equalsIgnoreCase(idStr))
          this.unlock(Long.valueOf(idStr));
	  }else{
	    if (StringUtils.isNotBlank(form_oper)) {
	      if (form_oper.equals("audit")) {
	        //排版通过,但是没有发布,用记点的是通过
	        bean.setState(Constants.DATA_STATE_TYPESETTING_PASS);
	      } else if (form_oper.equals("publish")) {
	        //直接发布,用户点的是直接发布
	        bean.setPublishDate(new Date());
//	        bean.setPublishUserId(AppContext.getCurrentUser().getId());
	        bean.setPublishUserId(bean.getCreateUser());
	        bean.setState(Constants.DATA_STATE_ALREADY_PUBLISH);
	        bean.setTopOrder(Byte.parseByte("1"));
	        bean.setExt1(String.valueOf(Constants.TYPESETTING_RECORD_PUBLISH));
	      } else if (form_oper.equals("noaudit")) {
	        //审核不通过
	        bean.setState(Constants.DATA_STATE_TYPESETTING_NOPASS);
	      } else if (form_oper.equals("cancelaudit")) {
	        //用户点取消按钮了
	        bean.setState(Constants.DATA_STATE_TYPESETTING_CREATE);
	      }
	    } else {
	      //尚末提交,也就是暂存
	      bean.setState(Constants.DATA_STATE_NO_SUBMIT);
	    }

	    NewsType type = this.getNewsTypeManager().getById(bean.getTypeId());

	    bean.setAuditAdvice1(auditAdvice);
	    bean.setAuditDate1(new Date());
	    bean.setAuditUserId1(type.getTypesettingStaff());

	    bean.setUpdateDate(new Date());
	    bean.setUpdateUser(AppContext.getCurrentUser().getId());

	    Map<String, Object> summ = new HashMap<String, Object>();
	    summ.put("state", bean.getState());
	    if ("publish".equals(form_oper)) {
	      summ.put("publishDate", bean.getPublishDate());
//	      summ.put("publishUserId", AppContext.getCurrentUser().getId());
          summ.put("publishUserId", bean.getCreateUser());
	      summ.put("ext1", bean.getExt1());
	    }
	    summ.put("auditAdvice1", bean.getAuditAdvice1());
	    summ.put("auditDate1", bean.getAuditDate1());
	    summ.put("auditUserId1", bean.getAuditUserId1());
	    summ.put("updateDate", bean.getUpdateDate());
	    summ.put("updateUser", bean.getUpdateUser());

	    Long agentId = AgentUtil.getAgentByApp(type.getAuditUser(), ApplicationCategoryEnum.news.getKey());
	    Long senderId = user.getId();
	    String senderName = user.getName();
	    int proxyType = 0;
	    if (agentId != null && agentId.equals(senderId)) {
	      proxyType = 1;
	      senderId = type.getAuditUser();
	      senderName = type.getAuditUserName();
	    }
	    // 发送审合通过消息消息
	    if (bean.getState().equals(Constants.DATA_STATE_TYPESETTING_PASS)) {
	      userMessageManager.sendSystemMessage(
	          MessageContent.get("news.alreadyauditing", bean.getTitle(), senderName, proxyType, user.getName()),
	          ApplicationCategoryEnum.news,
	          senderId,
	          MessageReceiver.get(bean.getId(), bean.getCreateUser(), "message.link.news.writedetail",
	              String.valueOf(bean.getId())), bean.getTypeId());

	      // 审合新闻通过加日志
	      appLogManager.insertLog(user, AppLogAction.News_TypesettingPass, user.getName(), bean.getTitle());
	    }
	    // 发送审合没有通过消息消息
	    if (bean.getState().equals(Constants.DATA_STATE_TYPESETTING_NOPASS)) {
	      userMessageManager.sendSystemMessage(
	          MessageContent.get("news.not.alreadyauditing", bean.getTitle(), senderName, proxyType,
	              user.getName()),
	              ApplicationCategoryEnum.news,
	              senderId,
	              MessageReceiver.get(bean.getId(), bean.getCreateUser(), "message.link.news.writedetail",
	                  String.valueOf(bean.getId())), bean.getTypeId());

	      // 审合新闻没有通过加日志
	      appLogManager.insertLog(user, AppLogAction.News_TypesettingNotPass, user.getName(), bean.getTitle());
	    }

	    //yangwulin 2012-11-13 修改管理员直接发布的不能全文检索。（这句代码3.5在下面if条件后面。这里应该是逻辑错误。）
	    this.update(bean.getId(), summ);
	    if (bean.getState() == Constants.DATA_STATE_ALREADY_PUBLISH) {
	      //触发发布事件
	      NewsAddEvent newsAddEvent = new NewsAddEvent(this);
	      newsAddEvent.setNewsDataBO(NewsUtils.newsDataPOToBO(bean));
	      EventDispatcher.fireEvent(newsAddEvent);
	    }
	    // 审核员直接发送发送消息
	    if (bean.getState().equals(Constants.DATA_STATE_ALREADY_PUBLISH)) {
	      Long publishDeptId = bean.getPublishDepartmentId();
	      V3xOrgDepartment publishDept = orgManager.getDepartmentById(publishDeptId);
	      Long publishAccountId = publishDept.getOrgAccountId();

	      List<Long> resultIds = new ArrayList<Long>();

	      List<V3xOrgMember> listMemberId = this.newsUtils.getScopeMembers(bean.getType().getSpaceType(),
	          publishAccountId, bean.getType().getOutterPermit());

	      for (V3xOrgMember member : listMemberId) {
	        resultIds.add(member.getId());
	      }
	      V3xOrgMember vom = orgManager.getMemberById(bean.getCreateUser());
	      this.initDataFlag(bean,true);
	      String deptName = bean.getPublishDepartmentName();
	      userMessageManager.sendSystemMessage(
	          MessageContent.get("news.auditing", bean.getTitle(), deptName).setBody(
	              this.getBody(bean.getId()).getContent(), bean.getDataFormat(),
	              bean.getCreateDate()), ApplicationCategoryEnum.news, bean.getPublishUserId(),
	              MessageReceiver.getReceivers(bean.getId(), resultIds, "message.link.news.assessor.auditing",
	                  //0表示用户从系统消息,网页等途径进行读取新闻(除在归档页面)
	                  String.valueOf(bean.getId())), bean.getTypeId());

	      // 这里加入全文检索

	      try {
	        //IndexEnable indexEnable = (IndexEnable) newsDataManager;
	        //IndexInfo info = indexEnable.getIndexInfo(bean.getId());
	        if (AppContext.hasPlugin("index")) {
	          indexManager.add(bean.getId(), ApplicationCategoryEnum.news.getKey());
	        }
	      } catch (Exception e) {
	        log.error("全文检索: ", e);
	      }

	      // 直接发布加日志
	      appLogManager.insertLog(user, AppLogAction.News_AuditPublish, user.getName(), bean.getTitle());

	    }

	    // 删除待办
	    affairManager.deleteByObjectId(ApplicationCategoryEnum.news, bean.getId());
	    //对新闻文件进行解锁
	    if (idStr != null && !"".equalsIgnoreCase(idStr))
	      this.unlock(Long.valueOf(idStr));
	  }
	}
	//客开 end

	public NewsBodyDao getNewsBodyDao() {
		return newsBodyDao;
	}

	public void setNewsBodyDao(NewsBodyDao newsBodyDao) {
		this.newsBodyDao = newsBodyDao;
	}
	
	/**
	 * 取正文
	 */
	public NewsBody getBody(long newsDataId){
		NewsBody body = this.newsBodyDao.getByDataId(newsDataId);
		String content = HtmlMainbodyHandler.replaceInlineAttachment(body.getContent());
		body.setContent(content);
		return body;
	}	

	/**
	 * 协同转新闻
	 * @throws BusinessException 
	 */
	public void saveCollNews(NewsData data) throws BusinessException {
		//板块类型
		Long typeId=data.getTypeId();
		NewsType type=this.getNewsTypeManager().getById(typeId);
		data.setType(type);
		
//		状态
		if(data.getState() == null){
			data.setState(Constants.DATA_STATE_ALREADY_PUBLISH);
		}
		//保存标新天数
		NewsType bulType=this.getNewsTypeManager().getById(data.getTypeId());
		data.setTopOrder(bulType.getTopCount());
		
		boolean isNew = true;
		boolean firstInitFlag=true;
		save(data, isNew);
		
//		这里加入全文检索
		try {
			if(data.getState().equals(Constants.DATA_STATE_ALREADY_PUBLISH)){
				if(firstInitFlag){
					IndexInfo info=this.getIndexInfo(data.getId());
					if(AppContext.hasPlugin("index")){
					    indexManager.add(info);   
					}
					
				}
			}
		} catch (Exception e) {
			log.error("全文检索: ", e);
		}
		
	}

	public void updateClick(long dataId, int clickNumTotal, Collection<ClickDetail> details) {
		String hql = "update NewsData set readCount = ? where id = ?";
		this.newsDataDao.bulkUpdate(hql, null, clickNumTotal, dataId);
		
	}
	
	public NewsDataLock lock(Long newdatasid, String action) {
		return this.lock(newdatasid,  AppContext.getCurrentUser().getId(), action);
	}
	
	public Map<Long, NewsDataLock> getLockInfo4Dump() {
		return this.newsdataLockMap;
	}
	
	public NewsDataLock lock(Long newdatasid, Long currentUserId, String action) {
		//进行文件锁的检查,方件锁是接口中的一个对象是不会抛空指针的
		NewsDataLock newslock=null;
		if(this.newsdataLockMap==null)
		{
			this.newsdataLockMap=new HashMap<Long, NewsDataLock>();
		}
		if(this.newsdataLockMap.containsKey(newdatasid))
		{
			//文件已加锁
			newslock=this.newsdataLockMap.get(newdatasid);
			/**
			 * 如果操作类型相同，且锁的对象与当前用户相同，也允许用户继续进行同一操作
			 * 仅当两种不同操作同时在进行时，锁才确定生效，比如同一人进行编辑和审核操作，或者两人分别进行编辑或审核操作
			 */
			if(newslock.getUserid()==currentUserId && action.equals(newslock.getAction()))
				return null;
			
			return newslock;
		}else
		{
			//文件没有加锁,对其加锁,继续进行相关的操作
			newslock=new NewsDataLock();
			newslock.setNewsid(newdatasid);
			newslock.setUserid(currentUserId);
			newslock.setAction(action);
			this.newsdataLockMap.put(newdatasid, newslock);
			//发送通知
			NotificationManager.getInstance().send(NotificationType.NewsLock, newslock);
			return null;
		}
	}

	@AjaxAccess
	public void unlock(Long newdatasid) {
		if(this.newsdataLockMap==null)
		{
			this.newsdataLockMap=new HashMap<Long, NewsDataLock>();
		}
		if(this.newsdataLockMap.containsKey(newdatasid))
		{
			this.newsdataLockMap.remove(newdatasid);
			// 发送通知
			NotificationManager.getInstance().send(NotificationType.NewsUnLock, newdatasid);
		}
	}
	
	/**
	 * 该板块存在待审核新闻，但当时的审核员已不可用，如果随后该板块设定了新的审核员，需要将原先的待审核新闻转给新的审核员
	 * @param newsTypeId   对应的新闻板块ID
	 * @param oldAuditorId 旧审核员ID(对应人员已不可用)
	 * @param newAuditorId 新审核员ID
	 */
	public void transferWait4AuditBulDatas2NewAuditor(Long newsTypeId, Long oldAuditorId, Long newAuditorId) {
		this.newsDataDao.transfer2NewAuditor(newsTypeId, oldAuditorId, newAuditorId);
	}

	//客开 start
	public void transferWait4AuditBulDatas2NewTypesettingStaff(Long newsTypeId, Long oldTypesettingStaff, Long typesettingStaff) {
	  this.newsDataDao.transfer2NewTypesettingStaff(newsTypeId, oldTypesettingStaff, typesettingStaff);
	}
	//客开 end

	/**
	 * 根据附件ID取正文
	 */
	public NewsBody getBodyByFileId(String fileid){
		return this.newsBodyDao.getByFileId(fileid);
	}	

	public PartitionManager getPartitionManager()
	{
		return partitionManager;
	}

	public void setPartitionManager(PartitionManager partitionManager)
	{
		this.partitionManager = partitionManager;
	}
	
	public IndexInfo getIndexInfo(Long id) throws BusinessException {
        // 首先取得ID取得NewsData
        NewsData newsData = getById(id);
        if(newsData==null) {return null;}
            V3xOrgMember member = orgManager.getEntityById(V3xOrgMember.class, newsData.getPublishUserId());
            if(member==null){return null;}
            newsData.setContent(this.getBody(id).getContent());
            String createUserName = member.getName();
            IndexInfo indexInfo = new IndexInfo();
            indexInfo.setTitle(newsData.getTitle());
            indexInfo.setStartMemberId(newsData.getPublishUserId());
            indexInfo.setHasAttachment(newsData.getAttachmentsFlag());
            indexInfo.setTypeId(newsData.getTypeId());
            indexInfo.setContentCreateDate(newsData.getCreateDate());
            indexInfo.setEntityID(newsData.getId());
            
            String formatType = newsData.getDataFormat();
            if(com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_HTML.equals(formatType)){
                indexInfo.setContentType(IndexInfo.CONTENTTYPE_HTMLSTR);
                indexInfo.setContent(newsData.getContent());
            } 
            else
            {
                String contentPath = this.fileManager.getFolder(newsData.getCreateDate(), false);
                Partition partition = partitionManager.getPartition(newsData.getCreateDate(), true);
                 if(com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_OFFICE_WORD.equals(formatType)){
                    indexInfo.setContentType(IndexInfo.CONTENTTYPE_WORD);
                }else if(com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_OFFICE_EXCEL.equals(formatType)){
                    indexInfo.setContentType(IndexInfo.CONTENTTYPE_XLS);
                }
                else if(com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_WPS_WORD.equals(formatType)){
                    indexInfo.setContentType(IndexInfo.CONTENTTYPE_WPS_Word);
                }
                else if(com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_WPS_EXCEL.equals(formatType)){
                    indexInfo.setContentType(IndexInfo.CONTENTTYPE_WPS_EXCEL);
                }
                 indexInfo.setContentID(Long.parseLong(newsData.getContent()));
                 indexInfo.setContentAreaId(partition.getId().toString());
                 indexInfo.setContentPath(contentPath.substring(contentPath.length()-11)+System.getProperty("file.separator"));
            }
            
            StringBuilder newsKeyword = new StringBuilder();
            if(newsData.getKeywords() != null)
                newsKeyword.append(newsData.getKeywords());
            if(newsData.getBrief() != null)
                newsKeyword.append("  "+newsData.getBrief());
            
            if(newsData.getPublishDepartmentName()==null)
            {
                V3xOrgDepartment dept = orgManager.getEntityById(V3xOrgDepartment.class, member.getOrgDepartmentId());
                newsKeyword.append(" "+dept.getName());
            }else{
                newsKeyword.append(" "+newsData.getPublishDepartmentName());
            }
            
            indexInfo.setKeyword(newsKeyword.toString());
            indexInfo.setAppType(ApplicationCategoryEnum.news);
            indexInfo.setCreateDate(newsData.getPublishDate());//目前设定的是发布日期，此处存疑
            indexInfo.setAuthor(createUserName);
            AuthorizationInfo authorizationInfo=new AuthorizationInfo();
            if(newsData.getType().getSpaceType().intValue() == SpaceType.group.ordinal()) {
                List<String> owner=new ArrayList<String>();
                owner.add("ALL");
                authorizationInfo.setOwner(owner);
            }else {
                List<String> account=new ArrayList<String>();
                account.add(String.valueOf(newsData.getType().getAccountId()));
                authorizationInfo.setAccount(account);
            }
            indexInfo.setAuthorizationInfo(authorizationInfo);
            IndexUtil.convertToAccessory(indexInfo);
            
            return indexInfo;
    }
	
	/**
     * yangwulin Sprint4  2012-11-15  全文检索
     * 获取在某一段时期内，某一板块下已发布的公告总数
     * @param beginDate 
     * @param endDate 
     * @return
     */
    public Integer findIndexByDate(Date beginDate, Date endDate){
        return this.newsDataDao.findIndexByDate(beginDate, endDate);
    }
    
    /**
    * yangwulin Sprint4  全文检索
    */
   public List<Long> findDocSourcesList(Date starDate, Date endDate, Integer firstRow, Integer pageSize){
       return this.newsDataDao.findDocSourcesList(starDate, endDate, firstRow, pageSize);
   }
   
   	/**
   	 * 为M1提供接口：获取指定新闻板块中当前登陆用户有权限访问的新闻数
   	 * @param typeId 指定的新闻板块ID
   	 * @return 新闻数
   	 */
	public Long getNewsDatasCount(Long typeId) {
		User currentUser = AppContext.getCurrentUser();
		return newsDataDao.getNewsDatasCount(currentUser.getId(), typeId, currentUser.getLoginAccount());
	}
	
	public DataCache<NewsData> getNewsData(){
		return this.dataCache;
	}
    public void clickCache(Long dataId, Long userId) {
        this.dataCache.click(dataId, new ClickDetail(userId, new Timestamp(System.currentTimeMillis())));
        NewsData bean = this.dataCache.get(dataId);
        if (bean == null)
            return;
        synchronized (readCountLock) {
            bean.setReadCount(this.dataCache.getClickTotal(dataId));
        }
        //发送消息
        NotificationManager.getInstance().send(NotificationType.NewsClickArticle, new CacheInfo(dataId, userId));
    }

    public void syncCache(NewsData bean, int clickCount) {
        this.dataCache.save(bean.getId(), bean, bean.getPublishDate().getTime(), clickCount);
        //发送消息
        NotificationManager.getInstance().send(NotificationType.NewsModifyArticle,
                new CacheInfo(bean.getId(), clickCount));
    }
    
    public void removeCache(Long dataId){
        this.getNewsData().remove(dataId);
        //发送消息
        NotificationManager.getInstance().send(NotificationType.NewsDeleteArticle, dataId);
    }

	@Override
	public void initData(NewsData bean) {
		this.initDataFlag(bean,false);
	}

    public List<NewsType> getAllCustomTypes() {
        return newsTypeManager.getAllCustomTypes();
    }

    @Override
    @AjaxAccess
    public FlipInfo newsStc(FlipInfo fif, Map<String, Object> params) {
        String stcWay = params.get("stcWay").toString();
        FlipInfo fi = new FlipInfo();
        //"publishNum","publishMember","clickNum","voteNum","state"
        if ("publishNum".equals(stcWay)) {
            return newsPublishNumStc(fi, params);
        } else if ("publishMember".equals(stcWay)) {
            return newsPublishMemberStc(fi, params);
        } else if ("clickNum".equals(stcWay)) {
            return newsClickNumStc(fi, params);
        } else {//state
            return newsStateStc(fi, params);
        }
    }

    /**
     * 新闻发布量统计
     */
    public FlipInfo newsPublishNumStc(FlipInfo fif, Map<String, Object> params) {
        Map<String, Object> hparam = buildNewsParam(params);
        FlipInfo fip = new FlipInfo();
        if ("day".equals(params.get("stcBy"))) {//汇总
            StringBuilder hql = new StringBuilder("from NewsData news where news.publishDate >= :sDate and news.publishDate<=:eDate");
            hql.append(" and news.typeId=:typeId and news.deletedFlag=:deletedFlag and news.state in(:state) ");
            Integer count = DBAgent.count(hql.toString(), hparam);
            List<StcVo> stcList = new ArrayList<StcVo>();
            stcList.add(new StcVo(TypeCastUtil.toString(params.get("publishDateStart")) 
                    + " ~ " + TypeCastUtil.toString(params.get("publishDateEnd")), count));
            fip.setData(stcList);
        } else {//按月，年汇总
            hparam.put("dateBetween", 1);
            String stcBy = TypeCastUtil.toString(params.get("stcBy"));
            String[] sqlCols = new String[] { stcBy };
            String[] orderBys = new String[] { stcBy + " desc" };
            ParseStcXmlUtil.DbSql dbsql = ParseStcXmlUtil.buildDbSql("news", sqlCols, orderBys, "publishNum", hparam);
            List<Map<String, Object>> dataList = exeQuerySql(dbsql.getSql(), dbsql.getParamList());
            List<StcVo> stcList = ParamUtil.mapsToBeans(dataList, StcVo.class, false);
            buildNullTime(params,stcList);
            fip.setData(stcList);
        }
        return fip;
    }
    
    private Map<String, Object> buildNewsParam(Map<String, Object> params) {
        //spaceType = TypeCastUtil.toLong(params.get("spaceType")), spaceId = TypeCastUtil.toLong(params.get("spaceId"))
        Map<String, Object> hparam = new HashMap<String, Object>();
        hparam.put("typeId", TypeCastUtil.toLong(params.get("typeId")));
            hparam.put("deletedFlag", Boolean.FALSE);
            hparam.put("state", CommonTools.newArrayList(Constants.DATA_STATE_ALREADY_PUBLISH,
                    Constants.DATA_STATE_ALREADY_PIGEONHOLE));

        hparam.put("sDate", TypeCastUtil.toSDate(params.get("publishDateStart")));
        hparam.put("eDate", TypeCastUtil.toEDate(params.get("publishDateEnd")));
        if (!"day".equals(params.get("stcBy"))) {
            hparam.put("deletedFlag", 0);
        }
        return hparam;
    }
    
    private void buildNullTime(Map<String, Object> params, List<StcVo> stcList) {
        String stcBy = TypeCastUtil.toString(params.get("stcBy"));
        if("month".equals(stcBy)){
            Date sDate = TypeCastUtil.toDate(params.get("publishDateStart")), 
                 eDate = TypeCastUtil.toDate(params.get("publishDateEnd"));
            int monthDif = DateUtil.beforeMonths(sDate, eDate) +1 ;
            List<String> stcs = new ArrayList<String>();
            for (StcVo stcVo : stcList) {
                stcs.add(stcVo.getStcTime());
            }
            for (int i = 0; i < monthDif; i++) {
                Date cDate = DateUtil.addMonth(eDate, -i);
                String stcTime = DateUtil.format(cDate, "yyyy-MM");
                if (!stcs.contains(stcTime)) {
                    StcVo stcVo = new StcVo();
                    stcVo.setStcTime(stcTime);
                    stcList.add(stcVo);
                }
            }
        }else if("year".equals(stcBy)){
            int sYear = TypeCastUtil.toInteger(params.get("publishDateStart")), 
                eYear = TypeCastUtil.toInteger(params.get("publishDateEnd"));
            int yearNum = eYear - sYear + 1;
            List<String> stcs = new ArrayList<String>();
            for (StcVo stcVo : stcList) {
                stcs.add(stcVo.getStcTime());
            }
            
            for (int i = 0; i < yearNum; i++) {
                String cyear = String.valueOf(eYear - i);
                if (!stcs.contains(cyear)) {
                    StcVo stcVo = new StcVo();
                    stcVo.setStcTime(cyear);
                    stcList.add(stcVo);
                }
            }
        }
        
        if ("month".equals(stcBy) || "year".equals(stcBy)) {
            Collections.sort(stcList, new Comparator<StcVo>() {
                @Override
                public int compare(StcVo o1, StcVo o2) {
                    return (int)((TypeCastUtil.toDate(o2.getStcTime()).getTime() - TypeCastUtil.toDate(o1.getStcTime()).getTime())/1000);
                }
            });
        }
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
    
    
    /**
     * 新闻发起者统计
     */
    public FlipInfo newsPublishMemberStc(FlipInfo fif, Map<String, Object> params) {
        Map<String, Object> hparam = buildNewsParam(params);
        FlipInfo fi = new FlipInfo();
        if ("day".equals(params.get("stcBy"))) {//汇总
            String stcTo = TypeCastUtil.toString(params.get("stcTo"));
            String select = "m.orgDepartmentId as deptId,news.publishUserId as memberId,",
                   groupBy = ",m.orgDepartmentId,news.publishUserId ";
            if ("dept".equals(stcTo)) {
                select = "m.orgDepartmentId as deptId,";
                groupBy = ",m.orgDepartmentId ";
            } else if ("acc".equals(stcTo)) {
                select = "";
                groupBy = " ";
            }

            StringBuilder hql = new StringBuilder("select new map(m.orgAccountId as accId,");
            hql.append(select).append("count(*) as stcNum) ");
            hql.append("from NewsData news,OrgMember m ");
            hql.append("where news.publishUserId=m.id and news.publishDate >= :sDate and news.publishDate<=:eDate ");
            hql.append("and news.typeId=:typeId and news.deletedFlag=:deletedFlag and news.state in(:state) ");
            hql.append("group by m.orgAccountId").append(groupBy);
            hql.append("order by count(*) desc");
            List<Map<String, Object>> dataList = DBAgent.find(hql.toString(), hparam);
            List<StcVo> stcList = ParamUtil.mapsToBeans(dataList, StcVo.class, false);
            initOrgInfo(stcList,stcTo);
            fi.setData(stcList);
        } else {//按月，年汇总
            hparam.put("dateBetween", 1);
            String stcTo = TypeCastUtil.toString(params.get("stcTo"));//member,dept,account
            String stcBy = TypeCastUtil.toString(params.get("stcBy"));//month,year
            List<String> stcTos = CommonTools.newArrayList("acc", stcBy);
            if ("member".equals(stcTo)) {
                stcTos.add("dept");
                stcTos.add("member");
            } else if ("dept".equals(stcTo)) {
                stcTos.add("dept");
            }
            ParseStcXmlUtil.DbSql dbsql = ParseStcXmlUtil.buildDbSql("news", 
                  stcTos.toArray(new String[] {}), new String[] { stcBy }, "publishNum", hparam);
            List<Map<String, Object>> dataList = exeQuerySql(dbsql.getSql(), dbsql.getParamList());
            fi.setData(mergeToMap(dataList));
        }
        return fi;
    }
    
    private void initOrgInfo(List<StcVo> stcList, String stcTo) {
        try {
            for (StcVo stcVo : stcList) {
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
    
    private List<Map<String, Object>> mergeToMap(List<Map<String, Object>> dataList) {
        List<StcVo> stcList = ParamUtil.mapsToBeans(dataList, StcVo.class, false);
        List<StcVo> mergeList = new ArrayList<StcVo>();
        for (StcVo stc : stcList) {
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
        for (StcVo stc : mergeList) {
            mergeMap.add(stc.valueOfMap());
        }
        return mergeMap;
    }
    
    /**
     * 新闻点击数
     */
    public FlipInfo newsClickNumStc(FlipInfo fif, Map<String, Object> params) {
        StringBuilder hql = new StringBuilder("select new map(news.title as stcTitle,");
        hql.append("news.publishUserId as memberId,news.readCount as stcNum) ");
        hql.append("from NewsData news where news.publishDate >= :sDate and news.publishDate<=:eDate ");
        hql.append("and news.typeId=:typeId and news.deletedFlag=:deletedFlag and news.state in(:state) ");
        hql.append("order by news.readCount desc");
        FlipInfo fi = new FlipInfo();
        Map<String, Object> hparam = buildNewsParam(params);
        List<Map<String, Object>> dataList = DBAgent.find(hql.toString(), hparam);
        List<StcVo> stcList = ParamUtil.mapsToBeans(dataList, StcVo.class, false);
        initOrgInfo(stcList,null);
        fi.setData(stcList);
        return fi;
    }
    
    /**
     * 新闻状态
     */
    public FlipInfo newsStateStc(FlipInfo fif, Map<String, Object> params) {
        StringBuilder hql = new StringBuilder("select new map(news.state as state,count(*) as stcNum) ");
        hql.append("from NewsData news where news.publishDate >= :sDate and news.publishDate<=:eDate ");
        hql.append("and news.typeId=:typeId and news.deletedFlag=:deletedFlag and news.state in(:state) ");
        hql.append("group by news.state ");
        hql.append("order by news.state asc");
        FlipInfo fi = new FlipInfo();
        Map<String, Object> hparam = buildNewsParam(params);
        List<Map<String, Object>> dataList = DBAgent.find(hql.toString(), hparam);
        List<StcVo> stcList = ParamUtil.mapsToBeans(dataList, StcVo.class, false);
        buildNullState(stcList,"news");
        fi.setData(stcList);
        return fi;
    }
    
    private void buildNullState(List<StcVo> stcList, String mode) {
        List<Integer> stcs = new ArrayList<Integer>();
        List<Integer> states = new ArrayList<Integer>();
        for (StcVo stcVo : stcList) {
            stcs.add(stcVo.getState());
        }
        if ("news".equals(mode)) {
            states.add(Constants.DATA_STATE_ALREADY_PUBLISH);
            if (AppContext.hasPlugin("doc")) {
                states.add(Constants.DATA_STATE_ALREADY_PIGEONHOLE);
            }
        }

        for (Integer state : states) {
            if (!stcs.contains(state)) {
                StcVo stcVo = new StcVo();
                stcVo.setState(state);
                stcList.add(stcVo);
            }
        }

        Collections.sort(stcList, new Comparator<StcVo>() {
            @Override
            public int compare(StcVo o1, StcVo o2) {
                return o1.getState() - o2.getState();
            }
        });
    }
    
    @Override
    public Map<String, Object> getTypeByMode(String mode, String sTypeId) {
        Map<String, Object> show = new HashMap<String, Object>();
        Long typeId = TypeCastUtil.toLong(sTypeId);
        if ("news".equals(mode)) {
            NewsType type = DBAgent.get(NewsType.class, typeId);
            if (type != null) {
                List<Integer> showAccList = CommonTools.newArrayList(3, 4, 17);
                show.put("hideAcc", !showAccList.contains(type.getSpaceType()));
                show.put("hideDept", Boolean.FALSE);
            }
        }
        return show;
    }

	@Override
    public DataRecord expStcToXls(Map<String, Object> params) {
        String mode = TypeCastUtil.toString(params.get("mode"));//news,
        DataRecord record = new DataRecord();
        record.setTitle(TypeCastUtil.toString(params.get("title")));
        record.setSheetName("sheet1");
        List<?> datas= null;
        if ("news".equals(mode)) {
            datas = newsStc(null, params).getData();
        }
        List<String> nameIds = new ArrayList<String>();
        List<String> colNames = new ArrayList<String>();
        initColName2Id(nameIds,colNames,params);
        if (datas != null) {
            for (Object o : datas) {
                if (o instanceof StcVo) {
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
        String stcWay = TypeCastUtil.toString(params.get("stcWay"));//publishNum,state
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
            boolean isGroupStc = "true".equals(TypeCastUtil.toString(params.get("isGroupStc")));
            String stcTo = TypeCastUtil.toString(params.get("stcTo"));//member,dept,acc
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
            String stcBy = TypeCastUtil.toString(params.get("stcBy"));//day,month,year
            if ("month".equals(stcBy)) {
                nameIds.remove(nameIds.size() - 1);
                colNames.remove(colNames.size() - 1);
                Date sDate = TypeCastUtil.toDate(params.get("publishDateStart")), 
                     eDate = TypeCastUtil.toDate(params.get("publishDateEnd"));
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
                int sYear = TypeCastUtil.toInteger(params.get("publishDateStart")), 
                    eYear = TypeCastUtil.toInteger(params.get("publishDateEnd"));
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
            String value = TypeCastUtil.toString(row.get(name));
            if (Strings.isBlank(value) && name.indexOf("stcNum") != -1) {
                value = "0";
            }
            
            if ("state".equals(name) && Strings.isNotBlank(value)) {
                int state = Integer.parseInt(value);
                if ("news".equals(mode)) {
                    value = (state == 100) ? ResourceUtil.getString("news.stc.piged.js") :ResourceUtil.getString("news.stc.published.js");
                }
            }
            
            drow.addDataCell(value, DataCell.DATA_TYPE_TEXT);
        }
        return drow;
    }

    /******************************6.0******************************/

    public static final int DATA_TYPE_Image  = 0; //图片新闻

    public static final int DATA_TYPE_LATEST = 1; //最新新闻

    public static final int DATA_TYPE_TOP    = 2; //最热新闻

    public static final int DATA_TYPE_FOCUS  = 3; //焦点新闻

    public static final int DATA_TYPE_SEARCH  = 4; //新闻搜索
    /**
     * 获取最新新闻列表
     * @param params
     * @return
     * @throws BusinessException
     */
    @AjaxAccess
    public Map<String, Object> findListDatas(Map<String, Object> params) throws BusinessException {
        User user = AppContext.getCurrentUser();
        int pageSize = NumberUtils.toInt(params.get("pageSize").toString(), 20);
        int pageNo = NumberUtils.toInt(params.get("pageNo").toString(), 1);
        //列表类型
        String listType = params.get("listType").toString();
        String spaceType = params.get("spaceType").toString();
        String spaceId = params.get("spaceId").toString();
        String typeId = params.get("typeId") != null ? params.get("typeId").toString() : null;
        
        //搜索
        String condition = params.get("condition").toString();
        String textfield1 = "";
        String textfield2 = "";
        if(Strings.isNotBlank(condition)){
            textfield1 = params.get("textfield1").toString();
            textfield2 = params.get("textfield2").toString();
        }

        int firstResult = (pageNo - 1) * pageSize;
        int maxResult = pageSize;
        Map<String, Object> result = new HashMap<String, Object>();
        List<NewsData> list = null;
        String myNews = params.get("myNews") != null ? params.get("myNews").toString() : null;
        if("all".equals(myNews)){
            List<Long> myNewsTypeIds = findMyNewsTypeIds(user);
            list = this.queryListDatas(NumberUtils.toInt(listType), firstResult, maxResult, null, myNewsTypeIds, user.getId(), condition, textfield1, textfield2);
        }else {
            if (Strings.isNotBlank(typeId)) {
                list = this.queryListDatas(NumberUtils.toInt(listType), firstResult, maxResult, Long.valueOf(typeId), null, user.getId(), condition, textfield1, textfield2);
                result.put("typeId", typeId);
            } else {
                // 栏目内容来源选择板块，需要过滤
                List<Long> selectTypeList = null;
                if (params.containsKey("fragmentId")) {
                    String fragmentId = params.get("fragmentId").toString();
                    String ordinal = params.get("ordinal").toString();
                    Map<String, String> preference = portletEntityPropertyManager.getPropertys(
                            Long.parseLong(fragmentId), ordinal);
                    String panelValue = params.get("panelValue").toString();
                    if (Strings.isNotBlank(panelValue)) {
                        String designateTypeIds = preference.get(panelValue);
                        selectTypeList = CommonTools.parseStr2Ids(designateTypeIds);
                    }
                }
                
                List<Long> myNewsTypeIds = new ArrayList<Long>();
                if(selectTypeList !=null){
                    myNewsTypeIds = selectTypeList;
                }else{
                    myNewsTypeIds = getMyNewsTypeIds(NumberUtils.toInt(spaceType), NumberUtils.toLong(spaceId));
                }
                list = this.queryListDatas(NumberUtils.toInt(listType), firstResult, maxResult, null, myNewsTypeIds, user.getId(), condition, textfield1, textfield2);
                result.put("spaceType", spaceType);
                result.put("spaceId", spaceId);
            }
        }
        int size = Pagination.getRowCount();
        int pages = (size + pageSize - 1) / pageSize;
        if (pages < 1) {
            pages = 1;
        }

        result.put("size", size);
        result.put("pages", pages);
        result.put("pageNo", pageNo);
        result.put("list", this.NewsDataToVO(user.getId(), list));
        result.put("currentUserId", user.getId());
        return result;
    }

    public List<Long> getMyNewsTypeIds(int spaceType, Long spaceId) throws BusinessException {
        User user = AppContext.getCurrentUser();
        boolean isV5Member = AppContext.getCurrentUser().getExternalType() == OrgConstants.ExternalType.Inner.ordinal();
        Long accountId = AppContext.currentAccountId();
        if (!isV5Member) {
            accountId = OrgHelper.getVJoinAllowAccount();
        }
        List<NewsType> myNewsTypeList = new ArrayList<NewsType>();
        if (spaceType == SpaceType.public_custom_group.ordinal()) {//自定义集团空间
            List<NewsType> customNewsTypeList = getNewsTypeManager().findAllOfCustom(spaceId, "publicCustomGroup");
            myNewsTypeList.addAll(customNewsTypeList);
        } else if (spaceType == SpaceType.public_custom.ordinal()) {//自定义单位空间
            List<NewsType> customNewsTypeList = getNewsTypeManager().findAllOfCustom(spaceId, "publicCustom");
            myNewsTypeList.addAll(customNewsTypeList);
        }  else if (spaceType == SpaceType.custom.ordinal()) {//自定义团队空间
            NewsType customNewsType = getNewsTypeManager().getById(spaceId);
            myNewsTypeList.add(customNewsType);
        }  else if (spaceType == SpaceType.group.ordinal()) {//集团版块
            List<NewsType> groupNewsTypeList = getNewsTypeManager().groupFindAll();
            myNewsTypeList.addAll(groupNewsTypeList);
        } else if (spaceType == SpaceType.corporation.ordinal()) {//单位版块
            List<NewsType> accountNewsTypeList = getNewsTypeManager().findAll(accountId);
            myNewsTypeList.addAll(accountNewsTypeList);
        } else {
            // 集团版块
            List<NewsType> groupNewsTypeList = getNewsTypeManager().groupFindAll();
            myNewsTypeList.addAll(groupNewsTypeList);
            // 单位版块
            List<NewsType> accountNewsTypeList = getNewsTypeManager().findAll(accountId);
            myNewsTypeList.addAll(accountNewsTypeList);
        }
        List<Long> myNewsTypeIds = new ArrayList<Long>();
        if (Strings.isNotEmpty(myNewsTypeList)) {
            for (NewsType newsType : myNewsTypeList) {
                if (user.isInternal() || newsType.getOutterPermit()) {
                    myNewsTypeIds.add(newsType.getId());
                }
            }
        }
        return myNewsTypeIds;
    }

    //查询字段，顺序不能变，要加只能在最后追加
    private static final String SELECT_FIELD = "select t_data.id,t_data.title,t_data.brief,t_data.keywords,t_data.dataFormat,t_data.createDate,t_data.createUser,t_data.updateDate,t_data.updateUser,"
                                                     + "t_data.publishDate,t_data.publishUserId,t_data.publishScope,t_data.publishDepartmentId,t_data.showPublishUserFlag,t_data.auditDate,t_data.auditUserId,"
                                                     + "t_data.typeId,t_data.accountId,t_data.readCount,t_data.topOrder,t_data.state,t_data.ext4,t_data.ext5,t_data.attachmentsFlag,"
                                                     + "t_data.imageNews,t_data.focusNews,t_data.imageId,t_data.imgUrl,t_data.praise,t_data.praiseSum,t_data.replyNumber,t_data.replyTime,"
                                                     + "t_data.commentPermit,t_data.messagePermit,t_data.topNumberOrder";

    @SuppressWarnings("unchecked")
    public List<NewsData> queryListDatas(int listType, int firstResult, int maxResult, Long typeId, List<Long> myNewsTypeIds, Long memberId, String condition, String textfield1, String textfield2) throws BusinessException {
        Pagination.setFirstResult(firstResult);
        Pagination.setMaxResults(maxResult);
        Map<String, Object> params = new HashMap<String, Object>();
        StringBuilder sb = new StringBuilder();
        StringBuilder hqlStr = new StringBuilder();
        hqlStr.append(SELECT_FIELD).append(" from ").append(NewsData.class.getName()).append(" t_data ");
        sb.append(" where t_data.state=:state ");
        params.put("state", Constants.DATA_STATE_ALREADY_PUBLISH);
        if (typeId != null) {//单版块
            sb.append(" and t_data.typeId=:typeId ");
            params.put("typeId", typeId);
        } else {
            if (Strings.isEmpty(myNewsTypeIds)){
                return new ArrayList<NewsData>();
            }
            sb.append(" and t_data.typeId in (:myNewsTypeIds) ");
            params.put("myNewsTypeIds", myNewsTypeIds);
        }
        if(Strings.isNotEmpty(condition)){
            if("title".equals(condition) && Strings.isNotBlank(textfield1)){
                sb.append(" and t_data.title like :textfield1 ");
                params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
            }else if("publishDepartment".equals(condition) && Strings.isNotBlank(textfield1)){
                hqlStr.append(" ," + OrgUnit.class.getName() + " as m ");
                sb.append(" and m.id = t_data.publishDepartmentId and m.name like :textfield1");
                params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
            }else if("publishDate".equals(condition)){
                if(Strings.isNotBlank(textfield1)){
                    sb.append(" and t_data.publishDate >=:textfield1 ");
                    textfield1 = Datetimes.formatNoTimeZone(Datetimes.getFirstTime(Datetimes.parseNoTimeZone(textfield1+" 00:00:00",Datetimes.datetimeStyle)),Datetimes.datetimeStyle);
                    params.put("textfield1", Datetimes.parseNoTimeZone(SQLWildcardUtil.escape(textfield1), Datetimes.datetimeStyle));
                }
                if(Strings.isNotBlank(textfield2)){
                    sb.append(" and t_data.publishDate <=:textfield2 ");
                    textfield2 = Datetimes.formatNoTimeZone(Datetimes.getLastTime(Datetimes.parseNoTimeZone(textfield2+" 00:00:00",Datetimes.datetimeStyle)),Datetimes.datetimeStyle);
                    params.put("textfield2", Datetimes.parseNoTimeZone(SQLWildcardUtil.escape(textfield2), Datetimes.datetimeStyle));
                }
            }else if("publishUser".equals(condition) && Strings.isNotBlank(textfield1)){
                hqlStr.append(" ," + OrgMember.class.getName() + " as m ");
                sb.append(" and m.id = t_data.publishUserId and m.name like :textfield1 ");
                params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
            }
        }
        String orderBy = " order by ";
        String topNumberOrder = "";
        if (typeId != null) {
            topNumberOrder = " t_data.topNumberOrder desc, ";
        }
        if (listType == DATA_TYPE_LATEST) {//最新新闻
            sb.append(" and t_data.deletedFlag=false ");
            sb.append(orderBy);
            sb.append(topNumberOrder);
            sb.append(" t_data.publishDate desc");
        } else if (listType == DATA_TYPE_TOP) {//最热新闻
            sb.append(" and t_data.praiseSum >0 and t_data.deletedFlag=false ");
            sb.append(orderBy);
            sb.append(topNumberOrder);
            sb.append(" t_data.praiseSum desc, t_data.publishDate desc");
        } else if (listType == DATA_TYPE_FOCUS) {//焦点新闻
            sb.append(" and t_data.focusNews=true and t_data.deletedFlag=false ");
            sb.append(orderBy);
            sb.append(topNumberOrder);
            sb.append(" t_data.publishDate desc");
        } else if (listType == DATA_TYPE_Image) {//图片新闻
            sb.append(" and t_data.imageNews=true and t_data.praiseSum >0 and t_data.deletedFlag=false ");
            sb.append(orderBy);
            sb.append(topNumberOrder);
            sb.append(" t_data.praiseSum desc , t_data.publishDate desc");
        } else if (listType == DATA_TYPE_SEARCH) {//新闻搜索
            sb.append(" and t_data.deletedFlag=false ");
            sb.append(orderBy);
            sb.append(topNumberOrder);
            sb.append(" t_data.publishDate desc");
        }
        return NewsUtils.objArr2NewsData((List<Object[]>) newsDataDao.find(hqlStr.toString() + sb.toString(), params));
    }

    private List<NewsDataVO> NewsDataToVO(Long memberId, List<NewsData> list) {
        List<NewsDataVO> result = new ArrayList<NewsDataVO>();
        if (Strings.isNotEmpty(list)) {
        	newsReadManager.getReadState(list, memberId);
            for (NewsData newsData : list) {
                NewsDataVO newsDataVO = new NewsDataVO();
                //从缓存中查询
                NewsData cacheNewsData = getNewsData().get(newsData.getId());
                newsDataVO.setId(newsData.getId());
                newsDataVO.setTitle(newsData.getTitle());
                newsDataVO.setFuTitle(newsData.getFutitle());
                //获取内容
                NewsBody body = this.getBody(newsData.getId());
                String content=body.getContent();
                String brief="";
                if ("HTML".equals(body.getBodyType())) {
                    String temp="";
                    if (Strings.isNotBlank(content)) {
                        temp = StrExtractor.getHTMLContent(content);
                    }
                    if (temp.length() > 100) {
                        brief = temp.substring(0, 100) + "...";
                    } else {
                        brief = temp;
                    }
                }else if(Strings.isNotBlank(newsData.getExt5())){
                    brief = "[Pdf]";
                }else {
                    brief = "["+body.getBodyType()+"]";
                }
                if(Strings.isNotBlank(newsData.getExt4())){
                    brief = "";
                }
                newsDataVO.setContent(brief);
                if(Strings.isNotBlank(newsData.getExt5())) {
                    newsDataVO.setContentType(com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_PDF);
                } else {
                    newsDataVO.setContentType(body.getBodyType());
                }
                newsDataVO.setImageNews(newsData.isImageNews());
                if (newsData.isImageNews()) {
                    newsDataVO.setImageId(newsData.getImageId());
                    if (newsData.getImageId() != null) {
                        newsDataVO.setImageUrl(SystemEnvironment.getContextPath() + "/commonimage.do?method=showImage&id=" + newsData.getImageId() + "&size=custom&h=100&w=165");
                    }
                }
                
                newsDataVO.setFocusNews(newsData.isFocusNews());
                newsDataVO.setPublishUserId(newsData.getPublishUserId());
                newsDataVO.setPublishUserName(Functions.showMemberName(newsData.getPublishUserId()));
                newsDataVO.setPublishUserDepart(Functions.showDepartmentName(newsData.getPublishDepartmentId()));
                newsDataVO.setCreateDate(Datetimes.formatDatetimeWithoutSecond(newsData.getCreateDate()));
                newsDataVO.setPublishDate(newsData.getPublishDate());
                newsDataVO.setPublishDate1(Datetimes.formatDatetimeWithoutSecond(newsData.getPublishDate()));
                newsDataVO.setTypeId(newsData.getTypeId());
                newsDataVO.setAttachmentsFlag(newsData.getAttachmentsFlag());
                newsDataVO.setMessagePermit(newsData.getMessagePermit());
                NewsType newsType = newsTypeManager.getById(newsData.getTypeId());
                if (newsType != null) {
                    newsDataVO.setTypeName(newsType.getTypeName());
                    if (newsType.getCommentPermit()) {
                        newsDataVO.setCommentPermit(newsData.getCommentPermit());
                    } else {
                        newsDataVO.setCommentPermit(false);
                    }
                } else {
                    newsDataVO.setTypeName("");
                    log.warn("新闻版块为空");
                }
                //查看个数 从缓存中取
                if (cacheNewsData != null) {
                    newsDataVO.setReadCount(cacheNewsData.getReadCount());
                } else {
                    newsDataVO.setReadCount(newsData.getReadCount());
                }
                if (newsData.getPraiseSum() != null) {
                    newsDataVO.setPraiseSum(newsData.getPraiseSum());
                }
                if (newsData.getReplyNumber() != null) {
                    newsDataVO.setReplyNumber(newsData.getReplyNumber());
                }
                // 评论点赞标记
                String praise = newsData.getPraise();
                if (Strings.isBlank(praise)) {
                    newsDataVO.setPraiseFlag(false);
                } else if (praise.contains(String.valueOf(AppContext.currentUserId()))) {
                    newsDataVO.setPraiseFlag(true);
                } else {
                    newsDataVO.setPraiseFlag(false);
                }
                if (Strings.isNotBlank(newsData.getPraise())) {
                    String praiseMember = Functions.showOrgEntities(newsData.getPraise(), OrgConstants.ORGENT_TYPE.Member.name(), "、");
                    newsDataVO.setPraiseMember(praiseMember == null ? "" : praiseMember);
                    if (newsData.getPraise().contains(String.valueOf(memberId))) {
                        newsDataVO.setPraiseFlag(true);
                    }
                }
                newsDataVO.setReadFlag(newsData.getReadFlag());
                if (Strings.isNotBlank(String.valueOf(newsData.getTopOrder()))) {
                	newsDataVO.setTopNumberOrder(String.valueOf(newsData.getTopNumberOrder()));
                }
                result.add(newsDataVO);
            }
        }

        return result;
    }

    /**
     * 获取我发布的个数
     * @param memberId
     * @return
     * @throws BusinessException
     */
    public int getMyIssueCount(Long memberId,List<Long> typeIds) throws BusinessException {
        if(Strings.isNotEmpty(typeIds)){
            String hql = " from " + NewsData.class.getName() + " a where a.createUser=:memberId and a.state<>:state and a.deletedFlag=false and a.typeId in(:typeIds)";
            Map<String,Object> param = new HashMap<String, Object>();
            param.put("memberId",memberId);
            param.put("state",Constants.DATA_STATE_ALREADY_PIGEONHOLE);
            param.put("typeIds",typeIds);
            return newsDataDao.count(hql, param);
        }
        return 0;
    }

    /**
     * 获取我发布的列表
     * @param params
     * @return
     * @throws BusinessException
     */
    @AjaxAccess
    public FlipInfo findMyIssue(FlipInfo flipInfo, Map<String, String> query) throws BusinessException {
        String spaceTypeStr = query.get("spaceType");
        String spaceIdStr = query.get("spaceId");
        String condition = query.get("condition");
        String textfield1 = query.get("textfield1");
        String textfield2 = query.get("textfield2");
        User user = AppContext.getCurrentUser();
        Map<String, Object> params = new HashMap<String, Object>();
        StringBuffer hql = new StringBuffer();
        int spaceType = NumberUtils.toInt(spaceTypeStr);
        Long spaceId = NumberUtils.toLong(spaceIdStr);
        List<Long> typeIds = getMyNewsTypeIds(spaceType, spaceId);
        List<NewsDataVO> newsDataVO = new ArrayList<NewsDataVO>();
        if(Strings.isNotEmpty(typeIds)){
            StringBuffer SELECT = new StringBuffer("select t_data from " + NewsData.class.getName() + " t_data ");
            hql.append(" where t_data.createUser=:memberId and t_data.deletedFlag=false and t_data.typeId in(:typeIds) and t_data.state<>:state ");
            params.put("typeIds", typeIds);
            params.put("state", Constants.DATA_STATE_ALREADY_PIGEONHOLE);
            if(Strings.isNotEmpty(condition)){
                if("title".equals(condition) && Strings.isNotBlank(textfield1)){
                    hql.append(" and t_data.title like :textfield1");
                    params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
                }else if("typeName".equals(condition) && Strings.isNotBlank(textfield1)){
                    SELECT.append(" ," + NewsType.class.getName() + " as m ");
                    hql.append(" and m.id = t_data.typeId and m.typeName like :textfield1");
                    params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
                }else if("createDate".equals(condition)){
                    if(Strings.isNotBlank(textfield1)){
                        hql.append(" and t_data.createDate >=:textfield1 ");
                        params.put("textfield1", Datetimes.getTodayFirstTime(SQLWildcardUtil.escape(textfield1)));
                    }
                    if(Strings.isNotBlank(textfield2)){
                        hql.append(" and t_data.createDate <=:textfield2 ");
                        params.put("textfield2", Datetimes.getTodayLastTime(SQLWildcardUtil.escape(textfield2)));
                    }
                }else if("state".equals(condition) && Strings.isNotBlank(textfield1)){
                    if(Strings.isNotBlank(textfield1) && !"all".equals(textfield1)){
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
                }
            }
            params.put("memberId", user.getId());
            hql.append(" order by t_data.createDate desc");
            List<NewsData> newsData = DBAgent.find(SELECT.toString() + hql.toString(), params, flipInfo);
            newsDataVO = toNewsDataVO4MyInfo(newsData);
        }
        flipInfo.setData(newsDataVO);

        return flipInfo;
    }

    /**
     * 获取我评论的个数
     * @param memberId
     * @return
     * @throws BusinessException
     */
    public int getMyReplyCount(Long memberId, List<Long> myNewsTypeIds) throws BusinessException {
        if(Strings.isNotEmpty(myNewsTypeIds)){
            String hql = " from " + NewsReply.class.getName() + " a, " + NewsData.class.getName()
                    + " b where a.newsId=b.id and a.fromMemberId=:memberId and b.state=:state and b.deletedFlag=false and a.deleteFlag=0 and b.typeId in(:typeIds)";
            Map<String,Object> param = new HashMap<String, Object>();
            param.put("memberId",memberId);
            param.put("state",Constants.DATA_STATE_ALREADY_PUBLISH);
            param.put("typeIds",myNewsTypeIds);
            return newsDataDao.count(hql, param);
        }
        return 0;
    }

    /**
     * 获取我评论的列表
     * @param params
     * @return
     * @throws BusinessException
     */
    public Map<String, Object> findMyReply(int pageNo, int pageSize, List<Long> myNewsTypeIds) throws BusinessException {
        User user = AppContext.getCurrentUser();
        int firstResult = (pageNo - 1) * pageSize;
        int pages = 1;
        Pagination.setFirstResult(firstResult);
        Pagination.setMaxResults(pageSize);
        List<NewsReplyVO> newsReplyVO = new ArrayList<NewsReplyVO>();
        if(Strings.isNotEmpty(myNewsTypeIds)){
            List<NewsReply> newsReplyList = new ArrayList<NewsReply>();
            String hql = "select a from " + NewsReply.class.getName() + " a, " + NewsData.class.getName()
                    + " b where a.newsId=b.id and a.fromMemberId=:memberId and b.state=:state and b.deletedFlag=false and a.deleteFlag=0 and b.typeId in(:typeIds) order by a.createDate desc";
            Map<String,Object> param = new HashMap<String, Object>();
            param.put("memberId",user.getId());
            param.put("state",Constants.DATA_STATE_ALREADY_PUBLISH);
            param.put("typeIds",myNewsTypeIds);
            newsReplyList = (List<NewsReply>) newsDataDao.find(hql, param);
            int size = Pagination.getRowCount();
            pages = (size + pageSize - 1) / pageSize;
            if (pages < 1) {
                pages = 1;
            }
            for (NewsReply nd : newsReplyList) {
                NewsReplyVO vo = new NewsReplyVO(nd);
                NewsData newsData = getNewsData().get(nd.getNewsId());
                if(newsData==null){
                    newsData = getById(nd.getNewsId());
                }
                String subContent = nd.getReplayContent();
                if(Strings.isNotEmpty(subContent)){
                    if (subContent.length() > 200) {
                        subContent = subContent.substring(0, 200) + "...";
                    }
                    vo.setReplayContent(subContent);
                }
                vo.setReplayTitle(newsData.getTitle());
                //存放发布部门
                vo.setFromMemberName(Functions.showDepartmentName(newsData.getPublishDepartmentId()));
                vo.setToMemberName(Functions.showMemberNameOnly(nd.getToMemberId()));
                newsReplyVO.add(vo);
            }
        }
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("pages", pages);
        result.put("replyList", newsReplyVO);
        result.put("pageNo", pageNo);
        return result;
    }

    /**
     * 获取我收藏的个数
     * @param memberId
     * @return
     * @throws BusinessException
     */
    public int getMyCollectCount(Long memberId, List<Long> myNewsTypeIds) throws BusinessException {
        DocLibBO lib = docApi.getPersonalLibOfUser(AppContext.currentUserId());
        if(lib!=null && Strings.isNotEmpty(myNewsTypeIds)){
            String hql = "SELECT d, t.favoriteSource, t.createTime FROM DocResourcePO t, NewsData d WHERE t.favoriteSource=d.id AND t.docLibId=:libId AND t.frType=:frType AND t.favoriteSource IS NOT NULL  AND d.typeId in(:typeIds)";
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("libId", lib.getId());
            params.put("frType", DocConstants.SYSTEM_NEWS);
            params.put("typeIds", myNewsTypeIds);
            return newsDataDao.count(hql, params);
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
    public FlipInfo findMyCollect(FlipInfo flipInfo, Map<String, String> query) throws BusinessException {
        User user = AppContext.getCurrentUser();
        String spaceTypeStr = query.get("spaceType");
        String spaceIdStr = query.get("spaceId");
        String condition = query.get("condition");
        String textfield1 = query.get("textfield1");
        String textfield2 = query.get("textfield2");
         
        int spaceType = NumberUtils.toInt(spaceTypeStr);
        Long spaceId = NumberUtils.toLong(spaceIdStr);
        List<Long> typeIds = getMyNewsTypeIds(spaceType, spaceId);
        DocLibBO lib = docApi.getPersonalLibOfUser(AppContext.currentUserId());
        List<NewsDataVO> newsDataVO = new ArrayList<NewsDataVO>();
        if(lib!=null && Strings.isNotEmpty(typeIds)){
            Map<Object, Object> params = new HashMap<Object, Object>();
            StringBuffer SELECT = new StringBuffer("SELECT d, t.favoriteSource, t.createTime FROM DocResourcePO t, NewsData d ");
            StringBuffer hql = new StringBuffer("WHERE t.favoriteSource=d.id AND t.docLibId=:libId AND t.frType=:frType AND t.favoriteSource IS NOT NULL  AND d.typeId in(:typeIds)");
            params.put("libId", lib.getId());
            params.put("frType", DocConstants.SYSTEM_NEWS);
            params.put("typeIds", typeIds);
            if(Strings.isNotEmpty(condition)){
                if("title".equals(condition) && Strings.isNotBlank(textfield1)){
                    hql.append(" and d.title like :textfield1");
                    params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
                }else if("typeName".equals(condition) && Strings.isNotBlank(textfield1)){
                    SELECT.append(" ," + NewsType.class.getName() + " as m ");
                    hql.append(" and m.id = d.typeId and m.typeName like :textfield1");
                    params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
                }else if("collectDate".equals(condition)){
                    if(Strings.isNotBlank(textfield1)){
                        hql.append(" and t.createTime >=:textfield1 ");
                        params.put("textfield1", Datetimes.getTodayFirstTime(SQLWildcardUtil.escape(textfield1)));
                    }
                    if(Strings.isNotBlank(textfield2)){
                        hql.append(" and t.createTime <=:textfield2 ");
                        params.put("textfield2", Datetimes.getTodayLastTime(SQLWildcardUtil.escape(textfield2)));
                    }
                }else if("publishDept".equals(condition) && Strings.isNotBlank(textfield1)){
                    SELECT.append("," + OrgUnit.class.getName() + " as m " );
                    hql.append(" and d.publishDepartmentId = m.id and m.name like :textfield1 and m.type=:unitType ");
                    params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
                    params.put("unitType", OrgConstants.UnitType.Department.name());
                }
            }
            hql.append(" order by t.createTime desc");
            List<Object[]> list = DBAgent.find(SELECT.append(hql).toString(), params, flipInfo);
            if (Strings.isNotEmpty(list)) {
                for (Object[] obj : list) {
                    NewsData data = (NewsData) obj[0];
                    NewsDataVO vo = this.toOneNewsDataVO(data);
                    vo.setPublishDate((Date) obj[2]);
                    newsDataVO.add(vo);
                }
            }
        }

        flipInfo.setData(newsDataVO);
        return flipInfo;
    }

    /**
     * 获取新闻审核个数
     * @param memberId
     * @return
     * @throws BusinessException
     */
    public int getMyAuditCount(Long memberId, List<Long> typeIds) throws BusinessException {
        if(Strings.isNotEmpty(typeIds)){
            String hql = " from " + NewsData.class.getName() + " a , " + NewsType.class.getName()
                    + " b where a.typeId=b.id and b.auditUser=:memberId and (a.state=:state1 or a.state=:state2 or a.state=:state3 or a.state=:NOPASS_AUDIT) and a.deletedFlag=false and b.id in(:typeIds)";// 客开 gxy 20180704 添加审核不通过条件
            Map<String,Object> param = new HashMap<String, Object>();
            param.put("memberId",memberId);
            param.put("state1",Constants.DATA_STATE_ALREADY_CREATE);
            param.put("state2",Constants.DATA_STATE_TYPESETTING_CREATE);//审核通过显示待排版数据20180705 gxy 
            param.put("state3",Constants.DATA_STATE_ALREADY_PUBLISH);//审核通过显示已发布数据20180705 gxy 
            param.put("NOPASS_AUDIT", Constants.DATA_STATE_NOPASS_AUDIT);// 客开 gxy 20180704 添加审核不通过条件
            param.put("typeIds",typeIds);
            return newsDataDao.count(hql, param);
        }
        return 0;
    }

    //客开 start
    /**
     * 获取新闻排版个数
     * @param memberId
     * @return
     * @throws BusinessException
     */
    public int getMyTypesettingCount(Long memberId, List<Long> typeIds) throws BusinessException {
        if(Strings.isNotEmpty(typeIds)){
            String hql = " from " + NewsData.class.getName() + " a , " + NewsType.class.getName()
                    + " b where a.typeId=b.id and b.typesettingStaff=:memberId and (a.state=:state1 or a.state=:state2 or a.state=:TYPESETTING_NOPASS) and a.deletedFlag=false and b.id in(:typeIds)";//客开 gxy 20180704 添加排版不通过数条件
            Map<String,Object> param = new HashMap<String, Object>();
            param.put("memberId",memberId);
            param.put("state1",Constants.DATA_STATE_TYPESETTING_CREATE);
            param.put("state2",Constants.DATA_STATE_ALREADY_PUBLISH);//排版通过显示已发布数据20180705 gxy 
            param.put("TYPESETTING_NOPASS", Constants.DATA_STATE_TYPESETTING_NOPASS);////客开 gxy 20180704 添加排版不通过数条件
            param.put("typeIds",typeIds);
            return newsDataDao.count(hql, param);
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
        String spaceTypeStr = query.get("spaceType");
        String spaceIdStr = query.get("spaceId");
        String condition = query.get("condition");
        String textfield1 = query.get("textfield1");
        String textfield2 = query.get("textfield2");

        int spaceType = NumberUtils.toInt(spaceTypeStr);
        Long spaceId = NumberUtils.toLong(spaceIdStr);
        List<Long> typeIds = getMyNewsTypeIds(spaceType, spaceId);
        List<NewsDataVO> newsDataVO = new ArrayList<NewsDataVO>();
        if(Strings.isNotEmpty(typeIds)){
            List<NewsData> newsDataList = new ArrayList<NewsData>();
            Map<String, Object> params = new HashMap<String, Object>();
            StringBuffer SELECT = new StringBuffer("select t_data from " + NewsData.class.getName() + " t_data , " + NewsType.class.getName() + " t_type ");
            StringBuffer hql = new StringBuffer(" where t_data.typeId = t_type.id and t_type.typesettingStaff=:memberId and t_data.deletedFlag=false and t_type.id in(:typeIds) ");
            if(Strings.isNotEmpty(condition)){
                if("title".equals(condition) && Strings.isNotBlank(textfield1)){
                    hql.append(" and t_data.title like :textfield1 ");
                    params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
                }else if("typeName".equals(condition) && Strings.isNotBlank(textfield1)){
                    hql.append(" and t_type.id = t_data.typeId and t_type.typeName like :textfield1 ");
                    params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
                }else if("createUser".equals(condition) && Strings.isNotBlank(textfield1)){
                    SELECT.append(", " + OrgMember.class.getName() + " m ");
                    hql.append(" and m.id = t_data.createUser and m.name like :textfield1 ");
                    params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
                }else if("state".equals(condition) && Strings.isNotBlank(textfield1)){
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
                }
            }
            hql.append(" and (t_data.state=:already_create or t_data.state=:already_audit or t_data.state=:TYPESETTING_NOPASS)");//客开 gxy 20180704 添加排版不通过数据  or t_data.state=:TYPESETTING_NOPASS
            params.put("already_create", Constants.DATA_STATE_TYPESETTING_CREATE);
            params.put("already_audit", Constants.DATA_STATE_ALREADY_PUBLISH);//排版通过显示已发布数据  20180705 gxy
            params.put("TYPESETTING_NOPASS", Constants.DATA_STATE_TYPESETTING_NOPASS);////客开 gxy 20180704 添加排版不通过数条件
            hql.append(" order by t_data.createDate desc");
            params.put("memberId", user.getId());
            params.put("typeIds", typeIds);
            newsDataList = DBAgent.find(SELECT.append(hql).toString(), params, flipInfo); 

            newsDataVO = toNewsDataVO4MyInfo(newsDataList);
        }

        flipInfo.setData(newsDataVO);
        return flipInfo;
    }

    /**
     * 取消排版
     */
    @AjaxAccess
    public String cancelTypesetting(String ids) throws Exception {
        if (Strings.isBlank(ids))
            return null;
        String[] idArr = ids.split(",");
        User user = AppContext.getCurrentUser();
        Long userId = user.getId();
        String userName = user.getName();

        for (String sid : idArr) {
            long dataId = Long.valueOf(sid);
            NewsData bean = getById(dataId);
            if (bean == null)
                continue;
            NewsType beanType = bean.getType();
            if (bean.getState().intValue() != Constants.DATA_STATE_TYPESETTING_PASS)
                continue;
            bean.setAuditAdvice(null);
            bean.setState(Constants.DATA_STATE_TYPESETTING_CREATE);
            this.addPendingAffair(beanType, bean);

            //yangwulin 2012-10-26 取消排版
            updateDirect(bean);

            //取消排版发消息
            List<Long> auth = new ArrayList<Long>();
            auth.add(bean.getCreateUser());
            Collection<MessageReceiver> receivers = MessageReceiver.get(bean.getId(), auth);
            try {
                userMessageManager.sendSystemMessage(
                        MessageContent.get("news.cancel.typesetting", bean.getTitle(), userName),
                        ApplicationCategoryEnum.news, userId, receivers);
            } catch (BusinessException e) {
                log.error("新闻取消排版发消息失败", e);
            }

            //取消排版加日志
            appLogManager.insertLog(user, AppLogAction.News_CancelTypesetting, userName, bean.getTitle());
        }

        return null;
    }
    //客开 end

    /**
     * 获取新闻审核列表
     * @param params
     * @return
     * @throws BusinessException
     */
    @AjaxAccess
    public FlipInfo findMyAudit(FlipInfo flipInfo, Map<String, String> query) throws BusinessException {
        User user = AppContext.getCurrentUser();
        String spaceTypeStr = query.get("spaceType");
        String spaceIdStr = query.get("spaceId");
        String condition = query.get("condition");
        String textfield1 = query.get("textfield1");
        String textfield2 = query.get("textfield2");
        
        int spaceType = NumberUtils.toInt(spaceTypeStr);
        Long spaceId = NumberUtils.toLong(spaceIdStr);
        List<Long> typeIds = getMyNewsTypeIds(spaceType, spaceId);
        List<NewsDataVO> newsDataVO = new ArrayList<NewsDataVO>();
        if(Strings.isNotEmpty(typeIds)){
            List<NewsData> newsDataList = new ArrayList<NewsData>();
            Map<String, Object> params = new HashMap<String, Object>();
            StringBuffer SELECT = new StringBuffer("select t_data from " + NewsData.class.getName() + " t_data , " + NewsType.class.getName() + " t_type ");
            StringBuffer hql = new StringBuffer(" where t_data.typeId = t_type.id and t_type.auditUser=:memberId and t_data.deletedFlag=false and t_type.id in(:typeIds) ");
            if(Strings.isNotEmpty(condition)){
                if("title".equals(condition) && Strings.isNotBlank(textfield1)){
                    hql.append(" and t_data.title like :textfield1 ");
                    params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
                }else if("typeName".equals(condition) && Strings.isNotBlank(textfield1)){
                    hql.append(" and t_type.id = t_data.typeId and t_type.typeName like :textfield1 ");
                    params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
                }else if("createUser".equals(condition) && Strings.isNotBlank(textfield1)){
                    SELECT.append(", " + OrgMember.class.getName() + " m ");
                    hql.append(" and m.id = t_data.createUser and m.name like :textfield1 ");
                    params.put("textfield1", "%" + SQLWildcardUtil.escape(textfield1) + "%");
                }else if("state".equals(condition) && Strings.isNotBlank(textfield1)){
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
                }
            }
            hql.append(" and (t_data.state=:already_create or t_data.state=:already_audit or t_data.state=:already_audit1 or t_data.state=:NOPASS_AUDIT)");// 客开 gxy 20180704 添加审核不通过数据   or t_data.state=:NOPASS_AUDIT
            params.put("already_create", Constants.DATA_STATE_ALREADY_CREATE);
            params.put("already_audit", Constants.DATA_STATE_TYPESETTING_CREATE);//审核通过显示待排版数据 20180705 gxy	
            params.put("already_audit1", Constants.DATA_STATE_ALREADY_PUBLISH);//审核通过显示已发布数据 20180705 gxy	
            params.put("NOPASS_AUDIT", Constants.DATA_STATE_NOPASS_AUDIT);// 客开 gxy 20180704 添加审核不通过条件
            hql.append(" order by t_data.createDate desc");
            params.put("memberId", user.getId());
            params.put("typeIds", typeIds);
            newsDataList = DBAgent.find(SELECT.append(hql).toString(), params, flipInfo);
            
            newsDataVO = toNewsDataVO4MyInfo(newsDataList);
        }
        
        flipInfo.setData(newsDataVO);
        return flipInfo;
    }

    /**
     * 保存新闻
     * @param param
     * @return
     * @throws BusinessException
     */
    @AjaxAccess
    public String saveNews(Map<String, Object> param) throws BusinessException {
        return null;
    }

    /**
     * 发布新闻/取消发布新闻
     * @param param
     * @return
     * @throws BusinessException
     */
    @AjaxAccess
    public String issueNews(Map<String, Object> param) throws BusinessException {
        User user = AppContext.getCurrentUser();
        String idStr = param.get("ids").toString();
        String spaceId = param.get("typeId").toString();
        String custom = param.get("custom").toString();
        if (StringUtils.isBlank(idStr)) {
            idStr = "";
        }
        String publishFlag = param.get("publishFlag").toString();
        String[] idStrs = idStr.split(",");
        NewsType type = null;

        for (String str : idStrs) {
            if (StringUtils.isBlank(str))
                continue;

            NewsData bean = getNewsData().get(Long.valueOf(str));
            if (bean == null)
                bean = getById(Long.valueOf(str));
            if (bean == null)
                continue;
            type = bean.getType();

            List<Long> resultIds = new ArrayList<Long>();
            List<V3xOrgMember> listMemberId = new ArrayList<V3xOrgMember>();
            if ("true".equals(custom)) {
                listMemberId = spaceManager.getSpaceMemberBySecurity(bean.getTypeId(), -1);
            } else if (Strings.isNotBlank(spaceId)) {
                listMemberId = spaceManager.getSpaceMemberBySecurity(Long.parseLong(spaceId), -1);
            } else {
                listMemberId = this.newsUtils.getScopeMembers(type.getSpaceType(), user.getLoginAccount(),
                        type.getOutterPermit());
            }
            for (V3xOrgMember member : listMemberId) {
                resultIds.add(member.getId());
            }

            if ("publish".equals(publishFlag)) {
                if (bean.getState() == Constants.DATA_STATE_ALREADY_PUBLISH) {
                    continue;
                }
                boolean flag = false;
                if (type != null) {
                    List<Long> domainIds = orgManager.getAllUserDomainIDs(user.getId());
                    for (NewsTypeManagers tm : type.getNewsTypeManagers()) {
                        if (domainIds.contains(tm.getManagerId())) {
                            if (Constants.MANAGER_FALG.equals(tm.getExt1()) || Constants.WRITE_FALG.equals(tm.getExt1())) {
                                flag = true;
                                break;
                            }
                        }
                    }
                }
                if (!flag) {
                    return "" + ResourceUtil.getString("news.alert.dont.has.publish.permission");
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
                      return "" + ResourceBundleUtil.getString(Constants.NEWS_RESOURCE_BASENAME,
                              "news.audit.notaudityet");
                  }
                }
                if(bean.getState().intValue() ==Constants.DATA_STATE_TYPESETTING_PASS){
                  bean.setState(Constants.DATA_STATE_ALREADY_PUBLISH);
                }else if(bean.getState().intValue() ==Constants.DATA_STATE_ALREADY_AUDIT){
                  if (type != null && type.isTypesettingFlag() && type.getTypesettingStaff().intValue() != 0) {
                    bean.setState(Constants.DATA_STATE_TYPESETTING_CREATE);
                  }else{
                    bean.setState(Constants.DATA_STATE_ALREADY_PUBLISH);
                  }
                //客开  gxy 20180802 草稿新闻直接发布问题修改 start
                }else if(bean.getState().intValue() ==Constants.DATA_STATE_NO_SUBMIT){
                    if (type != null && type.isAuditFlag() && type.getAuditUser().intValue() != 0) {
                    	bean.setState(Constants.DATA_STATE_ALREADY_CREATE);
                    }else if (type != null && type.isTypesettingFlag() && type.getTypesettingStaff().intValue() != 0) {
                		bean.setState(Constants.DATA_STATE_TYPESETTING_CREATE);
                    }
                //客开  gxy 20180802 草稿新闻直接发布问题修改 end
                }else{
                  bean.setState(Constants.DATA_STATE_ALREADY_PUBLISH);
                }
                //客开 end

                //客开 start
                boolean hasOldBean = false;
                NewsData oldBean = null;
                if(bean.getOldId()!=null &&bean.getOldId().intValue()!=0){
                   oldBean = this.getById(Long.valueOf(bean.getOldId()));
                   hasOldBean = oldBean!=null?true:false;
                }
                if(hasOldBean){
                  //如果是二次发布且排版通过并发布，当前新闻内容覆盖之前的老新闻（除发布时间、发布人、查阅留痕等信息需要保留不变外），删除当前新闻
                  //title SPACETYPE  TYPE_ID
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
                  //删除老新闻的附件
                  for(Map.Entry<Long, Long> entry:oldFileUrlsMap.entrySet()){
                    attachmentManager.deleteById(entry.getValue());
                  }
                  
                  //把新新闻的附件指向老新闻
                  for(Attachment att:atts){
                    if(newAtts.contains(att.getFileUrl()))continue;
                    att.setReference(oldBean.getId());
                    att.setSubReference(oldBean.getId());
                    attachmentManager.update(att);
                  }
                  NewsBody body = newsBodyDao.get(bean.getId());
                  newsBodyDao.deleteByDataId(oldBean.getId());//删除老新闻的内容
                  body.setId(oldBean.getId());//把新新闻的内容复制到老新闻上
                  newsBodyDao.save(body);
                  //更新老新闻
                  oldBean.setTitle(bean.getTitle());
                  oldBean.setFutitle(bean.getFutitle());
                  oldBean.setSpaceType(bean.getSpaceType());
                  oldBean.setType(bean.getType());
                  oldBean.setTypeId(bean.getTypeId());
                  oldBean.setTypeName(bean.getTypeName());
                  oldBean.setPublishDepartmentId(bean.getPublishDepartmentId());
                  oldBean.setPublishDepartmentName(bean.getPublishDepartmentName());
                  oldBean.setBrief(bean.getBrief());
                  oldBean.setKeywords(bean.getKeywords());
                  oldBean.setShowPublishUserFlag(bean.isShowPublishUserFlag());
                  oldBean.setImgUrl(bean.getImgUrl());
                  oldBean.setImageId(bean.getImageId());
                  oldBean.setImageNews(bean.isImageNews());
                  oldBean.setShareWeixin(bean.getShareWeixin());
                  oldBean.setAttachmentsFlag(bean.getAttachmentsFlag());
                  oldBean.setAuditAdvice(bean.getAuditAdvice());
                  oldBean.setAuditAdvice1(bean.getAuditAdvice1());
                  oldBean.setAuditDate(bean.getAuditDate());
                  oldBean.setAuditDate1(bean.getAuditDate1());
                  oldBean.setAuditUserId(bean.getAuditUserId());
                  oldBean.setAuditUserId1(bean.getAuditUserId1());
                  this.updateDirect(oldBean);
                  //删除新新闻
                  this.delete(bean.getId());
                  // 删除待办
                  affairManager.deleteByObjectId(ApplicationCategoryEnum.news, bean.getId());
                  getNewsData().remove(oldBean.getId());
                  getNewsData().remove(bean.getId());
//                  getNewsData().save(oldBean.getId(), oldBean, oldBean.getPublishDate().getTime(), (oldBean.getReadCount() == null ? 0 : oldBean.getReadCount()));
                }else{
                  //客开 end
                  //如果该新闻类型无审核员，则其最终审核记录状态设置为"无审核"，否则设置为"审核通过" added by Meng Yang 2009-06-11
                  if (type != null && !type.isAuditFlag()) {
                      // 无审核员，设置为"无审核"
                      bean.setExt3(String.valueOf(Constants.AUDIT_RECORD_NO));
                  } else if (type != null && type.isAuditFlag()) {
                      // 有审核员，设置为"审核通过"
                      bean.setExt3(String.valueOf(Constants.AUDIT_RECORD_PASS));
                  }
                  //客开 start
                  if(bean.getState().intValue() == Constants.DATA_STATE_ALREADY_PUBLISH){
                    bean.setPublishDate(new Date());
//                    bean.setPublishUserId(AppContext.getCurrentUser().getId());
                    bean.setPublishUserId(bean.getCreateUser());
                  }
                  //客开 end
                  bean.setReadCount(0);
                  bean.setUpdateDate(new Date());
                  bean.setUpdateUser(AppContext.getCurrentUser().getId());
                  bean.setTopOrder(Byte.valueOf("1"));
                  // 取消置顶
                  bean.setTopOrder(Byte.valueOf("0"));
                  //取消点赞
                  bean.setPraiseSum(0);
                  bean.setPraise(null);
                  bean.setReplyTime(null);
                  this.updateDirect(bean);
                  //客开 start
                  if(bean.getState().intValue() == Constants.DATA_STATE_ALREADY_PUBLISH){
                    //触发发布事件
                    NewsAddEvent newsAddEvent = new NewsAddEvent(this);
                    newsAddEvent.setNewsDataBO(NewsUtils.newsDataPOToBO(bean));
                    EventDispatcher.fireEvent(newsAddEvent);
                    // 配置发布范围
                    this.getNewsReadManager().deleteReadByData(bean.getId());
                  }
                  // 这里加入全文检索
                  try {
                    if (AppContext.hasPlugin("index")) {
                      indexManager.add(bean.getId(), ApplicationCategoryEnum.news.getKey());
                    }
                  } catch (Exception e) {
                    log.error("全文检索失败", e);
                  }
                  // 直接发布加日志
                  appLogManager.insertLog(user, AppLogAction.News_Publish, user.getName(), bean.getTitle());
              }
            } else {
                removeCache(Long.valueOf(str));
                // 取消发布，回到草稿状态
                if (bean.getState() != Constants.DATA_STATE_ALREADY_PUBLISH)
                    continue;

                bean.setState(Constants.DATA_STATE_NO_SUBMIT);
                bean.setAuditAdvice(null);

                bean.setPublishDate(null);
                bean.setPublishUserId(null);
                bean.setReadCount(0);
                bean.setUpdateDate(null);
                bean.setUpdateUser(null);
                // 取消置顶
                bean.setTopOrder(Byte.valueOf("0"));
                //取消焦点
                bean.setFocusNews(false);
                //取消点赞
                bean.setPraiseSum(0);
                bean.setPraise(null);
                //判断该新闻版块允许评论 并且回复数大于0
                if(bean.getReplyNumber()>0){
                    newsReplyManager.deleteAllReplyByNewsId(bean.getId());
                }
                bean.setReplyNumber(0);
                bean.setReplyTime(null);
                
                this.updateDirect(bean);
                // 取消发布加日志
                appLogManager.insertLog(user, AppLogAction.News_CancelPublish, user.getName(), bean.getTitle());

                // 在此从全文检索库中删除
                try {
                    if (AppContext.hasPlugin("index")) {
                        indexManager.delete(bean.getId(), ApplicationCategoryEnum.news.getKey());
                    }

                } catch (Exception e) {
                    log.error("全文检索：", e);
                }
                //取消发布新闻发送系统消息
                userMessageManager.sendSystemMessage(
                        MessageContent.get("news.cancel.publish", bean.getTitle(), user.getName()).setBody(
                                this.getBody(bean.getId()).getContent(), bean.getDataFormat(), bean.getCreateDate()),
                        ApplicationCategoryEnum.news, user.getId(), MessageReceiver.getReceivers(bean.getId(),
                                resultIds, "", "", new Timestamp(System.currentTimeMillis()) + ""),
                        bean.getType().getId());
            }
            initDataFlag(bean, true);
            String deptName = bean.getPublishDepartmentName();
            // 发送审合通过消息消息进行发布
            if (bean.getState().equals(Constants.DATA_STATE_ALREADY_PUBLISH)) {
                userMessageManager.sendSystemMessage(
                        MessageContent.get("news.auditing", bean.getTitle(), deptName).setBody(
                                this.getBody(bean.getId()).getContent(), bean.getDataFormat(), bean.getCreateDate()),
                        ApplicationCategoryEnum.news, user.getId(),
                        MessageReceiver.getReceivers(bean.getId(), resultIds, "message.link.news.assessor.audit",
                                String.valueOf(bean.getId()), new Timestamp(System.currentTimeMillis()) + ""),
                        bean.getType().getId());

            }
        } // for循环结束

        return "ok";
    }

    /**
     * 审核新闻/取消审核新闻
     * @param param
     * @return
     * @throws BusinessException
     */
    @AjaxAccess
    public String auditNews(Map<String, Object> param) throws BusinessException {
        User user = AppContext.getCurrentUser();
        String idStr = param.get("newsId").toString();
        if (StringUtils.isBlank(idStr)) {
            throw new BusinessException("news_not_exists");
        }
        NewsData bean = getById(Long.valueOf(idStr));
        if(bean.isDeletedFlag()){
        	return "delete";
        }
        //处理审核两次的情况,只有是未审核的状态才允许审核操作
        if (bean.getState().intValue() != Constants.DATA_STATE_ALREADY_CREATE) {
            return "news.audit.already";
        }
        String form_oper = param.get("form_oper").toString();
        boolean hasOldBean = false;

        NewsData oldBean = null;
        if(bean.getOldId()!=null &&bean.getOldId().intValue()!=0){
           oldBean = this.getById(Long.valueOf(bean.getOldId()));
          if(oldBean!=null && StringUtils.isNotBlank(form_oper) && form_oper.equals("publish")){
            hasOldBean = true;
          }
        }
        NewsType type = this.getNewsTypeManager().getById(bean.getTypeId());
        boolean hasTypesetting = type != null && type.isTypesettingFlag() && type.getTypesettingStaff()!=null && type.getTypesettingStaff().intValue() !=0 && type.getTypesettingStaff().intValue()!=1;
  	  
  	  	if(hasOldBean && !hasTypesetting){
          //如果是二次发布且排版通过并发布，当前新闻内容覆盖之前的老新闻（除发布时间、发布人、查阅留痕等信息需要保留不变外），删除当前新闻
          //title SPACETYPE  TYPE_ID
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
          //删除老新闻的附件
          for(Map.Entry<Long, Long> entry:oldFileUrlsMap.entrySet()){
            attachmentManager.deleteById(entry.getValue());
          }
          //把新新闻的附件指向老新闻
          for(Attachment att:atts){
            if(newAtts.contains(att.getFileUrl()))continue;
            att.setReference(oldBean.getId());
            att.setSubReference(oldBean.getId());
            attachmentManager.update(att);
          }
          NewsBody body = newsBodyDao.get(bean.getId());
          newsBodyDao.deleteByDataId(oldBean.getId());//删除老新闻的内容
          body.setId(oldBean.getId());//把新新闻的内容复制到老新闻上
          newsBodyDao.save(body);
          //更新老新闻
          oldBean.setTitle(bean.getTitle());
          oldBean.setFutitle(bean.getFutitle());
          oldBean.setSpaceType(bean.getSpaceType());
          oldBean.setType(bean.getType());
          oldBean.setTypeId(bean.getTypeId());
          oldBean.setTypeName(bean.getTypeName());
          oldBean.setPublishDepartmentId(bean.getPublishDepartmentId());
          oldBean.setPublishDepartmentName(bean.getPublishDepartmentName());
          oldBean.setBrief(bean.getBrief());
          oldBean.setKeywords(bean.getKeywords());
          oldBean.setShowPublishUserFlag(bean.isShowPublishUserFlag());
          oldBean.setImgUrl(bean.getImgUrl());
          oldBean.setImageId(bean.getImageId());
          oldBean.setImageNews(bean.isImageNews());
          oldBean.setShareWeixin(bean.getShareWeixin());
          oldBean.setAttachmentsFlag(bean.getAttachmentsFlag());
          oldBean.setAuditAdvice(bean.getAuditAdvice());
          oldBean.setAuditAdvice1(bean.getAuditAdvice1());
          oldBean.setAuditDate(bean.getAuditDate());
          oldBean.setAuditDate1(bean.getAuditDate1());
          oldBean.setAuditUserId(bean.getAuditUserId());
          oldBean.setAuditUserId1(bean.getAuditUserId1());
          
        //客开 gxy 新闻发布时间可调整 start 20180712
          try {
        	  SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
              String editTime = param.get("editPublishDate").toString();
              if(editTime!=null && !"".equals(editTime)){
            	  Date date = format.parse(editTime);
            	  oldBean.setPublishDate(date);
              }
		  } catch (Exception e) {
			  log.error("发布时间调整异常", e);
		  }
        //客开 gxy 新闻发布时间可调整 start 20180712
          
          this.updateDirect(oldBean);
          //删除新新闻
          this.delete(bean.getId());
          // 删除待办
          affairManager.deleteByObjectId(ApplicationCategoryEnum.news, bean.getId());
          getNewsData().remove(oldBean.getId());
          getNewsData().remove(bean.getId());
//          getNewsData().save(oldBean.getId(), oldBean, oldBean.getPublishDate().getTime(), (oldBean.getReadCount() == null ? 0 : oldBean.getReadCount()));
          //对新闻文件进行解锁
          if (idStr != null && !"".equalsIgnoreCase(idStr))
            this.unlock(Long.valueOf(idStr));
        }else{
        
        
        if (StringUtils.isNotBlank(form_oper)) {
            if ("audit".equals(form_oper)) {
                //审核通过,但是没有发布,用记点的是通过
                bean.setState(Constants.DATA_STATE_ALREADY_AUDIT);
            } else if ("publish".equals(form_oper)) {
                //直接发布,用户点的是直接发布
              //客开 start
                if(type != null && type.isTypesettingFlag() && type.getTypesettingStaff()!=null && type.getTypesettingStaff().intValue() !=0 && type.getTypesettingStaff().intValue()!=1){
                  bean.setState(Constants.DATA_STATE_TYPESETTING_CREATE);
                //客开 gxy 新闻发布时间可调整 start 20180704
                  try {
                	  SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                      String editTime = param.get("editPublishDate").toString();
                      if(editTime==null || "".equals(editTime)){
                    	  bean.setPublishDate(new Date());
                      }else{
                    	  Date date = format.parse(editTime);
                          bean.setPublishDate(date);
                      }
                     
          		  } catch (ParseException e) {
          			  log.error("发布时间调整异常", e);
          		  }
                  //客开 gxy 新闻发布时间可调整 end 20180704
                }else{
                	//客开 gxy 新闻发布时间可调整 start 20180704
                    try {
                  	  SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                        String editTime = param.get("editPublishDate").toString();
                        if(editTime==null || "".equals(editTime)){
                      	  bean.setPublishDate(new Date());
                        }else{
                      	  Date date = format.parse(editTime);
                            bean.setPublishDate(date);
                        }
            		  } catch (ParseException e) {
            			  log.error("发布时间调整异常", e);
            		  }
                  //客开 gxy 新闻发布时间可调整 end 20180704
                  //bean.setPublishDate(new Date());
//                  bean.setPublishUserId(AppContext.getCurrentUser().getId());
                  bean.setPublishUserId(bean.getCreateUser());
                  bean.setState(Constants.DATA_STATE_ALREADY_PUBLISH);
                  bean.setTopOrder(Byte.parseByte("1"));
                }
                //客开 e
                bean.setExt3(String.valueOf(Constants.AUDIT_RECORD_PUBLISH));
            } else if ("noaudit".equals(form_oper)) {
                //审核不通过
                bean.setState(Constants.DATA_STATE_NOPASS_AUDIT);
            } else if ("cancelaudit".equals(form_oper)) {
                //用户点取消按钮了
                bean.setState(Constants.DATA_STATE_ALREADY_CREATE);
            }
        } else {
            //尚末提交,也就是暂存
            bean.setState(Constants.DATA_STATE_NO_SUBMIT);
        }


        bean.setAuditAdvice(param.get("auditAdvice").toString());
        bean.setAuditDate(new Date());
        bean.setAuditUserId(type.getAuditUser());

        bean.setUpdateDate(new Date());
        bean.setUpdateUser(user.getId());

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
//            summ.put("publishUserId", AppContext.getCurrentUser().getId());
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

        Long agentId = AgentUtil.getAgentByApp(type.getAuditUser(), ApplicationCategoryEnum.news.getKey());
        Long senderId = user.getId();
        String senderName = user.getName();
        int proxyType = 0;
        if (agentId != null && agentId.equals(senderId)) {
            proxyType = 1;
            senderId = type.getAuditUser();
            senderName = type.getAuditUserName();
        }

        // 发送审合通过消息消息
        if (bean.getState().equals(Constants.DATA_STATE_ALREADY_AUDIT)) {
            userMessageManager.sendSystemMessage(
                    MessageContent.get("news.alreadyauditing", bean.getTitle(), senderName, proxyType, user.getName()),
                    ApplicationCategoryEnum.news, senderId, MessageReceiver.get(bean.getId(), bean.getCreateUser(),
                            "message.link.news.writedetail", String.valueOf(bean.getId())),
                    bean.getTypeId());

            // 审合新闻通过加日志
            appLogManager.insertLog(user, AppLogAction.News_AuditPass, user.getName(), bean.getTitle());
        }
        // 发送审合没有通过消息消息
        if (bean.getState().equals(Constants.DATA_STATE_NOPASS_AUDIT)) {
            userMessageManager.sendSystemMessage(
                    MessageContent.get("news.not.alreadyauditing", bean.getTitle(), senderName, proxyType,
                            user.getName()),
                    ApplicationCategoryEnum.news, senderId, MessageReceiver.get(bean.getId(), bean.getCreateUser(),
                            "message.link.news.writedetail", String.valueOf(bean.getId())),
                    bean.getTypeId());

            // 审合新闻没有通过加日志
            appLogManager.insertLog(user, AppLogAction.News_AduitNotPass, user.getName(), bean.getTitle());
        }

        //修改管理员直接发布的不能全文检索。（这句代码3.5在下面if条件后面。这里应该是逻辑错误。）
        this.update(bean.getId(), summ);
        if (bean.getState() == Constants.DATA_STATE_ALREADY_PUBLISH) {
            //触发发布事件
            NewsAddEvent newsAddEvent = new NewsAddEvent(this);
            newsAddEvent.setNewsDataBO(NewsUtils.newsDataPOToBO(bean));
            EventDispatcher.fireEvent(newsAddEvent);
        }
        //触发审核事件
        NewsAuditEvent newsAuditEvent = new NewsAuditEvent(this);
        newsAuditEvent.setNewsDataBO(NewsUtils.newsDataPOToBO(bean));
        EventDispatcher.fireEvent(newsAuditEvent);
        // 审核员直接发送发送消息
        if (bean.getState().equals(Constants.DATA_STATE_ALREADY_PUBLISH)) {
            List<Long> resultIds = new ArrayList<Long>();

            List<V3xOrgMember> listMemberId = new ArrayList<V3xOrgMember>();
            Long typeId = bean.getAccountId();
            if (type.getSpaceType().intValue() == (SpaceType.public_custom.ordinal())
                    || type.getSpaceType().intValue() == (SpaceType.public_custom.ordinal())
                    || type.getSpaceType().intValue() == (SpaceType.public_custom_group.ordinal())) {
                listMemberId = spaceManager.getSpaceMemberBySecurity(typeId, -1);
            } else {
                listMemberId = this.newsUtils.getScopeMembers(type.getSpaceType(), user.getLoginAccount(),
                        type.getOutterPermit());
            }

            for (V3xOrgMember member : listMemberId) {
                resultIds.add(member.getId());
            }
            V3xOrgMember vom = orgManager.getMemberById(bean.getCreateUser());
            initDataFlag(bean, true);
            String deptName = bean.getPublishDepartmentName();
            userMessageManager.sendSystemMessage(
                    MessageContent.get("news.auditing", bean.getTitle(), deptName).setBody(
                            this.getBody(bean.getId()).getContent(), bean.getDataFormat(), bean.getCreateDate()),
                    ApplicationCategoryEnum.news, bean.getPublishUserId(),
                    MessageReceiver.getReceivers(bean.getId(), resultIds, "message.link.news.assessor.auditing",
                            //0表示用户从系统消息,网页等途径进行读取新闻(除在归档页面)
                            String.valueOf(bean.getId())),
                    bean.getTypeId());

            // 这里加入全文检索
            try {
                if (AppContext.hasPlugin("index")) {
                    indexManager.add(bean.getId(), ApplicationCategoryEnum.news.getKey());
                }
            } catch (Exception e) {
                log.error("全文检索: ", e);
            }

            // 直接发布加日志
            appLogManager.insertLog(user, AppLogAction.News_AuditPublish, user.getName(), bean.getTitle());

        }

        // 删除待办
        affairManager.deleteByObjectId(ApplicationCategoryEnum.news, bean.getId());
        //对新闻文件进行解锁
        if (idStr != null && !"".equalsIgnoreCase(idStr)) {
            unlock(Long.valueOf(idStr));
        }
        }
        return "ok";
    }
    //客开start
    /**
     * 新闻排版审核
     * @param param
     * @return
     * @throws BusinessException
     */
    @AjaxAccess
    public String auditNews2(Map<String, Object> param) throws BusinessException {
      User user = AppContext.getCurrentUser();
      String idStr = param.get("newsId").toString();
      if (StringUtils.isBlank(idStr)) {
        throw new BusinessException("news_not_exists");
      }
      NewsData bean = getById(Long.valueOf(idStr));
      //处理排版两次的情况,只有是未排版的状态才允许排版操作
      if (bean.getState().intValue() != Constants.DATA_STATE_TYPESETTING_CREATE) {
        return "news.audit.already";
      }
      boolean hasOldBean = false;
      String form_oper = param.get("form_oper").toString();
      NewsData oldBean = null;
      if(bean.getOldId()!=null &&bean.getOldId().intValue()!=0){
         oldBean = this.getById(Long.valueOf(bean.getOldId()));
        if(oldBean!=null && StringUtils.isNotBlank(form_oper) && form_oper.equals("publish")){
          hasOldBean = true;
        }
      }
      if(hasOldBean){
        //如果是二次发布且排版通过并发布，当前新闻内容覆盖之前的老新闻（除发布时间、发布人、查阅留痕等信息需要保留不变外），删除当前新闻
        //title SPACETYPE  TYPE_ID
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
        //删除老新闻的附件
        for(Map.Entry<Long, Long> entry:oldFileUrlsMap.entrySet()){
          attachmentManager.deleteById(entry.getValue());
        }
        //把新新闻的附件指向老新闻
        for(Attachment att:atts){
          if(newAtts.contains(att.getFileUrl()))continue;
          att.setReference(oldBean.getId());
          att.setSubReference(oldBean.getId());
          attachmentManager.update(att);
        }
        NewsBody body = newsBodyDao.get(bean.getId());
        newsBodyDao.deleteByDataId(oldBean.getId());//删除老新闻的内容
        body.setId(oldBean.getId());//把新新闻的内容复制到老新闻上
        newsBodyDao.save(body);
        //更新老新闻
        oldBean.setTitle(bean.getTitle());
        oldBean.setFutitle(bean.getFutitle());
        oldBean.setSpaceType(bean.getSpaceType());
        oldBean.setType(bean.getType());
        oldBean.setTypeId(bean.getTypeId());
        oldBean.setTypeName(bean.getTypeName());
        oldBean.setPublishDepartmentId(bean.getPublishDepartmentId());
        oldBean.setPublishDepartmentName(bean.getPublishDepartmentName());
        oldBean.setBrief(bean.getBrief());
        oldBean.setKeywords(bean.getKeywords());
        oldBean.setShowPublishUserFlag(bean.isShowPublishUserFlag());
        oldBean.setImgUrl(bean.getImgUrl());
        oldBean.setImageId(bean.getImageId());
        oldBean.setImageNews(bean.isImageNews());
        oldBean.setShareWeixin(bean.getShareWeixin());
        oldBean.setAttachmentsFlag(bean.getAttachmentsFlag());
        oldBean.setAuditAdvice(bean.getAuditAdvice());
        oldBean.setAuditAdvice1(bean.getAuditAdvice1());
        oldBean.setAuditDate(bean.getAuditDate());
        oldBean.setAuditDate1(bean.getAuditDate1());
        oldBean.setAuditUserId(bean.getAuditUserId());
        oldBean.setAuditUserId1(bean.getAuditUserId1());
        
      //客开 gxy 新闻发布时间可调整 start 20180712
        try {
      	  SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            String editTime = param.get("editPublishDate").toString();
            if(editTime!=null && !"".equals(editTime)){
          	  Date date = format.parse(editTime);
          	  oldBean.setPublishDate(date);
            }
		  } catch (Exception e) {
			  log.error("发布时间调整异常", e);
		  }
      //客开 gxy 新闻发布时间可调整 start 20180712
        
        this.updateDirect(oldBean);
        //删除新新闻
        this.delete(bean.getId());
        // 删除待办
        affairManager.deleteByObjectId(ApplicationCategoryEnum.news, bean.getId());
        getNewsData().remove(oldBean.getId());
        getNewsData().remove(bean.getId());
//        getNewsData().save(oldBean.getId(), oldBean, oldBean.getPublishDate().getTime(), (oldBean.getReadCount() == null ? 0 : oldBean.getReadCount()));
        //对新闻文件进行解锁
        if (idStr != null && !"".equalsIgnoreCase(idStr))
          this.unlock(Long.valueOf(idStr));
      }else{
        if (StringUtils.isNotBlank(form_oper)) {
          if ("audit".equals(form_oper)) {
            //审核通过,但是没有发布,用记点的是通过
            bean.setState(Constants.DATA_STATE_TYPESETTING_PASS);
          } else if ("publish".equals(form_oper)) {
            //直接发布,用户点的是直接发布
        	//客开 gxy 新闻发布时间可调整 start
              
              try {
            	  SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                  String editTime = param.get("editPublishDate").toString();
                  if(editTime==null || "".equals(editTime)){
                	  bean.setPublishDate(new Date());
                  }else{
                	  Date date = format.parse(editTime);
                      bean.setPublishDate(date);
                  }
			  } catch (ParseException e) {
				  log.error("发布时间调整异常", e);
			  }
              
              //bean.setPublishDate(new Date());
              //客开 gxy 新闻发布时间可调整 end
//            bean.setPublishUserId(AppContext.getCurrentUser().getId());
            bean.setPublishUserId(bean.getCreateUser());
            bean.setState(Constants.DATA_STATE_ALREADY_PUBLISH);
            bean.setTopOrder(Byte.parseByte("1"));
            bean.setExt1(String.valueOf(Constants.TYPESETTING_RECORD_PUBLISH));
          } else if ("noaudit".equals(form_oper)) {
            //审核不通过
            bean.setState(Constants.DATA_STATE_TYPESETTING_NOPASS);
          } else if ("cancelaudit".equals(form_oper)) {
            //用户点取消按钮了
            bean.setState(Constants.DATA_STATE_TYPESETTING_CREATE);
          }
        } else {
          //尚末提交,也就是暂存
          bean.setState(Constants.DATA_STATE_NO_SUBMIT);
        }

        NewsType type = this.getNewsTypeManager().getById(bean.getTypeId());
        bean.setAuditAdvice1(param.get("auditAdvice").toString());
        bean.setAuditDate1(new Date());
        bean.setAuditUserId1(type.getTypesettingStaff());

        bean.setUpdateDate(new Date());
        bean.setUpdateUser(user.getId());

        Map<String, Object> summ = new HashMap<String, Object>();
        summ.put("state", bean.getState());

        if ("publish".equals(form_oper)) {
          summ.put("publishDate", bean.getPublishDate());
//          summ.put("publishUserId", AppContext.getCurrentUser().getId());
          summ.put("publishUserId", bean.getCreateUser());
          summ.put("ext1", bean.getExt1());
        }
        summ.put("auditAdvice1", bean.getAuditAdvice1());
        summ.put("auditDate1", bean.getAuditDate1());
        summ.put("auditUserId1", bean.getAuditUserId1());
        summ.put("updateDate", bean.getUpdateDate());
        summ.put("updateUser", bean.getUpdateUser());

        Long agentId = AgentUtil.getAgentByApp(type.getAuditUser(), ApplicationCategoryEnum.news.getKey());
        Long senderId = user.getId();
        String senderName = user.getName();
        int proxyType = 0;
        if (agentId != null && agentId.equals(senderId)) {
          proxyType = 1;
          senderId = type.getAuditUser();
          senderName = type.getAuditUserName();
        }

        // 发送审合通过消息消息
        if (bean.getState().equals(Constants.DATA_STATE_TYPESETTING_PASS)) {
          userMessageManager.sendSystemMessage(
              MessageContent.get("news.alreadyauditing", bean.getTitle(), senderName, proxyType, user.getName()),
              ApplicationCategoryEnum.news, senderId, MessageReceiver.get(bean.getId(), bean.getCreateUser(),
                  "message.link.news.writedetail", String.valueOf(bean.getId())),
                  bean.getTypeId());

          // 审合新闻通过加日志
          appLogManager.insertLog(user, AppLogAction.News_TypesettingPass, user.getName(), bean.getTitle());
        }
        // 发送审合没有通过消息消息
        if (bean.getState().equals(Constants.DATA_STATE_TYPESETTING_NOPASS)) {
          userMessageManager.sendSystemMessage(
              MessageContent.get("news.not.alreadyauditing", bean.getTitle(), senderName, proxyType,
                  user.getName()),
                  ApplicationCategoryEnum.news, senderId, MessageReceiver.get(bean.getId(), bean.getCreateUser(),
                      "message.link.news.writedetail", String.valueOf(bean.getId())),
                      bean.getTypeId());

          // 审合新闻没有通过加日志
          appLogManager.insertLog(user, AppLogAction.News_TypesettingNotPass, user.getName(), bean.getTitle());
        }

        //修改管理员直接发布的不能全文检索。（这句代码3.5在下面if条件后面。这里应该是逻辑错误。）
        this.update(bean.getId(), summ);
        if (bean.getState() == Constants.DATA_STATE_ALREADY_PUBLISH) {
          //触发发布事件
          NewsAddEvent newsAddEvent = new NewsAddEvent(this);
          newsAddEvent.setNewsDataBO(NewsUtils.newsDataPOToBO(bean));
          EventDispatcher.fireEvent(newsAddEvent);
        }
        //触发审核事件
        NewsAuditEvent newsAuditEvent = new NewsAuditEvent(this);
        newsAuditEvent.setNewsDataBO(NewsUtils.newsDataPOToBO(bean));
        EventDispatcher.fireEvent(newsAuditEvent);
        // 审核员直接发送发送消息
        if (bean.getState().equals(Constants.DATA_STATE_ALREADY_PUBLISH)) {
          List<Long> resultIds = new ArrayList<Long>();

          List<V3xOrgMember> listMemberId = new ArrayList<V3xOrgMember>();
          Long typeId = bean.getAccountId();
          if (type.getSpaceType().intValue() == (SpaceType.public_custom.ordinal())
              || type.getSpaceType().intValue() == (SpaceType.public_custom.ordinal())
              || type.getSpaceType().intValue() == (SpaceType.public_custom_group.ordinal())) {
            listMemberId = spaceManager.getSpaceMemberBySecurity(typeId, -1);
          } else {
            listMemberId = this.newsUtils.getScopeMembers(type.getSpaceType(), user.getLoginAccount(),
                type.getOutterPermit());
          }

          for (V3xOrgMember member : listMemberId) {
            resultIds.add(member.getId());
          }
          V3xOrgMember vom = orgManager.getMemberById(bean.getCreateUser());
          initDataFlag(bean, true);
          String deptName = bean.getPublishDepartmentName();
          userMessageManager.sendSystemMessage(
              MessageContent.get("news.auditing", bean.getTitle(), deptName).setBody(
                  this.getBody(bean.getId()).getContent(), bean.getDataFormat(), bean.getCreateDate()),
                  ApplicationCategoryEnum.news, bean.getPublishUserId(),
                  MessageReceiver.getReceivers(bean.getId(), resultIds, "message.link.news.assessor.auditing",
                      //0表示用户从系统消息,网页等途径进行读取新闻(除在归档页面)
                      String.valueOf(bean.getId())),
                      bean.getTypeId());

          // 这里加入全文检索
          try {
            if (AppContext.hasPlugin("index")) {
              indexManager.add(bean.getId(), ApplicationCategoryEnum.news.getKey());
            }
          } catch (Exception e) {
            log.error("全文检索: ", e);
          }

          // 直接发布加日志
          appLogManager.insertLog(user, AppLogAction.News_AuditPublish, user.getName(), bean.getTitle());

        }

        // 删除待办
        affairManager.deleteByObjectId(ApplicationCategoryEnum.news, bean.getId());
        //对新闻文件进行解锁
        if (idStr != null && !"".equalsIgnoreCase(idStr)) {
          unlock(Long.valueOf(idStr));
        }
      }
      return "ok";
    }
    //客开 end

    /**
     * 删除新闻
     * @param param
     * @return
     * @throws BusinessException
     */
    @AjaxAccess
    public String deleteNews(Map<String, Object> param) throws BusinessException {
        User user = AppContext.getCurrentUser();
        String userName = user.getName();
        String idStr = param.get("newsIds").toString();

        if (Strings.isNotBlank(idStr)) {
            String[] idStrs = idStr.split(",");
            for (String id : idStrs) {
                if (StringUtils.isNotBlank(id)) {
                    NewsData bean = getById(Long.valueOf(id));
                    try {
                        if (bean == null) {
                            continue;
                        }
                        boolean isAdmin = newsTypeManager.isManagerOfType(bean.getTypeId(), user.getId());
                        if (!user.getId().equals(bean.getCreateUser()) && !isAdmin) {
                            return "-1";
                        }
                        if (bean.isFocusNews() && !isAdmin) {
                            return "isFocus";
                        }
                        
                        // 已经提交审核的需要发送消息，删除待办
                        if (bean.getState().intValue() == Constants.DATA_STATE_ALREADY_CREATE) {
                            affairManager.deleteByObjectId(ApplicationCategoryEnum.news, bean.getId());

                            userMessageManager.sendSystemMessage(MessageContent.get("news.delete", bean.getTitle(), userName), ApplicationCategoryEnum.news, user.getId(),
                                    MessageReceiver.get(bean.getId(), bean.getType().getAuditUser()), bean.getTypeId());
                        }
                        try {
                            //删除全文检索信息
                            if (bean.getState().intValue() == Constants.DATA_STATE_ALREADY_PUBLISH) {
                                indexManager.delete(bean.getId(), ApplicationCategoryEnum.news.getKey());
                            }
                        } catch (Exception e) {
                            log.error(e);
                        }
                        appLogManager.insertLog(user, AppLogAction.News_Delete, userName, bean.getTitle());
                        bean.setDeletedFlag(true);
                        this.updateDirect(bean);
                        //从缓存中清理被真实删除的新闻，以免二者出现不同步的现象
                        removeCache(Long.valueOf(id));

                    } catch (BusinessException e) {
                        break;
                    }
                }
            }
        }
        return "";
    }

    /**
     * 删除回复
     * @param param
     * @return
     * @throws BusinessException
     */
    @AjaxAccess
    public String deleteReply(Map<String, Object> param) throws BusinessException {
        return null;
    }

    /**
     * 设置焦点/取消设置焦点
     * @param param
     * @return
     * @throws BusinessException
     */
    @AjaxAccess
    public String setFocus(Map<String, Object> param) throws BusinessException {
        String idStr = param.get("newsIds").toString();
        boolean focusFlag = (Boolean)param.get("focusFlag");
        if (StringUtils.isNotBlank(idStr)) {
            List<Long> ids = CommonTools.parseStr2Ids(idStr);
            if (Strings.isNotEmpty(ids)) {
                for (Long id : ids) {
                    NewsData newsData = getById(id);
                    if (focusFlag) {
                        newsData.setFocusNews(true);
                        updateDirect(newsData);
                    } else {
                        newsData.setFocusNews(false);
                        updateDirect(newsData);
                    }
                    //更新缓存
                    removeCache(id);
                }
            }
        }
        return "";
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
        String ids = param.get("newsIds").toString();
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
                        appLogManager.insertLog(user, AppLogAction.News_Pigeonhole, userName, res.getFrName(),
                                folderName);
                    }
                    idList.add(Long.valueOf(idA[i]));
                    // 更新缓存中新闻的状态为归档,防止通过系统提示信息查看归档后的新闻
                    Long longID = Long.valueOf(idA[i]);
                    NewsData bean = getNewsData().get(longID);
                    if (bean != null) {
                        bean.setState(Constants.DATA_STATE_ALREADY_PIGEONHOLE);
                        getNewsData().save(longID, bean, bean.getPublishDate().getTime(),
                                (bean.getReadCount() == null ? 0 : bean.getReadCount()));
                    }
                }
            }
            this.pigeonhole(idList);
        }
        return "";
    }

    /**
     * 设置移动
     * @param param
     * @return
     * @throws BusinessException
     */
    @AjaxAccess
    public String setMove(Map<String, Object> param) throws BusinessException {
        return null;
    }

    @Override
    public Integer getNewsNumber4Type(Long boardId) {
        String hql = "from "+NewsData.class.getName()+" as a where a.typeId=? and a.state=? and a.deletedFlag=false";
        return newsDataDao.count(hql, null, boardId, Constants.DATA_STATE_ALREADY_PUBLISH);
    }

    @Override
    public Integer getNewsReplyNumber4Type(Long boardId) {
        String hql = "select sum(a.replyNumber) from " + NewsData.class.getName()
                + " as a where a.typeId=? and a.state=? and a.deletedFlag=false group by a.typeId";
        Integer total = 0;
        Number num = (Number) newsDataDao.findUnique(hql, null, boardId,
                Constants.DATA_STATE_ALREADY_PUBLISH);
        if(num!=null){
            total = num.intValue();
        }else{
            total = 0;
        }
        return total;
    }
    
    private List<NewsDataVO> toNewsDataVO4MyInfo(List<NewsData> newsData){
        List<NewsDataVO> newsDataVO = new ArrayList<NewsDataVO>();
        for(NewsData data : newsData){
            newsDataVO.add(toOneNewsDataVO(data));
        }
        return newsDataVO;
    }

    private NewsDataVO toOneNewsDataVO(NewsData data) {
        NewsDataVO vo = new NewsDataVO();
        vo.setId(data.getId());
        vo.setTitle(data.getTitle());
        vo.setFuTitle(data.getFutitle());
        NewsType newsType = newsTypeManager.getById(data.getTypeId());
        if (newsType != null) {
            vo.setTypeName(newsType.getTypeName());
            vo.setAuditFlag(newsType.isAuditFlag());
        } else {
            vo.setAuditFlag(false);
            vo.setTypeName("");
        }
        //获取内容
        NewsBody body = this.getBody(data.getId());
        if(Strings.isNotBlank(data.getExt5())) {
            vo.setContentType(com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_PDF);
        } else {
            vo.setContentType(body.getBodyType());
        }
        vo.setPublishUserId(data.getPublishUserId());
        vo.setPublishUserName(Functions.showMemberName(data.getPublishUserId()));
        vo.setCreateUserName(Functions.showMemberName(data.getCreateUser()));
        vo.setPublishUserDepart(Functions.showDepartmentName(data.getPublishDepartmentId()));
        vo.setCreateDate(Datetimes.formatDatetimeWithoutSecond(data.getCreateDate()));
        vo.setPublishDate(data.getPublishDate());
        vo.setImageNews(data.isImageNews());
        vo.setFocusNews(data.isFocusNews());
        vo.setAttachmentsFlag(data.getAttachmentsFlag());
        vo.setTypeId(data.getTypeId());
        vo.setState(data.getState());
        
        return vo;
    }
    /**
     * 取消审核
     */
    @AjaxAccess
    public String cancelAudit(String ids) throws Exception {
        if (Strings.isBlank(ids))
            return null;
        String[] idArr = ids.split(",");
        User user = AppContext.getCurrentUser();
        Long userId = user.getId();
        String userName = user.getName();

        for (String sid : idArr) {
            long dataId = Long.valueOf(sid);
            NewsData bean = getById(dataId);
            if (bean == null)
                continue;
            NewsType beanType = bean.getType();
            if (bean.getState().intValue() != Constants.DATA_STATE_ALREADY_AUDIT)
                continue;
            bean.setAuditAdvice(null);
            bean.setState(Constants.DATA_STATE_ALREADY_CREATE);
            this.addPendingAffair(beanType, bean);

            //yangwulin 2012-10-26 取消审核
            updateDirect(bean);

            //取消审核发消息
            List<Long> auth = new ArrayList<Long>();
            auth.add(bean.getCreateUser());
            Collection<MessageReceiver> receivers = MessageReceiver.get(bean.getId(), auth);
            try {
                userMessageManager.sendSystemMessage(
                        MessageContent.get("news.cancel.audit", bean.getTitle(), userName),
                        ApplicationCategoryEnum.news, userId, receivers);
            } catch (BusinessException e) {
                log.error("新闻取消审核发消息失败", e);
            }

            //取消审核加日志
            appLogManager.insertLog(user, AppLogAction.News_CancelAudit, userName, bean.getTitle());
        }

        return null;
    }
    /**
     * 为以下几种情况增加待办事项：
     * 1.新建新闻，发送待审核，增加一条对应的待办事项记录；
     * 2.已发送的新闻，未审核之前修改，再行发送，增加一条待审核记录，同时删除修改之前已有的待办事项记录；
     * 3.已审核且不通过的新闻，修改后再次发送待审核，增加一条对应的待办事项记录。
     * 抽取成为单独方法，便于单点维护 by Meng Yang at 2009-07-15
     * @param beanType  新闻板块
     * @param bean      新闻
     * @throws BusinessException 
     * @throws BusinessException 
     */
    public void addPendingAffair(NewsType beanType, NewsData bean) throws BusinessException {

        CtpAffair affair = new CtpAffair();
        affair.setIdIfNew();
        affair.setTrack(TrackEnum.no.ordinal());
        affair.setDelete(false);
        // 利用 subjectId 存储空间类型，将来用于进入不同的页面
        affair.setSubObjectId(Long.valueOf(beanType.getSpaceType().toString()));
        affair.setMemberId(beanType.getAuditUser());
        affair.setState(StateEnum.col_pending.key());
        affair.setSubState(SubStateEnum.col_pending_unRead.key());
        affair.setSenderId(bean.getCreateUser());
        affair.setSubject(bean.getTitle());
        affair.setObjectId(bean.getId());
        affair.setApp(ApplicationCategoryEnum.news.key());
        affair.setSubApp(ApplicationSubCategoryEnum.news_audit.key());
        affair.setCreateDate(new Timestamp(bean.getCreateDate().getTime()));
        affair.setReceiveTime((new Timestamp(System.currentTimeMillis())));
        V3xOrgMember member = orgManager.getMemberById(bean.getCreateUser());
        if (member != null) {
            affair.setSenderId(member.getId());
        }
        AffairUtil.setHasAttachments(affair, bean.getAttachmentsFlag());

        AffairUtil.addExtProperty(affair, AffairExtPropEnums.spaceType, beanType.getSpaceType());
        AffairUtil.addExtProperty(affair, AffairExtPropEnums.spaceId, beanType.getAccountId());
        AffairUtil.addExtProperty(affair, AffairExtPropEnums.typeId, beanType.getId());

        affairManager.save(affair);
    }
    
    @AjaxAccess
    public String isAuditType(Long id){
        NewsData news = getNewsData().get(id);
        if(news==null){
            news = getById(id);
        }
        NewsType newsType = newsTypeManager.getById(news.getTypeId());
        if(newsType.isAuditFlag() && newsType.getAuditUser()!=null){
            return "true";
        }
        return "false";
    }

    //客开 start 是否排版
    @AjaxAccess
    public String isTypesettingType(Long id){
      NewsData news = getNewsData().get(id);
      if(news==null){
        news = getById(id);
      }
      NewsType newsType = newsTypeManager.getById(news.getTypeId());
      if(newsType.isTypesettingFlag() && newsType.getTypesettingStaff()!=null){
        return "true";
      }
      return "false";
    }
    //客开 end

    @AjaxAccess
    public String typeHasIssue(Long id) throws BusinessException {
        User user = AppContext.getCurrentUser();
        NewsData bean = getNewsData().get(id);
        if (bean == null) {
            bean = getById(id);
        }
        if (bean != null) {
            NewsType type = bean.getType();
            boolean flag = false;
            if (type != null) {
                List<Long> domainIds = orgManager.getAllUserDomainIDs(user.getId());
                for (NewsTypeManagers tm : type.getNewsTypeManagers()) {
                    if (domainIds.contains(tm.getManagerId())) {
                        if (Constants.MANAGER_FALG.equals(tm.getExt1()) || Constants.WRITE_FALG.equals(tm.getExt1())) {
                            flag = true;
                            break;
                        }
                    }
                }
            }
            if (!flag) {
                return "0";
            }
            return "ok";
        }
        return "-1";
    }
    
    /**
     * 获取当前用户可以查看的所有新闻
     * @param user     当前用户
     * @param forSection   是否用于首页栏目显示
     * @throws BusinessException 
     */
    public List<NewsData> findMyNewsDatas(User user, int firstResult, int maxResult) throws BusinessException {
        List<Long> myNewsTypeIds = findMyNewsTypeIds(user);
        List<NewsData> list = null;
        try {
            list = this.queryListDatas(NewsDataManagerImpl.DATA_TYPE_LATEST, firstResult, maxResult, null, myNewsTypeIds, user.getId(), null, null, null);
        } catch (BusinessException e) {
            log.error("获取新闻列表异常！", e);
        }
        if (Strings.isNotEmpty(list)) {
            newsReadManager.getReadState(list, user.getId());
            initList(list);
        }
        return list;
    }
    
    public List<Long> findMyNewsTypeIds(User user) throws BusinessException{
        boolean isV5Member = AppContext.getCurrentUser().getExternalType() == OrgConstants.ExternalType.Inner.ordinal();
        Long accountId = AppContext.currentAccountId();
        if (!isV5Member) {
            accountId = OrgHelper.getVJoinAllowAccount();
        }
        List<NewsType> typeList = new ArrayList<NewsType>();
        try {
            List<PortalSpaceFix> fixList = spaceManager.getAccessSpace(user.getId(), accountId);
            if (fixList != null) {
                for (PortalSpaceFix portalSpaceFix : fixList) {
                    if (portalSpaceFix.getType().intValue() == SpaceType.custom.ordinal()) {
                        typeList.addAll(newsTypeManager.findAllOfCustom(portalSpaceFix.getId(), "custom"));
                    } else if (portalSpaceFix.getType().intValue() == SpaceType.public_custom.ordinal()) {
                        typeList.addAll(newsTypeManager.findAllOfCustom(portalSpaceFix.getId(), "publicCustom"));
                    } else if (portalSpaceFix.getType().intValue() == SpaceType.public_custom_group.ordinal()) {
                        typeList.addAll(newsTypeManager.findAllOfCustom(portalSpaceFix.getId(), "publicCustomGroup"));
                    }
                }
            }
        } catch (BusinessException e) {
            log.error("", e);
        }

        // 集团版块
        List<NewsType> groupNewsTypeList = newsTypeManager.groupFindAll();
        typeList.addAll(groupNewsTypeList);
        // 单位版块
        List<NewsType> accountNewsTypeList = newsTypeManager.findAll(accountId);
        typeList.addAll(accountNewsTypeList);
        List<Long> myNewsTypeIds = new ArrayList<Long>();
        if (Strings.isNotEmpty(typeList)) {
            for (NewsType newsType : typeList) {
                if (user.isInternal() || newsType.getOutterPermit()) {
                    myNewsTypeIds.add(newsType.getId());
                }
            }
        }
        return myNewsTypeIds;
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
        String newsIds = param.get("newsIds").toString();
        String typeId = param.get("typeId").toString();
        List<Long> ids = CommonTools.parseStr2Ids(newsIds);
        for (Long id : ids) {
            NewsData newsdata = this.getById(id);
            Boolean stateFlag = this.stateFlag(newsdata);
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
        }
        return true;
    }

    /**
     * 新闻状态判断
     */
    public Boolean stateFlag(NewsData newsdata) {
        if (newsdata == null 
                || !newsdata.getType().isUsedFlag() 
                || newsdata.isDeletedFlag() 
                || newsdata.getState().intValue() != Constants.DATA_STATE_ALREADY_PUBLISH) {
            return false;
        } else {
            return true;
        }
    }
    
    /**
     * 将选中的新闻置顶
     */
    public void top(List<Long> ids, Long typeId) throws BusinessException {
        List<NewsData> dataList = this.newsDataDao.getTopedNewsDatas(typeId);
        int newTop = 0;
        if (Strings.isNotEmpty(dataList)) {
            newTop = dataList.size();
            int alreadyTop = dataList.size();
            for (NewsData topData : dataList) {
                topData.setTopNumberOrder((byte) alreadyTop--);
                this.newsDataDao.update(topData);
            }
        }

        for (Long id : ids) {
        	NewsData data = this.getById(id);
            if (data.getState() != Constants.DATA_STATE_ALREADY_PUBLISH) { // 发布后才能置顶
                continue;
            }

            data.setTopNumberOrder((byte) ++newTop);
            this.newsDataDao.update(data);
        }
    }

    /**
     * 对新闻进行取消置顶操作
     * @param ids 要取消置顶的新闻列表
     */
    public void cancelTop(List<Long> ids) {
        String hql = "update " + NewsData.class.getName() + " as n set n.topNumberOrder=:noTop where n.id in (:ids)";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("noTop", Byte.valueOf("0"));
        params.put("ids", ids);
        this.newsDataDao.bulkUpdate(hql, params);
    }

	@Override
	public void updateTopNumberOrder(String oldTopNumberStr, String newTopNumberStr, Long newsTypeId) {
        if (!oldTopNumberStr.equals(newTopNumberStr)) {
            int newTopNumber = Integer.valueOf(newTopNumberStr);
            List<NewsData> topedNewsDatas = this.getTopedNewsDatas(newsTypeId);
            if (topedNewsDatas != null && topedNewsDatas.size() > 0) {
                int topNumberOrderNum = newTopNumber;
                for (int i = 0; i < topedNewsDatas.size(); i++) {
                	NewsData newsData = topedNewsDatas.get(i);

                    if (i <= newTopNumber - 1) {
                        this.updateTopOrder(newsData.getId(), Byte.valueOf(topNumberOrderNum + ""));
                        topNumberOrderNum--;
                    } else {
                        this.updateTopOrder(newsData.getId(), Byte.valueOf(0 + ""));
                    }
                }
            }
        }
    }

	@Override
    public List<NewsData> getTopedNewsDatas(Long newsTypeId) {
        return this.newsDataDao.getTopedNewsDatas(newsTypeId);
    }

	@Override
    public void updateTopOrder(Long newsDataId, Byte newTopNumberOrder) {
        Map<String, Object> columns = new HashMap<String, Object>();
        columns.put("topNumberOrder", newTopNumberOrder);
        this.newsDataDao.update(newsDataId, columns);
    }
}
