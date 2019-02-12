package com.seeyon.apps.czexchange.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jgroups.util.UUID;

import com.seeyon.apps.czexchange.dao.EdocSummaryAndDataRelationDAO;
import com.seeyon.apps.czexchange.po.EdocSummaryAndDataRelation;
import com.seeyon.apps.sursenExchange.po.MidReceiveFile;
import com.seeyon.apps.sursenExchange.po.MidReceiveSummary;
import com.seeyon.ctp.util.DBAgent;

public class EdocSummaryAndDataRelationDaoImpl implements EdocSummaryAndDataRelationDAO {

	private static final Log log = LogFactory.getLog(EdocSummaryAndDataRelationDaoImpl.class);
	@Override
	public List<EdocSummaryAndDataRelation> getRelationByEdicId(Long edocId) {

		String hql = " from " + EdocSummaryAndDataRelation.class.getSimpleName() + " where edocId=:edocId";
		Map<String, Object> params = new HashMap();
		params.put("edocId", edocId);
		List<EdocSummaryAndDataRelation> list =  DBAgent.find(hql, params);
		return list;
	}

	@Override
	public void updateReceiveSummary(MidReceiveSummary res) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public List<MidReceiveFile> findFileBy(Long id) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<MidReceiveSummary> findBy(String flag, Integer integer) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Long getMaxId() {
		// TODO Auto-generated method stub
		return Long.valueOf(String.valueOf(UUID.randomUUID()));
	}

	@Override
	public EdocSummaryAndDataRelation getRelationByMsgId(String msgId) {
		String hql = " from " + EdocSummaryAndDataRelation.class.getSimpleName() + "  r where r.msgId =:msgId";
		Map<String, Object> params = new HashMap();
		params.put("msgId", msgId);
		List<EdocSummaryAndDataRelation> list = DBAgent.find(hql, params);
		if(list!=null&&list.size()>0){
			return list.get(0);
		}
		return null;
	}

	@Override
	public void updateStatus(String msgId, int status) {
//		UPDATE pro_edoc_datarel rel set rel.rel_status='1' WHERE rel.rel_msgId='6292039876770219085'
		String hql = "update "+EdocSummaryAndDataRelation.class.getName() +" rel set rel.status=:status  where rel.msgId=:msgId";
		Map<String ,Object> param = new HashMap<String, Object>();
		param.put("status", status);
		param.put("msgId", msgId);
		int len = DBAgent.bulkUpdate(hql, param);
		if(len<=0){
			log.error("not exits msgid = "+msgId+" !!!!");
		}
	}

}
