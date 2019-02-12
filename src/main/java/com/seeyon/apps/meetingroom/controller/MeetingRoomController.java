package com.seeyon.apps.meetingroom.controller;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.kdXdtzXc.manager.KDMeetingTypeManage;
import com.seeyon.apps.meeting.constants.MeetingConstant.DateFormatEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.MeetingActionEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.RoomAttEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.RoomNeedAppEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.RoomSortByEnum;
import com.seeyon.apps.meeting.constants.MeetingPathConstant;
import com.seeyon.apps.meeting.manager.MeetingManager;
import com.seeyon.apps.meeting.manager.MeetingResourcesManager;
import com.seeyon.apps.meeting.manager.MeetingTypeManager;
import com.seeyon.apps.meeting.manager.MeetingValidationManager;
import com.seeyon.apps.meeting.po.MeetingTemplate;
import com.seeyon.apps.meeting.po.MeetingType;
import com.seeyon.apps.meeting.util.MeetingUtil;
import com.seeyon.apps.meetingroom.manager.MeetingRoomManager;
import com.seeyon.apps.meetingroom.po.MeetingRoom;
import com.seeyon.apps.meetingroom.po.MeetingRoomApp;
import com.seeyon.apps.meetingroom.po.MeetingRoomPerm;
import com.seeyon.apps.meetingroom.util.MeetingRoomAdminUtil;
import com.seeyon.apps.meetingroom.util.MeetingRoomHelper;
import com.seeyon.apps.meetingroom.util.MeetingRoomRoleUtil;
import com.seeyon.apps.meetingroom.util.MeetingRoomUtil;
import com.seeyon.apps.meetingroom.vo.MeetingRoomAppVO;
import com.seeyon.apps.meetingroom.vo.MeetingRoomVO;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.Constants;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.filemanager.manager.AttachmentEditHelper;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.organization.OrgConstants.MemberPostType;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.bo.MemberPost;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;
import com.seeyon.v3x.meeting.domain.MtMeeting;
import com.seeyon.v3x.mobile.message.manager.MobileMessageManager;

import www.seeyon.com.utils.ReqUtil;

/**
 * 
 * @author 唐桂林
 *
 */
public class MeetingRoomController extends BaseController {
	
	private static final Log LOGGER = LogFactory.getLog(MeetingRoomController.class);

	private MeetingRoomManager meetingRoomManager;
	private MeetingTypeManager meetingTypeManager;
	private MeetingValidationManager meetingValidationManager;
	private MeetingManager meetingManager;
	private OrgManager orgManager;
	private AttachmentManager attachmentManager;
	private AffairManager affairManager;
	private MobileMessageManager mobileMessageManager;
	private MeetingResourcesManager meetingResourcesManager;
	private KDMeetingTypeManage kdMeetingTypeManage;
	
	
	public KDMeetingTypeManage getKdMeetingTypeManage() {
		return kdMeetingTypeManage;
	}

	public void setKdMeetingTypeManage(KDMeetingTypeManage kdMeetingTypeManage) {
		this.kdMeetingTypeManage = kdMeetingTypeManage;
	}

	/**
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView createAdd(HttpServletRequest request, HttpServletResponse response) throws Exception {
		boolean isAdmin = MeetingRoomRoleUtil.isMeetingRoomAdminRole();
		boolean isAccountAdmin = MeetingRoomRoleUtil.isAdministrator();
		if (!isAdmin && !isAccountAdmin) {
			return refreshWorkspace();
		}
		
		Long roomId = Strings.isBlank(request.getParameter("id")) ? -1L : Long.parseLong(request.getParameter("id"));
		String flag = request.getParameter("flag");
		
		User currentUser = AppContext.getCurrentUser();
		
		MeetingRoomVO roomVo = new MeetingRoomVO();
		
		if("register".equals(flag)) {
			// 单位管理员创建会议室不显示自己，因为单位管理员不是会议室管理员
			if (!isAccountAdmin) {
				roomVo.setAdminIds(String.valueOf(currentUser.getId()));
				roomVo.setAdminNames(currentUser.getName());
				roomVo.setAdminMembers("Member|" + currentUser.getId());
			}
		} else {
			MeetingRoom room = this.meetingRoomManager.getRoomById(roomId);
			if(room == null) {
				return refreshWorkspace();
			}
			
			//过滤当前会议室管理员
			roomVo = MeetingRoomHelper.convertToVO(roomVo, room);
			
			//获取当前会议室所属管理员
			String[] admins = MeetingRoomAdminUtil.getRoomAdmins(room);
			roomVo.setAdminIds(admins[0]);
			roomVo.setAdminNames(admins[1]);
			//设置已有的会议室管理员
			roomVo.setAdminMembers(admins[2]);
			
			//获取当前会议室管理范围
			roomVo.setMngdepId(room.getMngdepId());
			roomVo.setMngdepName(MeetingRoomUtil.getMeetingRoomMngdepNames(room.getMngdepId()));
			
			//获取当前会议室制度附件
			List<Attachment> attatchmentsC = this.attachmentManager.getByReference(room.getId(), RoomAttEnum.attachment.key());
			if (attatchmentsC.size() > 0) {
				roomVo.setAttatchments(attatchmentsC);
				roomVo.setAttObj(attatchmentsC.get(0));
			}
			
			//获取当前会议室制度附件
			List<Attachment> attatchmentsI = this.attachmentManager.getByReference(room.getId(), RoomAttEnum.image.key());
			if (attatchmentsI.size() > 0) {
				roomVo.setAttatchImage(attatchmentsI);
				roomVo.setImageObj(attatchmentsI.get(0));
			}
		}
			
		roomVo.setRoomAdminList(MeetingRoomRoleUtil.getMeetingRoomAdminList(AppContext.currentAccountId()));
		
		ModelAndView mav = new ModelAndView("meetingroom/createadd");
		mav.addObject("bean", roomVo);
		
		return mav;
	}
	
	/**
	 * 执行新建会议室操作
	 * 
	 * @param request
	 * @param response
	 * @return null,刷新add.jsp页面
	 * @throws Exception
	 */
	@CheckRoleAccess(roleTypes = {Role_NAME.MeetingRoomAdmin,Role_NAME.AccountAdministrator})
	public ModelAndView execAdd(HttpServletRequest request, HttpServletResponse response) throws Exception {
		StringBuffer buffer = new StringBuffer();
		String msgType = "success";
		
		User currentUser = AppContext.getCurrentUser();
		Long roomId = Strings.isBlank(request.getParameter("id")) ? -1L : Long.parseLong(request.getParameter("id"));
		String roomName = request.getParameter("name");
		Integer needApp = Strings.isBlank(request.getParameter("needApp")) ? RoomNeedAppEnum.no.key() : Integer.parseInt(request.getParameter("needApp"));
		Integer needMsg = Strings.isBlank(request.getParameter("needMsg")) ? RoomNeedAppEnum.no.key() : Integer.parseInt(request.getParameter("needMsg"));
		String _image = request.getParameter("image");//从页面得到图片的名字
		String _content = request.getParameter("filenameContent");
		boolean hasMeetingRoomApp = Strings.isBlank(request.getParameter("hasMeetingRoomApp")) ? false : Boolean.parseBoolean(request.getParameter("hasMeetingRoomApp"));
		
		if(!MeetingUtil.isIdNull(roomId)) {
			
			boolean isAdmin = MeetingRoomRoleUtil.isMeetingRoomAdminRole();
			//若会议室有有效会议室管理员，并且不是本人，且不是单位管理员，则不能修改
			List<Long> roleAdminList = MeetingRoomAdminUtil.getRoomAdminIdList(roomId);
			boolean isAccountAdmin = MeetingRoomRoleUtil.isAdministrator();
			if (Strings.isNotEmpty(roleAdminList) && !roleAdminList.contains(currentUser.getId()) && !isAccountAdmin) {
				isAdmin = false;
			}
			if (!isAdmin && !isAccountAdmin) {
				msgType = "notAdmin";
				buffer.append("parent._submitCallback('" + msgType + "', '"+ ResourceUtil.getString("mr.alert.notAdmin") +"');");
				rendJavaScript(response, buffer.toString());
				return null;
			}
		}		
		
		MeetingRoom repeatRoom = this.meetingValidationManager.checkRoomNameRepeat(roomId, roomName);
		if (repeatRoom != null) {
			msgType = "isRepeat";
			String accountName = orgManager.getUnitById(repeatRoom.getAccountId()).getName();
			if(repeatRoom.getAccountId().equals(AppContext.currentAccountId())){
				accountName = ResourceUtil.getString("mr.alert.currentAccount");
			}
			buffer.append("parent._submitCallback('" + msgType + "', '"+ ResourceUtil.getString("mr.alert.namesame", accountName) +"');");
			rendJavaScript(response, buffer.toString());
			return null;
		}
		
		MeetingRoomVO roomVo = new MeetingRoomVO();
		roomVo.setId(roomId);
		roomVo.setRoomId(roomId);
		roomVo.setName(roomName);
		roomVo.setContent(request.getParameter("content"));
		roomVo.setDescription(request.getParameter("description"));
		roomVo.setEqdescription(request.getParameter("eqdescription"));
		roomVo.setPlace(request.getParameter("place"));
		roomVo.setSeatCount(Integer.parseInt(request.getParameter("seatCount")));
		roomVo.setStatus(Integer.parseInt(request.getParameter("status")));
		roomVo.setAdmin(request.getParameter("adminIds"));
		roomVo.setMngdepId(request.getParameter("mngdepId"));
		roomVo.setImage(_image);
		roomVo.setSystemNowDatetime(DateUtil.currentDate());
		roomVo.setCurrentUser(currentUser);
		roomVo.setHasMeetingRoomApp(hasMeetingRoomApp);
		// 增加不用申请也发消息的处理(增加类型2为不用申请也需要发消息给管理员)
		if (RoomNeedAppEnum.no_but_need_msg.key() == needMsg) {
			roomVo.setNeedApp(needMsg);
		} else {
			roomVo.setNeedApp(needApp);
		}
		
		
		if(roomVo.isNew()) {
			roomVo.setIdIfNew();
		}
		
		try {
		
			if (!roomVo.isNew()) {
				this.attachmentManager.deleteByReference(roomVo.getId());
			}
			
			List<Attachment> attList = new ArrayList<Attachment>();
			AttachmentEditHelper editHelper = new AttachmentEditHelper(request);
			if(!Strings.isBlank(_image)) {
				editHelper.setSubReference(Long.parseLong(_image));
				//记录操作日志
				if(editHelper.hasEditAtt()){
					attachmentManager.deleteByReference(editHelper.getReference(), editHelper.getSubReference());
				}
				List<Attachment> attachments = attachmentManager.getAttachmentsFromRequest(ApplicationCategoryEnum.meetingroom, roomVo.getId(), RoomAttEnum.image.key(), request);
				if(attachments!=null && attachments.size()>0) {
					for(int i=0; i<attachments.size(); i++) {
						if(attachments.get(i).getFileUrl()==Long.parseLong(_image)) {
							Attachment attachment = attachments.get(i);
							attachment.setSubReference(RoomAttEnum.image.key());
							attList.add(attachment);
						}
					}
				}
			}
			
			if(!Strings.isBlank(_content)) {
				editHelper.setSubReference(Long.parseLong(_content));
				//记录操作日志
				if(editHelper.hasEditAtt()){
					attachmentManager.deleteByReference(editHelper.getReference(), editHelper.getSubReference());
				}
				List<Attachment> attachments = attachmentManager.getAttachmentsFromRequest(ApplicationCategoryEnum.meetingroom, roomVo.getId(), RoomAttEnum.attachment.key(), request);
				if(attachments!=null && attachments.size()>0) {
					for(int i=0; i<attachments.size(); i++) {
						if(attachments.get(i).getFileUrl()==Long.parseLong(_content)) {
							Attachment attachment = attachments.get(i);
							attachment.setSubReference(RoomAttEnum.attachment.key());
							attList.add(attachment);
						}
					}
				}
			}
			
			if(Strings.isNotEmpty(attList)) {
				attachmentManager.create(attList);
			}
			
			boolean ok = this.meetingRoomManager.transAdd(roomVo);
			if(!ok) {
				msgType = "failure";
			}
		} catch(Exception e) {
			LOGGER.error("登记会议室出错", e);
			msgType = "failure";
		}
		buffer.append("parent._submitCallback('" + msgType + "');");
		rendJavaScript(response, buffer.toString());
		
		return null;
	}


	/**
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@CheckRoleAccess(roleTypes = {Role_NAME.MeetingRoomAdmin,Role_NAME.AccountAdministrator})
	public ModelAndView execDelRoom(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String[] ids = request.getParameterValues("id");
		
		Map<String, Object> parameterMap = new HashMap<String, Object>();
        parameterMap.put("idList", MeetingUtil.getIdList(ids));
        
        try {
        	this.meetingRoomManager.transDelRoom(parameterMap);
        } catch(Exception e) {
        	LOGGER.error("删除会议类型出错", e);
        	parameterMap.put("msgType", "failure");
        	parameterMap.put("msg", e.getMessage());
        }
        boolean isAccountAdmin = MeetingRoomRoleUtil.isAdministrator();
        StringBuffer buffer = new StringBuffer();
        if(isAccountAdmin) {
			if (parameterMap.get("msgType").toString().equals("success")) {
				buffer.append("parent.location.reload();");
			} else {
				buffer.append("alert('" + parameterMap.get("msg") + "'); parent.location.reload();");
			}
        	//buffer.append("parent._submitCallbackAccount('"+parameterMap.get("msgType")+"', '"+parameterMap.get("msg")+"')");
        } else {
        	buffer.append("parent._submitCallback('"+parameterMap.get("msgType")+"', '"+parameterMap.get("msg")+"')");
        }
        rendJavaScript(response, buffer.toString());
        
        return null;
	}
	
	
	/**
	 * 申请会议室页面，弹出页面
	 * 
	 * @param request
	 * @param response
	 * @return 弹出createapp.jsp页面
	 * @throws Exception
	 */
	public ModelAndView createApp(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("meetingroom/createapp");
		
		User currentUser = AppContext.getCurrentUser();
		
		V3xOrgMember v3xOrgMember = this.orgManager.getMemberById(currentUser.getId());
		Long deptId = null;
		if(currentUser.getLoginAccount().longValue() != currentUser.getAccountId().longValue()) {
			List<MemberPost> postList = this.orgManager.getMemberPosts(currentUser.getLoginAccount().longValue(), currentUser.getId());
			if(Strings.isNotEmpty(postList)) {
				for(MemberPost post : postList) {
					if(post.getOrgAccountId().longValue()==currentUser.getLoginAccount().longValue() && MemberPostType.Concurrent.name().equals(post.getType().name())) {
						deptId = post.getDepId();
						break;
					}
				}
			}
		} else {
			deptId = v3xOrgMember.getOrgDepartmentId();	
		}
		
		Long roomId = MeetingUtil.getLong(request, "id", Constants.GLOBAL_NULL_ID);
		MeetingRoom room = this.meetingRoomManager.getRoomById(roomId);
		if(room != null) {
			room = new MeetingRoom();
		}
		
		// SZP 获取会议类型
		List<MeetingType> meetingTypeList = meetingTypeManager.getMeetingTypeList(v3xOrgMember.getOrgAccountId());

		List<Map<String, Object>> allMeetingType = kdMeetingTypeManage.getAllMeetingType();
		mav.addObject("allMeetingType",allMeetingType);
		mav.addObject("action","create");
		mav.addObject("bean", room);
		mav.addObject("user", v3xOrgMember);
		mav.addObject("meetingType", meetingTypeList);
		mav.addObject("v3xOrgDepartment", this.orgManager.getDepartmentById(deptId));
		mav.addObject("meetingRoomAdmin", MeetingRoomRoleUtil.isMeetingRoomAdminRole());
		return mav;
	}
	
	/**
	 * 执行会议室申请操作
	 * 
	 * @param request
	 * @param response
	 * @return null，关闭弹出窗口
	 * @throws Exception
	 */
	public ModelAndView execApp(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Map<String, String> parameterMap = new HashMap<String, String>();
		parameterMap.put("roomId", request.getParameter("roomId"));
		parameterMap.put("perId", request.getParameter("perId"));
		parameterMap.put("departmentId", request.getParameter("departmentId"));
		parameterMap.put("description", request.getParameter("description"));
		parameterMap.put("startDatetime", request.getParameter("startDatetime"));
		parameterMap.put("endDatetime", request.getParameter("endDatetime"));
		//项目  信达资产   公司  kimde  修改人  msg  修改时间    2017-11-09   修改功能   申请会议室页面添加申请人数量 和申请设备  start
		parameterMap.put("peopleNumber", request.getParameter("peopleNumber"));
		System.out.println("数量"+request.getParameter("peopleNumber"));
		System.out.println("设备"+request.getParameter("shebei "));
		parameterMap.put("shebei", request.getParameter("shebei"));
		parameterMap.put("meetingType", request.getParameter("meetingType"));
		parameterMap.put("meetingmiaoshu", request.getParameter("meetingmiaoshu"));
		//项目  信达资产   公司  kimde   修改人  msg  修改时间   2017-11-09   修改功能    申请会议室页面添加申请人数量和申请设备  end
		
		MeetingRoomAppVO appVo = new MeetingRoomAppVO();
		appVo.setAction(MeetingActionEnum.apply.name());
		appVo.setParameterMap(parameterMap);
		appVo.setCurrentUser(AppContext.getCurrentUser());
		appVo.setSystemNowDatetime(DateUtil.currentDate());
		
		try {
			this.meetingRoomManager.transApp(appVo);
		} catch(Exception e) {
			LOGGER.error("会议室申请失败", e);
			appVo.setMsg(ResourceUtil.getString("meeting.meetingroom.apply.failed"));
		}
		
		StringBuffer buffer = new StringBuffer();
		if(Strings.isBlank(request.getParameter("linkSectionId"))) {
			buffer.append("if(parent._submitCallback) {");
			buffer.append("  parent._submitCallback('" + appVo.getMsg() + "');");
			buffer.append("}");
			rendJavaScript(response, buffer.toString());
			return null;
		} else {
			if(appVo.getMeetingRoomApp() != null) {
				buffer.append(appVo.getMeetingRoomApp().getId()+"|"+appVo.getMsg());
			}
			super.rendText(response, buffer.toString());
			return null;
		}
	}
	
	/**
	 * 执行会议室申请操作
	 * 
	 * @param request
	 * @param response
	 * @return null，关闭弹出窗口
	 * @throws Exception
	 */
	public ModelAndView addRoomAppDesc(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Long roomAppId = Strings.isBlank(request.getParameter("roomAppId")) ? Constants.GLOBAL_NULL_ID : Long.parseLong(request.getParameter("roomAppId"));
		
		MeetingRoomAppVO appVo = new MeetingRoomAppVO();
		try {
			appVo.setRoomAppId(roomAppId);
			appVo.setDescription(request.getParameter("description"));
			meetingRoomManager.transAddRoomAppDesc(appVo);
		} catch(Exception e) {
			logger.error("会议室申请添加用途失败", e);
		}
		
		StringBuilder buffer = new StringBuilder();
		buffer.append("if(parent._submitCallback) {");
		buffer.append("  parent._submitCallback('" + appVo.getMsg() + "');");
		buffer.append("}");
		rendJavaScript(response, buffer.toString());
		return null; 
	}
	
	public ModelAndView execCancel(HttpServletRequest request, HttpServletResponse response) throws Exception {
		StringBuffer buffer = new StringBuffer();
		String msgType = "success";
		
		String[] ids = request.getParameterValues("id");
		if (ids != null && ids.length > 0) {
			Map<String, Object> parameterMap = new HashMap<String, Object>();
			parameterMap.put("roomAppIdList", MeetingUtil.getIdList(ids));
			parameterMap.put("currentUser", AppContext.getCurrentUser());
			parameterMap.put("cancelContent", request.getParameter("cancelContent"));
			parameterMap.put("action", MeetingActionEnum.cancelRoomApp.name());
			try {
				boolean result = this.meetingRoomManager.transCancelRoomApp(parameterMap);
				
				if(!result) {
					msgType = "failure"; 
				}
			} catch(Exception e) {
				LOGGER.error("撤销会议室申请出错", e);
				msgType = "failure";
			}
			
			if(Strings.isBlank(request.getParameter("linkSectionId"))) {
				buffer.append("if(parent._submitCallback) {");
				buffer.append("  parent._submitCallback('" + msgType + "');");
				buffer.append("}");
			}
		}
		
		rendJavaScript(response, buffer.toString());
		return null;
	}
	
	public ModelAndView execClearPerm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		StringBuffer buffer = new StringBuffer();
		String msgType = "success";
		
		String[] ids = request.getParameterValues("id");
		
		if (ids != null && ids.length > 0) {
			Map<String, Object> parameterMap = new HashMap<String, Object>();
			parameterMap.put("roomAppIdList", MeetingUtil.getIdList(ids));
			parameterMap.put("currentUser", AppContext.getCurrentUser());
			parameterMap.put("cancelContent", request.getParameter("cancelContent"));
			parameterMap.put("action", MeetingActionEnum.cancelRoomApp.name());
			try {
				boolean result = this.meetingRoomManager.transClearRoomPerm(parameterMap);
				
				if(!result) {
					msgType = "failure"; 
				}
			} catch(Exception e) {
				LOGGER.error("撤销会议室申请出错", e);
				msgType = "failure";
			}
			
			if(Strings.isBlank(request.getParameter("linkSectionId"))) {
				buffer.append("if(parent._submitCallback) {");
				buffer.append("  parent._submitCallback('" + msgType + "');");
				buffer.append("}");
			}
			
		}
		rendJavaScript(response, buffer.toString());
		return null;
	}

	
	public ModelAndView execFinish(HttpServletRequest request, HttpServletResponse response) throws Exception {
		StringBuffer buffer = new StringBuffer();
		String msgType = "success";
		
		String[] ids = request.getParameterValues("id");
		if(ids!=null && ids.length>0) {
			Map<String, Object> parameterMap = new HashMap<String, Object>();
			parameterMap.put("roomAppId", Long.parseLong(ids[0]));
			parameterMap.put("currentUser", AppContext.getCurrentUser());
			parameterMap.put("endDatetime", DateUtil.currentDate());
			parameterMap.put("action", MeetingActionEnum.finishRoomApp.name());
			parameterMap.put("isContainMeeting", request.getParameter("isContainMeeting"));
			try {
				boolean result = this.meetingRoomManager.transFinishAdvanceRoomApp(parameterMap);
				
				if(!result) {
					msgType = "failure"; 
				}
			} catch(Exception e) {
				LOGGER.error("提前结束会议室申请出错", e);
				msgType = "failure";
			}
		} else {
			msgType = "failure";
		}
		
		if(Strings.isBlank(request.getParameter("linkSectionId"))) {
			buffer.append("if(parent._submitCallback) {");
			buffer.append("  parent._submitCallback('" + msgType + "');");
			buffer.append("}");
		} else {
			
		}
		
		rendJavaScript(response, buffer.toString());
		return null;
	}
	
	/**
	 * 会议室审批页面
	 * 
	 * @param request
	 * @param response
	 * @return 转到createperm.jsp页面或者弹出createpermopen.jsp页面
	 * @throws Exception
	 */
	public ModelAndView createPerm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Long roomAppId = ReqUtil.getLong(request, "id", Constants.GLOBAL_NULL_ID);
		Long affairId = Strings.isBlank(request.getParameter("affairId"))?-1:Long.parseLong(request.getParameter("affairId"));
		String proxy = request.getParameter("proxy");
		
		String openWin = request.getParameter("openWin");
		String view = "meetingroom/createperm";
		if ("1".equals(openWin)) {//1 这里1只是起着标示的作用，没有什么特殊的意义(消息打开连接)
			view = "meetingroom/createpermopen";
		}
		ModelAndView mav = new ModelAndView(view);
		
		CtpAffair currentAffair = null;
		
		int confereeCount = 0;
		
		MeetingRoomAppVO appVo = new MeetingRoomAppVO();
		MeetingRoomApp roomApp = null;
		try {
			roomApp = this.meetingRoomManager.getRoomAppById(roomAppId);
			
			if(roomApp == null) {
				StringBuffer buffer = new StringBuffer();
				String msg = ResourceUtil.getString("meeting.room.app.cancel");
				buffer.append("alert('"+msg+"');");
				buffer.append("closeWindow();");
				buffer.append(getCloseWindowFunction());
				super.rendJavaScript(response, buffer.toString());
				return null;
			}
			
			if ("1".equals(openWin)) {//周期批量处理
				if(roomApp.getPeriodicityId() != null) {
					List<MeetingRoomApp> periodicityRoomAppList = this.meetingRoomManager.getWaitRoomAppListByPeriodicityId(roomApp.getPeriodicityId());
					if(Strings.isNotEmpty(periodicityRoomAppList)) {
						roomApp = periodicityRoomAppList.get(0);
						mav.addObject("periodicityRoomAppList", periodicityRoomAppList);
					}
				}
			}
			if(roomApp != null) {
				if(roomApp.getMeetingId() != null) {
					MtMeeting meeting = meetingManager.getMeetingById(roomApp.getMeetingId());
					if(meeting != null) {
						appVo.setMeetingName(meeting.getTitle());

						String conferees = meeting.getConferees();
						if(Strings.isNotBlank(conferees)){
							//通过类型计算人员数量
							String arrCount[] = conferees.split(",");
							for(String item : arrCount){
								if(Strings.isNotBlank(item)){
									String data[] = item.split("[|]");
									List<V3xOrgMember> list = this.orgManager.getMembersByType(data[0], Long.valueOf(data[1]));
									if(list != null){
										confereeCount += list.size();
									}
								}
							}
						}
					}
				} else if(roomApp.getTemplateId() != null) {
					MeetingTemplate template = meetingManager.getTemplateById(roomApp.getTemplateId());
					if(template != null) {
						appVo.setMeetingName(template.getTitle());
					}
				}
				
				appVo.setRoomId(roomApp.getRoomId());
				appVo.setRoomAppId(roomApp.getId());
				appVo.setMeetingRoomApp(roomApp);
				
				
				MeetingRoomPerm roomPerm = this.meetingRoomManager.getRoomPermByAppId(roomAppId);
				if(roomPerm != null) {
					appVo.setMeetingRoomPerm(roomPerm);
					appVo.setRoomPermId(roomPerm.getId());
				}
				
				List<CtpAffair> list = this.affairManager.getAffairs(ApplicationCategoryEnum.meetingroom, roomApp.getId());
			    if(Strings.isNotEmpty(list)) {
			        currentAffair = list.get(0);
			    }
			    //代理人处理
			    if(currentAffair != null && currentAffair.getTransactorId() != null) {
				    V3xOrgMember member = this.orgManager.getMemberById(currentAffair.getTransactorId());
				    if(member != null) {
				    	 mav.addObject("proxyName", member.getName());
				    }
				}			    
			}			
		} catch (Exception e) {
			LOGGER.error("通过id获取会议室申请对象报错!",e);
		}
		
		MeetingRoom room = this.meetingRoomManager.getRoomById(appVo.getRoomId());
		appVo.setMeetingRoom(room);
		
		List<Attachment> attatchmentsC = this.attachmentManager.getByReference(appVo.getRoomId(), RoomAttEnum.attachment.key());
		if(attatchmentsC.size()>0){
			mav.addObject("attatchments", attatchmentsC);
			mav.addObject("attObj", attatchmentsC.get(0));
		}
		List<Attachment> attatchmentsI = this.attachmentManager.getByReference(appVo.getRoomId(), RoomAttEnum.image.key());
		if(attatchmentsI.size()>0){
			mav.addObject("attatchImage", attatchmentsI);
			mav.addObject("imageObj",attatchmentsI.get(0));
		}
		
		mav.addObject("departmentName", this.orgManager.getDepartmentById(roomApp.getDepartmentId()).getName());
		
		mav.addObject("count", confereeCount);//参会人数
		mav.addObject("proxy", "1".equals(proxy));
		
		mav.addObject("bean", appVo);
		mav.addObject("affairId", affairId);
		// 会议用品
		Long meetingId = roomApp.getMeetingId();
		String resourcesNames = new String();
		if (null != meetingId) {
			resourcesNames = meetingResourcesManager.getResourceNamesByMeetingId(meetingId);
		}
		mav.addObject("resourcesName", resourcesNames);
		
		// 谁审核的 原逻辑取的是perid,现在的逻辑是在perm表中添加审核人字段，如果审核人为空，取会议室的全部管理员
		if (appVo.getMeetingRoomApp().getAuditingId() != null) {
			mav.addObject("peradmin", appVo.getMeetingRoomApp().getAuditingId());
		} else {
			String adminformat = MeetingRoomAdminUtil.getRoomAdmins(appVo.getMeetingRoom())[2];
			mav.addObject("peradmin",Strings.isNotBlank(adminformat)? adminformat.replaceAll("Member[|]", ""):adminformat);
		}
		
		//checkAuditRight = !checkAuditRight ? "1".equals(openWin) : true;//打开窗口和管理员待办内嵌页面都进行权限验证
		
		mav.addObject("isPeriodicity", !MeetingUtil.isIdBlank(request.getParameter("periodicityInfoId")));
		return mav;
	}
	
	
	/**
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	public ModelAndView execPerm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String permStatusStr = request.getParameter("permStatus");
        String description = request.getParameter("description");
		String openWin = request.getParameter("openWin");
        Long periodicityId = Strings.isBlank(request.getParameter("periodicityId")) ? Constants.GLOBAL_NULL_ID : Long.parseLong(request.getParameter("periodicityId"));
        //代理人id
        Long proxyId = Strings.isBlank(request.getParameter("proxyId")) ? Constants.GLOBAL_NULL_ID : Long.parseLong(request.getParameter("proxyId"));
        Long roomAppId = Strings.isBlank(request.getParameter("id")) ? -1 : Long.parseLong(request.getParameter("id"));
        Long affairId = Strings.isBlank(request.getParameter("affairId")) ? -1 : Long.parseLong(request.getParameter("affairId"));
        String[] roomAppIds = request.getParameterValues("roomAppId");
        
        MeetingRoomAppVO appVo = new MeetingRoomAppVO();
		appVo.setRoomAppId(roomAppId);
		appVo.setDescription(request.getParameter("description"));
		appVo.setStatus(Integer.parseInt(request.getParameter("permStatus")));
		appVo.setSystemNowDatetime(DateUtil.currentDate());
		appVo.setCurrentUser(AppContext.getCurrentUser());
		appVo.setProxyId(proxyId);
		appVo.setAffairId(affairId);
		appVo.setPeriodicityId(periodicityId);
		appVo.setPeriodicityRoomAppIdList(MeetingUtil.getIdList(roomAppIds));
		
		boolean ok = true;
		try {
			this.meetingRoomManager.transPerm(appVo);
		} catch(Exception e) {
			LOGGER.error("审核会议室出错", e);
			ok = false;
		}
		StringBuffer buffer = new StringBuffer();
		if(ok) {
			if(Strings.isBlank(request.getParameter("linkSectionId"))) {
				buffer.append("if(parent._submitCallback) {");
				buffer.append("  parent._submitCallback('" + appVo.getMsg() + "');");
				buffer.append("}");
			} else {
				if(appVo.getMeetingRoomApp() != null) {
					buffer.append(appVo.getMeetingRoomApp().getId()+"|"+appVo.getMsg());
				}
				super.rendText(response, buffer.toString());
				return null;
			}
		}
		rendJavaScript(response, buffer.toString());
		
		return null;
	}

	public ModelAndView mtroom(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("meetingroom/mtroom");
		int needApp = Strings.isBlank(request.getParameter("needApp")) ? -1 : Integer.parseInt(request.getParameter("needApp"));
		int sortType = Strings.isBlank(request.getParameter("sort")) ? RoomSortByEnum.name.key() : Integer.parseInt(request.getParameter("needApp"));
		Long meetingId = Strings.isBlank(request.getParameter("meetingId")) ? -1L : Long.parseLong(request.getParameter("meetingId"));
		String action = request.getParameter("action");//判断是增加还是修改(create新增,edit修改)
		String returnMrStr = request.getParameter("returnMr");//获取返回的记录
		String timepams = Strings.isBlank(request.getParameter("timepams")) ? DateUtil.get19DateAndTime() : request.getParameter("timepams");
		
		List<MeetingRoomApp> appedList = new ArrayList<MeetingRoomApp>();
		
		User currentUser = AppContext.getCurrentUser();
		
		List<MeetingRoom> list = this.meetingRoomManager.getMyCanAppRoomList(currentUser, sortType, null, null);
		if(Strings.isNotEmpty(list)) {
			List<Long> meetingroomList = new ArrayList<Long>();
			for(MeetingRoom bean : list) {
				meetingroomList.add(bean.getId());
			}
			appedList = this.meetingRoomManager.getUsedRoomAppListByDate(DateUtil.parse(timepams), meetingroomList);
		}
		String mtRoom = MeetingRoomHelper.meetingroomToJson(list);
		
		String jsonMt = MeetingRoomHelper.meetingroomAppToJson(appedList, meetingId, AppContext.currentUserId(), action);
		
		String returnMr = "null";
		String oldRoomAppId = "null";
		String[] returnMrs = Strings.isBlank(returnMrStr) ? null : returnMrStr.split(",");
		if(returnMrs!=null && returnMrs.length > 4) {
			oldRoomAppId = "\""+returnMrs[3] + "\""; 
			
			mav.addObject("meetingRoom", returnMrs[0]);
			mav.addObject("startDate", returnMrs[1]);
			mav.addObject("endDate", returnMrs[2]);
			
			StringBuffer buffer = new StringBuffer();
			buffer.append("[");
			buffer.append("{");
			buffer.append("id: \"" + returnMrs[3] + "\",");
			buffer.append("start_date: \"" + returnMrs[1] + "\",");
			buffer.append("end_date: \"" + returnMrs[2] + "\",");
			buffer.append("section_id: \"" + returnMrs[0] + "\"");
			buffer.append("}");
			buffer.append("]");
			returnMr = buffer.toString();
		}
		
		mav.addObject("mtRoom", mtRoom);
		mav.addObject("jsonMt", jsonMt);
		mav.addObject("needApp", needApp);
		mav.addObject("returnMr", returnMr);
		mav.addObject("oldRoomAppId", oldRoomAppId);
		mav.addObject("action", action);
		mav.addObject("meetId", meetingId);
		
		//这个日期字符串，需要在jsp中转为js日期对象(注意这里的格式：yyyy/MM/dd HH:mm，这样js通过 new Date(str)才能转成功)
		mav.addObject("newDate", Datetimes.format(new Date(),DateFormatEnum.yyyyMMddHHmm2.key()));
		return mav;
	}
	
	public ModelAndView mtroomAjax(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("meetingroom/mtroom");
		String action = request.getParameter("action");//判断是增加还是修改(create新增,edit修改)
		Long meetingId = Strings.isBlank(request.getParameter("meetingId")) ? -1L : Long.parseLong(request.getParameter("meetingId")); 
		if("edit".equals(action)) {//如果是修改,则获取会议的ID
			mav.addObject("meetId", meetingId);
		}
		int sortType = Strings.isBlank(request.getParameter("sort")) ? RoomSortByEnum.name.key() : Integer.parseInt(request.getParameter("needApp"));
		String timepams = Strings.isBlank(request.getParameter("timepams")) ? DateUtil.get19DateAndTime() : request.getParameter("timepams");
		
		List<MeetingRoomApp> appedList = new ArrayList<MeetingRoomApp>();
		
		List<MeetingRoom> list = this.meetingRoomManager.getMyCanAppRoomList(AppContext.getCurrentUser(), sortType, null, null);
		if(Strings.isNotEmpty(list)) {
			List<Long> meetingroomList = new ArrayList<Long>();
			for(MeetingRoom bean : list) {
				meetingroomList.add(bean.getId());
			}
			appedList = this.meetingRoomManager.getUsedRoomAppListByDate(DateUtil.parse(timepams), meetingroomList);
		}
		
		String jsonMt = MeetingRoomHelper.meetingroomAppToJson(appedList, meetingId, AppContext.currentUserId(), action);
		
		//json字符串中文乱码
		response.setHeader("Cache-Control", "no-cache"); 
		response.setContentType("text/json;charset=UTF-8"); 
		PrintWriter out = response.getWriter();
		out.println(jsonMt);
		out.close();
		return null;
	}
	
	/**
	 * ajax方式获取会议室
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getAllMeetingRoomAjax(HttpServletRequest request, HttpServletResponse response) throws Exception {
		int sortType = Integer.valueOf(request.getParameter("sort"));
		
		User currentUser = AppContext.getCurrentUser();
		request.setCharacterEncoding("UTF-8");
		
		String roomName = request.getParameter("roomName");
		List<MeetingRoom> list = this.meetingRoomManager.getMyCanAppRoomList(currentUser, sortType, roomName, null);

		String mtRoom = MeetingRoomHelper.meetingroomToJson(list);
		
		response.setContentType("application/text;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
	    PrintWriter out = response.getWriter();
        out.println(mtRoom);
        out.close();
        
        return null;
	}
	
	/**
	 * 点击会议室获取会议室信息
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getMeetingRoomById(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("meetingroom/mtroominfo");
		Long roomId = Strings.isBlank(request.getParameter("roomId")) ? -1L : Long.parseLong(request.getParameter("roomId"));
		
		MeetingRoom meetingRoom = meetingRoomManager.getRoomById(roomId);
		List<Attachment> attatchmentsC = attachmentManager.getByReference(meetingRoom.getId(), RoomAttEnum.attachment.key());
		if(attatchmentsC.size()>0){
			mav.addObject("attatchments", attatchmentsC);
			mav.addObject("attObj", attatchmentsC.get(0));
		}
		List<Attachment> attatchmentsI = attachmentManager.getByReference(meetingRoom.getId(), RoomAttEnum.image.key());
		if(attatchmentsI.size()>0){
			mav.addObject("attatchImage", attatchmentsI);
			mav.addObject("imageObj",attatchmentsI.get(0));
			Attachment att = attatchmentsI.get(0);
			java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd");
			String createTime = String.valueOf(df.format(att.getCreatedate()));
			mav.addObject("fileId", att.getFileUrl());
			mav.addObject("createTime", createTime);
			mav.addObject("filename", att.getFilename());
		}
		mav.addObject("meetingRoom", meetingRoom);
		return mav;
	}
	
	/**
	 * 点击确定时将ID值转化成会议室名称
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getMeetingRoomByIdAjax(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
		Long roomId = Strings.isBlank(request.getParameter("roomId")) ? -1L : Long.parseLong(request.getParameter("roomId"));
		MeetingRoom room = this.meetingRoomManager.getRoomById(roomId);
		String mtRoom = null;
		if (room != null) {
			mtRoom = room.getId() + "," + room.getName()+","+room.getNeedApp();
		}
		
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter(); 
		out.println(mtRoom);
		out.close();
		
		return null;
	}
	
	public ModelAndView checkRoomUsed(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String flag = "y";
		
		Long roomId = Strings.isBlank(request.getParameter("roomId")) ? -1L : Long.parseLong(request.getParameter("roomId"));
		Long meetingId = Strings.isBlank(request.getParameter("meetingId")) ? -1L : Long.parseLong(request.getParameter("meetingId"));
		String sDate = request.getParameter("startDate");
		String eDate = request.getParameter("endDate");
		if(Strings.isNotBlank(sDate) && sDate.length() < 17) {
			sDate += ":59";
		}
		if(Strings.isNotBlank(eDate) && eDate.length() < 17) {
			eDate += ":00";
		}
		Date startDate = DateUtil.parse(sDate, DateFormatEnum.yyyyMMddHHmmss.key());
		Date endDate = DateUtil.parse(eDate, DateFormatEnum.yyyyMMddHHmmss.key());
		
		boolean isRepeat = this.meetingValidationManager.checkRoomUsed(roomId, startDate, endDate, meetingId);
		if (!isRepeat) {
			flag = "n";
		}
		
		PrintWriter out = response.getWriter();
		out.println(flag);
		out.close();
		
		return null;
	}
	
	/**
	 * 会议室管理主框架页面
	 * 
	 * @param request
	 * @param response
	 * @return 转到index.jsp页面
	 * @throws Exception
	 */
	//@CheckRoleAccess(roleTypes={Role_NAME.MeetingRoomAdmin})
	public ModelAndView index(HttpServletRequest request, HttpServletResponse response) throws Exception {
		if(!MeetingRoomRoleUtil.hasRoomResource(AppContext.getCurrentUser())) {
			return refreshWorkspace();
		}
		boolean isAdmin = MeetingRoomRoleUtil.isMeetingRoomAdminRole();
		
		ModelAndView mav = new ModelAndView("meetingroom/index");
		mav.addObject("isAdmin", MeetingRoomRoleUtil.isMeetingRoomAdminRole());
		if (isAdmin) {
			mav.addObject("top", 2);
		} else {
			mav.addObject("top", 1);
		}
		return mav;
	}

	/**
	 * 新建会议室主框架页面
	 * 
	 * @param request
	 * @param response
	 * @return 转到add.jsp页面
	 * @throws Exception
	 */
	//@CheckRoleAccess(roleTypes={Role_NAME.MeetingRoomAdmin})
	public ModelAndView add(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("meetingroom/add");
		return mav;
	}

	/**
	 * 会议室管理的左侧页面
	 * 
	 * @return 转到meetListLeft.jsp页面
	 * @throws Exception
	 */
	//@CheckRoleAccess(roleTypes={Role_NAME.MeetingRoomAdmin})
	public ModelAndView meetListLeft(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("meetingroom/meetListLeft");
		String from = request.getParameter("from");
		mav.addObject("from", from);
		return mav;
	}

	/**
	 * 会议室申请主框架页面
	 * 
	 * @param request
	 * @param response
	 * @return 转到app.jsp页面
	 * @throws Exception
	 */
	public ModelAndView app(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("meetingroom/app");
		return mav;
	}

	/**
	 * 会议室审批主框架页面
	 * 
	 * @param request
	 * @param response
	 * @return 转到perm.jsp页面
	 * @throws Exception
	 */
	//@CheckRoleAccess(roleTypes={Role_NAME.MeetingRoomAdmin})
	public ModelAndView perm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("meetingroom/perm");
		return mav;
	}
	
	/**
	 * 查看会议室预定情况
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView reservation(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("meetingroom/reservation");
		return mav;
	}

	/**
	 * 会议室预定撤销主框架页面
	 * 
	 * @param request
	 * @param response
	 * @return 转到cancel.jsp页面
	 * @throws Exception
	 */
	public ModelAndView cancel(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String select = request.getParameter("select");
		String flag = request.getParameter("flag");
		ModelAndView mav = new ModelAndView("meetingroom/cancel");
		mav.addObject("select",select);
		mav.addObject("flag",flag);
		return mav;
	}

	/**
	 * 会议室统计主框架页面
	 * 
	 * @param request
	 * @param response
	 * @return 转到total.jsp页面
	 * @throws Exception
	 */
	public ModelAndView total(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("meetingroom/total");
		return mav;
	}

	/**
	 * 会议室使用情况查看主框架页面
	 * 
	 * @param request
	 * @param response
	 * @return 转到view.jsp页面
	 * @throws Exception
	 */
	public ModelAndView view(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("meetingroom/view");
		return mav;
	}
	
	private String getCloseWindowFunction() {
		StringBuilder buffer = new StringBuilder();
		buffer.append("function closeWindow() {");
		buffer.append("  if(window.dialogArguments && window.dialogArguments.callback) {");
		buffer.append("    window.dialogArguments.callback();");
		buffer.append("  } else if(window.dialogArguments && window.dialogArguments.dialogDealColl) {");
		buffer.append("    window.dialogArguments.dialogDealColl.close();");
		buffer.append("    window.dialogArguments.location.reload();");
		buffer.append("  } else if(window.dialogArguments) {");
		buffer.append("    window.dialogArguments.getA8Top().reFlesh();");
		buffer.append("    parent.window.close();");
		buffer.append("  } else {");
        buffer.append("    if(parent.window.listFrame) {");
        buffer.append("       parent.window.listFrame.location.reload();");
        buffer.append("    } else {");
        buffer.append("  	  parent.window.close();");
        buffer.append("	   }");
        buffer.append("  }");
        buffer.append("}");
		return buffer.toString();
	}
	
	/****************************** 依赖注入 **********************************/
	public void setMeetingRoomManager(MeetingRoomManager meetingRoomManager) {
		this.meetingRoomManager = meetingRoomManager;
	}
	public void setMeetingTypeManager(MeetingTypeManager meetingTypeManager) {
		this.meetingTypeManager = meetingTypeManager;
	}
	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}
	public void setAttachmentManager(AttachmentManager attachmentManager) {
		this.attachmentManager = attachmentManager;
	}
	public void setMeetingValidationManager(MeetingValidationManager meetingValidationManager) {
		this.meetingValidationManager = meetingValidationManager;
	}
	public void setAffairManager(AffairManager affairManager) {
		this.affairManager = affairManager;
	}

	public void setMeetingManager(MeetingManager meetingManager) {
		this.meetingManager = meetingManager;
	}
	
    public void setMobileMessageManager(MobileMessageManager mobileMessageManager) {
		this.mobileMessageManager = mobileMessageManager;
	}
    
	public MeetingResourcesManager getMeetingResourcesManager() {
		return meetingResourcesManager;
	}

	public void setMeetingResourcesManager(MeetingResourcesManager meetingResourcesManager) {
		this.meetingResourcesManager = meetingResourcesManager;
	}
	
	/**
	 * 打开催办会议室管理员审核会议室申请操作窗口
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView openRemindersDialog(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView(MeetingPathConstant.reminders_dialog);
		// 是否可以发送短信
		boolean isCanSendSMS = false;
		if (SystemEnvironment.hasPlugin("sms")) {
			isCanSendSMS = mobileMessageManager.isCanUseSMS();
		}
		mav.addObject("canSendPhone", isCanSendSMS);
		// 要催办的用户集合
		List<V3xOrgMember> userList = new ArrayList<V3xOrgMember>();
		String auditIds = request.getParameter("auditIds");
		String[] admins = auditIds.split(",");
		for (String memberId : admins) {
			V3xOrgMember member = orgManager.getMemberById(Long.valueOf(memberId.trim()));
			if(member.isValid())
			userList.add(member);
		}
		mav.addObject("userList", userList);
		return mav;
	}
	
	/**
	 * 执行会议室申请催办
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView execReminders(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String memberIdArray = request.getParameter("memberIdArray");
		String[] memberIdArrays = memberIdArray.split(",");
		List<Long> memberIds = new ArrayList<Long>();
		for (String memberId : memberIdArrays) {
			memberIds.add(Long.parseLong(memberId));
		}
		
		String content = request.getParameter("remindContent");
		String sendPhoneMessage = request.getParameter("sendPhoneMessage");
		String roomAppId = request.getParameter("roomAppId");
		User user = AppContext.getCurrentUser();
		// 催办
		try{
			meetingRoomManager.execReminders(memberIds, content, Boolean.getBoolean(sendPhoneMessage), Long.parseLong(roomAppId), user);
		} catch (Exception e) {
			LOGGER.error("会议室申请催办出错", e);
		}
		return null;
	}
}
