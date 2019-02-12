package com.seeyon.v3x.news.dao;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.seeyon.ctp.common.dao.CTPBaseHibernateDao;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.v3x.news.domain.NewsData;
import com.seeyon.v3x.news.domain.NewsType;
/**
 * 该类是NewsDataDAO类,它继承自BaseHibernateDAO,BaseHibernateDAO封闭了一些比较好用的方法
 * BaseHibernateDAO继承自AbstractHibernateDao;
 * AbstractHibernateDao继承自Spring中的HibernateDaoSupport
 * @author IORIadmin
 *
 */
public interface NewsDataDao extends CTPBaseHibernateDao<NewsData> {
	
	//新闻左外联新闻阅读信息表，注意其中有个阅读者命名参数需要设定
	
	public static final String SELECTSELECT = 
	         "select t_data.id, t_data.title, t_data.brief,t_data.keywords, t_data.publishScope, t_data.publishDepartmentId, t_data.dataFormat, t_data.createDate, t_data.createUser, " +
	                 " t_data.publishDate, t_data.publishUserId, t_data.readCount, t_data.topOrder, t_data.accountId, t_data.typeId, t_data.state, " +
	                 " t_data.attachmentsFlag, t_data.auditUserId, t_data.imageNews, t_data.focusNews,t_data.ext5,t_data.ext4, t_data.imageId, reads.managerId from NewsData as t_data ";
	public static final String ORDER_BY = " order by t_data.publishDate desc";
	
	public abstract Map<Long, List<NewsData>> findByReadUserHomeDAO(long id, List<NewsType> typeList) throws DataAccessException;
	
	// 列出当前用户所能看到的新闻: (新闻发布)
	public abstract List<NewsData> findWriteAllDAO(Long typeId, long userId);
	//点击新闻列表页面的更多按钮执行的操作
	public abstract List<NewsData> findByReadUserDAO(Long userId, Long typeId,long loginAccount);
	
	//在单位新闻列表页面右上角的查询功能
	public abstract List<NewsData> findByReadUserDAO(long id, String property, Object value, Object value1, List<NewsType> inList) throws Exception;
	/**
	 * 这是从单位新闻首页点击"更多"按钮,目前也使用于集团新闻首页的更多按钮
	 */
	public abstract List<NewsData> findByReadUserDAO(long id, List<NewsType> inList, Integer imageOrFocus) throws DataAccessException, BusinessException;
	
	//集团页面点击更多,查询出所有类型的新闻,这个方法暂时没有用,已经合到findByReadUserDAO(id, typeList);里面了
	@SuppressWarnings("unchecked")
	public abstract List<NewsData> groupFindByReadUserDAO(long id, List<NewsType> typeList) throws DataAccessException, BusinessException;
	
	/**
	 * 在单位新闻列表页面右上角的查询功能
	 * 这个方法可以和findByReadUserDAO合并为一个方法,可以做为一个后备的方法
	 */
	public abstract List<NewsData> groupFindByReadUserDAO(long id,String property,Object value, List<NewsType> inList) throws DataAccessException, BusinessException;
	
	/**
	 * 用户模块管理页面什么也不输入的时候进行的查询
	 */
	public abstract List<NewsData> findAllDAO(Long userId, Long typeId,List<NewsType> inList) throws Exception;
	
	//用户在模块管理页面输入相关的查询条件
	public abstract List<NewsData> findByPropertyDAO(Long userId, Long typeId, String condition, Object value, Object value1,List<NewsType> inList) throws Exception;
	/**
	 * H5调用首页查询所有新闻（包括搜索）
	 * @param userId
	 * @param condition 搜索类型
	 * @param value	搜索值
	 * @param value1
	 * @return
	 * @throws Exception
	 */
	public abstract List<NewsData> findByUserPropertyDAO(List<Long> inList, String condition, Object value,Object value1,Long userId) throws Exception;
	/**
	 * 显示当前用户的待审核条数
	 * @param auditList
	 * @return
	 */
	public abstract List getPendingCountOfUserDAO(List<NewsType> auditList);
	
	/**
	 * 点击板块管理后,再点击新闻审核后所看到的列表
	 * @param userId
	 * @param property
	 * @param value
	 * @param auditTypeList
	 * @return
	 * @throws BusinessException
	 */
	public abstract List<NewsData> getAuditDataListNewDAO(Long userId,String property,Object value,List<NewsType> auditTypeList) 
	        throws BusinessException;
	
	/**
	 * 将某一指定新闻板块下待审核的新闻对应待办事项转到新审核员名下<br>
	 * 由于旧的待办事项可能是较早以前的，在转移时，将其时间改为当前时间，便于新的审核员在其待办事项最开始几项中看到<br>
	 * 这种情况发生的场景：旧审核员离职了，而其具有审核权的新闻板块还有待审核新闻<br>
	 * @param newsTypeId    新闻板块ID
	 * @param oldAuditorId  旧审核员ID
	 * @param newAuditorId  新审核员ID
	 */
	public abstract void transfer2NewAuditor(Long newsTypeId, Long oldAuditorId, Long newAuditorId);
	
	//客开 start
	public abstract void transfer2NewTypesettingStaff(Long newsTypeId, Long oldTypesettingStaff, Long typesettingStaff);
	//客开 end
	
	/**
	 * 点击板块管理后,再点击新闻审核后所看到的列表,2012-11-5 yangwulin 根据当前的板块查询当前板块需要审核的新闻。
	 * @param userId 用户Id
	 * @param property 查询类型
	 * @param value   查询值
	 * @param newsTypeId 当前板块的Id
	 * @return
	 * @throws BusinessException
	 */
	public List<NewsData> getAuditDataListNewInfo(Long userId,String property,Object value,String newsTypeId) throws BusinessException;
	
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
	 * @param userId 当前登陆用户ID
	 * @param typeId 指定的新闻板块ID
	 * @param loginAccount 当前登陆用户的单位ID
	 * @return
	 */
	public Long getNewsDatasCount(Long userId, Long typeId ,long loginAccount);
	/**
	 * 新闻点赞
	 * @param newsId
	 * @param praise
	 * @param praise_sum
	 * @return 
	 */
	public int addPraise(Long newsId,String praise,int praise_sum);
	/**
	 * 取得某一个新闻板块下已发布、被置顶的新闻
	 * @param typeId	新闻板块ID
	 */
	public List<NewsData> getTopedNewsDatas(Long typeId);

}
