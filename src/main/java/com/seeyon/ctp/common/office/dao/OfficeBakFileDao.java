package com.seeyon.ctp.common.office.dao;

import java.util.List;

import com.seeyon.ctp.common.office.po.OfficeBakFile;

/**
 * 备份数据与源数据持久成
 * @author chenxd
 *
 */
public interface OfficeBakFileDao {
	/**
	 * 根据sourceId查询所有的备份数据在ctp_file里面的ID
	 * @param sourceId
	 * @return
	 */
	public List<Long> getOfficeBakFileIds (Long sourceId);
	
	/**
	 * 保存备份数据与原数据的关系
	 * @param officeBakFile
	 */
	public void save(OfficeBakFile officeBakFile);
	
	/**
	 * 根据备份数据的ID删除关系数据
	 */
	public void delete(Long fileId);
}
