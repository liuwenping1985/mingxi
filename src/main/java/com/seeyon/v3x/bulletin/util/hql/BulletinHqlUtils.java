package com.seeyon.v3x.bulletin.util.hql;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.common.dao.paginate.Pagination;
import com.seeyon.ctp.organization.po.OrgMember;
import com.seeyon.ctp.organization.po.OrgUnit;
import com.seeyon.ctp.portal.util.Constants.SpaceType;
import com.seeyon.ctp.util.SQLWildcardUtil;
import com.seeyon.v3x.bulletin.dao.BulDataDao;
import com.seeyon.v3x.bulletin.domain.BulData;
import com.seeyon.v3x.bulletin.domain.BulPublishScope;
import com.seeyon.v3x.bulletin.domain.BulRead;
import com.seeyon.v3x.bulletin.domain.BulType;
import com.seeyon.v3x.bulletin.util.Constants;
import com.seeyon.v3x.bulletin.util.Constants.VisitRole;

/**
 * 公告Hql工具类，在重构获取公告列表的代码时应运而生。
 * @author <a href="mailto:yangm@seeyon.com">Rookie Young</a> 2010-7-30
 */
public class BulletinHqlUtils extends PublicInfoHqlUtils {

	private static final Log logger = LogFactory.getLog(BulletinHqlUtils.class);
	/** 公告主表别名 */
	private static final String BulData_Alias = "t_bul_data";
	/** 公告阅读表别名 */
	private static final String BulRead_Alias = "t_bul_read";
	/** 公告发布范围表别名 */
	private static final String BulPublishScope_Alias = "t_bul_scope";
	/** 公告板块表别名 */
	private static final String BulType_Alias = "t_bul_type";
	/** 人员表别名 */
	private static final String V3xOrgMember_Alias = "t_org_member";
	/** 单位表别名 */
	private static final String V3xOrgUnit_Alias = "t_org_unit";
	/** 需要去重时的hql语句关键词 */
	private static final String DISTINCT = "distinct ";

    /**
     * 用户角色场景下，查询公告列表时所要获取的公告字段
     */
    private static final List<String> Selected_Fields       = Arrays.asList("id", "title", "publishDepartmentId", "dataFormat", "createDate", "createUser", "publishDate", "publishUserId", "readCount",
            "topOrder", "accountId", "typeId", "state", "attachmentsFlag", "auditUserId", "ext5", "showPublishUserFlag", "updateDate" , "writePublish" , "publishChoose");

	/**
	 * 用户角色场景下，Hql语句中选择字段部分的内容
	 */
	private static String getSelectedFieldsHql() {
		StringBuilder result = new StringBuilder();
		for(String field : Selected_Fields) {
			result.append(BulData_Alias + '.' + field + ',');
		}
		return result.substring(0, result.length() - 1);
	}

    public static final String Hql_Selected_Fields         = getSelectedFieldsHql();

	/**
	 * <pre>
	 * 公告模块中存在大量查看公告列表信息的场景，简要梳理，可发现其包括了四种不同角色为主线的访问模式：
	 * 1.用户以<b>普通用户角色</b>查看整个单位或集团公告板块下的已发布公告，
	 *   或某一特定公告板块(部门公告是这种情况下的特例)下的已发布公告，
	 *   或所有空间的所有板块下的已发布公告("我的公告")，
	 *   此时需要获取用户对公告的阅读信息，一般也需要进行发布范围匹配(如用户为管理员则除外)；
	 * 2.用户以<b>发起人角色</b>进入某一公告板块查看自己发起的公告列表，不获取阅读信息，不进行范围匹配；
	 * 3.用户以<b>审核员角色</b>查看自己在某一单位或集团下需审核的公告列表，不获取阅读信息，不进行范围匹配；
	 * 4.用户以<b>管理员角色</b>查看其所管理的某一板块下的所有已发布公告，不获取阅读信息，不进行范围匹配；
	 * 5.在以上各种情况中，用户一般都可以按照不同的<b>搜索条件</b>，
	 *   如：标题、发布人、发布日期、所属板块等输入<b>搜索条件值</b>进行搜索；
	 * 6.用户在<b>综合查询界面</b>输入各种查询条件查看对应的公告列表，不需获取阅读信息，视查询条件进行范围匹配。
	 *
	 * 一言以蔽之：
	 * 有4 + <b>1</b>(特殊情况：用户角色时，该用户为板块管理员)种不同角色
	 * 在3 + <b>1</b>(不限定空间类型，也即全部空间)种不同空间中的某一板块或全部板块
	 * 按6种目前已有的搜索类型
	 * 查询与角色对应状态的公告列表
	 *
	 * 因此，最终结果的影响因素有三：
	 * 1.<b>用户信息</b>：包括用户的访问角色及进行发布范围匹配所需的信息等；
	 * 2.<b>板块信息</b>：查看某种空间下的全部或某一公告板块等；
	 * 3.<b>搜索信息</b>：用户进行搜索的类型及属性值。
	 * 
	 * 用于查询的Hql语句由四部分组成：
	 * <tt>select fields... (所要选择的字段) from tables...(关联的表) where conditions... (约束条件) order by ... (排序方式)</tt>
	 * 以上三个影响因素决定了这四部分的最终结果。
	 * 
	 * 在不同的场景中，将以上三个影响因素模型自Controller或Manager层进行包装和设值，
	 * <b>便可调用此方法来获取各种不同场景下的Hql语句及其命名参数键值对，随后据此获取公告列表结果值。</b>
	 * 参见：{@link #findBulDatas(UserInfo, TypeInfo, SearchInfo, PageInfo, BulDataDao)}。
	 * 
	 * 某些较为特殊的情况下（如首页栏目取最新8条公告、公告首页每个板块取6条最新公告），
	 * 分页信息对最终结果也会有所影响，但可以在获取结果时{@link #findBulDatas(UserInfo, TypeInfo, SearchInfo, PageInfo, BulDataDao)}
	 * 利用ThreadLocal将分页信息设入，这样，在生成Hql语句时，就无需考虑分页信息的影响。
	 *
	 * 主要目的在于消除{@link com.seeyon.v3x.bulletin.manager.BulDataManagerImpl}中的大量重复代码，便于单点维护。
	 * </pre>
	 * @param userInfo		用户信息，此参数传入时<b>不会</b>为空
	 * @param typeInfo		板块信息，此参数传入时<b>不会</b>为空
	 * @param searchInfo	搜索信息，此参数传入时<b>可能</b>为空
	 */
	public static HqlResult getHqlResult(UserInfo userInfo, TypeInfo typeInfo, SearchInfo searchInfo) {
		Map<String, Object> params = new HashMap<String, Object>();
		StringBuilder select = new StringBuilder("select ");
		StringBuilder from = new StringBuilder(" from ");
		StringBuilder where = new StringBuilder(" where ");
		StringBuilder orderBy = new StringBuilder(" order by ");

		switch(userInfo.getRole()) {
		case User:
			setHqlAndParams4User(userInfo, typeInfo, searchInfo, select, from, where, orderBy, params);
			break;
		case Poster:
			setHqlAndParams4Poster(userInfo, typeInfo, searchInfo, select, from, where, orderBy, params);
			break;
		case Auditor:
			setHqlAndParams4Auditor(userInfo, typeInfo, searchInfo, select, from, where, orderBy, params);
			break;
		case Admin:
			setHqlAndParams4Admin(userInfo, typeInfo, searchInfo, select, from, where, orderBy, params);
			break;
		//客开 start
  	    case Typesetting:
          setHqlAndParams4Typesetting(userInfo, typeInfo, searchInfo, select, from, where, orderBy, params);
          break;
        }
		//客开end

		HqlResult result = new HqlResult(select.toString() + from + where + orderBy, params);
		result.setDistinct(select.toString().indexOf(DISTINCT) != -1);
		result.setDistinctColumn(BulData_Alias + '.' + "id");
		return result;
	}
	/**
	 * 政务【我的提醒】查【单位公告】总数 (根据getHqlResult改造) wangjingjing
	 */
	public static HqlResult getHqlResultCount(UserInfo userInfo, TypeInfo typeInfo, SearchInfo searchInfo) {
		Map<String, Object> params = new HashMap<String, Object>();
		StringBuilder select = new StringBuilder("select ");
		StringBuilder from = new StringBuilder(" from ");
		StringBuilder where = new StringBuilder(" where ");
		StringBuilder orderBy = new StringBuilder(" order by ");

		switch(userInfo.getRole()) {
		case User:
			setHqlAndParams4User(userInfo, typeInfo, searchInfo, select, from, where, orderBy, params);
			break;
		case Poster:
			setHqlAndParams4Poster(userInfo, typeInfo, searchInfo, select, from, where, orderBy, params);
			break;
		case Auditor:
			setHqlAndParams4Auditor(userInfo, typeInfo, searchInfo, select, from, where, orderBy, params);
			break;
		case Admin:
			setHqlAndParams4Admin(userInfo, typeInfo, searchInfo, select, from, where, orderBy, params);
			break;
			//客开 start
        case Typesetting:
          setHqlAndParams4Typesetting(userInfo, typeInfo, searchInfo, select, from, where, orderBy, params);
          break;
        }
        //客开end

		HqlResult result = new HqlResult("select count("+Hql_Selected_Fields.split(",")[0] + ")" + from + where, params);
		result.setDistinct(select.toString().indexOf(DISTINCT) != -1);
		result.setDistinctColumn(BulData_Alias + '.' + "id");
		return result;
	}
	
	/** 用户角色场景处理  */
	private static void setHqlAndParams4User(UserInfo userInfo, TypeInfo typeInfo, SearchInfo searchInfo,
			StringBuilder select, StringBuilder from, StringBuilder where, StringBuilder orderBy, Map<String, Object> params) {
		boolean isDistinct = !userInfo.isAdminAsUser() && typeInfo.getSpaceType() != SpaceType.department &&
		 					 (searchInfo == null || !userInfo.getUserId().equals(searchInfo.getCreatorId()));
		boolean fromIsearch = searchInfo != null && searchInfo.isFromIsearch();
		
		// SZP 按公司、分公司、子公司查询发布公告
		List<Long> domainIds = userInfo.getDomainIds();
        domainIds.add(-4494177213242261212L); // 查询 中国信达分公司 SZP
        domainIds.add(-3451572810087969062L);// 查询 中国信达子公司  SZP
        domainIds.add(-2329940225728493295L); // 查询 中国信达资产管理股份有限公司 SZP
        
		//区分当前场景是否需要去重复
		if(isDistinct) {
			//区分是否综合查询场景
			select.append(Hql_Selected_Fields);
			from.append(BulData.class.getName() + " as " + BulData_Alias);
			//综合查询所得结果目前不需获取阅读信息，其他场景需要获取阅读信息
			if(!fromIsearch) {
				params.put("userId", userInfo.getUserId());
			}
			where.append(BulData_Alias+".id in(select "+BulPublishScope_Alias + ".bulDataId from " + BulPublishScope.class.getName() + " as " + BulPublishScope_Alias+" where ");
			where.append(BulPublishScope_Alias + ".bulDataId=" + BulData_Alias + ".id and ");
			where.append(BulData_Alias + ".state=:published and " + BulData_Alias + ".deletedFlag=false " +
					 (fromIsearch ? "" : " and ("+(BulData_Alias + ".createUser=:userId or " + BulData_Alias + ".auditUserId=:userId or " + BulData_Alias + ".publishUserId=:userId or ")) +
					 	(fromIsearch ? "and(" : "") + BulPublishScope_Alias + ".userId in (:userDomainIds) ) ) ");
			
			//某个空间所有公告板块，此时获取的公告只按发布日期降序排列
			if(typeInfo.getTypeId() == null || Long.valueOf(-1L).equals(typeInfo.getTypeId())) {
				if(typeInfo.getSpaceType() !=null && (typeInfo.getSpaceType().ordinal() != SpaceType.personal.ordinal()) //这里由于枚举的变更，综合查询的时候文化建设这点使用这个枚举来代替
				    ||(typeInfo.getSpaceType().ordinal() == SpaceType.personal.ordinal() && Long.valueOf(-1L).equals(typeInfo.getTypeId()))) { //个人公告查询根据单位过滤
					where.append(" and " + BulData_Alias + ".accountId=:accountId ");
					params.put("accountId", typeInfo.getAccountId());
				}
				orderBy.append(BulData_Alias + ".publishDate desc ");
			}
			//某个特定公告板块，此时获取的公告按照置顶号、发布日期降序排列
			else {
				where.append(" and " +BulData_Alias + ".typeId=:typeId ");
				params.put("typeId", typeInfo.getTypeId());
				orderBy.append(BulData_Alias + ".topOrder desc, " + BulData_Alias + ".publishDate desc ");
			}

			params.put("userDomainIds", domainIds);
		}
		else {
			select.append(Hql_Selected_Fields);
			from.append(BulData.class.getName() + " as " + BulData_Alias);
			if(!fromIsearch) {
				params.put("userId", userInfo.getUserId());
			}
            where.append(BulData_Alias+".id in(select "+BulPublishScope_Alias + ".bulDataId from " + BulPublishScope.class.getName() + " as " + BulPublishScope_Alias+" where ");
			where.append(BulPublishScope_Alias + ".bulDataId=" + BulData_Alias + ".id and ");
			where.append(BulData_Alias + ".state=:published and " + BulData_Alias + ".deletedFlag=false " +
					 (fromIsearch ? ")" : " and ("+(BulData_Alias + ".createUser=:userId or " + BulData_Alias + ".auditUserId=:userId or " + BulData_Alias + ".publishUserId=:userId or ") +
					 	 BulPublishScope_Alias + ".userId in (:userDomainIds) ) ) "));
			if(typeInfo.getTypeId() != null) {
				where.append(" and " + BulData_Alias + ".typeId=:typeId ");
				params.put("typeId", typeInfo.getTypeId());
				orderBy.append(BulData_Alias + ".topOrder desc, " + BulData_Alias + ".publishDate desc ");
			}
			else {
				orderBy.append(BulData_Alias + ".publishDate desc ");
			}
			if (!fromIsearch) {
                params.put("userDomainIds", domainIds);
            }
		}
		params.put("published", Constants.DATA_STATE_ALREADY_PUBLISH);
		
		handleSearchInfo(searchInfo, from, where, params);
	}

	/** 发起人角色场景处理  */
	private static void setHqlAndParams4Poster(UserInfo userInfo, TypeInfo typeInfo, SearchInfo searchInfo,
			StringBuilder select, StringBuilder from, StringBuilder where, StringBuilder orderBy, Map<String, Object> params) {
		select.append(BulData_Alias);
		from.append(BulData.class.getName() + " as " + BulData_Alias);
		where.append(BulData_Alias + ".typeId=:typeId and " + BulData_Alias + ".createUser=:userId and " +
					 BulData_Alias + ".state in (:notPublishedStates) and " + BulData_Alias + ".deletedFlag=false");
		orderBy.append(BulData_Alias + ".createDate desc ");
		
		params.put("typeId", typeInfo.getTypeId());
		params.put("userId", userInfo.getUserId());
		params.put("notPublishedStates", Constants.getDataStatesNoPublish());

		handleSearchInfo(searchInfo, from, where, params);
	}

	/** 审核员角色场景处理  */
	private static void setHqlAndParams4Auditor(UserInfo userInfo, TypeInfo typeInfo, SearchInfo searchInfo,
			StringBuilder select, StringBuilder from, StringBuilder where, StringBuilder orderBy, Map<String, Object> params) {
		select.append(BulData_Alias);
		from.append(BulData.class.getName() + " as " + BulData_Alias + ", " + BulType.class.getName() + " as " + BulType_Alias);
		where.append(BulData_Alias + ".deletedFlag=false and " + BulType_Alias + ".accountId=:accountId and " + BulType_Alias + ".spaceType=:spaceType and " +
					 BulType_Alias + ".auditUser=:auditUserId and (" + BulData_Alias + ".state=:wait4Audit or " + BulData_Alias + ".state=:auditPassed)" +
					 " and " + BulData_Alias + ".typeId=" + BulType_Alias + ".id ");
		orderBy.append(BulData_Alias + ".createDate desc ");
		
		params.put("accountId", typeInfo.getAccountId());
		params.put("spaceType", typeInfo.getSpaceType().ordinal());
		params.put("auditUserId", userInfo.getUserId());
		params.put("wait4Audit", Constants.DATA_STATE_ALREADY_CREATE);
		params.put("auditPassed", Constants.DATA_STATE_ALREADY_AUDIT);

		handleSearchInfo(searchInfo, from, where, params);
	}
	//客开 start
	/** 排版员角色场景处理  */
	private static void setHqlAndParams4Typesetting(UserInfo userInfo, TypeInfo typeInfo, SearchInfo searchInfo,
	    StringBuilder select, StringBuilder from, StringBuilder where, StringBuilder orderBy, Map<String, Object> params) {
	  select.append(BulData_Alias);
	  from.append(BulData.class.getName() + " as " + BulData_Alias + ", " + BulType.class.getName() + " as " + BulType_Alias);
	  where.append(BulData_Alias + ".deletedFlag=false and " + BulType_Alias + ".accountId=:accountId and " + BulType_Alias + ".spaceType=:spaceType and " +
	      BulType_Alias + ".typesettingStaff=:typesettingStaff and (" + BulData_Alias + ".state=:wait4Audit or " + BulData_Alias + ".state=:auditPassed)" +
	      " and " + BulData_Alias + ".typeId=" + BulType_Alias + ".id ");
	  orderBy.append(BulData_Alias + ".createDate desc ");
	  
	  params.put("accountId", typeInfo.getAccountId());
	  params.put("spaceType", typeInfo.getSpaceType().ordinal());
	  params.put("typesettingStaff", userInfo.getUserId());
	  params.put("wait4Audit", Constants.DATA_STATE_TYPESETTING_CREATE);
	  params.put("auditPassed", Constants.DATA_STATE_TYPESETTING_PASS);
	  
	  handleSearchInfo(searchInfo, from, where, params);
	}
	//客开 end
	

	/** 管理员角色场景处理  */
	private static void setHqlAndParams4Admin(UserInfo userInfo, TypeInfo typeInfo, SearchInfo searchInfo,
			StringBuilder select, StringBuilder from, StringBuilder where, StringBuilder orderBy, Map<String, Object> params) {
		select.append(Hql_Selected_Fields);
		from.append(BulData.class.getName() + " as " + BulData_Alias);
		where.append(BulData_Alias + ".typeId=:typeId and " + BulData_Alias + ".state=:published and " + BulData_Alias + ".deletedFlag=false ");
		orderBy.append(BulData_Alias + ".topOrder desc, " + BulData_Alias + ".publishDate desc ");
		
		params.put("published", Constants.DATA_STATE_ALREADY_PUBLISH);
		params.put("typeId", typeInfo.getTypeId());

		handleSearchInfo(searchInfo, from, where, params);
	}

	/**
	 * 处理搜索信息对Hql语句中表关联(from)、查询条件(where)的影响并将对应命名参数及其值加入Map
	 */
	public static void handleSearchInfo(SearchInfo searchInfo, StringBuilder from, StringBuilder where, Map<String, Object> params) {
		if(searchInfo != null) {
			if(StringUtils.isNotBlank(searchInfo.getTitle())) {
				where.append(" and " + BulData_Alias + ".title like :title ");
				params.put("title", "%" + SQLWildcardUtil.escape(searchInfo.getTitle().trim()) + "%");
			}

			if(StringUtils.isNotBlank(searchInfo.getCreatorName())) {
				from.append(", " + OrgMember.class.getName() + " as " + V3xOrgMember_Alias);
				where.append(" and " + BulData_Alias + ".publishUserId=" + V3xOrgMember_Alias + ".id " +
							 " and " + V3xOrgMember_Alias + ".name like :creatorName ");
				params.put("creatorName", "%" + SQLWildcardUtil.escape(searchInfo.getCreatorName().trim()) + "%");
			}

			if(searchInfo.getCreatorId() != null) {
				where.append(" and " + BulData_Alias + ".createUser = :creatorId ");
				params.put("creatorId", searchInfo.getCreatorId());
			}

			//按照日期区间查询目前暂只有按发布日期，日后也可以很方便地扩展到创建日期、审核日期等
			if(searchInfo.getBeginDate() != null) {
				where.append(" and " + BulData_Alias + ".publishDate >= :beginDate ");
				params.put("beginDate", searchInfo.getBeginDate());
			}

			if(searchInfo.getEndDate() != null) {
				where.append(" and " + BulData_Alias + ".publishDate <= :endDate ");
				params.put("endDate", searchInfo.getEndDate());
			}

			if(searchInfo.getBulTypeId() != null) {
				where.append(" and " + BulData_Alias + ".typeId = :selectedTypeId ");
				params.put("selectedTypeId", searchInfo.getBulTypeId());
			}
			
			if(searchInfo.getPublishDepartmentName() != null) {
				from.append(", " + OrgUnit.class.getName() + " as " + V3xOrgUnit_Alias);
				where.append(" and " + BulData_Alias + ".publishDepartmentId=" + V3xOrgUnit_Alias + ".id " +
							 " and " + V3xOrgUnit_Alias + ".name like :publishDepartmentName ");
				params.put("publishDepartmentName", "%" + SQLWildcardUtil.escape(searchInfo.getPublishDepartmentName().trim()) + "%");
			}
			
			//目前暂未用到，可用于日后扩展
			if(searchInfo.getTopFlag() != null) {
				if(searchInfo.getTopFlag().booleanValue())
					where.append(" and " + BulData_Alias + ".topOrder>0 ");
				else
					where.append(" and " + BulData_Alias + ".topOrder=0 ");
			}
		}
	}
	
	/**
	 * 根据用户信息和板块信息获取所要查看的公告列表，是最简化的情况，分页信息默认，无搜索信息
	 * @return 不同角色所要查看的公告列表，视前端展现需要，可能还需在随后进行初始化操作
	 * @see com.seeyon.v3x.bulletin.util.BulletinUtils#initList(List)
	 */
	public static List<BulData> findBulDatas(UserInfo userInfo, TypeInfo typeInfo, BulDataDao bulDataDao) {
		return findBulDatas(userInfo, typeInfo, null, bulDataDao);
	}

	/**
	 * 根据用户信息、板块信息以及搜索信息，获取所要查看的公告列表，此时分页信息自Request中获取，经ThreadLocal传输至BaseHibernateDao中
	 * @param userInfo		用户信息
	 * @param typeInfo		板块信息
	 * @param searchInfo	搜索信息
	 * @return 不同角色所要查看的公告列表，视前端展现需要，可能还需在随后进行初始化操作
	 * @see com.seeyon.v3x.bulletin.util.BulletinUtils#initList(List)
	 */
	public static List<BulData> findBulDatas(UserInfo userInfo, TypeInfo typeInfo, SearchInfo searchInfo, BulDataDao bulDataDao) {
		return findBulDatas(userInfo, typeInfo, searchInfo, null, bulDataDao);
	}
	
	
	//**********************2012-11-06 yangwulin Sprint4 begin****************************************************************
	/**
	 * yangwulin Sprint4 2012-11-06 
     * 根据用户信息、板块信息以及搜索信息，获取所要查看的公告列表，此时分页信息自Request中获取，经ThreadLocal传输至BaseHibernateDao中
     * @param userInfo      用户信息
     * @param typeInfo      板块信息
     * @param searchInfo    搜索信息
     * @return 不同角色所要查看的公告列表，视前端展现需要，可能还需在随后进行初始化操作
     * @see com.seeyon.v3x.bulletin.util.BulletinUtils#initList(List)
     */
    public static List<BulData> findBulDatasByTypeId(UserInfo userInfo, TypeInfo typeInfo, SearchInfo searchInfo, BulDataDao bulDataDao,String bulTypeId) {
        return findBulDatas(userInfo, typeInfo, searchInfo, null, bulDataDao,bulTypeId);
    }
    
    /**
     * yangwulin Sprint4 2012-11-06 
     * 根据用户信息、板块信息、搜索信息及分页信息（需手动设置进行干预的情况），获取所要查看的公告列表
     * @param userInfo      用户信息
     * @param typeInfo      板块信息
     * @param searchInfo    搜索信息
     * @param pageInfo      分页信息
     * @return 不同角色所要查看的公告列表，视前端展现需要，可能还需在随后进行初始化操作
     * @see com.seeyon.v3x.bulletin.util.BulletinUtils#initList(List)
     */
    @SuppressWarnings("unchecked")
    public static List<BulData> findBulDatas(UserInfo userInfo, TypeInfo typeInfo, SearchInfo searchInfo, PageInfo pageInfo, BulDataDao bulDataDao,String bulTypeId) {
        HqlResult hqlResult = getHqlResultByTypeId(userInfo, typeInfo, searchInfo,bulTypeId);
        
        if(pageInfo != null) {
            Pagination.setNeedCount(pageInfo.isNeedCount());
            if(pageInfo.getFirstResult() != -1)
                Pagination.setFirstResult(pageInfo.getFirstResult());
            
            if(pageInfo.getMaxResults() != -1)
                Pagination.setMaxResults(pageInfo.getMaxResults());
        }
        
        if(userInfo.getRole() == VisitRole.User) {
            boolean fromIsearch = searchInfo != null && searchInfo.isFromIsearch();
            List<Object[]> objs = null;
            if(hqlResult.isDistinct()) {
                objs = bulDataDao.find(hqlResult.getHql(), hqlResult.getDistinctColumn(), true, hqlResult.getNamedParameter());
            }
            else {
                objs = bulDataDao.find(hqlResult.getHql(), hqlResult.getNamedParameter());
            }
            return parseObjArrs2BulDatas(objs, fromIsearch, bulDataDao);
        }
        else {
            return bulDataDao.find(hqlResult.getHql(), hqlResult.getNamedParameter());
        }
    }
    
    /**
     * yangwulin Sprint4 2012-11-06 
     * @param userInfo
     * @param typeInfo
     * @param searchInfo
     * @param bulTypeId
     * @return
     */
    public static HqlResult getHqlResultByTypeId(UserInfo userInfo, TypeInfo typeInfo, SearchInfo searchInfo,String bulTypeId) {
        Map<String, Object> params = new HashMap<String, Object>();
        StringBuilder select = new StringBuilder("select ");
        StringBuilder from = new StringBuilder(" from ");
        StringBuilder where = new StringBuilder(" where ");
        StringBuilder orderBy = new StringBuilder(" order by ");

        switch(userInfo.getRole()) {
        case User:
            setHqlAndParams4User(userInfo, typeInfo, searchInfo, select, from, where, orderBy, params);
            break;
        case Poster:
            setHqlAndParams4Poster(userInfo, typeInfo, searchInfo, select, from, where, orderBy, params);
            break;
        //yangwulin 2012-11-06 添加代码    
        case Auditor:
            setHqlBulListByTypeId(userInfo, typeInfo, searchInfo, select, from, where, orderBy, params,bulTypeId);
            break;
        case Admin:
            setHqlAndParams4Admin(userInfo, typeInfo, searchInfo, select, from, where, orderBy, params);
            break;
          //客开 start
        case Typesetting:
          setHqlAndParams4Typesetting(userInfo, typeInfo, searchInfo, select, from, where, orderBy, params);
          break;
        }
        //客开end

        HqlResult result = new HqlResult(select.toString() + from + where + orderBy, params);
        result.setDistinct(select.toString().indexOf(DISTINCT) != -1);
        result.setDistinctColumn(BulData_Alias + '.' + "id");
        return result;
    }
    /**
     * 审核员场景处理 yangwulin Sprint4 2012-11-06 审核员在审核的时候，对改板块只能审核该板块的公告
     * @param userInfo
     * @param typeInfo
     * @param searchInfo
     * @param select
     * @param from
     * @param where
     * @param orderBy
     * @param params
     * @param bulTypeId
     */
    private static void setHqlBulListByTypeId(UserInfo userInfo, TypeInfo typeInfo, SearchInfo searchInfo,
            StringBuilder select, StringBuilder from, StringBuilder where, StringBuilder orderBy, Map<String, Object> params,String bulTypeId) {
        select.append(BulData_Alias);
        from.append(BulData.class.getName() + " as " + BulData_Alias + ", " + BulType.class.getName() + " as " + BulType_Alias);
        where.append(BulData_Alias + ".deletedFlag=false and " + BulType_Alias + ".accountId=:accountId and " + BulType_Alias + ".spaceType=:spaceType and " +
                     BulType_Alias + ".auditUser=:auditUserId and (" + BulData_Alias + ".state=:wait4Audit or " + BulData_Alias + ".state=:auditPassed)"  +
                     " and " + BulData_Alias + ".typeId=" + BulType_Alias + ".id ");
        //yangwulin 2012-11-06 添加代码
        if (bulTypeId != null && !"".equals(bulTypeId)) {
            where.append(" and "+BulData_Alias+".typeId=:typeId ");
        }
        orderBy.append(BulData_Alias + ".createDate desc ");
        //yangwulin 2012-11-06 添加代码
        if (bulTypeId != null && !"".equals(bulTypeId)) {
            params.put("typeId", Long.parseLong(bulTypeId));
        }
        params.put("accountId", typeInfo.getAccountId());
        params.put("spaceType", typeInfo.getSpaceType().ordinal());
        params.put("auditUserId", userInfo.getUserId());
        params.put("wait4Audit", Constants.DATA_STATE_ALREADY_CREATE);
        params.put("auditPassed", Constants.DATA_STATE_ALREADY_AUDIT);

        handleSearchInfo(searchInfo, from, where, params);
    }
   //**********************2012-11-06 yangwulin Sprint4 end****************************************************************
    
	
	/**
	 * 根据用户信息、板块信息、搜索信息及分页信息（需手动设置进行干预的情况），获取所要查看的公告列表
	 * @param userInfo		用户信息
	 * @param typeInfo		板块信息
	 * @param searchInfo	搜索信息
	 * @param pageInfo		分页信息
	 * @return 不同角色所要查看的公告列表，视前端展现需要，可能还需在随后进行初始化操作
	 * @see com.seeyon.v3x.bulletin.util.BulletinUtils#initList(List)
	 */
	@SuppressWarnings("unchecked")
	public static List<BulData> findBulDatas(UserInfo userInfo, TypeInfo typeInfo, SearchInfo searchInfo, PageInfo pageInfo, BulDataDao bulDataDao) {
		HqlResult hqlResult = getHqlResult(userInfo, typeInfo, searchInfo);
		
		if(pageInfo != null) {
			Pagination.setNeedCount(pageInfo.isNeedCount());
			if(pageInfo.getFirstResult() != -1)
				Pagination.setFirstResult(pageInfo.getFirstResult());
			
			if(pageInfo.getMaxResults() != -1)
				Pagination.setMaxResults(pageInfo.getMaxResults());
		}
		
		if(userInfo.getRole() == VisitRole.User) {
			boolean fromIsearch = searchInfo != null && searchInfo.isFromIsearch();
			List<Object[]> objs = null;
			if(hqlResult.isDistinct()) {
				objs = bulDataDao.find(hqlResult.getHql(), hqlResult.getDistinctColumn(), true, hqlResult.getNamedParameter());
			}
			else {
				objs = bulDataDao.find(hqlResult.getHql(), hqlResult.getNamedParameter());
			}
			return parseObjArrs2BulDatas(objs, fromIsearch, bulDataDao, userInfo.getUserId());
		} else if (userInfo.getRole() == VisitRole.Admin) {
			boolean fromIsearch = searchInfo != null && searchInfo.isFromIsearch();
			List<Object[]> objs = null;
			objs = bulDataDao.find(hqlResult.getHql(), hqlResult.getNamedParameter());
			return parseObjArrs2BulDatas(objs, fromIsearch, bulDataDao, userInfo.getUserId());
		} else {
			return bulDataDao.find(hqlResult.getHql(), hqlResult.getNamedParameter());
		}
	}
	
	/**
	 * 政务【我的提醒】查【单位公告】总数 (根据findBulDatas改造) wangjingjing
	 * 根据用户信息、板块信息、搜索信息及分页信息（需手动设置进行干预的情况），获取所要查看的公告列表
	 * @param userInfo		用户信息
	 * @param typeInfo		板块信息
	 * @param searchInfo	搜索信息
	 * @param pageInfo		分页信息
	 * @return 不同角色所要查看的公告列表，视前端展现需要，可能还需在随后进行初始化操作
	 * @see com.seeyon.v3x.bulletin.util.BulletinUtils#initList(List)
	 */
	@SuppressWarnings("unchecked")
	public static Long findBulDatasCount(UserInfo userInfo, TypeInfo typeInfo, SearchInfo searchInfo, BulDataDao bulDataDao) {
		if(userInfo.getRole() == VisitRole.User) {
			HqlResult hqlResult = getHqlResult(userInfo, typeInfo, searchInfo);
			boolean fromIsearch = searchInfo != null && searchInfo.isFromIsearch();
			List<Object[]> objs = null;
			if(hqlResult.isDistinct()) {
				objs = bulDataDao.find(hqlResult.getHql(), hqlResult.getDistinctColumn(), true, hqlResult.getNamedParameter());
			}
			else {
				objs = bulDataDao.find(hqlResult.getHql(), hqlResult.getNamedParameter());
			}
			return parseObjArrs2BulDatasCount(objs, fromIsearch, bulDataDao);
		}
		else {
			HqlResult hqlResult = getHqlResultCount(userInfo, typeInfo, searchInfo);
			List<Object> objs = bulDataDao.find(hqlResult.getHql(), hqlResult.getNamedParameter());
			if(null != objs && !objs.isEmpty()){
				return Long.valueOf(objs.get(0).toString());
			}
			return 0L;
		}
	}
	
	/**
	 * 在<b>用户角色场景</b>下，将公告字段数组集合转换为公告集合<br>
	 * 同时在需要读取阅读信息时，将左外联阅读信息表所获取的已阅未读标识设值<br>
	 * 获取大字段：公告的发布范围<br>
	 * @param objArrList 查询结果集
	 * @param fromIsearch 是否处于综合查询场景(不读取阅读信息)
	 * @param bulDataDao
	 * @return List&ltBulData&gt 可能为空，在获取结果后使用时需进行校验
	 */
	public static List<BulData> parseObjArrs2BulDatas(List<Object[]> objArrList, boolean fromIsearch, BulDataDao bulDataDao) {
        return parseObjArrs2BulDatas(objArrList, fromIsearch, bulDataDao, null);
    }
	
	@SuppressWarnings("unchecked")
    public static List<BulData> parseObjArrs2BulDatas(List<Object[]> objArrList, boolean fromIsearch, BulDataDao bulDataDao, Long userId) {
		Map<Long, BulData> bulDataMap = null;
		List<BulData> result = null;
		if(CollectionUtils.isNotEmpty(objArrList)) {
			bulDataMap = new LinkedHashMap<Long, BulData>();
			for(Object[] arr : objArrList) {
				BulData data = new BulData();
				int index = 0;
				for(String fieldName : Selected_Fields) {
					try {
						PropertyUtils.setSimpleProperty(data, fieldName, arr[index++]);
					} catch (Exception e) {
						logger.error("设置公告属性时出现异常：", e);
					}
				}
				bulDataMap.put(data.getId(), data);
			}
		}
		
		if(bulDataMap != null){
			String hql = "select " + BulData_Alias + "." + "id" + ", " + BulData_Alias + "." + "publishScope"
				+ " from " + BulData.class.getName() + " as " + BulData_Alias + " where " + 
			        BulData_Alias + "." + "id" + " in (:ids)";
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("ids", bulDataMap.keySet());
			List<Object[]> objs = bulDataDao. find(hql, -1, -1, params);
			for(Object[] arr : objs) {
				bulDataMap.get((Long)arr[0]).setPublishScope((String)arr[1]);
			}

            if(!fromIsearch && userId != null){
                String hql1 = "select " + BulRead_Alias + ".bulletinId"
                        + " from " + BulRead.class.getName() + " as " + BulRead_Alias + " where " +BulRead_Alias + ".managerId=:userId and "
                        +  BulRead_Alias+".bulletinId in(:ids)";
                    Map<String, Object> params1 = new HashMap<String, Object>();
                    params1.put("ids", bulDataMap.keySet());
                    params1.put("userId", userId);
                    List<Object> objs1 = bulDataDao. find(hql1, -1, -1, params1);
                for(Object arr : objs1) {
                    bulDataMap.get((Long)arr).setReadFlag(true);
                }
            }
			result = new ArrayList<BulData>(bulDataMap.values());
		}
		return result;
	}
	
	/**
	 * 政务【我的提醒】查【单位公告】总数 (根据parseObjArrs2BulDatas改造) wangjingjing
	 * 在<b>用户角色场景</b>下，将公告字段数组集合转换为公告集合<br>,获取公告总条数
	 * 同时在需要读取阅读信息时，将左外联阅读信息表所获取的已阅未读标识设值<br>
	 * 获取大字段：公告的发布范围<br>
	 * @param objArrList 查询结果集
	 * @param fromIsearch 是否处于综合查询场景(不读取阅读信息)
	 * @param bulDataDao
	 * @return List&ltBulData&gt 可能为空，在获取结果后使用时需进行校验
	 */
	@SuppressWarnings("unchecked")
	public static Long parseObjArrs2BulDatasCount(List<Object[]> objArrList, boolean fromIsearch, BulDataDao bulDataDao) {
		Map<Long, BulData> bulDataMap = null;
		if(CollectionUtils.isNotEmpty(objArrList)) {
			bulDataMap = new LinkedHashMap<Long, BulData>();
			for(Object[] arr : objArrList) {
				BulData data = new BulData();
				int index = 0;
				for(String fieldName : Selected_Fields) {
					try {
						PropertyUtils.setSimpleProperty(data, fieldName, arr[index++]);
					} catch (Exception e) {
						logger.error("设置公告属性时出现异常：", e);
					}
				}
				if(data.getReadFlag().equals(false))
				bulDataMap.put(data.getId(), data);
			}
		}
		
		if(bulDataMap != null && !bulDataMap.isEmpty()){
			String hql = "select count(" + BulData_Alias + "." + "id" 
				+ ") from " + BulData.class.getName() + " as " + BulData_Alias + " where " + BulData_Alias + "." + "id" + " in (:ids)";
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("ids", bulDataMap.keySet());
			List<Object> objs = bulDataDao. find(hql, -1, -1, params);
			if(null != objs && !objs.isEmpty()){
				return Long.valueOf(objs.get(0).toString());
			}
		}
		return null;
	}
	
	/**
	 * 为保留、兼容老接口而增加的方法，以前公告按照发布时间查询时不支持区间查询<br>
	 * 比如：{@link com.seeyon.v3x.bulletin.manager.BulDataManagerImpl#deptFindByReadUser(long, long, String, String)}<br>
	 * @param property	搜索类型
	 * @param value		搜索值（按照日期查询时，搜索值只有一个）
	 */
	public static SearchInfo getSearchInfo(String property, Object value) {
		String propValue = value == null ? null : value.toString();
		return getSearchInfo(property, propValue, PublicInfoHqlUtils.Only_One_Date);
	}
	
	/**
	 * 为M1提供接口：获取指定公告板块中当前登陆用户有权限访问的公告数
	 * @param userInfo
	 * @param typeInfo
	 * @param bulDataDao
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static Long getBulDatasCount(UserInfo userInfo, TypeInfo typeInfo, BulDataDao bulDataDao) {
		HqlResult hqlResult = getHqlResultToGetCount(userInfo, typeInfo);
		
		List<Object> objs = null;
		
		if(userInfo.getRole() == VisitRole.User) {//如果是普通用户
			if(hqlResult.isDistinct()) {
				objs = bulDataDao.find(hqlResult.getHql(), hqlResult.getDistinctColumn(), true, hqlResult.getNamedParameter());
			}else {
				objs = bulDataDao.find(hqlResult.getHql(), hqlResult.getNamedParameter());
			}
		} else {//如果是公告管理员
			objs = bulDataDao.find(hqlResult.getHql(), hqlResult.getNamedParameter());
		}
		
		if(null != objs && !objs.isEmpty()){
			return Long.valueOf(objs.get(0).toString());
		}
		
		return 0L;
	}
	/**
	 * 为M1提供接口：生成统计公告板块中当前用户有权限查看的公告数的SQL
	 * @param userInfo
	 * @param typeInfo
	 * @return
	 */
	public static HqlResult getHqlResultToGetCount(UserInfo userInfo, TypeInfo typeInfo) {
		Map<String, Object> params = new HashMap<String, Object>();
		StringBuilder select = new StringBuilder("select ");
		StringBuilder from = new StringBuilder(" from ");
		StringBuilder where = new StringBuilder(" where ");

		setHqlAndParams4UserToGetCount(userInfo, typeInfo, select, from, where, params);


		HqlResult result = new HqlResult(select.toString() + from + where , params);
		result.setDistinct(select.toString().indexOf(DISTINCT) != -1);
		result.setDistinctColumn(BulData_Alias + '.' + "id");
		
		return result;
	}
	/**
	 * 为M1提供接口：生成统计公告板块中当前用户有权限查看的公告数的SQL
	 * @param userInfo
	 * @param typeInfo
	 * @param select
	 * @param from
	 * @param where
	 * @param params
	 */
	private static void setHqlAndParams4UserToGetCount(UserInfo userInfo, TypeInfo typeInfo,StringBuilder select, StringBuilder from, StringBuilder where, Map<String, Object> params) {
		boolean isDistinct = !userInfo.isAdminAsUser() && typeInfo.getSpaceType() != SpaceType.department;
		
		select.append("count("+DISTINCT + BulData_Alias+".id) ");
		
		//判断是否需要去重(当为普通用户时，需要根据发布范围查询，可能会出现重复数据；如果是管理员，无需根据发布范围查询，因此不会出现重复数据。)
		if(isDistinct) {
			from.append(BulData.class.getName() + " as " + BulData_Alias);
			
			from.append(", " + BulPublishScope.class.getName() + " as " + BulPublishScope_Alias);
			where.append(BulPublishScope_Alias + ".bulDataId=" + BulData_Alias + ".id and ");
			
			//某个空间所有公告板块，此时获取的公告只按发布日期降序排列
			if(typeInfo.getTypeId() != null) {
				where.append(BulData_Alias + ".typeId=:typeId and ");
				params.put("typeId", typeInfo.getTypeId());
			}

			where.append(BulData_Alias + ".state=:published and " + BulData_Alias + ".deletedFlag=false and " +
						 "(" + BulData_Alias + ".createUser=:userId or " 
						     + BulData_Alias + ".auditUserId=:userId or " 
						     + BulData_Alias + ".publishUserId=:userId or " 
						     + BulPublishScope_Alias + ".userId in (:userDomainIds) " +
						 ")");
			params.put("userId", userInfo.getUserId());
			
			// SZP 按公司、分公司、子公司查询发布公告
			List<Long> domainIds = userInfo.getDomainIds();
	        domainIds.add(-4494177213242261212L); // 查询 中国信达分公司 SZP
	        domainIds.add(-3451572810087969062L);// 查询 中国信达子公司  SZP
	        domainIds.add(-2329940225728493295L); // 查询 中国信达资产管理股份有限公司 SZP
			params.put("userDomainIds", domainIds);
		}else {
			from.append(BulData.class.getName() + " as " + BulData_Alias);
			
			if(typeInfo.getTypeId() != null) {
				where.append(BulData_Alias + ".typeId=:typeId and ");
				params.put("typeId", typeInfo.getTypeId());
			}
			
			where.append(BulData_Alias + ".state=:published and " + BulData_Alias + ".deletedFlag=false ");
		}
		params.put("published", Constants.DATA_STATE_ALREADY_PUBLISH);
	}
}
