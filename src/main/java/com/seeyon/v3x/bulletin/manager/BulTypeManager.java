package com.seeyon.v3x.bulletin.manager;

import java.util.Collection;
import java.util.List;

import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.portal.util.Constants.SpaceType;
import com.seeyon.v3x.bulletin.dao.BulTypeDao;
import com.seeyon.v3x.bulletin.domain.BulType;
import com.seeyon.v3x.bulletin.domain.BulTypeManagers;

/**
 * 公告类型的Manager接口
 * @author wolf
 *
 */
public interface BulTypeManager {

    /**
     * 获取版块ETag
     * @param key 版块ID或其它
     * @return
     */
    public Long getTypeETagDate(String key);

    /**
     * 版块内容有新增、修改、删除、取消发布、归档、移动到其它版块时更新时间戳
     * @param key 版块ID或其它
     */
    public void updateTypeETagDate(String key);

    /**
     * 获取人员ETag
     * @param key 人员ID
     * @return
     */
    public Long getUserETagDate(Long key);

    /**
     * 人员点击公告时更新时间戳
     * @param key 人员ID
     */
    public void updateUserETagDate(Long key);

    public abstract BulTypeDao getBulTypeDao();

    /**
     * 获取全部板块信息
     * @return
     */
    public Collection<BulType> getAllBulletinTypes();

    /**
     * 为了支持集群时双机同步数据，将此方法设为public以便监听程序调用
     * @param bulType
     */
    public void initPartAdd(BulType bulType);

    /**
     * 为了支持集群时双机同步数据，将此方法设为public以便监听程序调用
     * @param bulType
     */
    public void initPartEdit(BulType bulType);

    /**
     * 根据公告类型ID删除公告类型，同时删除公告管理员和公告发起员
     * @param id
     * @throws BusinessException 
     */
    public abstract void delDept(Long id) throws BusinessException;

    /**
     * 查询所有公告类型。支持分页
     * @return
     */
    public abstract List<BulType> findAll();

    /**
     * 查询所有单位公告类型。支持分页--和--不分页--2中
     * @return
     */
    public abstract List<BulType> boardFindAll();

    public abstract List<BulType> boardFindAllByPage();

    public abstract List<BulType> boardFindAllByAccountId(Long accountId);

    /**
     * 获取某个单位或某个自定义空间公告板块列表
     * @param accountId 单位id或空间id
     * @return
     */
    public List<BulType> findAccountBulletinTypes(Long accountId);

    /**
     * 查询所有自定义单位或集团公告类型
     * @param spaceId
     * @param spaceType
     * @param isPage 是否分页
     * @return
     */
    public List<BulType> customAccBoardFindAllByPage(long spaceId, int spaceType, boolean isPage);

    /**
     * 查询自定义单位所有公告类型
     * @param spaceId
     * @param spaceType
     * @return
     */
    public List<BulType> customAccBoardAllBySpaceId(Long spaceId, int spaceType);

    /**
     * 查询所有公告类型。支持分页--和--不分页--2中
     * @return
     */
    public abstract List<BulType> groupFindAll();

    //拿到所有的部门空间的公告
    public List<BulType> departmentFindAll();

    public abstract List<BulType> groupFindAllByPage();

    /**
     * 查询所有外单位公告类型。支持分页
     * @return
     */
    public abstract List<BulType> otherFindAll();

    /**
     * 查询符合条件的公告类型。支持分页
     * @param property
     * @param value
     * @return
     */
    public abstract List<BulType> findByProperty(String property, Object value);

    public List<BulType> findByPropertyNoPaging(String property, Object value);

    /**
     * 查询符合条件的集团公告类型。支持分页
     * @param property
     * @param value
     * @return
     */
    public abstract List<BulType> groupFindByProperty(String property, Object value);

    /**
     * 是否是集团公告板块管理员、审核员
     * 
     * @param memberId
     * @return
     */
    public boolean isGroupBulTypeManager(long memberId);

    /**
     * 判断用户是否当前登陆单位的部门公告管理员,辅助部门公告管理菜单是否出现的权限判断
     * @param memberId  当前用户ID
     * @param loginAccountId   登陆单位ID(用户可跨单位办公)
     * @return 用户是否当前登陆单位的某个部门公告管理员
     * added by Meng Yang 2009-06-23
     * @throws BusinessException 
     */
    public boolean isDepartmentBulTypeManager(long memberId, long loginAccountId);

    /**
     * 判断用户是否某一特定部门的部门公告管理员，用于跨单位兼职时的权限判断
     * @param memberId 当前用户ID
     * @param deptId   当前部门ID
     * @return 是否为当前部门公告管理员
     */
    public boolean isManagerOfThisDept(long memberId, Long deptId) throws BusinessException;

    /**
     * 是否是集团公告板块撰写者
     * 
     * @param memberId
     * @return
     */
    public boolean isGroupBulTypeAuth(long memberId);

    /**
     * 取得有我来审核的集团公告板块
     * 
     * @param memberId
     * @return
     */
    public List<BulType> getAuditGroupBulType(long memberId);

    /**
     * 取得有我来审核的单位公告板块
     * 
     * @param memberId
     * @return
     */
    public List<BulType> getAuditUnitBulType(long memberId);

    /**
     * 获取由我来审核的自定义单位公告板块
     * @param memberId
     * @param spaceId
     * @param spaceType
     * @return
     */
    public List<BulType> getAuditUnitBulType(long memberId, long spaceId, int spaceType);

    /**
     * 只根据用户，不根据当前单位
     */
    public List<BulType> getAuditUnitBulTypeOnlyByMember(long memberId);

    /**
     * 得到可以审核的版块列表
     * 单位类型时，accountId 为 null 说明不验证单位
     *
     */
    public List<BulType> getAuditTypeByMember(Long memberId, SpaceType spaceType, Long accountId);

    public List<BulType> getManagerTypeByMember(Long memberId, SpaceType spaceType, Long accountId);

    public List<BulType> getWriterTypeByMember(Long memberId, SpaceType spaceType, Long accountId);
    //客开s
    public List<BulType> getPaiBanTypeByMember(Long memberId, SpaceType spaceType, Long accountId);
    //客开e
    
    /**
     * 根据公告类型ID查询
     * @param id
     * @return
     */
    public abstract BulType getById(Long id);

    /**
     * 更新部门时用到
     * @param id
     * @return
     */
    public abstract BulType getByDeptId(Long id);

    /**
     * 保存公告类型。同时保存公告管理员列表。
     * @param type
     * @return
     * @throws BusinessException
     */
    public abstract BulType save(BulType type) throws BusinessException;

    public BulType saveBulType(BulType type, boolean isNew);

    /**
     * 保存某个公告类型的发起员。在添加之前会删除原来该公告类型的发起员
     * @param typeId 公告类型ID
     * @param writeIds 发起员的用户ID列表
     */
    public void saveWriteByType(Long typeId, String[][] writeIds);

    /**
     * 得到 writeFlag 的BulTypeManagers
     * 
     */
    public List<BulTypeManagers> findTypeWriters(BulType bt);

    /**
     * 初始化类型下总数
     */
    public void setTotalItemsOfType(List<BulType> types);

    /**
     * 逻辑删除版块
     */
    public void setTypeDeleted(List<Long> ids);

    /**
     * 用于新建单位时初始化公告板块
     * @param accountId  单位id
     */
    public void initBulType(long accountId);

    /**
     * 判断用户是否管理员
     */
    public boolean isManagerOfType(long typeId, long userId);

    /**
     * 用于更新公告板块的排序顺序
     * @param accountId
     */
    public void updateBulTypeOrder(String[] bulTypeIds);

    /**
     * 取得某个用户有新建权限的所有版块
     */
    public List<BulType> getTypesCanNew(Long memberId, SpaceType spaceType, Long accountId);

    /**
     * 判断用户是否有新建权限
     */
    public boolean hasAuth(Long memberId, Long accountId);

    /**
     * 左上角的按公告名称查询
     */
    public List<BulType> getBulByTypeName(Long menmberID, String bulTypeName, boolean isIgnoreUsed, int spaceType);

    /**
     * 左上角的按公告数量查询
     */

    public List<BulType> getBulByTol(Long memberID, String total, String matches, boolean isIgnoreUsed, int spaceType);

    /**
     * 按公告是否需要审核查询
     */
    public List<BulType> findByAuditFlag(Long memberId, String flag, boolean isIgnoreUsed, int spaceType);

    /**
     * 按公告审核员名字查询
     */
    public List<BulType> findByAuditUserName(Long memberId, String username, boolean isIgnoreUsed, int spaceType);

    /**
     * 查询可以发布的公告的版块
     * @param memberId
     * @param spaceType
     * @param accountId
     * @return
     */
    public List<BulType> getTypesCanCreate(Long memberId, SpaceType spaceType, Long accountId);

    /**
     * 删除人员时修改板块的管理员、审核员、发起者
     * @param id
     * @is isNotGroup 是否排除集团板块
     * @throws BusinessException
     */
    public void delMember(Long id, boolean isNotGroup) throws BusinessException;

    public BulType createBulTypeByDept(Long spaceId, String spaceName, int spaceType);

    /**
     * 用于判断是否是公告审核员
     */
    public boolean isAuditorOfBul(Long memberId);

    /**
     * 获取所有自定义空间的板块（部门、自定义团队、自定义单位、自定义集团）
     * @return
     */
    public List<BulType> getAllCustomTypes();
    
    /**
     * 获取能查看的公告版块id
     * @param user
     * @return
     * @throws BusinessException
     */
    public List<Long> getCanSeeBoard(User user) throws BusinessException;

}