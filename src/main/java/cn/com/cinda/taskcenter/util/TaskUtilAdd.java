// Decompiled by Jad v1.5.8e2. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://kpdus.tripod.com/jad.html
// Decompiler options: packimports(3) fieldsfirst ansi space 
// Source File Name:   TaskUtilAdd.java

package cn.com.cinda.taskcenter.util;


public class TaskUtilAdd
{

	public static final String sqlCountTodoByGroup = "select COUNT(*) AS COUNT  from cinda_task.TASK_TODOLIST where task_id in (select task_id from cinda_task.COPY_TODOLIST where TASK_ASSIGNEER=?)  and (task_status='11' or task_status='12') and task_app_src in(";
	public static final String sqlCountHasTodoByGroup = "select count(*) as count from cinda_task.TASK_TODOLIST where task_status='13' and task_confirmor =? and task_app_src in (";
	public static final String sqlTodoByGroup = "select * from cinda_task.TASK_TODOLIST where task_id in (select task_id from cinda_task.COPY_TODOLIST where TASK_ASSIGNEER=?) and (task_status='11' or task_status='12')";
	public static final String sqlHasdoByGroup = "select * from cinda_task.TASK_TODOLIST where task_status='13' and task_confirmor = ?";
	public static final String sqlTodoByGroupTopTwo = "select * from (select rownum,c.*, row_number() over (order by task_assignee_time desc) rk from (  select * from ( select * from cinda_task.TASK_TODOLIST where task_status='13' and task_confirmor =? union all select *  from cinda_task.TASK_TODOLIST where task_id in (select task_id from cinda_task.COPY_TODOLIST where TASK_ASSIGNEER=?)  and (task_status='11' or task_status='12') ))c) where rk between ? and ?";
	public static final String sqlQueryTodoByUserID = "select * from (select rownum,c.*, row_number() over (order by task_assignee_time desc) rk from (  select * from ( select * from cinda_task.TASK_TODOLIST where task_status='13' and task_confirmor =? union all  select *  from cinda_task.TASK_TODOLIST where task_id in (select task_id from cinda_task.COPY_TODOLIST where TASK_ASSIGNEER=?)  and (task_status='11' or task_status='12') ))c) where rk between ? and ?";
	public static final String sqlCountTodoByUserID = "select count(*) as count from cinda_task.TASK_TODOLIST where task_id in (select task_id from cinda_task.COPY_TODOLIST where TASK_ASSIGNEER=?) and (task_status='11' or task_status='12') ";
	public static final String sqlCountHasdoByUserID = "select count(*) as count from cinda_task.TASK_TODOLIST where task_status='13' and task_confirmor = ?";
	public static final String sqlQueryDoneByUserID = "select * from ( select rownum, b.*, row_number() over (order by task_assignee_time desc, task_app_src) rk  from (  select a.* from (  select * from cinda_task.TASK_TODOLIST where task_executor=? and task_status='14'  and (task_batch_name<>'流程结束' or task_batch_name is null) union all select * from cinda_task.TASK_TODOLIST where task_executor=?  and task_status='14'  and (task_batch_name='流程结束' ) and ROUND(TO_NUMBER(sysdate -  to_date(task_submit_time,'YYYY-MM-DD   HH24:MI:SS')))<7  ) a  ) b ) where rk between ? and ?";
	public static final String sqlCountDoneByUserID = "select sum(count) as sum from(select count(*) as count  from cinda_task.TASK_TODOLIST where task_executor=? and task_status='14'  and (task_batch_name<>'流程结束' or task_batch_name is null) union all select count(*) as count from cinda_task.TASK_TODOLIST where  task_executor=?  and task_status='14'  and (task_batch_name='流程结束' ) and ROUND(TO_NUMBER(sysdate -  to_date(task_submit_time,'YYYY-MM-DD   HH24:MI:SS')))<7  )";

	public TaskUtilAdd()
	{
	}
}