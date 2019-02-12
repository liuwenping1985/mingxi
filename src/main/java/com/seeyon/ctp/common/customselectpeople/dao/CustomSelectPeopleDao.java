package com.seeyon.ctp.common.customselectpeople.dao;

import java.util.List;

import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;

public interface CustomSelectPeopleDao {
	
	public List<CtpEnumItem> getEnumItemByEnumId(Long enumId,String showValue);
	
	public List<CtpEnumItem> getEnumItemByEnumId(Long enumId);
}
