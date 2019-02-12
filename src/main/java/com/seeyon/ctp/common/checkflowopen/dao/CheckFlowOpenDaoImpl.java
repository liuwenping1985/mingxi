package com.seeyon.ctp.common.checkflowopen.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.ctp.common.checkflowopen.po.ProCheckFlowOpen;
import com.seeyon.ctp.util.DBAgent;

public class CheckFlowOpenDaoImpl implements CheckFlowOpenDao{
	

	
	@SuppressWarnings("unchecked")
	@Override
	public String checkFlowOpen(Long affairId,String currentUserName){
		
		String currentOpenUser = "null";
		//User user  = AppContext.getCurrentUser();
		//String currentUserName = user.getName();
		
		List<ProCheckFlowOpen> userLst =  getOpenFlowUser(affairId);
		if (userLst == null || userLst.size() == 0){
			ProCheckFlowOpen checkFlowOpen = new ProCheckFlowOpen();
			checkFlowOpen.setIdIfNew();
			checkFlowOpen.setCurrentOpenUser(currentUserName);
			checkFlowOpen.setAffairId(affairId);
			DBAgent.save(checkFlowOpen);
			return currentOpenUser;
		}
		
		ProCheckFlowOpen checkFlowOpen = userLst.get(0);
		String userNames = checkFlowOpen.getCurrentOpenUser();
		String[] userNameLst = userNames.split(",");
		for(String userName : userNameLst){
			if (!userName.equalsIgnoreCase(currentUserName)){
				currentOpenUser = userName;
				break;
			}
		}
		if (userNames.indexOf(currentUserName)== -1){
			checkFlowOpen.setCurrentOpenUser(String.format("%s,%s", userNames,currentUserName));
			DBAgent.saveOrUpdate(checkFlowOpen);
		}
		
		return currentOpenUser;
	}
	
	public void removeOpenUser(Long affairId, String currentUserName){
		
		List<ProCheckFlowOpen> checkFlowOpenLst = getOpenFlowUser(affairId);
		if (checkFlowOpenLst == null || checkFlowOpenLst.size() == 0){
			return;
		}
		
		ProCheckFlowOpen checkFlowOpen = checkFlowOpenLst.get(0);
		// 删除记录
		if (currentUserName == null){
			DBAgent.delete(checkFlowOpen);
			return;
		}

		String userNames = checkFlowOpen.getCurrentOpenUser();
		String[] userNameLst = userNames.split(",");
	    String openUser = "";
		for(String userName : userNameLst){
			if (userName.equalsIgnoreCase(currentUserName)){
				continue;
			}
			if (openUser.equals("")){
				openUser = userName;
			}else{
				openUser = String.format("%s,%s", openUser,userName);
			}
		}
		if (openUser.equals("")){
			DBAgent.delete(checkFlowOpen);
		}else{
			checkFlowOpen.setCurrentOpenUser(openUser);
			DBAgent.saveOrUpdate(checkFlowOpen);
		}
		return;
	}
	
	@SuppressWarnings("unchecked")
	private List<ProCheckFlowOpen> getOpenFlowUser(Long affairId){

		Map<String, Long> map = new HashMap<String, Long>();
		String hql = "from " + ProCheckFlowOpen.class.getName() + " f where f.affairId =:affairId";
		
		map.put("affairId", affairId);

		return DBAgent.find(hql, map);
	}
	
}
