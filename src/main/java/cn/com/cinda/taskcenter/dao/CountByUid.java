package cn.com.cinda.taskcenter.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import org.apache.log4j.Logger;

import cn.com.cinda.taskcenter.common.GloabVar;
import cn.com.cinda.taskcenter.model.Task;

public class CountByUid {
	private static Logger log = Logger.getLogger(TaskDAO.class);

	public static final SimpleDateFormat formatter = new SimpleDateFormat(
			"yyyy-MM-dd HH:mm:ss");

	public String AllcountTimeSql(String uid) {
		String AllcountTime = "";
		AllcountTime = "select sum(((to_date(TASK_SUBMIT_TIME,'yyyy-mm-dd   hh24:mi:ss') - to_date(TASK_ASSIGNEE_TIME,'yyyy-mm-dd   hh24:mi:ss'))*24)) as s ,"
				+ "  avg(((to_date(TASK_SUBMIT_TIME,'yyyy-mm-dd   hh24:mi:ss') - to_date(TASK_ASSIGNEE_TIME,'yyyy-mm-dd   hh24:mi:ss'))*24)) as a "
				+ " from  cinda_task.task_todolist where   TASK_EXECUTOR = '"
				+ uid.trim()
				+ "'";
		return AllcountTime;
	}

	/**
	 * 统计时间的方法 统计页面使用
	 * 
	 * @return Task 返回VO
	 */
	public Task get_Task_count_Time(String sqlCount) {
		DbConnection dbconn = new DbConnection();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Task p = null;
		con = dbconn.getConnection();
		log.debug("统计所有任务数量的SQL语句是：" + sqlCount);
		try {
			pstmt = con.prepareStatement(sqlCount);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				p = new Task();
				p.setTimeAll(rs.getFloat("s"));
				p.setTimeAvg(rs.getFloat("a"));

			}
		} catch (SQLException ex) {
			log.error("SQL查询当前应用的发送方式失败", ex);
		} finally {
			try {
				if (pstmt != null) {
					pstmt.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException ex1) {
				log.error("关闭连接失败", ex1);
			}
		}
		return p;
	}

	/**
	 * 对task_todolist表中按照查询代办的数量，按照应用来源分类
	 * 
	 * @param String
	 *            uid当前用户
	 * @return ArrayList 最终返回更新结果
	 */
	public static ArrayList get_TodoTask_count_byUser(String uid) {
		ArrayList Result = new ArrayList();
		Connection con = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		String sql = "select task_app_src ,APP_VAR_5, "
				+ "sum(case TASK_STATUS when '" + GloabVar.TASK_STATUS_READED
				+ "'    then 1 else 0 end) + sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_ASSIGNED
				+ "' then 1 else 0 end)+sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_APPED
				+ "' then 1 else 0 end) as countF "
				+ " from cinda_task.task_todolist where 1=1 "
				+ " and  (TASK_ASSIGNEER like '%" + uid
				+ "%' or task_confirmor='" + uid + "')"
				+ " group by  task_app_src  ,APP_VAR_5  order by task_app_src ";
		log.debug("用户统计任务数量的SQL是：" + sql);
		try {
			psdSelect = con.prepareStatement(sql);
			rs = psdSelect.executeQuery();
			while (rs.next()) {
				Task p = new Task();
				p.setTask_app_src(rs.getString("task_app_src"));
				p.setApp_var_5(rs.getString("app_var_5"));
				p.setCountF(rs.getInt("countF"));// 待办事宜共计

				Result.add(p);
			}
		} catch (SQLException ex) {
			log.error("获取未处理消息出错，错误如下： " + ex.getMessage());
		} finally {
			try {
				if (psdSelect != null) {
					psdSelect.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException ex1) {
				ex1.printStackTrace();
				log.error("关闭连接失败");
			}
		}
		return Result;
	}

	/**
	 * 对task_todolist表中按照查询已办的数量，按照应用来源分类
	 * 
	 * @param String
	 *            uid当前用户
	 * @return ArrayList 最终返回更新结果
	 */
	public static ArrayList get_HaddoTask_count_byUser(String uid) {
		ArrayList Result = new ArrayList();
		Connection con = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		String sql = "select task_app_src ,APP_VAR_5, count(*) as countE from cinda_task.task_todolist "
				+ "where TASK_STATUS = '"
				+ GloabVar.TASK_STATUS_FINISHED
				+ "'"
				+ " and  task_executor='"
				+ uid.trim()
				+ "' group by  task_app_src  ,APP_VAR_5  order by task_app_src ";
		log.debug("用户统计任务数量的SQL是：" + sql);
		try {
			psdSelect = con.prepareStatement(sql);
			rs = psdSelect.executeQuery();
			while (rs.next()) {
				Task p = new Task();
				p.setTask_app_src(rs.getString("task_app_src"));
				p.setApp_var_5(rs.getString("app_var_5"));
				p.setCountE(rs.getInt("countE"));// 待办事宜共计

				Result.add(p);
			}
		} catch (SQLException ex) {
			log.error("获取未处理消息出错，错误如下： " + ex.getMessage());
		} finally {
			try {
				if (psdSelect != null) {
					psdSelect.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException ex1) {
				ex1.printStackTrace();
				log.error("关闭连接失败");
			}
		}
		return Result;
	}

}
