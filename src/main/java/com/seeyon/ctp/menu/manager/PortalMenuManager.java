package com.seeyon.ctp.menu.manager;

import java.util.List;
import java.util.Map;

import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.login.bo.MenuBO;
import com.seeyon.ctp.portal.po.PortalSpaceMenu;
import com.seeyon.ctp.portal.space.bo.MenuTreeNode;

public interface PortalMenuManager {

	/**
	 * 
	 * @方法名称: getMenusOfMember
	 * @功能描述: 获取用户的所有授权菜单
	 * @参数 ：@param user 登录用户
	 * @参数 ：@return
	 * @参数 ：@throws BusinessException
	 * @返回类型：List<MenuBO>
	 */
	public List<MenuBO> getMenusOfMember(User user) throws BusinessException;

	/**
	 * 
	 * @方法名称: getCustomizeMenusOfMember
	 * @功能描述: 获取用户定制显示的菜单
	 * @参数 ：@param user 登录用户
	 * @参数 ：@return
	 * @参数 ：@throws BusinessException
	 * @返回类型：List<MenuBO>
	 */
	public List<MenuBO> getCustomizeMenusOfMember(User user) throws BusinessException;
	
	/**
	 * 
	 * @方法名称: getCustomizeMenusOfMember
	 * @功能描述: 获取用户定制显示的菜单
	 * @参数 ：@param userId 登录用户
	 * @参数 ：@param accountId 单位编号
	 * @参数 ：@param userId 是否区别管理员
	 * @参数 ：@return
	 * @参数 ：@throws BusinessException
	 * @返回类型：List<MenuBO>
	 */
	public List<MenuBO> getMenusOfMember(Long userId, Long accountId, boolean isAdmin) throws BusinessException;
	/**
	 * 
	 * @方法名称: getCustomizeMenusOfMember
	 * @功能描述: 获取用户定制显示的菜单
	 * @参数 ：@param user 登录用户
	 * @参数 ：@param isChange 是否强制初始化个人菜单
	 * @参数 ：@return
	 * @参数 ：@throws BusinessException
	 */
	public List<MenuBO> getCustomizeMenusOfMember(User user, Boolean isChange) throws BusinessException;
	/**
	 * 
	 * @方法名称: getCustomizeMenusOfMember
	 * @功能描述: 获取用户定制显示的菜单
	 * @参数 ：@param user 登录用户
	 * @参数 ：@param menus 所有授权的菜单，可以为空
	 * @参数 ：@param isChange 是否强制初始化个人菜单
	 * @参数 ：@return
	 * @参数 ：@throws BusinessException
	 */
	public List<MenuBO> getCustomizeMenusOfMember(User user, List<MenuBO> menus, Boolean isChange) throws BusinessException;
	/**
	 * 
	 * @方法名称: getCustomizeMenusOfMember
	 * @功能描述: 获取用户定制显示的菜单
	 * @参数 ：@param user 登录用户
	 * @参数 ：@param menus 所有授权的菜单，可以为空
	 * @参数 ：@return
	 * @参数 ：@throws BusinessException
	 * @返回类型：List<MenuBO>
	 */
	public List<MenuBO> getCustomizeMenusOfMember(User user, List<MenuBO> menus) throws BusinessException;

	/**
	 * 
	 * @方法名称: getCustomizeMenusOfMember
	 * @功能描述: 获取用户定制显示的菜单
	 * @参数 ： userId 用户编号
	 * @参数 ： accountId 单位编号
	 * @参数 ： isadmin 是否管理员
	 * @参数 ： menus 菜单集合（可以为空）
	 * @参数 ： cmenus 自定义菜单（可以为空）
	 * @return
	 * @throws BusinessException
	 */
	public List<MenuBO> getCustomizeMenus(Long userId, Long accountId, boolean isadmin, List<MenuBO> menus,
			Map<String, String> cmenus) throws BusinessException;

	/**
	 * 获取用户菜单排序不显示的菜单
	 * 
	 * @param user
	 * @param allMenus
	 *            用户所有的授权菜单
	 * @param customizeMenus
	 *            用户定制显示的菜单
	 * @return
	 * @throws BusinessException
	 */
	public List<MenuBO> getUnselectedMenusOfMember(User user, List<MenuBO> allMenus, List<MenuBO> customizeMenus)throws BusinessException;
	
	/**
	 * 保存用户菜单排序信息
	 * 
	 * @param user
	 * @param menuIds
	 *            排好序的菜单ID列表
	 * @throws BusinessException
	 */
	public void saveMenuSort(String selectedMenusString) throws BusinessException;
	
	/**
	 * 保存空间菜单
	 * 
	 */
	public void saveSpaceMenu(Long spaceId, List<Map<String, Object>> menus);
	/**
	 * 删除空间菜单
	 * 
	 */
	public void deleteSpaceMenu(Long spaceId);
	
	/**
	 * 获取空间菜单
	 * 
	 * @throws BusinessException
	 */
	public List<MenuTreeNode> getSpaceMenuIds(Long spaceId) throws BusinessException;
	/**
	 * 获取系统默认前端菜单
	 * 
	 * @return 返回系统默认前端菜单树List<PrivTreeNodeBO>
	 * @throws BusinessException
	 */
	public List<MenuTreeNode> getAllUseAbleMenus() throws BusinessException;
	/**
	 * 
	 * @方法名称: findSpaceMenusBySpaceId
	 * @功能描述: 通过空间ID,查询空间菜单
	 * @参数 ：@param spaceId 空间编号
	 * @参数 ：@return
	 * @返回类型：List<PortalSpaceMenu>
	 */
	public List<PortalSpaceMenu> findSpaceMenusBySpaceId(Long spaceId);

	
	

}
