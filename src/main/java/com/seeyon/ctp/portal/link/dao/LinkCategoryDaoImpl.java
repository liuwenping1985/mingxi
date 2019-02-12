package com.seeyon.ctp.portal.link.dao;

import java.util.List;

import com.seeyon.ctp.portal.po.PortalLinkCategory;
import com.seeyon.ctp.util.CommonTools;
import com.seeyon.ctp.util.DBAgent;

public class LinkCategoryDaoImpl implements LinkCategoryDao {
    @Override
    @SuppressWarnings("unchecked")
    public List<PortalLinkCategory> getLinkCategorys(String name) {
        String hsql = "from LinkCategory as link where link.name = :name";
        return DBAgent.find(hsql, CommonTools.newHashMap("name", name));
    }

    @Override
    @SuppressWarnings("rawtypes")
    public int getMaxOrderNumber() {
        String hsql = "select max(link.orderNum) from LinkCategory as link";
        List list = DBAgent.find(hsql);
        int number = 0;
        if (list != null && list.isEmpty() == false) {
            if (list.get(0) != null) {
                number = (Integer) list.get(0);
                number = number + 1;
            }
        }
        return number;
    }

    @Override
    public void deleteCategorys(String linkCategoryIds) {
        List<Long> ids = CommonTools.parseStr2Ids(linkCategoryIds);
        String hsql = "delete from LinkCategory as link where link.id in (:ids)";
        DBAgent.bulkUpdate(hsql, CommonTools.newHashMap("ids", ids));
    }
}
