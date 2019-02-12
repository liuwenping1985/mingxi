package com.seeyon.ctp.common.office.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.ctp.common.office.po.OfficeBakFile;
import com.seeyon.ctp.util.DBAgent;

/**
 * 备份数据与源数据持久成实现
 * @author chenxd
 *
 */
public class OfficeBakFileDaoImpl implements OfficeBakFileDao {
	/**
	 * 根据sourceId查询所有的备份数据在ctp_file里面的ID
	 */
	@Override
	public List<Long> getOfficeBakFileIds(Long sourceId) {
		
		Map pmap = new HashMap();
		pmap.put("sourceId", sourceId);
		String hql = "from OfficeBakFile where sourceId = :sourceId";
		List<OfficeBakFile> querylist = DBAgent.find(hql, pmap);
		List<Long> list = new ArrayList<Long>();
		if(querylist!=null){
			for(OfficeBakFile ql:querylist){
				list.add(ql.getFileId());
			}
		}
		return list;
	}
	/**
	 * 保存备份数据与原数据的关系
	 */
	@Override
	public void save(OfficeBakFile officeBakFile) {
		DBAgent.save(officeBakFile);
	}
	/**
	 * 根据备份数据的ID删除关系数据
	 */
	@Override
	public void delete(Long fileId) {
		String hql = "delete from OfficeBakFile where fileId= :fileId";
		Map  pMap = new HashMap();
		pMap.put("fileId", fileId);
		DBAgent.bulkUpdate(hql,pMap);
	}

}
