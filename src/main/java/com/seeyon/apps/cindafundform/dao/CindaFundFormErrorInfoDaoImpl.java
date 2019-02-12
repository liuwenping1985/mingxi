package com.seeyon.apps.cindafundform.dao;

import java.util.List;

import com.seeyon.apps.cindafundform.po.CindaFundFormErrorInfo;
import com.seeyon.ctp.util.DBAgent;

public class CindaFundFormErrorInfoDaoImpl implements CindaFundFormErrorInfoDao {

	@Override
	public void save(CindaFundFormErrorInfo record) {
		DBAgent.save(record);
	}

	@Override
	public void update(CindaFundFormErrorInfo record) {
	    DBAgent.update(record);
	}

	@Override
	public void delete(CindaFundFormErrorInfo record) {
		DBAgent.delete(record);
	}

	@Override
	public List<CindaFundFormErrorInfo> select() {
	    StringBuilder hql = new StringBuilder("from CindaFundFormErrorInfo _this");
	    return DBAgent.find(hql.toString());
	}

	@Override
	public CindaFundFormErrorInfo findById(long id) {
		return DBAgent.get(CindaFundFormErrorInfo.class, id);
	}

}
