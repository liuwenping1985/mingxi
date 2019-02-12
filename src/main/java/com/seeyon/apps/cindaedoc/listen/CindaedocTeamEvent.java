package com.seeyon.apps.cindaedoc.listen;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

import com.seeyon.apps.cindaedoc.manager.CindaedocManager;
import com.seeyon.apps.collaboration.event.CollaborationStartEvent;
import com.seeyon.apps.collaboration.manager.ColManager;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.JDBCAgent;
import com.seeyon.ctp.util.annotation.ListenEvent;

public class CindaedocTeamEvent {
	
	private String tabName = AppContext.getSystemProperty("cindaedoc.cinda_qianbao_tabname");
	private String zsName = AppContext.getSystemProperty("cindaedoc.cinda_qianbao_team");
	private String drName = AppContext.getSystemProperty("cindaedoc.cinda_qianbao_person");
	
	private ColManager colManager;
	private OrgManager orgManager;
	private CindaedocManager cindaedocManager;

	public void setCindaedocManager(CindaedocManager cindaedocManager) {
		this.cindaedocManager = cindaedocManager;
	}

	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}

	public void setColManager(ColManager colManager) {
		this.colManager = colManager;
	}

	@ListenEvent(event = CollaborationStartEvent.class)
	public void onStart(CollaborationStartEvent event) throws BusinessException {
		if (AppContext.getSystemProperty("cindaedoc.cinda_qianbao").equals(event.getTemplateCode())) {
			ColSummary cs = colManager.getColSummaryById(event.getSummaryId());
			if (cs != null) {
				String sql = "select " + zsName + " from " + tabName + " where id = ?";
				Connection connOA = JDBCAgent.getConnection();
				List<String[]> listData = cindaedocManager.getDataBySql(sql, connOA, 0, new Object[]{cs.getFormRecordid()});
				if (listData != null && listData.size() > 0) {
					String[] data = listData.get(0);
					if (data != null && data.length > 0 && data[0] != null && !"".equals(data[0])) {
						String[] teams = data[0].split(",");
						List<V3xOrgMember> listAll = new ArrayList<V3xOrgMember>();
						for (int i = 0; i < teams.length; i++) {
							String[] team = teams[i].split("\\|");
							listAll.addAll(orgManager.getMembersByTeam(Long.valueOf(team[1])));
						}
						StringBuffer sb = new StringBuffer("");
						if (listAll.size() > 0) {
							for (V3xOrgMember vom : listAll) {
								sb.append("Member|").append(vom.getId()).append(",");
							}
							if (sb.length() > 0) {
								sb.setLength(sb.length() - 1);
							}
						}
						if (sb.length() > 0) {
							String upSql = "update " + tabName + " set " + drName + " = ? where id = ?";
							cindaedocManager.updateBySql(upSql, connOA, new Object[]{sb.toString(), cs.getFormRecordid()});
						}
					}
				}
			}
		}
	}
}