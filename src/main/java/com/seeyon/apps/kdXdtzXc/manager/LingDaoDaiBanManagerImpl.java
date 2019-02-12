package com.seeyon.apps.kdXdtzXc.manager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.apps.doc.po.DocResourcePO;
import com.seeyon.apps.kdXdtzXc.dao.LingDaoDaiBanDao;
import com.seeyon.apps.kdXdtzXc.util.PropertiesUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.v3x.common.web.login.CurrentUser;

public class LingDaoDaiBanManagerImpl implements LingDaoDaiBanManager {
	private static final Log LOGGER = LogFactory.getLog(LingDaoDaiBanManagerImpl.class);
	private LingDaoDaiBanDao lingDaoDaiBanDao;

	public LingDaoDaiBanDao getLingDaoDaiBanDao() {
		return lingDaoDaiBanDao;
	}

	public void setLingDaoDaiBanDao(LingDaoDaiBanDao lingDaoDaiBanDao) {
		this.lingDaoDaiBanDao = lingDaoDaiBanDao;
	}

	public List<Map<String, Object>> listCtpAffairmanage() {
		List<Map<String, Object>> listCtpAffair1 = lingDaoDaiBanDao.listCtpAffair();
		return listCtpAffair1;
	}

	@SuppressWarnings("unchecked")
	@Override
	public FlipInfo getallGenDuo(FlipInfo paramFlipInfo, Map<String, Object> params) throws BusinessException {
		JdbcTemplate kimdeJdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
		User user = CurrentUser.get();
		Long currentUserId = user.getId();
		String lingdaoDaiban_sql = (String) PropertiesUtils.getInstance().get("lingdaoDaiban_sql");
		List<Map<String, Object>> lingdaoIdList = kimdeJdbcTemplate.queryForList(lingdaoDaiban_sql, new Object[] { currentUserId });
		if (lingdaoIdList == null || lingdaoIdList.size() == 0)
			return null;
		List<Long> lindaoIds = new ArrayList<Long>();
		for (int i = 0; i < lingdaoIdList.size(); i++) {
			Map<String, Object> oneData = lingdaoIdList.get(i);
			String LINGDAOID = (String) oneData.get("field0001");
			if (StringUtils.isEmpty(LINGDAOID))
				continue;
			lindaoIds.add(Long.valueOf(LINGDAOID));
		}

		List<Integer> apps = new ArrayList<Integer>();
		apps.add(1);
		apps.add(19);
		apps.add(20);
		apps.add(21);
		apps.add(6);
		apps.add(29);
		String hql = "from CtpAffair c where c.app in(:_app) and c.memberId in (:_memberId) AND c.state=3 order by c.createDate desc";
		params.put("_memberId", lindaoIds);
		params.put("_app", apps);
		List<CtpAffair> listctpAffair = DBAgent.find(hql, params, paramFlipInfo);
		paramFlipInfo.setData(listctpAffair);
		return paramFlipInfo;
	}

	/**
	 * 公文查询流程激活
	 */
	@Override
	public CtpAffair listQueryCtpAffair(Long objectid) {
		Map<String, Object> map = new HashMap<String, Object>();
		String hql = "from  CtpAffair c WHERE c.objectId =:objectId and c.completeTime is not null  ORDER BY c.completeTime DESC";
		map.put("objectId", objectid);
		List<CtpAffair> find = DBAgent.find(hql, map);
		CtpAffair ctpAffair = null;
		if (find != null && find.size() > 0) {
			ctpAffair = find.get(0);
		}
		if (ctpAffair != null) {
			JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
			String sql = "UPDATE ctp_affair  SET STATE=3 WHERE id= ?";
			jdbcTemplate.update(sql, new Object[] { ctpAffair.getId() });
			String sql1 = "UPDATE edoc_summary SET  STATE=0 WHERE id=?";
			jdbcTemplate.update(sql1, new Object[] { objectid });
		}
		return ctpAffair;
	}

	/*
	 * 专题列表
	 */

	public FlipInfo listAllDocResourcePO(FlipInfo paramFlipInfo, Map<String, Object> params) {
		String hql = "from DocResourcePO where parentFrId = :parentFrId  ";
		String parentFrId = (String) params.get("parentFrId");
		if (!StringUtils.isEmpty(parentFrId)) {
			params.put("parentFrId", Long.valueOf(parentFrId));
			List<DocResourcePO> listDocResourcePO = DBAgent.find(hql, params, paramFlipInfo);
			for (DocResourcePO doc : listDocResourcePO) {
				String memberName = Functions.showMemberName(doc.getCreateUserId());
				doc.setUsername(memberName);
			}
			paramFlipInfo.setData(listDocResourcePO);
			return paramFlipInfo;
		}
		return null;
	}

}
