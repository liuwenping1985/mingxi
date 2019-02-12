package com.seeyon.v3x.news.manager;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.excel.DataRecord;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.annotation.AjaxAccess;
import com.seeyon.ctp.util.cache.DataCache;
import com.seeyon.ctp.util.cache.UpdateClickManager;
import com.seeyon.v3x.isearch.model.ConditionModel;
import com.seeyon.v3x.news.dao.NewsBodyDao;
import com.seeyon.v3x.news.domain.NewsBody;
import com.seeyon.v3x.news.domain.NewsData;
import com.seeyon.v3x.news.domain.NewsRead;
import com.seeyon.v3x.news.domain.NewsType;
import com.seeyon.v3x.news.util.NewsDataLock;
/**
 * 新闻最重要的Manager的接口。包括了新闻发起员、新闻审核员、新闻管理员、普通用户的操作。
 * @author wolf
 *
 */
public interface NewsDataManager extends UpdateClickManager {

	/**
	 * 新闻发起员保存新闻
	 * @param data
	 * @return
	 */
	public NewsData save(NewsData data, boolean isNew);
	/**
	 * 自定义单位新闻发起员保存新闻
	 * @param data
	 * @param isNew
	 * @return
	 */
	public NewsData saveCustomNews(NewsData data, boolean isNew);
	/**
	 * 直接保存
	 */
	public void updateDirect(NewsData data);
	
	/**
	 * 新闻管理员删除新闻。只做标记！
	 * @param id
	 */
	public void delete(Long id);
	
	/**
	 * 新闻发起员实际删除新闻
	 * @param id
	 * @throws BusinessException
	 */
	public void deleteReal(Long id) throws BusinessException;
	
	/**
	 * 删除一个类型下的所有新闻
	 */
	public void deleteRealOfType(long typeId) throws BusinessException;
	
	/**
	 * 新闻管理员批量删除新闻
	 * @param ids
	 */
	public void deletes(List<Long> ids);
	
	/**
	 * 新闻管理员查询所有可管理的新闻
	 * @return
	 * @throws BusinessException
	 * @throws Exception 
	 */
	public List<NewsData> findAll() throws BusinessException, Exception;
	
	/**
	 * 新闻管理员根据新闻的某一属性查询所有可管理的新闻
	 * @param property
	 * @param value
	 * @return
	 * @throws BusinessException
	 * @throws Exception 
	 */
	public List<NewsData> findByProperty(String property,Object value) throws BusinessException, Exception;
	
	/**
	 * 根据Id获取新闻
	 * @param id
	 * @return
	 */
	public NewsData getById(Long id);
	
	/**
	 * 获取某个新闻管理员可以管理的新闻类型
	 * @param managerUserId
	 * @param isIgnoreUsed 是否忽略该新闻类型是否启用。true 不处理是否启用字段；false 返回启用的新闻类型
	 * @return
	 * @throws Exception 
	 */
	public List<NewsType> getTypeList(Long managerUserId,boolean isIgnoreUsed,long loginAccount) throws Exception;
	public List<NewsType> getTypeList(Long managerUserId, int spaceType, long spaceId) throws Exception;
	
	public NewsTypeManager getNewsTypeManager();

	public NewsReadManager getNewsReadManager();

	/**
	 * 返回新闻审核员可以审核的新闻列表
	 * @param userId
	 * @param property
	 * @param value
	 * @return
	 * @throws BusinessException
	 */
	public List<NewsData> getAuditList(Long userId,String property,Object value,long loginAccount) throws BusinessException;
	
	/**
	 * 
	 */
	public List<NewsData> getAuditDataListNew(Long userId,String property,Object value, int spaceType) throws BusinessException;

	/**
	 * 返回当前用户可以阅读的所有图片新闻或焦点新闻
	 */
	public List<NewsData> findByReadUser4ImageNews(Long userId, long loginAccount, boolean isInternal, Integer imageOrFocus, int spaceType) throws DataAccessException, BusinessException;

	/**
	 * 返回当前用户可以阅读的所有图片新闻或焦点新闻（指定板块）
	 */
	public List<NewsData> findByReadUser4ImageNews(User user, Integer imageOrFocus, int spaceType, List<Long> typeIds) throws DataAccessException, BusinessException;
	
		/**
	 * 返回当前用户可以阅读的所有新闻(包括HMTL正文内容)
	 * @param id
	 * @return
	 * @throws DataAccessException
	 * @throws BusinessException
	 */
	public List<NewsData> findByReadUserContent(long id, List<NewsType> typeList,long loginAccount, Integer imageOrFocus) throws DataAccessException, BusinessException;
	
	/**
	 * 返回当前用户可以阅读的所有集团新闻
	 * @param id
	 * @return
	 * @throws DataAccessException
	 * @throws BusinessException
	 */
	public List<NewsData> groupFindByReadUser(long id, List<NewsType> typeList, Integer imageOrFocus) throws DataAccessException, BusinessException;
	
	/**
	 * 返回首页显示的当前用户可以阅读的所有新闻
	 */
	public List<NewsData> findByReadUserForIndex(Long userId, long loginAccount, boolean isInternal) throws DataAccessException, BusinessException;

	/**
	 * 返回首页显示的当前用户可以阅读的所有新闻（指定板块）
	 */
	public List<NewsData> findByReadUserForIndex(Long userId, long loginAccount, boolean isInternal, List<Long> typeIds) throws DataAccessException, BusinessException;

	/**
     * 返回当前用户可以阅读的所有新闻
     */
	public List<NewsData> findNewsByUserId(Long userId, int firstNum, int pageSize);
	
	public List<NewsData> findNewsByUserIdNew(Long userId, Long loginAccount,List<NewsType> typeIds,boolean isInternal);
	
	/**
	 * 返回自定义单位/集团首页显示的当前用户可以阅读的所有新闻
	 * @param userId
	 * @param loginAccount
	 * @param spaceType
	 * @param isInternal
	 * @return
	 * @throws DataAccessException
	 * @throws BusinessException
	 */
	public List<NewsData> findCustomByReadUserForIndex(Long userId, long loginAccount, int spaceType, boolean isInternal) throws DataAccessException, BusinessException;
	
	/**
	 * 返回集团空间首页显示的当前用户可以阅读的所有新闻
	 */
	public List<NewsData> groupFindByReadUserForIndex(long id, boolean isInternal) throws DataAccessException, BusinessException;

	/**
	 * 返回集团空间首页显示的当前用户可以阅读的所有新闻（指定板块）
	 */
	public List<NewsData> groupFindByReadUserForIndex(long id, boolean isInternal, List<Long> typeIds) throws DataAccessException, BusinessException;
	
	/**
	 * 返回当前用户可以阅读的新闻，property=value
	 * @param id
	 * @param property
	 * @param value
	 * @return
	 * @throws DataAccessException
	 * @throws BusinessException
	 */
	public List<NewsData> findByReadUser(long id,String property,Object value, Object value1, List<NewsType> typeList,long loginAccount) throws Exception;
	/**
	 * 返回当前用户可以阅读的自定义单位新闻，property=value
	 * @param id
	 * @param property
	 * @param value
	 * @param typeList
	 * @param loginAccount
	 * @param spaceType
	 * @return
	 * @throws DataAccessException
	 * @throws BusinessException
	 */
	public List<NewsData> findByReadUser(long id, String property, Object value, Object value1, List<NewsType> typeList,long loginAccount, String spaceType) throws Exception;
	/**
	 * 返回当前用户可以阅读的集团新闻，property=value
	 * @param id
	 * @param property
	 * @param value
	 * @return
	 * @throws DataAccessException
	 * @throws BusinessException
	 */
	public List<NewsData> groupFindByReadUser(long id,String property,Object value, Object value1, List<NewsType> typeList) throws Exception;
	
	/**
	 * 新闻发起员可以处理的新闻，property=value
	 * @param condition
	 * @param value
	 * @return
	 * @throws BusinessException
	 */
	public List<NewsData> findWriteByProperty(String condition, Object value) throws BusinessException;

	/**
	 * 新闻发起员可以处理的所有新闻
	 * @return
	 * @throws BusinessException
	 */
	public List<NewsData> findWriteAll() throws BusinessException;
	
	/**
	 * 获取某个新闻发起员可以管理的新闻类型
	 * @param writeId 发起者用户ID
	 * @param isIgnoreUsed 是否忽略该新闻类型是否启用。true 不处理是否启用字段；false 返回启用的新闻类型
	 * @return
	 */
	public List<NewsType> getTypeListByWrite(Long writeId,boolean isIgnoreUsed);
	
	/**
	 * 根据ID获取新闻，并设置某用户阅读该新闻的阅读情况
	 * @param id
	 * @param userId
	 * @return
	 */
	public NewsData getById(Long id,Long userId);
	
	/**
	 * 根据用户ID获取某新闻的阅读情况统计列表。只有系统管理员和该新闻所属类型的新闻管理员可以查看阅读统计情况
	 * @param data
	 * @param userId
	 * @return
	 * @throws Exception 
	 */
	public List<NewsRead> getReadListByData(NewsData data,Long userId) throws Exception;
	
	/**
	 * 新闻管理员查看新闻的统计情况
	 * @param type
	 * @return
	 */
	public List statistics(String searchType, final long newsTypeId);

	public void pigeonhole(List<Long> idList);

	public List<NewsData> findByProperty(Long typeId, String condition, Object value,Object value1, long userid) throws Exception;

	public List<NewsData> findAll(Long typeId,long userid) throws Exception;
	
	public List<NewsData> findAllWithOutFilter(Long typeId) throws Exception;
	public int findAllWithOutFilterTotal(Long typeId) throws Exception;
	/**
	 * 得到新闻版块下的所有新闻
	 * @param typeId
	 * @return
	 * @throws Exception
	 */
	public List<NewsData> getNewsByTypeId(final Long typeId) throws Exception;

	public List<NewsData> findByReadUser(Long userId, Long typeId) throws BusinessException;
		//导出列表包括正文信息。
	public List<NewsData> findByReadUserContent(Long userId, Long typeId) throws BusinessException;
	public List<NewsData> findByReadUser(Long userId, Long typeId,long loginAccount) throws BusinessException;

	public List<NewsData> findWriteByProperty(Long typeId, String condition, Object value) throws BusinessException;

	public List<NewsData> findWriteAll(Long typeId,long userId) throws BusinessException;

	public List<NewsType> getManagerGroupBulType(Long managerUserId,boolean isIgnoreUsed)throws Exception;
	
	/**
	 * 更新审核时候操作
	 * @param summaryId
	 * @param columns
	 */
	public void update(Long Id, Map<String, Object> columns);
	
	/**
	 * 初始化
	 */
	public void init();
	
	/**
	 * 判斷某條數據是否存在
	 */
	public boolean dataExist(Long bulId);
	
	public List<NewsData> findByReadUser4Section(Long userId, Long typeId) throws BusinessException;
	public List<NewsData> findByReadUser4Mobile(long id,String property,Object value) throws DataAccessException, BusinessException;	
	public List<NewsData> findByReadUser4Mobile(long id,String property,Object value,long loginAccount) throws DataAccessException, BusinessException;

	/**
	 * 判断某个审核员是否有未审核事项
	 */
	public boolean hasPendingOfUser(Long userId, Long... typeIds);
	
	//客开s
	public boolean hasPending2OfUser(Long userId, Long... typeIds);
	
	
	public NewsBodyDao getNewsBodyDao();
	//客开e
	
	
	/**
	 * 
	 */
	public Map<Long, List<NewsData>> findByReadUserHome(long id, List<NewsType> typeList) throws DataAccessException,
	BusinessException ;
	
	/**
	 * 
	 */
	/**
	 * 审核员对某个类型的待办总数
	 */
	public int getPendingCountOfUser(Long userId, int spaceType);
	
	/**
	 * 得到状态
	 */
	public int getStateOfData(long id);
	/**
	 * 确认新闻的类型存在,并且启用
	 * @param typeId
	 * @return
	 */
	public boolean typeExist(long typeId);
	
	/**
	 * 
	 */
	public boolean isManagerOfType(long typeId, long userId);
	
	/**
	 * 综合查询
	 */
	public List<NewsData> iSearch(ConditionModel cModel,long loginAccount);
	
	/**
	 * 取正文
	 */
	public NewsBody getBody(long newsDataId);
	
	
	public int readOneTime(long dataId);
	
	/**
	 * 协同转发新闻
	 * @throws BusinessException 
	 */
	public void saveCollNews(NewsData data) throws BusinessException;
	
	/**
	 * 检验文件中否加锁
	 * NewsDataLock:为空表示文件已加锁,不能再访问了
	 * NewsDataLock:不为空表示文件还没有加锁,可以访问,并进行加锁
	 * action表示当前的动作
	 */
	public NewsDataLock lock(Long newdatasid,String action);
	
	/**
	 * 检验文件中否加锁
	 * NewsDataLock:为空表示文件已加锁,不能再访问了
	 * NewsDataLock:不为空表示文件还没有加锁,可以访问,并进行加锁
	 * action表示当前的动作
	 */
	public NewsDataLock lock(Long newsid, Long userid, String action);
	
	/**
	 * 对新闻进行解锁
	 */
	public void unlock(Long newdatasid);
	
	public Map<Long, NewsDataLock> getLockInfo4Dump();
	
	/**
	 * 该板块存在待审核新闻，但当时的审核员已不可用，如果随后该板块设定了新的审核员，需要将原先的待审核新闻转给新的审核员
	 * @param newsTypeId   对应的新闻板块ID
	 * @param oldAuditorId 旧审核员ID(对应人员已不可用)
	 * @param newAuditorId 新审核员ID
	 */
	public void transferWait4AuditBulDatas2NewAuditor(Long newsTypeId, Long oldAuditorId, Long auditUser);
	
	//客开start
	public void transferWait4AuditBulDatas2NewTypesettingStaff(Long newsTypeId, Long oldTypesettingStaff, Long typesettingStaff);
	//客开end
	
	/**
	 * 根据附件ID取正文
	 */
	public NewsBody getBodyByFileId(String fileid);
	
	
	/**
     * 点击板块管理后,再点击新闻审核后所看到的列表,2012-11-5 yangwulin 根据当前的板块查询当前板块需要审核的新闻。
     * @param userId 用户Id
     * @param property 查询类型
     * @param value   查询值
     * @param newsTypeId 当前板块的Id
     * @return
     * @throws BusinessException
     */
    public List<NewsData> getAuditDataListNew(Long userId,String property,Object value,int spaceType,String newsTypeId) throws BusinessException;

    /**
     * yangwulin Sprint4  2012-11-15  全文检索
     * 获取在某一段时期内，某一板块下已发布的公告总数
     * @param beginDate 
     * @param endDate 
     * @return
     */
    public Integer findIndexByDate(Date beginDate, Date endDate);
    
    /**
    * yangwulin Sprint4  全文检索
    */
   public List<Long> findDocSourcesList(Date starDate, Date endDate, Integer firstRow, Integer pageSize);
   
  	/**
  	 * 为M1提供接口：获取指定新闻板块中当前登陆用户有权限访问的新闻数
  	 * @param typeId 指定的新闻板块ID
  	 * @return 新闻数
  	 */
	public Long getNewsDatasCount( Long typeId);
	
	/**
	 * 为H5提供接口：实现获取首页所有新闻（支持搜索）
	 * @param condition
	 * @param value
	 * @param value1
	 * @param userid
	 * @return
	 * @throws Exception
	 */
	public List<NewsData> findByUserProperty(String condition, Object value, Object value1,List<Long> typesIds,Long userId) throws Exception;
	
	/**
	 * 判断新闻板块审核员是否可用
	 * @param typeId
	 * @return
	 */
	public boolean isAuditUserEnabled(Long typeId) throws Exception;
	//客开 start
	public boolean isTypesettingStaffEnabled(Long typeId) throws Exception;
	//客开end
	
	public DataCache<NewsData> getNewsData();
	public void clickCache(Long dataId, Long userId);
	public void syncCache(NewsData bean, int clickCount);
	public void removeCache(Long dataId);
	/**
	 * 初始化新闻 1、初始化发起者姓名 2、初始化新闻是否存在附件标志 3、初始化新闻发布部门的中文名称
	 * @param data
	 */
	public void initData(NewsData data);
	
	public void initDataFlag(NewsData bean, boolean b);
	/**
	 * 审核操作
	 * @param objectId
	 * @param formOper
	 * @param auditAdvice
	 */
	public void auditNews (String objectId, String formOper,String auditAdvice) throws Exception;

    /**
     * 获取所有自定义空间的板块（自定义团队、自定义单位、自定义集团）
     * @return
     */
    public List<NewsType> getAllCustomTypes();
    
    int findByReadUserForWechat(long userId, String countFlag) throws BusinessException;
    
    
    public FlipInfo newsStc(FlipInfo fi, Map<String, Object> params);
    
    public Map<String, Object> getTypeByMode(String mode, String sTypeId);
    
    public DataRecord expStcToXls(Map<String, Object> params);

    /******************************6.0******************************/

    /**
     * 获取我发布的个数
     * @param memberId
     * @return
     * @throws BusinessException
     */
    public int getMyIssueCount(Long memberId,List<Long> myNewsTypeIds) throws BusinessException;

    /**
     * 获取我评论的个数
     * @param memberId
     * @return
     * @throws BusinessException
     */
    public int getMyReplyCount(Long memberId,List<Long> myNewsTypeIds) throws BusinessException;

    /**
     * 获取我收藏的个数
     * @param memberId
     * @return
     * @throws BusinessException
     */
    public int getMyCollectCount(Long memberId,List<Long> myNewsTypeIds) throws BusinessException;

    /**
     * 获取新闻审核个数
     * @param memberId
     * @return
     * @throws BusinessException
     */
    public int getMyAuditCount(Long memberId,List<Long> myNewsTypeIds) throws BusinessException;
    
    //客开 start
    /**
     * 获取新闻排版个数
     * @param memberId
     * @return
     * @throws BusinessException
     */
    public int getMyTypesettingCount(Long memberId,List<Long> myNewsTypeIds) throws BusinessException;
    //客开 end
    
    /**
     * 我能查看的新闻板块id
     * @param spaceType
     * @param spaceId
     * @return
     * @throws BusinessException
     */
    public List<Long> getMyNewsTypeIds(int spaceType, Long spaceId) throws BusinessException;
    
    /**
     * 查询新闻
     * @param listType
     * @param firstResult
     * @param maxResult
     * @param typeId
     * @param myNewsTypeIds
     * @return
     * @throws BusinessException
     */
    public List<NewsData> queryListDatas(int listType, int firstResult, int maxResult, Long typeId, List<Long> myNewsTypeIds, Long memberId, String condition, String textfield1, String textfield2) throws BusinessException;
    
    /**
     * 查看新闻版块 发布 帖子总数
     * @param boardId
     * @return
     */
    public Integer getNewsNumber4Type(Long boardId);
    
    /**
     * 查看新闻版块发布帖子的回复总数
     * @param boardId
     * @return
     */
    public Integer getNewsReplyNumber4Type(Long boardId);
    
    /**
     * 审核新闻/取消审核新闻
     * @param param
     * @return
     * @throws BusinessException
     */
    @AjaxAccess
    public String auditNews(Map<String, Object> param) throws BusinessException;
    
    public Map<String, Object> findMyReply(int pageNo, int pageSize, List<Long> myNewsTypeIds) throws BusinessException;
    
    /**
     * 获取当前用户可以查看的所有公告
     * @param user     当前用户
     */
    public List<NewsData> findMyNewsDatas (User user,int firstResult, int maxResult) throws BusinessException;
	/**
	 * 在新闻板块的置顶总个数变化之后，对已经置顶的新闻进行处理，使其置顶状态与板块的置顶总数保持一致
	 * @param oldTopNumberStr 	旧的板块置顶总数
	 * @param newTopNumberStr 	新的板块置顶总数
	 * @param newsTypeId 		新闻板块ID
	 */
	public void updateTopNumberOrder(String oldTopNumberStr, String newTopNumberStr, Long newsTypeId);
	
    /**
     * 获取某个版块下面已经置顶的新闻
     * @param newsTypeId
     */
    public List<NewsData> getTopedNewsDatas(Long newsTypeId);
    
    /**
     * 更新某条新闻的置顶数目
     * @param newsDataId		新闻ID
     * @param newTopNumberOrder	新的置顶数
     */
    public void updateTopOrder(Long newsDataId, Byte newTopNumberOrder);
}
