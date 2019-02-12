/**
 * $Author: leikj $
 * $Rev: 6983 $
 * $Date:: 2012-11-05 10:40:41 +#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
package com.seeyon.ctp.portal.link.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.ctp.portal.po.PortalLinkOption;
import com.seeyon.ctp.util.CommonTools;
import com.seeyon.ctp.util.DBAgent;

public class LinkOptionDaoImpl implements LinkOptionDao {
    @Override
    @SuppressWarnings("unchecked")
    public List<PortalLinkOption> getLinkOptionBySystemId(long linkSystemId) {
        String hsql = "from LinkOption as link where link.linkSystemId= :linkSystemId order by link.orderNum asc";
        List<PortalLinkOption> list = DBAgent.find(hsql, CommonTools.newHashMap("linkSystemId", linkSystemId));
        return list;
    }

    @Override
    public PortalLinkOption findLinkOptionBy(final long linkSystemId, final String paramName) {
        String hsql = "from LinkOption as link where link.linkSystemId=:linkSystemId and link.paramName=:paramName";
        Map<String, Object> namedParameterMap = new HashMap<String, Object>();
        namedParameterMap.put("linkSystemId", linkSystemId);
        namedParameterMap.put("paramName", paramName);
        return (PortalLinkOption) DBAgent.find(hsql, namedParameterMap);
    }
}
