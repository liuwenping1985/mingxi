package com.seeyon.apps.doc.dao;

import java.sql.Timestamp;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.hibernate.Session;

import com.seeyon.apps.doc.po.DocResourcePO;
import com.seeyon.apps.doc.po.DocTypePO;
import com.seeyon.apps.doc.vo.DocSearchModel;
import com.seeyon.ctp.common.dao.CTPBaseHibernateDao;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.v3x.isearch.model.ConditionModel;

public interface DocResourceDao extends CTPBaseHibernateDao<DocResourcePO> {
	
	
	//kekai  zhaohui  获取列表中frOroder 最小值 start
		public Number getMinFrOderByParentFrId(Long ParentFrId);
	
	
	
	/**
	 * 注意，此处在保存文档时，获取主键ID的策略自2010-10-22起进行了调整(可对照CVS历史版本记录)<br>
	 * 此前的策略是通过自增组件，先获取doc_resources表中的最大ID，加1后设为当前文档ID<br>
	 * 此策略需要保证同步，以免出现主键重复，单机环境尚可，在集群环境下存在困难，改为使用UUID<br>
	 * @see com.seeyon.apps.doc.util.Constants#getNewDocResourceId
	 * @editor Rookie Young
	 */
	public Long saveAndGetId(DocResourcePO dr);
	
	public boolean isDocResourceExsit(Long archiveId);
	
	/**
	 * 取得多个docResource
	 */
	public List<DocResourcePO> getDocsByIds(String ids);
	
	public List<DocResourcePO> getDocsByIds(List<Long> idList);

	public List<DocResourcePO> getDocsBySourceId(List<Long> resourceId);
	
	/**
	 * 获取文档夹下的全部子文档
	 * @param dr	文档夹
	 */
	public List<DocResourcePO> getSubDocResources(DocResourcePO dr);
	
	/**
	 * 根据文档夹ID获取对应文档夹下的全部子文档
	 * @param drId	文档夹Id
	 */
	public List<DocResourcePO> getSubDocResources(Long drId);
	
	/**
	 * 获取文档综合查询的结果
	 * @param cModel	综合查询值模型
	 * @param docType	查询的文档类型
	 */
	public List<DocResourcePO> iSearch(ConditionModel cModel, DocTypePO docType);
	
	public Session getDocSession();

	public void releaseDocSession(Session session);

	/**
	 * 修改文档库名称时，对应的根文档夹名称也需要同步修改
	 * @param docLibId		文档库ID
	 * @param newLibName	文档库新名称，需赋值给根文档夹
	 */
	public void updateRootFolderName(Long docLibId, String newLibName);
	
	/**
	 * 在归档协同时，判断当前选中的协同是否有至少一个已被归档
	 * @param docResId	归档源文档夹ID
	 * @param contentId	文档类型ID
	 * @param srIds	待归档的、选中的协同ID(col_summary主键ID)集合
	 * @return	当前选中的协同是否有至少一个已被归档
	 */
	public boolean judgeSamePigeonhole(Long docResId, Long contentId, List<Long> srIds);
	
	/**
	 * 获取项目阶段下的文档
	 * @param phaseId				项目阶段ID
	 * @param projectLogicalPath	项目文档夹的逻辑路径
	 */
	public List<DocResourcePO> getDocsOfProjectPhase(Long phaseId, String projectLogicalPath);
	

	/**
	 * 获取项目阶段下所有有权限的文档
	 * @param projectLogicalPath	项目文档夹的逻辑路径
	 * @param orgIds
	 * @param hasAcl
	 * @param paramMap  查询条件
	 * @return
	 */
	public List<DocResourcePO> getDocsOfProjectPhase(String projectLogicalPath,String orgIds, boolean hasAcl,Map<String,String> paramMap);
	
	/**
	 * 在修改、替换、历史版本恢复过程中，同步更新其对应映射文件的名称
	 * @param docResourceId		源ID
	 * @param newName			新名称
	 */
	
	public void updateLinkName(Long docResourceId, String newName);

	/**
	 * 在收藏  归档过程中，同步更新其对应文档来源类型
	 * @param docResourceId		源ID
	 * @param forderId			文档夹
	 * @param newType			新名称
	 */
	public void updateSourceType(Long docResourceId, Long forderId, Integer newType);
	
	/**
     * 根据日期时间段获取文档数量
     * @param starDate 开始日期
     * @param endDate  结束日期
     * @return
     * @throws BusinessException
     */
    public Integer findDocSourcesCountByDate(Date starDate, Date endDate)throws BusinessException ;


    /**
     * 根据日期时间段获取所有资源ID集合
     * @param starDate
     * @param endDate
     * @param firstRow
     * @param pageSize
     * @return
     * @throws BusinessException
     */
    public List<Long> findDocSourcesList(Date starDate, Date endDate, Integer firstRow,Integer pageSize)throws BusinessException;
    
    /**
     * 根据文档类型获取用户对应的文档ID
     * @param userId
     * @param type
     * @return
     */
    public Long findDocIdByType(Long userId,Long type);

    /**
     * 根据文档夹下的所有文档
     * @param forderId
     * @param createrId 创建者
     * @return
     */
    public List<DocResourcePO> findDocFilesByFolder(Long forderId,Long createrId);

	/**
	 * 查询某种权限类型的文档
	 * @param docId
	 * @param UserIds
	 * @param title
	 *            标题
	 * @param createIds
	 *            创建者
	 * @param OutMiniType
	 *            例外的frType
	 * @param aclType
	 * 			  文档权限类型
	 * @param FlipInfo
	 * @return
	 */
	public List<DocResourcePO> findDocByAclType(FlipInfo fpi ,Long docId,
			Collection<Long> userIds, String title, Collection<Long> createIds,
			Collection<Long> OutMiniType,List<Byte> aclTypes)throws BusinessException;

	/**
	 * 查询某种权限类型的无权文档
	 * @param docId
	 * @param UserIds
	 * @param title
	 *            标题
	 * @param createIds
	 *            创建者
	 * @param OutMiniType
	 *            例外的frType
	 * @param aclType
	 * 			  文档权限类型
	 * @param FlipInfo
	 * @return
	 */
	public List<DocResourcePO> findDocByAclTypeWithoutAcl(FlipInfo fpi ,Long docId,
			Collection<Long> userIds, String title, Collection<Long> createIds,
			Collection<Long> OutMiniType,Byte aclType)throws BusinessException;
	/**
	 * 查询借阅给我的文档（个人 单位）
	 * @param userIds
	 * @param title
	 *            标题
	 * @param createIds
	 *            创建者
	 * @param OutMiniType
	 *            例外的frType
	 * @param aclType
	 * 			  文档权限类型
	 * @param FlipInfo
	 * @return
	 */
	public List<DocResourcePO> findBorrowDoc(FlipInfo fpi,
			Collection<Long> userIds, String title, Collection<Long> createIds,
			Collection<Long> OutMiniType)throws BusinessException;
	
	/**
     * 在修改、替换、历史版本恢复过程中，查询到所有映射文档，备用
     * @param docResourceId     源ID
     */
    public List<Long> getAllLink(Long docResourceId);
    
    List<DocResourcePO>  findByLogicPathLike(String logicPath);
    
    void updateOpenSquareTimeByParentForder(DocResourcePO parentForder,Timestamp openSquareTime);
    
    List<DocResourcePO> findPigeonholeArchive(Collection<Long> ids, Boolean isDuplicatePigeonhole);
    
    void updatePigeonholeArchive(Collection<Long> docIds);
    /**
     * 获取文档库下的所有文档(不分页)
     * @param docLibId    文档库ID
     */
    public List<DocResourcePO> getDocsByLibId(Long docLibId);
    
    List<DocResourcePO> findFavoriteByCondition(Map<String, Object> params);
    
    public List<Long> getDocsByParentFrId(Long parentFrId);
    
    /**
     * 根据物理路径和文件名称查询文档夹及文件
     * 
     * @param logicPaths
     * @param dsm
     * @return
     * @throws BusinessException 
     */
    public List<DocResourcePO> getDocResourceByLogicPathLike(List<String> logicPaths, DocSearchModel dsm) throws BusinessException;

}