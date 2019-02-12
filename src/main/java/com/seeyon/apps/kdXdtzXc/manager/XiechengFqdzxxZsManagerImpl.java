package com.seeyon.apps.kdXdtzXc.manager;

import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.kdXdtzXc.dao.XiechengFqdzxxZsDao;
import com.seeyon.apps.kdXdtzXc.po.XiechengFqdzxxZs;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.FlipInfo;
public class XiechengFqdzxxZsManagerImpl implements XiechengFqdzxxZsManager {

	private static final Log LOGGER = LogFactory.getLog(XiechengFqdzxxZsManagerImpl.class);
	
	private XiechengFqdzxxZsDao xiechengFqdzxxZsDao;
	
	public XiechengFqdzxxZsDao getXiechengFqdzxxZsDao() {
		return xiechengFqdzxxZsDao;
	}

	public void setXiechengFqdzxxZsDao(XiechengFqdzxxZsDao xiechengFqdzxxZsDao) {
		this.xiechengFqdzxxZsDao = xiechengFqdzxxZsDao;
	}

	
	public List<XiechengFqdzxxZs> getAll() throws BusinessException {
		return xiechengFqdzxxZsDao.getAll();
	}

	public List<XiechengFqdzxxZs> getDataByIds(Long[] ids) {
		return xiechengFqdzxxZsDao.getDataByIds(ids);
	}

	public XiechengFqdzxxZs getDataById(Long id) throws BusinessException {
		return xiechengFqdzxxZsDao.getDataById(id);
	}

	public void add(XiechengFqdzxxZs xiechengFqdzxxZs) throws BusinessException {
		xiechengFqdzxxZsDao.add(xiechengFqdzxxZs);
	}

	public void update(XiechengFqdzxxZs xiechengFqdzxxZs) throws BusinessException {
		xiechengFqdzxxZsDao.update(xiechengFqdzxxZs);
	}
	
	public void deleteAll(Long[] ids) throws BusinessException {
		xiechengFqdzxxZsDao.deleteAll(ids);
	}

	public void deleteById(Long id) throws BusinessException {
		xiechengFqdzxxZsDao.deleteById(id);
	}
	
	public FlipInfo getListXiechengFqdzxxZsData(FlipInfo fi, Map<String, Object> params) throws BusinessException {
		String hql = "from XiechengFqdzxxZs as xiechengFqdzxxZs ";
		List<XiechengFqdzxxZs> dataList = DBAgent.find(hql, params, fi);
		fi.setData(dataList);
		return fi;
	}

	@Override
	public List<Map<String, Object>> getByTime(int year, int month) {
		
		return xiechengFqdzxxZsDao.getByTime(year, month);
	}

}
