package com.seeyon.apps.taskcenter.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSONObject;
import com.seeyon.apps.cinda.authority.manager.CindaAuthorityManager;
import com.seeyon.apps.taskcenter.Manager.TaskCenterOAManager;
import com.seeyon.apps.taskcenter.bo.TaskCenterResource;
import com.seeyon.apps.taskcenter.constant.TaskCenterConstant;
import com.seeyon.apps.taskcenter.dao.TaskCenterOADao;
import com.seeyon.apps.taskcenter.po.ProSystemConfigLink;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgPost;
import com.seeyon.ctp.util.ReqUtil;
import com.seeyon.ctp.util.TextEncoder;

import www.seeyon.com.utils.FileUtil;

public class ProSenderUrlController extends BaseController{

	private static final Log log = LogFactory.getLog(ProSenderUrlController.class); 
	
	private TaskCenterOAManager taskCenterOAManager;
	private CindaAuthorityManager cindaAuthorityManager;
	private TaskCenterOADao taskCenterOADao;
	
	

	public void setTaskCenterOADao(TaskCenterOADao taskCenterOADao) {
		this.taskCenterOADao = taskCenterOADao;
	}
	public void setCindaAuthorityManager(CindaAuthorityManager cindaAuthorityManager) {
		this.cindaAuthorityManager = cindaAuthorityManager;
	}
	public TaskCenterOAManager getTaskCenterOAManager() {
		return taskCenterOAManager;
	}
	public void setTaskCenterOAManager(TaskCenterOAManager taskCenterOAManager) {
		this.taskCenterOAManager = taskCenterOAManager;
	}
	public ModelAndView initlinks(HttpServletRequest request, HttpServletResponse response) throws Exception{
		try {
//			String configPath = SystemEnvironment.getApplicationFolder()+"/WEB-INF/classes/cindalinks.json";
			String configPath = SystemEnvironment.getApplicationFolder()+"/WEB-INF/classes/ProSystemConfigLink.json";
			String jsonString = FileUtil.readTextFile(configPath,"utf-8");
//			ExportLinks links = JSONObject.parseObject(jsonString,ExportLinks.class);
			List<ProSystemConfigLink> links = JSONObject.parseArray(jsonString, ProSystemConfigLink.class);
			this.taskCenterOADao.saveOrUpdateAll(links);
//			this.taskCenterOAManager.inportLinks(links.getLinkList());
			super.rendJavaScript(response, "alert('加载配置完成！')");
		} catch (Exception e) {
			log.error("加载配置文件错误："+e);
			try {
				super.rendJavaScript(response, "alert('加载失败！')");
			} catch (IOException e1) {
				log.error("",e1);
			}
		}
		return null;
	}
	public ModelAndView exportlinks(HttpServletRequest request, HttpServletResponse response) throws Exception{
//		List<ProSenderUrl> list = taskCenterOAManager.getAllLinksIndb();
		List<ProSystemConfigLink> systemlinks = this.taskCenterOADao.findAll(ProSystemConfigLink.class);
//		ExportLinks links = new ExportLinks();
//		links.setLinkList(list);
//		String filename = "cindalinks.json";
		String filename = "ProSystemConfigLink.json";
//		filename=new String(filename.getBytes("gbk"),"iso-8859-1");
		response.setHeader("Content-Disposition",
		      "attachment; filename=\""+filename+"\"");
		response.setCharacterEncoding("UTF-8");
		response.setHeader("Content-Type","application/octet-stream");

		response.setContentType("application/json;charset=UTF-8");
		try {
			PrintWriter out = response.getWriter();
			out.append(JSONObject.toJSONString(systemlinks));
			out.flush();
			out.close();
		} catch (Exception e) {
			log.error("",e);
		}
		return null;
	}
	private void counttitle(List<TaskCenterResource> listRes,String linktype){
		if(listRes!=null){
			for (TaskCenterResource taskroot : listRes) {
				if (taskroot == null){
					continue;
				}
				StringBuffer title = new StringBuffer();
				int chs = 0;
				for (TaskCenterResource ch : taskroot.getChilds()) {
					chs+=ch.getChilds().size();
				}
				if("systemSettingsSection".equals(linktype)){
					//总共有X个大项，共X个配置
					title.append("总共有"+taskroot.getChilds().size()+"个大项，共"+chs+"个配置");
				}else{
					
					title.append("总共有"+taskroot.getChilds().size()+"个规程，共"+chs+"个模块");
				}
				taskroot.setName(title.toString());
			}
		}
		
	}
	public ModelAndView moreTemplate(HttpServletRequest request, HttpServletResponse response) throws Exception
  {
	     ModelAndView modelAndView = new ModelAndView("plugin/oadev/common/template/moreTreeTemplate");
	     String templateType = ReqUtil.getString(request, "templatetype");
	     String A1 = ReqUtil.getString(request, "A1");
	     String B1 = ReqUtil.getString(request, "C1");
	     /*返回所有REQUEST参数
	      //
	     Enumeration<?> names2 = request.getParameterNames();  
	        while(names2.hasMoreElements()){  
	            System.out.println(names2.nextElement());  
	        } 
	        */
	     if (templateType!=null && templateType.equals("1")){
	    	 modelAndView = new ModelAndView("plugin/oadev/common/template/moreTemplate");
	     }

         User user = AppContext.getCurrentUser();
		String rootCode = ReqUtil.getString(request, "sId");
		List<TaskCenterResource> listRes = null;
		if("systemSettingsSection".equalsIgnoreCase(rootCode)){
			listRes = taskCenterOAManager.getTaskCenterResource(user);
			counttitle(listRes,"systemSettingsSection");
		}else{
			listRes = cindaAuthorityManager.getTaskCenterResource(user, rootCode);
			counttitle(listRes,"");
		}
		 String columnsName = ReqUtil.getString(request, "columnsName");
		 Long orgAccountId = user.getLoginAccount();
		
		 // collTempleteCategory 是一个数组， 数组中的每个元素是一个模板的数组
		 modelAndView.addObject("collTempleteCategory", listRes);  
		 modelAndView.addObject("portolurl", TaskCenterConstant.portolurl);
		 modelAndView.addObject("ownerLogin", user.getLoginName()); 
		 //modelAndView.addObject("hkdepartId", taskCenterOAManager.getjtUserDeptId(user.getLoginName()));
		 modelAndView.addObject("hkdepartId", taskCenterOAManager.getOrganizationByLoginName(user.getLoginName()));
		 modelAndView.addObject("columnsName", columnsName);
		 modelAndView.addObject("orgAccountId", orgAccountId.toString());
		 modelAndView.addObject("sId", rootCode);
		return modelAndView;
	}
	public ModelAndView listpost(HttpServletRequest request, HttpServletResponse response) throws Exception
	  {
		
		ModelAndView modelAndView = new ModelAndView("plugin/linkauthity/listPost");
		modelAndView.addObject("roleType", V3xOrgPost.class.getSimpleName());
		return modelAndView;
	  }
	public ModelAndView listmember(HttpServletRequest request, HttpServletResponse response) throws Exception
	  {
		
		ModelAndView modelAndView = new ModelAndView("plugin/linkauthity/listmember");
		modelAndView.addObject("roleType", V3xOrgMember.class.getSimpleName());

		return modelAndView;
	  }
	public ModelAndView listdept(HttpServletRequest request, HttpServletResponse response) throws Exception
	  {
		
		ModelAndView modelAndView = new ModelAndView("plugin/linkauthity/listdept");
		modelAndView.addObject("roleType", V3xOrgDepartment.class.getSimpleName());
		
		return modelAndView;
	  }
	public ModelAndView linksTree(HttpServletRequest request, HttpServletResponse response) throws Exception
	  {
		String roleId = ReqUtil.getString(request, "roleId");
		String roleType = ReqUtil.getString(request, "roleType");
		ModelAndView mv = new ModelAndView("plugin/linkauthity/linksTree");
		mv.addObject("roleId", roleId);
		mv.addObject("roleType", roleType);
		
		return mv;
	  }

	  public static void main(String[] args) {
			try {
//				String configPath = SystemEnvironment.getApplicationFolder()+"/WEB-INF/classes/cindalinks.json";
				String configPath = SystemEnvironment.getApplicationFolder()+"/WEB-INF/classes/ProSystemConfigLink.json";
				String jsonString = FileUtil.readTextFile("/Users/mac/Downloads/ProSystemConfigLink.json","utf-8");
//				ExportLinks links = JSONObject.parseObject(jsonString,ExportLinks.class);
//				List<ProSystemConfigLink> links = JSONObject.parseArray(jsonString, ProSystemConfigLink.class);
//				for (ProSystemConfigLink link : links) {
//					System.out.println(JSONObject.toJSONString(link));
//				}
				System.out.println(TextEncoder.decode("/1.0/dzd5dnRmcw=="));
//				this.taskCenterOADao.saveOrUpdateAll(links);
//				this.taskCenterOAManager.inportLinks(links.getLinkList());
//				super.rendJavaScript(response, "alert('加载配置完成！')");
			} catch (Exception e) {
				log.error("加载配置文件错误："+e);
			}
	}   
}
