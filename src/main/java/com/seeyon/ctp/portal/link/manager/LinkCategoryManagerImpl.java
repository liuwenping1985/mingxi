package com.seeyon.ctp.portal.link.manager;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.portal.link.util.Constants;
import com.seeyon.ctp.portal.po.PortalLinkCategory;
import com.seeyon.ctp.util.DBAgent;

public class LinkCategoryManagerImpl implements LinkCategoryManager {
    private LinkSystemManager linkSystemManager;

    public void setLinkSystemManager(LinkSystemManager linkSystemManager) {
        this.linkSystemManager = linkSystemManager;
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<PortalLinkCategory> getAllCategories() throws BusinessException {
        String queryString = "from PortalLinkCategory where creatorType = :creatorType order by orderNum";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("creatorType", Constants.LINK_CREATOR_TYPE_SYSTEMADMIN);
        return DBAgent.find(queryString, params);
    }

    @Override
    public PortalLinkCategory saveCategory(Long categoryId, String cname, boolean isSystemAdmin,Long parentId)
            throws BusinessException {
    	if(Constants.LINK_CATEGORY_COMMON_NAME.equals(cname)||Constants.LINK_CATEGORY_IN_NAME.equals(cname)
    			||Constants.LINK_CATEGORY_OUT_NAME.equals(cname)||Constants.LINK_CATEGORY_KNOWLEDGE_NAME.equals(cname)){
    		throw new BusinessException("已存在名称为 " + cname + " 的关联系统类别！");
    	}else if (checkDuplicateCategoryInDB(cname, AppContext.currentUserId(), categoryId)) {
            throw new BusinessException("已存在名称为 " + cname + " 的关联系统类别！");
        }
        PortalLinkCategory category = null;
        int type = Constants.LINK_CREATOR_TYPE_MEMBER;
        //isSystemAdmin = AppContext.isSystemAdmin();
        Date date = new Date();
        if (categoryId == -1) {
            category = new PortalLinkCategory();
            category.setNewId();
            category.setCname(cname);
            category.setCreateTime(date);
            category.setCreateUserId(AppContext.currentUserId());
            category.setDescription("");
            category.setLastUserId(AppContext.currentUserId());
            category.setLastUpdate(date);
            category.setSystem(false);
            category.setOrderNum(selectMaxSort("PortalLinkCategory") + 1);
            if (isSystemAdmin) {
                parentId = 0L;
                type = Constants.LINK_CREATOR_TYPE_SYSTEMADMIN;
            }
            category.setParentId(parentId);
            category.setCreatorType(type);
            DBAgent.save(category);
        } else {
            category = DBAgent.get(PortalLinkCategory.class, categoryId);
            if (category == null) {
                throw new BusinessException("没有找到关联系统类别，categoryId:" + categoryId);
            }
            category.setCname(cname);
            category.setCreateTime(date);
            category.setCreateUserId(AppContext.currentUserId());
            category.setLastUserId(AppContext.currentUserId());
            category.setLastUpdate(date);
            DBAgent.update(category);
        }
        return category;
    }

    @Override
    public void deleteCategory(Long categoryId) throws BusinessException {
        if (linkSystemManager.checkLinkSytemByCategory(categoryId)) {
            throw new BusinessException(ResourceUtil.getString("link.jsp.del.cateory.existdata"));
        }
        PortalLinkCategory category = DBAgent.get(PortalLinkCategory.class, categoryId);
        DBAgent.delete(category);
    }

    @SuppressWarnings("rawtypes")
    @Override
    public long selectMaxSort(String entityName) {
        String hql = "select max(orderNum) from " + entityName;
        List result = DBAgent.find(hql);
        Long maxSort = (Long) result.get(0);
        if (maxSort == null) {
            return 0;
        } else {
            return maxSort;
        }
    }

    /**
     * 检查数据库中一些字段是否有重复
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
    private boolean checkDuplicateInDB(String fieldName, Object[] valueArray, String entityName, Long id)
            throws BusinessException {
        if (valueArray == null || valueArray.length == 0) {
            throw new BusinessException("valueList is empty");
        }
        List valueList = new ArrayList();
        for (int i = 0; i < valueArray.length; i++) {
            valueList.add(valueArray[i]);
        }
        StringBuffer sql = new StringBuffer();
        sql.append("select count(id) from " + entityName + " where ");
        sql.append(fieldName).append(" in (:valueList) and id != :id ");
        Map params = new HashMap();
        params.put("valueList", valueList);
        params.put("id", id);
        List list = DBAgent.find(sql.toString(), params);
        Long count = (Long) list.get(0);
        return count > 0;
    }
    
    @SuppressWarnings({ "rawtypes", "unchecked" })
    private boolean checkDuplicateCategoryInDB(String categoryName, Long createUserId, Long id) throws BusinessException {
        StringBuffer sql = new StringBuffer();
        sql.append("select count(id) from PortalLinkCategory where cname = :cname and createUserId = :createUserId and id != :id ");
        Map params = new HashMap();
        params.put("cname", categoryName);
        params.put("createUserId", createUserId);
        params.put("id", id);
        List list = DBAgent.find(sql.toString(), params);
        Long count = (Long) list.get(0);
        return count > 0;
    }

    @Override
    public PortalLinkCategory selectCategoryById(long categoryId) throws BusinessException {
        return DBAgent.get(PortalLinkCategory.class, categoryId);
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<PortalLinkCategory> getCategoriesByUser() throws BusinessException {
        String queryString = "from PortalLinkCategory where creatorType = :creatorType and createUserId =:createUserId order by orderNum";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("creatorType", Constants.LINK_CREATOR_TYPE_MEMBER);
        params.put("createUserId", AppContext.currentUserId());
        return DBAgent.find(queryString, params);
    }

    @Override
    public List<PortalLinkCategory> getCategoriesByAdmin() throws BusinessException {
        return getAllCategories();
    }
}
