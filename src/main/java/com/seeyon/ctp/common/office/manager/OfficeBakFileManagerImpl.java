package com.seeyon.ctp.common.office.manager;

import java.util.List;

import com.seeyon.ctp.common.office.dao.OfficeBakFileDao;
import com.seeyon.ctp.common.office.po.OfficeBakFile;
import com.seeyon.ctp.util.UUIDLong;

/**
 * 备份数据与源数据Manager实现（ctp_file）
 * @author chenxd
 *
 */
public class OfficeBakFileManagerImpl implements OfficeBakFileManager {

	private OfficeBakFileDao obdao;
	
	@Override
	public List<Long> getOfficeBakFileIds(Long sourceId) {
		return obdao.getOfficeBakFileIds(sourceId);
	}
	
	/**
	 * 保存表间关系
	 */
	@Override
	public void save(OfficeBakFile officeBakFile) {
		 Long newFileId = Long.valueOf(UUIDLong.longUUID());
		 officeBakFile.setId(newFileId);
		 obdao.save(officeBakFile);
	}
	
	@Override
	public void delete(Long fileId) {
		obdao.delete(fileId);
	}
	public void setObdao(OfficeBakFileDao obdao) {
		this.obdao = obdao;
	}

}
