package com.seeyon.ctp.portal.link.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.ctp.portal.po.PortalLinkSpace;
import com.seeyon.ctp.portal.po.PortalLinkSpaceAcl;
import com.seeyon.ctp.util.DBAgent;

public class LinkSpaceDaoImpl implements LinkSpaceDao {
    @SuppressWarnings("unchecked")
    public List<PortalLinkSpace> getLinkSpacesCanAccess(List<Long> domainIds) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("domainIds", domainIds);
        String hql = "select sp from " + PortalLinkSpace.class.getName() + " sp, " + PortalLinkSpaceAcl.class.getName()
                + " acl " + " where acl.linkSpaceId=sp.id and acl.userId in (:domainIds) order by sp.sort asc ";
        if(null!=domainIds && domainIds.size()>1000){
        	List<PortalLinkSpace> result= new ArrayList<PortalLinkSpace>();
        	int maxLength = 999, listSize = domainIds.size();
    		int length = listSize/maxLength;
    		if(listSize!=0){
    		    length++;
    		}
    		for(int i=0; i<length; i++){
    			int start = i*maxLength;
    			int end = (i+1)*maxLength;
    			if(end>(listSize)){
    				end = listSize;
    			}
    			if(start==end){
    				break;
    			}
    			List<Long> subDomainIds = domainIds.subList(start, end);
    			params.put("domainIds", subDomainIds);
        		List<PortalLinkSpace> subSpaces = DBAgent.find(hql, params);
        		if(null!=subSpaces && !subSpaces.isEmpty()){
        			result.addAll(subSpaces);
        		}
    		}
    		return result;
        }else{
        	params.put("domainIds", domainIds);
        	return DBAgent.find(hql, params);
        }
    }

    
    @SuppressWarnings("unchecked")
    public boolean isUseTheLinkSpace(List<Long> domainIds, Long linkSpaceId) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("domainIds", domainIds);
        params.put("linkSpaceId", linkSpaceId);
        String hql = "select count(sp.id) from " + PortalLinkSpace.class.getName() + " sp, "
                + PortalLinkSpaceAcl.class.getName() + " acl "
                + " where acl.linkSpaceId=sp.id and sp.id=:linkSpaceId and acl.userId in (:domainIds) ";
        List<Long> result = DBAgent.find(hql, params);
        long count = 0;
        if (result != null && result.size() == 1) {
            count = result.get(0);
        }
        return count > 0;
    }

}
