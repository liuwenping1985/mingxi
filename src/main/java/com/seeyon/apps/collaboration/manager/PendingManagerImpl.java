package com.seeyon.apps.collaboration.manager;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.itextpdf.text.log.SysoCounter;
import com.seeyon.apps.agent.bo.AgentModel;
import com.seeyon.apps.agent.utils.AgentUtil;
import com.seeyon.apps.collaboration.api.CollaborationApi;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.collaboration.util.ColUtil;
import com.seeyon.apps.edoc.api.EdocApi;
import com.seeyon.apps.edoc.bo.SimpleEdocSummary;
import com.seeyon.apps.edoc.enums.EdocEnum;
import com.seeyon.apps.meeting.api.MeetingApi;
import com.seeyon.apps.meeting.bo.MeetingBO;
import com.seeyon.apps.taskcenter.Manager.TaskCenterManager;
import com.seeyon.apps.taskcenter.bo.CenterTaskBO;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.ApplicationSubCategoryEnum;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.content.affair.AffairCondition;
import com.seeyon.ctp.common.content.affair.AffairCondition.SearchCondition;
import com.seeyon.ctp.common.content.affair.AffairExtPropEnums;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.AffairUtil;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.content.affair.constants.SubStateEnum;
import com.seeyon.ctp.common.ctpenumnew.EnumNameEnum;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceBundleUtil;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.permission.bo.Permission;
import com.seeyon.ctp.common.permission.manager.PermissionManager;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.template.CtpTemplate;
import com.seeyon.ctp.common.po.template.CtpTemplateCategory;
import com.seeyon.ctp.common.security.SecurityHelper;
import com.seeyon.ctp.common.supervise.manager.SuperviseManager;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.common.template.manager.TemplateManager;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.portal.section.CommonAffairSectionUtils;
import com.seeyon.ctp.portal.section.PendingRow;
import com.seeyon.ctp.portal.section.templete.BaseSectionTemplete.OPEN_TYPE;
import com.seeyon.ctp.portal.section.util.SectionUtils;
import com.seeyon.ctp.portal.space.manager.PortletEntityPropertyManager;
import com.seeyon.ctp.portal.util.Constants.SpaceType;
import com.seeyon.ctp.report.chart2.bo.ChartBO;
import com.seeyon.ctp.report.chart2.bo.Title;
import com.seeyon.ctp.report.chart2.bo.serie.PieSerie;
import com.seeyon.ctp.report.chart2.bo.serie.SerieItem;
import com.seeyon.ctp.report.chart2.core.ChartRender;
import com.seeyon.ctp.report.chart2.vo.ChartVO;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.v3x.edoc.dao.EdocSummaryDao;
import com.seeyon.v3x.menu.manager.MenuFunction;
import com.seeyon.v3x.worktimeset.manager.WorkTimeManager;

import net.joinwork.bpm.definition.BPMSeeyonPolicy;

/**
 * @author <a href="tanmf@seeyon.com">Tanmf</a>
 * @date 2013-1-25
 */
public class PendingManagerImpl implements PendingManager {
    private static final Log log = LogFactory.getLog(PendingManagerImpl.class);
    private OrgManager orgManager;
    private PortletEntityPropertyManager portletEntityPropertyManager;
    private AffairManager affairManager;
    private WorkTimeManager workTimeManager;
    private SuperviseManager superviseManager;
    private EdocApi edocApi;
    private CollaborationApi collaborationApi;
    private MeetingApi meetingApi;
    private PermissionManager            permissionManager;
    private ChartRender chartRender;
    private CommonAffairSectionUtils commonAffairSectionUtils;
    private TaskCenterManager            taskCenterManager;
    private TemplateManager templateManager;

   	public void setTemplateManager(TemplateManager templateManager) {
   		this.templateManager = templateManager;
   	}

    
    public void setTaskCenterManager(TaskCenterManager taskCenterManager) {
		this.taskCenterManager = taskCenterManager;
	}
    
    public CommonAffairSectionUtils getCommonAffairSectionUtils() {
		return commonAffairSectionUtils;
	}

	public void setCommonAffairSectionUtils(CommonAffairSectionUtils commonAffairSectionUtils) {
		this.commonAffairSectionUtils = commonAffairSectionUtils;
	}

	public void setPermissionManager(PermissionManager permissionManager) {
        this.permissionManager = permissionManager;
    }
    
    public void setMeetingApi(MeetingApi meetingApi) {
        this.meetingApi = meetingApi;
    }
    
    public void setCollaborationApi(CollaborationApi collaborationApi) {
        this.collaborationApi = collaborationApi;
    }

	public void setEdocApi(EdocApi edocApi) {
		this.edocApi = edocApi;
	}

	public SuperviseManager getSuperviseManager() {
		return superviseManager;
	}

	public void setSuperviseManager(SuperviseManager superviseManager) {
		this.superviseManager = superviseManager;
	}

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void setPortletEntityPropertyManager(PortletEntityPropertyManager portletEntityPropertyManager) {
        this.portletEntityPropertyManager = portletEntityPropertyManager;
    }

    public void setAffairManager(AffairManager affairManager) {
        this.affairManager = affairManager;
    }

    public void setWorkTimeManager(WorkTimeManager workTimeManager) {
        this.workTimeManager = workTimeManager;
    }

    public void setChartRender(ChartRender chartRender) {
		this.chartRender = chartRender;
	}
    
	public int getUnReadPendingCount(Long memberId, Long fragmentId, String ordinal) {
		return getPendingCount(memberId, fragmentId, ordinal, true);
	}

	public int getPendingCount(Long memberId, Long fragmentId, String ordinal) {
		return getPendingCount(memberId, fragmentId, ordinal, false);
	}

	public int getPendingCount(Long memberId, Map<String, String> preference, boolean isUnRead) {
		String currentPanel="";
		if(preference!=null&&preference.size()>0){
			currentPanel=SectionUtils.getPanel("all", preference);
		}
		return getPendingCount(memberId,preference,isUnRead,currentPanel);
	}
	
	private int getPendingCount(Long memberId,Map<String, String> preference,boolean isUnRead,String currentPanel){
		AffairCondition condition = getPendingSectionAffairCondition(memberId, preference);
		if (isUnRead) {
			condition.addSearch(SearchCondition.subState, String.valueOf(SubStateEnum.col_pending_unRead.getKey()), "");
		}
		if ("sender".equals(currentPanel)) {
			List<Integer> appEnum = new ArrayList<Integer>();
			// 查询指定发起人，用于查询指定发起人的时候查询比较复杂，所以采用HQL的方式进行查询，其他情况维持原来的逻辑不变
			String tempStr = preference.get(currentPanel + "_value");
			return (Integer) affairManager.getAffairListBySender(memberId, tempStr, condition, true, null, appEnum);
		}
		else {
			return condition.getPendingCount(affairManager);
		}
	}
	private int getPendingCount(Long memberId, Long fragmentId, String ordinal, boolean isUnRead) {
		Map<String, String> preference = new HashMap<String, String>();
		String currentPanel = "";
		if (fragmentId != null && Strings.isNotBlank(ordinal)) {
			preference = portletEntityPropertyManager.getPropertys(fragmentId, ordinal);
			currentPanel = SectionUtils.getPanel("all", preference);
		}
		return getPendingCount(memberId,preference,isUnRead,currentPanel);
	}
    @SuppressWarnings("unchecked")
    public List<CtpAffair> getPendingList(Long memberId, Long fragmentId, String ordinal, int count) {
    	  Map<String,String> preference = portletEntityPropertyManager.getPropertys(fragmentId, ordinal);
        return getPublicPendingList(memberId, preference, count);
    }

    @SuppressWarnings("unchecked")
    public List<CtpAffair> getPublicPendingList(Long memberId, Map<String, String> preference, int count) {
        String currentPanel = SectionUtils.getPanel("all", preference);
        AffairCondition condition = getPendingSectionAffairCondition(memberId, preference);
        String columnStyle=preference.get("columnStyle");
        //待开会议栏目默认值Policy_value=A___30
        String policeValue = preference.get("Policy_value");
        //待开会议栏目编辑为来源是会议后，sources_Policy_value=A___30
        String sourcesPolicyValue=preference.get("sources_Policy_value");
        //排序类型默认降序
        String orderType = "desc";
        //如果是待开会议，排序时按升序排列
        if(Strings.isNotBlank(policeValue) && "A___30".equals(policeValue) || Strings.isNotBlank(sourcesPolicyValue) && "A___30".equals(sourcesPolicyValue)){
        	orderType = "asc";
        }
        FlipInfo fi = new FlipInfo();
        fi.setNeedTotal(false);
        fi.setPage(1);
        fi.setSize(count);
        List<Integer> appEnum=new ArrayList<Integer>();
        if("sender".equals(currentPanel)){
            //查询指定发起人，用于查询指定发起人的时候查询比较复杂，所以采用HQL的方式进行查询，其他情况维持原来的逻辑不变,这个里面会对receiveTime排序
            String tempStr = preference.get(currentPanel+"_value");
            return (List<CtpAffair>)affairManager.getAffairListBySender(memberId, tempStr, condition, false,fi,appEnum);
        }
        else{
            fi.setSortField("receiveTime");
            fi.setSortOrder(orderType);
            return condition.getPendingAffair(affairManager, fi);
        }
    }
    private static boolean hasValue(Map query){
      return query.get("state")!=null&&Strings.isNotBlank(String.valueOf(query.get("state"))) && !"".equals(query.get("state"));
    }

    @SuppressWarnings("unchecked")
    public FlipInfo getMoreList4SectionContion(FlipInfo fi, Map query) throws BusinessException{
    	
    	//客开 start
    	int htmlpage = fi.getPage();
    	int htmlsize = fi.getSize();
    	//客开 end
    	
    	// 客开 2018-06-19 gyz start
    	Boolean isCondition = true;
    	// 客开 2018-06-19 gyz end
    	
    	Boolean fromMore = true;
    	
        if(fi == null || query == null) {
            return null;
        }
        Boolean isTrack = false;
        if(query.get("isTrack") != null && "true".equals(query.get("isTrack").toString())){
            isTrack = true;
        }
        //如果不是跟踪的 时候，必须传 state值
        if(!isTrack && query.get("state") == null){
            return null;
        }
        User user = AppContext.getCurrentUser();
        Long memberId = AppContext.currentUserId();
        Map<String,String> preference = new HashMap<String,String>();
        String fromM1 = (String)query.get("fromM1");
        if(Strings.isNotBlank(fromM1)) {
            preference = (Map<String,String>)JSONUtil.parseJSONString(fromM1);
        } else if(query.get("fragmentId")!= null && query.get("ordinal") != null){
        	String fragmentIdStr=query.get("fragmentId").toString();
        	if(Strings.isNotBlank(fragmentIdStr)){
        		Long fragmentId = Long.parseLong(fragmentIdStr);
        		String ordinal = query.get("ordinal").toString();
        		preference = portletEntityPropertyManager.getPropertys(fragmentId, ordinal);
        	}
        }

        //我的提醒：超期待办
        if (query.get("myRemind") != null && "overTime".equals(query.get("myRemind").toString())) {
            preference.put("sources_overTime_name", "overTime");
            preference.put("panel", "sources");
        }
        //我的提醒：待办会议
        if (query.get("myRemind") != null && "meeting".equals(query.get("myRemind").toString())) {
            preference.put("sources_Policy_value", "A___6");
            preference.put("panel", "sources");
        }

        String currentPanel = SectionUtils.getPanel("all", preference);
        List<CtpAffair> affairList = null;
        preference.put("isFromMore", String.valueOf(fromMore));
        AffairCondition condition = getPendingSectionAffairCondition(memberId, preference);
        if(!"pendingSection".equals(query.get("section")) && !"trackSection".equals(query.get("section"))) {
        	if(hasValue(query)) {
        		int state =Integer.parseInt(query.get("state").toString());
        		if(state == StateEnum.col_waitSend.key()) {//待发事项排除信息报送
                	condition.addSearch(SearchCondition.catagory, "waitsend_catagory_all", null,fromMore);
                } else if(state == StateEnum.col_sent.key()) {//已发事项排除信息报送
                	condition.addSearch(SearchCondition.catagory, "sent_catagory_all",null, fromMore);
                } else if(state == StateEnum.col_done.key()){//已办事项
                    condition.addSearch(SearchCondition.catagory, "done_catagory_all",null, fromMore);
                }
        	}
        }
        // 流程来源,拼装来自栏目编辑页面的条件
        String tempStr = preference.get(currentPanel+"_value");
        if("meeting".equals(query.get("meeting_category"))){//如果是来至 【已办会议】更多(moreMeeting)，就只查询出会议(会议通知+会议室)相关信息
            condition.addSearch(SearchCondition.catagory, "catagory_meet", null,fromMore);
        }else if(!"all".equals(currentPanel)) {
            if(StringUtils.isNotBlank(tempStr)) {
            	// 组装查询条件
                if("track_catagory".equals(currentPanel)){//分类
                	condition.addSearch(SearchCondition.catagory, tempStr, null,fromMore);
                }else if("importLevel".equals(currentPanel)){//重要程度
                	condition.addSearch(SearchCondition.importLevel, tempStr, null,fromMore);
                }else if("Policy".equals(currentPanel)){
                	condition.addSearch(SearchCondition.policy4Portal, tempStr, null,fromMore);
                }
            }
        }
        String conditions = (String) query.get("condition");
        if(Strings.isNotBlank(conditions)){
        	// 客开 2018-06-19 gyz start
        	isCondition = false;
        	// 客开 2018-06-19 gyz end
            String textField1 = (String) query.get("textfield");
            String textField2 = (String) query.get("textfield1");
            SearchCondition con = AffairCondition.SearchCondition.valueOf(conditions);
            if(con != null){
                //对时间进行特殊处理，当开始日期时，将时间置为最小，当是结束时间时，将时间置为最大
                if (AffairCondition.SearchCondition.createDate.name().equals(conditions) ||
                        AffairCondition.SearchCondition.receiveDate.name().equals(conditions) ||
                        AffairCondition.SearchCondition.dealDate.name().equals(conditions) ||
                        AffairCondition.SearchCondition.expectedProcessTime.name().equals(conditions)) {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    if(Strings.isNotBlank(textField1)){
                        textField1 = Datetimes.getServiceFirstTime(textField1);
                    }
                    if(Strings.isNotBlank(textField2)){
                        textField2 = Datetimes.getServiceLastTime(textField2);
                    }
                }
                condition.addSearch(con, textField1, textField2,true);
            }
        }
        
    	String objectId = (String) query.get("objectId");
    	if(Strings.isNotBlank(objectId)){
    		condition.addSearch(AffairCondition.SearchCondition.moduleId, query.get("objectId").toString(), null);
    	}
        
        if(isTrack) {
        	 if("sender".equals(currentPanel)){
        		
        		 condition.addSearch(AffairCondition.SearchCondition.applicationEnum,"1,4",null);
        		 condition.setIsTrack(true);
        		 List<Integer> appEnum=new ArrayList<Integer>();
        		 //查询指定发起人
        		 affairList = (List<CtpAffair>)affairManager.getAffairListBySender(memberId, tempStr, condition, false,fi,appEnum);
             }else{
            	 affairList = condition.getTrackAffair(affairManager,fi);
             }
        }else {
        	//根据前端传递过来的页码重置页码
        	if(query.get("page") != null){
        		fi.setPage(Integer.parseInt(query.get("page").toString()));
        	}
            int state = Integer.parseInt(query.get("state").toString()) ;
            condition.setState(StateEnum.valueOf(state));
            if(fi.getSortField() == null){
                if(state == StateEnum.col_done.key()) {
                	if("meeting".equals(query.get("meeting_category"))){
                		fi.setSortField("receiveTime");
                	}else{
                		fi.setSortField("completeTime");
                	}
                } else if(state == StateEnum.col_pending.key()){
                    fi.setSortField("receiveTime");
                }else {
                    fi.setSortField("createDate");
                }
                if(state ==StateEnum.col_pending.key()){//如果是待办事项， 查找会议
                	 //待开会议栏目默认值Policy_value=A___30
                    String policeValue = preference.get("Policy_value");
                    //待开会议栏目编辑为来源是会议后，sources_Policy_value=A___30
                    String sourcesPolicyValue=preference.get("sources_Policy_value");
                    //如果是待开会议，排序时按升序排列
                    if(Strings.isNotBlank(policeValue) && "A___30".equals(policeValue) || Strings.isNotBlank(sourcesPolicyValue) && "A___30".equals(sourcesPolicyValue)){
                    	fi.setSortOrder("asc");
                    }else{
                    	fi.setSortOrder("desc");
                    }
                }else{
                	fi.setSortOrder("desc");
                }
            }
            List<Integer> appEnum=new ArrayList<Integer>();
            String groupBy = String.valueOf(query.get("isGroupBy"));
            boolean isGroupBy = false;
            if (!"".equals(groupBy) && Strings.isNotBlank(groupBy)) {
                isGroupBy = Boolean.parseBoolean(groupBy);
            }
            if("sender".equals(currentPanel)){
                //查询指定发起人，用于查询指定发起人的时候查询比较复杂，所以采用HQL的方式进行查询，其他情况维持原来的逻辑不变
                affairList = (List<CtpAffair>)affairManager.getAffairListBySender(memberId, tempStr, condition, false, fi,appEnum,isGroupBy);
            }else{
            	if(state == StateEnum.col_pending.key()){
            		fi.setSize(100000);
            		affairList = condition.getPendingAffair(affairManager, fi);
            	}else{
            		if(state == StateEnum.col_done.key() && isGroupBy){
            			affairList = (List<CtpAffair>) affairManager.getDeduplicationAffairs(memberId, condition, false, fi);
            		}else{
            			fi.setSize(100000);
            			affairList = condition.getSectionAffair(affairManager, state, fi,isGroupBy,false);
            		}
            	}
            }
        }
        String rowStr = preference.get("rowList");
        if(Strings.isBlank(rowStr)){
        	rowStr="subject,receiveTime,sendUser,category,edocMark,currentNodesInfo";//客开 添加公文编号、当前待办人 20180622  gxy
        }
        List<CtpAffair> affairListClone = new ArrayList<CtpAffair>();
        CtpAffair ctpAffairORG = null;
        CtpAffair ctpAffairclo = null;
        for(int a = 0 ; a < affairList.size(); a ++){
        	ctpAffairORG = affairList.get(a);
        	try {
				ctpAffairclo = (CtpAffair) ctpAffairORG.clone();
				ctpAffairclo.setId(ctpAffairORG.getId());
			} catch (CloneNotSupportedException e) {
			}
        	affairListClone.add(ctpAffairclo);
        }
        boolean isNeedReplayCounts = Boolean.TRUE.equals(query.get("isNeedReplayCounts"));
        boolean processingProgress = Boolean.TRUE.equals(query.get("processingProgress"));
        //客开 gxy 20180622 显示待办人去掉验证 start
        /*if((query.containsKey("showCurNodesInfo") && (Boolean)query.get("showCurNodesInfo")) || isTrack){
        	if(Strings.isNotBlank(rowStr) &&  rowStr.indexOf("currentNodesInfo") == -1){
        		rowStr += ",currentNodesInfo";
        	}
        }*/
      //客开 gxy 20180622 显示待办人去掉验证 end
        List<PendingRow> voList  = affairList2PendingRowList(affairListClone, isNeedReplayCounts,processingProgress, user, null, false,rowStr);
        
        //客开 2018-03-23 gxy start 
        if(voList.size()>0){
        	for(PendingRow pr:voList){
                try {
                	CtpTemplateCategory clc = null;
    				if(pr.getTemplateId()!=null && !"".equals(pr.getTemplateId())){
    					CtpTemplate ctpTemplate = templateManager.getCtpTemplate(Long.valueOf(pr.getTemplateId()));
    					clc = templateManager.getCtpTemplateCategory(ctpTemplate.getCategoryId());
    					if("发文模版".equals(clc.getName())){
    					    if("-2066523224662719456".equals(ctpTemplate.getId()+"") ){
        						pr.setCategoryLabel("部门发文");
        					}else{
        						pr.setCategoryLabel("公司发文");
        					}
    					    //客开 2018-07-03 赵培珅 任务来源显示错误 start 
    					}else if("收文模版".equals(clc.getName())){
    							pr.setCategoryLabel("收文处理");
    					}else{
    						pr.setCategoryLabel(clc.getName());
    					}
    					if("2135462982126750833".equals(ctpTemplate.getId()+"") ){
    						pr.setCategoryLabel("签报");
    					}
    						//客开 2018-07-03 赵培珅 任务来源显示错误 end 
    				}
	   			} catch (Exception e) {
	   				log.error("获取任务来源异常",e);
	   			}
            }
        }
      //客开 2018-03-23 gxy end
        
		
		// 客开 start 融合第三方数据
		try {
			if (!isTrack && !"sender".equals(currentPanel)) {
				SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm");
				int state = Integer.parseInt(query.get("state").toString());
				String groupBy = String.valueOf(query.get("isGroupBy"));
				boolean isGroupBy = false;
				if (!"".equals(groupBy) && Strings.isNotBlank(groupBy)) {
					isGroupBy = Boolean.parseBoolean(groupBy);
				}
				// 客开 2018-06-15 gyz start
				if (isCondition) {
					// 客开 2018-06-15 gyz end

					if (state == StateEnum.col_pending.key()) {
						try {
							//String str = "group1,group2,group3,group4";
							//String[] group = str.split(",");
							//for (String param : group) {
								List<CenterTaskBO> tslist = taskCenterManager.newjasonTodolist(user.getLoginName(),
										"");
								if (tslist.size() > 0) {
									for (CenterTaskBO ttb : tslist) {
										PendingRow pr = new PendingRow();
										pr.setSubject(ttb.getSubject());// 标题
										pr.setCategoryLabel(ttb.getFlowName());// 分类
										pr.setCreateDate(format.parse(ttb.getAssignerTime()));
										pr.setReceiveTimeAll(ttb.getAssignerTime().substring(0, 16));// 接受时间
										pr.setPolicyName(ttb.getFlowNode());// 节点名称
										pr.setCreateMemberName(ttb.getDesignator());// 发起人
										pr.setLink(ttb.getLinkPath());// 链接
										voList.add(pr);
									}
								}
							//}
						} catch (Exception e) {
							log.error("获取第三方待办数据异常", e);
						}
					} else {
						try {
							if (state == StateEnum.col_done.key() && isGroupBy) {

							} else {
								FlipInfo flipInfo = new FlipInfo();
								flipInfo.setSize(100000);
								List<CenterTaskBO> list = taskCenterManager.listmydoneTask(flipInfo, null).getData();
								if (list.size() > 0) {
									for (CenterTaskBO ttb : list) {
										PendingRow pr = new PendingRow();
										pr.setSubject(ttb.getSubject());// 标题
										pr.setCategoryLabel(ttb.getFlowName());// 分类
										pr.setCreateDate(format.parse(ttb.getSubmitTime()));
										pr.setCompleteTime(ttb.getSubmitTime().substring(0, 16));
										pr.setPolicyName(ttb.getFlowNode());// 节点名称
										pr.setCreateMemberName(ttb.getDesignator());// 发起人
										pr.setLink(ttb.getLinkPath());// 链接
										voList.add(pr);
									}
								}
							}
						} catch (Exception e) {
							log.error("获取第三方已办数据异常", e);
						}
					}

					// 客开 2018-06-15 gyz start
				}
				// 客开 2018-06-15 gyz end

				ListSort(voList);

				List<PendingRow> newList = null;
				int pageSize = htmlsize;
				int toIndex = htmlsize;
				fi.setPage(htmlpage);
				fi.setSize(htmlsize);
				htmlpage--;
				for (int i = pageSize * htmlpage; i < voList.size(); i += pageSize) {
					if (i + pageSize > voList.size()) {
						toIndex = voList.size() - i;
					}
					newList = voList.subList(i, i + toIndex);
					break;
				}
				// 客开 gxy 201800622 start
				/*for (PendingRow pp : newList) {
					List<CtpAffair> caList = affairManager.getAffairs(pp.getObjectId(), StateEnum.col_pending);
					if (caList.size() > 0) {
        				//客开 赵培珅 2018-06-14 start 代办人显示错误       				
        				//if(null != caList.get(0).getSummaryState() && caList.get(0).getSummaryState()!=3){
							V3xOrgMember member = orgManager.getMemberById(caList.get(0).getMemberId());
							pp.setCurrentNodesInfo(member.getName());
        			//	}
        				//客开 赵培珅 2018-06-14 end   代办人显示错误   
					}
				}*/
				// 客开 gxy 20180622 end
				fi.setData(newList);
				fi.setTotal(voList.size());

			}
		} catch (Exception e) {
			log.error("更多页面第三方数据分割异常", e);
		}
		// 客开 end 融合第三方数据
			
		return fi;
	}

    public FlipInfo getMoreAgentList4SectionContion(FlipInfo fi, Map query) throws BusinessException{
        User user = AppContext.getCurrentUser();
        Long memberId = user.getId();
        Object[] agentObj = AgentUtil.getUserAgentToMap(memberId);
        boolean agentToFlag = (Boolean)agentObj[0];
        Map<Integer,List<AgentModel>> ma = (Map<Integer,List<AgentModel>>)agentObj[1];

        AffairCondition condition = new AffairCondition(memberId, StateEnum.col_pending);
        condition.setAgent(agentToFlag, ma);

        //更多待办的条件查询
        String conditions = (String)query.get("condition");
        if(Strings.isNotBlank(conditions)){
            String textField1 = (String)query.get("textfield");
            String textField2 = (String)query.get("textfield1");

            SearchCondition con = AffairCondition.SearchCondition.valueOf(conditions);
            if(con != null){
                //对时间进行特殊处理，当开始日期时，将时间置为最小，当是结束时间时，将时间置为最大
                if (AffairCondition.SearchCondition.createDate.name().equals(conditions) ||
                        AffairCondition.SearchCondition.receiveDate.name().equals(conditions) ||
                        AffairCondition.SearchCondition.dealDate.name().equals(conditions) ||
                        AffairCondition.SearchCondition.expectedProcessTime.name().equals(conditions)) {
                    if(Strings.isNotBlank(textField1)){
                        textField1 = Datetimes.getServiceFirstTime(textField1);
                    }
                    if(Strings.isNotBlank(textField2)){
                        textField2 = Datetimes.getServiceLastTime(textField2);
                    }
                }
                condition.addSearch(con, textField1, textField2);
            }
        }
        if(fi.getSortField() == null){
            fi.setSortField("receiveTime");
            fi.setSortOrder("desc");
        }

        List<CtpAffair> affairList = condition.getAgentPendingAffair(affairManager, fi);
        List<PendingRow> voList  = affairList2PendingRowList(affairList, false,false, user, null, true,String.valueOf(query.get("rowStr")));
        fi.setData(voList);

        return fi;
    }

    public Map<String, Integer> getGroupByApp(Long memberId, StateEnum state,Map<String,String> preference){
        Map<String, Integer> result = new HashMap<String, Integer>();
        AffairCondition condition=getPendingSectionAffairCondition(memberId, preference);
        List<Integer> appEnum=new ArrayList<Integer>();
        List<Object[]> temp =new ArrayList<Object[]>();
        String currentPanel = SectionUtils.getPanel("all", preference);
        if("sender".equals(currentPanel)){
        	//查询指定发起人，用于查询指定发起人的时候查询比较复杂，所以采用HQL的方式进行查询，其他情况维持原来的逻辑不变
            String tempStr = preference.get(currentPanel+"_value");
        	temp=(List<Object[]>)affairManager.getAffairListBySender(memberId, tempStr, condition, true, null,appEnum,"app","sub_app");
        }else{
        	temp =condition.group(appEnum,"app","subApp");
        }

        int allColl = 0; //所有协同
        int zyxt= 0;//自由协同，
        int xtbdmb = 0;//协同/表单模板，
        int shouWen = 0;//收文
        int faWen = 0;//发文
        int daiFaEdoc = 0;//待发送
        int daiQianShou = 0;//待签收
        int daiDengJi = 0;//待登记
        int qianBao = 0;//签报
        int huiYi = 0;//会议
        int huiYiShi = 0;//会议室审批
        int diaoCha = 0; //调查
        int daiShenPiGGXX = 0;//待审批公共信息 (公告，新闻，调查，讨论= 0
        int daiShenPiZHBG = 0;//待审批综合办公审批
        if (!temp.isEmpty()) {
        	for (int _count =0; _count< temp.size(); _count ++) {
        		Object[] os  = null;
        		try{
        			os = temp.get(_count);
        		}catch(Exception e){
        			log.error("*****"+e.getLocalizedMessage()+"currentPanel:"+currentPanel,e);
        			continue;
        		}
                Integer appInt = ((Number)os[0]).intValue();
                Integer subApp=0;
                if(os[1]!=null){
                	subApp = ((Number)os[1]).intValue();
                }
                int count = ((Number)os[2]).intValue();

                ApplicationCategoryEnum app =  ApplicationCategoryEnum.valueOf(appInt);
                if(app == null){
                    continue;
                }
                switch (app) {
                case collaboration:
                    allColl += count;
                    if(Strings.equals(subApp, ApplicationSubCategoryEnum.collaboration_self.key())){
                        zyxt = count; //待审核
                    }
                    else if(Strings.equals(subApp, ApplicationSubCategoryEnum.collaboration_tempate.key())){
                        xtbdmb = count; //填写
                    }
                    break;
                case edoc:
                case edocSend:
                    faWen = count;
                    break;
                case edocRec:
                	shouWen = shouWen+count;
                    break;
                case edocSign:
                    qianBao = count;
                    break;
                case edocRegister:
                    daiDengJi = count;
                    break;
                case exSend:
                    daiFaEdoc = count;
                    break;
                case exSign:
                    daiQianShou = count;
                    break;
                case exchange:
                case edocRecDistribute:
                    break;
                case meeting:
                    huiYi = count;
                    break;
                case meetingroom:
                    huiYiShi = count;
                    break;
                case news:
                case bulletin:
                    daiShenPiGGXX += count;
                    break;
                case inquiry:
                    if(Strings.equals(subApp, ApplicationSubCategoryEnum.inquiry_audit.key())){
                        daiShenPiGGXX += count; //待审核
                    }
                    else if(Strings.equals(subApp, ApplicationSubCategoryEnum.inquiry_write.key())){
                    	diaoCha += count; //填写
                    }
                    break;
                case office:
                    daiShenPiZHBG += count;
                    break;
                default:
                    break;
                }
            }
        }

        result.put("allColl", allColl); //所有协同
        result.put("zyxt", zyxt);//自由协同，
        result.put("xtbdmb", xtbdmb);//协同/表单模板，
        result.put("shouWen", shouWen);//收文
        result.put("faWen", faWen);//发文
        result.put("daiFaEdoc", daiFaEdoc);//待发送
        result.put("daiQianShou", daiQianShou);//待签收
        result.put("daiDengJi", daiDengJi);//待登记
        result.put("qianBao", qianBao);//签报
        result.put("huiYi", huiYi);//会议
        result.put("huiYiShi", huiYiShi);//会议室审批
        result.put("diaoCha", diaoCha);//调查
        result.put("daiShenPiGGXX", daiShenPiGGXX);//待审批公共信息 (公告，新闻，调查，讨论)
        result.put("daiShenPiZHBG", daiShenPiZHBG);//待审批综合办公审批

        return result;
    }

    public Map<Integer, Integer> getGroupByImportment(Long memberId, StateEnum state,Map<String,String> preference,Integer... appKeys){
        Map<Integer, Integer> result = new HashMap<Integer, Integer>();
        List<Object[]> temp =new ArrayList<Object[]>();
        temp=getCalcuteResult(memberId,preference,"important_level","importantLevel",appKeys);
        int other = 0;
        for (int _count=0; _count < temp.size(); _count ++) {
        	Object[] o  = null;
        	try{
        		o =  temp.get(_count);
        	}catch(Exception e){
        		log.error("*****"+e.getLocalizedMessage()+"***memeberId:"+memberId +"***preference="+preference+"***appKeys="+appKeys ,e);
    			continue;
        	}
            if(o != null && o[0] != null){
                result.put(((Number)o[0]).intValue(), ((Number)o[1]).intValue());
            }else if(o != null&&o[0] == null&&o[1]!=null){
                other += ((Number)o[1]).intValue();
            }
        }
        result.put(-1, other);
        return result;
    }

    public Map<Integer, Integer> getGroupBySubState(Long memberId, StateEnum state,Map<String,String> preference,Integer... appKeys){
        Map<Integer, Integer> result = new HashMap<Integer, Integer>();
        List<Object[]> temp =new ArrayList<Object[]>();
        temp=getCalcuteResult(memberId,preference,"sub_state","subState",appKeys);
        for (Object[] o : temp) {
            if(o != null && o[0] != null){
                result.put(((Number)o[0]).intValue(), ((Number)o[1]).intValue());
            }else if(o != null && o[0] == null&&o[1]!=null){
            	result.put(0,((Number)o[1]).intValue());
            }
        }
        return result;
    }
    /**
     * 计算统计结果
     * @param memberId
     * @param preference
     * @param senderBroupByName
     * @param groupByPropertyName
     * @param appKeys
     * @return
     */
    private List<Object[]> getCalcuteResult(Long memberId,
			Map<String, String> preference,String senderBroupByName,String groupByPropertyName,Integer... appKeys) {
    	List<Object[]> temp =new ArrayList<Object[]>();
    	AffairCondition condition=getPendingSectionAffairCondition(memberId, preference);
        boolean hasApp = appKeys != null && appKeys.length > 0;
        List<Integer> appEnum=new ArrayList<Integer>();
        if(hasApp){
        	appEnum=Strings.newArrayList(appKeys);
        }
        String currentPanel = SectionUtils.getPanel("all", preference);
        if("sender".equals(currentPanel)){
        	//查询指定发起人，用于查询指定发起人的时候查询比较复杂，所以采用HQL的方式进行查询，其他情况维持原来的逻辑不变
            String tempStr = preference.get(currentPanel+"_value");
        	temp=(List<Object[]>)affairManager.getAffairListBySender(memberId, tempStr, condition, true, null,appEnum,senderBroupByName);
        }else{
        	temp =condition.group(appEnum,groupByPropertyName);
        }
        return temp;
	}

    public Map<String,Integer> getGroupByIsOverTime(Long memberId, StateEnum state,Map<String,String> preference,Integer... appKeys){
        Map<String,Integer> result=new HashMap<String, Integer>();
        String currentPanel = SectionUtils.getPanel("all", preference);
        List<Object[]> temp =new ArrayList<Object[]>();
        temp=getCalcuteResult(memberId,preference,"IS_COVER_TIME","coverTime",appKeys);
        int nullSize=0;
        int falseSize=0;
        int trueSize=0;
        for (Object[] o : temp) {
            if(o != null){
            	if(o[0]==null){
            		nullSize=((Integer)o[1]).intValue();
            	}else if("sender".equals(currentPanel)){
            		if(((Number)o[0]).byteValue()==0){
            			falseSize=((Number)o[1]).intValue();
            		}
            		if(((Number)o[0]).byteValue()==1){
            			trueSize=((Number)o[1]).intValue();
            		}
                }else{
            		if(!(Boolean)o[0]){
            			falseSize=((Number)o[1]).intValue();
            		}
            		if((Boolean)o[0]){
            			trueSize=((Number)o[1]).intValue();
            		}
            	}
            }
        }
        result.put("noOverdue", nullSize+falseSize);
        result.put("overdue", trueSize);

        return result;
    }

    @SuppressWarnings("unchecked")
    private AffairCondition getPendingSectionAffairCondition(Long memberId, Map<String,String> preference){
        String currentPanel = SectionUtils.getPanel("all", preference);
        String isFromMore = preference.get("isFromMore");
        boolean fromMore =false;
        if(Strings.isNotBlank(isFromMore)){
        	fromMore = Boolean.valueOf(fromMore);
        }
        Object[] agentObj = AgentUtil.getUserAgentToMap(memberId);
        boolean agentToFlag = (Boolean)agentObj[0];
        Map<Integer,List<AgentModel>> ma = (Map<Integer,List<AgentModel>>)agentObj[1];
        AffairCondition condition = new AffairCondition(memberId, StateEnum.col_pending,
                ApplicationCategoryEnum.collaboration,
                ApplicationCategoryEnum.edoc,
                ApplicationCategoryEnum.meeting,
                ApplicationCategoryEnum.bulletin,
                ApplicationCategoryEnum.news,
                ApplicationCategoryEnum.inquiry,
                ApplicationCategoryEnum.office,
                ApplicationCategoryEnum.info,
                ApplicationCategoryEnum.meetingroom,
                ApplicationCategoryEnum.edocRecDistribute,
                ApplicationCategoryEnum.infoStat
        );
       
        if("all".equals(currentPanel)){
        }
        else if("overTime".equals(currentPanel)){
            condition.addSearch(SearchCondition.overTime, null, null,fromMore);
        }
        else if("freeCol".equals(currentPanel)) {//自由协同
            condition.addSearch(SearchCondition.catagory, "catagory_coll", null,fromMore);
        }
        else if(!"agent".equals(currentPanel)){
        	if(Strings.isNotBlank(currentPanel) && "sources".equals(currentPanel)){
        		condition.addSourceSearchCondition(preference,fromMore);
        	}else{
    		   String tempStr = preference.get(currentPanel+"_value");
               if(Strings.isBlank(tempStr) || "null".equalsIgnoreCase(tempStr)){
                 //没有重要程度为-1的数据，加上这个条件就是为了查不出数据
                //   condition.addSearch(SearchCondition.importLevel, "-1", null,fromMore);
               }else{
                   if("templete_pending".equals(currentPanel)){
                       condition.addSearch(SearchCondition.templete, tempStr, null,fromMore);
                   }
                   else if("Policy".equals(currentPanel)){
                       condition.addSearch(SearchCondition.policy4Portal, tempStr, null,fromMore);
                   }
                   else if("importLevel".equals(currentPanel)){
                       condition.addSearch(SearchCondition.importLevel, tempStr, null,fromMore);
                   }
                   else if("catagory".equals(currentPanel)){
                       condition.addSearch(SearchCondition.catagory, tempStr, null,fromMore);
                   }
                   else if("track_catagory".equals(currentPanel)){
                       condition.addSearch(SearchCondition.catagory, tempStr, null,fromMore);
                   }
                   else if("handlingState".equals(currentPanel)){
                       condition.addSearch(SearchCondition.handlingState, tempStr, null,fromMore);
                   }
               }
        	}
        }
        condition.setAgent(agentToFlag, ma);
        return condition;
    }
    private boolean isG6Version(){
        String isG6=SystemProperties.getInstance().getProperty("edoc.isG6");
        if("true".equals(isG6)){
        	return true;
        }
        return false;
    }
    public List<PendingRow> affairList2PendingRowList(List<CtpAffair> affairs, boolean isNeedReplyCounts, boolean processingProgress, User user, String currentPanel, boolean isProxy,String rowStr) throws BusinessException {
    	boolean isGov = isG6Version();
        boolean edocDistributeFlag = true;
        
        List<Integer> edocApps =new ArrayList<Integer>();
        edocApps.add(ApplicationCategoryEnum.edocSend.getKey());//发文 19
        edocApps.add(ApplicationCategoryEnum.edocRec.getKey());//收文 20
        edocApps.add(ApplicationCategoryEnum.edocSign.getKey());//签报21
        edocApps.add(ApplicationCategoryEnum.exSend.getKey());//待发送公文22
        edocApps.add(ApplicationCategoryEnum.exSign.getKey());//待签收公文 23
        edocApps.add(ApplicationCategoryEnum.edocRegister.getKey());//待登记公文 24
        edocApps.add(ApplicationCategoryEnum.edocRecDistribute.getKey());//收文分发34

        /**
         * 用于显示当前待办人
         * 将affairs中公文和协同的取出来放在不同的List中，然后通过in sql语句将各自的summary的currentNodesInfo取出保存在PendingRow中
         */
        List<Long> collIdList = new ArrayList<Long>();
        List<Long> edocIdList = new ArrayList<Long>();
        
        List<Integer> edocEnums =new ArrayList<Integer>();
        edocEnums.add(ApplicationCategoryEnum.edocSend.getKey());//发文 19
        edocEnums.add(ApplicationCategoryEnum.edocRec.getKey());//收文 20
        edocEnums.add(ApplicationCategoryEnum.edocSign.getKey());//签报21
        edocEnums.add(ApplicationCategoryEnum.exSend.getKey());//待发送公文22
        edocEnums.add(ApplicationCategoryEnum.exSign.getKey());//待签收公文 23
        edocEnums.add(ApplicationCategoryEnum.edocRegister.getKey());//待登记公文 24
        edocEnums.add(ApplicationCategoryEnum.edocRecDistribute.getKey());//收文分发34
        
        //获取权限
        Map<String,Permission>  permissonMap = new HashMap<String, Permission>();
        List<Permission> permissonList = permissionManager.getPermissionsByCategory(EnumNameEnum.col_flow_perm_policy.name(), AppContext.currentAccountId());
        for (Permission permission : permissonList) {
            permissonMap.put(permission.getName(), permission);
        }
        
        boolean needCheckIsEdocRegister  = false;
        boolean needCheckIsExchangeRole  = false;
        boolean needCheckHasEdocDistributeGrant = false;
        for(CtpAffair affair : affairs){
        	//协同
        	if(affair.getApp() == ApplicationCategoryEnum.collaboration.key()){
        		collIdList.add(affair.getObjectId());
        	}
        	//公文
        	else if(edocApps.contains(affair.getApp())){
				ApplicationCategoryEnum appEnum = ApplicationCategoryEnum.valueOf(affair.getApp());
				if (appEnum.equals(ApplicationCategoryEnum.edocRegister)) {
					needCheckIsEdocRegister = true;
				}
				else if (appEnum.equals(ApplicationCategoryEnum.exSend)) {
					needCheckIsExchangeRole = true;
				}
				else if (appEnum.equals(ApplicationCategoryEnum.edocRecDistribute)) {
					needCheckHasEdocDistributeGrant = true;
				}
        		edocIdList.add(affair.getObjectId());
        	}
        }
        
        Map<Long,ColSummary> colSummaryMap = new HashMap<Long,ColSummary>();

        boolean isCurrentNodesInfo = rowStr.indexOf("currentNodesInfo") != -1 ;
        if(isCurrentNodesInfo || isNeedReplyCounts){ //需要查询当前待办人和回复人数的时候才去查下affair
        	if(Strings.isNotEmpty(collIdList)){
        		List<ColSummary> colSummarys = collaborationApi.findColSummarys(collIdList);
        		for(ColSummary summary : colSummarys){
        			colSummaryMap.put(summary.getId(), summary);
        		}
        	}
        }
        
        Map<Long,SimpleEdocSummary> edocMap = new HashMap<Long,SimpleEdocSummary>();
        boolean isEdocRegister = false;
        boolean isExchangeRole = false;
        boolean hasEdocDistributeGrant = false;
        
        if(Strings.isNotEmpty(edocIdList) && SystemEnvironment.hasPlugin("edoc")){
        	if(isCurrentNodesInfo){
        		List<SimpleEdocSummary> summarys =edocApi.findSimpleEdocSummarysByIds(edocIdList) ;
        		for(SimpleEdocSummary summary : summarys){
        			edocMap.put(summary.getId(), summary);
        		}
        	}

            try {
            	if(needCheckIsEdocRegister){
            		isEdocRegister = edocApi.isEdocCreateRole(user.getId(),user.getLoginAccount() , EdocEnum.edocType.recEdoc.ordinal());
            	}
            }
            catch (Exception e) {
                log.error("", e);
            }
            if(needCheckIsExchangeRole){
            	isExchangeRole = edocApi.isExchangeRole(user.getId(),user.getLoginAccount());
            }
            
            try {
            	if(needCheckHasEdocDistributeGrant){
            		hasEdocDistributeGrant = edocApi.isEdocCreateRole( user.getId(),user.getLoginAccount(), EdocEnum.edocType.distributeEdoc.ordinal());
            	}
            }
            catch(Exception e) {
                log.error("", e);
            }
        }
        
        //控制是否查询会议回执统计信息
        boolean isProcessingProgress = rowStr.indexOf("processingProgress") != -1 ;
        Map<Long, Map<String, Integer>> map_replyCount = new HashMap<Long, Map<String, Integer>>();
        if(processingProgress || isProcessingProgress){
        	Map<String, Integer> map_reply = new HashMap<String, Integer>();
        	for(CtpAffair affair : affairs){
        		Set<Long> set = map_replyCount.keySet();
        		if(set.contains(affair.getObjectId())){
        			continue;
        		}
        		if(meetingApi != null){
        			MeetingBO meeting = meetingApi.getMeeting(affair.getObjectId());
        			if(meeting != null){
        				map_reply = new HashMap<String, Integer>();
        				map_reply.put("allCount", meeting.getAllCount());
        				map_reply.put("joinCount", meeting.getJoinCount());
        				map_reply.put("unjoinCount", meeting.getUnjoinCount());
        				map_reply.put("pendingCount", meeting.getPendingCount());
        				map_replyCount.put(affair.getObjectId(), map_reply);
        			}
        		}
        	}
        	
        }
        
        List<PendingRow> rowList = new ArrayList<PendingRow>();
        for(CtpAffair affair:affairs){
            PendingRow row= new PendingRow();
            String currentNodesInfo = "";
            boolean isHasAttachments = AffairUtil.isHasAttachments(affair);
            Permission  permisson = permissonMap.get(affair.getNodePolicy());
            if (permisson != null) {
                row.setDisAgreeOpinionPolicy(permisson.getNodePolicy().getDisAgreeOpinionPolicy());
            }
            /**
             * 以下情况显示催办按钮
             * 1、协同、公文的：已发数据（在已发栏目、跟踪栏目的已发数据）
             * 2、协同的督办人，查看已办数据。\
             * 3、全部改为前段处理的方式，已发栏目直接true,跟踪栏目判断状态，已办栏目ajax判断是否是督办人
             */
            if(affair.getState()==StateEnum.col_sent.getKey()){
            	row.setSpervisor(true);
            }
            if(affair.getApp() == ApplicationCategoryEnum.collaboration.key()){
            	if (AppContext.hasPlugin("collaboration")) {
                	ColSummary summary =  colSummaryMap.get(affair.getObjectId());
	            	if(summary != null){
	            		if(isCurrentNodesInfo){
	            			currentNodesInfo = ColUtil.parseCurrentNodesInfo(summary);
	            		}
	            		if(isNeedReplyCounts){
	            			if(summary.getReplyCounts() != null) {
	            				row.setReplyCounts(summary.getReplyCounts());
	            			}
	            		}
	            	}
	            	if(null != affair.getAutoRun() && affair.getAutoRun()){
	            		String _subject = ResourceUtil.getString("collaboration.newflow.fire.subject",affair.getSubject());
	            		affair.setSubject(_subject);
	            	}
	            	row.setActivityId(affair.getActivityId());
	            	row.setCaseId(affair.getCaseId());
	            	row.setProcessId(affair.getProcessId());
	            	row.setTemplateId(affair.getTempleteId()+"");
	            	row.setPreApproverName(null == affair.getPreApprover() ? "   " : ColUtil.getMemberName(affair.getPreApprover()));
				}
            }
            else if(edocApps.contains(affair.getApp())){
            	if (AppContext.hasPlugin(ApplicationCategoryEnum.edoc.name())) {
            		SimpleEdocSummary summary = edocMap.get(affair.getObjectId());
	            	if(summary != null){
	            		if(isCurrentNodesInfo){
	            			currentNodesInfo = commonAffairSectionUtils.parseCurrentNodesInfo(summary.getCompleteTime(),
	                			summary.getCurrentNodesInfo(), Collections.<Long, String> emptyMap());
	            		}
	            	}
	            	row.setActivityId(affair.getActivityId());
	            	row.setCaseId(affair.getCaseId());
	            	row.setProcessId(affair.getProcessId());
	            	row.setTemplateId(affair.getTempleteId() == null ? "" : String.valueOf(affair.getTempleteId()));
	            	
	            	isHasAttachments = AffairUtil.isHasAttachments(affair);
            	}	
            	row.setPreApproverName(null == affair.getPreApprover() ? "   " : ColUtil.getMemberName(affair.getPreApprover()));
            }
            if(Strings.isNotBlank(currentNodesInfo)){
            	row.setCurrentNodesInfo(currentNodesInfo);
        	}

            Map<String, Object> extMap=null;
            String forwardMember = affair.getForwardMember();
            Integer resentTime = affair.getResentTime();
            String subject = ColUtil.showSubjectOfAffair(affair, isProxy, -1).replaceAll("\r\n", "").replaceAll("\n", "");
            Integer subApp = affair.getSubApp();
            Long objectId = affair.getObjectId();
            Long templeteId = affair.getTempleteId();
            if(null != templeteId){
            	row.setTemplateId(templeteId.toString());
            }
            row.setSubject(ColUtil.showSubjectOfSummary4Done(affair, -1));
            if(Integer.valueOf(StateEnum.col_pending.getKey()).equals(affair.getState())){
            	row.setSubject(subject);
            }
            row.setSubState(affair.getSubState());
            row.setState(affair.getState());
            Long deadLineDate = affair.getDeadlineDate();
            if(deadLineDate == null){
            	deadLineDate = 0L;
            }
            row.setDeadLineDate(deadLineDate);
            
            String memberName = Functions.showMemberName(affair.getSenderId());
            
            if (memberName == null && (affair.getSenderId()==null || affair.getSenderId() == -1)) {
                memberName = Strings.escapeNULL(affair.getExtProps(), "");
            }
            //客开 赵培珅 2018-5-2 start
            row.setSubObjectId(affair.getSubObjectId()+"");
            row.setApp(affair.getApp()+"");
            //客开 赵培珅 2018-5-2 end
            row.setMemberId(affair.getMemberId());
            row.setCreateMemberName(memberName);
            row.setCreateMemberAlt(memberName);
            row.setCreateMemberId(affair.getSenderId());
            row.setCreateDate(affair.getCreateDate());
            if(null != affair.getReceiveTime()){//修复OA-15330 空指针异常，做防护
            	 // 更多页面页显示全部时间
                row.setReceiveTimeAll(Datetimes.format(affair.getReceiveTime(), "yyyy-MM-dd HH:mm"));
                 // 首页显示今日、明日...
            	String receiveTimeStr=ColUtil.getDateTime(affair.getReceiveTime(),"yyyy-MM-dd HH:mm");
                row.setReceiveTime(receiveTimeStr);
                row.setCompleteTime(receiveTimeStr);
            }
            //加签、知会、当前会签  ps:回退优先，如果这条记录也被回退过，则优先显示回退图标，加签图标不显示
            if(affair.getFromId()!=null&&affair.getBackFromId()==null){
            	row.setFromName(ResourceUtil.getString("collaboration.pending.addOrJointly.label", Functions.showMemberName(affair.getFromId())));
            }
            //回退、指定回退,OA-86015  
            if(affair.getBackFromId()!=null){
            	row.setBackFromName(ResourceUtil.getString("collaboration.pending.stepBack.label", Functions.showMemberName(affair.getBackFromId())));
            }

            row.setId(affair.getId());
            row.setObjectId(objectId);
            row.setBodyType(affair.getBodyType());
            row.setImportantLevel(affair.getImportantLevel());
            row.setHasAttachments(isHasAttachments);
            // 首页  显示处理期限   今日，明日，否则显示正常日期
            if(affair.getExpectedProcessTime()!=null){
            	 row.setDealLineName(ColUtil.getDateTime(affair.getExpectedProcessTime(),"yyyy-MM-dd HH:mm"));
                 // 更多页面
                 row.setDeadLine(ColUtil.getDeadLineName(affair.getExpectedProcessTime()));
            }else{
            	// 兼容老数据
            	// 分别给首页和更多页面传值
            	String deadLineName = ColUtil.getDeadLineName(affair.getDeadlineDate());
                row.setDealLineName(deadLineName);
            	row.setDeadLine(deadLineName);
            }
            //处理时间
            if(affair.getCompleteTime()!=null){
                row.setCompleteTime(Datetimes.format(affair.getCompleteTime(),"yyyy-MM-dd HH:mm"));
            }
            //设置流程超期状态0未超期、1即将超期、2已超期
            Boolean isOverTime=false;
            if(affair.getDeadlineDate() != null&&affair.getDeadlineDate() > 0){
                isOverTime = affair.isCoverTime()==null ? false:affair.isCoverTime();
                //超期事件突出显示
                row.setDistinct(isOverTime);
                row.setOverTime(isOverTime);
            }
            if(affair.getExpectedProcessTime() != null || (affair.getDeadlineDate() != null && affair.getDeadlineDate() != 0)){
                row.setShowClockIcon(true);
            }

            // 处理是否超期  （处理期限是否大于当前期限）
            Date now = new Date(System.currentTimeMillis());
            Boolean isCoverTime = affair.isCoverTime();
            Date _expectedProcessTime = affair.getExpectedProcessTime();
            if(_expectedProcessTime == null && affair.getDeadlineDate() != null && affair.getDeadlineDate() != 0){
            	_expectedProcessTime = workTimeManager.getCompleteDate4Nature(affair.getReceiveTime(), affair.getDeadlineDate(),AppContext.currentAccountId());
            }
            boolean isExpectedOvertime = _expectedProcessTime!=null && now.after(_expectedProcessTime);

            if((isCoverTime != null && isCoverTime) || isExpectedOvertime){
            	row.setDealTimeout(true);
            }
            //设置“文号”和“发文单位”
            String sendUnitName=null;
            if(edocEnums.contains(affair.getApp())&&(rowStr.indexOf("edocMark")!=-1||rowStr.indexOf("sendUnit")!=-1)){
            	if(extMap==null){
        			extMap=Strings.escapeNULL(AffairUtil.getExtProperty(affair),new HashMap<String, Object>());
        		}
        		String edocMark=(String)extMap.get(AffairExtPropEnums.edoc_edocMark.name());
        		if("null".equals(edocMark) || edocMark == null){
        			edocMark="";
        		}
        		sendUnitName = (String)extMap.get(AffairExtPropEnums.edoc_sendUnit.name());
        		row.setEdocMark(edocMark);
        		row.setSendUnit(sendUnitName == null ? "":sendUnitName);
            }


            if(affair.getApp().equals(ApplicationCategoryEnum.meeting.getKey()) &&  AppContext.hasPlugin("meeting")){
            	boolean showMeetingDetail=rowStr.indexOf("placeOfMeeting")!=-1||rowStr.indexOf("theConferenceHost")!=-1||rowStr.indexOf("processingProgress")!=-1;
            	if ("inform".equals(affair.getNodePolicy())) {
                    row.setMeetingImpart(ResourceUtil.getString("collaboration.pending.meetingImpart.lable"));
                }
                String meetingPlace = "";
                Long meetingEmccId = null;
                if(extMap==null){
            		extMap=Strings.escapeNULL(AffairUtil.getExtProperty(affair),new HashMap<String, Object>());
            	}
                //获取会议参会人数，全部人数，不参加人数，待定人数
                
                Map<String, Integer> countMap = map_replyCount.get(affair.getObjectId());
                if(countMap != null){
                	row.setProcessedNumber(countMap.get("joinCount"));
                	row.setUnJoinNumber(countMap.get("unjoinCount"));
                	row.setPendingNumber(countMap.get("pendingCount"));
                	row.setTotalNumber(countMap.get("allCount"));
                	row.setProcessingProgress(row.getProcessedNumber() + "|" + row.getTotalNumber());
                }
                
                if(showMeetingDetail) {
                	if(extMap.containsKey(AffairExtPropEnums.meeting_place.name())){
                		meetingPlace = (String)extMap.get(AffairExtPropEnums.meeting_place.name());
                	}
                	meetingEmccId = objToLong(extMap.get(AffairExtPropEnums.meeting_emcee_id.name()));//主持人ID
                	row.setPlaceOfMeeting(meetingPlace);
                    V3xOrgMember emccMember= orgManager.getMemberById(meetingEmccId);
                    row.setTheConferenceHost(Functions.showMemberName(emccMember));
                    row.setTheConferenceHostId(meetingEmccId);                    
                }else{
                	if(extMap != null){
                    	if(extMap.containsKey(AffairExtPropEnums.meeting_place.name())){
                    		meetingPlace = (String)extMap.get(AffairExtPropEnums.meeting_place.name());
                    		row.setPlaceOfMeeting(meetingPlace);
                    	}
                    }
                }
                String meetingNature = (String)extMap.get(AffairExtPropEnums.meeting_videoConf.name());
                row.setMeetingNature(meetingNature);
            }
            if(isOverTime){
                row.addExtIcons("/common/images/timeout.gif");
            }else if(affair.getDeadlineDate() != null && affair.getDeadlineDate() != 0){
                row.addExtIcons("/common/images/overTime.gif");
            }
            row.setPolicyName(getPolicyName(affair));
            //branches_a8_v350_r_gov GOV-3865 唐桂林  首页-个人空间-自定义待办栏目，设置显示节点权限列，权限为"协同"的权限显示为国际资源化key值 start
            if(isGov){
                String str = row.getPolicyName();
                if(Strings.isNotBlank(str)){
                    if(str.length()>8){
                        str=str.substring(0,8);
                        row.setPolicyName(str+"...");
                    }
                }
            }
            int app = affair.getApp();
            String url="";
            boolean flagTemp=false;
            ApplicationCategoryEnum appEnum = ApplicationCategoryEnum.valueOf(app);
            switch (appEnum) {
            case collaboration :
                row.setLink("/collaboration/collaboration.do?method=summary&openFrom=listPending&affairId=" + affair.getId());
                url="/collaboration/collaboration.do?method=listPending&openFrom=listPending";
                row.setCategory(app, url);
                row.setCategory(ResourceUtil.getString("pending.collaboration.label"), url);
                break;
            case meetingroom:
                if(null != affair.getSubApp() && affair.getSubApp().equals(ApplicationSubCategoryEnum.meetingRoomAudit.getKey())){
                	
                    row.setLink("/meetingroom.do?method=createPerm&openWin=1&id=" + objectId+"&affairId="+affair.getId());
                    url = "/meetingroom.do?method=index";
                    row.setCategory(app, url);
                    row.setReceiveTime(ColUtil.getDateTime(affair.getReceiveTime(),"yyyy-MM-dd HH:mm"));
                    row.setCategory(ResourceUtil.getString("pending.meetingroom.label"), url);
                }
                if(null!=affair.getSubApp())row.setApplicationSubCategoryKey(affair.getSubApp());
                break;
            case meeting :
            	row.setLink("/mtMeeting.do?method=mydetail&id=" + objectId + "&affairId="+affair.getId() + "&state=10");
                url = "/meetingNavigation.do?method=entryManager&entry=meetingPending";


                if(affair.getReceiveTime() != null && affair.getCompleteTime() != null){
                	row.setCompleteTime(convertMeetingTime(affair.getReceiveTime(), affair.getCompleteTime()));
                }
                if(null != affair.getReceiveTime()){
                    row.setReceiveTime(ColUtil.getDateTime(affair.getReceiveTime(),"yyyy-MM-dd HH:mm"));
                }
                row.setCategory(app, subApp, url);
                row.setCategory(ResourceUtil.getString("pending.meeting.label"), url);
                break;
            case edocSend:
                row.setLink("/edocController.do?method=detailIFrame&from=Pending&affairId=" + affair.getId());
                if(null != affair.getSubState() && affair.getSubState()==SubStateEnum.col_pending_ZCDB.key()){
                    url="/edocController.do?method=entryManager&entry=sendManager&listType=listZcdb";
                }else{
                    url="/edocController.do?method=entryManager&entry=sendManager&listType=listPending";
                }

                row.setCategory(app, url);
                row.setCategory(ResourceUtil.getString("pending.edocSend.label"), url);
                break;
            case edocRec:
                if(isGov) {
                    row.setLink("/edocController.do?method=detailIFrame&from=Pending&affairId=" + affair.getId());
                    if(MenuFunction.hasMenu(getMenuIdByApp(appEnum.getKey()))) {
                        //branches_a8_v350_r_gov GOV-2641  唐桂林修改政务收文阅件链接 start
                        url="/edocController.do?method=entryManager&entry=recManager&objectId="+affair.getObjectId();
                        //branches_a8_v350_r_gov GOV-2641  唐桂林修改政务收文阅件链接 end
                    }
                } else {
                    row.setLink("/edocController.do?method=detailIFrame&from=Pending&affairId=" + affair.getId());
                    if(null != affair.getSubState() && affair.getSubState()==SubStateEnum.col_pending_ZCDB.key()){
                        url="/edocController.do?method=entryManager&entry=recManager&listType=listZcdb";
                    }else{
                        url="/edocController.do?method=entryManager&entry=recManager&listType=listPending";
                    }
                }
                row.setCategory(app, url);
                row.setCategory(ResourceUtil.getString("pending.edocRec.label"), url);
                break;
            case edocSign:
                row.setLink("/edocController.do?method=detailIFrame&from=Pending&affairId=" + affair.getId());
                if(null != affair.getSubState() && 
                        (affair.getSubState()==SubStateEnum.col_pending_ZCDB.key() 
                           || SubStateEnum.col_pending_specialBackToSenderReGo.key() == affair.getSubState())){
                    url="/edocController.do?method=entryManager&entry=signReport&listType=listZcdb";
                }else{
                    url="/edocController.do?method=entryManager&entry=signReport&listType=listPending";
                }
                row.setCategory(app, url);
                row.setCategory(ResourceUtil.getString("pending.edocSign.label"), url);
                break;
            case exSend:
                row.setLink("/exchangeEdoc.do?method=sendDetail&modelType=toSend&id="+affair.getSubObjectId()+"&affairId="+affair.getId());
            
                if(MenuFunction.hasMenu(getMenuIdByApp(appEnum.getKey()))) {
                    //branches_a8_v350_r_gov GOV-2073  唐桂林修改政务收文阅件链接 start
                    //branches_a8_v350_r_gov GOV-5016 唐桂林 公文的首页代办中，有一条公文分发数据，点击公文发文链接进去却没有数据 start
                    if(isGov) {
                        url = "/exchangeEdoc.do?method=listMainEntry&modelType=toSend&listType=listExchangeToSend";
                        if(rowStr.indexOf("edocMark")!=-1||rowStr.indexOf("sendUnit")!=-1){
                        	if(extMap==null){
                        		extMap=Strings.escapeNULL(AffairUtil.getExtProperty(affair),new HashMap<String, Object>());
                        	}
                        	Object edocExSendRetreat=extMap.get(AffairExtPropEnums.edoc_edocExSendRetreat.name());
                        	if(affair.getApp()==ApplicationCategoryEnum.exSend.key() &&  edocExSendRetreat!=null) {
                        		row.setSubject(subject+"("+ResourceBundleUtil.getString("com.seeyon.v3x.edoc.resources.i18n.EdocResource", "edoc.gov.retreat.label")+")");
                        		url += "&modelType=sent";
                        	}
                        }
                    } else {
                        url = "/exchangeEdoc.do?method=listMainEntry&modelType=toSend";
                    }
                    //branches_a8_v350_r_gov GOV-5016 唐桂林 公文的首页代办中，有一条公文分发数据，点击公文发文链接进去却没有数据 end
                    //branches_a8_v350_r_gov GOV-2073  唐桂林修改政务收文阅件链接 end
                }
                
                if(!isExchangeRole){
                	flagTemp=true;
                    url="";
                }
                
                row.setCategory(app, url);
                row.setCategory(ResourceUtil.getString("pending.exSend.label"), url);
                break;
            case exSign:
                //待办
                if(isGov) {
                    String modelType = "toReceive";
                	if(extMap==null){
                		extMap=Strings.escapeNULL(AffairUtil.getExtProperty(affair),new HashMap<String, Object>());
                	}
                	Object edocRecieveRetreat=extMap.get(AffairExtPropEnums.edoc_edocRecieveRetreat.name());
                	if(affair.getApp()==ApplicationCategoryEnum.exSign.key() &&  edocRecieveRetreat!=null) {
                		row.setSubject(subject+"("+ResourceBundleUtil.getString("com.seeyon.v3x.edoc.resources.i18n.EdocResource", "edoc.gov.retreat.label")+")");
                		modelType = "retreat";
                	}
                	row.setLink("/exchangeEdoc.do?method=receiveDetail&id="+affair.getSubObjectId()+"&affairId="+affair.getId()+"&modelType="+modelType);
            		url="/exchangeEdoc.do?method=listMainEntry&modelType=toReceive&listType=listExchangeToRecieve";
            		if(affair.getApp()==ApplicationCategoryEnum.exSign.key() &&  edocRecieveRetreat!=null) {
            			row.setSubject(subject+"("+ResourceBundleUtil.getString("com.seeyon.v3x.edoc.resources.i18n.EdocResource", "edoc.gov.retreat.label")+")");
            			if(affair.getApp()==ApplicationCategoryEnum.exSign.key() &&  edocRecieveRetreat!=null) {
            				url += "&listType=listRecieveRetreat";
            			}
                	}
                }else {
                    row.setLink("/exchangeEdoc.do?method=receiveDetail&modelType=toReceive&id="+affair.getSubObjectId()+"&affairId="+affair.getId());
                    url="/exchangeEdoc.do?method=listMainEntry&modelType=toReceive";
                }
                row.setCategory(app, url);
                row.setCategory(ResourceUtil.getString("pending.exSign.label"), url);
                break;
            case edocRegister:
                //branches_a8_v350_r_gov GOV-2657  唐桂林修改政务公文登记链接 start
                if(isGov) {
                    row.setLink("/edocController.do?method=entryManager&entry=recManager&toFrom=newEdocRegister&edocType="+EdocEnum.edocType.recEdoc.ordinal()+
                    		"&exchangeId="+affair.getSubObjectId()+"&edocId="+affair.getObjectId()+"&affairId="+affair.getId()+"&registerType=1&comm=create"+
                    		"&recListType=registerPending", OPEN_TYPE.href);
                    if(MenuFunction.hasMenu(getMenuIdByApp(appEnum.getKey())) && isEdocRegister) {
                    	url = "/edocController.do?method=entryManager&entry=recManager&toFrom=listRegister&recListType=registerPending&edocType="+EdocEnum.edocType.recEdoc.ordinal();
                    	if(extMap==null){
                    		extMap=Strings.escapeNULL(AffairUtil.getExtProperty(affair),new HashMap<String, Object>());
                    	}
                    	Object edocRegisterRetreat=extMap.get(AffairExtPropEnums.edoc_edocRegisterRetreat.name());
                        if(affair.getApp()==24 && edocRegisterRetreat!=null) {
                            row.setSubject(subject+"("+ResourceBundleUtil.getString("com.seeyon.v3x.edoc.resources.i18n.EdocResource", "edoc.gov.retreat.label")+")");
                            url += "&listType=registerRetreat";
                            //被回退的待登记，再登记时需要进行编辑修改操作，所以传comm=edit
                            row.setLink("/edocController.do?method=entryManager&entry=recManager&toFrom=newEdocRegister&edocType="+EdocEnum.edocType.recEdoc.ordinal()+
                            		"&exchangeId="+affair.getSubObjectId()+"&edocId="+affair.getObjectId()+"&affairId="+affair.getId()+"&registerType=1&comm=edit"+
                            		"&recListType=registerPending", OPEN_TYPE.href);
                        }
                    }
                } else {
                    row.setLink("/edocController.do?method=entryManager&entry=recManager&listType=newEdoc&comm=register&regeiterCompetence=register&recieveId="+affair.getSubObjectId()+"&edocId="+affair.getObjectId()+"&affairId=" + affair.getId(), OPEN_TYPE.href);
                    url="/edocController.do?method=entryManager&entry=recManager&listType=listV5Register";
                }
                //branches_a8_v350_r_gov GOV-2657  唐桂林修改政务公文登记链接 end
                row.setCategory(app, url);
                row.setCategory(ResourceUtil.getString("pending.edocRegister.label"), url);
                break;
            case edocRecDistribute:
                row.setLink("/edocController.do?method=entryManager&entry=recManager&toFrom=newEdoc&recListType=listDistribute&id="+affair.getObjectId()+"&affairId=" + affair.getId(), OPEN_TYPE.href);
               
                if(edocDistributeFlag && hasEdocDistributeGrant) {
                    url = "/edocController.do?method=entryManager&entry=recManager&edocType=1&toFrom=listDistribute";
                }
                edocDistributeFlag = false;
                row.setCategory(app, url);
                row.setCategory(ResourceUtil.getString("edoc.receive.toAttribute"), url);
                break;
            case info://信息报送
            	if(SystemEnvironment.hasPlugin("infosend")) {
	                subject = ColUtil.mergeSubjectWithForwardMembers(affair.getSubject(), forwardMember, resentTime, null, -1);
	                row.setSubject(subject);
	                row.setCreateDate(affair.getReceiveTime());
	                row.setApplicationCategoryKey(affair.getApp());
	                row.setApplicationSubCategoryKey(affair.getSubApp());
	                if(affair.getSubApp()==null || affair.getSubApp()==ApplicationSubCategoryEnum.info_self.key()
	                		|| affair.getSubApp()==ApplicationSubCategoryEnum.info_tempate.key()) {
	                	row.setLink("/info/infoDetail.do?method=summary&id="+affair.getObjectId()+"&openFrom=Pending&affairId=" + affair.getId() + "");
	                	if(user.hasResourceCode("F18_infoAudit")) {
	                		url = "/info/infoMain.do?method=infoAudit&listType=listInfoPending";
	                	}
	                } else if(affair.getSubApp()==ApplicationSubCategoryEnum.info_magazine.key()) {
	                	row.setLink("/info/magazine.do?method=summary&magazineId="+affair.getObjectId()+"&openFrom=Pending&affairId=" + affair.getId() + "");
	                	if(user.hasResourceCode("F18_magazineAudit")) {
	                		url = "/info/infoMain.do?method=magazineAudit&listType=listMagazineAuditPending";
	                	}
	                } else if(affair.getSubApp()==ApplicationSubCategoryEnum.info_magazine_publish.key()) {
	                	row.setLink("/info/magazine.do?method=openMagazinePublishDialog&openFromType=2");
	                	if(user.hasResourceCode("F18_magazinePublish")) {
	                		url = "/info/infoMain.do?method=magazineAudit&listType=listMagazinePublishPending";
	                	}
	                }
	                row.setCategory(ResourceUtil.getString("menu.info.report"), url);
	                break;
            	}
            case bulletin:
                String[] bulLinks = getPendingCategoryLink(affair);
                row.setLink(bulLinks[0], OPEN_TYPE.href_blank);
                row.setApplicationCategoryKey(app);
                if ("agent".equals(currentPanel) && !user.getId().equals(affair.getMemberId())) { // 代理人查看公告审核事项，不显示后面的应用链接
                    row.setCategory(ResourceUtil.getString("collaboration.pending.bulletin.label"), null);
                } else {
                    row.setCategory(ResourceUtil.getString("collaboration.pending.bulletin.label"), bulLinks[1], OPEN_TYPE.href_blank);
                }
                break;
            case news:
                String[] newsLinks = getPendingCategoryLink(affair);
                row.setLink(newsLinks[0], OPEN_TYPE.href_blank);
                row.setApplicationCategoryKey(app);
                if ("agent".equals(currentPanel) && !user.getId().equals(affair.getMemberId())) { // 代理人查看新闻审核事项，不显示后面的应用链接
                    row.setCategory(ResourceUtil.getString("collaboration.pending.news.label"), null);
                } else {
                    row.setCategory(ResourceUtil.getString("collaboration.pending.news.label"), newsLinks[1], OPEN_TYPE.href_blank);
                }
                break;
            case inquiry:
                String[] inquiryLinks = getPendingCategoryLink(affair);
                row.setLink(inquiryLinks[0], OPEN_TYPE.href_blank);
                row.setApplicationCategoryKey(app);
                row.setApplicationSubCategoryKey(affair.getSubApp());
                if ("agent".equals(currentPanel) && !user.getId().equals(affair.getMemberId())) { // 代理人查看新闻审核事项，不显示后面的应用链接
                    row.setCategory(ResourceUtil.getString("collaboration.pending.inquiry.label"), null);
                } else {
                    row.setCategory(ResourceUtil.getString("collaboration.pending.inquiry.label"), inquiryLinks[1], OPEN_TYPE.href_blank);
                }
                break;
            case office: // 综合办公审批
                try {
                    row.setApplicationCategoryKey(app);
                    row.setApplicationSubCategoryKey(affair.getSubApp());
                    if (ApplicationSubCategoryEnum.office_auto.key() == subApp.intValue()) { // 车辆
                        row.setLink("/office/autoUse.do?method=autoAuditEdit&affairId=" + affair.getId()+"&v="+SecurityHelper.func_digest(affair.getId()));
                        row.setCategory(ResourceUtil.getString("office.app.auto.js"), "/office/autoUse.do?method=index&tgt=autoAudit");
                    } else if (ApplicationSubCategoryEnum.office_stock.key() == subApp.intValue()) { // 办公用品
                        row.setLink("/office/stockUse.do?method=stockAuditEdit&affairId=" + affair.getId()+"&v="+SecurityHelper.func_digest(affair.getId()));
                        row.setCategory(ResourceUtil.getString("office.app.stock.js"), "/office/stockUse.do?method=index&tgt=stockAudit");
                    } else if (ApplicationSubCategoryEnum.office_asset.key() == subApp.intValue()) { // 办公设备
                        row.setLink("/office/assetUse.do?method=assetAuditEdit&operate=audit&affairId=" + affair.getId()+"&v="+SecurityHelper.func_digest(affair.getId()));
                        row.setCategory(ResourceUtil.getString("office.app.asset.js"), "/office/assetUse.do?method=index&tgt=assetAudit");
                    } else if (ApplicationSubCategoryEnum.office_book.key() == subApp.intValue()) { // 图书资料
                        row.setLink("/office/bookUse.do?method=bookAuditDetail&bookApplyId=" + objectId+"&v="+SecurityHelper.func_digest(objectId));
                        row.setCategory(ResourceUtil.getString("office.app.book.js"), "/office/bookUse.do?method=index&tgt=bookAudit");
                    }
                    break;
                } catch (Exception e) {
                	log.info(e.getLocalizedMessage());
                }
            }
            row.setSummaryState(affair.getSummaryState());
            row.setState(affair.getState());
            row.setHasResPerm(this.hasResPerm(affair, user));
            //当前用户不是公文收发员设置为false
            if(flagTemp){
            	row.setHasResPerm(false);
            }
            
            //wxj  修复jira bug OA-109617上一处理人：待办栏目更多列表'会议、新闻、公告、调查'数据的上一处理人显示为"undefined"
            if(null == row.getPreApproverName()) {
                row.setPreApproverName(" ");
            }

            rowList.add(row);
        }
        return rowList;
    }
    //将Object类型的数据转换为Long类型
    private static Long objToLong(Object obj){
    	return obj==null ? null :((Number)obj).longValue();
    }
    //将Object类型的数据转换为Integer类型
    private static Integer objToInteger(Object obj){
    	return obj==null ? null :((Number)obj).intValue();
    }

    private static String[] getPendingCategoryLink(CtpAffair affair) {
        Map<String, Object> extMap=Strings.escapeNULL(AffairUtil.getExtProperty(affair),new HashMap<String, Object>());
        Integer subApp = affair.getSubApp();
        Long objectId = affair.getObjectId();

        String link = null;
        String categoryLink = null;

        ApplicationCategoryEnum appEnum = ApplicationCategoryEnum.valueOf(affair.getApp());
        Integer spaceType = objToInteger(extMap.get(AffairExtPropEnums.spaceType.name()));
        Long spaceId = objToLong(extMap.get(AffairExtPropEnums.spaceId.name()));
        Long typeId = objToLong(extMap.get(AffairExtPropEnums.typeId.name()));

        String from = "";
        if (!Integer.valueOf(SpaceType.corporation.ordinal()).equals(spaceType) && !Integer.valueOf(SpaceType.group.ordinal()).equals(spaceType)) {
            from = "&spaceType=" + spaceType + "&spaceId=" + spaceId;
        }

        switch (appEnum) {
            case news:
                link = "/newsData.do?method=newsView&newsId=" + objectId + "&affairId=" + affair.getId() + "&from=myAudit";
                categoryLink = "/newsData.do?method=newsMyInfo&type=4" + from;
                break;
            case bulletin:
                link = "/bulData.do?method=bulView&bulId=" + objectId + "&affairId=" + affair.getId() + "&from=myAudit";
                if(ApplicationSubCategoryEnum.bulletin_to_publish.key() == subApp.intValue()) {
                	categoryLink = "/bulData.do?method=bulMyInfo&type=1" + from;
                }else {
                	categoryLink = "/bulData.do?method=bulMyInfo&type=3" + from;
                }
                break;
            case inquiry:
                if (ApplicationSubCategoryEnum.inquiry_audit.key() == subApp.intValue()) { // 调查审核
                    link = "/inquiryData.do?method=inquiryView&inquiryId=" + objectId + "&affairId=" + affair.getId() + "&isAuth=true";
                    categoryLink = "/inquiryData.do?method=inquiryIAuth" + from;
                } else if (ApplicationSubCategoryEnum.inquiry_write.key() == subApp.intValue()) { // 调查填写
                    link = "/inquiryData.do?method=inquiryView&inquiryId=" + objectId + "&affairId=" + affair.getId();
                    categoryLink = "/inquiryData.do?method=inquiryBoardIndex&boardId=" + typeId + from;
                }
                break;
        }

        return new String[] { link, categoryLink };
    }

    private String getPolicyName(CtpAffair affair){
		String policy = affair.getNodePolicy();
		if(Strings.isNotBlank(policy)){
			return BPMSeeyonPolicy.getShowName(policy);
		}
		return "";
	}

    public boolean hasResPerm(CtpAffair affair, User user){
        ApplicationCategoryEnum appEnum = ApplicationCategoryEnum.valueOf(affair.getApp());
        Integer subApp = affair.getSubApp();

        boolean f = true;

        switch (appEnum) {
            case collaboration:
                //待办
                if(affair.getState()==StateEnum.col_pending.getKey()){
                    f = user.hasResourceCode("F01_listPending");
                }
                else if(affair.getState()==StateEnum.col_done.getKey()){
                    f = user.hasResourceCode("F01_listDone");
                }
                else if(affair.getState()==StateEnum.col_waitSend.getKey()){
                    f = user.hasResourceCode("F01_listWaitSend");
                }
                else if(affair.getState()==StateEnum.col_sent.getKey()){
                    f = user.hasResourceCode("F01_listSent");
                }
                break;
            case edocSend:
                //待办
                if(affair.getState()==StateEnum.col_pending.getKey()){
                    f = user.hasResourceCode("F07_sendManager");
                }
                else if(affair.getState()==StateEnum.col_done.getKey()){
                    f = user.hasResourceCode("F07_sendManager");
                }
                else if(affair.getState()==StateEnum.col_waitSend.getKey()){
                    f = user.hasResourceCode("F07_sendManager");
                }
                else if(affair.getState()==StateEnum.col_sent.getKey()){
                    f = user.hasResourceCode("F07_sendManager");
                }
                break;

            case edocRec:
                //待办
                if(affair.getState()==StateEnum.col_pending.getKey()){
                    f = user.hasResourceCode("F07_recManager");
                }
                else if(affair.getState()==StateEnum.col_done.getKey()){
                    f = user.hasResourceCode("F07_recManager");
                }
                else if(affair.getState()==StateEnum.col_waitSend.getKey()){
                    f = user.hasResourceCode("F07_recManager");
                }
                else if(affair.getState()==StateEnum.col_sent.getKey()){
                    f = user.hasResourceCode("F07_recManager");
                }
                break;
            case edocSign://签报
                //待办
                if(affair.getState()==StateEnum.col_pending.getKey()){
                    f = user.hasResourceCode("F07_signReport");
                }
                else if(affair.getState()==StateEnum.col_done.getKey()){
                    f = user.hasResourceCode("F07_signReport");
                }
                else if(affair.getState()==StateEnum.col_waitSend.getKey()){
                    f = user.hasResourceCode("F07_signReport");
                }
                else if(affair.getState()==StateEnum.col_sent.getKey()){
                    f = user.hasResourceCode("F07_signReport");
                }
                break;
            case exSend://待发送公文
                f = user.hasResourceCode("F07_exWaitSend");
                break;
            case exSign://待签收公文
                f = user.hasResourceCode("F07_exToReceive");
                break;
            case edocRecDistribute://收文待分发
            	f = user.hasResourceCode("F07_recListFenfaing");
                break;
            case edocRegister://待登记
            	if(isG6Version()){
            		f = user.hasResourceCode("F07_recListRegistering");
            	}else{
            		f = user.hasResourceCode("F07_recRegister");
            	}
                break;
            case bulletin:
                f = (user.hasResourceCode("F05_bulIndexGroup") || user.hasResourceCode("F05_bulIndexAccount"));
                break;
            case news:
                f = (user.hasResourceCode("F05_newsIndexGroup") || user.hasResourceCode("F05_newsIndexAccount"));
                break;
            case inquiry:
                f = (user.hasResourceCode("F05_inquiryIndexAccount") || user.hasResourceCode("F05_inquiryIndexGroup"));
                break;
            case office:
                if (ApplicationSubCategoryEnum.office_auto.key() == subApp.intValue()) { // 车辆
                    f = (user.hasResourceCode("F03_officeAutoUse"));
                } else if (ApplicationSubCategoryEnum.office_stock.key() == subApp.intValue()) { // 办公用品
                    f = (user.hasResourceCode("F03_officeStockUse"));
                } else if (ApplicationSubCategoryEnum.office_asset.key() == subApp.intValue()) { // 办公设备
                    f = (user.hasResourceCode("F03_officeAssetUse"));
                } else if (ApplicationSubCategoryEnum.office_book.key() == subApp.intValue()) { // 图书资料
                    f = (user.hasResourceCode("F03_officeBookUse"));
                }
                break;
            case meeting :
                if(affair.getState()==StateEnum.col_pending.getKey()){
                    f = user.hasResourceCode("F09_meetingPending");
                }
                else if(affair.getState()==StateEnum.col_done.getKey()){
                    f = user.hasResourceCode("F09_meetingDone");
                }
                break;
            case meetingroom:
                f = (user.hasResourceCode("F09_meetingRoom"));
                break;

            case info:
                if(affair.getState()==StateEnum.col_pending.getKey() || affair.getState()==StateEnum.col_done.getKey()) {//待办，已办
                	if(subApp.intValue()==ApplicationSubCategoryEnum.info_magazine.key()) {
                		 f = user.hasResourceCode("F18_magazineAudit");
                	} else if(subApp.intValue()== ApplicationSubCategoryEnum.info_magazine_publish.key()) {
                		 f = user.hasResourceCode("F18_magazinePublish");
                	} else {
                		 f = user.hasResourceCode("F18_infoAudit");
                	}
                } else if(affair.getState()==StateEnum.col_sent.getKey()) {//已发
                	f = user.hasResourceCode("F18_infoReport");
                }
                break;

            default:
                f = true;
                break;
            }

        return f;
    }
    
    /**
	 * 获取会议参会人员数量及总人数
	 * @param meetingId
	 * @return
	 * @throws BusinessException
	 */
	public Integer[] getJoinMeetingCount(CtpAffair affair) throws BusinessException {
		int processedNumber = 0;
        int totalNumber =0;
        if(meetingApi != null){
        	processedNumber = meetingApi.getProcessedNumberByObjectId(affair.getObjectId());
        	totalNumber = meetingApi.getTotalNumberByObjectId(affair.getObjectId());
        }
		return new Integer[]{processedNumber, totalNumber};
	}

	@Override
	public List<CtpAffair> getPendingAffairList(FlipInfo fp,Long memberId,Map<String,String> preference) {
		AffairCondition condition=getPendingSectionAffairCondition(memberId, preference);
		List<CtpAffair> affairs=new ArrayList<CtpAffair>();
		String currentPanel = SectionUtils.getPanel("all", preference);
		List<Integer> appEnum=new ArrayList<Integer>();
		if("sender".equals(currentPanel)){
			//查询指定发起人，用于查询指定发起人的时候查询比较复杂，所以采用HQL的方式进行查询，其他情况维持原来的逻辑不变
            String tempStr = preference.get(currentPanel+"_value");
            affairs=(List<CtpAffair>)affairManager.getAffairListBySender(memberId, tempStr, condition, false,fp,appEnum);
		}else{
			affairs=condition.getPendingAffairList(affairManager, fp);
		}
		return affairs;
	}

	@Override
	public List<CtpAffair> getZcdbAffairList(FlipInfo fp,Long memberId,Map<String,String> preference) {
		AffairCondition condition=getPendingSectionAffairCondition(memberId, preference);
		List<CtpAffair> affairs=new ArrayList<CtpAffair>();
		String currentPanel = SectionUtils.getPanel("all", preference);
		List<Integer> appEnum=new ArrayList<Integer>();
		if("sender".equals(currentPanel)){
			//查询指定发起人，用于查询指定发起人的时候查询比较复杂，所以采用HQL的方式进行查询，其他情况维持原来的逻辑不变
            String tempStr = preference.get(currentPanel+"_value");
            affairs=(List<CtpAffair>)affairManager.getAffairListBySender(memberId, tempStr, condition, false,fp,appEnum);
		}else{
			affairs=condition.getZcdbAffairList(affairManager, fp);
		}
		return affairs;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<CtpAffair> getAffairsByCategoryAndImpLevl(FlipInfo fp,
			List<Integer> colEnums, int i,Long memberId,Map<String,String> preference) {
		AffairCondition condition=getPendingSectionAffairCondition(memberId, preference);
		List<CtpAffair> affairs=new ArrayList<CtpAffair>();
		String currentPanel = SectionUtils.getPanel("all", preference);
		List<Integer> appEnum=new ArrayList<Integer>();
		if("sender".equals(currentPanel)){
		    
		    condition.addSearch(SearchCondition.importLevel, String.valueOf(i), "");
			//查询指定发起人，用于查询指定发起人的时候查询比较复杂，所以采用HQL的方式进行查询，其他情况维持原来的逻辑不变
            String tempStr = preference.get(currentPanel+"_value");
            affairs=(List<CtpAffair>)affairManager.getAffairListBySender(memberId, tempStr, condition, false,fp,appEnum);
		}else{
			affairs=condition.getAffairsByCategoryAndImpLevl(affairManager, fp,colEnums, i);
		}
		return affairs;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<CtpAffair> getCollAffairs(FlipInfo fp,Long memberId,Map<String,String> preference,boolean isTemplete) {
		AffairCondition condition=getPendingSectionAffairCondition(memberId, preference);
		List<CtpAffair> affairs=new ArrayList<CtpAffair>();
		String currentPanel = SectionUtils.getPanel("all", preference);
		List<Integer> appEnum=new ArrayList<Integer>();
		if("sender".equals(currentPanel)){
			//查询指定发起人，用于查询指定发起人的时候查询比较复杂，所以采用HQL的方式进行查询，其他情况维持原来的逻辑不变
            String tempStr = preference.get(currentPanel+"_value");
            affairs=(List<CtpAffair>)affairManager.getAffairListBySender(memberId, tempStr, condition, false,fp,appEnum);
		}else{
			affairs=condition.getCollAffairs(affairManager, fp,isTemplete);
		}
		return affairs;
	}

	@Override
	public List<CtpAffair> getAffairCountByApp(FlipInfo fp,Long memberId,Map<String,String> preference,List<Integer> appEnums) {
		AffairCondition condition=getPendingSectionAffairCondition(memberId, preference);
		List<CtpAffair> affairs=new ArrayList<CtpAffair>();
		String currentPanel = SectionUtils.getPanel("all", preference);
		List<Integer> appEnum=new ArrayList<Integer>();
		if("sender".equals(currentPanel)){
			//查询指定发起人，用于查询指定发起人的时候查询比较复杂，所以采用HQL的方式进行查询，其他情况维持原来的逻辑不变
            String tempStr = preference.get(currentPanel+"_value");
            affairs=(List<CtpAffair>)affairManager.getAffairListBySender(memberId, tempStr, condition, false,fp,appEnum);
		}else{
			affairs=condition.getAffairCountByApp(affairManager, fp, appEnums);
		}
		return affairs;
	}

	@Override
	public Map transInitChartData(Map params) throws BusinessException {
		Map resultMap=new HashMap();
		String _fragmentId=(String)params.get("fragmentId");
		Long fragmentId=Long.valueOf(_fragmentId);
		String ordinal=(String) params.get("ordinal");
		Long memberId=AppContext.currentUserId();
		List<String> graphicalList = new ArrayList<String>();
		Map<String, String> preference = portletEntityPropertyManager
				.getPropertys(fragmentId, ordinal);
		// 选择的统计图
		String graphical = preference.get("graphical_value");
		if (Strings.isBlank(graphical)) {
			graphical = "importantLevel,overdue,handlingState,handleType,exigency";
		}
		String[] graphicalArr = graphical.split(",");
		graphicalList = Arrays.asList(graphicalArr);

		//查询统计图所需要的数据
        for(String chartValue : graphicalList){
            //办理类型
            if("handleType".equals(chartValue)){
                Map<String, Integer> pendingGroups = getGroupByApp(memberId, StateEnum.col_pending,preference);
                resultMap.put("allColl", pendingGroups.get("allColl")); //所有协同
                resultMap.put("zyxt", pendingGroups.get("zyxt"));//自由协同，
                resultMap.put("xtbdmb", pendingGroups.get("xtbdmb"));//协同/表单模板，
                resultMap.put("shouWen", pendingGroups.get("shouWen"));//收文
                resultMap.put("faWen", pendingGroups.get("faWen"));//发文
                resultMap.put("daiFaEdoc", pendingGroups.get("daiFaEdoc"));//待发送
                resultMap.put("daiQianShou", pendingGroups.get("daiQianShou"));//待签收
                resultMap.put("daiDengJi", pendingGroups.get("daiDengJi"));//待登记
                resultMap.put("qianBao", pendingGroups.get("qianBao"));//签报
                resultMap.put("huiYi", pendingGroups.get("huiYi"));//会议
                resultMap.put("huiYiShi", pendingGroups.get("huiYiShi"));//会议室审批
                resultMap.put("diaoCha", pendingGroups.get("diaoCha"));//调查
                resultMap.put("daiShenPiGGXX", pendingGroups.get("daiShenPiGGXX"));//待审批公共信息 (公告，新闻，调查，讨论)
                resultMap.put("daiShenPiZHBG", pendingGroups.get("daiShenPiZHBG"));//待审批综合办公审批
                
                resultMap.put("handleType", this.createHandleTypeChart(resultMap)); //图表参数
            }
            //重要程度
            else if("importantLevel".equals(chartValue)){
                Map<Integer, Integer> pendingGroups = getGroupByImportment(memberId, StateEnum.col_pending,preference, ApplicationCategoryEnum.collaboration.key());

                resultMap.put("import3Count", Strings.escapeNULL(pendingGroups.get(3), 0));//非常重要
                resultMap.put("import2Count", Strings.escapeNULL(pendingGroups.get(2), 0));//重要
                resultMap.put("import1Count", Strings.escapeNULL(pendingGroups.get(1), 0)+Strings.escapeNULL(pendingGroups.get(-1), 0));//普通，important_level为null的也按普通统计
                
                resultMap.put("importantLevel", this.createImportantLevelChart(resultMap)); //图表参数
            }
            //紧急程度（公文）
            else if("exigency".equals(chartValue)){
                List<Integer> edocEnums =new ArrayList<Integer>();
                edocEnums.add(ApplicationCategoryEnum.edocSend.getKey());//发文 19
                edocEnums.add(ApplicationCategoryEnum.edocRec.getKey());//收文 20
                edocEnums.add(ApplicationCategoryEnum.edocSign.getKey());//签报21
                edocEnums.add(ApplicationCategoryEnum.exSend.getKey());//待发送公文22
                edocEnums.add(ApplicationCategoryEnum.exSign.getKey());//待签收公文 23
                edocEnums.add(ApplicationCategoryEnum.edocRegister.getKey());//待登记公文 24
                edocEnums.add(ApplicationCategoryEnum.edocRecDistribute.getKey());//收文分发34

                Map<Integer, Integer> pendingGroups = getGroupByImportment(memberId, StateEnum.col_pending,preference,edocEnums.toArray(new Integer[edocEnums.size()]));

                resultMap.put("commonExigency", Strings.escapeNULL(pendingGroups.get(1), 0)+Strings.escapeNULL(pendingGroups.get(-1), 0));//普通，important_level为null的也按普通统计
                resultMap.put("pingAnxious", Strings.escapeNULL(pendingGroups.get(2), 0));//平急
                resultMap.put("expedited", Strings.escapeNULL(pendingGroups.get(3), 0));//加急
                resultMap.put("urgent", Strings.escapeNULL(pendingGroups.get(4), 0));//特急 exigency
                resultMap.put("teTi", Strings.escapeNULL(pendingGroups.get(5), 0));//特提 topExigency
                
                resultMap.put("exigency", this.createExigencyChart(resultMap)); //图表参数
            }
            //是否超期
            else if("overdue".equals(chartValue)){
                Map<String,Integer> map = getGroupByIsOverTime(memberId,StateEnum.col_pending,preference);

                resultMap.put("overdue", map.get("overdue"));//已超期
                resultMap.put("noOverdue", map.get("noOverdue"));//未超期
                
                resultMap.put("overdue", this.createOverdueChart(resultMap)); //图表参数
            }
            //办理状态
            else if("handlingState".equals(chartValue)){
                Map<Integer, Integer> pendingGroups = getGroupBySubState(memberId,StateEnum.col_pending,preference);

                int count = 0;
                for (Map.Entry<Integer, Integer> c : pendingGroups.entrySet()) {
                    if(!c.getKey().equals(SubStateEnum.col_pending_ZCDB.key())){
                        count += c.getValue();
                    }
                }

                resultMap.put("pendingCount", count);//待办
                resultMap.put("zcdbCount", Strings.escapeNULL(pendingGroups.get(SubStateEnum.col_pending_ZCDB.key()), 0));//暂存待办
                
                resultMap.put("handlingState", this.createHandlingStateChart(resultMap)); //图表参数
            }
        }
        return resultMap;
	}

	//办理类型图表
	private ChartVO createHandleTypeChart(Map resultMap) throws BusinessException{
		if (MapUtils.isEmpty(resultMap)) {
			return null;
		}
		ChartBO bo = new ChartBO();
		bo.setNoDataText("collaboration.pending.noDataAlert2");
		//标题
		bo.setTitle(new Title().setText(ResourceUtil.getString("collaboration.pending.handleType")));
		//颜色列表
		List<String> colorList = new ArrayList<String>();
		//系列
		PieSerie pieSerie = new PieSerie();
		pieSerie.setSymbol("rectangle"); //长方形图例
		List<SerieItem> serieData = new ArrayList<SerieItem>();
		if (Integer.valueOf(resultMap.get("zyxt").toString()) != 0) {
			serieData.add(new SerieItem(resultMap.get("zyxt")).setId("zyxt").setName("collaboration.eventsource.category.collaboration"));
			colorList.add("#f2693d");
		}
		if (Integer.valueOf(resultMap.get("xtbdmb").toString()) != 0) {
			serieData.add(new SerieItem(resultMap.get("xtbdmb")).setId("xtbdmb").setName("collaboration.eventsource.category.collOrFormTemplete"));
			colorList.add("#8cc52b");
		}
		if (Integer.valueOf(resultMap.get("shouWen").toString()) != 0) {
			serieData.add(new SerieItem(resultMap.get("shouWen")).setId("shouWen").setName("collaboration.pending.lable1"));
			colorList.add("#ff7c1c");
		}
		if (Integer.valueOf(resultMap.get("faWen").toString()) != 0) {
			serieData.add(new SerieItem(resultMap.get("faWen")).setId("faWen").setName("collaboration.pending.lable2"));
			colorList.add("#efa900");
		}
		if (Integer.valueOf(resultMap.get("daiFaEdoc").toString()) != 0) {
			serieData.add(new SerieItem(resultMap.get("daiFaEdoc")).setId("daiFaEdoc").setName("collaboration.pending.lable3"));
			colorList.add("#f12924");
		}
		if (Integer.valueOf(resultMap.get("daiQianShou").toString()) != 0) {
			serieData.add(new SerieItem(resultMap.get("daiQianShou")).setId("daiQianShou").setName("collaboration.pending.lable4"));
			colorList.add("#b22600");
		}
		if (Integer.valueOf(resultMap.get("daiDengJi").toString()) != 0) {
			serieData.add(new SerieItem(resultMap.get("daiDengJi")).setId("daiDengJi").setName("collaboration.pending.lable5"));
			colorList.add("#e461a7");
		}
		if (Integer.valueOf(resultMap.get("qianBao").toString()) != 0) {
			serieData.add(new SerieItem(resultMap.get("qianBao")).setId("qianBao").setName("collaboration.pending.lable6"));
			colorList.add("#e02b9c");
		}
		if (Integer.valueOf(resultMap.get("huiYi").toString()) != 0) {
			serieData.add(new SerieItem(resultMap.get("huiYi")).setId("huiYi").setName("collaboration.pending.lable7"));
			colorList.add("#1e8bd0");
		}
		if (Integer.valueOf(resultMap.get("huiYiShi").toString()) != 0) {
			serieData.add(new SerieItem(resultMap.get("huiYiShi")).setId("huiYiShi").setName("collaboration.pending.lable8"));
			colorList.add("#077bbb");
		}
		if (Integer.valueOf(resultMap.get("daiShenPiGGXX").toString()) != 0) {
			serieData.add(new SerieItem(resultMap.get("daiShenPiGGXX")).setId("daiShenPiGGXX").setName("collaboration.pending.lable9"));
			colorList.add("#00585c");
		}
		if (Integer.valueOf(resultMap.get("daiShenPiZHBG").toString()) != 0) {
			serieData.add(new SerieItem(resultMap.get("daiShenPiZHBG")).setId("daiShenPiZHBG").setName("collaboration.pending.lable10"));
			colorList.add("#418700");
		}
		if (Integer.valueOf(resultMap.get("diaoCha").toString()) != 0) {
			serieData.add(new SerieItem(resultMap.get("diaoCha")).setId("diaoCha").setName("collaboration.pending.inquiry.label"));
			colorList.add("#14d6c0");
		}
		pieSerie.setData(serieData);
		bo.setSeries(pieSerie);
		bo.setColor(colorList.toArray(new String[]{}));
		return this.chartRender.render(bo);
	}
	//重要程度图表
	private ChartVO createImportantLevelChart(Map resultMap) throws BusinessException{
		if (MapUtils.isEmpty(resultMap)) {
			return null;
		}
		ChartBO bo = new ChartBO();
		bo.setNoDataText("collaboration.pending.noDataAlert2");
		//标题
		bo.setTitle(new Title().setText(ResourceUtil.getString("collaboration.pending.importantLevel")));
		//颜色列表
		bo.setColor("#f2693d", "#efa900", "#8cc52b");
		//系列
		PieSerie pieSerie = new PieSerie();
		pieSerie.setSymbol("rectangle"); //长方形图例
		List<SerieItem> serieData = new ArrayList<SerieItem>();
		serieData.add(new SerieItem(resultMap.get("import3Count")).setId("import3").setName("collaboration.newcoll.veryimportant"));
		serieData.add(new SerieItem(resultMap.get("import2Count")).setId("import2").setName("collaboration.newcoll.important"));
		serieData.add(new SerieItem(resultMap.get("import1Count")).setId("import1").setName("collaboration.pendingsection.importlevl.normal"));
		pieSerie.setData(serieData);
		bo.setSeries(pieSerie);
		return this.chartRender.render(bo);
	}
	
	//紧急程度（公文）图表
	private ChartVO createExigencyChart(Map resultMap) throws BusinessException{
		if (MapUtils.isEmpty(resultMap)) {
			return null;
		}
		ChartBO bo = new ChartBO();
		bo.setNoDataText("collaboration.pending.noDataAlert1");
		//标题
		bo.setTitle(new Title().setText(ResourceUtil.getString("collaboration.pending.exigencyGraph")));
		//颜色列表
		bo.setColor("#f12924", "#f2693d", "#ffde00", "#cc66ff", "#a9e051");
		//系列
		PieSerie pieSerie = new PieSerie();
		pieSerie.setSymbol("rectangle"); //长方形图例
		List<SerieItem> serieData = new ArrayList<SerieItem>();
		serieData.add(new SerieItem(resultMap.get("teTi")).setId("teTi").setName("collaboration.pending.exigencyNames3"));
		serieData.add(new SerieItem(resultMap.get("urgent")).setId("urgent").setName("collaboration.pending.exigencyNames1"));
		serieData.add(new SerieItem(resultMap.get("expedited")).setId("expedited").setName("collaboration.pending.exigencyNames2"));
		serieData.add(new SerieItem(resultMap.get("pingAnxious")).setId("pingAnxious").setName("collaboration.pending.exigencyNames4"));
		serieData.add(new SerieItem(resultMap.get("commonExigency")).setId("commonExigency").setName("collaboration.pendingsection.importlevl.normal"));
		pieSerie.setData(serieData);
		bo.setSeries(pieSerie);
		return this.chartRender.render(bo);
	}
	
	//是否超期图表
	private ChartVO createOverdueChart(Map resultMap) throws BusinessException{
		if (MapUtils.isEmpty(resultMap)) {
			return null;
		}
		ChartBO bo = new ChartBO();
		bo.setNoDataText("collaboration.pending.noDataAlert2");
		//标题
		bo.setTitle(new Title().setText(ResourceUtil.getString("collaboration.pending.overdueGraph")));
		//颜色列表
		bo.setColor("#1e8bd0", "#f2693d");
		//系列
		PieSerie pieSerie = new PieSerie();
		pieSerie.setSymbol("rectangle"); //长方形图例
		List<SerieItem> serieData = new ArrayList<SerieItem>();
		serieData.add(new SerieItem(resultMap.get("noOverdue")).setId("noOverdue").setName("collaboration.pending.overdueNames3"));
		serieData.add(new SerieItem(resultMap.get("overdue")).setId("overdue").setName("collaboration.pending.overdueNames2"));
		pieSerie.setData(serieData);
		bo.setSeries(pieSerie);
		return this.chartRender.render(bo);
	}
	
	//办理状态图表
	private ChartVO createHandlingStateChart(Map resultMap) throws BusinessException{
		if (MapUtils.isEmpty(resultMap)) {
			return null;
		}
		ChartBO bo = new ChartBO();
		bo.setNoDataText("collaboration.pending.noDataAlert2");
		//标题
		bo.setTitle(new Title().setText(ResourceUtil.getString("collaboration.pending.handlingState.name")));
		//颜色列表
		bo.setColor("#8cc52b", "#1e8bd0");
		//系列
		PieSerie pieSerie = new PieSerie();
		pieSerie.setSymbol("rectangle"); //长方形图例
		List<SerieItem> serieData = new ArrayList<SerieItem>();
		serieData.add(new SerieItem(resultMap.get("pendingCount")).setId("pending").setName("collaboration.pending.handlingState.pending"));
		serieData.add(new SerieItem(resultMap.get("zcdbCount")).setId("zcdb").setName("collaboration.pending.handlingState.zcdb"));
		pieSerie.setData(serieData);
		bo.setSeries(pieSerie);
		return this.chartRender.render(bo);
	}
	
	@Override
	public List<CtpAffair> getAffairsIsOverTime(FlipInfo fp, Long memberId,
			Map<String, String> preference, boolean isOverTime) {
		AffairCondition condition=getPendingSectionAffairCondition(memberId, preference);
		List<CtpAffair> affairs=new ArrayList<CtpAffair>();
		String currentPanel = SectionUtils.getPanel("all", preference);
		List<Integer> appEnum=new ArrayList<Integer>();
		if("sender".equals(currentPanel)){
			//查询指定发起人，用于查询指定发起人的时候查询比较复杂，所以采用HQL的方式进行查询，其他情况维持原来的逻辑不变
            String tempStr = preference.get(currentPanel+"_value");
            affairs=(List<CtpAffair>)affairManager.getAffairListBySender(memberId, tempStr, condition, false,fp,appEnum);
		}else{
			affairs=condition.getAffairsIsOverTime(affairManager,fp,isOverTime);
		}
		return affairs;
	}

	/**
	 * 首页会议召开时间显示
	 * @param beginDate
	 * @param endDate
	 * @return
	 */
	public String convertMeetingTime(java.util.Date beginDate, java.util.Date endDate) {
		StringBuffer displayDate = new StringBuffer();
		java.util.Date todayDate = new java.util.Date();
		java.util.Date tomorrowDate = new java.util.Date(todayDate.getTime()+24*60*60*1000);
		//今日会议
		if(isTheSameDay(beginDate, todayDate)) {
			displayDate.append(ResourceUtil.getString("menu.tools.calendar.today"));//今日
			displayDate.append(Datetimes.format(beginDate,"HH:mm"));
			displayDate.append(" - ");
			if(isTheSameDay(endDate, todayDate)){//开始、结束时间是同一天
				displayDate.append(Datetimes.format(endDate,"HH:mm"));
			}else if(isTheSameDay(endDate, tomorrowDate)){//今天开始，明天结束
				if(isTheSameYear(beginDate, endDate)){//开始结束时间是在同一年
					displayDate.append(ResourceUtil.getString("menu.tools.calendar.tomorrow"));//明日
					displayDate.append(Datetimes.format(endDate,"HH:mm"));
				}else{
					displayDate.append(Datetimes.format(endDate,"yyyy-MM-dd HH:mm"));
				}
			}else{
				displayDate.append(Datetimes.format(endDate,"MM-dd HH:mm"));
			}
		}
		//明日会议
		else if(isTheSameDay(beginDate, tomorrowDate)) {
			displayDate.append(ResourceUtil.getString("menu.tools.calendar.tomorrow"));//明日
			displayDate.append(Datetimes.format(beginDate,"HH:mm"));
			displayDate.append(" - ");
			if(isTheSameDay(endDate, tomorrowDate)){//明天开始，明天结束
				displayDate.append(ResourceUtil.getString("menu.tools.calendar.tomorrow"));//明日
				displayDate.append(Datetimes.format(endDate,"HH:mm"));
			}else{
				displayDate.append(Datetimes.format(endDate,"MM-dd HH:mm"));
			}
		}
		//某日
		else  {
			displayDate.append(Datetimes.format(beginDate,"yyyy-MM-dd HH:mm"));
			displayDate.append(" - ");
			displayDate.append(Datetimes.format(endDate,"MM-dd HH:mm"));
		}
		return displayDate.toString();
	}

	/**
	 * 两个时间是否为同一天
	 * @param oneDay
	 * @param twoDate
	 * @return
	 */
	@SuppressWarnings("deprecation")
	public boolean isTheSameDay(java.util.Date oneDay, java.util.Date twoDate) {
		return oneDay.getYear()==twoDate.getYear() && oneDay.getMonth()==twoDate.getMonth() && oneDay.getDate()==twoDate.getDate();
	}
	/**
	 * 判断两天是否是在同一年
	 * @param oneDay
	 * @param twoDate
	 * @return
	 */
	public boolean isTheSameYear(java.util.Date oneDay, java.util.Date twoDate) {
		return oneDay.getYear()==twoDate.getYear();
	}

	@Override
	public int getAgentPendingCount(long memberId) throws BusinessException {
		// TODO Auto-generated method stub
		return 0;
	}
	public static String getMenuIdByApp(int appEnum)
	{
		String menuResource = "";
		if(appEnum==ApplicationCategoryEnum.edocSend.getKey())
		{
		    menuResource="F07_sendManager";
		}
		else if(appEnum==ApplicationCategoryEnum.edocRec.getKey() || appEnum==ApplicationCategoryEnum.edocRegister.getKey())
		{
		    menuResource="F07_recManager";
		}
		else if(appEnum==ApplicationCategoryEnum.edocSign.getKey())
		{
		    menuResource="F07_signReport";
		}
		else if(appEnum==ApplicationCategoryEnum.exSend.getKey() || appEnum==ApplicationCategoryEnum.exSign.getKey())
		{//公文交换菜单
		    menuResource="F07_edocExchange";
		}
		return menuResource;
	}

	private Map<String, String> getMeetingPendingCount(List<CtpAffair> meetingAppAffairList) throws BusinessException {
		Map<String, String> countMap = new HashMap<String, String>();
		try {
			List<CtpAffair> joinList = new ArrayList<CtpAffair>();
			List<CtpAffair> unJoinList = new ArrayList<CtpAffair>();
			List<CtpAffair> pendingList = new ArrayList<CtpAffair>();
			if (Strings.isNotEmpty(meetingAppAffairList)) {
				for (CtpAffair ctpAffair : meetingAppAffairList) {
					if (ctpAffair.getMemberId().longValue() == ctpAffair.getSenderId().longValue()) {
						joinList.add(ctpAffair);
					}
					else {
						if (ctpAffair.getState() == StateEnum.mt_unAttend.key()) {// 不参加
							unJoinList.add(ctpAffair);
						}
						else {
							if (ctpAffair.getSubState() == SubStateEnum.meeting_pending_join.key()) {// 参加
								joinList.add(ctpAffair);
							}
							else if (ctpAffair.getSubState() == SubStateEnum.meeting_pending_unJoin.key()) {// 不参加
								unJoinList.add(ctpAffair);
							}
							else if (ctpAffair.getSubState() == SubStateEnum.meeting_pending_pause.key()) {// 待定
								pendingList.add(ctpAffair);
							}
						}
					}
				}
			}
			countMap.put("joinCount", String.valueOf(joinList.size()));
			countMap.put("unjoinCount", String.valueOf(unJoinList.size()));
			countMap.put("pendingCount", String.valueOf(pendingList.size()));
			countMap.put("allCount", String.valueOf(meetingAppAffairList.size()));
		} catch (Exception e) {
			log.info("m3首页获取会议状态出错", e);
		}
		return countMap;
	}
	
	public  void ListSort(List<PendingRow> list) {
        Collections.sort(list, new Comparator<PendingRow>() {
            public int compare(PendingRow o1, PendingRow o2) {
            //SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	            try {
	            	Date dt1 = null;
	            	if(o1.getReceiveTimeAll()==null || "".equals( o1.getReceiveTimeAll() )){
	            		//o1.getCompleteTime().replace("今日", format.format(new Date()));
	            		dt1 = sdf.parse(o1.getCompleteTime());
	            	}else{
	            		dt1 = sdf.parse(o1.getReceiveTimeAll());
	            	}
	            	
	            	Date dt2 = null;
	            	if(o2.getReceiveTimeAll()==null || "".equals( o2.getReceiveTimeAll() ) ){
	            		//o2.getCompleteTime().replace("今日", format.format(new Date()));
	            		dt2 = sdf.parse(o2.getCompleteTime());
	            	}else{
	            		dt2 = sdf.parse(o2.getReceiveTimeAll());
	            	}
            	
	                if (dt1.getTime() < dt2.getTime()) {
	                    return 1;
	                } else if (dt1.getTime() > dt2.getTime()) {
	                    return -1;
	                } else {
	                    return 0;
	                }
                } catch (Exception e) {
               	 log.error("待办数据时间比较异常",e);
                }
                return 0;
            }
        });
    }
	
}
