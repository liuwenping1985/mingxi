package cn.com.cinda.taskcenter.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;

import org.apache.log4j.Logger;

import cn.com.cinda.taskcenter.common.CommonPara;
import cn.com.cinda.taskcenter.common.ConnectionPool;
import cn.com.cinda.taskcenter.common.TaskInfor;
import cn.com.cinda.taskcenter.common.UserInfor;
import cn.com.cinda.taskcenter.model.Task;
import cn.com.cinda.taskcenter.util.TaskLinkUtil;
import cn.com.cinda.taskcenter.util.TaskMonitorUtil;
import cn.com.cinda.taskcenter.util.TaskUtil;

public class QueryMonitorList {
	private static final SimpleDateFormat FORMAT = new SimpleDateFormat(
			"yyyy-MM-dd HH:mm:ss");

	private Logger log = Logger.getLogger(this.getClass());

	/**
	 * 查询监控列表
	 * 
	 * @param common
	 *            分页信息
	 * @param selcon
	 *            查询监控列表条件
	 * @param userId
	 *            用户id
	 * @return
	 */
	public List getMonitorList(CommonPara common, Properties selcon,
			String userId) {
		List taskList = new ArrayList();

		// 初始化分页信息
		int iPageCountUse = common.iPageCountUse; // 每页显示的条数
		int iCurPageNo = common.iCurPageNo; // 当前页码
		int iTotalRow = 0; // 总条数
		int iTotalPage = 0; // 总页数

		int minRow = (iCurPageNo - 1) * iPageCountUse + 1;// 分页查询的起始行
		int maxRow = iCurPageNo * iPageCountUse;// 分页查询的终止行

		CommonPara resultInfo = new CommonPara();
		resultInfo.iCurPageNo = iCurPageNo;
		resultInfo.iPageCountUse = iPageCountUse;

		//
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = ConnectionPool.getConnection();
			pstmt = con.prepareStatement(initStatementCount(con, selcon, userId));

			rs = pstmt.executeQuery();
			if (rs.next()) {
				// 获得总的记录条数
				iTotalRow = rs.getInt(1);

				if (iTotalRow % iPageCountUse == 0) {
					iTotalPage = iTotalRow / iPageCountUse;
				} else {
					iTotalPage = iTotalRow / iPageCountUse + 1;
				}
			}

			resultInfo.iTotalRow = iTotalRow;
			resultInfo.iTotalPage = iTotalPage;
			// 返回分页信息
			taskList.add(resultInfo);

			// 获得链接信息
			pstmt = con.prepareStatement(TaskUtil.linkPathSql);
			rs = pstmt.executeQuery();
			HashMap hm = new HashMap();
			while (rs.next()) {
				// 流程名称
				String appSrc = rs.getString("task_linkType_code");
				// 任务状态
				String state = rs.getString("TASK_LINK_STATUS");
				// 任务链接
				String link = rs.getString("task_link_format");
				hm.put(appSrc + "," + state, link);
			}

			String sql = initStatement(con, selcon, userId, minRow, maxRow);
			pstmt= con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Task p = new Task();

				p.setApp_var_1(rs.getString("app_var_1"));
				p.setApp_var_2(rs.getString("app_var_2"));
				p.setApp_var_3(rs.getString("app_var_3"));
				p.setApp_var_4(rs.getString("app_var_4"));
				p.setApp_var_5(rs.getString("app_var_5"));
				p.setApp_var_6(rs.getString("app_var_6"));
				p.setApp_var_7(rs.getString("app_var_7"));
				p.setApp_var_8(rs.getString("app_var_8"));
				p.setApp_var_9(rs.getString("app_var_9"));
				p.setDelflag(new Integer(rs.getInt("delflag")));
				p.setDept_code(rs.getString("dept_code"));
				p.setTask_allow_deliver(new Integer(rs
						.getInt("task_allow_deliver")));
				p.setTask_app_src(rs.getString("task_app_src"));
				p.setTask_app_moudle(rs.getString("TASK_APP_MOUDLE"));

				p.setTask_assignee_rule(rs.getString("task_assignee_rule"));
				String time = rs.getString("task_assignee_time");
				time = time.substring(5, 16);
				p.setTask_assignee_time(time);
				p.setTask_assigneer(TaskUtil.replaceNull(UserInfor
						.getUserNameById(rs.getString("task_assigneer"))));
				p.setTask_batch_id(rs.getString("task_batch_id"));
				p.setTask_batch_name(rs.getString("task_batch_name"));
				p.setTask_cc(rs.getString("task_cc"));

				p.setTask_creator(TaskUtil.replaceNull(UserInfor
						.getUserNameById(rs.getString("task_creator"))));
				p.setTask_comments(rs.getString("task_comments"));
				String confirmTime = TaskUtil.replaceNull(rs
						.getString("task_confirm_time"));
				if (confirmTime != null && !"".equals(confirmTime)) {
					confirmTime = confirmTime.substring(5, 16);
				}

				p.setTask_confirm_time(confirmTime);
				p.setTask_confirmor(TaskUtil.replaceNull(UserInfor
						.getUserNameById(rs.getString("task_confirmor"))));
				p.setTask_content(rs.getString("task_content"));
				String createTime = TaskUtil.replaceNull(rs
						.getString("task_create_time"));
				if (createTime != null && !"".equals(createTime)) {
					createTime = createTime.substring(5, 16);
				}
				p.setTask_create_time(createTime);

				p.setTask_designator(TaskUtil.replaceNull(UserInfor
						.getUserNameById(rs.getString("task_designator"))));
				p.setTask_executor(TaskUtil.replaceNull(UserInfor
						.getUserNameById(rs.getString("task_executor"))));
				p.setTask_id(rs.getString("task_id"));
				p.setTask_kind(new Integer(rs.getInt("task_kind")));

				p.setTask_link2_name(rs.getString("task_link2_name"));
				p.setTask_link2_type(rs.getString("task_link2_type"));

				p.setTask_link3_name(rs.getString("task_link3_name"));
				p.setTask_link3_type(rs.getString("task_link3_type"));

				p.setTask_link4_name(rs.getString("task_link4_name"));
				p.setTask_link4_type(rs.getString("task_link4_type"));

				p.setTask_link5_name(rs.getString("task_link5_name"));
				p.setTask_link5_type(rs.getString("task_link5_type"));

				p.setTask_link_type(rs.getString("task_link_type"));

				p.setTask_msg_id(rs.getString("task_msg_id"));
				p.setTask_msg_status(new Integer(rs.getInt("task_msg_status")));
				p.setTask_result_code(rs.getString("task_result_code"));
				p.setTask_stage_name(rs.getString("task_stage_name"));
				p.setTask_status(rs.getString("task_status"));
				String subject = rs.getString("task_subject");
				if (subject == null) {
					subject = "";
				}
				p.setTask_subject(subject);

				p.setTask_submit(rs.getString("task_submit"));
				String submitTime = TaskUtil.replaceNull(rs
						.getString("task_submit_time"));
				if (submitTime != null && !"".equals(submitTime)) {
					submitTime = submitTime.substring(5, 16);
				}
				p.setTask_submit_time(submitTime);

				// 应用自定义状态
				p.setTask_app_state(rs.getString("task_app_state"));
				// link
				String linkType = rs.getString("task_link_type");
				String task_link_format = TaskLinkUtil.getTaskLink(linkType,
						hm, p);
				p.setTask_link_format(task_link_format);

				taskList.add(p);
			}

			return taskList;
		} catch (SQLException ex) {
			log.error(ex);
		} finally {
			ConnectionPool.release(null, null, pstmt, con);
		}

		return taskList;
	}

	// 初始化监控列表sql
	private String initStatement(Connection con, Properties selcon,
			String userId, int minRow, int maxRow) throws SQLException {
		//String sql = "";
		//PreparedStatement pstmt = null;
		

		String userInRole = selcon.getProperty("userInRole");
		String taskSubject = selcon.getProperty("taskSubject");
		String taskKind = selcon.getProperty("taskKind");
		String appSource = selcon.getProperty("appSource");
		String taskState = selcon.getProperty("taskState");
		String startTime1 = selcon.getProperty("startTime1");
		String startTime2 = selcon.getProperty("startTime2");
		startTime1 = startTime1 + " 00:00:00";
		startTime2 = startTime2 + " 23:59:59";
		String sql2="select * from (select rownum, TASK_TODOLIST.*,"
		+ " row_number() over (order by task_app_src, task_assignee_time desc) rk"
		+ " from cinda_task.TASK_TODOLIST where (task_assignee_time between '"+ startTime1+"' and '"+startTime2+"')";
		
		// 总公司管理员
		if (TaskInfor.SYSTEM_ADMINISTRATOR.equals(userInRole)) {
			if(!taskKind.equals(TaskInfor.TASK_KIND_ALL+""))
	        {
				sql2 = sql2 + " and task_kind='" + taskKind+"' ";
	        	
	        }
			if(!taskState.equals(TaskInfor.TASK_STATUS_ALL+""))
	        {
				sql2 = sql2 + " and task_status='" + taskState+"' ";
	        	
	        }
	        if(!appSource.equals(TaskInfor.APP_CODE_All))
	        {
	        	sql2 = sql2 + "and task_app_src='"+ appSource + "' ";
	        	
	        }
	        if (taskSubject != null && !"".equals(taskSubject.trim())) {
				sql2 = sql2 + " and task_subject like '%" + taskSubject.trim() + "%'";
			}

	        sql2 = sql2 + ") where rk between " + minRow + " and " + maxRow + "";
	        //System.out.println(sql2);
			
			
			
			
			
			/*
			if ((taskSubject == null || taskSubject.trim().equals(""))&&(!taskKind.equals(TaskInfor.TASK_KIND_ALL+""))&&(!appSource.equals(TaskInfor.APP_CODE_All))) {
				sql = TaskMonitorUtil.taskMonitorListSql2;
				pstmt = con.prepareStatement(sql);

				pstmt.setInt(1, Integer.parseInt(taskKind));
				pstmt.setString(2, appSource);
				pstmt.setString(3, taskState);
				pstmt.setString(4, startTime1 + " 00:00:00");
				pstmt.setString(5, startTime2 + " 23:59:59");
				pstmt.setInt(6, minRow);
				pstmt.setInt(7, maxRow);

			} else {
				sql = TaskMonitorUtil.taskMonitorListSql1;
				pstmt = con.prepareStatement(sql);

				pstmt.setInt(1, Integer.parseInt(taskKind));
				pstmt.setString(2, appSource);
				pstmt.setString(3, taskState);
				pstmt.setString(4, startTime1 + " 00:00:00");
				pstmt.setString(5, startTime2 + " 23:59:59");
				pstmt.setString(6, "%" + taskSubject + "%");
				pstmt.setInt(7, minRow);
				pstmt.setInt(8, maxRow);

			}*/
		} else if (TaskInfor.DEP_ADMINISTRATOR.equals(userInRole)) { // 办事处管理员
			String deptId = UserInfor.getDeptCodeByUserId(userId);
			if(!taskKind.equals(TaskInfor.TASK_KIND_ALL+""))
	        {
				sql2 = sql2 + " and task_kind='" + taskKind+"' ";
	        	
	        }
	        if(!appSource.equals(TaskInfor.APP_CODE_All))
	        {
	        	sql2 = sql2 + "and task_app_src='"+ appSource + "' ";
	        	
	        }
	        if(!taskState.equals(TaskInfor.TASK_STATUS_ALL+""))
	        {
				sql2 = sql2 + " and task_status='" + taskState+"' ";
	        	
	        }
	        if (taskSubject != null && !"".equals(taskSubject.trim())) {
				sql2 = sql2 + " and task_subject like '%" + taskSubject.trim() + "%'";
			}
	        sql2 = sql2 + "and dept_code='"+ deptId + "' ";

	        sql2 = sql2 + ") where rk between " + minRow + " and " + maxRow + "";
	        //System.out.println(sql2);
			/*
			"select * from (select rownum, TASK_TODOLIST.*,"
			+ " row_number() over (order by task_app_src, task_assignee_time desc) rk"
			+ " from cinda_task.TASK_TODOLIST where task_kind=? and task_app_src=? and dept_code=? and task_status=?"
			+ " and (task_assignee_time between ? and ?))"
			+ " where rk between ? and ?";
			/*
			if (taskSubject == null || taskSubject.trim().equals("")) {
				sql = TaskMonitorUtil.taskMonitorListSql4;
				pstmt = con.prepareStatement(sql);

				String deptId = UserInfor.getDeptCodeByUserId(userId);

				pstmt.setInt(1, Integer.parseInt(taskKind));
				pstmt.setString(2, appSource);
				pstmt.setString(3, deptId);
				pstmt.setString(4, taskState);
				pstmt.setString(5, startTime1 + " 00:00:00");
				pstmt.setString(6, startTime2 + " 23:59:59");
				pstmt.setInt(7, minRow);
				pstmt.setInt(8, maxRow);

			} else {
				sql = TaskMonitorUtil.taskMonitorListSql3;
				pstmt = con.prepareStatement(sql);

				String deptId = UserInfor.getDeptCodeByUserId(userId);

				pstmt.setInt(1, Integer.parseInt(taskKind));
				pstmt.setString(2, appSource);
				pstmt.setString(3, deptId);
				pstmt.setString(4, taskState);
				pstmt.setString(5, startTime1 + " 00:00:00");
				pstmt.setString(6, startTime2 + " 23:59:59");
				pstmt.setString(7, "%" + taskSubject + "%");
				pstmt.setInt(8, minRow);
				pstmt.setInt(9, maxRow);

			}*/
		}
		return sql2;
	}

	// 初始化监控列表记录条数sql
	private String initStatementCount(Connection con,
			Properties selcon, String userId) throws SQLException {
		//String sql = "";
		//PreparedStatement pstmt = null;

		String userInRole = selcon.getProperty("userInRole");
		String taskSubject = selcon.getProperty("taskSubject");
		String taskKind = selcon.getProperty("taskKind");
		String appSource = selcon.getProperty("appSource");
		String taskState = selcon.getProperty("taskState");
		String startTime1 = selcon.getProperty("startTime1");
		String startTime2 = selcon.getProperty("startTime2");
		startTime1 = startTime1 + " 00:00:00";
		startTime2 = startTime2 + " 23:59:59";
		
		String sql2 = "select count(*) from cinda_task.TASK_TODOLIST"
			+ " where (task_assignee_time between '"+ startTime1 
		    + "' and '" + startTime2 + "')";
		
		
		
		
		/*String sql2="select count(*) from (select rownum, TASK_TODOLIST.*,"
			+ " row_number() over (order by task_app_src, task_assignee_time desc) rk"
			+ " from cinda_task.TASK_TODOLIST where (task_assignee_time between '"+ startTime1+"' and '"+startTime2+"')";
*/
		// 总公司管理员
		if (TaskInfor.SYSTEM_ADMINISTRATOR.equals(userInRole)) {
			if(!taskKind.equals(TaskInfor.TASK_KIND_ALL+""))
	        {
				sql2 = sql2 + " and task_kind='" + taskKind+"' ";
	        	
	        }
			if(!taskState.equals(TaskInfor.TASK_STATUS_ALL+""))
	        {
				sql2 = sql2 + " and task_status='" + taskState+"' ";
	        	
	        }
	        if(!appSource.equals(TaskInfor.APP_CODE_All))
	        {
	        	sql2 = sql2 + "and task_app_src='"+ appSource + "' ";
	        	
	        }
	        if (taskSubject != null && !"".equals(taskSubject.trim())) {
				sql2 = sql2 + " and task_subject like '%" + taskSubject.trim() + "%'";
			}

	        //System.out.println(sql2);
			/*
			if (taskSubject == null || taskSubject.trim().equals("")) {
				sql = TaskMonitorUtil.taskMonitorCountSql2;
				pstmt = con.prepareStatement(sql);

				pstmt.setInt(1, Integer.parseInt(taskKind));
				pstmt.setString(2, appSource);
				pstmt.setString(3, taskState);
				pstmt.setString(4, startTime1 + " 00:00:00");
				pstmt.setString(5, startTime2 + " 23:59:59");

			} else {
				sql = TaskMonitorUtil.taskMonitorCountSql1;
				pstmt = con.prepareStatement(sql);

				pstmt.setInt(1, Integer.parseInt(taskKind));
				pstmt.setString(2, appSource);
				pstmt.setString(3, taskState);
				pstmt.setString(4, startTime1 + " 00:00:00");
				pstmt.setString(5, startTime2 + " 23:59:59");
				pstmt.setString(6, "%" + taskSubject + "%");

			}*/
		} else if (TaskInfor.DEP_ADMINISTRATOR.equals(userInRole)) 
		{ 
			// 办事处管理员
			String deptId = UserInfor.getDeptCodeByUserId(userId);
			if(!taskKind.equals(TaskInfor.TASK_KIND_ALL+""))
	        {
				sql2 = sql2 + " and task_kind='" + taskKind+"' ";
	        	
	        }
	        if(!appSource.equals(TaskInfor.APP_CODE_All))
	        {
	        	sql2 = sql2 + "and task_app_src='"+ appSource + "' ";
	        	
	        }
	        if(!taskState.equals(TaskInfor.TASK_STATUS_ALL+""))
	        {
				sql2 = sql2 + " and task_status='" + taskState+"' ";
	        	
	        }
	        if (taskSubject != null && !"".equals(taskSubject.trim())) {
				sql2 = sql2 + " and task_subject like '%" + taskSubject.trim() + "%'";
			}
	        sql2 = sql2 + "and dept_code='"+ deptId + "' ";

	        //System.out.println(sql2);
			
			
			
			
			/*
			if (taskSubject == null || taskSubject.trim().equals("")) {
				sql = TaskMonitorUtil.taskMonitorCountSql4;
				pstmt = con.prepareStatement(sql);

				String deptId = UserInfor.getDeptCodeByUserId(userId);

				pstmt.setInt(1, Integer.parseInt(taskKind));
				pstmt.setString(2, appSource);
				pstmt.setString(3, deptId);
				pstmt.setString(4, taskState);
				pstmt.setString(5, startTime1 + " 00:00:00");
				pstmt.setString(6, startTime2 + " 23:59:59");

			} else {
				sql = TaskMonitorUtil.taskMonitorCountSql3;
				pstmt = con.prepareStatement(sql);

				String deptId = UserInfor.getDeptCodeByUserId(userId);

				pstmt.setInt(1, Integer.parseInt(taskKind));
				pstmt.setString(2, appSource);
				pstmt.setString(3, deptId);
				pstmt.setString(4, taskState);
				pstmt.setString(5, startTime1 + " 00:00:00");
				pstmt.setString(6, startTime2 + " 23:59:59");
				pstmt.setString(7, "%" + taskSubject + "%");

			}*/
		}

		return sql2;
	}

}
