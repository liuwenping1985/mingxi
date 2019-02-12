package com.seeyon.ctp.common.customselectpeople.Manager;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.google.common.base.Strings;
import com.seeyon.ctp.common.customselectpeople.dao.CustomSelectPeopleDao;
import com.seeyon.ctp.common.customselectpeople.po.CustomSelectPeoplePO;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.util.FlipInfo;

public class CustomSelectPeopleManagerImpl implements CustomSelectPeopleManager{
	
	private CustomSelectPeopleDao customSelectPeopleDao;
	
	public void setCustomSelectPeopleDao(CustomSelectPeopleDao customSelectPeopleDao) {
		this.customSelectPeopleDao = customSelectPeopleDao;
	}

	public FlipInfo getLeaderNames(FlipInfo flipInfo, Map<String, String> condition) throws Exception{
		return getLeaderEnumItem(flipInfo,condition);
	}
	
	public List<CustomSelectPeoplePO> getEnumItemByEnumId(){
		
		List<CustomSelectPeoplePO>  list = new ArrayList<CustomSelectPeoplePO>();
		// 获取领导-职务枚举
		List<CtpEnumItem> enumItemLst = customSelectPeopleDao.getEnumItemByEnumId(-5843629142424599099L);
		for (CtpEnumItem enumItem : enumItemLst) {
			CustomSelectPeoplePO customSelectPeoplePo = new CustomSelectPeoplePO();
			customSelectPeoplePo.setId(enumItem.getId());
			customSelectPeoplePo.setShowValue(enumItem.getShowvalue());
			customSelectPeoplePo.setSortNumber(enumItem.getSortnumber());
			customSelectPeoplePo.setEnumValue(enumItem.getEnumvalue());
		    list.add(customSelectPeoplePo);
		}
		return list;
	}
	
	  private FlipInfo getLeaderEnumItem(FlipInfo flipInfo, Map<String, String> condition) throws Exception{
		  
		  List<CustomSelectPeoplePO>  list = new ArrayList<CustomSelectPeoplePO>();
		  String showValue = Strings.isNullOrEmpty(condition.get("showValue")) ? "" : condition.get("showValue");

		  List<CtpEnumItem> enumItemLst = customSelectPeopleDao.getEnumItemByEnumId(-5843629142424599099L,showValue);
		  for (CtpEnumItem enumItem : enumItemLst) {
	    		CustomSelectPeoplePO customSelectPeoplePo = new CustomSelectPeoplePO();
	    		customSelectPeoplePo.setId(enumItem.getId());
	    		customSelectPeoplePo.setShowValue(enumItem.getShowvalue());
	    		customSelectPeoplePo.setSortNumber(enumItem.getSortnumber());
	    		customSelectPeoplePo.setEnumValue(enumItem.getEnumvalue());
		    	list.add(customSelectPeoplePo);
	    	}
	    	flipInfo.setData(list);
		  return flipInfo;
	    }
	  
	 
}
