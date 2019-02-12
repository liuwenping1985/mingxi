package com.seeyon.apps.doc.dao;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Hibernate;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Expression;
import org.hibernate.type.Type;
import org.springframework.orm.hibernate3.HibernateCallback;

import com.seeyon.apps.doc.po.DocResourcePO;
import com.seeyon.apps.doc.po.DocTypePO;
import com.seeyon.apps.doc.po.Potent;
import com.seeyon.apps.doc.util.Constants;
import com.seeyon.apps.doc.util.DocSearchHqlUtils;
import com.seeyon.apps.doc.vo.DocSearchModel;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.dao.BaseHibernateDao;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.CommonTools;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.SQLWildcardUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.v3x.isearch.model.ConditionModel;

/** 
* @Description 文档、文档夹DAO
* @Author Macx   
* @Date：2012-9-10 上午11:15:40 
*/
public class DocResourceDaoImpl extends BaseHibernateDao<DocResourcePO> implements DocResourceDao {

	private static final Log         log = LogFactory.getLog(DocResourceDaoImpl.class);
	private OrgManager orgManager;

	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}
	
	//kekai  zhaohui  获取列表中frOroder 最小值 start
	public Number getMinFrOderByParentFrId(Long ParentFrId){
		String hql = "select min(frOrder) from DocResourcePO where parentFrId = :ParentFrId";
		Map<String, Object> params = new HashMap<String, Object>();
        params.put("ParentFrId", ParentFrId);
		Number number = (Number) this.findUnique(hql, params);
		return number;
		
	}
	//kekai  zhaohui  获取列表中frOroder 最小值 end
    /**
     * 注意，此处在保存文档时，获取主键ID的策略自2010-10-22起进行了调整(可对照CVS历史版本记录)<br>
     * 此前的策略是通过自增组件，先获取doc_resources表中的最大ID，加1后设为当前文档ID<br>
     * 此策略需要保证同步，以免出现主键重复，单机环境尚可，在集群环境下存在困难，改为使用UUID<br>
     * @see com.seeyon.v3x.doc.util.Constants#getNewDocResourceId
     * @editor Rookie Young
     */
    public Long saveAndGetId(DocResourcePO dr) {
        if (dr.isNew()) {
            // 由于此前文档Id自增均为正数，在前端jsp/js中变量命名时无需考虑负数转换问题，如：
            // var property_${Id} = ...;
            // 类似代码，Id如为负数，则一般需将"-"转换为"_"
            // 为避免Id生成策略的调整对前端代码影响太大，强制只生成正数UUID
            dr.setId(UUIDLong.absLongUUID());
        }
        dr.setFrName(dr.getFrName().trim());
        Long ret = dr.getId();
        if (dr.getParentFrId() != 0L) {
            dr.setLogicalPath(this.get(dr.getParentFrId()).getLogicalPath() + "." + ret);
        } else {
            dr.setLogicalPath(String.valueOf(ret));
        }
        this.save(dr);
        return ret;
    }

    public boolean isDocResourceExsit(Long archiveId) {
        int count = getQueryCount("from DocResourcePO where id = ?", new Object[] { archiveId },
                new Type[] { Hibernate.LONG });
        return count > 0 ? true : false;
    }

    /**
     * 取得多个docResource
     */
    public List<DocResourcePO> getDocsByIds(String ids) {
        if (Strings.isBlank(ids)) {
            return new ArrayList<DocResourcePO>();
        }
        List<Long> idList = CommonTools.parseStr2Ids(ids);
        return getDocsByIds(idList);
    }

    @SuppressWarnings("unchecked")
    public List<DocResourcePO> getDocsByIds(List<Long> idList) {
        String hql = "from DocResourcePO where id in (:ids) order by createTime desc";
        return this.find(hql, -1, -1, CommonTools.newHashMap("ids", idList));
    }

    @SuppressWarnings("unchecked")
    public List<DocResourcePO> getDocsBySourceId(List<Long> resourceId) {
        List<DocResourcePO> docs = new ArrayList<DocResourcePO>();
        for(List<Long> docResources : Strings.splitList(resourceId, 500)){
            DetachedCriteria criteria = DetachedCriteria.forClass(DocResourcePO.class);
            criteria.add(Expression.in("sourceId", docResources));
            docs.addAll( super.executeCriteria(criteria, -1, -1));
        }
        return docs;
    }

    /**
     * 获取文档夹下的全部子文档
     * @param dr    文档夹
     */
    @SuppressWarnings("unchecked")
    public List<DocResourcePO> getSubDocResources(DocResourcePO dr) {
        String hsql = "from DocResourcePO as a where a.logicalPath like :lp or a.id = :aid";
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("lp", dr.getLogicalPath() + ".%");
        map.put("aid", dr.getId());
        return this.find(hsql, -1, -1, map);
    }

    /**
     * 根据文档夹ID获取对应文档夹下的全部子文档
     * @param drId  文档夹Id
     */
    public List<DocResourcePO> getSubDocResources(Long drId) {
        DocResourcePO dr = this.get(drId);
        return this.getSubDocResources(dr);
    }

    /**
     * 获取文档综合查询的结果
     * @param cModel    综合查询值模型
     * @param docType   查询的文档类型
     */
    public List<DocResourcePO> iSearch(ConditionModel cModel, DocTypePO docType) {
        String title = cModel.getTitle();
        String keywords = cModel.getKeywords();
        Date beginDate = cModel.getBeginDate();
        Date endDate = cModel.getEndDate();
        Long fromUserId = cModel.getFromUserId();
        Long docLibId = cModel.getDocLibId();
        long userId = cModel.getUser().getId();
        Map<String, Object> nmap = new HashMap<String, Object>();
        StringBuilder sb = new StringBuilder("from DocResourcePO as dr where docLibId = :docLibId and frType = :docType");
        nmap.put("docLibId", docLibId);
        nmap.put("docType", docType.getId());
        if (Strings.isNotBlank(title)) {
            sb.append(" and frName like :lp");
            nmap.put("lp", "%" + title + "%");
        }
        if (Strings.isNotBlank(keywords)) {
            sb.append(" and keyWords like :lk");
            nmap.put("lk", "%" + keywords + "%");
        }
        if (fromUserId != null) {
            sb.append(" and createUserId = :fUserId");
            nmap.put("fUserId", fromUserId);
        } else {
            sb.append(" and createUserId != :userId");
            nmap.put("userId", userId);
        }
        if (beginDate != null) {
            sb.append(" and createTime >= :begin");
            nmap.put("begin", beginDate);
        }
        if (endDate != null) {
            sb.append(" and createTime <= :end");
            nmap.put("end", endDate);
        }
        sb.append(" order by frOrder ");
        return this.find(sb.toString(), -1, -1, nmap);
    }

    public Session getDocSession() {
        return super.getSession();
    }

    public void releaseDocSession(Session session) {
        super.releaseSession(session);
    }

    /**
     * 修改文档库名称时，对应的根文档夹名称也需要同步修改
     * @param docLibId      文档库ID
     * @param newLibName    文档库新名称，需赋值给根文档夹
     */
    public void updateRootFolderName(Long docLibId, String newLibName) {
        String hql = "update " + DocResourcePO.class.getName() + " set frName=? where parentFrId=0 and docLibId=?";
        this.bulkUpdate(hql, null, newLibName.trim(), docLibId);
    }
    
    /**
     * 更新文档夹到广场时，更新文档更新到广场的时间OpenSquareTime
     * @param parentForderId
     */
    public void updateOpenSquareTimeByParentForder(DocResourcePO parentForder,Timestamp openSquareTime){
        String hql = "update DocResourcePO set openSquareTime=:openSquareTime where logicalPath like :logicalPath";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("logicalPath", parentForder.getLogicalPath() + "%");
        params.put("openSquareTime", openSquareTime);
        DBAgent.bulkUpdate(hql, params);
    }

    /**
     * 在归档协同时，判断当前选中的协同是否有至少一个已被归档
     * @param docResId  归档源文档夹ID
     * @param contentId 文档类型ID
     * @param srIds 待归档的、选中的协同ID(col_summary主键ID)集合
     * @return  当前选中的协同是否有至少一个已被归档
     */
    public boolean judgeSamePigeonhole(Long docResId, Long contentId, List<Long> srIds) {
        String hql = "select count(d.id) from " + DocResourcePO.class.getCanonicalName() + " as d, "
                + CtpAffair.class.getCanonicalName() + " as a "
                + "where (d.sourceId=a.id or d.sourceId in(:colIds)) and d.parentFrId=:drId and d.frType=:frType and a.objectId in (:colIds)";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("drId", docResId);
        params.put("frType", contentId);
        params.put("colIds", srIds);
        Integer count = null;
        Number number = (Number) this.findUnique(hql, params);
        if (null != number) {
            count = number.intValue();
        }
        return count != null && count.intValue() > 0;
    }

    /**
     * 获取项目阶段下的文档
     * @param phaseId               项目阶段ID
     * @param projectLogicalPath    项目文档夹的逻辑路径
     */
    @SuppressWarnings("unchecked")
    public List<DocResourcePO> getDocsOfProjectPhase(Long phaseId, String projectLogicalPath) {
        String hql = "from DocResourcePO as d where d.isFolder=false and d.frType!=" + Constants.LINK_FOLDER
                + " and d.logicalPath like :logicalPath order by d.lastUpdate desc";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("logicalPath", projectLogicalPath + ".%");
        return this.find(hql, params);
    }

    /**
     * 获取项目阶段下所有有权限的文档
     * @param projectLogicalPath    项目文档夹的逻辑路径
     * @param orgIds
     * @param hasAcl
     * @param paramMap  查询条件
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<DocResourcePO> getDocsOfProjectPhase(String projectLogicalPath, String orgIds, boolean hasAcl,
            Map<String, String> paramMap) {
        //获取所有有权限的文档夹
        String hql = "from DocResourcePO as d where d.isFolder=false and d.frType!=" + Constants.LINK_FOLDER
                + " and d.logicalPath like :logicalPath ";
        Map<String, Object> params = new HashMap<String, Object>();
        //条件查询
        if (paramMap != null && paramMap.containsKey("condition")) {
            String condition = paramMap.get("condition");
            String value = paramMap.get(condition);
            if ((value != null && !"".equals(value))||"modifyDate".equals(condition)) {
                if ("name".equals(condition)) {
                    hql += " and frName like :name ";
                    params.put("name", "%" + SQLWildcardUtil.escape(value) + "%");
                } else if ("modifyDate".equals(condition)) {
                    if(Strings.isNotBlank(paramMap.get("beginTime"))){
                        hql += " and lastUpdate >= :firstTime ";
                      params.put("firstTime", Datetimes.getTodayFirstTime(paramMap.get("beginTime")));
                    }
                    if(Strings.isNotBlank(paramMap.get("endTime"))){
                        hql += " and lastUpdate <= :lastTime ";
                        params.put("lastTime", Datetimes.getTodayLastTime(paramMap.get("endTime")));
                    }
                    
                }else if("lastUserId".equals(condition)){
                    hql += " and lastUserId in (select id from OrgMember m where m.name like :memberName) ";
                    params.put("memberName", "%" + SQLWildcardUtil.escape(value) + "%");
                }
            }
        }
        //上级有权限的   查看非 无权限的  目录
        String whereSql = "and d.parentFrId in (:parentFrIds) ";
        if (hasAcl) {
            whereSql = "and d.parentFrId not in (:parentFrIds)";
        }
        Map<String,Object> param = new HashMap<String,Object>();
       //性能问题，分开查
       String inSql = "select doc.id from DocResourcePO doc, DocAcl da where doc.isFolder=true and doc.id = da.docResourceId and da.userId in(:orgIds) and doc.logicalPath like :logicalPath "
                + "and da.sharetype = " + Constants.SHARETYPE_DEPTSHARE + " and da.potent = '" + Potent.noPotent +"'";
       param.put("orgIds", Constants.parseStrings2Longs(orgIds, ","));
       param.put("logicalPath", projectLogicalPath + "%");
       List<Long> parentFrIds = DBAgent.find(inSql, param);
       parentFrIds.add(-1L);
       params.put("parentFrIds", parentFrIds);
       params.put("logicalPath", projectLogicalPath + "%");
       hql += whereSql + " order by d.lastUpdate desc";
       return this.find(hql, params);
    }

    /**
     * 在修改、替换、历史版本恢复过程中，同步更新其对应映射文件的名称
     * @param docResourceId     源ID
     * @param newName           新名称
     */
    public void updateLinkName(Long docResourceId, String newName) {
        String hql = "update " + DocResourcePO.class.getCanonicalName()
                + " set frName=? where sourceId=? and (frType=? or frType=?)";
        this.bulkUpdate(hql, null, newName, docResourceId, Constants.FORMAT_TYPE_LINK,
                Constants.FORMAT_TYPE_LINK_FOLDER);
    }

    @Override
    public void updateSourceType(Long docResourceId,Long forderId,  Integer newType) {
        String hql = "update " + DocResourcePO.class.getCanonicalName()
                + " set sourceType=? where sourceId=? and parentFrId=?";
        this.bulkUpdate(hql, null, newType, docResourceId, forderId);
    }

    public Integer findDocSourcesCountByDate(Date starDate, Date endDate) throws BusinessException {
        String hql = "select count(id)  from " + DocResourcePO.class.getCanonicalName()
                + " where createTime >=? and createTime <=? ";
        List result = this.find(hql, null, new Object[] { starDate, endDate });
        if(result.isEmpty()) return 0;
        return ((Number)result.listIterator().next()).intValue();
    }

    @SuppressWarnings("unchecked")
    public List<Long> findDocSourcesList(final Date starDate, final Date endDate, final Integer firstRow,
            final Integer pageSize) throws BusinessException {

        return (List<Long>) getHibernateTemplate().execute(new HibernateCallback() {
            public Object doInHibernate(Session session) throws HibernateException, SQLException {
                String hql = "select id  from " + DocResourcePO.class.getCanonicalName()
                        + " where createTime >=? and createTime <=? order by createTime desc";
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

    @Override
    public Long findDocIdByType(Long userId, Long type) {
        String hql = "select id from DocResourcePO as a where a.createUserId = :userId and a.frType = :frType ";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("userId", userId);
        params.put("frType", type);
        Number number = (Number) this.findUnique(hql, params);
        if (number != null ) {
            return number.longValue();
        }
        return null;
    }
    
    @Override
    public List<DocResourcePO> findDocFilesByFolder(Long folderId,Long createrId) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("docId", folderId);
        String hql = "from DocResourcePO as d where d.isFolder=false and d.frType!=" + Constants.LINK_FOLDER;
        if(createrId!= null){
            hql += " and d.createUserId = :createUserId";
            params.put("createUserId", createrId);
        }
        hql+= " and d.parentFrId =:docId order by d.lastUpdate desc";
        return this.find(hql, params);
    }
    
    @Override
    public List<DocResourcePO> findBorrowDoc(FlipInfo fpi,
            Collection<Long> userIds, String title, Collection<Long> createIds,
            Collection<Long> OutMiniType)throws BusinessException {
        Map<String,Object> param = new HashMap<String,Object>();
        String hql = " and ((a.sharetype = :pborrow and a.ownerId != :ownerId) or a.sharetype = :dborrow)  and a.sdate<= :edate and a.edate >= :sdate";
        //个人借阅和个人共享不包括自己的文档
        param.put("ownerId", AppContext.currentUserId());
        param.put("pborrow", Constants.SHARETYPE_PERSBORROW);
        param.put("dborrow", Constants.SHARETYPE_DEPTBORROW);
        param.put("sdate", Datetimes.getTodayFirstTime());
        param.put("edate", Datetimes.getTodayLastTime());
        return findDocs(fpi,null,userIds, title, createIds,OutMiniType, hql,param);
    }

    @Override
    public List<DocResourcePO> findDocByAclType(FlipInfo fpi, Long docId,
            Collection<Long> userIds, String title, Collection<Long> createIds,
            Collection<Long> OutMiniType, List<Byte> aclTypes) throws BusinessException {
        Map<String,Object> param = new HashMap<String,Object>();
        String hql = "";
        if(aclTypes != null){
            hql = " and (";
            int count = 0;
            for(Byte aclType : aclTypes){
                if(count++>0)
                    hql += " or" ;
                hql += " a.sharetype = :aclType"+count;
                param.put("aclType"+count, aclType);
            }

            hql += " )";
        }
        hql += " and (a.sharetype = :pshare and a.ownerId != :ownerId)";
        param.put("ownerId", AppContext.currentUserId());
        param.put("pshare", Constants.SHARETYPE_PERSSHARE);
        return findDocs(fpi,docId,userIds, title, createIds,OutMiniType, hql,param);
    }

    @Override
    public List<DocResourcePO> findDocByAclTypeWithoutAcl(FlipInfo fpi, Long docId,
            Collection<Long> userIds, String title, Collection<Long> createIds,
            Collection<Long> OutMiniType, Byte aclType) throws BusinessException {
        Map<String,Object> param = new HashMap<String,Object>();
        String hql = " and a.potent='"+Potent.noPotent+"'";
        if(aclType != null){
            hql += " and a.sharetype = :aclType";
            param.put("aclType", aclType);
        }
        return findDocs(fpi,docId,userIds, title, createIds,OutMiniType, hql,param);
    }
    
    private List<DocResourcePO> findDocs(FlipInfo fpi, Long docId,
            Collection<Long> userIds, String title, Collection<Long> createIds,
            Collection<Long> OutMiniType, String whereString,Map<String,Object> param) throws BusinessException {
        StringBuilder hql = new StringBuilder(" select distinct d from DocResourcePO d, DocAcl a,OrgMember o where d.id=a.docResourceId and"
        		+ " o.id = d.createUserId and o.enable = 1 and o.status = 1 and o.loginable = 1 and o.assigned = 1 and o.state = 1 and o.deleted = 0 ");
        if(Strings.isNotEmpty(userIds)){
            hql.append(" and a.userId in (:userIds) and (a.potent!='")
                    .append(Potent.noPotent).append("' or a.sharetype = 2 )");
            param.put("userIds", userIds);      
        }
        
        if(docId != null){
            hql.append(" and d.parentFrId = :parentFrId");
            param.put("parentFrId", docId);
        }
        
        if(Strings.isNotBlank(title)){
            hql.append(" and d.frName like  :title");
            param.put("title", "%"+title+"%");          
        }
        
        if(Strings.isNotEmpty(createIds)){
            hql.append(" and d.createUserId in (:createIds)");
            param.put("createIds", createIds);
            
        }
        
        if(Strings.isNotEmpty(OutMiniType)){
            hql.append(" and d.frType not in (:OutMiniType)");
            param.put("OutMiniType", OutMiniType);
            
        }
        hql.append(whereString);
        hql.append(" order by d.frOrder, d.lastUpdate desc");
        List<DocResourcePO> list = DBAgent.find(hql.toString(), param, fpi);
        return list;
    }
    
    
    /**
     * 在修改、替换、历史版本恢复过程中，查询到所有映射文档，备用
     * @param docResourceId     源ID
     */
    public List<Long> getAllLink(Long docResourceId) {
        String hql = "select id  from " + DocResourcePO.class.getCanonicalName()
                + " where sourceId=:sourceId and (frType="+ Constants.FORMAT_TYPE_LINK+ " or frType="+ Constants.FORMAT_TYPE_LINK_FOLDER+ ")";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("sourceId", docResourceId);
        return  find(hql, params);
    }
    
    @Override
    public List<DocResourcePO> findByLogicPathLike(String logicPath) {
        String hql = "from DocResourcePO doc where doc.logicalPath like :logicalPath ";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("logicalPath", logicPath + "%");
        return find(hql,-1,-1, params);
    }
    
    @Override
    public List<DocResourcePO> findPigeonholeArchive(Collection<Long> ids, Boolean isDuplicatePigeonhole) {
        List<Long> frTypes = Arrays.asList(new Long[] { 1L, 2l, 3l, 5l, 6l, 7l, 8l, 9l, 21l });
        if (!ids.isEmpty()) {
            String hql = "from DocResourcePO doc where doc.id in(:ids) and doc.frType in(:frTypes) ";
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("ids", ids);
            params.put("frTypes", frTypes);
            if (isDuplicatePigeonhole) {
                hql += "and doc.isPigeonholeArchive =:isPigeonholeArchive ";
                params.put("isPigeonholeArchive", isDuplicatePigeonhole);
            }
            return DBAgent.find(hql, params);
        }
        return Collections.emptyList();
    }
    
    public void updatePigeonholeArchive(Collection<Long> docIds) {
        if (Strings.isNotEmpty(docIds)) {
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("docIds", docIds);
            params.put("isPigeonholeArchive", Boolean.TRUE);
            String hql = "update DocResourcePO set isPigeonholeArchive=:isPigeonholeArchive where id in(:docIds)";
            DBAgent.bulkUpdate(hql, params);
        }
    }
    
    @SuppressWarnings("unchecked")
    public List<DocResourcePO> getDocsByLibId(Long docLibId) {
        String hsql = "from DocResourcePO as a where a.docLibId = :docLibId and parentFrId <> 0";
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("docLibId", docLibId);
        return this.find(hsql, -1, -1, map);
    }
    @SuppressWarnings("unchecked")
    public List<Long> getDocsByParentFrId(Long parentFrId) {
    	String hsql = "select id from DocResourcePO as a where parentFrId = :parentFrId";
    	Map<String, Object> map = new HashMap<String, Object>();
    	map.put("parentFrId", parentFrId);
    	return this.find(hsql, -1, -1, map);
    }
    
    @Override
    public List<DocResourcePO> findFavoriteByCondition(Map<String,Object> params) {
    	String userName = (String) params.get("userName");
    	String fromTime = (String) params.get("fromTime");
    	String toTime = (String) params.get("toTime");
    	String frType = (String) params.get("frType");
    	String docName = (String) params.get("docName");
    	String docLibId = (String) params.get("docLibId");
    	Map<String, Object> map = new HashMap<String, Object>();
    	StringBuilder hsql = new StringBuilder("select dr from DocResourcePO as dr ");
    	String where = " where dr.favoriteSource IS NOT NULL and dr.docLibId = :docLibId";
    	map.put("docLibId", Long.parseLong(docLibId));
    	if(Strings.isNotBlank(userName)){
    		final String org = ",OrgMember as o";
    		final String con = " and o.id = dr.createUserId and o.name like :name";
    		hsql.append(org+where+con);
    		map.put("name", "%"+SQLWildcardUtil.escape(userName.trim())+"%");
    	}else{
    		hsql.append(where);
    		if(Strings.isNotBlank(fromTime)){
        		hsql.append(" and dr.createTime >=:fromTime");
        		map.put("fromTime", Datetimes.getTodayFirstTime(fromTime));
        	}
        	if(Strings.isNotBlank(toTime)){
        		hsql.append(" and dr.createTime <=:toTime");
        		map.put("toTime", Datetimes.getTodayLastTime(toTime));
        	}
        	if(Strings.isNotBlank(frType)){
        		hsql.append(" and dr.frType =:frType");
        		map.put("frType", Long.parseLong(frType));
        	}
        	if(Strings.isNotBlank(docName)){
        		hsql.append(" and dr.frName like :docName");
        		map.put("docName", "%"+SQLWildcardUtil.escape(docName.trim())+"%");
        	}
    	}
    	hsql.append(" order by dr.lastUpdate desc, dr.frOrder");
        //map.put("docLibId", docLibId);
        return this.find(hsql.toString(), map);
    }
    
	@SuppressWarnings("unchecked")
	@Override
	public List<DocResourcePO> getDocResourceByLogicPathLike(List<String> logicPaths, DocSearchModel dsm)
			throws BusinessException {
		Map<String, Object> params = new HashMap<String, Object>();
		StringBuilder hql = DocSearchHqlUtils.searchByProperties(dsm, params);
		StringBuilder hql2 = new StringBuilder();
		List<DocResourcePO> docResourceList = new ArrayList<DocResourcePO>();

		for (int i = 0; i < logicPaths.size(); i++) {
			hql2.append(" and d.logicalPath like :logicalPath");
			params.put("logicalPath", logicPaths.get(i) + "%");
			hql.append(hql2);
			List<DocResourcePO> result = this.find(hql.toString(),-1,-1, params);
			docResourceList.addAll(result);
		}
		return docResourceList;
	}
    
}
