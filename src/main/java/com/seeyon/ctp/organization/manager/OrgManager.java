/**
 * $Author: $
 * $Rev: $
 * $Date:: 2012-06-05 15:14:56#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */

package com.seeyon.ctp.organization.manager;

import java.util.Date;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.OrgConstants.RelationshipObjectiveName;
import com.seeyon.ctp.organization.OrgConstants.TeamMemberType;
import com.seeyon.ctp.organization.bo.MemberPost;
import com.seeyon.ctp.organization.bo.MemberRole;
import com.seeyon.ctp.organization.bo.OrgRoleDefaultDefinition;
import com.seeyon.ctp.organization.bo.OrgTypeIdBO;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgDutyLevel;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgLevel;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgPost;
import com.seeyon.ctp.organization.bo.V3xOrgRelationship;
import com.seeyon.ctp.organization.bo.V3xOrgRole;
import com.seeyon.ctp.organization.bo.V3xOrgTeam;
import com.seeyon.ctp.organization.bo.V3xOrgUnit;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.UniqueList;
import com.seeyon.ctp.util.annotation.AjaxAccess;

/**
 * <p>Title: 组织模型OrgManager接口</p>
 * <p>Description: 接口提供组织模型信息与状态等查询</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * <p>接口维护规则：本接口用于提供外部应用对组织模型信息的查询支持，对组织模型信息维护管理等接口请不要定义于此�?</p>
 * 
 * @see com.seeyon.ctp.organization.bo.V3xOrgMember
 * @see com.seeyon.ctp.organization.bo.V3xOrgAccount
 * @see com.seeyon.ctp.organization.bo.V3xOrgLevel
 * @see com.seeyon.ctp.organization.bo.V3xOrgPost
 * @see com.seeyon.ctp.organization.bo.V3xOrgRole
 * @see com.seeyon.ctp.organization.bo.V3xOrgTeam
 * @see com.seeyon.ctp.organization.bo.V3xOrgDepartment
 * @see com.seeyon.ctp.organization.bo.V3xOrgRelationship
 * @see com.seeyon.ctp.organization.bo.V3xOrgEntity
 * 
 * @author gaohang
 * @author lilong
 */

public interface OrgManager {
	
	/**
	 * 是否允许显示人员卡片
	 * @param memberid_me
	 * @param memeberid2_other
	 * @return
	 * @throws BusinessException
	 */
	@AjaxAccess
	public boolean canShowPeopleCard(Long memberid_me,Long memeberid2_other) throws BusinessException;
	 /**
     * 获取插件判断，返回不应该出现的角色列�?
     * @return 无效角色列表
     * @throws BusinessException
     */
    public List<V3xOrgRole> getPlugDisableRole(Long accountId) throws BusinessException;
	/**
	 * 获取部门下所有member的bo，不包含子部门，包含外部人员，不包含无效人员
	 * @param departmentId
	 * @return
	 */
	public List getAllMembersByDepartmentBO(Long departmentId);
	/**
	 * 获取当前用户的所属部门（包含兼职的），�?�人格式
	 * @return
	 * @throws BusinessException
	 */
	public String getLoginMemberDepartment(String accountId) throws BusinessException;

    /**
     * 获取实体
     * 
     * @param <T>
     * @param classType
     *            实体�?
     * @param id
     *            实体的ID
     * @return 组织模型实体
     * @throws BusinessException
     */
    <T extends V3xOrgEntity> T getEntityById(Class<T> classType, Long id) throws BusinessException;
    
    /**
     * 获取实体�?<b>请不要调用setter，否则天诛地�?</b>
     * 
     * @param classType
     * @param id
     * @return
     * @throws BusinessException
     */
    <T extends V3xOrgEntity> T getEntityByIdNoClone(Class<T> classType, Long id) throws BusinessException;

    /**
     * 获取实体
     * 
     * @param entityType
     *            实体类型
     * @param id
     *            实体的ID
     * @return 组织模型实体
     * @throws BusinessException
     */
    V3xOrgEntity getEntity(String entityType, Long id) throws BusinessException;
    
    /**
     * 判断当前人员与某人员�?在单位和兼职单位是否在互相可�?
     * @param currentMemberId 当前人员
     * @param memberId 被比较人�?
     * @return true可见false不可�?
     */
    boolean checkAccessAccount(Long currentMemberId, Long memberId) throws BusinessException;

    /**
     * 把组织类型和id用�?�|”连接，该方法自动分解，返回对应数据
     * 
     * @param typeAndId
     *            �?"|"组合的字符串，如：Member|-92874958395或�?�Department|3461234123458
     * @return 组织模型实体
     * @throws BusinessException
     */
    V3xOrgEntity getEntity(String typeAndId) throws BusinessException;
    
    /**
     * 按照ID取任意类型对象，读取的顺序依次是：人、部门�?�岗位�?�单位�?�职级�?�组、角色（<b>只读取有效的，停用的不读�?</b>�?
     * @param id
     * @return
     * @throws BusinessException
     */
    V3xOrgEntity getEntityAnyType(Long id) throws BusinessException;
    
    /**
     * 把组织类型和id用�?�|”连接，该方法自动分解，返回对应数据
     * <br>用于解析选人界面部门角色和部门岗位返回实�?
     * @param typeAndId
     *            �?"|"组合的字符串，如：Department_Post|-92874958395_3461234123458
     * @return 返回列表，get(0)单位或部门等组织实体，get(1)岗位或角色等组织实体
     * @throws BusinessException
     */
    List<V3xOrgEntity> getEntitys4Merge(String typeAndId) throws BusinessException;
    
    /**
     * 判断当前登录用户是否有是部门管理�?
     * @return
     * @throws BusinessException
     */
    boolean isDepartmentAdmin() throws BusinessException;
    /**
     * 获取单位下所有人员，不包含兼�?
     * @param accountId
     * @return
     * @throws BusinessException
     */
    public List<V3xOrgMember> getAllMembersWithOutConcurrent(Long accountId) throws BusinessException;
    
    /**
     * 判断当前人员是否是HR管理�?
     * @return
     * @throws BusinessException
     */
    public boolean isHRAdmin() throws BusinessException;
    
	/**
	 * 根据实体的属性从表中查找单个实体(无需载入关系,适用于七大实�?)
	 * 
	 * @param entityClassName 实体类名�?
	 * @param property 属�?�名�?
	 * @param value 属�?��??
	 * @param accountId 单位id
	 * @return all persistent instances of the <code>Entity</code> entity.
	 */
	V3xOrgEntity getEntityNoRelation(String entityClassName, String property,
			Object value, Long accountId) throws BusinessException;

    /**
     * 把多项组织类型和id�?","以及“|”连接，格式必须�?../SelectPeople/Element.js中产生的�?致�?�该方法自动分解，返回对应数�?
     * 
     * @param typeAndIds
     *            先用","，再�?"|"组合的字符串，如：Member|-92874958395,Department|3461234123458,Department|5435234764545
     * @return 实体列表
     * @throws BusinessException
     */
    List<V3xOrgEntity> getEntities(String typeAndIds) throws BusinessException;

    /**
     * 根据实体的属性从表中查找实体
     * 
     * @param entityClassName 实体�?
     * @param property 属�??
     * @param value 属�?��??
     * @param accountId 单位id
     * @return all persistent instances of the <code>Entity</code> entity.
     */
    List<V3xOrgEntity> getEntityList(String entityClassName, String property, Object value, Long accountId)
            throws BusinessException;

	/**
	 * 当你的value参数是String类型时，才能用该方法，千万不要把Long转成String，这是不道德�?
	 * 
	 * @param entityClassName 实体类的名称
	 * @param property 属�??
	 * @param value 属�?��??
	 * @param accountId 单位id
	 * @return 实体列表
	 * @throws BusinessException
	 */
	List<V3xOrgEntity> getEntityList(String entityClassName, String property,
			String value, Long accountId) throws BusinessException;

    /**
     * 根据属�?�和属�?��?�获取符合条件的实体列表(支持分页)
     * @param entityClassName 实体�?
     * @param property 属�??
     * @param value 属�?��??
     * @param accountId 单位id
     * @param isPaginate 是否分页:true分页false不分�?
     * @return 实体列表
     * @throws BusinessException
     */
    List<V3xOrgEntity> getEntityList(String entityClassName, String property, Object value, Long accountId,
            boolean isPaginate) throws BusinessException;
    /**
     * 根据属�?�和属�?��?�获取符合条件的实体列表(支持分页)
     * @param entityClassName 实体�?
     * @param property 属�??
     * @param value 属�?��??
     * @param accountId 单位id
     * @param isPaginate 是否分页:true分页false不分�?
     * @param equal  字符串类型的参数是否完全匹配，true:完全匹配 ，用=�? false:模糊匹配�? 用like
     * @return 实体列表
     * @throws BusinessException
     */
    List<V3xOrgEntity> getEntityList(String entityClassName, String property, Object value, Long accountId,
            boolean isPaginate,boolean equal) throws BusinessException;

    /**
     * 根据类型及ID查询�?属人�?
     * 
     * 把多项组织类型和id�?","以及“|”连接，格式必须�?../SelectPeople/Element.js中产生的�?致�?�该方法自动分解，返回对应数�?
     * 
     * @param typeAndIds
     *            先用","，再�?"|"组合的字符串，如：Member|-92874958395,Department|3461234123458,Department|5435234764545<br>
     *            如果是Department_Role，这�?123123434_231234236，兼容系统预置角�?123123434_DeptAdmin
     * @return
     * @throws BusinessException
     */
    Set<V3xOrgMember> getMembersByTypeAndIds(String typeAndIds) throws BusinessException;

    /**
     * 从全�?获取实体
     * 
     * @param entityType 实体类型
     * @param id 实体id
     * @return 具体实体对象
     * @throws BusinessException
     */
    V3xOrgEntity getGlobalEntity(String entityType, Long id) throws BusinessException;

    /*-------------------------单位操作---------------------------*/

    /**
	 * 根据登录名获取该人员�?在单位实体对�?
	 * 
	 * @param loginName 人员登录�?
	 * @return �?在单位实�?
	 * @throws BusinessException
	 */
    V3xOrgAccount getAccountByLoginName(String loginName) throws BusinessException;

    /**
	 * 返回当前单位的子单位，包含他自己
	 * 
	 * @param accountId 单位id
	 * @param firstLayer 是否只取第一�?: true只取第一层子单位  false查询�?有子单位
	 * @return 子单位列�?
	 * @throws BusinessException
	 */
    List<V3xOrgAccount> getChildAccount(Long accountId, boolean firstLayer) throws BusinessException;

    /**
	 * 获得当前单位�?在树的根单位, 当前只能有一个根单位
	 * 
	 * @return 单位实体
	 * @throws BusinessException
	 */
    V3xOrgAccount getRootAccount() throws BusinessException;
    
    /**
     * 获得当前单位�?在树的根单位, 当前只能有一个根单位；如果是独立单位就返�?<code>null</code>
     * 
     * @param accountId
     * @return
     * @throws BusinessException
     */
    V3xOrgAccount getRootAccount(long accountId) throws BusinessException;

	/**
	 * 返回人员兼职的单位列表，包含人员�?在单位�??
	 * 
	 * @param memberId 人员id
	 * @return 单位列表
	 * @throws BusinessException
	 */
	List<V3xOrgAccount> concurrentAccount(Long memberId) throws BusinessException;
	
	/**
     * 专门为portal出现切换单位选项出现提供接口，其中包括本单位
     * @param memberId 人员
     * @return 兼职信息完整的单位列�?(兼职信息完整包括:兼职单位，兼职部门，兼职岗位，兼职职务完�?)
     * @throws BusinessException
     */
    List<V3xOrgAccount> concurrentAccounts4ChangeAccount(Long memberId)  throws BusinessException;
    /**
     * 判断当前登录用户在当前单位是否是管理�?
     * @return
     * @throws BusinessException
     */
    public Boolean isAdministrator() throws BusinessException;

    /**
     * 返回人员兼职的单位列表，不包含人员所在单位�??
     * 
     * @param memberId
     *            人员Id
     * @return 人员兼职单位列表�?
     * @throws BusinessException
     */
    List<V3xOrgAccount> getConcurrentAccounts(Long memberId)  throws BusinessException;
    /**
     * 获取人员的兼职信�?
     * @param memberId
     * @return
     * @throws BusinessException
     */
    public List<MemberPost> getMemberConcurrentPosts(Long memberId) throws BusinessException;

    /**
     * 返回单位下的兼职列表,Map<部门ID,兼职列表>
     * 
     * @param accountId 单位id
     * @return
     * @throws BusinessException
     */
    Map<Long, List<MemberPost>> getConcurentPosts(Long accountId) throws BusinessException;

    /**
     * 返回单位下人员的兼职列表,Map<部门ID,兼职列表>
     * @param accountId 单位id
     * @param memberId 人员id
     * @return
     * @throws BusinessException
     */
    Map<Long, List<MemberPost>> getConcurentPostsByMemberId(Long accountId, Long memberId)
            throws BusinessException;
    
    /**
     * 返回�?个单位下的副岗列�?,Map<部门ID,人员列表>
     * 
     * @param accountId
     * @return
     * @throws BusinessException
     */
    public List<MemberPost> getSecondPostByAccount(Long accountId) throws BusinessException;

    
    List<MemberPost> getMainPostByAccount(Long accountId) throws BusinessException;
    /**
     * 返回�?个单位下的兼职列�?,Map<部门ID,人员列表>
     * @param accountId
     * @return
     * @throws BusinessException
     */
    Map<Long, List<V3xOrgMember>> getConcurentPostByAccount(Long accountId) throws BusinessException;

    /**
     * 返回�?个成员能够访问的的单位列�?
     * @param memberId 人员id
     * @return 单位列表
     * @throws BusinessException
     */
    List<V3xOrgAccount> accessableAccounts(Long memberId) throws BusinessException;
    
    /**
     * 返回单位能够访问的的单位列表
     * @param unitId 单位id
     * @return 单位列表
     * @throws BusinessException
     */
    List<V3xOrgAccount> accessableAccountsByUnitId(Long unitId) throws BusinessException;
    
    /**
     * 得到这个人在指定单位下的岗位信息
     * 
     * @param accountId 可以�?<code>null</code>，表示所有单�?
     * @param memberId
     * @return
     * @throws BusinessException
     */
    List<MemberPost> getMemberPosts(Long accountId, Long memberId) throws BusinessException;
    
    /**
     * 获取某人员的�?有副�?
     * @param memberId 人员id
     * @return 副岗信息列表
     * @throws BusinessException
     */
    List<MemberPost> getMemberSecondPosts(Long memberId) throws BusinessException;

    /*-------------------------岗位管理---------------------------*/

    /**
     * 政务版�?��?�按单位查询职级
     * 
     * @param accountID
     *            单位id
     * @param type
     * @param value
     * @return 职级列表
     * @throws BusinessException
     */
    List<V3xOrgDutyLevel> getAllDutyLevels(Long accountID, String type, String value) throws BusinessException;

    /**
     * 根据名称取组织模型实体列表（从数据库中查询）
     * 
     * @param clazz
     *            组织模型实体类型，如OrgDepartment.class
     * @param name
     *            实体的名�?
     * @param accountId
     *            �?在单位Id
     * @return �?在单位下的符合指定类型和名称的实体�??
     * @throws BusinessException
     */
    <T extends V3xOrgEntity> List<T> getEntitiesByName(Class<T> clazz, String name, Long accountId) throws BusinessException;
    
    /**
     * 根据名称取组织模型实体列表（从缓存中获取）�??(内部做了ThreadCache)
     * 
     * @param clazz
     *            组织模型实体类型，如OrgDepartment.class
     * @param name
     *            实体的名�?
     * @param accountId
     *            �?在单位Id <code>null</code>表示任意单位
     * @return �?在单位下的符合指定类型和名称的实体�??
     * @throws BusinessException
     */
    <T extends V3xOrgEntity> List<T> getEntitiesByNameWithCache(Class<T> clazz, String name, Long accountId) throws BusinessException;
    
    <T extends V3xOrgEntity> List<T> getEntitiesByNameWithCache(Class<T> clazz, String name, Long accountId, Integer externalType) throws BusinessException;

    /**
     * 获取�?有子部门（不包含自己�?
     * @param parentDepId 父部门id
     * @param firtLayer true只查询一层子部门 false查询�?有子部门
     * @return 部门列表
     * @throws BusinessException
     */
    List<V3xOrgDepartment> getChildDepartments(Long parentDepId, boolean firtLayer) throws BusinessException;
    
    /**
     * 获取�?有子部门（不包含自己�?
     * @param accountId 单位id
     * @param firtLayer true只查询一层子部门 false查询�?有子部门
     * @return 部门列表
     * @throws BusinessException
     */
    List<V3xOrgDepartment> getChildDeptsByAccountId(Long accountId, boolean firtLayer) throws BusinessException;

    /**
     * 获取�?有子部门（不包含自己�?
     * @param parentDepId 父部门id
     * @param firtLayer true只查询一层子部门 false查询�?有子部门
     * @param isInteranl 是否为内部部门，false==外单�?
     * @return
     * @throws BusinessException
     */
    List<V3xOrgDepartment> getChildDepartments(Long parentDepId, boolean firtLayer, boolean isInteranl)
            throws BusinessException;

    /**
     * 获取某单位下某部门的父部�?
     * 
     * @param depId 部门id
     * @return
     * @throws BusinessException
     */
    V3xOrgDepartment getParentDepartment(Long depId) throws BusinessException;

    /**
     * 获得某部门的�?有父部门
     * 
     * @param depId 部门id
     * @return
     * @throws BusinessException
     */
    List<V3xOrgDepartment> getAllParentDepartments(Long depId) throws BusinessException;

    /**
     * 根据部门的path获得部门
     * 
     * @param path
     * @return
     * @throws BusinessException
     */
    V3xOrgDepartment getDepartmentByPath(String path) throws BusinessException;

    /**
     * <pre>
     * 得到我能访问的组,
     * �?、普通用户包括（前提是这个单位下的组�?:
     * 1. 我建的私有组
     * 2. 我是成员或关联人员系统组
     * 3. 公开范围有我的系统组(单位、集团�?�项�?)
     * <del>4. 我是部门管理员的部门系统�?</del>
     * 
     * 二�?�单位管理员�?
     * 1. 这个单位�?有的单位系统组（不包括部门组�?
     * 2. 集团公开范围有这个单位的系统�?
     * 
     * 三�?�集团�?�审计�?�系统管理员管理�?
     * 1. �?有的集团系统�?
     * 2. 这个单位的系统组
     * <del>2. 公开范围有我的系统组</del>
     * 
     * 其它:
     * 1. 看到集团组的前提是单位在集团树下
     * </pre>
     * 
     * @param memberId 人员id
     * @param accountId 单位id，每次都返回集团�?
     * @return 组实体列�?
     * @throws BusinessException
     */
    List<V3xOrgTeam> getTeamsByMember(Long memberId, Long accountId) throws BusinessException;

    /**
     * 通过人员ID获得除个人组�?有的�?
     * 
     * @param memberId
     *            人员id
     * @return
     * @throws BusinessException
     */
    List<V3xOrgTeam> getTeamsExceptPersonByMember(Long memberId) throws BusinessException;

    /**
     * 获取组的不同类型的成员�?? 组下面有组长、组的领导�?�组员�?�组的相关人员四类人员�??<br>
     * 
     * @param teamId
     *            组id
     * @param orgRelType
     *            四类人员的标�?
     * @return 人员列表
     * @throws BusinessException
     */
	List<V3xOrgEntity> getTeamMember(Long teamId, OrgConstants.TeamMemberType orgRelType) throws BusinessException;
    
    /**
     * 判断组的公开范围是否有公�?范围如果有公�?组，如果没有就是私有�?
     * @param team
     * @return
     * @throws BusinessException
     */
    boolean isEmptyTeamScope(V3xOrgTeam team) throws BusinessException;

    /**
     * 获取组的成员。由组长、组员构�?
     * 
     * @param teamId
     *            组id
     * @return 人员列表
     * @throws BusinessException
     */
	List<V3xOrgEntity> getTeamMember(Long teamId) throws BusinessException;

    /**
     * 获取组的成员
     * 
     * @param teamId
     *            组id
     * @return 组内人员列表
     * @throws BusinessException
     */
    List<V3xOrgMember> getMembersByTeam(Long teamId) throws BusinessException;
    
    /**
     * 获取组的成员
     * 
     * @param teamId
     *            组id
     * @return 组内人员列表
     * @throws BusinessException
     */
    List<V3xOrgMember> getMembersByTeam(Long teamId, Set<Long> teamIds) throws BusinessException;
    //start mwl 通讯录中领导的信息需要有权限才可以查看 
	List<V3xOrgMember> getMembersByTeam(Set<Long> teamIds,Long teamId) throws BusinessException;
	//start mwl 通讯录中领导的信息需要有权限才可以查看 
    /**
     * 获取组的相关人员
     * 
     * @param teamId
     *            组id
     * @return
     * @throws BusinessException
     */
    List<V3xOrgMember> getTeamRelative(Long teamId) throws BusinessException;

    /**
     * 获取�?个单位或部门下面指定角色的人员列�?
     * 
     * @param unitId
     *            部门或单位的ID
     * @param roleId
     *            角色的ID
     * @throws BusinessException
     */
    List<V3xOrgMember> getMembersByRole(Long unitId, Long roleId) throws BusinessException;
    
    /**
     * 获取�?个单位或部门下面指定角色名称的人员列�?
     * @param unitId 部门或单位的ID
     * @param roleName 角色名称
     * @return
     * @throws BusinessException
     */
    List<V3xOrgMember> getMembersByRole(Long unitId, String roleName) throws BusinessException;
    /**
     * 根据角色获取实体
     * @param unitId
     * @param roleId
     * @return
     * @throws BusinessException
     */
    public List<V3xOrgEntity> getEntitysByRole(Long unitId, Long roleId) throws BusinessException;

    /**
     * 根据角色和人员ID，返回指定人员管理的单位或�?�部�?
     * 
     * @param roleId，已知的角色的ID，比如�?�部门管理员�?
     * @param userId，当前人员的ID
     * @return 返回单位或�?�部门的ID列表
     * @throws BusinessException
     */
    List<Long> getDomainByRole(Long roleId, Long userId) throws BusinessException;

    /**
     * 取部门角色对应的�?有人员�??
     * （仅包含有效人员）判断人员是否有效标�?<code>isValid()</code>方法
     * @param departmentId 部门Id
     * @param roleName 角色名称
     * @return 角色对应的所有人员，部门或角色不存在返回size�?0的List�?
     */
    List<V3xOrgMember> getMembersByDepartmentRole(long departmentId, String roleName) throws BusinessException;
    
    /**
     * 取指定部门下指定角色下的人员，自动往上查�? 
     * 
     * @param departmentId
     * @param roleNameOrId 可以是ID，也可以是Name
     * @return
     * @throws BusinessException
     */
    List<V3xOrgMember> getMembersByDepartmentRoleOfUp(long departmentId, String roleNameOrId) throws BusinessException;
    
    /**
     * 取指定人员在指定单位的工作部门（含主\副\兼）下指定角色下的人员，自动�?上查�? (常用于本部门匹配)
     * 
     * @param memberId
     * @param roleNameOrId 可以是ID，也可以是Name
     * @param accountId
     * @return
     * @throws BusinessException
     */
    List<V3xOrgMember> getMembersByMemberRoleOfUp(long memberId, String roleNameOrId, Long accountId) throws BusinessException;

    /**
     * 解析指定人员�?在部门的某个岗位下的人员（仅取该部门�?
     * 
     * @param departmentId 部门id
     * @param postId 岗位id，可以是基准�?
     * @return
     * @throws BusinessException
     */
    List<V3xOrgMember> getMembersByDepartmentPost(long departmentId, long postId) throws BusinessException;
    
    /**
     * 解析指定人员�?在部门的某个岗位下的人员，当本部门没有匹配到的时候，自动�?上级部门查找，直到全单位
     * 
     * @param departmentId 部门id
     * @param postId 岗位id，可以是基准�?
     * @return
     * @throws BusinessException
     */
    List<V3xOrgMember> getMembersByDepartmentPostOfUp(long departmentId, long postId) throws BusinessException;
    
    /**
     * 解析指定人员�?在部门的某个岗位下的人员
     * 
     * @param departmentId 部门id
     * @param postId 岗位id，可以是基准�?
     * @return
     * @throws BusinessException
     */
    List<V3xOrgMember> getMembersByDepartmentPostOfDown(long departmentId, long postId) throws BusinessException;
    
    /**
     * 取指定人员在指定单位的工作部门（含主\副\兼）下指定岗位下的人员，自动�?上查�? (常用于本部门匹配),如果向上找不到，去全单位�?
     * 
     * @param memberId
     * @param postId
     * @param accountId
     * @return
     * @throws BusinessException
     */
    List<V3xOrgMember> getMembersByMemberPostOfUp(long memberId, long postId, long accountId) throws BusinessException;
    /**
     * 取指定人员在指定单位的工作部门（含主\副\兼）下指定岗位下的人员，自动�?上查�? (常用于本部门匹配),如果向上找不�?,返回空集�?
     * 
     * @param memberId
     * @param postId
     * @param accountId
     * @return
     * @throws BusinessException
     */
    List<V3xOrgMember> getMembersByMemberPostOfOnlyUp(long memberId,long postId0, long accountId) throws BusinessException;
    /**
     * 固定角色的解�?
     * 
     * @param type 角色的类型，接收的格式是：{@link OrgConstants.ORGENT_TYPE}，支持Department_Role,Department_Post
     * @param id 对应的ID，如果是Department_Role，这�?123123434_231234236，兼容系统预置角�?123123434_DeptAdmin
     * @return
     * @throws BusinessException
     */
    List<V3xOrgMember> getMembersByType(String type, String id) throws BusinessException;
    
    /**
     * 根据OrgTypeIdBO返回member
     * @param bo
     * @return
     * @throws BusinessException
     */
    List<V3xOrgMember> getMembersByOrgType(OrgTypeIdBO bo) throws BusinessException;
    
    /**
     * 固定角色的解�?
     * 
     * @param type 角色的类型，接收的格式是：{@link OrgConstants.ORGENT_TYPE}�?<b>不支持Department_Role,Department_Post</b>
     * @param id 对应的ID
     * @return
     * @throws BusinessException
     */
    List<V3xOrgMember> getMembersByType(String type, Long id) throws BusinessException;

    /**
     * 取得指定单位�?有人员的姓名。为解决单点性能问题，如果有�?要频繁取无效人员姓名的需求，请使用此方法先取�?
     * @param accountId 单位Id，如果为<code>null</code>�?<code>OrgEntity.VIRTUAL_ACCOUNT_ID</code>则返回全集团的人员名称�??
     * @return 人员Id-姓名的Map，包含启用�?�停用和已删除人员�??
     * @throws BusinessException
     */
    Map<Long, String> getAllMemberNames(Long accountId) throws BusinessException;

    /**
     * 取得�?有单位的�?称�??
     * @return 单位Id-�?称Map，包含启用�?�停用和已删除单位�??
     * @throws BusinessException
     */
    Map<Long, String> getAllAccountShortNames() throws BusinessException;

    /**
     * 获得部门下所有外部成员成�?
     * @param departmentId 部门id
     * @param firtLayer true只查询本部门  false同时查询子部�?
     * @return
     * @throws BusinessException
     */
    List<V3xOrgMember> getExtMembersByDepartment(Long departmentId, boolean firtLayer) throws BusinessException;

    /**
     * 获得单位下所有的外部成员
     * @param accountId
     * @return
     * @throws BusinessException
     */
    List<V3xOrgMember> getAllExtMembers(Long accountId) throws BusinessException;

    /**
     * 根据名称获得成员，可能会有多个，限定为有效的可以访问系统的人�?
     * （仅包含有效人员）判断人员是否有效标�?<code>isValid()</code>方法
     * @param memberName 人员姓名
     * @return
     * @throws BusinessException
     */
    List<V3xOrgMember> getMemberByName(String memberName) throws BusinessException;
    
    /**
     * 根据名称获得成员，可能会有多个，限定为有效的可以访问系统的人�?
     * （仅包含有效人员）判断人员是否有效标�?<code>isValid()</code>方法
     * @param memberName
     * @param accountId
     * @return
     * @throws BusinessException
     */
    List<V3xOrgMember> getMemberByName(String memberName, Long accountId) throws BusinessException;
    
    /**
     * 根据模糊名称返回人员列表，可能会有多个，限定为有效的可以访问系统的人�?
     * （仅包含有效人员）判断人员是否有效标�?<code>isValid()</code>方法
     * @param indistinctName 模糊名称
     * @return
     * @throws BusinessException
     */
    List<V3xOrgMember> getMemberByIndistinctName(String indistinctName) throws BusinessException;

    /**
     * 判断是否为单位管理员�?
     * 为isAdministrator、isSystemAdmin、isGroupAdmin、isAccountAdmin�?起调用�?�优化，请勿传入与loginName不匹配的account�?
     * 
     * @param loginName
     *            登录�?
     * @param account
     *            登录名标识的用户�?在单位�??
     * @return true－如果是系统管理员和单位管理员，false-其他
     * @throws BusinessException
     */
    Boolean isAdministrator(String loginName, V3xOrgAccount account) throws BusinessException;
    
    /**
     * 判断是否为单位管理员�?
     * 为isAdministrator、isSystemAdmin、isGroupAdmin、isAccountAdmin�?起调用�?�优化，请勿传入与loginName不匹配的account�?
     * 
     * @param memberId
     *            人员id
     * @param account
     *            登录名标识的用户�?在单位�??
     * @return true－是单位管理员，false-其他
     * @throws BusinessException
     */
    Boolean isAdministratorById(Long memberId, V3xOrgAccount account) throws BusinessException;
    
    /**
     * 判断是否为单位管理员�?
     * 为isAdministrator、isSystemAdmin、isGroupAdmin、isAccountAdmin�?起调用�?�优化，请勿传入与loginName不匹配的account�?
     * 
     * @param memberId
     *            人员id
     * @param accountId
     *            登录名标识的用户�?在单位�??
     * @return true－是单位管理员，false-其他
     * @throws BusinessException
     */
    Boolean isAdministratorById(Long memberId, Long accountId) throws BusinessException;
    
    /**
     * 判断是否为集团库管理员�??
     * 为isAdministrator、isSystemAdmin、isGroupAdmin、isAccountAdmin�?起调用�?�优化，请勿传入与loginName不匹配的account�?
     * 
     * @param loginName
     *            登录�?
     * @param account
     *            登录名标识的用户�?在单位�??
     * @return true－如果是集团库管理员，false-其他
     * @throws BusinessException
     */
    Boolean isDocGroupAdmin(String loginName, V3xOrgAccount account) throws BusinessException;

    /**
     * 判断是否为系统管理员�?
     * 为isAdministrator、isSystemAdmin、isGroupAdmin、isAccountAdmin�?起调用�?�优化，请勿传入与loginName不匹配的account�?
     * 
     * @param loginName
     *            登录�?
     * @return true－如果是系统管理员，false-其他
     * @throws BusinessException
     */
    Boolean isSystemAdmin(String loginName) throws BusinessException;
    
    /**
     * 判断是否为系统管理员�?
     * 为isAdministrator、isSystemAdmin、isGroupAdmin、isAccountAdmin�?起调用�?�优化，请勿传入与loginName不匹配的account�?
     * 
     * @param memberId
     *            人员id
     * @return true－如果是系统管理员，false-其他
     * @throws BusinessException
     */
    Boolean isSystemAdminById(Long memberId) throws BusinessException;

    /**
     * 是否为审计管理员
     * @param loginName 登录�?
     * @return 
     * @throws BusinessException
     */
    Boolean isAuditAdmin(String loginName) throws BusinessException;
    
    /**
     * 是否为审计管理员
     * @param memberId 人员id
     * @return 
     * @throws BusinessException
     */
    Boolean isAuditAdminById(Long memberId) throws BusinessException;

    /**
     * 是否为平台管理员
     * @param loginName 登录�?
     * @return 
     * @throws BusinessException
     */
    Boolean isPlatformAdmin(String loginName) throws BusinessException;

    /**
     * 是否为平台管理员
     * @param memberId 人员id
     * @return 
     * @throws BusinessException
     */
    public Boolean isPlatformAdminById(Long memberId) throws BusinessException;
    
    /**
     * 判断是否为集团管理员�?
     * 为isAdministrator、isSystemAdmin、isGroupAdmin、isAccountAdmin�?起调用�?�优化，请勿传入与loginName不匹配的account�?
     * 
     * @param loginName
     *            登录�?
     * @param account
     *            登录名标识的用户�?在单位�??
     * @return true－如果是集团管理员，false-其他
     * @throws BusinessException
     */
    Boolean isGroupAdmin(String loginName, V3xOrgAccount account) throws BusinessException;
    
    /**
     * 判断是否为集团管理员�?
     * 为isAdministrator、isSystemAdmin、isGroupAdmin、isAccountAdmin�?起调用�?�优化，请勿传入与loginName不匹配的account�?
     * 
     * @param memberId
     *            人员id
     * @return true－如果是集团管理员，false-其他
     * @throws BusinessException
     */
    Boolean isGroupAdminById(Long memberId) throws BusinessException;

    // 更新管理
    /**
     * 是否修改
     * @param date
     * @param accountId
     * @return
     * @throws BusinessException
     */
    boolean isModified(Date date, Long accountId) throws BusinessException;

    /**
     * 获取修改时间
     * @param accountId
     * @return
     * @throws BusinessException
     */
    Date getModifiedTimeStamp(Long accountId) throws BusinessException;

    /**
     * 个人组织属�?�访问：从组织模型获得当前执行人的所有相关组织属性，不包含部门角�?
     * 参数说明�? userId：当前用户的ID types: �?要返回的域的类型，这是一个变参，可根据需要�?�择输入域的类型�? 
     * 返回结果�? String
     * 类： 以�?�号隔开的ID串�?? 列表类：组织模型元素对象列表�?
     * @param memberId
     * @param types
     * @throws BusinessException
     */
    List<Long> getUserDomainIDs(Long memberId, String... types) throws BusinessException;
    
    /**
     * 获取某人员所有组织信息ID集合
     * @param memberId
     * @return
     * @throws BusinessException
     */
    List<Long> getAllUserDomainIDs(Long memberId) throws BusinessException;

    /**
     * 个人组织属�?�访问：从组织模型获得当前执行人的所有相关组织属性，不包含部门角�?
     * @param memberId
     * @param accountId
     * @param types
     * @return
     * @throws BusinessException
     */
    List<Long> getUserDomainIDs(Long memberId, Long accountId, String... types) throws BusinessException;
    
    /**
     * 个人组织属�?�访问：从组织模型获得当前执行人的所有相关组织属性，不包含部门角�?
     * @param memberId
     * @param types
     * @return
     * @throws BusinessException
     */
    String getUserIDDomain(Long memberId, String... types) throws BusinessException;

    /**
     * 获取单位下所有人�?
     * @param accountId
     * @param includeChildAcc true时包�?有含子单位，false时仅本单�?
     * @return
     * @throws BusinessException
     */
    List<V3xOrgMember> getAllMembers(Long accountId,boolean includeChildAcc) throws BusinessException;

    /**
     * 个人组织属�?�访问：从组织模型获得当前执行人的所有相关组织属性，逗号分隔，不包含部门角色
     * @param memberId
     * @param accountId
     * @param types
     * @return
     * @throws BusinessException
     */
    String getUserIDDomain(Long memberId, Long accountId, String... types) throws BusinessException;

    /**
     * 得到�?有部门主管为当前人员的部门列�?(根据单位ID获得)
     * @param memberId 人员id
     * @param accountId 单位id
     * @return 部门列表
     * @throws BusinessException
     */
    List<V3xOrgDepartment> getDeptsByManager(Long memberId, Long accountId) throws BusinessException;
    
    /**
     * 得到�?有部门分管领导为当前人员的部门列�?(根据单位ID获得)
     * @param memberId 人员id
     * @param accountId 单位id
     * @return 部门列表
     * @throws BusinessException
     */
    List<V3xOrgDepartment> getDeptsByDeptLeader(Long memberId, Long accountId) throws BusinessException;
    
    /**
     * 得到�?有部门管理员为当前人员的部门列表(根据单位ID获得)
     * @param memberId
     * @param accountId
     * @return
     * @throws BusinessException
     */
    List<V3xOrgDepartment> getDeptsByAdmin(Long memberId, Long accountId) throws BusinessException;

    /**
     * 根据人员的ID取得人员的部门列�?
     * 
     * @param memberId
     *            用户Id
     * @return
     * @throws BusinessException
     */
    List<V3xOrgDepartment> getDepartmentsByUser(Long memberId) throws BusinessException;

    /**
     * 判断单位是否在集团树�?
     * @param accountId 单位id
     * @return
     * @throws BusinessException
     */
    boolean isAccountInGroupTree(Long accountId) throws BusinessException;
    
    Integer getAllMembersNumsWithOutConcurrent(Long accountId) throws BusinessException;
    
    /**
     * 取得系统中每个单位的人数（含兼职人员�?
     * 
     * @return Map<单位ID, 人数>，包括集�?
     * @throws BusinessException
     */
    Map<Long, Integer> getMemberNumsMapWithConcurrent() throws BusinessException;
    
    /**
     * 判断角色是否是固定角�?
     * @param roleCode
     * @return
     * @throws BusinessException
     */
    public boolean isBaseRole(String roleCode) throws BusinessException;
    /**
     * 根据查询条件获取单位下人员数�?
     * @param accountId
     * @param type
     * @param isInternal
     * @param enable
     * @param condition
     * @param feildvalue
     * @return
     */
    public Integer getAllMembersNumsByAccountId(Long accountId, Integer type, Boolean isInternal,
            Boolean enable, String condition, Object feildvalue);

    /**
     * 获取实体
     * @param entityClassName 实体�?
     * @param property 属�??
     * @param value 属�?��??
     * @param accountId 单位id
     * @return
     * @throws BusinessException
     */
    List<V3xOrgEntity> getEntity(String entityClassName, String property, Object value, Long accountId)
            throws BusinessException;

    /**
     * 根据基准岗ID查询单位自建�?
     * @param bmPostId  基准岗ID
     * @param accountId 单位ID
     * @return 单位自建�?
     * @throws BusinessException
     */
    V3xOrgPost getAccountPostByBMPostId(Long bmPostId, Long accountId) throws BusinessException;

	
	
    /**
     * 获取实体列表，不考虑实体关系，�?�用于查询组织模型实�?
     * @param entityClassName 实体�?
     * @param property 属�??
     * @param value 属�?��??
     * @param accountId 单位id
     * @return
     * @throws BusinessException
     */
    List<V3xOrgEntity> getEntityListNoRelation(String entityClassName, String property, Object value, Long accountId)
            throws BusinessException;

    /**
     * 获取实体列表，不考虑实体关系，�?�用于查询组织模型实体，分页
     * @param entityClassName 实体�?
     * @param property 属�??
     * @param value 属�?��??
     * @param accountId 单位id
     * @param isPaginate 是否分页
     * @return
     * @throws BusinessException
     */
    List<V3xOrgEntity> getEntityListNoRelation(String entityClassName, String property, Object value, Long accountId,
            boolean isPaginate) throws BusinessException;

    /**
     * 获取实体列表，不考虑实体关系，�?�用于查询组织模型实体，分页
     * @param entityClassName 实体�?
     * @param property 属�??
     * @param value 属�?��??
     * @param accountId 单位id
     * @param isPaginate 是否分页
     * @param 是否精确匹配
     * @param 是否启用
     * @return
     * @throws BusinessException
     */
    public List<V3xOrgEntity> getEntityNoRelation(String entityClassName, String property, Object value,
            Long accountId, boolean isPaginate,boolean equal,Boolean enable)  throws BusinessException;   
    
    
    /**
     * 获得外部人员访问权限
     * @param memberId 人员id
     * @param includeDisabled 是否包含无效人员
     * @return
     * @throws BusinessException
     */
    List<V3xOrgEntity> getExternalMemberWorkScope(Long memberId, boolean includeDisabled) throws BusinessException;

    /**
     * 根据人员ID获得内部人员与外部人员的互访权限(不包括挂靠部门的情况)
     * @param memberId 人员id
     * @param includeDisabled 是否包含无效人员
     * @return
     * @throws BusinessException
     */
    List<V3xOrgMember> getMemberWorkScopeForExternal(Long memberId, boolean includeDisabled) throws BusinessException;
    
	/**
	 * 根据人员ID获得内部人员可以访问的外部部�?
	 * 
	 * @param memberId 人员id
	 * @return
	 * @throws BusinessException
	 */
	public List<Long> getDepartmentWorkScopeForExternal(Long memberId) throws BusinessException;

    /**
     * 获得�?有单位的外部人员
     * @param includeDisabled 是否包含无效人员
     * @return
     * @throws BusinessException
     */
    List<V3xOrgMember> getAllAccountsExtMember(boolean includeDisabled) throws BusinessException;

    /**
     * 根据手机查询人员<br>
     * <em>注意：手机号没有唯一判断，系统可能存在某两个人相同手机号，但接口只返回第�?个匹配的结果，如果没有查询到则返回null</em>
     * @param mobile 手机�?
     * @param accountId 单位ID，如果查询全集团请传集团ID
     * @return
     * @throws BusinessException
     */
    V3xOrgMember getMembersByMobile(String mobile, Long accountId) throws BusinessException;

    /**
     * 根据实体属�?�获得实体（不载入实体关系）
     * @param entityClassName
     * @param accountId
     * @param isPaginate
     * @param args
     * @return
     * @throws BusinessException
     */
    List<? extends V3xOrgEntity> getEntitysByPropertysNoRelation(String entityClassName, Long accountId,
            boolean isPaginate, Object... args) throws BusinessException;

    /**
     * 根据岗位id获得绑定的集团基准岗
     * 如果岗位本身为集团基准岗则返回岗位本�?
     * 如果没有绑定基准岗则返回�?
     * @param postId
     * @return
     * @throws BusinessException
     */
    V3xOrgPost getBMPostByPostId(Long postId) throws BusinessException;

    /**
     * 取得�?有指定单位引用的基准岗�??
     * @param accountId 单位Id；如果�?�为<code>OrgEntity.VIRTUAL_ACCOUNT_ID</code>，等同于取全集团�?有被引用的基准岗，但不包含未被引用的�?
     * 
     * @return 指定单位引用的所有基准岗�?
     * @throws BusinessException
     */
    List<V3xOrgPost> getAllBenchmarkPost(Long accountId) throws BusinessException;

    /**
     * 获取�?个部门下的已启用的组列表
     * @param depId 部门id
     * @return
     * @throws BusinessException
     */
    List<V3xOrgTeam> getDepartmentTeam(Long depId) throws BusinessException;
    
    /**
     * 判断是否是指定角色，支持单位角色和部门下的角�?
     * 
     * @param memberId 指定的人�?
     * @param unitId 可以是单位�?�部门，可以�?<b>null</b>；如果是单位角色，这里给的是部门，暂无此情况
     * @param roleNameOrId 角色名：FormAdmin、HrAdmin、ProjectBuild、DepManager、DepAdmin；或者角色ID
     * @param postTypes 岗位类型组合：主岗�?�副岗�?�兼职�??<br/>
     *     不传类型时检查所有岗位类型，只要具备�?个岗位类型的岗位就返回true；传多个类型时在指定岗位类型内检查�??
     * @throws BusinessException
     * @return
     */
    boolean isRole(Long memberId, Long unitId, String roleNameOrId, OrgConstants.MemberPostType... postTypes) throws BusinessException;

    /**
     * 判断人员是否具备指定岗位�?
     * @param memberId 人员Id
     * @param postId 岗位Id，岗位为基准岗时�?查基准岗下所有岗�?
     * @param postTypes 岗位类型组合：主岗�?�副岗�?�兼职�??<br/>
     *     不传类型时检查所有岗位类型，只要具备�?个岗位类型的岗位就返回true；传多个类型时在指定岗位类型内检查�??
     * @return 人员在限定条件下具备指定岗位时返回true，否则返回false。指定id的人员不存在返回false，指定id的岗位不存在返回false�?
     * @throws BusinessException 
     */
    boolean isPost(long memberId, long postId, OrgConstants.MemberPostType... postTypes) throws BusinessException;

    /**
     * 判断指定人员是否在指定部门�?�只判断主岗，不包括副岗和兼职部门�??
     * @param memberId
     * @param deptIdList 部门Id列表，人员只要在其中任何�?个部门下就返�?<tt>true</tt>�?
     * @param includeChild 是否判断子部�?
     * @return 人员在指定部门下返回<tt>true</tt>，否则返�?<tt>false</tt>�?
     * @throws BusinessException 
     */
    boolean isInDepartment(long memberId, List<Long> deptIdList, boolean includeChild) throws BusinessException;

    /**
     * 取得系统管理员�??
     * @return 系统管理员实体�??
     */
    V3xOrgMember getSystemAdmin();

    /**
     * 取得审计管理员�??
     * @return 审计管理员实体�??
     */
    V3xOrgMember getAuditAdmin();
    
    /**
     * 取得集團管理员�??
     * @return 审计集團员实体�??
     */
    V3xOrgMember getGroupAdmin();
    
    /**
     * 取得单位管理�?
     * 
     * @param accountId
     * @return
     */
    V3xOrgMember getAdministrator(Long accountId);
    /**
     * 在集团基准角色同步到各单位的情况下，传入�?个单位的映射角色ID，再根据传入的unitId，获取此单位/部门映射对应的角色Id
     * @param roleId
     * @param unitId
     * @return
     * @throws BusinessException
     */
    public String getRoleByOtherBenchmarkRole(String roleId, Long unitId) throws BusinessException;
    
    /**
     * 获取部门下的岗位
     * @param departmentId 部门id
     * @return
     * @throws BusinessException
     */
    List<V3xOrgPost> getDepartmentPost(Long departmentId) throws BusinessException;

    /**
     * 判断指定人员是否在指定的部门
     * 
     * @param currentNodeMemberId
     * @param memberPostTypes {@link OrgConstants.MemberPostType} 岗位类型：主管�?�副岗�?�兼职，可以为null，表示所�?
     * @param deptIdList
     * @param hasChildDep
     * @return
     * @throws BusinessException
     */
    boolean isInDepartment(long memberId, List<String> memberPostTypes, List<Long> deptIdList, boolean hasChildDep)
            throws BusinessException;

    /**
     * 取得�?有的扩展角色定义�?
     * @return 角色名称-扩展角色定义Map
     */
    Map<String, OrgRoleDefaultDefinition> getRoleDefinitions();

    /**
     * 查找�?有单位�??
     * 
     * @return �?有单位的列表
     * @throws BusinessException
     */
//    List<OrgAccount> getAllAccounts() throws BusinessException;

    /**
     * 取指定单位的�?有部门（不包含停用部门，包含外部部门）�??
     * 
     * @param accountId
     *            单位Id
     * @return 单位的部门列表�??
     * @throws BusinessException
     */
    List<V3xOrgDepartment> getAllDepartments(Long accountId) throws BusinessException;

    /**
     * 取指定单位的�?有职务级别（不包含停用职务级别）�?
     * 
     * @param accountId
     *            单位Id�?
     * @return 单位的职务级别列表�??
     * @throws BusinessException
     */
    List<V3xOrgLevel> getAllLevels(Long accountId) throws BusinessException;
    /**
     * 获取部门角色关联的人员，返回选人格式
     * @param departmentTypeAndId
     * @param roleNameOrId
     * @return
     * @throws BusinessException
     */
    public Map getMembersByDepartmentRoleByStr(String departmentTypeAndId, String roleNameOrId) throws BusinessException;

    /**
     * 政务版�?��?�取指定单位的所有职级（不包含停用职级）�?
     * 
     * @param accountId
     *            单位Id�?
     * @return 单位的职级列表�??
     * @throws BusinessException
     */
    List<V3xOrgDutyLevel> getAllDutyLevels(Long accountId) throws BusinessException;

    /**
     * 取指定单位的�?有岗位（不包含停用岗位）�?
     * 
     * @param accountId
     *            单位Id
     * @return 单位岗位列表
     * @throws BusinessException
     */
    List<V3xOrgPost> getAllPosts(Long accountId) throws BusinessException;

    /**
     * 取指定单位的�?有角色，不包含系统管理员，审计管理员，单位管理员，集团管理员这四个集团角�?
     * 
     * @param accountId
     *            单位Id
     * @return 角色列表
     * @throws BusinessException
     */
    List<V3xOrgRole> getAllRoles(Long accountId) throws BusinessException;
    /**
     * 取指定单位的�?有部门角色�??
     * 
     * @param accountId
     *            单位Id
     * @return 角色列表
     * @throws BusinessException
     */
    List<V3xOrgRole> getAllDepRoles(Long accountId) throws BusinessException;

    /**
     * 取指定单位的�?有组（不包含停用的组）�??
     * 
     * @param accountId
     *            单位Id
     * @return 组列表�??
     * @throws BusinessException
     */
    List<V3xOrgTeam> getAllTeams(Long accountId) throws BusinessException;

    /**
     * 按Id取单位�??
     * 
     * @param id
     *            单位Id�?
     * @return 单位实体。指定Id的单位不存在返回<CODE>null</CODE>�?
     * @throws BusinessException
     */
    V3xOrgAccount getAccountById(Long id) throws BusinessException;

    /**
     * 按id取部门�??
     * 
     * @param id
     *            部门id
     * @return 部门实体
     * @throws BusinessException
     */
    V3xOrgDepartment getDepartmentById(Long id) throws BusinessException;
    V3xOrgDepartment getDepartmentByCode(String code) throws BusinessException;
    V3xOrgMember getMemberByCode(String code) throws BusinessException;
    V3xOrgAccount getAccountByCode(String code) throws BusinessException;
    /**
     * 根据角色获得实体（包含重复的�?
     * @param unitId
     * @param roleId
     * @return
     * @throws BusinessException
     */
    List<V3xOrgEntity> getEntitysByRoleAllowRepeat(Long unitId, Long roleId) throws BusinessException;

    /**
     * 按id取职务级别�??
     * 
     * @param id
     *            职务级别id
     * @return 职务级别实体
     * @throws BusinessException
     */
    V3xOrgLevel getLevelById(Long id) throws BusinessException;
    
    /**
     * 获取导出组织信息动作的标�?
     * @return true,exporting; false,end exported
     */
    boolean getOrgExportFlag();

    /**
     * 按id取人员�??
     * 
     * @param memberId
     *            人员Id�?
     * @return 人员实体
     * @throws BusinessException
     */
    V3xOrgMember getMemberById(Long memberId) throws BusinessException;
    
    /**
     * 获取某单位内人员�?大排序号
     * @param accountId
     * @return
     * @throws BusinessException
     */
    Integer getMaxMemberSortByAccountId(Long accountId) throws BusinessException;
    
    /**
     * 根据ID获取组织结构
     * @param id
     * @return
     * @throws BusinessException
     */
    V3xOrgUnit getUnitById(Long id) throws BusinessException;

    /**
     * 按登录名取人员，限定为有效的可以访问系统的人�?
     * 
     * @param loginName
     *            人员登录�?
     * @return 人员实体
     * @throws BusinessException
     */
    V3xOrgMember getMemberByLoginName(String loginName) throws BusinessException;

    /**
     * 按Id取岗位�?? 如果id为空�?-1，则返回未分配岗位（id为{@link com.seeyon..organization.domain.OrgEntity#DEFAULT_NULL_ID 空}）�??
     * 
     * @param id
     *            岗位Id
     * @return 岗位实体
     * @throws BusinessException
     */
    V3xOrgPost getPostById(Long id) throws BusinessException;

    /**
     * 按照角色实体Id取实�?
     * 
     * @param id
     *            角色Id
     * @return 角色实体
     * @throws BusinessException
     */
    V3xOrgRole getRoleById(Long id) throws BusinessException;
    
    /**
     * 根据人员id和单位id，获取这个人�?在单位内拥有的角色列表，包含部门角色
     * <br>注意：这个方法会返回人员的岗位�?�部门�?�职务所拥有的角�?
     * <pre>
     * | unitId类型   | 部门角色   | 单位角色 |集团角色 |
     * ---------------------------------------------
     * |  null       |    V    |    V    |    V    |
     * |  部门ID     |    V    |         |         |
     * |  单位ID     |         |    V    |    V    |
     * |  集团ID     |         |         |    V    |
     * </pre>
     * @param memberId 人员id
     * @param unitId 组织id
     *              <pre>
     *              1. 可以�?<code>null</code>，表示全系统担任�?有�?�单位角色�?�和“部门角色�??
     *              2. 单位id：在这个单位下担任的“单位角色�?�和“部门角色�??
     *              3. 部门id：在这个部门下担任的“部门角色�??
     *              </pre>
     * @return 人员�?拥有角色列表
     * @throws BusinessException
     */
    List<MemberRole> getMemberRoles(Long memberId, Long unitId) throws BusinessException;

    /**
     * 按名称取角色�?
     * 
     * @param roleName 角色名称，取值范围见{@link OrgConstants.Role_SYSTEM_NAME}
     * @return 指定单位指定名称的角色，不存在则返回<CODE>null</CODE>�?
     * @throws BusinessException
     */
    V3xOrgRole getRoleByName(String roleName, Long accountId) throws BusinessException;

    /**
     * 按Id取组�?
     * 
     * @param id
     *            组Id
     * @return 组实�?
     * @throws BusinessException
     */
    V3xOrgTeam getTeamById(Long id) throws BusinessException;

    /**
     * 取得部门人员。（包括�?/�?/兼）
     * @param departmentId 部门Id
     * @param firstLayer �?<CODE>true</CODE>时不包含子部门人员，否则取本部门以及�?有子部门的人员�??
     * @return 部门下的人员
     * @throws BusinessException
     */
    List<V3xOrgMember> getMembersByDepartment(Long departmentId, boolean firstLayer) throws BusinessException;

    /**
     * 取具有某个职务级别的�?有人员�??
     * （仅包含有效人员）判断人员是否有效标�?<code>isValid()</code>方法
     * @param levelId 职务级别Id
     * @return 具有指定职务级别的有效人员�??
     * @throws BusinessException
     * @see V3xOrgMember
     */
    List<V3xOrgMember> getMembersByLevel(Long levelId) throws BusinessException;

    /**
     * 判断人员是否具有部门管理员角色�??
     * 
     * @param memberId
     *            人员Id�?
     * @param depId
     *            部门Id
     * @return 如果具有部门管理员返�?<CODE>true</CODE>，否则返�?<CODE>false</CODE>�?
     * @throws BusinessException
     */

    Boolean isDepAdminRole(Long memberId, Long depId) throws BusinessException;

    /**
     * 根据单位获得兼职列表
     * @param accountId 单位id
     * @return 单位内所有兼职关�?
     * @throws BusinessException
     */
    List<MemberPost> getAllConcurrentPostByAccount(Long accountId) throws BusinessException;
    
    /**
     * 根据部门获得兼职列表
     * @param accountId 单位id
     * @return 部门内所有兼职关�?
     * @throws BusinessException
     */
    List<MemberPost> getAllConcurrentPostBydepartment(Long departmentId) throws BusinessException;
    
    /*----------------------迁移过来的接�?--------------------*/
	
	/**
	 * 根据名称获得�?�?<br>
	 * 遍历�?有名字符合单位取第一个结果返�?
	 * 
	 * @param accountName
	 *            单位名称
	 * @return 单位实体
	 * @throws BusinessException
	 */
	V3xOrgAccount getAccountByName(String accountName) throws BusinessException;

    /**
     * 获取某单位的�?有部门角�?
     * 
     * @param accountID
     *            单位id
     * @return 角色列表
     * @throws BusinessException
     */
    List<V3xOrgRole> getDepartmentRolesByAccount(Long accountID) throws BusinessException;
    
    /**
     * 获取某单位排除部门分管领导外的所有部门角�?
     * @param accountID
     * @return
     * @throws BusinessException
     */
    List<V3xOrgRole> getDepartmentRolesWithoutDepLeaderByAccount(Long accountID) throws BusinessException;

    /**
     * 得到错误映射的集团职务级�?<br>
     * 用于设定职务级别做映射时错误查询映射的职务级�?
     * 
     * @param accountId
     * @param levelId
     * @param groupLevelId
     * @return OrgLevel
     * @throws BusinessException
     */
    V3xOrgLevel getErrorMapLevel(Long accountId, Integer levelId, Integer groupLevelId) throws BusinessException;

    /**
     * 获得人员�?在角色的域（如人员A为哪个部门的主管，人员B为哪个单位的hr管理员，如果是部门角色，则得到是哪个部门的角色）
     * 
     * @param memberId
     *            人员ID
     * @param roleId
     *            角色ID
     * @return
     * @throws BusinessException
     */
    List<V3xOrgUnit> getGroupByMemberAndRole(Long memberId, Long roleId)  throws BusinessException;

    /**
     * 获得单位下启用状态的�?低职务级�?<br>
     * 原主要作�?:<br>
     * 1.通讯录代码检查职务级�?<br>
     * 2.公共方法functions中检查职务级�?<br>
     * 3.集团管理员将未分配人员到指定单位去检验如果没有职务分配一个最小的职务级别DistributeManager<br>
     * 
     * 建议应用代码采用统一的方法进行职务级别的处理,建议使用Functions中的代码
     * 
     * @param accountId
     *            单位ID
     * @return
     * @throws BusinessException
     */
    V3xOrgLevel getLowestLevel(Long accountId) throws BusinessException;

	/**
	 * 根据部门及人员类型查找部门下的人�?
	 * 
	 * @return
	 * @param departmentId
	 *            部门ID
	 * @param firtLayer
	 *            是否只取当前部门人员
	 * @param type
	 *            人员类型: <code>null</code>表示�?+�?+�?
	 */
	List<V3xOrgMember> getMembersByDepartment(Long departmentId, boolean firtLayer, OrgConstants.MemberPostType type) throws BusinessException;

	/**
	 * 判断当前职务级别是否映射到正确的集团职务级别
	 * 
	 * @param accountId
	 * @param levelId
	 * @param groupLevelId
	 * @return
	 * @throws BusinessException
	 */
    boolean isGroupLevelMapRight(Long accountId, Integer levelId, Integer groupLevelId) throws BusinessException;
    
    /**
     * 取指定单位的�?有人员�?�只包含能够登录的人�?<br>
     * 判断人员是否有效标识<code>isValid()</code>方法
     * 
     * @param accountId
     *            单位Id V3xOrgEntity.VIRTUAL_ACCOUNT_ID表示全系�?
     * @return 单位人员列表
     */
    List<V3xOrgMember> getAllMembers(Long accountId) throws BusinessException;
    
    /**
     * 获取指定单位的所有人员，包括外部人员
     * @param accountId
     * @return
     * @throws BusinessException
     */
    List<V3xOrgMember> getAllMembersWithOuter(Long accountId) throws BusinessException;
    
    /**
     * 取得�?个大Map<姓名, 人员对象>；key同时包括：姓名�?�姓�?(code)、姓�?(登录�?)�?<br>
     * 当姓名存在重复时，就没有单个姓名的key<br>
     * 并做线程级缓�?
     * <pre>
     * e.g�?
     *      谭敏�?
     *      谭敏�?(10202)
     *      谭敏�?(tanmf)
     *      刘强(402034)
     *      刘强(liuq1)
     *      刘强(670001)
     *      刘强(liuq2)
     * </pre>
     * @param accountId V3xOrgEntity.VIRTUAL_ACCOUNT_ID表示全系�?
     * @return
     * @throws BusinessException
     */
    public Map<String, V3xOrgMember> getMemberNamesMap(Long accountId) throws BusinessException;
    
    public Map<String, V3xOrgMember> getMemberNamesMap(Long accountId, Integer externalType) throws BusinessException;

    /**
     * 取具有某个岗位的�?有有效人员，包括主岗、副岗和兼职为指定岗位的�?有人�?<br>
     * （仅包含有效人员）判断人员是否有效标�?<code>isValid()</code>方法 
     * 
     * @param postId
     *            岗位Id，如果为基准岗，则包括所有基准岗关联岗位的人员�??
     * @return 具有指定岗位的所有人员�?�如果岗位不存在返回size�?0的List�?
     * @throws BusinessException
     */
    List<V3xOrgMember> getMembersByPost(Long postId) throws BusinessException;
    /**
     * 获取当前登录用户的所在部门（考虑兼职�?
     * @return
     * @throws BusinessException
     */
    public V3xOrgDepartment getCurrentDepartment() throws BusinessException;
    
    /**
     * 获取岗位下的人员，支持标准岗
     * <pre>
     * /--- PostId --|-- accountId --|--------------- 返回�? ------------/
     * |   标准�?           |   null/集团ID |   全集团所有单位引用自建岗下的人员  |
     * |   标准�?           |   单位ID       |   指定单位引用自建岗下的人�?              |
     * |   单位自建�?  |   此参数被忽略   |   指定单位引用自建岗下的人�?              |
     * </pre>
     * 
     * @param postId
     * @param accountId
     * @return
     * @throws BusinessException
     */
    public List<V3xOrgMember> getMembersByPost(Long postId, Long accountId) throws BusinessException;
    
	/**
     * 根据不同的类型获得组�? 组有三个类型：系统组、个人组、项目组�?
     * 其标志定义在OrgEntity中，分别是TEAM_TYPE_PERSONAL,TEAM_TYPE_SYSTEM,TEAM_TYPE_PROJECT
     * 注：这个方法不会返回被停用的�?
     * 
     * @param type
     *            : 组类�?
     * @return
     * @throws BusinessException
     */
	List<V3xOrgTeam> getTeamByType(int type, Long accId) throws BusinessException;
	
	/**
     * 获得个人组列�?
     * 
     * @param ownerId
     *            组拥有�?�的人员id
     * @return 个人�?
     * @throws BusinessException
     */
	List<V3xOrgTeam> getTeamsByOwner(Long ownerId, Long accountID) throws BusinessException;
	
	/**
	 * 获取有效的未删除的所有单�?
	 * @return
	 * @throws BusinessException
	 */
	List<V3xOrgAccount> getAllAccounts() throws BusinessException;
	/**
     * 获取组织的父组织
     * @param orgunit
     * @return
     * @throws BusinessException
     */
    V3xOrgUnit getParentUnit(V3xOrgUnit orgunit) throws BusinessException;
    
    /**
     * 根据组织ID获取父组�?
     * @param unitId
     * @return
     * @throws BusinessException
     */
    V3xOrgUnit getParentUnitById(Long unitId) throws BusinessException;
    
    /**
     * 根据时间获取在这时间后修改的实体列表
     * @param entityClassName
     * @param dateTime
     * @return
     * @throws BusinessException
     */
    List<V3xOrgEntity> findModifyEntity(String entityClassName, java.util.Date dateTime) throws BusinessException;
    /**
     * 是否是超级管理员
     * @param loginName
     * @param account
     * @return
     * @throws BusinessException
     */
    public Boolean isSuperAdmin(String loginName, V3xOrgAccount account) throws BusinessException;
    public Boolean isSuperAdminById(Long memberId) throws BusinessException;
    
    /**
     * 查询关系表数�? <b>废弃</b>
     * @param type <b>不可�?</b>为null
     * @param sourceId 可以�?<code>null</code>
     * @param accountId 可以�?<code>null</code>
     * @param objectiveIds 可以�?<code>null</code>可以�?<code>null</code>，value类型只能是Long/String/List&lt;Long&gt;/List&lt;String&gt;
     * @return
     */
    @Deprecated
    List<V3xOrgRelationship> getV3xOrgRelationship(OrgConstants.RelationshipType type, Long sourceId, Long accountId, EnumMap<OrgConstants.RelationshipObjectiveName, Object> objectiveIds) throws BusinessException;
    
    /**
     * 通过关系ID获取关系实体
     * @param id 关系主键ID
     * @return
     */
    V3xOrgRelationship getV3xOrgRelationshipById(Long id);
    
    /**
     * 判断用户是否在某�?个域中， 适用于判断单位和部门的角色�?�岗�?
     * 
     * @param entId
     *            域实体ID，比如部门�?�角色�?�岗位等
     * @param userId
     * @param groupId
     *            群组ID，特指单位和部门
     * @return
     * @throws BusinessException
     */
    public boolean isInDomain(Long groupId, Long entId, Long userId)
            throws BusinessException; // 当前登陆单位
    /**
     * 判断职务级别访问范围
     * @param memberID1
     * @param memberID2
     * @return
     * @throws BusinessException
     */
    public boolean checkLevelScope(Long memberID1,Long memberID2) throws BusinessException;

    public boolean isInDomain(Long groupId, Long entId, Long userId,
            Long accountId) throws BusinessException; // 根据单位ID判断

    /**
     * 判断用户是否在某�?个域中， 适用于判断不包括单位和部门的角色、岗位等
     * 
     * @param entId
     *            域实体ID，比如部门�?�角色�?�岗位等
     * @param userId
     * @return
     * @throws BusinessException
     */
    public boolean isInDomain(Long entId, Long userId) throws BusinessException;

    public boolean isInDomainByAccount(Long entId, Long userId, Long accountId)
            throws BusinessException;
    /**
     * 判断当前登录单位是否是集�?
     * @return
     * @throws BusinessException
     */
    boolean isGroup() throws BusinessException;
    
    /**
     * 从数据库中取出人员，默认条件�?<code>isDelete=false and isVirtual=false and isAssigned=true</code>，即把删除人员�?�虚拟账号�?�取消分配缺省排除，通过其它接口提供
     * 
     * @param accountId �?属单�?(不包含兼职人�?)，可以为<code>null</code>，表示不区分
     * @param type 人员类型：正�?/非正�?/...，可以为<code>null</code>，表示不区分 
     * @param isInternal 可以�?<code>null</code>，表示不区分
     * @param enable 可以�?<code>null</code>，表示不区分
     * @param condition 取�?�：name, code, loginName, orgPostId(主岗), orgLevelId(主岗的职务级�?)
     * @param feildvalue condition对应的�?�，类型必须也是对应的，比如name就是String，orgPostId就必须是Long，否则数据库抛出异常
     * @param flipInfo 分页信息，可以为<code>null</code>，表示所�?
     * @return
     */
    List<V3xOrgMember> getAllMembersByAccountId(Long accountId, Integer type, Boolean isInternal, Boolean enable,
            String condition, Object feildvalue, FlipInfo flipInfo);
    
    /**
     * 从数据库中取出人员，默认条件�?<code>isDelete=false and isVirtual=false and isAssigned=true</code>，即把删除人员�?�虚拟账号�?�取消分配缺省排除，通过其它接口提供
     * 
     * @param departmentId 不能为null
     * @param isCludChildDepart 是否包含子部门，<code>true</code>包含
     * @param type 人员类型：正�?/非正�?/...，可以为<code>null</code>，表示不区分 
     * @param isInternal 可以�?<code>null</code>，表示不区分
     * @param enable 可以�?<code>null</code>，表示不区分
     * @param condition 取�?�：name, code, loginName, orgPostId(主岗), orgLevelId(主岗的职务级�?)
     * @param feildvalue condition对应的�?�，类型必须也是对应的，比如name就是String，orgPostId就必须是Long，否则数据库抛出异常
     * @param flipInfo 分页信息，可以为<code>null</code>，表示所�?
     * @return
     */
    List<V3xOrgMember> getAllMembersByDepartmentId(Long departmentId, boolean isCludChildDepart, Integer type, Boolean isInternal, Boolean enable, String condition,  Object feildvalue, FlipInfo flipInfo);
    
    /**
     * 判断原始登录名是否正�?
     * @param loginName 登录�?
     * @param password 密码
     * @return
     */
    Boolean isOldPasswordCorrect(String loginName, String password);
    
    /**
     * 登录名是否重�?
     * @param loginName 登录�?
     * @return
     */
    Boolean isExistLoginName(String loginName);
    /**
     * 根据角色名称获得分配的实�?
     * @param unitId
     * @param rolename
     * @return
     * @throws BusinessException
     */
    public List<V3xOrgEntity> getEntitysByRole(Long unitId, String rolename) throws BusinessException;
    /**
     * 根据角色名称获得分配的实�?(返回选人字符串格�?)
     * @param unitId
     * @param rolename
     * @return
     * @throws BusinessException
     */
    public String getEntitysStrByRole(Long unitId, String rolename) throws BusinessException;
    
    /**
     * 获取岗位下的人员，支持集团基准岗，限制单位可见范�?
     * <pre>
     * /--- PostId --|-- accountId --|--------------- 返回�? ------------/
     * |   标准�?           |   null/集团ID |   全集团所有单位引用自建岗下的人员  |
     * |   标准�?           |   单位ID       |   指定单位引用自建岗下的人�?              |
     * |   单位自建�?  |   此参数被忽略   |   指定单位引用自建岗下的人�?              |
     * </pre>
     * 
     * @param postId 岗位id
     * @param accountId 当前登录者的当前登录单位id
     * @return
     * @throws BusinessException
     */
    List<V3xOrgMember> getMembersByPost4Access(Long postId, Long accountId) throws BusinessException;
    
    /**
     * 根据单位ID判断是否可以访问集团
     * @param accountId 单位id
     * @return
     * @throws BusinessException
     */
    boolean isAccessGroup(Long accountId) throws BusinessException;
    
    /**
     * 只根据实体ID去获取实体名称，只从缓存中查询，不从数据库中查，只支持人员，部门单位，组，职务，岗位实体
     * @param id
     * @return
     * @throws BusinessException
     */
    V3xOrgEntity getEntityOnlyById(Long id) throws BusinessException;
    
    /**
     * 5.1新增接口，配合T3任务每个单位不同登录页任务项<br>
     * 根据设置的url获取单位ID
     * @param customLoginUrl 单位的登录url(不包括ip地址和端�?)
     * @return 单位ID，如果匹配到返回null
     * @throws BusinessException
     */
    Long getAccountIdByCustomLoginUrl(String customLoginUrl) throws BusinessException;
    
    /**
     * 5.1新增接口，配合T3任务每个单位不同登录页任务项<br>
     * 根据单位ID获取单位独立登录地址
     * @param accountId 单位ID
     * @return 单位独立登录页地�?，如果没有就返回null
     * @throws BusinessException
     */
    String getCustomLoginUrlByAccountId(Long accountId) throws BusinessException;
    
    /**
     * 根据部门名称获取部门列表
     * @param deptName
     * @return
     * @throws BusinessException
     */
    List<V3xOrgDepartment> getDepartmentsByName(String deptName, Long acccountId) throws BusinessException;
    
    /**
     * 根据组名称获取组列表
     * @param teamName
     * @param acccountId
     * @return
     * @throws BusinessException
     */
    List<V3xOrgTeam> getTeamsByName(String teamName, Long acccountId) throws BusinessException;
    
    /**
     * 获取某人在某部门内能看到的所有人员列表，根据单位内的工作范围过滤
     * @param memberId 人员ID
     * @param departmentId 部门ID
     * @return
     * @throws BusinessException
     */
    List<V3xOrgMember> getMembersByDeptIdWithCheckLevelScope(Long memberId, Long departmentId) throws BusinessException;
    
    
    /**
     * 返回�?个部门下的副岗和兼职列表,Map<部门ID,人员列表>
     * 
     * @param departmentId
     * @return
     * @throws BusinessException
     */
    List<MemberPost> getSecConMemberByDept(Long departmentId) throws BusinessException;
    
    /**
     * 获取人员在特定单位的兼职信息
     * @param memberId
     * @return
     * @throws BusinessException
     */
    List<MemberPost> getMemberConcurrentPostsByAccountId(Long memberId, Long acccountId) throws BusinessException;
    
    /**
     * 删除�?有的兼职岗位
     * @param accountId 可以�?<code>null</code>，表示所有单�?
     * @throws BusinessException
     */
    void clearAllCurrentPosts(Long accountId) throws BusinessException;
    
    /**得到崗位類的關係
     * @param memberId 可以為空
     * @param accountId 可以為空    
     * @param enummap 可以為空
     * @return
     * @throws BusinessException
     */
    List<V3xOrgRelationship> getMemberPostRelastionships(Long memberId, Long accountId,
            EnumMap<RelationshipObjectiveName, Object> enummap) throws BusinessException;
    
    /**
     * @param deptId Long 部門id
     * @return 頂級部門層級�?1�?始；无效部门返回-1
     * @throws BusinessException
     */
    int getDeptLevel(Long deptId) throws BusinessException;
    
    /**
     * 获取单位下的部门的岗�?
     * @param accountId 单位id
     * @return
     * @throws BusinessException
     */
    Map<Long, List<V3xOrgPost>> getAccountDeptPosts(Long accountId) throws BusinessException;
    
    /**
     * 根据前面的部门，判断后面的部门是否是其子部门
     * @param parentDepId
     * @param deptid
     * @return
     * @throws BusinessException
     */
    boolean isInDepartmentPathOf(Long parentDepId, Long deptid) throws BusinessException;
    
    /**
     * 取得单位下的外部部门
     * @param accountId
     * @return
     */
	List<V3xOrgDepartment> getAllExtDepartments(Long accountId);
	
	/**
	 * 取得单位下的内部部门
	 * @param accountId
	 * @return
	 * @throws BusinessException
	 */
	List<V3xOrgDepartment> getAllInternalDepartments(Long accountId) throws BusinessException;
	
	/**
	 * 根据组id和组内人员类型取得组人员
	 * @param teamId
	 * @param teamIds
	 * @param types
	 * @return
	 * @throws BusinessException
	 */
	List<V3xOrgMember> getMembersByTeam(Long teamId, Set<Long> teamIds, TeamMemberType[] types)
			throws BusinessException;
	
	/**
     * 普�?�人员可以看到的部门中的人员
     * @param memberId
     * @param departmentId
     * @param levelScope
     * @param 是否只包含本部门。为true时不包含子部门人员，否则取本部门以及�?有子部门的人员�??
     * @return
     * @throws BusinessException
     */
	List<V3xOrgMember> canSeMembersByDeptId(Long memberId, Long departmentId, int levelScope,boolean filter) throws BusinessException;
	
	/**
     * 获取人员可以看到的职�?
     * @param currentMember
     * @param levelScope
     * @param allLevels
     * @param accountId
     * @param concurrentPostMap
     * @return
     * @throws BusinessException
     */
	Set<Long> canSeeLevels(V3xOrgMember currentMember, int levelScope, List<V3xOrgLevel> allLevels, Long accountId,
			Map<Long, List<MemberPost>> concurrentPostMap) throws BusinessException;
	/**
	 * 获取可以选择的部�?
	 * @param memberId
	 * @param departmentId
	 * @param levelScope
	 * @param canSeeLevels
	 * @param deptIds
	 * @return
	 * @throws BusinessException
	 */
	Boolean canSeSubDept(Long memberId, Long departmentId, int levelScope, Set<Long> canSeeLevels,
			Set<Long> deptIds) throws BusinessException;
	/**
	 * 获取该单位下的，集团、单位或部门自定义角�?
	 * @param accountId
	 * @param bond
	 * @return
	 * @throws BusinessException
	 */
	List<V3xOrgRole> getAllCustomerRoles(Long accountId, int bond) throws BusinessException;
	
	/**
	 * 取指定单位下指定单位下的人员，自动往上查�? 
	 * @param accountId
	 * @param roleNameOrId
	 * @return
	 * @throws BusinessException
	 */
	List<V3xOrgMember> getMembersByAccountRoleOfUp(long accountId, String roleNameOrId) throws BusinessException;
	
	/**
	 * 獲取系統設置的初始密碼，如果沒設置過，則�?123456
	 * @return 初始密碼
	 */
	String getInitPWD();
	
	String getInitPWDForPage();
	
	/**
	 * 获取�?个单位或部门下面指定人员是否具有特定角色
	 * 
	 * @param memberId 人员的id
	 * @param unitId 部门或�?�单位的id
	 * @param roleName 角色名称
	 * @return 如果有特定角则返回true
	 * @throws BusinessException
	 */
	Boolean hasSpecificRole(Long memberId, Long unitId, String roleName) throws BusinessException;
	
	 /**
     * 
     * @方法名称: getMemberRolesForSet
     * @功能描述:
     * * 根据人员id和单位id，获取这个人�?在单位内拥有的角色列表，包含部门角色
     * <br>注意：这个方法会返回人员的岗位�?�部门�?�职务所拥有的角�?
     * <pre>
     * | unitId类型   | 部门角色   | 单位角色 |集团角色 |
     * ---------------------------------------------
     * |  null       |    V    |    V    |    V    |
     * |  部门ID     |    V    |         |         |
     * |  单位ID     |         |    V    |    V    |
     * |  集团ID     |         |         |    V    |
     * </pre>
     * @参数 ：@param memberId 人员id
     * @参数 ：@param unitId 组织id
     *              <pre>
     *              1. 可以�?<code>null</code>，表示全系统担任�?有�?�单位角色�?�和“部门角色�??
     *              2. 单位id：在这个单位下担任的“单位角色�?�和“部门角色�??
     *              3. 部门id：在这个部门下担任的“部门角色�??
     *              </pre> 
     * @参数 ：@return 角色集合
     * @参数 ：@throws BusinessException
     * @返回类型：Set<String>
     * @创建时间 �?2015�?11�?18�? 下午8:10:51
     * @创建�? �? FuTao
     * @修改�? �? 
     * @修改时间 �?
     */
	public Set<String> getMemberRolesForSet(Long id, Long accountId) throws BusinessException;
	
	 /**
     * 取得单位的部门下的外部部�?
     * @param accountId 单位编号
     * @param deptId 部门编号
     * @return
     */
	public List<V3xOrgDepartment> getChildExtDepartments(Long accountId, Long deptId);
    /**
     * 根据人员ID获得内部人员与外部人员的互访权限(不包括挂靠部门的情况)
     * @param memberId 人员id
     * @return HashMap<Long:工作范围部门编号, UniqueList<V3xOrgMember>:用户信息集合>
     * @throws BusinessException
     */
	public HashMap<Long, UniqueList<V3xOrgMember>> getMemberWorkScopeForExternalForMap(Long memberId)
			throws BusinessException;
	/**
	 * 判断指定人员是否是制定单位的兼职人员(给肖林提供的接口)
	 * @param memberId
	 * @param accountId
	 * @return
	 * @throws BusinessException
	 */
	public boolean isSecondMemberForAccount(Long memberId, Long accountId) throws BusinessException;
	/**
	 * 
	 * @方法名称: checkRolePrefabricated
	 * @功能描述: �?查角色是否预�?
	 * @参数 ：@param roleId 角色编号
	 * @参数 ：@return
	 * @参数 ：@throws BusinessException
	 * @返回类型：boolean
	 * @创建时间 �?2016�?6�?14�? 下午9:40:54
	 * @修改�? �? 
	 * @修改时间 �?
	 */
	public boolean checkRolePrefabricated(Long roleId) throws BusinessException;
	/**
	 * 
	 * @方法名称: getRoleByCode
	 * @功能描述: 通过code过去角色列表
	 * @参数 ：@param code 角色code
	 * @参数 ：@param accountId 单位编号
	 * @参数 ：@return
	 * @参数 ：@throws BusinessException

	 */
	public List<V3xOrgRole> getRoleByCode(String code, Long accountId) throws BusinessException;
	/**
	 * 能够获取的岗位下的人�?
	 * @param memberId
	 * @param postId
	 * @param levelScope
	 * @return
	 * @throws BusinessException
	 */
	public List<V3xOrgMember> canSeMembersByPostId(Long memberId, Long postId,int levelScope) throws BusinessException;
	
	/**
	* 指定单位下，获取指定实体在指定更新日期后的列表数据和�?后更新时�?
	* @param entityClassName
	* @param updateTime  取所有实体，传null
	* @param accountId  实体是单位时，可以为null
	* @return  map   key=list,lastDate
	* @throws BusinessException
	*/
	Map<String,Object> getUpdateEntityAndLastTime(String entityClassName,Date updateTime,Long accountId) throws BusinessException;
	
	/**
	 * 获取�?有的人员，（包含无效人员�?
	 * @param accountId
	 * @return
	 * @throws BusinessException
	 */
	List<V3xOrgMember> getAllMembersWithDisable(Long accountId) throws BusinessException;
	/**
	 * 校验人员是否可以进行离职办理
	 * @param memberId
	 * @return
	 * @throws BusinessException
	 */
	String checkCanLeave(Long memberId) throws BusinessException;
	
	/**
	 * 获取无效实体（删除和停用�?
	 * 只给快�?�查询用的，每次�?多只返回十条数据
	 * @param entityClassName
	 * @param accountId
	 * @return
	 */
	List<V3xOrgEntity> getDisableEntity(String entityClassName, Long accountId,String condition, Object feildvalue);
	/**
	 * 获取人员头像
	 * @param memberId
	 * @return
	 */
	String getAvatarImageUrl(Long memberId);
	/**
	 * 人员是vjon人员时，判断是否可以互访
	 * @param currentMemberId
	 * @param memberId
	 * @return
	 * @throws BusinessException
	 */
	boolean checkLevelForExternal(Long currentMemberId, Long memberId)throws BusinessException;
	
	/**
	 * 获取该部门的全路�?
	 * @param deptId
	 * @return
	 * @throws BusinessException
	 */
	String showDepartmentFullPath(Long deptId) throws BusinessException;
	
    int getMemberExternalType(Long memberId) throws BusinessException;
    
    /**
	 * 获取总公司和分公司单位ID和名称
	 */
	public Map<String,String> getAccountIdAndNames();
}