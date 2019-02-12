package com.seeyon.v3x.news.dao;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.dao.DataAccessException;
import org.springframework.orm.hibernate3.HibernateCallback;

import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.dao.BaseHibernateDao;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.po.OrgMember;
import com.seeyon.ctp.organization.po.OrgUnit;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.SQLWildcardUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.v3x.news.domain.NewsData;
import com.seeyon.v3x.news.domain.NewsType;
import com.seeyon.v3x.news.util.Constants;
import com.seeyon.v3x.news.util.NewsUtils;
/**
 * 该类是NewsDataDAO类,它继承自BaseHibernateDAO,BaseHibernateDAO封闭了一些比较好用的方法
 * BaseHibernateDAO继承自AbstractHibernateDao;
 * AbstractHibernateDao继承自Spring中的HibernateDaoSupport
 * @author IORIadmin
 *
 */
public class NewsDataDaoImpl extends BaseHibernateDao<NewsData> implements NewsDataDao{
	Log log = LogFactory.getLog(NewsDataDaoImpl.class);
	
	private static final String ORDER_BY = " order by t_data.publishDate desc";
	
	public Map<Long, List<NewsData>> findByReadUserHomeDAO(long id, List<NewsType> typeList) throws DataAccessException {
		List<NewsData> list = null;
		Map<Long, List<NewsData>> amap = new HashMap<Long, List<NewsData>>();
		if (typeList == null || typeList.isEmpty()) {
			return amap;
		} else {
			for(NewsType t : typeList){					
				final String hqlf = NewsUtils.SELECT_FIELDS + " where t_data.typeId=:typeId and  t_data.state=:state and t_data.deletedFlag=false " + ORDER_BY;
				final int count = Constants.NEWS_HOMEPAGE_TABLE_COLUMNS;
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("typeId", t.getId());
				params.put("state", Constants.DATA_STATE_ALREADY_PUBLISH);
				list = NewsUtils.objArr2News((List<Object[]>)this.find(hqlf, 0, count, params));
				amap.put(t.getId(), list);	
			}
		}
		return amap;
	}
	
	// 列出当前用户所能看到的新闻: (新闻发布)
	public List<NewsData> findWriteAllDAO(Long typeId, long userId) {
		Map<String, Object> parameterMap = new HashMap<String, Object>();
		Set<Integer> nopublishset = Constants.getDataStatesNoPublish();
		//新闻左外联新闻阅读信息表
		final String hqlStr = NewsUtils.SELECT_FIELDS + " where t_data.typeId = :typeId and t_data.state in (:states) " +  
		 " and t_data.createUser =:userId and t_data.deletedFlag = false " + " order by t_data.createDate desc";
		parameterMap.put("typeId", typeId);
		parameterMap.put("states", nopublishset);
		parameterMap.put("userId", userId);
		return NewsUtils.objArr2News((List<Object[]>)this.find(hqlStr, parameterMap));
	}
	
	//点击新闻列表页面的更多按钮执行的操作
	public List<NewsData> findByReadUserDAO(Long userId, Long typeId,long loginAccount) {
		String hqlType = (typeId == null ? " t_data.accountId =:accountId " : (" t_data.typeId =:typeId "));
		//新闻左外联新闻阅读信息表
		final String hqlf = NewsUtils.SELECT_FIELDS + " where " + hqlType + "and t_data.state=:state and t_data.deletedFlag=false " + ORDER_BY;
		Map<String, Object> params = new HashMap<String, Object>();
		if (typeId != null) 
			params.put("typeId", typeId);
		else 
			params.put("accountId", loginAccount);
		params.put("state", Constants.DATA_STATE_ALREADY_PUBLISH);
		return NewsUtils.objArr2News((List<Object[]>)this.find(hqlf, params));
	}
	
	//在单位新闻列表页面右上角的查询功能
	public List<NewsData> findByReadUserDAO(long id, String property, Object value, Object value1, List<NewsType> inList) throws Exception {
		List<NewsData> list;
		List<Object> flag =null;
		List<Long> typeIdLlist=new ArrayList<Long>();
		Map<String, Object> params=new HashMap<String, Object>();
		if (inList == null || inList.isEmpty()) {
			return Collections.EMPTY_LIST;
		} else {
			for (NewsType t : inList) {
				typeIdLlist.add(t.getId());
			}
		}
		String hqlType = " t_data.typeId in (:typelist) and ";
        if("createUser".equals(property)){
        	final String hqlf = NewsUtils.SELECT_FIELDS + "," + OrgMember.class.getName() 
        	+ " m where t_data.createUser = m.id and m.name like :createUser and t_data.deletedFlag=false"
        	+ " and " + hqlType + " t_data.state = :tstate"
        	+ ORDER_BY;
        	params.put("createUser", "%" + SQLWildcardUtil.escape((String)value) + "%");
        	params.put("typelist", typeIdLlist);
        	params.put("tstate", Constants.DATA_STATE_ALREADY_PUBLISH);
			list = NewsUtils.objArr2News((List<Object[]>)this.find(hqlf, params, flag));
        } else if ("departMent".equals(property)) {
        	final String hqlf = NewsUtils.SELECT_FIELDS + "," + OrgUnit.class.getName() 
        	+ " m where t_data.publishDepartmentId = m.id and m.name like :departMent and m.type=:unitType and t_data.deletedFlag=false"
        	+ " and " + hqlType + " t_data.state = :tstate"
        	+ ORDER_BY;
        	params.put("unitType", OrgConstants.UnitType.Department.name());
        	params.put("departMent", "%" + SQLWildcardUtil.escape((String)value) + "%");
        	params.put("typelist", typeIdLlist);
        	params.put("tstate", Constants.DATA_STATE_ALREADY_PUBLISH);
        	list = NewsUtils.objArr2News((List<Object[]>)this.find(hqlf, params, flag));
        } else if ("updateDate".equals(property)) {
    	 	StringBuffer hqlf =  new StringBuffer();       
    	 	hqlf.append(NewsUtils.SELECT_FIELDS + " where" + hqlType + " t_data.state = :tstate and t_data.deletedFlag=false ");      		
			if (!"".equals(value)) {
				hqlf.append(" and t_data."+property+" >= :vaule ");
				params.put("vaule", Datetimes.getTodayFirstTime(SQLWildcardUtil.escape((String)value)));
			}
			if (!"".equals(value1)) {
				hqlf.append(" and t_data."+property+" <= :vaule1 ");
				params.put("vaule1", Datetimes.getTodayLastTime(SQLWildcardUtil.escape((String)value1)));
			}
			hqlf.append(ORDER_BY);
    		params.put("typelist", typeIdLlist);
			params.put("tstate", Constants.DATA_STATE_ALREADY_PUBLISH);
			list = NewsUtils.objArr2News((List<Object[]>)this.find(hqlf.toString(), params, flag));
        } else if ("publishDate".equals(property)) {
        	StringBuffer hqlf =  new StringBuffer();       
    	 	hqlf.append(NewsUtils.SELECT_FIELDS + " where" + hqlType + " t_data.state = :tstate and t_data.deletedFlag=false ");      		
			if (!"".equals(value)) {
				hqlf.append(" and t_data."+property+" >= :vaule ");
				params.put("vaule", Datetimes.getTodayFirstTime(SQLWildcardUtil.escape((String)value)));
			}
			if (!"".equals(value1)) {
				hqlf.append(" and t_data."+property+" <= :vaule1 ");
				params.put("vaule1", Datetimes.getTodayLastTime(SQLWildcardUtil.escape((String)value1)));
			}
			hqlf.append(ORDER_BY);
    		params.put("typelist", typeIdLlist);
			params.put("tstate", Constants.DATA_STATE_ALREADY_PUBLISH);
			list = NewsUtils.objArr2News((List<Object[]>)this.find(hqlf.toString(), params, flag));
        }else{
        	//应该是查询出来全部的,结果没有/为什么
            if(value instanceof String && !("".equalsIgnoreCase(value.toString()))){
            	final Object qvalue = "%"+SQLWildcardUtil.escape((String)value)+"%";
        		final String hqlf = NewsUtils.SELECT_FIELDS + " where" + hqlType + " t_data.state = :tstate and t_data.deletedFlag=false and t_data."+property+" like :pro" + ORDER_BY;        		
				//占位符的个数一定要确认
				params.put("typelist", typeIdLlist);
				params.put("tstate", Constants.DATA_STATE_ALREADY_PUBLISH);
				params.put("pro", qvalue);
				list = NewsUtils.objArr2News((List<Object[]>)this.find(hqlf, params, flag));
            } else {
            	final String hqlf = NewsUtils.SELECT_FIELDS + " where " + hqlType+" t_data.state = :tstate and t_data.deletedFlag = false " + ORDER_BY;
            	params.put("typelist", typeIdLlist);
            	params.put("tstate", Constants.DATA_STATE_ALREADY_PUBLISH);
            	list = NewsUtils.objArr2News((List<Object[]>)this.find(hqlf, params, flag));
            }
        }
		return list;
	}
	
	/**
	 * 这是从单位新闻首页点击"更多"按钮,目前也使用于集团新闻首页的更多按钮
	 */
	public List<NewsData> findByReadUserDAO(long id, List<NewsType> inList, Integer imageOrFocus) throws DataAccessException, BusinessException {
		List<Long> typeIdLlist = new ArrayList<Long>();
		Map<String, Object> params = new HashMap<String, Object>();
		List<Object> flag = null;
		if (inList == null || inList.isEmpty()) {
			return Collections.EMPTY_LIST;
		}else{
	    	for (int i = 0; i < inList.size(); i++)
			{
				NewsType t=inList.get(i);
				typeIdLlist.add(t.getId());
			}
		}
		String hqlType = " t_data.typeId in(:typeIdList) and ";
		StringBuilder hqlf = new StringBuilder();
		hqlf.append(NewsUtils.SELECT_FIELDS + " where" + hqlType +" t_data.state = :tstatae and t_data.deletedFlag = false ");	
		if(imageOrFocus != null){
			if(imageOrFocus.intValue() == Constants.ImageNews){
				hqlf.append(" and t_data.imageNews = true ");
			} else {
				hqlf.append(" and t_data.focusNews = true ");
			}
		}
		hqlf.append(ORDER_BY);
    	params.put("typeIdList", typeIdLlist);
		params.put("tstatae", Constants.DATA_STATE_ALREADY_PUBLISH);
    	return NewsUtils.objArr2News((List<Object[]>)this.find(hqlf.toString(), params, flag));
	}
	
	
	//集团页面点击更多,查询出所有类型的新闻,这个方法暂时没有用,已经合到findByReadUserDAO(id, typeList);里面了
	@SuppressWarnings("unchecked")
	public List<NewsData> groupFindByReadUserDAO(long id, List<NewsType> typeList) throws DataAccessException, BusinessException {	
		List<NewsData> list = new ArrayList<NewsData>();
		Map<String, Object> parameterMap = new HashMap<String, Object>();
		final String hqlStr = NewsUtils.SELECT_FIELDS + " where t_data.typeId in (:typeIds) and t_data.state =:state and t_data.deletedFlag=false " + ORDER_BY;	
		
		List<Long> typeIds = new ArrayList<Long>();
		if(typeList==null || typeList.isEmpty()) {
			return list;
		} else {
			for(NewsType newsType : typeList) {
				typeIds.add(newsType.getId());
			}
		}
		parameterMap.put("typeIds", typeIds);
		parameterMap.put("state", Constants.DATA_STATE_ALREADY_PUBLISH);
		return NewsUtils.objArr2News((List<Object[]>)this.find(hqlStr, parameterMap));		
	}
	
	/**
	 * 在单位新闻列表页面右上角的查询功能
	 * 这个方法可以和findByReadUserDAO合并为一个方法,可以做为一个后备的方法
	 */
	public List<NewsData> groupFindByReadUserDAO(long id,String property,Object value, List<NewsType> inList) throws DataAccessException, BusinessException {
		Map<String, Object> parameterMap = new HashMap<String, Object>();
		List<Long> typeIds = new ArrayList<Long>();		
		if (inList == null || inList.isEmpty()) {
			return new ArrayList<NewsData>();
		} else {
			for(NewsType newsType : inList) {
				typeIds.add(newsType.getId());
			}
		}
		String hqlType = " t_data.typeId in (:typeIds) and ";
		parameterMap.put("typeIds", typeIds);

        if("type".equals(property)) {
        	final String hqlStr = NewsUtils.SELECT_FIELDS + " where t_data.state=:state and t_data.deletedFlag=false and t_data.typeId=:typeId " + ORDER_BY;
        	Long typeId = Long.valueOf((String)value);
        	parameterMap.put("state", Constants.DATA_STATE_ALREADY_PUBLISH);
        	parameterMap.put("typeId", typeId);
        	return NewsUtils.objArr2News((List<Object[]>)this.find(hqlStr, parameterMap));      	
        } else {
        	if(value !=null){
        		final String hqlStr = NewsUtils.SELECT_FIELDS + " where" + hqlType+" t_data.state =:state and t_data.deletedFlag = false  and t_data."+property+" like :name" + ORDER_BY;
        		parameterMap.put("state", Constants.DATA_STATE_ALREADY_PUBLISH);
        		String name = "%" + SQLWildcardUtil.escape((String)value) + "%";
        		parameterMap.put("name", name);
				return NewsUtils.objArr2News((List<Object[]>)this.find(hqlStr, parameterMap));
        	} else {        		
        		final String hqlStr = NewsUtils.SELECT_FIELDS + " where " + hqlType + " t_data.state=:state and t_data.deletedFlag = false " + ORDER_BY;
        		parameterMap.put("state", Constants.DATA_STATE_ALREADY_PUBLISH);
        		return NewsUtils.objArr2News((List<Object[]>)this.find(hqlStr, parameterMap));   		
        	}      	
        }
	}
	
	/**
	 * 用户模块管理页面什么也不输入的时候进行的查询
	 */
	public List<NewsData> findAllDAO(Long userId, Long typeId,List<NewsType> inList) throws Exception {
		//采用新闻Constants的表态管理Set进行查询,便于统一
		Map<String, Object> params=new HashMap<String, Object>();
		//设置typeStr的点位符,
		List<Long> typeidlist=new ArrayList<Long>();
		for (NewsType ty : inList){
			typeidlist.add(ty.getId());
		}
		//设置状态的点位符
		String hqlState="t_data.state in (:tstatelist) and";
		String hqlType="t_data.typeId in (:typeidlist) and ";
		params.put("typeidlist", typeidlist);
		params.put("tstatelist", Constants.getDataStatesCanManage());
		params.put("typeid", typeId);
		final String hqlStr = NewsUtils.SELECT_FIELDS + " where t_data.typeId = :typeid and " + hqlType + hqlState + " t_data.deletedFlag=false " + ORDER_BY;
		return NewsUtils.objArr2News((List<Object[]>)this.find(hqlStr,params));
	}
	
	//用户在模块管理页面输入相关的查询条件
	public List<NewsData> findByPropertyDAO(Long userId, Long typeId, String condition, Object value,Object value1,List<NewsType> inList) throws Exception {
		Map<String, Object> params=new HashMap<String, Object>();
		List<Long> typeidList=new ArrayList<Long>();
		for (int i = 0; i < inList.size(); i++) {
			NewsType t=inList.get(i);
			typeidList.add(t.getId());
		}
		//设置状态的点位符
		String hqlState="t_data.state in (:tstate) and ";
		String hqlType="";
		params.put("tstate", Constants.getDataStatesCanManage());
		String hqlcondi="";
		String orgMang="";
		if("publishUserId".equals(condition)){
			//按发起者查询
			orgMang=","+ OrgMember.class.getName()+" as m ";
			hqlcondi = " t_data.createUser=m.id and m.name like :pro and ";
			params.put("pro", "%" + SQLWildcardUtil.escape((String)value) + "%");
		} else if("updateDate".equals(condition)){
			StringBuilder sb = new StringBuilder();
			
			if (!"".equals(value)) {
				sb.append(" t_data." + condition + " >= :vaule and ");
				params.put("vaule", Datetimes.getTodayFirstTime(SQLWildcardUtil.escape((String)value)));
			}
			if (!"".equals(value1)) {
				sb.append(" t_data."+condition+" <= :vaule1 and ");
				params.put("vaule1", Datetimes.getTodayLastTime(SQLWildcardUtil.escape((String)value1)));
			}
			hqlcondi = sb.toString();
		} else if("publishDate".equals(condition)){
			StringBuilder sb = new StringBuilder();
			if (!"".equals(value)) {
				sb.append(" t_data." + condition + " >= :vaule and ");
				params.put("vaule", Datetimes.getTodayFirstTime(SQLWildcardUtil.escape((String)value)));
			}
			if (!"".equals(value1)) {
				sb.append(" t_data."+condition+" <= :vaule1 and ");
				params.put("vaule1", Datetimes.getTodayLastTime(SQLWildcardUtil.escape((String)value1)));
			}
			hqlcondi = sb.toString();
		} else {
			hqlcondi = " t_data." + condition + " like :pro and";
			params.put("pro", "%" + SQLWildcardUtil.escape((String)value) + "%");
		}
		params.put("typeid", typeId);
		
		//modified by Meng Yang 2009-05-27 确定只选择其中的新闻，否则将会把人员信息也一同带入从而导致转型异常，前端页面报错
		final String hqlStr = NewsUtils.SELECT_FIELDS + orgMang+"where t_data.typeId = :typeid and " +
							hqlType+hqlState+hqlcondi+" t_data.deletedFlag = false  " +
							"order by t_data.state, t_data.updateDate desc";
		return NewsUtils.objArr2News((List<Object[]>)this.find(hqlStr, params));
	}

	// H5
	public List<NewsData> findByUserPropertyDAO(List<Long> typeidList, String condition, Object value, Object value1, Long userId)
			throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		String orgMang = "";
		String hqlcondi = "";
		String hqlType=" and t_data.typeId in (:typeidlist) ";
		params.put("typeidlist", typeidList);
		if ("publishUserId".equals(condition)) {// 按发布人查询
			orgMang = "," + OrgMember.class.getName() + " as m ";
			hqlcondi = " and t_data.publishUserId=m.id and m.name like :pro ";
			params.put("pro", "%" + SQLWildcardUtil.escape((String) value) + "%");
		} else if ("publishDate".equals(condition)) {
			StringBuilder sb = new StringBuilder();
			if (!"".equals(value)) {
				sb.append(" and t_data." + condition + " >= :vaule ");
				params.put("vaule", Datetimes.getTodayFirstTime(SQLWildcardUtil.escape((String) value)));
			}
			if (!"".equals(value1)) {
				sb.append(" and t_data." + condition + " <= :vaule1 ");
				params.put("vaule1", Datetimes.getTodayLastTime(SQLWildcardUtil.escape((String) value1)));
			}
			hqlcondi = sb.toString();
		} else if ("title".equals(condition) && Strings.isNotBlank(value.toString())) {
			hqlcondi = " and t_data.title like :pro ";
			params.put("pro", "%" + SQLWildcardUtil.escape((String) value) + "%");
		}
		final String hqlStr = NewsUtils.SELECT_FIELDS + orgMang + " where t_data.state=:state and t_data.deletedFlag= :flag " + hqlcondi + hqlType
				+ " order by t_data.publishDate desc ";
		params.put("state", Constants.DATA_STATE_ALREADY_PUBLISH);
		params.put("flag", false);
		return NewsUtils.objArr2News((List<Object[]>) this.find(hqlStr, params));
	}

	/**
	 * 显示当前用户的待审核条数
	 * @param auditList
	 * @return
	 */
	public List getPendingCountOfUserDAO(List<NewsType> auditList){
		String hqlStr="from NewsData as t_data where t_data.typeId in (:typeidList) and t_data.state = :tstate";
		Map<String, Object> params=new HashMap<String, Object>();
		List<Object> flag=null;
		List<Long> typeidList=new ArrayList<Long>();
		for (NewsType ty : auditList) {
			typeidList.add(ty.getId());
		}
		params.put("typeidList", typeidList);
		params.put("tstate",Constants.DATA_STATE_ALREADY_CREATE);
		List<NewsData> list=this.find(hqlStr, params, flag); 
		return list;
	}
	
	/**
	 * 点击板块管理后,再点击新闻审核后所看到的列表
	 * @param userId
	 * @param property
	 * @param value
	 * @param auditTypeList
	 * @return
	 * @throws BusinessException
	 */
	public List<NewsData> getAuditDataListNewDAO(Long userId,String property,Object value,List<NewsType> auditTypeList) throws BusinessException{
		Map<String, Object> params=new HashMap<String, Object>();
		String hqlStr = "from NewsData as t_data where (t_data.state = :state1 or t_data.state = :state2)";
		params.put("state1", Constants.DATA_STATE_ALREADY_CREATE);
		params.put("state2", Constants.DATA_STATE_ALREADY_AUDIT);
        if(StringUtils.isNotBlank(property) && value!=null){
			if("type".equals(property)){
				hqlStr += " and t_data.typeId =:type ";
				params.put("type", Long.parseLong(value.toString()));
			}else{
				List<Long> typeIdList = new ArrayList<Long>();
				for(NewsType t : auditTypeList){
					typeIdList.add(t.getId());
				}
				String hqlType = " t_data.typeId in (:typeIdList) ";
				params.put("typeIdList", typeIdList);
				hqlStr += " and " + hqlType;
				if (value instanceof String)
				{
					hqlStr += " and t_data." + property + " like :pro ";
					params.put("pro", "%"+SQLWildcardUtil.escape((String)value)+"%");
				}
				else
				{
					hqlStr += " and t_data." + property + " = :pro";
					params.put("pro", value);
				}
			}
		}else{
			List<Long> typeIdList = new ArrayList<Long>();
			for(NewsType t : auditTypeList){
				typeIdList.add(t.getId());
			}
			String hqlType = " t_data.typeId in (:typeIdList) ";
			params.put("typeIdList", typeIdList);
			hqlStr += " and " + hqlType;
		}
        hqlStr+=" order by createDate desc";
        List<NewsData> list=this.find(hqlStr, params);
        
        return list;
	}
	
	/**
     * 点击板块管理后,再点击新闻审核后所看到的列表,2012-11-5 yangwulin 根据当前的板块查询当前板块需要审核的新闻。
     * @param userId 用户Id
     * @param property 查询类型
     * @param value   查询值
     * @param newsTypeId 当前板块的Id
     * @return 当前板块需要审核的新闻。
     * @throws BusinessException
     */
	public List<NewsData> getAuditDataListNewInfo(Long userId,String property,Object value,String newsTypeId) throws BusinessException{
        Map<String, Object> params=new HashMap<String, Object>();
        String hqlStr = "from NewsData as t_data where (t_data.state = :state1 or t_data.state = :state2)";
        params.put("state1", Constants.DATA_STATE_ALREADY_CREATE);
        params.put("state2", Constants.DATA_STATE_ALREADY_AUDIT);
        if(StringUtils.isNotBlank(property) && value!=null){
            if("type".equals(property)){
                hqlStr += " and t_data.typeId =:type ";
                params.put("type", Long.parseLong(value.toString()));
            }else{
               
              //yangwulin sprint5 板块审核的时候根据当前板块查询出的审核，注释的版本是审核所以板块需该人员审核的新闻。
                /* List<Long> typeIdList = new ArrayList<Long>();
                for(NewsType t : auditTypeList){
                    typeIdList.add(t.getId());
                }
                String hqlType = " t_data.typeId in (:typeIdList) ";
                params.put("typeIdList", typeIdList);
                hqlStr += " and " + hqlType;
                */
                String hqlType = "";
                if (newsTypeId != null && !"".equals(newsTypeId)) {
                    hqlType = " t_data.typeId=(:newsTypeId) ";
                    params.put("newsTypeId", Long.parseLong(newsTypeId));
                }
                hqlStr += " and " + hqlType;
                
                if (value instanceof String)
                {
                    hqlStr += " and t_data." + property + " like :pro ";
                    params.put("pro", "%"+SQLWildcardUtil.escape((String)value)+"%");
                }
                else
                {
                    hqlStr += " and t_data." + property + " = :pro";
                    params.put("pro", value);
                }
            }
        }else{
            //yangwulin sprint5 板块审核的时候根据当前板块查询出的审核，注释的版本是审核所以板块需该人员审核的新闻。
            /*List<Long> typeIdList = new ArrayList<Long>();
            for(NewsType t : auditTypeList){
                typeIdList.add(t.getId());
            }
            String hqlType = " t_data.typeId=(:typeIdList) ";
            params.put("typeIdList", typeIdList);
            hqlStr += " and " + hqlType;
            */
            String hqlType = "";
            if (newsTypeId != null && !"".equals(newsTypeId)) {
                hqlType = " t_data.typeId=(:newsTypeId) ";
                params.put("newsTypeId", Long.parseLong(newsTypeId));
            }
            if(!"".equals(hqlType)){
                hqlStr += " and " + hqlType;
            }
        }
        hqlStr+=" order by createDate desc";
        List<NewsData> list=this.find(hqlStr, params);
        
        return list;
    }
	
	/**
     * yangwulin Sprint4  2012-11-15  全文检索
     * 获取在某一段时期内，某一板块下已发布的公告总数
     * @param beginDate 
     * @param endDate 
     * @return
     */
    public Integer findIndexByDate(Date beginDate, Date endDate){
        StringBuffer sbHql = new StringBuffer("select count(b.id) from ");
        sbHql.append(NewsData.class.getName());
        sbHql.append(" as b where b.publishDate >= ? and b.publishDate <= ?");
        Number result = (Number) this.findUnique(sbHql.toString(), null, beginDate,endDate);
        return result==null?0:result.intValue();
    }
    
    /**
     * yangwulin Sprint4  全文检索
     */
    @SuppressWarnings("unchecked")
    public List<Long> findDocSourcesList(final Date starDate, final Date endDate, final Integer firstRow,final Integer pageSize) {
        return (List<Long>) getHibernateTemplate().execute(new HibernateCallback() {
              public Object doInHibernate(Session session) throws HibernateException, SQLException {
                  String hql = "select b.id  from " + NewsData.class.getName() + " as b where b.publishDate >=? and b.publishDate <=? order by publishDate desc";
          Query query = null;     
          query = session.createQuery(hql);
          query.setParameter(0, starDate);
          query.setParameter(1, endDate);
          query.setFirstResult(firstRow);
          query.setMaxResults(pageSize);
          
          return query.list();
              }
          });
    }
    
	
	/**
	 * 将某一指定新闻板块下待审核的新闻对应待办事项转到新审核员名下<br>
	 * 由于旧的待办事项可能是较早以前的，在转移时，将其时间改为当前时间，便于新的审核员在其待办事项最开始几项中看到<br>
	 * 这种情况发生的场景：旧审核员离职了，而其具有审核权的新闻板块还有待审核新闻<br>
	 * @param newsTypeId    新闻板块ID
	 * @param oldAuditorId  旧审核员ID
	 * @param newAuditorId  新审核员ID
	 */
	public void transfer2NewAuditor(Long newsTypeId, Long oldAuditorId, Long newAuditorId) {
		String hql = "update " + CtpAffair.class.getName() + " as af set af.memberId=:newAuditorId, af.createDate=:now, af.receiveTime=:now where af.app=:news and " +
					 "af.memberId=:oldAuditorId and af.objectId in (select news.id from " + NewsData.class.getName() + " as news " +
					 "where news.typeId=:newsTypeId and news.state=:wait4Audit)";
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("newAuditorId", newAuditorId);
		params.put("news", ApplicationCategoryEnum.news.key());
		params.put("oldAuditorId", oldAuditorId);
		params.put("newsTypeId", newsTypeId);
		params.put("wait4Audit", Constants.DATA_STATE_ALREADY_CREATE);
		params.put("now", new Timestamp(System.currentTimeMillis()));
		super.bulkUpdate(hql, params);
	}
	//客开 start
	public void transfer2NewTypesettingStaff(Long newsTypeId, Long oldTypesettingStaff, Long typesettingStaff) {
	  String hql = "update " + CtpAffair.class.getName() + " as af set af.memberId=:typesettingStaff, af.createDate=:now, af.receiveTime=:now where af.app=:news and " +
	      "af.memberId=:oldTypesettingStaff and af.objectId in (select news.id from " + NewsData.class.getName() + " as news " +
	      "where news.typeId=:newsTypeId and news.state=:wait4Audit)";
	  
	  Map<String, Object> params = new HashMap<String, Object>();
	  params.put("typesettingStaff", typesettingStaff);
	  params.put("news", ApplicationCategoryEnum.news.key());
	  params.put("oldTypesettingStaff", oldTypesettingStaff);
	  params.put("newsTypeId", newsTypeId);
	  params.put("wait4Audit", Constants.DATA_STATE_TYPESETTING_CREATE);
	  params.put("now", new Timestamp(System.currentTimeMillis()));
	  super.bulkUpdate(hql, params);
	}
	//客开 end
	
	/**
	 * 为M1提供接口：获取指定新闻板块中当前登陆用户有权限访问的新闻数
	 * @param userId 当前登陆用户ID
	 * @param typeId 指定的新闻板块ID
	 * @param loginAccount 当前登陆用户的单位ID
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Long getNewsDatasCount(Long userId, Long typeId ,long loginAccount) {
		String hqlType = (typeId == null ? " t_data.accountId =:accountId " : (" t_data.typeId =:typeId "));

		String hqlf = "select count( distinct t_data.id ) from NewsData as t_data  where " + hqlType + "and t_data.state=:state and t_data.deletedFlag=false ";
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		if (typeId != null) {
			params.put("typeId", typeId);
		} else {
			params.put("accountId", loginAccount);
		}
		params.put("state", Constants.DATA_STATE_ALREADY_PUBLISH);
		List<Object> objs = find(hqlf, params);
		
		if(null != objs && !objs.isEmpty()){
			return Long.valueOf(objs.get(0).toString());
		}
		return 0L;
	}
	
	public int addPraise(Long newsId,String praise,int praise_sum){
		Map<String,Object> param = new HashMap<String,Object>();
		String hql = "update NewsData set praise = :praise,praiseSum = :praise_sum where id=:id";
		param.put("praise", praise);
		param.put("praise_sum", praise_sum);
		param.put("id", newsId);
		
		int i =super.bulkUpdate(hql, param);
		return i;
	}
	
	/**
	 * 取得某一个新闻板块下已发布、被置顶的新闻
	 * @param typeId	新闻板块ID
	 */
	@SuppressWarnings("unchecked")
	public List<NewsData> getTopedNewsDatas(Long typeId) {
		String hql = "from NewsData as data where data.typeId=? and data.topNumberOrder>0 and data.state=? and data.deletedFlag=false order by data.topNumberOrder desc";
		return this.findVarargs(hql, typeId, Constants.DATA_STATE_ALREADY_PUBLISH);
	}

}
