package com.seeyon.apps.czexchange.listener;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.cinda.exchange.client.util.ClientUtil;
import com.seeyon.v3x.edoc.domain.EdocSignReceipt;
import com.seeyon.v3x.edoc.event.EdocSignEvent;
import com.seeyon.v3x.exchange.dao.EdocRecieveRecordDao;
import com.seeyon.v3x.exchange.domain.EdocRecieveRecord;
import com.seeyon.v3x.exchange.manager.EdocExchangeManager;
import com.seeyon.apps.czexchange.dao.EdocReceiptLogDao;
import com.seeyon.apps.czexchange.dao.EdocSummaryAndDataRelationDAO;
import com.seeyon.apps.czexchange.enums.EdocSendOrReceiveStatusEnum;
import com.seeyon.apps.czexchange.manager.CzDocExchangeManager;
import com.seeyon.apps.czexchange.manager.EdocReceiptLogManager;
import com.seeyon.apps.czexchange.po.EdocReceiptLog;
import com.seeyon.apps.czexchange.po.EdocSummaryAndDataRelation;
import com.seeyon.apps.czexchange.util.CzVisualUser;
import com.seeyon.apps.dev.doc.enums.EdocTypeEnum;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.annotation.ListenEvent;


public class CzEdocSignListener  {
	
	private static final Log log = LogFactory.getLog(CzEdocSignListener.class);
	
	private EdocReceiptLogManager edocReceiptLogManager;
	private CzDocExchangeManager czDocExchangeManager;
	
	public void setCzDocExchangeManager(CzDocExchangeManager czDocExchangeManager) {
		this.czDocExchangeManager = czDocExchangeManager;
	}

	public EdocReceiptLogManager getEdocReceiptLogManager() {
		return edocReceiptLogManager;
	}

	public void setEdocReceiptLogManager(EdocReceiptLogManager edocReceiptLogManager) {
		this.edocReceiptLogManager = edocReceiptLogManager;
	}

	private EdocReceiptLogDao edocReceiptLogDao;
	
	public EdocReceiptLogDao getEdocReceiptLogDao() {
		return edocReceiptLogDao;
	}

	public void setEdocReceiptLogDao(EdocReceiptLogDao edocReceiptLogDao) {
		this.edocReceiptLogDao = edocReceiptLogDao;
	}

	private EdocRecieveRecordDao edocRecieveRecordDao;
	public EdocRecieveRecordDao getEdocRecieveRecordDao() {
		return edocRecieveRecordDao;
	}

	public void setEdocRecieveRecordDao(EdocRecieveRecordDao edocRecieveRecordDao) {
		this.edocRecieveRecordDao = edocRecieveRecordDao;
	}

	private EdocExchangeManager edocExchangeManager;
	
	public EdocExchangeManager getEdocExchangeManager() {
		return edocExchangeManager;
	}

	public void setEdocExchangeManager(EdocExchangeManager edocExchangeManager) {
		this.edocExchangeManager = edocExchangeManager;
	}

	private EdocSummaryAndDataRelationDAO edocSummaryAndDataRelationDAO;

	public EdocSummaryAndDataRelationDAO getEdocSummaryAndDataRelationDAO() {
		return edocSummaryAndDataRelationDAO;
	}

	public void setEdocSummaryAndDataRelationDAO(
			EdocSummaryAndDataRelationDAO edocSummaryAndDataRelationDAO) {
		this.edocSummaryAndDataRelationDAO = edocSummaryAndDataRelationDAO;
	}

	@ListenEvent(event= EdocSignEvent.class)//协同发起时立刻执行，同步模式，如果监听代码出了异常，会导致整个事务回滚，协同发起失败。
	  public void onEdocSignEvent(EdocSignEvent event){
		EdocSignReceipt edocSignReceipt = event.getEdocSignReceipt();
		
		// 下面这个代码获得的  ID 是 edoc_exchange_receive 表中的 reply_id
		// 公文的 ID 需要查询出这个表中的 Edoc_id
		
		Long replyId = event.getSendDetailId();
	
		String hql = " from " + EdocRecieveRecord.class.getSimpleName() + " where replyId=:replyId";
		Map<String, Object> params = new HashMap();
		params.put("replyId", String.valueOf(replyId));
		List<EdocRecieveRecord> listEdocRecieveRecord = DBAgent.find(hql, params);
		EdocRecieveRecord edocRecieveRecord = null;
		if(listEdocRecieveRecord!=null&&listEdocRecieveRecord.size()>0){
			edocRecieveRecord = listEdocRecieveRecord.get(0);
		}else{
			log.error("监听程序监听到了需要发送公文签收的回执， 但是， 在 EdocRecieveRecord 表中， 没有找到对应的公文， ReplyId= " + replyId);
			return;
		}
	
		// 把公文 Id 转换成 msgId
		List<EdocSummaryAndDataRelation> list = edocSummaryAndDataRelationDAO.getRelationByEdicId(edocRecieveRecord.getEdocId());
		if(list!=null&&list.size()>0){
			// 对于 收文来说， 一个 EdocId 只能对应一个 msgId
			EdocSummaryAndDataRelation edocSummaryAndDataRelation = list.get(0);
			//增加判断，如果是收文，且没有签收的进行推送，签收完成的就别推送了
			if(edocSummaryAndDataRelation.getApp()==EdocTypeEnum.recEdoc.ordinal() && edocSummaryAndDataRelation.getStatus().intValue()==EdocSendOrReceiveStatusEnum.Received.getKey()){
				// 在真正发送回执之前， 为了防止接口调用出错， 首先保存到回执的队列中
				EdocReceiptLog edocReceiptLog = new EdocReceiptLog(edocSummaryAndDataRelation.getMsgId(), "1");
				edocReceiptLogDao.saveOrUpdate(edocReceiptLog);
				edocReceiptLogManager.sendReceiptLog(edocReceiptLog);
			}
		}else{
			log.error("在发送公文回执的时候， 出现严重错误， 对应表中没有找到相应的记录 edocId = " +  edocRecieveRecord.getEdocId());
		}

	 }

}
