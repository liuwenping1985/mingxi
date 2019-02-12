package com.seeyon.ctp.organization.manager;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import com.seeyon.ctp.organization.bo.*;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;

import com.seeyon.apps.kdXdtzXc.util.PropertiesUtils;
import com.seeyon.apps.ldap.config.LDAPConfig;
import com.seeyon.apps.ldap.util.Authenticator;
import com.seeyon.apps.ldap.util.LDAPTool;
import com.seeyon.apps.ldap.util.LdapUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.config.SystemConfig;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.ctpenumnew.dao.EnumItemDAO;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.flag.SysFlag;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.log.CtpLogFactory;
import com.seeyon.ctp.common.po.BasePO;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.common.po.usermapper.CtpOrgUserMapper;
import com.seeyon.ctp.common.usermapper.dao.UserMapperDao;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.OrgConstants.Account_AccessScope_Type;
import com.seeyon.ctp.organization.OrgConstants.MemberPostType;
import com.seeyon.ctp.organization.OrgConstants.ORGENT_TYPE;
import com.seeyon.ctp.organization.OrgConstants.RelationshipObjectiveName;
import com.seeyon.ctp.organization.OrgConstants.RelationshipType;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.OrgConstants.TEAM_TYPE;
import com.seeyon.ctp.organization.OrgConstants.TeamMemberType;

import com.seeyon.ctp.organization.dao.OrgCache;
import com.seeyon.ctp.organization.dao.OrgDao;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.po.JoinAccount;
import com.seeyon.ctp.organization.po.OrgLevel;
import com.seeyon.ctp.organization.po.OrgMember;
import com.seeyon.ctp.organization.po.OrgRelationship;
import com.seeyon.ctp.organization.principal.NoSuchPrincipalException;
import com.seeyon.ctp.organization.principal.PrincipalManager;
import com.seeyon.ctp.portal.api.SpaceApi;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UniqueList;
import com.seeyon.ctp.util.annotation.AjaxAccess;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;
import com.seeyon.ctp.util.json.JSONUtil;

public class OrgManagerImpl implements OrgManager {
	private final static Log     logger       = CtpLogFactory.getLog(OrgManagerImpl.class);
	private OrgCache             orgCache;
	private OrgDao               orgDao;
	private OrgManagerDirect     orgManagerDirect;
	private JoinOrgManagerDirect joinOrgManagerDirect;
	private JoinAccountCustomerFieldInfoManager joinAccountCustomerFieldInfoManager;
	private PrincipalManager     principalManager;
	private SystemConfig         systemConfig;
	private SpaceApi             spaceApi;
	private EnumItemDAO          newEnumItemDAO;
	private String accounts = "-2329940225728493295|中国信达资产管理股份有限公司,"
	        +"3664162159175945848|黑龙江分公司,3421399311787445171|山东分公司,-9041150167127212005|辽宁分公司,"
			+"3074543492480519438|宁夏分公司,-4058377350576844976|上海自贸区分公司,2662344410291130278|北京分公司,"
			+"-186884716227510066|海南分公司,-760181039509385580|江西分公司,6622655769517115117|广西分公司,"
			+"2834525107653790181|河北分公司,3674408233290321902|新疆分公司,4498629552994928530|重庆分公司,"
			+"7685034498061782501|安徽分公司,-933361846426711257|云南分公司,4538261120908608848|甘肃分公司,"
			+"-5358952287431081185|江苏分公司,-5775279222203856230|上海分公司,-2253116709917929726|湖南分公司,"
			+"-6820179698828490815|广东分公司,2918815885120916765|浙江分公司,1615999057975788128|天津分公司,"
			+"6385708607716213359|陕西分公司,7036903945253766800|河南分公司,-3365316383954745086|山西分公司,"
			+"814361513619050478|吉林分公司,-6020108033365555254|四川分公司,-2653794827601557270|福建分公司,"
			+"-2593247964549918808|贵州分公司,8554224093722463471|内蒙古分公司,4651911572204437887|深圳分公司,"
			+"9139674887561694241|青海分公司,1755267543710320898|湖北分公司,7099810924049157974|后援中心,"
			+"-9126218257469846298|南洋商业银行有限公司（中国）";
	private static List<String>  roleCodeList = new ArrayList<String>();
	private Map<String,String> account_map = new HashMap<String, String>();
	private String[] account_ids = accounts.split(",");
	{
		for (String tmpId : account_ids) {
			String[] str = tmpId.split("\\|");
			account_map.put(str[0], str[1]);//单位ID对应单位名称
		}
	}
	
	/**
	 * 获取总公司和分公司单位ID和名称
	 */
	public Map<String,String> getAccountIdAndNames(){
		return account_map;
	}

	public void setOrgCache(OrgCache orgCache) {
		this.orgCache = orgCache;
	}

	public void setOrgDao(OrgDao orgDao) {
		this.orgDao = orgDao;
	}

	public void setOrgManagerDirect(OrgManagerDirect orgManagerDirect) {
		this.orgManagerDirect = orgManagerDirect;
	}

	public void setJoinOrgManagerDirect(JoinOrgManagerDirect joinOrgManagerDirect) {
		this.joinOrgManagerDirect = joinOrgManagerDirect;
	}

	public void setJoinAccountCustomerFieldInfoManager(JoinAccountCustomerFieldInfoManager joinAccountCustomerFieldInfoManager) {
		this.joinAccountCustomerFieldInfoManager = joinAccountCustomerFieldInfoManager;
	}

	public void setPrincipalManager(PrincipalManager principalManager) {
		this.principalManager = principalManager;
	}

	public void setSystemConfig(SystemConfig systemConfig) {
		this.systemConfig = systemConfig;
	}

	public void setSpaceApi(SpaceApi spaceApi) {
		this.spaceApi = spaceApi;
	}

	public void setNewEnumItemDAO(EnumItemDAO newEnumItemDAO) {
		this.newEnumItemDAO = newEnumItemDAO;
	}

	static String roleCode[] = new String[] { "EdocManagement", "Accountexchange", "SendEdoc", "SignEdoc", "RecEdoc",
		"FormAdmin", "EdocModfiy", "HrAdmin", "SalaryAdmin", "PerformanceAdmin", "ShowAdmin", "MemberBlog",
		"CarsAdmin", "StocksAdmin", "AssetsAdmin", "BooksAdmin", "AccountLeader", "AccountSpecialTrainAdmin",
		"DepartmentSpecialTrainAdmin", "DepManager", "DepLeader", "DepAdmin", "Departmentexchange","EmployeeBenefitAdmin","MeetingRoomAdmin","AttendanceAdmin" };

	static String[][] PlugConfig = new String[14][2];
	static{
		PlugConfig[0] = new String[]{"edoc","Departmentexchange,EdocManagement,Accountexchange,SendEdoc,SignEdoc,RecEdoc,EdocModfiy"};
		PlugConfig[1] = new String[]{"hr","HrAdmin,SalaryAdmin"};
		PlugConfig[2] = new String[]{"seeyonreport","ReportAdmin"};
		PlugConfig[3] = new String[]{"infosend","InfoReporter,MagazineAudit,InfoManager"};
		PlugConfig[4] = new String[]{"office","AssetsAdmin,BooksAdmin,CarsAdmin,StocksAdmin"};
		PlugConfig[5] = new String[]{"didicar","GroupSpecialTrainAdmin,AccountSpecialTrainAdmin,DepartmentSpecialTrainAdmin"};
		PlugConfig[6] = new String[]{"didicar*","GroupSpecialTrainAdmin"};
		PlugConfig[7] = new String[]{"neigou","EmployeeBenefitAdmin"};
		PlugConfig[8] = new String[]{"show","ShowAdmin"};
		PlugConfig[9] = new String[]{"behavioranalysis", "PerformanceAdmin"};
		PlugConfig[10] = new String[]{"blog","MemberBlog"};
		PlugConfig[11] = new String[]{"doc", "EdocModfiy"};
		PlugConfig[12] = new String[]{"meeting", "MeetingRoomAdmin"};
		PlugConfig[13] = new String[]{"attendance", "AttendanceAdmin"};
		roleCodeList= Arrays.asList(roleCode);
	}

	public List<V3xOrgRole> getPlugDisableRole(Long accountId) throws BusinessException {
		List<V3xOrgRole> list = new ArrayList<V3xOrgRole>();
		for (String[] obj : PlugConfig) {
			if (!AppContext.hasPlugin(obj[0])||obj[0].indexOf("*")!=-1) {
				String[] code = obj[1].split(",");
				for (String string : code) {
					if(AppContext.hasPlugin(StringUtils.removeEnd(obj[0], "*"))){
						logger.debug("角色插件："+AppContext.getSystemProperty("didicar.isGroupControl.isNeed"));
						if(Boolean.parseBoolean(AppContext.getSystemProperty("didicar.isGroupControl.isNeed"))){
							break;
						}
					}
					V3xOrgRole role = getRoleByName(string, accountId);
					if (role != null) {
						list.add(role);
					}
				}
			}
		}
		return list;
	}

	public <T extends V3xOrgEntity> T getEntityByIdNoClone(Class<T> classType, Long id) throws BusinessException {
		return getEntityById(classType, id, false);
	}

	public <T extends V3xOrgEntity> T getEntityById(Class<T> classType, Long id) throws BusinessException {
		return getEntityById(classType, id, true);
	}

	private <T extends V3xOrgEntity> T getEntityById(Class<T> classType, Long id, boolean isClone) throws BusinessException {
		if (classType == null) {
			return null;
		}

		// 忽略传入id为0和-1，没有必要去查
		if (id == null || Strings.equals(id, V3xOrgEntity.DEFAULT_NULL_ID) || Strings.equals(id, 0L)) {
			return null;
		}

		//补充系统自动触发信息的用户
		if (classType.equals(V3xOrgMember.class) && Strings.equals(V3xOrgEntity.CONFIG_SYSTEM_AUTO_TRIGGER_ID, id)) {
			V3xOrgMember member = new V3xOrgMember();
			member.setId(id);
			member.setName(ResourceUtil.getString("org.system.auto.trigger"));
			member.setOrgAccountId(V3xOrgEntity.VIRTUAL_ACCOUNT_ID);

			return (T)member;
		}

		//补充工资管理员发信息的用户
		if (classType.equals(V3xOrgMember.class) && Strings.equals(V3xOrgEntity.CONFIG_SALARY_ADMIN_TRIGGER_ID, id)) {
			V3xOrgMember member = new V3xOrgMember();
			member.setId(id);
			member.setName(ResourceUtil.getString("sys.role.rolename.SalaryAdmin"));
			member.setOrgAccountId(V3xOrgEntity.VIRTUAL_ACCOUNT_ID);

			return (T)member;
		}

		// 1、从内存取（启用）
		T ent = (T) orgCache.getV3xOrgEntity(classType, id, isClone);
		if (ent != null) {
			return ent;
		}

		// 2、从无效实体缓存中取
		ent = (T)orgCache.getDisabledEntity(classType, id, isClone);
		if (ent != null) {
			return ent;
		}

		// 3、从数据库中取
		BasePO l = orgDao.getEntity(OrgHelper.boClassTopoClass(classType), id);
		ent = (T) OrgHelper.poTobo(l);

		// 4、 无效实体进入缓存
		if(ent != null && !ent.isValid()){
			orgCache.cacheDisabledEntity(ent);
		}

		return ent;
	}

	@Override
	public V3xOrgEntity getEntity(String entityType, Long id) throws BusinessException {
		// 流程匹配的时候，类型可能是其他的对象。只会用到name和id，临时封装成一个对象
		if(V3xOrgEntity.ORGENT_TYPE_JOINACCOUNTTAG.equals(entityType)){
			//枚举值对象
			CtpEnumItem item = newEnumItemDAO.findById(id);
			if(item != null){
				V3xOrgEntity entity = new V3xOrgMember();
				entity.setId(id);
				entity.setName(ResourceUtil.getString(item.getShowvalue()));
				return entity; 
			}
		}
		return getEntityById(OrgHelper.strTobo(entityType), id);
	}

	@Override
	public List<V3xOrgEntity> getEntitys4Merge(String typeAndId) throws BusinessException {
		if (Strings.isBlank(typeAndId)) {
			return null;
		}

		String[] data = typeAndId.split("[|]");

		if (data.length < 2) {
			throw new BusinessException("参数格式不正确 [" + typeAndId + "]; 正确的格式应该为 [Department_Post|5129341885565_123456789]");
		}

		List<V3xOrgEntity> result = new ArrayList<V3xOrgEntity>();

		String[] unitStr = data[0].split("_");
		String[] entiStr = data[1].split("_");

		//加载到list里面的顺序不要随意修改
		V3xOrgEntity unit = this.getEntity(unitStr[0], Long.valueOf(entiStr[0]));
		V3xOrgEntity enti = this.getEntity(unitStr[1], Long.valueOf(entiStr[1]));

		if(unit != null && enti != null){
			result.add(unit);
			result.add(enti);
		}

		return result;

	}

	@Override
	public V3xOrgEntity getEntity(String typeAndId) throws BusinessException {
		if (Strings.isBlank(typeAndId)) {
			return null;
		}

		String[] data = typeAndId.split("[|]");

		if (data.length < 2) {
			throw new BusinessException("参数格式不正确 [" + typeAndId + "]; 正确的格式应该为 [Member|5129341885565]");
		}

		return getEntity(data[0], Long.valueOf(data[1]));
	}

	@Override
	public V3xOrgEntity getEntityAnyType(Long id) throws BusinessException {
		V3xOrgEntity ent = orgCache.getV3xOrgEntity(V3xOrgMember.class, id);
		if (ent == null) {
			ent = orgCache.getV3xOrgEntity(V3xOrgDepartment.class, id);
		}
		if (ent == null) {
			ent = orgCache.getV3xOrgEntity(V3xOrgPost.class, id);
		}
		if (ent == null) {
			ent = orgCache.getV3xOrgEntity(V3xOrgLevel.class, id);
		}
		if (ent == null) {
			ent = orgCache.getV3xOrgEntity(V3xOrgAccount.class, id);
		}
		if (ent == null) {
			ent = orgCache.getV3xOrgEntity(V3xOrgTeam.class, id);
		}
		if (ent == null) {
			ent = orgCache.getV3xOrgEntity(V3xOrgRole.class, id);
		}

		return ent;
	}

	@Override
	public V3xOrgEntity getEntityNoRelation(String entityClassName, String property, Object value, Long accountId)
	throws BusinessException {
		List<V3xOrgEntity> list = getEntityNoRelation(entityClassName, property, value, accountId,false);
		return Strings.isEmpty(list) ? null : list.get(0);
	}

	public List<V3xOrgEntity> getEntityNoRelation(String entityClassName, String property, Object value,
			Long accountId, boolean isPaginate,boolean equal) {
		return getEntityNoRelation(entityClassName,property,value,accountId,isPaginate,equal,true);
	}

	@Override
	public List<V3xOrgEntity> getEntityNoRelation(String entityClassName, String property, Object value,
			Long accountId, boolean isPaginate,boolean equal,Boolean enable) {

		List<V3xOrgEntity> enList = new ArrayList<V3xOrgEntity>();

		if (entityClassName.equals(V3xOrgLevel.class.getSimpleName())) {
			enList.addAll(OrgHelper.listPoTolistBo(orgDao.getAllLevelPO(accountId, enable, property, value, null,equal)));
		} else if (entityClassName.equals(V3xOrgMember.class.getSimpleName())) {
			Map<String, String> map = OrgHelper.getMemberExtAttrKeyMaps();
			if(map.containsKey(property)) {
				enList.addAll(OrgHelper.listPoTolistBo(orgDao.getAllMemberPOByAccountId(accountId, null, null, enable,
						map.get(property), value, null,equal)));
			} else {
				enList.addAll(OrgHelper.listPoTolistBo(orgDao.getAllMemberPOByAccountId(accountId, null, null, enable,
						property, value, null,equal)));
			}
		} else if (entityClassName.equals(V3xOrgPost.class.getSimpleName())) {
			enList.addAll(OrgHelper.listPoTolistBo(orgDao.getAllPostPO(accountId, enable, property, value, null,equal)));
		} else if (entityClassName.equals(V3xOrgRole.class.getSimpleName())) {
			enList.addAll(OrgHelper.listPoTolistBo(orgDao.getAllRolePO(accountId, enable, property, value, null,equal)));
		} else if (entityClassName.equals(V3xOrgTeam.class.getSimpleName())) {
			enList.addAll(OrgHelper.listPoTolistBo(orgDao.getAllTeamPO(accountId, null, enable, property, value, null,equal)));
		} else if (entityClassName.equals(V3xOrgAccount.class.getSimpleName())) {
			enList.addAll(OrgHelper.listPoTolistBo(orgDao.getAllUnitPO0(OrgConstants.UnitType.Account, null, enable, null,
					property, value, null,equal)));
		} else if (entityClassName.equals(V3xOrgDepartment.class.getSimpleName())) {
			enList.addAll(OrgHelper.listPoTolistBo(orgDao.getAllUnitPO0(OrgConstants.UnitType.Department, accountId, enable, null,
					property, value, null,equal)));
		}

		return enList;
	}

	public List<V3xOrgEntity> getEntityNoRelation(String entityClassName, String property, Object value,
			Long accountId, boolean isPaginate) {
		return getEntityNoRelation(entityClassName,property,value,accountId,isPaginate,false);
	}


	@Override
	public List<V3xOrgEntity> getEntities(String typeAndIds) throws BusinessException {
		if (Strings.isBlank(typeAndIds)) {
			return null;
		}

		List<V3xOrgEntity> list = new ArrayList<V3xOrgEntity>();

		String[] items = typeAndIds.split(V3xOrgEntity.ORG_ID_DELIMITER);
		for (String item : items) {
			V3xOrgEntity entity = this.getEntity(item);
			if (entity != null) {
				list.add(entity);
			}
		}

		return list;
	}

	@Override
	public List<V3xOrgEntity> getEntityList(String entityClassName, String property, Object value, Long accountId)
	throws BusinessException {
		return getEntityList(entityClassName, property, value, accountId, false);
	}

	@Override
	public List<V3xOrgEntity> getEntityList(String entityClassName, String property, String value, Long accountId)
	throws BusinessException {
		return getEntityNoRelation(entityClassName, property, value, accountId, false);
	}

	@Override
	public List<V3xOrgEntity> getEntityList(String entityClassName, String property, Object value, Long accountId,
			boolean isPaginate) throws BusinessException {
		return getEntityNoRelation(entityClassName, property, value, accountId, isPaginate);
	}

	@Override
	public List<V3xOrgEntity> getEntityList(String entityClassName, String property, Object value, Long accountId,
			boolean isPaginate,boolean equal) throws BusinessException {
		return getEntityNoRelation(entityClassName, property, value, accountId, isPaginate,equal);
	}

	@Override
	public Set<V3xOrgMember> getMembersByTypeAndIds(String typeAndIds) throws BusinessException {
		Set<V3xOrgMember> members = new HashSet<V3xOrgMember>();
		if (StringUtils.isNotBlank(typeAndIds)) {
			String[] items = typeAndIds.split(V3xOrgEntity.ORG_ID_DELIMITER);
			for (String item : items) {
				String[] data = item.split("[|]");

				String type = data[0];
				String id = data[1];

				members.addAll(getMembersByType(type, id));
			}
		}

		return members;
	}

	@Override
	@Deprecated
	public V3xOrgEntity getGlobalEntity(String entityType, Long id) throws BusinessException {
		return getEntity(entityType, id);
	}
	public V3xOrgEntity getGlobalEntityNoClone(String entityType, Long id) throws BusinessException {
		return getEntity(entityType, id);
	}

	@Override
	public V3xOrgAccount getAccountByLoginName(String loginName) throws BusinessException {
		V3xOrgMember member = getMemberByLoginName(loginName);
		if(member == null){
			return null;
		}

		Long accountId = member.getOrgAccountId();

		return getAccountById(accountId);
	}

	@Override
	public List<V3xOrgAccount> getChildAccount(Long accountId, boolean firstLayer) throws BusinessException {
		if (firstLayer) {
			V3xOrgAccount source = this.getAccountById(accountId);
			List<V3xOrgAccount> accounts = orgCache.getChildAccount(accountId);
			List<V3xOrgAccount> results = new UniqueList<V3xOrgAccount>();

			for (V3xOrgAccount a : accounts) {
				if(null != a.getPath()
						&& null != source
						&& a.getPath().length() == source.getPath().length() + 4) {//00000001与000000010001、000000010002
					results.add(a);
				}
			}
			results.add(source);
			return results;
		} else {
			return orgCache.getChildAccount(accountId);
		}
	}

	@Override
	public V3xOrgAccount getRootAccount() throws BusinessException {
		List<V3xOrgAccount> allAccounts = this.orgCache.getAllV3xOrgEntityNoClone(V3xOrgAccount.class, null);
		if("true".equals(SystemProperties.getInstance().getProperty("org.isGroupVer"))){
			for (V3xOrgAccount a : allAccounts) {
				if(a.isValid() && a.isGroup()){
					return a;
				}
			}
		}

		for (V3xOrgAccount a : allAccounts) {
			if(a.isValid() && "00000001".equals(a.getPath())){
				return a;
			}
		}
		return null;
	}

	@Override
	public V3xOrgAccount getRootAccount(long accountId) throws BusinessException {
		V3xOrgAccount account = this.orgCache.getV3xOrgEntityNoClone(V3xOrgAccount.class, accountId);
		if(account == null || !account.isValid()){
			return null;
		}

		//多组织
		if("true".equals(SystemProperties.getInstance().getProperty("org.isGroupVer"))){
			List<V3xOrgAccount> allAccounts = this.orgCache.getAllV3xOrgEntityNoClone(V3xOrgAccount.class, null);
			for (V3xOrgAccount a : allAccounts) {
				if(a.isGroup() && account.getPath().startsWith(a.getPath())){
					return a;
				}
			}
		}
		else{ //单组织
			if("00000001".equals(account.getPath())){
				return account;
			}
		}

		return null;
	}

	@Override
	public List<V3xOrgAccount> concurrentAccounts4ChangeAccount(Long memberId) throws BusinessException {
		return concurrentAccount(memberId, true);
	}

	@Override
	public List<V3xOrgAccount> concurrentAccount(Long memberId) throws BusinessException {
		return concurrentAccount(memberId, true);
	}

	private List<V3xOrgAccount> concurrentAccount(Long memberId, boolean isIncludeCurrentAccount) throws BusinessException {
		List<V3xOrgAccount> accounts = new UniqueList<V3xOrgAccount>();

		OrgConstants.MemberPostType[] postType = null;
		if(!isIncludeCurrentAccount){ //只取兼职单位
			postType = new OrgConstants.MemberPostType[]{OrgConstants.MemberPostType.Concurrent};
		}

		List<V3xOrgRelationship> rels = this.orgCache.getMemberPostRelastionships(memberId, null, postType);

		for (V3xOrgRelationship rel : rels) {
			if(!isValidMemberPost4ConPost(rel)){//OA-54076
				continue;
			}

			V3xOrgAccount relAccount = getAccountById(rel.getOrgAccountId());
			if(relAccount != null && relAccount.isValid()){
				accounts.add(relAccount);
			}
		}

		Collections.sort(accounts, CompareSortEntity.getInstance());

		return accounts;
	}

	@Override
	public List<V3xOrgAccount> getConcurrentAccounts(Long memberId) throws BusinessException {
		return concurrentAccount(memberId, false);
	}

	@Override
	public Map<Long, List<MemberPost>> getConcurentPosts(Long accountId) throws BusinessException {
		return getConcurentPostsByMemberId(accountId, null);
	}

	@Override
	public Map<Long, List<MemberPost>> getConcurentPostsByMemberId(Long accountId, Long memberId) throws BusinessException {
		Map<Long, List<MemberPost>> cntMap = new HashMap<Long, List<MemberPost>>();
		List<MemberPost> result = this.getMemberPosts(accountId, memberId);

		for (MemberPost memberPost : result) {
			if(memberPost.getType() == MemberPostType.Concurrent){
				Long depId = memberPost.getDepId();
				Strings.addToMap(cntMap, depId, memberPost);
			}
		}

		return cntMap;
	}

	/**
	 *
	 * @param accountId 可以为<code>null</code>
	 * @param memberId 可以为<code>null</code>
	 * @param type 可以为<code>null</code>
	 * @return
	 * @throws BusinessException
	 */
	private List<MemberPost> getMemberPosts0(Long accountId, Long memberId, MemberPostType ... types) throws BusinessException {
		List<MemberPost> result = new UniqueList<MemberPost>();

		List<V3xOrgRelationship> rs = null;

		Set<String> ts = new HashSet<String>();

		if(types != null && types.length > 0){
			for (MemberPostType t : types) {
				ts.add(t.name());
			}
		}

		if(memberId == null){ //取全单位的
			if(ts.isEmpty() || ts.contains(MemberPostType.Main.name())){ //包含主岗
				EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
				if(!ts.isEmpty()){
					enummap.put(RelationshipObjectiveName.objective5Id, ts);
				}

				rs = this.orgCache.getV3xOrgRelationship(RelationshipType.Member_Post, memberId, accountId, enummap);
			}
			else{ //取单位下的兼职或者副岗
				rs = this.orgCache.getEntityConPostRelastionships(accountId, null, types);
			}
		}
		else{ //取单个人的
			rs = this.orgCache.getMemberPostRelastionships(memberId, accountId, types);
		}

		for (V3xOrgRelationship cnt : rs) {
			if(isValidMemberPost(cnt)){
				MemberPost cntPost = new MemberPost(cnt);
				result.add(cntPost);
			}
		}

		return result;
	}

	@Override
	public List<MemberPost> getMemberPosts(Long accountId, Long memberId) throws BusinessException {
		return getMemberPosts0(accountId, memberId);
	}

	@Override
	public List<MemberPost> getMemberSecondPosts(Long memberId) throws BusinessException {
		V3xOrgMember member = this.orgCache.getV3xOrgEntityNoClone(V3xOrgMember.class, memberId);
		return getMemberPosts0(null == member ? null : member.getOrgAccountId(), memberId, MemberPostType.Second);
	}

	@Override
	public List<MemberPost> getMemberConcurrentPosts(Long memberId) throws BusinessException {
		return getMemberPosts0(null, memberId, MemberPostType.Concurrent);
	}

	@Override
	public List<MemberPost> getMemberConcurrentPostsByAccountId(Long memberId, Long acccountId) throws BusinessException {
		return getMemberPosts0(acccountId, memberId, MemberPostType.Concurrent);
	}

	public List<MemberPost> getSecondPostByAccount(Long accountId) throws BusinessException {
		return getMemberPosts0(accountId, null, MemberPostType.Second);
	}

	@Override
	public List<MemberPost> getMainPostByAccount(Long accountId) throws BusinessException {
		return getMemberPosts0(accountId, null, MemberPostType.Main);
	}

	@Override
	public List<V3xOrgAccount> accessableAccounts(Long memberId) throws BusinessException {
		V3xOrgMember m = getMemberById(memberId);
		if (null == memberId || null == m) {
			throw new BusinessException("根据人员ID获取人员对象为空！memberId=" + memberId);
		}

		List<V3xOrgAccount> acList = new UniqueList<V3xOrgAccount>();

		Long accountId = m.getOrgAccountId();

		//人员所属的单位
		V3xOrgAccount selfacc = getAccountById(accountId);
		if (null != selfacc && !m.isVJoinExternal()) {
			acList.add(selfacc);
		}

		//V-Join人员取准出单位
		if (m.isVJoinExternal()) {
			Long jAccountId = OrgHelper.getVJoinAllowAccount();
			V3xOrgAccount jAccount = this.getAccountById(jAccountId);
			if (jAccount != null) {
				acList.add(jAccount);
			}

			return acList;
		}

		accessableUnit(accountId, acList);

		//人员所在兼职单位
		List<V3xOrgAccount> conAccounts = this.getConcurrentAccounts(memberId);
		acList.addAll(conAccounts);
		for (V3xOrgAccount account : conAccounts) {
			accessableUnit(account.getId(), acList);
		}

		return acList;
	}

	@Override
	public boolean checkAccessAccount(Long currentMemberId, Long memberId) throws BusinessException {
		V3xOrgMember currentMember  = this.getMemberById(currentMemberId);
		V3xOrgMember targetMember = this.getMemberById(memberId);
		if (null == targetMember || null == currentMember) {
			return false;
		}
		if(currentMember.isVJoinExternal() || targetMember.isVJoinExternal()){
			return checkLevelForExternal(currentMemberId,memberId);
		}
		//主岗单位在同一单位，可见。
		if(currentMember.getOrgAccountId().equals(targetMember.getOrgAccountId())){
			return true;
		}
		List<V3xOrgAccount> sourceList = accessableAccounts(currentMemberId);
		Set<Long> sIds = new HashSet<Long>();
		for (V3xOrgAccount sA : sourceList) {
			sIds.add(sA.getId());
		}

		if (sIds.contains(targetMember.getOrgAccountId())) {
			return true;
		}
		// 考虑所在兼职单位的可见
		List<V3xOrgAccount> conAccounts = this.getConcurrentAccounts(memberId);
		for (V3xOrgAccount conA : conAccounts) {
			if (sIds.contains(conA.getId())) {
				return true;
			}
		}
		return false;
	}

	public boolean checkLevelForExternal(Long currentMemberId, Long memberId) throws BusinessException{
		V3xOrgMember currentMember = getMemberById(currentMemberId);  
		if(currentMember == null){
			return false;
		}
		V3xOrgMember member = getMemberById(memberId);  
		if(member == null){
			return false;
		}

		//vjoin人员访问A8人员，判断是否在互访范围内
		if(currentMember.isVJoinExternal() && member.getExternalType().equals(0)){
			List<V3xOrgMember> innerMembers = joinOrgManagerDirect.getAccessInnerMembers(currentMemberId);
			if(innerMembers.contains(member)){
				return true;
			}
			return false;
		}
		//A8人员访问vjon人员，判断是否在访问范围内
		if(currentMember.getExternalType().equals(0) && member.isVJoinExternal()){
			List<V3xOrgMember> externalMembers = joinOrgManagerDirect.getAccessExternalMembers(currentMemberId);
			if(externalMembers.contains(member)){
				return true;
			}
			return false;
		}
		//都为vjoin人员，只能访问在本外部单位的人员
		if(currentMember.isVJoinExternal() && member.isVJoinExternal() && currentMember.getOrgDepartmentId().equals(member.getOrgDepartmentId())){
			return true;
		}

		return false;
	}

	@Override
	public boolean isAccessGroup(Long accountId) throws BusinessException {
		List<V3xOrgAccount> accessList = accessableAccountsByUnitId(accountId);
		for (V3xOrgAccount a : accessList) {
			if(a.getIsGroup()) {
				return true;
			} else {
				continue;
			}
		}
		return false;
	}

	/**
	 * 计算这个单位分支内的所有父单位的递归算法
	 * @param result
	 * @param account
	 * @throws BusinessException
	 */
	private void getAllParentAccount(List<V3xOrgAccount> result, V3xOrgAccount account) throws BusinessException {
		V3xOrgUnit parentUnit = this.getParentUnit(account);
		if(null != parentUnit && !account.isGroup() && OrgConstants.UnitType.Account.equals(parentUnit.getType())) {
			result.add((V3xOrgAccount)parentUnit);
			getAllParentAccount(result, (V3xOrgAccount)parentUnit);
		} else if(null != parentUnit && account.isGroup() && OrgConstants.UnitType.Account.equals(parentUnit.getType())) {
			result.add((V3xOrgAccount)parentUnit);
			return;
		}
	}

	private void accessableUnit(Long accountId, List<V3xOrgAccount> acList) throws BusinessException {
		List<V3xOrgRelationship> refList = orgCache.getV3xOrgRelationship(RelationshipType.Account_AccessScope,
				accountId, null, null);
		V3xOrgAccount account = getAccountById(accountId);

		if (null == account) {
			throw new BusinessException("获取单位异常，根据ID获取单位为空！");
		}
		//把自己加进去
		acList.add(account);
		//整个系统的所有单位列表
		List<V3xOrgAccount> allAccouts = orgCache.getAllAccounts();
		//如果是集团直接返回所有单位
		if (account.isGroup()) {
			acList.addAll(allAccouts);
			Collections.sort(acList, CompareUnitPath.getInstance());
			return;
		}

		String accountPath = account.getPath();
		List<V3xOrgAccount> samelengthPathList = orgCache.getSameLengthPathUnits(accountPath);
		List<V3xOrgAccount> allParents = new UniqueList<V3xOrgAccount>();
		//递归去找分支内的所有父单位一直找到集团
		this.getAllParentAccount(allParents, account);

		/*****自由设置********/
		//自由设置的最终列表
		List<V3xOrgAccount> resultFreeSet = new UniqueList<V3xOrgAccount>();
		resultFreeSet.addAll(allAccouts);
		boolean isFreeSet = false;//自由设置
		//Fix OA-7587
		Long permissionType = (Long) (null == account.getPOProperties("EXT_ATTR_12") ? Long.valueOf(0) : account
				.getPOProperties("EXT_ATTR_12"));

		for (V3xOrgRelationship rel : refList) {
			if (Long.valueOf(1).equals(permissionType)) {//分级管理
				if (OrgConstants.Account_AccessScope_Level_0.equals(rel.getObjective0Id())) {
					//分支内可见上级单位，只查询他范围内的上级单位
					acList.addAll(allParents);
				} else if (OrgConstants.Account_AccessScope_Level_1.equals(rel.getObjective0Id())) {
					//分之内可见平级单位，只能看到分支内的平级单位，上级单位相同的平级单位
					acList.addAll(samelengthPathList);
				} else if (OrgConstants.Account_AccessScope_Level_2.equals(rel.getObjective0Id())) {
					//分之内可见下级单位，只看范围内子单位
					acList.addAll(getChildAccount(accountId, false));
				} else if (OrgConstants.Account_AccessScope_Level_3.equals(rel.getObjective0Id())) {
					//分之内可见上级单位 && 分支内可见平级单位
					acList.addAll(allParents);
					acList.addAll(samelengthPathList);
				} else if (OrgConstants.Account_AccessScope_Level_4.equals(rel.getObjective0Id())) {
					//分支内可见上级单位 && 分支内可见下级单位
					acList.addAll(allParents);
					acList.addAll(getChildAccount(accountId, false));
				} else if (OrgConstants.Account_AccessScope_Level_5.equals(rel.getObjective0Id())) {
					//分支内可见平级单位 && 分支内可见下级单位
					acList.addAll(samelengthPathList);
					acList.addAll(getChildAccount(accountId, false));
				} else if (OrgConstants.Account_AccessScope_Level_6.equals(rel.getObjective0Id())) {
					//分支内可见上级 && 分支内可见平级 && 分支内可见下级
					acList.addAll(allParents);
					acList.addAll(samelengthPathList);
					acList.addAll(getChildAccount(accountId, false));
				} else {
					//平级设置三者都不勾选，只能看见自己
					acList.add(account);
					break;
				}
			} else if (rel.getObjective0Id() == null || Strings.isBlank(rel.getObjective5Id())) {
				//如果Objective0为空，则访问范围是所有单位
				acList.addAll(allAccouts);
				break;
			} else if (Long.valueOf(0).equals(permissionType)) {//统一设置
				if (Account_AccessScope_Type.NOT_ACCESS.name().equals(rel.getObjective5Id())) {
					break;
				} else {
					acList.addAll(allAccouts);
					break;
				}
			} else if (Long.valueOf(2).equals(permissionType)) {//自由设置
				if (Account_AccessScope_Type.NOT_ACCESS.name().equals(rel.getObjective5Id())) {
					isFreeSet = true;
					try {
						resultFreeSet.remove(getAccountById(rel.getObjective0Id()));
					} catch (Exception e) {
						logger.warn("获取选人界面单位可见范围自由设置单位列表异常", e);
						//ignore
						continue;
					}
				} else if (Account_AccessScope_Type.CAN_ACCESS.name().equals(rel.getObjective5Id())) {
					V3xOrgAccount a = getAccountById(rel.getObjective0Id());
					if (null != a && a.isValid()) {
						acList.add(a);
					}
					continue;
				} else {
					continue;
				}
			} else {
				continue;
			}
		}

		//自由设置的最终结果
		if (isFreeSet) {
			acList.addAll(resultFreeSet);
		}
		//用path进行一次排序
		Collections.sort(acList, CompareUnitPath.getInstance());
	}

	@Override
	public List<V3xOrgAccount> accessableAccountsByUnitId(Long unitId) throws BusinessException {
		unitId = dealAccountId2GroupId(unitId);
		List<V3xOrgAccount> acList = new UniqueList<V3xOrgAccount>();
		if (null == this.getAccountById(unitId)) {
			return acList;
		}
		accessableUnit(unitId, acList);
		return acList;
	}

	/**
	 * 将传进来的如果是null或者1，自动转换成集团ID
	 * @param unitId
	 * @return
	 */
	private Long dealAccountId2GroupId(Long unitId) {
		if (null == unitId || V3xOrgEntity.VIRTUAL_ACCOUNT_ID.equals(unitId)) {
			unitId = OrgConstants.GROUPID;
		}
		return unitId;
	}


	@Override
	public List<V3xOrgDutyLevel> getAllDutyLevels(Long accountID, String type, String value) throws BusinessException {
		return null;
	}

	@SuppressWarnings("unchecked")
	@Override
	public <T extends V3xOrgEntity> List<T> getEntitiesByName(Class<T> clazz, String name, Long accountId)
	throws BusinessException {
		return (List<T>) getEntityList(clazz.getSimpleName(), "name", name, accountId);
	}

	public <T extends V3xOrgEntity> List<T> getEntitiesByNameWithCache(Class<T> clazz, String name, Long accountId) throws BusinessException {
		return getEntitiesByNameWithCache(clazz, name, accountId, OrgConstants.ExternalType.Inner.ordinal());
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public <T extends V3xOrgEntity> List<T> getEntitiesByNameWithCache(Class<T> clazz, String name, Long accountId, Integer externalType)
	throws BusinessException {
		if(Strings.isBlank(name)){
			return Collections.EMPTY_LIST;
		}

		String key = clazz.getSimpleName() + name + accountId;

		List enList = (List)AppContext.getThreadContext(key);
		if(enList != null) {
			return enList;
		}
		else{
			enList = new ArrayList();
			AppContext.putThreadContext(key, enList);
		}

		List<? extends V3xOrgEntity> allEntList = orgCache.getAllV3xOrgEntityNoClone(clazz, accountId, externalType);
		for (V3xOrgEntity e : allEntList) {
			if(Strings.equals(e.getName(), name)){
				enList.add(OrgHelper.cloneEntity(e));
			}
		}

		return enList;
	}

	@Override
	public List<V3xOrgDepartment> getChildDepartments(Long parentDepId, boolean firtLayer) throws BusinessException {
		return getChildDepartments(parentDepId, firtLayer, true);
	}

	@Override
	public List<V3xOrgDepartment> getChildDepartments(Long parentDepId, boolean firtLayer, boolean isInteranl)
	throws BusinessException {
		List<V3xOrgDepartment> resultList = new UniqueList<V3xOrgDepartment>();

		V3xOrgUnit parentDep = this.orgCache.getV3xOrgEntityNoClone(V3xOrgUnit.class, parentDepId);
		if(parentDep == null || !parentDep.isValid()){
			return resultList;
		}

		if(parentDep.getExternalType() != OrgConstants.ExternalType.Inner.ordinal()){
			return joinOrgManagerDirect.getChildDepartments(parentDepId, firtLayer, OrgConstants.ExternalType.Interconnect1.ordinal());
		}

		/*        List<V3xOrgDepartment> depsList = getAllDepartments(parentDep.getOrgAccountId());

        for (V3xOrgDepartment d : depsList) {
            if(Strings.equals(d.getIsInternal(), isInteranl)
                && (
                    (firtLayer && d.getParentPath().equals(parentDep.getPath())) //不包含子部门
                    ||
                    (!firtLayer && d.getParentPath().startsWith(parentDep.getPath()))
                )){
                resultList.add(d);
            }
        }*/
        
        String subDeptType=null;
        if(firtLayer && isInteranl){
        	subDeptType = OrgCache.SUBDEPT_INNER_FIRST;
        }else if(!firtLayer && isInteranl){
        	subDeptType = OrgCache.SUBDEPT_INNER_ALL;
        }else if(!isInteranl){
        	subDeptType = OrgCache.SUBDEPT_OUTER_ALL;
        }
        List<Long> deptIdsList = this.orgCache.getSubDeptList(parentDepId,subDeptType);
        List<V3xOrgDepartment> deptList = new UniqueList<V3xOrgDepartment>();
        for(Long deptId : deptIdsList){
        	V3xOrgDepartment dept = orgCache.getV3xOrgEntity(V3xOrgDepartment.class, deptId);
            if(dept != null && dept.isValid()){
                deptList.add(dept);
            }else{
                logger.info(parentDepId+ "的子部门："+ deptId + "不存在或者不可用");
            }
        }
        Collections.sort(deptList, CompareSortEntity.getInstance());
        return deptList;
    }

    @Override
    public V3xOrgDepartment getParentDepartment(Long depId) throws BusinessException {
        V3xOrgDepartment dept = getDepartmentById(depId);
        if (dept == null) {
            return null;
        }

        return this.getDepartmentById(dept.getSuperior());
    }

	@Override
	public List<V3xOrgDepartment> getAllParentDepartments(Long depId) throws BusinessException {
		return getAllParentDepartments0(depId, true);
	}

	private List<V3xOrgDepartment> getAllParentDepartments0(Long depId, boolean isNeedSort) throws BusinessException {
		List<V3xOrgDepartment> fDeps = new ArrayList<V3xOrgDepartment>();
		V3xOrgDepartment dept = this.getDepartmentById(depId);
		if (dept == null) {
			//throw new BusinessException("子部门Id错误。");
			logger.warn("orgCache中没有该部门id:"+ depId);
			return fDeps;
		}

		//如果这个部门是V5外部部门不向上找上级部门
		if (dept.getExternalType() == OrgConstants.ExternalType.Inner.ordinal() && !dept.getIsInternal()) {
			return fDeps;
		}

		for(;;){
			Long pId = dept.getSuperior();
			if(pId == null){
				break;
			}
			dept = this.getDepartmentById(pId);
			if(dept == null || !dept.isValid() || dept.getType() == OrgConstants.UnitType.Account){
				break;
			}
			fDeps.add(dept);
		}

		if(isNeedSort){
			Collections.sort(fDeps, CompareUnitPath.getInstance());
		}

		return fDeps;
	}

	public V3xOrgDepartment getDepartmentByPath(String path) throws BusinessException {
		if (Strings.isBlank(path)) {
			return null;
		}

		V3xOrgUnit unit = this.orgCache.getV3xOrgUnitByPath(path);
		if(unit == null){
			return null;
		}

		if(unit.getEntityType().equals(OrgConstants.ORGENT_TYPE.Department.name())){
			return (V3xOrgDepartment)unit;
		}

		return null;
	}

	@Override
	public List<V3xOrgTeam> getTeamsByMember(Long memberId, Long accountId) throws BusinessException {
		List<V3xOrgTeam> result = new UniqueList<V3xOrgTeam>();

		boolean isAccountInGroupTree = this.isAccountInGroupTree(accountId);

		V3xOrgMember member = this.getMemberById(memberId);

		//系统管理员
		if(member.getIsAdmin() && this.isSystemAdminById(memberId) || this.isGroupAdminById(memberId) || this.isAuditAdminById(memberId)) {
		    List<V3xOrgTeam> allTeams = orgCache.getAllV3xOrgEntityNoClone(V3xOrgTeam.class, null);
		    for (V3xOrgTeam team : allTeams) {
		        if(team.getType() == OrgConstants.TEAM_TYPE.SYSTEM.ordinal() && team.isValid()
		                && (Strings.equals(team.getOwnerId(), accountId) || Strings.equals(team.getOwnerId(), OrgConstants.GROUPID))){
		        	V3xOrgTeam cloneTeam = OrgHelper.cloneEntity(team);
		        	result.add(cloneTeam);
		        }
		    }
		}
		//单位管理员
		if(member.getIsAdmin() && this.isAdministratorById(memberId, accountId)) {
		    List<V3xOrgTeam> allTeams = orgCache.getAllV3xOrgEntityNoClone(V3xOrgTeam.class, accountId);
		    for (V3xOrgTeam team : allTeams) {
		        if(team.getType() == OrgConstants.TEAM_TYPE.SYSTEM.ordinal() && Strings.equals(team.getOrgAccountId(), accountId) && team.isValid()){
		        	V3xOrgTeam cloneTeam = OrgHelper.cloneEntity(team);
		        	result.add(cloneTeam);
		        }
		    }
		}
		//普通用户
		else if(!member.getIsAdmin()){
		    //取我建的个人组
		    List<V3xOrgTeam> allTeams = orgCache.getAllV3xOrgEntityNoClone(V3xOrgTeam.class, accountId);
    		for (V3xOrgTeam team : allTeams) {
    			if(team == null || !team.isValid()){
    			    continue;
    			}

    			Long ownerId = team.getOwnerId();
    			if(team.getType() == OrgConstants.TEAM_TYPE.PERSONAL.ordinal() && Strings.equals(memberId, ownerId)){
    				V3xOrgTeam cloneTeam = OrgHelper.cloneEntity(team);
    				result.add(cloneTeam);
    			}
    		}

    		//取成员包含我的系统组
    		List<Long> accountIds = Strings.newArrayList(accountId);
    		if(isAccountInGroupTree){
    		    accountIds.add(OrgConstants.GROUPID);
    		}
    		List<Long> teamMembers = this.getUserDomainIDs(memberId, accountId, 
                    ORGENT_TYPE.Member.name(),
                    ORGENT_TYPE.Department.name(),
                    ORGENT_TYPE.Post.name(),
                    ORGENT_TYPE.Level.name(),
                    ORGENT_TYPE.Team.name());
    		List<V3xOrgRelationship>  memberPost = orgCache.getMemberPostRelastionships(memberId, accountId);
    		Set<Long> deptIds = new HashSet<Long>();
    		for(V3xOrgRelationship post : memberPost){
    			deptIds.add(post.getObjective0Id());
    		}
    		for(Long id : teamMembers){
    		    List<V3xOrgRelationship> relList = orgCache.getMemberTeamRelastionships(id, accountIds);
	    		for (V3xOrgRelationship r : relList) {
	    			if(!deptIds.contains(r.getObjective0Id()) && OrgConstants.ORGENT_TYPE.Department.name().equals(r.getObjective6Id()) && "1".equals(r.getObjective7Id())){
	    				continue;
	    			}
	    		    V3xOrgTeam t = this.orgCache.getV3xOrgEntity(V3xOrgTeam.class, r.getSourceId());
	    		    if(t != null && t.isValid() && (t.getType() == TEAM_TYPE.SYSTEM.ordinal() || t.getType() == TEAM_TYPE.PROJECT.ordinal())){
	    		        result.add(t);
	    		    }
	            }
    		}
		}

		//公开范围包括我的系统组
        List<Long> teamMembers = this.getUserDomainIDs(memberId, accountId,
                    ORGENT_TYPE.Member.name(),
                    ORGENT_TYPE.Account.name(),
                    ORGENT_TYPE.Department.name(),
                    ORGENT_TYPE.Post.name(),
                    ORGENT_TYPE.Level.name(),
                    ORGENT_TYPE.Team.name());

        if(isAccountInGroupTree){
            teamMembers.add(OrgConstants.GROUPID);
        }

        EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
        enummap.put(OrgConstants.RelationshipObjectiveName.objective0Id, teamMembers);

        List<V3xOrgRelationship> relList = orgCache.getV3xOrgRelationship(RelationshipType.Team_PubScope, (Long)null, (Long)null, enummap);
        for (V3xOrgRelationship r : relList) {
            V3xOrgTeam t = this.orgCache.getV3xOrgEntity(V3xOrgTeam.class, r.getSourceId());
            if(t != null && t.isValid() && (t.getType() == TEAM_TYPE.SYSTEM.ordinal() || t.getType() == TEAM_TYPE.PROJECT.ordinal())){
                result.add(t);
            }
        }

        initTeams(result);

        Collections.sort(result,CompareSortEntity.getInstance());

        return result;
    }

    @Override
    public List<V3xOrgTeam> getTeamsExceptPersonByMember(Long memberId) throws BusinessException {
        List<V3xOrgTeam> allTeams = new UniqueList<V3xOrgTeam>();
        List<V3xOrgAccount> allAccounts = accessableAccounts(memberId);

        for (V3xOrgAccount v3xOrgAccount : allAccounts) {
            List<V3xOrgTeam> teams = getTeamsByMember(memberId, v3xOrgAccount.getId());
            for (V3xOrgTeam team : teams) {
                if (TEAM_TYPE.PERSONAL.ordinal() != team.getType() && (team.contains(memberId))) {
                    allTeams.add(team);
                }
            }
        }

        Collections.sort(allTeams, CompareTypeEntity.getInstance());

        return allTeams;
    }

    @Override
    public List<V3xOrgTeam> getTeamByType(int type, Long accId) throws BusinessException {
        List<V3xOrgTeam> list = orgCache.getAllV3xOrgEntity(V3xOrgTeam.class, accId);
        List<V3xOrgTeam> teams = new ArrayList<V3xOrgTeam>();

        for (Iterator<V3xOrgTeam> it = list.iterator(); it.hasNext();) {
            V3xOrgTeam team = (V3xOrgTeam) it.next();
            if (team.getType() == type && team.isValid()) {
                teams.add(team);
            }
        }

        return teams;
    }

    @Override
    public List<V3xOrgEntity> getTeamMember(Long teamId, OrgConstants.TeamMemberType orgRelType) throws BusinessException {
        List<V3xOrgEntity> members = new UniqueList<V3xOrgEntity>();
        V3xOrgTeam team = orgCache.getV3xOrgEntity(V3xOrgTeam.class, teamId);
        if (team == null || !team.isValid()){
            return members;
        }

        initTeam(team);

        List<OrgTypeIdBO> list = team.getMemberList(orgRelType.ordinal());

        for (OrgTypeIdBO memberId : list) {
        	String type = memberId.getType();
        	if(OrgConstants.ORGENT_TYPE.Department_Post.name().equals(type)){
        		List<V3xOrgMember> memberList = this.getMembersByDepartmentPost(memberId.getDepartmentId(), memberId.getPostId());
        		members.addAll(memberList);
        	}else{
        		V3xOrgEntity m = orgCache.getV3xOrgEntity(OrgHelper.getV3xClass(memberId.getType()), memberId.getLId());
        		if (m != null && m.isValid()){
        			members.add(m);
        		}
        	}
        }

		return members;
	}

	@Override
	public boolean isEmptyTeamScope(V3xOrgTeam team) throws BusinessException {
		List<V3xOrgRelationship> rellist = orgCache.getV3xOrgRelationship(OrgConstants.RelationshipType.Team_PubScope,
				team.getId(), team.getOrgAccountId(), null);
		if (rellist.isEmpty()) {
			return true;	
		}
		return false;
	}

	@Override
	public List<V3xOrgEntity> getTeamMember(Long teamId) throws BusinessException {
		List<V3xOrgEntity> members = new UniqueList<V3xOrgEntity>();
		members.addAll(getTeamMember(teamId,OrgConstants.TeamMemberType.Leader));
		members.addAll(getTeamMember(teamId,OrgConstants.TeamMemberType.Member));
		return members;
	}

	@Override
	public List<V3xOrgMember> getMembersByTeam(Long teamId) throws BusinessException {
		return this.getMembersByTeam(teamId, null);
	}
	@Override
	public List<V3xOrgMember> getMembersByTeam(Long teamId,Set<Long> teamIds) throws BusinessException {
		if(teamIds == null){
			teamIds = new HashSet<Long>();
		}
		List<V3xOrgMember> members = new UniqueList<V3xOrgMember>();
		V3xOrgTeam team = orgCache.getV3xOrgEntity(V3xOrgTeam.class, teamId);
		if (team == null || !team.isValid()){
			return members;
		}

		initTeam(team);

		List<OrgTypeIdBO> list = team.getAllMembers();
		for (OrgTypeIdBO memberId : list) {
			String type = memberId.getType();
			if(OrgConstants.ORGENT_TYPE.Department_Post.name().equals(type)){
				List<V3xOrgMember> memberList = this.getMembersByDepartmentPost(memberId.getDepartmentId(), memberId.getPostId());
				members.addAll(memberList);
			}else{
				V3xOrgEntity m = orgCache.getV3xOrgEntity(OrgHelper.getV3xClass(memberId.getType()), memberId.getLId());
				if (m != null && m.isValid()) {
					if (m instanceof V3xOrgMember) {
						members.add((V3xOrgMember) m);
					} else if (m instanceof V3xOrgDepartment) {
						members.addAll(this.getMembersByDepartment(m.getId(), "1".equals(memberId.getInclude())));
					} else if (m instanceof V3xOrgPost) {
						members.addAll(this.getMembersByPost(m.getId()));
					} else if (m instanceof V3xOrgLevel) {
						members.addAll(this.getMembersByLevel(m.getId()));
					} else if (m instanceof V3xOrgTeam && !teamIds.contains(m.getId())) {
						teamIds.add(m.getId());
						members.addAll(this.getMembersByTeam(m.getId(), teamIds));
					}
				}
			}
		}
		return members;
	}
	//start mwl 通讯录中领导的信息需要有权限才可以查看  【重写getMembersByTeam()】
	public List<V3xOrgMember> getMembersByTeam(Set<Long> teamIds,Long teamId) throws BusinessException {
		if(teamIds == null){
			teamIds = new HashSet<Long>();
		}
		List<V3xOrgMember> members = new UniqueList<V3xOrgMember>();
		V3xOrgTeam team = orgCache.getV3xOrgEntity(V3xOrgTeam.class, teamId);
		if (team == null || !team.isValid()){
			return members;
		}
		initTeam(team);
		List<OrgTypeIdBO> list = team.getAllMembers();
		for (OrgTypeIdBO memberId : list) {
			String type = memberId.getType();
			if(OrgConstants.ORGENT_TYPE.Department_Post.name().equals(type)){
				List<V3xOrgMember> memberList = this.getMembersByDepartmentPost(memberId.getDepartmentId(), memberId.getPostId());
				members.addAll(memberList);
			}else{
				V3xOrgEntity m = orgCache.getV3xOrgEntity(OrgHelper.getV3xClass(memberId.getType()), memberId.getLId());
				if (m != null && m.isValid()) {
					if (m instanceof V3xOrgMember) {
					//start mwl 进行强转 V3xOrgMember
					V3xOrgMember a = (V3xOrgMember) m;
					//end mwl 进行强转 V3xOrgMember
					
					 //start mwl 通讯录中领导的信息需要有权限才可以查�?  
					 Long memberId1 = a.getId();
					 Long orgAccountId = a.getOrgAccountId(); 
					 //敏感信息隐藏角色
					 String tongxunlu_minganjuese = (String) PropertiesUtils.getInstance().get("tongxunlu_minganjuese");
					 boolean flag =this.hasSpecificRole(memberId1, orgAccountId, tongxunlu_minganjuese);
					 a.setIsLeader(flag);
					//end mwl 通讯录中领导的信息需要有权限才可以查�?  
				
						members.add(a);
					} else if (m instanceof V3xOrgDepartment) {
						members.addAll(this.getMembersByDepartment(m.getId(), "1".equals(memberId.getInclude())));
					} else if (m instanceof V3xOrgPost) {
						members.addAll(this.getMembersByPost(m.getId()));
					} else if (m instanceof V3xOrgLevel) {
						members.addAll(this.getMembersByLevel(m.getId()));
					} else if (m instanceof V3xOrgTeam && !teamIds.contains(m.getId())) {
						teamIds.add(m.getId());
						members.addAll(this.getMembersByTeam(m.getId(), teamIds));
					}
				}
			}
		}
		return members;
	}
	//end mwl 通讯录中领导的信息需要有权限才可以查看  【重写getMembersByTeam()】
	
	@Override
	public List<V3xOrgMember> getMembersByTeam(Long teamId,Set<Long> teamIds, OrgConstants.TeamMemberType[] types) throws BusinessException {
		if(teamIds == null){
			teamIds = new HashSet<Long>();
		}
		List<V3xOrgMember> members = new UniqueList<V3xOrgMember>();
		V3xOrgTeam team = orgCache.getV3xOrgEntity(V3xOrgTeam.class, teamId);
		if (team == null || !team.isValid()){
			return members;
		}

		initTeam(team);
		List<V3xOrgEntity> membertypes = new UniqueList<V3xOrgEntity>();
		if(types !=null){
			for(OrgConstants.TeamMemberType type :types){
				membertypes.addAll(getTeamMember(teamId,type));
			}
		}
		for (V3xOrgEntity entity : membertypes) {
			if (entity != null && entity.isValid()){
				if(entity instanceof V3xOrgMember){
					members.add((V3xOrgMember)entity);
				}else if(entity instanceof V3xOrgDepartment){
					members.addAll(this.getMembersByDepartment(entity.getId(), false));
				}else if(entity instanceof V3xOrgPost){
					members.addAll(this.getMembersByPost(entity.getId()));
				}else if(entity instanceof V3xOrgLevel){
					members.addAll(this.getMembersByLevel(entity.getId()));
				}else if(entity instanceof V3xOrgTeam && !teamIds.contains(entity.getId())){
					teamIds.add(entity.getId());
					members.addAll(this.getMembersByTeam(entity.getId(), teamIds, types));
				}
			}
		}
		return members;
	}

	@Override
	public List<V3xOrgMember> getTeamRelative(Long teamId) throws BusinessException {
		List<V3xOrgMember> members = new UniqueList<V3xOrgMember>();
		V3xOrgTeam team = orgCache.getV3xOrgEntity(V3xOrgTeam.class, teamId);
		if (team == null || !team.isValid()){
			return members;
		}

		initTeam(team);

		List<OrgTypeIdBO> list = team.getAllRelatives();
		if (Strings.isEmpty(list)){
			return members;
		}

		for (OrgTypeIdBO memberId : list) {
			String type = memberId.getType();
			if(OrgConstants.ORGENT_TYPE.Department_Post.name().equals(type)){
				List<V3xOrgMember> memberList = this.getMembersByDepartmentPost(memberId.getDepartmentId(), memberId.getPostId());
				members.addAll(memberList);
			}else{
				V3xOrgMember m = orgCache.getV3xOrgEntity(V3xOrgMember.class, memberId.getLId());
				if (m != null && m.isValid()){
					members.add(m);
				}
			}
		}

		return members;
	}
	@Override
	public String getRoleByOtherBenchmarkRole(String roleId, Long unitId) throws BusinessException {
		OrgConstants.Role_NAME systemRoleName = null;
		try{
			systemRoleName = OrgConstants.Role_NAME.valueOf(roleId);
		}
		catch(Exception e){
			//ignore
		}

		V3xOrgUnit unitById = this.getUnitById(unitId);

		if(systemRoleName != null){ //说明是系统预置角色
			return roleId;
		}else{
			if(null != unitById && null != unitById.getOrgAccountId()){
				unitId = unitById.getOrgAccountId();
			}
			//按照
			V3xOrgRole role = this.getRoleByName(roleId, unitId);
			if(null!=role){
				roleId = role.getId().toString();
			}

			//如果不是数字，直接返回null
			try {
				Long.parseLong(roleId);
			} catch (Exception e) {
				logger.info("找不到对应的角色 ："+roleId);
				return null;
			}
		}

		//获取集团基准角色ID
		Long grouproleId=-1L;
		List<V3xOrgRelationship> relList = orgCache.getV3xOrgRelationship(RelationshipType.Banchmark_Role, Long.valueOf(roleId), (Long)null, null);
		for (V3xOrgRelationship v3xOrgRelationship : relList) {
			grouproleId = v3xOrgRelationship.getObjective0Id();
		}
		//获取对应的单位映射角色ID
		String accroleId=roleId;
		EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
		enummap.put(OrgConstants.RelationshipObjectiveName.objective0Id, grouproleId);
		List<V3xOrgRelationship> relListacc = orgCache.getV3xOrgRelationship(RelationshipType.Banchmark_Role, (Long)null, (Long)null, enummap);
		for (V3xOrgRelationship v3xOrgRelationship : relListacc) {
			//OA-46573 流程调用模板报错防护屏蔽
			if(null == this.getRoleById(v3xOrgRelationship.getSourceId())) continue;
			if(null == unitById || null == unitById.getOrgAccountId()) continue;
			if(unitById.getOrgAccountId().equals(this.getRoleById(v3xOrgRelationship.getSourceId()).getOrgAccountId())){
				accroleId = String.valueOf(v3xOrgRelationship.getSourceId());
			}
		}
		return accroleId;
	}

	@Override
	public List<V3xOrgTeam> getTeamsByOwner(Long ownerId, Long accountID) throws BusinessException {
		List<V3xOrgTeam> list = orgCache.getAllV3xOrgEntity(V3xOrgTeam.class, accountID);
		List<V3xOrgTeam> teamList = new ArrayList<V3xOrgTeam>();
		for (Iterator<V3xOrgTeam> it = list.iterator(); it.hasNext();) {
			V3xOrgTeam team = (V3xOrgTeam) it.next();
			if (team.getType() == OrgConstants.TEAM_TYPE.PERSONAL.ordinal() && team.getOwnerId().equals(ownerId)) {
				teamList.add((V3xOrgTeam) team);
			}
		}

		Collections.sort(teamList, CompareTimeEntity.getInstance());
		return teamList;
	}

	@Override
	public List<V3xOrgMember> getMembersByRole(Long unitId, Long roleId) throws BusinessException {
		V3xOrgRole role = this.getRoleById(roleId);
		if (role == null) {
			return Collections.emptyList();
		}

		if(role.getExternalType() != OrgConstants.ExternalType.Inner.ordinal()){
			return joinOrgManagerDirect.getMembersByRoleNameOrId(unitId, roleId.toString());
		}

		List<V3xOrgRelationship> relList = orgCache.getRoleEntityRelastionships(roleId, unitId, null);
		if(relList.isEmpty()) {
			return new ArrayList<V3xOrgMember>(); 
		}

		Collections.sort(relList, CompareSortRelationship.getInstance());

		List<V3xOrgMember> cntList = new UniqueList<V3xOrgMember>();
		//增加此处代码为直接获取某单位的单位管理员人员
		if(OrgConstants.Role_NAME.AccountAdministrator.name().equals(role.getName())) {
			for (V3xOrgRelationship rel : relList) {
				V3xOrgMember mem = orgCache.getV3xOrgEntityNoClone(V3xOrgMember.class, rel.getSourceId());
				if(mem == null){
					BasePO l = orgDao.getEntity(OrgHelper.boClassTopoClass(V3xOrgMember.class), rel.getSourceId());
					mem = (V3xOrgMember) OrgHelper.poTobo(l);
				}
				if (mem != null) {
					//角色下的人员经常会被修改，直接克隆
					cntList.add(OrgHelper.cloneEntity(mem));
				}
			}
		}
		else{
			for (V3xOrgRelationship rel : relList) {
				List<V3xOrgMember> members = this.getMembersByType(rel.getObjective5Id(), String.valueOf(rel.getSourceId()));
				for (V3xOrgMember member : members) {
					if(member != null && member.isValid()){
						cntList.add(member);
					}
				}
			}
		}

		return cntList;
	}
	@Override
	public List<V3xOrgEntity> getEntitysByRole(Long unitId, Long roleId) throws BusinessException {
		V3xOrgRole role = orgCache.getV3xOrgEntity(V3xOrgRole.class, roleId);
		if (role == null){
			return Collections.emptyList();
		}

		List<V3xOrgRelationship> relList = orgCache.getRoleEntityRelastionships(roleId, unitId, null);
		List<V3xOrgEntity> cntList = new UniqueList<V3xOrgEntity>();
		//        //增加此处代码为直接获取某单位的单位管理员人员
		//        if(OrgConstants.Role_SYSTEM_NAME.AccountAdministrator.name().equals(role.getName())) {
		//        	if(!relList.isEmpty()) cntList.add(getMemberById(relList.get(0).getSourceId()));
		//        }
		for (V3xOrgRelationship rel : relList) {
			V3xOrgEntity entity = this.getEntity(rel.getObjective5Id(), rel.getSourceId());
			if(entity!=null&&entity.isValid()){
				cntList.add(entity);
			}
		}
		return cntList;
	}
	@Override
	public List<V3xOrgEntity> getEntitysByRoleAllowRepeat(Long unitId, Long roleId) throws BusinessException {
		V3xOrgRole role = orgCache.getV3xOrgEntity(V3xOrgRole.class, roleId);
		if(role == null){//fix:OA-70496集团管理员下有一个集团角色（后面两个都是复制的），没有人使用，删除的时候也提示被使用 不能删除
			role = this.getRoleById(roleId);
		}
		if (role == null)
			return Collections.emptyList();

		List<V3xOrgRelationship> relList = orgCache.getRoleEntityRelastionships(roleId, unitId, null);

		List<V3xOrgEntity> cntList = new UniqueList<V3xOrgEntity>();
		//        //增加此处代码为直接获取某单位的单位管理员人员
		//        if(OrgConstants.Role_SYSTEM_NAME.AccountAdministrator.name().equals(role.getName())) {
		//        	if(!relList.isEmpty()) cntList.add(getMemberById(relList.get(0).getSourceId()));
		//        }

		for (V3xOrgRelationship rel : relList) {
			V3xOrgEntity entity = this.getEntity(rel.getObjective5Id(), rel.getSourceId());
			if (entity != null) {
				//暂时把角色管理的部门或单位id写在Description中
				entity.setDescription(String.valueOf(rel.getObjective0Id()));
				cntList.add(entity);
			}
		}

		return cntList;
	}
	@Override
	public List<V3xOrgEntity> getEntitysByRole(Long unitId, String rolename) throws BusinessException {
		Long roleId = getRoleByName(rolename, AppContext.currentAccountId()).getId();
		return getEntitysByRole(unitId,roleId);
	}
	@Override
	public String getEntitysStrByRole(Long unitId, String rolename) throws BusinessException{
		List<V3xOrgEntity> list = getEntitysByRole(unitId,rolename);

		return OrgHelper.getSelectPeopleStrSimple(list);
	}


	public List<V3xOrgMember> getMembersByRole(Long unitId, String roleName) throws BusinessException {
		//V3xOrgUnit unit = orgCache.getV3xOrgEntity(V3xOrgUnit.class, unitId);
		//V3xOrgUnit unit = getEntityById(V3xOrgUnit.class, unitId);
		//V3xOrgUnit unit = getAccountById(unitId);
		//这里修改为从数据库插，而不从缓存中取为了停用的单位的单位管理员，人员无法这里通过unit获取到某单位实体
		Long accountId = null;
		if(unitId != null){
			V3xOrgUnit unit = (V3xOrgUnit)orgCache.getV3xOrgEntity(V3xOrgUnit.class, unitId);
			if(unit != null){
				accountId = unit.getOrgAccountId();
			}
		}

		V3xOrgRole role = null;
		if(OrgConstants.Role_NAME.AccountAdministrator.name().equals(roleName)
				|| OrgConstants.Role_NAME.AuditAdmin.name().equals(roleName)
				|| OrgConstants.Role_NAME.GroupAdmin.name().equals(roleName)
				|| OrgConstants.Role_NAME.SystemAdmin.name().equals(roleName)) {
			role = getRoleByName(roleName, OrgConstants.GROUPID);
		} else {
			role = getRoleByName(roleName, accountId);
		}

		if (role == null){
			return new ArrayList<V3xOrgMember>(0);
		}

		return this.getMembersByRole(unitId, role.getId());
	}

	@Override
	public Boolean hasSpecificRole(Long memberId ,Long unitId, String roleName) throws BusinessException{
		List<V3xOrgMember> members = getMembersByRole(unitId, roleName);
		for(V3xOrgMember m : members){
			if(m.getId().equals(memberId)){
				return true;
			}
		}
		return false;
	} 

	@Override
	public List<Long> getDomainByRole(Long roleId, Long userId) throws BusinessException {
		List<Long> entities = new UniqueList<Long>();
		List<V3xOrgRelationship> rl = orgCache.getEntityRoleRelastionships(Strings.newArrayList(userId), null, null);
		for (V3xOrgRelationship rel : rl) {
			if(Strings.equals(rel.getObjective1Id(),roleId)){
				entities.add(rel.getObjective0Id());
			}
		}

		return entities;
	}

	@Override
	public List<V3xOrgMember> getMembersByMemberRoleOfUp(long memberId, String roleNameOrId, Long accountId) throws BusinessException{
		List<V3xOrgMember> members = new UniqueList<V3xOrgMember>();

		List<Long> workDeptIds = this.getWorkDepartments(memberId, accountId);

		for (Long workDeptId : workDeptIds) {
			V3xOrgDepartment department = this.getDepartmentById(workDeptId);
			if (null == department || !department.isValid()) {
				continue;
			}
			V3xOrgRole role = this.getRoleByNameOrId(this.getRoleByOtherBenchmarkRole(roleNameOrId, accountId), department.getOrgAccountId());
			if (null == role || !role.isValid()){
				continue;
			}

			//先查询本部门
			List<V3xOrgMember> result1 = getMembersByRole(workDeptId, role.getId());
			if(result1 != null && !result1.isEmpty()) {
				members.addAll(result1);
				//return result1;
			} else {
				List<V3xOrgDepartment> allParentDept = getAllParentDepartments(department.getId());
				for (int i = allParentDept.size(); i > 0; i--) {
					V3xOrgDepartment parentDept = allParentDept.get(i - 1);

					List<V3xOrgMember> result0 = getMembersByRole(parentDept.getId(), role.getId());
					if (result0 != null && !result0.isEmpty()) {
						members.addAll(result0);
						break;
						//return result0;
					}
				}

			}

		}

		return members;
	}

	@Override
	public List<V3xOrgMember> getMembersByDepartmentRole(long departmentId, String roleNameOrId) throws BusinessException {
		V3xOrgDepartment department = orgCache.getV3xOrgEntity(V3xOrgDepartment.class, departmentId);
		if(department == null || !department.isValid()){
			return new ArrayList<V3xOrgMember>(0);
		}

		if(department.getExternalType() != OrgConstants.ExternalType.Inner.ordinal()){
			return joinOrgManagerDirect.getMembersByRoleNameOrId(departmentId, roleNameOrId);
		}

		V3xOrgRole role = getRoleByNameOrId(this.getRoleByOtherBenchmarkRole(roleNameOrId, departmentId), department.getOrgAccountId());
		if(role == null || !role.isValid()){
			return new ArrayList<V3xOrgMember>(0);
		}

		return this.getMembersByRole(departmentId, role.getId());
	}

	@Override
	public Map<String, String> getMembersByDepartmentRoleByStr(String departmentTypeAndId, String roleNameOrId) throws BusinessException {
		V3xOrgDepartment department = (V3xOrgDepartment)this.getEntity(departmentTypeAndId);
		if(department == null || !department.isValid()){
			return new HashMap<String, String>();
		}

		V3xOrgRole role = getRoleByNameOrId(roleNameOrId, department.getOrgAccountId());
		HashMap<String, String> m = new HashMap<String, String>();
		List<V3xOrgMember> membersByRole = this.getMembersByRole(department.getId(), role.getId());
		m.put("names", OrgHelper.showOrgEntities(membersByRole,"id","entityType",null));
		m.put("values", OrgHelper.parseElements(membersByRole,"id","entityType"));
		return m;
	}

	@Override
	public List<V3xOrgMember> getMembersByDepartmentRoleOfUp(long departmentId, String roleNameOrId) throws BusinessException{
		V3xOrgDepartment department = orgCache.getV3xOrgEntity(V3xOrgDepartment.class, departmentId);
		if(department == null || !department.isValid()){
			return new ArrayList<V3xOrgMember>(0);
		}

		V3xOrgRole role = getRoleByNameOrId(this.getRoleByOtherBenchmarkRole(roleNameOrId, departmentId), department.getOrgAccountId());
		if(role == null || !role.isValid()){
			return new ArrayList<V3xOrgMember>(0);
		}

		{
			List<V3xOrgMember> result1 = this.getMembersByRole(departmentId, role.getId());
			if (result1 != null && !result1.isEmpty()) {
				return result1;
			}
		}

		List<V3xOrgDepartment> allParentDept = this.getAllParentDepartments(departmentId);
		for (int i = allParentDept.size(); i > 0; i--) {
			V3xOrgDepartment parentDept = allParentDept.get(i - 1);

			List<V3xOrgMember> result0 = this.getMembersByRole(parentDept.getId(), role.getId());
			if (result0 != null && !result0.isEmpty()) {
				return result0;
			}
		}

		return new ArrayList<V3xOrgMember>(0);
	}

	@Override
	public List<V3xOrgMember> getMembersByAccountRoleOfUp(long accountId, String roleNameOrId) throws BusinessException{
		V3xOrgAccount account = orgCache.getV3xOrgEntity(V3xOrgAccount.class, accountId);
		if(account == null || !account.isValid()){
			return new ArrayList<V3xOrgMember>(0);
		}

		V3xOrgRole role = getRoleByNameOrId(this.getRoleByOtherBenchmarkRole(roleNameOrId, accountId), accountId);
		if(role == null || !role.isValid()){
			return new ArrayList<V3xOrgMember>(0);
		}

		{
			List<V3xOrgMember> result1 = this.getMembersByRole(accountId, role.getId());
			if (result1 != null && !result1.isEmpty()) {
				return result1;
			}
		}

		List<V3xOrgAccount> allParentAccount =new ArrayList<V3xOrgAccount>();
		this.getAllParentAccount(allParentAccount, account);
		for (int i = 0; i < allParentAccount.size(); i++) {
			V3xOrgAccount parentAccount = allParentAccount.get(i);

			V3xOrgRole pRole = getRoleByNameOrId(this.getRoleByOtherBenchmarkRole(roleNameOrId, parentAccount.getOrgAccountId()), parentAccount.getOrgAccountId());
			if(pRole == null || !pRole.isValid()){
				continue;
			}
			List<V3xOrgMember> pResult = this.getMembersByRole(parentAccount.getId(), pRole.getId());
			if (pResult != null && !pResult.isEmpty()) {
				return pResult;
			}
		}

		return new ArrayList<V3xOrgMember>(0);
	}

	@Override
	public List<V3xOrgMember> getMembersByDepartmentPost(long departmentId, long postId0) throws BusinessException {
		UniqueList<V3xOrgMember> memberList = new UniqueList<V3xOrgMember>();

		V3xOrgDepartment department = this.getDepartmentById(departmentId);
		if(department == null || !department.isValid()){
			return memberList;
		}

		List<Long> posts = this.getAccountPostByBachmarkPost(postId0, department.getOrgAccountId());
		if(posts.isEmpty()){
			return memberList;
		}

		EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
		enummap.put(OrgConstants.RelationshipObjectiveName.objective0Id, departmentId);
		enummap.put(OrgConstants.RelationshipObjectiveName.objective1Id, posts);

		List<V3xOrgRelationship> rels = orgCache.getV3xOrgRelationship(RelationshipType.Member_Post, (Long)null, (Long)null, enummap);
		Collections.sort(rels, CompareSortRelationship.getInstance());

		for (V3xOrgRelationship rel : rels) {
			if(!isValidMemberPost(rel)){
				continue;
			}
			V3xOrgMember mem = orgCache.getV3xOrgEntity(V3xOrgMember.class, rel.getSourceId());
			if (mem != null && mem.isValid()) {
				memberList.add(OrgHelper.cloneEntityImmutableDecorator(mem));
			}
		}

		return memberList;
	}
	@Override
	public boolean isGroup() throws BusinessException {
		return getAccountById(AppContext.currentAccountId()).isGroup();
	}

	@Override
	public List<V3xOrgMember> getMembersByDepartmentPostOfUp(long departmentId, long postId) throws BusinessException {
		List<V3xOrgMember> members = getMembersByDepartmentPostOfUp0(departmentId, postId);

		//如果根单位没有，则全单位匹配
		if (members.isEmpty()) {
			V3xOrgDepartment dep = getDepartmentById(departmentId);
			if (dep == null || !dep.isValid()) {
				return Collections.emptyList();
			}

			members = this.getMembersByPost(postId, dep.getOrgAccountId());
		}

		return members;
	}

	private List<V3xOrgMember> getMembersByDepartmentPostOfUp0(long departmentId, long postId) throws BusinessException {
		V3xOrgDepartment dep = getDepartmentById(departmentId);
		if (dep == null || !dep.isValid()) {
			return Collections.emptyList();
		}

		V3xOrgPost post = getPostById(postId);
		if (post == null || !post.isValid())
			return Collections.emptyList();

		Map<String, List<V3xOrgMember>> dep2Members = new HashMap<String, List<V3xOrgMember>>();

		List<Long> postIds = getAccountPostByBachmarkPost(postId, dep.getOrgAccountId());
		if(postIds.isEmpty()){
			return Collections.emptyList();
		}

		EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
		enummap.put(OrgConstants.RelationshipObjectiveName.objective1Id, postIds);

		List<V3xOrgRelationship> ents = orgCache.getV3xOrgRelationship(RelationshipType.Member_Post, (Long)null, (Long)null, enummap);
		Collections.sort(ents, CompareSortRelationship.getInstance());

		for (V3xOrgRelationship rel : ents) {
			if(!isValidMemberPost(rel)){
				continue;
			}
			V3xOrgDepartment d = orgCache.getV3xOrgEntity(V3xOrgDepartment.class, rel.getObjective0Id());
			V3xOrgMember m = orgCache.getV3xOrgEntity(V3xOrgMember.class, rel.getSourceId());
			if (d != null && d.isValid() && m != null && m.isValid()) {
				Strings.addToMap(dep2Members, d.getPath(), m);
			}
		}

		if(dep2Members.isEmpty()){
			return Collections.emptyList();
		}

		List<V3xOrgDepartment> allParentDept = this.getAllParentDepartments(departmentId);

		List<V3xOrgDepartment> _allParentDept = new ArrayList<V3xOrgDepartment>(allParentDept);
		_allParentDept.add(dep); //先从我的部门开始

		for (int i = _allParentDept.size(); i > 0; i--) {
			String path = _allParentDept.get(i - 1).getPath();
			List<V3xOrgMember> result = new ArrayList<V3xOrgMember>();

			for (Iterator<Map.Entry<String, List<V3xOrgMember>>> iter = dep2Members.entrySet().iterator(); iter.hasNext();) {
				Map.Entry<String, List<V3xOrgMember>> entry = iter.next();
				String p = entry.getKey();
				List<V3xOrgMember> ms = entry.getValue();

				if(p.startsWith(path)){
					result.addAll(ms);
				}
			}

			if(!result.isEmpty()){
				return result;
			}
		}

		return Collections.emptyList();
	}

	@Override
	public List<V3xOrgMember> getMembersByDepartmentPostOfDown(long departmentId, long postId) throws BusinessException {
		UniqueList<V3xOrgMember> memberList = new UniqueList<V3xOrgMember>();

		V3xOrgDepartment department = this.getDepartmentById(departmentId);
		if(department == null || !department.isValid()){
			return memberList;
		}

		List<Long> posts = this.getAccountPostByBachmarkPost(postId, department.getOrgAccountId());
		if(posts.isEmpty()){
			return memberList;
		}

		List<Long> departmentIds = new ArrayList<Long>();

		List<V3xOrgDepartment> departments = this.getChildDepartments(departmentId, false);
		for (V3xOrgDepartment d : departments) {
			departmentIds.add(d.getId());
		}

		departmentIds.add(departmentId);

		EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
		enummap.put(OrgConstants.RelationshipObjectiveName.objective0Id, departmentIds);
		enummap.put(OrgConstants.RelationshipObjectiveName.objective1Id, posts);

		List<V3xOrgRelationship> rels = orgCache.getV3xOrgRelationship(RelationshipType.Member_Post, (Long)null, (Long)null, enummap);
		Collections.sort(rels, CompareSortRelationship.getInstance());

		for (V3xOrgRelationship rel : rels) {
			if(!isValidMemberPost(rel)){
				continue;
			}

			V3xOrgMember mem = orgCache.getV3xOrgEntity(V3xOrgMember.class, rel.getSourceId());
			if (mem != null && mem.isValid()) {
				memberList.add(mem);
			}
		}

		return memberList;
	}

	@Override
	public List<V3xOrgMember> getMembersByMemberPostOfUp(long memberId, long postId0, long accountId) throws BusinessException {
		return getMembersByMemberPostOf(memberId,postId0,accountId,false);
	}

	@Override
	public List<V3xOrgMember> getMembersByOrgType(OrgTypeIdBO bo) throws BusinessException {
		String type = bo.getType();
		Long LId = bo.getLId();
		String id = bo.getId();
		boolean inClude = !"0".equals(bo.getInclude());
		if(Strings.isBlank(type) || id==null){
			return new ArrayList<V3xOrgMember>();
		}

		if ("user".equals(type) || type.equals(ORGENT_TYPE.Member.name())) {
			List<V3xOrgMember> members = new ArrayList<V3xOrgMember>(1);

			V3xOrgMember member = this.getMemberById(Long.valueOf(id));
			if(member != null && member.isValid()){
				members.add(member);
			}

			return members;
		}
		else if (ORGENT_TYPE.Department.name().equals(type)) {
			List<V3xOrgMember> members = getMembersByDepartment(LId, inClude);
			return members;
		}
		else if (ORGENT_TYPE.Team.name().equals(type)) {
			List<V3xOrgMember> members = this.getMembersByTeam(LId);
			return members;
		}
		else if (ORGENT_TYPE.Post.name().equals(type)) {
			List<V3xOrgMember> members = getMembersByPost(LId);
			return members;
		}
		else if (ORGENT_TYPE.Level.name().equals(type)) {
			List<V3xOrgMember> members = getMembersByLevel(LId);
			return members;
		}
		else if (ORGENT_TYPE.Department_Post.name().equals(type)) {
			List<V3xOrgMember> members = getMembersByDepartmentPost(bo.getDepartmentId(),bo.getPostId());
			return members;
		}
		else{
			return new ArrayList<V3xOrgMember>(0);
		}
	}

	@Override
	public List<V3xOrgMember> getMembersByType(String type, String id) throws BusinessException {
		if(Strings.isBlank(type) || Strings.isBlank(id)){
			return new ArrayList<V3xOrgMember>();
		}

		if ("user".equals(type) || type.equals(ORGENT_TYPE.Member.name())) {
			List<V3xOrgMember> members = new ArrayList<V3xOrgMember>(1);

			V3xOrgMember member = this.getMemberById(Long.valueOf(id));
			if(member != null && member.isValid()){
				members.add(member);
			}

			return members;
		}
		else if (ORGENT_TYPE.Department.name().equals(type)) {
			List<V3xOrgMember> members = getMembersByDepartment(Long.parseLong(id), false);
			return members;
		}
		else if (V3xOrgEntity.ORGREL_TYPE_DEP_POST.equals(type)) {
			String[] ts = id.split(V3xOrgEntity.ROLE_ID_DELIMITER);
			if (ts.length != 2){
				throw new BusinessException("传入的ID错误" + id);
			}

			Long departmentId = Long.parseLong(ts[0]);
			Long postId = Long.parseLong(ts[1]);

			List<V3xOrgMember> members = getMembersByDepartmentPost(departmentId, postId);
			return members;
		}
		else if (V3xOrgEntity.ORGREL_TYPE_DEP_ROLE.equals(type)) {
			String[] ts = id.split(V3xOrgEntity.ROLE_ID_DELIMITER);
			if (ts.length != 2){
				throw new BusinessException("传入的ID错误" + id);
			}
			Long departmentId = Long.parseLong(ts[0]);
			return getMembersByDepartmentRole(departmentId, ts[1]);

		} else if (V3xOrgEntity.ORGREL_TYPE_ACCOUNT_ROLE.equals(type)) {
			String[] ts = id.split(V3xOrgEntity.ROLE_ID_DELIMITER);
			if (ts.length != 2){
				throw new BusinessException("传入的ID错误" + id);
			}

			V3xOrgAccount account = this.getAccountById(Long.parseLong(ts[0]));
			V3xOrgRole role= this.getRoleById(Long.parseLong(ts[1]));
			if (!account.isValid()||!role.isValid()) {
				return new ArrayList<V3xOrgMember>();
			}

			return getMembersByRole(account.getId(), Long.parseLong(ts[1]));
		}
		else if (ORGENT_TYPE.Role.name().equals(type)) {
			OrgConstants.Role_NAME systemRoleName = null;
			try{
				systemRoleName = OrgConstants.Role_NAME.valueOf(id);
			}
			catch(Exception e){
				//ignore
			}

			if(systemRoleName != null){ //说明是系统预置角色
				return this.getMembersByRole(null, systemRoleName.name());
			}
			else{
				return this.getMembersByRole(null, Long.parseLong(id));
			}
		}
		else if (ORGENT_TYPE.Account.name().equals(type)) {
			List<V3xOrgMember> members = getAllMembers(Long.parseLong(id));
			return members;
		}
		else if (ORGENT_TYPE.Team.name().equals(type)) {
			List<V3xOrgMember> members = this.getMembersByTeam(Long.parseLong(id));
			return members;
		}
		else if (ORGENT_TYPE.Post.name().equals(type)) {
			List<V3xOrgMember> members = getMembersByPost(Long.parseLong(id));
			return members;
		}
		else if (ORGENT_TYPE.Level.name().equals(type)) {
			List<V3xOrgMember> members = getMembersByLevel(Long.parseLong(id));
			return members;
		}else if(ORGENT_TYPE.JoinAccountTag.name().equals(type)){
			//外部单位下的标签（vjoin外部单位自定义属性    JoinAccountTag|9204212548207594455）
			List<V3xOrgMember> members = joinOrgManagerDirect.getMembersByEnumId(Long.parseLong(id));
			return members;
		}
		else{
			return new ArrayList<V3xOrgMember>(0);
		}
	}

	@Override
	public List<V3xOrgMember> getMembersByType(String type, Long id) throws BusinessException{
		return getMembersByType(type, String.valueOf(id));
	}

	@Override
	public Map<Long, String> getAllMemberNames(Long accountId) throws BusinessException {
		Map<Long, String> map = new HashMap<Long, String>();
		List<V3xOrgMember> memList = getAllMembers(accountId);
		for (V3xOrgMember v3xOrgMember : memList) {
			map.put(v3xOrgMember.getId(), v3xOrgMember.getName());
		}

		return map;
	}

	@Override
	public Map<Long, String> getAllAccountShortNames() throws BusinessException {
		List<V3xOrgAccount> list = orgCache.getAllV3xOrgEntityNoClone(V3xOrgAccount.class, null);
		Map<Long, String> map = new HashMap<Long, String>();
		for (V3xOrgAccount v3xOrgAccount : list) {
			map.put(v3xOrgAccount.getId(), v3xOrgAccount.getShortName());
		}
		return map;
	}

	@Override
	public List<V3xOrgMember> getExtMembersByDepartment(Long departmentId, boolean firtLayer) throws BusinessException {
		V3xOrgDepartment dep = getDepartmentById(departmentId);
		if (dep == null)
			return null;

		List<V3xOrgMember> list = orgCache.getAllV3xOrgEntity(V3xOrgMember.class, dep.getOrgAccountId());
		List<V3xOrgMember> memberList = new UniqueList<V3xOrgMember>();

		List<V3xOrgDepartment> deps = new ArrayList<V3xOrgDepartment>();
		if (!firtLayer) {
			deps = getChildDepartments(departmentId, firtLayer, false);
		}

		deps.add(dep);
		for (Iterator<V3xOrgMember> it = list.iterator(); it.hasNext();) {
			V3xOrgMember member = (V3xOrgMember) it.next();
			for (Iterator<V3xOrgDepartment> dep_it = deps.iterator(); dep_it.hasNext();) {
				Long depId = dep_it.next().getId();
				if (depId != null && depId.equals(member.getOrgDepartmentId()) && !member.getIsInternal()) // 必须是外部人员
				{
					memberList.add(member);
					break;
				}
			}

		}
		Collections.sort(memberList, CompareSortEntity.getInstance());
		return memberList;
	}

	@Override
	public List<V3xOrgMember> getAllExtMembers(Long accountId) throws BusinessException {
		List<V3xOrgMember> list = orgCache.getAllV3xOrgEntity(V3xOrgMember.class, accountId);
		List<V3xOrgMember> memberList = new ArrayList<V3xOrgMember>();
		for (Iterator<V3xOrgMember> it = list.iterator(); it.hasNext();) {
			V3xOrgMember member = (V3xOrgMember) it.next();
			if (!member.getIsInternal()) {
				memberList.add((V3xOrgMember) member);
			}
		}
		Collections.sort(memberList, CompareSortEntity.getInstance());
		return memberList;
	}

	@Override
	public List<V3xOrgMember> getMemberByName(String memberName) throws BusinessException {
		return this.getEntitiesByNameWithCache(V3xOrgMember.class, memberName, null);
	}

	@Override
	public List<V3xOrgMember> getMemberByName(String memberName, Long accountId) throws BusinessException {
		return this.getEntitiesByNameWithCache(V3xOrgMember.class, memberName, accountId);
	}

	@Override
	public Boolean isAdministrator(String loginName, V3xOrgAccount account) throws BusinessException {
		try {
			Long memberId = principalManager.getMemberIdByLoginName(loginName);
			return this.isAdministratorById(memberId, account.getId());
		}
		catch (NoSuchPrincipalException e) {
			return false;
		}
	}

	public Boolean isAdministratorById(Long memberId, V3xOrgAccount account) throws BusinessException{
		return this.isAdministratorById(memberId, account.getId());
	}

	@Override
	public Boolean isAdministratorById(Long memberId, Long accountId) throws BusinessException {       
		List<V3xOrgRelationship> rss = orgCache.getRoleEntityRelastionships(OrgConstants.ACCOUNT_ADMIN_ROLE_ID, accountId, accountId);
		for(V3xOrgRelationship rs:rss){
			if(rs.getSourceId().equals(memberId)){
				return true;
			}
		}
		return false;
	}
	@Override
	public Boolean isAdministrator() throws BusinessException {
		return isAdministratorById(AppContext.currentUserId(), AppContext.currentAccountId());
	}

	@Override
	public Boolean isSystemAdmin(String loginName) throws BusinessException {
		try {
			Long memberId = principalManager.getMemberIdByLoginName(loginName);
			return this.isSystemAdminById(memberId);
		}
		catch (NoSuchPrincipalException e) {
			return false;
		}
	}

	@Override
	public Boolean isSystemAdminById(Long memberId) throws BusinessException{
		return (Strings.equals(memberId, OrgConstants.SYSTEM_ADMIN_ID));

		//return isRole(memberId, OrgConstants.GROUPID, OrgConstants.Role_NAME.SystemAdmin.name());
	}

	@Override
	public Boolean isAuditAdmin(String loginName) throws BusinessException {
		try {
			Long memberId = principalManager.getMemberIdByLoginName(loginName);
			return this.isAuditAdminById(memberId);
		}
		catch (NoSuchPrincipalException e) {
			return false;
		}
	}

	@Override
	public Boolean isAuditAdminById(Long memberId) throws BusinessException{
		return (Strings.equals(memberId, OrgConstants.AUDIT_ADMIN_ID));

		//return isRole(memberId, OrgConstants.GROUPID, OrgConstants.Role_NAME.AuditAdmin.name());
	}

	@Override
	public Boolean isDocGroupAdmin(String loginName, V3xOrgAccount account) throws BusinessException{
		try {
			Long memberId = principalManager.getMemberIdByLoginName(loginName);
			return isRole(memberId, account.getId(), OrgConstants.Role_NAME.DocGroupAdmin.name());
		}
		catch (NoSuchPrincipalException e) {
			return false;
		}
	}

	@Override
	public Boolean isGroupAdmin(String loginName, V3xOrgAccount account) throws BusinessException {
		try {
			Long memberId = principalManager.getMemberIdByLoginName(loginName);
			return this.isGroupAdminById(memberId);
		}
		catch (NoSuchPrincipalException e) {
			return false;
		}
	}

	@Override
	public Boolean isPlatformAdmin(String loginName) throws BusinessException {
		try {
			Long memberId = principalManager.getMemberIdByLoginName(loginName);
			return this.isPlatformAdminById(memberId);
		}
		catch (NoSuchPrincipalException e) {
			return false;
		}
	}

	public Boolean isSuperAdminById(Long memberId) throws BusinessException {
		return Strings.equals(memberId, OrgConstants.SUPER_ADMIN_ID);
	}

	public Boolean isSuperAdmin(String loginName, V3xOrgAccount account) throws BusinessException {
		try {
			Long memberId = principalManager.getMemberIdByLoginName(loginName);
			return Strings.equals(memberId, OrgConstants.SUPER_ADMIN_ID);
		}
		catch (Exception e) {
			return false;
		}
	}

	@Override
	public Boolean isGroupAdminById(Long memberId) throws BusinessException{
		return (Strings.equals(memberId, OrgConstants.GROUP_ADMIN_ID));

		//return isRole(memberId, OrgConstants.GROUPID, OrgConstants.Role_NAME.GroupAdmin.name());
	}

	@Override
	public Boolean isPlatformAdminById(Long memberId) throws BusinessException {
		return (Strings.equals(memberId, OrgConstants.PLATFORM_ADMIN_ID));
	}

	@Override
	public boolean isModified(Date date, Long accountId) throws BusinessException {
		return orgCache.isModified(null, date, accountId);
	}

	@Override
	public Date getModifiedTimeStamp(Long accountId) throws BusinessException {
		return orgCache.getModifiedTimeStamp(null, accountId);
	}

	@Override
	public List<Long> getUserDomainIDs(Long memberId, String... types) throws BusinessException {
		return this.getUserDomainIDs(memberId, null, types);
	}

	@Override
	public List<Long> getAllUserDomainIDs(Long memberId) throws BusinessException {
		return this.getUserDomainIDs(memberId, OrgConstants.ORGENT_TYPE.Account.name(),
				OrgConstants.ORGENT_TYPE.Department.name(), OrgConstants.ORGENT_TYPE.Post.name(),
				OrgConstants.ORGENT_TYPE.Level.name(), OrgConstants.ORGENT_TYPE.Member.name(),
				OrgConstants.ORGENT_TYPE.Team.name(), OrgConstants.ORGENT_TYPE.Role.name());
	}

	public List<Long> getUserDomainIDs(Long memberId, Long accountId, String... types0) throws BusinessException {
		if (types0 == null || types0.length == 0) {
			return Collections.emptyList();
		}

		Date orgModifyDate = this.getModifiedTimeStamp(null);
		String key = buildKey(memberId, accountId, types0);

		List<Long> data = new UniqueList<Long>();
		if(this.checkCacheModify("getUserDomainIDs", key, String.valueOf(orgModifyDate))){
			/**
			 * 项目  信达资产   公司  kimde  修改人  陈岩   修改时间    2017-11-15   修改功能  类型转换  start
			 */
			List<Long> cacheData = (List<Long>)this.getCacheData("getUserDomainIDs", key);
			/**
			 * 项目  信达资产   公司  kimde  修改人  陈岩   修改时间    2017-11-15   修改功能  类型转换  end
			 */
			data.addAll(cacheData);
			return data;
		}

		data.addAll(getUserDomain0(memberId, accountId, types0));

		this.saveCacheData("getUserDomainIDs", key, String.valueOf(orgModifyDate), data);

		return data;
	}

	/**
	 * 
	 * @param cacheGroup
	 * @param key
	 * @param etag
	 * @return true-没有修改；false-修改了
	 */
	private boolean checkCacheModify(String cacheGroup, String key, String etag){
		Map<String, String> etagCache = getLocalCache(cacheGroup + "Date");

		String etag0 = etagCache.get(key);

		return etag0 != null && Strings.equals(etag, etag0);
	}

	private <T extends Serializable> T getCacheData(String cacheGroup, String key){
		Map<String, T> dataCache = getLocalCache(cacheGroup + "Data");
		return dataCache.get(key);
	}

	private <T extends Object> void saveCacheData(String cacheGroup, String key, String etag, T data){
		Map<String, T> dataCache = getLocalCache(cacheGroup + "Data");
		Map<String, String> etagCache = getLocalCache(cacheGroup + "Date");

		dataCache.put(key, data);
		etagCache.put(key, etag);
	}

	private List<Long> getUserDomain0(Long memberId, final Long accountId0, String... types0) throws BusinessException{
		if (types0 == null || types0.length == 0) {
			return Collections.emptyList();
		}

		V3xOrgMember member = this.getMemberById(memberId);
		if(null == member){
			return new ArrayList<Long>(0);
		}

		Long accountId = null;
		if(null != accountId0 && !accountId0.equals(V3xOrgEntity.VIRTUAL_ACCOUNT_ID)){ //用空或VIRTUAL_ACCOUNT_ID表示全集团，不区分单位，如果指定单位，则仅在这个单位内查
			accountId = accountId0;
		}

		List<Long> resultIds = new UniqueList<Long>();

		Set<String> types = newHashSet(types0);

		List<Long> accountIds = new UniqueList<Long>();

		List<Long> departmentIds = new UniqueList<Long>();

		List<Long> postIds = new UniqueList<Long>();

		List<Long> levelIds = new UniqueList<Long>();

		List<Long> roleIds = new UniqueList<Long>();

		List<Long> teamIds = new UniqueList<Long>();

		Set<Long> deptIds = new HashSet<Long>();
		{
			List<V3xOrgRelationship> rels = orgCache.getMemberPostRelastionships(memberId, accountId);
			for (V3xOrgRelationship rel : rels) {
				if(member.getIsInternal()) {//内部人员
					if(!isValidMemberPost(rel)){//外部人员没有objective1_id
						continue;
					}
				}

				V3xOrgDepartment dept = orgCache.getV3xOrgEntityNoClone(V3xOrgDepartment.class, rel.getObjective0Id());

				if(null == dept || !dept.isValid()){
					continue;
				}

				deptIds.add(rel.getObjective0Id()); //我的直接所在部门
				departmentIds.add(dept.getId());

				if(member.getIsInternal() || member.isVJoinExternal()) {//内部人员或V-Join外部人员
					V3xOrgPost post = orgCache.getV3xOrgEntityNoClone(V3xOrgPost.class, rel.getObjective1Id());
					V3xOrgLevel level = orgCache.getV3xOrgEntityNoClone(V3xOrgLevel.class, rel.getObjective2Id());
					V3xOrgAccount account = orgCache.getV3xOrgEntityNoClone(V3xOrgAccount.class, dept.getOrgAccountId());

					if(account != null && account.isValid()){
						accountIds.add(dept.getOrgAccountId());
					}

					//上级部门
					List<V3xOrgDepartment> parentDepts = this.getAllParentDepartments0(dept.getId(), false);
					for (V3xOrgDepartment d : parentDepts) {
						departmentIds.add(d.getId());
					}

					//标准岗
					if(null != post && post.isValid()) {
						V3xOrgPost bmPost = this.getBMPostByPostId(post.getId());
						if(bmPost != null && bmPost.isValid()){
							postIds.add(bmPost.getId());
						}
						postIds.add(post.getId());
					}

					//职务级别
					if(level != null){
						levelIds.add(level.getId());

						//考虑集团职务级别
						if (level.getGroupLevelId() != null) {
							V3xOrgLevel groupLevel = orgCache.getV3xOrgEntityNoClone(V3xOrgLevel.class, level.getGroupLevelId());

							if(groupLevel != null && groupLevel.isValid()){
								levelIds.add(groupLevel.getId());
							}
						}
					}
				}
			}
		}

		//2012-12-22 lilong 此接口为考虑单位管理员的单位id,  因为管理员没有Member_Post
		{
			if(member.getIsAdmin()) {
				accountIds.add(member.getOrgAccountId());
			}
		}

		//普通用户才有组ID
		if(!member.getIsAdmin() && (types.contains(ORGENT_TYPE.Team.name()) || types.contains(ORGENT_TYPE.Role.name()))){
			List<Long> accountids = null;
			if(accountId != null){
				accountids = Strings.newArrayList(accountId);
			}

			Set<V3xOrgTeam> allteams = new HashSet<V3xOrgTeam>();
			Set<Long> ids = new HashSet<Long>();
			ids.add(memberId);
			ids.addAll(levelIds);
			ids.addAll(postIds);
			ids.addAll(departmentIds);

			this.getParTeam(member,accountids, ids, allteams, deptIds);

			for(V3xOrgTeam team: allteams){
				teamIds.add(team.getId());
			}
		}

		if(types.contains(ORGENT_TYPE.Role.name())) {
			List<Long> roleMembers = new ArrayList<Long>();
			roleMembers.addAll(departmentIds);
			roleMembers.addAll(postIds);
			roleMembers.addAll(levelIds);
			roleMembers.addAll(teamIds);
			roleMembers.add(memberId);

			List<V3xOrgRelationship> rels = orgCache.getEntityRoleRelastionships(roleMembers, null, accountId);
			for (V3xOrgRelationship rel : rels) {
				V3xOrgRole role = orgCache.getV3xOrgEntityNoClone(V3xOrgRole.class, rel.getObjective1Id());
				if(role != null && role.isValid() && role.getBond() == OrgConstants.ROLE_BOND.ACCOUNT.ordinal()){ //过滤掉部门角色
					roleIds.add(role.getId());
				}
			}
		}

		if(types.contains(ORGENT_TYPE.Member.name())){
			resultIds.add(memberId);
		}
		if (types.contains(ORGENT_TYPE.Account.name())) {
			resultIds.addAll(accountIds);

			//没有指定单位，表示全集团
			if (accountId == null && !member.isVJoinExternal()) {
				for (Long a : accountIds) {
					V3xOrgAccount root = this.getRootAccount(a);
					if (root != null) {
						resultIds.add(root.getId());

						break;
					}
				}
			}
		}
		if(types.contains(ORGENT_TYPE.Department.name())){
			resultIds.addAll(departmentIds);
		}
		if(types.contains(ORGENT_TYPE.Post.name())){
			resultIds.addAll(postIds);
		}
		if(types.contains(ORGENT_TYPE.Level.name())){
			resultIds.addAll(levelIds);
		}
		if(types.contains(ORGENT_TYPE.Team.name())){
			resultIds.addAll(teamIds);
		}
		if(types.contains(ORGENT_TYPE.Role.name())){
			resultIds.addAll(roleIds);
		}

		//如果是V-Join人员，获取人员所在外部单位的自定义属性：枚举值
		if (member.isVJoinExternal()) {
			JoinAccount joinAccount = joinAccountCustomerFieldInfoManager.getByDepartmentId(member.getOrgDepartmentId());
			if (joinAccount != null) {
				if (joinAccount.getExtAttr31() != null) {
					resultIds.add(joinAccount.getExtAttr31());
				}
				if (joinAccount.getExtAttr32() != null) {
					resultIds.add(joinAccount.getExtAttr32());
				}
				if (joinAccount.getExtAttr33() != null) {
					resultIds.add(joinAccount.getExtAttr33());
				}
				if (joinAccount.getExtAttr34() != null) {
					resultIds.add(joinAccount.getExtAttr34());
				}
				if (joinAccount.getExtAttr35() != null) {
					resultIds.add(joinAccount.getExtAttr35());
				}
				if (joinAccount.getExtAttr36() != null) {
					resultIds.add(joinAccount.getExtAttr36());
				}
				if (joinAccount.getExtAttr37() != null) {
					resultIds.add(joinAccount.getExtAttr37());
				}
				if (joinAccount.getExtAttr38() != null) {
					resultIds.add(joinAccount.getExtAttr38());
				}
				if (joinAccount.getExtAttr39() != null) {
					resultIds.add(joinAccount.getExtAttr39());
				}
				if (joinAccount.getExtAttr40() != null) {
					resultIds.add(joinAccount.getExtAttr40());
				}
			}
		}

		Collections.sort(resultIds);

		return resultIds;
	}

	private <T extends Object> Set<T> newHashSet(T... ts){
		Set<T> list = new HashSet<T>(ts.length);
		for (T t : ts) {
			list.add(t);
		}

		return list;
	}

	// 只在当前线程有效的缓存，避免多次执行相同的查询
	private <K extends Object, V extends Object> Map<K, V> getLocalCache(final String cacheName) {
		Map<K, V> cache = (Map<K, V> )AppContext.getCache(cacheName);
		if (cache == null) {
			cache = new ConcurrentHashMap<K, V>();
			AppContext.putCache(cacheName, cache);
		}

		return cache;
	}

	private String buildKey(Long memberId, Long accountId, String... type) {
		StringBuffer sb = new StringBuffer();
		String SEP = "_";
		sb.append(memberId).append(SEP).append(accountId);
		for (String s : type) {
			sb.append(SEP).append(s);
		}
		return sb.toString();
	}

	@Override
	public String getUserIDDomain(Long memberId, String... types) throws BusinessException {
		return this.getUserIDDomain(memberId, null, types);
	}

	public String getUserIDDomain(Long memberId, Long accountId, String... types) throws BusinessException {
		List<Long> ids = this.getUserDomainIDs(memberId, accountId, types);
		return Strings.join(ids, ",");
	}

	@Override
	public List<V3xOrgDepartment> getDeptsByManager(Long memberId, Long accountId) throws BusinessException {
		List<V3xOrgDepartment> resultList = new ArrayList<V3xOrgDepartment>();
		V3xOrgRole role = getRoleByName(Role_NAME.DepManager.name(), accountId);
		if (role == null) {
			return resultList;
		}

		List<Long> deptIds = this.getDomainByRole(role.getId(), memberId);
		for (Long depId : deptIds) {
			V3xOrgDepartment dept;
			try {
				dept = orgCache.getV3xOrgEntity(V3xOrgDepartment.class, depId);
				if(dept != null && dept.isValid()){
					resultList.add(dept);
				}
			} catch (ClassCastException e) {
				logger.error("该人员的部门角色关系数据有误，捕获异常不影响登录");
				continue;
			}
		}

		return resultList;
	}

	@Override
	public List<V3xOrgDepartment> getDeptsByDeptLeader(Long memberId, Long accountId) throws BusinessException {
		List<V3xOrgDepartment> resultList = new ArrayList<V3xOrgDepartment>();
		V3xOrgRole role = getRoleByName(Role_NAME.DepLeader.name(), accountId);
		if (role == null) {
			return resultList;
		}

		List<Long> deptIds = this.getDomainByRole(role.getId(), memberId);
		for (Long depId : deptIds) {
			V3xOrgDepartment dept;
			try {
				dept = orgCache.getV3xOrgEntity(V3xOrgDepartment.class, depId);
				if(dept != null && dept.isValid()){
					resultList.add(dept);
				}
			} catch (ClassCastException e) {
				logger.error("该人员的部门角色关系数据有误，捕获异常不影响登录");
				continue;
			}
		}

		return resultList;
	}

	@Override
	public List<V3xOrgDepartment> getDeptsByAdmin(Long memberId, Long accountId) throws BusinessException {
		List<V3xOrgDepartment> resultList = new ArrayList<V3xOrgDepartment>();
		V3xOrgRole role = getRoleByName(Role_NAME.DepAdmin.name(), accountId);
		if (role == null) {
			return resultList;
		}

		List<Long> deptIds = getDomainByRole(role.getId(), memberId);
		for (Long depId : deptIds) {
			V3xOrgDepartment dept = orgCache.getV3xOrgEntity(V3xOrgDepartment.class, depId);
			if(dept != null && dept.isValid()){
				resultList.add(dept);
			}
		}

		return resultList;
	}

	@Override
	public List<V3xOrgDepartment> getDepartmentsByUser(Long memberId) throws BusinessException {
		List<V3xOrgDepartment> resultList = new UniqueList<V3xOrgDepartment>();

		List<Long> deptIds = this.getWorkDepartments(memberId, null);

		for (Long deptId : deptIds) {
			V3xOrgDepartment dept = orgCache.getV3xOrgEntity(V3xOrgDepartment.class, deptId);
			if (dept != null) {
				resultList.add(dept);
			}
		}

		return resultList;
	}
	@Override
	public boolean isDepartmentAdmin() throws BusinessException {
		//改為是否是部門管理員
		return this.isRole(AppContext.currentUserId(), null, OrgConstants.Role_NAME.DepAdmin.name());
		//getMemberById(AppContext.currentUserId()).
		//return getDepartmentById(getMemberById(AppContext.currentUserId()).getOrgDepartmentId())!=null?true:false;
	}
	@Override
	public boolean isHRAdmin() throws BusinessException {
		return this.isRole(AppContext.currentUserId(), AppContext.currentAccountId(), OrgConstants.Role_NAME.HrAdmin.name());
		//getMemberById(AppContext.currentUserId()).
		//return getDepartmentById(getMemberById(AppContext.currentUserId()).getOrgDepartmentId())!=null?true:false;
	}

	@Override
	public boolean isAccountInGroupTree(Long accountId) throws BusinessException {
		return this.getRootAccount(accountId) != null;
	}

	@Override
	public List<V3xOrgEntity> getEntity(String entityClassName, String property, Object value, Long accountId)
	throws BusinessException {
		return getEntityList(entityClassName, property, value, accountId);

	}

	@Override
	public V3xOrgPost getAccountPostByBMPostId(Long bmPostId, Long accountId) throws BusinessException {
		V3xOrgPost v3xOrgPost = null;
		EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
		enummap.put(OrgConstants.RelationshipObjectiveName.objective0Id, bmPostId);
		List<V3xOrgRelationship> refList = orgCache.getV3xOrgRelationship(OrgConstants.RelationshipType.Banchmark_Post, null, accountId, enummap);
		for (V3xOrgRelationship v3xOrgRelationship : refList) {
			v3xOrgPost = getPostById(v3xOrgRelationship.getSourceId());
		}

		return v3xOrgPost;
	}

	@Override
	public List<V3xOrgEntity> getEntityListNoRelation(String entityClassName, String property, Object value,
			Long accountId) throws BusinessException {
		return getEntityNoRelation(entityClassName, property, value, accountId, false);
	}

	@Override
	public List<V3xOrgEntity> getEntityListNoRelation(String entityClassName, String property, Object value,
			Long accountId, boolean isPaginate) throws BusinessException {
		return getEntityNoRelation(entityClassName, property, value, accountId, isPaginate);
	}

	@Override
	public List<V3xOrgEntity> getExternalMemberWorkScope(Long memberId, boolean includeDisabled)
	throws BusinessException {
		List<V3xOrgEntity> ents = new ArrayList<V3xOrgEntity>();
		List<V3xOrgRelationship> rels = orgCache.getV3xOrgRelationship(
				OrgConstants.RelationshipType.External_Workscope, memberId, null, null);
		if (rels == null) {
			return ents;
		}
		for (V3xOrgRelationship rel : rels) {
			if (rel.getObjective5Id() != null) {
				V3xOrgEntity ent = null;

				ent = getEntityById(OrgHelper.getEntityTypeByOrgConstantsType(rel.getObjective5Id()), rel.getObjective0Id());

				if (ent != null) {
					ents.add(ent);
				}
			}
		}

		return ents;
	}

	@Override
	public List<V3xOrgMember> getMemberWorkScopeForExternal(Long memberId, boolean includeDisabled) throws BusinessException {
		UniqueList<V3xOrgMember> ents = new UniqueList<V3xOrgMember>();

		List<Long> teamMembers = this.getUserDomainIDs(memberId,
				ORGENT_TYPE.Member.name(),
				ORGENT_TYPE.Account.name(),
				ORGENT_TYPE.Department.name(),
				ORGENT_TYPE.Post.name(),
				ORGENT_TYPE.Level.name(),
				ORGENT_TYPE.Team.name());

		EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
		enummap.put(OrgConstants.RelationshipObjectiveName.objective0Id, teamMembers);

		List<V3xOrgRelationship> spRels = orgCache.getV3xOrgRelationship(RelationshipType.External_Workscope, (Long)null, (Long)null, enummap);
		for (V3xOrgRelationship r : spRels) {
			V3xOrgMember member = this.orgCache.getV3xOrgEntity(V3xOrgMember.class, r.getSourceId());
			if(member != null && member.isValid() && !member.getIsInternal()){
				ents.add(member);
			}
		}

		return ents;
	}

	@Override
	public HashMap<Long,UniqueList<V3xOrgMember>> getMemberWorkScopeForExternalForMap(Long memberId) throws BusinessException {
		HashMap<Long,UniqueList<V3xOrgMember>> entMap=new HashMap<Long, UniqueList<V3xOrgMember>>();
		UniqueList<V3xOrgMember> ents =null;
		List<Long> teamMembers = this.getUserDomainIDs(memberId,
				ORGENT_TYPE.Member.name(),
				ORGENT_TYPE.Account.name(),
				ORGENT_TYPE.Department.name(),
				ORGENT_TYPE.Post.name(),
				ORGENT_TYPE.Level.name(),
				ORGENT_TYPE.Team.name());

		EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
		enummap.put(OrgConstants.RelationshipObjectiveName.objective0Id, teamMembers);

		List<V3xOrgRelationship> spRels = orgCache.getV3xOrgRelationship(RelationshipType.External_Workscope, (Long)null, (Long)null, enummap);
		for (V3xOrgRelationship r : spRels) {
			Long objective0Id=r.getObjective0Id();
			String objective5Id=r.getObjective5Id();
			V3xOrgMember member = this.orgCache.getV3xOrgEntity(V3xOrgMember.class, r.getSourceId());
			if(member != null && member.isValid() && !member.getIsInternal()){
				//暂时考虑以下这几种类型
				if(objective5Id.equals(ORGENT_TYPE.Account.name())||objective5Id.equals(ORGENT_TYPE.Post.name())||objective5Id.equals(ORGENT_TYPE.Level.name())||objective5Id.equals(ORGENT_TYPE.Team.name())){
					continue;
				}
				if(objective5Id.equals(ORGENT_TYPE.Member.name())){
					member=this.getMemberById(objective0Id);
					if(member!=null){
						objective0Id=member.getOrgDepartmentId();
					}else{
						continue;
					}
				}
				if(entMap.containsKey(objective0Id)){
					ents=entMap.get(objective0Id);
				}else{
					ents = new UniqueList<V3xOrgMember>();
				}
				ents.add(member);
				entMap.put(objective0Id, ents);
			}

		}

		return entMap;
	}

	public List<Long> getDepartmentWorkScopeForExternal(Long memberId) throws BusinessException {
		UniqueList<Long> deptIds = new UniqueList<Long>();
		List<V3xOrgMember> members = this.getMemberWorkScopeForExternal(memberId, false);
		for (V3xOrgMember member : members) {
			deptIds.add(member.getOrgDepartmentId());
		}
		return deptIds;
	}

	@Override
	public List<V3xOrgMember> getAllAccountsExtMember(boolean includeDisabled) throws BusinessException {
		UniqueList<V3xOrgMember> ents = new UniqueList<V3xOrgMember>();
		for (V3xOrgAccount account : orgCache.getAllAccounts()) {
			List<V3xOrgMember> extMembers = getAllExtMembers(account.getId());
			for (V3xOrgMember extMember : extMembers) {
				if (!includeDisabled) {
					if (extMember.isValid()) {
						ents.add(extMember);
					}
				} else {
					ents.add(extMember);
				}
			}
		}
		return ents;
	}

	@Override
	@Deprecated
	public List<? extends V3xOrgEntity> getEntitysByPropertysNoRelation(String entityClassName, Long accountId,
			boolean isPaginate, Object... args) throws BusinessException {
		return null;
	}

	@Override
	public V3xOrgMember getMembersByMobile(String mobile, Long accountId) throws BusinessException {
		if(Strings.isBlank(mobile)) {
			logger.error("根据电话查询人员传入参数电话为空！");
			throw new BusinessException("根据电话查询人员传入参数电话为空！");
		}
		List<V3xOrgMember> temp = this.getAllMembers(accountId);
		for (V3xOrgMember m : temp) {
			if(Strings.isNotBlank(m.getTelNumber()) && m.getTelNumber().equals(mobile)) {
				return m;
			}
		}
		return null;
	}

	@Override
	public V3xOrgPost getBMPostByPostId(Long postId) throws BusinessException {
		if (postId == null || postId == V3xOrgEntity.DEFAULT_NULL_ID) {
			return null;
		}
		V3xOrgPost post = getPostById(postId);
		if (post == null) {
			return null;
		}

		//如果岗位本身是集团基准岗
		if (getAccountById(post.getOrgAccountId()).isGroup()) {
			return post;
		}

		//取得岗位绑定的基准岗
		List<V3xOrgRelationship> rels = orgCache.getV3xOrgRelationship(OrgConstants.RelationshipType.Banchmark_Post, postId, null, null);
		for (V3xOrgRelationship rel : rels) {
			return this.getPostById(rel.getObjective0Id());
		}

		return null;
	}

	@Override
	public List<V3xOrgPost> getAllBenchmarkPost(Long accountId) throws BusinessException {
		List<V3xOrgPost> posts = new ArrayList<V3xOrgPost>();
		List<V3xOrgRelationship> rels = orgCache.getV3xOrgRelationship(OrgConstants.RelationshipType.Banchmark_Post, null, accountId, null);
		for (V3xOrgRelationship rel : rels) {
			V3xOrgPost post = orgCache.getV3xOrgEntity(V3xOrgPost.class, rel.getObjective0Id());
			if (post != null && post.isValid()) {
				posts.add(post);
			}
		}

		return posts;
	}
	@Override
	public V3xOrgDepartment getCurrentDepartment() throws BusinessException {
		V3xOrgDepartment dept = getDepartmentById(getMemberById(AppContext.currentUserId()).getOrgDepartmentId());
		if(dept.getOrgAccountId().equals(AppContext.currentAccountId())){
			return dept;
		}else{
			List<MemberPost> concurrent_post = getMemberById(AppContext.currentUserId()).getConcurrent_post();
			for (MemberPost memberPost : concurrent_post) {
				V3xOrgDepartment departmentById = getDepartmentById(memberPost.getDepId());
				if(departmentById.getOrgAccountId().equals(AppContext.currentAccountId())){
					return departmentById;
				}
			}
			return new V3xOrgDepartment();
		}
	}
	@Override
	public List<V3xOrgTeam> getDepartmentTeam(Long depId) throws BusinessException {
		return this.orgManagerDirect.getDepartmentTeam(depId, false);
	}
	@Override

	public boolean isBaseRole(String roleCode) throws BusinessException {
		if(roleCode==null){
			return false;
		}
		OrgConstants.Role_NAME systemRoleName = null;
		try{
			systemRoleName = OrgConstants.Role_NAME.valueOf(roleCode);
		}
		catch(Exception e){
			//ignore
		}

		if(systemRoleName != null){
			return true;
		}else{
			return false;
		}
	}
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.DepAdmin})
	public String getLoginMemberDepartment(String accountId) throws BusinessException {
		Long accId = Long.valueOf(accountId);
		List<V3xOrgEntity> list = new ArrayList<V3xOrgEntity>();
		HashMap<String, String> map = new HashMap<String, String>();
		StringBuilder returnstr = new StringBuilder();
		V3xOrgMember memberById = this.getMemberById(AppContext.currentUserId());
		V3xOrgDepartment departmentById = this.getDepartmentById(memberById.getOrgDepartmentId());
		if (memberById.getOrgAccountId().equals(accId)
				&& departmentById != null) {
			list.add(departmentById);
		} else {
			List<MemberPost> concurrent_post = memberById.getConcurrent_post();
			for (MemberPost memberPost : concurrent_post) {
				V3xOrgDepartment departmentById2 = this.getDepartmentById(memberPost.getDepId());
				if (departmentById2 != null) {
					list.add(departmentById2);
				}
			}
		}
		for (int i = 0; i < list.size(); i++) {
			if (i == 0) {
				returnstr.append(list.get(i).getId());
			} else {
				returnstr.append(",").append(list.get(i).getId());
			}
		}
		map.put("ids", returnstr.toString());
		return JSONUtil.toJSONString(map);
	}
	@Override
	public boolean isRole(Long memberId, Long unitId, String roleNameOrId, OrgConstants.MemberPostType... postTypes) throws BusinessException {
		V3xOrgMember member = this.getMemberById(memberId);
		if(member == null || !member.isValid()){
			return false;
		}

		OrgConstants.Role_NAME roleName = null;
		try{
			roleName = OrgConstants.Role_NAME.valueOf(roleNameOrId);
		}
		catch(Exception e){
		}

		List<MemberRole> memberRoles = new ArrayList<MemberRole>();

		List<MemberRole> memberRoles0 = this.getMemberRoles(memberId, unitId);
		for (MemberRole memberRole : memberRoles0) {
			V3xOrgRole role = memberRole.getRole();
			if((roleName == null && String.valueOf(role.getId()).equals(roleNameOrId))
					|| (roleName != null && roleNameOrId.equals(role.getCode()))){
				memberRoles.add(memberRole);
			}
		}

		if(Strings.isEmpty(memberRoles)){
			return false;
		}

		//管理员不用判断岗位类型
		//不指定类型或者全类型就直接返回true
		if(member.getIsAdmin() || postTypes == null || postTypes.length == 0 || postTypes.length == 3){
			return true;
		}

		Set<OrgConstants.MemberPostType> postTypeSet = Strings.newHashSet(postTypes);


		boolean isMain = postTypeSet.contains(MemberPostType.Main);
		boolean isSecond = postTypeSet.contains(MemberPostType.Second);

		//我的副岗部门的ID
		Set<Long> secondDeptIds = new HashSet<Long>();
		if(isSecond){
			List<MemberPost> memberSecondPosts = this.getMemberSecondPosts(memberId);
			for (MemberPost memberSecondPost : memberSecondPosts) {
				List<V3xOrgDepartment> memberDepts = this.getAllParentDepartments(memberSecondPost.getDepId());
				for (V3xOrgDepartment d : memberDepts) {
					secondDeptIds.add(d.getId());
				}

				secondDeptIds.add(memberSecondPost.getDepId());
			}
		}

		if(isMain || isSecond){
			//主岗部门
			Set<Long> mainDeptIds = new HashSet<Long>();
			List<V3xOrgDepartment> memberDepts = this.getAllParentDepartments(member.getOrgDepartmentId());
			for (V3xOrgDepartment d : memberDepts) {
				mainDeptIds.add(d.getId());
			}

			mainDeptIds.add(member.getOrgDepartmentId());

			for (MemberRole memberRole : memberRoles) {
				if(Strings.equals(member.getOrgAccountId(), memberRole.getAccountId())){
					if(memberRole.getRole().getBond() == OrgConstants.ROLE_BOND.DEPARTMENT.ordinal()){
						Long roleDeptId = memberRole.getDepartment().getId();
						if(isMain && mainDeptIds.contains(roleDeptId)){ //主岗
							return true;
						}
						if(isSecond && (!mainDeptIds.contains(roleDeptId) || secondDeptIds.contains(roleDeptId))){ //附岗
							return true;
						}
					}
					else{ //单位角色
						return true;
					}
				}
			}
		}

		if(postTypeSet.contains(MemberPostType.Concurrent)){
			for (MemberRole memberRole : memberRoles) {
				if(!Strings.equals(member.getOrgAccountId(), memberRole.getAccountId())){
					return true;
				}
			}
		}

		return false;
	}

	/**
	 * 得到指定人在指定单位的工作部门，包括主岗、副岗等部门
	 *
	 * @param memberId
	 * @param _accountId 如果为<code>null</code>，将包含兼职部门
	 * @return
	 * @throws BusinessException
	 */
	private List<Long> getWorkDepartments(long memberId, Long _accountId) throws BusinessException {
		List<Long> ds = new UniqueList<Long>();
		V3xOrgMember member = getMemberById(memberId);
		if (member == null) {
			return ds;
		}

		List<V3xOrgRelationship> ents = this.orgCache.getMemberPostRelastionships(memberId, _accountId);
		for (V3xOrgRelationship r : ents) {
			if(isValidMemberPost(r)){
				ds.add(r.getObjective0Id());
			}
		}

		return ds;
	}

	public boolean isPost(long memberId, long postId, OrgConstants.MemberPostType... postTypes) throws BusinessException {
		V3xOrgPost post = orgCache.getV3xOrgEntity(V3xOrgPost.class, postId);
		if (post == null) {
			return false;
		}

		V3xOrgMember member = orgCache.getV3xOrgEntity(V3xOrgMember.class, memberId);
		if (member == null)
			return false;
		Set<Long> postIdsSet = new HashSet<Long>();
		List<Long> postIds = getAccountPostByBachmarkPost(postId, null);
		if(postIds.isEmpty()){
			return false;
		}else{
			postIdsSet.addAll(postIds);
		}

		List<V3xOrgRelationship> ents = this.orgCache.getMemberPostRelastionships(memberId, null, postTypes);

		for (V3xOrgRelationship ent : ents) {
			if(isValidMemberPost(ent) && ent.getSourceId().equals(memberId) && postIdsSet.contains(ent.getObjective1Id())){
				return true;
			}
		}

		return false;
	}


	public boolean isInDepartment(long memberId, List<Long> deptIdList, boolean includeChild) throws BusinessException {
		List<String> postTypes = new ArrayList<String>(1);
		postTypes.add(OrgConstants.MemberPostType.Main.name());

		return isInDepartment(memberId, postTypes, deptIdList, includeChild);
	}

	@Override
	public V3xOrgMember getSystemAdmin() {
		//判断是否是a6，如果是a6，system账号绑定的角色是单位管理员角色，直接从人员缓存中获取system账号信息
		boolean isA6 = (Boolean)SysFlag.sys_isA6Ver.getFlag();
		if(isA6){
			try {
				V3xOrgMember member = this.getMemberById(OrgConstants.SYSTEM_ADMIN_ID);
				return member;
			} catch (BusinessException e) {
				logger.error(e.getMessage());
			}
		}else{
			try {
				List<V3xOrgMember> members = getMembersByRole(OrgConstants.GROUPID, OrgConstants.Role_NAME.SystemAdmin.name());
				if(!Strings.isEmpty(members)){
					return members.get(0);
				}
			}
			catch (Exception e) {
				logger.error(e.getMessage());
			}
		}

		return null;
	}

	@Override
	public V3xOrgMember getAuditAdmin() {
		try {
			List<V3xOrgMember> members = getMembersByRole(OrgConstants.GROUPID, OrgConstants.Role_NAME.AuditAdmin.name());
			if(!Strings.isEmpty(members)){
				return members.get(0);
			}
		}
		catch (BusinessException e) {
			//ignore
		}

		return null;
	}
	@Override
	public List<? extends V3xOrgEntity> getAllMembersByDepartmentBO(Long departmentId) {
		return OrgHelper.listPoTolistBo(orgDao.getAllMemberPOByDepartmentId(departmentId, false, null, null, true, null, null, null));
	}


	@Override
	public V3xOrgMember getGroupAdmin() {
		try {
			List<V3xOrgMember> members = getMembersByRole(getRootAccount().getId(), OrgConstants.Role_NAME.GroupAdmin.name());
			if(!Strings.isEmpty(members)){

				return members.get(0);
			}
		}
		catch (BusinessException e) {
			//ignore
		}

		return null;
	}

	@Override
	public V3xOrgMember getAdministrator(Long accountId) {
		try {
			List<V3xOrgMember> members = getMembersByRole(accountId, OrgConstants.Role_NAME.AccountAdministrator.name());
			for (V3xOrgMember bo : members) {
				if(bo.getIsAdmin()) {
					return bo;
				}
			}
		}
		catch (BusinessException e) {
			//ignore
		}

		return null;
	}

	public boolean isInDepartment(long memberId, List<String> memberPostTypes, List<Long> deptIdList, boolean hasChildDep) throws BusinessException {
		V3xOrgMember member = this.getEntityById(V3xOrgMember.class, memberId);
		if (member == null)
			return false;

		Set<Long> departmentList = new HashSet<Long>(deptIdList);
		if(hasChildDep) {
			for(Long deptId : deptIdList) {
				List<V3xOrgDepartment> ds = this.getChildDepartments(deptId, false);
				if(!Strings.isEmpty(ds)){
					for (V3xOrgDepartment d : ds) {
						departmentList.add(d.getId());
					}
				}
			}
		}

		List<V3xOrgRelationship> ents = this.orgCache.getMemberPostRelastionships(memberId, null);

		for (V3xOrgRelationship ent : ents) {
			if(memberPostTypes != null && !memberPostTypes.contains(ent.getObjective5Id())){
				continue;
			}

			if(!departmentList.contains(ent.getObjective0Id())){
				continue;
			}

			if(isValidMemberPost(ent) && ent.getSourceId().equals(memberId)){
				return true;
			}
		}

		return false;
	}

	// 角色定义缓存
	private Map<String, OrgRoleDefaultDefinition> roleDefinitions;

	@Override
	public Map<String, OrgRoleDefaultDefinition> getRoleDefinitions() {
		if (this.roleDefinitions == null) {
			this.roleDefinitions = findAllRoleDefinition();
		}
		return this.roleDefinitions;
	}

	/**
	 * 在整个Spring上下文查找扩展的角色定义。
	 * @return 角色定义Id-实体Map
	 */
	private Map<String, OrgRoleDefaultDefinition> findAllRoleDefinition() {
		Map<?, OrgRoleDefaultDefinition> beans = AppContext.getBeansOfType(OrgRoleDefaultDefinition.class);
		Map<String, OrgRoleDefaultDefinition> map = new HashMap<String, OrgRoleDefaultDefinition>();
		for (OrgRoleDefaultDefinition def : beans.values()) {
			if (map.containsKey(def.getId())) {
				logger.warn("角色" + def.getId() + "已存在，不允许重复定义。");
			}
			map.put(def.getId(), def);
		}
		return map;
	}

	@Override
	public List<V3xOrgDepartment> getAllDepartments(Long accountId) throws BusinessException {
		List<V3xOrgDepartment> list = orgCache.getAllV3xOrgEntity(V3xOrgDepartment.class, accountId);
		List<V3xOrgDepartment> depList = new UniqueList<V3xOrgDepartment>();
		for (Iterator<V3xOrgDepartment> it = list.iterator(); it.hasNext();) {
			V3xOrgDepartment dep = it.next();
			if (dep.isValid()) {
				depList.add(dep);
			}
		}

		Collections.sort(depList, CompareSortEntity.getInstance());
		return depList;
	}
	@Override
	public List<V3xOrgDepartment> getAllInternalDepartments(Long accountId) throws BusinessException {
		List<V3xOrgDepartment> list = orgCache.getAllV3xOrgEntity(V3xOrgDepartment.class, accountId);
		List<V3xOrgDepartment> depList = new UniqueList<V3xOrgDepartment>();
		for (Iterator<V3xOrgDepartment> it = list.iterator(); it.hasNext();) {
			V3xOrgDepartment dep = it.next();
			if (dep.isValid() && dep.getIsInternal()) {
				depList.add(dep);
			}
		}
		Collections.sort(depList, CompareSortEntity.getInstance());
		return depList;
	}

	@Override
	public List<V3xOrgDepartment> getAllExtDepartments(Long accountId){
		List<V3xOrgDepartment> list = orgCache.getAllV3xOrgEntity(V3xOrgDepartment.class, accountId);
		List<V3xOrgDepartment> depList = new UniqueList<V3xOrgDepartment>();
		for (Iterator<V3xOrgDepartment> it = list.iterator(); it.hasNext();) {
			V3xOrgDepartment dep = it.next();
			if (dep.isValid() && !dep.getIsInternal()) {
				depList.add(dep);
			}
		}

		Collections.sort(depList, CompareSortEntity.getInstance());

		return depList;
	}


	@Override
	public List<V3xOrgDepartment> getChildExtDepartments(Long accountId,Long deptId){
		List<V3xOrgDepartment> list = orgCache.getAllV3xOrgEntity(V3xOrgDepartment.class, accountId);
		List<V3xOrgDepartment> depList = new UniqueList<V3xOrgDepartment>();
		for (Iterator<V3xOrgDepartment> it = list.iterator(); it.hasNext();) {
			V3xOrgDepartment dep = it.next();
			if (dep.isValid() && !dep.getIsInternal() && Strings.equals(dep.getSuperior(), deptId)) {
				depList.add(dep);
			}
		}

		Collections.sort(depList, CompareSortEntity.getInstance());

		return depList;
	}


	@Override
	@AjaxAccess
	public boolean canShowPeopleCard(Long memberid_me,Long memeberid2_other) throws BusinessException{
		if(null==memberid_me){
			memberid_me = AppContext.getCurrentUser().getId();
		}
		V3xOrgMember currentMember = getMemberById(memberid_me);
		V3xOrgMember member = getMemberById(memeberid2_other);
		//可以查看有效或者离职的人员
		if(currentMember.isV5External()){
			Collection<V3xOrgMember> members = OuterWorkerAuthUtil.getCanAccessMembers(memberid_me, currentMember.getOrgDepartmentId(), currentMember.getOrgAccountId(), this);
			if(members.contains(member)){
				return true;
			}else{
				return false;
			}
		}else{
			boolean canSeeMember = (!member.getIsDeleted() && member.getEnabled()) || member.getState() == OrgConstants.MEMBER_STATE.ONBOARD.ordinal();
			if(!canSeeMember || member.getIsAdmin() || !checkLevelScope(memberid_me,memeberid2_other) || !checkAccessAccount(memberid_me,memeberid2_other)
			){
				return false;
			}else{
				return true;
			}
		}
	}

	@Override
	@AjaxAccess
	public int getMemberExternalType(Long memberId) throws BusinessException{
		int type = OrgConstants.ExternalType.Inner.ordinal();
		V3xOrgMember member = getMemberById(memberId);
		if(member != null){
			type = member.getExternalType();
		}
		return type;
	}

	@Override
	public List<V3xOrgLevel> getAllLevels(Long accountId) throws BusinessException {
		List<V3xOrgLevel> list = orgCache.getAllV3xOrgEntity(V3xOrgLevel.class, accountId);

		List<V3xOrgLevel> levelList = new ArrayList<V3xOrgLevel>();
		for (Iterator<V3xOrgLevel> it = list.iterator(); it.hasNext();) {
			V3xOrgLevel level = (V3xOrgLevel) it.next();
			if (level.isValid()) {
				levelList.add(level);
			}
		}

		Collections.sort(levelList, CompareSortLevelId.getInstance());

		return levelList;
	}

	@Override
	public List<V3xOrgDutyLevel> getAllDutyLevels(Long accountId) throws BusinessException {
		return null;
	}

	@Override
	public List<V3xOrgPost> getAllPosts(Long accountId) throws BusinessException {
		List<V3xOrgPost> list = orgCache.getAllV3xOrgEntity(V3xOrgPost.class, accountId);
		List<V3xOrgPost> postList = new ArrayList<V3xOrgPost>();
		for (Iterator<V3xOrgPost> it = list.iterator(); it.hasNext();) {
			V3xOrgPost post = (V3xOrgPost) it.next();
			if (post.isValid()) {
				postList.add(post);
			}
		}
		Collections.sort(postList, CompareSortEntity.getInstance());
		return postList;
	}

	@Override
	public List<V3xOrgRole> getAllRoles(Long accountId) throws BusinessException {
		List<V3xOrgRole> list = orgCache.getAllV3xOrgEntity(V3xOrgRole.class, accountId);
		List<V3xOrgRole> roleList = new UniqueList<V3xOrgRole>();
		for (Iterator<V3xOrgRole> it = list.iterator(); it.hasNext();) {
			V3xOrgRole role = it.next();
			if (role != null && role.isValid()&&(role.getBond()==0||role.getBond()==1||role.getBond()==2)){
				roleList.add(role);
			}
		}
		//根据插件过滤角色

		List<V3xOrgRole> dislist = getPlugDisableRole(accountId);

		if (dislist != null) {
			for (V3xOrgRole v3xOrgRole : dislist) {
				for (int i = 0; i < roleList.size(); i++) {
					V3xOrgRole role = roleList.get(i);
					if (role.getId().equals(v3xOrgRole.getId())) {
						roleList.remove(i--);
					}

				}
			}
		}
		Collections.sort(roleList, CompareSortEntity.getInstance());
		return roleList;
	}
	@Override
	public List<V3xOrgRole> getAllDepRoles(Long accountId) throws BusinessException {

		List<V3xOrgRole> deproleList = new ArrayList<V3xOrgRole>();
		List<V3xOrgRole> roleList  = getAllRoles(accountId);
		for (V3xOrgRole v3xOrgRole : roleList) {
			if(v3xOrgRole.getBond()==OrgConstants.ROLE_BOND.DEPARTMENT.ordinal()){
				// a6s版本下不能出现部门公文收发员
				if(!AppContext.hasPlugin("edoc") && v3xOrgRole.getCode().equals(Role_NAME.Departmentexchange.name())){
					continue;
				}
				deproleList.add(v3xOrgRole);
			}
		}
		return deproleList;
	}

	@Override
	public List<V3xOrgTeam> getAllTeams(Long accountId) throws BusinessException {
		List<V3xOrgTeam> list = orgCache.getAllV3xOrgEntity(V3xOrgTeam.class, accountId);
		List<V3xOrgTeam> teamList = new ArrayList<V3xOrgTeam>();
		for (Iterator<V3xOrgTeam> it = list.iterator(); it.hasNext();) {
			V3xOrgTeam team = (V3xOrgTeam) it.next();
			if (team.isValid()) {
				teamList.add(team);
			}
		}
		Collections.sort(teamList, CompareSortEntity.getInstance());
		return teamList;
	}

	@Override
	public V3xOrgAccount getAccountById(Long id) throws BusinessException {
		V3xOrgUnit unit = this.getEntityById(V3xOrgUnit.class, id);
		if(unit != null && (unit instanceof V3xOrgAccount)){
			return (V3xOrgAccount)unit;
		}

		return null;
	}

	@Override
  //客开 @CheckRoleAccess(roleTypes = { Role_NAME.GroupAdmin, Role_NAME.AccountAdministrator, Role_NAME.HrAdmin, Role_NAME.DepAdmin })
	public V3xOrgDepartment getDepartmentById(Long id) throws BusinessException {
		V3xOrgUnit unit = this.getEntityById(V3xOrgUnit.class, id);
		if(unit != null && (unit instanceof V3xOrgDepartment)){
			return (V3xOrgDepartment)unit;
		}

		return null;
	}
	
	// 客开
	public V3xOrgAccount getAccountByCode(String code) throws BusinessException{
		List<V3xOrgEntity> list = getEntityList(V3xOrgAccount.class.getSimpleName(), "code", code, null);
		 if (list != null && list.size() > 0) {
			 return (V3xOrgAccount) list.get(0);
		 }
		 
		return null;
	}
	
	public V3xOrgDepartment getDepartmentByCode(String code) throws BusinessException{
		List<V3xOrgEntity> list = getEntityList(V3xOrgDepartment.class.getSimpleName(), "code", code, null);
		 if (list != null && list.size() > 0) {
			 return (V3xOrgDepartment) list.get(0);
		 }
		 
		return null;
	}
	
	public V3xOrgMember getMemberByCode(String code) throws BusinessException{
		List<V3xOrgEntity> list = getEntityList(V3xOrgMember.class.getSimpleName(), "code", code, null);
		 if (list != null && list.size() > 0) {
			 return (V3xOrgMember) list.get(0);
		 }
		 
		return null;
	}
	

	@Override
	public V3xOrgUnit getUnitById(Long id) throws BusinessException {
		return getEntityById(V3xOrgUnit.class, id);
	}

	@Override
  //客开 @CheckRoleAccess(roleTypes = { Role_NAME.GroupAdmin, Role_NAME.AccountAdministrator, Role_NAME.HrAdmin, Role_NAME.DepAdmin })
	public V3xOrgLevel getLevelById(Long id) throws BusinessException {
		return getEntityById(V3xOrgLevel.class, id);
	}

    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin, Role_NAME.AccountAdministrator, Role_NAME.HrAdmin})
    public V3xOrgMember getMemberById(Long memberId) throws BusinessException {
        return this.getEntityById(V3xOrgMember.class, memberId);
    }

	@Override
	public V3xOrgMember getMemberByLoginName(String loginName) throws BusinessException {
		try{
			return getMemberById(principalManager.getMemberIdByLoginName(loginName));
		}
		catch (NoSuchPrincipalException e) {
			return null;
		}
	}

	@Override
  //客开 @CheckRoleAccess(roleTypes = { Role_NAME.GroupAdmin, Role_NAME.AccountAdministrator, Role_NAME.HrAdmin, Role_NAME.DepAdmin })
	public V3xOrgPost getPostById(Long id) throws BusinessException {
		return getEntityById(V3xOrgPost.class, id);
	}

	/**
	 * 获取组织的父组织
	 * @param orgunit
	 * @return
	 * @throws BusinessException
	 */
	 @Override
	 public V3xOrgUnit getParentUnit(V3xOrgUnit orgunit) throws BusinessException {
		if (orgunit == null) {
			return null;
		} else {
			return this.getUnitById(orgunit.getSuperior());
		}
	 }

	 /**
	  * 获取组织的父组织
	  * @param orgunit
	  * @return
	  * @throws BusinessException
	  */
	 @Override
  //客开 @CheckRoleAccess(roleTypes = { Role_NAME.GroupAdmin, Role_NAME.AccountAdministrator, Role_NAME.HrAdmin })
	 public V3xOrgUnit getParentUnitById(Long unitId) throws BusinessException {
		 if (unitId == null) {
			 return null;
		 } else {
			 V3xOrgUnit unit = orgCache.getV3xOrgEntity(V3xOrgUnit.class, unitId);
			 if(null == unit) {
				 return null;
			 }
			 return this.getUnitById(unit.getSuperior());

		 }
	 }

	 //只有系统预置角色采用使用名称
	 private V3xOrgRole getRoleByNameOrId(String roleNameOrId, Long accountId) throws BusinessException{
		 OrgConstants.Role_NAME systemRoleName = null;
		 try{
			 systemRoleName = OrgConstants.Role_NAME.valueOf(roleNameOrId);
		 }
		 catch(Exception e){
			 //ignore
		 }

		 if(systemRoleName != null){ //说明是系统预置角色
			 if(OrgConstants.Role_NAME.AccountAdministrator.name().equals(roleNameOrId)
					 || OrgConstants.Role_NAME.AuditAdmin.name().equals(roleNameOrId)
					 || OrgConstants.Role_NAME.GroupAdmin.name().equals(roleNameOrId)
					 || OrgConstants.Role_NAME.SystemAdmin.name().equals(roleNameOrId)) {
				 return this.getRoleByName(roleNameOrId, OrgConstants.GROUPID);
			 }
			 else {
				 return this.getRoleByName(roleNameOrId, accountId);
			 }
		 }
		 else{
			 return this.getRoleById(Long.parseLong(roleNameOrId));
		 }
	 }

	 @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.AccountAdministrator,Role_NAME.DepAdmin,Role_NAME.GroupAdmin,Role_NAME.HrAdmin})
	 public V3xOrgRole getRoleById(Long id) throws BusinessException {
		 V3xOrgRole role = (V3xOrgRole) orgCache.getV3xOrgEntity(V3xOrgRole.class, id);
		 if (role != null) {
			 return role;
		 } else {
			 return (V3xOrgRole) OrgHelper.poTobo(orgDao.getOrgRolePO(id));
		 }
	 }

	 @Override
	 public boolean checkRolePrefabricated(Long id)throws BusinessException {
		 V3xOrgRole role=this.getRoleById(id);
		 if(role!=null){
			 if(roleCodeList.contains(role.getCode())){
				 return true;
			 }
		 }
		 return false;
	 }

	 @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.AccountAdministrator,Role_NAME.DepAdmin})
	 public V3xOrgRole getRoleByName(String roleName, Long accountId) throws BusinessException {
		 List<V3xOrgRole> list = orgCache.getAllV3xOrgEntityNoClone(V3xOrgRole.class, null);
		 for (V3xOrgRole role : list) {
			 if(accountId != null && !role.getOrgAccountId().equals(accountId)){
				 continue;
			 }
			 if (roleName.equals(role.getName()) || roleName.equals(role.getCode())){
				 return OrgHelper.cloneEntity(role);
			 }
		 }

		 return null;
	 }

	 @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.AccountAdministrator,Role_NAME.DepAdmin})
	 public List<V3xOrgRole> getRoleByCode(String code, Long accountId) throws BusinessException {
		 List<V3xOrgRole> rolelist = new ArrayList<V3xOrgRole>();

		 List<V3xOrgRole> list = new ArrayList<V3xOrgRole>();
		 V3xOrgAccount account = this.getAccountById(accountId);
		 if (account != null && account.getExternalType() == OrgConstants.ExternalType.Interconnect3.ordinal()) {
			 //兼容V-Join角色
			 V3xOrgRole role = joinOrgManagerDirect.getRoleByCode(code, accountId);
			 if (role != null) {
				 list.add(role);
			 }
		 } else {
			 list = orgCache.getAllV3xOrgEntityNoClone(V3xOrgRole.class, null);
		 }

		 for (V3xOrgRole role : list) {
			 if(accountId != null && !role.getOrgAccountId().equals(accountId)){
				 continue;
			 }
			 if (code.equals(role.getCode())){
				 rolelist.add(role);
			 }
		 }

		 return rolelist;
	 }


	 @Override
	 public V3xOrgTeam getTeamById(Long id) throws BusinessException {
		 V3xOrgTeam team = (V3xOrgTeam) this.getEntityById(V3xOrgTeam.class, id);

		 if (team != null && team.isValid()){
			 initTeam(team);
		 }

		 return team;
	 }

	 private void initTeam(V3xOrgTeam team) throws BusinessException{
		 List<V3xOrgRelationship> ents = orgCache.getTeamMemberRelastionships(team.getId());
		 Collections.sort(ents, CompareSortRelationship.getInstance());

		 for (V3xOrgRelationship ent : ents) {
			 String type = ent.getObjective6Id();
			 String id = ent.getObjective0Id().toString();
			 boolean isValid = false;
			 if(OrgConstants.ORGENT_TYPE.Department_Post.name().equals(type)){
				 Long deptId = Long.valueOf(ent.getObjective0Id());
				 Long postId = Long.valueOf(ent.getObjective1Id());
				 V3xOrgEntity dept = orgCache.getV3xOrgEntityNoClone(OrgHelper.getV3xClass(OrgConstants.ORGENT_TYPE.Department.name()), deptId);
				 if (dept != null && dept.isValid()) {
					 V3xOrgEntity post = orgCache.getV3xOrgEntityNoClone(OrgHelper.getV3xClass(OrgConstants.ORGENT_TYPE.Post.name()), postId);
					 if (post != null && post.isValid()) {
						 isValid = true;
						 id = deptId+V3xOrgEntity.ROLE_ID_DELIMITER+postId;
					 }
				 }
			 }else{
				 V3xOrgEntity mem = orgCache.getV3xOrgEntityNoClone(OrgHelper.getV3xClass(ent.getObjective6Id()), ent.getObjective0Id());
				 if (mem != null && mem.isValid()) {
					 isValid = true;
				 }
			 }
			 if (isValid) {
				 OrgTypeIdBO typeIdBO = new OrgTypeIdBO();
				 typeIdBO.setId(id);
				 typeIdBO.setType(type);
				 typeIdBO.setInclude(ent.getObjective7Id());
				 team.addTeamMember(typeIdBO, OrgConstants.TeamMemberType.valueOf(ent.getObjective5Id()).ordinal());
			 }
		 }
	 }

	 private void initTeams(List<V3xOrgTeam> teams) throws BusinessException{
		 if(Strings.isEmpty(teams)){
			 return;
		 }

		 for (V3xOrgTeam team : teams) {
			 initTeam(team);
		 }
	 }

	 public List<V3xOrgMember> getMembersByDepartment(Long departmentId, boolean firtLayer) throws BusinessException {
		 return this.getMembersByDepartment(departmentId, firtLayer, null);
	 }

	 public List<V3xOrgMember> getMembersByLevel(Long levelId) throws BusinessException {
		 UniqueList<V3xOrgMember> memberList = new UniqueList<V3xOrgMember>();

		 V3xOrgLevel level = orgCache.getV3xOrgEntity(V3xOrgLevel.class, levelId);
		 if (level == null || !level.isValid()){
			 return memberList;
		 }

		 //考虑集团职务级别
		 if (null != getAccountById(level.getOrgAccountId()) && getAccountById(level.getOrgAccountId()).isGroup()) {
			 List<OrgLevel> levels = orgDao.getAllLevelPO(null, true, "groupLevelId", level.getId(), null);
			 for (OrgLevel orgLevel : levels) {
				 memberList.addAll(getMembersByLevel(orgLevel.getId()));
			 }

			 //throw new UnsupportedOperationException("暂无应用需求");
		 }
		 else {
			 EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
			 enummap.put(OrgConstants.RelationshipObjectiveName.objective2Id, levelId);

			 List<V3xOrgRelationship> ents = orgCache.getV3xOrgRelationship(RelationshipType.Member_Post, (Long)null, (Long)null, enummap);
			 Collections.sort(ents, CompareSortRelationship.getInstance());

			 for (V3xOrgRelationship ent : ents) {
				 if(!isValidMemberPost(ent)){
					 continue;
				 }
				 V3xOrgMember mem = (V3xOrgMember) orgCache.getV3xOrgEntity(V3xOrgMember.class, ent.getSourceId());
				 if (mem != null && mem.isValid()) {
					 memberList.add(mem);
				 }
			 }
		 }

		 return memberList;
	 }

	 @Override
	 public Boolean isDepAdminRole(Long userId, Long depId) throws BusinessException {
		 return isRole(userId, depId, OrgConstants.Role_NAME.DepAdmin.name());
	 }

	 @Override
	 public Map<Long, List<V3xOrgMember>> getConcurentPostByAccount(Long accountId) throws BusinessException {
		 Map<Long, List<V3xOrgMember>> cntMap = new HashMap<Long, List<V3xOrgMember>>();
		 OrgConstants.MemberPostType[] postType = new OrgConstants.MemberPostType[]{OrgConstants.MemberPostType.Concurrent};
		 List<V3xOrgRelationship> cntList = orgCache.getEntityConPostRelastionships(accountId, null, postType);

		 for (V3xOrgRelationship cnt : cntList) {
			 if(!isValidMemberPost(cnt)){
				 continue;
			 }
			 Long depId = cnt.getObjective0Id();

			 V3xOrgMember cntMember = orgCache.getV3xOrgEntity(V3xOrgMember.class, cnt.getSourceId());
			 if (cntMember != null && cntMember.isValid()) {
				 Strings.addToMap(cntMap, depId, cntMember);
			 }
		 }

		 return cntMap;
	 }

	 @Override
	 public List<MemberPost> getAllConcurrentPostByAccount(Long accountId) throws BusinessException {
		 OrgConstants.MemberPostType[] postType = new OrgConstants.MemberPostType[]{OrgConstants.MemberPostType.Concurrent};
		 List<V3xOrgRelationship> rels = orgCache.getEntityConPostRelastionships(accountId, null, postType);

		 List<MemberPost> Concurrents = new ArrayList<MemberPost>();
		 if(!Strings.isEmpty(rels)){
			 for (V3xOrgRelationship o : rels) {
				 if(isValidMemberPost(o)){
					 Concurrents.add(new MemberPost(o));
				 }
			 }
		 }

		 return Concurrents;
	 }

	 @Override
	 public List<MemberPost> getAllConcurrentPostBydepartment(Long departmentId) throws BusinessException {
		 List<MemberPost> Concurrents = new ArrayList<MemberPost>();
		 V3xOrgDepartment  department = this.getDepartmentById(departmentId);
		 if(department == null){
			 return Concurrents;
		 }

		 OrgConstants.MemberPostType[] postType = new OrgConstants.MemberPostType[]{OrgConstants.MemberPostType.Concurrent};
		 List<V3xOrgRelationship> rels = orgCache.getEntityConPostRelastionships(department.getOrgAccountId(), departmentId, postType);
		 if(!Strings.isEmpty(rels)){
			 for (V3xOrgRelationship o : rels) {
				 if(isValidMemberPost(o)){
					 Concurrents.add(new MemberPost(o));
				 }
			 }
		 }

		 return Concurrents;
	 }

	 @Override
	 public V3xOrgAccount getAccountByName(String accountName) throws BusinessException {
		 List<V3xOrgEntity> list = getEntityList(V3xOrgAccount.class.getSimpleName(), "name", accountName, null);
		 if (list != null && list.size() > 0) {
			 return (V3xOrgAccount) list.get(0);
		 }

		 return null;
	 }

	 public List<V3xOrgDepartment> getDepartmentsByName(String deptName, Long accountId) throws BusinessException {
		 return this.getEntitiesByNameWithCache(V3xOrgDepartment.class, deptName, accountId);
	 }

	 @Override
	 public List<V3xOrgTeam> getTeamsByName(String teamName, Long accountId) throws BusinessException {
		 return this.getEntitiesByNameWithCache(V3xOrgTeam.class, teamName, accountId);
	 }

	 @Override
	 public List<V3xOrgRole> getDepartmentRolesByAccount(Long accountID) throws BusinessException {
		 List<V3xOrgRole> accountRolesList = getAllRoles(accountID);
		 List<V3xOrgRole> list = new ArrayList<V3xOrgRole>();
		 for (V3xOrgRole role : accountRolesList) {
			 if (OrgConstants.ROLE_BOND.DEPARTMENT.ordinal() == role.getBond()) {
				 list.add(role);
			 }
		 }
		 return list;

	 }

	 @Override
	 public List<V3xOrgRole> getDepartmentRolesWithoutDepLeaderByAccount(Long accountID) throws BusinessException {
		 List<V3xOrgRole> accountRolesList = getAllRoles(accountID);
		 List<V3xOrgRole> list = new ArrayList<V3xOrgRole>();
		 for (V3xOrgRole role : accountRolesList) {
			 if (OrgConstants.ROLE_BOND.DEPARTMENT.ordinal() == role.getBond()
					 && !OrgConstants.Role_NAME.DepLeader.name().equals(role.getCode())) {
				 list.add(role);
			 }
		 }
		 return list;

	 }

	 @Override
	 public V3xOrgLevel getErrorMapLevel(Long accountId, Integer levelId, Integer groupLevelId) throws BusinessException {
		 List<V3xOrgLevel> levelList = getAllLevels(accountId);
		 int groupLevel = V3xOrgEntity.MAX_LEVEL_NUM;
		 if (groupLevelId != null) {
			 groupLevel = groupLevelId.intValue();
		 }
		 int levelIdInt = levelId.intValue();
		 for (V3xOrgLevel level : levelList) {
			 int levelIt = level.getLevelId().intValue();
			 int grouplevelIt = V3xOrgEntity.MAX_LEVEL_NUM;
			 if (level.getGroupLevelId() != null) {
				 V3xOrgLevel orgGroupLevelIt = getLevelById(level.getGroupLevelId());
				 if (orgGroupLevelIt != null) {
					 grouplevelIt = orgGroupLevelIt.getLevelId().intValue();
				 }
			 }
			 if (levelIt > levelIdInt && groupLevel > grouplevelIt) {
				 return level;
			 } else if (levelIt < levelIdInt && groupLevel < grouplevelIt) {
				 return level;
			 }
		 }
		 return null;
	 }

	 public List<V3xOrgUnit> getGroupByMemberAndRole(Long memberId, Long roleId) throws BusinessException {
		 List<V3xOrgUnit> ents = new ArrayList<V3xOrgUnit>();
		 List<Long> entityIds = this.getDomainByRole(roleId, memberId);
		 if (entityIds != null && entityIds.size() > 0) {
			 for (Long id : entityIds) {
				 V3xOrgUnit ent = orgCache.getV3xOrgEntity(V3xOrgUnit.class, id);
				 if (ent != null && ent.isValid()) {
					 ents.add(ent);
				 }
			 }
		 }
		 return ents;
	 }

	 @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.DepAdmin})
	 public V3xOrgLevel getLowestLevel(Long accountId) throws BusinessException {
		 List<V3xOrgLevel> levels = getAllLevels(accountId);
		 V3xOrgLevel low = null;
		 for (V3xOrgLevel level : levels) {
			 if (level.isValid()) {
				 if (low != null) {
					 if (level.getLevelId() > low.getLevelId()) {
						 low = level;
					 }
				 } else {
					 low = level;
				 }
			 }
		 }
		 return low;
	 }

	 public List<V3xOrgMember> getMembersByDepartment(Long departmentId, boolean firtLayer, OrgConstants.MemberPostType type) throws BusinessException {
		 V3xOrgDepartment dep = getDepartmentById(departmentId);
		 if (dep == null) {
			 return Collections.emptyList();
		 }

		 //考虑外部部门
		 if (!dep.getIsInternal()) {
			 if (dep.getExternalType() == OrgConstants.ExternalType.Inner.ordinal()) {
				 return getExtMembersByDepartment(departmentId, firtLayer);
			 } else {//V-Join流程节点匹配
				 if(dep.getExternalType()==OrgConstants.ExternalType.Interconnect1.ordinal()){
					 return joinOrgManagerDirect.getMembersByDepartment(departmentId, false);
				 }else{
					 return joinOrgManagerDirect.getMembersByDepartment(departmentId, firtLayer);
				 }
			 }
		 } else {
			 List<V3xOrgMember> memberList = new UniqueList<V3xOrgMember>();

			 List<Long> deptIds = new UniqueList<Long>();
			 if (!firtLayer){
				 //List<V3xOrgDepartment> deps = getChildDepartments(departmentId, firtLayer);
				 deptIds = this.orgCache.getSubDeptList(departmentId,"2");
			 }

			 deptIds.add(departmentId);

			 //List<V3xOrgRelationship> rels = orgCache.getV3xOrgRelationship(OrgConstants.RelationshipType.Member_Post);
			 OrgConstants.MemberPostType[] postType = null;
			 if(null!=type){ //只取兼职单位
				 postType = new OrgConstants.MemberPostType[]{type};
			 }
			 List<V3xOrgRelationship> rels = orgCache.getDepartmentRelastionships(deptIds,postType);

			 for (V3xOrgRelationship rel : rels) {     
				 if(!isValidMemberPost(rel)){
					 continue;
				 }
				 V3xOrgMember member = orgCache.getV3xOrgEntityNoClone(V3xOrgMember.class, rel.getSourceId());
				 
				 if (member != null && member.isValid() && member.getIsInternal() && !member.getIsAdmin()) {
					 /**
					  * 项目  信达资产   公司  kimde  修改人  陈岩   修改时间    2017-12-01   修改功能  通讯录中领导的信息需要有权限才可以查看  start 
					  */
					 Long memberId = member.getId();
					 Long orgAccountId = member.getOrgAccountId(); 
					 String officeHouseNum = member.getOfficeHouseNum();
					 //敏感信息隐藏角色
					 String tongxunlu_minganjuese = (String) PropertiesUtils.getInstance().get("tongxunlu_minganjuese");
					 boolean flag =this.hasSpecificRole(memberId, orgAccountId, tongxunlu_minganjuese);
					 /**
					  * 项目  信达资产   公司  kimde  修改人  陈岩   修改时间    2017-12-01   修改功能  通讯录中领导的信息需要有权限才可以查看  end 
					  */
					 V3xOrgMember newMember = OrgHelper.cloneEntityImmutableDecorator(member);
					 if(!member.getOrgAccountId().equals(rel.getOrgAccountId())){
                        newMember.setSortId(rel.getSortId());
                     }
					 /**
					  * 项目  信达资产   公司  kimde  修改人  陈岩   修改时间    2017-12-01   修改功能  通讯录中领导的信息需要有权限才可以查看  start 
					  */
					 newMember.setIsLeader(flag);
					 newMember.setOfficeHouseNum(officeHouseNum);
					 /**
					  * 项目  信达资产   公司  kimde  修改人  陈岩   修改时间    2017-12-01   修改功能  通讯录中领导的信息需要有权限才可以查看  end 
					  */
					 if(!memberList.contains(newMember)){
                        memberList.add(newMember);
                    }
				 }
			 }

			 Collections.sort(memberList, CompareSortEntity.getInstance());

			 return memberList;
		 }
	 }

	 @Override
	 public boolean isGroupLevelMapRight(Long accountId, Integer levelId, Integer groupLevelId) throws BusinessException {
		 List<V3xOrgLevel> levelList = getAllLevels(accountId);
		 int groupLevel = V3xOrgEntity.MAX_LEVEL_NUM;
		 if (groupLevelId != null) {
			 groupLevel = groupLevelId.intValue();
		 }
		 int levelIdInt = levelId.intValue();
		 for (V3xOrgLevel level : levelList) {
			 int levelIt = level.getLevelId().intValue();
			 int grouplevelIt = V3xOrgEntity.MAX_LEVEL_NUM;
			 if (level.getGroupLevelId() != null) {
				 V3xOrgLevel orgGroupLevelIt = getLevelById(level.getGroupLevelId());
				 if (orgGroupLevelIt != null) {
					 grouplevelIt = orgGroupLevelIt.getLevelId().intValue();
				 }
			 }
			 if (levelIt > levelIdInt && groupLevel > grouplevelIt) {
				 return false;
			 } else if (levelIt < levelIdInt && groupLevel < grouplevelIt) {
				 return false;
			 }
		 }
		 return true;
	 }

	 @Override
	 public List<V3xOrgMember> getAllMembersWithOuter(Long accountId) throws BusinessException {
		 List<V3xOrgMember> memberList = new UniqueList<V3xOrgMember>();
		 boolean isVirtual = V3xOrgEntity.VIRTUAL_ACCOUNT_ID.equals(accountId);

		 // 需要获得整个系统的人员
		 if (isVirtual) {
			 return orgCache.getAllV3xOrgEntity(V3xOrgMember.class, null);
		 }

		 V3xOrgAccount account = this.getAccountById(accountId);
		 if(account == null){
			 return memberList;
		 }

		 List<V3xOrgAccount> accounts = new ArrayList<V3xOrgAccount>();

		 //如果是集团，取集团内的所有人员
		 if (account.isGroup()) {
			 accounts = getChildAccount(accountId, false);
		 }

		 accounts.add(account);

		 List<Long> accountIds = new ArrayList<Long>();
		 for (V3xOrgAccount a : accounts) {
			 accountIds.add(a.getId());
		 }


		 List<OrgRelationship> relsPo = orgDao.getOrgRelationshipPOByAccountsAndMembers(OrgConstants.RelationshipType.Member_Post, null, accountIds, null, null);
		 Collections.sort(relsPo, CompareSortRelationship.getInstance2());

		 List<V3xOrgMember> allMembers = orgCache.getAllV3xOrgEntityNoClone(V3xOrgMember.class, null);
		 Map<Long, V3xOrgMember> allMemberMap = new HashMap<Long, V3xOrgMember>();
		 for (V3xOrgMember m : allMembers) {
			 allMemberMap.put(m.getId(), m);
		 }

		 for (OrgRelationship rel : relsPo) {
			 if(!isValidMemberPost(rel)){
				 continue;
			 }
			 V3xOrgMember member = allMemberMap.get(rel.getSourceId());
			 if (member != null && member.isValid() && !member.getIsAdmin()) {
				 memberList.add(OrgHelper.cloneEntity(member));
			 }
		 }

		 return memberList;
	 }

	 @Override
	 public List<V3xOrgMember> getAllMembers(Long accountId) throws BusinessException {
		 List<V3xOrgMember> memberList = new UniqueList<V3xOrgMember>();
		 boolean isVirtual = V3xOrgEntity.VIRTUAL_ACCOUNT_ID.equals(accountId);

		 // 需要获得整个系统的人员
		 if (isVirtual) {
			 List<V3xOrgMember> members = orgCache.getAllV3xOrgEntityNoClone(V3xOrgMember.class, null);
			 for (V3xOrgMember member : members) {
				 if (member != null && member.isValid() && !member.getIsAdmin()) {
					 memberList.add(OrgHelper.cloneEntityImmutableDecorator(member));
				 }
			 }

			 Collections.sort(memberList, CompareSortEntity.getInstance());
			 return memberList;
		 }

		 V3xOrgAccount account = this.getAccountById(accountId);
		 if(account == null){
			 return memberList;
		 }

		 if(account.getExternalType().equals(OrgConstants.ExternalType.Interconnect3.ordinal())){
			 joinOrgManagerDirect.getAllMembers(accountId, true, null, null);
		 }

		 HashSet<Long> accountIds = new HashSet<Long>();
		 accountIds.add(account.getId());

		 //如果是集团，取集团内的所有人员
		 if (account.isGroup()) {
			 List<V3xOrgAccount> accounts = getChildAccount(accountId, false);
			 for (V3xOrgAccount a : accounts) {
				 accountIds.add(a.getId());
			 }
		 }

		 List<V3xOrgRelationship> rels = orgCache.getV3xOrgRelationship(OrgConstants.RelationshipType.Member_Post);

		 for (V3xOrgRelationship rel : rels) {
			 if(!accountIds.contains(rel.getOrgAccountId()) || !isValidMemberPost(rel)){
				 continue;
			 }

			 //如果是副岗，直接跳过，单位下只取主岗和兼职的信息
			 if(OrgConstants.MemberPostType.Second.name().equals(rel.getObjective5Id())){
				 continue;
			 }

			 V3xOrgMember member = orgCache.getV3xOrgEntityNoClone(V3xOrgMember.class, rel.getSourceId());
			 if (member != null && member.isValid() && member.getIsInternal() && !member.getIsAdmin()) {
				 if(memberList.contains(member)){
					 continue;
				 }
				 /**
				  * 项目  信达资产   公司  kimde  修改人  陈岩   修改时间    2017-11-17   修改功能  通讯录中领导的信息需要有权限才可以查看  start 
				  */
				 Long memberId = member.getId();
				 Long orgAccountId = member.getOrgAccountId(); 
				//敏感信息隐藏角色
				 String tongxunlu_minganjuese = (String) PropertiesUtils.getInstance().get("tongxunlu_minganjuese");
				 boolean flag =this.hasSpecificRole(memberId, orgAccountId, tongxunlu_minganjuese);
				 /**
				  * 项目  信达资产   公司  kimde  修改人  陈岩   修改时间    2017-11-17   修改功能  通讯录中领导的信息需要有权限才可以查看  end 
				  */

				 V3xOrgMember newMember = OrgHelper.cloneEntityImmutableDecorator(member);
				 /**
				  * 项目  信达资产   公司  kimde  修改人  陈岩   修改时间    2017-11-14   修改功能  通讯录列表增加办公室门牌号  start 
				  */
				 newMember.setOfficeHouseNum(member.getOfficeHouseNum());
				 /**
				  * 项目  信达资产   公司  kimde  修改人  陈岩   修改时间    2017-11-14   修改功能  通讯录列表增加办公室门牌号  end 
				  */

				 /**
				  * 项目  信达资产   公司  kimde  修改人  陈岩   修改时间    2017-11-17   修改功能  通讯录中领导的信息需要有权限才可以查看  start 
				  */
				 newMember.setIsLeader(flag);
				 /**
				  * 项目  信达资产   公司  kimde  修改人  陈岩   修改时间    2017-11-17   修改功能  通讯录中领导的信息需要有权限才可以查看  end 
				  */
				 if(OrgConstants.MemberPostType.Concurrent.name().equals(rel.getObjective5Id())){
					 newMember.setSortId(rel.getSortId());
				 }
				 memberList.add(newMember);
			 }
		 }

		 Collections.sort(memberList, CompareSortEntity.getInstance());

		 return memberList;
	 }

	 public Map<String, V3xOrgMember> getMemberNamesMap(Long accountId) throws BusinessException {
		 return getMemberNamesMap(accountId, OrgConstants.ExternalType.Inner.ordinal());
	 }

	 public Map<String, V3xOrgMember> getMemberNamesMap(Long accountId, Integer externalType) throws BusinessException {
		 String key = "MemberName_" + accountId;

		 Map<String, V3xOrgMember> result = (Map<String, V3xOrgMember>)AppContext.getThreadContext(key);
		 if(result != null) {
			 return result;
		 }
		 else{
			 result = new HashMap<String, V3xOrgMember>();
			 AppContext.putThreadContext(key, result);
		 }

		 List<V3xOrgMember> members = orgCache.getAllV3xOrgEntityNoClone(V3xOrgMember.class, null, externalType);
        Set<String> repeatNames = new HashSet<String>();
		 for (V3xOrgMember m : members) {
			 if(m == null || !m.isValid() || m.getIsAdmin()){
				 continue;
			 }

			 if(V3xOrgEntity.VIRTUAL_ACCOUNT_ID.equals(accountId)){ //全系统，都保留
				 //ingore
			 }
			 else if(accountId != null && !Strings.equals(m.getOrgAccountId(), accountId)){ //不是同一个单位的，不要
				 continue;
			 }

			 String name = m.getName();
			 String code = m.getCode();
			 String loginName = m.getLoginName();

			 V3xOrgMember privM = result.get(name);
			 if(privM != null && Strings.equals(privM.getId(), m.getId())){ //同一人
				 continue;
			 }

			 m = OrgHelper.cloneEntityImmutableDecorator(m);

			 if(privM != null && !Strings.equals(privM.getId(), m.getId())){ //存在同名人员，去掉姓名的key，留下code、loginName
				 result.remove(name);
                repeatNames.add(name);
            }
            else if(repeatNames.contains(name)){
            	//存在重名的，不加入。
            }else{ //不存在重名的
                result.put(name, m);
            }
            
            if(Strings.isNotBlank(code)){
                result.put(name + "(" + code + ")", m);
            }
            
            if(Strings.isNotBlank(loginName)){
                result.put(name + "(" + loginName + ")", m);
            }
        }
        
        return result;
    }

	 /**
	  * 判断是否是有效的人员岗位：<br>
	  * 1. 主岗、兼职：部门、岗位、职务级别都必须填写<br>
	  * 2. 副岗：部门必须填写<br>
	  * @param rel
	  * @return
	  */
	 private boolean isValidMemberPost(V3xOrgRelationship rel){
		 /**
        this.depId = rel.getObjective0Id();
        this.postId = rel.getObjective1Id();
        this.levelId = rel.getObjective2Id();
		  */
		 return isValidMemberPost(rel.getObjective0Id(), rel.getObjective1Id(), rel.getObjective5Id());
	 }

	 private boolean isValidMemberPost(OrgRelationship rel){
		 return isValidMemberPost(rel.getObjective0Id(), rel.getObjective1Id(), rel.getObjective5Id());
	 }

	 private boolean isValidMemberPost(Long objective0Id, Long objective1Id, String objective5Id){
		 if(Strings.equals(objective5Id, MemberPostType.Concurrent.name()) || Strings.equals(objective5Id, MemberPostType.Main.name())){
			 return objective0Id != null && !Strings.equals(objective0Id, -1L)
			 && objective1Id != null;// && !Strings.equals(rel.getObjective1Id(), -1L)//这里注释掉的原因，由于NC同步过来没有主岗的人员他的主岗ID为-1，这个关系就会有问题
			 //OA-75876 客户bug回测：未设置兼职职务级别，在兼职单位通讯录中看不到兼职人员信息
			 //&& rel.getObjective2Id() != null;// && !Strings.equals(rel.getObjective2Id(), -1L);
		 }
		 else if(Strings.equals(objective5Id, MemberPostType.Second.name())){
			 return objective0Id != null && !Strings.equals(objective0Id, -1L);
		 }

		 return false;
	 }
	 
	 public boolean isValidMemberPost12(Long objective0Id, Long objective1Id, String objective5Id){
		 if(Strings.equals(objective5Id, MemberPostType.Concurrent.name()) || Strings.equals(objective5Id, MemberPostType.Main.name())){
			 return objective0Id != null && !Strings.equals(objective0Id, -1L)
			 && objective1Id != null;// && !Strings.equals(rel.getObjective1Id(), -1L)//这里注释掉的原因，由于NC同步过来没有主岗的人员他的主岗ID为-1，这个关系就会有问题
			 //OA-75876 客户bug回测：未设置兼职职务级别，在兼职单位通讯录中看不到兼职人员信息
			 //&& rel.getObjective2Id() != null;// && !Strings.equals(rel.getObjective2Id(), -1L);
		 }
		 else if(Strings.equals(objective5Id, MemberPostType.Second.name())){
			 return objective0Id != null && !Strings.equals(objective0Id, -1L);
		 }

		 return false;
	 }
	

	 /**
	  * 判断是否是有效的兼职岗位：<br>
	  * 1. 主岗、兼职：部门、岗位都必须填写<br>
	  * 2. 不必有职务级别<br>
	  * OA-54076
	  * @param rel
	  * @return
	  */
	 private boolean isValidMemberPost4ConPost(V3xOrgRelationship rel){
		 if(Strings.equals(rel.getObjective5Id(), MemberPostType.Concurrent.name()) || Strings.equals(rel.getObjective5Id(), MemberPostType.Main.name())){
			 return rel.getObjective0Id() != null && !Strings.equals(rel.getObjective0Id(), -1L)
			 && rel.getObjective1Id() != null;// && !Strings.equals(rel.getObjective1Id(), -1L)//这里注释掉的原因，由于NC同步过来没有主岗的人员他的主岗ID为-1，这个关系就会有问题
			 //&& rel.getObjective2Id() != null;// && !Strings.equals(rel.getObjective2Id(), -1L);
		 }
		 return false;
	 }

	 @Override
	 public List<V3xOrgMember> getAllMembersWithOutConcurrent(Long accountId) throws BusinessException {
		 List<V3xOrgMember> memberList = new UniqueList<V3xOrgMember>();
		 boolean isVirtual = V3xOrgEntity.VIRTUAL_ACCOUNT_ID.equals(accountId);

		 // 需要获得整个系统的人员
		 if (isVirtual) {
			 return orgCache.getAllV3xOrgEntity(V3xOrgMember.class, null);
		 }

		 V3xOrgAccount account = this.getAccountById(accountId);
		 if(account == null){
			 return memberList;
		 }

		 List<V3xOrgAccount> accounts = new ArrayList<V3xOrgAccount>();

		 //如果是集团，取集团内的所有人员
		 if (account.isGroup()) {
			 accounts = getChildAccount(accountId, false);
		 }

		 accounts.add(account);

		 List<Long> accountIds = new ArrayList<Long>();
		 for (V3xOrgAccount a : accounts) {
			 accountIds.add(a.getId());
		 }
		 for (Long long1 : accountIds) {
			 memberList.addAll(getAllMembersByAccountId(long1, null, null, true, "admin", false, null));
		 }
		 //        List<V3xOrgRelationship> rels = orgCache.getV3xOrgRelationship(OrgConstants.RelationshipType.Member_Post, null, accountIds, null);
		 //        Collections.sort(rels, CompareSortRelationship.getInstance());
		 //
		 //        for (V3xOrgRelationship rel : rels) {
		 //            V3xOrgMember member = orgCache.getV3xOrgEntity(V3xOrgMember.class, rel.getSourceId());
		 //            if (member != null && member.isValid() && member.getIsInternal() && !member.getIsAdmin()) {
		 //                memberList.add(member);
		 //            }
		 //        }
		 //        for (V3xOrgMember member : memberList) {
		 //        	if(member.getIsAdmin()){
		 //        		memberList.remove(member);
		 //        	}
		 //
		 //		}

		 return memberList;
	 }
	 @Override
	 public Integer getAllMembersNumsWithOutConcurrent(Long accountId) throws BusinessException {
		 boolean isVirtual = V3xOrgEntity.VIRTUAL_ACCOUNT_ID.equals(accountId);
		 Integer nums = 0;
		 // 需要获得整个系统的人员
		 if (isVirtual) {
			 return orgCache.getAllV3xOrgEntity(V3xOrgMember.class, null).size();
		 }

		 V3xOrgAccount account = this.getAccountById(accountId);
		 if(account == null){
			 return 0;
		 }

		 List<V3xOrgAccount> accounts = new ArrayList<V3xOrgAccount>();

		 //如果是集团，取集团内的所有人员
		 if (account.isGroup()) {
			 accounts = getChildAccount(accountId, false);
		 }

		 accounts.add(account);

		 List<Long> accountIds = new ArrayList<Long>();
		 for (V3xOrgAccount a : accounts) {
			 accountIds.add(a.getId());
		 }
		 for (Long long1 : accountIds) {
			 //OA-48188 产品经理季宏利确认，全部人员不包括外部人员
			 nums+=getAllMembersNumsByAccountId(long1, null, true, true, "admin", false);
		 }


		 return nums;
	 }
	 @Override
	 public List<V3xOrgMember> getAllMembers(Long accountId,boolean includeChildAcc) throws BusinessException {
		 List<V3xOrgMember> memberList = new UniqueList<V3xOrgMember>();
		 if(!includeChildAcc){
			 return getAllMembers(accountId);
		 }else if(includeChildAcc){
			 memberList = getAllMembers(accountId);
			 List<V3xOrgAccount> acclist = getChildAccount(accountId, false);
			 for (V3xOrgAccount v3xOrgAccount : acclist) {
				 memberList.addAll(getAllMembers(v3xOrgAccount.getId()));
			 }
		 }
		 return memberList;
	 }

	 @Override
	 public List<V3xOrgMember> getMembersByPost(Long postId) throws BusinessException {

		 return this.getMembersByPost(postId, null);
	 }
	 @Override
	 public boolean checkLevelScope(Long memberID1,Long memberID2) throws BusinessException {
		 return OrgHelper.checkLevelScope(memberID1, memberID2);
	 }
	 /**
	  * 得到标准岗下的单位岗
	  * @param postId 标准岗，如果不是标准岗，则返回自己
	  * @param accountId 需要查询的指定单位，可以为null，表示所有引用的单位
	  * @return
	  */
	 private List<Long> getAccountPostByBachmarkPost(Long postId, Long accountId) throws BusinessException {
		 V3xOrgPost post = orgCache.getV3xOrgEntity(V3xOrgPost.class, postId);
		 if(null == post) {
			 logger.error("得到标准岗下的单位岗接口异常，从缓存中获取岗位为空，岗位ID为"+postId);
			 return Collections.emptyList();
		 }
		 if(V3xOrgEntity.VIRTUAL_ACCOUNT_ID.equals(accountId) || OrgConstants.GROUPID.equals(accountId)) {
			 accountId = null;
		 }
		 List<Long> postIds = new ArrayList<Long>();
		 if (this.getAccountById(post.getOrgAccountId()).isGroup()) {
			 //如果是基准岗,取得所有和基准岗关联的岗位
			 EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
			 enummap.put(OrgConstants.RelationshipObjectiveName.objective0Id, post.getId());

			 List<V3xOrgRelationship> rels = orgCache.getV3xOrgRelationship(OrgConstants.RelationshipType.Banchmark_Post, null, accountId, enummap);
			 for (V3xOrgRelationship rel : rels) {
				 postIds.add(rel.getSourceId());
			 }
		 }
		 else {
			 postIds.add(postId);
		 }

		 return postIds;
	 }

	 @Override
	 public List<V3xOrgMember> getMembersByPost(Long postId, Long accountId) throws BusinessException {
		 V3xOrgPost post = orgCache.getV3xOrgEntityNoClone(V3xOrgPost.class, postId);

		 List<V3xOrgMember> memberList = new UniqueList<V3xOrgMember>();

		 if (post == null || !post.isValid()){
			 return memberList;
		 }

		 if(post.getExternalType() != OrgConstants.ExternalType.Inner.ordinal()){
			 return joinOrgManagerDirect.getMembersByPost(postId, null);
		 }

		 List<Long> postIds = getAccountPostByBachmarkPost(postId, accountId);
		 if(postIds.isEmpty()){
			 return memberList;
		 }

		 EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
		 enummap.put(OrgConstants.RelationshipObjectiveName.objective1Id, postIds);

		 List<V3xOrgRelationship> ents = orgCache.getV3xOrgRelationship(RelationshipType.Member_Post, (Long)null, (Long)null, enummap);

		 Collections.sort(ents, CompareSortRelationship.getInstance());

		 for (V3xOrgRelationship ent : ents) {
			 if(!isValidMemberPost(ent)){
				 continue;
			 }
			 V3xOrgMember mem = (V3xOrgMember) orgCache.getV3xOrgEntityNoClone(V3xOrgMember.class, ent.getSourceId());
			 if (mem != null && mem.isValid()) {
				 memberList.add(OrgHelper.cloneEntityImmutableDecorator(mem));
			 }
		 }

		 return memberList;
	 }

	 @Override
	 public List<V3xOrgMember> getMembersByPost4Access(Long postId, Long accountId) throws BusinessException {
		 V3xOrgPost post = orgCache.getV3xOrgEntity(V3xOrgPost.class, postId);

		 List<V3xOrgMember> memberList = new UniqueList<V3xOrgMember>();

		 List<Long> accountIds = null;
		 List<V3xOrgAccount> accessAccounts = this.accessableAccountsByUnitId(accountId);
		 if (!accessAccounts.isEmpty()) {
			 accountIds = new ArrayList<Long>();
			 for (V3xOrgAccount a : accessAccounts) {
				 accountIds.add(a.getId());
			 }
		 }

		 if (post == null || !post.isValid()) {
			 return memberList;
		 }

		 List<Long> postIds = getAccountPostByBachmarkPost(postId, null);
		 if (postIds.isEmpty()) {
			 return memberList;
		 }

		 EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
		 enummap.put(OrgConstants.RelationshipObjectiveName.objective1Id, postIds);

		 List<V3xOrgRelationship> ents = orgCache.getV3xOrgRelationship(OrgConstants.RelationshipType.Member_Post, null, accountIds, enummap);

		 Collections.sort(ents, CompareSortRelationship.getInstance());

		 for (V3xOrgRelationship ent : ents) {
			 if (!isValidMemberPost(ent)) {
				 continue;
			 }
			 V3xOrgMember mem = (V3xOrgMember) orgCache.getV3xOrgEntity(V3xOrgMember.class, ent.getSourceId());
			 if (mem != null && mem.isValid()) {
				 memberList.add(OrgHelper.cloneEntityImmutableDecorator(mem));
			 }
		 }

		 return memberList;
	 }

	 @Override
	 public List<MemberRole> getMemberRoles(Long memberId, Long unitId) throws BusinessException {
		 List<MemberRole> result = new UniqueList<MemberRole>();

		 List<V3xOrgRelationship> relList = getEntityRoleRelastionshipsByMember(memberId, unitId);

		 for (V3xOrgRelationship rel : relList) {
			 V3xOrgRole role = orgCache.getV3xOrgEntity(V3xOrgRole.class, rel.getObjective1Id());
			 if(role == null || !role.isValid()){
				 continue;
			 }

			 V3xOrgUnit dept = this.orgCache.getV3xOrgEntity(V3xOrgUnit.class, rel.getObjective0Id());
			 if(dept == null || !dept.isValid()){
				 continue;
			 }

			 MemberRole mr = new MemberRole();
			 //此处的memberid放置实体的ID
			 mr.setMemberId(rel.getSourceId());
			 if(dept.getType().equals(OrgConstants.UnitType.Department)){
				 mr.setDepartment((V3xOrgDepartment)dept);
			 }
			 mr.setRole(role);
			 mr.setAccountId(rel.getOrgAccountId());

			 result.add(mr);
		 }

		 //TODO 没有排序, 是否要排序再确定

		 return result;
	 }

	 @Override
	 public List<V3xOrgAccount> getAllAccounts() throws BusinessException{
		 List<V3xOrgAccount> allAccounts = orgCache.getAllAccounts();
		 Collections.sort(allAccounts, CompareSortEntity.getInstance());
		 return allAccounts;
	 }

	 @Override
	 public List<V3xOrgDepartment> getChildDeptsByAccountId(Long accountId, boolean firtLayer) throws BusinessException {
		 V3xOrgAccount currentAccount = orgCache.getV3xOrgEntity(V3xOrgAccount.class, accountId);
		 if (!firtLayer) {
			 return orgCache.getChildDeptByAccountId(accountId);
		 } else {
			 List<V3xOrgDepartment> depts = new ArrayList<V3xOrgDepartment>();
			 List<V3xOrgDepartment> deptList = orgCache.getChildDeptByAccountId(accountId);
			 for (V3xOrgDepartment o : deptList) {
				 if (o.getParentPath().equals(currentAccount.getPath())) {
					 depts.add(o);
				 } else {
					 continue;
				 }
			 }
			 return depts;
		 }
	 }

	 public List<V3xOrgEntity> findModifyEntity(final String entityClassName, final java.util.Date dateTime) throws BusinessException {
		 //TODO
		 return null;
	 }

	 @Override
	 public List<V3xOrgPost> getDepartmentPost(Long departmentId) throws BusinessException {
		 List<V3xOrgPost> postlist = new ArrayList<V3xOrgPost>();
		 List<V3xOrgRelationship> rellist = this.getV3xOrgRelationship(OrgConstants.RelationshipType.Department_Post, departmentId, null, null);
		 for (V3xOrgRelationship orgRelationship : rellist) {
			 V3xOrgPost post = this.getPostById(orgRelationship.getObjective0Id());
			 if(null == post) {
				 continue;
			 }
			 postlist.add(post);
		 }

		 Collections.sort(postlist, CompareSortEntity.getInstance());

		 return postlist;
	 }

	 @Override
	 public V3xOrgRelationship getV3xOrgRelationshipById(Long id) {
		 return orgCache.getV3xOrgRelationshipById(id);
	 }

	 @Override
	 @Deprecated
	 public List<V3xOrgRelationship> getV3xOrgRelationship(RelationshipType type, Long sourceId, Long accountId,
			 EnumMap<RelationshipObjectiveName, Object> objectiveIds) throws BusinessException {
		 return orgCache.getV3xOrgRelationship(type, sourceId, accountId, objectiveIds);
	 }

	 @Override
	 public boolean isInDomain(Long groupId, Long entId, Long userId) throws BusinessException {
		 // TODO Auto-generated method stub
		 return false;
	 }

	 @Override
	 public boolean isInDomain(Long groupId, Long entId, Long userId, Long accountId) throws BusinessException {
		 // TODO Auto-generated method stub
		 return false;
	 }

	 @Override
	 public boolean isInDomain(Long entId, Long userId) throws BusinessException {
		 // TODO Auto-generated method stub
		 return false;
	 }

	 @Override
	 public boolean isInDomainByAccount(Long entId, Long userId, Long accountId) throws BusinessException {
		 // TODO Auto-generated method stub
		 return false;
	 }

	 @Override
	 public List<V3xOrgMember> getMemberByIndistinctName(String indistinctName) throws BusinessException {
		 if (Strings.isBlank(indistinctName)){
			 return Collections.emptyList();
		 }

		 indistinctName = indistinctName.toLowerCase();

		 List<V3xOrgMember> memberList = new ArrayList<V3xOrgMember>();
		 List<V3xOrgMember> list = orgCache.getAllV3xOrgEntityNoClone(V3xOrgMember.class, null);

		 for (V3xOrgMember member : list) {
			 String name = member.getName();
			 if (member != null && name != null && name.toLowerCase().indexOf(indistinctName) != -1 && member.isValid()) // 必须是内部人员
			 {
				 memberList.add(OrgHelper.cloneEntity(member));
			 }
		 }

		 Collections.sort(memberList, CompareSortEntity.getInstance());

		 return memberList;
	 }

	 @Override
	 public Integer getMaxMemberSortByAccountId(Long accountId) throws BusinessException {
		 return orgManagerDirect.getMaxSortNum(V3xOrgMember.class.getSimpleName(), accountId);
	 }

	 @Override
	 public List<V3xOrgMember> getAllMembersByAccountId(Long accountId, Integer type, Boolean isInternal,
			 Boolean enable, String condition, Object feildvalue, FlipInfo flipInfo) {
		 List<V3xOrgMember> result = new UniqueList<V3xOrgMember>();
		 List<OrgMember> members = orgDao.getAllMemberPOByAccountId(accountId, type, isInternal, enable, condition, feildvalue, flipInfo);
		 @SuppressWarnings("unchecked")
		 List<V3xOrgMember> memberBOs = (List<V3xOrgMember>) OrgHelper.listPoTolistBo(members);
		 for(V3xOrgMember m : memberBOs){
			 if(m.getExternalType().equals(OrgConstants.ExternalType.Inner.ordinal())){
				 result.add(m);
			 }
		 }
		 return result;
	 }
	 @Override
	 public Integer getAllMembersNumsByAccountId(Long accountId, Integer type, Boolean isInternal,
			 Boolean enable, String condition, Object feildvalue) {
		 Integer members = orgDao.getAllMemberPONumsByAccountId(accountId, type, isInternal, enable, condition, feildvalue);

		 return members;
	 }

	 @Override
	 public List<V3xOrgMember> getAllMembersByDepartmentId(Long departmentId, boolean isCludChildDepart, Integer type,
			 Boolean isInternal, Boolean enable, String condition, Object feildvalue, FlipInfo flipInfo) {
		 List<OrgMember> members = orgDao.getAllMemberPOByDepartmentId(departmentId, isCludChildDepart, type, isInternal, enable, condition,
				 feildvalue, flipInfo);
		 @SuppressWarnings("unchecked")
		 List<V3xOrgMember> memberBOs = (List<V3xOrgMember>) OrgHelper.listPoTolistBo(members);
		 return memberBOs;
	 }

	 @Override
	 public Boolean isOldPasswordCorrect(String loginName, String password) {
		 V3xOrgMember member = null;
		 try {
			 member = this.getMemberByLoginName(loginName);
		 } catch (BusinessException e) {
			 // ignore
			 logger.error(e);
			 return Boolean.FALSE;
		 }
		 if(null == member) return Boolean.FALSE;
		 //不允许非本人以为的人校验密码！（王飞飞）
		 User user = AppContext.getCurrentUser();
		 try {
			 if(isHRAdmin() && isAdministratorById(member.getId(),user.getLoginAccount())){
				 //如果当前人员是hr管理员，可以修改单位管理员的密码
			 }else if(null == user || ( null!=user && user.getId().compareTo(member.getId())!=0)){
				 return Boolean.FALSE;
			 }
		 } catch (BusinessException e) {
		 }
		 //判断如果开启AD则输入AD密码校验 ,並且這個人綁定了，進行ad密碼驗證。否則進行oa密碼驗證
		 if(LdapUtils.isLdapEnabled() && !member.getIsAdmin() && LdapUtils.isBind(member.getId())) {//OA-55561
			 UserMapperDao userMapperDao = (UserMapperDao) AppContext.getBean("userMapperDao");
			 Authenticator a = LDAPTool.createAuthenticator(userMapperDao);
			 String ldapAdloginName = getLdapAdLoginName(loginName, userMapperDao);
			 CtpOrgUserMapper ep = a.auth(ldapAdloginName, password);
			 if (ep != null) {
				 return Boolean.TRUE;
			 } else {
				 return Boolean.FALSE;
			 }
		 } else {
			 return principalManager.authenticate(loginName, password);
		 }
	 }

	 private String getLdapAdLoginName(String a8LoginName, UserMapperDao userMapperDao) {
		 List<CtpOrgUserMapper> userMappers = userMapperDao.getExLoginNames(a8LoginName, LDAPConfig.getInstance().getType());
		 String stateNames = "";
		 for (CtpOrgUserMapper map : userMappers) {
			 stateNames = map.getExLoginName();

		 }
		 return stateNames;

	 }

	 @Override
	 public Boolean isExistLoginName(String loginName) {
		 return principalManager.isExist(loginName);
	 }

	 @Override
	 public boolean getOrgExportFlag() {
		 return orgCache.getOrgExportFlag();
	 }

	 @Override
	 public V3xOrgEntity getEntityOnlyById(Long id) throws BusinessException {
		 //只查询缓存
		 return orgCache.getEntityOnlyById(id);
	 }

	 @Override
	 public Long getAccountIdByCustomLoginUrl(String customLoginUrl) throws BusinessException {
		 if(Strings.isBlank(customLoginUrl)) {
			 throw new BusinessException("输入的单位自定义url为空，无法查询！");
		 }
		 Map<String, Long> url2IDMap = new HashMap<String, Long>();
		 List<V3xOrgAccount> allAccounts = orgCache.getAllAccounts();
		 for (V3xOrgAccount a : allAccounts) {
			 /* 1.单位开启自定义登录地址 0或null为未开启，1为开启
			  *  2.customLoginUrl不为空
			  */
			 if(null != a.getProperty("isCustomLoginUrl")
					 && ((Long)a.getProperty("isCustomLoginUrl")).longValue() == 1
					 && null != a.getProperty("customLoginUrl")) {

				 url2IDMap.put((String)a.getProperty("customLoginUrl"), a.getId());
			 }
		 }

		 return url2IDMap.get(customLoginUrl);
	 }

	 @Override
	 public String getCustomLoginUrlByAccountId(Long accountId) throws BusinessException {
		 if(null == accountId) {
			 throw new BusinessException("单位ID为空！");
		 }

		 V3xOrgAccount a = this.getAccountById(accountId);
		 if(null == a) {
			 return null;
		 } else {
			 if(null != a.getProperty("isCustomLoginUrl")
					 && ((Long)a.getProperty("isCustomLoginUrl")).longValue() == 1
					 && null != a.getProperty("customLoginUrl")) {
				 return (String)a.getProperty("customLoginUrl");
			 }
		 }
		 return null;
	 }

	 public Map<Long, Integer> getMemberNumsMapWithConcurrent() throws BusinessException{
		 Date orgModifyDate = this.getModifiedTimeStamp(null);

		 //没有修改
		 /**
		  * 项目  信达资产   公司  kimde  修改人  陈岩   修改时间    2017-11-15   修改功能  类型转换  start
		  */
		 if(this.checkCacheModify("getMemberNumsMapWithConcurrent", "key", String.valueOf(orgModifyDate))){
			 return (Map<Long, Integer>)this.getCacheData("getMemberNumsMapWithConcurrent", "key");
		 }
		 /**
		  * 项目  信达资产   公司  kimde  修改人  陈岩   修改时间    2017-11-15   修改功能  类型转换  end
		  */

		 Map<Long, Set<Long>> num = new HashMap<Long, Set<Long>>();

		 List<V3xOrgRelationship> rs = this.orgCache.getV3xOrgRelationship(RelationshipType.Member_Post);
		 Map<Long,V3xOrgMember> map = new HashMap<Long,V3xOrgMember>();
		 for (V3xOrgRelationship r : rs) {
			 if(!isValidMemberPost(r)){
				 continue;
			 }

			 Long memberId = r.getSourceId();
			 Long accountId = r.getOrgAccountId();
			 V3xOrgMember member = null;
			 if(map.containsKey(memberId)){
				 member = map.get(memberId);
			 }else{
				 member = this.orgCache.getV3xOrgEntityNoClone(V3xOrgMember.class, memberId);
				 map.put(memberId, member);
			 }

			 if(member != null && member.isValid() && member.getIsInternal() && !member.getIsAdmin()) {
				 Set<Long> n = num.get(accountId);
				 if(n == null){
					 n = new HashSet<Long>();
					 num.put(accountId, n);
				 }

				 n.add(memberId);
			 }
		 }

		 Map<Long, Integer> result = new HashMap<Long, Integer>();
		 for (Map.Entry<Long, Set<Long>> e : num.entrySet()) {
			 result.put(e.getKey(), e.getValue().size());
		 }

		 //合并集团的

		 //如果是集团，取集团内的所有人员
		 Set<Long> groupMemberId = new HashSet<Long>();
		 List<V3xOrgAccount> groupAccounts = getChildAccount(OrgConstants.GROUPID, false);
		 for (V3xOrgAccount account : groupAccounts) {
			 Set<Long> a = num.get(account.getId());
			 if(!Strings.isEmpty(a)){
				 groupMemberId.addAll(a);
			 }
		 }

		 result.put(OrgConstants.GROUPID, groupMemberId.size());

		 this.saveCacheData("getMemberNumsMapWithConcurrent", "key", String.valueOf(orgModifyDate), result);

		 return result;
	 }

	 @Override
	 public List<V3xOrgMember> getMembersByDeptIdWithCheckLevelScope(Long memberId, Long departmentId) throws BusinessException {
		 V3xOrgMember member = this.getMemberById(memberId);
		 if(null == member) {
			 return Collections.EMPTY_LIST;
		 }
		 V3xOrgDepartment department = this.getDepartmentById(departmentId);
		 V3xOrgAccount acc = this.getAccountById(department.getOrgAccountId());

		 int newAccountLevelScope = acc.getLevelScope();
		 if (newAccountLevelScope < 0) {//如果目标单位是无限制，直接返回这个部门下所有人员
			 return getMembersByDepartment(departmentId, true);
		 }
		 // 兼职在这个部门的有权限
		 Map<Long, List<MemberPost>> concurrentPostMap = getConcurentPostsByMemberId(department.getOrgAccountId(), memberId);
		 Set<Long> deptIds = concurrentPostMap.keySet();
		 if (deptIds.contains(departmentId)) {
			 return getMembersByDepartment(departmentId, true);
		 }

		 // member的单位的工作范围设置
		 //int currentAccountLevelScope = this.getAccountById(member.getOrgAccountId()).getLevelScope();
		 int currentMemberLevelSortId = 0;
		 //int accountLevelScope = 0;
		 int memberLevelSortId = 0;
		 List<V3xOrgMember> resultsList = new UniqueList<V3xOrgMember>();


		 List<V3xOrgMember> deptMembers = getMembersByDepartment(departmentId, true);
		 if(deptMembers.size() <= 0) {
			 return Collections.EMPTY_LIST;
		 }
		 for (V3xOrgMember m1 : deptMembers) {
			 V3xOrgMember temptM = m1;
			 Long accId = acc.getOrgAccountId();
			 if(!Strings.equals(m1.getOrgAccountId(),accId)){
				 temptM = OrgHelper.cloneEntity(m1);
				 temptM.setOrgDepartmentId(departmentId);
				 List<MemberPost> memberPosts = this.getConcurentPostsByMemberId(accId, m1.getId()).get(departmentId);
				 if(!memberPosts.isEmpty()){
					 temptM.setOrgLevelId(memberPosts.get(0).getLevelId());
				 }else{
					 temptM.setOrgLevelId(this.getLowestLevel(accId).getId());
				 }
				 temptM.setOrgAccountId(acc.getOrgAccountId());
			 }
			 V3xOrgLevel memberLevel = this.getLevelById(temptM.getOrgLevelId());
			 memberLevelSortId = memberLevel!=null ? memberLevel.getLevelId() : 0;
			 if(member.getOrgAccountId().equals(temptM.getOrgAccountId())) {//同单位
				 if(newAccountLevelScope < 0 || member.getOrgDepartmentId().equals(temptM.getOrgDepartmentId())) {//同单位同部门
					 resultsList.add(m1);
				 continue;
				 }
				 V3xOrgLevel currentMemberLevel = this.getLevelById(member.getOrgLevelId());
				 currentMemberLevelSortId = currentMemberLevel != null ? currentMemberLevel.getLevelId() : 0;
				 //accountLevelScope = newAccountLevelScope;
			 } else {//不同单位取兼职
				 currentMemberLevelSortId = OrgHelper.mappingLevelSortId(member, accId, temptM, accId);
				 //accountLevelScope = newAccountLevelScope;
			 }

			 if (currentMemberLevelSortId - memberLevelSortId <= newAccountLevelScope) {
				 resultsList.add(m1);
			 }
		 }
		 return resultsList;
	 }

	 /**
	  * 映射集团职务级别，考虑兼职
	  * @return
	  * @throws BusinessException
	  */
	 private int mappingGroupLevelWithConPost(V3xOrgMember currentMember, V3xOrgMember member) throws BusinessException {
		 int currentMemberLevelSortId=0;
		 V3xOrgLevel level = null;
		 Map<Long, List<MemberPost>> concurrentPostMap = this.getConcurentPostsByMemberId(
				 currentMember.getOrgAccountId(), member.getId());
		 if(concurrentPostMap != null && !concurrentPostMap.isEmpty()) {
			 Iterator<List<MemberPost>> it = concurrentPostMap.values().iterator();
			 while (it.hasNext()) {
				 List<MemberPost> cnPostList = it.next();
				 for (MemberPost memberPost : cnPostList) {
					 // 如果兼职到与当前人员同一个部门下，则直接返回相同职务级别，因为同部门的不受职务级别控制
					 if(memberPost.getDepId().equals(currentMember.getOrgDepartmentId())) {
						 return this.getLevelById(currentMember.getOrgLevelId()).getLevelId();
					 } else {
						 Long cnLevelId = memberPost.getLevelId();
						 V3xOrgLevel cnLevel = this.getLevelById(cnLevelId);
						 if(null == cnLevel) {
							 level = this.getLowestLevel(currentMember.getOrgAccountId());
							 return level != null ? level.getLevelId().intValue() : 0;
						 } else {
							 return cnLevel.getLevelId();
						 }
					 }
				 }
			 }
		 } else {

			 Long mappingGroupId = this.getLevelById(currentMember.getOrgLevelId()).getGroupLevelId();
			 Long levelIdOfGroup = (!currentMember.getOrgLevelId().equals(-1L)) ? mappingGroupId : Long.valueOf(-1); //当前登录者对应集团的职务级别id

			 List<V3xOrgLevel> levels = this.getAllLevels(member.getOrgAccountId());
			 for (V3xOrgLevel _level : levels) {
				 if (levelIdOfGroup != null) {
					 if (levelIdOfGroup.equals(_level.getGroupLevelId())) {
						 level = _level;
						 break;
					 }
				 }
			 }
			 if (level == null) {
				 level = this.getLowestLevel(member.getOrgAccountId()); //最低职务级别
			 }

			 if (level != null) {
				 currentMemberLevelSortId = level.getLevelId();
			 }
		 }
		 return currentMemberLevelSortId;
	 }

	 @Override
	 public List<MemberPost> getSecConMemberByDept(Long deptId) throws BusinessException {
		 List<MemberPost> result = new UniqueList<MemberPost>();
		 V3xOrgEntity entity = orgCache.getEntityOnlyById(deptId);
		 if(entity==null){
			 return result;
		 }
		 List<V3xOrgRelationship> cntList = orgCache.getEntityConPostRelastionships(entity.getOrgAccountId(), deptId);
		 for (V3xOrgRelationship cnt : cntList) {
			 if(isValidMemberPost(cnt)){
				 MemberPost cntPost = new MemberPost(cnt);
				 result.add(cntPost);
			 }
		 }
		 return result;
	 }

	 @Override
	 public void clearAllCurrentPosts(Long accountId) throws BusinessException {
		 EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
		 enummap.put(OrgConstants.RelationshipObjectiveName.objective5Id, OrgConstants.MemberPostType.Concurrent);
		 List<V3xOrgRelationship> rels = orgCache.getV3xOrgRelationship(OrgConstants.RelationshipType.Member_Post, null, accountId, enummap);
		 for (V3xOrgRelationship v : rels) {
			 orgManagerDirect.deleteOrgRelationshipById(v.getId());
		 }
	 }

	 @Override
	 public List<V3xOrgRelationship> getMemberPostRelastionships(Long memberId, Long accountId, EnumMap<RelationshipObjectiveName, Object> enummap) throws BusinessException{
		 return orgCache.getV3xOrgRelationship(RelationshipType.Member_Post, memberId, accountId, enummap);
	 }

	 @Override
	 public int getDeptLevel(Long deptId) throws BusinessException {
		 int deptDeep =-1;
		 V3xOrgDepartment dept = this.getDepartmentById(deptId);
		 if (dept != null) {
			 V3xOrgAccount currentAccont = this.getAccountById(dept.getOrgAccountId());
			 String accountPath = currentAccont.getPath();
			 deptDeep = (dept.getPath().length() - accountPath.length()) / 4;

		 }
		 return deptDeep;
	 }

	 @Override
	 public Map<Long, List<V3xOrgPost>> getAccountDeptPosts(Long accountId) throws BusinessException {
		 Map<Long, List<V3xOrgPost>> tempPostMap = new HashMap<Long, List<V3xOrgPost>>();

		 List<V3xOrgRelationship> rellist = orgCache.getV3xOrgRelationship(RelationshipType.Department_Post, null, accountId, null);

		 for (V3xOrgRelationship orgRelationship : rellist) {
			 V3xOrgPost post = this.orgCache.getV3xOrgEntityNoClone(V3xOrgPost.class, orgRelationship.getObjective0Id());
			 if(null == post || !post.isValid()) {
				 continue;
			 }

			 Strings.addToMap(tempPostMap, orgRelationship.getSourceId(), OrgHelper.cloneEntity(post));
		 }

		 for (Long key : tempPostMap.keySet()) {
			 List<V3xOrgPost> value = tempPostMap.get(key);
			 Collections.sort(value, CompareSortEntity.getInstance());
		 }

		 return tempPostMap;
	 }

	 @Override
	 public boolean isInDepartmentPathOf(Long parentDepId,Long deptid)
	 throws BusinessException {

		 V3xOrgUnit parentDep = this.getEntityById(V3xOrgUnit.class, parentDepId);
		 if(parentDep == null || !parentDep.isValid()){
			 return false;
		 }
		 V3xOrgUnit dept = this.getEntityById(V3xOrgUnit.class, deptid);
		 if(dept == null || !dept.isValid()){
			 return false;
		 }

		 if(dept.getPath().startsWith(parentDep.getPath())){
			 return true;
		 }

		 return false;
	 }

	 private void getParTeam(V3xOrgMember member,List<Long> accountIds, Set<Long> ids, Set<V3xOrgTeam> allTeams, Set<Long> deptIds) throws BusinessException {

		 OrgConstants.TeamMemberType[] teamMemberType = new OrgConstants.TeamMemberType[] {TeamMemberType.Member, TeamMemberType.Leader};

		 if(ids != null && !ids.isEmpty()){
			 //增加子集组
			 Set<Long> newTeams = new HashSet<Long>();
			 for (Long id : ids) {
				 //得到上一级的组
				 List<V3xOrgRelationship> rels = orgCache.getMemberTeamRelastionships(id, accountIds, teamMemberType);
				 //如果上一级的组不为空,则保存所有上一级组
				 for (V3xOrgRelationship v : rels) {
					 if(!deptIds.contains(v.getObjective0Id()) && OrgConstants.ORGENT_TYPE.Department.name().equals(v.getObjective6Id()) && "1".equals(v.getObjective7Id())){
						 continue;
					 }
					 //组成员是部门下的岗位
					 if(OrgConstants.ORGENT_TYPE.Department_Post.name().equals(v.getObjective6Id())){
						 Long departmentId = v.getObjective0Id();
						 Long postId = v.getObjective1Id();
						 List<V3xOrgMember> members= getMembersByDepartmentPost(departmentId, postId);
						 if(Strings.isEmpty(members) || !members.contains(member)){
							 continue;
						 }
					 }
					 V3xOrgTeam parTeam = orgCache.getV3xOrgEntityNoClone(V3xOrgTeam.class, v.getSourceId());
					 if (parTeam != null && parTeam.isValid() && !allTeams.contains(parTeam)
							 && (parTeam.getType() == TEAM_TYPE.PERSONAL.ordinal()
									 || parTeam.getType() == TEAM_TYPE.SYSTEM.ordinal()
									 || parTeam.getType() == TEAM_TYPE.PROJECT.ordinal())) {
						 newTeams.add(parTeam.getId());
						 allTeams.add(parTeam);
					 }
				 }
			 }

			 getParTeam(member,accountIds,newTeams,allTeams,deptIds);
		 }
	 }


	 @Override
	 public List<V3xOrgMember> canSeMembersByDeptId(Long memberId, Long departmentId,int levelScope,boolean filter) throws BusinessException{

		 V3xOrgMember currentMember = this.getMemberById(memberId);
		 V3xOrgDepartment department = this.getDepartmentById(departmentId);
		 V3xOrgDepartment currentDepartment = this.getDepartmentById(currentMember.getOrgDepartmentId());

		 boolean isInner = currentMember.getIsInternal();
		 if(isInner){
			 //如果传入的人员不是当前登录人返回空list
			 if(!memberId.equals(AppContext.currentUserId())){
				 return Collections.EMPTY_LIST;
			 }
			 V3xOrgAccount acc = this.getAccountById(department.getOrgAccountId());

			 //得到单位职务级别限制
			 int newAccountLevelScope = levelScope; //acc.getLevelScope();
			 if(departmentId.equals(currentMember.getOrgDepartmentId())){
				 return getMembersByDepartment(departmentId, filter);
			 }

			 if (newAccountLevelScope < 0) {//如果目标单位是无限制，直接返回这个部门下所有人员
				 return getMembersByDepartment(departmentId, filter);
			 }
			 /*	        List<MemberPost> secondList = this.getMemberSecondPosts(memberId);
	        for(MemberPost mp : secondList){
	        	if(departmentId.equals(mp.getDepId())){
	        		  return getMembersByDepartment(departmentId, filter);
	        	}
	        }*/

			 //当前登录人登录单位,兼职在这个部门的有权限
			 Map<Long, List<MemberPost>> concurrentPostMap = getConcurentPostsByMemberId(department.getOrgAccountId(), memberId);
			 Set<Long> deptIds1 = concurrentPostMap.keySet();

			 if (deptIds1.contains(departmentId)) {
				 return getMembersByDepartment(departmentId, filter);
			 }

			 //单位的所有职务级别
			 List<V3xOrgLevel> allLevels = this.getAllLevels(department.getOrgAccountId());

			 //当前人的集团映射职务级别
			 V3xOrgLevel tempLevel1 = this.getLevelById(currentMember.getOrgLevelId());
			 Long groupLevelId = tempLevel1.getGroupLevelId();

			 //设置当前人员的职级
			 int currentMemberLevel = this.getLowestLevel(acc.getId()).getLevelId().intValue();

			 if(currentMember.getOrgAccountId().equals(department.getOrgAccountId())){
				 currentMemberLevel = this.getLevelById(currentMember.getOrgLevelId()).getLevelId().intValue();
			 }else if(!concurrentPostMap.isEmpty()){
				 Set<Long> deptIds = concurrentPostMap.keySet();
				 int tempLevel = -1;
				 for(Long dId : deptIds){
					 for(MemberPost memberPost: concurrentPostMap.get(dId)){
						 Long cnLevelId = memberPost.getLevelId();
						 V3xOrgLevel cnLevel = this.getLevelById(cnLevelId);
						 tempLevel = cnLevel.getLevelId().intValue();
						 if(currentMemberLevel>=tempLevel){
							 currentMemberLevel = tempLevel;
						 }
					 }
				 }

			 }else if(groupLevelId!=null){
				 for (V3xOrgLevel level : allLevels) {
					 if (level.getGroupLevelId() != null) {
						 V3xOrgLevel orgGroupLevelIt = getLevelById(level.getGroupLevelId());
						 if (orgGroupLevelIt != null && groupLevelId .equals(orgGroupLevelIt.getId())) {
							 currentMemberLevel = level.getLevelId();
						 }
					 }
				 }
			 }

			 List<V3xOrgMember> resultsList = new UniqueList<V3xOrgMember>();

			 //查询出部门中的所有人员
			 List<V3xOrgMember> deptMembers = getTempMembersByDepartment(departmentId, filter, null);
			 if(deptMembers.size() <= 0) {
				 return Collections.EMPTY_LIST;
			 }
			 boolean isParent = false;
			 List<V3xOrgDepartment> parentDepts = this.getAllParentDepartments(departmentId);
			 for(V3xOrgDepartment pd : parentDepts){
				 if(pd.getId().equals(currentMember.getOrgDepartmentId())){
					 isParent = true;
					 break;
				 }
			 }
			 if(isParent){
				 resultsList.addAll(deptMembers);
			 }else{
				 Set<Integer> canSeeLevels = new HashSet<Integer>();
				 for(V3xOrgLevel level : allLevels){
					 if (currentMemberLevel - level.getLevelId() <= newAccountLevelScope){
						 canSeeLevels.add(level.getLevelId());
					 }
				 }

				 List<MemberPost> currentMemberPostList =getMemberPosts0(department.getOrgAccountId(), memberId, MemberPostType.Main,MemberPostType.Second);
				 Map<Long,V3xOrgLevel> tempLevelMap = new HashMap<Long, V3xOrgLevel>();
				 for(V3xOrgMember member : deptMembers){	        
					 V3xOrgLevel memberLevel = null;
					 Long memberLevelId = member.getOrgLevelId();
					 if(null!=memberLevelId){
						 if(tempLevelMap.containsKey(memberLevelId)){
							 memberLevel = tempLevelMap.get(memberLevelId);
						 }else{
							 memberLevel = this.getLevelById(member.getOrgLevelId());
							 if(null!=memberLevel){
								 tempLevelMap.put(memberLevelId, memberLevel);
							 }
						 }
					 }

					 if(null!=memberLevel 
							 && null!=memberLevel.getLevelId()
							 && canSeeLevels.contains(memberLevel.getLevelId())){
						 resultsList.add(member);
					 }else{
						 boolean deptEqual = false;
						 List<MemberPost> memberPostList =getMemberPosts0(department.getOrgAccountId(), member.getId(), MemberPostType.Main);
						 for(MemberPost mp : memberPostList){
							 //如果当前人员的主岗部门是 这个人的主岗所在部门的上级部门，则可以看到
							 if(getAllParentDepartments(mp.getDepId()).contains(currentDepartment)){
								 resultsList.add(member);
								 break;
							 }
							 //如果当前人员的主岗或者副岗和 这个人的主岗所在部门相同， 则可以看到
							 if(deptEqual) break;
							 for(MemberPost cmp : currentMemberPostList){
								 if(cmp.getDepId().equals(mp.getDepId())){
									 resultsList.add(member);
									 deptEqual = true;
									 break;
								 }
							 }
						 }
					 }
				 }
			 }

			 return resultsList;
		 }else{
			 List<V3xOrgMember> memberList = (List<V3xOrgMember>) OuterWorkerAuthUtil.getCanAccessMembers(memberId,currentMember.getOrgDepartmentId(),department.getOrgAccountId(),this);
			 List<Long> deptIds = new ArrayList<Long>();
			 if (!filter){
				 List<V3xOrgDepartment> deps = getChildDepartments(departmentId, filter);
				 for (V3xOrgDepartment d : deps) {
					 deptIds.add(d.getId());
				 }
			 }
			 deptIds.add(departmentId);

            List<V3xOrgMember> resultMember  = new ArrayList<V3xOrgMember>();
            
            OrgConstants.MemberPostType[] postType = new OrgConstants.MemberPostType[]{OrgConstants.MemberPostType.Second,OrgConstants.MemberPostType.Concurrent};
            for(V3xOrgMember m : memberList){
            	if(deptIds.contains(m.getOrgDepartmentId())){
            		resultMember.add(m);
            		continue;
            	}
            	
            	List<V3xOrgRelationship> rels = this.orgCache.getMemberPostRelastionships(memberId, department.getOrgAccountId(), postType);
	            for(V3xOrgRelationship rel : rels){
	            	Long memberDeptId = rel.getObjective0Id();
	            	if(deptIds.contains(memberDeptId)){
	            		resultMember.add(m);
	            		break;
	            	}
	            }
            }

			 return resultMember;
		 }

	 }

	 @Override
	 public List<V3xOrgMember> canSeMembersByPostId(Long memberId, Long postId,int levelScope) throws BusinessException{
		 V3xOrgPost post = this.getPostById(postId);
		 V3xOrgAccount acc = this.getAccountById(post.getOrgAccountId());

		 if (levelScope < 0) {//如果目标单位是无限制，直接返回这个部门下所有人员
			 return this.getMembersByPost(postId);
		 }
		 List<V3xOrgMember> tempList = new UniqueList<V3xOrgMember>();
		 List<V3xOrgDepartment> deptList = this.getChildDepartments(acc.getId(), true);
		 for(V3xOrgDepartment dept : deptList){
			 List<V3xOrgMember> deptMemberList = new UniqueList<V3xOrgMember>();
			 deptMemberList = this.canSeMembersByDeptId(memberId, dept.getId(), levelScope, false);
			 tempList.addAll(deptMemberList);
		 }

		 List<V3xOrgMember> resultsList = new UniqueList<V3xOrgMember>();
		 for(V3xOrgMember member : tempList){
			 //主岗
			 if(postId.equals(member.getOrgPostId())){
				 resultsList.add(member);
			 }else{
				 //副岗
				 if(member.getOrgAccountId().equals(post.getOrgAccountId())){
					 List<MemberPost> mplist= this.getMemberSecondPosts(member.getId());
					 if(!mplist.isEmpty()){
						 for(MemberPost mp :mplist){
							 if(mp.getPostId().equals(postId)){
								 resultsList.add(member);
								 break;
							 }
						 }
					 }
				 }else{
					 List<MemberPost> mplist= this.getMemberConcurrentPostsByAccountId(member.getId(),post.getOrgAccountId());
					 if(!mplist.isEmpty()){
						 for(MemberPost mp :mplist){
							 if(mp.getPostId().equals(postId)){
								 resultsList.add(member);
								 break;
							 }
						 }
					 }

				 }
			 }

		 }

		 return resultsList;


		 /*    	V3xOrgMember currentMember = this.getMemberById(memberId);
    	//如果传入的人员不是当前登录人返回空list
    	if(!memberId.equals(AppContext.currentUserId())){
    		return Collections.EMPTY_LIST;
    	}
    	V3xOrgPost post = this.getPostById(postId);
        V3xOrgAccount acc = this.getAccountById(post.getOrgAccountId());

        int newAccountLevelScope = levelScope; //acc.getLevelScope();
        if (newAccountLevelScope < 0) {//如果目标单位是无限制，直接返回这个部门下所有人员
        	return this.getMembersByPost(postId);
        }

        //当前登录人登录单位,兼职在这个部门的有权限
        List<MemberPost> MemberPostList= this.getMemberConcurrentPostsByAccountId(currentMember.getId(),post.getOrgAccountId());

        //单位的所有职务级别
        List<V3xOrgLevel> allLevels = this.getAllLevels(post.getOrgAccountId());

        //当前人的集团映射职务级别
        V3xOrgLevel tempLevel = this.getLevelById(currentMember.getOrgLevelId());
        Long groupLevelId = tempLevel.getGroupLevelId();

        //设置当前人员的职级
        int currentMemberLevel = this.getLowestLevel(acc.getId()).getLevelId().intValue();
        if(currentMember.getOrgAccountId().equals(post.getOrgAccountId())){
        	currentMemberLevel = this.getLevelById(currentMember.getOrgLevelId()).getLevelId().intValue();
        }else if(!MemberPostList.isEmpty()){
			for(MemberPost mp :MemberPostList){
				Long levelId = mp.getLevelId();
				if(null==levelId) continue;
				int level = this.getLevelById(levelId).getLevelId().intValue();
				if(level<currentMemberLevel){
					currentMemberLevel = level;
				}
			}
        }else if(groupLevelId!=null){
        	for (V3xOrgLevel level : allLevels) {
                if (level.getGroupLevelId() != null) {
                    V3xOrgLevel orgGroupLevelIt = getLevelById(level.getGroupLevelId());
                    if (orgGroupLevelIt != null && groupLevelId .equals(orgGroupLevelIt.getId())) {
                    	currentMemberLevel = level.getLevelId();
                    }
                }
            }
        }

        List<V3xOrgMember> resultsList = new UniqueList<V3xOrgMember>();

        //查询出部门中的所有人员
        List<V3xOrgMember> postMembers = this.getMembersByPost(postId);
        if(postMembers.size() <= 0) {
        	return Collections.EMPTY_LIST;
        }

    	Set<Integer> canSeeLevels = new HashSet<Integer>();
    	for(V3xOrgLevel level : allLevels){
    		if (currentMemberLevel - level.getLevelId() <= newAccountLevelScope){
    			canSeeLevels.add(level.getLevelId());
    		}
    	}

    	Map<Long,V3xOrgLevel> tempLevelMap = new HashMap<Long, V3xOrgLevel>();
    	for(V3xOrgMember member : postMembers){
    		Long levelId = member.getOrgLevelId();
    		if(!member.getOrgAccountId().equals(post.getOrgAccountId())){
    			  List<MemberPost> mplist= this.getMemberConcurrentPostsByAccountId(member.getId(),post.getOrgAccountId());
    		        if(!mplist.isEmpty()){
    					for(MemberPost mp :mplist){
    						if(!mp.getPostId().equals(postId)) continue;
    						if(mp.getLevelId()!=null){
    							levelId = mp.getLevelId();
    						}
    					}
    		        }
    		}

    		V3xOrgLevel memberLevel = null;
    		if(null!=levelId){
    			if(tempLevelMap.containsKey(levelId)){
    			    memberLevel = tempLevelMap.get(levelId);
    			}else{
    				memberLevel = this.getLevelById(levelId);
    				if(null!=memberLevel){
    					tempLevelMap.put(levelId, memberLevel);
    				}
    			}
    		}

    		if(null!=memberLevel 
					&& null!=memberLevel.getLevelId()
					&& canSeeLevels.contains(memberLevel.getLevelId())){
				resultsList.add(member);
			}

    	}

        return resultsList;*/
	 }

	 /**
	  * 获取部门下的人员,非V3xOrgMember,可能变更过岗位、部门、职级、单位 
	  * 如果是兼职或副岗，设置人员的岗位、部门、职级、单位 为relationship中的值
	  * @param departmentId
	  * @param firtLayer
	  * @param type
	  * @return
	  * @throws BusinessException
	  */
	 private List<V3xOrgMember> getTempMembersByDepartment(Long departmentId, boolean firtLayer, OrgConstants.MemberPostType type) throws BusinessException {

		 V3xOrgDepartment dep = getDepartmentById(departmentId);
		 if (dep == null) {
			 return Collections.emptyList();
		 }
		 V3xOrgAccount account = this.getAccountById(dep.getOrgAccountId());
		 if (account == null) {
			 return Collections.emptyList();
		 }
		 //获得当前单位的最低职级
		 Long lowestLevel = this.getLowestLevel(account.getId()).getId();

		 //考虑外部部门
		 if (!dep.getIsInternal()) {
			 return getExtMembersByDepartment(departmentId, firtLayer);
		 }
		 else {
			 List<V3xOrgMember> memberList = new UniqueList<V3xOrgMember>();

			 List<Long> deptIds = new ArrayList<Long>();
			 if (!firtLayer){
				 List<V3xOrgDepartment> deps = getChildDepartments(departmentId, firtLayer);
				 for (V3xOrgDepartment d : deps) {
					 deptIds.add(d.getId());
				 }
			 }

			 deptIds.add(dep.getId());

			 EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
			 enummap.put(OrgConstants.RelationshipObjectiveName.objective0Id, deptIds);

			 if(null != type) {
				 List<String> types = new ArrayList<String>();
				 types.add(type.name());
				 enummap.put(OrgConstants.RelationshipObjectiveName.objective5Id, types);
			 }

			 List<V3xOrgRelationship> rels = orgCache.getV3xOrgRelationship(RelationshipType.Member_Post, (Long)null, (Long)null, enummap);
			 Collections.sort(rels, CompareSortRelationship.getInstance());

			 for (V3xOrgRelationship rel : rels) {
				 if(!isValidMemberPost(rel)){
					 continue;
				 }
				 V3xOrgMember member = orgCache.getV3xOrgEntity(V3xOrgMember.class, rel.getSourceId());
				 if (member != null && member.isValid()){
					 if(!member.getOrgAccountId().equals(rel.getOrgAccountId())){
						 member.setOrgAccountId(rel.getOrgAccountId());
						 member.setOrgDepartmentId(departmentId);
						 member.setOrgPostId(rel.getObjective1Id());
						 if(rel.getObjective2Id()!=null){
							 member.setOrgLevelId(rel.getObjective2Id());
						 }else{
							 member.setOrgLevelId(lowestLevel);
						 }
					 }
					 memberList.add(member);
				 }
			 }

			 return memberList;
		 }
	 }

	 @Override
	 public Boolean canSeSubDept(Long memberId, Long departmentId,int levelScope, Set<Long> canSeeLevels, Set<Long> deptIds) throws BusinessException{

		 //如果传入的人员不是当前登录人返回空list
		 if(!memberId.equals(AppContext.currentUserId())){
			 return true;
		 }

		 V3xOrgMember currentMember = getMemberById(memberId);
		 boolean isInner = currentMember.getIsInternal();
		 if(isInner){

			 V3xOrgDepartment dept = this.getDepartmentById(departmentId);
			 List<MemberPost> currentMemberPostList =getMemberPosts0(dept.getOrgAccountId(), memberId, MemberPostType.Main,MemberPostType.Second);

			 if (levelScope < 0) {//如果目标单位是无限制，直接返回这个部门下所有人员
				 return true;
			 }

			 if (deptIds.contains(departmentId)) {
				 return true;
			 }

			 //查询出部门中的所有人员
			 List<V3xOrgMember> deptMembers = getMembersByDepartment(departmentId, true, null);
			 if(deptMembers.size() <= 0) {
				 return true;
			 }

			 List<V3xOrgDepartment> parentDepts = this.getAllParentDepartments(departmentId);
			 for(V3xOrgDepartment pd : parentDepts){
				 if(pd.getId().equals(currentMember.getOrgDepartmentId())){
					 return true;
				 }
			 }

			 Map<Long,V3xOrgLevel> tempLevelMap = new HashMap<Long, V3xOrgLevel>();
			 for(V3xOrgMember member : deptMembers){
				 if(!member.isValid()) continue;
				 List<MemberPost> memberPostList =getMemberPosts0(dept.getOrgAccountId(), member.getId(), MemberPostType.Main,MemberPostType.Second);
				 for(MemberPost mp : memberPostList){
					 for(MemberPost cmp : currentMemberPostList){
						 if(cmp.getDepId().equals(mp.getDepId())){
							 return true;
						 }
					 }
				 }

				 V3xOrgLevel memberLevel = null;
				 Long memberLevelId = member.getOrgLevelId();
				 if(null!=memberLevelId){
					 if(tempLevelMap.containsKey(memberLevelId)){
						 memberLevel = tempLevelMap.get(memberLevelId);
					 }else{
						 memberLevel = this.getLevelById(member.getOrgLevelId());
						 if(null!=memberLevel){
							 tempLevelMap.put(memberLevelId, memberLevel);
						 }
					 }
				 }

				 if(null!=memberLevel 
						 && null!=memberLevel.getLevelId()
						 && !canSeeLevels.contains(Long.valueOf(memberLevel.getLevelId()))){
					 return false;
				 }
			 }
		 }else{
			 V3xOrgDepartment dept = getDepartmentById(departmentId);
			 Collection<V3xOrgDepartment> depts = OuterWorkerAuthUtil.getCanAccessDep(currentMember.getId(), currentMember.getOrgDepartmentId(), currentMember.getOrgAccountId(), this);
			 depts.contains(dept);
			 return true;
		 }

		 return true;

	 }

	 @Override
	 public Set<Long> canSeeLevels(V3xOrgMember currentMember,int levelScope, List<V3xOrgLevel> allLevels, Long accountId, Map<Long, List<MemberPost>> concurrentPostMap) throws BusinessException{
		 Set<Long> canSeeLevels = new HashSet<Long>();
		 if(!currentMember.getIsInternal()){
			 return canSeeLevels;
		 }
		 //当前人的集团映射职务级别
		 Long groupLevelId = this.getLevelById(currentMember.getOrgLevelId()).getGroupLevelId();

		 //设置当前人员的职级
		 int currentMemberLevel = this.getLowestLevel(accountId).getLevelId().intValue();

		 if(currentMember.getOrgAccountId().equals(accountId)){
			 currentMemberLevel = this.getLevelById(currentMember.getOrgLevelId()).getLevelId().intValue();
		 }else if(!concurrentPostMap.isEmpty()){
			 Set<Long> deptIds = concurrentPostMap.keySet();
			 int tempLevel = -1;
			 for(Long departmentId : deptIds){
				 for(MemberPost memberPost: concurrentPostMap.get(departmentId)){
					 Long cnLevelId = memberPost.getLevelId();
					 V3xOrgLevel cnLevel = this.getLevelById(cnLevelId);
					 tempLevel = cnLevel.getLevelId().intValue();
					 if(currentMemberLevel>=tempLevel){
						 currentMemberLevel = tempLevel;
					 }
				 }
			 }

		 }else if(groupLevelId!=null){
			 for (V3xOrgLevel level : allLevels) {
				 if (level.getGroupLevelId() != null) {
					 V3xOrgLevel orgGroupLevelIt = getLevelById(level.getGroupLevelId());
					 if (orgGroupLevelIt != null && groupLevelId .equals(orgGroupLevelIt.getId())) {
						 currentMemberLevel = level.getLevelId();
					 }
				 }
			 }
		 }

		 for(V3xOrgLevel level : allLevels){
			 if (currentMemberLevel - level.getLevelId() <= levelScope){
				 canSeeLevels.add(Long.valueOf(level.getLevelId()));
			 }
		 }
		 return canSeeLevels;
	 }

	 @Override
	 public List<V3xOrgRole> getAllCustomerRoles(Long accountId,int bond) throws BusinessException {
		 List<V3xOrgRole> customerRoleList = new ArrayList<V3xOrgRole>();
		 List<V3xOrgRole> roleList  = getAllRoles(accountId);
		 //预置的所有角色。
		 String roleNames="|";
		 for(Role_NAME roleName:Role_NAME.values()){
			 roleNames=roleNames+roleName+"|";
		 }

		 for (V3xOrgRole v3xOrgRole : roleList) {
			 if(bond==OrgConstants.ROLE_BOND.GROUP.ordinal() && v3xOrgRole.getBond()==OrgConstants.ROLE_BOND.GROUP.ordinal()){
				 //集团自定义角色
				 if(roleNames.indexOf("|"+v3xOrgRole.getCode()+"|")<0){
					 customerRoleList.add(v3xOrgRole);
				 }
			 }else if(bond==OrgConstants.ROLE_BOND.ACCOUNT.ordinal() && v3xOrgRole.getBond()==OrgConstants.ROLE_BOND.ACCOUNT.ordinal()){
				 //单位自定义角色
				 if(roleNames.indexOf("|"+v3xOrgRole.getCode()+"|")<0){
					 customerRoleList.add(v3xOrgRole);
				 }
			 }else if(bond==OrgConstants.ROLE_BOND.DEPARTMENT.ordinal() && v3xOrgRole.getBond()==OrgConstants.ROLE_BOND.DEPARTMENT.ordinal()){
				 //部门自定义角色
				 if(roleNames.indexOf("|"+v3xOrgRole.getCode()+"|")<0){
					 customerRoleList.add(v3xOrgRole);
				 }
			 }
		 }
		 return customerRoleList;
	 }

	 @Override
	 public String getInitPWD(){
		 String pwd =OrgConstants.DEFAULT_PASSWORD;
		 String initPassword = systemConfig.get("initPassword");
		 if(!Strings.isBlank(initPassword)){
			 pwd = initPassword;
		 }
		 return pwd;
	 }

	 @Override
	 public String getInitPWDForPage(){
		 String pwd =OrgConstants.DEFAULT_PASSWORD;
		 String initPassword = systemConfig.get("initPassword");
		 if(!Strings.isBlank(initPassword)){
			 pwd = initPassword;
		 }
		 pwd ="initPwd_"+pwd;
		 return pwd;
	 }

	 @Override
	 public Set<String> getMemberRolesForSet(Long memberId, Long unitId) throws BusinessException {
		 Set<String> result = new HashSet<String>();
		 List<V3xOrgRelationship> relList = getEntityRoleRelastionshipsByMember(memberId, unitId);
		 for (V3xOrgRelationship rel : relList) {
			 V3xOrgRole role = orgCache.getV3xOrgEntityNoClone(V3xOrgRole.class, rel.getObjective1Id());
			 if(role == null || !role.isValid()){
				 continue;
			 }
			 result.add(role.getCode());
		 } 
		 //TODO 没有排序, 是否要排序再确定
		 return result;
	 }
	 /**
	  * 
	  * @方法名称: getOrgRelationship
	  * @功能描述: 获取用户单位关系
	  * @参数 ：@param memberId
	  * @参数 ：@param unitId
	  * @参数 ：@return
	  * @参数 ：@throws BusinessException
	  * @返回类型：List<V3xOrgRelationship>
	  * @创建时间 ：2015年11月18日 下午8:05:30
	  * @创建人 ： FuTao
	  * @修改人 ： 
	  * @修改时间 ：
	  */
	 private List<V3xOrgRelationship> getEntityRoleRelastionshipsByMember(Long memberId, Long unitId) throws BusinessException{
		 Long accountId = null;
		 Long _departmentId = null;

		 if(unitId != null && !unitId.equals(V3xOrgEntity.VIRTUAL_ACCOUNT_ID) && !Strings.equals(unitId, -1L)){
			 V3xOrgUnit unit = this.getUnitById(unitId);
			 if(unit == null){
				 logger.warn("UnitId[" + unitId + "]不存在");
				 return null;
			 }
			 accountId = unit.getOrgAccountId();

			 if(unit.getType() == OrgConstants.UnitType.Department){
				 _departmentId = unitId;
			 }
		 }

		 List<Long> teamMembers = null;

		 //外部人员不能通过其他实体查找角色权限，除了组和外部单位
		 V3xOrgMember member = this.getMemberById(memberId);
		 if(member.isV5External()){
			 teamMembers = this.getUserDomainIDs(memberId, accountId,ORGENT_TYPE.Member.name(),ORGENT_TYPE.Team.name(),ORGENT_TYPE.Department.name());
		 }else if(member.getIsAdmin()){
			 //管理员不能通过其他实体查找角色权限
			 teamMembers = Strings.newArrayList(memberId);
		 }else if(accountId!=null&&accountId.equals(OrgConstants.GROUPID)){
			 //如果是集团角色分配
			 teamMembers = this.getUserDomainIDs(memberId, AppContext.currentAccountId(), 
					 ORGENT_TYPE.Account.name(),
					 ORGENT_TYPE.Member.name(),
					 ORGENT_TYPE.Department.name(),
					 ORGENT_TYPE.Post.name(),
					 ORGENT_TYPE.Level.name(),
					 ORGENT_TYPE.Team.name());
		 }
		 if(teamMembers==null){
			 teamMembers = this.getUserDomainIDs(memberId, accountId, 
					 ORGENT_TYPE.Account.name(),
					 ORGENT_TYPE.Member.name(),
					 ORGENT_TYPE.Department.name(),
					 ORGENT_TYPE.Post.name(),
					 ORGENT_TYPE.Level.name(),
					 ORGENT_TYPE.Team.name());
		 }
		 List<V3xOrgRelationship> relList = orgCache.getEntityRoleRelastionships(teamMembers, _departmentId, accountId);

		 //管理员和外部人员不能通过整个集团查找角色权限
		 if(!member.getIsAdmin() && member.getIsInternal() && (Boolean)SysFlag.sys_isGroupVer.getFlag()){
			 //增加全集团范围
			 teamMembers.add(OrgConstants.GROUPID);
			 List<V3xOrgRelationship> grouprelList = orgCache.getEntityRoleRelastionships(teamMembers, _departmentId, OrgConstants.GROUPID);
			 relList.addAll(grouprelList);
		 }
		 return  relList;


	 }

	 @Override
	 public List<V3xOrgMember> getMembersByMemberPostOfOnlyUp(long memberId,long postId0, long accountId) throws BusinessException {
		 return getMembersByMemberPostOf(memberId,postId0,accountId,true);
	 }

	 private List<V3xOrgMember> getMembersByMemberPostOf(long memberId,long postId0, long accountId,boolean onlyUp) throws BusinessException {
		 List<V3xOrgMember> members = new UniqueList<V3xOrgMember>();

		 List<Long> accountPosts = this.getAccountPostByBachmarkPost(postId0, accountId);
		 if(accountPosts.isEmpty()){
			 return members;
		 }

		 long postId = accountPosts.get(0);

		 V3xOrgPost post = orgCache.getV3xOrgEntity(V3xOrgPost.class, postId);
		 if(post == null || !post.isValid()){
			 return members;
		 }

		 //岗位和要匹配的单位是同一个单位的才有意义
		 if(Strings.equals(post.getOrgAccountId(), accountId)){
			 List<Long> workDeptIds = this.getWorkDepartments(memberId, accountId);
			 for (Long workDeptId : workDeptIds) {
				 if(onlyUp){
					 members.addAll(this.getMembersByDepartmentPostOfOnlyUp0(workDeptId, postId));
				 }else{
					 members.addAll(this.getMembersByDepartmentPostOfUp0(workDeptId, postId));
				 }
			 }
		 }

		 if(members.isEmpty() && !onlyUp){
			 members = this.getMembersByPost(postId);
		 }

		 return members;
	 }



	 private List<V3xOrgMember> getMembersByDepartmentPostOfOnlyUp0(long departmentId, long postId) throws BusinessException {
		 V3xOrgDepartment dep = getDepartmentById(departmentId);
		 if (dep == null || !dep.isValid()) {
			 return Collections.emptyList();
		 }

		 V3xOrgPost post = getPostById(postId);
		 if (post == null || !post.isValid())
			 return Collections.emptyList();

		 Map<String, List<V3xOrgMember>> dep2Members = new HashMap<String, List<V3xOrgMember>>();

		 List<Long> postIds = getAccountPostByBachmarkPost(postId, dep.getOrgAccountId());
		 if(postIds.isEmpty()){
			 return Collections.emptyList();
		 }

		 EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
		 enummap.put(OrgConstants.RelationshipObjectiveName.objective1Id, postIds);

		 List<V3xOrgRelationship> ents = orgCache.getV3xOrgRelationship(RelationshipType.Member_Post, (Long)null, (Long)null, enummap);
		 Collections.sort(ents, CompareSortRelationship.getInstance());

		 for (V3xOrgRelationship rel : ents) {
			 if(!isValidMemberPost(rel)){
				 continue;
			 }
			 V3xOrgDepartment d = orgCache.getV3xOrgEntity(V3xOrgDepartment.class, rel.getObjective0Id());
			 V3xOrgMember m = orgCache.getV3xOrgEntity(V3xOrgMember.class, rel.getSourceId());
			 if (d != null && d.isValid() && m != null && m.isValid()) {
				 Strings.addToMap(dep2Members, d.getPath(), m);
			 }
		 }

		 if(dep2Members.isEmpty()){
			 return Collections.emptyList();
		 }

		 List<V3xOrgDepartment> allParentDept = this.getAllParentDepartments(departmentId);

		 List<V3xOrgDepartment> _allParentDept = new ArrayList<V3xOrgDepartment>(allParentDept);
		 _allParentDept.add(dep); //先从我的部门开始
		 String currentPath = dep.getPath();
		 for (int i = _allParentDept.size(); i > 0; i--) {
			 String path = _allParentDept.get(i - 1).getPath();
			 List<V3xOrgMember> result = new ArrayList<V3xOrgMember>();

			 for (Iterator<Map.Entry<String, List<V3xOrgMember>>> iter = dep2Members.entrySet().iterator(); iter.hasNext();) {
				 Map.Entry<String, List<V3xOrgMember>> entry = iter.next();
				 String p = entry.getKey();
				 List<V3xOrgMember> ms = entry.getValue();

				 if(p.startsWith(path) && currentPath.indexOf(p)==0){
					 result.addAll(ms);
				 }                      
			 }

			 if(!result.isEmpty()){
				 return result;
			 }
		 }

		 return Collections.emptyList();
	 }


	 @Override
	 public boolean isSecondMemberForAccount(Long memberId,Long accountId) throws BusinessException {
		 boolean isSecondMemberForAccount = false;
		 List<MemberPost> list =  getMemberPosts0(accountId, memberId, MemberPostType.Concurrent);
		 if(null!=list && list.size()>0){
			 isSecondMemberForAccount = true;
		 }
		 return isSecondMemberForAccount;
	 }

	 @Override
	 public Map<String,Object> getUpdateEntityAndLastTime(String entityClassName,Date updateTime,Long accountId) throws BusinessException{
		 Map<String,Object> result = new HashMap<String, Object>();
		 List<V3xOrgEntity> list = new UniqueList<V3xOrgEntity>();
		 Date lastDate = updateTime;
		 List<BasePO> entityList = orgDao.getAllEntityPO(entityClassName,accountId,updateTime);
		 for(BasePO entity : entityList){
			 V3xOrgEntity bo = OrgHelper.poTobo(entity);
			 Date ut = bo.getUpdateTime();
			 if(null == lastDate || ut.compareTo(lastDate)>0) {
				 lastDate = ut;
			 }
			 list.add(bo);
		 }
		 result.put("list", list);
		 result.put("lastDate", lastDate);
		 return result;
	 }

	 @Override
	 public List<V3xOrgMember> getAllMembersWithDisable(Long accountId){
		 List<BasePO> memberPoList = orgDao.getAllEntityPO(V3xOrgMember.class.getSimpleName(),accountId,null);
		 List<V3xOrgMember> members = (List<V3xOrgMember>) OrgHelper.listPoTolistBo(memberPoList);
		 return members;
	 }

	 @Override
	 public String checkCanLeave(Long memberId) throws BusinessException{
		 String result = null;
		 V3xOrgMember member = this.getMemberById(memberId);
		 List<V3xOrgDepartment> departments = getDeptsByManager(memberId, member.getOrgAccountId());
		 if(Strings.isNotEmpty(departments)){
			 for(V3xOrgDepartment department : departments){
				 boolean createDeptSpace = spaceApi.isCreateDepartmentSpace(department.getId());
				 if(createDeptSpace){
					 String deptName = department.getName();
					 V3xOrgRole role = getRoleByName(Role_NAME.DepManager.name(), department.getOrgAccountId());
					 String roleName = role.getName();
					 return ResourceUtil.getString("MessageStatus.DEPMANAGER_EXIST_CANNOT_DEL", deptName,roleName);
				 }
			 }
		 }
		 return result;
	 }

	 /**
	  * 只给快速查询用的，每次最多只返回十条数据
	  */
	 @Override
	 public List<V3xOrgEntity> getDisableEntity(String entityClassName ,Long accountId,String condition, Object feildvalue){
		 List<BasePO> memberPoList = orgDao.getDisableEntityPO(entityClassName,accountId,condition,feildvalue);
		 List<V3xOrgEntity> entitys = (List<V3xOrgEntity>) OrgHelper.listPoTolistBo(memberPoList);
		 return entitys;
	 }

	 @Override
	 public String getAvatarImageUrl(Long memberId){
		 return OrgHelper.getAvatarImageUrl(memberId);
	 }

	 @Override
	 @AjaxAccess
	 public String showDepartmentFullPath(Long deptId) throws BusinessException {
		 return OrgHelper.showDepartmentFullPath(deptId);
	 }
}
