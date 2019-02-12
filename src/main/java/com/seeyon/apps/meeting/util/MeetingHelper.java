package com.seeyon.apps.meeting.util;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.agent.bo.AgentModel;
import com.seeyon.apps.agent.bo.MemberAgentBean;
import com.seeyon.apps.index.bo.Accessory;
import com.seeyon.apps.index.bo.IndexInfo;
import com.seeyon.apps.meeting.bo.MeetingBO;
import com.seeyon.apps.meeting.bo.MtTemplateBO;
import com.seeyon.apps.meeting.constants.MeetingConstant.MeetingCategoryEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.MeetingRecordStateEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.MeetingStateEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.MeetingTypeCategoryEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.MeetingTypeSystemEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.RoomAppStateEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.RoomAppUsedStateEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.RoomNeedAppEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.SummaryBusinessTypeEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.SummaryStateEnum;
import com.seeyon.apps.meeting.constants.MeetingListConstant.ListTypeValueEnum;
import com.seeyon.apps.meeting.po.Meeting;
import com.seeyon.apps.meeting.po.MeetingSummary;
import com.seeyon.apps.meeting.po.MeetingTemplate;
import com.seeyon.apps.meeting.vo.MeetingListVO;
import com.seeyon.apps.meetingroom.manager.MeetingRoomManager;
import com.seeyon.apps.meetingroom.po.MeetingRoom;
import com.seeyon.apps.meetingroom.util.MeetingRoomAdminUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.content.affair.constants.SubStateEnum;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.filemanager.manager.PartitionManager;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.po.filemanager.Partition;
import com.seeyon.ctp.organization.OrgConstants.ORGENT_TYPE;
import com.seeyon.ctp.organization.bo.MemberPost;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.Strings;
import com.seeyon.v3x.meeting.contants.MeetingContentEnum;
import com.seeyon.v3x.meeting.domain.MtComment;
import com.seeyon.v3x.meeting.domain.MtMeeting;
import com.seeyon.v3x.meeting.domain.MtReply;

public class MeetingHelper {

	private static final Log LOGGER = LogFactory.getLog(MeetingHelper.class);
	
	private static OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
	
	/**
	 * 获取当前用户组织模型(单位、部门、组、人员。目前与会人员限定在这三种类型)ID集合，配合进行查询(增加了岗位)
	 * @param memberId
	 * @return
	 */
    public static List<Long> getDomainIds(Long memberId) {
        List<Long> result = null;
        try {
            result = orgManager.getUserDomainIDs(memberId, 
            		V3xOrgEntity.VIRTUAL_ACCOUNT_ID,
                    V3xOrgEntity.ORGENT_TYPE_ACCOUNT,
                    V3xOrgEntity.ORGENT_TYPE_DEPARTMENT, 
                    V3xOrgEntity.ORGENT_TYPE_TEAM,
                    V3xOrgEntity.ORGENT_TYPE_MEMBER,
                    V3xOrgEntity.ORGENT_TYPE_POST,
                    V3xOrgEntity.ORGENT_TYPE_LEVEL);
        } catch (BusinessException e) {
        	LOGGER.error("获取当前人员部门、组、人员对应的组织模型实体ID失败", e);
        }
        return result;
    }
	
	public static Long getMeetingOwnerDepartmentId(User currentUser) {
    	long currentDeptId = currentUser.getDepartmentId();
    	if(!currentUser.getLoginAccount().equals(currentUser.getAccountId())) {
    		try {
				Map<Long, List<MemberPost>> map=orgManager.getConcurentPostsByMemberId(currentUser.getLoginAccount(), currentUser.getId());
				long min=-1;
				for(Long deptId:map.keySet()){
					List<MemberPost> list=map.get(deptId);
					for(MemberPost concurrentPost:list){
						if(min==-1) min=concurrentPost.getSortId();
						if(concurrentPost.getSortId()<=min){
							min=concurrentPost.getSortId();
							currentDeptId=deptId;
						}
					}
				}
    		} catch (Exception e) {  
    			LOGGER.error("会议室申请所属部门判断异常:", e);
			}
    	}
    	return currentDeptId;
    }
	
	public static List<Long> getAllUnitIdList(User currentUser) throws BusinessException {
		Long userId = currentUser.getId();
		//当会议室申请范围选择的是集团，这个会议室不能显示出来。因此不传accountId（限制了单位Id则获取不到集团），修改为V3xOrgEntity.VIRTUAL_ACCOUNT_ID
		return orgManager.getUserDomainIDs(userId, V3xOrgEntity.VIRTUAL_ACCOUNT_ID, ORGENT_TYPE.Post.name(), ORGENT_TYPE.Department.name(), ORGENT_TYPE.Account.name());
	}
	
	public static V3xOrgMember getMemberById(Long userId){
		V3xOrgMember member = null;
       try {
           member = (V3xOrgMember) orgManager.getMemberById(userId);
       } catch (BusinessException e) {
             LOGGER.error("",e);
       }
       if(member==null) member=new V3xOrgMember();
       return member;
	}
	
	/**
	 * 根据用户ID获取用户单位名称
	 * @param userId
	 * @return
	 */
	public static String getMemberAccountNameByUserId(Long userId) {
		
		V3xOrgAccount account = null;
		V3xOrgMember member = getMemberById(userId);
		Long accountId = member.getOrgAccountId();
		try {
			account = (V3xOrgAccount) orgManager.getAccountById(accountId);
	    } catch (BusinessException e) {
	    	LOGGER.error("",e);
	    }
	    if(account==null) account=new V3xOrgAccount();
		return account.getShortName();
	}
	
	public static String getMemberNameByUserId(Long userId){
		return getMemberById(userId).getName();
	}
    
    /**
     * 获取用户的会议被代理人
     * @return
     */
    public static List<AgentModel> getMeetingAgents(Long userId) {
    	List<AgentModel> agentModels = new ArrayList<AgentModel>();
    	List<AgentModel> agentToList = MemberAgentBean.getInstance().getAgentModelToList(userId);
    	List<AgentModel> agentList = MemberAgentBean.getInstance().getAgentModelList(userId);
    	if(Strings.isEmpty(agentToList)){
    		agentToList = agentList;
    	}
    	if(agentToList!=null){
    		Date date = new Date();
    		for(AgentModel m : agentToList){
    			if(m.isHasMeeting() && date.after(m.getStartDate()) && date.before(m.getEndDate())){
    				agentModels.add(m);
    			}
    		}
    	}
    	return agentModels;
    }
    
    /**
     * 获取用户的会议被代理人
     * @return
     */
    public static List<Long> getMeetingAgentUserIds(Long userId) {
    	List<Long> ids = new ArrayList<Long>();
    	List<AgentModel> agentToList = MemberAgentBean.getInstance().getAgentModelToList(userId);
    	List<AgentModel> agentList = MemberAgentBean.getInstance().getAgentModelList(userId);
    	if(Strings.isEmpty(agentToList)){
    		agentToList = agentList;
    	}
    	if(agentToList!=null){
    		Date date = new Date();
    		for(AgentModel m : agentToList){
    			if(m.isHasMeeting() && date.after(m.getStartDate()) && date.before(m.getEndDate())){
    				ids.add(m.getAgentToId());
    			}
    		}
    	}
    	return ids;
    }
    
	/*********** 会议列表辅助类 ************/
	public static boolean isMeetingList(int type) throws BusinessException {
		return (type == ListTypeValueEnum.pending.ordinal()) || (type == ListTypeValueEnum.done.ordinal());
	}
	public static boolean isMyCreateList(int type) throws BusinessException {
		return (type == ListTypeValueEnum.wait.ordinal()) || (type == ListTypeValueEnum.send.ordinal());
	}
	public static boolean isSendList(int type) throws BusinessException {
		return type == ListTypeValueEnum.send.ordinal();
	}
	public static boolean isWaitList(int type) throws BusinessException {
		return type == ListTypeValueEnum.wait.ordinal();
	}
	public static boolean isPendingList(int type) throws BusinessException {
		return type == ListTypeValueEnum.pending.ordinal();
	}
	public static boolean isDoneList(int type) throws BusinessException {
		return type == ListTypeValueEnum.done.ordinal();
	}
	
	/*********** 会议状态辅助类 ************/
	public static boolean isFinished(int state) throws BusinessException {
		return (state==MeetingStateEnum.finish.key() || state==MeetingStateEnum.finish_advance.key() || state==MeetingStateEnum.summary.key() || state==MeetingStateEnum.pigeonhole.key());
	}
	public static boolean isWait(int state) throws BusinessException {
		return state == MeetingStateEnum.save.key();
	}
	public static boolean isSend(int state) throws BusinessException {
		return state == MeetingStateEnum.send.key();
	}
	public static boolean isStart(int state) throws BusinessException {
		return state == MeetingStateEnum.start.key();
	}
	public static boolean isPending(int state) throws BusinessException {
		return state == MeetingStateEnum.send.key() || state == MeetingStateEnum.start.key();
	}
	public static boolean isSendDisplay(int state) throws BusinessException {
		return state == MeetingStateEnum.send.key() || state == MeetingStateEnum.periodicity.key();
	}
	public static boolean isPeriodicity(int category) throws BusinessException {
		return category == MeetingCategoryEnum.periodicity.key();
	}
	public static boolean isPublish(int state) throws BusinessException {
		return state == SummaryStateEnum.publish.key();
	}
	public static boolean isRecord(Long recordId, int recordState) throws BusinessException {
		return (!MeetingUtil.isIdNull(recordId) && MeetingRecordStateEnum.yes.key()==recordState);
	}
	
	public static boolean isRoomPass(Integer roomState) throws BusinessException {
		return roomState.intValue() == RoomAppStateEnum.pass.key();
	}
	
	public static boolean isRoomNotPass(Integer roomState) throws BusinessException {
		return roomState.intValue() == RoomAppStateEnum.notpass.key();
	}
	
	public static boolean isRoomWait(Integer roomState) throws BusinessException {
		return roomState.intValue() == RoomAppStateEnum.wait.key();
	}
	
	public static Integer getRoomAppStatus(MeetingRoom room) throws BusinessException {
		Integer appStatus = RoomAppStateEnum.wait.key();
		/** 申请人是会议室管理员，直接将审批状态置为通过 */
		if(room.getNeedApp().intValue() == RoomNeedAppEnum.no.key() || room.getNeedApp().intValue() == RoomNeedAppEnum.no_but_need_msg.key()) {
			appStatus = RoomAppStateEnum.pass.key();
		} else {
			/** 申请人会议室管理员，直接将审批状态置为通过 */
			if(MeetingRoomAdminUtil.isRoomAdmin(room)) {
				appStatus = RoomAppStateEnum.pass.key();
			}
		}
		return appStatus;
	}
	
	public static Long getRoomAppAuditingId(Integer appStatus, Integer needApp, Long userId) {
		if(needApp.intValue() == RoomNeedAppEnum.yes.key() && appStatus.intValue()==RoomAppStateEnum.pass.key()) {
			return userId;
		}
		return null;
	}
	
	/*********** 会议状态集 ************/
	public static List<Integer> getAffairPendingStateList() throws BusinessException {
		List<Integer> affairStateList = new ArrayList<Integer>();
		affairStateList.add(StateEnum.col_sent.key());
		affairStateList.add(StateEnum.col_pending.key());
        affairStateList.add(StateEnum.mt_attend.key());
        affairStateList.add(StateEnum.mt_unAttend.key());
        return affairStateList;
	}
	public static List<Integer> getAffairDoneStateList() throws BusinessException {
		List<Integer> affairStateList = new ArrayList<Integer>();
		affairStateList.add(StateEnum.col_done.key());
        affairStateList.add(StateEnum.mt_attend.key());
        affairStateList.add(StateEnum.mt_unAttend.key());
        return affairStateList;
	}
	public static List<Integer> getAffairStateListForApi() throws BusinessException {
		List<Integer> affairStateList = new ArrayList<Integer>();
		affairStateList.add(StateEnum.col_pending.key());
		affairStateList.add(StateEnum.mt_attend.key());
		affairStateList.add(StateEnum.mt_unAttend.key());
		affairStateList.add(StateEnum.col_done.key());
        return affairStateList;
	}	
	public static List<Integer> getSummaryScopeBusinessTypeList() throws BusinessException {
		List<Integer> businessTypeList = new ArrayList<Integer>();
		businessTypeList.add(SummaryBusinessTypeEnum.meeting.key());
		businessTypeList.add(SummaryBusinessTypeEnum.summary.key());
		businessTypeList.add(SummaryBusinessTypeEnum.emcee.key());
		businessTypeList.add(SummaryBusinessTypeEnum.recorder.key());
        return businessTypeList;
	}
	public static List<Integer> getSystemMeetingTypeSortList() throws BusinessException {
		List<Integer> sortIdList = new ArrayList<Integer>();
    	sortIdList.add(MeetingTypeSystemEnum.systemNormal.key());
    	sortIdList.add(MeetingTypeSystemEnum.systemImport.key());
        return sortIdList;
	}	
	public static List<Integer> getMeetingPendingStateList() throws BusinessException {
		List<Integer> stateList = new ArrayList<Integer>();
		stateList.add(MeetingStateEnum.start.key());
		stateList.add(MeetingStateEnum.send.key());
		return stateList;
	}
	public static List<Integer> getRoomAppRepeatStateList() throws BusinessException {
		List<Integer> stateList = new ArrayList<Integer>();
		stateList.add(RoomAppStateEnum.wait.key());
		stateList.add(RoomAppStateEnum.pass.key());
		return stateList;
	}	
	public static List<Integer> getRoomPermSubStateList() throws BusinessException {
		List<Integer> subStateList = new ArrayList<Integer>();
		subStateList.add(SubStateEnum.col_normal.getKey());
		subStateList.add(SubStateEnum.col_pending_unRead.getKey());
		subStateList.add(SubStateEnum.col_pending_read.getKey());
		return subStateList;
	}
	public static List<Integer> getNotFormMeetingTypeCategoryList() throws BusinessException {
		List<Integer> typeList = new ArrayList<Integer>();
		typeList.add(MeetingTypeCategoryEnum.normal.key());
		typeList.add(MeetingTypeCategoryEnum.important.key());
		typeList.add(MeetingTypeCategoryEnum.userDefined.key());
		return typeList;
	}
	
	public static String convertMeetingTypeContent(String content){
		StringBuilder result = new StringBuilder();
		int a=MeetingContentEnum.content_title.getKey();
		int b=MeetingContentEnum.content_leader.getKey();
		int c=MeetingContentEnum.content_attender.getKey();
		int d=MeetingContentEnum.content_tel.getKey();
		int e=MeetingContentEnum.content_notice.getKey();
		int f=MeetingContentEnum.content_plan.getKey();
		if(content.length()>0 && content != null){
		   String[] str=content.split(","); 
		   for(int i=0;i<str.length;i++) {
			   try {
				   if(Integer.parseInt(str[i])==a){
					   result.append(ResourceUtil.getString("meeting.important.title")+"，");
				   }
				   else if(Integer.parseInt(str[i])==b){
					   result.append(ResourceUtil.getString("meeting.important.leader")+"，");
				   }
				   else if(Integer.parseInt(str[i])==c){
					   result.append(ResourceUtil.getString("meeting.important.attender")+"，");
				   }
				   else if(Integer.parseInt(str[i])==d){
					   result.append(ResourceUtil.getString("meeting.important.telephone")+"，");
				   }
				   else if(Integer.parseInt(str[i])==e){
					   result.append(ResourceUtil.getString("meeting.important.notice")+"，");
				   }
				   else if(Integer.parseInt(str[i])==f){
					   result.append(ResourceUtil.getString("meeting.important.plan")+"，");
				   }
			   } catch(Exception ex) {
				   LOGGER.info("会议类型内容转换报错:"+ex.getMessage());
			   }
		   }
		   if(Strings.isBlank(result.toString())) {
			   result = new StringBuilder(content);
		   } else {
			   result = new StringBuilder(result.substring(0, result.length()-1));
		   }
		}
	    return result.toString();
	}
	
	/**
     * 将非标准正文的会议纪要转换为Accessory，以便全文检索
     * @param file 会议纪要的非标准正文文件
     * @param summary 会议纪要对象
     * @return
     */
    public static Accessory summaryToAccessory(MeetingSummary summary){
        if(Strings.isNotBlank(summary.getContent())) {
            FileManager fileManager = (FileManager) AppContext.getBean("fileManager");
            String contentPath = "";
            try {
                contentPath = fileManager.getFolder(summary.getCreateDate(), false);
            } catch (BusinessException e) {
                  LOGGER.error("",e);
            }
            Accessory accessory = new Accessory();
            accessory.setEntityID(Long.parseLong(summary.getContent()));
            accessory.setTitle(summary.getMtName());
            accessory.setType(getContentType(summary.getDataFormat()));
            accessory.setCreateDate(summary.getCreateDate());
            accessory.setAttAreaId(getAttAreaId(summary.getCreateDate()));
            accessory.setAttPath(contentPath.substring(contentPath.length()-11)+System.getProperty("file.separator")+summary.getContent());
            return accessory;
        }
        return null;
    }
	
    private static int getContentType(String dataFormatType){
        if(com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_OFFICE_WORD.equals(dataFormatType)){
            return IndexInfo.CONTENTTYPE_WORD;
        }else if(com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_OFFICE_EXCEL.equals(dataFormatType)){
            return IndexInfo.CONTENTTYPE_XLS;
        }else if(com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_WPS_WORD.equals(dataFormatType)){
            return IndexInfo.CONTENTTYPE_WPS_Word;
        }else if(com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_WPS_EXCEL.equals(dataFormatType)){
            return IndexInfo.CONTENTTYPE_WPS_EXCEL;
        }
        return -1;
    }
    
    private static String getAttAreaId(java.util.Date date) {
        //附件路径
        PartitionManager partitionManager = (PartitionManager) AppContext.getBean("partitionManager");
        Partition partition = partitionManager.getPartition(date, true);
        return partition.getId().toString();
    }
    
    public static List<MtMeeting> convertToMeetingList(List<Object[]> objlist) {
        List<MtMeeting> list = new ArrayList<MtMeeting>();
        if(objlist == null || objlist.size() == 0)
            return list;
        for(Object[] objects : objlist) {
        	MtMeeting meeting = new Meeting().make(objects, null);
            list.add(meeting);
        }
        return list;
    }
    
    public static List<MeetingBO> convertToMeetingBOList(List<MtMeeting> list) throws BusinessException {
    	MeetingRoomManager meetingRoomManager = (MeetingRoomManager)AppContext.getBean("meetingRoomManager");
    	List<MeetingBO> meetingList = new ArrayList<MeetingBO>();
    	List<Long> roomIdList = new ArrayList<Long>();
    	if(Strings.isNotEmpty(list)) {
	     	try {
	     		for(MtMeeting meeting : list) {
		    		if(meeting.getRoom() != null) {
		    			roomIdList.add(meeting.getRoom());
		    		}
		    	}
	     		Map<Long, MeetingRoom> roomMap = meetingRoomManager.getRoomMap(roomIdList);
		     	
		        for (MtMeeting meeting : list) {
		        	MeetingBO bo = new MeetingBO();
		        	BeanUtils.copyProperties(bo, meeting);
		        	bo.setHasAttsFlag(meeting.isHasAttachments());
		        	bo.setBodyType(meeting.getDataFormat());
		        	if(meeting.getRoom() != null) {
		        		bo.setMeetPlace(roomMap.get(meeting.getRoom()).getName());
		        	}
		        	meetingList.add(bo);
		        }
	        } catch(Exception e) {
	        	LOGGER.error("获取会议数据出错", e);
	        }
    	}
    	return meetingList;
    }
    
    
    public static MtTemplateBO convertToTemplateBO(MeetingTemplate bean){
        MtTemplateBO bo = null;
        if(bean != null){
            bo = new MtTemplateBO();
            
            bo.setId(bean.getId());
            bo.setTitle(bean.getTitle());
            bo.setAccountId(bean.getAccountId());
        }
        return bo;
    }
    
    public static void modulateCommentOpinion(Map<Long, List<MtComment>> commentMap, List<MtReply> replyList, List<MtComment> mtComments){
	    if(mtComments != null){
	        for(MtComment mtComment : mtComments){
	            Long key = mtComment.getReplyId();
	            if(commentMap.containsKey(key)){
	                commentMap.get(key).add(mtComment);
	            }else{
	                List<MtComment> c = new ArrayList<MtComment>();
	                c.add(mtComment);
	                commentMap.put(key, c);
	            }
	        }
	    }
	}
    
    public static List<MtMeeting> convertToMeetingListForApi(List<Object[]> objlist) {
        List<MtMeeting> list = new ArrayList<MtMeeting>();
        if(objlist == null || objlist.size() == 0)
            return list;
        for(Object[] arr : objlist){
            MtMeeting meeting = new MtMeeting();
            int n = 0;
            meeting.setId((Long)arr[n++]);
            meeting.setTitle((String)arr[n++]);
            meeting.setMeetingType((String)arr[n++]);
            meeting.setCreateUser((Long)arr[n++]);
            meeting.setEmceeId((Long)arr[n++]);
            meeting.setRecorderId((Long)arr[n++]);
            meeting.setBeginDate((Date)arr[n++]);
            meeting.setEndDate((Date)arr[n++]);
            meeting.setState((Integer)arr[n++]);
            meeting.setRemindFlag((Boolean)arr[n++]);
            meeting.setHasAttachments((Boolean)arr[n++]);
            meeting.setAccountId((Long)arr[n++]);
            meeting.setDataFormat((String)arr[n++]);
            meeting.setBeforeTime((Integer)arr[n++]);
            meeting.setCreateDate((Date)arr[n++]);
            list.add(meeting);
        }
        return list;
    }
    
    public static List<MeetingListVO> convertToMeetingAgentList(List<MeetingListVO> voList,Long currentUserId, AgentModel agent) throws BusinessException{
    	if(Strings.isNotEmpty(voList)) {
    		//判断当前用户是不是让别人干活的人
            for(MeetingListVO bean : voList) {
            	boolean isAgentTo = agent.getAgentToId().equals(currentUserId);
            	bean.setProxyId(isAgentTo ? -1l : agent.getAgentToId());
            }
        }
        return voList;
    }
    
    public static String[] getRoomAppUsedStateName(Integer status, Integer usedStatus, Date currentDate, Date startDatetime, Date endDatetime) throws BusinessException {
    	String[] usedstatusArr = new String[2];
    	if(status.intValue() == RoomAppStateEnum.pass.key()) {//会议审核通过，才能使用
	    	if(usedStatus==null || usedStatus.intValue()==RoomAppUsedStateEnum.normal.key()) {
				if(!MeetingDateUtil.compareDate(currentDate, startDatetime)) {//未使用
					usedstatusArr[0] = ResourceUtil.getString("meeting.room.used.status.0");
					usedstatusArr[1] = "0";
				} else if(MeetingDateUtil.compareDate(currentDate, startDatetime) && !MeetingDateUtil.compareDate(currentDate, endDatetime)) {
					usedstatusArr[0] = ResourceUtil.getString("meeting.room.used.status.1");
					usedstatusArr[1] = "1";
				} else if(MeetingDateUtil.compareDate(currentDate, endDatetime)) {
					usedstatusArr[0] = ResourceUtil.getString("meeting.room.used.status.2");
					usedstatusArr[1] = "2";
				}
	    	} else {
	    		usedstatusArr[0] = ResourceUtil.getString("meeting.room.used.status.3");
	    		usedstatusArr[1] = "3";
	    	}
    	} else {
    		usedstatusArr[0] = ResourceUtil.getString("meeting.room.used.status.0");
    		usedstatusArr[1] = "0";
    	}
    	return usedstatusArr;
	}
    
}
