package com.seeyon.apps.syncorg.log.manager.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.alibaba.fastjson.JSONObject;
import com.seeyon.apps.syncorg.enums.SyncStatusEnum;
import com.seeyon.apps.syncorg.log.dao.SyncLogDao;
import com.seeyon.apps.syncorg.log.manager.SyncLogManager;
import com.seeyon.apps.syncorg.manager.CzOrgManager;
import com.seeyon.apps.syncorg.po.log.SyncLog;
import com.seeyon.apps.syncorg.web.SyncLogWeb;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.AjaxAccess;


public class SyncLogManagerImpl implements SyncLogManager {

	
	private static final Log log = LogFactory.getLog(SyncLogManagerImpl.class);
	
	private SyncLogDao syncLogDao;
	public SyncLogDao getSyncLogDao() {
		return syncLogDao;
	}
	public void setSyncLogDao(SyncLogDao syncLogDao) {
		this.syncLogDao = syncLogDao;
	}
	
	private CzOrgManager czOrgManager;
	public CzOrgManager getCzOrgManager() {
		return czOrgManager;
	}
	public void setCzOrgManager(CzOrgManager czOrgManager) {
		this.czOrgManager = czOrgManager;
	}
	@Override
	@AjaxAccess
	public FlipInfo queryByCondition(FlipInfo flipInfo,
			Map<String, String> query) {
		List<SyncLog> list = syncLogDao.queryByCondition(flipInfo, query);
		List<SyncLogWeb> listWeb = new ArrayList();
		if(list!=null&&list.size()>0){
			for(SyncLog moveLog : list){
				SyncLogWeb web = new SyncLogWeb(moveLog);
				listWeb.add(web);
			}
		}
		flipInfo.setData(listWeb);
		return flipInfo;
	}
	@Override
	@AjaxAccess
	public void insert(SyncLog syncLog) {
		syncLogDao.insert(syncLog);
		
	}
	
	@Override
	@AjaxAccess
	public void update(SyncLog syncLog) {
		syncLogDao.update(syncLog);
		
	}
	@Override
	@AjaxAccess
	public String syncOne(String id) {
		
		try {
			SyncLog syncLog = syncLogDao.getById(Long.valueOf(id));
			return czOrgManager.SyncOne(syncLog);
		} catch (Exception e) {
				log.error("", e);
		}
		return "false";
	}

	@Override
	@AjaxAccess
	/*
	 * 迁移全部记录
	 * @see com.seeyon.apps.oadev.log.manager.MoveLogManager#moveAll()
	 */
	public String SyncAll() {
		log.info("启动了迁移全部记录的程序, 包括成功的记录， 失败的记录和未迁移的记录。");
		List<SyncLog> list = syncLogDao.getListByStatus(null);
		return moveList(list);
	}
	
	private String moveList(List<SyncLog> list){
		String retval = "";
		if(list!=null&&list.size()>0){

			log.info("查询出需要同步的总数是：" + list.size());
			for(SyncLog syncLog : list){
				try{
					log.info("开始同步记录：" + JSONObject.toJSONString(syncLog));
					String oneReturn = syncOne(String.valueOf(syncLog.getId()));
					if(!Strings.isBlank(oneReturn)&&!"true".equals(oneReturn)){
						retval = oneReturn;
					}
				}catch(Exception e){
					log.info("同步记录失败 " + syncLog.getXmlString());
					log.error("", e);
					retval = "false";
				}

			}
		}
		return retval;
	}
	@Override
	@AjaxAccess
	/*
	 * 迁移失败的记录
	 * @see com.seeyon.apps.oadev.log.manager.MoveLogManager#moveFailed()
	 */
	public String syncFailed() {
		log.info("启动了同步所有未成功记录的程序, 包括失败的记录和未同步的记录。");
		List<SyncLog> list = syncLogDao.getListByStatus(new SyncStatusEnum [] {SyncStatusEnum.Failed, SyncStatusEnum.None });
		return moveList(list);
	}
	@Override
	@AjaxAccess
	public List<SyncLog> getAll() {
		// TODO Auto-generated method stub
		return syncLogDao.getAll();
	}
	@Override
	@AjaxAccess
	public String deleteRecord(String ids) {
		boolean retsult = syncLogDao.deleteRecord(ids);
		return retsult ? "true":"false";
	}
}
