package cn.com.cinda.taskclient.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import cn.com.cinda.taskcenter.model.Task;
import cn.com.cinda.taskcenter.util.TaskAppHelp;

import com.seeyon.apps.taskcenter.webclient.HKServiceClient;

import com.seeyon.ctp.common.constants.SystemProperties;

/*import com.caucho.hessian.client.HessianProxyFactory;*/

/**
 * 集团平台任务中心集成接口实现
 * 
 * @date 2011-7-1
 * 
 */
public class TaskServiceImpl {

	public static Logger log = Logger.getLogger(TaskServiceImpl.class);

	/**
	 * 新版用户管理所在域名
	 */
	public static String gumPortalDomain = SystemProperties.getInstance().getProperty("","http://portal10.zc.cinda.ccb");

	/**
	 * 新版用户管理的任务服务接口地址
	 */
	public static String taskServiceUrl = "/gtaskctr/axis/services/taskPubService";

	/**
	 * 新版用户管理的任务页面链接地址
	 */
	public static String taskLinkPath = "/gtaskctr/task/";

	public TaskServiceImpl() {
		if (gumPortalDomain == null) {
//			init();
		}
	}

	/**
	 * 初始化配置文件
	 */
/*	public void init() {
		// taskManager.url=http://portal10.zc.cinda.ccb/gtaskctr/axis/services/

		FileInputStream is = null;
		try {
			Properties initVars = new Properties();
			is = new FileInputStream(TaskInfor.CONFIG_FILE_PATH);
			initVars.load(is);

			String path = initVars.getProperty("taskManager.url");
			gumPortalDomain = path.split("/gtaskctr/")[0];
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (is != null) {
				try {
					is.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}*/

	/**
	 * 查询用户待办
	 * 
	 * @param userId
	 * @param appSysCode
	 *            应用编码
	 * @param flag
	 *          任务类型标识
	 * @param pageNo
	 *            当前页数
	 * @param pageSize
	 *            每页显示记录数
	 * @return
	 */
	public List queryTaskListByFlag(String userId, String appSysCode, String flag, int pageNo,
			int pageSize) {

		List list = new ArrayList();

		try {
			if (!UserServiceImpl.connect(gumPortalDomain + taskServiceUrl)) {
				return list;
			}

/*			HessianProxyFactory factory = new HessianProxyFactory();
			TaskPubService srv = (TaskPubService) factory.create(
					TaskPubService.class, gumPortalDomain + taskServiceUrl);
			String[][] ret = srv.queryTaskListByFlag(userId, appSysCode, flag, pageNo,
					pageSize);*/
			
			
			//自己的实现方式
			String[][] ret = null;
			HKServiceClient client = new HKServiceClient(gumPortalDomain + taskServiceUrl);
			Object result = (Object[]) client.invokeMethod("queryTaskListByFlag", new Object[]{userId, appSysCode, flag, pageNo,
					pageSize});
			if(result!=null && result.getClass().isArray()){
				ret = (String[][]) result;
			}
			
			
			// {任务id1，任务主题1，应用编码1，创建时间1，任务状态1，任务附加数据1，任务环节1，任务创建人1}
			for (int i = 0; ret != null && i < ret.length; i++) {
				Task p = new Task();
				// p.getTask_link_format()
				// getApp_var_5()
				// getTask_stage_name
				// p.getTask_subject();
				// 分配时间p.getTask_assignee_time();
				// 分配人p.getTask_designator();
				p.setTask_id(ret[i][0]);
				p.setApp_var_5(TaskAppHelp.getAppNameByCode(ret[i][2]));// 流程名称
				p.setTask_subject(ret[i][1]);
				p.setTask_app_code(ret[i][2]);
				String time = ret[i][3];
				p.setTask_assignee_time(time);
				p.setTask_status(ret[i][4]);
				p.setTask_stage_name(ret[i][6]);
				p.setTask_designator(ret[i][7]);
				p.setTask_link_format(ret[i][8]); // 环节  // 客开 赵辉 添加url链接
				p.setApp_var_1("true"); // 识别是这个系统的文件
				p.setTask_app_src(ret[i][2]);

				list.add(p);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return list;
	}
	
	/**
	 * 查询用户待办
	 * 
	 * @param userId
	 * @param appSysCode
	 *            应用编码
	 * @param flag
	 *          任务类型标识
	 * @param pageNo
	 *            当前页数
	 * @param pageSize
	 *            每页显示记录数
	 * @return
	 */
	public List queryTaskList(String userId, String appSysCode, int pageNo,
			int pageSize) {

		List list = new ArrayList();

		try {
			if (!UserServiceImpl.connect(gumPortalDomain + taskServiceUrl)) {
				return list;
			}

/*			HessianProxyFactory factory = new HessianProxyFactory();
			TaskPubService srv = (TaskPubService) factory.create(
					TaskPubService.class, gumPortalDomain + taskServiceUrl);
			String[][] ret = srv.queryTaskList(userId, appSysCode, pageNo,
					pageSize);*/

			
			//自己的实现方式
			String[][] ret = null;
			HKServiceClient client = new HKServiceClient(gumPortalDomain + taskServiceUrl);
			Object result = client.invokeMethod("queryTaskList", new Object[]{userId, appSysCode, pageNo,
					pageSize});
			if(result!=null && result.getClass().isArray()){
				ret = (String[][]) result;
			}
				
			// {任务id1，任务主题1，应用编码1，创建时间1，任务状态1，任务附加数据1，任务环节1，任务创建人1}
			for (int i = 0; ret != null && i < ret.length; i++) {
				Task p = new Task();
				// p.getTask_link_format()
				// getApp_var_5()
				// getTask_stage_name
				// p.getTask_subject();
				// 分配时间p.getTask_assignee_time();
				// 分配人p.getTask_designator();
				p.setTask_id(ret[i][0]);
				p.setApp_var_5(TaskAppHelp.getAppNameByCode(ret[i][2]));// 流程名称
				p.setTask_subject(ret[i][1]);
				p.setTask_app_code(ret[i][2]);
				String time = ret[i][3];
				p.setTask_assignee_time(time);
				p.setTask_status(ret[i][4]);
				p.setTask_stage_name(ret[i][6]);
				p.setTask_designator(ret[i][7]);
				p.setTask_link_format(gumPortalDomain + taskLinkPath); // 环节
				p.setApp_var_1("true"); // 识别是这个系统的文件
				p.setTask_app_src(ret[i][2]);

				list.add(p);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return list;
	}
	
	/**
	 * 根据用户ID查询公文阅文待办任务列表
	 * @param userId
	 * @param pageNo
	 * @param rowPage
	 * @return
	 */
	public List queryYueWenTaskLis(String userId, int pageNo, int pageSize){
		List list = new ArrayList();

		try {
			if (!UserServiceImpl.connect(gumPortalDomain + taskServiceUrl)) {
				return list;
			}

/*			HessianProxyFactory factory = new HessianProxyFactory();
			TaskPubService srv = (TaskPubService) factory.create(
					TaskPubService.class, gumPortalDomain + taskServiceUrl);
			String[][] ret = srv.queryYueWenTaskLis(userId, pageNo, pageSize);*/

			
			
			//自己的实现方式
			String[][] ret = null;
			HKServiceClient client = new HKServiceClient(gumPortalDomain + taskServiceUrl);
			Object result = client.invokeMethod("queryYueWenTaskLis", new Object[]{userId, pageNo, pageSize});
			if(result!=null && result.getClass().isArray()){
				ret = (String[][]) result;
			}
			
			
			// {任务id1，任务主题1，应用编码1，创建时间1，任务状态1，任务附加数据1，任务环节1，任务创建人1}
			for (int i = 0; ret != null && i < ret.length; i++) {
				Task p = new Task();
				// p.getTask_link_format()
				// getApp_var_5()
				// getTask_stage_name
				// p.getTask_subject();
				// 分配时间p.getTask_assignee_time();
				// 分配人p.getTask_designator();
				p.setTask_id(ret[i][0]);
				p.setApp_var_5(TaskAppHelp.getAppNameByCode(ret[i][2]));// 流程名称
				p.setTask_subject(ret[i][1]);
				p.setTask_app_code(ret[i][2]);
				String time = ret[i][3];
				p.setTask_assignee_time(time);
				p.setTask_status(ret[i][4]);
				p.setTask_stage_name(ret[i][6]);
				p.setTask_designator(ret[i][7]);
				p.setTask_link_format(gumPortalDomain + taskLinkPath); // 环节
				p.setApp_var_1("true"); // 识别是这个系统的文件
				p.setTask_app_src(ret[i][2]);

				list.add(p);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return list;
	}

	/**
	 * 根据用户id获得待办记录数
	 * 
	 * @param userid
	 *            用户ID
	 * @return
	 */
	public int queryTaskCount(String userId, String appSysCode) {
		try {
			if (!UserServiceImpl.connect(gumPortalDomain + taskServiceUrl)) {
				return 0;
			}

/*			HessianProxyFactory factory = new HessianProxyFactory();
			TaskPubService srv = (TaskPubService) factory.create(
					TaskPubService.class, gumPortalDomain + taskServiceUrl);
			String count = srv.queryTaskCount(userId, appSysCode);*/

			//自己的实现方式
			String count = null;
			HKServiceClient client = new HKServiceClient(gumPortalDomain + taskServiceUrl);
			Object result = client.invokeMethod("queryTaskCount", new Object[]{userId, appSysCode});
			if(result!=null ){
				count =  (String) result;
			}
			
			if (count == null || count.trim().equals("")) {
				return 0;
			} else {
				return Integer.parseInt(count);
			}

		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return 0;
	}

	/**
	 * 根据用户id和状态获得记录数
	 * 
	 * @param userid
	 *            用户ID
	 * @param state
	 *            状态
	 * @return
	 */
	public int queryTaskCountByStatus(String userId, String appSysCode,
			String state) {
		try {
			if (!UserServiceImpl.connect(gumPortalDomain + taskServiceUrl)) {
				return 0;
			}

/*			HessianProxyFactory factory = new HessianProxyFactory();
			TaskPubService srv = (TaskPubService) factory.create(
					TaskPubService.class, gumPortalDomain + taskServiceUrl);
			String count = srv
					.queryTaskCountByStatus(userId, appSysCode, state);*/

			//自己的实现方式
			String count = null;
			HKServiceClient client = new HKServiceClient(gumPortalDomain + taskServiceUrl);
			Object result = client.invokeMethod("queryTaskCountByStatus", new Object[]{userId, appSysCode, state});
			if(result!=null ){
				count =  (String) result;
			}
			
			if (count == null || count.trim().equals("")) {
				return 0;
			} else {
				return Integer.parseInt(count);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return 0;
	}

	/**
	 * 根据用户id和状态获得列表
	 * 
	 * @param userid
	 *            用户ID
	 * @param state
	 *            状态
	 * @param pageNO
	 *            当前页
	 * @param pageSize
	 *            每页显示记录数
	 * @return
	 */
	public List queryTaskListByStatus(String userId, String appSysCode,
			String state, int pageNo, int pageSize) {

		List taskList = new ArrayList();
		try {
			if (!UserServiceImpl.connect(gumPortalDomain + taskServiceUrl)) {
				return taskList;
			}

/*			HessianProxyFactory factory = new HessianProxyFactory();
			TaskPubService srv = (TaskPubService) factory.create(
					TaskPubService.class, gumPortalDomain + taskServiceUrl);
			String[][] ret2 = srv.queryTaskListByStatus(userId, appSysCode,
					state, pageNo, pageSize);*/

			//自己的实现方式
			String[][] ret2 = null;
			HKServiceClient client = new HKServiceClient(gumPortalDomain + taskServiceUrl);
			Object result = client.invokeMethod("queryTaskListByStatus", new Object[]{userId, appSysCode,
					state, pageNo, pageSize});
			if(result!=null && result.getClass().isArray()){
				ret2 = (String[][]) result;
			}
			
			
			for (int i = 0; ret2 != null && i < ret2.length; i++) {
				String[] tmp = ret2[i];
				Task p = new Task();
				p.setTask_id(tmp[0]);
				p.setApp_var_5(TaskAppHelp.getAppNameByCode(tmp[2])); // 流程名称
				p.setTask_stage_name(tmp[6]); // 流程节点名称
				p.setTask_link_format(tmp[8]);// 链接路径  客开 赵辉 获取接口传入Url
				p.setTask_subject(tmp[1]); // 主题
				//p.setTask_assignee_time(tmp[3].substring(5, 16));// 分配时间
				p.setTask_assignee_time(tmp[3]);
				if (null != tmp[7]) {
					p.setTask_assigneer(tmp[7]); // 分配人
				}
				p.setTask_linkType_code(gumPortalDomain + taskLinkPath);
				p.setApp_var_1("true"); // 识别是这个系统的文件
				p.setTask_status(tmp[4]);// 状态
				p.setTask_batch_name(tmp[6]); // 任务所在的环节
				p.setTask_app_src(tmp[2]);
				p.setTask_submit_time(tmp[3]);

				taskList.add(p);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return taskList;
	}
	
	/**
	 * 根据用户id和状态获得列表(已办)
	 * 
	 * @param userid
	 *            用户ID
	 * @param state
	 *            状态
	 * @param pageNO
	 *            当前页
	 * @param pageSize
	 *            每页显示记录数
	 * @return
	 */
	public List queryTaskDoneListByStatus(String userId, String appSysCode,
			String state, int pageNo, int pageSize) {

		List taskList = new ArrayList();
		try {
			log.info("链接输出："+gumPortalDomain + taskServiceUrl);
			if (!UserServiceImpl.connect(gumPortalDomain + taskServiceUrl)) {
				return taskList;
			}

/*			HessianProxyFactory factory = new HessianProxyFactory();
			TaskPubService srv = (TaskPubService) factory.create(
					TaskPubService.class, gumPortalDomain + taskServiceUrl);
			String[][] ret2 = srv.queryTaskDoneListByStatus(userId, appSysCode,
					state, pageNo, pageSize);*/

			//自己的实现方式
			String[][] ret2 = null;
			HKServiceClient client = new HKServiceClient(gumPortalDomain + taskServiceUrl);
			Object result = client.invokeMethod("queryTaskListByStatus", new Object[]{userId, appSysCode,
					state, pageNo, pageSize});
			if(result!=null && result.getClass().isArray()){
				ret2 = (String[][]) result;
			}
			
			
			for (int i = 0; ret2 != null && i < ret2.length; i++) {
				String[] tmp = ret2[i];
				Task p = new Task();
				p.setTask_id(tmp[0]);
				p.setApp_var_5(TaskAppHelp.getAppNameByCode(tmp[2])); // 流程名称
				p.setTask_stage_name(tmp[6]); // 流程节点名称
				p.setTask_link_format(tmp[8]);// 链接路径 客开 赵辉 获取接口传入Url
				p.setTask_subject(tmp[1]); // 主题
				//p.setTask_assignee_time(tmp[3].substring(5, 16));// 分配时间
				p.setTask_assignee_time(tmp[3]);
				if (null != tmp[7]) {
					p.setTask_assigneer(tmp[7]); // 分配人
				}
				p.setTask_linkType_code(tmp[8]);
				p.setApp_var_1("true"); // 识别是这个系统的文件
				p.setTask_status(tmp[4]);// 状态
				p.setTask_batch_name(tmp[6]); // 任务所在的环节
				p.setTask_app_src(tmp[2]);
				p.setTask_submit_time(tmp[3]);
				taskList.add(p);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return taskList;
	}

	/**
	 * 根据应用类型查询用户任务数量（待办或者已办）
	 * 
	 * @param appType
	 *            应用类型
	 * @param userId
	 *            用户id
	 * @param status
	 *            任务状态（1：待办；3：已办）
	 * @return 数组{{应用1，数量1}，{应用2，数量2}，。。。}
	 */
	public String[][] queryTaskCountByFlag(String[] appType, String userId, String flag, 
			String status) {
		try {
			if (!UserServiceImpl.connect(gumPortalDomain + taskServiceUrl)) {
				return new String[][] {};
			}

/*			HessianProxyFactory factory = new HessianProxyFactory();
			TaskPubService srv = (TaskPubService) factory.create(
					TaskPubService.class, gumPortalDomain + taskServiceUrl);
			String[][] ret = srv.queryTaskCountByFlag(appType, userId, flag, status);*/

			//自己的实现方式
			String[][] ret = null;
			HKServiceClient client = new HKServiceClient(gumPortalDomain + taskServiceUrl);
			Object result = client.invokeMethod("queryTaskCountByFlag", new Object[]{appType, userId, flag, status});
			if(result!=null && result.getClass().isArray()){
				ret = (String[][]) result;
			}
			
			
			if (ret == null) {
				return new String[][] {};
			} else {
				return ret;
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return new String[][] {};
	}
	
	/**
	 * 根据应用类型查询用户任务数量（待办或者已办）
	 * 
	 * @param appType
	 *            应用类型
	 * @param userId
	 *            用户id
	 * @param status
	 *            任务状态（1：待办；3：已办）
	 * @return 数组{{应用1，数量1}，{应用2，数量2}，。。。}
	 */
	public String[][] queryTaskCountByApp(String[] appType, String userId, 
			String status) {
		try {
			if (!UserServiceImpl.connect(gumPortalDomain + taskServiceUrl)) {
				return new String[][] {};
			}

/*			HessianProxyFactory factory = new HessianProxyFactory();
			TaskPubService srv = (TaskPubService) factory.create(
					TaskPubService.class, gumPortalDomain + taskServiceUrl);
			String[][] ret = srv.queryTaskCountByApp(appType, userId, status);*/

			//自己的实现方式
			String[][] ret = null;
			HKServiceClient client = new HKServiceClient(gumPortalDomain + taskServiceUrl);
			Object result = client.invokeMethod("queryTaskCountByApp", new Object[]{appType, userId, status});
			if(result!=null && result.getClass().isArray()){
				ret = (String[][]) result;
			}
			
			
			if (ret == null) {
				return new String[][] {};
			} else {
				return ret;
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return new String[][] {};
	}
	
	/**
	 * 查询公文阅文的用户任务数量（待办或者已办）
	 * 
	 * @param userId
	 *            用户id
	 * @param status
	 *            任务状态（1：待办；3：已办）
	 * @return 数组{{应用1，数量1}，{应用2，数量2}，。。。}
	 */
	public String[] queryYueWenTaskCount(String userId, String status) {
		try {
			if (!UserServiceImpl.connect(gumPortalDomain + taskServiceUrl)) {
				return new String[] {};
			}

/*			HessianProxyFactory factory = new HessianProxyFactory();
			TaskPubService srv = (TaskPubService) factory.create(
					TaskPubService.class, gumPortalDomain + taskServiceUrl);
			String[] ret = srv.queryYueWenTaskCount(userId, status);*/

			//自己的实现方式
			String[] ret = null;
			HKServiceClient client = new HKServiceClient(gumPortalDomain + taskServiceUrl);
			Object result = client.invokeMethod("queryYueWenTaskCount", new Object[]{userId, status});
			if(result!=null && result.getClass().isArray()){
				ret = (String[]) result;
			}
			
			
			if (ret == null) {
				return new String[] {};
			} else {
				return ret;
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return new String[] {};
	}

	public String getGumPortalDomain() {
		return gumPortalDomain;
	}

	public void setGumPortalDomain(String gumPortalDomain) {
		TaskServiceImpl.gumPortalDomain = gumPortalDomain;
	}

	public String getTaskServiceUrl() {
		return taskServiceUrl;
	}

	public void setTaskServiceUrl(String taskServiceUrl) {
		TaskServiceImpl.taskServiceUrl = taskServiceUrl;
	}

	public String getTaskLinkPath() {
		return taskLinkPath;
	}

	public void setTaskLinkPath(String taskLinkPath) {
		TaskServiceImpl.taskLinkPath = taskLinkPath;
	}

}
