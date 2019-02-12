package com.seeyon.apps.taskcenter.Manager;

import java.rmi.RemoteException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.xml.namespace.QName;
import javax.xml.rpc.ParameterMode;
import javax.xml.rpc.encoding.XMLType;

import org.apache.axis.client.Call;
import org.apache.axis.client.Service;
import org.apache.axis2.AxisFault;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.core.env.SystemEnvironmentPropertySource;

import cn.com.cinda.taskcenter.common.CommonPara;
import cn.com.cinda.taskcenter.common.OutAndInSysTaskHelp;
import cn.com.cinda.taskcenter.common.TaskInfor;
import cn.com.cinda.taskcenter.common.UrlHelp;
import cn.com.cinda.taskcenter.dao.NewQueryDoneList;
import cn.com.cinda.taskcenter.dao.QueryDoneList;
import cn.com.cinda.taskcenter.dao.QueryTaskDetail;
import cn.com.cinda.taskcenter.dao.QueryTodoList;
import cn.com.cinda.taskcenter.dao.QueryTodolistNew;
import cn.com.cinda.taskcenter.model.Task;
import cn.com.cinda.taskcenter.util.ObjectSort;
import cn.com.cinda.taskcenter.util.StringUtils;
import cn.com.cinda.taskcenter.util.TaskUtil;
import cn.com.cinda.taskclient.service.impl.TaskServiceImpl;
import cn.com.cinda.taskclient.service.impl.UserServiceImpl;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.seeyon.apps.taskcenter.bo.CenterTaskBO;
import com.seeyon.apps.taskcenter.bo.TaskCenterResource;
import com.seeyon.apps.taskcenter.constant.TaskCenterConstant;
import com.seeyon.apps.taskcenter.dao.TaskCenterDao;
import com.seeyon.apps.taskcenter.dao.TaskCenterOADao;
import com.seeyon.apps.taskcenter.po.ProSenderUrl;
import com.seeyon.apps.taskcenter.po.TaskGroups;
import com.seeyon.apps.taskcenter.task.domain.CopyTodolist;
import com.seeyon.apps.taskcenter.task.domain.TaskTodolist;
import com.seeyon.apps.taskcenter.util.DoneListSortUtils;
import com.seeyon.apps.taskcenter.util.TaskCenterUtil;
import com.seeyon.apps.taskcenter.webclient.WorkToDoWebServiceServiceStub;
import com.seeyon.apps.taskcenter.webclient.WorkToDoWebServiceServiceStub.GetUserWorkTodoNum;
import com.seeyon.apps.taskcenter.webclient.WorkToDoWebServiceServiceStub.GetUserWorkTodoNumE;
import com.seeyon.apps.taskcenter.webclient.WorkToDoWebServiceServiceStub.GetUserWorkTodoNumResponseE;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.AjaxAccess;

public class TaskCenterManagerImpl implements TaskCenterManager{

	private static final Log log = LogFactory.getLog(TaskCenterManagerImpl.class);
	private TaskCenterOADao taskCenterOADao;
	private TaskCenterDao taskCenterDao;
	private static String  portolurl = TaskCenterConstant.portolurl;
	
	public void setTaskCenterDao(TaskCenterDao taskCenterDao) {
		this.taskCenterDao = taskCenterDao;
	}
	public void setTaskCenterOADao(TaskCenterOADao taskCenterOADao) {
		this.taskCenterOADao = taskCenterOADao;
	}
	private TaskGroups findbyCodeAndApp(String code,String app){
		TaskGroups group =null;
		Map<String,Object> param = new HashMap<String, Object>();
		param.put("code", code);
		param.put("app", app);
		String hql = " from "+TaskGroups.class.getSimpleName() + " g where g.groupCode=:code and g.app=:app";
		List<TaskGroups> list = DBAgent.find(hql, param);
		if(list!=null&&list.size()>0){
			return list.get(0);
		}else{
			return new TaskGroups();
		}
		
	}
	private void initgroupApps(String[] apps,String[] outapps ,String grupName ,String groupcode){
		for (String app : apps) {
			TaskGroups gr = this.findbyCodeAndApp(groupcode, app);
			gr.setApp(app);
			gr.setGroupCode(groupcode);
			gr.setName(grupName);
			
			a :for (String out : outapps) {
				if(out.equalsIgnoreCase(app)){
					gr.setOutSys(true);
					 break a;
				}
			}
			this.taskCenterOADao.saveOrUpdate(gr);
		}
	}
	@Override
	public void init(){
		
		try {
			//		[GROUP_OUTAPP2]
					String group= "APP_SYS_GUMS,APP_SYS_OA";
					//业务类
					String group1 = "MBLC,TZD,XQGL,LCPT,CZLC,ISO,YHGL,RLZY,GJSJ,JZDC_GZSCB,ZJCW_JZDC,JZDC_GZSCB_FWDY,ZJCW_JZDC_FWDY,STYW,SJJKCY,CZLCCY,SJJK,YWCW,LAWISO,JZ2NEW,CZLCGD,PMLC,ISO2012,APP_SYS_IRS";
					String [] outs = group.split(",");
					String[] groupapps = group1.split(",");
					this.initgroupApps(groupapps, outs, "业务类", "group1");
					//行政事务
					String group2="OALC,MEETING,APP_SYS_GUMS,APP_SYS_OA";
					groupapps = group2.split(",");
					this.initgroupApps(groupapps, outs, "行政事务", "group2");
					//group3=财务类
					String group3="ZJCW,ZJCW_JZ";	
					groupapps = group3.split(",");
					this.initgroupApps(groupapps, outs, "财务类", "group3");
					//group4=审计类
					String group4="SJJK_LINK_FK,SJJK_LINK_YJ";
					groupapps = group4.split(",");
					this.initgroupApps(groupapps, outs, "审计类", "group4");
		} catch (Exception e) {
			log.error("初始task组信息失败",e);
		}

	}

	/**
	 * in check.jsp reEdit，检查当前待办任务是否仍处于可处理状态
	 * @param taskId
	 * @return
	 */
	@AjaxAccess
	@Override
	public String taskCheak(String taskId ){
		String result = "-1";
		QueryTaskDetail query=new QueryTaskDetail();
		Task task=query.getTaskById(taskId.trim());
		log.info("//////////////////////任务状态："+JSONObject.toJSONString(task));
		User user = AppContext.getCurrentUser();
		if(user!=null)
		{
			if(task!=null && task.getTask_status()!=null)
			{
				result = task.getTask_status();
			}else
			{
				result = "-2";
				if(task.getTask_id()==null){
					result = "11";
				}
			}
		}
		return result;
	}

	/**
	 * 改造自count.jsp
	 * @param loginName
	 * @return
	 */
	@Override
	public List count(String loginName){
/*			String userId = ((HttpServletRequest) request).getUserPrincipal()
			.getName();
	// String userId="jsbzyp";
	QueryTodolistNew todolist = new QueryTodolistNew();
	HashMap result = todolist.getCountByGrours(userId);
	if (result.size() > 0) {
		Set entries = result.entrySet();
		Iterator iter = entries.iterator();
		while (iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();
			Object key = entry.getKey();
			String value = (String) entry.getValue();
			String content = key.toString() + "(" + value + ")";
			//System.out.println(content);
			out.println("<li><a href=\"javascript:openUrl()\" style=\"font-size:12px;\">"
					+ content + "</a></li>");
		}
	}
	out.print("<li id='HRtodoCount'><a href='javascript:openUrlToHR()' style='font-size:12px;'>人力资源(0)</a></li>");
*/
		StringBuffer sb = new StringBuffer();
		List<Map<String,String>> list  = new ArrayList<Map<String,String>>();
		QueryTodolistNew todolist = new QueryTodolistNew();
		Map result = todolist.getCountByGrours(loginName);
		Map groups = UrlHelp.getGroupNamekeyMap();
		if (result.size() > 0) {
			Set entries = result.entrySet();
			Iterator iter = entries.iterator();
			while (iter.hasNext()) {
				Map.Entry entry = (Map.Entry) iter.next();
				Object key = entry.getKey();
				String value = (String) entry.getValue();
				String content = key.toString() + "(" + value + ")";
				//System.out.println(content);
//				String html = "<li><a href=\"javascript:openUrl()\" style=\"font-size:12px;\">"	+ content + "</a></li>";
//				sb.append(html);
				//添加到map
				Map<String,String> map = new HashMap<String, String>();
//				map.put("html", html);
				map.put("subject", content);
				map.put("group", key.toString());
				map.put("count", String.valueOf(value));
				map.put("url", TaskCenterConstant.taskListurl+groups.get(key));
				list.add(map);
				
			}
		}
//		String html = "<li id='HRtodoCount'><a href='javascript:openUrlToHR()' style='font-size:12px;'>人力资源(0)</a></li>";
//		sb.append(html);
		String hrcount = this.getHrCountSizeByClient(loginName);
		Map<String,String> map = new HashMap<String, String>();
		map.put("subject", "人力资源("+hrcount+")");
		map.put("count",hrcount);
		map.put("url", this.getHROpenUrl(loginName));
		list.add(map);
		return list;

	}
	
	/**
	 * 来自countTodolistByGroup.jsp 获得hr待办的url
	 * @param loginName
	 * @return
	 */
	public String getHROpenUrl(String loginName){
		//获取人力资源远程调用URL
		String zcRemoteUrl = TaskCenterConstant.zcRemoteUrl; //UrlHelp.getVal("serverconf","zcRemoteUrl");
		//获取portalUser
		String todayTime = Datetimes.format(new Date(), "yyyy-MM-dd HH:mm:ss");
		String enString = StringUtils.encrypt(loginName + "," + todayTime);
		String url = zcRemoteUrl+"?otherIdp=1&portalUser="+enString+"&type=sso";
		log.info("获取人力资源待办URL为："+url);
		return url;
	}
	@AjaxAccess
	@Override
	public FlipInfo todoList(FlipInfo flipInfo,	Map<String, String> param){
		String group = ParamUtil.getString(param, "gcode");
		String user = AppContext.getCurrentUser().getLoginName(); //ParamUtil.getString(param, "user");
		List<CenterTaskBO> list = this.newjasonTodolist(user, group);
		DBAgent.memoryPaging(list, flipInfo);
		return flipInfo;
	}
	/**
	 * 未使用的方法
	 * @param user
	 * @param group
	 * @return
	 */
	public List<TaskTodolist> getTaskToDoList(String user,String group){
		if(Strings.isBlank(user)){
			log.error("参数用户名为空user="+user);
			return new ArrayList<TaskTodolist>();
		}
		StringBuffer hql = new StringBuffer();
		hql.append("select t from "+TaskTodolist.class.getSimpleName()+" t,"+CopyTodolist.class.getSimpleName()+" c ");
		hql.append("where ((t.taskConfirmor=:user1 and t.taskStatus=:taskStatus1) or (c.taskId=t.taskId and c.taskAssigneer=:user2 and t.taskStatus in (:taskStatus2)))");
		Map<String,Object> params =  new HashMap<String, Object>();
		params.put("taskStatus1", "13");
		List status2 = new ArrayList();
		status2.add("11");
		status2.add("12");
		params.put("taskStatus1", "13");
		params.put("user1", user);
		params.put("user2", user);
		params.put("taskStatus2", status2);
		if(Strings.isNotBlank(group)){
			List<String> list = UrlHelp.getGroupApps(group);
			if(list!=null && list.size()>0){
				hql.append(" and t.taskAppSrc in (:taskApps)");
				params.put("taskApps", list);
			}
		}
		List res= this.taskCenterDao.findListByHQL(hql.toString(), params);
		return res;
	}
	/***
	 * 获取人力资源待办数量	
	 * @param loginName
	 * @return
	 */
	public String getHrCountSizeByClient(String loginName){
		GetUserWorkTodoNum param = new GetUserWorkTodoNum();
		param.setArg0(loginName);
		GetUserWorkTodoNumE getobj = new GetUserWorkTodoNumE();
		getobj.setGetUserWorkTodoNum(param);
		try {
			WorkToDoWebServiceServiceStub stub = new WorkToDoWebServiceServiceStub(TaskCenterConstant.hrRemoteUrl);
			GetUserWorkTodoNumResponseE res = stub.getUserWorkTodoNum(getobj);
			if(res!=null && res.getGetUserWorkTodoNumResponse()!=null){
				int result = res.getGetUserWorkTodoNumResponse().get_return();
				log.info("通过接口获得HR待办数量：count="+result);
				if(result>0){
					
					return result+"";
				}
				
			}
		} catch (Exception e) {
			log.error("获取HR待办数量出错！",e);
		}
		return "0";
	}
	/***
	 * 获取人力资源待办数量	
	 * @param loginName
	 * @return
	 */
	public String getHrCountSize(String loginName){
/*		System.getProperties().setProperty("proxySet", "false");
		System.getProperties().setProperty("http.proxyHost", "");
		System.getProperties().setProperty("http.proxyPort", "");
		System.getProperties().setProperty("proxyHost", "");
		System.getProperties().setProperty("proxyPort", "");*/
		Integer mes = new Integer("0");
		try {
			//从配置文件获取人力资源系统待办URL
			String hrRemoteUrl = TaskCenterConstant.hrRemoteUrl; //UrlHelp.getVal("serverconf","hrRemoteUrl");
			hrRemoteUrl = (hrRemoteUrl.endsWith("wsdl")?hrRemoteUrl:(hrRemoteUrl+"?wsdl"));
			String hrNameSpaceUri = "http://webService.common.staffing.talentbase.neusoft.com/" ; ///UrlHelp.getVal("serverconf","hrNameSpaceUri");
			// /////////////////接口调用////////////////////////////////////////////////////////
			log.info("start call getUserWorkTodoNum: remoteUrl=" + hrRemoteUrl
							+ ",nameSpace=" + hrNameSpaceUri);
			// 创建调用对象
			Service service = new Service();
			Call call = (Call) service.createCall();
			
			// 设置service所在URL
			call.setTargetEndpointAddress(new java.net.URL(hrRemoteUrl));
			call.setOperationName(new QName(hrNameSpaceUri,"getUserWorkTodoNum"));
			
			// 初始化参数，并调用接口
			QName qn1 = new QName(hrNameSpaceUri, "getUserWorkTodoNum");
			call.addParameter("arg0", qn1, ParameterMode.IN);
			call.setReturnType(XMLType.XSD_INT);

			// 初始化参数，并调用接口
			mes = (Integer) call.invoke(new Object[] {loginName});
			log.info("调用人力资源待办数量接口返回值为："+mes);
			// ///////////////////////end///////////////////////////////////////////////////
		} catch (Exception e) {
			log.error("",e);
		}
		return mes.toString();
		
	}
	/**
	 * 复制mydone.jsp
	 * @param flipInfo
	 * @param param
	 * @return
	 */
	@AjaxAccess
	@Override
	public FlipInfo listmydoneTask(FlipInfo flipInfo,	Map<String, String> param){
	//	{name: 'taskId', mapping: 'a'},
	//		{name: 'flowName', mapping: 'b'},
	//    {name: 'flowNode', mapping: 'c'},
	//    {name: 'subject', mapping: 'd'},
	//    {name: 'batchName',mapping: 'e'},
	//    {name: 'submitTime',mapping: 'f'},
	//    {name: 'linkPath',mapping: 'g'},
	//    {name: 'appvar1',mapping:'h'},
	//    {name: 'detailPath',mapping:'i'},
		try {
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String nowDate = df.format(new Date());

//			String userId = (String) request.getUserPrincipal().getName();
			String userId = AppContext.getCurrentUser().getLoginName();

			if(param!=null){
				String leader = param.get("leaderName");
				if(leader!=null && !"".equals(leader) && !"null".equals(leader)){
					userId = leader;
				}
			}
			
			String user = StringUtils.encrypt(userId + "," + nowDate);

			NewQueryDoneList query = new NewQueryDoneList();
			List<Task> allList = query.getDoneList(null, null, userId);

			List resluts = new ArrayList();
			if(allList!=null){
				
				for (Task p :allList) {
					
					// 链接路径
					String linkPath = p.getTask_link_format();
					if (p.getTask_app_src().equals(TaskInfor.APP_CODE_OA)) {
						linkPath = linkPath + "&portalUID=" + userId;
					}
					//需要用加密的用户名代替
					if (linkPath != null && linkPath.indexOf("$[TEMPSECUSER]$") > -1) {
						String user_secr = StringUtils.encrypt(userId);
						linkPath = linkPath.replaceAll("\\$\\[TEMPSECUSER\\]\\$", user_secr);
					}
					if (linkPath != null && linkPath.indexOf("$[TEMPUSER]$") > -1) {
						linkPath = linkPath.replaceAll("\\$\\[TEMPUSER\\]\\$", userId);
					}
					
					String state = p.getTask_status();
					String linkPath2 = p.getTask_linkType_code() + "&taskListId=" + p.getTask_id()
					+ ((null != state && !"".equals(state)) ? "&taskCode=" + state : "")
					+ "&otherIdp=1&portalUser=" + user;
					String detailPath = p.getTask_linkType_code() + "&taskListId=" + p.getTask_id()
					+ "&otherIdp=1&portalUser=" + user;
					CenterTaskBO bo = new CenterTaskBO();
//				Map<String,String> json = new HashMap<String, String>();
					//任务id
//				json.put("taskId", p.getTask_id());
					bo.setTaskId(p.getTask_id());
					//流程名称
//				json.put("flowName", p.getApp_var_5());
					bo.setFlowName(p.getApp_var_5());
					//环节名称(任务所办环节)
//				json.put("flowNode", p.getTask_stage_name());
					bo.setFlowNode(p.getTask_stage_name());
					//标题
//				json.put("subject", p.getTask_subject());
					bo.setSubject(p.getTask_subject());
					//任务所处环节
//				json.put("batchName", p.getTask_batch_name());
					bo.setBatchName(p.getTask_batch_name());
					//提交时间
//				json.put("submitTime", p.getTask_submit_time());
					bo.setSubmitTime(p.getTask_submit_time());
					if ("true".equals(p.getApp_var_1())) {
						//链接路径
//					json.put("linkPath", linkPath2.startsWith("http")?linkPath2:portolurl+linkPath2);
//					json.put("appvar1", p.getApp_var_1());
						bo.setLinkPath(linkPath2.startsWith("http")?linkPath2:portolurl+linkPath2);
						bo.setAppvar1(p.getApp_var_1());
					} else {
						//链接路径
//					json.put("linkPath", linkPath.startsWith("http")?linkPath:portolurl+linkPath);
//					json.put("appvar1", p.getApp_var_1());
						bo.setLinkPath(linkPath.startsWith("http")?linkPath:portolurl+linkPath);
						bo.setAppvar1(p.getApp_var_1());
						detailPath =portolurl+"/taskctr/jsp/viewTaskDetail.jsp?a=2a533047a5e4b2ccfc269373b662f3bb640620112b77100fd&b=2a533047a5e4b2ccfc269373b662f3bb640620112b7742dda&taskId="+p.getTask_id();
						
					}
					
					//详细信息路径
//				json.put("detailPath", detailPath);
					bo.setDetailPath(detailPath);
					resluts.add(bo);
				}
			}
			Collections.sort(resluts,new DoneListSortUtils());
			DBAgent.memoryPaging(resluts, flipInfo);
//			JSONObject jsonRet = new JSONObject();
//			jsonRet.put("data", jsonArr);
//			jsonRet.put("totalProperty", jsonArr.size() + "");
//
//			out.clear();
//			out.write(jsonRet.toString());
		} catch (Exception ex) {
			log.error("查询已办事项出错！",ex);
		}
		return flipInfo;
	}

	/**
	 * 来自newjasonTodolist.jsp
	 * @param userId
	 * @return
	 */
	public List<CenterTaskBO> newjasonTodolist(String userId,String group){
		try {

			//userId加密
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String nowDate = df.format(new Date());
			String incryPtUserId = StringUtils.encrypt(userId + "," + nowDate);

			//得到集团userId
			TaskServiceImpl taskSeive = new TaskServiceImpl();
			UserServiceImpl userServe = new UserServiceImpl();

			String jtUserId = userServe.getUserIdByAccount(userId);

			//获得资产平台任务待办(最新500条)
			QueryTodolistNew query = new QueryTodolistNew();
			List zcList = query.getTodoList(userId, null);

			log.info("zc um todo size=" + zcList.size());

			//获得集团平台任务待办(最新500条)
			//获得除阅文以外的集团平台待办任务
			List gumList = taskSeive.queryTaskListByFlag(jtUserId, null, "2", 1, 500);

			log.info("gum todo size=" + gumList.size());

			List allList = new ArrayList();
			allList.addAll(zcList);
			allList.addAll(gumList);

			// 应用对应的分类
			List<String> listApps = UrlHelp.getGroupApps(group);

			// 排序
			//改成在客户端排序2016
			//Collections.sort(allList, new ObjectSort());

			//处理显示的数据列表
			int allLen = allList.size();
			//List data = new ArrayList();
			//for (int i = 0; i < allLen && i < 500; i++) {// 排序后，再次取最新500条
			//	data.add(allList.get(i));
			//}

			//如果除阅文以外的待办任务不到500条,再次取得阅文待办并排序
			if (allLen / 2 < 500) {
				List dataOARead = new ArrayList();
				List gumListOfOARead = taskSeive.queryYueWenTaskLis(jtUserId, 1, 500 - allLen / 2);
				if (gumListOfOARead != null && gumListOfOARead.size() > 0) {
					allList.addAll(gumListOfOARead);
				}
			}

//			JSONArray jsonArr = new JSONArray();
			List<CenterTaskBO> listresult = new ArrayList<CenterTaskBO>(); 
			int len = allList.size();
			for (int u = 0; u < len; u++) {
				Task task = (Task) allList.get(u);

				//开始对分类的控制
				String appSrc = task.getTask_app_src();
				String typeV = "";
				//增加对全部数据获取的判断
				if(listApps.size()==0){
					typeV = "all";
				}else if ((appSrc == null && group.equals("group1"))|| listApps.contains(appSrc)) {
					typeV = group;
				} else {
					continue;
				}
				// 链接路径
				String linkPath = task.getTask_link_format();
				if (task.getTask_app_src().equals(TaskInfor.APP_CODE_OA)) {
					linkPath = linkPath + "&portalUID=" + userId;
				}
				//需要用加密的用户名代替
				if (linkPath != null && linkPath.indexOf("$[TEMPSECUSER]$") > -1) {
					String user_secr = StringUtils.encrypt(userId);
					linkPath = linkPath.replaceAll("\\$\\[TEMPSECUSER\\]\\$", user_secr);
				}
				if (linkPath != null && linkPath.indexOf("$[TEMPUSER]$") > -1) {
					linkPath = linkPath.replaceAll("\\$\\[TEMPUSER\\]\\$", userId);
				}

				String linkPath2 = task.getTask_link_format() + "&taskListId=" + task.getTask_id()
				+ "&otherIdp=1&portalUser=" + incryPtUserId;
				String detailPath = task.getTask_link_format() + "&taskListId=" + task.getTask_id()
				+ "&otherIdp=1&portalUser=" + incryPtUserId;

				CenterTaskBO bo = new CenterTaskBO();
//				JSONObject json = new JSONObject();
				//任务id
		//		json.put("a", task.getTask_id());
				bo.setTaskId(task.getTask_id());
				//流程名称
			//	json.put("b", task.getApp_var_5());
				bo.setFlowName(task.getApp_var_5());
				//环节名称
//				json.put("c", task.getTask_stage_name());
				bo.setFlowNode(task.getTask_stage_name());
				//标题
//				json.put("d", task.getTask_subject());
				bo.setSubject( task.getTask_subject());
				//分配时间
//				json.put("e", task.getTask_assignee_time());
				bo.setAssignerTime(task.getTask_assignee_time());
				//分配人
//				json.put("f", task.getTask_designator());
				bo.setDesignator(task.getTask_designator());
				if ("true".equals(task.getApp_var_1())){
					//链接路径
//					json.put("g", linkPath2);
					bo.setLinkPath(linkPath2);
//					json.put("h", task.getApp_var_1());
					bo.setAppvar1(task.getApp_var_1());
				} else {
					//链接路径
//					json.put("g", linkPath);
					bo.setLinkPath(linkPath);
//					json.put("h", task.getApp_var_1());
					bo.setAppvar1(task.getApp_var_1());
				}

				//详细信息路径
//				json.put("i", detailPath);
				bo.setDetailPath(detailPath);
				//类型
//				json.put("j", typeV);
				bo.setType(typeV);
				//转交链接
//				json.put("k", task.getTask_link_format2());
				bo.setLinkPath2(task.getTask_link_format2());
//				jsonArr.add(json);
				if(!bo.getLinkPath().startsWith("http")){
					bo.setLinkPath(portolurl+bo.getLinkPath());
					bo.setLinkPath2(portolurl+bo.getLinkPath2());
					bo.setDetailPath(portolurl+bo.getDetailPath());
				}
				listresult.add(bo);
			}

//			JSONObject jsonRet = new JSONObject();
//			jsonRet.put("data", jsonArr);
//			jsonRet.put("totalProperty", jsonArr.size() + "");

//			return jsonRet.toString();
			return listresult;
		} catch (Exception e) {
			log.error("",e);
		}
		return new ArrayList<CenterTaskBO>();

	}

	@Override
	public List<TaskGroups> getAllTaskGroups() {
		
		List<TaskGroups> list = (List<TaskGroups>) AppContext.getCache("CINDA_TASK_GROUP_CACHE");
		if(list==null || list.size()==0){
			list = new ArrayList<TaskGroups>();
			AppContext.putCache("CINDA_TASK_GROUP_CACHE", list);
			synchronized (list) {
				list = (List<TaskGroups>) AppContext.getCache("CINDA_TASK_GROUP_CACHE");
				if(list.size()==0){
					list = this.taskCenterOADao.findAll(TaskGroups.class); 
					AppContext.putCache("CINDA_TASK_GROUP_CACHE", list);
				}
			}
		}
		return list;
	}
}
