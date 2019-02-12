package cn.com.cinda.taskcenter.util;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import cn.com.cinda.taskcenter.common.TaskInfor;

public class TaskMonitorUtil {

	private static final SimpleDateFormat FORMAT = new SimpleDateFormat(
			"yyyy-MM-dd");

	private static final SimpleDateFormat FORMAT2 = new SimpleDateFormat(
			"yyyy-MM-dd HH:mm:ss");

	// 查询监控列表(条件：任务类型、任务来源、任务状态、分配时间、任务主题)，根据任务来源正排序，分配时间倒排序
	public static String taskMonitorListSql1 = "select * from (select rownum, TASK_TODOLIST.*,"
			+ " row_number() over (order by task_app_src, task_assignee_time desc) rk"
			+ " from cinda_task.TASK_TODOLIST where task_kind=? and task_app_src=? and task_status=?"
			+ " and (task_assignee_time between ? and ?) and task_subject like ?)"
			+ " where rk between ? and ?";

	// 查询监控列表(条件：任务类型、任务来源、任务状态、分配时间)，根据任务来源正排序，分配时间倒排序
	public static String taskMonitorListSql2 = "select * from (select rownum, TASK_TODOLIST.*,"
			+ " row_number() over (order by task_app_src, task_assignee_time desc) rk"
			+ " from cinda_task.TASK_TODOLIST where task_kind=? and task_app_src=? and task_status=?"
			+ " and (task_assignee_time between ? and ?))"
			+ " where rk between ? and ?";

	// 查询监控列表(条件：任务类型、任务来源、部门编码、任务状态、分配时间、任务主题)，根据任务来源正排序，分配时间倒排序
	public static String taskMonitorListSql3 = "select * from (select rownum, TASK_TODOLIST.*,"
			+ " row_number() over (order by task_app_src, task_assignee_time desc) rk"
			+ " from cinda_task.TASK_TODOLIST where task_kind=? and task_app_src=? and dept_code=? and task_status=?"
			+ " and (task_assignee_time between ? and ?) and task_subject like ?)"
			+ " where rk between ? and ?";

	// 查询监控列表(条件：任务类型、任务来源、部门编码、任务状态、分配时间)，根据任务来源正排序，分配时间倒排序
	public static String taskMonitorListSql4 = "select * from (select rownum, TASK_TODOLIST.*,"
			+ " row_number() over (order by task_app_src, task_assignee_time desc) rk"
			+ " from cinda_task.TASK_TODOLIST where task_kind=? and task_app_src=? and dept_code=? and task_status=?"
			+ " and (task_assignee_time between ? and ?))"
			+ " where rk between ? and ?";

	// 查询监控列表记录条数(条件：任务类型、任务来源、任务状态、分配时间、任务主题)
	public static String taskMonitorCountSql1 = "select count(*) from cinda_task.TASK_TODOLIST"
			+ " where task_kind=? and task_app_src=? and task_status=?"
			+ " and (task_assignee_time between ? and ?) and task_subject like ?";

	// 查询监控列表记录条数(条件：任务类型、任务来源、任务状态、分配时间)
	public static String taskMonitorCountSql2 = "select count(*) from cinda_task.TASK_TODOLIST"
			+ " where task_kind=? and task_app_src=? and task_status=?"
			+ " and (task_assignee_time between ? and ?)";

	// 查询监控列表记录条数(条件：任务类型、任务来源、部门编码、任务状态、分配时间、任务主题)
	public static String taskMonitorCountSql3 = "select count(*) from cinda_task.TASK_TODOLIST"
			+ " where task_kind=? and task_app_src=? and dept_code=? and task_status=?"
			+ " and (task_assignee_time between ? and ?) and task_subject like ?";

	// 查询监控列表记录条数(条件：任务类型、任务来源、部门编码、任务状态、分配时间)
	public static String taskMonitorCountSql4 = "select count(*) from cinda_task.TASK_TODOLIST"
			+ " where task_kind=? and task_app_src=? and dept_code=? and task_status=?"
			+ " and (task_assignee_time between ? and ?)";
//insert by fjh 20070625
	//	 查询监控列表记录条数(条件：部门编码、任务来源，任务状态、分配时间)
	
	public static String taskMonitorCountSql5 = "select count(*) from cinda_task.TASK_TODOLIST"
			+ " where task_kind=? and task_app_src=? and dept_code=? and task_status=?"
			+ " and (task_assignee_time between ? and ?)";

	// 获得任务类型列表
	public static List getTaskKindList() {
		List list = new ArrayList();
		list.add(TaskInfor.TASK_KIND_APP + "=流程应用");
		list.add(TaskInfor.TASK_KIND_ALL + "=所有");
		// list.add(TaskInfor.TASK_KIND_MANAGE + "=任务管理");
		// list.add(TaskInfor.TASK_KIND_OTHER + "=其他");

		return list;
	}

	// 获得任务来源列表
	public static List getTaskSourceList() {
		List list = new ArrayList();
		list.add(TaskInfor.APP_CODE_MBLC + "=模版流程");
		list.add(TaskInfor.APP_CODE_CZLC + "=处置流程");
		list.add(TaskInfor.APP_CODE_XMDA + "=项目档案");
		list.add(TaskInfor.APP_CODE_SSYJ + "=预警系统");
		//changed by fjh 20070613
		list.add(TaskInfor.APP_CODE_OA + "=公文流转");
		list.add(TaskInfor.APP_CODE_GJSJ + "=终结认定及跟进审计");
		list.add(TaskInfor.APP_CODE_All + "=所有");
		
//		list.add(TaskInfor.APP_CODE_ISO + "=ISO");

		return list;
	}

	// 获得任务状态列表
	public static List getTaskStateList() {
		List list = new ArrayList();

		list.add(TaskInfor.TASK_STATUS_BUILD + "=新建");
		list.add(TaskInfor.TASK_STATUS_ASSIGNED + "=待办");
        //changed by fjh 20070613
		//list.add(TaskInfor.TASK_STATUS_READED + "=已分配");
		list.add(TaskInfor.TASK_STATUS_APPED + "=在办");
		list.add(TaskInfor.TASK_STATUS_CANCEL + "=终止");
		list.add(TaskInfor.TASK_STATUS_FINISHED + "=已办");
		list.add(TaskInfor.TASK_STATUS_ALL + "=所有");
		

		return list;

	}

	// 根据查询条件和用户角色获得监控列表sql
	public static String getMonitorListSql(String queryParam, String userInRole) {
		String sql = "";

		// 总公司管理员
		if (TaskInfor.SYSTEM_ADMINISTRATOR.equals(userInRole)) {
			if (queryParam == null || queryParam.trim().equals("")) {
				sql = taskMonitorListSql2;
			} else {
				sql = taskMonitorListSql1;
			}
		} else if (TaskInfor.DEP_ADMINISTRATOR.equals(userInRole)) { // 办事处管理员
			if (queryParam == null || queryParam.trim().equals("")) {
				sql = taskMonitorListSql4;
			} else {
				sql = taskMonitorListSql3;
			}
		} else { // 没有权限访问
			return null;
		}

		return sql;
	}

	// 根据查询条件和用户角色获得监控列表countSql
	public static String getMonitorCountSql(String queryParam, String userInRole) {
		String sql = "";

		// 总公司管理员
		if (TaskInfor.SYSTEM_ADMINISTRATOR.equals(userInRole)) {
			if (queryParam == null || queryParam.trim().equals("")) {
				sql = taskMonitorCountSql2;
			} else {
				sql = taskMonitorCountSql1;
			}
		} else if (TaskInfor.DEP_ADMINISTRATOR.equals(userInRole)) { // 办事处管理员
			if (queryParam == null || queryParam.trim().equals("")) {
				sql = taskMonitorCountSql4;
			} else {
				sql = taskMonitorCountSql3;
			}
		} else { // 没有权限访问
			return null;
		}

		return sql;
	}

	public static String getSystemTime() {
		return FORMAT.format(new Date());
	}

}
