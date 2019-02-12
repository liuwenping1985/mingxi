package com.seeyon.apps.meeting.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.meeting.constants.MeetingConstant.DateFormatEnum;
import com.seeyon.apps.meeting.constants.MeetingPathConstant;
import com.seeyon.apps.meeting.manager.MeetingTypeManager;
import com.seeyon.apps.meeting.po.MeetingType;
import com.seeyon.apps.meeting.util.MeetingUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.constants.Constants;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;

public class MeetingTypeController extends BaseController {

	private static final Log LOGGER = LogFactory.getLog(MeetingTypeController.class);
	
	private MeetingTypeManager meetingTypeManager;
	
	
	@CheckRoleAccess(roleTypes= {Role_NAME.AccountAdministrator})
    public ModelAndView list(HttpServletRequest request, HttpServletResponse response) throws Exception {
	     ModelAndView mav = new ModelAndView(MeetingPathConstant.meeting_list_type_frame);
	     
	     HashMap<String, Object> conditionMap = new HashMap<String, Object>();
	     conditionMap.put("condition", request.getParameter("condition"));
	     conditionMap.put("textfield", request.getParameter("textfield"));
	     conditionMap.put("accountId", AppContext.currentAccountId());
	     List<MeetingType> typeList = this.meetingTypeManager.findMeetingTypeList(conditionMap);
	     mav.addObject("meetingType", typeList);
	     
	     //新建单位可能存在问题，导致未预制到分类数据，此处做兼容
	     List<Integer> defaultType = new ArrayList<Integer>();
	     defaultType.add(1);//普通会议
	     defaultType.add(2);//重要会议
	     defaultType.add(3);//表单触发会议
	     for(MeetingType type : typeList){
	    	 if(defaultType.contains(type.getSortId())){
	    		 defaultType.remove((Object)type.getSortId());
	    	 }
	     }
	     if(defaultType.size() == 0){
	    	 return mav;
	     }
	     Object[][] defaultInfo = new Object[3][2];
	     defaultInfo[0][0] = ResourceUtil.getString("meeting.mtMeeting.label.ordinary");
	     defaultInfo[0][1] = "";
	     defaultInfo[1][0] = ResourceUtil.getString("meeting.type.important");
	     defaultInfo[1][1] = "1,2,3,4,5,6";
	     defaultInfo[2][0] = ResourceUtil.getString("meeting.type.form");
	     defaultInfo[2][1] = "1,2,3,4,5,6";
	     for(Integer sortId : defaultType){
	    	 Map<String, Object> parameterMap = new HashMap<String, Object>();
	         parameterMap.put("id", Constants.GLOBAL_NULL_ID);
	         parameterMap.put("name", defaultInfo[sortId-1][0]);
	         parameterMap.put("state", "1");
	         parameterMap.put("sortId", sortId);
	         parameterMap.put("content", defaultInfo[sortId-1][1]);
	         parameterMap.put("userId", AppContext.currentUserId());
	         parameterMap.put("accountId", AppContext.currentAccountId());
	         parameterMap.put("systemNowDatetime", DateUtil.currentDateString(DateFormatEnum.yyyyMMddHHmmss.key()));
	         try {
	         	this.meetingTypeManager.transAdd(parameterMap);
	         } catch(Exception e) {
	         	LOGGER.error("保存会议类型出错", e);
	         }
	     }
	     
	     typeList = this.meetingTypeManager.findMeetingTypeList(conditionMap);
	     mav.addObject("meetingType", typeList);
	     return mav;
    }
	
	@CheckRoleAccess(roleTypes= {Role_NAME.AccountAdministrator})
    public ModelAndView createAdd(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView(MeetingPathConstant.meeting_type_create_frame);
		String id = request.getParameter("id");
		String readOnly = request.getParameter("readOnly");
		if(id != null && id.length()>0){
			try{
				MeetingType meetingType = this.meetingTypeManager.getMeetingTypeById(Long.parseLong(id));
				mav.addObject("bean", meetingType);
          }catch(Exception e){
            LOGGER.error("", e);
          }
      }
      if(readOnly != null && readOnly.length() > 0){
    	  mav.addObject("readOnly", "true");
      }
      return mav;
    }
	
	@CheckRoleAccess(roleTypes = Role_NAME.AccountAdministrator)
    public ModelAndView execAdd(HttpServletRequest request, HttpServletResponse response) throws Exception {
        StringBuilder content = new StringBuilder();
        String[] content1 = request.getParameterValues("content");
        if(content1 != null && content1.length > 0){
            for(int i=0; i<content1.length; i++){
                content.append(content1[i]).append(",");
            }
        }
        
        Map<String, Object> parameterMap = new HashMap<String, Object>();
        parameterMap.put("id", request.getParameter("id"));
        parameterMap.put("name", request.getParameter("name"));
        parameterMap.put("state", request.getParameter("state"));
        parameterMap.put("sortId", 100);
        parameterMap.put("content", content.toString());
        parameterMap.put("userId", AppContext.currentUserId());
        parameterMap.put("accountId", AppContext.currentAccountId());
        parameterMap.put("systemNowDatetime", DateUtil.currentDateString(DateFormatEnum.yyyyMMddHHmmss.key()));
        
        try {
        	this.meetingTypeManager.transAdd(parameterMap);
        } catch(Exception e) {
        	LOGGER.error("保存会议类型出错", e);
        	parameterMap.put("msgType", "failure");
        	parameterMap.put("msg", e.getMessage());
        }
        
        StringBuffer buffer = new StringBuffer();
        buffer.append("parent._submitCallback('"+parameterMap.get("msgType")+"', '"+parameterMap.get("msg")+"')");
        rendJavaScript(response, buffer.toString());
        
        return null;
    }
	
    @CheckRoleAccess(roleTypes= {Role_NAME.AccountAdministrator})
    public ModelAndView execDel(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String[] ids = request.getParameterValues("id");
        
        Map<String, Object> parameterMap = new HashMap<String, Object>();
        List<Long> idList = MeetingUtil.getIdList(ids);
        parameterMap.put("idList", idList);
        
        try {
        	this.meetingTypeManager.transDel(parameterMap);
        } catch(Exception e) {
        	LOGGER.error("删除会议类型出错", e);
        	parameterMap.put("msgType", "failure");
        	parameterMap.put("msg", e.getMessage());
        }
        
        StringBuffer buffer = new StringBuffer();
        buffer.append("parent._submitCallback('"+parameterMap.get("msgType")+"', '"+parameterMap.get("msg")+"')");
        rendJavaScript(response, buffer.toString());
        
        return null;
    }
	
	/****************************** 依赖注入 **********************************/
	public void setMeetingTypeManager(MeetingTypeManager meetingTypeManager) {
		this.meetingTypeManager = meetingTypeManager;
	}
	
}
