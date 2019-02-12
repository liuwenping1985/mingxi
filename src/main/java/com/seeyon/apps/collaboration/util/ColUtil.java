/**
 * $Author$
 * $Rev$
 * $Date::                     $:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */

package com.seeyon.apps.collaboration.util;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.JSONException;
import org.json.JSONObject;

import com.seeyon.apps.agent.bo.AgentDetailModel;
import com.seeyon.apps.agent.bo.AgentModel;
import com.seeyon.apps.agent.bo.MemberAgentBean;
import com.seeyon.apps.collaboration.api.CollaborationApi;
import com.seeyon.apps.collaboration.bo.DateSharedWithWorkflowEngineThreadLocal;
import com.seeyon.apps.collaboration.constants.ColConstant;
import com.seeyon.apps.collaboration.enums.CollaborationEnum;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.collaboration.vo.SeeyonPolicy;
import com.seeyon.apps.doc.api.DocApi;
import com.seeyon.apps.doc.bo.DocResourceBO;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.content.affair.AffairData;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.content.affair.constants.SubStateEnum;
import com.seeyon.ctp.common.ctpenumnew.EnumNameEnum;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.common.po.template.CtpTemplate;
import com.seeyon.ctp.common.quartz.QuartzHolder;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.common.template.manager.TemplateManager;
import com.seeyon.ctp.form.service.FormManager;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.privilege.manager.PrivilegeManager;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.IdentifierUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.workflow.exception.BPMException;
import com.seeyon.ctp.workflow.wapi.WorkflowApiManager;
import com.seeyon.v3x.worktimeset.exception.WorkTimeSetExecption;
import com.seeyon.v3x.worktimeset.manager.WorkTimeManager;

import net.joinwork.bpm.definition.BPMSeeyonPolicy;

public class ColUtil {
    private static Log                log              = LogFactory.getLog(ColUtil.class);
    protected static final int        INENTIFIER_SIZE  = 20;
    private static final int          CURRENT_NODES_INFO_SIZE  = 10;//当前待办人数量
    private static final String       PROXYSTR         = ResourceUtil.getString("collaboration.proxy");
    private static final String       ISADVANCEREMIND  = "1";
    private static final String       NOTADVANCEREMIND = "0";
    private static DocApi             docApi;
    private static EnumManager        enumManagerNew;
    private static OrgManager         orgManager;
    private static WorkTimeManager    workTimeManager;
    private static TemplateManager    templateManager;
    private static WorkflowApiManager wapi;
    private static FormManager        formManager;
    private static CollaborationApi   collaborationApi;
    private static PrivilegeManager   privilegeManager;
    private static AffairManager      affairManager;
    
    public static boolean isFinshed(ColSummary summary) {
        return summary.getFinishDate() != null;
    }
    
    public static  boolean isHasAttachments(ColSummary summary) {
        return IdentifierUtil.lookupInner(summary.getIdentifier(),
                INENTIFIER_INDEX.HAS_ATTACHMENTS.ordinal(), '1');
    }

    public static void setHasAttachments(ColSummary summary,Boolean hasAttachments) {
        if(Strings.isBlank(summary.getIdentifier())){
            summary.setIdentifier(IdentifierUtil.newIdentifier(summary.getIdentifier(), INENTIFIER_SIZE,
                    '0'));
        }
        summary.setIdentifier(IdentifierUtil.update(summary.getIdentifier(),
               INENTIFIER_INDEX.HAS_ATTACHMENTS.ordinal(), hasAttachments ? '1' : '0'));
    }

    /**
     * 标志位, 共100位，采用枚举的自然顺序
     */
    protected static enum INENTIFIER_INDEX {
        HAS_ATTACHMENTS, // 是否有附件
        HAS_FORMTRIGGER, // 是否有配置表单触发
    }

    public static String getMemberName(Long id){
        return Functions.showMemberName(id);
    }
    
    //流程期限
    public static String getDeadLineName(Date deadlineDatetime){
        if(null == deadlineDatetime){//无
            return ResourceUtil.getString("collaboration.project.nothing.label");
        }else{
        	return Datetimes.formatDatetimeWithoutSecond(deadlineDatetime).toString();
        }
    }
    //节点期限
    public static String getDeadLineName(Long value){
        if(value == null || value == 0){//无
            return ResourceUtil.getString("collaboration.project.nothing.label");
        }
        EnumManager enumManager = getEnumManager();
        if(enumManager == null){
            return ResourceUtil.getString("collaboration.project.nothing.label");
        }
        CtpEnumItem cei = enumManager.getEnumItem(EnumNameEnum.collaboration_deadline, value.toString());
        if(cei == null){//无
            return ResourceUtil.getString("collaboration.project.nothing.label");
        }
        return ResourceUtil.getString(cei.getLabel());
    }

    //获得流程期限--如果流程期限大于0且枚举没有该流程期限，则返回具体的流程期限时间（公文用）
    public static String getDeadLineNameForEdoc(Long value, Timestamp createTime){
        if(value == null || value == 0){//无
            return ResourceUtil.getString("collaboration.project.nothing.label");
        }
        EnumManager enumManager = getEnumManager();
        if(enumManager == null){
            return ResourceUtil.getString("collaboration.project.nothing.label");
        }
        CtpEnumItem cei = enumManager.getEnumItem(EnumNameEnum.collaboration_deadline, value.toString());
        if(cei == null){//无
        	if(value>0){
        		return Functions.showDeadlineTime(createTime.toString(), value);
        	}
            return ResourceUtil.getString("collaboration.project.nothing.label");
        }
        return ResourceUtil.getString(cei.getLabel());
    }
    //提醒
    public static String getAdvanceRemind(String value){
        if(value == null  || "0".equals(value)){//无
            return ResourceUtil.getString("collaboration.project.nothing.label");
        }
        EnumManager enumManager = getEnumManager();
        if(enumManager  == null){
            return ResourceUtil.getString("collaboration.project.nothing.label");
        }
        CtpEnumItem cei = enumManager.getEnumItem(EnumNameEnum.common_remind_time, value);
        if(cei == null){//无
            return ResourceUtil.getString("collaboration.project.nothing.label");
        }
        return ResourceUtil.getString(cei.getLabel());
    }
    //基准时长
    public static String getStandardDuration(String value){
        if(value == null || "0".equals(value)){//无
            return ResourceUtil.getString("collaboration.project.nothing.label");
        }
        EnumManager enumManager = getEnumManager();
        if(enumManager  == null){
            return ResourceUtil.getString("collaboration.project.nothing.label");
        }
        CtpEnumItem cei = enumManager.getEnumItem(EnumNameEnum.collaboration_deadline, value);
        if(cei == null){//无
            return ResourceUtil.getString("collaboration.project.nothing.label");
        }
        return ResourceUtil.getString(cei.getLabel());
    }
    
    //重要程度
    public static String getImportantLevel(String value){
        if(value == null){//无
            return ResourceUtil.getString("collaboration.project.nothing.label");
        }
        EnumManager enumManager = getEnumManager();
        if(enumManager  == null){
            return ResourceUtil.getString("collaboration.project.nothing.label");
        }
        CtpEnumItem cei = enumManager.getEnumItem(EnumNameEnum.common_importance, value);
        if(cei == null){//无
            return ResourceUtil.getString("collaboration.project.nothing.label");
        }
        return ResourceUtil.getString(cei.getLabel());
    }

    public static String showSubjectOfSummary(ColSummary summary, Boolean isProxy, int length, String proxyName){
        if(summary == null){
            return null;
        }
        String subject = summary.getSubject();
        if(null != summary.getAutoRun() && summary.getAutoRun()){
        	subject = ResourceUtil.getString("collaboration.newflow.fire.subject",subject);
        }
        return showSubject(subject,summary.getForwardMember(),summary.getResentTime(),isProxy,length,proxyName,false);
    }
    /**
     * 此方法针对 我的代理列表功能
     * @param affair
     * @param isProxy
     * @param length
     * @return
     */
    public static String showSubjectOfAffair(CtpAffair affair, Boolean isProxy, int length){
    	User user = AppContext.getCurrentUser();
        if(affair == null){
        	return null;
        }

        String proxyName = "";
        if(!affair.getMemberId().equals(user.getId())){
        	proxyName = Functions.showMemberNameOnly(affair.getMemberId());
        }

        return showSubject(affair.getSubject(),affair.getForwardMember(),affair.getResentTime(),isProxy,length,proxyName,false);
    }

    private static String showSubject(String subject, String forwardMember,Integer resendTiem, Boolean isProxy, int length, String proxyName,Boolean isAgentDeal){
        if(Strings.isEmpty(proxyName)){
            return mergeSubjectWithForwardMembers(subject, length, forwardMember, resendTiem, null);
        }
        String colProxyLabel = "";
        if(Boolean.TRUE.equals(isProxy)){
        	//我的代理列表(我代表别人)，我是代理人
            List<AgentModel> _agentModelList = MemberAgentBean.getInstance().getAgentModelList(AppContext.getCurrentUser().getId());
            //代理我的代理人列表，我是被代理人
            List<AgentModel> _agentModelToList = MemberAgentBean.getInstance().getAgentModelToList(AppContext.getCurrentUser().getId());
            boolean agentToFlag = false;
            if(_agentModelList != null && !_agentModelList.isEmpty()){
                agentToFlag = false;
            }else if(_agentModelToList != null && !_agentModelToList.isEmpty()){
                agentToFlag = true;
            }
            if(agentToFlag){
            	//(XX)代理
                colProxyLabel = "(" + proxyName + PROXYSTR + ")";
            }else{
                if(isAgentDeal){      //被代理人自己处理
                	//(XX)处理
                    colProxyLabel = "(" + ResourceUtil.getString("collaboration.proxy.deal", proxyName) + ")";
                }else{
                	//代理(XX)
                    colProxyLabel = "(" + ResourceUtil.getString("collaboration.proxy") + proxyName + ")";
                }
            }
            length -= colProxyLabel.getBytes().length;
        }
        return mergeSubjectWithForwardMembers(subject, length, forwardMember, resendTiem, null) + colProxyLabel;
    }
    /**
     * 用于协同已办的显示
     * @param summary
     * @param isProxy
     * @param length
     * @param proxyName
     * @param isAgentDeal
     * @return
     */
    public static String showSubjectOfSummary4Done(CtpAffair affair, int length){
        if(affair == null){
            return null;
        }
        V3xOrgMember member = null;
        String subject = "";
        String colProxyLabel = "";
        boolean isAgent = true;
        User user = AppContext.getCurrentUser();
        long userId = user.getId();
        if(affair.getTransactorId() != null){//当前登录人就是代理人的时候不需要显示代理信息
            Long memberId = affair.getTransactorId();
            if(memberId.longValue()==userId){
                memberId = affair.getMemberId();
            }else{
                isAgent = false;
            }
            try {
                member = getOrgManager().getMemberById(memberId);
                if(!member.getIsAdmin()){
                  if(member != null){
                    if(isAgent){
                      //代理(XX)
                      colProxyLabel = "(" + ResourceUtil.getString("collaboration.proxy") + member.getName() + ")";
                    }else {
                      //(XX)代理
                      colProxyLabel = "(" + member.getName() + ResourceUtil.getString("collaboration.proxy") + ")";
                    }
                    length -= colProxyLabel.getBytes().length;
                    //subject = mergeSubjectWithForwardMembers(affair.getSubject(), length, affair.getForwardMember(), affair.getResentTime(), null) + colProxyLabel;
                  }
                }
                  subject = mergeSubjectWithForwardMembers(affair.getSubject(), length, affair.getForwardMember(), affair.getResentTime(), null) + colProxyLabel;
                
            } catch (Exception e) {
                log.info(e.getLocalizedMessage());
            }
          }else if(affair.getMemberId() != userId){//代理人已办查看被代理人处理的
        	try{
    			member = getOrgManager().getMemberById(affair.getMemberId());
    			//(XX)处理
                colProxyLabel = "(" + ResourceUtil.getString("collaboration.proxy.deal", member.getName()) + ")";
    			length -= colProxyLabel.getBytes().length;
    			subject = mergeSubjectWithForwardMembers(affair.getSubject(), length, affair.getForwardMember(), affair.getResentTime(), null) + colProxyLabel;
    		}catch(Exception e){
    		  log.info(e.getLocalizedMessage());
    		}
        }else{
            subject = mergeSubjectWithForwardMembers(affair.getSubject(), length, affair.getForwardMember(), affair.getResentTime(), null);
        }
        return subject;
    }
    /**
     * 分解转发人、转发次数，用于任务项分配往Affair表写
     *
     * @param subject
     * @param subjectLength
     * @param forwardMember
     * @param resentTime
     * @param orgManager
     * @param locale
     * @return
     */
    public static  String mergeSubjectWithForwardMembers(String subject, int subjectLength, String forwardMember,
            Integer resentTime, Locale locale) {
        StringBuffer sb = new StringBuffer();
        if(resentTime != null && resentTime > 0){
            sb.append(ResourceUtil.getString("collaboration.new.repeat.label", resentTime));
        }
        if(subject != null){
        	if(subjectLength==-1 || subjectLength==0){
        		sb.append(subject);
        	}else{
        		sb.append(Strings.getSafeLimitLengthString(subject, subjectLength, "..."));
        	}
        }
        if(StringUtils.isNotBlank(forwardMember)) {
            String[] forwardMembers = forwardMember.split(",");
            for (String m : forwardMembers) {
                try {
                	try {
                		long memberId = Long.parseLong(m);
                		V3xOrgMember member =  getOrgManager().getEntityById(V3xOrgMember.class, memberId);
                		sb.append(ResourceUtil.getString("collaboration.forward.subject.suffix", member.getName()));
                	} catch(NumberFormatException nfe) {
                		sb.append(ResourceUtil.getString("collaboration.forward.subject.suffix", m));
                	}
                }
                catch (Exception e) {
                  log.info(e.getLocalizedMessage());
                }
            }
        }
        return sb.toString();
    }
    /**
     * 分解转发人、转发次数，用于任务项分配往Affair表写
     *
     * @param subject
     * @param forwardMember
     * @param orgManager
     * @param locale 语言，如果是null，则采用当前登录者的语言
     * @return 转发人姓名
     */
    public static String mergeSubjectWithForwardMembers(ColSummary summary, OrgManager orgManager, Locale locale) {
        return mergeSubjectWithForwardMembers(summary.getSubject(), -1,
                summary.getForwardMember(), summary.getResentTime(), locale);
    }
    /**
     *  通栏：标题最长显示38个字（不包括图标）,超过就出现省略号
	 *	1/2栏：标题最长显示26个字（不包括图标),超过就出现省略号
	 *  1/3栏：标题最长显示18个字（不包括图标）,超过就出现省略号
     * @param subject
     * @param forwardMember
     * @param resentTime
     * @param locale
     * @param width -1 代表非首页调用
     * @return
     */
    public static String mergeSubjectWithForwardMembers(String subject, String forwardMember,
            Integer resentTime, Locale locale,int width){
    	int length=-1;
    	if(width==10){//通栏
    		length=78;
    	}else if(width==5){//两栏
    		length=26*2+4;
    	}else if(0<width&&width<5){//多栏
    		length=18*2+4;
    	}
        return mergeSubjectWithForwardMembers(subject, length, forwardMember, resentTime, locale);
    }
    /**
     * 时间拼装
     * @param day
     * @param hour
     * @param minute
     * @param second
     * @param filterFlag 秒 过滤
     * @return
     */
    public static String timePatchwork(long day, long hour, long minute, long second, boolean filterFlag){
        String timeStr = "";
        if(second != 0){
            timeStr = second + ResourceUtil.getString("common.time.second");
        }
        if(minute != 0){
            timeStr = minute + ResourceUtil.getString("common.time.minute");
            if(!filterFlag)
                timeStr += second + ResourceUtil.getString("common.time.second");
        }
        if (hour != 0){
            timeStr = hour + ResourceUtil.getString("common.time.hour")
            + minute + ResourceUtil.getString("common.time.minute");
            if(!filterFlag)
                timeStr += second + ResourceUtil.getString("common.time.second");
        }
        if (day != 0){
            timeStr = day + ResourceUtil.getString("common.time.day") + hour + ResourceUtil.getString("common.time.hour")
            + minute + ResourceUtil.getString("common.time.minute");
            if(!filterFlag)
                timeStr += second + ResourceUtil.getString("common.time.second");
        }
        return timeStr;
    }

    
    /**
	 * 根据affair得到错误提示消息，回退，撤销，取回等
	 * @param affair
	 * @return
	 */
	public static String getErrorMsgByAffair(CtpAffair affair) {
		String state = "";
		String msg = "";
		if(affair != null){
			String forwardMemberId = affair.getForwardMember();
			int forwardMemberFlag = 0;
			String forwardMember = null;
			if(Strings.isNotBlank(forwardMemberId)){
				try {
					forwardMember = getOrgManager().getMemberById(Long.parseLong(forwardMemberId)).getName();
					forwardMemberFlag = 1;
				}
				catch (Exception e) {
				  log.info(e.getLocalizedMessage());
				}
			}

	    	if(affair.isDelete()){
	    		state = ResourceUtil.getString("collaboration.state.9.delete");
	    	}
	    	else{
	        	switch(StateEnum.valueOf(affair.getState())){
	        		case col_done : state = ResourceUtil.getString("collaboration.state.4.done");
	        		break;
		        	case col_cancel : state = ResourceUtil.getString("collaboration.state.5.cancel");
		        	break;
		        	case col_stepBack : state = ResourceUtil.getString("collaboration.state.6.stepback");
		        	break;
		        	case col_takeBack : state = ResourceUtil.getString("collaboration.state.7.takeback");
		        	break;
		        	case col_competeOver : state = ResourceUtil.getString("collaboration.state.8.strife");
		        	break;
		        	case col_stepStop : state = ResourceUtil.getString("collaboration.state.10.stepstop");
		        	break;
		        	case col_waitSend :
		        		switch(SubStateEnum.valueOf(affair.getSubState())){
		        			case col_waitSend_stepBack:state = ResourceUtil.getString("collaboration.state.6.stepback");
		        			    break;
		        			case col_waitSend_cancel:state = ResourceUtil.getString("collaboration.state.5.cancel");
		        			    break;
		        			case col_pending_specialBackToSenderCancel:state = ResourceUtil.getString("collaboration.state.6.stepback");
		        			    break;
		        		}
		        	break;
	        	}
	    	}
	    	String appName=ResourceUtil.getString("application."+affair.getApp()+".label");
	    	msg = ResourceUtil.getString("collaboration.state.invalidation.alert", Strings.toHTML(affair.getSubject(),false), state,appName, forwardMemberFlag, forwardMember);
		}else{
			state = ResourceUtil.getString("collaboration.state.9.delete");
			msg = ResourceUtil.getString("collaboration.state.inexistence.alert", state);
		}
    	return msg;
	}
	 
	public static Long getMinutesBetweenDatesByWorkTime(Date startDate,Date endDate ,Long orgAccountId ){
        if(startDate == null
            ||endDate == null
            ||orgAccountId == null){
            return 0L;
        }
        Long workTime = 0L;
        try {
            workTime = getWorkTimeManager().getDealWithTimeValue(startDate,endDate,orgAccountId);
            workTime = workTime/(60*1000);
        } catch (WorkTimeSetExecption e1) {
          log.error("获取工作时间分钟数异常",e1);
        }
        return workTime;
    }
	
	public static double getMinutesBetweenDatesByWorkTimehasDecimal(Date startDate,Date endDate ,Long orgAccountId ){
        if(startDate == null
            ||endDate == null
            ||orgAccountId == null){
            return 0L;
        }
        double workTime = 0L;
        try {
            workTime = getWorkTimeManager().getDealWithTimeValue(startDate,endDate,orgAccountId);
            workTime = workTime/60.0/1000.0;
        } catch (WorkTimeSetExecption e1) {
          log.error("获取工作时间分钟数异常",e1);
        }
        return workTime;
    }
	
    public static Long convert2WorkTime(Long time, Long accountId){
        return getWorkTimeManager().convert2WorkTime(time,accountId);
    }
    
    public static AffairData getAffairData(ColSummary summary) throws BusinessException {
        AffairData affairData = new AffairData();
        affairData.setForwardMember(summary.getForwardMember());
        affairData.setModuleType(ApplicationCategoryEnum.collaboration.key());
        if (summary.getId() != null) {
            affairData.setModuleId(summary.getId());
        }
        //容错处理
        int importantLevel = 1;
        if(summary.getImportantLevel() != null){
            importantLevel = summary.getImportantLevel();
        }else{
            summary.setImportantLevel(1);
        }

        affairData.setImportantLevel(importantLevel);
        affairData.setIsSendMessage(true); //是否发消息
        affairData.setResentTime(summary.getResentTime());//如协同colsummary
        affairData.setState(StateEnum.col_pending.key());//事项状态 - 协同业务中3为待办
        affairData.setSubject(summary.getSubject());//如协同colsummary
        affairData.setSubState(SubStateEnum.col_pending_unRead.key());//事项子状态 协同业务中11为协同-待办-未读
        affairData.setSummaryAccountId(summary.getOrgAccountId());//如协同colsummary.orgAccountId
        affairData.setTemplateId(summary.getTempleteId());//如协同colsummary
        affairData.setIsHasAttachment(ColUtil.isHasAttachments(summary));//是否有附件
        affairData.setContentType(summary.getBodyType());
        affairData.setSender(summary.getStartMemberId());
        affairData.setFormRecordId(summary.getFormRecordid());
        affairData.setFormAppId(summary.getFormAppid());
        affairData.setFormId(summary.getFormid());
        affairData.setCreateDate(summary.getCreateDate());
        affairData.setProcessDeadlineDatetime(summary.getDeadlineDatetime());
        affairData.setCaseId(summary.getCaseId());
        affairData.setOrgAccountId(summary.getOrgAccountId());
        return affairData;
    }


    /**
     * 获取流程模板对应的单位
     *
     * @param defaultAccountId
     * @param summary
     * @param templateManager
     * @return
     * @throws BusinessException
     */
    public static Long getFlowPermAccountId(Long defaultAccountId, ColSummary summary) throws BusinessException{
    	Long flowPermAccountId = defaultAccountId;
        Long templeteId = summary.getTempleteId();
        if (templeteId != null) {
        	if(summary.getPermissionAccountId()!= null){
        		flowPermAccountId = summary.getPermissionAccountId();
        	}
        } else {
            if (summary.getOrgAccountId() != null) {
                flowPermAccountId = summary.getOrgAccountId();
            }
        }
        return flowPermAccountId;
    }
    
    public static Long getFlowPermAccountId(Long defaultAccountId, Long summaryOrgAccountId, Long templateOrgAccountId) throws BusinessException{
        Long flowPermAccountId = defaultAccountId;
        if(templateOrgAccountId != null){
                flowPermAccountId = templateOrgAccountId;
        }
        else{
            if(summaryOrgAccountId != null){
                flowPermAccountId = summaryOrgAccountId;
            }
        }
        return flowPermAccountId;
    }

    /**
     * 检测是否是空字符串, 不允许空格 <br>
     * ColUtil.isBlank(null)        = true <br>
     * ColUtil.isBlank("")          = true <br>
     * ColUtil.isBlank(" ")         = true <br>
     * ColUtil.isBlank("null")      = true <br>
     * ColUtil.isBlank("undefined") = true <br>
     * ColUtil.isBlank("bob")       = false <br>
     * ColUtil.isBlank("  bob  ")   = false <br>
     * @param val
     * @return
     */
    public static boolean isBlank(String val){
        if("null".equals(val)){
            return true;
        }
        if("undefined".equals(val)){
            return true;
        }
        return Strings.isBlank(val);
    }
    /**
     * 检测是否是空字符串, 不允许空格 <br>
     * ColUtil.isNotBlank(null)        = false <br>
     * ColUtil.isNotBlank("")          = false <br>
     * ColUtil.isNotBlank(" ")         = false <br>
     * ColUtil.isNotBlank("null")      = false <br>
     * ColUtil.isNotBlank("undefined") = false <br>
     * ColUtil.isNotBlank("bob")       = true <br>
     * ColUtil.isNotBlank("  bob  ")   = true <br>
     * @param val
     * @return
     */
    public static boolean isNotBlank(String val){
        return !ColUtil.isBlank(val);
    }
    /**
     * 产生最终标题
     *
     * @param template
     * @param summary
     * @param sender
     * @return
     * @throws BusinessException
     */
    public static String makeSubject4NewWF(CtpTemplate template, ColSummary summary, User sender) throws BusinessException{
        //String  subject  = ResourceUtil.getString("collaboration.newflow.fire.subject", template.getSubject() + "(" + sender.getName() + " " + Datetimes.formatDatetimeWithoutSecond(summary.getCreateDate()) + ")");
        String  subject  =  template.getSubject() + "(" + sender.getName() + " " + Datetimes.formatDatetimeWithoutSecond(summary.getCreateDate()) + ")";
        if(template == null || Strings.isBlank(template.getColSubject())){
            return subject;
        }

        if(Strings.isNotBlank(template.getColSubject())){
            WorkflowApiManager wapi = getWorkflowApiManager();
            FormManager formManager = getFormManager();
            String[] policy = wapi.getStartNodeFormPolicy(template.getWorkflowId());
            if(policy != null && policy[2] != null){
                
                String subjectForm = formManager.getCollSubjuet(summary.getFormAppid(), template.getColSubject(), summary.getFormRecordid(), null, Long.parseLong(policy[2]), true);
                
                log.info(AppContext.currentUserLoginName()+"，表单接口,协同标题生成：Param:appid:"+summary.getFormAppid()+",template.getColSubject()："+template.getColSubject()+",recordId:"+summary.getFormRecordid()+",policy:"+Long.parseLong(policy[2]));
                
                //转移换行符，标题中不能用换行符
                subjectForm = Strings.toText(subjectForm);
                
                if (Strings.isBlank(subjectForm)) {
                    subjectForm = "{" + ResourceUtil.getString("collaboration.subject.default") + "}";
                }
                
                subject = subjectForm;
                if (subject.length() > 300) {
                    subject = Strings.toText(subject).substring(0, 295) + "...";
                }
                log.info("最终标题："+subject);
            }
        }
        return subject;
    }
    
    public static String makeSubject(CtpTemplate template, ColSummary summary, User sender) throws BusinessException{
        if(template == null || Strings.isBlank(template.getColSubject())){
            return summary.getSubject();
        }
        String subject = summary.getSubject();
        if(Strings.isNotBlank(template.getColSubject())){
            WorkflowApiManager wapi = getWorkflowApiManager();
            FormManager formManager = getFormManager();
            String[] policy = wapi.getStartNodeFormPolicy(template.getWorkflowId());
            
            if(policy != null && policy[2] != null){
                
                log.info(AppContext.currentUserLoginName()+"，表单接口,协同标题生成：Param:appid:"+summary.getFormAppid()+",template.getColSubject()："+template.getColSubject()+",recordId:"+summary.getFormRecordid()+",policy:"+Long.parseLong(policy[2]));
                subject = formManager.getCollSubjuet(summary.getFormAppid(), template.getColSubject(), summary.getFormRecordid(), null, Long.parseLong(policy[2]), false);
                log.info("协同标题生成成功, 协同ID=："+summary.getId());
                //转移换行符，标题中不能用换行符
                subject = Strings.toText(subject);
                if (subject.length() > 300) {
                    subject = Strings.toText(subject).substring(0, 295) + "...";
                }
            }
        }
        return subject;
    }
    
    /**
     * 根据模板标题和流程ID查询模板标题
     * @param templateColSubject 模板标题
     * @param templateWorkflowId 模板流程ID
     * @param summary
     * @param sender
     * @return
     * @throws BusinessException
     */
    @SuppressWarnings("finally")
	public static String makeSubject(String templateColSubject,Long templateWorkflowId, ColSummary summary, User sender) throws BusinessException{
    	if(Strings.isBlank(templateColSubject)){
            return summary.getSubject();
        }
        String subject = summary.getSubject();
        if(Strings.isNotBlank(templateColSubject)){
        	try {
        		WorkflowApiManager wapi = getWorkflowApiManager();
                FormManager formManager = getFormManager();
                String[] policy = wapi.getStartNodeFormPolicy(templateWorkflowId);
                
                if(policy != null && policy[2] != null){
                    
                    subject = formManager.getCollSubjuet(summary.getFormAppid(), templateColSubject, summary.getFormRecordid(), null, Long.parseLong(policy[2]), false);
                    
                    log.info(AppContext.currentUserLoginName()+"，表单接口,协同标题生成：Param:appid:"+summary.getFormAppid()+",template.getColSubject()："+ templateColSubject + ",recordId:"+summary.getFormRecordid()+",policy:"+Long.parseLong(policy[2]));
                    //转移换行符，标题中不能用换行符
                    subject = Strings.toText(subject);
                    if (subject.length() > 300) {
                        subject = Strings.toText(subject).substring(0, 295) + "...";
                    }
                    log.info("最终标题："+subject);
                }
			} catch (Exception e) {
				log.error("",e);
				subject = summary.getSubject();
			} finally {
				return subject;
			}
            
        }
        return subject;
    }
    
    /**
     * 获得节点权限名称
     * @param affair
     * @return
     * @throws BusinessException
     */
    public static SeeyonPolicy getPolicyByAffair(CtpAffair affair) throws BusinessException {
    	try{
    		SeeyonPolicy seeyonPolicy = getPolicy(affair);
    		if(seeyonPolicy == null){
    			return new SeeyonPolicy("collaboration",ResourceUtil.getString("node.policy.collaboration"));
    		}else if(Strings.isBlank(seeyonPolicy.getId())){
    			return new SeeyonPolicy("collaboration",ResourceUtil.getString("node.policy.collaboration"));
    		}
    		return seeyonPolicy;
    	}catch(Exception e){
    	  log.error("",e);
    		return new SeeyonPolicy("collaboration",ResourceUtil.getString("node.policy.collaboration"));
    	}
    }
	private static SeeyonPolicy getPolicy(CtpAffair affair) throws BusinessException, BPMException {
		if (affair == null
        		|| affair.getState().equals(StateEnum.col_waitSend.getKey())
        		|| affair.getState().equals(StateEnum.col_sent.getKey())){
            return new SeeyonPolicy("newCol",ResourceUtil.getString("node.policy.newCol"));
        }
        if(Strings.isNotBlank(affair.getNodePolicy())){
            return new SeeyonPolicy(affair.getNodePolicy(), BPMSeeyonPolicy.getShowName(affair.getNodePolicy()));
        }
        WorkflowApiManager wapi = getWorkflowApiManager();
        CollaborationApi collaborationApi = getCollaborationApi();
        ColSummary summary = collaborationApi.getColSummary(affair.getObjectId());
        if(summary != null){
            String[] result = wapi.getNodePolicyIdAndName(ModuleType.collaboration.name(),summary.getProcessId(),String.valueOf(affair.getActivityId()));
            if(result==null)
                return new SeeyonPolicy("collaboration",ResourceUtil.getString("node.policy.collaboration"));
            return new SeeyonPolicy(result[0],result[1]);
        }else{
            return new SeeyonPolicy("collaboration",ResourceUtil.getString("node.policy.collaboration"));
        }
	}
    /**
     * 对日期进行转换，如果传入的日期与当前系统日期相同则显示成'今日'，时间不变，如果日期与系统日期不相同，则只显示日期<br>
     * 例如当前系统时间为'2013-01-31 12:12:12',传入的日期为'2013-01-31 13:13:13'，则显示成'今日 13:13:13' <br>
     * 例如当前系统时间为'2013-01-31 12:12:12',传入的日期为'2013-01-30 13:13:13'，则显示成'2013-01-30' <br>
     * @param srcDate
     * @param datetimeStyle
     * @return
     */
    public static String getDateTime(Date srcDate, String datetimeStyle){
        
        //找到客户端0点的相对服务器时间
        long todayFirstTime = Datetimes.getTodayFirstTime().getTime();
        
        long todayLastTime = todayFirstTime + 86400000;
        long tomorrowLastTime = todayLastTime + 86400000;
        if(srcDate == null){
        	return ResourceUtil.getString("collaboration.project.nothing.label");
        }
        long srcDateStamp = srcDate.getTime();
        //今天
        if(todayFirstTime <= srcDateStamp && srcDateStamp < todayLastTime){
            String dateTime = Datetimes.format(srcDate, datetimeStyle);
            return ResourceUtil.getString("menu.tools.calendar.today") + dateTime.substring(11);
        }
        //明天
        else if(todayLastTime < srcDateStamp && srcDateStamp < tomorrowLastTime){
            String dateTime = Datetimes.format(srcDate, datetimeStyle);
            return ResourceUtil.getString("menu.tools.calendar.tomorrow") + dateTime.substring(11);
        }
        else{
            return Datetimes.format(srcDate, "yyyy-MM-dd");
        }
    }

    public static void deleteQuartzJobOfSummary(ColSummary summary){
        deleteQuartzJob(summary.getId());
    }

    public static void deleteQuartzJob(Long summaryId){
        if(QuartzHolder.hasQuartzJob("ColProcessDeadLine" + summaryId)){
            QuartzHolder.deleteQuartzJob("ColProcessDeadLine" + summaryId);
            QuartzHolder.deleteQuartzJob("ColProcessRemind" + summaryId);
        }
        QuartzHolder.deleteQuartzJob("ColSupervise" + summaryId);
    }
    /**
     * 发送消息 控制
     * @param affair
     * @return
     */
    public static Integer getImportantLevel(CtpAffair affair){
        if(affair == null || affair.getImportantLevel() == null){
            return 1;
        }
        //模板协同
        if(affair.getTempleteId() != null) {
            switch (affair.getImportantLevel()) {
                case 1:
                    return 4;
                case 2:
                    return 5;
                case 3:
                    return 6;
                default:
                    break;
            }
        }else{
            //自由协同
            return affair.getImportantLevel();
        }
        return 1;
    }
    /**
     * 发送消息 控制
     * @param affair
     * @return
     */
    public static Integer getImportantLevel(ColSummary summary){
        if(summary == null || summary.getImportantLevel() == null ){
            return 1;
        }
        //模板协同
        if(summary.getTempleteId() != null) {
            switch (summary.getImportantLevel()) {
                case 1:
                    return 4;
                case 2:
                    return 5;
                case 3:
                    return 6;
                default:
                    break;
            }
        }else{
            //自由协同
            return summary.getImportantLevel();
        }
        return 1;
    }
    /**
     * 将集团管理员账号和单位管理员账号 转换成'集团管理员'或者'单位管理员'
     * @return
     */
    public static String getAccountName(){
        User user = AppContext.getCurrentUser();
        return OrgHelper.showMemberNameOnly(Long.valueOf(user.getId()));
    }
    /**
     * 校验协同是否超期
     * @param startDate
     * @param endDate
     * @param deadline
     * @param summary
     * @return
     */
    public static boolean checkColSummaryIsOverTime(ColSummary summary){
       return summary.isCoverTime() == null ? false : summary.isCoverTime();
    }

    /**
     * 校验事项是否超期
     * @param affair
     * @return
     */
    public static boolean checkAffairIsOverTime(CtpAffair affair,ColSummary summary){
        long accountId;
        Date edate = new Date();
        //如果未设置流程期限，则不存在超期
        /*if(affair == null || affair.getDeadlineDate() == null || "0".equals(affair.getDeadlineDate().toString())){
            return false;
        }*/
        if(affair == null || affair.getExpectedProcessTime() == null){
            return false;
        }
        
        edate = affair.getExpectedProcessTime();
        
        /*try {
            accountId = ColUtil.getFlowPermAccountId(AppContext.currentAccountId(), summary);
            edate = getWorkTimeManager().getCompleteDate4Nature(affair.getReceiveTime(), affair.getDeadlineDate(),accountId);
        }catch (BusinessException e) {
          log.error("计算工作时间是否超期",e);
        }*/
        boolean isOverTime = false;
        Date finishDate = affair.getCompleteTime();
        if(finishDate == null){
            if(edate.after(new Date())){
                isOverTime = false;
            }else{
                isOverTime = true;
            }
        }else{
            if(edate.after(finishDate)){
                isOverTime = false;
            }else{
                isOverTime = true;
            }
        }
        return isOverTime;
    }
    /**
     * 验证affair是否是有效数据
     * @param affair 当前事项
     * @param isFilterDelete 是否过滤删除
     * @return
     */
    public static boolean isAfffairValid(CtpAffair affair,boolean isFilterDelete){
    	if(affair == null){
    		return false;
    	}
        StateEnum state = StateEnum.valueOf(affair.getState());

        boolean isSpecail = false;
        boolean isUserSelf= false;
        if(null!=AppContext.getCurrentUser()){
            isUserSelf= AppContext.getCurrentUser().getId().equals(affair.getSenderId());
        }
        if(affair.getSubState() != null){
            SubStateEnum subState =  SubStateEnum.valueOf(affair.getSubState());
            isSpecail = SubStateEnum.col_pending_specialBacked.equals(subState) || SubStateEnum.col_pending_specialBackToSenderCancel.equals(subState);
        }

        if(affair == null
                || StateEnum.col_cancel.equals(state)
                || StateEnum.col_stepBack.equals(state)
                || StateEnum.col_takeBack.equals(state)
                || StateEnum.col_stepStop.equals(state)
                || StateEnum.col_competeOver.equals(state)
                || (StateEnum.col_waitSend.equals(state) && !isSpecail && !isUserSelf)
                || (isFilterDelete && affair.isDelete())){
        		return false;
        }else {
            return true;
        }
    }
    public static boolean isAfffairValid(CtpAffair affair){
        return isAfffairValid(affair,false);
    }

    public static void affairExcuteRemind(CtpAffair affair, Long summaryAccountId) {
        //不需要计算setExpectedProcessTime
        Date deadLineRunTime = affair.getExpectedProcessTime();
        Long remindTime = affair.getRemindDate();
        Date advanceRemindTime = null;
        if (remindTime != null && remindTime != -1 &&  remindTime != 0) {
            advanceRemindTime = workTimeManager.getRemindDate(deadLineRunTime, remindTime);
        }
        affairExcuteRemind(affair,summaryAccountId,deadLineRunTime,advanceRemindTime);
    }

    public static void affairRepeatAutoDeal(List<Long> ids,Long commentId,String policyName,boolean canAnyMerge,String count){
    	if(Strings.isEmpty(ids)){
    		return ;
    	}
    	String _ids = Strings.join(ids, ",");
    	String name = "AffAIRAUTOtSKIP" + ids.get(0)+"_"+Math.random();
        Map<String, String> datamap = new HashMap<String, String>(2);
        datamap.put("_isAffairAutotSkip", "1");
        datamap.put("_affairIds",_ids );
        datamap.put("_commentId",String.valueOf(commentId ));
        datamap.put("_policyName",policyName);
        datamap.put("isAnyMerge",String.valueOf(canAnyMerge));
        datamap.put("count",count);
        
        //当前时间之后的30秒
        int randomInOneMinte = (int)(Math.random()*20+1)*1000;
        Date _excuteTime =  new java.util.Date(System.currentTimeMillis()+randomInOneMinte);
        
        try {
			if(QuartzHolder.newQuartzJob(name, _excuteTime , "affairIsOvertopTimeJob", datamap)){
				log.info("______增加定时任务__AffAIRAUTOtSKIP，ids:"+_ids+",定时任务name:"+name+",预计执行时间:"+_excuteTime);
			}else{
				log.info("______增加定时任务__AffAIRAUTOtSKIP，ids:"+_ids+",定时任务name:"+name+",失败了、失败了、失败了!");
			}
			
        } catch (Throwable e) {
			 log.error("",e);
		}
    
    }

    public static void affairExcuteRemind4Node(CtpAffair affair, Long summaryAccountId,Date deadLineRunTime,Date advanceRemindTime) {
        if (affair.getApp() == ApplicationCategoryEnum.collaboration.key()
                || affair.getApp() == ApplicationCategoryEnum.edoc.key()
                || affair.getApp() == ApplicationCategoryEnum.edocRec.key()
                || affair.getApp() == ApplicationCategoryEnum.edocSend.key()
                || affair.getApp() == ApplicationCategoryEnum.edocSign.key()
                || affair.getApp() == ApplicationCategoryEnum.info.key()) {
            //超期提醒
            try {
                if (deadLineRunTime != null) {
                      Long affairId = affair.getId();
                      {
                          //先删除老的定时任务
                          String jobName = new StringBuilder("DeadLine").append(affair.getObjectId())
                                                                        .append("_")
                                                                        .append(affair.getActivityId())
                                                                        .toString();
                          QuartzHolder.deleteQuartzJob(jobName);
                          
                          String name = jobName;
                          Map<String, String> datamap = new HashMap<String, String>(2);
                          datamap.put("isAdvanceRemind", ISADVANCEREMIND);
                          datamap.put("activityId", String.valueOf(affair.getActivityId()));
                          datamap.put("objectId", String.valueOf(affair.getObjectId()));
                          datamap.put("affairId", String.valueOf(affairId));
                          //Long templateId= affair.getTempleteId();
                          //log.info("templateId:="+templateId);
                          //增加30秒随机数
                      	  int randomInOneMinte = (int)(Math.random()*30+1)*1000;
                      	  Date _runDate = new java.util.Date(deadLineRunTime.getTime()+randomInOneMinte);
                      	  //if(null!=templateId && templateId.longValue()==2447814604579751585l){
                      		 //log.info("指定模板调试用：3分钟触发超期自动跳过任务:"+templateId);
                      		//_runDate = new java.util.Date(System.currentTimeMillis()+180000+randomInOneMinte);//3分钟
                      	  //}
                          QuartzHolder.newQuartzJob(name,_runDate , "affairIsOvertopTimeJob", datamap);
                          log.info("______创建定时任务：activityId:"+affair.getActivityId()+",objectId："+affair.getObjectId()+",事项名："+affair.getId()+",定时任务name:"+name+",预计执行时间:"+deadLineRunTime);
                      }
                      
                      Long remindTime = affair.getRemindDate();
                      if (remindTime != null && !Long.valueOf(0).equals(remindTime) && !Long.valueOf(-1).equals(remindTime)
                    		  && advanceRemindTime != null  &&  advanceRemindTime.before(deadLineRunTime)) {
                          
                        //先删除老的定时任务
                          String jobName = new StringBuilder("Remind").append(affair.getObjectId())
                                  .append("_")
                                  .append(affair.getActivityId())
                                  .toString();
                          QuartzHolder.deleteQuartzJob(jobName);
                          
                          String name = "Remind" + affair.getObjectId() + "_" + affair.getActivityId();
                          Map<String, String> datamap = new HashMap<String, String>(2);
                          datamap.put("isAdvanceRemind", NOTADVANCEREMIND);
                          datamap.put("activityId", String.valueOf(affair.getActivityId()));
                          datamap.put("objectId", String.valueOf(affair.getObjectId()));
                          datamap.put("affairId", String.valueOf(affairId));
                          QuartzHolder.newQuartzJob(name, advanceRemindTime, "affairIsOvertopTimeJob", datamap);
                      }
                }
            } catch (Exception e) {
              log.error("获取定时调度器对象失败", e);
            }
        }
    }

    private static boolean checkApp(CtpAffair affair){
      return affair.getApp() == ApplicationCategoryEnum.collaboration.key()
      || affair.getApp() == ApplicationCategoryEnum.edoc.key()
      || affair.getApp() == ApplicationCategoryEnum.edocRec.key()
      || affair.getApp() == ApplicationCategoryEnum.edocSend.key()
      || affair.getApp() == ApplicationCategoryEnum.edocSign.key()
      || affair.getApp() == ApplicationCategoryEnum.info.key();
    }

    public static void affairExcuteRemind(CtpAffair affair, Long summaryAccountId,Date deadLineRunTime,Date advanceRemindTime) {
        if (checkApp(affair)) {
            //超期提醒
            try {
                if (deadLineRunTime != null) {
                      Long affairId = affair.getId();
                      {
                          String name = "DeadLine" + affairId;
                          Map<String, String> datamap = new HashMap<String, String>(2);
                          datamap.put("isAdvanceRemind", "1");
                          datamap.put("affairId", String.valueOf(affairId));
                          QuartzHolder.newQuartzJob(name,deadLineRunTime , "affairIsOvertopTimeJob", datamap);
                      }
                      Long remindTime = affair.getRemindDate();
                      if (remindTime != null && advanceRemindTime != null && remindTime !=-1 && remindTime != 0 && advanceRemindTime.before(deadLineRunTime)) {
                              String name = "Remind" + affairId;
                              Map<String, String> datamap = new HashMap<String, String>(2);
                              datamap.put("isAdvanceRemind", "0");
                              datamap.put("affairId", String.valueOf(affairId));
                              QuartzHolder.newQuartzJob(name, advanceRemindTime, "affairIsOvertopTimeJob", datamap);
                      }
                }
            } catch (Exception e) {
              log.error("获取定时调度器对象失败", e);
            }
        }
    }
    /**
     * 校验是否有资源菜单
     * @param resourceCode
     * @return
     * @throws BusinessException
     */
    public static boolean checkByReourceCode(String resourceCode){
        User user = AppContext.getCurrentUser();
        if(user != null){
            return user.hasResourceCode(resourceCode);
        }

        PrivilegeManager pc = getPrivilegeManager();
    	boolean isHave = false;
		try {
			isHave = pc.checkByReourceCode(resourceCode);
		} catch (BusinessException e) {
		  log.error("",e);
		}
    	return isHave;
    }
    //当前处理人信息
	public static String parseCurrentNodesInfo(ColSummary summary) {
		if(null==summary.getFinishDate()){//流程未结束
			String cninfo=summary.getCurrentNodesInfo();
			StringBuilder currentNodsInfo=new StringBuilder();
			String currentNodesId="";
			int allCount=0;
			int count=0;
			if(Strings.isNotBlank(cninfo) && !"null".equalsIgnoreCase(cninfo)){
				String[] nodeArr=cninfo.split(";");
				allCount=nodeArr.length;
				int index = 0;
				for (String node : nodeArr) {
					//if (Strings.isNotBlank(node) && count < 2) {// 显示两个处理人信息
					if (Strings.isNotBlank(node)) {//客开 gxy 20180716 显示所有处理人信息
									// id&nama;id&name
						String userIdStr = nodeArr[index];
						if (currentNodesId.indexOf(userIdStr) != -1) {// 去重复
							count--;
						}
						else {
							String userIdStr2 = userIdStr;
							if (userIdStr.indexOf("&") != -1) {
								userIdStr2 = userIdStr.split("&")[0];
							}
							Long uid = Long.valueOf(userIdStr2);// 节点处理人id

							if (currentNodsInfo.length() == 0) {
								currentNodsInfo.append(ColUtil.getMemberName(uid));
							}
							else {
								currentNodsInfo.append("、" + ColUtil.getMemberName(uid));
							}
							currentNodesId += ";" + userIdStr2;

						}

					}
					index ++;
					count ++;
				}
			}else{
				return "";
			}

			if("null".equalsIgnoreCase(currentNodsInfo.toString())){
			    return "";
			}
			String currentStr=currentNodsInfo.toString();
			//多于2个人拼接...
			//客开 gxy 20180716 显示所有处理人信息 start
			/*if(allCount>=3 && count != 1){
				currentStr=currentStr+"...";
			}*/
			//客开 gxy 20180716 显示所有处理人信息 end
			return currentStr;
		}else{//流程结束
			return ResourceUtil.getString("collaboration.list.finished.label");
		}
	}
	//原来有当前处理人信息，追加
	public static void setCurrentNodesInfo(ColSummary colSummary, String cnStr) {
		String cninfo=colSummary.getCurrentNodesInfo();
		if(Strings.isNotBlank(cninfo)){//原来有当前处理人信息，追加
			colSummary.setCurrentNodesInfo(cninfo+";"+cnStr);
		}else{
			colSummary.setCurrentNodesInfo(cnStr);
		}
	}

	public static boolean isChildrenWorkFlow(ColSummary summary){
		return Integer.valueOf(ColConstant.NewflowType.child.ordinal()).equals(summary.getNewflowType());
	}

	public static void setCurrentNodesInfoFromCache(ColSummary summary, Long needRemoveCurrentMemberId)
			throws BusinessException {

		List<CtpAffair> affairs = DateSharedWithWorkflowEngineThreadLocal.getWorkflowAssignedAllAffairs();
		int count = 0;
		List<String> _newCurrentInfos =  new ArrayList<String>();
		if (Strings.isNotEmpty(affairs)) {
			// 最多只存10个待办人
			for (int k = 0; k < affairs.size() && count < CURRENT_NODES_INFO_SIZE; k++) {
				CtpAffair cf = affairs.get(k);
				String policy = cf.getNodePolicy();
				// 知会节点不算待办
				if (Strings.isNotBlank(policy) && !"inform".equals(policy)) {
					long memberId = cf.getMemberId();
					_newCurrentInfos.add(String.valueOf(memberId));
					count++;
				}
			}
		}
		//如果已经新生成的》2了，就不用解析老的了，性能优化
		String oldInfos = summary.getCurrentNodesInfo();
		if(count < CURRENT_NODES_INFO_SIZE && oldInfos != null){
		    
		    int leftCount = CURRENT_NODES_INFO_SIZE - count;
			String[] _oldInfos = oldInfos.split("[;]");
			String oldMenberId = String.valueOf(needRemoveCurrentMemberId);
			for(int i = 0;i < _oldInfos.length && leftCount > 0; i++){
			    String s = _oldInfos[i];
			    if(!s.equals(oldMenberId)){
			        _newCurrentInfos.add(s);
			        leftCount--;
			    }
			}
		}
		
		if(_newCurrentInfos.size() != 0){
		    String __str  = Strings.join(_newCurrentInfos, ";");
	        //if(Strings.isBlank(__str)){
	            log.info("协同id="+summary.getId()+",时间：+"+new Date());
	        //}
	        summary.setCurrentNodesInfo(__str);
		}else{
		    updateCurrentNodesInfo(summary);
		}
		
		
		/*移除线程变量*/
		DateSharedWithWorkflowEngineThreadLocal.RemoveWorkflowAssignedAllAffairs();
	}

	/**
	 * 重新更新当前待办人信息
	 * @param summary
	 * @param isUpdateToDB 是否直接更新到数据库
	 * @throws BusinessException
	 */
	public static void updateCurrentNodesInfo(ColSummary summary) throws BusinessException {
		List<Integer> states = new ArrayList<Integer>();
		states.add( StateEnum.col_pending.key());
		states.add( StateEnum.col_pending_repeat_auto_deal.getKey());
		Map<String,Object> map = new LinkedHashMap<String,Object>();
		map.put("objectId", summary.getId());
		map.put("state",states);
		map.put("delete", false);
		map.put("nodePolicy","inform");
		
		FlipInfo fi = new FlipInfo();
		fi.setNeedTotal(false);
		fi.setSize(CURRENT_NODES_INFO_SIZE);
		
//		List<CtpAffair> affairs = getAffairManager().getAffairsByObjectIdAndStates(fi, summary.getId(), states);
		List<CtpAffair> affairs = getAffairManager().getAffairsForCurrentUsers(fi, map);
		int count = 0;
        String current = "";
        if(Strings.isNotEmpty(affairs)){
        	//最多只存10个待办人
        	for(int k = 0;k < affairs.size() && count<CURRENT_NODES_INFO_SIZE;k++){
            	CtpAffair cf = affairs.get(k);
            	String policy=cf.getNodePolicy();
            	//知会节点不算待办
				if(Strings.isNotBlank(policy)&&!"inform".equals(policy)){
					long memberId=cf.getMemberId();
					/*if(current.indexOf(memberId+"")!=-1){//一个人只需要显示一次
						continue;
					}*/
					if(k!=affairs.size()-1){
						current += cf.getMemberId()+";";
					}else{
						current += cf.getMemberId();
					}
					count++;
				}
            }
        }
       // if(Strings.isBlank(current)){
        	log.info("协同"+summary.getId()+",id="+summary.getId()+"!时间："+new Date());
        //}
        summary.setCurrentNodesInfo(current);
	}

	public static boolean checkAgent(CtpAffair affair,ColSummary summary,boolean isWebAlert) throws Exception {
		return checkAgent(affair.getMemberId(), affair.getSubject(), ModuleType.collaboration, isWebAlert, AppContext.getRawRequest());
	}
	
	public static String ajaxCheckAgent(Long affairMemberId,String subject,ModuleType moduleType){
		
		String result = "";
		User user = AppContext.getCurrentUser();
		
		if(user.getId().equals(affairMemberId)){
			result = "";
		}else if(user.isAdmin()){
			log.info("[代理校验]:类型："+moduleType.getKey()+",当前用户:"+user.getName()+"uerid:"+user.getId()+",管理员！");
			result = "";
		}else{
			List<Long> ownerIds = MemberAgentBean.getInstance().getAgentToMemberId(moduleType.getKey(),user.getId());
			
			V3xOrgMember m = null;
			
			try {
				m = getOrgManager().getMemberById(affairMemberId);
	       
				if(Strings.isNotEmpty(ownerIds) && ownerIds.contains(affairMemberId)) {
		            
					result = "";
		            
					log.info("[代理校验]:类型："+moduleType.getKey()+",当前用户:"+user.getName()+",代理:"+m.getName()+",处理业务数据："+subject);
		       
				}else {
		        	
		        	result = "你不是当前业务的所属人,也不是当前业务的代理人,无法处理该业务,请联系管理员,谢谢配合!";
		        	
		        	if(null != moduleType && null != user && null != m){
		        		log.info("[代理校验]:类型："+moduleType.getKey()+",你不是当前业务的所属人,也不是当前业务的代理人,无法处理该协同,请联系管理员,谢谢配合!param:当前用户:"+user.getName()+",代理:"+m.getName()+",业务数据:"+subject);
		        	}
		
		
		        }
			} catch (BusinessException e) {
				log.info("",e);
			}
		}
		
		return result;
	}
	
	public static boolean checkAgent(Long affairMemberId,String subject,ModuleType moduleType,boolean isWebAlert,HttpServletRequest request) throws Exception {

			String result = ajaxCheckAgent(affairMemberId, subject, moduleType);
			
			if(Strings.isNotBlank(result)){
				if(isWebAlert){
					webAlertAndClose(AppContext.getRawResponse(), result);
				}
				Enumeration<?> es= request.getHeaderNames();
				StringBuilder stringBuffer= new StringBuilder();
				if(es!=null){
					while(es.hasMoreElements()){
						Object name= es.nextElement();
						String header= request.getHeader(name.toString());
						stringBuffer.append(name+":="+header+",");
					}
					log.warn("request header---"+stringBuffer.toString());
				}
				return false;
			}else{
				return true;
			}

	}

	public static void webAlertAndClose(HttpServletResponse response,String msg) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<script>");
        out.println("alert('"+ StringEscapeUtils.escapeEcmaScript(msg)+"');");
        out.println("if(window.parentDialogObj && window.parentDialogObj['dialogDealColl']){");
        out.println(" window.parentDialogObj['dialogDealColl'].close();");
        out.println("}else if(window.dialogArguments){"); //弹出
        out.println("  if(window.dialogArguments.parentDialogObj){");
        out.println("    try{window.dialogArguments.parentDialogObj.close();}catch(e){}");
        out.println("  }else{");
        out.println("    window.close();");
        out.println("  }");
        out.println("}else{");
        out.println(" window.close();");
        out.println("}");
        out.println("</script>");
    }
	
	/**
     * 当有具体的处理期限的时间点则返回具体时间点，否则返回相对时间
     * @param affair
     * @param isShowToday
     * @return
     */
	public static String getDeadlineDisplayName(CtpAffair affair,boolean isShowToday){
		String deadlineDisplayName = "";
		if(affair.getExpectedProcessTime()!=null){
			if(isShowToday){
				deadlineDisplayName = getDateTime(affair.getExpectedProcessTime(),"yyyy-MM-dd HH:mm");
			}else{
				deadlineDisplayName = DateUtil.format(affair.getExpectedProcessTime(), "yyyy-MM-dd HH:mm");
			}
		}else{
			deadlineDisplayName = getDeadLineName(affair.getDeadlineDate());
		}
		return deadlineDisplayName ;
	}
	
	public static String getAdvancePigeonholeName(Long archiveId,String str){
        String dvancePigeonholeName = "";
        try {
            JSONObject jo = new JSONObject(str);
            String archiveFolder = jo.optString("archiveFieldName", "");
            if(Strings.isNotBlank(archiveFolder)){
                archiveFolder = "\\"+"{"+archiveFolder+"}";
            }
            //调用模板的时候显示的名字
              if(null == getDocApi().getDocResourceName(archiveId)){
                 return "wendangisdeleted";
            }
            dvancePigeonholeName = getArchiveAllNameById(archiveId) + archiveFolder;
        } catch (Exception e) {
            log.error("",e);
        }
        return dvancePigeonholeName;
    }
	
	/**
	 * 获取高级归档的归档路径
	 */
	public static String getAdvancePigeonholeName(Long archiveId,String str,String flag){
		String dvancePigeonholeName = "";
		try {
			JSONObject jo = new JSONObject(str);
			String archiveFolder = jo.optString("archiveFieldName", "");
			if(Strings.isNotBlank(archiveFolder)){
			    archiveFolder = "\\"+"{"+archiveFolder+"}";
			}
			//调用模板的时候显示的名字
			if("template".equals(flag)){
			    String docPath = ColUtil.getArchiveAllNameById(archiveId);
			  if(Strings.isBlank(docPath)){
			     return "wendangisdeleted";
			  }
				dvancePigeonholeName = docPath+archiveFolder;
			}else{
				String archiveFieldValue = jo.optString("archiveFieldValue", "");
			
				String docPath = getDocApi().getDocResourceName(archiveId);
				if(Strings.isBlank(docPath)){
				  dvancePigeonholeName = ResourceUtil.getString("collaboration.project.nothing.label");
				}else{
				  dvancePigeonholeName = docPath+"\\"+archiveFieldValue;
				}
			}
		} catch (Exception e) {
			log.error("",e);
		}
		return dvancePigeonholeName;
	}
	/**
	 * 获取高级归档的json格式
	 */
	public static String getAdvancePigeonhole(String archiveField,String archiveFieldName,String archiveFieldValue,String archiveIsCreate,String archiveKeyword){
		String dvancePigeonholeName = "";
		try {
			JSONObject jo = new JSONObject();
			jo.put("archiveField", archiveField);
			jo.put("archiveFieldName", archiveFieldName);
			jo.put("archiveIsCreate", archiveIsCreate);
			jo.put("archiveFieldValue", archiveFieldValue);
			jo.put("archiveKeyword",archiveKeyword);
			dvancePigeonholeName = jo.toString();
		} catch (JSONException e) {
			log.error("",e);
		}
		return dvancePigeonholeName;
	}
	
	public static ColSummary addOneReplyCounts(ColSummary summary){
		Integer replyCounts = summary.getReplyCounts();
		if(null != replyCounts){
			summary.setReplyCounts(replyCounts.intValue() +1);
		}else{
			summary.setReplyCounts(1);
		}
		return summary;
	}
	public static ColSummary removeOneReplyCounts(ColSummary summary){
		Integer replyCounts = summary.getReplyCounts();
		if(null != replyCounts && replyCounts.intValue() != 1){
			summary.setReplyCounts(replyCounts.intValue() - 1);
		}else{
			summary.setReplyCounts(0);
		}
		return summary;
	}
	
	public static void putImportantI18n2Session(){
		EnumManager enumManager = getEnumManager();
    	List<CtpEnumItem> secretLevelItems =  enumManager.getEnumItems(EnumNameEnum.edoc_urgent_level);
        String i18nValue2 = ResourceUtil.getString("edoc.urgentlevel.pingji");
        if(Strings.isNotEmpty(secretLevelItems)){
        	for(CtpEnumItem item : secretLevelItems){
        		if("2".equals(item.getValue())){
        			i18nValue2 = ResourceUtil.getString(item.getLabel());
        			break;
        		}
        	}
        }
        AppContext.putRequestContext("i18nValue2",i18nValue2);
    }
	
	/**
	 * 是否为数字
	 * @param id
	 * @return
	 */
    public static boolean isLong(String id) {
        String regex= "[-]{0,1}[\\d]+?";
        return id.matches(regex);
    }
    
    public static boolean isColSummaryFinished(ColSummary summary) {
        if (summary.getState() == null) {
            return false;
        }
        int intValue = summary.getState().intValue();
        return CollaborationEnum.flowState.terminate.ordinal() == intValue || CollaborationEnum.flowState.finish.ordinal() == intValue;
    }

	public static void deleteQuartzJobForNode(CtpAffair affair) {
		boolean isDateLineDate = affair.getDeadlineDate() != null && affair.getDeadlineDate() != 0
				&& affair.getDeadlineDate() != -1;
		boolean isRemindDate = affair.getRemindDate() != null && affair.getRemindDate() != 0
				&& affair.getRemindDate() != -1;

		if (isDateLineDate) {
			QuartzHolder.deleteQuartzJob("DeadLine" + affair.getId());
			QuartzHolder.deleteQuartzJob("DeadLine" + affair.getObjectId() + "_" + affair.getActivityId());
		}

		if (isRemindDate && isDateLineDate) {
			QuartzHolder.deleteQuartzJob("Remind" + affair.getId());
			QuartzHolder.deleteQuartzJob("Remind" + affair.getObjectId() + "_" + affair.getActivityId());
		}
		
		//协同流程回退、指定回退操作后删除节点多次提醒任务
		ColUtil.deleteCycleRemindQuartzJob(affair, false);
	}

	
	public static void deleteQuartzJobForNodes(Collection<CtpAffair> affairs) {
		if(Strings.isEmpty(affairs)){
			return;
		}
		Set<String> jobNames = new HashSet<String>();
		for(CtpAffair affair: affairs){

			boolean isDateLineDate = affair.getDeadlineDate() != null && affair.getDeadlineDate() != 0
					&& affair.getDeadlineDate() != -1;
			boolean isRemindDate = affair.getRemindDate() != null && affair.getRemindDate() != 0
					&& affair.getRemindDate() != -1;
			if (isDateLineDate) {
				jobNames.add("DeadLine" + affair.getObjectId() + "_" + affair.getActivityId());
			}
			
			if (isRemindDate && isDateLineDate) {
				jobNames.add("Remind" + affair.getObjectId() + "_" + affair.getActivityId());
			}
			
			//协同流程回退、指定回退操作后删除节点多次提醒任务
			ColUtil.deleteCycleRemindQuartzJob(affair, false);
		}
		
		if(Strings.isNotEmpty(jobNames)){
			for(String jobName : jobNames){
				QuartzHolder.deleteQuartzJob(jobName);
			}
		}
	}

	
	public static Long getAgentMemberId(Long templateId, Long memberId, Date date) throws BusinessException {
		String collaborationType ="freeColl";//自由协同
        if(templateId  != null){
            collaborationType ="templateColl"; //表单/模板协同
        }
        Long agentMemberId = null;
        List<AgentModel> agentToModels = MemberAgentBean.getInstance().getAgentModelToList(memberId);
        if(agentToModels != null && !agentToModels.isEmpty()){
            if("freeColl".equals(collaborationType)){
                for(AgentModel agentModel : agentToModels){
                    if(date.compareTo(agentModel.getStartDate()) >= 0 && date.before(agentModel.getEndDate())){
                        if(agentModel.isHasCol()){
                            agentMemberId = Long.valueOf(agentModel.getAgentId());
                            break;
                        }
                    }
                }
            }else if("templateColl".equals(collaborationType)){
                for(AgentModel agentModel : agentToModels){
                    if(date.after(agentModel.getStartDate()) && date.before(agentModel.getEndDate())){
                        List<AgentDetailModel> details = agentModel.getAgentDetail();
                        if(agentModel.isHasTemplate()){
                            if(Strings.isEmpty(details)){
                                agentMemberId = Long.valueOf(agentModel.getAgentId());
                                break;
                            } else {
                                for(AgentDetailModel detail : details){
                                    if(detail.getEntityId().equals(templateId)){
                                        agentMemberId =Long.valueOf(agentModel.getAgentId());
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return agentMemberId;
	}

	/**
	 * 根据文档ID获取归档全路径名称
	 * @param archiveId
	 * @return
	 */
	public static String getArchiveAllNameById(Long archiveId) throws BusinessException {
		String archiveAllName = ResourceUtil.getString("collaboration.project.nothing.label");
		if (AppContext.hasPlugin(ApplicationCategoryEnum.doc.name()) && archiveId != null) {
			DocResourceBO docResourceBO = getDocApi().getDocResource(archiveId);
	    	if(docResourceBO == null){
	    		archiveAllName = "";
	    	}else{
	    		archiveAllName = getDocApi().getPhysicalPath(docResourceBO.getLogicalPath(), "\\", false, 0);
	    	}
		}
		
		return archiveAllName;
	}
	
	/**
	 * 
	 * @param objectId
	 * @param activityId
	 * @param affairManager
	 */
	public static void deleteCycleRemindQuartzJob(CtpAffair affair, boolean isFinishAll) {
		boolean isDateLineDate = affair.getDeadlineDate()!=null && affair.getDeadlineDate().longValue()!=0 && affair.getDeadlineDate()!=-1;
		
		if(isDateLineDate) {
			String jobName = "CycleRemind_" + affair.getObjectId() + "_" + affair.getActivityId();
			
			try {
				boolean isDeleteJob = true;
				if(isFinishAll) {
			        List<CtpAffair> affairList = getAffairManager().getAffairsByObjectIdAndNodeId(affair.getObjectId(), affair.getActivityId());
			        if(Strings.isNotEmpty(affairList)) {
			        	for(CtpAffair bean : affairList) {
			        		if(bean.getState()!=null && bean.getState().intValue()==StateEnum.col_pending.key()) {
			        			isDeleteJob = false;
			        			break;
			        		}
			        	}
			        }
				}
		        if(isDeleteJob) {
		        	if(QuartzHolder.hasQuartzJob(jobName, jobName)) {
		        		log.error("删除节点超期后多次提醒定时任务时间：" + DateUtil.get19DateAndTime() + " jobName=" + jobName);
		        		
		        		QuartzHolder.deleteQuartzJobByGroupAndJobName(jobName, jobName);	        		
		        	}
		        }
			} catch(Exception e) {
				log.error("删除节点超期后多次提醒定时任务出错：" + DateUtil.get19DateAndTime() + " jobName=" + jobName);
			}
		}
	}
	/**
     * 设置Affair的运行时长，超时时长，按工作时间设置的运行时长，按工作时间设置的超时时长。
     * @param affair
     * @throws BusinessException
     */
    public static void setTime2Affair(CtpAffair affair,ColSummary summary) throws BusinessException{
    	//工作日计算运行时间和超期时间。
    	long runWorkTime = 0L;
    	long orgAccountId = summary.getOrgAccountId();
		runWorkTime = getWorkTimeManager().getDealWithTimeValue(affair.getReceiveTime(),new Date(),orgAccountId);
		runWorkTime = runWorkTime/(60*1000);
		Long deadline = 0l;
		Long workDeadline = 0l;
		if((affair.getExpectedProcessTime()!=null || affair.getDeadlineDate()!=null) &&  !Long.valueOf(0).equals(affair.getDeadlineDate())){
		    if (affair.getDeadlineDate()!= null) {
		    	deadline = affair.getDeadlineDate().longValue();
		    } else {
		    	deadline = workTimeManager.getDealWithTimeValue(DateUtil.currentTimestamp(), affair.getExpectedProcessTime(), orgAccountId);
				deadline = deadline/1000/60;
		    }
		    workDeadline = getWorkTimeManager().convert2WorkTime(deadline, orgAccountId);
		}

		//超期工作时间
		Long overWorkTime = 0L;
		//设置了处理期限才进行计算,没有设置处理期限的话,默认为0;
		if(workDeadline!=null &&  !Long.valueOf(0).equals(workDeadline)){
			long ow = runWorkTime - workDeadline;
			overWorkTime =  ow >0 ? ow: 0l ;
		}

    	//自然日计算运行时间和超期时间
    	long runTime = (System.currentTimeMillis() - affair.getReceiveTime().getTime())/(60*1000);
    	Long overTime = 0L;
    	if( affair.getDeadlineDate()!= null && affair.getDeadlineDate()!= 0){
    		Long o = runTime - affair.getDeadlineDate();
    		overTime = o >0 ? o : 0l;
    	}
    	
    	//避免时间到了定时任务还没有执行。暂时不需要考虑是否在工作时间，因为定时任务那边也没有考虑，先保持一致。
    	if(affair.getExpectedProcessTime() != null){
    	    if(new Date().after(affair.getExpectedProcessTime())){  
    	        affair.setCoverTime(true);
    	    }
    	}
    	
    	if(affair.isCoverTime()!=null && affair.isCoverTime()){
    	    if(Long.valueOf(0).equals(overTime)) {
    	    	overTime = 1l;
    	    }
    	    if(Long.valueOf(0).equals(overWorkTime)){
    	    	overWorkTime = 1l;
    	    }
    	}
    	affair.setOverTime(overTime);
    	affair.setOverWorktime(overWorkTime);
    	affair.setRunTime(runTime == 0 ? 1 : runTime);
    	affair.setRunWorktime(runWorkTime == 0 ? 1:runWorkTime);
    }
	/**
	 * 根据文档Id获取归档简称路径
	 * @return
	 * @throws BusinessException
	 */
	public static String getArchiveNameById(Long archiveId) throws BusinessException{
		String archiveName = ResourceUtil.getString("collaboration.project.nothing.label");
		if (AppContext.hasPlugin(ApplicationCategoryEnum.doc.name()) && archiveId != null) {
			archiveName = getDocApi().getDocResourceName(archiveId);
			String archiveAllName = getArchiveAllNameById(archiveId);
	    	if (archiveName != null && !archiveName.equals(archiveAllName)) {
	    		archiveName = "...\\"+archiveName;
	    	}
		}
    	return archiveName;
	}
	
	private static OrgManager getOrgManager(){
        if(orgManager == null){
            orgManager = (OrgManager) AppContext.getBean("orgManager");
        }
        return orgManager;
    }
	
    private static DocApi getDocApi() {
        if (docApi == null) {
            docApi = (DocApi) AppContext.getBean("docApi");
        }
        return docApi;
    }

    private static EnumManager getEnumManager() {
        if (enumManagerNew == null) {
            enumManagerNew = (EnumManager) AppContext.getBean("enumManagerNew");
        }
        return enumManagerNew;
    }
    
    private static WorkTimeManager getWorkTimeManager(){
        if(workTimeManager == null){
            workTimeManager = (WorkTimeManager)AppContext.getBean("workTimeManager");
        }
        return workTimeManager;
    }
    
    private static TemplateManager getTemplateManager() {
        if (templateManager == null) {
            templateManager = (TemplateManager) AppContext.getBean("templateManager");
        }
        return templateManager;

    }
    
    private static WorkflowApiManager getWorkflowApiManager() {
        if (wapi == null) {
            wapi = (WorkflowApiManager) AppContext.getBean("wapi");
        }
        return wapi;
    }

    private static FormManager getFormManager() {
        if (formManager == null) {
            formManager = (FormManager) AppContext.getBean("formManager");
        }
        return formManager;
    }
    
    private static CollaborationApi getCollaborationApi() {
        if (collaborationApi == null) {
            collaborationApi = (CollaborationApi) AppContext.getBean("collaborationApi");
        }
        return collaborationApi;
    }
    
    private static PrivilegeManager getPrivilegeManager() {
        if (privilegeManager == null) {
            privilegeManager = (PrivilegeManager) AppContext.getBean("privilegeManager");
        }
        return privilegeManager;
    }
    
    private static AffairManager getAffairManager() {
        if (affairManager == null) {
            affairManager = (AffairManager) AppContext.getBean("affairManager");
        }
        return affairManager;
    }
}
