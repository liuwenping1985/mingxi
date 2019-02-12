package cn.com.cinda.taskcenter.util;

import java.util.ArrayList;
import java.util.List;

import cn.com.cinda.taskcenter.common.TaskInfor;

public class TaskUtil {

	// 查询待办列表，根据流程名称正排序，分配时间倒排序,changed by fjh 20071116,查询有问题
	//public static String sqlOrderByWorkflowName = "select * from (select rownum, TASK_TODOLIST.*,"
	//		+ " row_number() over (order by app_var_5, task_assignee_time desc) rk"
	//		+ " from cinda_task.TASK_TODOLIST where ((task_status=? or task_status=?) and (task_assigneer like ? or task_assigneer like ? or task_assigneer = ? ))"
	//		+ " or (task_status=? and task_confirmor = ?))"
	//		+ " where rk between ? and ?";
	public static String sqlOrderByWorkflowName = "select * from (select rownum, TASK_TODOLIST.*,"
		+ " row_number() over (order by app_var_5, task_assignee_time desc) rk"
		+ " from cinda_task.TASK_TODOLIST where ((task_status=? or task_status=?) and (SUBSTR(task_assigneer,1,?) = ? or SUBSTR(task_assigneer,length(task_assigneer)-?,length(task_assigneer))=? or task_assigneer like ? or task_assigneer = ? ))"
		+ " or (task_status=? and task_confirmor = ?))"
		+ " where rk between ? and ?";
	// 查询待办列表，根据流程环节正排序，分配时间倒排序 changed by fjh 20071116,查询有问题
//	public static final String sqlOrderByWorkflowNode = "select * from (select rownum, TASK_TODOLIST.*,"
//			+ " row_number() over (order by task_stage_name, task_assignee_time desc) rk"
//			+ " from cinda_task.TASK_TODOLIST where ((task_status=? or task_status=?) and (task_assigneer like ? or task_assigneer like ? or task_assigneer = ? ))"
//			+ " or (task_status=? and task_confirmor like ?))"
//			+ " where rk between ? and ?";
	public static final String sqlOrderByWorkflowNode = "select * from (select rownum, TASK_TODOLIST.*,"
		+ " row_number() over (order by task_stage_name, task_assignee_time desc) rk"
		+ " from cinda_task.TASK_TODOLIST where ((task_status=? or task_status=?) and (SUBSTR(task_assigneer,1,?) = ? or SUBSTR(task_assigneer,length(task_assigneer)-?,length(task_assigneer))=? or task_assigneer like ? or task_assigneer = ? ))"
	    + " or (task_status=? and task_confirmor like ?))"
		+ " where rk between ? and ?";

	// 查询待办列表，根据分配时间倒排序,changed by fjh 20071119,修改查询条件
//	public static final String sqlOrderByAsignerTime = "select * from (select rownum, TASK_TODOLIST.*,"
//			+ " row_number() over (order by task_assignee_time desc) rk"
//			+ " from cinda_task.TASK_TODOLIST where ((task_status=? or task_status=?) and (task_assigneer like ? or task_assigneer like ? or task_assigneer = ? ))"
//			+ " or (task_status=? and task_confirmor like ?))"
//			+ " where rk between ? and ?";
	public static final String sqlOrderByAsignerTime = "select * from (select rownum, TASK_TODOLIST.*,"
	    + " row_number() over (order by task_assignee_time desc) rk"
	    + " from cinda_task.TASK_TODOLIST where ((task_status=? or task_status=?) and (SUBSTR(task_assigneer,1,?) = ? or SUBSTR(task_assigneer,length(task_assigneer)-?,length(task_assigneer))=? or task_assigneer like ? or task_assigneer = ? ))"
		+ " or (task_status=? and task_confirmor like ?))"
		+ " where rk between ? and ?";

	// 查询待办列表，根据被分配人正排序，分配时间倒排序,修改查询条件,20071119
//	public static final String sqlOrderByAssigner = "select * from (select rownum, TASK_TODOLIST.*,"
//			+ " row_number() over (order by task_assigneer, task_assignee_time desc) rk"
//			+ " from cinda_task.TASK_TODOLIST where ((task_status=? or task_status=?) and (task_assigneer like ? or task_assigneer like ? or task_assigneer = ? ))"
//			+ " or (task_status=? and task_confirmor = ?))"
//			+ " where rk between ? and ?";
	public static final String sqlOrderByAssigner = "select * from (select rownum, TASK_TODOLIST.*,"
		+ " row_number() over (order by task_assigneer, task_assignee_time desc) rk"
		+ " from cinda_task.TASK_TODOLIST where ((task_status=? or task_status=?) and (SUBSTR(task_assigneer,1,?) = ? or SUBSTR(task_assigneer,length(task_assigneer)-?,length(task_assigneer))=? or task_assigneer like ? or task_assigneer = ? ))"
		+ " or (task_status=? and task_confirmor = ?))"
		+ " where rk between ? and ?";

	// 查询待办列表，根据应用来源正排序，分配时间倒排序（默认排序）,changed by fjh 20071119
//	public static final String sqlOrderByDefault = "select * from (select rownum, TASK_TODOLIST.*,"
//			+ " row_number() over (order by task_app_src, task_assignee_time desc) rk"
//			+ " from cinda_task.TASK_TODOLIST where ((task_status=? or task_status=?) and (task_assigneer like ? or task_assigneer like ? or task_assigneer = ? ))"
//			+ " or (task_status=? and task_confirmor = ?))"
//			+ " where rk between ? and ?";
	public static final String sqlOrderByDefault = "select * from (select rownum, TASK_TODOLIST.*,"
		+ " row_number() over (order by task_app_src, task_assignee_time desc) rk"
		+ " from cinda_task.TASK_TODOLIST where ((task_status=? or task_status=?) and (SUBSTR(task_assigneer,1,?) = ? or SUBSTR(task_assigneer,length(task_assigneer)-?,length(task_assigneer))=? or task_assigneer like ? or task_assigneer = ? ))"
		+ " or (task_status=? and task_confirmor = ?))"
		+ " where rk between ? and ?";

	// 查询待办列表的记录总条数,changed by fjh 20071119,修改查询代办的sql语句
	//public static final String sqlCountTodo = "select count(*) from cinda_task.TASK_TODOLIST"
	//		+ " where ((task_status=? or task_status=?) and (task_assigneer like ? or task_assigneer like ? or task_assigneer = ? ))"
	//		+ " or (task_status=? and task_confirmor = ?)";
	public static final String sqlCountTodo="select count(*) from cinda_task.TASK_TODOLIST"
		+ " where ((task_status=? or task_status=?) and (SUBSTR(task_assigneer,1,?) = ? or SUBSTR(task_assigneer,length(task_assigneer)-?,length(task_assigneer))=? or task_assigneer like ? or task_assigneer = ? ))"
		+ " or (task_status=? and task_confirmor = ?)";

	// 查询链接列表
	public static final String linkPathSql = "select * from cinda_task.TASK_LINK_TYPE";

	// 查询已办列表的sql
	public static final String doneListSql = "select * from (select rownum, TASK_TODOLIST.*,"
			+ " row_number() over (order by task_assignee_time desc, task_app_src) rk"
			+ " from cinda_task.TASK_TODOLIST where task_executor=? and task_status=?"
			+ " and (task_batch_name<>'"
			+ TaskInfor.FLOW_END_BATCH_NAME
			+ "' or task_batch_name is null))" + " where rk between ? and ?";
	
	// 查询已办列表的记录总条数
	public static final String sqlCountDone = "select count(*) from cinda_task.TASK_TODOLIST"
			+ " where task_executor=? and task_status=?"
			+ " and (task_batch_name<>'"
			+ TaskInfor.FLOW_END_BATCH_NAME
			+ "' or task_batch_name is null)";

	// 获得任务状态名称
	public static String getTaskStateName(String taskStateStr) {

		int taskState = Integer.parseInt(taskStateStr);
		String temp = "";

		if (TaskInfor.TASK_STATUS_BUILD == taskState) {
			temp = "新建";
		} else if (TaskInfor.TASK_STATUS_ASSIGNED == taskState) {
			temp = "待办";
		} else if (TaskInfor.TASK_STATUS_READED == taskState) {
			temp = "分配";
		} else if (TaskInfor.TASK_STATUS_APPED == taskState) {
			temp = "在办";
		} else if (TaskInfor.TASK_STATUS_CANCEL == taskState) {
			temp = "终止";
		} else if (TaskInfor.TASK_STATUS_FINISHED == taskState) {
			temp = "已办";
		} else {
			temp = "其他";
		}

		return temp;
	}

	// 根据排序获得待办列表sql
	public static String getTodoListSql(String orderBy) {
		String sql = "";
		if (orderBy == null || orderBy.equals("")) {
			//sql = sqlOrderByDefault;
			sql = sqlOrderByAsignerTime;
		} else if (orderBy.equalsIgnoreCase("flowName")) {
			sql = sqlOrderByWorkflowName;
		} else if (orderBy.equalsIgnoreCase("flowNode")) {
			sql = sqlOrderByWorkflowNode;
		} else if (orderBy.equalsIgnoreCase("asignerTime")) {
			sql = sqlOrderByAsignerTime;
		} else if (orderBy.equalsIgnoreCase("asigner")) {
			sql = sqlOrderByAssigner;
		}

		return sql;
	}

	// 根据排序获得已办列表sql
	public static String getDoneListSql(String orderBy) {
		String sql = doneListSql;

		return sql;
	}

	// 根据任务类型值获得类型名称
	public static String getTaskKindName(Integer kindValue) {
		String temp = "";
		if (kindValue == null) {
			return "";
		} else if (kindValue.intValue() == TaskInfor.TASK_KIND_APP) {
			temp = "流程应用";
		} else if (kindValue.intValue() == TaskInfor.TASK_KIND_MANAGE) {
			temp = "任务管理";
		} else if (kindValue.intValue() == TaskInfor.TASK_KIND_OTHER) {
			temp = "其他";
		}

		return temp;
	}

	// 根据消息状态值获得消息状态名称
	public static String getMessageStateName(Integer msgState) {
		String temp = "";
		if (msgState == null || "".equals(msgState)) {
			return "";
		}

		int state = msgState.intValue();
		if (state == TaskInfor.TASK_MSG_STATUS_NOSEND) {
			temp = "不发送";
		} else if (state == TaskInfor.TASK_MSG_STATUS_SEND) {
			temp = "还没有发送";
		} else if (state == TaskInfor.TASK_MSG_STATUS_SENDED) {
			temp = "已经发送";
		} else if (state == TaskInfor.TASK_MSG_STATUS_SENDFAIL) {
			temp = "发送失败";
		}

		return temp;
	}

	// 获得是否允许转交名称
	public static String getDeliverName(Integer deliverState) {
		int state = deliverState.intValue();
		String temp = "";
		if (state == TaskInfor.TASK_ALLOW_DELIVER_YES) {
			temp = "是";
		} else {
			temp = "否";
		}
		return temp;
	}

	// 根据任务来源编号获得来源名称
	public static String getTaskSourceName(String taskSourceCode) {
		String temp = "";
		if (taskSourceCode == null) {
			return "";
		} else if (taskSourceCode.equalsIgnoreCase(TaskInfor.APP_CODE_MBLC)) {
			temp = "模板流程";
		} else if (taskSourceCode.equalsIgnoreCase(TaskInfor.APP_CODE_CZLC)) {
			temp = "处置流程";
		} else if (taskSourceCode.equalsIgnoreCase(TaskInfor.APP_CODE_XMDA)) {
			temp = "项目档案";
		} else if (taskSourceCode.equalsIgnoreCase(TaskInfor.APP_CODE_SSYJ)) {
			temp = "预警系统";
		} else if (taskSourceCode.equalsIgnoreCase(TaskInfor.APP_CODE_OA)) {
			temp = "公文流转";
		} else if (taskSourceCode.equalsIgnoreCase(TaskInfor.APP_CODE_ISO)) {
			temp = "ISO";
		} else if (taskSourceCode.equalsIgnoreCase(TaskInfor.APP_CODE_GJSJ)) {
			temp = "终结认定及跟进审计"; 
		}
		else {
			temp = taskSourceCode;
		}

		return temp;
	}
	
	// 根据任务来源编号获得来源名称(从数据库表中取得)
	public static String getTaskSourceName2(String taskSourceCode) {
		String temp = taskSourceCode;
		
		if(taskSourceCode == null) {
			return "";
		}
		
		String taskSoruceName = TaskAppHelp.getAppNameByCode(taskSourceCode);
		if(taskSoruceName!=null && !"".equals(taskSoruceName)) {
			temp = taskSoruceName;
		}
		return temp;
	}

	// 替换null为空
	public static String replaceNull(String str) {
		if (str == null) {
			return "";
		} else {
			return str;
		}
	}

	// 截取字符串
	public static String trimString(String str, int len) {
		if (str == null) {
			return "";
		}

		if (str.length() > len) {
			String newStr = str.substring(0, len) + "..";
			return newStr;
		} else {
			return str;
		}

	}

}
