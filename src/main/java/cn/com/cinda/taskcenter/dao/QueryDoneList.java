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
import cn.com.cinda.taskcenter.util.TaskUtil;

/**
 * 查询已办列表
 * 
 * @author hkgt
 * 
 */
public class QueryDoneList {
	private static final SimpleDateFormat FORMAT = new SimpleDateFormat(
			"yyyy-MM-dd HH:mm:ss");

	private Logger log = Logger.getLogger(this.getClass());

	/**
	 * 查询已办列表
	 * 
	 * @param common
	 *            分页信息
	 * @param sql
	 *            查询语句
	 * @param userId
	 *            用户id
	 * @return
	 */
	public List getDoneList(CommonPara common, String sql, String userId) {
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
			pstmt = con.prepareStatement(TaskUtil.sqlCountDone);

			pstmt.setString(1, userId);
			pstmt.setString(2, TaskInfor.TASK_STATUS_FINISHED + "");

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

			pstmt = con.prepareStatement(sql);

			pstmt.setString(1, userId);
			pstmt.setString(2, TaskInfor.TASK_STATUS_FINISHED + "");
			pstmt.setInt(3, minRow);
			pstmt.setInt(4, maxRow);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				Task task = new Task();

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
				String time = rs.getString("task_assignee_time");
				time = time.substring(5, 16);
				task.setTask_assignee_time(time);
				task.setTask_assigneer(TaskUtil.replaceNull(UserInfor
						.getUserNameById(rs.getString("task_assigneer"))));
				task.setTask_batch_id(rs.getString("task_batch_id"));
				task.setTask_batch_name(rs.getString("task_batch_name"));
				task.setTask_cc(rs.getString("task_cc"));

				task.setTask_creator(rs.getString("task_creator"));
				task.setTask_comments(rs.getString("task_comments"));
				task.setTask_confirm_time(rs.getString("task_confirm_time"));
				task.setTask_confirmor(rs.getString("task_confirmor"));
				task.setTask_content(rs.getString("task_content"));
				task.setTask_create_time(rs.getString("task_create_time"));

				task.setTask_designator(rs.getString("task_designator"));
				task.setTask_executor(rs.getString("task_executor"));
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
				task.setTask_msg_status(new Integer(rs.getInt("task_msg_status")));
				task.setTask_result_code(rs.getString("task_result_code"));
				task.setTask_stage_name(rs.getString("task_stage_name"));
				task.setTask_status(rs.getString("task_status"));
				String subject = rs.getString("task_subject");
				if (subject == null) {
					subject = "";
				}
				task.setTask_subject(subject);

				task.setTask_submit(rs.getString("task_submit"));
				task.setTask_submit_time(rs.getString("task_submit_time"));

				// 应用自定义状态
				task.setTask_app_state(rs.getString("task_app_state"));
				// link
				String linkType = rs.getString("task_link_type");
				String task_link_format = TaskLinkUtil.getTaskLink(linkType,
						LinkHelper.getLinkTypeMap(), task);
				task.setTask_link_format(task_link_format);

				taskList.add(task);
			}

			return taskList;
		} catch (SQLException ex) {
			log.error(ex);
		} finally {
			ConnectionPool.release(null, null, pstmt, con);
		}

		return taskList;
	}

	/**
	 * 查询已办列表
	 * 
	 * @param common
	 *            分页信息
	 * @param selcon
	 *            查询条件
	 * @return
	 */
	public List getDoneList(CommonPara common, Properties selcon) {
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
			pstmt = con.prepareStatement(getQuerySqlCount(selcon));

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

			pstmt = con.prepareStatement(getQuerySql(selcon, minRow, maxRow));

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

				p.setTask_creator(rs.getString("task_creator"));
				p.setTask_comments(rs.getString("task_comments"));
				p.setTask_confirm_time(rs.getString("task_confirm_time"));
				p.setTask_confirmor(rs.getString("task_confirmor"));
				p.setTask_content(rs.getString("task_content"));
				p.setTask_create_time(rs.getString("task_create_time"));

				p.setTask_designator(rs.getString("task_designator"));
				p.setTask_executor(rs.getString("task_executor"));
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
				p.setTask_submit_time(rs.getString("task_submit_time"));

				// 应用自定义状态
				p.setTask_app_state(rs.getString("task_app_state"));
				// link
				String linkType = rs.getString("task_link_type");
				String task_link_format = TaskLinkUtil.getTaskLink(linkType,
						LinkHelper.getLinkTypeMap(), p);
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

	/**
	 * 根据查询条件获得记录数的sql
	 * 
	 * @param selcon
	 * @return
	 */
	private String getQuerySqlCount(Properties selcon) {
		String userId = selcon.getProperty("userId");
		String taskSubject = selcon.getProperty("taskSubject");
		String taskKind = selcon.getProperty("taskKind");
		String appSource = selcon.getProperty("appSource");
		String taskState = selcon.getProperty("taskState");
		String startTime1 = selcon.getProperty("startTime1");
		String startTime2 = selcon.getProperty("startTime2");
		
		startTime1 = startTime1 + " 00:00:00";
		startTime2 = startTime2 + " 23:59:59";

		String stageName = selcon.getProperty("stageName");
        
		// 根据查询条件获得sql
		String sql = "select count(*) from cinda_task.TASK_TODOLIST"
				+ " where task_executor='" + userId + "' and task_status='"
				+ taskState + "'" + " and task_batch_name is not null"
			    + " and (task_assignee_time between '"+ startTime1 
			    + "' and '" + startTime2 + "')";
		//System.out.println("sql="+sql);
		/*String sql = "select count(*) from cinda_task.TASK_TODOLIST"
			+ " where task_executor='" + userId + "' and task_status='"
			+ taskState + "'" + " and task_batch_name is not null"
			+ " and task_kind='" + taskKind + "' and task_app_src='"
			+ appSource + "'" + " and (task_assignee_time between '"
			+ startTime1 + "' and '" + startTime2 + "')";*/
        if(!taskKind.equals(TaskInfor.TASK_KIND_ALL+""))
        {
        	sql = sql + " and task_kind='" + taskKind+"' ";
        	
        }
        if(!appSource.equals(TaskInfor.APP_CODE_All))
        {
        	sql = sql + "and task_app_src='"+ appSource + "' ";
        	
        }

		if (taskSubject != null && !"".equals(taskSubject.trim())) {
			sql = sql + " and task_subject like '%" + taskSubject.trim() + "%'";
		}
		if (stageName != null && !"".equals(stageName.trim())) {
			sql = sql + " and task_stage_name like '%" + stageName.trim()
					+ "%'";
		}
		//System.out.println("sql="+sql);
		log.info(sql);
       
		return sql;
	}

	/**
	 * 根据查询条件、最小行和最大行获得查询结果的sql
	 * 
	 * @param selcon
	 * @param minRow
	 * @param maxRow
	 * @return
	 */
	private String getQuerySql(Properties selcon, int minRow, int maxRow) {
		String userId = selcon.getProperty("userId");
		String taskSubject = selcon.getProperty("taskSubject");
		String taskKind = selcon.getProperty("taskKind");
		String appSource = selcon.getProperty("appSource");
		String taskState = selcon.getProperty("taskState");
		String startTime1 = selcon.getProperty("startTime1");
		String startTime2 = selcon.getProperty("startTime2");

		startTime1 = startTime1 + " 00:00:00";
		startTime2 = startTime2 + " 23:59:59";

		String stageName = selcon.getProperty("stageName");

		// 根据查询条件获得sql
		//changed by fjh 20070625,修改查询条件，增加了查询所有的情况
		String sql = "select * from (select rownum, TASK_TODOLIST.*,"
				+ " row_number() over (order by task_assignee_time desc) rk"
				+ " from cinda_task.TASK_TODOLIST" + " where task_executor='" + userId
				+ "' and task_status='" + taskState + "'"
				+ " and task_batch_name is not null" + " and (task_assignee_time between '" + startTime1 + "' and '"
				+ startTime2 + "')";
		/*String sql = "select * from (select rownum, TASK_TODOLIST.*,"
		+ " row_number() over (order by task_app_src, task_assignee_time desc) rk"
		+ " from cinda_task.TASK_TODOLIST" + " where task_executor='" + userId
		+ "' and task_status='" + taskState + "'"
		+ " and task_batch_name is not null" + " and task_kind='"
		+ taskKind + "' and task_app_src='" + appSource + "'"
		+ " and (task_assignee_time between '" + startTime1 + "' and '"
		+ startTime2 + "')";*/
		if(!taskKind.equals(TaskInfor.TASK_KIND_ALL+""))
        {
        	sql = sql + " and task_kind='" + taskKind+"' ";
        }
        if(!appSource.equals(TaskInfor.APP_CODE_All))
        {
        	sql = sql + "and task_app_src='"+ appSource + "' ";
        }

		if (taskSubject != null && !"".equals(taskSubject.trim())) {
			sql = sql + " and task_subject like '%" + taskSubject.trim() + "%'";
		}
		if (stageName != null && !"".equals(stageName.trim())) {
			sql = sql + " and task_stage_name like '%" + stageName.trim()
					+ "%'";
		}
		sql = sql + ") where rk between " + minRow + " and " + maxRow + "";

		log.info(sql);
		
		return sql;
	}
}
