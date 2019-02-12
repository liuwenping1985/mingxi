package com.seeyon.apps.kdXdtzXc.controller;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.collaboration.enums.CollaborationEnum;
import com.seeyon.apps.kdXdtzXc.manager.LingDaoDaiBanManager;
import com.seeyon.apps.kdXdtzXc.manager.XdzcEdocSummaryManager;
import com.seeyon.apps.kdXdtzXc.util.JSONUtilsExt;
import com.seeyon.apps.kdXdtzXc.util.RequestUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.v3x.edoc.domain.EdocSummary;
import com.seeyon.v3x.edoc.manager.EdocManager;
import com.seeyon.v3x.edoc.manager.EdocSummaryManager;
import com.seeyon.v3x.edoc.webmodel.EdocSummaryModel;

public class XdzcEdocController extends BaseController {
	private XdzcEdocSummaryManager xdzcEdocSummaryManager;
	private LingDaoDaiBanManager lingDaoDaiBanManager;
	private EdocSummaryManager edocSummaryManager;
	private EdocManager edocManager;
	
	
	public EdocManager getEdocManager() {
		return edocManager;
	}

	public void setEdocManager(EdocManager edocManager) {
		this.edocManager = edocManager;
	}

	public EdocSummaryManager getEdocSummaryManager() {
		return edocSummaryManager;
	}

	public void setEdocSummaryManager(EdocSummaryManager edocSummaryManager) {
		this.edocSummaryManager = edocSummaryManager;
	}

	public LingDaoDaiBanManager getLingDaoDaiBanManager() {
		return lingDaoDaiBanManager;
	}

	public void setLingDaoDaiBanManager(LingDaoDaiBanManager lingDaoDaiBanManager) {
		this.lingDaoDaiBanManager = lingDaoDaiBanManager;
	}

	public XdzcEdocSummaryManager getXdzcEdocSummaryManager() {
		return xdzcEdocSummaryManager;
	}

	public void setXdzcEdocSummaryManager(XdzcEdocSummaryManager xdzcEdocSummaryManager) {
		this.xdzcEdocSummaryManager = xdzcEdocSummaryManager;
	}

	/**
	 * 详情页面
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView detailIFrame(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xdzcEdoc/edocDetailIFrame");
		return modelAndView;
	}

	public void getFirstArrairId_bySummaryId(HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
			String summaryId = request.getParameter("summaryId");
			String sql = "SELECT t1.ID FROM ctp_affair t1, edoc_summary t2 WHERE t2.id = t1.object_id AND t2.id = ? ORDER BY create_date ASC";
			List<Map<String, Object>> affairList = jdbcTemplate.queryForList(sql, new Object[] { summaryId });
			Map<String, Object> map = new HashMap<String, Object>();
			if (affairList != null && affairList.size() > 0)
				map = affairList.get(0);
			this.write(JSONUtilsExt.objects2json("success", true, "message", "操作成功!", "affairId", map.get("ID").toString()), response);
		} catch (Exception e) {
			this.write(JSONUtilsExt.objects2json("success", false, "message", "操作失败:" + e.getMessage()), response);
		}
	}

	public ModelAndView getAllEdocSummarys(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xdzcEdoc/list_allEdocSummary");
		List<EdocSummaryModel> allEdocSummarys = xdzcEdocSummaryManager.getAllEdocSummarys(request);
		modelAndView.addObject("allEdocSummarys", allEdocSummarys);

		modelAndView.addAllObjects(RequestUtil.getParameterValueMap(request, false));
		return modelAndView;
	}

	/**
	 * 选择模板
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView selectTemplate(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xdzcEdoc/selectTemplate");
		/*
		 * JdbcTemplate jdbcTemplate = (JdbcTemplate)
		 * AppContext.getBean("kimdeJdbcTemplate"); String templateCategory =
		 * request.getParameter("templeteCategory") == null ? "-1" :
		 * request.getParameter("templeteCategory"); List<Map<String, Object>>
		 * templateList = jdbcTemplate.
		 * queryForList("select id, subject from ctp_template t where t.category_id="
		 * +templateCategory); Map<String, Long> subject_id_map = new
		 * HashMap<String, Long>(); if(templateList != null &&
		 * templateList.size() > 0){ for(Map<String, Object> oneMap :
		 * templateList){ Object id = oneMap.get("id"); String subject =
		 * (String) oneMap.get("subject"); subject_id_map.put(subject,
		 * Long.valueOf(id.toString())); } }
		 * modelAndView.addObject("subject_id_map", subject_id_map);
		 */
		modelAndView.addAllObjects(RequestUtil.getParameterValueMap(request, false));
		return modelAndView;
	}

	protected void write(String str, HttpServletResponse response) {
		try {
			response.setContentType("text/html;charset=UTF-8");
			response.getWriter().write(str);
			response.getWriter().flush();
			response.getWriter().close();
		} catch (Exception e) {
		}
	}

	/**
	 * 流程激活公文
	 * 
	 * @param request
	 * @param response
	 */
	public void edocLiuchengjihuo(HttpServletRequest request, HttpServletResponse response) {
	//客开 赵培珅  2018-06-01 start
		try {
	    	Long objectid = Long.valueOf(request.getParameter("edocid"));
	    	String summaryIds = request.getParameter("summaryIds");
			EdocSummary edocSummary = edocSummaryManager.findById(objectid);
			if(edocSummary != null && CollaborationEnum.flowState.finish.ordinal() != edocSummary.getState())
				throw new Exception("只有已完成的流程可以激活!");
			
			edocManager.reActiveHasFinishedFlow(summaryIds);
			this.write(JSONUtilsExt.objects2json("success", true, "message", "操作成功!"), response);
		} catch (Exception e) {
			this.write(JSONUtilsExt.objects2json("success", false, "message", e.getMessage()), response);
		}
	}

	public void edocChongDinWei(HttpServletRequest request, HttpServletResponse response) {
		try {
			JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
			String summarId = request.getParameter("summaryId");
			String affairId = request.getParameter("affairId");
			boolean isGourpBy = StringUtils.isEmpty(request.getParameter("isGourpBy")) ? true : Boolean.valueOf(request.getParameter("isGourpBy"));
			
			EdocSummary edocSummary = edocSummaryManager.findById(Long.valueOf(summarId));
			if(CollaborationEnum.flowState.finish.ordinal() == edocSummary.getState()){
				throw new Exception("结束的流程不能进行重定向！");
			}
			String _affairId = "";
			if(!isGourpBy){
				String sql = "SELECT CAN_DUE_REMIND FROM ctp_affair  WHERE ID=" + affairId + " AND OBJECT_ID= " + summarId;
				List<Map<String, Object>> listaffic = jdbcTemplate.queryForList(sql);
				if (listaffic != null && listaffic.size() > 0) {
					Map<String, Object> oneData = listaffic.get(0);
					String CAN_DUE_REMIND = oneData.get("CAN_DUE_REMIND") != null ? oneData.get("CAN_DUE_REMIND").toString() : null;
					if ("0".equals(CAN_DUE_REMIND))
						throw new Exception("虚拟圆圈开始任务节点不能重定向！");
				}
				_affairId = affairId;
			}else{
				String sql = "SELECT ID FROM ctp_affair  WHERE CAN_DUE_REMIND !=0 AND OBJECT_ID= " + summarId+" ORDER BY RECEIVE_TIME DESC";
				List<Map<String, Object>> listaffic = jdbcTemplate.queryForList(sql);
				if (listaffic != null && listaffic.size() > 0) {
					Map<String, Object> oneData = listaffic.get(0);
					_affairId = oneData.get("ID") != null ? oneData.get("ID").toString() : null;
				}
			}
			this.write(JSONUtilsExt.objects2json("success", true, "message", "操作成功!", "affairId", _affairId), response);
		} catch (Exception e) {
			this.write(JSONUtilsExt.objects2json("success", false, "message", e.getMessage()), response);
		}
	}
	
	/**
	 * 重定位选择人时校验是不是本流程中的人员
	 * @param request
	 * @param response
	 */
	public void checkUserForChongdingwei(HttpServletRequest request, HttpServletResponse response) {
		try {
			JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
			String summarId = request.getParameter("summaryId");
			String selectedIds = StringUtils.isEmpty(request.getParameter("selectedIds")) ? "" : request.getParameter("selectedIds");
			String selectedNames = StringUtils.isEmpty(request.getParameter("selectedNames")) ? "" : request.getParameter("selectedNames");
			String[] selectedIdAry = selectedIds.split(",");
			String[] selectedNameAry = selectedNames.split(",");
			if(selectedIdAry != null && selectedIdAry.length > 0){
				EdocSummary edocSummary = edocSummaryManager.findById(Long.valueOf(summarId));
				String sql = "SELECT MEMBER_ID FROM ctp_affair  WHERE OBJECT_ID= " + summarId + " AND CASE_ID = "+edocSummary.getCaseId();
				List<Map<String, Object>> listaffic = jdbcTemplate.queryForList(sql);
				Set<String> MEMBER_ID_LIST = new HashSet<String>();
				if (listaffic != null && listaffic.size() > 0) {
					for(int j=0; j<listaffic.size(); j++){
						Map<String, Object> oneData = listaffic.get(j);
						String MEMBER_ID = oneData.get("MEMBER_ID") != null ? oneData.get("MEMBER_ID").toString() : null;
						if(!StringUtils.isEmpty(MEMBER_ID))
							MEMBER_ID_LIST.add(MEMBER_ID);
					}
				}
				for(int i=0; i<selectedIdAry.length; i++){
					String selectedId = selectedIdAry[i];
					String selectedName = selectedNameAry[i];
					if(!MEMBER_ID_LIST.contains(selectedId))
						throw new Exception("["+selectedName + "]不在此流程中，不能选择！");
				}
			}
			this.write(JSONUtilsExt.objects2json("success", true, "message", "操作成功!"), response);
		} catch (Exception e) {
			this.write(JSONUtilsExt.objects2json("success", false, "message", e.getMessage()), response);
		}
	}
}
