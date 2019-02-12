package cn.com.cinda.taskcenter.util;

import cn.com.cinda.taskcenter.common.TaskInfor;

public class TaskStatUtil {

	// 部门待办任务统计（应用编码、任务来源）
	public static final String sqlStatTodo = "select task_app_src, app_var_5, count(*) count from cinda_task.TASK_TODOLIST"
			+ " where dept_code like ? and (task_status=? or task_status=? or task_status=?)"
			+ " group by task_app_src, app_var_5 order by task_app_src, app_var_5";

	// 部门待办任务统计（应用编码）
	public static final String sqlStatTodo2 = "select task_app_src, count(*) count from cinda_task.TASK_TODOLIST"
			+ " where dept_code like ? and (task_status=? or task_status=? or task_status=?)"
			+ " group by task_app_src order by task_app_src";

	// 部门中所有用户待办任务统计（应用编码）
	public static final String sqlStatTodo3 = "select task_app_src, count(*) count, task_assigneer, task_confirmor from cinda_task.TASK_TODOLIST"
			+ " where dept_code like ? and (task_status=? or task_status=? or task_status=?)"
			+ " group by task_app_src, task_assigneer, task_confirmor order by task_app_src";

	// 部门已办任务统计（应用编码、任务来源）(包含流程已经结束的已办任务)
	public static final String sqlStatDone = "select task_app_src, app_var_5, count(*) count from cinda_task.TASK_TODOLIST"
		+ " where dept_code like ? and task_status=?"
		+ " and  task_batch_name is not null"
		+ " group by task_app_src, app_var_5 order by task_app_src, app_var_5";
	/*public static final String sqlStatDone = "select task_app_src, app_var_5, count(*) count from cinda_task.TASK_TODOLIST"
			+ " where dept_code=? and task_status=?"
			+ " and (task_batch_name<>'"
			+ TaskInfor.FLOW_END_BATCH_NAME
			+ "' or task_batch_name is null)"
			+ " group by task_app_src, app_var_5 order by task_app_src, app_var_5";*/

	// 部门已办任务统计（应用编码）(包含流程已经结束的已办任务)
	public static final String sqlStatDone2 = "select task_app_src, count(*) count from cinda_task.TASK_TODOLIST"
	+ " where dept_code like ? and task_status=?"
	+ " and task_batch_name is not null"
	+ " group by task_app_src order by task_app_src";
	/*public static final String sqlStatDone2 = "select task_app_src, count(*) count from cinda_task.TASK_TODOLIST"
			+ " where dept_code=? and task_status=?"
			+ " and (task_batch_name<>'"
			+ TaskInfor.FLOW_END_BATCH_NAME
			+ "' or task_batch_name is null)"
			+ " group by task_app_src order by task_app_src";*/

	// 部门中所有用户已办任务统计（应用编码）(包含流程已经结束的已办任务)
	public static final String sqlStatDone3 = "select task_app_src, count(*) count, task_executor from cinda_task.TASK_TODOLIST"
			+ " where dept_code like ? and task_status=?"
			+ " and  task_batch_name is not null"
			+ " group by task_app_src, task_executor order by task_app_src";
	/*public static final String sqlStatDone3 = "select task_app_src, count(*) count, task_executor from cinda_task.TASK_TODOLIST"
		+ " where dept_code like ? and task_status=?"
		+ " and (task_batch_name<>'"
		+ TaskInfor.FLOW_END_BATCH_NAME
		+ "' or task_batch_name is null)"
		+ " group by task_app_src, task_executor order by task_app_src";*/

	// 个人已办任务时间统计(任务执行人存在时，任务已经完成)
	public static final String userTaskStaTime = "select sum((to_date(task_submit_time,'yyyy-mm-dd hh24:mi:ss') - to_date(task_assignee_time,'yyyy-mm-dd hh24:mi:ss'))*24) as sumv,"
			+ " avg((to_date(task_submit_time,'yyyy-mm-dd hh24:mi:ss') - to_date(task_assignee_time,'yyyy-mm-dd hh24:mi:ss'))*24) as avgv "
			+ " from cinda_task.TASK_TODOLIST where task_executor=?";

	// 个人待办任务统计（应用编码、任务来源）,changed by fjh 20071120  修改查询代办的方式,原有的查询语句存在漏洞
//	public static final String sqlUserStatTodo = "select task_app_src, app_var_5, count(*) count from cinda_task.TASK_TODOLIST"
//			+ " where ((task_status=? or task_status=?) and (task_assigneer like ? or task_assigneer like ? or task_assigneer = ?))"
//			+ " or (task_status=? and task_confirmor = ?)"
//			+ " group by task_app_src, app_var_5 order by task_app_src, app_var_5";
	public static final String sqlUserStatTodo = "select task_app_src, app_var_5, count(*) count from cinda_task.TASK_TODOLIST"
		+ " where ((task_status=? or task_status=?) and (SUBSTR(task_assigneer,1,?) = ? or SUBSTR(task_assigneer,length(task_assigneer)-?,length(task_assigneer))=? or task_assigneer like ? or task_assigneer = ? ))"
		+ " or (task_status=? and task_confirmor = ?)"
		+ " group by task_app_src, app_var_5 order by task_app_src, app_var_5";
   //insert by fjh 20070613
	//已经分配给某个人，但没有申领的任务数量统计，changed by fjh 20071120,修改了统计的语句，原有统计存在漏洞
//	public static final String sqlUserStatTodo3 = "select  count(*) count,sum((sysdate - to_date(task_assignee_time,'yyyy-mm-dd hh24:mi:ss'))*24) as sumv from cinda_task.TASK_TODOLIST"
//		+ " where task_status=?  and (task_assigneer like ? or task_assigneer like ? or task_assigneer = ?)";
	
	public static final String sqlUserStatTodo3 = "select  count(*) count,sum((sysdate - to_date(task_assignee_time,'yyyy-mm-dd hh24:mi:ss'))*24) as sumv from cinda_task.TASK_TODOLIST"
		+ " where task_status=?  and (SUBSTR(task_assigneer,1,?) = ? or SUBSTR(task_assigneer,length(task_assigneer)-?,length(task_assigneer))=? or task_assigneer like ? or task_assigneer = ?)";
	
	//个人在办任务数量统计
	public static final String sqlUserStatTodo4 = "select  count(*) count,sum((sysdate - to_date(TASK_CONFIRM_TIME,'yyyy-mm-dd hh24:mi:ss'))*24) as sumv from cinda_task.TASK_TODOLIST"
		+ " where task_status=?  and task_confirmor =?";
		
	
	
	// 个人待办任务统计（应用编码），changed by fjh ,20071120原有查询存在漏洞
//	public static final String sqlUserStatTodo2 = "select task_app_src, count(*) count from cinda_task.TASK_TODOLIST"
//			+ " where ((task_status=? or task_status=?) and (task_assigneer like ? or task_assigneer like ? or task_assigneer = ?))"
//			+ " or (task_status=? and task_confirmor = ?)"
//			+ " group by task_app_src order by task_app_src";
	public static final String sqlUserStatTodo2 = "select task_app_src, count(*) count from cinda_task.TASK_TODOLIST"
		+ " where ((task_status=? or task_status=?) and (SUBSTR(task_assigneer,1,?) = ? or SUBSTR(task_assigneer,length(task_assigneer)-?,length(task_assigneer))=? or task_assigneer like ? or task_assigneer = ? ))"
		+ " or (task_status=? and task_confirmor = ?)"
		+ " group by task_app_src order by task_app_src";

	// 个人已办任务统计（应用编码、任务来源）
	public static final String sqlUserStatDone = "select task_app_src, app_var_5, count(*) count from cinda_task.TASK_TODOLIST"
		+ " where task_executor=? and task_status=?"
		+ " and ((task_batch_name<>'"
		+ TaskInfor.FLOW_END_BATCH_NAME
		+ "' or task_batch_name is null) or (task_batch_name='" + TaskInfor.FLOW_END_BATCH_NAME +"' and ROUND(TO_NUMBER(sysdate -  to_date(task_submit_time,'YYYY-MM-DD   HH24:MI:SS')))<7))"
		+ " group by task_app_src, app_var_5 order by task_app_src, app_var_5";
	// 个人已办任务统计（应用编码）
	public static final String sqlUserStatDone2 = "select task_app_src, count(*) count from cinda_task.TASK_TODOLIST"
			+ " where task_executor=? and task_status=?"
			+ " and ((task_batch_name<>'"
			+ TaskInfor.FLOW_END_BATCH_NAME
			+ "' or task_batch_name is null) or (task_batch_name='" + TaskInfor.FLOW_END_BATCH_NAME +"' and ROUND(TO_NUMBER(sysdate -  to_date(task_submit_time,'YYYY-MM-DD   HH24:MI:SS')))<7))"
			+ " group by task_app_src order by task_app_src";

	// 获得任务表中所有的应用编码
	public static final String sqlAppSrcList = "select distinct task_app_src from cinda_task.TASK_TODOLIST order by task_app_src";
}
