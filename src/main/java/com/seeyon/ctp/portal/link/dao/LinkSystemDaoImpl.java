package com.seeyon.ctp.portal.link.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.portal.link.util.Constants;
import com.seeyon.ctp.portal.po.PortalLinkAcl;
import com.seeyon.ctp.portal.po.PortalLinkSystem;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.FlipInfo;

public class LinkSystemDaoImpl implements LinkSystemDao {

    @SuppressWarnings({ "unchecked", "rawtypes" })
    @Override
    public FlipInfo selectLinkSystem(FlipInfo fi, Map params) {
        StringBuffer hql = new StringBuffer();
        Long userId=AppContext.currentUserId();
        //查有没有个人自定义排序数据,用于判断用哪个字段做排序,bug:OA-127344 
        String orderHql="from PortalLinkMember where memberId = :userId";
        Map orderParams=new HashMap();
        orderParams.put("userId",userId);
        boolean hasOrder=DBAgent.exists(orderHql,orderParams);
        
        Map p = new HashMap();
        //OA-28759 排除categoryId为0的情况，否则查询不出数据
        if (params.get("categoryId") != null && !"0".equals(params.get("categoryId"))) {
            hql.append(" and ls.linkCategoryId = :categoryId");
            p.put("categoryId", Long.valueOf(params.get("categoryId").toString()));
        }
        if (params.get("linkSystemId") != null) {
            hql.append(" and ls.id in (:linkSystemId)");
            p.put("linkSystemId", params.get("linkSystemId"));
        }
        if ((params.get("includeKnowledge") == null || "null".equals(params.get("includeKnowledge")) ) 
        		&& ( params.get("categoryId") == null || "0".equals(params.get("categoryId")))) {
            hql.append(" and ls.linkCategoryId != :categoryKnowledgeId and ls.creatorType =:creatorType"); 
            p.put("categoryKnowledgeId", Constants.LINK_CATEGORY_KNOWLEDGE_ID); 
            p.put("creatorType", Constants.LINK_CREATOR_TYPE_SYSTEMADMIN);
        }
        
        if(hasOrder){
        	p.put("userId", userId);
        	hql.insert(
                    0,
                    "select new map(ls.id as id, ls.lname as lname, lc.cname as cname, ls.createTime as createTime, "
                    + "ls.linkCategoryId as linkCategoryId, lc.description as description,ls.description as ldescription, "
                    + "ls.image as image, ls.createUserId as createUserId, ls.enabled as enabled, lm.userLinkSort as orderNum) "
                    + "from PortalLinkSystem ls, PortalLinkCategory lc ,PortalLinkMember lm where lm.memberId = :userId"
                    + " and ls.linkCategoryId = lc.id and lm.linkSystemId=ls.id ");
        	if (fi.getSortField() == null || "".equals(fi.getSortField())) {
                fi.setSortField("lm.userLinkSort,ls.id");//排序俩字段,解决oracle排序问题
            }
        }else{
        	hql.insert(
                    0,
                    "select new map(ls.id as id, ls.lname as lname, lc.cname as cname, ls.createTime as createTime, "
                    + "ls.linkCategoryId as linkCategoryId, lc.description as description,ls.description as ldescription, "
                    + "ls.image as image, ls.createUserId as createUserId, ls.enabled as enabled, ls.orderNum as orderNum) "
                    + "from PortalLinkSystem ls, PortalLinkCategory lc where ls.linkCategoryId = lc.id ");
        	if (fi.getSortField() == null || "".equals(fi.getSortField())) {
                fi.setSortField("ls.orderNum,ls.id");//排序俩字段,解决oracle排序问题
            }
        }
        if (fi.getSortField() != null && "createTime".equals(fi.getSortField())) {
            fi.setSortField("ls.createTime");
        }
        if (fi.getSortField() != null && "description".equals(fi.getSortField())) {
            fi.setSortField("ls.description");
        }
        DBAgent.find(hql.toString(), p, fi);
        return fi;
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<PortalLinkSystem> selectLinkSystem(List<Long> linkSystemId, int size, long linkCategoryId) {
        List<PortalLinkSystem> ret = new ArrayList<PortalLinkSystem>();
        if (linkSystemId == null || linkSystemId.isEmpty() == true) {
            return ret;
        }

        Map<String, Object> params = new HashMap<String, Object>();
        String sql = "from PortalLinkSystem where id in (:linkSystemId) and linkCategoryId in (:linkCategoryId) order by orderNum asc";
        params.put("linkSystemId", linkSystemId);
        params.put("linkCategoryId", linkCategoryId);
        FlipInfo fi = new FlipInfo();
        if (size > 0) {
            fi.setSize(size);
            DBAgent.find(sql, params, fi);
            return fi.getData();
        }
        return DBAgent.find(sql, params);
    }

    @Override
    @SuppressWarnings("rawtypes")
    public boolean isUseTheSystem(Long systemId, Long systemCategoryId, List<Long> domainIds) {
        String hql = "select count(distinct acl.id) from " + PortalLinkAcl.class.getName() + " as acl where "
                + "acl.userId in (:domainIds) and (acl.linkSystemId=:systemId or acl.linkCategoryId=:systemCategoryId)";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("systemId", systemId);
        params.put("systemCategoryId", systemCategoryId);
        params.put("domainIds", domainIds);
        List list = DBAgent.find(hql, params);
        Long count = (Long) list.get(0);
        return count > 0;
    }

    @SuppressWarnings({ "rawtypes", "unchecked" })
    @Override
    public PortalLinkSystem selectLinkSystemById(long linkSystemId) {
        StringBuffer hql = new StringBuffer(
                "select ls from PortalLinkSystem ls left join fetch ls.linkAcls left join fetch ls.linkOptions left join fetch ls.linkSpaces lsp left join fetch lsp.linkSpaceAcls left join fetch ls.linkSections lsc left join fetch lsc.linkSectionSecurities left join fetch ls.linkMenus where ls.id = :id");
        Map params = new HashMap();
        params.put("id", linkSystemId);
        List<PortalLinkSystem> list = DBAgent.find(hql.toString(), params);
        if (list != null && list.size() > 0) {
            return list.get(0);
        }
        return null;
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<PortalLinkSystem> findLinkSystemByCreator(long userId, int creatorType, int size) {
        String queryString = "from PortalLinkSystem where createUserId=:createUserId and creatorType=:creatorType and enabled = 1 order by orderNum asc";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("createUserId", userId);
        params.put("creatorType", creatorType);
        if (size > 0) {
            FlipInfo flip = new FlipInfo();
            flip.setSize(size);
            return DBAgent.find(queryString, params, flip);
        }
        return DBAgent.find(queryString, params);
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<PortalLinkSystem> findAllLinkSystem(List<Long> linkSystemId) {
        String sql = "from PortalLinkSystem vls where id in (:linkSystemId)";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("linkSystemId", linkSystemId);
        return DBAgent.find(sql, params);
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<PortalLinkSystem> findLinkSystemBySharerType(List<Long> linkSystemId, int creatorType,
            boolean includeKnowledge, long userId) {
        String sql = "from PortalLinkSystem where id in (:linkSystemId) and creatorType=:creatorType and enabled = 1";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("linkSystemId", linkSystemId);
        params.put("creatorType", creatorType);
        if (!includeKnowledge) {
            sql += " and linkCategoryId != :categoryId";
            params.put("categoryId", Constants.LINK_CATEGORY_KNOWLEDGE_ID);
        } else {
            sql += " and createUserId!=:createUserId";
            params.put("createUserId", userId);
        }
        sql += " order by orderNum,id asc";//OA-115455默认排序增加id,解决oracle数据库orderNum全是1时两个排序顺序不一致问题
        return DBAgent.find(sql, params);
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<PortalLinkSystem> findLinkSystemByCreator(long userId, long linkCategoryId) {
        String queryString = "from PortalLinkSystem where createUserId=:createUserId and creatorType=:creatorType and linkCategoryId=:linkCategoryId";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("createUserId", userId);
        params.put("creatorType", Constants.LINK_CREATOR_TYPE_MEMBER);
        params.put("linkCategoryId", linkCategoryId);
        return DBAgent.find(queryString, params);
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<PortalLinkSystem> findAllShareKnowledge(List<Long> linkSystemId, long userId, int size) {
        String queryString = "from PortalLinkSystem where "
                + "((((creatorType=:systemType and linkCategoryId=:linkCategoryId) or creatorType=:memberType) and id in (:linkSystemId))"
                + " or (creatorType=:creatorType and createUserId = :createUserId))" + " and enabled = 1 ";
        queryString += " order by createTime desc";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("memberType", Constants.LINK_CREATOR_TYPE_MEMBER);
        params.put("systemType", Constants.LINK_CREATOR_TYPE_SYSTEMADMIN);
        params.put("linkCategoryId", Constants.LINK_CATEGORY_KNOWLEDGE_ID);
        params.put("linkSystemId", linkSystemId);
        params.put("creatorType", Constants.LINK_CREATOR_TYPE_MEMBER);
        params.put("createUserId", userId);
        FlipInfo flip = new FlipInfo();
        if (size > 0) {
            flip.setSize(size);
        }
        return DBAgent.find(queryString, params, flip);
    }

    @SuppressWarnings("rawtypes")
    @Override
    public FlipInfo findMemberShareKnowledge(FlipInfo fi, Map params) {
        StringBuffer hql = new StringBuffer();
        Map<String, Object> p = new HashMap<String, Object>();
        if (params.get("linkSystemId") != null) {
            hql.append(" and ls.id in (:linkSystemId)");
            p.put("linkSystemId", params.get("linkSystemId"));
        }
        hql.append(" and ls.creatorType = :creatorType and ls.createUserId != :createUserId and ls.enabled = 1");
        p.put("creatorType", Constants.LINK_CREATOR_TYPE_MEMBER);
        p.put("createUserId", AppContext.currentUserId());
        hql.insert(
                0,
                "select new map(ls.id as id, ls.lname as lname, lc.cname as cname, ls.createTime as createTime, ls.linkCategoryId as linkCategoryId, lc.description as description, ls.image as image, ls.createUserId as createUserId, ls.enabled as enabled) from PortalLinkSystem ls, PortalLinkCategory lc where ls.linkCategoryId = lc.id ");
        if (fi.getSortField() != null && "createTime".equals(fi.getSortField())) {
            fi.setSortField("ls.createTime");
        }
        DBAgent.find(hql.toString(), p, fi);
        return fi;
    }

    @SuppressWarnings("rawtypes")
    @Override
    public FlipInfo findLinkSystemByCreator(FlipInfo fi, Map params) {
        StringBuffer hql = new StringBuffer();
        Map<String, Object> p = new HashMap<String, Object>();

        if (params.get("creatorType") != null) {
            hql.append(" and ls.creatorType = :creatorType");
            p.put("creatorType", params.get("creatorType"));
        }
        if (params.get("createUserId") != null) {
            hql.append(" and ls.createUserId = :createUserId");
            p.put("createUserId", params.get("createUserId"));
        }
        hql.insert(
                0,
                "select new map(ls.id as id, ls.lname as lname, lc.cname as cname, ls.createTime as createTime, ls.linkCategoryId as linkCategoryId, lc.description as description, ls.image as image, ls.createUserId as createUserId, ls.enabled as enabled) from PortalLinkSystem ls, PortalLinkCategory lc where ls.linkCategoryId = lc.id ");
        DBAgent.find(hql.toString(), p, fi);
        return fi;
    }

    @SuppressWarnings({ "rawtypes", "unchecked" })
    @Override
    public boolean checkLinkSytemByCategory(Long categoryId) {
        StringBuffer hql = new StringBuffer(
                "select count(id) from PortalLinkSystem where linkCategoryId = :linkCategoryId");
        Map params = new HashMap();
        params.put("linkCategoryId", categoryId);
        List list = DBAgent.find(hql.toString(), params);
        Long count = (Long) list.get(0);
        return count > 0;
    }

    @Override
    public PortalLinkSystem selectLinkSystem(String lname, Long categoryId) {
        StringBuffer hql = new StringBuffer(
                "from PortalLinkSystem where linkCategoryId = :linkCategoryId and lname = :lname");
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("linkCategoryId", categoryId);
        params.put("lname", lname);
        List<PortalLinkSystem> list = DBAgent.find(hql.toString(), params);
        if (list != null && list.size() > 0) {
            return list.get(0);
        }
        return null;
    }

    @Override
    public PortalLinkSystem findLinkSystemByUrl(String linkSystemUrl) {
        StringBuffer hql = new StringBuffer(
        "from PortalLinkSystem where url = :url ");
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("url", linkSystemUrl);
        List<PortalLinkSystem> list = DBAgent.find(hql.toString(), params);
        if (list != null && list.size() > 0) {
            return list.get(0);
        }
        return null;
    }

	@Override
	public List<PortalLinkSystem> findAll() {
		StringBuffer hql = new StringBuffer("from PortalLinkSystem");
		return DBAgent.find(hql.toString());
	}
}
