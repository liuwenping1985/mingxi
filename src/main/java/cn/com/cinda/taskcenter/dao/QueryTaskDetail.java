package cn.com.cinda.taskcenter.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;


import cn.com.cinda.taskcenter.common.ConnectionPool;
import cn.com.cinda.taskcenter.common.UserInfor;
import cn.com.cinda.taskcenter.model.Task;
import cn.com.cinda.taskcenter.util.TaskUtil;

/**
 * 查询任务详细休息
 * 
 * @author hkgt
 * 
 */
public class QueryTaskDetail {
	
	private static final SimpleDateFormat FORMAT = new SimpleDateFormat(
			"yyyy-MM-dd HH:mm:ss");

	private Logger log = Logger.getLogger(this.getClass());

	/**
	 * 通过任务id获得任务对象
	 * 
	 * @param taskId
	 *            任务id
	 * @return
	 */
	public Task getTaskById(String taskId) {
		Task task = new Task();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select * from cinda_task.TASK_TODOLIST where task_id=?";

		try {
			con = ConnectionPool.getConnection();
			pstmt = con.prepareStatement(sql);

			pstmt.setString(1, taskId);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				task.setApp_var_1(rs.getString("app_var_1"));
				task.setApp_var_2(rs.getString("app_var_2"));
				task.setApp_var_3(rs.getString("app_var_3"));
				task.setApp_var_4(rs.getString("app_var_4"));
				task.setApp_var_5(rs.getString("app_var_5"));
				task.setApp_var_6(rs.getString("app_var_6"));
				task.setApp_var_7(rs.getString("app_var_7"));
				task.setApp_var_8(rs.getString("app_var_8"));
				task.setApp_var_9(rs.getString("app_var_9"));

				task.setDelflag(new Integer(rs.getInt("delflag")));
				task.setDept_code(rs.getString("dept_code"));
				task.setTask_allow_deliver(new Integer(rs
						.getInt("task_allow_deliver")));
				task.setTask_app_src(rs.getString("task_app_src"));
				task.setTask_app_moudle(rs.getString("TASK_APP_MOUDLE"));
				task.setTask_assignee_rule(rs.getString("task_assignee_rule"));
				task.setTask_assignee_time(rs.getString("task_assignee_time"));
				//changed by fjh 20070614,因为任务的分配人可能是多个，多个是用','隔开的
				String userids=rs.getString("task_assigneer");
				String useridch="";
				if((userids!=null)&&(userids.length()>0))
				{
					String[] userIds=userids.split(",");
					for(int i=0;i<userIds.length;i++)
					{
						if(userIds[i].equals("weblogic")||(userIds[i].equals("taskcenter")))
						{
							continue;
						}
						else{
							String name=UserInfor.getUserNameById(userIds[i]);
							if(name!=null)
							{
							useridch=useridch+UserInfor.getUserNameById(userIds[i])+",";
							}else{
								useridch=useridch+userIds[i]+",";
								
							}
						}
					}
				}
				//task.setTask_assigneer(TaskUtil.replaceNull(UserInfor
						//.getUserNameById(rs.getString("task_assigneer"))));
				task.setTask_assigneer(useridch);
				task.setTask_batch_id(rs.getString("task_batch_id"));
				task.setTask_batch_name(rs.getString("task_batch_name"));
				task.setTask_cc(rs.getString("task_cc"));
				task.setTask_creator(TaskUtil.replaceNull(UserInfor
						.getUserNameById(rs.getString("task_creator"))));
				task.setTask_comments(rs.getString("task_comments"));
				task.setTask_confirm_time(TaskUtil.replaceNull(rs
						.getString("task_confirm_time")));
				task.setTask_confirmor(TaskUtil.replaceNull(UserInfor
						.getUserNameById(rs.getString("task_confirmor"))));
				task.setTask_content(rs.getString("task_content"));
				task.setTask_create_time(rs.getString("task_create_time"));
				task.setTask_designator(TaskUtil.replaceNull(UserInfor
						.getUserNameById(rs.getString("task_designator"))));
				task.setTask_executor(TaskUtil.replaceNull(UserInfor
						.getUserNameById(rs.getString("task_executor"))));
				task.setTask_id(rs.getString("task_id"));
				task.setTask_kind(new Integer(rs.getInt("task_kind")));
				task.setTask_link2_name(rs.getString("task_link2_name"));
				task.setTask_link2_type(rs.getString("task_link2_type"));
				task.setTask_link3_name(rs.getString("task_link3_name"));
				task.setTask_link3_type(rs.getString("task_link3_type"));
				task.setTask_link4_name(rs.getString("task_link4_name"));
				task.setTask_link4_type(rs.getString("task_link4_type"));
				task.setTask_link5_name(rs.getString("task_link5_name"));
				task.setTask_link5_type(rs.getString("task_link5_type"));
				task.setTask_link_type(rs.getString("task_link_type"));
				task.setTask_msg_id(rs.getString("task_msg_id"));
				task.setTask_msg_status(new Integer(rs
						.getInt("task_msg_status")));
				task.setTask_result_code(rs.getString("task_result_code"));
				task.setTask_stage_name(rs.getString("task_stage_name"));
				task.setTask_status(rs.getString("task_status"));

				String subject = rs.getString("task_subject");
				if (subject == null) {
					subject = "";
				}
				task.setTask_subject(subject);
				task.setTask_submit(UserInfor.getUserNameById(rs
						.getString("task_submit")));
				String taskSubmitTime = rs.getString("task_submit_time");
				if (taskSubmitTime == null) {
					taskSubmitTime = "";
				}
				task.setTask_submit_time(taskSubmitTime);

				// 应用自定义状态
				task.setTask_app_state(rs.getString("task_app_state"));
			}

			return task;
		} catch (SQLException ex) {
			log.error(ex);
		} finally {
			ConnectionPool.release(null, null, pstmt, con);
		}

		return task;
	}
	
	//获得应用编码和名称映射
	public Map getAppNameMap() {
		Connection con = null;
		Statement stmt = null;
		ResultSet rs = null;
		Map appNameMap = new HashMap();
		try {
			String sql = "select * from cinda_task.TASK_APP";
			con = ConnectionPool.getConnection();
			//con = JdbcHelper.getConn();
			stmt = con.createStatement();
			rs = stmt.executeQuery(sql);

			while (rs.next()) {
				String taskAppCode = rs.getString("TASK_APP_CODE");
				String taskAppName = rs.getString("TASK_APP_NAME");
				appNameMap.put(taskAppCode, taskAppName);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			ConnectionPool.release(rs, stmt, null, con);
		}

		return appNameMap;
	}
}
