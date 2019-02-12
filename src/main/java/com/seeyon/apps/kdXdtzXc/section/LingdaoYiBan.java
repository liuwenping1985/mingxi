
package com.seeyon.apps.kdXdtzXc.section;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.collaboration.enums.CollaborationEnum;
import com.seeyon.apps.collaboration.manager.PendingManager;
import com.seeyon.apps.collaboration.util.ColUtil;
import com.seeyon.apps.custom.manager.CustomManager;
import com.seeyon.apps.edoc.api.EdocApi;
import com.seeyon.apps.edoc.enums.EdocEnum;
import com.seeyon.apps.taskcenter.Manager.TaskCenterManager;
import com.seeyon.apps.taskcenter.bo.CenterTaskBO;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.ApplicationSubCategoryEnum;
import com.seeyon.ctp.common.content.affair.AffairCondition;
import com.seeyon.ctp.common.content.affair.AffairCondition.SearchCondition;
import com.seeyon.ctp.common.content.affair.AffairExtPropEnums;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.AffairUtil;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.flag.SysFlag;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.template.CtpTemplate;
import com.seeyon.ctp.common.po.template.CtpTemplateCategory;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.common.template.manager.TemplateManager;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.portal.section.BaseSectionImpl;
import com.seeyon.ctp.portal.section.CommonAffairSectionUtils;
import com.seeyon.ctp.portal.section.SectionProperty;
import com.seeyon.ctp.portal.section.SectionReference;
import com.seeyon.ctp.portal.section.SectionReferenceValueRange;
import com.seeyon.ctp.portal.section.templete.BaseSectionTemplete;
import com.seeyon.ctp.portal.section.templete.BaseSectionTemplete.OPEN_TYPE;
import com.seeyon.ctp.portal.section.templete.MultiRowVariableColumnTemplete;
import com.seeyon.ctp.portal.section.templete.mobile.MListTemplete;
import com.seeyon.ctp.portal.section.util.SectionUtils;
import com.seeyon.ctp.portal.util.PortletPropertyContants.PropertyName;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.Strings;
import com.seeyon.v3x.common.manager.ConfigGrantManager;
import com.seeyon.v3x.common.web.login.CurrentUser;
import com.seeyon.v3x.worktimeset.manager.WorkTimeManager;

/**
 * @author zhaifeng
 *  已办事项栏目
 */
public class LingdaoYiBan extends BaseSectionImpl {
    private static final Log log = LogFactory.getLog(LingdaoYiBan.class);
    private AffairManager affairManager;
    private ConfigGrantManager configGrantManager;
    private WorkTimeManager workTimeManager;
    private EdocApi edocApi;
    private PendingManager pendingManager;
    private CommonAffairSectionUtils commonAffairSectionUtils;
    
    private TemplateManager templateManager;

	public void setTemplateManager(TemplateManager templateManager) {
		this.templateManager = templateManager;
	}

	public EdocApi getEdocApi() {
		return edocApi;
	}

	public void setEdocApi(EdocApi edocApi) {
		this.edocApi = edocApi;
	}

    public WorkTimeManager getWorkTimeManager() {
        return workTimeManager;
    }

    public void setWorkTimeManager(WorkTimeManager workTimeManager) {
        this.workTimeManager = workTimeManager;
    }

    public void setAffairManager(AffairManager affairManager) {
        this.affairManager = affairManager;
    }

    public void setConfigGrantManager(ConfigGrantManager configGrantManager) {
        this.configGrantManager = configGrantManager;
    }

    public void setPendingManager(PendingManager pendingManager) {
		this.pendingManager = pendingManager;
	}

    public CommonAffairSectionUtils getCommonAffairSectionUtils() {
		return commonAffairSectionUtils;
	}

	public void setCommonAffairSectionUtils(CommonAffairSectionUtils commonAffairSectionUtils) {
		this.commonAffairSectionUtils = commonAffairSectionUtils;
	}

	@Override
    public void init() {
    	super.init();
    	if (AppContext.hasPlugin("edoc")) {
    		return;
    	}
    	
    	//不展示公文相关配置信息
    	List<SectionProperty> properties = this.getProperties();
    	for (SectionProperty sp : properties) {
    		SectionReference[] references = sp.getReference();
    		for (SectionReference ref : references) {
    			if ("rowList".equals(ref.getName())) {
    				SectionReferenceValueRange[] valueRanges = ref.getValueRanges();
    				List<SectionReferenceValueRange> result = new ArrayList<SectionReferenceValueRange>(); 
    				for (SectionReferenceValueRange val : valueRanges) {
    					if (!"edocMark".equals(val.getValue()) && !"sendUnit".equals(val.getValue())) {
    						result.add(val);
    					}
    				}
    				ref.setValueRanges(result.toArray(new SectionReferenceValueRange[0]));
    			}
    		}
    	}
    }
    
    @Override
    public String getIcon() {
        return null;
    }

    @Override
    public String getId() {
        //栏目ID，与配置文件中的ID相同
        return "lingdaoYiBan";
    }
    
    @Override
    public boolean isAllowUsed() {
        /*User user = AppContext.getCurrentUser();
        if (user.isV5Member()) {
            return true;
        } else {
            return AppContext.isAdmin() || AppContext.hasResourceCode("F01_listDone");
        }*/
    	
    	boolean useFlag = false;
    	User user = CurrentUser.get();
    	CustomManager customManager = (CustomManager) AppContext.getBean("customManager");
        List<Long> secretary = customManager.queryallSecretary();
        for(long l:secretary){
        	if(user.getId()==l){
        		useFlag = true;
 				break;
 			}
        }
        return useFlag || user.isAdmin();
    }

    @Override
    public String getName(Map<String, String> preference) {
        return "领导已办";
    }

    public Integer getTotal(Map<String, String> preference) {
    	return null;
    }
    
    @Override
    public BaseSectionTemplete projection(Map<String, String> preference) {
        String rowStr = preference.get("rowList");
        boolean isGroupBy = true;
        // 数据显示
        String dateList = preference.get("dateList");
        //判断是否选择‘同一流程只显示最后一条 ’
        if (Strings.isBlank(dateList)) {
            isGroupBy = false;
        } else {
            isGroupBy = true;
        }
        //传到更多页面时，发起时间、处理期限是必须显示的，而不是通过配置的，同时为了保证顺序问题，因此要如此处理(将deadline放到category前面)
        if (Strings.isBlank(rowStr)) {
        	rowStr = "subject,createDate,receiveTime,sendUser,deadline,category";
        }else{
        	//如果rowStr 不为空的 要添加 处理期限,并且要放到category之前
        	int index1 = rowStr.indexOf(",category");
        	if(index1 != -1){
        		rowStr = rowStr.substring(0,index1)+",deadline,category";
        	}else{
        		rowStr = rowStr + ",deadline";
        	}
        	//添加 发起时间  放到标题之后
        	rowStr = rowStr.substring(0,8) + "createDate," + rowStr.substring(8);
        }
        
        AffairCondition condition = new AffairCondition();
        FlipInfo fi = new FlipInfo();
        fi.setNeedTotal(false);
        // 显示行数
        String count = preference.get("count");
        //默认行数
        int coun = 8;
        if (Strings.isNotBlank(count)) {
            coun = Integer.parseInt(count);
        }
        fi.setSize(coun);

        fi.setNeedTotal(false);
        List<CtpAffair> affairs = new ArrayList<CtpAffair>();
		try {
			affairs = this.querySectionAffair(condition, fi, preference);
		} catch (BusinessException e1) {
			log.error("",e1);
		}
        String s =   "";
        try {
			s = URLEncoder.encode(this.getName(preference), "UTF-8");
		} catch (UnsupportedEncodingException e) {
			log.error("",e);
			
		}
        MultiRowVariableColumnTemplete c = this.getTemplete(affairs, preference);
        //【更多】
        c.addBottomButton(BaseSectionTemplete.BOTTOM_BUTTON_LABEL_MORE,"/lingDaoDaiBanController.do?method=listallDoneAffair",null,"sectionMoreIco");
        c.setDataNum(coun);
        return c;
    }
    
    /**
     * 根据条件查询列表
     * @param affairCondition
     * @param fi
     * @param preference
     * @return
     * @throws BusinessException 
     */
    private List<CtpAffair> querySectionAffair(AffairCondition affairCondition,FlipInfo fi,Map<String, String> preference) throws BusinessException{
    	Long memberId = AppContext.getCurrentUser().getId();
    	
    	Map<String, Object> map = new HashMap<String, Object>();
        CustomManager customManager = (CustomManager) AppContext.getBean("customManager");
        map = customManager.isSecretary();
        if(map.get("leaderID")!=null && !"".equals(map.get("leaderID"))){
        	memberId = Long.valueOf(map.get("leaderID")+"");
		}
    	
        affairCondition.setMemberId(memberId);
        String panel = SectionUtils.getPanel("all", preference);
        
        boolean isGroupBy = true;
        boolean isProtal = false;
        // 数据显示
        String dateList = preference.get("dateList");
        //判断是否选择‘同一流程只显示最后一条 ’
        if (Strings.isBlank(dateList)) {
            isGroupBy = false;
        } else {
            isGroupBy = true;
            isProtal = true;
        }
        
        // 流程来源
        if(!"all".equals(panel)) {
        	if(Strings.isNotBlank(panel) && "sources".equals(panel)){
        		affairCondition.addSourceSearchCondition(preference,false);
        	}else{
        	  String tempStr=preference.get(panel+"_value");
              if(Strings.isNotBlank(tempStr)){
            	// 组装查询条件
                if("track_catagory".equals(panel)){//分类
                    affairCondition.addSearch(SearchCondition.catagory, tempStr, null);
                }else if("importLevel".equals(panel)){//重要程度
                    affairCondition.addSearch(SearchCondition.importLevel, tempStr, null);
                    //已办 重要程度，排除会议
                    affairCondition.addSearch(SearchCondition.catagory, "done_catagory_all", null);
                }
                else if("templete_pending".equals(panel)){
                    affairCondition.addSearch(SearchCondition.templete, tempStr, null);
                }
                else if("Policy".equals(panel)){
                    affairCondition.addSearch(SearchCondition.policy4Portal, tempStr, null);
                }
                else if("sender".equals(panel)){
                    affairCondition = new AffairCondition(memberId, StateEnum.col_done,
                            ApplicationCategoryEnum.collaboration,
                            ApplicationCategoryEnum.edoc,
                            ApplicationCategoryEnum.meeting);
                    int pageSize = 8;
                    String countStr = preference.get("count");
                    if (Strings.isNotBlank(countStr)) {
                        pageSize = Integer.parseInt(countStr);//设置行数
                    }
                    String columnStyle=preference.get("columnStyle");
                    
                    if("doubleList".equals(columnStyle)){
                        pageSize=pageSize*2;
                    }
                    fi = new FlipInfo();
                    fi.setNeedTotal(false);
                    fi.setPage(1);
                    fi.setSize(pageSize);
                    List<Integer> appEnum=new ArrayList<Integer>();
                    //查询指定发起人
                    return (List<CtpAffair>)affairManager.getAffairListBySender(memberId, tempStr, affairCondition, false,fi,appEnum,isGroupBy);
                }
            }else{
            	return new ArrayList<CtpAffair>();
            }
          }
        }else{
        	//'全部'，但要排除掉会议 详见：AffaiCondition的initSearch()
        	affairCondition.addSearch(SearchCondition.catagory, "done_catagory_all", null);
        }
        
      
        List<CtpAffair> affairs = null;
        if(isGroupBy){
        	affairs = (List<CtpAffair>) affairManager.getDeduplicationAffairs(memberId, affairCondition, false, fi);
        }else{
        	affairs = affairCondition.getSectionAffair(affairManager,StateEnum.col_done.key(),fi,isGroupBy,isProtal);
        }
        if(null == affairs){
        	affairs = new ArrayList<CtpAffair>();
        }
           
        return affairs;
    }
    /**
     * 获得列表模版
     * @param affairs
     * @return
     */
    private MultiRowVariableColumnTemplete getTemplete(List<CtpAffair> affairs,Map<String, String> preference){
        //User user = AppContext.getCurrentUser();
        MultiRowVariableColumnTemplete c = new MultiRowVariableColumnTemplete();
        String widthStr=preference.get("width");
        int width=10;
        if(Strings.isNotBlank(widthStr)){
        	width=Integer.valueOf(widthStr);
        }
        // 显示列
        String rowStr = preference.get("rowList");
        if (Strings.isBlank(rowStr)) {
        	//客开 start
            /*if (user.isV5Member()) {
                rowStr = "subject,receiveTime,sendUser,category";
            } else {
                rowStr = "subject,receiveTime,sendUser";
            }*/
        	rowStr = "category,subject,receiveTime,currentNodesInfo";// 20180524
        	//客开 end
        }
        String[] rows = rowStr.split(",");
        List<String> list = Arrays.asList(rows);
        //判断是否选择‘标题’
        boolean isSubject = list.contains("subject");
        //判断是否选择‘上一处理人’
        boolean isPreApproverName = list.contains("preApproverName");
        //判断是否选择‘处理时间/召开时间’
        boolean isCompleteTime = list.contains("receiveTime");
        //判断是否选择'公文文号'
        boolean isEdocMark = list.contains("edocMark");
        //判断是否选择'发文单位'
        boolean isSendUnit = list.contains("sendUnit");
        //判断是否选择‘发起人’
        boolean isSendUser = list.contains("sendUser");
        //判断是否选择‘分类’
        boolean isCategory = list.contains("category");
        //判断是否选择‘当前待办人’
        boolean isCurrentNodesInfo = list.contains("currentNodesInfo");
        
        Boolean isGov = (Boolean)(SysFlag.is_gov_only.getFlag());
        if(isGov == null){
            isGov = false;
        }
        boolean mtAppAuditFlag = true;
        boolean hasMtAppAuditGrant = false;
        boolean edocDistributeFlag = true;
        boolean hasEdocDistributeGrant = false;
        //默认为8条记录
        int count = 8;
      //客开 gxy 20180511 栏目固定显示条数 start
        /*String coun = preference.get("count");
        if(Strings.isNotBlank(coun)){
            count = Integer.parseInt(coun);
        }
        if(null != affairs){
        	//count=affairs.size();//新需求，不加空行了
        }*/
      //客开 gxy 20180511 栏目固定显示条数 end
        
        //客开 start
        MultiRowVariableColumnTemplete.Row rowsub = c.addRow();
		MultiRowVariableColumnTemplete.Cell subrows = rowsub.addCell();
		subrows.setAlt("任务来源");
		subrows.setCellContent("任务来源");
		subrows.setClassName("font_bold");
		subrows.setCellWidth(20);
		
		MultiRowVariableColumnTemplete.Cell subrows1 = rowsub.addCell();
		subrows1.setAlt("标题");
		subrows1.setCellContent("标题");
		subrows1.setClassName("font_bold");
		subrows1.setCellWidth(40);
		
		MultiRowVariableColumnTemplete.Cell subrows2 = rowsub.addCell();
		subrows2.setAlt("处理时间");
		subrows2.setCellContent("处理时间");
		subrows2.setClassName("font_bold");
		subrows2.setCellWidth(20);
		
		MultiRowVariableColumnTemplete.Cell subrows3 = rowsub.addCell();
		subrows3.setAlt("当前待办人");
		subrows3.setCellContent("当前待办人");
		subrows3.setClassName("font_bold");
		subrows3.setCellWidth(20);
		//客开 end
        
		Map<Long,String> currentNodeInfos = commonAffairSectionUtils.parseCurrentNodeInfos(affairs);
        
        try {
        	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm");
            TaskCenterManager taskCenterManager = (TaskCenterManager) AppContext.getBean("taskCenterManager");
            FlipInfo flipInfo = new FlipInfo(0, SectionUtils.getSectionCount(8, preference));
            
            Map<String, Object> map = new HashMap<String, Object>();
            CustomManager customManager = (CustomManager) AppContext.getBean("customManager");
            OrgManager orgManager = (OrgManager) AppContext.getBean("orgManager");
            map = customManager.isSecretary();
            String leaderName = "";
            if(map.get("leaderID")!=null && !"".equals(map.get("leaderID"))){
            	V3xOrgMember member = orgManager.getMemberById(Long.valueOf(map.get("leaderID")+""));
     			leaderName = member.getLoginName();
    		}
            Map<String, String> par = new HashMap<String, String>();
			par.put("leaderName", leaderName);
            List<CenterTaskBO> ctlist = taskCenterManager.listmydoneTask(flipInfo, par).getData();
            for (CenterTaskBO data : ctlist) {
            	CtpAffair cf = new CtpAffair();
            	cf.setSubject(data.getSubject());
            	cf.setIdentifier(data.getFlowName());
            	cf.setCompleteTime(format.parse(data.getSubmitTime()));
            	cf.setExtProps("javascript:function openwin(){openCtpWindow({'url':'"+data.getLinkPath()+"'});return;};openwin();");
            	affairs.add(cf);
            }
            ListSort(affairs);
		} catch (Exception e) {
			log.error("获取已办数据异常", e);
		}
        
        for(int i = 0;i < count-1;i++){
            MultiRowVariableColumnTemplete.Row row = c.addRow();
        	//标题
            MultiRowVariableColumnTemplete.Cell subjectCell = null;
            //上一处理人
            MultiRowVariableColumnTemplete.Cell preApproverNameCell = null;
            //处理时间
            MultiRowVariableColumnTemplete.Cell completeTimeCell = null;
            //公文文号
            MultiRowVariableColumnTemplete.Cell edocMarkCell = null;
            //发文单位
            MultiRowVariableColumnTemplete.Cell sendUnitCell = null;
            //发起人
            MultiRowVariableColumnTemplete.Cell createMemberCell = null;
            //分类
            MultiRowVariableColumnTemplete.Cell categoryCell = null;
            //当前待办人
            MultiRowVariableColumnTemplete.Cell currentNodesInfoCell=null;
           
            //客开 start
            if(isCategory){
            	categoryCell = row.addCell();
            	categoryCell.setCellWidth(20);
            	categoryCell.setCellContentWidth(20);
            }
            //客开 end
            
            if(isSubject){
            	subjectCell = row.addCell();
            }
            if(isCompleteTime){
            	completeTimeCell = row.addCell();
            	//客开 start
            	completeTimeCell.setCellWidth(20);
            	completeTimeCell.setCellContentWidth(20);
            	//客开 end
            }
            if(isEdocMark){
            	edocMarkCell = row.addCell();
            }
            if(isSendUnit){
            	sendUnitCell = row.addCell();
            }
            if(isCurrentNodesInfo){
            	currentNodesInfoCell=row.addCell();
            	currentNodesInfoCell.setCellWidth(20);
            	currentNodesInfoCell.setCellContentWidth(20);
            }
            if(isSendUser){
            	createMemberCell = row.addCell();
            }
            if(isPreApproverName){
            	preApproverNameCell = row.addCell();
            }
            /*if(isCategory){
            	categoryCell = row.addCell();
            }*/
            
            //如果为空则添加默认空行
            if(affairs == null || affairs.size() == 0){
            	continue;
            }
            if(i < affairs.size()) {
                CtpAffair affair = affairs.get(i);
                
                //客开 start 
                if(affair.getId()==null){
                	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm");
                	
                	categoryCell.setCellContent(affair.getIdentifier());
                	categoryCell.setAlt(affair.getIdentifier());
                	categoryCell.setOpenType(BaseSectionTemplete.OPEN_TYPE.openWorkSpace);
                	categoryCell.setLinkURL(affair.getExtProps());
                	categoryCell.setCellWidth(20);
                	
                	subjectCell.setCellContent(affair.getSubject());
                	subjectCell.setAlt(affair.getSubject());
                	subjectCell.setOpenType(BaseSectionTemplete.OPEN_TYPE.openWorkSpace);
                	subjectCell.setLinkURL(affair.getExtProps());
                	subjectCell.setCellWidth(40);
                	
                	completeTimeCell.setCellContent(format.format(affair.getCompleteTime()));
                	completeTimeCell.setAlt(format.format(affair.getCompleteTime()));
                	completeTimeCell.setOpenType(BaseSectionTemplete.OPEN_TYPE.openWorkSpace);
                	completeTimeCell.setLinkURL(affair.getExtProps());
                	completeTimeCell.setCellWidth(20);
                	
                	currentNodesInfoCell.setCellContent("");
                	currentNodesInfoCell.setAlt("");
                	currentNodesInfoCell.setOpenType(BaseSectionTemplete.OPEN_TYPE.openWorkSpace);
                	currentNodesInfoCell.setLinkURL(affair.getExtProps());
                	currentNodesInfoCell.setCellWidth(20);
                }else{// 客开 end
                	String forwardMember = affair.getForwardMember();
                    Integer resentTime = affair.getResentTime();
                    String subject = ColUtil.showSubjectOfAffair(affair, false, -1).replaceAll("\r\n", "").replaceAll("\n", "");
                    //设置标题代理信息
                    if(Integer.valueOf(StateEnum.col_done.key()).equals(affair.getState())){
                    	subject = ColUtil.showSubjectOfSummary4Done(affair, -1);
                    }
                    if(isSubject){
                    	String showName = ColUtil.mergeSubjectWithForwardMembers(affair.getSubject(), forwardMember, resentTime,null,-1);
                        if(affair.getAutoRun() != null && affair.getAutoRun()){
                        	showName = ResourceUtil.getString("collaboration.newflow.fire.subject",showName);
                        	subject = ResourceUtil.getString("collaboration.newflow.fire.subject",subject);
                        }
                    	subjectCell.setAlt(showName);
                        
                        /*subjectCell.setCellWidth(100);
                        int cellWidth = 50;
                        if(rows.length == 3) {
                        	cellWidth = 65;
                        }else if(rows.length == 2) {
                        	cellWidth = 90;
                        }else if(rows.length == 1){
                        	cellWidth = 100;
                        }
                        subjectCell.setCellContentWidth(cellWidth);*/
                    	subjectCell.setCellWidth(40);
                    	subjectCell.setCellContentWidth(40);
                    	
                        //设置重要程度图标
                        if(affair.getImportantLevel() != null && affair.getImportantLevel() > 1  && affair.getImportantLevel() < 6){
                            subjectCell.addExtPreClasses("ico16 important"+affair.getImportantLevel()+"_16");
                        }
                        //设置附件图标
                        if(AffairUtil.isHasAttachments(affair)){
                        	subjectCell.addExtClasses("ico16 affix_16");
                        }
                        Map<String, Object> extMap = Strings.escapeNULL(AffairUtil.getExtProperty(affair),new HashMap<String, Object>());
                        if(extMap!=null && extMap.get(AffairExtPropEnums.meeting_videoConf.name()) != null) {
                        	String meetingNature = (String)extMap.get(AffairExtPropEnums.meeting_videoConf.name());
                        	//会议方式 1普通会议 2视频会议
                        	if("2".equals(meetingNature)) {
                        		subjectCell.addExtClasses("ico16 meeting_video_16");
                        	}
                        }
                        
                        //设置正文类型图标
                        if(affair.getBodyType() != null && !"10".equals(affair.getBodyType()) && !"30".equals(affair.getBodyType()) && !"HTML".equals(affair.getBodyType())){
                            String bodyType = affair.getBodyType();
                            String bodyTypeClass = convertPortalBodyType(bodyType);
                            if(!"html_16".equals(bodyTypeClass)) {
                            	subjectCell.addExtClasses("ico16 "+bodyTypeClass);
                            }
                        }
                        //流程状态
                        if(Integer.valueOf(CollaborationEnum.flowState.finish.ordinal()).equals(affair.getSummaryState())){
                        	subjectCell.addExtPreClasses("ico16 flow3_16");
                        }else if(Integer.valueOf(CollaborationEnum.flowState.terminate.ordinal()).equals(affair.getSummaryState())){
                        	subjectCell.addExtPreClasses("ico16 flow1_16");
                        }
                        subjectCell.setCellContent(subject.replaceAll("\\r\\n", ""));
                    }
                    int app = affair.getApp();
                    String url = "";
                    
                    //客开 2018-03-23 gxy start
                    String categoryName="";
                    try {
                    	CtpTemplateCategory clc = null;
                    	CtpTemplate ctpTemplate = null;
        				if(affair.getTempleteId()!=null && !"".equals(affair.getTempleteId()) && !"null".equals(affair.getTempleteId()) ){
        					ctpTemplate = templateManager.getCtpTemplate(Long.valueOf(affair.getTempleteId()));
        					clc = templateManager.getCtpTemplateCategory(ctpTemplate.getCategoryId());
        					if("发文模版".equals(clc.getName())){
        						if("-2066523224662719456".equals(ctpTemplate.getId()+"") ){
            						categoryName = "部门发文";
            					}else{
            						categoryName = "公司发文";
            					}
        					 //客开 2018-07-03 赵培珅 任务来源显示错误 start 	
        					}else if("收文模版".equals(clc.getName())){
        							categoryName = "收文处理";
        					}else{
        						categoryName = clc.getName();
        					}
        					if("2135462982126750833".equals(ctpTemplate.getId()+"") ){
        						categoryName = "签报";
        					}
        					 //客开 2018-07-03 赵培珅 任务来源显示错误 end 
        				}else{
        					categoryName = ResourceUtil.getString("application."+app+".label");
        				}
					} catch (Exception e) {
						log.error("获取任务来源异常",e);
					}
                    //客开 2018-03-23 gxy end
                    
                    ApplicationCategoryEnum appEnum = ApplicationCategoryEnum.valueOf(app);
                    String from = null;
                    switch (StateEnum.valueOf(affair.getState())) {
                        case col_sent: from = "Sent"; break;
                        case col_pending: from = "Pending"; break;
                        case col_done: from = "Done"; break;
                        default: from = "Done";
                    }
                    switch (appEnum) {
                        case collaboration:
                        	if(subjectCell != null){
                        		subjectCell.setLinkURL("/collaboration/collaboration.do?method=summary&openFrom=listDone&affairId=" + affair.getId());
                        	}
                        	if(categoryCell != null){
                        		//判断是否有资源菜单权限
                        		//boolean hasResPerm = pendingManager.hasResPerm(affair, user);
                        		//if(hasResPerm){
                        			url = AppContext.getRawRequest().getContextPath() + "/collaboration/collaboration.do?method=listDone";
                            		categoryName = "<a href="+url+">"+categoryName+"</a>";
                        		//}
                        		categoryCell.setCellContentHTML(categoryName);
                        	}
                        	
                        	if(isPreApproverName){
                        		preApproverNameCell.setCellContentHTML(ColUtil.getMemberName(affair.getPreApprover()));
                        	}
                        	
                        	
                            break;
                        case meeting:
                        	String linkURL = "";
                            if(affair.getSubApp() == ApplicationSubCategoryEnum.meetingAudit.key()) {//会议审核
                                linkURL = "/mtAppMeetingController.do?method=mydetail&id=" + affair.getObjectId()+"&affairId="+affair.getId();
                                if(mtAppAuditFlag) {
                                    //hasMtAppAuditGrant = configGrantManager.hasConfigGrant(user.getLoginAccount(), user.getId(), "v3x_meeting_create_acc", "v3x_meeting_create_acc_review");
                                	hasMtAppAuditGrant = false;//兼容老G6数据升级，因为v5会议已经没有会议审核功能，故这里不允许链接
                                }
                                if(hasMtAppAuditGrant) {
                                    url = AppContext.getRawRequest().getContextPath() + "/mtMeeting.do?method=entryManager&entry=meetingManager&listMethod=listAudit&listType=listAppAuditingMeetingAudited";
                                }
                                mtAppAuditFlag = false;
                            }else if(affair.getSubApp() == ApplicationSubCategoryEnum.minutesAudit.key()){//会议纪要
                            	linkURL = "/mtSummary.do?method=mydetail&recordId=" + affair.getObjectId()+"&affairId="+affair.getId();
                                url = AppContext.getRawRequest().getContextPath() + "/mtSummary.do?method=listHome&from=audit&listType=audited";
                            }else if(affair.getSubApp() == ApplicationSubCategoryEnum.meetingNotification.key()){//会议通知
                            	linkURL = "/mtMeeting.do?method=mydetail&id="+affair.getObjectId();
                                url = AppContext.getRawRequest().getContextPath() + "/meetingNavigation.do?method=entryManager&entry=meetingDone";
                            }
                            if(subjectCell != null){
                            	subjectCell.setLinkURL(linkURL);
                            }
                            if(categoryCell != null){
                                String meetingCategory = ResourceUtil.getString("pending.meeting.label");
                        		String category = "<a href="+url+">"+meetingCategory+"</a>";
                        		categoryCell.setCellContentHTML(category);
                            }
                            break;
                        case meetingroom:
                        	if(subjectCell != null){
                        		subjectCell.setLinkURL("/meetingroom.do?method=createPerm&openWin=1&id="+affair.getObjectId());
                        	}
                        	if(categoryCell != null){
                        		url = AppContext.getRawRequest().getContextPath() + "/meetingroom.do?method=index";
                        		String category = null;
                        		//if(user.hasResourceCode("F09_meetingDone")){
                        		    category = "<a href="+url+">"+categoryName+"</a>";
                        		/*}
                        		else{
                        		    category = categoryName;
                        		}*/
                        		categoryCell.setCellContentHTML(category);
                        	}
                            break;
                        case edocSend:
                        	if(subjectCell != null){
                        		subjectCell.setLinkURL("/edocController.do?method=detailIFrame&from=" + from + "&affairId=" + affair.getId() + "");
                        	}
                        	if(categoryCell != null){
                        		//判断是否有资源菜单权限
                        	    //if(user.hasResourceCode("F07_sendManager")){
                        	        url = AppContext.getRawRequest().getContextPath() + "/edocController.do?method=entryManager&entry=sendManager&listType=listDoneAll";
                        	        categoryName = "<a href="+url+">"+categoryName+"</a>";
                        	    //}
                        		
                        		categoryCell.setCellContentHTML(categoryName);
                        	}
                        	getEdocExtField(affair, edocMarkCell, sendUnitCell, width);
                        	if(isPreApproverName){
                        		preApproverNameCell.setCellContentHTML(ColUtil.getMemberName(affair.getPreApprover()));
                        	}
                            break;
                        case edocRec:
                        	if(subjectCell != null){
                        		subjectCell.setLinkURL("/edocController.do?method=detailIFrame&from=" + from + "&affairId=" + affair.getId() + "");
                        	}
                        	if(categoryCell != null){
                        		//判断是否有资源菜单权限
                        	    //if(user.hasResourceCode("F07_recManager")){
                        			url = AppContext.getRawRequest().getContextPath() + "/edocController.do?method=entryManager&entry=recManager&listType=listDoneAll&objectId=" + affair.getObjectId();
                        			categoryName = "<a href="+url+">"+categoryName+"</a>";
                        	    //}
                        		
                        		categoryCell.setCellContentHTML(categoryName);
                        	}
                        	getEdocExtField(affair, edocMarkCell, sendUnitCell, width);
                        	if(isPreApproverName){
                        		preApproverNameCell.setCellContentHTML(ColUtil.getMemberName(affair.getPreApprover()));
                        	}
                            break;
                        case edocSign:
                        	if(subjectCell != null){
                        		subjectCell.setLinkURL("/edocController.do?method=detailIFrame&from=" + from + "&affairId=" + affair.getId() + "");
                        	}
                        	if(categoryCell != null){
                        		//判断是否有资源菜单权限
                        	    //if(user.hasResourceCode("F07_signReport")){
                        			url = AppContext.getRawRequest().getContextPath() + "/edocController.do?method=entryManager&entry=signReport&listType=listDoneAll";
                        			categoryName = "<a href="+url+">"+categoryName+"</a>";
                        	   // }
                        		
                        		categoryCell.setCellContentHTML(categoryName);
                        	}
                        	getEdocExtField(affair, edocMarkCell, sendUnitCell, width);
                        	if(isPreApproverName){
                        		preApproverNameCell.setCellContentHTML(ColUtil.getMemberName(affair.getPreApprover()));
                        	}
                        	break;
                        case exSend:
                        case exSign:
                        case edocRegister://收文待登记
                        	if(subjectCell != null){
                        		subjectCell.setLinkURL("/edocController.do?method=detaiIFramel&from=" + from + "&affairId=" + affair.getId() + "");
                        	}
                        	if(categoryCell != null){
                        		//判断是否有资源菜单权限
                    			url = AppContext.getRawRequest().getContextPath() + "/edocController.do?method=entryManager&entry=recManager&listType=listV5RegisterDone";
                                categoryName = "<a href="+url+">"+categoryName+"</a>";
                        		
                        		categoryCell.setCellContentHTML(categoryName);
                        	}
                            getEdocExtField(affair, edocMarkCell, sendUnitCell, width);
                            break;
                        case edocRecDistribute:
                        	if(subjectCell != null){
                        		subjectCell.setLinkURL("/edocController.do?method=detailIFrame&from=Sent&&affairId=" + affair.getId(), OPEN_TYPE.href);
                        	}
                        	if(categoryCell != null){
                        		/*if(edocDistributeFlag) {
                                    try {
                                        hasEdocDistributeGrant = edocApi.isEdocCreateRole( user.getId(), user.getLoginAccount(),EdocEnum.edocType.distributeEdoc.ordinal());
                                    } catch(Exception e) {
                                        hasEdocDistributeGrant = false;
                                    }
                                }   
                                if(hasEdocDistributeGrant) {*/
                                    url = AppContext.getRawRequest().getContextPath() + "/edocController.do?method=entryManager&entry=recManager&listType=listSent";
                                //}
                                edocDistributeFlag = false;
                                String category = "<a href="+url+">"+categoryName+"</a>";
                        		categoryCell.setCellContentHTML(category);
                        	}
                            
                            getEdocExtField(affair, edocMarkCell, sendUnitCell, width);
                            break;              
                        case info:
                        	if(subjectCell != null){
                        		subjectCell.setLinkURL("/infoDetailController.do?method=detail&summaryId="+affair.getObjectId()+"&from=" + from + "&affairId=" + affair.getId() + "");
                        	}
                            url = AppContext.getRawRequest().getContextPath() + "/infoNavigationController.do?method=indexManager&entry=infoAuditing&toFrom=listInfoAuditDone&affairId="+affair.getObjectId();
                            if(categoryCell != null){
                            	String category = "<a href="+url+">"+categoryName+"</a>";
                        		categoryCell.setCellContentHTML(category);
                            }
                            break;
                        default:break;
                    }
                    //处理时间/召开时间
                    if(completeTimeCell != null){
                    	if(affair.getApp() == ApplicationCategoryEnum.meeting.key() || affair.getApp() == ApplicationCategoryEnum.meetingroom.key()){
                            //String dateTime = ColUtil.getDateTime(affair.getReceiveTime(), "yyyy-MM-dd HH:mm");
                            String dateTime = Datetimes.format(affair.getReceiveTime(), "yyyy-MM-dd HH:mm");//客开 修改时间显示格式
                            completeTimeCell.setCellContentHTML("<span class='color_gray' title='" + dateTime + "'>" + dateTime + "</span>");
                        }else {
                        	if(affair.getCompleteTime()!=null){
                        		//String dateTime = ColUtil.getDateTime(affair.getCompleteTime(), "yyyy-MM-dd HH:mm");
                        		String dateTime = Datetimes.format(affair.getCompleteTime(), "yyyy-MM-dd HH:mm");//客开 修改时间显示格式
                        		completeTimeCell.setCellContentHTML("<span class='color_gray' title='" + dateTime + "'>" + dateTime + "</span>");
                        	}
                        }
                    }
                    //当前处理人
                    List<Integer> edocApps =new ArrayList<Integer>(); 
                    edocApps.add(ApplicationCategoryEnum.edocSend.getKey());//发文 19
                    edocApps.add(ApplicationCategoryEnum.edocRec.getKey());//收文 20
                    edocApps.add(ApplicationCategoryEnum.edocSign.getKey());//签报21
                    edocApps.add(ApplicationCategoryEnum.exSend.getKey());//待发送公文22
                    edocApps.add(ApplicationCategoryEnum.exSign.getKey());//待签收公文 23
                    edocApps.add(ApplicationCategoryEnum.edocRegister.getKey());//待登记公文 24
                    edocApps.add(ApplicationCategoryEnum.edocRecDistribute.getKey());//收文分发34
                    
                    //客开 gxy 20180622 start 
                    String currentNodesInfoStr=currentNodeInfos.get(affair.getObjectId());
                    if(Strings.isNotBlank(currentNodesInfoStr)&&isCurrentNodesInfo){
                    	String currentInfo=Strings.getSafeLimitLengthString(currentNodesInfoStr, 8, "..");
                    	currentInfo="<span title='"+currentNodesInfoStr+"' >"+currentInfo+"</span>";
                    	currentNodesInfoCell.setCellContentHTML(currentInfo);
                	}
                    /*try {
                    	List<CtpAffair> caList = affairManager.getAffairs(affair.getObjectId(), StateEnum.col_pending);
            			if(caList.size()>0){
            				OrgManager orgManager = (OrgManager) AppContext.getBean("orgManager");
    						V3xOrgMember member = orgManager.getMemberById(caList.get(0).getMemberId());
    						String currentInfo=Strings.getSafeLimitLengthString(member.getName(), 8, "..");
                        	currentInfo="<span title='"+member.getName()+"' >"+currentInfo+"</span>";
                        	currentNodesInfoCell.setCellContentHTML(currentInfo);
    					}
					} catch (Exception e) {
					}*/
                    //客开 gxy 20180622 end
                    
                    
                    //发起人
                    if(createMemberCell != null){
                    	String memberName = Functions.showMemberName(affair.getSenderId());
                    	createMemberCell.setAlt(memberName);
                    	if(Strings.isNotBlank(memberName) && memberName.length() > 4){
                    		memberName = memberName.substring(0,4)+"...";
                    	}
                        //一个栏目可以被重复添加多个 id可能会出现重复而导致无法定位人员卡片，需要唯一的标示ID来定位人员卡片 --xiangfan
                        //long flag = UUIDLong.longUUID();
                        //人员卡片
                        //memberName = "<span id=\""+flag+"\"><a class=\"defaulttitlecss\" id=\"panlees\" onmouseover=\"showPerCard('"+affair.getSenderId()+"','"+flag+"')\">" + memberName + "</a></span>";
                        //知会，加签图标
                        if(affair.getFromId() != null){
                            String title = ResourceUtil.getString("collaboration.pending.addOrJointly.label", Functions.showMemberName(affair.getFromId()));
                            memberName = memberName + "<span class='ico16 signature_16' title='"+title+"'></span>";
                        }
                        createMemberCell.setCellContentHTML(memberName);
                    }
                }
            }
        }
        return c;
    }
    
    private String convertPortalBodyType(String bodyType) {
    	String bodyTypeClass = "html_16";
    	if("FORM".equals(bodyType) || "20".equals(bodyType)) {
			bodyTypeClass = "form_text_16";
		} else if("TEXT".equals(bodyType) || "30".equals(bodyType)) {
			bodyTypeClass = "txt_16";
		} else if("OfficeWord".equals(bodyType) || "41".equals(bodyType)) {
			bodyTypeClass = "doc_16";
		} else if("OfficeExcel".equals(bodyType) || "42".equals(bodyType)) {
			bodyTypeClass = "xls_16";
		} else if("WpsWord".equals(bodyType) || "43".equals(bodyType)) {
			bodyTypeClass = "wps_16";
		} else if("WpsExcel".equals(bodyType) || "44".equals(bodyType)) {
			bodyTypeClass = "xls2_16";
		} else if("Pdf".equals(bodyType) || "45".equals(bodyType)) {
			bodyTypeClass = "pdf_16";
		} else if("videoConf".equals(bodyType)) {
			bodyTypeClass = "meeting_video_16";
		}
		return bodyTypeClass;
    }
    /**
     * 取出公文扩展字段
     * @param affair CtpAffair对象
     * @param edocMarkCell 公文文号
     * @param sendUnitCell 公文发文单位
     */
    public static void getEdocExtField(CtpAffair affair, MultiRowVariableColumnTemplete.Cell edocMarkCell, MultiRowVariableColumnTemplete.Cell sendUnitCell, int width){
        Map<String, Object> extParam = AffairUtil.getExtProperty(affair);
        if(null != extParam && null != extParam.get(AffairExtPropEnums.edoc_edocMark.name()) && edocMarkCell != null){
            String str = String.valueOf(extParam.get(AffairExtPropEnums.edoc_edocMark.name()));
            if(str.length() > 7 && width < 10)
                str = str.substring(0, 7) + "...";
            edocMarkCell.setCellContentHTML("<span title='"+String.valueOf(extParam.get(AffairExtPropEnums.edoc_edocMark.name()))+"' >"+str+"</span>");
        }
        if(null != extParam && null != extParam.get(AffairExtPropEnums.edoc_sendUnit.name()) && sendUnitCell != null){
        	sendUnitCell.setCellContent(String.valueOf(extParam.get(AffairExtPropEnums.edoc_sendUnit.name())));
        }
    }

    public  void ListSort(List<CtpAffair> list) {
        Collections.sort(list, new Comparator<CtpAffair>() {
            public int compare(CtpAffair o1, CtpAffair o2) {
            //SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	            try {
	           	 	Date dt1 = o1.getCompleteTime();
	           	 	Date dt2 = o2.getCompleteTime();
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
