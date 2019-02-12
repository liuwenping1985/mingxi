package com.seeyon.apps.czexchange.dao;

import java.util.List;

import com.seeyon.apps.czexchange.po.EdocSummaryAndDataRelation;
import com.seeyon.apps.sursenExchange.po.MidReceiveFile;
import com.seeyon.apps.sursenExchange.po.MidReceiveSummary;

public interface EdocSummaryAndDataRelationDAO {

	// 对于收文来说， 一个公文的 edocId 只对应一条记录， 对于发文来说， 可能会有多条记录， 一个接收单位一条记录
	public List<EdocSummaryAndDataRelation> getRelationByEdicId(Long edocId);
	
	public EdocSummaryAndDataRelation getRelationByMsgId(String msgId);
	
	public void updateReceiveSummary(MidReceiveSummary res);
	
	public List<MidReceiveFile> findFileBy(Long id);
	
	public List<MidReceiveSummary> findBy(String flag, Integer integer);
	
	public Long getMaxId();
	
	public void updateStatus(String msgId, int status);
}
