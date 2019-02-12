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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.ctp.portal.po.PortalLinkOptionValue;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.UUIDLong;

public class LinkOptionValueDaoImpl implements LinkOptionValueDao {

    @Override
    @SuppressWarnings("rawtypes")
    public PortalLinkOptionValue findOptionValues(long userId, long linkOptionId) {
        String hsql = "from PortalLinkOptionValue as link where link.userId= :userId and link.linkOptionId= :linkPtionId";
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("userId", userId);
        map.put("linkPtionId", linkOptionId);
        List list = DBAgent.find(hsql, map);
        if (list != null && list.isEmpty() == false) {
            PortalLinkOptionValue value = (PortalLinkOptionValue) list.get(0);
            return value;
        }
        return null;
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<PortalLinkOptionValue> selectLinkOptionValues(long userId, List<Long> optionId) {
        StringBuffer buffer = new StringBuffer();
        buffer.append("from PortalLinkOptionValue as link where link.userId=:userId and link.linkOptionId in ( :ids)");
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("ids", optionId);
        map.put("userId", userId);
        List<PortalLinkOptionValue> list = DBAgent.find(buffer.toString(), map);
        return list;
    }

    @Override
    @SuppressWarnings("unchecked")
    public PortalLinkOptionValue findOptionValues(long linkSystemId, String paramName, long userId) {
        StringBuffer sbf = new StringBuffer();
        sbf.append("select lov.id, lov.value, lov.user_id, lov.link_option_id from v3x_link_option_value lov ");
        sbf.append("inner join v3x_link_option lo on lov.link_option_id = lo.id ");
        sbf.append("where lo.link_system_id= :linkSystemId and lo.param_name= :paramName  and lov.user_id= : userId");
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("linkSystemId", linkSystemId);
        map.put("paramName", paramName);
        map.put("userId", userId);
        List<PortalLinkOptionValue> list = DBAgent.find(sbf.toString(), map);
        if (list != null && list.isEmpty() == false) {
            PortalLinkOptionValue value = (PortalLinkOptionValue) list.get(0);
            return value;
        }
        return null;
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<Object[]> statisticsLinkOptionValue(final List<PortalLinkOptionValue> linkOptionList) {
        if (linkOptionList == null || linkOptionList.size() == 0) {
            return null;
        }
        if (linkOptionList.get(0).getValue() == null || linkOptionList.get(0).getValue().isEmpty()) {
            return null;
        }
        List<Long> linkIds = new ArrayList<Long>();
        StringBuffer hql = new StringBuffer();
        hql.append("select lov.userId,");
        for (PortalLinkOptionValue lo : linkOptionList) {
            linkIds.add(lo.getId());
            hql.append(" max(case lov.linkOptionId when " + lo.getId() + " then lov.value else '' end),");
        }
        hql.delete(hql.length() - 1, hql.length());
        hql.append(" from PortalLinkOptionValue lov where lov.linkOptionId in (:linkIds) ");
        hql.append(" group by lov.userId");
        Map<String, Object> namedParameterMap = new HashMap<String, Object>();
        namedParameterMap.put("linkIds", linkIds);
        return DBAgent.find(hql.toString(), namedParameterMap);
    }

    @Override
    public void deleteParamValues(final List<Long> linkOptionIds, final List<Long> userIds) {
        StringBuffer hql = new StringBuffer();
        hql.append("delete from PortalLinkOptionValue as a where a.linkOptionId in (:linkOptionIds) and a.userId in (:userIds)");
        Map<String, Object> nameParameters = new HashMap<String, Object>();
        nameParameters.put("linkOptionIds", linkOptionIds);
        nameParameters.put("userIds", userIds);
        DBAgent.bulkUpdate(hql.toString(), nameParameters);
    }

    @Override
    public void saveLinkOptionValue(List<PortalLinkOptionValue> linkOptionValue) {
    	for(PortalLinkOptionValue portalLinkOptionValue:linkOptionValue){
    		portalLinkOptionValue.setId(UUIDLong.longUUID());
    	}
        DBAgent.saveAll(linkOptionValue);
    }

    @Override
    public void deleteLinkOptionValue(List<PortalLinkOptionValue> linkOptionValue) {
//        DBAgent.deleteAll(linkOptionValue);
        StringBuilder hql=new StringBuilder();
        Map<String,Object> map=new HashMap<String,Object>();
        List<Long> list=new ArrayList<Long>();
        if(linkOptionValue.size()>0){
		        for(PortalLinkOptionValue portalLinkOptionValue:linkOptionValue){
		        	hql.append("delete from PortalLinkOptionValue where linkOptionId in(:linkOptionId) and userId in(:userId)");
		        	list.add(portalLinkOptionValue.getLinkOptionId());
		        }
        	}
        map.put("linkOptionId", list);
        map.put("userId", linkOptionValue.get(0).getUserId());
        DBAgent.bulkUpdate(hql.toString(), map);
        }
}
