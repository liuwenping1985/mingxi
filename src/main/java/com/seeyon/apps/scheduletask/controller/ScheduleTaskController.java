package com.seeyon.apps.scheduletask.controller;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.scheduletask.ScheduleTaskJob;
import com.seeyon.apps.scheduletask.constant.STConstants;
import com.seeyon.apps.scheduletask.constant.STConstants.OrgTriggerDate;
import com.seeyon.apps.scheduletask.constant.STConstants.Timer_Type;
import com.seeyon.apps.scheduletask.manager.ScheduleTaskManager;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.Strings;

public class ScheduleTaskController extends BaseController{
	private static final Log log = LogFactory.getLog(ScheduleTaskController.class);
	private volatile boolean isGroup = false;
    private ScheduleTaskManager scheduleTaskManager;
    private OrgManager orgManager;
    
	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}
	public void setScheduleTaskManager(ScheduleTaskManager scheduleTaskManager) {
		this.scheduleTaskManager = scheduleTaskManager;
	}
	public boolean isGroup() {
		isGroup = AppContext.getCurrentUser().isGroupAdmin();
		return isGroup;
	}
	public ModelAndView configTask(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("plugin/oadev/systemConfig/configTask");
        String synchType = request.getParameter("synchType");
        String beanName = request.getParameter("taskName");
        ScheduleTaskJob task = scheduleTaskManager.getScheduleTask(beanName);
        mav.addObject("beanName", beanName);
        mav.addObject("synchType", synchType);
        mav.addObject("runing", task.isRuning());
        mav.addObject("type", task.getConfig().getTriggerDate().getKey());
        mav.addObject("hour", task.getConfig().getTriggerHour());
        mav.addObject("min", task.getConfig().getTriggerMinute());
        mav.addObject("isStart", task.getConfig().isCanExcute());
        int hours = task.getConfig().getIntervalHour();
        mav.addObject("intervalDay", hours/24);
        mav.addObject("intervalHour", hours%24);
        mav.addObject("intervalMin", task.getConfig().getIntervalMin());
        mav.addObject("timerType", task.getConfig().getTimerType());
        if(task.getConfig().getAccountId()!=null && task.getConfig().getAccountId()!=-1L){
        	V3xOrgAccount account = orgManager.getAccountById(task.getConfig().getAccountId());
        	mav.addObject("account",account);
        	
        }else{
        	V3xOrgAccount account = orgManager.getAccountById(AppContext.currentAccountId());
        	mav.addObject("account",account);
        	task.getConfig().setAccountId(AppContext.currentAccountId());
        }
		return mav;
	}
    /**
     * 同步操作处理/oadev/scheduleTask.do?method=configTask&taskName=
     */
	public ModelAndView timerOperation(HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        String synchType = request.getParameter("synchType");
        String beanName = request.getParameter("taskName");
        ModelAndView mav = super.redirectModelAndView("/oadev/scheduleTask.do?method=configTask&taskName="+beanName+"&synchType="+synchType);
        ScheduleTaskJob task = this.scheduleTaskManager.getScheduleTask(beanName);
        //手动
        if("hand".equals(synchType)){
            String orgIdStr = request.getParameter("orgId");
            String startTime = request.getParameter("startTime");
            Long orgId = AppContext.currentAccountId();
            if(Strings.isNotBlank(orgIdStr)){
            	orgId = Long.parseLong(orgIdStr);
            }
            if(Strings.isNotBlank(startTime)){
            	task.getConfig().setStartTime(startTime);
            }else{
            	task.getConfig().setStartTime(STConstants.DEFAULTTIME);
            }
            if(task!=null && !orgId.equals(task.getConfig().getAccountId())){
            	task.getConfig().setAccountId(orgId);
            }
//          这里开始工作，完成后，修改同步时间run
            task.setTaskTimestamp(Datetimes.format(new Date(System.currentTimeMillis()), "yyyy-MM-dd HH:mm:ss"));
            task.setRuning(true);
            task.execute(null);
            task.setRuning(false);
        }
        //自动
        else if("auto".equals(synchType)){
            String timeType = request.getParameter("timerType"); 
            boolean isStart = "1".equals(request.getParameter("isStart"));
            //设定时间
            if(Timer_Type.setTime.name().equals(timeType)){
                int type = Integer.valueOf(request.getParameter("type"));
                int hour = Integer.valueOf(request.getParameter("hour"));
                int min = Integer.valueOf(request.getParameter("min"));
            	task.getConfig().setTimerType(Timer_Type.setTime.ordinal());
            	task.setTriggerDate(OrgTriggerDate.values()[type]);
            	task.setTriggerTime(hour, min);
            	//间隔时间
            }else if(Timer_Type.intervalTime.name().equals(timeType)){
                int intervalDay = Integer.parseInt(request.getParameter("intervalDay"));
                int intervalHour = Integer.parseInt(request.getParameter("intervalHour"));
                int intervalMin = Integer.parseInt(request.getParameter("intervalMin"));
                //间隔时间同步
                task.getConfig().setTimerType(Timer_Type.intervalTime.ordinal());
                task.setIntervalTime((intervalDay*24 + intervalHour), intervalMin);
            }
            task.getConfig().setCanExcute(isStart);
            this.scheduleTaskManager.saveOrUpdataConfig(task);
        }
        mav.addObject("isStart", task.getConfig().isCanExcute());
        mav.addObject("type", task.getConfig().getTriggerDate().getKey());
        mav.addObject("hour", task.getConfig().getTriggerHour());
        mav.addObject("min", task.getConfig().getTriggerMinute());
        int hours = task.getConfig().getIntervalHour();
        mav.addObject("intervalDay", hours/24);
        mav.addObject("intervalHour", hours%24);
        mav.addObject("intervalMin", task.getConfig().getIntervalMin());
        mav.addObject("timerType", task.getConfig().getTimerType());
        return mav;
    }
}
