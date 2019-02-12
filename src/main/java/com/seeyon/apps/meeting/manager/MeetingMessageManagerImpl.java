package com.seeyon.apps.meeting.manager;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.collections.CollectionUtils;

import com.seeyon.apps.agent.bo.MemberAgentBean;
import com.seeyon.apps.meeting.constants.MeetingConstant.AppLog_MeetingRoomEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.MeetingMessageTypeEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.PeriodicityTypeEnum;
import com.seeyon.apps.meeting.po.MeetingPeriodicity;
import com.seeyon.apps.meeting.po.MeetingType;
import com.seeyon.apps.meeting.util.MeetingHelper;
import com.seeyon.apps.meeting.util.MeetingUtil;
import com.seeyon.apps.meeting.vo.MeetingNewVO;
import com.seeyon.apps.meetingroom.po.MeetingRoom;
import com.seeyon.apps.meetingroom.po.MeetingRoomPerm;
import com.seeyon.apps.meetingroom.util.MeetingRoomAdminUtil;
import com.seeyon.apps.meetingroom.vo.MeetingRoomAppVO;
import com.seeyon.apps.meetingroom.vo.MeetingRoomVO;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.Constants;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.usermessage.Constants.LinkOpenType;
import com.seeyon.ctp.common.usermessage.MessageContent;
import com.seeyon.ctp.common.usermessage.MessageReceiver;
import com.seeyon.ctp.common.usermessage.MessageUtil;
import com.seeyon.ctp.common.usermessage.UserMessageManager;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.Strings;
import com.seeyon.v3x.meeting.domain.MtMeeting;
import com.seeyon.v3x.meeting.domain.MtReply;


/**
 * 
 * @author 唐桂林
 *
 */
public class MeetingMessageManagerImpl implements MeetingMessageManager {

	private OrgManager orgManager;
	private UserMessageManager userMessageManager;
	private MeetingTypeManager meetingTypeManager;
	private AppLogManager appLogManager;
	private MeetingResourcesManager meetingResourcesManager;
	
	/**
	 * 会议发送-新建/修改/撤销消息-发给参会人员
	 * @param newVo
	 * @throws BusinessException
	 */
	@Override
	public void sendMeetingMessage(MeetingNewVO newVo) throws BusinessException {
		String meetingTitle = newVo.getMeeting().getTitle();
		Date beginDate = newVo.getMeeting().getBeginDate();
		Date endDate = newVo.getMeeting().getEndDate();
		String content = newVo.getMeeting().getContent();
		String bodyType = newVo.getMeeting().getDataFormat();
		Date createDate = newVo.getMeeting().getCreateDate();
		Long createUser = newVo.getMeeting().getCreateUser();
		String createUserName = MeetingHelper.getMemberNameByUserId(createUser);
		Long meetingId = newVo.getMeeting().getId();
		boolean isForceSMS = "1".equals(String.valueOf(newVo.getMeeting().getIsSendTextMessages()));
	    
		List<Long> affairMemberIdList = newVo.getAffairMemberIdList();
		
		List<Long> memberIdNewList = new ArrayList<Long>();
		List<Long> memberIdUpdateList = new ArrayList<Long>();
		List<Long> memberIdCanelList = new ArrayList<Long>();
		List<Long> agentIdNewList = new ArrayList<Long>();
		List<Long> agentIdUpdateList = new ArrayList<Long>();
		List<Long> agentIdCanelList = new ArrayList<Long>();
		
		
		if(newVo.isNew()) {
			memberIdNewList = affairMemberIdList;
		} else {
			if(Strings.isNotEmpty(newVo.getOldMtReplyList())) {
				List<Long> oldAffairMemberIdList = new ArrayList<Long>();
				for(MtReply oldMtReply : newVo.getOldMtReplyList()) {
					if(affairMemberIdList.contains(oldMtReply.getUserId())) {
						memberIdUpdateList.add(oldMtReply.getUserId());
					} else {
						memberIdCanelList.add(oldMtReply.getUserId());
					}
					oldAffairMemberIdList.add(oldMtReply.getUserId());
				}
				for(Long memberId : affairMemberIdList) {
					if(!oldAffairMemberIdList.contains(memberId)) {
						memberIdNewList.add(memberId);
					}
				}
			} else if(Strings.isNotEmpty(newVo.getAffairList())) {
				memberIdNewList = affairMemberIdList;
			}
		}
		
		if(memberIdNewList.contains(createUser)) {
			memberIdNewList.remove(createUser);
		}
		
		String meetPlace = newVo.getMeeting().getMeetPlace();
		if(Strings.isNotEmpty(memberIdNewList)) {
			
			String msgKey = "";
			Object[] msgParams = null;
			//周期性会议发送消息
			if(newVo.isCategoryPeriodicity()) {
				MeetingPeriodicity periodicity = newVo.getPeriodicity();
				if(periodicity != null) {
					String scope = "";
			    	String[] week = {ResourceUtil.getString("meeting.periodicity.message.mondy"),
			    			ResourceUtil.getString("meeting.periodicity.message.thesday"),
			    			ResourceUtil.getString("meeting.periodicity.message.wednesday"),
			    			ResourceUtil.getString("meeting.periodicity.message.thursday"),
			    			ResourceUtil.getString("meeting.periodicity.message.friday"),
			    			ResourceUtil.getString("meeting.periodicity.message.saturday"),
			    			ResourceUtil.getString("meeting.periodicity.message.sunday")};
			    	if(periodicity.getPeriodicityType() == PeriodicityTypeEnum.day.key()) {
			    		scope = ResourceUtil.getString("meeting.periodicity.message.scope0")+periodicity.getScope()+ResourceUtil.getString("meeting.periodicity.message.scope1");
			    	} else if(periodicity.getPeriodicityType() == PeriodicityTypeEnum.week.key()) {
			    		scope = ResourceUtil.getString("meeting.periodicity.message.scope2")+week[Integer.parseInt(periodicity.getScope())-1]+"";
			    	} else {
			    		scope = ResourceUtil.getString("meeting.periodicity.message.scope3")+periodicity.getScope()+ResourceUtil.getString("meeting.periodicity.message.scope4");
			    	}
			    	msgKey = "mt.send.periodicity";
			    	msgParams = new Object[]{meetingTitle, createUserName,newVo.getPeriodicity().getStartDate(), newVo.getPeriodicity().getEndDate(),scope,beginDate, endDate};
				}
			} else {
				if((!MeetingUtil.isIdNull(newVo.getRoomId()) && newVo.getRoomId() != -1) || Strings.isNotBlank(meetPlace)) {
					if(Strings.isBlank(meetPlace)){
						meetPlace = newVo.getMeetingRoomAppVO().getMeetingRoom().getName();
					}
					msgKey = "meeting.mt.send1";
			    	msgParams = new Object[]{meetingTitle, createUserName, beginDate, endDate,meetPlace};
				} else {
					msgKey = "meeting.mt.send2";
			    	msgParams = new Object[]{meetingTitle, createUserName, beginDate, endDate};
				}
			}
			if(msgParams != null) {
				MessageContent msgContent = MessageContent.get(msgKey, msgParams);
				msgContent.setBody(content, bodyType, createDate);
				Collection<MessageReceiver> receiverList = getReceivers(meetingId, memberIdNewList, "message.link.mt.send", LinkOpenType.open, isForceSMS, meetingId, "0", "-1");
				userMessageManager.sendSystemMessage(msgContent, ApplicationCategoryEnum.meeting, createUser, receiverList, MeetingMessageTypeEnum.Meeting_Notification.key());
				//给代理人发送消息
				for (Long memberIdNew : memberIdNewList) {
					Long agentId = MemberAgentBean.getInstance().getAgentMemberId(ApplicationCategoryEnum.meeting.ordinal(), memberIdNew);
					if(null != agentId){
						agentIdNewList.add(agentId);
					}
				}
				if (Strings.isNotEmpty(agentIdNewList)) {
					MessageContent agentMsgContent = MessageContent.get(msgKey, msgParams);
					agentMsgContent = agentMsgContent.add("meeting.agent");
					Collection<MessageReceiver> agentReceiverList = getReceivers(meetingId, agentIdNewList, "message.link.mt.send", LinkOpenType.open, isForceSMS, meetingId, "0", "-1");
					userMessageManager.sendSystemMessage(agentMsgContent, ApplicationCategoryEnum.meeting, createUser, agentReceiverList, MeetingMessageTypeEnum.Meeting_Notification.key());
				}
			}
		}
		
		if(memberIdUpdateList.contains(createUser)) {
			memberIdUpdateList.remove(createUser);
		}
		if(Strings.isNotEmpty(memberIdUpdateList)) {
			String msgKey = "";
			Object[] msgParams = null;
			
			if(newVo.getRoomId() != -1 || Strings.isNotBlank(meetPlace)) {
				if(Strings.isBlank(meetPlace)){
					meetPlace = newVo.getMeetingRoomAppVO().getMeetingRoom().getName();
				}
				msgKey = "meeting.mt.edit1";
		    	msgParams = new Object[]{meetingTitle, createUserName, beginDate, endDate,meetPlace};
			} else {
				msgKey = "meeting.mt.edit2";
		    	msgParams = new Object[]{meetingTitle, createUserName, beginDate, endDate};
			}
			if (msgParams != null) {
				MessageContent msgContent = MessageContent.get(msgKey, msgParams);
				msgContent.setBody(content, bodyType, createDate);
				Collection<MessageReceiver> receiverList = getReceivers(meetingId, memberIdUpdateList, "message.link.mt.send", LinkOpenType.open, isForceSMS, meetingId, "0", "-1");
				userMessageManager.sendSystemMessage(msgContent, ApplicationCategoryEnum.meeting, createUser, receiverList, MeetingMessageTypeEnum.Meeting_Notification.key());
				//给代理人发送消息
				for (Long memberIdUpdate : memberIdUpdateList) {
					Long agentId = MemberAgentBean.getInstance().getAgentMemberId(ApplicationCategoryEnum.meeting.ordinal(), memberIdUpdate);
					if(null != agentId){
						agentIdUpdateList.add(agentId);
					}
				}
				if (Strings.isNotEmpty(agentIdUpdateList)) {
					MessageContent agentMsgContent = MessageContent.get(msgKey, msgParams);
					agentMsgContent = agentMsgContent.add("meeting.agent");
					Collection<MessageReceiver> agentReceiverList = getReceivers(meetingId, agentIdUpdateList, "message.link.mt.send", LinkOpenType.open, isForceSMS, meetingId, "0", "-1");
					userMessageManager.sendSystemMessage(agentMsgContent, ApplicationCategoryEnum.meeting, createUser, agentReceiverList, MeetingMessageTypeEnum.Meeting_Notification.key());
				}
			}
			
		}
		
		if(memberIdCanelList.contains(createUser)) {
			memberIdCanelList.remove(createUser);
		}
		if(Strings.isNotEmpty(memberIdCanelList)) {
			String msgKey = "mt.cancel";
			Object[] msgParams = new Object[]{meetingTitle, createUserName, beginDate, endDate};
			
			MessageContent msgContent = MessageContent.get(msgKey, msgParams);
			msgContent.setBody(content, bodyType, createDate);
			Collection<MessageReceiver> receiverList = MessageReceiver.get(meetingId, memberIdCanelList, isForceSMS);
			userMessageManager.sendSystemMessage(msgContent, ApplicationCategoryEnum.meeting, createUser, receiverList, MeetingMessageTypeEnum.Meeting_Notification.key());
			//给代理人发送消息
			for (Long memberIdCanel : memberIdCanelList) {
				Long agentId = MemberAgentBean.getInstance().getAgentMemberId(ApplicationCategoryEnum.meeting.ordinal(), memberIdCanel);
				if(null != agentId){
					agentIdCanelList.add(agentId);
				}
			}
			if (Strings.isNotEmpty(agentIdCanelList)) {
				MessageContent agentMsgContent = MessageContent.get(msgKey, msgParams);
				agentMsgContent = agentMsgContent.add("meeting.agent");
				Collection<MessageReceiver> agentReceiverList = getReceivers(meetingId, agentIdCanelList, "message.link.mt.send", LinkOpenType.open, isForceSMS, meetingId, "0", "-1");
				userMessageManager.sendSystemMessage(agentMsgContent, ApplicationCategoryEnum.meeting, createUser, agentReceiverList, MeetingMessageTypeEnum.Meeting_Notification.key());
			}
		}
		//表单触发会议给会议发起人发送消息
        List<MeetingType> meetingTypeList = meetingTypeManager.getFormMeetingTypeList(newVo.getCurrentUser().getAccountId());
        if(!Strings.isEmpty(meetingTypeList)){
            Long formMeetingType = meetingTypeList.get(0).getId();
            if (formMeetingType == newVo.getMeeting().getMeetingTypeId() && newVo.isNew()) {
            	String msgKey = "meeting.mt.fromSend";
                MessageContent msgContent = MessageContent.get(msgKey, meetingTitle);
                msgContent.setBody(content, bodyType, createDate);
                MessageReceiver receiver = MessageReceiver.get(meetingId, createUser, "message.link.mt.send", meetingId, "0", "-1");
                userMessageManager.sendSystemMessage(msgContent, ApplicationCategoryEnum.meeting, createUser, receiver, MeetingMessageTypeEnum.Meeting_Notification.key());
              //给代理人发送消息
    			Long agentId = MemberAgentBean.getInstance().getAgentMemberId(ApplicationCategoryEnum.meeting.ordinal(), createUser);
    			if(null != agentId){
    				MessageContent agentMsgContent = MessageContent.get(msgKey, meetingTitle);
    				agentMsgContent = agentMsgContent.add("meeting.agent");
    	    		 MessageReceiver agentReceiver = MessageReceiver.get(meetingId, agentId, "message.link.mt.send", meetingId, "0", "-1");
    	                userMessageManager.sendSystemMessage(agentMsgContent, ApplicationCategoryEnum.meeting, createUser, agentReceiver, MeetingMessageTypeEnum.Meeting_Notification.key());
    			}
            }
        }
	}
	
	/**
     * 发送会议存在冲突消息——发送给会议冲突人
     * @param messageMap
     * @throws BusinessException
     */
    @Override
    public void sendconfereesConflictMessage(Map<String, Object> messageMap) throws BusinessException {
        String title = (String)messageMap.get("title");
        String title1 = (String)messageMap.get("title1");
        Long meetingId = (Long)messageMap.get("meetingId");
        Long createUser = (Long)messageMap.get("createUser");
        Long memberId = (Long)messageMap.get("memberId");
        
        MessageReceiver receiverList = MessageReceiver.get(meetingId, memberId);
        
        MessageContent messageContent = MessageContent.get("mt.collide", title, title1);
        userMessageManager.sendSystemMessage(messageContent, ApplicationCategoryEnum.meeting, createUser, receiverList, MeetingMessageTypeEnum.Meeting_Notification.key());
    }
	
	/**
	 * 会议提前提醒消息-发给参会人员
	 * @param newVo
	 * @throws BusinessException
	 */
	@Override
	public void sendMeetingRemindMessage(MeetingNewVO newVo) throws BusinessException {
		if(CollectionUtils.isNotEmpty(newVo.getAffairMemberIdList())) {
			String meetingTitle = newVo.getMeeting().getTitle();
			Date beginDate = newVo.getMeeting().getBeginDate();
			String content = newVo.getMeeting().getContent();
			String bodyType = newVo.getMeeting().getDataFormat();
			Date createDate = newVo.getMeeting().getCreateDate();
			Long createUser = newVo.getMeeting().getCreateUser();
			Long meetingId = newVo.getMeeting().getId();
			
			MessageContent msg = MessageContent.get("mt.remind", meetingTitle, beginDate);
			msg.setBody(content, bodyType, createDate);
			for(Long memberId : newVo.getAffairMemberIdList()) {
				MessageReceiver receiver = MessageReceiver.get(meetingId, memberId, "message.link.mt.send", meetingId, "0", "-1");
				userMessageManager.sendSystemMessage(msg, ApplicationCategoryEnum.meeting, createUser, receiver, MeetingMessageTypeEnum.Meeting_Notification.key());		
			}
		}
	}
	
	/**
	 * 会议撤销消息-发给参会人员
	 * @param newVo
	 * @throws BusinessException
	 */
	@Override
	public void sendMeetingCancelMessage(MeetingNewVO newVo) throws BusinessException {
		String meetingTitle = newVo.getMeeting().getTitle();
		Date beginDate = newVo.getMeeting().getBeginDate();
		Date endDate = newVo.getMeeting().getEndDate();
		String content = newVo.getMeeting().getContent();
		String bodyType = newVo.getMeeting().getDataFormat();
		Date createDate = newVo.getMeeting().getCreateDate();
		Long createUser = newVo.getMeeting().getCreateUser();
		String createUserName = MeetingHelper.getMemberNameByUserId(createUser);
		Long meetingId = newVo.getMeeting().getId();
		boolean isForceSMS = "1".equals(newVo.getMeeting().getIsSendTextMessages());
		
		List<Long> memberIdCanelList = new ArrayList<Long>();
		
		for(MtReply oldMtReply : newVo.getOldMtReplyList()) {
			memberIdCanelList.add(oldMtReply.getUserId());
		}
		
		if(memberIdCanelList.contains(createUser)) {
			memberIdCanelList.remove(createUser);
		}
		if(Strings.isNotEmpty(memberIdCanelList)) {
			MessageContent msgContent = MessageContent.get("mt.cancel", meetingTitle, createUserName, beginDate, endDate);
			msgContent.setBody(content, bodyType, createDate);
			Collection<MessageReceiver> receiverList = MessageReceiver.get(meetingId, memberIdCanelList, isForceSMS);
			userMessageManager.sendSystemMessage(msgContent, ApplicationCategoryEnum.meeting, createUser, receiverList, MeetingMessageTypeEnum.Meeting_Notification.key());
		}
	}
	
	/**
	 * 会议撤销消息
	 * @param parameterMap
	 * @throws BusinessException
	 */
	@Override
	@SuppressWarnings("unchecked")
	public void sendMeetingCancelMessage(Map<String, Object> messageMap) throws BusinessException {
		String title = (String)messageMap.get("title");
		Long meetingId = (Long)messageMap.get("meetingId");
		Long createUser = (Long)messageMap.get("createUser");
		List<Long> memberIdList = (List<Long>)messageMap.get("memberIdList");
		String content = (String)messageMap.get("content");
		User currentUser = (User)messageMap.get("currentUser");
		boolean sendSMS = MeetingUtil.getBoolean(messageMap, "sendSMS", false);
		
		Collection<MessageReceiver> receiverList = MessageReceiver.get(meetingId, memberIdList, sendSMS);
    	
		MessageContent messageContent = MessageContent.get("meeting.message.cancel", title, currentUser.getName(), content);
		userMessageManager.sendSystemMessage(messageContent, ApplicationCategoryEnum.meeting, createUser, receiverList, MeetingMessageTypeEnum.Meeting_Notification.key());
	}
	
	/**
	 * 邀请会议消息-发给新增参会人员
	 * @param meeting
	 * @param currentUser
	 * @param affairMemberList
	 * @throws BusinessException
	 */
	@Override
	public void sendInviteMessage(MtMeeting meeting, User currentUser, List<Long> affairMemberList) throws BusinessException {
		MessageContent content = MessageContent.get("mt.invite", meeting.getTitle(), currentUser.getName(), meeting.getBeginDate());
		content.setBody(meeting.getContent(), meeting.getDataFormat(), meeting.getCreateDate());
		
		Collection<MessageReceiver> receivers = MessageReceiver.getReceivers(meeting.getId(), affairMemberList, "message.link.mt.invite", meeting.getId().toString(),"0","-1");
		
		// 给被邀请人员发送被邀请消息
        userMessageManager.sendSystemMessage(content, ApplicationCategoryEnum.meeting, currentUser.getId(), receivers, MeetingMessageTypeEnum.Meeting_Notification.key());

	}
	
	/**
	 * 回执消息
	 * @param parameterMap
	 * @throws BusinessException
	 */
	@Override
	@SuppressWarnings("unchecked")
	public void sendReplyMessage(Map<String, Object> messageMap) throws BusinessException {
		List<Long> memberIdList = (List<Long>)messageMap.get("memberIdList");
		Long meetingId = (Long)messageMap.get("meetingId");
		Long userId = (Long)messageMap.get("userId");
		String userName = (String)messageMap.get("userName");
		Integer feedbackFlag = (Integer)messageMap.get("feedbackFlag");
		Integer proxyType = (Integer)messageMap.get("proxyType");
		Integer contentType = (Integer)messageMap.get("contentType");
		String title = (String)messageMap.get("title");
		
		//回复内容
		String replyContent = (String)messageMap.get("replyContent");
		String feedback = MessageUtil.getComment4Message(replyContent);
		
		MessageContent content = MessageContent.get("meeting.message.reply", title, userName, feedbackFlag, contentType, feedback, proxyType, userName);
		Collection<MessageReceiver> receiverList = MessageReceiver.get(meetingId, memberIdList);
		userMessageManager.sendSystemMessage(content, ApplicationCategoryEnum.meeting, userId, receiverList, MeetingMessageTypeEnum.Meeting_Reply.key());
	}
	
	@Override
	@SuppressWarnings("unchecked")
	public void sendCommentMessage(Map<String, Object> messageMap) throws BusinessException {
		List<Long> memberIdList = (List<Long>)messageMap.get("memberIdList");
		List<Long> hiddenIdList = (List<Long>)messageMap.get("hiddenIdList");
		Long meetingId = (Long)messageMap.get("meetingId");
		Long userId = (Long)messageMap.get("userId");
		String userName = (String)messageMap.get("userName");
		String title = (String)messageMap.get("title");
		String commentContent = (String)messageMap.get("commentContent");
		
		Long replyUserId = (Long)messageMap.get("replyUserId");
		String replyUserName = "";
		if(replyUserId != null) {
			V3xOrgMember member = orgManager.getMemberById(replyUserId);
			if(member != null) {
				replyUserName = member.getName();
			}
		}
		
		if(Strings.isNotEmpty(memberIdList)) {
			MessageContent content = new MessageContent("mt.comment", title, userName, replyUserName, 1, commentContent);			
			List<MessageReceiver> receiverList = new ArrayList<MessageReceiver>();
			
			for(Long memberId : memberIdList) {
				receiverList.add(MessageReceiver.get(meetingId, memberId, "message.link.mt.send", meetingId, 0, -1));
			}
			
			userMessageManager.sendSystemMessage(content, ApplicationCategoryEnum.meeting, userId, receiverList, MeetingMessageTypeEnum.Meeting_Notification.key());
		}
		
		if(Strings.isNotEmpty(hiddenIdList)) {
			MessageContent content = new MessageContent("mt.comment", title, userName, replyUserName, 0, commentContent);
			
			List<MessageReceiver> receiverList = new ArrayList<MessageReceiver>();
			
			for(Long memberId : hiddenIdList) {
				receiverList.add(MessageReceiver.get(meetingId, memberId, "message.link.mt.send", meetingId, 0, -1));
			}
			
			userMessageManager.sendSystemMessage(content, ApplicationCategoryEnum.meeting, userId, receiverList, MeetingMessageTypeEnum.Meeting_Notification.key());
		}
    }
	
	/**
	 * 提前结束消息
	 * @param parameterMap
	 * @throws BusinessException
	 */
	@Override
	@SuppressWarnings("unchecked")
	public void sendFinishAdvanceMessage(Map<String, Object> messageMap) throws BusinessException {
		String title = (String)messageMap.get("title");
		Long meetingId = (Long)messageMap.get("meetingId");
		Long createUser = (Long)messageMap.get("createUser");
		List<Long> memberIdList = (List<Long>)messageMap.get("memberIdList");
		
		if(memberIdList.contains(createUser)) {
			memberIdList.remove(createUser);
		}
		if(Strings.isNotEmpty(memberIdList)) {
			MessageContent content = MessageContent.get("meeting.msg.finish.advance", title);
			Collection<MessageReceiver> receiverList = MessageReceiver.getReceivers(meetingId, memberIdList, "message.link.mt.send", meetingId, "0", "-1");
			userMessageManager.sendSystemMessage(content, ApplicationCategoryEnum.meeting, createUser, receiverList, MeetingMessageTypeEnum.Meeting_Notification.key());
		}
	}
	
	
	
	/**
	 * 会议室管理员变更消息
	 * @param roomVo
	 * @throws BusinessException
	 */
	@Override
	public void sendRoomAdminMessage(MeetingRoomVO roomVo) throws BusinessException {
		
		if(!roomVo.isNew()) {
		    Long currentUserId = roomVo.getCurrentUser().getId();
			String newadmin = roomVo.getAdmin();
			String oldadmin = "";
			
			String newMngdepids = roomVo.getMngdepId();
			String oldMngdepids = "";
			
			MeetingRoom oldRoom = roomVo.getOldRoom();
			if(oldRoom != null) {
				oldadmin = oldRoom.getAdmin();
				oldMngdepids = oldRoom.getMngdepId();
			}
			
			List<Long> newAdminList = MeetingRoomAdminUtil.getRoomAdminIdList(roomVo.getMeetingRoom());
			//过滤掉当前登录者
            if (newAdminList.contains(currentUserId)) {
                newAdminList.remove(currentUserId);
            }
			// 当修改了管理员的时候，发送消息
			if(!oldadmin.equals(newadmin)) {
				List<Long> oldAdminList = MeetingRoomAdminUtil.getRoomAdminIdList(roomVo.getOldRoom());
				//过滤掉当前登录者
				if (oldAdminList.contains(currentUserId)) {
				    oldAdminList.remove(currentUserId);
				}
				MessageContent content = MessageContent.get("mr.alert.canceladmin", new Object[] { roomVo.getName(), roomVo.getCurrentUser().getName() });
				for(Long oldAdmin : oldAdminList) {
					if(!newAdminList.contains(oldAdmin)) {
						MessageReceiver receiver = MessageReceiver.get(roomVo.getId(), oldAdmin);
						userMessageManager.sendSystemMessage(content, ApplicationCategoryEnum.meeting, roomVo.getCurrentUser().getId(), receiver, MeetingMessageTypeEnum.Meeting_RoomCheck.key());						
					}
				}
				
				content = MessageContent.get("mr.alert.addadmin", new Object[] { roomVo.getName(), roomVo.getCurrentUser().getName() });
				for(Long newAdmin : newAdminList) {
					if(!oldAdminList.contains(newAdmin)) {
						MessageReceiver receiver = MessageReceiver.get(roomVo.getId(), newAdmin);
						userMessageManager.sendSystemMessage(content, ApplicationCategoryEnum.meeting, roomVo.getCurrentUser().getId(), receiver, MeetingMessageTypeEnum.Meeting_RoomCheck.key());
					}
				}
			}
			
			// 当修改了管理范围的时候，发送消息
			if(!oldMngdepids.equals(newMngdepids)) {
				List<Long> newMngdepIdList = MeetingUtil.getOrgIdList(newMngdepids);
				List<Long> oldMngdepIdList = MeetingUtil.getOrgIdList(oldMngdepids);
				
				String addMngdepnames = "";
				String removeMngdepnameds = "";
				
				for(Long newMngdepId : newMngdepIdList) {
					if(!oldMngdepIdList.contains(newMngdepId)) {
						if(Strings.isNotBlank(addMngdepnames)) {
							addMngdepnames += ",";
						}
						addMngdepnames += orgManager.getUnitById(newMngdepId)==null?orgManager.getPostById(newMngdepId).getName():orgManager.getUnitById(newMngdepId).getName();
					}
				}
				for(Long oldMngdepId : oldMngdepIdList) {
					if(!newMngdepIdList.contains(oldMngdepId)) {
						if(Strings.isNotBlank(removeMngdepnameds)) {
							removeMngdepnameds += ",";
						}
						removeMngdepnameds += orgManager.getUnitById(oldMngdepId)==null?orgManager.getPostById(oldMngdepId).getName():orgManager.getUnitById(oldMngdepId).getName();
						break;
					}
				}	
				
				MessageContent mngAddContent = null;
				MessageContent mngRemoveContent = null;
				if(Strings.isNotBlank(addMngdepnames)) {
					mngAddContent = MessageContent.get("mr.alert.addAppRange", new Object[] { roomVo.getName(), roomVo.getCurrentUser().getName(), addMngdepnames });
				}
				if(Strings.isNotBlank(removeMngdepnameds)) {
					mngRemoveContent = MessageContent.get("mr.alert.cancelAppRange", new Object[] { roomVo.getName(), roomVo.getCurrentUser().getName(), removeMngdepnameds });
				}
				for(Long newAdmin : newAdminList) {
					MessageReceiver receiver = MessageReceiver.get(roomVo.getId(), newAdmin);
					
					if(mngAddContent != null) {
						userMessageManager.sendSystemMessage(mngAddContent, ApplicationCategoryEnum.meeting, roomVo.getCurrentUser().getId(), receiver, MeetingMessageTypeEnum.Meeting_RoomCheck.key());
					}
					if(mngRemoveContent != null) {
						userMessageManager.sendSystemMessage(mngRemoveContent, ApplicationCategoryEnum.meeting, roomVo.getCurrentUser().getId(), receiver, MeetingMessageTypeEnum.Meeting_RoomCheck.key());
					}
				}
			}
		}
	}
	
	/**
	 * 会议室申请消息-发给会议室管理员
	 * @param appVo
	 * @throws BusinessException
	 */
	@Override
	public void sendRoomAppMessage(MeetingRoomAppVO appVo) throws BusinessException {
		Long userId = appVo.getCurrentUser().getId();
		String userName = appVo.getCurrentUser().getName();
		String roomName = appVo.getMeetingRoom().getName();
		String appDescription = appVo.getMeetingRoomApp().getDescription();
		appDescription = appDescription==null ? "" : appDescription;
		
		List<Long> auditingIdList = appVo.getAuditingIdList();
		if(auditingIdList.contains(userId)) {
			auditingIdList.remove(userId);
		}
		if(Strings.isNotEmpty(auditingIdList)) {
			
			MessageContent msgContent = MessageContent.get("mr.label.pleaseperm", userName, roomName, appDescription);
			
			String periodicityId = "-1";
			if(!MeetingUtil.isIdNull(appVo.getMeetingRoomApp().getPeriodicityId())) {
				periodicityId = String.valueOf(appVo.getMeetingRoomApp().getPeriodicityId());
			}
			Collection<MessageReceiver> receivers = MessageReceiver.getReceivers(appVo.getMeetingRoomApp().getId(), auditingIdList, "message.link.mt.room_perm", appVo.getMeetingRoomApp().getId(), "0", "-1", periodicityId);
			
			for(Long memberId : auditingIdList) {
				Long agentId = MemberAgentBean.getInstance().getAgentMemberId(ApplicationCategoryEnum.meeting.key(), memberId);
				if(agentId != null) {
					MessageReceiver receiver = MessageReceiver.get(appVo.getMeetingRoomApp().getId(), agentId, "message.link.mt.room_perm");
					
					String[] linkParams = new String[4];
					linkParams[0] = String.valueOf(appVo.getMeetingRoomApp().getId());
					linkParams[1] = "1";
					linkParams[2] = String.valueOf(memberId);
					linkParams[3] = periodicityId;
					receiver.setLinkParam(linkParams);
					
					receivers.add(receiver);
				}
			}
			userMessageManager.sendSystemMessage(msgContent, ApplicationCategoryEnum.meeting, userId, receivers, MeetingMessageTypeEnum.Meeting_RoomCheck.key());
			
			if (null != appVo.getMeeting()) {
			        //请等待会议室的审核，审核通过后您的通知会正式发出
			        msgContent = MessageContent.get("mt.wait.meeting.room", userName);
			} else {
			    //您申请的会议室已经提交成功，请等待会议室管理人员的审核！
			    msgContent = MessageContent.get("mt.wait.meeting.roomApp", userName);
			}
	        MessageReceiver receiver = MessageReceiver.get(appVo.getMeetingId(), appVo.getCurrentUser().getId());
            userMessageManager.sendSystemMessage(msgContent, ApplicationCategoryEnum.meeting, AppContext.getCurrentUser().getId(), receiver, MeetingMessageTypeEnum.Meeting_RoomCheck.key());
		}
	}
	
	/**
	 * 会议室申请消息-发给会议室管理员
	 * @param appVo
	 * @throws BusinessException
	 */
	@Override
	public void sendNoticeMessage(MeetingRoomAppVO appVo) throws BusinessException {
		Long userId = appVo.getCurrentUser().getId();
		String userName = appVo.getCurrentUser().getName();
		String roomName = appVo.getMeetingRoom().getName();
		String[] admins = appVo.getMeetingRoom().getAdmin().split(",");
		String description = appVo.getDescription();
		if (appVo.getMeeting()!=null){
			description = appVo.getMeeting().getTitle();
		}
		description = description==null ? "" : description;
		List<Long> auditingIdList = new ArrayList<Long>();
		for (String memberid : admins) {
			auditingIdList.add(Long.parseLong(memberid));
		}
		if(auditingIdList.contains(userId)) {
			auditingIdList.remove(userId);
		}
		if(Strings.isNotEmpty(auditingIdList)) {
			//添加会议用品
			Long meetingId = appVo.getMeetingRoomApp().getMeetingId();
			String resourcesNames = new String();
			if (null != meetingId) {
				resourcesNames = meetingResourcesManager.getResourceNamesByMeetingId(meetingId);
			}
			String key = "mr.label.noticeperm";
			MessageContent msgContent = new MessageContent();
			if(Strings.isNotEmpty(resourcesNames)){
				key = "mr.label.noticeperm1";
				msgContent = MessageContent.get(key, userName, roomName, appVo.getStartDatetime(), appVo.getEndDatetime(), resourcesNames,description);
			}else{
				msgContent = MessageContent.get(key, userName, roomName, description);
			}
			String periodicityId = "-1";
			if(!MeetingUtil.isIdNull(appVo.getMeetingRoomApp().getPeriodicityId())) {
				periodicityId = String.valueOf(appVo.getMeetingRoomApp().getPeriodicityId());
			}
			Collection<MessageReceiver> receivers = MessageReceiver.getReceivers(appVo.getMeetingRoomApp().getId(), auditingIdList, "", appVo.getMeetingRoomApp().getId(), "0", "-1", periodicityId);
			for(Long memberId : auditingIdList) {
				Long agentId = MemberAgentBean.getInstance().getAgentMemberId(ApplicationCategoryEnum.meeting.key(), memberId);
				if(agentId != null) {
					MessageReceiver receiver = MessageReceiver.get(appVo.getMeetingRoomApp().getId(), agentId, "");
					
					String[] linkParams = new String[4];
					linkParams[0] = String.valueOf(appVo.getMeetingRoomApp().getId());
					linkParams[1] = "1";
					linkParams[2] = String.valueOf(memberId);
					linkParams[3] = periodicityId;
					receiver.setLinkParam(linkParams);
					
					receivers.add(receiver);
				}
			}
			userMessageManager.sendSystemMessage(msgContent, ApplicationCategoryEnum.meeting, userId, receivers, MeetingMessageTypeEnum.Meeting_RoomCheck.key());
		}
	}
	
	/**
	 * 会议室审核消息-发给申请人
	 * @param appVo
	 * @throws BusinessException
	 */
	@Override
	public void sendRoomPermMessage(MeetingRoomAppVO appVo) throws BusinessException {
		MeetingRoomPerm bean = appVo.getMeetingRoomPerm();
		String roomName = appVo.getMeetingRoom().getName();
		String permDescription = appVo.getMeetingRoomPerm().getDescription();		
		String msgKey = "mr.alert.permno";
		//审批通过
		if(MeetingHelper.isRoomPass(bean.getIsAllowed())) {
			msgKey = "mr.alert.permok";
		}
		MessageContent msg = MessageContent.get(msgKey, roomName, permDescription);
		
		Long dealUserId = appVo.getCurrentUser().getId();
		Long appUserId = appVo.getMeetingRoomApp().getPerId();
		if(appVo.getCurrentAffair()!=null && appVo.getCurrentAffair().getMemberId().longValue()!=appVo.getCurrentUser().getId().longValue()) {
			dealUserId = appVo.getCurrentAffair().getMemberId();
		}
		MessageReceiver receiver = MessageReceiver.get(appVo.getMeetingRoomApp().getId(), appUserId);
		userMessageManager.sendSystemMessage(msg, ApplicationCategoryEnum.meeting, dealUserId, receiver, MeetingMessageTypeEnum.Meeting_RoomCheck.key());
	}
	
	/**
	 * 会议室审核不通过消息
	 * @param room
	 * @param perIdList
	 * @throws BusinessException
	 */
	@Override
	public void sendRoomRefuseMessage(MeetingRoom room, List<Long> perIdList) throws BusinessException {
		MessageContent content = MessageContent.get("mr.alert.bestopped", new Object[]{room.getName()});
		for(Long perId : perIdList) {
			MessageReceiver receiver = MessageReceiver.get(new Long(ApplicationCategoryEnum.meetingroom.getKey()), perId);
			this.userMessageManager.sendSystemMessage(content, ApplicationCategoryEnum.meeting, perId, receiver, MeetingMessageTypeEnum.Meeting_RoomCheck.key());
		}
	}
	
	/**
	 * 会议室撤销消息(预订撤销-发给会议室管理员，会议室审核撤销-发给申请人)
	 * @param messageMap
	 * @throws BusinessException
	 */
	@Override
	@SuppressWarnings("unchecked")
	public void sendRoomAppCancelMessage(Map<String, Object> messageMap) throws BusinessException {
		Long toCreateUser = messageMap.get("toCreateUser")==null ? Constants.GLOBAL_NULL_ID : (Long)messageMap.get("toCreateUser");
		Long createUser = (Long)messageMap.get("createUser");
		String createUserName = MeetingHelper.getMemberNameByUserId(createUser);
		String roomName = (String)messageMap.get("roomName");
		String cancelContent = (String)messageMap.get("cancelContent");
		Long roomAppId = (Long)messageMap.get("roomAppId");
		List<Long> memberIdList = (List<Long>)messageMap.get("memberIdList");
				
		String msgKey = "meeting.msg.room.app.cancel";
		if(toCreateUser!=null && toCreateUser.longValue()!=createUser.longValue()) {
			msgKey = "meeting.msg.room.app.admin.cancel";
			memberIdList.add(toCreateUser);
		}

		if(memberIdList.contains(createUser)) {
			memberIdList.remove(createUser);
		}
		MessageContent msgContent = MessageContent.get(msgKey, createUserName, roomName, Strings.isBlank(cancelContent)?0:1, cancelContent);
		Collection<MessageReceiver> receivers = MessageReceiver.get(roomAppId, memberIdList);
		userMessageManager.sendSystemMessage(msgContent, ApplicationCategoryEnum.meeting, createUser, receivers, MeetingMessageTypeEnum.Meeting_RoomCheck.key());
	}
	
	/**
	 * 发送撤销会议纪要消息
	 * @param messageMap
	 * @throws BusinessException
	 */
	@SuppressWarnings("unchecked")
	public void sendSummaryCancelMessage(Map<String, Object> messageMap) throws BusinessException {
		List<Long> memberIdList = (List<Long>)messageMap.get("memberIdList");
		Long summaryId = (Long)messageMap.get("summaryId");
		Long createUser = (Long)messageMap.get("createUser");
		String createUserName = MeetingHelper.getMemberNameByUserId(createUser);
		String title = (String)messageMap.get("title");
		
		String cancelContent = (String)messageMap.get("cancelContent");
		
		Collection<MessageReceiver> receivers = MessageReceiver.get(summaryId, memberIdList);
		MessageContent msgContent = MessageContent.get("mt.summary.cancel", createUserName, title, cancelContent);
		userMessageManager.sendSystemMessage(msgContent, ApplicationCategoryEnum.meeting, createUser, receivers, MeetingMessageTypeEnum.Meeting_Summary.key());
	}
	
	/**
     * 发送发起会议纪要消息
     * @param messageMap
     * @throws BusinessException
     */
    @SuppressWarnings("unchecked")
    public void sendSummaryMessage(Map<String, Object> messageMap) throws BusinessException {
        List<Long> memberIdList = (List<Long>)messageMap.get("memberIdList");
        Long summaryId = (Long)messageMap.get("summaryId");
        Long createUser = (Long)messageMap.get("createUser");
        String createUserName = MeetingHelper.getMemberNameByUserId(createUser);
        String title = (String)messageMap.get("title");
        Boolean isEdit = (Boolean) messageMap.get("isEdit");
        String msgKey = "mt.summary.send";
        //编辑会议纪要
        if (isEdit){
            msgKey = "mt.summary.edit2";
        }
        
        MessageContent msgContent = MessageContent.get(msgKey, createUserName, title);
        Collection<MessageReceiver> receiverList = MessageReceiver.getReceivers(summaryId, memberIdList, "message.link.mt.send.scope",summaryId);
        
        userMessageManager.sendSystemMessage(msgContent, ApplicationCategoryEnum.meeting, createUser, receiverList, MeetingMessageTypeEnum.Meeting_Summary.key());
    }
	
	/**
	 * 该方法只用于MessageReceiver.get()获取多人员时，编译错误，慎用
	 * @param referenceId
	 * @param receiverIds
	 * @param linkType
	 * @param openType
	 * @param isForceSMS
	 * @param linkParam
	 * @return
	 */
	private static Collection<MessageReceiver> getReceivers(Long referenceId, Collection<Long> receiverIds, String linkType, LinkOpenType openType, boolean isForceSMS, Object... linkParam) {
		Set<MessageReceiver> r = new HashSet<MessageReceiver>();
		if (receiverIds != null && !receiverIds.isEmpty()) {
			for (Long receiverId : receiverIds) {
				r.add(new MessageReceiver(referenceId, receiverId, linkType, openType, isForceSMS, linkParam));
			}
		}
		return r;
	}
	
	/****************************** 依赖注入 **********************************/
	public void setUserMessageManager(UserMessageManager userMessageManager) {
		this.userMessageManager = userMessageManager;
	}
	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}
	public void setMeetingTypeManager(MeetingTypeManager meetingTypeManager) {
        this.meetingTypeManager = meetingTypeManager;
    }
	public void setAppLogManager(AppLogManager appLogManager) {
		this.appLogManager = appLogManager;
	}
	public MeetingResourcesManager getMeetingResourcesManager() {
		return meetingResourcesManager;
	}
	public void setMeetingResourcesManager(MeetingResourcesManager meetingResourcesManager) {
		this.meetingResourcesManager = meetingResourcesManager;
	}

	@Override
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void sendRoomAppRemindersMessage(Map<String, Object> messageMap) throws BusinessException {
		Long createUser = (Long) messageMap.get("senderId");
		List<Long> receiverList = (List) messageMap.get("receiverIds");
		// 是否发送短信
		Boolean sendPhoneMessage = (Boolean) messageMap.get("sendPhoneMessage");
		Long roomAppId = (Long) messageMap.get("roomAppId");
		String periodicityId = (String) messageMap.get("periodicityId");
		String content = (String) messageMap.get("content");
		String sendname = (String) messageMap.get("sendname");
		String roomname = (String) messageMap.get("roomname");
		MeetingRoom mr =  (MeetingRoom) messageMap.get("meetingroom");
		MessageContent msgContent = MessageContent.get("mr.label.remindersperm",
				new Object[] { sendname, roomname, content });
		// 多个接收者，一样的链接
		Collection<MessageReceiver> receivers = getReceivers(
				new Long(ApplicationCategoryEnum.meetingroom.getKey()), receiverList, "message.link.mt.room_perm",
				LinkOpenType.open, sendPhoneMessage, roomAppId, "0", "-1", periodicityId);
		// 处理人代理
		for(Long memberId : receiverList) {
			Long agentId = MemberAgentBean.getInstance().getAgentMemberId(ApplicationCategoryEnum.meeting.key(), memberId);
			if(agentId != null) {
				List<Long> meetingRoomAdmins=MeetingRoomAdminUtil.getRoomAdminIdList(mr);
				boolean isAgentAdmin = meetingRoomAdmins.contains(agentId);
				// 代理会议室管理员要检查是否是本会议室管理员，是才可以发送消息，不是，不发送
				if (isAgentAdmin) {
					MessageReceiver receiver = MessageReceiver.get(roomAppId, agentId, "message.link.mt.room_perm");
					String[] linkParams = new String[4];
					linkParams[0] = String.valueOf(roomAppId);
					linkParams[1] = "1";
					linkParams[2] = String.valueOf(memberId);
					linkParams[3] = periodicityId;
					receiver.setLinkParam(linkParams);
					receivers.add(receiver);
				}
			}
		}
        userMessageManager.sendSystemMessage(msgContent, ApplicationCategoryEnum.meeting, createUser, receivers, MeetingMessageTypeEnum.Meeting_RoomCheck.key());
	}

	@Override
	@SuppressWarnings("unchecked")
	public void sendMeetingReceiptMessage(Map<String, Object> messageMap) throws BusinessException {
		Long createUser = (Long) messageMap.get("senderId");
		List<Long> receiverList = (List<Long>) messageMap.get("receiverIds");
		Long meetingId = (Long) messageMap.get("meetingId");
		Boolean sendPhoneMessage = messageMap.get("sendPhoneMessage") == null ? false
				: (Boolean) messageMap.get("sendPhoneMessage"); // 是否发送短信
		
		String msgContentKey = "";
		Object[] msgContentVal = null;
		String content = "";
		String sendname = "";
		String meetingTitle = "";
		User user = new User();
		String sendTerminal = (String) messageMap.get("sendTerminal");
		if (null != sendTerminal && "M3".equals(sendTerminal)) {
			MtMeeting mt = (MtMeeting) messageMap.get("mtmeeting");
			sendname = mt.getCreateUserName() == null ? orgManager.getMemberById(mt.getCreateUser()).getName()
					: mt.getCreateUserName();
			meetingTitle = mt.getTitle();
			msgContentKey = "mr.label.remindersmeetingreceiptM3";
			msgContentVal = new Object[] { sendname, meetingTitle };
			
			user = (User) messageMap.get("user");
		} else {
			content = (String) messageMap.get("content");
			sendname = (String) messageMap.get("sendname");
			meetingTitle = (String) messageMap.get("meetingTitle");
			msgContentKey = "mr.label.remindersmeetingreceipt";
			msgContentVal = new Object[] { sendname, meetingTitle, content };

			
			user.setId(createUser);
			user.setLoginAccount((Long) messageMap.get("loginAccount"));
			user.setRemoteAddr((String) messageMap.get("remoteAddr"));
		}
		// 记录催办会议回执日志
		appLogManager.insertLog(user, AppLog_MeetingRoomEnum.replyreminders.key(), sendname,
				meetingTitle);
		MessageContent msgContent = MessageContent.get(msgContentKey, msgContentVal);
		Collection<MessageReceiver> receivers = getReceivers(meetingId, receiverList, "message.link.mt.send",
				LinkOpenType.open, sendPhoneMessage, meetingId, "0", "-1");
		// 代理人处理
		for (Long receiverId : receiverList) {
			Long agentId = MemberAgentBean.getInstance().getAgentMemberId(ApplicationCategoryEnum.meeting.key(), receiverId);
			if (agentId != null) {
				MessageReceiver receiver = null;
				receiver = MessageReceiver.get(meetingId, agentId, "message.link.mt.send", LinkOpenType.open,
						sendPhoneMessage);
				String[] linkParams = new String[3];
				linkParams[0] = String.valueOf(meetingId);
				linkParams[1] = "1";
				linkParams[2] = String.valueOf(receiverId); // 传入被代理人的ID
				receiver.setLinkParam(linkParams);
				// 给代理人发消息
				MessageContent msgAgentContent = MessageContent.get(msgContentKey, msgContentVal).add("col.agentuser",
						orgManager.getMemberById(receiverId).getName());
				userMessageManager.sendSystemMessage(msgAgentContent, ApplicationCategoryEnum.meeting, createUser,
						receiver, MeetingMessageTypeEnum.Meeting_Reply.key());
			}
		}

		userMessageManager.sendSystemMessage(msgContent, ApplicationCategoryEnum.meeting, createUser, receivers,
				MeetingMessageTypeEnum.Meeting_Reply.key());
	}
	
}
