package com.seeyon.ctp.rest.resources;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.agent.bo.MemberAgentBean;
import com.seeyon.apps.common.manager.MeetingLockManager;
import com.seeyon.apps.meeting.api.MeetingApi;
import com.seeyon.apps.meeting.api.MeetingVideoManager;
import com.seeyon.apps.meeting.bo.MeetingBO;
import com.seeyon.apps.meeting.bo.MtReplyBO;
import com.seeyon.apps.meeting.bo.MtSummaryBO;
import com.seeyon.apps.meeting.constants.MeetingConstant.MeetingActionEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.MeetingCategoryEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.MeetingNatureEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.RoomAppStateEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.RoomAttEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.SummaryBusinessTypeEnum;
import com.seeyon.apps.meeting.constants.MeetingListConstant.ListTypeEnum;
import com.seeyon.apps.meeting.constants.MeetingListConstant.MeetingListTypeEnum;
import com.seeyon.apps.meeting.manager.ConfereesConflictManager;
import com.seeyon.apps.meeting.manager.MeetingApplicationHandler;
import com.seeyon.apps.meeting.manager.MeetingManager;
import com.seeyon.apps.meeting.manager.MeetingNewManager;
import com.seeyon.apps.meeting.manager.MeetingResourcesManager;
import com.seeyon.apps.meeting.manager.MeetingSummaryManager;
import com.seeyon.apps.meeting.manager.MeetingValidationManager;
import com.seeyon.apps.meeting.outer.MeetingM3Manager;
import com.seeyon.apps.meeting.outer.MeetingRoomM3Manager;
import com.seeyon.apps.meeting.po.MeetingResources;
import com.seeyon.apps.meeting.po.MeetingSummary;
import com.seeyon.apps.meeting.util.MeetingHelper;
import com.seeyon.apps.meeting.util.MeetingOrgHelper;
import com.seeyon.apps.meeting.util.MeetingUtil;
import com.seeyon.apps.meeting.vo.ConfereesConflictVO;
import com.seeyon.apps.meeting.vo.MeetingListVO;
import com.seeyon.apps.meeting.vo.MeetingMemberVO;
import com.seeyon.apps.meeting.vo.MeetingNewVO;
import com.seeyon.apps.meetingroom.manager.MeetingRoomListManager;
import com.seeyon.apps.meetingroom.manager.MeetingRoomManager;
import com.seeyon.apps.meetingroom.po.MeetingRoom;
import com.seeyon.apps.meetingroom.po.MeetingRoomApp;
import com.seeyon.apps.meetingroom.po.MeetingRoomPerm;
import com.seeyon.apps.meetingroom.util.MeetingRoomRoleUtil;
import com.seeyon.apps.meetingroom.vo.MeetingRoomAppVO;
import com.seeyon.apps.meetingroom.vo.MeetingRoomListVO;
import com.seeyon.apps.meetingroom.vo.MeetingRoomOccupancyVO;
import com.seeyon.apps.meetingroom.vo.MeetingRoomVO;
import com.seeyon.apps.taskmanage.util.MenuPurviewUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.GlobalNames;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.constants.SubStateEnum;
import com.seeyon.ctp.common.content.mainbody.handler.impl.HtmlMainbodyHandler;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.common.usermessage.MessageContent;
import com.seeyon.ctp.common.usermessage.MessageReceiver;
import com.seeyon.ctp.common.usermessage.MessageUtil;
import com.seeyon.ctp.common.usermessage.UserMessageManager;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.BeanUtils;
import com.seeyon.ctp.util.CommonTools;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.RestInterfaceAnnotation;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.v3x.common.dao.paginate.Pagination;
import com.seeyon.v3x.common.security.SecurityCheck;
import com.seeyon.v3x.common.security.SecurityCheckParam;
import com.seeyon.v3x.common.web.login.CurrentUser;
import com.seeyon.v3x.meeting.contants.MeetingMessageTypeEnum;
import com.seeyon.v3x.meeting.domain.MtComment;
import com.seeyon.v3x.meeting.domain.MtMeeting;
import com.seeyon.v3x.meeting.domain.MtReply;
import com.seeyon.v3x.meeting.domain.MtReplyWithAgentInfo;
import com.seeyon.v3x.meeting.manager.MtMeetingManager;
import com.seeyon.v3x.meeting.manager.MtReplyManager;
import com.seeyon.v3x.meeting.util.Constants;
import com.seeyon.v3x.meeting.util.MeetingMsgHelper;

/**
 * REST 会议资源
 * @author Zhangc
 */
@Path("meeting")
@Consumes({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
@Produces(MediaType.APPLICATION_JSON)
public class MeetingResource extends BaseResource {
    private static final Log   LOGGER             = LogFactory.getLog(MeetingResource.class);
    private MtMeetingManager   mtMeetingManager   = (MtMeetingManager) AppContext.getBean("mtMeetingManager");
    private MeetingManager     meetingManager   = (MeetingManager) AppContext.getBean("meetingManager");
    private MeetingM3Manager     meetingM3Manager   = (MeetingM3Manager) AppContext.getBean("meetingM3Manager");
    private MeetingRoomM3Manager meetingRoomM3Manager   = (MeetingRoomM3Manager) AppContext.getBean("meetingRoomM3Manager");
    private MtReplyManager     mtReplyManager     = (MtReplyManager) AppContext.getBean("replyManager");
    private OrgManager         orgManager         = (OrgManager) AppContext.getBean("orgManager");
    private AttachmentManager  attachmentManager  = (AttachmentManager) AppContext.getBean("attachmentManager");
    private UserMessageManager userMessageManager = (UserMessageManager) AppContext.getBean("userMessageManager"); ;
    private AffairManager      affairManager      = (AffairManager) AppContext.getBean("affairManager");
    private FileManager        fileManager        = (FileManager) AppContext.getBean("fileManager");
    private MeetingApi         meetingApi         = (MeetingApi) AppContext.getBean("meetingApi");
    private MenuPurviewUtil    menuPurviewUtil    = (MenuPurviewUtil)AppContext.getBean("menuPurviewUtil");
	private MeetingRoomManager meetingRoomManager = (MeetingRoomManager) AppContext.getBean("meetingRoomManager");
	private MeetingNewManager  meetingNewManager  = (MeetingNewManager) AppContext.getBean("meetingNewManager");
	private MeetingResourcesManager   meetingResourcesManager   = (MeetingResourcesManager) AppContext.getBean("meetingResourcesManager");
    private MeetingApplicationHandler meetingApplicationHandler = (MeetingApplicationHandler) AppContext.getBean("meetingApplicationHandler");
	private MeetingRoomListManager meetingRoomListManager = (MeetingRoomListManager) AppContext.getBean("meetingRoomListManager");
	private MeetingSummaryManager meetingSummaryManager = (MeetingSummaryManager) AppContext.getBean("meetingSummaryManager");
	private MeetingValidationManager meetingValidationManager = (MeetingValidationManager) AppContext.getBean("meetingValidationManager");
	private ConfereesConflictManager confereesConflictManager = (ConfereesConflictManager) AppContext.getBean("confereesConflictManager");
	private MeetingLockManager meetingLockManager = (MeetingLockManager) AppContext.getBean("meetingLockManager");
	
    private static final String RETURN_ERROR_MESSGAE = "errorMsg";
    private static final String RETURN_DATA = "data";
    private static final String SUCCESS_KEY        = "success"; 
    
    /*************************************  会议列表Rest接口 start ***********************************************/
    
	/**
	 * M3获取会议待办列表<BR>
	 * @param pageMap 分页信息
	 * 	<pre>
	 *        类型    名称             必填     备注
	 *        String   pageNo     Y     页数(1,2,3...)
	 *        String   pageSize   Y     每页显示条数
	 *  </pre>
	 * @return
	 * @throws BusinessException 
	 */
	@POST
	@Path("findPendingMeetings")
	public Response findPendingMeetings(Map<String,String> pageMap) throws BusinessException {
		String listType = ListTypeEnum.listPendingMeeting.name();
		User user = AppContext.getCurrentUser();
		FlipInfo flipInfo = super.getFlipInfo();
		flipInfo = meetingM3Manager.findM3MeetingList(listType, flipInfo, pageMap);
		List<MeetingListVO> meetingList = (List<MeetingListVO>)flipInfo.getData();
		List<MeetingListRestVO>  meetingVOList = new ArrayList<MeetingListRestVO>();
		for(MeetingListVO meeting : meetingList) {
			MeetingListRestVO meetingListRestVO = new MeetingListRestVO();
			BeanUtils.convert(meetingListRestVO,meeting);
			if(!"inform".equals(meeting.getNodePolicy())) {
			    //当该会议详情为代理人打开的时候，过滤掉用户ID
			    Long userID = meeting.getProxyId() == -1 ? user.getId() : meeting.getProxyId();
				List<MtReplyBO> meetingReplyList = meetingApi.findReplyByMeetingIdAndUserId(meeting.getId(), userID);
				if(meetingReplyList != null && meetingReplyList.size() > 0) {
				    MtReplyBO mrReply = meetingReplyList.get(0);
				    if (mrReply.getLookState() == 2 && meeting.getCreateUser().equals(user.getId())) { //已查看并没有回执&&登录者为会议发起人
				        meetingListRestVO.setFeedbackFlag(Constants.FEEDBACKFLAG_ATTEND);
				    } else {
	                    meetingListRestVO.setFeedbackFlag(mrReply.getFeedbackFlag());
				    }
				} 
				//当登录者为会议发起人的时候，回执状态默认为参加
				else if (meeting.getCreateUser().equals(user.getId())){
                    meetingListRestVO.setFeedbackFlag(Constants.FEEDBACKFLAG_ATTEND);
                } else {
					meetingListRestVO.setFeedbackFlag(Constants.FEEDBACKFLAG_NOREPLY);
				}
			} else {
				meetingListRestVO.setFeedbackFlag(Constants.FEEDBACKFLAG_IMPART);
			}
			
			if(meeting.getProxyId() != -1){
				meetingListRestVO.setProxyName(orgManager.getMemberById(meeting.getProxyId()).getName());
			}
			
			//6.1之前的版本可能同时存在room于meet_place，兼容如果存在room则清空meet_place
			if(Strings.isNotEmpty(meetingListRestVO.getRoomName())){
				meetingListRestVO.setMeetPlace("");
			}
			
			//告知人不显示会议纪要图标
            if(meeting.getIsImpart()){
                meetingListRestVO.setBusinessType(SummaryBusinessTypeEnum.impart.key());
            } 
            
			meetingVOList.add(meetingListRestVO);
		}
		
		flipInfo.setData(meetingVOList);
		return ok(flipInfo);
	}
    
	/**
	 * 获取会议已办列表<BR>
	 * @param pageMap 分页信息
	 * <pre>
	 *        类型    名称           必填     备注
	 *        String   pageNo    Y 	页数(1,2,3...)
	 *        String   pageSize  Y 	每页显示条数
	 * </pre>
	 * @return
	 * @throws BusinessException 
	 */
	@POST
	@Path("findDoneMeetings")
	@RestInterfaceAnnotation
	public Response findDoneMeetings(Map<String,String> pageMap) throws BusinessException {
		User user = AppContext.getCurrentUser();
		String listType = ListTypeEnum.listDoneMeeting.name();
		
		FlipInfo flipInfo = super.getFlipInfo();
		flipInfo = meetingM3Manager.findM3MeetingList(listType, flipInfo, pageMap);
		List<MeetingListVO> meetingList = (List<MeetingListVO>)flipInfo.getData();
		
		List<MeetingListRestVO>  meetingVOList = new ArrayList<MeetingListRestVO>();
		for(MeetingListVO meeting : meetingList) {
			MeetingListRestVO meetingListRestVO = new MeetingListRestVO();
			BeanUtils.convert(meetingListRestVO,meeting);
			//by 吴晓菊、 OA-113121M3：会议已开列表，代理的数据，代理人显示成了null
			if(meeting.getProxyId() != -1){
                meetingListRestVO.setProxyName(orgManager.getMemberById(meeting.getProxyId()).getName());
            }
			
			//6.1之前的版本可能同时存在room于meet_place，兼容如果存在room则清空meet_place
			if(Strings.isNotEmpty(meetingListRestVO.getRoomName())){
				meetingListRestVO.setMeetPlace("");
			}
			
			//告知人不显示会议纪要图标
			if(meeting.getIsImpart()){
			    meetingListRestVO.setBusinessType(SummaryBusinessTypeEnum.impart.key());
            } 
			
			meetingVOList.add(meetingListRestVO);
		}
		
		flipInfo.setData(meetingVOList);
		
		return ok(flipInfo);
	}
	
	/**
	 * 查询已发会议
	 * @param params 传入参数
	 * <pre>
	 * 类型 	|	名称	| 	必填	|	备注
	 * String	|	pageNo	|	Y	|	页数
	 * String	|	pageSize|	Y	|	每页显示条数
	 * </per>
	 * @return FlipInfo data(List<MeetingBO>) 
	 * @throws BusinessException 
	 * @author wulin v6.1 2017-01-06
	 */
	@POST
	@Path("findSentMeetings")
	public Response findSentMeetings(Map<String,String> pageMap) throws BusinessException {
		User user = AppContext.getCurrentUser();
		String listType = ListTypeEnum.listSendMeeting.name();
		
		FlipInfo flipInfo = super.getFlipInfo();
		flipInfo = meetingM3Manager.findM3MeetingList(listType, flipInfo, pageMap);
		List<MeetingListVO> meetingList = (List<MeetingListVO>)flipInfo.getData();
		List<MeetingListRestVO>  meetingVOList = new ArrayList<MeetingListRestVO>();
		for(MeetingListVO meeting : meetingList) {
			MeetingListRestVO meetingListRestVO = new MeetingListRestVO();
			BeanUtils.convert(meetingListRestVO,meeting);
			meetingListRestVO.setCreateUserName(user.getName());
			
			//6.1之前的版本可能同时存在room于meet_place，兼容如果存在room则清空meet_place
			if(Strings.isNotEmpty(meetingListRestVO.getRoomName())){
				meetingListRestVO.setMeetPlace("");
			}
			meetingVOList.add(meetingListRestVO);
		}
		
		flipInfo.setData(meetingVOList);
		return ok(flipInfo);
	}
	
	/**
	 * 查询待发会议
	 * @param params 传入参数
	 * <pre>
	 * 类型 	|	名称	| 	必填	|	备注
	 * String	|	pageNo	|	Y	|	页数
	 * String	|	pageSize|	Y	|	每页显示条数
	 * </per>
	 * @return FlipInfo data(List<MeetingBO>) 
	 * @throws BusinessException 
	 * @author wulin v6.1 2017-01-06
	 */
	@POST
	@Path("findWaitSentMeetings")
	public Response findWaitSentMeetings(Map<String,String> pageMap) throws BusinessException {
		User user = AppContext.getCurrentUser();
		String listType = ListTypeEnum.listWaitSendMeeting.name();
		
		FlipInfo flipInfo = super.getFlipInfo();
		flipInfo = meetingM3Manager.findM3MeetingList(listType, flipInfo, pageMap);
		List<MeetingListVO> meetingList = (List<MeetingListVO>)flipInfo.getData();
		List<MeetingListRestVO>  meetingVOList = new ArrayList<MeetingListRestVO>();
		for(MeetingListVO meeting : meetingList) {
			MeetingListRestVO meetingListRestVO = new MeetingListRestVO();
			BeanUtils.convert(meetingListRestVO,meeting);
			meetingListRestVO.setCreateUserName(user.getName());
			
			//6.1之前的版本可能同时存在room于meet_place，兼容如果存在room则清空meet_place
			if(Strings.isNotEmpty(meetingListRestVO.getRoomName())){
				meetingListRestVO.setMeetPlace("");
			}
			meetingVOList.add(meetingListRestVO);
		}
		
		flipInfo.setData(meetingVOList);
		return ok(flipInfo);
	}
	
	
	/**
	 * 获取会议待办列表<BR>
	 * method:POST<BR>
	 * Path("pendings/{personid}")<BR>
	 * @param personId 人员ID 非必填  当personId为空时，获取当前登录人员的待办列表
	 * @param pageMap 参数map对象
	 * <pre>
	 * 类型               名称                     必填                        备注
	 * Object   pageNo      N           当前第几页  如果分页信息不传递，取默认
	 * Object   pageSize    N           每页显示多少条数据 如果分页信息不传递，取默认
	 * </pre>
	 * @return
	 * <pre>
	 *  会议待办列表
	 * <pre>
	 */
	@POST
	@Path("pendings/{personid}")
	@RestInterfaceAnnotation
	public Response getPendingMeetings(@PathParam("personid") Long personId, Map<String, Object> pageMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
        	String listType = ListTypeEnum.listPendingMeeting.name();
        	Integer pageSize = pageMap.get("pageSize")==null ? 20 : (Integer)pageMap.get("pageSize");
            Integer pageNo = pageMap.get("pageNo")==null ? 1 : (Integer)pageMap.get("pageNo");
        	resultMap = meetingM3Manager.findM3MeetingList(listType, personId, pageSize, pageNo);
            
        } catch(Exception e) {
        	
        }
        return ok(resultMap);
	}
	
	/**
	 * 获取会议待办列表<BR>
	 * method:GET<BR>
	 * <pre>
	 * Long personId 人员ID            非必填    当personId为空时，获取当前登录人员的待办列表
	 * String pageNo   当前第几页                   非必填   如果分页信息不传递，取默认
	 * String pageSize 每页显示多少条数据    非必填   如果分页信息不传递，取默认
	 * </pre>
	 * @return
	 * <pre>
	 *  会议待办列表
	 * <pre>
	 */
	@GET
	@Path("pendings")
	@RestInterfaceAnnotation
	public Response getPendingMeetings(@QueryParam("personid") Long personId, @QueryParam("pageNo") String pageNo, @QueryParam("pageSize") String pageSize) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			pageSize = pageSize == null ? "20" : pageSize;
			pageNo = pageNo == null ? "1" : pageNo;
        	String listType = ListTypeEnum.listPendingMeeting.name();
        	resultMap = meetingM3Manager.findM3MeetingList(listType, personId, Integer.parseInt(pageSize), Integer.parseInt(pageNo));
            
        } catch(Exception e) {
        	
        }
        return ok(resultMap);
	}	
	
	/**
	 * 获取会议已发列表<BR>
	 * @param personId 人员Id 非必填    当personId为空时，获取当前登录人员的会议已发数量
	 * @param pageMap
	 * <pre>
	 *        类型    名称           必填     备注
	 *        Object   pageNo    N 	页数(1,2,3...),如果分页信息不传递，取默认
	 *        Object   pageSize  N 	每页显示条数,如果分页信息不传递，取默认
	 * </pre>
	 * @return
	 * <pre>
	 * 	 已发会议列表数据
	 * </pre>
	 */
	@POST
	@Path("sends/{personid}")
	@RestInterfaceAnnotation
	public Response getSendMeetings(@PathParam("personid") Long personId, Map<String, Object> pageMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
        	String listType = ListTypeEnum.listSendMeeting.name();
        	Integer pageSize = pageMap.get("pageSize")==null ? 20 : (Integer)pageMap.get("pageSize");
            Integer pageNo = pageMap.get("pageNo")==null ? 1 : (Integer)pageMap.get("pageNo");
        	resultMap = meetingM3Manager.findM3MeetingList(listType, personId, pageSize, pageNo);
            
        } catch(Exception e) {
        	
        }
        return ok(resultMap);
	}

	/**
	 * 获取会议待发列表<BR>
	 * @param personId 人员Id 非必填    当personId为空时，获取当前登录人员的会议待发列表
	 * @param pageMap
	 * <pre>
	 *        类型    名称           必填     备注
	 *        Object   pageNo    N 	页数(1,2,3...),如果分页信息不传递，取默认
	 *        Object   pageSize  N 	每页显示条数,如果分页信息不传递，取默认
	 * </pre>
	 * @return
	 * <pre>
	 * 	待发会议列表数据
	 * </pre>
	 */
	@POST
	@Path("waitsends/{personid}")
	@RestInterfaceAnnotation
	public Response getWaitsendMeetings(@PathParam("personid") Long personId, Map<String, Object> pageMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
        	String listType = ListTypeEnum.listWaitSendMeeting.name();
        	Integer pageSize = pageMap.get("pageSize")==null ? 20 : (Integer)pageMap.get("pageSize");
            Integer pageNo = pageMap.get("pageNo")==null ? 1 : (Integer)pageMap.get("pageNo");
        	resultMap = meetingM3Manager.findM3MeetingList(listType, personId, pageSize, pageNo);
            
        } catch(Exception e) {
        	
        }
        return ok(resultMap);
	}

	/**
     * 获取会议待办数量<BR>
     * @param Long personId 人员Id 非必填    当personId为空时，获取当前登录人员的会议待办数量
     * method:GET<BR>
     * @return
	 * <pre>
	 *  会议待办数量
	 * <pre>
     */
	@GET
    @Path("pendingCount")
    public Response getPendingMeetingCount(@QueryParam("personid") Long personId) {
		String listType = ListTypeEnum.listPendingMeeting.name();
		
        int count = 0;
        int pageSize = 20;
        Pagination.setMaxResults(pageSize);
        Pagination.setFirstResult(count);
                
        Map<String, Object> resultMap = new HashMap<String, Object>();
        
        try {
        	resultMap = meetingM3Manager.findM3MeetingListCount(listType);
        } catch(Exception e) {
        	
        }
        return ok(resultMap);
    }
	
	/*************************************  会议列表Rest接口 end ***********************************************/
	
    /**
     * 判断当前人员具有的会议与会议室相关的菜单权限
     * @return Map
     * data 是否是该单位会议室管理员<br />
     * haveMeetingDoneRole 是否有已办列表的权限<br />
     * haveMeetingPendingRole 是否有待办列表的权限<br />
     * haveMeetingArrangeRole 是否有会议安排的权限<br />
     * haveMeetingRoomApp 是否有会议室申请的权限<br />
     * haveMeetingRoomPerm 是否有会议室审核的权限<br />
     * @throws BusinessException
     */
    @GET
    @Produces({ MediaType.APPLICATION_JSON })
    @Path("meeting/user/privMenu")
    @SuppressWarnings("static-access")
    public Response meetingUserPeivMenu() throws BusinessException {
    	
    	Map<String,Object> params = new HashMap<String,Object>();
    	User user = AppContext.getCurrentUser();
    	
    	//是否是该单位会议室管理员
    	params.put(RETURN_DATA, MeetingRoomRoleUtil.isMeetingRoomAdminRole());
    	//已开会议
    	params.put("haveMeetingDoneRole", menuPurviewUtil.isHaveMeetingDone(user));
    	//待开会议
    	params.put("haveMeetingPendingRole", menuPurviewUtil.isHaveMeetingPending(user));
    	//会议安排
    	params.put("haveMeetingArrangeRole", menuPurviewUtil.isHaveMeetingArrange(user));
    	//会议室申请
    	params.put("haveMeetingRoomApp", menuPurviewUtil.isHaveMeetingRoomApp(user));
    	//会议室审核
    	params.put("haveMeetingRoomPerm", menuPurviewUtil.isHaveMeetingRoomPerm(user));
        	
    	return ok(params);
    }
    
    

	/**
	 * 提交震荡回复
	 * @param params
	 * <pre>
	 *  类型	                  名称			必填	                   备注
	 *  String           meetingId       Y               会议Id
	 *  String           replyId         Y               回执Id
	 *  String           content         Y               内容
	 *  String           memberId        Y               人员Id(如果是代理情况，传入被代理人ID)
	 *  String           hiddencomment   Y               是否隐藏意见(true：是； false：否)
	 *  String           hidden2creator  Y               是否对发起人隐藏(true：是； false：否)
	 *  String           sendMsg         Y               是否发送消息(true：是； false：否)
	 * </pre>
	 * @return  
	 * <pre>
	 * 		MtComment 意见对象
	 * </pre>
	 *   
	 * @throws BusinessException
	 */
	@POST
    @Path("comment")
	public Response comment(Map<String, Object> params) throws BusinessException{
		//前台获取各种参数
        Long meetingId = ParamUtil.getLong(params, "meetingId");//会议ID
        Long replyId = ParamUtil.getLong(params, "replyId");//回执的ID
        String content = ParamUtil.getString(params, "content");//内容
        Long memberId = ParamUtil.getLong(params, "memberId");
        String hiddencomment = ParamUtil.getString(params,"hiddencomment");
        String hidden2creator = ParamUtil.getString(params,"hidden2creator");
        String pSendMsg = ParamUtil.getString(params,"sendMsg");
        Long proxyId = 0l;

        if(meetingId == null || replyId == null || content == null || proxyId == null 
        		|| hiddencomment == null || hidden2creator == null || pSendMsg == null
        		|| memberId == null){
        	return ok(errorParams());
        }
        
        User user =  CurrentUser.get();
		if(!memberId.equals(user.getId())){
			proxyId = MemberAgentBean.getInstance().getAgentMemberId(ApplicationCategoryEnum.meeting.key(), memberId);
			if(!user.getId().equals(proxyId)){
				return ok(errorParams());
			}
		}
        
		boolean ishidden =Boolean.parseBoolean(hiddencomment.toLowerCase());
		boolean hiddenCreator = Boolean.parseBoolean(hidden2creator.toLowerCase()); 
		boolean sendMsg = Boolean.parseBoolean(pSendMsg.toLowerCase()); 
		
		//参数准备
        Long creatorId = AppContext.currentUserId();
        String creatorName = AppContext.currentUserName();
		MtMeeting meeting = meetingManager.getMeetingById(meetingId);
		//构造回复
		MtComment mc = new MtComment();
		mc.setIdIfNew();
		mc.setContent(content);
		mc.setCreateUserId(creatorId);
		mc.putExtraAttr("creator", creatorName);
		mc.setIsHidden(ishidden);
		mc.setReplyId(replyId);
		mc.setMeetingId(meetingId);
		mc.setCreateDate(new java.sql.Timestamp(new Date().getTime()));
		if(proxyId.longValue()!=0l){
			mc.setProxyId(memberId.toString());
		}
		
		MtReply reply = mtReplyManager.getById(replyId);
		if(ishidden){
		    String showToId = reply.getUserId().toString();
            if (!hiddenCreator) {
                showToId += ","+meeting.getCreateUser().toString();
            }
		    mc.setShowToId(showToId);
		}
		//重复提交校验
		Long submitKey = AppContext.getCurrentUser().getId();
		//保存回复
		try {
			if(meetingLockManager.isLock(submitKey)){
				return null;
			}
			mtMeetingManager.saveComment(mc);
		} finally {
			if(meetingLockManager.isLock(submitKey)){
				meetingLockManager.unLock(submitKey);
			}
		}
		//发送消息
		if(sendMsg){
			MeetingMsgHelper.sendMessage("" ,mc, reply, meeting, AppContext.getCurrentUser());
		}
        //保存附件
        String relateInfo = ParamUtil.getString(params, "fileJson", "[]");
        List<Map> files = JSONUtil.parseJSONString(relateInfo, List.class);
        try {
        	List<Attachment> attList = attachmentManager.getAttachmentsFromAttachList(ApplicationCategoryEnum.meeting, meetingId, mc.getId(), files);
        	if(!attList.isEmpty()){
        		attachmentManager.create(attList);
        	}
		} catch (Exception ex) {
			LOGGER.error(ex);
			throw new BusinessException(ex);
		}
		return ok(mc);
	}
	

	/**
	 * 会议回执 <BR>
	 * @param map
	 * <pre>
	 * 	类型	                  名称			必填	                   备注
	 * String            meetingId      Y                会议ID
	 * String            content        Y                内容
	 * String            memberId       Y                人员Id
	 * String            feedbackFlag   Y                回执态度  （参加 1  不参加  0    待定 -1   告知人员传递3）
	 * String            fileJson       N                附件json数据
	 * </pre>
	 * @return
	 * <pre>
	 * 	MtReply 会议回执对象。
	 * </pre>
	 */
	@POST
	@Path("reply")
	@RestInterfaceAnnotation
	public Response reply(Map<String, Object> params) throws BusinessException{
		Long meetingId =ParamUtil.getLong(params, "meetingId");
		String content = ParamUtil.getString(params,"content","");
		Long memberId = ParamUtil.getLong(params, "memberId");
		Long proxyId = 0l;
		
		User user =  CurrentUser.get();
		if(user == null && memberId != null){
		    Long mId = Long.valueOf(memberId);
		    setCurrentUser(mId);
		    user = (User) AppContext.getThreadContext(GlobalNames.SESSION_CONTEXT_USERINFO_KEY);
		}
		if(!memberId.equals(user.getId())){
			proxyId = MemberAgentBean.getInstance().getAgentMemberId(ApplicationCategoryEnum.meeting.key(), memberId);
			if(!user.getId().equals(proxyId)){
				Map<String,String> retMap = new HashMap<String, String>();
				retMap.put("errorMsg", ResourceUtil.getString("meeting.error.noReply"));
				LOGGER.info("回执传入会议人员信息非法!传入人员id:"+memberId+",当前获取登录人员Id:"+user.getId()+",获取代理人Id:"+proxyId);
				return ok(retMap);
			}
		}
		
		MeetingBO meeting = meetingApi.getMeeting(meetingId);
		if(meeting.getState()==Constants.DATA_STATE_FINISH){//如果会议已结束
			 Map<String,String> retMap = new HashMap<String, String>();
			 retMap.put("errorMsg", ResourceUtil.getString("meeting.status.finish"));
			 return ok(retMap);
		}
		
		if(params.get("feedbackFlag") == null){
			return ok(errorParams());
		}
		
		int option = ParamUtil.getInt(params,"feedbackFlag");
		MtMeeting mtMeeting = meetingManager.getMeetingById(meetingId);
		//当与会人选择的部门或者集团的时候，不能使用meeting.getConferees()直接与memberId相比较
		MeetingMemberVO vo = meetingManager.getAllTypeMember(meetingId, mtMeeting);
		List<Long> confereeMemberList = vo.getConferees();
		if(mtMeeting.getImpart() != null && !confereeMemberList.contains(memberId) && mtMeeting.getImpart().contains(String.valueOf(memberId)) && option != Constants.FEEDBACKFLAG_IMPART){
			return ok(errorParams());
		}
		
		if(mtMeeting.getConferees() != null && confereeMemberList.contains(memberId) && option != Constants.FEEDBACKFLAG_ATTEND
				&& option != Constants.FEEDBACKFLAG_PENDING && option != Constants.FEEDBACKFLAG_UNATTEND){
			return ok(errorParams());
		}
		
		MtReplyBO relyBO = null;
        if (proxyId.longValue() == 0l) {
			List<MtReplyBO> myReplyList = meetingApi.findReplyByMeetingIdAndUserId(meetingId, user.getId());
			if(Strings.isEmpty(myReplyList)){
				relyBO = new MtReplyBO();
				relyBO.setMeetingId(meetingId);
				relyBO.setUserId(user.getId());
			}else{
				//如果之前已经有回执了，就不必更新为已读了，否则会把之前的回执意见覆盖掉
				relyBO = myReplyList.get(0);
				//删除之前的附件关联
				attachmentManager.deleteByReference(meetingId, relyBO.getId());
				if(option==Constants.FEEDBACKFLAG_NOREPLY){
					return ok(errorParams());
				}
			}
			relyBO.setOldFeedbackFlag(relyBO.getFeedbackFlag());
			relyBO.setUserName(user.getName());
			relyBO.setFeedback(content);
			relyBO.setFeedbackFlag(option);
			relyBO.setLookState(1);
			relyBO.setLookTime(new java.sql.Timestamp(new Date().getTime()));
			relyBO.setExt1(Constants.Not_Agent);
			relyBO.setExt2(Constants.Not_Agent);
		}else{
			List<MtReplyBO> myReplyList = meetingApi.findReplyByMeetingIdAndUserId(meetingId,  memberId);
			if(Strings.isEmpty(myReplyList)){
				relyBO = new MtReplyBO();
				relyBO.setMeetingId(meetingId);
			}else{
				relyBO = myReplyList.get(0);
				//删除之前的附件关联
				attachmentManager.deleteByReference(meetingId, relyBO.getId());
				if(option==Constants.FEEDBACKFLAG_NOREPLY){
					return ok(errorParams());
				}
			}
			relyBO.setOldFeedbackFlag(relyBO.getFeedbackFlag());
			relyBO.setFeedback(content);
			relyBO.setFeedbackFlag(option);
			relyBO.setLookState(1);
			relyBO.setLookTime(new java.sql.Timestamp(new Date().getTime()));
			//如果是代理的情况下  设置创建人为代理人，代理人为创建人
			relyBO.setExt1(Constants.PASSIVE_AGENT_FLAG);
			relyBO.setExt2(user.getName());
			relyBO.setUserId(memberId);
			relyBO.setUserName(orgManager.getMemberById(memberId).getName());
		}
		MtReply reply = new MtReply();
		BeanUtils.convert(reply, relyBO);
		meetingManager.updateReplyCount(relyBO, mtMeeting);
		//重复提交校验
		Long submitKey = AppContext.getCurrentUser().getId();
		try {
			if(meetingLockManager.isLock(submitKey)){
				return null;
			}
			reply = mtReplyManager.save(reply);
		} finally {
			if(meetingLockManager.isLock(submitKey)){
				meetingLockManager.unLock(submitKey);
			}
		}
        //如果等于-100的话，是从未查看状态变为已查看状态，不需要发送消息；其他的回执需要发送消息
        if (relyBO.getFeedbackFlag().intValue() != Constants.FEEDBACKFLAG_NOREPLY) {
            List<Long> listId = new ArrayList<Long>();
            listId.add(meeting.getCreateUser());
            Collection<MessageReceiver> receivers = MessageReceiver.getReceivers(meetingId, listId, "message.link.mt.reply", meeting.getId().toString(), reply.getId().toString());
            String feedback = MessageUtil.getComment4Message(relyBO.getFeedback());
            int contentType = Strings.isBlank(feedback) ? -1 : 1;
            int proxyType = 0;
            userMessageManager.sendSystemMessage(MessageContent.get("meeting.message.reply", meeting.getTitle(), user.getName(), relyBO.getFeedbackFlag(), contentType, feedback, proxyType, user.getName()), ApplicationCategoryEnum.meeting, user.getId(), receivers, MeetingMessageTypeEnum.Meeting_Reply.key());
        }
        
        /*
        if (fileUrlIds != null) {
            Long[] fileIds = {};
            if (fileUrlIds.length() > 2) {
                fileIds = CommonTools.parseStr2Ids(fileUrlIds.substring(1, fileUrlIds.length() - 1), ",").toArray(new Long[] {});
            }
            List<V3XFile> v3xFileList = fileManager.getV3XFile(fileIds);
            addAttachments(v3xFileList, meetingId, reply.getId());
        }
        */
        //保存附件
        String relateInfo = ParamUtil.getString(params, "fileJson", "[]");
        List<Map> files = JSONUtil.parseJSONString(relateInfo, List.class);
        try {
        	List<Attachment> attList = attachmentManager.getAttachmentsFromAttachList(ApplicationCategoryEnum.meeting, meetingId, reply.getId(), files);
        	if(!attList.isEmpty()){
        		attachmentManager.create(attList);
        	}
		} catch (Exception ex) {
			LOGGER.error(ex);
			throw new BusinessException(ex);
		}
        return ok(reply);
	}
	
	/**
	 * 会议详情api
	 * Long affairId  事项Id 非必填
	 * Long meetingId 会议Id 必填
	 * @param String openFrom  来源       非必填  当 openFrom=（关联文档：glwd 或 文档中心：docLib）时，不校验会议是否撤销
	 * @return
	 * <pre>
	 * 	会议详情map结构
	 * </pre>
	 * @throws BusinessException
	 */
    @GET
    @Produces({ MediaType.APPLICATION_JSON })
    @Path("detail")
    public Response detail(@QueryParam("affairId") Long affairId, @QueryParam("meetingId") Long meetingId, @QueryParam("openFrom") String openFrom) throws BusinessException {
    	Map<String, Object> map = new HashMap<String, Object>();
    	
    	if(meetingId == null){
    		return ok(errorParams());
    	}
    	
    	Integer zero = 0;
        int attCount = 0; //计算附件关联文档的个数
        
        MeetingBO meetingBO = new MeetingBO();
        if(meetingApi != null){
        	meetingBO = meetingApi.getMeetingByAffairId(affairId, AppContext.currentUserId(), meetingId, openFrom);//会议
        }
        
        if(meetingBO.getErrorRet().size() > 0) {
        	return ok(meetingBO.getErrorRet());
        }
        
        meetingBO.setCreateUserName(Functions.showMemberName(meetingBO.getCreateUser()));
        String emcName = Functions.showMemberName(meetingBO.getEmceeId());
        if(Strings.isNotBlank(emcName) && emcName.length() > 18){
        	emcName =  emcName.substring(0, 18) +"...";
        }
        meetingBO.setEmceeName(emcName);
        String recName = Functions.showMemberName(meetingBO.getRecorderId());
        if(Strings.isNotBlank(recName) && recName.length() > 18){
        	recName = recName.subSequence(0, 18) +"...";
        }
        meetingBO.setRecorderName(recName);
        if (!"html".equalsIgnoreCase(meetingBO.getBodyType())) {
            V3XFile file = fileManager.getV3XFile(Long.valueOf(meetingBO.getContent()));
            
            if(file != null){
                meetingBO.setLastModified(DateUtil.formatDateTime(file.getUpdateDate()));
            }
        } else {//HTML 正文需要被正文组件重新解析，才能正常显示其中的关联和附件
            String htmlContentString = meetingBO.getContent();
            meetingBO.setContent(HtmlMainbodyHandler.replaceInlineAttachment(htmlContentString));
        }
        //附件,关联文档
        List<Attachment> attachments = null; 
        if (meetingBO != null) {
            attachments = attachmentManager.getByReference(meetingBO.getId(),meetingBO.getId());
        }
        attCount = 0 ;
        for (Attachment att : attachments) {
            if (zero.equals(att.getType())) {
                attCount++;
            }
        }
        
        Map<String,List<V3xOrgMember>> mapListMember = mtMeetingManager.getMeetingMemberReply(meetingBO);
        
        //与会人信息列表
        List<V3xOrgMember> confereeMemberList = mapListMember.get("confereeList");
        //告知人信息列表
        List<V3xOrgMember> impartMemberList =  mapListMember.get("impartList");
        
        meetingBO.setLeaderNames(MeetingOrgHelper.getMemberNames(meetingBO.getLeader()));
        
        //全部人员Id
        List<Long> replyMemberIds = new ArrayList<Long>();
        
        List<String> confereesNames = new ArrayList<String>();
        int leaderMemberSize = 0;
        for (V3xOrgMember member : confereeMemberList) {
        	String memberName = Functions.showMemberName(member.getId());
        	MeetingReplyMemberVO replyMemberVO = new MeetingReplyMemberVO();
        	replyMemberVO.setMemberId(member.getId());
        	replyMemberVO.setMemberName(memberName);
        	replyMemberVO.setMemberPost(OrgHelper.showOrgPostNameByMemberid(member.getId()));
        	if(Strings.isNotBlank(meetingBO.getLeader()) && meetingBO.getLeader().contains(String.valueOf(member.getId()))){
        		leaderMemberSize++;
        	}else{
        		confereesNames.add(memberName);
        	}
        	
        	replyMemberIds.add(member.getId());
		}
        //设置详细页面显示的与会人
        List<String> showConfereesNames = new ArrayList<String>();
        if (confereesNames.size() > 10) {
            showConfereesNames = confereesNames.subList(0, 10);
        } else {
            showConfereesNames = confereesNames;
        }
        meetingBO.setConfereesNames(showConfereesNames.toString().substring(1,showConfereesNames.toString().length()-1));
        
        
        List<String> impartNames = new ArrayList<String>();
        for (V3xOrgMember member : impartMemberList) {
        	
        	String memberName = Functions.showMemberName(member.getId());
        	impartNames.add(memberName);
        	replyMemberIds.add(member.getId());
		}
        
        //设置详细页面显示的告知人
        List<String> showImpartNames = new ArrayList<String>();
        if (impartNames.size() > 10) {
            showImpartNames = impartNames.subList(0, 10);
        } else {
            showImpartNames = impartNames;
        }
        meetingBO.setImpartNames(showImpartNames.toString().substring(1,showImpartNames.toString().length()-1));
        
        if("pending".equals(openFrom)){
        	//查看时需要回执一条数据,控制图标
        	long memberId = meetingBO.getProxyId() == 0l ? AppContext.currentUserId() : meetingBO.getProxyId();
        	List<MtReplyBO> myReplyList = meetingApi.findReplyByMeetingIdAndUserId(meetingId,  memberId);
        	if(Strings.isNotEmpty(myReplyList) || myReplyList.size() > 0){
        		MtReplyBO replyBO = myReplyList.get(0);
        		if(replyBO != null && replyBO.getLookState() == null){
        			MtReply reply = new MtReply();
        			BeanUtils.convert(reply, replyBO);
        			
        			reply.setMeetingId(meetingId);
        			reply.setUserId(memberId);
        			if(meetingBO.getCreateUser() == AppContext.currentUserId()){
        				reply.setFeedbackFlag(Constants.FEEDBACKFLAG_ATTEND);
        			} else {
        				reply.setFeedbackFlag(Constants.FEEDBACKFLAG_NOREPLY);
        			}
        			reply.setLookState(1);//已查看
        			reply.setLookTime(new java.sql.Timestamp(new Date().getTime()));
        			mtReplyManager.save(reply);
        			
        			CtpAffair affair = affairManager.get(meetingBO.getAffairId());
        			if(affair !=null && (affair.getSubState() == null || !affair.getSubState().equals(SubStateEnum.col_pending_read.key()))){
        				affair.setSubState(SubStateEnum.col_pending_read.key());
        				affairManager.updateAffair(affair);
        			}
        		}
        	}
        }
        
        boolean showVideoEntrance = false;
        
		if(AppContext.hasPlugin("videoconference")) {
			MtMeeting meeting = meetingManager.getMeetingById(meetingId);
			List<Long> list = CommonTools.getMemberIdsByTypeAndId(meeting.getConferees(), orgManager);
			long userId = AppContext.currentUserId();
			if(MeetingNatureEnum.video.key().equals(meeting.getMeetingType()) && (list.contains(userId) || meeting.getEmceeId() == userId || meeting.getRecorderId() == userId)
				&& MeetingHelper.isPending(meeting.getState()) && MeetingHelper.isRoomPass(meeting.getRoomState())){
				showVideoEntrance = true;
				MeetingVideoManager meetingVideoManager = meetingApplicationHandler.getMeetingVideoHandler();
				String v_url = meetingVideoManager.getJoinImportUrlM3();
				map.put("v_url", v_url);
				
				meetingBO.setContent(meetingBO.getContent() + meetingVideoManager.getVideoUrlContent(meeting.getVideoMeetingId()));
			}
		}
		
		map.put("v_entrance", showVideoEntrance);
        
        //回复
        List<MtReplyBO> replyList = meetingApi.findReplyList(meetingId);
        // 未回执的
        Map<String, List<Long>> ReplyUsers = meetingApi.findMtReplyUsers(meetingId);
        List<Long>  noFeedbackList = ReplyUsers.get("noFeedback");
        String noFeedBackMemberIds = "";
        for (Long memberid : noFeedbackList) {
			noFeedBackMemberIds += memberid.toString() + ",";
		}
        // 设置代理人信息
        Long memberId =  meetingBO.getCreateUser();
		if(!memberId.equals(AppContext.currentUserId())){
			memberId = AppContext.currentUserId();
		}
		Long proxyId = MemberAgentBean.getInstance().getAgentMemberId(ApplicationCategoryEnum.meeting.key(), memberId);
		//修复OA-132633人员设置了代理人，被代理人登录M3后无法回执会议。当前登录人不是代理人时不为代理字段赋值
		if(null!=proxyId && proxyId.equals(AppContext.currentUserId())){
			meetingBO.setProxyId(proxyId);
			meetingBO.setProxy(true);
		}
        map.put("noFeedBackMemberIds", noFeedBackMemberIds);
        map.put("currentUser", AppContext.getCurrentUser());
        map.put("currentUserId", AppContext.currentUserId());
        map.put("meeting", meetingBO);
        map.put("attachmentList", attachments);
        map.put("attCount", attCount);
        map.put("confereeMemberSize", confereesNames.size());
        map.put("leaderMemberSize", leaderMemberSize);
        map.put("impartMemberSize", impartNames.size());
        map.put("replyList", replyList);
        map.put("replySize", replyList.size());
        map.put("listType", openFrom);
        //控制详情页面各按钮状态
        this.showOrHideButton(map, meetingBO, openFrom, replyMemberIds);

        //同步消息
        //userMessageManager.updateSystemMessageStateByUserAndReference(AppContext.currentUserId(), meetingId);
        
        return ok(JSONUtil.toJSONString(map));
    }
    
    /*
     * 控制详情页面各按钮状态
     */
    private void showOrHideButton(Map<String, Object> map, MeetingBO meetingBO, String openFrom, List<Long> replyMemberIds) throws BusinessException{
    	boolean canReply = true;         //回执
    	boolean canQuickReply = true;    //快速回执
    	boolean canCancel = false;       //撤销
    	boolean canModify = false;       //编辑
    	boolean canAdvanceOver = false;  //提前结束
    	boolean canSummary = true;       //纪要
    	
    	//当前为知会的时候隐藏纪要
    	if(meetingBO.getBusinessType().intValue() == 9){
    		canSummary = false;
    	}
    	//顶部区域
    	map.put("canSummary", canSummary);
    	
    	//当前会议结束和关联文档 、文档中心、会议结束的不显示按钮区域
    	if(MeetingHelper.isWait(meetingBO.getState()) || MeetingHelper.isFinished(meetingBO.getState()) ||
    		meetingBO.getAffairState().intValue() == 4 || "glwd".equals(openFrom) || "docLib".equals(openFrom)){
    		
    		map.put("showButton", false);
    		return;
    	}
    	
    	long currentUserId = AppContext.currentUserId();
    	long createUserId = meetingBO.getCreateUser();
    	long proxyId = -1;
    	if(meetingBO.getProxyId() != 0){
    		proxyId = meetingBO.getProxyId();
    	}
    	
    	//当前人员是发起人或者被代理人是发起人，但两个人员都不在参会人员中，隐藏回执
    	if((proxyId == createUserId && !replyMemberIds.contains(proxyId)) || 
    			(currentUserId == createUserId && !replyMemberIds.contains(currentUserId)) ) {
    		canReply = false;
    	}
    	
    	//当前为知会的时候隐藏快速回执  || 当前人员是发起人或者被代理人是发起人隐藏快速回执
    	if(meetingBO.getBusinessType().intValue() == 9 || currentUserId == createUserId || proxyId == createUserId){
    		canQuickReply = false;
    	}
    	
    	//当前人员是发起人，会议处于已发送或已开始状态
    	if(currentUserId == createUserId && MeetingHelper.isPending(meetingBO.getState())){
    		canCancel = true;
    	}
    	
    	//当前人员是发起人，会议处于已发送或已开始状态
    	if(currentUserId == createUserId && MeetingHelper.isPending(meetingBO.getState())){
    		canModify = true;
    	}
    	
    	//当前人员是发起人，会议处于已开始状态
    	if(currentUserId == createUserId && MeetingHelper.isStart(meetingBO.getState())){
    		canAdvanceOver = true;
    	}
    	
    	//按钮区域
    	map.put("canReply", canReply);
    	map.put("canQuickReply", canQuickReply);
    	map.put("canCancel", canCancel);
    	map.put("canModify", canModify);
    	map.put("canAdvanceOver", canAdvanceOver);
    	
    	map.put("showButton", canReply || canQuickReply || canCancel || canModify || canAdvanceOver);
    }
    
    /**
     * 查看具体会议人员
     * <pre>
     * Long affairId  事项Id 非必填
     * Long meetingId 会议Id 必填
     * String operate 人员类型  必填 【conferee：与会人、leader：参会领导、impart：告知人】
     * String listType 来自页签 必填 【"join", "noJoin", "pending", "noFeedback","impart"】
     * </pre>
     * @return FlipInfo
     */
    @GET
    @Produces({ MediaType.APPLICATION_JSON })
    @Path("meetingMembers")
    @RestInterfaceAnnotation
    public Response showMeetingMembers(@QueryParam("affairId") Long affairId, @QueryParam("meetingId") Long meetingId, @QueryParam("operate") String operate, @QueryParam("listType") String listType) throws BusinessException{
        FlipInfo flipInfo = getFlipInfo();
        List<MeetingReplyMemberVO> memberList = new ArrayList<MeetingReplyMemberVO>();
            
        if(meetingId == null){
            return ok(errorParams());
        }
        
        MeetingBO meetingBO = meetingApi.getMeetingByAffairId(affairId, AppContext.currentUserId(), meetingId, "meetingDetail");//会议
        
        Map<String,List<V3xOrgMember>> mapListMember = mtMeetingManager.getMeetingMemberReply(meetingBO);
        
        //与会人信息列表
        List<V3xOrgMember> confereeMemberList = mapListMember.get("confereeList");
        //告知人信息列表
        List<V3xOrgMember> impartMemberList =  mapListMember.get("impartList");
        
        List<MeetingReplyMemberVO> confereeMemberListVO = new ArrayList<MeetingReplyMemberVO>();
        List<MeetingReplyMemberVO> leaderMemberListVO = new ArrayList<MeetingReplyMemberVO>();
        List<MeetingReplyMemberVO> impartMemberListVO = new ArrayList<MeetingReplyMemberVO>();
        
        if ("conferee".equals(operate) || "leader".equals(operate)) {
            for (V3xOrgMember member : confereeMemberList) {
                String memberName = Functions.showMemberName(member.getId());
                MeetingReplyMemberVO replyMemberVO = new MeetingReplyMemberVO();
                replyMemberVO.setMemberId(member.getId());
                replyMemberVO.setMemberName(memberName);
                replyMemberVO.setMemberPost(OrgHelper.showOrgPostNameByMemberid(member.getId()));
                if(Strings.isNotBlank(meetingBO.getLeader()) && meetingBO.getLeader().contains(String.valueOf(member.getId()))){
                    leaderMemberListVO.add(replyMemberVO);
                }else{
                    confereeMemberListVO.add(replyMemberVO);
                }
            }
        } else if ("impart".equals(operate)){

            List<String> impartNames = new ArrayList<String>();
            for (V3xOrgMember member : impartMemberList) {
                
                String memberName = Functions.showMemberName(member.getId());
                impartNames.add(memberName);
                
                MeetingReplyMemberVO replyMemberVO = new MeetingReplyMemberVO();
                replyMemberVO.setMemberId(member.getId());
                replyMemberVO.setMemberName(memberName);
                replyMemberVO.setMemberPost(OrgHelper.showOrgPostNameByMemberid(member.getId()));
                impartMemberListVO.add(replyMemberVO);
            }
        }
        
        //各种参会人员
        Map<String, List<Long>> replyUserIds = meetingApi.findMtReplyUsers(meetingId);
        
        List<Long> noFeedbackStateList = replyUserIds.get("noFeedbackStateList");
        
        String[] names = { "join", "noJoin", "pending", "noFeedback","impart"};
        for (int i = 0; i < names.length; i++) { //初始化各类人员名称
            List<Long> memberIds = replyUserIds.get(names[i]);
            Map<Long,Long> lookStateMap = new HashMap<Long,Long>();
            if("noFeedback".equals(names[i])) {
                for(int j=0;j<memberIds.size() && j<noFeedbackStateList.size();j++){
                    lookStateMap.put(memberIds.get(j), noFeedbackStateList.get(j));
                }
            }
            //设置与会人处理状态
            for (MeetingReplyMemberVO replyMemberVO : confereeMemberListVO){
                //设置处理状态的标识
                if(memberIds.contains(replyMemberVO.getMemberId())) {
                    replyMemberVO.setReplyState(names[i]);
                }
                if(lookStateMap.containsKey(replyMemberVO.getMemberId())) {
                    replyMemberVO.setLook(String.valueOf(lookStateMap.get(replyMemberVO.getMemberId())));
                }
            }
            //告知处理状态
            for (MeetingReplyMemberVO replyMemberVO : impartMemberListVO){
                if(memberIds.contains(replyMemberVO.getMemberId())) {
                    replyMemberVO.setReplyState(names[i]);
                }
                if(lookStateMap.containsKey(replyMemberVO.getMemberId())) {
                    replyMemberVO.setLook(String.valueOf(lookStateMap.get(replyMemberVO.getMemberId())));
                }
            }
            //参会领导处理状态
            for (MeetingReplyMemberVO replyMemberVO : leaderMemberListVO){
                if(memberIds.contains(replyMemberVO.getMemberId())) {
                    replyMemberVO.setReplyState(names[i]);
                }
                if(lookStateMap.containsKey(replyMemberVO.getMemberId())) {
                    replyMemberVO.setLook(String.valueOf(lookStateMap.get(replyMemberVO.getMemberId())));
                }
            }
        }
        if ("conferee".equals(operate)) {
            for (MeetingReplyMemberVO replyMemberVO : confereeMemberListVO) {
                if (listType.equals(replyMemberVO.getReplyState())) {
                    memberList.add(replyMemberVO);
                }
            }
        } else if ("impart".equals(operate)) {
            for (MeetingReplyMemberVO replyMemberVO : impartMemberListVO) {
                if ("join".equals(listType)) {
                    listType = "impart";
                }
                if (listType.equals(replyMemberVO.getReplyState())) {
                    memberList.add(replyMemberVO);
                }
            }
        } else if ("leader".equals(operate)) {
            for (MeetingReplyMemberVO replyMemberVO : leaderMemberListVO) {
                if (listType.equals(replyMemberVO.getReplyState())) {
                    memberList.add(replyMemberVO);
                }
            }
        }
        
        DBAgent.memoryPaging(memberList, flipInfo);
            
        return ok(flipInfo);
    }
    /**
     * 查看会议纪要中的实际与会人员
     * <pre>
     * @param Long recordId 会议纪要ID 必填
     * </pre>
     * @return FlipInfo
     */
    @GET
    @Produces({ MediaType.APPLICATION_JSON })
    @Path("showMeetingSummaryMembers")
    public Response showMeetingSummaryMembers(@QueryParam("recordId") Long recordId) throws BusinessException{
        FlipInfo flipInfo = getFlipInfo();
        MeetingSummary mtSummary = null;
        List<MeetingReplyMemberVO> memberList = new ArrayList<MeetingReplyMemberVO>();
        
        if(recordId == null){
            return ok(errorParams());
        }
        mtSummary = meetingSummaryManager.getSummaryById(recordId);
        if (null != mtSummary) {
            List<Long> memlist = new ArrayList<Long>();
            MtMeeting meeting = meetingManager.getMeetingById(mtSummary.getMeetingId());
            // 实际与会人
            List<V3xOrgMember> scopesList = MeetingOrgHelper.getMembersByTypeAndId(mtSummary.getConferees(),
                    orgManager);
            for (V3xOrgMember scopes : scopesList) {
                memlist.add(scopes.getId());
            }

            if (!Strings.isEmpty(memlist)) {
                for (int i = 0; i < memlist.size(); i++) {
                    if (memlist.get(i).equals(meeting.getRecorderId()) || memlist.get(i).equals(meeting.getEmceeId())) {
                        continue;
                    }
                    MeetingReplyMemberVO memberVo = new MeetingReplyMemberVO();
                    memberVo.setMemberId(memlist.get(i));
                    String name = Functions.showMemberNameOnly(memlist.get(i));
                    memberVo.setMemberName(name);
                    // 当前人员职位
                    memberVo.setMemberPost(OrgHelper.showOrgPostNameByMemberid(memlist.get(i)));
                    memberList.add(memberVo);
                }

            }

            DBAgent.memoryPaging(memberList, flipInfo);
        }

        return ok(flipInfo);
    }
	
    /**
	 * 获取会议纪要
	 * @param recordId 会议纪要ID
	 * @return
	 * <pre>
	 * MtSummary对象
	 * </pre>
	 * @throws BusinessException
	 */
	@GET
	@Path("summary/{recordId}")
	@RestInterfaceAnnotation
	public Response getMeetingSummary(@PathParam("recordId") Long recordId) throws BusinessException{
		Map<String,Object> retMap = new HashMap<String,Object>();
		String errorMsg = "";
		MeetingSummary mtSummary = null;
		MtSummaryBO  sb = null;
		int memberNumber = 0;
		if(recordId == null){
			errorMsg = ResourceUtil.getString("meeting.params.error");
		}
		else{
			try{
			    User user = AppContext.getCurrentUser();
			    
			  //安全校验
		        SecurityCheckParam param = new SecurityCheckParam(ApplicationCategoryEnum.meeting, user, recordId);
		        SecurityCheck.isLicit(param);
		        if(!param.getCheckRet()){
		            errorMsg = param.getCheckMsg();
		            if(Strings.isBlank(errorMsg)){
		                errorMsg = ResourceUtil.getString("meeting.view.noAccess");
		            }
		        }else{
		            mtSummary = meetingSummaryManager.getSummaryById(recordId);
	                if(null != mtSummary){
	                    sb = new MtSummaryBO();
	                    //ID 内容
	                    sb.setId(mtSummary.getId());
	                    //记录人
	                    sb.setCreateUserName(Functions.showMemberNameOnly(Long.valueOf(mtSummary.getCreateUser())));
	                    sb.setContent(mtSummary.getContent());
	                    sb.setBodyType(mtSummary.getDataFormat());
	                    sb.setCreateDateFormat(this.formatShowTime(mtSummary.getCreateDate()));
	                    
	                    MtMeeting meeting = meetingManager.getMeetingById(mtSummary.getMeetingId());
	                    MeetingBO meetingBO = meetingManager.getMeetingBO(meeting);
	                    retMap.put("meeting",meetingBO);
	                    List<Long> memlist = new ArrayList<Long>();
	                    //实际与会人
    	                List<V3xOrgMember> scopesList =  MeetingOrgHelper.getMembersByTypeAndId(mtSummary.getConferees(), orgManager);
    	                for (V3xOrgMember scopes : scopesList) {
    	                    memlist.add(scopes.getId());
    	                }
	                    
	                    List<String> showNames = new ArrayList<String>();
	                    if(!Strings.isEmpty(memlist)){
	                        for(int i = 0 ; i< memlist.size(); i++){
	                        	if (memlist.get(i).equals(meeting.getRecorderId()) || memlist.get(i).equals(meeting.getEmceeId())) {
	                        		continue;
	                        	}
	                        	MeetingReplyMemberVO memberVo = new MeetingReplyMemberVO();
	                        	memberVo.setMemberId(memlist.get(i));
	                        	String name = Functions.showMemberNameOnly(memlist.get(i));
	                        	memberVo.setMemberName(name);
	                        	//当前人员职位
	                        	memberVo.setMemberPost(OrgHelper.showOrgPostNameByMemberid(memlist.get(i)));
	                        	
	                        	showNames.add(name);
	                        	memberNumber++;
	                        }
	                        List<String> showActualName = new ArrayList<String>();
	                        if (showNames.size() > 10) {
	                            showActualName = showNames.subList(0, 10);
	                        } else {
	                            showActualName = showNames;
	                        }
	                        sb.setActualShowName(showActualName.toString().substring(1,showActualName.toString().length()-1));
	                    }
	                    //附件和关联文档
	                    List<Attachment> byReference = attachmentManager.getByReference(sb.getId(),sb.getId());
	                    sb.setSummaryAttmentList(byReference);
	                    int attCount = 0 ;
	                    if(!Strings.isEmpty(byReference)){
	                        for(Attachment a :byReference){
	                            if(a.getType().intValue() == 0){
	                                attCount ++;
	                            }
	                        }
	                        sb.setSummaryAttCount(attCount);
	                    }
	                }
		        }
			}catch(Throwable e){
				errorMsg = ResourceUtil.getString("meeting.resource.dataError"); 
				retMap.put(RETURN_ERROR_MESSGAE,errorMsg);
				LOGGER.error("", e);
			}
		}
		retMap.put(RETURN_DATA,sb);
		retMap.put("memberNumber", memberNumber); //实际与会人数量
		return ok(retMap);
	}
	
	//格式化M3展示时间
	private String formatShowTime(Date d) {
		String paten  = "HH:mm";
        String retuDate="";
        if (d != null) {
            if(DateUtil.getYear(d)!=DateUtil.getYear(new Date())){//跨年 
                paten = "yyyy-MM-dd " + paten;
                retuDate = DateUtil.format(d, paten);
            }else if(DateUtil.getMonth(new Date()) != DateUtil.getMonth(d)){//跨月
                paten = "MM-dd "+paten;
                retuDate = DateUtil.format(d, paten);
            } else if(DateUtil.getDay(new Date()) != DateUtil.getDay(d)){//跨日
                paten = "MM-dd "+paten;
                retuDate = DateUtil.format(d, paten);
            }else{//今天的会议
                retuDate = ResourceUtil.getString("meeting.list.date.today")+" "+DateUtil.format(d, paten);
            }
             return retuDate;
        }
        return "";
	}
	
	/**
     * 获取邀请时选人界面过滤的人员
     * @param Long meetingId 会议Id 必填
     * @return
     * <pre>
     *  参会人员所有信息,如：[{id:181818,name:"杨海",type:"member",disable:true}]
     * </pre>
     * @throws BusinessException
     */
    @GET
    @Produces({ MediaType.APPLICATION_JSON })
    @Path("removeInvitePer")
    public Response removeInvitePer(@QueryParam("meetingId") Long meetingId) throws BusinessException {
        List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
        
        MtMeeting bean = meetingManager.getMeetingById(Long.valueOf(meetingId));
        List<Long> leaderIdList = new ArrayList<Long>();//存放参会领导ID
        List<MtReplyWithAgentInfo> replyLeaderExList = mtMeetingManager.getMtReplyInfoByLeader(bean, leaderIdList);
        List<MtReplyWithAgentInfo> replyExList = mtMeetingManager.getMtReplyInfo(bean, leaderIdList);
        if(Strings.isNotEmpty(replyLeaderExList) && Strings.isNotEmpty(replyExList)){
            List<MtReplyWithAgentInfo> leaderInfoList = new ArrayList<MtReplyWithAgentInfo>();
            for (MtReplyWithAgentInfo mtReplyWithAgentInfo : replyExList) {
                if(mtReplyWithAgentInfo.getReplyUserId()!=null && leaderIdList.contains(mtReplyWithAgentInfo.getReplyUserId())){
                    leaderInfoList.add(mtReplyWithAgentInfo);
                }
            }
            replyExList.removeAll(leaderInfoList);
        }
        //添加告知
        Map<String,String> impartMap = new HashMap<String,String>();
        List<Long> conferees = mtMeetingManager.getConfereeIds(bean.getConferees(), bean.getCreateUser(), bean.getEmceeId(), bean.getRecorderId());
        List<MtReplyWithAgentInfo> impartExList =  getImpartMemberIds(bean.getImpart(), conferees, impartMap);
        List<MtReplyWithAgentInfo> excludeReplyExList = new ArrayList<MtReplyWithAgentInfo>();
        if(replyExList != null)
            excludeReplyExList.addAll(replyExList);
        if(replyLeaderExList != null)
            excludeReplyExList.addAll(replyLeaderExList);
        if (impartExList.size() > 0) {
            excludeReplyExList.addAll(impartExList);
        }
        MtReplyWithAgentInfo emcee = new MtReplyWithAgentInfo();
        emcee.setReplyUserId(bean.getEmceeId());
        excludeReplyExList.add(emcee);
        if(bean.getRecorderId() != null && !bean.getEmceeId().equals(bean.getRecorderId())){
            MtReplyWithAgentInfo recorder = new MtReplyWithAgentInfo();
            recorder.setReplyUserId(bean.getRecorderId());
            excludeReplyExList.add(recorder);
        }
        
        List<Long> memberIdList = new ArrayList<Long>();
        //封装数据
        for (MtReplyWithAgentInfo excludeReplyEx : excludeReplyExList) {
            Map<String,Object> retMap = new HashMap<String,Object>();
            memberIdList.add(excludeReplyEx.getReplyUserId());
            retMap.put("id", excludeReplyEx.getReplyUserId());
            retMap.put("name", excludeReplyEx.getReplyUserName());
            retMap.put("type", "member");
            retMap.put("display", "none");
            list.add(retMap);
        }
        //当发起人不在会议过滤人员中时，添加过滤掉会议发起人
        if (!memberIdList.contains(bean.getCreateUser())) {
            Map<String,Object> retMap = new HashMap<String,Object>();
            retMap.put("id", bean.getCreateUser());
            retMap.put("name", bean.getCreateUserName());
            retMap.put("type", "member");
            retMap.put("display", "none");
            list.add(retMap);
        }
        
        return ok(JSONUtil.toJSONString(list));
    }
    /**
     * 获取参会人员是否有会议冲突详情
     * @param params 参数map对象
     * <pre>
     *   类型                           名称                           必填                 备注
     * String   meetingId      N    会议Id
     * Long     beginDatetime  Y    会议开始时间
     * Long     endDatetime    Y    会议结束时间
     * String   emceeId        N    主持人ID(直接人员ID）
     * String   recorderId     N    记录人ID(直接人员ID）
     * String   conferees      Y    选择的会议参会人员ID（格式：Member|1212223,Member|1212223)
     * </pre>
     * @return
     * <pre>
     * boolean   state   会议冲突状态
     * List<ConfereesConflictVO>  message 会议冲突人员详细信息
     * </pre>
     * @throws BusinessException
     */
    @POST
    @Path("checkConfereesConflict")
    public Response checkConfereesConflict(Map<String, Object> params) throws BusinessException{
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("conflict", "false");
        List<ConfereesConflictVO> conflictList = new ArrayList<ConfereesConflictVO>();
        
        String meetingId = ParamUtil.getString(params, "meetingId");
        Long beginDatetime = ParamUtil.getLong(params, "beginDatetime");
        Long endDatetime = ParamUtil.getLong(params, "endDatetime");
        String recorderId = ParamUtil.getString(params, "recorderId");
        String emceeId = ParamUtil.getString(params, "emceeId");
        String conferees = ParamUtil.getString(params, "conferees");
        
        Map<String, Object> confereesParamemterMap = new HashMap<String, Object>();
        confereesParamemterMap.put("meetingId", Strings.isBlank(meetingId) ? -1l : Long.parseLong(meetingId));
        confereesParamemterMap.put("emceeId", Strings.isBlank(emceeId) ? -1l : Long.parseLong(emceeId));
        confereesParamemterMap.put("recorderId", Strings.isBlank(recorderId) ? -1l : Long.parseLong(recorderId));
        confereesParamemterMap.put("beginDatetime", beginDatetime);
        confereesParamemterMap.put("endDatetime", endDatetime);
        confereesParamemterMap.put("conferees", conferees);
        confereesParamemterMap.put("currentUser", AppContext.getCurrentUser());
        
        try {
            conflictList = confereesConflictManager.findConfereesConflictVOList(confereesParamemterMap); 
        } catch(Exception e) {
            LOGGER.error("获取参会人员是否有会议冲突详情失败！" + e);
        }

        if (conflictList.size() > 0) {
            result.put("conflict", "true"); //返回是否冲突标志
        }
        
        return ok(result);
    }
    /**
     * 执行会议邀请
     * @param meetingId Long Y 会议ID
     * @param conferees String Y 邀请人员信息(格式：Member|1212223,Member|1212223)
     * @return
     * @throws BusinessException
     */
    @GET
    @Path("transInviteConferees")
    public Response transInviteConferees(@QueryParam("meetingId") Long meetingId, @QueryParam("conferees") String conferees) throws BusinessException{
        Map<String, Object> result = new HashMap<String, Object>();
        if(MeetingUtil.isIdNull(meetingId) || Strings.isBlank(conferees)){
        	return ok(errorParams());
        }
        String res = meetingManager.transInviteConferees(meetingId, conferees);
        result.put(SUCCESS_KEY, res);
        return ok(result);
    }
    /**
     *  获取会议目标为除otherMemberIds 的全体与会人员ID集合，未对代理人进行处理
     * @param currentMemberIds Type|Ids
     * @param otherMemberIds
     * @return
     */
    private List<MtReplyWithAgentInfo> getImpartMemberIds(String currentMemberIds,List<Long> conferees,Map<String,String> otherMemberIds) {

        List<MtReplyWithAgentInfo> memberIds = new ArrayList<MtReplyWithAgentInfo>();
        if (Strings.isNotBlank(currentMemberIds)) {
            Set<V3xOrgMember> orgMember = null;
            try {
                orgMember = this.orgManager.getMembersByTypeAndIds(currentMemberIds);
                if(orgMember!=null && orgMember.size()>0) {
                    for(V3xOrgMember member : orgMember) {
                        Long memberId = member.getId();
                        if(otherMemberIds.containsValue(memberId) && conferees.contains(memberId)) {
                            continue;
                        }
                        MtReplyWithAgentInfo exMr = new MtReplyWithAgentInfo();
                        exMr.setReplyUserId(member.getId());
                        memberIds.add(exMr);
                    }
                }
            } catch(Exception e) {
                LOGGER.error("获取会议目标为除otherMemberIds 的全体与会人员ID集合，未对代理人进行处理", e);
            }
        }
        return memberIds;
    }
	
    /**
	 * 会议处理
	 * POST
	 * Path("mydetail/{meetingid}")
	 * @param params 参数map对象
	 * <pre>
	 * 类型         名称                  必填                 备注
	 * String   meetingId    Y           会议Id
	 * String   userId       Y           当前用户
	 * String   feedbackFlag Y           回执态度（未回执 -100 参加 1 不参加  0   待定 -1 ）
	 * String   feedback     Y           回执内容
	 * </pre>
	 * @return
	 * <pre>
	 * 	{result:msg} 结果数据
	 * </pre>
	 * @throws BusinessException
	 */
	/*@POST
	@Path("handleMeeting")
	public Response handleMeeting(Map<String, Object> params) throws BusinessException{
		String flag = "";
		try {
			flag = mtMeetingManager.savemeetingReply(params);
		} catch (Exception e) {
			LOGGER.info("", e);
		}
		Map<String,Object> result = new HashMap<String,Object>();
		result.put("result", flag);
		return ok(result);
	}*/

	
	

	

	/**
	 * 获取单条会议数据<BR>
	 * @param long meetingId 会议Id 必填
	 * @return
	 * <pre>
	 * 	MtMeeting对象
	 * </pre>
	 */
	@GET
    @Path("{id}")
	@RestInterfaceAnnotation
    public Response getMeeting(@PathParam("id") long meetingId) throws BusinessException {
        return this.getMeeting(meetingId, new HashMap<String,Object>());
    }
	
	
	/**
	 * 获取单条会议数据<BR>
	 * @param meetingId 会议id  必填
	 * @param map 参数Map
	 * <pre>
	 * 	类型	                  名称			必填	                   备注
	 *  Long             proxyId           N              被代理人Id
	 *  Long             currentUserId     N              当前用户Id
	 * </pre>
	 * @return
	 * @throws BusinessException 
	 */
	@POST
	@Path("{id}")
	public Response getMeeting(@PathParam("id") long meetingId,Map<String, Object> map) throws BusinessException {
		Long proxyId = ParamUtil.getLong(map, "proxyId",0l);
		Long currentUserId = ParamUtil.getLong(map, "currentUserId",0l);
		MtMeeting meeting = null;
		try{
			// SECURITY 访问安全检查
			if(AppContext.getCurrentUser() != null){
				if (!SecurityCheck.isLicit(AppContext.getRawRequest(), AppContext.getRawResponse(), ApplicationCategoryEnum.meeting, AppContext.getCurrentUser(), meetingId, null, null)) {
			         BusinessException bexception = new BusinessException( ResourceUtil.getString("m1.collaboration.no_permission"));
			         bexception.setCode("2003");
			         throw bexception;
			        }
			}
		      meeting = mtMeetingManager.getMtMeetingById(meetingId,proxyId,true,currentUserId);
		}catch(Exception e){
			LOGGER.error("",e);
		}
		
		if(proxyId != null && proxyId != 0l && proxyId != -1l){
            currentUserId = proxyId;
        }
		
		List<CtpAffair> affairList = affairManager.getAffairs(ApplicationCategoryEnum.meeting, meetingId, currentUserId);
		if(Strings.isNotEmpty(affairList)) {
			boolean isLook = false;
			for(CtpAffair affair : affairList) {
				if(affair.getSubState() == null || affair.getSubState() == SubStateEnum.col_pending_unRead.key()) {
					 affairManager.updateAffairReaded(affair);
					 isLook = true;
				}
			}
			
			if(isLook) {
				List<MtReply> mList = mtReplyManager.findByMeetingIdAndUserId(meeting.getId(), currentUserId);
	            if(mList != null && mList.size() == 0) {
	                MtReply mtReply = new MtReply();
	                mtReply.setMeetingId(meeting.getId());
	                mtReply.setUserId(currentUserId);
	                if(meeting.getCreateUser().equals(Long.valueOf(currentUserId))){
	                	mtReply.setFeedbackFlag(1);
	                    mtReply.setLookState(1);
	                } else {
	                	mtReply.setFeedbackFlag(-100);
	                    mtReply.setLookState(2);
	                }
	                mtReply.setLookTime(new java.sql.Timestamp(new Date().getTime()));
	                mtReplyManager.save(mtReply);
	            }
			}
		}
		return ok(meeting);
	}
	/**
	 * 撤销会议
	 * @param params 传入参数
	 * <pre>
	 * 类型 	|	名称	| 	必填	|	备注
	 * String	|	meetingId	|	Y	|	当前会议Id
	 * String	|	isBatch		|	N	|	周期性会议是否批量撤销（true，false）
	 * String	|	content		|	Y	| 	撤销附言
	 * String	|	sendSMS		|	N	|	是否发送短信
	 * </per>
	 * @return Map<String,String>
	 * @throws BusinessException 
	 */
	@POST
	@Path("cancelMeeting")
	public Response cancelMeeting(Map<String,String> params) throws BusinessException {
		
		Long meetingId = ParamUtil.getLong(params, "meetingId"); 
		String isBatch = ParamUtil.getString(params, "isBatch", "false");
		String content = ParamUtil.getString(params, "content");
		String sendSMS = ParamUtil.getString(params, "sendSMS", "false");
		Map<String, Object> parameterMap = new HashMap<String, Object>();
    	parameterMap.put("meetingId", meetingId);
    	parameterMap.put("isBatch",  "false".equals(isBatch)?false:true);
    	parameterMap.put("currentUser", AppContext.getCurrentUser());
    	parameterMap.put("content", content);
    	parameterMap.put("sendSMS", "false".equals(sendSMS)?false:true);
    	boolean is_success = meetingManager.transCancelMeeting(parameterMap);
    	
		Map<String,String> returnMessage = new HashMap<String,String>();
    	
    	String message = SUCCESS_KEY;
    	if(!is_success) {
    		message = RETURN_ERROR_MESSGAE;
    	}
    	returnMessage.put("message", message);
		return ok(returnMessage);
	}
	
	/**
	 * 提前结束会议
	 * @param params 传入参数
	 * <pre>
	 * 类型 	|	名称	| 	必填	|	备注
	 * String	|	meetingId	|	Y	|	当前会议Id
	 * </per>
	 * @return Map<String,String>
	 * @throws BusinessException 
	 */
	@POST
	@Path("advanceMeeting")
	public Response advanceMeeting(Map<String,String> params) throws BusinessException{
		Long meetingId = ParamUtil.getLong(params, "meetingId"); 
		String content = ParamUtil.getString(params, "content");
		Map<String, Object> parameterMap = new HashMap<String, Object>();
    	parameterMap.put("meetingId", meetingId);
    	parameterMap.put("currentUser", AppContext.getCurrentUser());
    	parameterMap.put("content", content);
    	parameterMap.put("action", MeetingActionEnum.finishMeeting.name());
    	parameterMap.put("endDatetime", DateUtil.currentDate());
    	boolean is_success = meetingManager.transFinishAdvanceMeeting(parameterMap);
    	
    	Map<String,String> returnMessage = new HashMap<String,String>();
    	
    	String message = SUCCESS_KEY;
    	if(!is_success) {
    		message = RETURN_ERROR_MESSGAE;
    	}
    	returnMessage.put("message", message);
		return ok(returnMessage);
	}
	
	/**
	 * 获取会议的震荡回复意见<BR>
	 * @param long meetingId  会议Id 必填
	 * @return
	 * <pre>
	 * 	List<MtReply> 意见列表
	 * </pre>
	 */
	@POST
	@Path("comments/{meetingid}")
	@RestInterfaceAnnotation
	public Response getMeetingComments(@PathParam("meetingid") long meetingId){
		List<MtReply> commentList = null;
		try {
			commentList = mtMeetingManager.getAllReplysAndComments(meetingId);
		} catch (BusinessException e) {
		    LOGGER.error("", e);
		}
		return ok(commentList);
	}
	
	/**
	 * 错误参数提示
	 * @return
	 */
	private Map<String,String> errorParams(){
		Map<String,String> retMap = new HashMap<String, String>();
		retMap.put("errorMsg", ResourceUtil.getString("meeting.error.errorParams"));
		return retMap;
	}
	
	
	
	/**
	 * 获取已申请的会议室
	 * @param params 传入参数
	 * <pre>
	 * 类型 	|	名称	| 	必填	|	备注
	 * String	|	pageNo	|	N	|	页数
	 * String	|	pageSize|	N	|	每页显示条数
	 * </per>
	 * @return flipInfo List<com.seeyon.ctp.rest.resources.MeetingRoomRestVO>
	 * @throws BusinessException 
	 */
	@POST
	@Path("getApplyMeemtingRooms")
	public Response getApplyMeemtingRooms(Map<String, String> params) throws BusinessException{
		User currentUser = AppContext.getCurrentUser();
		FlipInfo flipInfo = super.getFlipInfo();
		flipInfo.setPage(ParamUtil.getInt(params, "pageNo",1));
		flipInfo.setSize(ParamUtil.getInt(params, "pageSize",20));
		Map<String, Object> conditionMap = new HashMap<String, Object>();
		conditionMap.put("userId", currentUser.getId());
		
		String type = params.get("openFrom");
		if(Strings.isNotBlank(type) && "meetingCreate".equals(type)){
			conditionMap.put("condition", "4");
			conditionMap.put("status", RoomAppStateEnum.pass.key());
		}
		
		List<MeetingRoomListVO> meetingRoomListVO = meetingRoomListManager.findMyRoomAppList(conditionMap,flipInfo);
		
		List<MeetingRoomRestVO> meetingRoomList = new ArrayList<MeetingRoomRestVO>();
		for(MeetingRoomListVO roomVo : meetingRoomListVO) {
			MeetingRoomRestVO meetingroom = new MeetingRoomRestVO();
			BeanUtils.convert(meetingroom,roomVo);
			meetingRoomList.add(meetingroom);
		}
		flipInfo.setData(meetingRoomList);
		return ok(flipInfo);
	}

	/**
	 * 获取待审核的会议室
	 * @param params 传入参数
	 * <pre>
	 * 类型 	|	名称	| 	必填	|	备注
	 * String	|	pageNo	|	N	|	页数
	 * String	|	pageSize|	N	|	每页显示条数
	 * </per>
	 * @return flipInfo List<com.seeyon.ctp.rest.resources.MeetingRoomRestVO>
	 * @throws BusinessException 
	 */
	@POST
	@Path("getMeetingRoomAudits")
	public Response getMeetingRoomAudits(Map<String,String> params) throws BusinessException {
		User currentUser = AppContext.getCurrentUser();
		FlipInfo flipInfo = super.getFlipInfo();
		flipInfo.setPage(ParamUtil.getInt(params, "pageNo",1));
		flipInfo.setSize(ParamUtil.getInt(params, "pageSize",20));
		Map<String, Object> conditionMap = new HashMap<String, Object>();
		conditionMap.put("userId", currentUser.getId());
		List<MeetingRoomListVO> meetingRoomListVO = meetingRoomListManager.findRoomPermList(conditionMap,flipInfo);
		
		List<MeetingRoomRestVO> meetingRoomList = new ArrayList<MeetingRoomRestVO>();
		for(MeetingRoomListVO roomVo : meetingRoomListVO) {
			MeetingRoomRestVO meetingroom = new MeetingRoomRestVO();
			BeanUtils.convert(meetingroom,roomVo);
			
			V3xOrgMember member = orgManager.getMemberById(roomVo.getAppPerId());
			//其他单位人员显示简称
            StringBuilder accountName = new StringBuilder();
            if(!currentUser.getLoginAccount().equals(member.getOrgAccountId())){
                V3xOrgAccount account = orgManager.getAccountById(member.getOrgAccountId());
                accountName.append("(").append(account.getShortName()).append(")");
            }
            meetingroom.setAppPerName(member.getName()+accountName);
			meetingRoomList.add(meetingroom);
		}
		flipInfo.setData(meetingRoomList);
		return ok(flipInfo);
	}
	
	/**
	 * 获取申请的会议室信息
	 * @param params 传入参数
	 * <pre>
	 * 类型 	|	名称	| 	必填	|	备注
	 * Long	|	roomAppId	|	Y	|	会议室申请Id
	 * </per>
	 * @return MeetingRoomRestVO
	 * @throws BusinessException 
	 */
	@POST
	@Path("getMeetingRoomApp")
	public Response getMeetingRoomApp(Map<String,String> params) throws BusinessException {
		MeetingRoomRestVO mrRestVO = new MeetingRoomRestVO();
		
		User currentUser = AppContext.getCurrentUser();
		Long roomAppId = Long.valueOf(params.get("roomAppId"));
		
		MeetingRoomApp mrapp = meetingRoomManager.getRoomAppById(roomAppId);
		
		if(mrapp == null){
			Map<String,String> retMap = new HashMap<String, String>();
			retMap.put("errorMsg", ResourceUtil.getString("meeting.room.app.cancel"));
			return ok(retMap);
		}
		
		MeetingRoom room = this.meetingRoomManager.getRoomById(mrapp.getRoomId());
		mrRestVO.setRoomId(room.getId());
		//会议室申请状态
		mrRestVO.setAppStatus(mrapp.getStatus());
		mrRestVO.setMeetingId(mrapp.getMeetingId());
		mrRestVO.setRoomAppId(mrapp.getId());
		mrRestVO.setRoomName(room.getName());
		mrRestVO.setStartDatetime(String.valueOf(mrapp.getStartDatetime()).substring(0,16));
		mrRestVO.setEndDatetime(String.valueOf(mrapp.getEndDatetime()).substring(0,16));
		mrRestVO.setAdminLab(room.getAdminLab());
		if (mrapp.getStartDatetime().getTime() > DateUtil.currentDate().getTime()) {
			mrRestVO.setCancelMRApp(true);
		} else {
			mrRestVO.setCancelMRApp(false);
		}
		//wuxiaoju 提前结束
		String[] usedstatusArr = MeetingHelper.getRoomAppUsedStateName(mrapp.getStatus(), mrapp.getUsedStatus(), DateUtil.currentDate(), mrapp.getStartDatetime(), mrapp.getEndDatetime());
		int usedstatus = Integer.parseInt(usedstatusArr[1]);
		if (usedstatus != 0 && usedstatus != 2 && usedstatus != 3) {//0:未使用,2:已使用,3:提前结束
            mrRestVO.setFinishMRApp(true);
        } else {
            mrRestVO.setFinishMRApp(false);
        }
		//wuxiaoju 当会议室拥有会议时，查询出会议名称
		if(mrapp.getMeetingId() != null) {
		    List<Long> meetingIdList = new ArrayList<Long>();
		    meetingIdList.add(mrapp.getMeetingId());
		    Map<Long, String> meetingNameMap = this.meetingManager.getMeetingNameMap(meetingIdList, null);
		    mrRestVO.setMeetingName(meetingNameMap.get(mrapp.getMeetingId()));
		}
		String permDescription = "";
		//审核状态不是未审核的时候。查询出审核意见
		if(mrapp.getStatus() != 0) {
			MeetingRoomPerm roomPerm = this.meetingRoomManager.getRoomPermByAppId(roomAppId);
			if (roomPerm!=null) {
				permDescription = roomPerm.getDescription();
			}
		}
		mrRestVO.setPermDescription(Strings.toHTML(permDescription));
		mrRestVO.setDescription(Strings.toHTML(mrapp.getDescription()));
		V3xOrgMember member = orgManager.getMemberById(mrapp.getPerId());
		//其他单位人员显示简称
        StringBuilder accountName = new StringBuilder();
        if(!currentUser.getLoginAccount().equals(member.getOrgAccountId())){
            V3xOrgAccount account = orgManager.getAccountById(member.getOrgAccountId());
            accountName.append("(").append(account.getShortName()).append(")");
        }
		mrRestVO.setAppPerName(member.getName()+accountName);
		mrRestVO.setAppPerId(member.getId());
		Long meetingId = mrapp.getMeetingId();
		String resourcesNames = new String();
		if (null != meetingId) {
			resourcesNames = meetingResourcesManager.getResourceNamesByMeetingId(meetingId);
		}
		mrRestVO.setMeetingResources(resourcesNames);
		return ok(mrRestVO);
	}
	
	/**
	 * 执行会议室审核
	 * @param params 传入参数
	 * <pre>
	 * 类型 	|	名称	| 	必填	|	备注
	 * Long	|	roomAppId	|	Y	|	会议室申请Id
	 * String	|	description	|	N	|	审核意见
	 * Integer	|	permStatus	|	Y	|	审核态度（1：同意、2：不同意）
	 * </per>
	 * @return boolean true/false
	 * @throws BusinessException 
	 */
	@SuppressWarnings("finally")
	@POST
	@Path("finishAuditMeetingRoom")
	public Response finishAuditMeetingRoom(Map<String,String> params) throws BusinessException {
		User currentUser = AppContext.getCurrentUser();
		MeetingRoomAppVO appVo = new MeetingRoomAppVO();
		appVo.setRoomAppId(Long.valueOf(params.get("roomAppId")));
		appVo.setDescription(params.get("description"));
		appVo.setStatus(Integer.valueOf(params.get("permStatus")));
		appVo.setSystemNowDatetime(DateUtil.currentDate());
		appVo.setCurrentUser(currentUser);
		boolean result = false;
		try {
			result =this.meetingRoomManager.transPerm(appVo);
		} catch (Exception e) {
			LOGGER.error("执行会议室审核报错",e);
			result = false;
		} finally {
			return ok(result);
		}
	}
	
	/**
     * 执行会议室提前结束
     * @param params 传入参数
     * <pre>
     * 类型                   |       名称                                | 必填  | 备注
     * Long    |   roomAppId       | Y  | 会议室申请Id
     * String  |  isContainMeeting | Y  | 会议室是否绑定会议（"false"：未绑定、"true"：绑定会议室）
     * </per>
     * @return  Map<String, Object>
     * @throws BusinessException 
     */
    @SuppressWarnings("finally")
    @POST
    @Path("finishMeetingRoom")
    public Response finishMeetingRoom(Map<String,String> params) throws BusinessException {
        Map<String, Object> r_map = new HashMap<String, Object>();
        Map<String, Object> parameterMap = new HashMap<String, Object>();
        
        parameterMap.put("roomAppId", Long.valueOf(params.get("roomAppId")));
        parameterMap.put("currentUser", AppContext.getCurrentUser());
        parameterMap.put("endDatetime", DateUtil.currentDate());
        parameterMap.put("action", MeetingActionEnum.finishRoomApp.name());
        parameterMap.put("isContainMeeting", params.get("isContainMeeting"));
        boolean result = false;
        try {
            result = this.meetingRoomManager.transFinishAdvanceRoomApp(parameterMap);
        } catch (Exception e) {
            LOGGER.error("执行会议室提前结束报错",e);
            result = false;
        } finally {
            r_map.put(SUCCESS_KEY, result);
            return ok(r_map);
        }
    }
	
	/**
	 * 撤销会议室
	 * @param params 传入参数
	 * <pre>
	 * 类型 	|	名称	| 	必填	|	备注
	 * Long	|	roomAppId	|	Y	|	会议室申请Id
	 * String |	cancelContent	| Y	| 撤销附言
	 * </per>
	 * @return boolean true/false
	 * @throws BusinessException 
	 */
	@SuppressWarnings("finally")
	@POST
	@Path("cancelMeetRoomApp")
	public Response cancelMeetRoomApp(Map<String,String> params) throws BusinessException{
		User currentUser = AppContext.getCurrentUser();
		
		Long roomAppId = ParamUtil.getLong(params, "roomAppId");
		String cancelContent = ParamUtil.getString(params, "cancelContent");
		
		if(roomAppId == null || cancelContent == null){
        	return ok(errorParams());
		}
		
		Map<String, Object> parameterMap = new HashMap<String, Object>();
		parameterMap.put("roomAppIdList", MeetingUtil.getIdList(params.get("roomAppId")));
		parameterMap.put("currentUser", currentUser);
		parameterMap.put("cancelContent", params.get("cancelContent"));
		parameterMap.put("action", MeetingActionEnum.cancelRoomApp.name());
		boolean result = false;
		try {
			result = this.meetingRoomManager.transCancelRoomApp(parameterMap);
		} catch(Exception e) {
			LOGGER.error("撤销会议室申请出错", e);
			result = false;
		} finally {
			return ok(result);
		}
	}
	
	
	/**
	 * 执行会议室申请操作
	 * @param params    传入参数
	 * 	<pre>
	 *        类型    名称             必填     备注
	 *        String   roomId            Y     会议室ID
	 *        String   description       N     用途
	 *        String   startDatetime     Y     开始时间
	 *        String   endDatetime       Y     结束时间
	 *  </pre>
	 * @return Map<String, Object>
	 * @throws BusinessException
	 * @throws ParseException 
	 */
	@POST
	@Path("execApp")
	public Response execApp(Map<String, Object> params) throws BusinessException{
		Map<String, Object> r_map = new HashMap<String, Object>();

		User user = AppContext.getCurrentUser();
		String roomId = ParamUtil.getString(params, "roomId");
		
		Map<String, String> parameterMap = new HashMap<String, String>();
		parameterMap.put("roomId", roomId);
		parameterMap.put("perId", String.valueOf(user.getId()));
		parameterMap.put("departmentId", String.valueOf(user.getDepartmentId()));
		parameterMap.put("description", ParamUtil.getString(params, "description"));
		parameterMap.put("startDatetime", ParamUtil.getString(params, "startDatetime"));
		parameterMap.put("endDatetime", ParamUtil.getString(params, "endDatetime"));
		
		//rest接口用   防止测试数据不合法
		List<MeetingRoom> meetingRooms = meetingRoomManager.getMyCanAppRoomList(user, -1, "", null);
		if(Strings.isEmpty(meetingRooms)){
			r_map.put("errorMsg", ResourceUtil.getString("meeting.rest.hasNoCanApply"));
			return ok(r_map);
		}
		boolean canNotApply = true;
		for(MeetingRoom meetingRoom : meetingRooms){
			if(roomId.equals(String.valueOf(meetingRoom.getId()))){
				canNotApply = false;
				break;
			}
		}
		if(canNotApply){
			r_map.put("errorMsg", ResourceUtil.getString("meeting.rest.canNotApply"));
			return ok(r_map);
		}
		
		MeetingRoomAppVO appVo = new MeetingRoomAppVO();
		appVo.setAction("apply");
		appVo.setParameterMap(parameterMap);
		appVo.setSystemNowDatetime(DateUtil.currentDate());
		appVo.setCurrentUser(AppContext.getCurrentUser());

		//重复提交校验
		Long submitKey = AppContext.getCurrentUser().getId();
		try {
			if(meetingLockManager.isLock(submitKey)){
				return null;
			}
			if(!meetingRoomManager.transApp(appVo)){
				r_map.put("errorMsg", appVo.getMsg());
			}else{
				//返回会议室申请状态
				r_map.put("roomAppState", appVo.getMeetingRoomApp().getStatus());
			}
		} catch (Exception e) {
			r_map.put("errorMsg", e.getMessage());
		} finally {
			if(meetingLockManager.isLock(submitKey)){
				meetingLockManager.unLock(submitKey);
			}
		}
		
		return ok(r_map);
	}
	
	/**
	 * 获取会议室列表
	 * @param params    传入参数
	 * 	<pre>
	 *        类型    名称             必填     备注
	 *        String   pageNo     Y     页数(1,2,3...)
	 *        String   pageSize   Y     每页显示条数
	 *        String   condition  N     查询条件类型(查询时选择的类型 time/roomName)
	 *        String   roomName   N     会议室名称
	 *        String   startDate  N     开始时间(yyyy-MM-dd HH:mm)
	 *        String   endDate    N     结束时间(yyyy-MM-dd HH:mm)
	 *  </pre>
	 * @return com.seeyon.ctp.util.FlipInfo
	 * @throws BusinessException
	 * @throws ParseException 
	 */
	@POST
	@Path("getMeetingRooms")
	public Response getMeetingRooms(Map<String, Object> params) throws BusinessException, ParseException{
		FlipInfo flipInfo = super.getFlipInfo();
		flipInfo.setPage(ParamUtil.getInt(params, "pageNo",1));
		flipInfo.setSize(ParamUtil.getInt(params, "pageSize",20));
		
		List<MeetingRoomListVO> meetingRoomVos = meetingRoomM3Manager.getMeetingRooms(params, flipInfo);

		flipInfo.setData(meetingRoomVos);
		return ok(flipInfo);
	}

	/**
	 * 获取会议室详情
	 * @param params
	 * 	<pre>
	 *        类型    名称             必填     备注
	 *        String   roomId     Y     会议室ID
	 *  </pre>
	 * @return com.seeyon.apps.meetingroom.vo.MeetingRoomVO
	 * @throws BusinessException
	 * @throws ParseException
	 */
	@POST
	@Path("getMeetingRoom")
	public Response getMeetingRoom(Map<String, Object> params) throws BusinessException, ParseException{
		Long roomId = ParamUtil.getLong(params, "roomId");

		MeetingRoom meetingRoom = meetingRoomManager.getRoomById(roomId);
		Map<String, Object> r_map = new HashMap<String, Object>();
		if(meetingRoom == null){
			r_map.put(RETURN_ERROR_MESSGAE, ResourceUtil.getString("meeting.meetingRoomDetail.noMeetingRoom"));
			return ok(r_map);
		}
		
		//处理管理员姓名
		String[] meetingRoomAdmins = meetingRoom.getAdmin().split(",");
		StringBuffer sbAdminNames = new StringBuffer();
		for(String meetingRoomAdmin : meetingRoomAdmins){
			if (Strings.isNotBlank(meetingRoomAdmin)) {
				V3xOrgMember member = orgManager.getMemberById(Long.valueOf(meetingRoomAdmin));
				sbAdminNames.append(member.getName() + ",");
			}
		}
		String adminNames = sbAdminNames.toString();
		if(Strings.isNotBlank(adminNames) && adminNames.endsWith(",")){
			adminNames = adminNames.substring(0, adminNames.length()-1);
		}

		MeetingRoomVO meetingRoomVo = new MeetingRoomVO();
		meetingRoomVo.setMeetingRoom(meetingRoom);
		meetingRoomVo.setAdminNames(adminNames);
		
		//图片处理
		List<Attachment> att = attachmentManager.getByReference(meetingRoom.getId(), RoomAttEnum.image.key()) ;
		if (att.size() > 0) {
			meetingRoomVo.setImage(String.valueOf(att.get(0).getFileUrl()));
		}
		return ok(meetingRoomVo);
	}
	
	/**
	 * 获取会议室预订所有天的集合
	 * @param params
	 * 	<pre>
	 *        类型    名称             必填     备注
	 *        String   roomId     Y     会议室ID
	 *  </pre>
	 * @return Map<String, Object>
	 * @throws BusinessException
	 * @throws ParseException 
	 */
	@POST
	@Path("getOrderDate")
	public Response getOrderDate(Map<String, Object> params) throws BusinessException, ParseException{
		Long roomId = ParamUtil.getLong(params, "roomId");
		
		if(roomId == null){
			return ok(errorParams());
		}
		
		List<MeetingRoomApp> list = meetingRoomManager.getAllRoomAppByRoomId(roomId);
		Set<String> set = new HashSet<String>();
		
		int count = 0;//计数，循环超300则直接返回
		String startDatetime = "";
		String endDatetime = "";
		Date tempDate;
		
		for(MeetingRoomApp app : list){
			startDatetime = Datetimes.format(app.getStartDatetime(), Datetimes.dateStyle);
			endDatetime = Datetimes.format(app.getEndDatetime(), Datetimes.dateStyle);
			
			set.add(startDatetime);
			
			if(startDatetime.equals(endDatetime)){
				//循环300次退出
				if(count++ > 300){
					break;
				}
				continue;
			}
			
			while(!startDatetime.equals(endDatetime)){
				//开始时间加一天
				tempDate = new SimpleDateFormat("yyyy-MM-dd").parse(startDatetime);
				tempDate = new Date(tempDate.getTime() + (24 * 60 * 60 * 1000));
				startDatetime = Datetimes.format(tempDate, Datetimes.dateStyle);
				set.add(startDatetime);
				//循环300次退出
				if(count++ > 300){
					break;
				}
			}
		}
		List<String> r_list = new ArrayList<String>();
		r_list.addAll(set);
		return ok(r_list);
	}
	
	/**
	 * 获取会议室申请信息
	 * @param params
	 * 	<pre>
	 *        类型    名称             必填     备注
	 *        String   roomId     Y     会议室ID
	 *        String   qDate             Y     查询日期 (yyyy-MM-dd)
	 *  </pre>
	 * @return List<com.seeyon.apps.meetingroom.po.MeetingRoomApp>
	 * @throws BusinessException
	 * @throws ParseException
	 */
	@POST
	@Path("getMeetingRoomApps")
	public Response getMeetingRoomApps(Map<String, Object> params) throws BusinessException, ParseException{
		String roomId = ParamUtil.getString(params, "roomId");
		String qDate = ParamUtil.getString(params, "qDate");
		
		String sStartDate = qDate + " 00:00:00";
		String sEndDate = qDate + " 00:00:00";
		
		SimpleDateFormat sdf = new SimpleDateFormat(DateUtil.YEAR_MONTH_DAY_HOUR_MINUTE_SECOND_PATTERN);
		Date startDate = sdf.parse(sStartDate);
		Date endDate = DateUtil.addDay(sdf.parse(sEndDate), 1);
		
		List<Long> roomIdList = new ArrayList<Long>();
		roomIdList.add(Long.valueOf(roomId));
		
		List<MeetingRoomApp> meetingRoomApps = meetingRoomManager.getUsedRoomAppListByDate(startDate, endDate, roomIdList, true);
		
		List<MeetingRoomOccupancyVO> meetingRoomOccupancys = copyAppToOccupancyVO(meetingRoomApps);
		
		return ok(meetingRoomOccupancys);
	}
	
	/**
	 * 复制申请信息至占用情况VO
	 * @return
	 * @throws BusinessException 
	 */
	private List<MeetingRoomOccupancyVO> copyAppToOccupancyVO(List<MeetingRoomApp> meetingRoomApps) throws BusinessException{
		List<MeetingRoomOccupancyVO> occupancyVos = new ArrayList<MeetingRoomOccupancyVO>();
		for(MeetingRoomApp app : meetingRoomApps){
			MeetingRoomOccupancyVO vo = new MeetingRoomOccupancyVO();
			vo.setStartDatetime(app.getStartDatetime());
			vo.setEndDatetime(app.getEndDatetime());
			vo.setDescription(Strings.toHTML(app.getDescription()));
			vo.setAppPerName(orgManager.getMemberById(app.getPerId()).getName());
			vo.setStatus(app.getStatus());
			vo.setAppId(app.getId());
			
			occupancyVos.add(vo);
		}
		return occupancyVos;
	}
	
	/**
	 * 获取会议室申请信息
	 * @param params
	 * 	<pre>
	 *        类型    名称             必填     备注
	 *        String   appId     Y     申请ID
	 *  </pre>
	 * @return
	 * @throws BusinessException
	 */
	@POST
	@Path("getMeetingRoomAppDetail")
	public Response getMeetingRoomAppDetail(Map<String, Object> params) throws BusinessException{
		Long appId = ParamUtil.getLong(params, "appId");
		MeetingRoomApp app = meetingRoomManager.getRoomAppById(appId);
		
		SimpleDateFormat sdf = new SimpleDateFormat(DateUtil.YMDHMS_PATTERN);
		
		MeetingRoom room = meetingRoomManager.getRoomById(app.getRoomId());
		V3xOrgMember member = orgManager.getMemberById(app.getPerId());
		V3xOrgDepartment department = orgManager.getDepartmentById(app.getDepartmentId());
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("startDatetime", sdf.format(app.getStartDatetime()));
		map.put("endDatetime", sdf.format(app.getEndDatetime()));
		map.put("roomName", room.getName());
		map.put("appPerName", member.getName());
		map.put("appDepartment", department.getName());
		map.put("description", Strings.toHTML(app.getDescription()));
		map.put("roomId", room.getId());
		map.put("perId", app.getPerId());

		return ok(map);
	}
	
	/**
	 * 新建会议初始化页面
	 * @return com.seeyon.ctp.common.authenticate.domain.User
	 * @throws BusinessException
	 */
	@POST
	@Path("create")
	public Response create() throws BusinessException{
		Map<String, Object> r_map = new HashMap<String, Object>();
		User user = AppContext.getCurrentUser();
		r_map.put("userId", String.valueOf(user.getId()));
		r_map.put("userName", user.getName());
		if(AppContext.hasPlugin("videoconference")) {
			MeetingVideoManager meetingVideoManager = meetingApplicationHandler.getMeetingVideoHandler();
			if(meetingVideoManager != null) {
				r_map.put("isShowMeetingNature", meetingVideoManager.isSupportCreateMobileMeeting());
			}
		}
		return ok(JSONUtil.toJSONString(r_map));
	}
	
	/**
	 * 会议发送
	 * @param params
	 * 	<pre>
	 *        类型    名称             必填     备注
	 *        String   title        Y     会议名称
	 *        String   beginDate    Y     开始时间 (yyyy-MM-dd hh:mm:ss)
	 *        String   endDate      Y     结束时间 (yyyy-MM-dd hh:mm:ss)
	 *        String   conferees    Y     与会人(Member|id1,Member|id2 ……)
	 *        String   emceeId      Y     主持人
	 *        String   recorderId   N     记录人
	 *        String   impart       N     告知人(Member|id1,Member|id2 ……)
	 *        String   beforeTime   Y     提前提醒(0：无；5：5分钟；10：10分钟；15：15分钟；
	 *        30：30分钟；60：1小时；120：2小时；180：3小时；240：4小时；480：8小时；720：0.5天；
	 *        1440：1天；2880：2天；4320：3天；10080：1周)
	 *        String   content      N     正文内容
	 *        String   selectRoomType Y   会议室选择类型(applied：已申请；apply：申请会议室；mtPlace：手动输入)
	 *        String   meetingPlace N     会议地点
	 *        String   isHasAtt     Y     是否存在附件("true"/"false")
	 *        Long     roomId       N     会议室ID
	 *        String   roomAppBeginDate N 会议室申请开始时间(yyyy-MM-dd hh:mm:ss)
	 *        String   roomAppEndDate   N 会议室申请结束时间(yyyy-MM-dd hh:mm:ss)
	 *        Long     roomAppId    N     会议室申请ID
	 *        String   type         Y     执行动作(send/save)
	 *        Long     meetingId    N     会议ID
	 *        String   meetingNature Y    会议方式（1：普通；2：视频）
	 *  </pre>
	 * @return Map<String, Object>
	 * @throws BusinessException
	 */
	@POST
	@Path("send")
	public Response send(Map<String, Object> params) throws BusinessException{
		Map<String, Object> r_map = new HashMap<String, Object>();
		
		String conferees = ParamUtil.getString(params, "conferees");
		String impart = ParamUtil.getString(params, "impart");
		
		conferees = removeRepeat(conferees);//去重
		impart = removeRepeat(impart);//去重
		
		Map<String, String> parameterMap = new HashMap<String, String>();
		parameterMap.put("title", ParamUtil.getString(params, "title"));
		parameterMap.put("beginDate", ParamUtil.getString(params, "beginDate"));
		parameterMap.put("endDate", ParamUtil.getString(params, "endDate"));
		parameterMap.put("conferees", conferees);
		parameterMap.put("emceeId", ParamUtil.getString(params, "emceeId"));
		parameterMap.put("recorderId", ParamUtil.getString(params, "recorderId"));
		parameterMap.put("impart", impart);
		parameterMap.put("beforeTime", ParamUtil.getString(params, "beforeTime"));
		parameterMap.put("content", ParamUtil.getString(params, "content"));
		parameterMap.put("selectRoomType", ParamUtil.getString(params, "selectRoomType"));
		parameterMap.put("meetingPlace", ParamUtil.getString(params, "meetingPlace"));
		parameterMap.put("bodyType", "HTML");
		parameterMap.put("isHasAtt", ParamUtil.getString(params, "isHasAtt"));
		parameterMap.put("meetingNature", ParamUtil.getString(params, "meetingNature"));
		parameterMap.put("projectId", "-1");
		parameterMap.put("meetingPassword", ParamUtil.getString(params, "password"));
		
		//roomapp对象需要的数据
		parameterMap.put("roomId", ParamUtil.getString(params, "roomId"));
		parameterMap.put("roomAppId", ParamUtil.getString(params, "roomAppId"));
		parameterMap.put("roomAppBeginDate", ParamUtil.getString(params, "roomAppBeginDate"));
		parameterMap.put("roomAppEndDate", ParamUtil.getString(params, "roomAppEndDate"));
		if(ParamUtil.getLong(params, "roomId") != null){
			MeetingRoom meetingRoom = meetingRoomManager.getRoomById(ParamUtil.getLong(params, "roomId"));
			parameterMap.put("roomNeedApp", String.valueOf(meetingRoom.getNeedApp()));
		}
		
		String type = ParamUtil.getString(params, "type");
		Long meetingId = ParamUtil.getLong(params, "meetingId", -1l);
		
		MeetingNewVO newVo = new MeetingNewVO();
		newVo.setAction(type);
		newVo.setMeetingId(meetingId);
		newVo.setRoomId(ParamUtil.getLong(params, "roomId", -1l));
		newVo.setRoomAppId(ParamUtil.getLong(params, "roomAppId", -1l));
		newVo.setCategory(MeetingCategoryEnum.single.key());
		newVo.setIsBatch(false);
		newVo.setSelectRoomType(ParamUtil.getString(params, "selectRoomType"));
		newVo.setCurrentUser(AppContext.getCurrentUser());
		if(meetingId == -1){
			newVo.setParameterMap(parameterMap);
		}else{
			MtMeeting meeting = meetingManager.getMeetingById(meetingId);
			if (null != meeting.getMeetingTypeId()) {
			    parameterMap.put("meetingTypeId", String.valueOf(meeting.getMeetingTypeId()));
			}
			parameterMap.put("bodyType", meeting.getDataFormat());//覆盖一次
			parameterMap.put("SendTextMessages", meeting.getIsSendMessage()?"1":"0");
			parameterMap.put("projectId", null!=meeting.getProjectId()?String.valueOf(meeting.getProjectId()):"-1");
			
			List<MeetingResources> meetingResources = meetingResourcesManager.getMeetingResourceListByMeetingId(meetingId);
			StringBuffer sb = new StringBuffer();
			for(MeetingResources meetingResource : meetingResources){
				sb.append(meetingResource.getResourceId() + ",");
			}
			parameterMap.put("resourcesId", Strings.isNotBlank(sb.toString())?sb.toString().substring(0, sb.toString().length()-1):"");
			
			parameterMap.put("mtTitle", meeting.getMtTitle());
			parameterMap.put("leader", meeting.getLeader());
			parameterMap.put("attender", meeting.getAttender());
			parameterMap.put("tel", meeting.getTel());
			parameterMap.put("notice", meeting.getNotice());
			parameterMap.put("plan", meeting.getPlan());
			
			newVo.setParameterMap(parameterMap);
		}
		newVo.setSystemNowDatetime(DateUtil.currentDate());
		newVo.setIsM3(true);
        AppContext.putThreadContext(GlobalNames.THREAD_CONTEXT_JSONSTR_KEY, ParamUtil.getString(params, "_json_params"));
        
        //重复提交校验
        Long submitKey = AppContext.getCurrentUser().getId();
        try {
			if(meetingLockManager.isLock(submitKey)){
				return null;
			}
			
			if("send".equals(type)){
				if(!meetingNewManager.transSend(newVo)){
					r_map.put("errorMsg", newVo.getErrorMsg());
				}
				//返回会议室申请状态
				if(newVo.getMeeting() != null){
					r_map.put("roomAppState", newVo.getMeeting().getRoomState());
				}
			}else if("save".equals(type)){
				if(!meetingNewManager.transSave(newVo)){
					r_map.put("errorMsg", newVo.getErrorMsg());
				}
			}
			r_map.put("type", type);
		} catch (Exception e) {
			r_map.put("errorMsg", e.getMessage());
		}finally {
			if(meetingLockManager.isLock(submitKey)){
				meetingLockManager.unLock(submitKey);
			}
		    removeThreadContext();
        }
		return ok(r_map);
	}
	
	/**
     * 会议室申请时间是否被占用
     * 注：此校验仅支持非周期会议，如果之后支持周期会议，需要增加传参以及修改调用方法
     * @param params
     *  <pre>
     *        类型    名称             必填     备注
     *        String   beginDate    Y     开始时间 (yyyy-MM-dd hh:mm:ss)
     *        String   endDate      Y     结束时间 (yyyy-MM-dd hh:mm:ss)
     *        Long     roomId       Y     会议室ID
     *        Long     meetingId    N     会议ID
     *  </pre>
     * @return Map<String, Object>
     * @throws BusinessException
     */
    @POST
    @Path("checkMeetingRoomConflict")
    public Response checkMeetingRoomConflict(Map<String, Object> params) throws BusinessException{
        Map<String, Object> r_map = new HashMap<String, Object>();
        
        Date beginDate = DateUtil.toDate(ParamUtil.getString(params, "beginDate"));
        Date endDate = DateUtil.toDate(ParamUtil.getString(params, "endDate"));
        Long roomId = ParamUtil.getLong(params, "roomId", -1l);
        Long meetingId = ParamUtil.getLong(params, "meetingId", -1l);
        
        if(MeetingUtil.isIdNull(roomId) || beginDate == null || endDate == null){
        	return ok(errorParams());
        }
        
        boolean isRepeat = false;
        try {
            isRepeat = meetingValidationManager.checkRoomUsed(roomId, beginDate, endDate, meetingId);
            if (!isRepeat) {
                r_map.put("errorMsg", ResourceUtil.getString("mr.alert.cannotapp"));
            }
            r_map.put(SUCCESS_KEY, "true");
        } catch (Exception e) {
            r_map.put("errorMsg", e.getMessage());
            LOGGER.error(e);
        }
        
        return ok(r_map);
    }
	
	/**
	 * 去除人员与部门之间重复数据
	 * @throws BusinessException 
	 * 
	 */
	private String removeRepeat(String input) throws BusinessException{
		if(Strings.isBlank(input)){
			return "";
		}
		String[] allData = input.split(",");
		
		List<V3xOrgMember> list_member = new ArrayList<V3xOrgMember>();
		String authType = "";
		Long authId;
		//获取所有人员信息
		for(String auth : allData){
			authType = auth.split("\\|")[0];
			authId = Long.valueOf(auth.split("\\|")[1]);
			if(V3xOrgEntity.ORGENT_TYPE_ACCOUNT.equals(authType)){
				List<V3xOrgMember> members = orgManager.getAllMembersByAccountId(authId, 1, true, true, null, null, null);
				list_member.addAll(members);
			}else if(V3xOrgEntity.ORGENT_TYPE_DEPARTMENT.equals(authType)){
				List<V3xOrgMember> members = orgManager.getAllMembersByDepartmentId(authId, true, 1, null, true, null, null, null);
				list_member.addAll(members);
			}/*  需要单独剔除人员类别
			else if(V3xOrgEntity.ORGENT_TYPE_MEMBER.equals(authType)){
				V3xOrgMember v3xOrgMember = orgManager.getMemberById(authId);
				list_member.add(v3xOrgMember);
			}*/
			else if(V3xOrgEntity.ORGENT_TYPE_TEAM.equals(authType)){
				List<V3xOrgMember> members = orgManager.getMembersByTeam(authId);
				list_member.addAll(members);
			}else if(V3xOrgEntity.ORGENT_TYPE_POST.equals(authType)){
				List<V3xOrgMember> members = orgManager.getMembersByPost(authId);
				list_member.addAll(members);
			}else if(V3xOrgEntity.ORGENT_TYPE_LEVEL.equals(authType)){
				List<V3xOrgMember> members = orgManager.getMembersByLevel(authId);
				list_member.addAll(members);
			}
		}
		//去重
		HashSet<V3xOrgMember> set = new HashSet<V3xOrgMember>(list_member);
		list_member.clear();
		list_member.addAll(set);

		//获取所有人员的ID
		List<Long> allMemberIds = new ArrayList<Long>();
		for(V3xOrgMember member : list_member){
			allMemberIds.add(member.getId());
		}
		
		StringBuffer output = new StringBuffer();
		for(String auth : allData){
			if(V3xOrgEntity.ORGENT_TYPE_MEMBER.equals(auth.split("\\|")[0])){
				Long memberId = Long.valueOf(auth.split("\\|")[1]);
				if(!allMemberIds.contains(memberId)){
					output.append(auth + ",");
				}
			}else{
				output.append(auth + ",");
			}
		}
		return output.toString().substring(0, output.toString().length()-1);
	}
	
	/**
	 * 获取会议修改所需元素
	 * @param params
	 * 	<pre>
	 *        类型    名称             必填     备注
	 *        String   meetingId     Y     会议ID
	 *  </pre>
	 * @return
	 * @throws BusinessException
	 */
	@POST
	@Path("getMeetingModifyElement")
	public Response getMeetingModifyElement(Map<String, Object> params) throws BusinessException{
		Long meetingId = ParamUtil.getLong(params, "meetingId");
		MtMeeting meeting = meetingManager.getMeetingById(meetingId);
		
		SimpleDateFormat sdf = new SimpleDateFormat(Datetimes.datetimeWithoutSecondStyle);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("meetingName", meeting.getTitle());
		map.put("startDate", Datetimes.format(meeting.getBeginDate(), Datetimes.datetimeWithoutSecondStyle));
		map.put("endDate", Datetimes.format(meeting.getEndDate(), Datetimes.datetimeWithoutSecondStyle));
		map.put("conferees", meeting.getConfereesNames());
		map.put("conferees_value", meeting.getConferees());
		map.put("host", meeting.getEmceeName());
		map.put("host_value", meeting.getEmceeId());
		map.put("recoder", meeting.getRecorderName());
		map.put("recoder_value", meeting.getRecorderId());
		map.put("notify", meeting.getImpartNames());
		map.put("notify_value", meeting.getImpart());
		map.put("reminder", meeting.getBeforeTime());
		map.put("content", meeting.getContent());
		map.put("data_format", meeting.getDataFormat());
		map.put("meetingNature_value", meeting.getMeetingType());
		map.put("meeting_password", meeting.getMeetingPassword());
		
		Long roomId = meeting.getRoom();
		if(roomId != null && roomId != -1){
			MeetingRoom room = meetingRoomManager.getRoomById(roomId);
			map.put("meetingPlace", room.getName());
			map.put("meetingPlace_value", room.getId());
			map.put("meetingPlace_type", "applied");
			
			MeetingRoomApp meetingRoomApp = meetingRoomManager.getRoomAppByMeetingId(meetingId);
			map.put("roomAppBeginDate", sdf.format(meetingRoomApp.getStartDatetime()));
			map.put("roomAppEndDate", sdf.format(meetingRoomApp.getEndDatetime()));
			map.put("meetingPlace_value1", meetingRoomApp.getId());
		}else{
			map.put("meetingPlace", meeting.getMeetPlace());
			map.put("meetingPlace_type", "mtPlace");
		}
		
		//缓存数据
		map.put("conferees_fill", this.analyze(meeting.getConferees()));
		map.put("notify_fill", this.analyze(meeting.getImpart()));
		if(Strings.isNotBlank(meeting.getEmceeName())){
			List<Map<String, String>> list = new ArrayList<Map<String, String>>();
			Map<String, String> map1 = new HashMap<String, String>();
			map1.put("id", String.valueOf(meeting.getEmceeId()));
			map1.put("name", meeting.getEmceeName());
			map1.put("type", V3xOrgEntity.ORGENT_TYPE_MEMBER);
			list.add(map1);
			map.put("host_fill", list);
		}
		if(Strings.isNotBlank(meeting.getRecorderName())){
			List<Map<String, String>> list = new ArrayList<Map<String, String>>();
			Map<String, String> map1 = new HashMap<String, String>();
			map1.put("id", String.valueOf(meeting.getRecorderId()));
			map1.put("name", meeting.getRecorderName());
			map1.put("type", V3xOrgEntity.ORGENT_TYPE_MEMBER);
			list.add(map1);
			map.put("recoder_fill", list);
		}
		
		//附件
        List<Attachment> attachments = attachmentManager.getByReference(meetingId, meetingId);
        map.put("attachments", attachments);
        
		if(AppContext.hasPlugin("videoconference")) {
			MeetingVideoManager meetingVideoManager = meetingApplicationHandler.getMeetingVideoHandler();
			if(meetingVideoManager != null) {
				map.put("isShowMeetingNature", meetingVideoManager.isSupportCreateMobileMeeting());
			}
		}
		return ok(map);
	}
	
	//解析人员，返回人员组建所需数据
	private List<Map<String, String>> analyze(String input){
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		if(Strings.isEmpty(input)){
			return list;
		}
		
		Map<String, String> map;
		
		String[] allData = input.split(",");
		String authType = "";
		Long authId;
		for(String auth : allData){
			map = new HashMap<String, String>();
			authType = auth.split("\\|")[0];
			authId = Long.valueOf(auth.split("\\|")[1]);
			map.put("id", auth.split("\\|")[1]);
			map.put("type", authType);
			if(V3xOrgEntity.ORGENT_TYPE_ACCOUNT.equals(authType)){
				map.put("name", Functions.showOrgAccountName(authId));
			}else if(V3xOrgEntity.ORGENT_TYPE_DEPARTMENT.equals(authType)){
				map.put("name", Functions.showDepartmentName(authId));
			}else if(V3xOrgEntity.ORGENT_TYPE_MEMBER.equals(authType)){
				map.put("name", Functions.showMemberName(authId));
			}else if(V3xOrgEntity.ORGENT_TYPE_TEAM.equals(authType)){
				map.put("name", Functions.getTeamName(authId));
			}else if(V3xOrgEntity.ORGENT_TYPE_POST.equals(authType)){
				map.put("name", Functions.showOrgPostName(authId));
			}else if(V3xOrgEntity.ORGENT_TYPE_LEVEL.equals(authType)){
				map.put("name", Functions.showOrgLeaveName(Functions.getLeave(authId)));
			}
			list.add(map);
		}
		return list;
	}
	
	/**
	 * 会议删除
	 * @param params
	 * 	<pre>
	 *        类型    名称             必填     备注
	 *        String   id        Y     会议ID
	 *        String   listType      Y     将要删除会议的来源 
	 *           <pre>
	 *           	listWaitSendMeeting   待发
	 *           	listDoneMeeting       已开
	 *           	listSendMeeting       已发
	 *           </pre>
	 *  </pre>
	 * @return Map<String, Object>
	 * @throws BusinessException
	 */
	@POST
	@Path("removeMeeting")
	public Response removeMeeting(Map<String, Object> params) throws BusinessException{
		Map<String, Object> r_map = new HashMap<String, Object>();
		
		String listType = ParamUtil.getString(params, "listType");
    	int type = MeetingListTypeEnum.getTypeName(listType);
    	
    	String idStr = ParamUtil.getString(params, "id");
        if(Strings.isNotBlank(idStr)) {
        	Map<String, Object> parameterMap = new HashMap<String, Object>(); 
        	List<Long> idList = MeetingUtil.getIdList(idStr);
        	parameterMap.put("idList", idList);
        	parameterMap.put("type", type);
        	parameterMap.put("currentUser", AppContext.getCurrentUser());
        	
        	meetingManager.transDeleteMeeting(parameterMap);
        	r_map.put(SUCCESS_KEY, ResourceUtil.getString("meeting.deal.delete.success"));
        }
		return ok(r_map);
	}

	
	/**
	 * 获取视频会议插件参数
	 * @param params
	 * 	<pre>
	 *        类型    名称             必填     备注
	 *        String   meetingId        Y     会议ID
	 *  </pre>
	 * @return Map<String, Object>
	 * @throws BusinessException
	 */
	@POST
	@Path("videoMeetingParams")
	public Response videoMeetingParams(Map<String, Object> params) throws BusinessException{
		Map<String, Object> r_map = new HashMap<String, Object>();

		Long meetingId = ParamUtil.getLong(params, "meetingId");
		
		if(MeetingUtil.isIdNull(meetingId)){
			return ok(errorParams());
		}
		
		if(AppContext.hasPlugin("videoconference")) {
			MtMeeting meeting = meetingManager.getMeetingById(meetingId);
			List<Long> list = CommonTools.getMemberIdsByTypeAndId(meeting.getConferees(), orgManager);
			long userId = AppContext.currentUserId();
			
			if(MeetingNatureEnum.video.key().equals(meeting.getMeetingType()) && (list.contains(userId) || meeting.getEmceeId() == userId || meeting.getRecorderId() == userId)){
				MeetingVideoManager meetingVideoManager = meetingApplicationHandler.getMeetingVideoHandler();
				if(meetingVideoManager != null) {
					String v_methodName = meetingVideoManager.getJoinButtonClkFunNameM3();
					
					Map<String, Object> v_params = new HashMap<String, Object>();
					
					String ext4 = meeting.getVideoMeetingId();
					Map<String, Object> ext4Map = JSONUtil.parseJSONString(ext4, Map.class);
					v_params.put("userName", AppContext.currentUserName());
					v_params.put("userId", userId);
					if(meeting.getEmceeId().equals(userId)){
						v_params.put("pCode", ext4Map.get("pcode1"));
						v_params.put("v_isEmcee", true);
					}else{
						v_params.put("pCode", ext4Map.get("pcode2"));
						v_params.put("v_isEmcee", false);
					}
					v_params.put("conferenceId", ext4Map.get("conferenceId"));
					
					r_map.put("v_methodName", v_methodName);
					r_map.put("v_params", meetingVideoManager.getJoinButtonClkFunParmasM3(v_params));
				}
			}
		}
		return ok(r_map);
	}
	
	/**
     * 清理缓存数据
     * 
     *
     * @Since A8-V5 6.1
     * @Author      : xuqw
     * @Date        : 2017年4月5日下午4:05:17
     *
     */
    private void removeThreadContext(){
        AppContext.removeThreadContext(GlobalNames.THREAD_CONTEXT_JSONSTR_KEY);
        AppContext.removeThreadContext(GlobalNames.THREAD_CONTEXT_JSONOBJ_KEY);
    }
    
	@GET
	@Produces({ MediaType.APPLICATION_JSON })
	@Path("detail/sendMessage")
	public Response sendRemindersMeetingReceiptMessage(@QueryParam("meetingId") String meetingId,
			@QueryParam("senderId") String senderId, @QueryParam("receiverIds") String receiverIds)
			throws BusinessException {
		Map<String, Object> messageMap = new HashMap<String, Object>();
		messageMap.put("senderId", Long.parseLong(senderId));
		String[] receiverIdsArr = receiverIds.substring(0,receiverIds.length()-1).split(",");
		List<Long> receiverIdsList = new ArrayList<Long>();
		for (String receiverId : receiverIdsArr) {
			receiverIdsList.add(Long.parseLong(receiverId));
		}
		messageMap.put("receiverIds", receiverIdsList);
		messageMap.put("meetingId", Long.parseLong(meetingId));
		messageMap.put("mtmeeting", mtMeetingManager.getMtMeetingById(Long.parseLong(meetingId), null));
		messageMap.put("sendTerminal","M3");
		messageMap.put("user", AppContext.getCurrentUser());
		
		Map<String,String> retMap = new HashMap<String, String>();
		try {
			meetingManager.sendMeetingReceiptMessage(messageMap);
			retMap.put("success", ResourceUtil.getString("meeting.deal.urge.success"));
		} catch (BusinessException e) {
			LOGGER.error("",e);
			retMap.put("failer", ResourceUtil.getString("meeting.deal.urge.failed"));
		}
		return ok(retMap);
	}
	
}
