package com.seeyon.apps.kdXdtzXc.manager;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.v3x.edoc.dao.EdocSummaryDao;
import com.seeyon.v3x.edoc.domain.EdocSummary;
import com.seeyon.v3x.edoc.manager.EdocHelper;
import com.seeyon.v3x.edoc.webmodel.EdocSummaryModel;

public class XdzcEdocSummaryManagerImpl implements XdzcEdocSummaryManager {
	private static final Log LOGGER = LogFactory.getLog(XdzcEdocSummaryManagerImpl.class);
	private OrgManager orgManager;
	private EdocSummaryDao edocSummaryDao;
	
	public OrgManager getOrgManager() {
		return orgManager;
	}

	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}

	public EdocSummaryDao getEdocSummaryDao() {
		return edocSummaryDao;
	}

	public void setEdocSummaryDao(EdocSummaryDao edocSummaryDao) {
		this.edocSummaryDao = edocSummaryDao;
	}

	public static String getSelectsummary() {
		return selectSummary;
	}

	private static final String selectSummary = "summary.id," + "summary.startUserId," + "summary.caseId," + "summary.completeTime," + "summary.subject," + "summary.secretLevel," + "summary.identifier," + "summary.docMark," + "summary.serialNo," + "summary.createTime," + "summary.sendTo," + "summary.issuer," + "summary.signingDate," + "summary.deadline," + "summary.deadlineDatetime," + "summary.startTime," + "summary.copies," + "summary.createPerson," + "summary.sendUnit," + "summary.sendDepartment," + "summary.hasArchive," + "summary.processId," + "summary.caseId," + "summary.urgentLevel, " + "summary.templeteId, " + "summary.state, " + "summary.copyTo, " + "summary.reportTo," + "summary.archiveId," + "summary.edocType, " + "summary.docMark2," + "summary.sendTo2, " + "summary.docType,"
	+ "summary.sendType," + "summary.keywords," + "summary.isQuickSend," + "summary.review, " + "summary.currentNodesInfo," + "summary.printUnit," + "summary.printer," + "summary.packTime," + "summary.sendUnit2," + "summary.copyTo2," + "summary.reportTo2," + "summary.keepPeriod," + "summary.receiptDate," + "summary.registrationDate," + "summary.auditor," + "summary.undertaker," + "summary.phone," + "summary.copies2," + "summary.orgAccountId";
	public List<EdocSummaryModel> getAllEdocSummarys(HttpServletRequest request){
    	//(1)得到公文数据
		Map<String, Object> parameterMap = new HashMap<String, Object>();
    	String hql = "select "+selectSummary+" from EdocSummary summary where summary.state <> :not_eq_state and summary.edocType = :edocType ";
    	parameterMap.put("not_eq_state", 2); //排除暂存代发的流程
    	String edocType = request.getParameter("edocType");
    	parameterMap.put("edocType", Integer.valueOf(edocType)); //过滤公文类型, 0发文；1收文；2签报
    	//增加过滤条件
		String condition = request.getParameter("condition");
		String textfield = request.getParameter("textfield");
		String textfield1 = request.getParameter("textfield1");
		if(!StringUtils.isEmpty(condition)){
			if(!StringUtils.isEmpty(textfield) &&condition.equals("subject")){
					hql += " and subject like :subject";
					parameterMap.put("subject","%"+textfield+"%"); 	
			}else if(!StringUtils.isEmpty(textfield)&&condition.equals("docMark")){
				hql+="and docMark = :docMark";
				parameterMap.put("docMark", textfield); 
			}else if(!StringUtils.isEmpty(textfield)&&condition.equals("docInMark")){
				hql+=" and createPerson like :createPerson";
				parameterMap.put("createPerson","%"+textfield+"%"); 
			}else if(!StringUtils.isEmpty(textfield)&&condition.equals("startMemberName")){
				hql+=" and createPerson like :startMemberName";
				parameterMap.put("startMemberName", "%"+textfield+"%"); 
			}else if(condition.equals("createDate")){
				if(!StringUtils.isEmpty(textfield)){
					hql+=" and createTime >= :createDateBegin";
					parameterMap.put("createDateBegin", Datetimes.getTodayFirstTime(textfield)); 
				}
				if(!StringUtils.isEmpty(textfield1)){
					hql+=" and createTime  <= :createDateEnd";
					parameterMap.put("createDateEnd", Datetimes.getTodayFirstTime(textfield1)); 
				}
			}else if(!StringUtils.isEmpty(textfield)&&condition.equals("isFinish")){
				if(textfield.equals("已结束")){
					hql+=" and completeTime is not null";
				}else if(textfield.equals("未结束")){
					hql+=" and completeTime is null";
				}
			}
		}
    	List<Object[]> edocSummaryList = null;
    	User user = AppContext.getCurrentUser();
    	Long danweiId = user.getAccountId(); //单位
    	Long bumen_id = user.getDepartmentId(); //部门
    	hql += " order by summary.createTime desc";
    		edocSummaryList = edocSummaryDao.find(hql.toString(), parameterMap);
    	
    	//(2)进行包包裹为EdocSummaryModel对象
		List<EdocSummaryModel> models = new ArrayList<EdocSummaryModel>(edocSummaryList.size());
		for (int i = 0; i < edocSummaryList.size(); i++) {
			Object[] obj = edocSummaryList.get(i);
			EdocSummary summary = new EdocSummary();
			buildEdocSummary(summary, obj);
			try {
				V3xOrgMember member = orgManager.getEntityById(V3xOrgMember.class, summary.getStartUserId());
				summary.setStartMember(member);
			} catch (BusinessException e) {
				LOGGER.error("", e);
			}
			EdocSummaryModel model = new EdocSummaryModel();
			model.setWorkitemId(null);
			model.setCaseId(summary.getCaseId() + "");
			model.setStartDate(new java.sql.Date(summary.getCreateTime().getTime()));
			model.setSummary(summary);
			// 设置流程是否超期标志
			java.sql.Timestamp startDate = summary.getCreateTime();
			java.sql.Timestamp finishDate = summary.getCompleteTime();
			Date now = new java.sql.Date(System.currentTimeMillis());

			if (summary.getDeadline() != null && summary.getDeadline() != 0) {
				Long deadline = summary.getDeadline() * 60000;
				if (finishDate == null) {
					if ((now.getTime() - startDate.getTime()) > deadline) {
						summary.setWorklfowTimeout(true);
					}
				} else {
					Long expendTime = summary.getCompleteTime().getTime() - summary.getCreateTime().getTime();
					if ((deadline - expendTime) < 0) {
						summary.setWorklfowTimeout(true);
					}
				}
			}
			model.setFinshed(summary.getCompleteTime() != null);
			model.setDeadlineDisplay(EdocHelper.getDeadLineName(summary.getDeadlineDatetime()));
			summary.setSubject(summary.getSubject());
			model.setSummary(summary);
			// 设置当前处理人信息
			model.setCurrentNodesInfo(EdocHelper.parseCurrentNodesInfo(summary));
			models.add(model);
		}
		return models;
    }
    
    public void buildEdocSummary(EdocSummary summary, Object[] object){
		int n = 0;
		summary.setId((Long) object[n++]);
		summary.setStartUserId((Long) object[n++]);
		summary.setCaseId((Long) object[n++]);
		summary.setCompleteTime((Timestamp) object[n++]);
		summary.setSubject((String) object[n++]);
		summary.setSecretLevel((String) object[n++]);
		summary.setIdentifier((String) object[n++]);
		summary.setDocMark((String) object[n++]);
		summary.setSerialNo((String) object[n++]);
		summary.setCreateTime((Timestamp) object[n++]);
		summary.setSendTo((String) object[n++]);
		summary.setIssuer((String) object[n++]);
		summary.setSigningDate((java.sql.Date) object[n++]);
		summary.setDeadline((Long) object[n++]);
		summary.setDeadlineDatetime((java.util.Date) object[n++]);
		summary.setStartTime((Timestamp) object[n++]);
		summary.setCopies((Integer) object[n++]);
		summary.setCreatePerson((String) object[n++]);
		summary.setSendUnit((String) object[n++]);
		summary.setSendDepartment((String) object[n++]);
		summary.setHasArchive((Boolean) object[n++]);
		summary.setProcessId((String) object[n++]);
		summary.setCaseId((Long) object[n++]);
		summary.setUrgentLevel((String) object[n++]);
		summary.setTempleteId((Long) object[n++]);
		summary.setState((Integer) object[n++]);
		summary.setCopyTo((String) object[n++]);
		summary.setReportTo((String) object[n++]);
		summary.setArchiveId((Long) object[n++]);
		summary.setEdocType((Integer) object[n++]);
		summary.setDocMark2((String) object[n++]);
		summary.setSendTo2((String) object[n++]);
		summary.setDocType((String) object[n++]);
		summary.setSendType((String) object[n++]);
		summary.setKeywords((String) object[n++]);
		summary.setIsQuickSend((Boolean) object[n++]);
		summary.setReview((String) object[n++]);
		summary.setCurrentNodesInfo((String) object[n++]);
		summary.setPrintUnit((String) object[n++]);
		summary.setPrinter((String) object[n++]);
		summary.setPackTime((Timestamp) object[n++]);
		summary.setSendUnit2((String) object[n++]);
		summary.setCopyTo2((String) object[n++]);
		summary.setReportTo2((String) object[n++]);
		summary.setKeepPeriod((Integer) object[n++]);
		summary.setReceiptDate((java.sql.Date) object[n++]);
		summary.setRegistrationDate((java.sql.Date) object[n++]);
		summary.setAuditor((String) object[n++]);
		summary.setUndertaker((String) object[n++]);
		summary.setPhone((String) object[n++]);
		summary.setCopies2((Integer) object[n++]);
		summary.setOrgAccountId((Long) object[n++]);
    }
}
