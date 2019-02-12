/**
 * $Author: renw $
 * $Rev: 47640 $
 * $Date:: 2015-03-24 11:23:46#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
package com.seeyon.ctp.privilege.manager;

import java.util.HashSet;
import java.util.List;
import java.util.Map;

import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.privilege.bo.PrivMenuBO;
import com.seeyon.ctp.privilege.bo.PrivTreeNodeBO;
import com.seeyon.ctp.privilege.po.PrivMenu;
import com.seeyon.ctp.privilege.po.PrivRoleMenu;
import com.seeyon.ctp.util.FlipInfo;

/**
 * <p>Title: 菜单操作的接口</p>
 * <p>Description: 菜单对象查询和更新的接口方法</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 */
/**
 * @author lenove
 *
 */
public interface PrivilegeMenuManager {

    /**
     * 根据菜单ID获取到菜单
     * @param menuId 菜单ID
     * @return 菜单对象
     */
    public PrivMenuBO findById(Long menuId);

    /**
     * 根据人员ID和所属单位ID查找到关联的菜单
     * @param memberId 人员ID
     * @param accountId 单位ID
     * @return 菜单Map对象
     * @throws 如果发生异常抛出异常 com.seeyon.ctp.common.exceptions.BusinessException
     */
    public Map<Long, PrivMenuBO> getByMember(Long memberId, Long accountId) throws BusinessException;
    
    public Map<Long, PrivMenuBO> getByMember0(Long memberId, Long accountId) throws BusinessException;
    /**
     * 返回List
     * @param roleIds
     * @return
     */
    public List<PrivMenuBO> getListByRole(Long[] roleIds)throws BusinessException;
    /**
     * 获取不可分配的资源
     * @return
     */
    public List<PrivMenuBO> getAllocatedDisableMenu() throws BusinessException;
    
    /**
     * 
     * @方法名称: getShortCutMenuOfMember
     * @功能描述: 获取人员所有快捷菜单
     * V6.0中，修改了校验方法，弃用这个方法
     * @deprecated
     */
    public List<PrivMenuBO> getShortCutMenuOfMember(Long memberId, Long accountId) throws BusinessException ;
    
    
    
    /**
     * 根据角色查找到关联的菜单
     * @param roleIds 角色ID数组
     * @return 菜单Map对象
     */
    public Map<Long, PrivMenuBO> getByRole(Long[] roleIds);
    
    
    /**
     * 根据角色查找到关联的菜单不包含父菜单
     * @param roleIds 角色ID数组
     * @return 菜单Map对象
     */
    public Map<Long, PrivMenuBO> getByRoleWithoutParent(Long[] roleIds);

    /**
     * 根据角色查找到关联的菜单资源
     * @param roleIds 角色ID数组
     * @return 菜单Map对象
     */
    public Map<Long, List<Long>> getMenuResourceByRole(Long[] roleIds);

    /**
     * 新建菜单
     * @param menu 需要新建的菜单对象
     * @return 创建菜单的ID
     */
    public PrivMenuBO create(PrivMenuBO menu) throws BusinessException;

    /**
     * 批量新建菜单
     * @param menus 需要新建的菜单对象
     */
    public void createPatch(List<PrivMenuBO> menus) throws BusinessException;

    /**
     * 更新菜单
     * @param menu 需要更新的菜单对象
     * @return 更新菜单的ID
     * @throws 如果发生异常抛出异常 com.seeyon.ctp.common.exceptions.BusinessException
     */
    public Long updateMenu(PrivMenuBO menu) throws BusinessException;

    /**
     * 批量更新菜单
     * @param menus 需要更新的菜单对象
     */
    public void updatePatch(List<PrivMenuBO> menus) throws BusinessException;

    /**
     * 更新菜单的路径和层级，用于菜单维护页面更新菜单树
     * @param parent 需要更新的菜单对象的父菜单ID
     * @param menuIds 需要更新的菜单ID
     * @throws 如果发生异常抛出异常 com.seeyon.ctp.common.exceptions.BusinessException
     */
    public void updateMenuPath(Long parent, List<String> menuIds) throws BusinessException;

    /**
     * 删除菜单
     * @param menu 需要删除的菜单
     * @return 是否成功
     * @throws 如果发生异常抛出异常 com.seeyon.ctp.common.exceptions.BusinessException
     */
    public boolean deleteMenu(PrivMenu menu) throws BusinessException;

    /**
     * 根据父菜单删除下级菜单
     * @param menu 父菜单ID
     * @return 是否成功
     * @throws 如果发生异常抛出异常 com.seeyon.ctp.common.exceptions.BusinessException
     */
    public boolean deleteMenuByParentId(Long menu) throws BusinessException;

    /**
     * 删除菜单
     * @param res 要删除的菜单
     * @return 是否成功
     * @throws 如果发生异常抛出异常 com.seeyon.ctp.common.exceptions.BusinessException
     */
    public boolean deleteMenu(Long[] menus) throws BusinessException;

    /**
     * 查找符合条件的菜单
     * @param menu 使用PrivMenu的实例对象中设置的属性值作为查询条件
     * @return 找到的菜单对象列表或者返回null在没有符合条件的菜单时
     */
    public List<PrivMenuBO> findMenus(PrivMenuBO menu);
    /**
     * 根据入口资源的ID查询菜单
     * @param resId
     * @return
     */
    public List<PrivMenuBO> findMenusbyEnterRes(Long resId);
    /**
     * 获取系统设置停用的菜单
     * @return
     */
    public List<PrivMenuBO> getConfigDisableMenu();

    /**
     * 查找符合条件的菜单
     * @param fi 翻页信息对象
     * @param param 查询条件Map
     * @return 找到的菜单对象列表或者返回null在没有符合条件的菜单时
     */
    public FlipInfo findMenus(FlipInfo fi, @SuppressWarnings("rawtypes") Map param);

    /**
     * 复制产品版本的菜单配置
     * @param fromVersion 
     * @param toVersion 
     * @throws 如果发生异常抛出异常 com.seeyon.ctp.common.exceptions.BusinessException
     */
    public void copyMenus(String fromVersion, String toVersion) throws BusinessException;

    /**
     * 获得菜单的父菜单
     * @param menu 菜单
     * @throws BusinessException 如果发生异常抛出异常 com.seeyon.ctp.common.exceptions.BusinessException
     */
    public Long findParentMenu(PrivMenuBO menu) throws BusinessException;

    /**
     * 根据父菜单ID获得下级菜单
     * @param menu 父菜单id
     * @throws BusinessException 如果发生异常抛出异常 com.seeyon.ctp.common.exceptions.BusinessException
     */
    public List<PrivMenu> findSubMenus(Long menu) throws BusinessException;
    /**
     * 根据人员ID获取其有权限的业务生成器的菜单
     * @param memberId 人员ID
     * @return
     * @throws BusinessException
     */
    public List<PrivMenuBO> getBusinessMenuByMember(Long memberId,Long AccountId) throws BusinessException;
    
    
    /**
     * 根据人员ID获取其有权限的业务生成器的菜单
     * @param memberId 人员ID
     * @param AccountId 单位编号
     * @param containLinkSystem 是否包含关联系统菜单
     * @return
     * @throws BusinessException
     */
    public List<PrivMenuBO> getBusinessMenuByMember(Long memberId,Long AccountId,Boolean containLinkSystem) throws BusinessException;
    
    /**
     * @param menu
     * @param parent
     * @return
     */
    public PrivMenuBO getMenuPath(PrivMenuBO menu, PrivMenuBO parent);

    /**
     * @param ids 业务生成器的菜单id
     * @return
     */
    Map<Long, PrivMenuBO> getPrivMenu4Form(Long[] ids);

    /**
     * 
     * @方法名称: getMenusOfMember
     * @功能描述: 根据人员ID和所属单位ID查找关联的资源
     * @参数 ：@param memberId 人员ID
     * @参数 ：@param accountId 单位ID
     * @参数 ：@return 资源对象列表
     * @参数 ：@throws 如果发生异常抛出异常 BusinessException
     * @返回类型：List<PrivMenuBO>
     * @创建时间 ：2015年12月8日 上午8:30:24
     * @创建人 ： FuTao
     * @修改人 ： 
     * @修改时间 ：
     */
    public List<PrivMenuBO> getMenusOfMember(Long memberId, Long accountId) throws BusinessException;

    
    /**
     * 
     * @方法名称: getTreeNodes
     * @功能描述: 获取菜单树
     * @参数 ：@param memberId 用户编号
     * @参数 ：@param accountId 单位编号
     * @参数 ：@param roleId 角色编号
     * @参数 ：@param showAll 是否显示所有
     * @参数 ：@param version 
     * @参数 ：@param appResCategory 资源类型
     * @参数 ：@param isAllocated 是否可以分配
     * @参数 ：@param treeNodes4Back 
     * @参数 ：@param treeNodes4Front 预制的
     * @参数 ：@param isCheckBusiness 是否校验业务生成器
     * @参数 ：@return
     * @参数 ：@throws BusinessException
     * @返回类型：List<PrivTreeNodeBO>
     * @创建时间 ：2015年12月8日 上午8:36:21
     * @创建人 ： FuTao
     * @修改人 ： 
     * @修改时间 ：
     */
	public Map<String, List<PrivTreeNodeBO>> getTreeNodes(String memberId, String accountId, String roleId, String showAll, String version,
			String appResCategory, String isAllocated, List<PrivTreeNodeBO> treeNodes4Back,
			List<PrivTreeNodeBO> treeNodes4Front,boolean isCheckBusiness) throws BusinessException;

	/**
	 * 
	 * @方法名称: findUnModifiable
	 * @功能描述: 获取不可用的菜单
	 * @参数 ：@return
	 * @返回类型：HashSet<Long>
	 * @创建时间 ：2015年12月9日 下午2:03:57
	 * @创建人 ： FuTao
	 * @修改人 ： 
	 * @修改时间 ：
	 */
	public HashSet<Long> findUnModifiable();
	/**
	 * 
	 * @方法名称: cleanPrivData
	 * @功能描述: 清理菜单数据
	 * @参数 ：@param roleId
	 * @参数 ：@throws BusinessException
	 * @返回类型：void
	 * @创建时间 ：2015年12月17日 下午8:43:53
	 * @创建人 ： FuTao
	 * @修改人 ： 
	 * @修改时间 ：
	 */
	public void cleanPrivData(Long roleId) throws BusinessException;
	
	/**
     * 
     * @方法名称: getMenuByCode
     * @功能描述: 通过原resource_code查询菜单
     * @参数 ：@param code
     * @参数 ：@return
     * @返回类型：PrivMenuBO
     * @创建时间 ：2015年12月9日 下午5:04:27
     * @创建人 ： FuTao
     * @修改人 ： 
     * @修改时间 ：
     */
	public PrivMenuBO getMenuByCode(String code);
	/**
     * @param role 角色ID
     * @return 不能修改的角色和资源关系列表, Map<菜单ID, PrivRoleMenu>
     */
    public Map<Long, PrivRoleMenu> findUnModifiableRoleMenuByRole(Long role);
    
    /**
     * 
     * @方法名称: setPlugInMenuDao
     * @功能描述: 加载插件菜单
     * @参数 ：@param path 菜单path
     * @参数 ：@param level 菜单级别
     * @参数 ：@param existMenuId 如果已经存在不用加载 返回false
     * @参数 ：@return
     * @返回类型：boolean
     * @创建时间 ：2016年4月5日 下午8:25:26
     * @创建人 ： FuTao
     * @修改人 ： 
     * @修改时间 ：
     */
    public boolean setPlugInMenuDao(String path, String level, Long existMenuId);

    /**
     * 
     * @throws BusinessException 
     * @方法名称: getMenusOfMemberForM1
     * @功能描述: 获取插件菜单
     * @参数 ：@param memberId
     * @参数 ：@param accountId
     * @参数 ：@return
     * @返回类型：List<PrivMenuBO>
     * @创建时间 ：2016年4月6日 上午11:46:21
     * @创建人 ： FuTao
     * @修改人 ： 
     * @修改时间 ：
     */
	public List<PrivMenuBO> getMenusOfMemberForM1(Long memberId, Long accountId) throws BusinessException ;

	  /**
     * 根据角色获得关联的URL列表
     * @param roleIds 角色ID数组
     * @return 关联的资源URL列表
     */
	public HashSet<String> getUrlsByRole(Long[] roleIds);

	/**
	 * 
	 * @throws BusinessException 
	 * @方法名称: getMenuValidity
	 * @功能描述: 过去菜单本地缓存是否过期
	 * @参数 ：@param memberId
	 * @参数 ：@param accountId
	 * @参数 ：@return
	 * @参数 ：@throws BusinessException
	 * @返回类型：boolean
	 * @创建时间 ：2016年7月27日 下午2:00:29
	 * @创建人 ： FuTao
	 * @修改人 ： 
	 * @修改时间 ：
	 */
	public boolean getMenuValidity(Long memberId, Long accountId) throws BusinessException;
	
	
	/*********************************************原menuCacheManager*************************************************************/
	
	/**
     * 根据人员ID_单位ID获取菜单list
     * @param memberId
     * @return
     * @throws BusinessException 
     */
    public Map<Long, PrivMenuBO> getMenus(Long memberId, Long accountId) throws BusinessException;
    
    /**
     * 更新当前人员缓存和时间戳
     */
    public void updateBiz();
    /**
     * 更新指定单位人员的缓存和时间戳
     * @param memberid 人员编号
     * @param accountId 单位编号
     */
    public void updateBiz(Long memberid, Long accountId);
    /**
     * 更新人员列表的菜单缓存和时间戳
     * @param memberIds 人员列表<人员编号>
     */
    public void updateBiz(List<Long> memberIds);
    /**
     * 
     * @方法名称: reSetMM1Menus
     * @功能描述: 判断M1是否启用，如果启用缓存中没有数据则重新加载数据
     * @参数 ：@param memberId
     * @参数 ：@param accountId
     * @参数 ：@return
     * @参数 ：@throws BusinessException
     * @返回类型：Map<Long,PrivMenuBO>
     * @创建时间 ：2016年4月6日 上午11:35:11
     * @创建人 ： FuTao
     * @修改人 ： 
     * @修改时间 ：
     */
    public Map<Long, PrivMenuBO> reSetMM1Menus(Long memberId, Long accountId) throws BusinessException;
	/**
	 * 
	 * @方法名称: getMenuByRole
	 * @功能描述: 通过角色查询菜单
	 * @参数 ：@param roleIds
	 * @参数 ：@return
	 * @参数 ：@throws BusinessException
	 * @返回类型：Long[]
	 */
	public Long[] getMenusByRole(Long[] roleIds) throws BusinessException;

	/**
	 * 
	 * @方法名称: getResourceCode
	 * @功能描述: 获取当前用户的菜单资源集合
	 * @参数 ：@param currentUser
	 * @参数 ：@return
	 * @参数 ：@throws BusinessException
	 * @返回类型：List<String>
	 */
	public List<String> getResourceCode(Long memberId, Long accountId) throws BusinessException;

	/**
	 * 
	 * @方法名称: updateMemberMenuLastDate
	 * @功能描述: 更新用户被修改的最后时间，一般用于后台修改用户
	 * @参数 ：@param memberId 用户编号
	 * @参数 ：@param accountId 单位编号
	 * @返回类型：void
	 */
	public void updateMemberMenuLastDate(Long memberId, Long accountId);

	/**
	 * 
	 * @方法名称: updateMemberMenuLastDateByRoleId
	 * @功能描述: 通过角色更新用户被修改该的最后时间一般用于后台修改角色分配人员
	 * @参数 ：@param roleId 角色编号
	 * @参数 ：@param accountId 单位编号，可为空
	 * @返回类型：void
	 * @创建时间 ：2016年8月21日 上午10:51:00
	 */
	public void updateMemberMenuLastDateByRoleId(Long roleId,Long accountId,List<V3xOrgMember> members);
	/**
	 * 
	 * @方法名称: updateLocalMemberMenuLastDate
	 * @功能描述: 当前用户本地更新最后修改时间
	 * @参数 ：@param memberId 用户编号
	 * @参数 ：@param accountId 但会编号
	 * @返回类型：void
	 */
	public void updateLocalMemberMenuLastDate(Long memberId, Long accountId);

	/**
	 * 
	 * @方法名称: validateMemberMenuLastDate
	 * @功能描述: 校验本地菜单更新时间是否和同步缓存一致
	 * @参数 ：@param memberId
	 * @参数 ：@param accountId
	 * @参数 ：@return
	 * @返回类型：boolean
	 * @创建时间 ：2016年8月2日 下午5:02:31
	 * @修改人 ： 
	 * @修改时间 ：
	 */
	public boolean validateMemberMenuLastDate(Long memberId, Long accountId);

	/**
	 * 获取所有的菜单 
	 * @param treeNodes4Back
	 * @param treeNodes4Front
	 * @return
	 * @throws BusinessException
	 */
	public Map<String, List<PrivTreeNodeBO>> getAllMenuNodes(List<PrivTreeNodeBO> treeNodes4Back,List<PrivTreeNodeBO> treeNodes4Front) throws BusinessException;

	/**
	 * 获取最大的path
	 * @param pathIndex 菜单的path （非必填）
	 * @param level 菜单层级（必填）
	 * @return
	 */
	public String getMaxPath(String pathIndex, Integer level);

	/**
	 * 
	 * @param pathIndex 菜单的path （必填）
	 * @param level 菜单层级（必填）
	 * @return
	 */
	public Boolean verifyPath(String pathIndex, Integer level);




	
}