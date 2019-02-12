package com.seeyon.apps.taskcenter.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jivesoftware.util.ParamUtils;
import org.springframework.web.servlet.ModelAndView;

import cn.com.cinda.taskcenter.dao.QueryTaskDetail;
import cn.com.cinda.taskcenter.model.Task;
import cn.com.cinda.taskcenter.util.TaskUtil;

import com.seeyon.apps.taskcenter.Manager.TaskCenterManager;
import com.seeyon.apps.taskcenter.po.TaskGroups;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.Strings;

public class TaskCenterController extends BaseController{
	private static final Log log = LogFactory.getLog(TaskCenterController.class);
	private TaskCenterManager taskCenterManager;
	
	public void setTaskCenterManager(TaskCenterManager taskCenterManager) {
		this.taskCenterManager = taskCenterManager;
	}
	public ModelAndView test(HttpServletRequest request, HttpServletResponse response)throws Exception{
		Thread th = new Thread(new Runnable() {
			
			@Override
			public void run() {
				while(true){
					Thread ht1 = new Thread(new Runnable() {
						
						@Override
						public void run() {
							// TODO Auto-generated method stub
							List<Map<String,String>> list = taskCenterManager.count("jsbfkq");
							log.warn(Thread.currentThread().getId()+"-----"+Thread.currentThread().getId());
							
						}
					});
					ht1.start();
					try {
						Thread.sleep(100L);
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
		}, "test");
		th.start();
		super.rendJavaScript(response, "alert('测试线程任务已经启动完成')");
		return null;
	}
	public ModelAndView desc(HttpServletRequest request, HttpServletResponse response)throws Exception{
		ModelAndView mv = new ModelAndView("plugin/taskcenter/desc");
		String total = ParamUtils.getParameter(request, "total");
		mv.addObject("total", total);
		List<TaskGroups> list = taskCenterManager.getAllTaskGroups();
		String taskgroup = ParamUtils.getParameter(request, "taskgroup");
		if("mydone".equals(taskgroup)){
			mv.addObject("typeName", "已办");
		}else{
			mv.addObject("typeName", "待办");
		}
		if(Strings.isNotBlank(taskgroup)){
			for (TaskGroups gr : list) {
				if(gr.getGroupCode().equals(taskgroup)){
					mv.addObject("taskgroup", gr.getName());
				}
			}
		}
		return mv;
	}
	public ModelAndView donelist(HttpServletRequest request, HttpServletResponse response)throws Exception{
		ModelAndView mv = new ModelAndView("plugin/taskcenter/donelist/tasklist");
		String taskgroup = ParamUtils.getParameter(request, "taskgroup");
		mv.addObject("taskgroup", taskgroup);
		return mv;
	}
	public ModelAndView todoList(HttpServletRequest request, HttpServletResponse response)
		    throws Exception{
		String taskgroup = ParamUtils.getParameter(request, "taskgroup");
		ModelAndView mv = new ModelAndView("plugin/taskcenter/todolist/tasklist");
		mv.addObject("taskgroup", taskgroup);
		return mv;
		
	}	
	public ModelAndView initgroup(HttpServletRequest request, HttpServletResponse response)
		    throws Exception{
				this.taskCenterManager.init();
				super.rendJavaScript(response, "alert('初始化完成')");
				return null;
		
	}

}
