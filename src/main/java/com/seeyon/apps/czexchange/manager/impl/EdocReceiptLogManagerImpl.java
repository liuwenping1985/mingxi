package com.seeyon.apps.czexchange.manager.impl;

import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.cinda.exchange.client.util.ClientUtil;
import com.seeyon.apps.czexchange.dao.EdocReceiptLogDao;
import com.seeyon.apps.czexchange.dao.EdocSummaryAndDataRelationDAO;
import com.seeyon.apps.czexchange.enums.EdocSendOrReceiveStatusEnum;
import com.seeyon.apps.czexchange.manager.EdocReceiptLogManager;
import com.seeyon.apps.czexchange.po.EdocReceiptLog;

public class EdocReceiptLogManagerImpl implements EdocReceiptLogManager {

	private static final Log log = LogFactory.getLog(EdocReceiptLogManagerImpl.class);
	
	private EdocReceiptLogDao edocReceiptLogDao;
	private EdocSummaryAndDataRelationDAO edocSummaryAndDataRelationDAO;
	public EdocSummaryAndDataRelationDAO getEdocSummaryAndDataRelationDAO() {
		return edocSummaryAndDataRelationDAO;
	}
	public void setEdocSummaryAndDataRelationDAO(
			EdocSummaryAndDataRelationDAO edocSummaryAndDataRelationDAO) {
		this.edocSummaryAndDataRelationDAO = edocSummaryAndDataRelationDAO;
	}
	public EdocReceiptLogDao getEdocReceiptLogDao() {
		return edocReceiptLogDao;
	}
	public void setEdocReceiptLogDao(EdocReceiptLogDao edocReceiptLogDao) {
		this.edocReceiptLogDao = edocReceiptLogDao;
	}
	@Override
	public void sendReceiptLog(EdocReceiptLog edocReceiptLog) {
		boolean success = ClientUtil.sendFlag(edocReceiptLog.getMsgId(), "OK");  // 收到的标示从目前文档上看还不清楚， 用 0 表示未收到  1 表示 收到
		if(success){
			edocReceiptLog.setSuccess(true);
			edocReceiptLog.setTryTimes(edocReceiptLog.getTryTimes() + 1);
			edocReceiptLogDao.saveOrUpdate(edocReceiptLog);
			edocSummaryAndDataRelationDAO.updateStatus(edocReceiptLog.getMsgId(), EdocSendOrReceiveStatusEnum.sendReceipt.getKey());
		}else{
			// 需要增加到回执的发送队列中， 等待进一步的发送回执
			edocReceiptLog.setSuccess(false);
			edocReceiptLog.setTryTimes(edocReceiptLog.getTryTimes() + 1);
			edocReceiptLogDao.saveOrUpdate(edocReceiptLog);
		}	
	}
	@Override
	public List<EdocReceiptLog> getUnSuccessRecord(Date createDate) {
		return edocReceiptLogDao.getUnSuccessRecord(createDate);
	}
}
