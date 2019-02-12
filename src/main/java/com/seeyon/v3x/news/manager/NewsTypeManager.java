package com.seeyon.v3x.news.manager;

import java.util.Collection;
import java.util.List;

import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.portal.util.Constants.SpaceType;
import com.seeyon.v3x.news.domain.NewsType;
import com.seeyon.v3x.news.domain.NewsTypeManagers;

/**
 * 新闻类型的Manager接口
 * @author wolf
 *
 */
public interface NewsTypeManager {

	/**
	 * 查询所有单位新闻类型。支持分页--和--不分页-2中接口
	 * @return
	 */
	public abstract List<NewsType> findAll();
	public abstract List<NewsType> findAll(long loginAccount);
	public List<NewsType> findAllByPage(long loginAccount);

    /**
     * 获取某个单位或某个自定义空间的新闻板块列表
     * @param accountId 单位id或空间id
     * @return
     */
    public List<NewsType> findAccountNewsTypes(Long accountId);

	/**
	 * 查询所有的自定义单位/集团新闻板块
	 * @param spaceId
	 * @param spaceType
	 * @param isPage 是否分页
	 * @return
	 */
	public List<NewsType> findAllByCustomAccId(long spaceId, int spaceType, boolean isPage);
	
	public List<NewsType> findAllOfCustomAcc(long spaceId, int spaceType);
	/**
	 * 查询所有自定义空间新闻类型。支持分页--和--不分页-2中接口
	 * @return
	 */
	public List<NewsType> findAllOfCustom(long loginAccount, String spaceType);
	
	/**
	 * 
	* @Description: 综合查询获取所有自定义空间的新闻版块
	* @param unitId
	* @return
	 */
	public List<NewsType> findCustomNewsTypeByUnitId(long unitId);
	/**
	 * 查询所有集团新闻类型。支持分页--和--不分页-2中接口
	 * @return
	 */
	public abstract List<NewsType> groupFindAll();
	public List<NewsType> groupFindAllByPage();

	/**
	 * 查询符合条件的新闻类型。支持分页
	 * @param property
	 * @param value
	 * @return
	 */
	public abstract List<NewsType> findByProperty(String property, Object value,long loginAccount);
	public List<NewsType> groupFindByProperty(String property, Object value);

	/**
	 * 根据新闻类型ID查询
	 * @param id
	 * @return
	 */
	public abstract NewsType getById(Long id);

	/**
	 * 保存新闻类型。同时保存新闻管理员列表。
	 * @param type
	 * @return
	 * @throws BusinessException
	 */
	public abstract NewsType save(NewsType type, boolean isNewParam) throws BusinessException;

	/**
	 * 保存某个新闻类型的发起员。在添加之前会删除原来该新闻类型的发起员
	 * @param typeId 新闻类型ID
	 * @param writeIds 发起员的用户ID列表
	 */
	public void saveWriteByType(Long typeId,String[][] writeIds);

	/**
	 * 是否是集团新闻板块管理员、审核员
	 * 
	 * @param memberId
	 * @return
	 */
	public boolean isGroupNewsTypeManager(long memberId);
	
	/**
	 * 是否是新闻公告板块撰写者
	 * 
	 * @param memberId
	 * @return
	 */
	public boolean isGroupNewsTypeAuth(long memberId);
	
	/**
	 * 取得有我来审核的单位新闻板块
	 * @param memberId
	 * @return
	 */
	public List<NewsType> getAuditUnitNewsTypeOnlyByMember(long memberId);
	
	public List<NewsType> getAuditGroupNewsTypeNoPaging(long memberId);
	public List<NewsType> getAuditUnitNewsTypeNoPaging(long memberId);
	/**
	 * 得到自定义空间可以审核的版块列表
	 * @param userId
	 * @param spaceId
	 * @param spaceType
	 * @return
	 */
	public List<NewsType> getCustomAuditUnitNewsTypeNoPaging(long userId, long spaceId, int spaceType);
	
	/**
	 * 得到可以审核的版块列表
	 * 单位类型时，accountId 为 null 说明不验证单位
	 *
	 */
	public List<NewsType> getAuditTypeByMember(Long memberId, SpaceType spaceType, Long accountId);
	public List<NewsType> getManagerTypeByMember(Long memberId, SpaceType spaceType, Long accountId);
	public List<NewsType> getWriterTypeByMember(Long memberId, SpaceType spaceType, Long accountId);
	//客开s
	public List<NewsType> getPaiBanTypeByMember(Long memberId, SpaceType spaceType, Long accountId);
	//客开e
	/**
	 * 初始化类型下总数
	 */
	public void setTotalItemsOfType(List<NewsType> types);
	
	public List<NewsType> findByPropertyNoPaging(String property, Object value,long loginAccount);
	/**
	 * 逻辑删除版块
	 */
	public void setTypeDeleted(List<Long> ids);

	/**
	 * 用于新建单位时初始化新闻板块
	 * @param accountId  单位id
	 */
	public void initNewsType(long accountId);
	
	/**
	 * 得到 writeFlag 的NewsTypeManagers
	 * 
	 */
	public List<NewsTypeManagers> findTypeWriters(NewsType bt);
	
	/**
	 * 判断用户是否管理员
	 */
	public boolean isManagerOfType(long typeId, long userId);
	
	/**
	 * 用于更新新闻板块的排序顺序
	 * @param accountId
	 */
	public void updateNewsTypeOrder(String[] newsTypeIds);
	
	/**
	 * 按模块名称查询某用户有管理权限的模块
	 */
	public List<NewsType> getNewsTypeList(Long memberId ,String typename , boolean isIgnoreUsed ,int spaceType) ;
	/**
	 * 按总数查询某用户有管理权限的模块
	 */
	public List<NewsType> getNewsTypeList(Long memberId ,String num , String match, boolean isIgnoreUsed ,int spaceType) ;

	/**
	 * 按是否需要审核查询某用户有管理权限的模块
	 */
	public List<NewsType> getNewsTypeListByAuditFlag(Long memberId ,String flag , boolean isIgnoreUsed ,int spaceType) ;
	
	/**
	 * 按审核员名字查询某用户有管理权限的模块
	 */
	public List<NewsType> getNewsTypeListByAuditUsername(Long memberId ,String username , boolean isIgnoreUsed ,int spaceType) ;

	/**
	 * 取得某个用户管理和审批的版块
	 */
	public List<NewsType> getTypesCanNew(Long memberId, SpaceType spaceType, Long accountId);
	
	/**
	 * 判断用户是否有新建权限
	 */
	public boolean hasAuth(Long memberId, Long accountId);
	
	/**
	 * 查询可以新建新闻的版块
	 */
	public List<NewsType> getTypesCanNewByMember(Long memberId, SpaceType spaceType, Long accountId);
	
	/**
	 * 支持双机热备，将此方法设为公开，以便监听处理类调用
	 * @param type
	 */
	public void initPartAdd(NewsType type);
	
	/**
	 * 支持双机热备，将此方法设为公开，以便监听处理类调用
	 * @param type
	 */
	public void initPartEdit(NewsType type);
	
	/**
	 * 获取全部板块信息
	 * @return
	 */
	public Collection<NewsType> getAllNewsTypes();
	
	/**
	 * 删除人员时修改板块的管理员、审核员、发起者
	 * @param id
	 * @throws BusinessException
	 */
	public void delMember(Long id) throws BusinessException;
	
	   /**
     * 删除人员时修改板块的管理员、审核员、发起者(排除集团板块)
     * @param id
     * @throws BusinessException
     */
    public void delMemberNotGroup(Long id) throws BusinessException;

    /**
     * 创建自定义团队空间对应新闻板块
     */
    public NewsType saveCustomNewsType(Long spaceId, String spaceName, int spaceType);

	/**
	 * 用于判断是否是新闻审核员
	 */
	public boolean isAuditorOfNews(Long memberId);

    /**
     * 获取所有自定义空间的板块（自定义团队、自定义单位、自定义集团）
     * @return
     */
    public List<NewsType> getAllCustomTypes();
    /**
     * 获取能看到的所有版块
     * @return
     */
    public List<Long> getCanSeeBoard(User user) throws BusinessException;

}