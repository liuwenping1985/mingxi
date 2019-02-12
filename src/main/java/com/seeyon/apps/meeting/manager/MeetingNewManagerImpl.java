package com.seeyon.apps.meeting.manager;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import com.seeyon.apps.cinda.manager.CindaManager;
import com.seeyon.apps.common.projectphaseevent.manager.ProjectPhaseEventManager;
import com.seeyon.apps.common.projectphaseevent.po.ProjectPhaseEvent;
import com.seeyon.apps.index.manager.IndexManager;
import com.seeyon.apps.meeting.constants.MeetingConstant;
import com.seeyon.apps.meeting.constants.MeetingConstant.MeetingCategoryEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.MeetingRecordStateEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.MeetingStateEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.RecordStateEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.RoomAppStateEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.RoomNeedAppEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.SummaryStateEnum;
import com.seeyon.apps.meeting.dao.MeetingTemplateDao;
import com.seeyon.apps.meeting.po.MeetingPeriodicity;
import com.seeyon.apps.meeting.po.MeetingSummary;
import com.seeyon.apps.meeting.po.MeetingTemplate;
import com.seeyon.apps.meeting.quartz.MeetingQuartzJobManager;
import com.seeyon.apps.meeting.util.MeetingDateUtil;
import com.seeyon.apps.meeting.util.MeetingHelper;
import com.seeyon.apps.meeting.util.MeetingNewHelper;
import com.seeyon.apps.meeting.util.MeetingTransHelper;
import com.seeyon.apps.meeting.util.MeetingUtil;
import com.seeyon.apps.meeting.vo.ConfereesConflictVO;
import com.seeyon.apps.meeting.vo.MeetingMemberVO;
import com.seeyon.apps.meeting.vo.MeetingNewVO;
import com.seeyon.apps.meeting.vo.MeetingOptionListVO;
import com.seeyon.apps.meetingroom.manager.MeetingRoomManager;
import com.seeyon.apps.meetingroom.po.MeetingRoom;
import com.seeyon.apps.meetingroom.po.MeetingRoomApp;
import com.seeyon.apps.meetingroom.util.MeetingRoomAdminUtil;
import com.seeyon.apps.meetingroom.vo.MeetingRoomAppVO;
import com.seeyon.apps.project.api.ProjectApi;
import com.seeyon.apps.project.bo.ProjectBO;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.Constants;
import com.seeyon.ctp.common.content.affair.AffairExtPropEnums;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.CommonTools;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.v3x.meeting.domain.MtMeeting;
import com.seeyon.v3x.meeting.domain.MtReply;
import com.seeyon.v3x.meeting.manager.MtReplyManager;

/**
 * 
 * @author 唐桂林
 *
 */
public class MeetingNewManagerImpl implements MeetingNewManager {
	
	private MeetingManager meetingManager;
	private MeetingTypeManager meetingTypeManager;
	private MeetingTypeRecordManager meetingTypeRecordManager;
	private MeetingRoomManager meetingRoomManager;
	private MeetingExtManager meetingExtManager;
	private MeetingResourcesManager meetingResourcesManager;
	private MeetingQuartzJobManager meetingQuartzJobManager;
	private MeetingPeriodicityManager meetingPeriodicityManager;
	private MeetingMessageManager meetingMessageManager;
	private MeetingSummaryManager meetingSummaryManager;
	private AffairManager affairManager;
	private OrgManager orgManager;
	private AppLogManager appLogManager;
	private IndexManager indexManager;
	private MeetingTemplateDao meetingTemplateDao;
    private ConfereesConflictManager confereesConflictManager;
    private ProjectApi projectApi;
    private ProjectPhaseEventManager projectPhaseEventManager;
    private MeetingConfereeManager meetingConfereeManager;
    private MtReplyManager replyManager;
    private MeetingValidationManager meetingValidationManager;
    private MeetingReplyManager meetingReplyManager;

    /****************************** 会议新建 **********************************/
	/**
	 * 新建/编辑会议
	 * @param newVo
	 * @return
	 * @throws BusinessException
	 */
	@Override
	public boolean newMeeting(MeetingNewVO newVo) throws BusinessException {
		User currentUser = newVo.getCurrentUser();
		MtMeeting meeting = new MtMeeting();
		newVo.setMeeting(meeting);
		
		
		
		/************** 新建会议 **************/
		if(newVo.isNew()) {
			//设置会议默认属性
			MeetingNewHelper.setNewMeetingDefaultValue(newVo);
			
			if(!MeetingUtil.isIdNull(meeting.getRoom())){
				newVo.setMeetingRoom(meetingRoomManager.getRoomById(meeting.getRoom()));
			}
		}
		/************** 编辑会议 **************/
		else {
			meeting = meetingManager.getMeetingById(newVo.getMeetingId());
			newVo.setMeeting(meeting);
			
			if(!MeetingHelper.isPeriodicity(meeting.getCategory())) {
				newVo.setIsBatch(false);
			}
			
			//设置正文信息
			meetingExtManager.setContent(newVo);
			
			if(AppContext.hasPlugin("videoconference")){
				String ext4 = meeting.getVideoMeetingId();
				if(Strings.isNotBlank(ext4)){
					Map<String, Object> ext4Map = JSONUtil.parseJSONString(ext4, Map.class);
					if(meeting.getEmceeId().equals(currentUser.getId())){
						newVo.getMeeting().setMeetingPassword(String.valueOf(ext4Map.get("pcode1")));
					}else{
						newVo.getMeeting().setMeetingPassword(String.valueOf(ext4Map.get("pcode2")));
					}
				}
			}
		}
		//设置会议室选项
		if(newVo.isRoomAppNew()) {
			newVo.setMeetingroomAppedNameList(meetingRoomManager.getRoomAppedNameListByUserId(currentUser.getId()));
		}else {
			List<MeetingOptionListVO> roomAppList = meetingRoomManager.getRoomAppedNameByRoomAppId(newVo.getRoomAppId());
			if(Strings.isNotEmpty(roomAppList)) {
				MeetingOptionListVO vo = roomAppList.get(0);
				newVo.setMyMeetingroomAppedName(vo);
				newVo.getMeeting().setBeginDate(vo.getBeginDate());
				newVo.getMeeting().setEndDate(vo.getEndDate());
				//用于判断会议室时间与会议时间是否一致
				MeetingRoomApp mtApp = new MeetingRoomApp();
				mtApp.setStartDatetime(vo.getBeginDate());
				mtApp.setEndDatetime(vo.getEndDate());
				newVo.setMeetingRoomApp(mtApp);
			}
		}
		if(!MeetingUtil.isIdNull(meeting.getRoom())) {
			newVo.setRoomId(meeting.getRoom());
			
			MeetingRoomApp roomApp = meetingRoomManager.getRoomAppByRoomAndMeetingId(meeting.getRoom(), meeting.getId());
			if(roomApp != null) {
				newVo.setMeetingRoomApp(roomApp);
				
				if(!MeetingHelper.isWait(meeting.getState())) {
					List<MeetingOptionListVO> roomAppList = meetingRoomManager.getRoomAppedNameByRoomAppId(roomApp.getId());
					if(Strings.isNotEmpty(roomAppList)) {
						newVo.setMyMeetingroomAppedName(roomAppList.get(0));
					}
				}
			}
		}
		
		boolean meetingflag = true;
		String openFrom = ParamUtil.getString(newVo.getParameterMap(), "openFrom");
		/************** 调用模板 **************/
		if("chooseTemplate".equals(openFrom)) {
			meetingExtManager.setMeetingByTemplate(newVo);
			meetingflag = false;
		}
		
		/************** 格式模板 **************/
		if("chooseContent".equals(openFrom)) {
			MeetingNewHelper.setMeetingByVo(newVo);
			meetingExtManager.setMeetingByContentTemplate(newVo);
			meetingflag = false;
		} 
		
		/************** 转发会议 **************/
		if(meetingflag && newVo.isFromApp()) {
			meetingExtManager.setMeetingByApp(newVo);
		}

		/** 获取周期会议设置 */
		String periodicityType = newVo.getParameterMap().get("periodicityType");
		if(!MeetingUtil.isIdNull(meeting.getPeriodicityId())) {
			newVo.setPeriodicity(meetingPeriodicityManager.getPeriodicityById(meeting.getPeriodicityId()));
			newVo.setPeriodicityId(meeting.getPeriodicityId());
			
		}else if(Strings.isNotBlank(periodicityType)){
			MeetingPeriodicity periodicity = new MeetingPeriodicity();
			periodicity.setPeriodicityType(Integer.valueOf(periodicityType));
			periodicity.setScope(newVo.getParameterMap().get("periodicityScope"));
			periodicity.setStartDate(Datetimes.parse(newVo.getParameterMap().get("periodicityStartDate")));
			periodicity.setEndDate(Datetimes.parse(newVo.getParameterMap().get("periodicityEndDate")));
			newVo.setPeriodicity(periodicity);
		}
		
		/** 会议方式列表(普通会议，红杉树视频会议) */
		meetingExtManager.setNatureNameList(newVo);
		
		/** 设置会议分类列表 */
		meetingExtManager.setMeetingTypeNameList(newVo);
		
		/** 会议资源列表 */
		meetingExtManager.setResourceNameList(newVo);
		
		/** 会议格式模板列表 */
		meetingExtManager.setContentTemplateNameList(newVo);
		
		/** 会议提前时间枚举 */
		meetingExtManager.setMeetingRemindTimeEnum(newVo);
		
		/** 设置关联项目参数 */
		meetingExtManager.setProjectNameList(newVo);
		
		/** 会议参会人员 */
		meetingExtManager.setConfereesNameList(newVo);
		
		/** 设置视频会议参数 */
		meetingExtManager.setVideoMeetingParameter(newVo);

		//会议附件回填
		meetingExtManager.setMeetingAttachment(newVo);
		
		//是否显示申请会议室按钮
        boolean isShowRoom = currentUser.hasResourceCode("F09_meetingRoomApp") && currentUser.hasResourceCode("F09_meetingRoom");
        newVo.setIsShowRoom(isShowRoom);
		return true;
	}

	/**
	 * 设置会议周期
	 * @param newVo
	 * @return
	 * @throws BusinessException
	 */
	@Override
	public boolean newPeriodicity(MeetingNewVO newVo) throws BusinessException {
		this.meetingPeriodicityManager.setNewPeriodicity(newVo);
		return true;
	}
	
	/**
	 * 发送/保存会议
	 * @param newVo
	 * @return
	 * @throws BusinessException
	 */
	@Override
	public boolean transSend(MeetingNewVO newVo) throws BusinessException {
		//add by  wfj 2018-11-2校验时间设置，此举因移动端而增加
	
		System.out.println("-----"+newVo.getIsM3());
		System.out.println("-----"+newVo.getRoomId());
		if(newVo.getIsM3()&&newVo.getRoomId()!=-1) {
			System.out.println("-----2");
				CindaManager cindaManager=(CindaManager) AppContext.getBean("cindaManager");
				String[] metSetArray=cindaManager.getCfgArray();
				if(metSetArray!=null) {
					Date nowdate=new Date();
					if(metSetArray[0]!="00:00"||metSetArray[1]!="00:00") {
						System.out.println("-----3");
						String newm="";
						
						int h=nowdate.getHours();
						int m=nowdate.getMinutes();
						int st=Integer.parseInt(metSetArray[0].replace(":", ""));
						int et=Integer.parseInt(metSetArray[1].replace(":", ""));
						if(m<10) {
							newm="0"+m;
						}else {
							newm=""+m;
						}
						int nhm=Integer.parseInt(h+newm);
						if(nhm<st||nhm>et) {
							newVo.setErrorMsg("当前时间不在可申请时间范围内("+metSetArray[0]+"~"+metSetArray[1]+")");
							return false;
						}
						
					}
					System.out.println("-----2"+newVo.getParameterMap().get("beginDate"));
					System.out.println("-----3"+newVo.getParameterMap().get("endDate"));
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					Date sdt;
					try {
						sdt = sdf.parse(newVo.getParameterMap().get("beginDate"));
					
					Date edt=sdf.parse(newVo.getParameterMap().get("endDate"));
					int dd=Integer.parseInt(metSetArray[2]);
					if(sdt.getTime()>nowdate.getTime()) {
						int st=differentDaysByMillisecond(nowdate,sdt);
						System.out.println("-----st"+st);
						if(st>dd) {
							newVo.setErrorMsg("所选日期已超过可预定天数("+metSetArray[2]+"天)");
							return false;
						}
					}
					if(edt.getTime()>nowdate.getTime()) {
						int et=differentDaysByMillisecond(nowdate,edt);
						if(et>dd) {
							newVo.setErrorMsg("所选日期已超过可预定天数("+metSetArray[2]+"天)");
							return false;
						}
					}
					} catch (ParseException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
				}
		}
				//end wfj 2018-11-2 校验时间设置，此举因移动端而增加
		MtMeeting meeting = null;
		if(newVo.isNew()) {
			meeting = new MtMeeting();
		} else {
			meeting = meetingManager.getMeetingById(newVo.getMeetingId());
			newVo.setOldMeeting(MeetingTransHelper.cloneMeeting(meeting));
		}
		newVo.setMeeting(meeting);
		
		MeetingNewHelper.setMeetingDefaultValueByVo(newVo);
		MeetingNewHelper.setMeetingByVo(newVo);

		this.meetingExtManager.checkVideoMeetingData(newVo);
		
		/** 保存会议资源 */
		meetingResourcesManager.saveMeetingResources(meeting);
		
		/** 保存会议类型使用记录 */
		meetingTypeRecordManager.saveMeetingTypeRecord(meeting);
		
		/** 周期会议 */
		if(newVo.isCategoryPeriodicity()) {

			if(newVo.isNew()) {
				newVo.setIsBatch(Boolean.TRUE);
			}
			
			if(newVo.getIsBatch()) {
				meetingPeriodicityManager.transSavePeriodicity(newVo);
				meeting.setPeriodicityId(newVo.getPeriodicity().getId());
				meeting.setTemplateId(newVo.getPeriodicityTemplateId());
				
				if(Strings.isNotEmpty(newVo.getPeriodicityDatesList())) {
					meeting.setBeginDate(newVo.getPeriodicityDatesList().get(0)[0]);
					meeting.setEndDate(newVo.getPeriodicityDatesList().get(0)[1]);
				}
				//为周期会议写入一套附件信息，触发下一条会议时作为模板的一部分使用
				meetingExtManager.saveMeetingAttachment(newVo.isNew(), meeting.getPeriodicityId(), -1l);
				if(!Constants.EDITOR_TYPE_HTML.equals(meeting.getDataFormat())){
					//克隆一份相同的文件
					meetingExtManager.cloneOfficeFile(Long.valueOf(meeting.getContent()), meeting.getPeriodicityId(), meeting.getCreateDate());
				}
				
			} else if(!newVo.isNew()) {
				newVo.setIsSingleEdit(Boolean.TRUE);
				
				meeting.setBeginDate(MeetingDateUtil.getMeetingNewDate(newVo.getOldMeeting().getBeginDate(), meeting.getBeginDate()));
				meeting.setEndDate(MeetingDateUtil.getMeetingNewDate(newVo.getOldMeeting().getEndDate(), meeting.getEndDate()));
				
				meeting.setCategory(MeetingCategoryEnum.single.key());
			}
		}
		
		//对比会议
		if(!newVo.isNew()) {
			if(newVo.getOldMeeting() != null && !MeetingHelper.isWait(newVo.getOldMeeting().getState())) {
				newVo.setOldMtReplyList(meetingReplyManager.getReplyByMeetingId(newVo.getMeeting().getId()));
			}
		}
		
		//保存附件
		saveMeetingAttachment(newVo.getIsM3(), newVo.isNew(), meeting.getId(), newVo.getIsBatch() ? meeting.getPeriodicityId() : -1l);
		
		if((!newVo.isRoomAppNew() || !newVo.isRoomNew()) && !MeetingNewVO.NewMeeting_selectRoomType_MtPlace.equals(newVo.getSelectRoomType())) {
			//修改后-会议室申请不为空
			MeetingRoomAppVO appVo = new MeetingRoomAppVO();
			appVo.setCategory(newVo.getCategory());
			appVo.setIsBatch(newVo.getIsBatch());
			appVo.setIsSingleEdit(newVo.getIsSingleEdit());
			appVo.setSystemNowDatetime(newVo.getSystemNowDatetime());
			appVo.setRoomAppId(newVo.getRoomAppId());
			appVo.setOldRoomAppId(ParamUtil.getLong(newVo.getParameterMap(), "oldRoomAppId"));
			appVo.setOldRoomId(ParamUtil.getLong(newVo.getParameterMap(), "oldRoomId"));
			appVo.setRoomId(newVo.getRoomId());
			appVo.setMeetingId(meeting.getId());
			appVo.setMeeting(meeting);
			appVo.setIsNewMeetingPeriodicity(newVo.getIsNewMeetingPeriodicity());
			newVo.setMeetingRoomAppVO(appVo);
			
			if(!newVo.isRoomNew()) {
				appVo = MeetingNewHelper.getMeetingRoomAppVOByParameterMap(newVo);
			}
			
			meetingRoomManager.transAppInMeeting(appVo);
			
			meeting.setRoomState(appVo.getMeetingRoomApp().getStatus());
			meeting.setRoom(appVo.getMeetingRoom().getId());
			meeting.setMeetPlace("");
			newVo.setRoomId(appVo.getMeetingRoom().getId());
			
		} else {
			meeting.setRoomState(RoomAppStateEnum.pass.key());
			meeting.setRoom(Constants.GLOBAL_NULL_ID);
			newVo.setRoomId(Constants.GLOBAL_NULL_ID);
			
			if(!newVo.isNew() && !MeetingUtil.isIdNull(newVo.getOldMeeting().getRoom())) {
				Map<String, Object> cancelAppMap = new HashMap<String, Object>();
				cancelAppMap.put("currentUser", newVo.getCurrentUser());
				cancelAppMap.put("meetingId", meeting.getId());
				cancelAppMap.put("isBatch", newVo.getIsBatch());
				meetingRoomManager.transCancelRoomApp(cancelAppMap);
			}
		}
		
		if(MeetingHelper.isRoomPass(meeting.getRoomState())) {
			boolean result = this.transPublishMeeting(newVo);
			if(!result) {
				return false;
			}
		} else {
			//会议室为待审核状态，会议不能召开
			meeting.setState(MeetingStateEnum.send.key());
			this.meetingManager.saveOrUpdate(meeting);
			
			//先发布再编辑申请会议室，再审核不通过，会议数据也发布出去了
			if(!newVo.isNew()) {
				affairManager.deletePhysicalByObjectId(newVo.getMeeting().getId());
			}
			
			//如果当前是修改会议的情况。则需要给对应的人员发送取消的消息：
			if(!newVo.isNew() && newVo.getOldMeeting()!=null) {
				//发给修改后撤销的与会人消息
				meetingMessageManager.sendMeetingCancelMessage(newVo);
			}
		}
		
		//老的会议室有id才查询,会议室申请有改变
		if((newVo.isRoomAppNew() || newVo.isRoomNew())  && !newVo.isNew() && newVo.getOldMeeting()!=null && !MeetingUtil.isIdNull(newVo.getOldMeeting().getRoom())){
			//发给修改了会议室之前的会议室管理员
			MeetingRoom meetingRoom = meetingRoomManager.getRoomById(newVo.getOldMeeting().getRoom());
			//老的有会议室是要审核的才发撤销的消息
			if(meetingRoom != null && meetingRoom.getNeedApp() == RoomNeedAppEnum.yes.key()) {
				Map<String,Object> messageMap = new HashMap<String,Object>();
				List<Long> oldAdminList = MeetingRoomAdminUtil.getRoomAdminIdList(meetingRoom);
				messageMap.put("createUser",newVo.getCurrentUser().getId());
				messageMap.put("roomName",meetingRoom.getName());
				
				MeetingRoomApp meetingRoomApp = meetingRoomManager.getRoomAppByMeetingId(newVo.getOldMeeting().getId());
				if(meetingRoomApp != null) {
					messageMap.put("roomAppId",meetingRoomApp.getId());
				}
				messageMap.put("memberIdList",oldAdminList);
				meetingMessageManager.sendRoomAppCancelMessage(messageMap);;
			}
		}
		
		if(newVo.getIsSingleEdit()) {//单次修改
			newVo.setMeetingRoomAppVO(null);
			newVo.setRoomId(-1l);
			boolean result = this.transGenerateNextMeeting(newVo);
			if(!result) {
				return false;
			}
		} else {
			int i = 0;
			while(i < 300 && newVo.getMeeting()!=null && MeetingHelper.isFinished(newVo.getMeeting().getState())) {
				i++;
				this.transFinishMeeting(newVo);
			}
		}
		return true;
	}
	
	/**
	 * 会议保存待发
	 * @param newVo
	 * @return
	 * @throws BusinessException
	 */
	@Override
	public boolean transSave(MeetingNewVO newVo) throws BusinessException {
		MtMeeting meeting = null;
		if(newVo.isNew()) {
			meeting = new MtMeeting();
		} else {
			meeting = meetingManager.getMeetingById(newVo.getMeetingId());
			newVo.setOldMeeting(MeetingTransHelper.cloneMeeting(meeting));
		}
		newVo.setMeeting(meeting);
		
		MeetingNewHelper.setMeetingByVo(newVo);
		MeetingNewHelper.setMeetingDefaultValueByVo(newVo);
		
		/** 保存会议资源 */
		meetingResourcesManager.saveMeetingResources(meeting);
		
		/** 保存会议类型使用记录 */
		meetingTypeRecordManager.saveMeetingTypeRecord(meeting);
		
		/** 周期会议 */
		if(newVo.isCategoryPeriodicity()) {
			if(newVo.isNew()) {
				newVo.setIsBatch(Boolean.TRUE);
			}
			if(newVo.getIsBatch()) {
				if(!MeetingUtil.isIdNull(meeting.getPeriodicityId())){
					newVo.setPeriodicity(meetingPeriodicityManager.getPeriodicityById(meeting.getPeriodicityId()));
				}
				meetingPeriodicityManager.transSavePeriodicity(newVo);
				meeting.setPeriodicityId(newVo.getPeriodicity().getId());
				
				if(Strings.isNotEmpty(newVo.getPeriodicityDatesList())) {
					meeting.setBeginDate(newVo.getPeriodicityDatesList().get(0)[0]);
					meeting.setEndDate(newVo.getPeriodicityDatesList().get(0)[1]);
				}
				//为周期会议写入一套附件信息，触发下一条会议时作为模板的一部分使用
				meetingExtManager.saveMeetingAttachment(newVo.isNew(), meeting.getPeriodicityId(), -1l);
				if(!Constants.EDITOR_TYPE_HTML.equals(meeting.getDataFormat())){
					//克隆一份相同的文件
					meetingExtManager.cloneOfficeFile(Long.valueOf(meeting.getContent()), meeting.getPeriodicityId(), meeting.getCreateDate());
				}
			} else if(!newVo.isNew()) {
				newVo.setIsSingleEdit(Boolean.TRUE);

				meeting.setCategory(MeetingCategoryEnum.single.key());
			}
		}
		
		//保存附件
		saveMeetingAttachment(newVo.getIsM3(), newVo.isNew(), meeting.getId(), newVo.getIsBatch() ? meeting.getPeriodicityId() : -1l);
		
		meeting.setState(MeetingStateEnum.save.key());
		meeting.setRoom(Constants.GLOBAL_NULL_ID);
		meeting.setRoomState(RoomAppStateEnum.pass.key());
		
		this.meetingManager.saveOrUpdate(meeting);
		this.meetingExtManager.checkVideoMeetingData(newVo);
		return true;
	}
	
	//保存附件
	private void saveMeetingAttachment(boolean isM3, boolean isNew, Long meetingId, Long periodicityId) throws BusinessException{
		if(isM3) {
			meetingExtManager.saveMeetingAttachmentM3(isNew, meetingId);
		} else {
			meetingExtManager.saveMeetingAttachment(isNew, meetingId, periodicityId);
		}
	}
	
	/**
	 * 发布会议
	 * @param newVo
	 * @return
	 * @throws BusinessException
	 */
	@Override
	public boolean transPublishMeeting(MeetingNewVO newVo) throws BusinessException {
		MtMeeting meeting = newVo.getMeeting();
	
		//通过会议时间设置会议状态
		MeetingNewHelper.setMeetingState(newVo);
		
		//会议发布时生成待办数据与回执数据
		createAffairsAndReplys(newVo);
		
		//会议未结束
		if(meeting.getState().intValue() != MeetingStateEnum.finish.key()) {
			meetingQuartzJobManager.createMeetingQuartzJob(newVo);
		} 
		
		//保存视频会议
		if(AppContext.hasPlugin("videoconference")) {	
			if(MeetingHelper.isPending(newVo.getMeeting().getState())) {
				boolean result = this.meetingExtManager.sendVideoMeeting(newVo);
				if(!result) {
					return false;
				}
			}
		}
		
		//更新会议
		this.meetingManager.saveOrUpdate(newVo.getMeeting());
		//更新与会对象
		meetingConfereeManager.saveOrUpdate(newVo.getMeeting());
		
		//记录项目的关联事项
        if (AppContext.hasPlugin("project")) {
            Long projectId = newVo.getMeeting().getProjectId();
            if(projectApi != null && !MeetingUtil.isIdNull(projectId)) {
                ProjectBO project = projectApi.getProject(projectId);
                if(project != null) {
                    if (project.getPhaseId() != 1) {
                        projectPhaseEventManager.save(new ProjectPhaseEvent(ApplicationCategoryEnum.meeting.key(), meeting.getId(), project.getPhaseId()));
                    }
                }
            }
        }
        
		//会议日志记录
        User actionUser = newVo.getCurrentUser();
        if(null == actionUser && null != meeting && null != meeting.getCreateUser()){
        	V3xOrgMember memberById = orgManager.getMemberById(meeting.getCreateUser());
        	actionUser  = new User();
        	actionUser.setId(memberById.getId());
        	actionUser.setName(memberById.getName());
        	actionUser.setLoginAccount(memberById.getOrgAccountId());
        }
        //定时任务没有登陆人员
        if(newVo.getCurrentUser() == null){
        	newVo.setCurrentUser(actionUser);
        }
        
		appLogManager.insertLog(actionUser, AppLogAction.Meeting_notice_new, actionUser.getName(),newVo.getMeeting().getTitle());
		
		if(AppContext.hasPlugin("index")){
            indexManager.update(meeting.getId(), ApplicationCategoryEnum.meeting.getKey());
        }
		
		//消息发送
		if(Strings.isNotEmpty(newVo.getAffairList())) {
			meetingMessageManager.sendMeetingMessage(newVo);
		}
		//判断会议是否冲突，当冲突的时候发送会议冲突提醒消息
		sendconfereesConflictMessage(newVo);
		
		//获取会议中没有电话号码的人员信息
		getNoPhoneNumberNames(newVo);
		
		return true;
	}
	
	private void sendconfereesConflictMessage(MeetingNewVO newVo)  throws BusinessException {
		//保存已发冲突消息人员信息。<会议ID,人员ID集合>
		Map<Long, List<Long>> conflictMember = new HashMap<Long, List<Long>>();
        Long meetingId = newVo.getMeeting().getId();
        Long emceeId = newVo.getMeeting().getEmceeId();
        Long recorderId = newVo.getMeeting().getRecorderId();
        Long beginDatetime = newVo.getMeeting().getBeginDate().getTime();
        Long endDatetime = newVo.getMeeting().getEndDate().getTime();
        String conferees = newVo.getMeeting().getConferees();
        Map<String, Object> confereesParamemterMap = new HashMap<String, Object>();
        confereesParamemterMap.put("meetingId", MeetingUtil.isIdNull(meetingId) ? Constants.GLOBAL_NULL_ID : meetingId);
        confereesParamemterMap.put("emceeId", MeetingUtil.isIdNull(emceeId) ? Constants.GLOBAL_NULL_ID : emceeId);
        confereesParamemterMap.put("recorderId", MeetingUtil.isIdNull(recorderId) ? Constants.GLOBAL_NULL_ID : recorderId);
        confereesParamemterMap.put("beginDatetime", beginDatetime);
        confereesParamemterMap.put("endDatetime", endDatetime);
        confereesParamemterMap.put("conferees", conferees);
        confereesParamemterMap.put("currentUser", newVo.getCurrentUser());
        List<ConfereesConflictVO> confereesConflictVoList = confereesConflictManager.findConfereesConflictVOList(confereesParamemterMap);
        if (confereesConflictVoList.size() > 0) {
            for (ConfereesConflictVO confereesConflictVo : confereesConflictVoList) {
            	//当前冲突会议已发消息人员
            	List<Long> memberList = new ArrayList<Long>();
                Map<String, Object> messageMap = new HashMap<String, Object>();
                messageMap.put("createUser", newVo.getMeeting().getCreateUser());
                messageMap.put("meetingId", newVo.getMeeting().getId());
                messageMap.put("title", newVo.getMeeting().getTitle());
                messageMap.put("title1", confereesConflictVo.getMtTitle());
                
                MeetingMemberVO vo = meetingManager.getAllTypeMember(confereesConflictVo.getMeetingId(), null);
                List<Long> allMember = vo.getAllMember();
                
                if (null != conflictMember.get(confereesConflictVo.getMeetingId())){
                	memberList.addAll(conflictMember.get(confereesConflictVo.getMeetingId()));
                }
                //冲突ID可能为人员ID、部门ID或者单位ID
                if ("Account".equals(confereesConflictVo.getCollideType())) { //单位
                    List<V3xOrgMember> orgMemberList = orgManager.getAllMembers(confereesConflictVo.getId());
                    if (orgMemberList.size() > 0) {
                        for (V3xOrgMember orgMember : orgMemberList) {
                        	if(allMember.contains(orgMember.getId()) && !memberList.contains(orgMember.getId())){
                        		messageMap.put("memberId", orgMember.getId());
                        		meetingMessageManager.sendconfereesConflictMessage(messageMap);
                        		memberList.add(orgMember.getId());
                        	}
                        }
                    }
                } else if ("Department".equals(confereesConflictVo.getCollideType())) { //部门
                    List<V3xOrgMember> orgMemberList = orgManager.getMembersByDepartment(confereesConflictVo.getId(), false);
                    if (orgMemberList.size() > 0) {
                        for (V3xOrgMember orgMember : orgMemberList) {
                        	if(allMember.contains(orgMember.getId()) && !memberList.contains(orgMember.getId())){
                        		messageMap.put("memberId", orgMember.getId());
                        		meetingMessageManager.sendconfereesConflictMessage(messageMap);
                        		memberList.add(orgMember.getId());
                        	}
                        }
                    }
                } else if ("Member".equals(confereesConflictVo.getCollideType())){ //人员
                	if(allMember.contains(confereesConflictVo.getId()) && !memberList.contains(confereesConflictVo.getId())){
                		messageMap.put("memberId", confereesConflictVo.getId());
                		meetingMessageManager.sendconfereesConflictMessage(messageMap);
                		memberList.add(confereesConflictVo.getId());
                	}
                }
                conflictMember.put(confereesConflictVo.getMeetingId(), memberList);
            }
        }
    }
	
	/**
	 * 结束会议
	 * @param newVo
	 * @return
	 * @throws BusinessException
	 */
	@Override
	public boolean transFinishMeeting(MeetingNewVO newVo) throws BusinessException {
		MtMeeting meeting = newVo.getMeeting();
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("state", StateEnum.col_done.key());
		affairManager.update(params, new Object[][] {
									{"app", ApplicationCategoryEnum.meeting.key()},
									{"objectId", meeting.getId()},
									{"state", StateEnum.col_pending.key()}});
		
		if(meeting.getState().intValue() == MeetingStateEnum.finish.key()
				|| meeting.getState().intValue() == MeetingStateEnum.finish_advance.key()) {
			this.meetingManager.saveOrUpdate(meeting);
		}
		
		//周期会议
		if(MeetingHelper.isPeriodicity(meeting.getCategory())) {
			this.transGenerateNextMeeting(newVo);
		} else {
			newVo.setMeeting(null);
		}
		
		return true;
	}
	
	/**
	 * 生成新的会议(用于周期会议)
	 * @param newVo
	 * @return
	 * @throws BusinessException
	 */
	@Override
	public boolean transGenerateNextMeeting(MeetingNewVO newVo) throws BusinessException {
		MtMeeting nextMeeting = newVo.getMeeting();
		
		nextMeeting = meetingPeriodicityManager.getNextMeetingByPeriodicity(newVo);
		newVo.setMeeting(nextMeeting);
		
		if(nextMeeting != null) {
			nextMeeting.setCategory(MeetingCategoryEnum.periodicity.key());
			nextMeeting.setCreateDate(newVo.getSystemNowDatetime());
			nextMeeting.setIdIfNew();
			nextMeeting.setRecordState(RecordStateEnum.no.key());
			MeetingNewHelper.setMeetingState(newVo);

			/** 保存会议类型使用记录 */
			meetingTypeRecordManager.saveMeetingTypeRecord(nextMeeting);
			
			/** 激活会议时，修改会议室申请记录 */
			MeetingRoomAppVO appVo = newVo.getMeetingRoomAppVO();
			if(appVo == null) {
				appVo = new MeetingRoomAppVO();
			}
			appVo.setMeeting(nextMeeting);
			appVo.setCurrentUser(newVo.getCurrentUser());
			
			this.meetingRoomManager.transGenerateNextRoomAppInMeeting(appVo);
			nextMeeting.setRoom(appVo.getRoomId());
			nextMeeting.setRoomState(appVo.getStatus());
			
			//判断周期会议是否存在附件
			if(meetingExtManager.hasAttachment(nextMeeting.getPeriodicityId())){
				nextMeeting.setHasAttachments(true);
				newVo.getMeeting().setHasAttachments(true);
				//生成附件信息
				meetingExtManager.saveMeetingAttachment(true, nextMeeting.getId(), nextMeeting.getPeriodicityId());
			}
			
			if(MeetingHelper.isRoomPass(nextMeeting.getRoomState())) {
				boolean result = transPublishMeeting(newVo);
				if(!result) {
					return false;
				}
			} else {
				this.meetingManager.saveOrUpdate(nextMeeting);
			}
		}
		return true;
	}
	
	private void createAffairsAndReplys(MeetingNewVO newVo) throws BusinessException {
		List<Long> alreayReplyMember = new ArrayList<Long>();//已经回执过的人员
		if(!newVo.isNew()) {
			List<MtReply> replyList = meetingReplyManager.getReplyByMeetingId(newVo.getMeeting().getId());
			for(MtReply reply : replyList){
				alreayReplyMember.add(reply.getUserId());
			}
			affairManager.deletePhysicalByObjectId(newVo.getMeeting().getId());
		}
		
		MtMeeting meeting = newVo.getMeeting();
		newVo.setEmceeIdList(new ArrayList<Long>());
		newVo.setRecorderIdList(new ArrayList<Long>());
		newVo.setConfereeIdList(new ArrayList<Long>());
		newVo.setImpartIdList(new ArrayList<Long>());
				
    	Set<Long> userIdList = new HashSet<Long>();
    	
    	MeetingNewHelper.addToList(userIdList, newVo.getEmceeIdList(), meeting.getEmceeId());
    	
    	MeetingNewHelper.addToList(userIdList, newVo.getRecorderIdList(), meeting.getRecorderId());
    	
    	if(Strings.isNotBlank(meeting.getConferees())) {
    		List<Long> memberIdList = CommonTools.getMemberIdsByTypeAndId(meeting.getConferees(), orgManager);
    		for(Long memberId : memberIdList) {
    			MeetingNewHelper.addToList(userIdList, newVo.getConfereeIdList(), memberId);
    		}
    	}
    	
    	if(Strings.isNotBlank(meeting.getImpart())) {
    		List<Long> memberIdList = CommonTools.getMemberIdsByTypeAndId(meeting.getImpart(), orgManager);
    		for(Long memberId : memberIdList) {
    			MeetingNewHelper.addToList(userIdList, newVo.getImpartIdList(), memberId);
    		}
    	}
    	
    	if(Strings.isNotBlank(meeting.getLeader())) {
    		List<Long> memberIdList = CommonTools.getMemberIdsByTypeAndId(meeting.getLeader(), orgManager);
    		for(Long memberId : memberIdList) {
    			MeetingNewHelper.addToList(userIdList, newVo.getLeaderIdList(), memberId);
    		}
    	}

    	Map<String, Object> affairExtParam = new HashMap<String, Object>();
        affairExtParam.put(AffairExtPropEnums.meeting_emcee.name(), MeetingNewHelper.getOrgMemberName(orgManager, meeting.getEmceeId()));
        affairExtParam.put(AffairExtPropEnums.meeting_emcee_id.name(), meeting.getEmceeId());
        affairExtParam.put(AffairExtPropEnums.meeting_videoConf.name(), meeting.getMeetingType());
        affairExtParam.put(AffairExtPropEnums.meeting_place.name(), MeetingNewHelper.getMeetingPlaceName(meetingRoomManager, meeting.getRoom(), meeting.getMeetPlace()));
        
        Integer state = StateEnum.col_pending.key();
        if(!MeetingHelper.getMeetingPendingStateList().contains(newVo.getMeeting().getState())) {
        	state = StateEnum.col_done.key();
        }
        
        Map<String, Object> affairMap = new HashMap<String, Object>();
        affairMap.put("objectId", meeting.getId());
        affairMap.put("state", state);
        affairMap.put("createUser", meeting.getCreateUser());
        affairMap.put("subject", meeting.getTitle());
        affairMap.put("beginDate", meeting.getBeginDate());
        affairMap.put("endDate", meeting.getEndDate());
        affairMap.put("createDate", meeting.getCreateDate());
        affairMap.put("updateDate", meeting.getUpdateDate());
        affairMap.put("bodyType", meeting.getDataFormat());
        affairMap.put("affairExtParam", affairExtParam);
        affairMap.put("alreayReplyMember", alreayReplyMember);

        List<Long> allMemberIdList = new ArrayList<Long>();
        List<CtpAffair> affairList = new ArrayList<CtpAffair>();
        List<MtReply> replyList = new ArrayList<MtReply>();
    	if(Strings.isNotEmpty(newVo.getEmceeIdList())) {
    		for(Long memberId : newVo.getEmceeIdList()) {
    			affairMap.put("memberId", memberId);
    			affairMap.put("inform", "");
    			affairList.add(MeetingNewHelper.createNewAffair(affairMap));
    			if(!alreayReplyMember.contains(memberId)){
					replyList.add(MeetingNewHelper.createNewMtReply(affairMap));
				}
    			allMemberIdList.add(memberId);
    		}
    	}        	
    	if(Strings.isNotEmpty(newVo.getRecorderIdList())) {
    		for(Long memberId : newVo.getRecorderIdList()) {
    			affairMap.put("memberId", memberId);
    			affairMap.put("inform", "");
    			affairList.add(MeetingNewHelper.createNewAffair(affairMap));
				if(!alreayReplyMember.contains(memberId)){
					replyList.add(MeetingNewHelper.createNewMtReply(affairMap));
				}
    			allMemberIdList.add(memberId);
    		}
    	}
    	
    	if(Strings.isNotEmpty(newVo.getConfereeIdList())) {
    		for(Long memberId : newVo.getConfereeIdList()) {
    			affairMap.put("memberId", memberId);
    			affairMap.put("inform", "");
    			affairList.add(MeetingNewHelper.createNewAffair(affairMap));
				if(!alreayReplyMember.contains(memberId)){
					replyList.add(MeetingNewHelper.createNewMtReply(affairMap));
				}
    			allMemberIdList.add(memberId);
    		}
    	}
    	if(Strings.isNotEmpty(newVo.getImpartIdList())) {
    		for(Long memberId : newVo.getImpartIdList()) {
    			affairMap.put("memberId", memberId);
    			affairMap.put("inform", "inform");
    			affairList.add(MeetingNewHelper.createNewAffair(affairMap));
				if(!alreayReplyMember.contains(memberId)){
					replyList.add(MeetingNewHelper.createNewMtReply(affairMap));
				}
    			allMemberIdList.add(memberId);
    		}
    	}
    	if(Strings.isNotEmpty(newVo.getLeaderIdList())) {
    		for(Long memberId : newVo.getLeaderIdList()) {
    			affairMap.put("memberId", memberId);
    			affairMap.put("inform", "");
    			affairList.add(MeetingNewHelper.createNewAffair(affairMap));
				if(!alreayReplyMember.contains(memberId)){
					replyList.add(MeetingNewHelper.createNewMtReply(affairMap));
				}
    			allMemberIdList.add(memberId);
    		}
    	}
    	
    	if(Strings.isNotEmpty(affairList)) {
    		affairManager.saveAffairs(affairList);
    		newVo.setAffairMemberIdList(allMemberIdList);
    		newVo.setAffairList(affairList);
    	}
    	if(Strings.isNotEmpty(replyList)){
    		meetingReplyManager.saveMtReplys(replyList);
    	}
    	
    	//计算会议各回执状态人数
    	int allCount = 0, joinCount = 0, unjoinCount = 0, pendingCount = 0;
    	for(MtReply reply : replyList){
    		allCount++;
    		if(reply.getFeedbackFlag() == MeetingConstant.MeetingReplyFeedbackFlagEnum.attend.key()){
    			joinCount++;
    		}else if(reply.getFeedbackFlag() == MeetingConstant.MeetingReplyFeedbackFlagEnum.unattend.key()){
    			unjoinCount++;
    		}else if(reply.getFeedbackFlag() == MeetingConstant.MeetingReplyFeedbackFlagEnum.pending.key()){
    			pendingCount++;
    		}
    	}
    	meeting.setAllCount(allCount);
    	meeting.setJoinCount(joinCount);
    	meeting.setUnjoinCount(unjoinCount);
    	meeting.setPendingCount(pendingCount);
    }
	
	/**
	 * 保存会议模板
	 * @param newVo
	 * @return
	 * @throws BusinessException
	 */
	@Override
	public boolean transSaveAsTemplate(MeetingNewVO newVo) throws BusinessException {
		User currentUser = newVo.getCurrentUser();
		boolean isNew = true;
		MeetingNewHelper.setMeetingByVo(newVo);
		//判断模板是否存在
		String templateName = newVo.getMeeting().getTitle();
		Long userId = currentUser.getId();
		//获取会议模板，过滤掉周期会议生成的模板
		List<MeetingTemplate> result = meetingTemplateDao.getTemplateByName(templateName, userId);
		//模板存在时，为template赋值
		if(Strings.isNotEmpty(result) && result.size()>0) {
		    newVo.setTemplate(result.get(0));
		    isNew = false;
		}
		
		MeetingNewHelper.setTemplateByMeeting(newVo);
		
		MeetingTemplate template = newVo.getTemplate();
		
		template.setCreateUser(currentUser.getId());
		template.setAccountId(currentUser.getAccountId());
		template.setCreateDate(newVo.getSystemNowDatetime());
		template.setUpdateDate(newVo.getSystemNowDatetime());
		template.setIdIfNew();
		//周期会议过滤掉周期会议生成的模板时，模板不存在时，新生成模板保存。（不然会覆盖掉周期会议模板）
		if (Strings.isEmpty(result) && result.size()==0) {
		    template.setId(UUIDLong.longUUID());
	        template.setPeriodicityId(null);
		}
		this.meetingExtManager.saveOrUpdateTemplate(template);
		//保存附件
		saveMeetingAttachment(false, isNew, template.getId(), -1l);
		return true;
	}
	
	/**
	 * 新建/编辑会议纪要
	 * @param newVo
	 * @return
	 * @throws BusinessException
	 */
	@Override
	public boolean newSummary(MeetingNewVO newVo) throws BusinessException {
		MtMeeting meeting = null;
		MeetingSummary summary = new MeetingSummary();
		if(!newVo.isSummaryNew()) {
			summary = meetingSummaryManager.getSummaryById(newVo.getSummaryId());
			if(summary == null) {
				return false;
			}
			meeting = meetingManager.getMeetingById(summary.getMeetingId());
		} else if(!newVo.isNew()) {
			meeting = meetingManager.getMeetingById(newVo.getMeetingId());
			if(!MeetingUtil.isIdNull(meeting.getRecordId())) {
				summary = meetingSummaryManager.getSummaryById(meeting.getRecordId());
			} else {
				summary.setDataFormat(Constants.EDITOR_TYPE_HTML);
			}
		}
		
		if(meeting == null) {
			return false;
		}
		
		newVo.setSummary(summary);
		newVo.setMeeting(meeting);
		
		User currentUser = newVo.getCurrentUser();
		
		Long recorderId = meeting.getRecorderId();//记录人id
        Long emceeId = meeting.getEmceeId();//主持人id
        Long curruntUserId = currentUser.getId();//当前登录人id
        //如果有记录人，则只有记录人可以记录会议纪要
        if(null!=recorderId && !Long.valueOf(-1).equals(recorderId)){
            if(!curruntUserId.equals(recorderId)){
                return false;
            }
        } else {//没有记录人，主持人可以记录会议纪要；
            if(!curruntUserId.equals(emceeId)){
                return false;
            }
        }
        
        Set<Long> userIdList = new HashSet<Long>();
    	
    	MeetingNewHelper.addToList(userIdList, newVo.getCreateUserIdList(), meeting.getCreateUser());
    	MeetingNewHelper.addToList(userIdList, newVo.getEmceeIdList(), meeting.getEmceeId());
    	MeetingNewHelper.addToList(userIdList, newVo.getRecorderIdList(), meeting.getRecorderId());
    	newVo.getEmceeList().add(orgManager.getMemberById(meeting.getEmceeId()));
    	
    	
    	if(!MeetingUtil.isIdNull(meeting.getRecorderId())) {
    		newVo.getRecorderList().add(orgManager.getMemberById(meeting.getRecorderId()));
    	}
    	if(Strings.isNotBlank(meeting.getConferees())) {
    		newVo.getConfereeList().addAll(orgManager.getEntities(meeting.getConferees()));
    	}
    	if(Strings.isNotBlank(meeting.getImpart())) {
    		newVo.getImpartList().addAll(orgManager.getEntities(meeting.getImpart()));
    	}
        
    	if(summary.isNew()) {
    		newVo.getScopeList().addAll(meetingSummaryManager.findRealConfereesList(meeting.getId()));
    		
    		StringBuilder buffer = new StringBuilder();
            if(Strings.isNotEmpty(newVo.getScopeList())){
                for(V3xOrgEntity entity : newVo.getScopeList()) {
                	if(Strings.isNotBlank(buffer.toString())) {
                		buffer.append(",");
                	}
                	buffer.append(entity.getEntityType());
                	buffer.append("|");
                	buffer.append(entity.getId());
                }
            }
            summary.setConferees(buffer.toString());
            
    	} else {
    		newVo.getScopeList().addAll(orgManager.getEntities(summary.getConferees()));
    	}
    	//实际与会人过滤掉主持人和记录人
    	newVo.getScopeList().remove(orgManager.getMemberById(meeting.getEmceeId()));
        if(!MeetingUtil.isIdNull(meeting.getRecorderId())) {
            newVo.getScopeList().remove(orgManager.getMemberById(meeting.getRecorderId()));
        }
    	meeting.setRoomName(meetingRoomManager.getRoomNameById(meeting.getRoom(), meeting.getMeetPlace()));
    	meeting.setMeetingTypeName(meetingTypeManager.getMeetingTypeNameById(meeting.getMeetingTypeId()));
    	
		return true;
	}
	
	/**
	 * 发送会议纪要
	 * @param newVo
	 * @return
	 * @throws BusinessException
	 */
	@Override
	public boolean transSendSummary(MeetingNewVO newVo) throws BusinessException {
		
		transSaveSummary(newVo);
		
		User currentUser = newVo.getCurrentUser();
		
		MeetingSummary summary = newVo.getSummary();
		
		meetingSummaryManager.saveMeetingSummaryScope(newVo);
		
		List<Long> memberIdList = meetingSummaryManager.getScopePeople(newVo.getMeeting(), summary.getId());
		
		Boolean idEdit = false;
		//编辑会议纪要
		if ("listMeetingSummary".equals(newVo.getParameterMap().get("listType"))) {
		    idEdit = true;
		}
		Map<String, Object> messageMap = new HashMap<String, Object>();
        messageMap.put("memberIdList", memberIdList);
        messageMap.put("createUser", currentUser.getId());
        messageMap.put("summaryId", summary.getId());
        messageMap.put("meetingId", newVo.getMeeting().getId());
        messageMap.put("title", summary.getMtName());
        messageMap.put("isEdit", idEdit);
		meetingMessageManager.sendSummaryMessage(messageMap);
		//日志
		AppLogAction logAction = AppLogAction.Meeting_summary_new;
		if(!newVo.isSummaryNew()) {			
            logAction = AppLogAction.Meeting_summary_modify;
        }
		appLogManager.insertLog(currentUser, logAction, currentUser.getName(), summary.getMtName());
        		
        //更新全文检索，吧纪要的正文检索进会议里
        if(AppContext.hasPlugin("index")){
            indexManager.update(summary.getMeetingId(), ApplicationCategoryEnum.meeting.getKey());
        }
        
		return true;
	}

	/**
	 * 保存会议纪要
	 * @param newVo
	 * @return
	 * @throws BusinessException
	 */
	@Override
	public boolean transSaveSummary(MeetingNewVO newVo) throws BusinessException {
		MtMeeting meeting = null;
		MeetingSummary summary = new MeetingSummary();
		if(!newVo.isSummaryNew()) {
			MeetingSummary oldSummary = meetingSummaryManager.getSummaryById(newVo.getSummaryId());
			if(oldSummary == null) {
				return false;
			}
			summary = oldSummary;
			meeting = meetingManager.getMeetingById(summary.getMeetingId());
		} else if(!newVo.isNew()) {
			meeting = meetingManager.getMeetingById(newVo.getMeetingId());
			if(!MeetingUtil.isIdNull(meeting.getRecordId())) {
				summary = meetingSummaryManager.getSummaryById(meeting.getRecordId());
			}
		}
		
		newVo.setSummary(summary);
		newVo.setMeeting(meeting);
		
		User currentUser = newVo.getCurrentUser();
		
		MeetingNewHelper.setSummaryByVo(newVo);
		MeetingNewHelper.setSummaryByMeeting(newVo);
		MeetingNewHelper.setSummaryState(newVo);
		
		summary.setCreateUser(currentUser.getId());
		summary.setUpdateUser(currentUser.getId());
		summary.setCreateDate(newVo.getSystemNowDatetime());
		summary.setUpdateDate(newVo.getSystemNowDatetime());
		summary.setDataFormat(newVo.getSummary().getDataFormat());
		summary.setAccountId(currentUser.getAccountId());
		summary.setConferees(newVo.getSummary().getConferees());
		summary.setMtTypeName(newVo.getSummary().getMtTypeName());
		summary.setIdIfNew();
		
		//老G6功能，现已放弃
		summary.setIsAudit(false);
		summary.setAuditors("");
		summary.setAuditNum(0);
		
		if("save".equals(newVo.getAction())) {
			summary.setState(SummaryStateEnum.draft.key());
		} else {
			summary.setState(SummaryStateEnum.publish.key());
		}
		meetingSummaryManager.saveOrUpdate(summary);
		
		if("send".equals(newVo.getAction())) {
        	meeting.setRecordState(MeetingRecordStateEnum.yes.key());
        } else {
        	meeting.setRecordState(MeetingRecordStateEnum.no.key());
        }
        meeting.setRecordId(summary.getId());
        this.meetingManager.saveOrUpdate(meeting);
		
        this.meetingExtManager.saveMeetingAttachment(newVo.isSummaryNew(), summary.getId(), -1l);
		
		return true;
	}
	
	private void getNoPhoneNumberNames(MeetingNewVO newVo) throws BusinessException{
		if("1".equals(String.valueOf(newVo.getMeeting().getIsSendTextMessages()))){
			newVo.setNoPhoneNumberNames(meetingValidationManager.checkMemberPhoneNumber(newVo.getMeeting().getId()));
		}
	}
	
	/****************************** 依赖注入 **********************************/
	public void setMeetingManager(MeetingManager meetingManager) {
		this.meetingManager = meetingManager;
	}
	public void setMeetingRoomManager(MeetingRoomManager meetingRoomManager) {
		this.meetingRoomManager = meetingRoomManager;
	}
	public void setMeetingExtManager(MeetingExtManager meetingExtManager) {
		this.meetingExtManager = meetingExtManager;
	}
	public void setMeetingQuartzJobManager(MeetingQuartzJobManager meetingQuartzJobManager) {
		this.meetingQuartzJobManager = meetingQuartzJobManager;
	}
	public void setMeetingMessageManager(MeetingMessageManager meetingMessageManager) {
		this.meetingMessageManager = meetingMessageManager;
	}
	public void setAffairManager(AffairManager affairManager) {
		this.affairManager = affairManager;
	}
	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}
	public void setMeetingResourcesManager(MeetingResourcesManager meetingResourcesManager) {
		this.meetingResourcesManager = meetingResourcesManager;
	}
	public void setMeetingPeriodicityManager(MeetingPeriodicityManager meetingPeriodicityManager) {
		this.meetingPeriodicityManager = meetingPeriodicityManager;
	}
	public void setMeetingSummaryManager(MeetingSummaryManager meetingSummaryManager) {
		this.meetingSummaryManager = meetingSummaryManager;
	}
	public void setMeetingTypeManager(MeetingTypeManager meetingTypeManager) {
		this.meetingTypeManager = meetingTypeManager;
	}
	public void setMeetingTypeRecordManager(MeetingTypeRecordManager meetingTypeRecordManager) {
		this.meetingTypeRecordManager = meetingTypeRecordManager;
	}
	public void setAppLogManager(AppLogManager appLogManager) {
		this.appLogManager = appLogManager;
	}
	public void setIndexManager(IndexManager indexManager) {
		this.indexManager = indexManager;
	}
	public void setMeetingTemplateDao(MeetingTemplateDao meetingTemplateDao) {
        this.meetingTemplateDao = meetingTemplateDao;
    }
	public ConfereesConflictManager getConfereesConflictManager() {
        return confereesConflictManager;
    }
    public void setConfereesConflictManager(ConfereesConflictManager confereesConflictManager) {
        this.confereesConflictManager = confereesConflictManager;
    }
    public ProjectApi getProjectApi() {
        return projectApi;
    }
    public void setProjectApi(ProjectApi projectApi) {
        this.projectApi = projectApi;
    }
    public ProjectPhaseEventManager getProjectPhaseEventManager() {
        return projectPhaseEventManager;
    }
    public void setProjectPhaseEventManager(ProjectPhaseEventManager projectPhaseEventManager) {
        this.projectPhaseEventManager = projectPhaseEventManager;
    }
	public void setMeetingConfereeManager(MeetingConfereeManager meetingConfereeManager) {
		this.meetingConfereeManager = meetingConfereeManager;
	}
	public void setReplyManager(MtReplyManager replyManager) {
		this.replyManager = replyManager;
	}
	public void setMeetingValidationManager(MeetingValidationManager meetingValidationManager) {
		this.meetingValidationManager = meetingValidationManager;
	}
	public void setMeetingReplyManager(MeetingReplyManager meetingReplyManager) {
		this.meetingReplyManager = meetingReplyManager;
	}
	//add by wfj 2018-11-2  判断日期差
		public static int differentDaysByMillisecond(Date date1,Date date2)
	    {
	        int days = (int) ((date2.getTime() - date1.getTime()) / (1000*3600*24));
	        return days;
	    }
		//end
}
