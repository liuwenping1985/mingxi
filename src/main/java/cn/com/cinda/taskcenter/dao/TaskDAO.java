package cn.com.cinda.taskcenter.dao;

import org.apache.log4j.Logger;

/*import cn.com.cinda.rtx.impl.MsgService;
import cn.com.cinda.rtx.impl.MsgServiceFactory;*/

import cn.com.cinda.taskcenter.common.GloabVar;
import cn.com.cinda.taskcenter.model.Task;
import cn.com.cinda.taskcenter.util.UUID;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;

/**
 * <p>
 * Title:TaskDAO
 * </p>
 * 
 * <p>
 * Description: TaskDAO类
 * </p>
 * 
 * <p>
 * Copyright: Copyright (c) 2007
 * </p>
 * 
 * <p>
 * Company:
 * </p>
 * 
 * @author not attributable
 * @version 1.0
 */

public class TaskDAO {
	private static Logger log = Logger.getLogger(TaskDAO.class);

	public static final SimpleDateFormat formatter = new SimpleDateFormat(
			"yyyy-MM-dd HH:mm:ss");

	// 所有统计页面使用的统计SQL语句
	public String AllcountSql() {
		String countAll = "";
		countAll = "select count(*)a  from cinda_task.TASK_TODOLIST "
				+ "where TASK_STATUS in ('" + GloabVar.TASK_STATUS_ASSIGNED
				+ "' ,'" + GloabVar.TASK_STATUS_READED + "','"
				+ GloabVar.TASK_STATUS_APPED + "' )  "; // 待办
		return countAll;
	}

	public String AllcountSql2() {
		String countAll2 = "";
		countAll2 = "select count(*)a  from cinda_task.TASK_TODOLIST "
				+ "where TASK_STATUS = '" + GloabVar.TASK_STATUS_FINISHED + "'";// 已办
																				// return
																				// countDep;
		return countAll2;
	}

	public String AllcountTimeSql() {
		String AllcountTime = "";
		AllcountTime = "select sum(((to_date(TASK_SUBMIT_TIME,'yyyy-mm-dd   hh24:mi:ss') - to_date(TASK_ASSIGNEE_TIME,'yyyy-mm-dd   hh24:mi:ss'))*24)) as s ,"
				+ "  avg(((to_date(TASK_SUBMIT_TIME,'yyyy-mm-dd   hh24:mi:ss') - to_date(TASK_ASSIGNEE_TIME,'yyyy-mm-dd   hh24:mi:ss'))*24)) as a "
				+ " from cinda_task.TASK_TODOLIST "
				+ " where   TASK_SUBMIT_TIME   is   NOT   NULL and TASK_ASSIGNEE_TIME is   NOT   NUL";
		return AllcountTime;
	}

	// 所有统计页面使用的统计SQL语句
	public String AllcountSql3(String dep_code) {
		String countAll = "";
		countAll = "select count(*)a  from cinda_task.TASK_TODOLIST "
				+ "where TASK_STATUS in ('" + GloabVar.TASK_STATUS_ASSIGNED
				+ "' ,'" + GloabVar.TASK_STATUS_READED + "','"
				+ GloabVar.TASK_STATUS_APPED + "') and dept_code = '"
				+ dep_code.trim() + "'"; // 待办
		return countAll;
	}

	public String AllcountSql4(String dep_code) {
		String countAll2 = "";
		countAll2 = "select count(*)a  from cinda_task.TASK_TODOLIST "
				+ "where TASK_STATUS = '" + GloabVar.TASK_STATUS_FINISHED
				+ "' and dept_code = '" + dep_code.trim() + "'";// 已办 return
																// countDep;
		return countAll2;
	}

	public String AllcountTimeSql2(String dep_code) {
		String AllcountTime = "";
		AllcountTime = "select sum(((to_date(TASK_SUBMIT_TIME,'yyyy-mm-dd   hh24:mi:ss') - to_date(TASK_ASSIGNEE_TIME,'yyyy-mm-dd   hh24:mi:ss'))*24)) as s ,"
				+ "  avg(((to_date(TASK_SUBMIT_TIME,'yyyy-mm-dd   hh24:mi:ss') - to_date(TASK_ASSIGNEE_TIME,'yyyy-mm-dd   hh24:mi:ss'))*24)) as a "
				+ " from cinda_task.TASK_TODOLIST where  dept_code = '"
				+ dep_code.trim()
				+ "'";
		return AllcountTime;
	}

	// 所有统计页面使用的统计SQL语句
	public String AllcountSql(String uid) {
		String countAll = "";
		countAll = "select count(*)a  from cinda_task.TASK_TODOLIST "
				+ "where TASK_STATUS in('" + GloabVar.TASK_STATUS_ASSIGNED
				+ "' ,'" + GloabVar.TASK_STATUS_READED + "','"
				+ GloabVar.TASK_STATUS_APPED + "' )"
				//+ " and  TASK_EXECUTOR = '" + uid.trim() + "'"; // 待办
				+ " and  (TASK_ASSIGNEER like '%"+uid+"%' or TASK_CONFIRMOR = '"+uid+"')";
		return countAll;
	}

	public String AllcountSql2(String uid) {
		String countAll2 = "";
		countAll2 = "select count(*)a  from cinda_task.TASK_TODOLIST "
				+ "where TASK_STATUS = '" + GloabVar.TASK_STATUS_FINISHED + "'"
				+ " and  TASK_EXECUTOR = '" + uid.trim() + "'";// 已办 return
																// countDep;
		return countAll2;
	}

	public String AllcountTimeSql(String uid) {
		String AllcountTime = "";
		AllcountTime = "select sum(((to_date(TASK_SUBMIT_TIME,'yyyy-mm-dd   hh24:mi:ss') - to_date(TASK_ASSIGNEE_TIME,'yyyy-mm-dd   hh24:mi:ss'))*24)) as s ,"
				+ "  avg(((to_date(TASK_SUBMIT_TIME,'yyyy-mm-dd   hh24:mi:ss') - to_date(TASK_ASSIGNEE_TIME,'yyyy-mm-dd   hh24:mi:ss'))*24)) as a "
				+ " from cinda_task.TASK_TODOLIST where   TASK_EXECUTOR = '"
				+ uid.trim()
				+ "'";
		return AllcountTime;
	}

	public static String getTaskMessageID(String task_app_src,
			String taskid_value, String taskid_name) {
		String messageID = null;
		DbConnection dbconn = new DbConnection();
		Connection con = null;
		con = dbconn.getConnection();
		String sql = "select TASK_MSG_ID from cinda_task.TASK_TODOLIST where TASK_APP_SRC='"
				+ task_app_src
				+ "' and "
				+ taskid_name
				+ "='"
				+ taskid_value
				+ "'";
		log.debug("get MessageID SQL=" + sql);
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = dbconn.getConnection();// 获取连接
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next())
			{
				messageID = rs.getString("TASK_MSG_ID");
			}
			log.debug("get messageID=" + messageID);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (pstmt != null) {
					pstmt.close();
				}
				if (con != null) {
					con.close();
				}

			} catch (SQLException ex1) {
				ex1.printStackTrace();
				log.error("关闭连接失败");
			}

		}

		return messageID;

	}

	/**
	 * 向任务中心添加任务
	 * 
	 * @param Task
	 *            task 传入VO
	 */
	public static void addTask(Task task) throws Exception {
		// 将任务插入数据库
		DbConnection dbconn = new DbConnection();
		Connection con = null;
		PreparedStatement pstmt = null;
		log.debug("*****************任务中心插入数据库：**********************");

		// 插入语句
		String sql = "insert into cinda_task.TASK_TODOLIST "
				+ "( TASK_ID ,TASK_KIND ,TASK_BATCH_ID,TASK_STAGE_NAME,TASK_BATCH_NAME,TASK_SUBJECT ,"
				+ " TASK_CONTENT ,TASK_STATUS , TASK_CREATOR ,TASK_DESIGNATOR ,TASK_ASSIGNEER ,TASK_ASSIGNEE_RULE, "
				+ "TASK_CC, TASK_ALLOW_DELIVER , TASK_CONFIRMOR , TASK_EXECUTOR , TASK_SUBMIT,"
				+ "TASK_CREATE_TIME ,TASK_ASSIGNEE_TIME,TASK_CONFIRM_TIME , TASK_SUBMIT_TIME,"
				+ "TASK_RESULT_CODE , DEPT_CODE , TASK_COMMENTS,TASK_APP_SRC   ,"
				+ "TASK_APP_MOUDLE  , APP_VAR_1 , APP_VAR_2 , APP_VAR_3 , APP_VAR_4 ,"
				+ "APP_VAR_5 , APP_VAR_6 ,  APP_VAR_7 ,  APP_VAR_8, APP_VAR_9 ,"
				+ "TASK_MSG_ID, TASK_MSG_STATUS , TASK_LINK_TYPE, TASK_LINK2_NAME,TASK_LINK2_TYPE,"
				+ "TASK_LINK3_NAME ,TASK_LINK3_TYPE,TASK_LINK4_NAME ,TASK_LINK4_TYPE, TASK_LINK5_NAME,"
				+ "TASK_LINK5_TYPE ,DELFLAG ) " + "values(?,?,?,?,?,?,?,?,?,?,"
				+ "?,?,?,?,?,?,?,?,?,?," + "?,?,?,?,?,?,?,?,?,?,"
				+ "?,?,?,?,?,?,?,?,?,?," + "?,?,?,?,?,?,?)";
		log.debug("插入任务中心数据库的sql是：" + sql);

		try {
			con = dbconn.getConnection();// 获取连接
			pstmt = con.prepareStatement(sql);

			// 插入数据库
			pstmt.setString(1, task.getTask_id());
			pstmt.setInt(2, task.getTask_kind().intValue());
			pstmt.setString(3, task.getTask_batch_id());
			pstmt.setString(4, task.getTask_stage_name());
			pstmt.setString(5, task.getTask_batch_name());
			pstmt.setString(6, task.getTask_subject());

			pstmt.setString(7, task.getTask_content());
			pstmt.setString(8, task.getTask_status());// 插入数据库时的任务状态是“建立”task.getTask_status()
			pstmt.setString(9, task.getTask_creator());
			pstmt.setString(10, task.getTask_designator());
			pstmt.setString(11, task.getTask_assigneer());
			pstmt.setString(12, task.getTask_assignee_rule());
			pstmt.setString(13, task.getTask_cc());
			pstmt.setInt(14, task.getTask_allow_deliver().intValue());
			pstmt.setString(15, task.getTask_confirmor());
			pstmt.setString(16, task.getTask_executor());
			pstmt.setString(17, task.getTask_submit());

			pstmt.setString(18, task.getTask_create_time()); // 创建时间
			pstmt.setString(19, task.getTask_assignee_time());
			pstmt.setString(20, task.getTask_confirm_time());
			pstmt.setString(21, task.getTask_submit_time());

			pstmt.setString(22, task.getTask_result_code());// 默认结果
			pstmt.setString(23, task.getDept_code());
			pstmt.setString(24, task.getTask_comments());

			// pstmt.setString(25, task.getTask_app_src());
			pstmt.setString(25, (task.getTask_app_src()).toUpperCase());// toUpperCase()方法：将String转化成大写字母格式，并返回

			pstmt.setString(26, task.getTask_app_moudle());
			pstmt.setString(27, task.getApp_var_1());
			pstmt.setString(28, task.getApp_var_2());
			pstmt.setString(29, task.getApp_var_3());
			pstmt.setString(30, task.getApp_var_4());
			pstmt.setString(31, task.getApp_var_5());
			pstmt.setString(32, task.getApp_var_6());
			pstmt.setString(33, task.getApp_var_7());
			pstmt.setString(34, task.getApp_var_8());
			pstmt.setString(35, task.getApp_var_9());
			pstmt.setString(36, task.getTask_msg_id());
			pstmt.setInt(37, task.getTask_msg_status().intValue());
			pstmt.setString(38, task.getTask_link_type());
			pstmt.setString(39, task.getTask_link2_name());
			pstmt.setString(40, task.getTask_link2_type());
			pstmt.setString(41, task.getTask_link3_name());
			pstmt.setString(42, task.getTask_link3_type());
			pstmt.setString(43, task.getTask_link4_name());
			pstmt.setString(44, task.getTask_link4_type());
			pstmt.setString(45, task.getTask_link5_name());
			pstmt.setString(46, task.getTask_link5_type());
			pstmt.setInt(47, task.getDelflag().intValue());

			pstmt.executeUpdate();// 执行SQL语句
			log.debug("任务中心插入数据库成功！");

		} catch (SQLException ex) {
			log.error("任务中心插入数据库失败" + sql, ex);
		} finally {
			try {
				if (pstmt != null) {
					pstmt.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException ex1) {
				ex1.printStackTrace();
				log.error("关闭连接失败");
			}
		}

	}

	/**
	 * 根据taskid更新任务表
	 * 
	 * @param String
	 *            taskid 应用的标识
	 * @param int
	 *            state 更新状态
	 * @return boolean 最终返回更新结果
	 */
	public static boolean updateTaskState_taskid(String task_app_src,
			String taskid_value, String taskid_name, int state) {
		DbConnection dbconn = new DbConnection();
		Connection con = null;
		PreparedStatement pstmt = null;
		String updateSql = "";

		// 得到TASK_STATUS的状态，判断是分配、申领、完成，更新数据库中相应的分配、申领、完成的时间值
		// 生成当前时间
		Calendar cd = Calendar.getInstance();// 获取服务器的当前时间
		java.util.Date startDate = cd.getTime();// 格式化时间的格式
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String now = formatter.format(startDate).toString();// 把java.util.Date
		// 类型转化成String类型的
		if (state == GloabVar.TASK_STATUS_ASSIGNED) { // 已分配
			updateSql = ", TASK_ASSIGNEE_TIME = '" + now.trim() + "'  ";
		} else if (state == GloabVar.TASK_STATUS_APPED) { // 已申领
			updateSql = ", TASK_CONFIRM_TIME = '" + now.trim() + "'  ";
		} else if (state == GloabVar.TASK_STATUS_FINISHED) { // 已申领
			updateSql = ", TASK_SUBMIT_TIME = '" + now.trim() + "'  ";
		}
		TaskDAO taskdao = new TaskDAO();
		Task task = taskdao.get_taskVO(task_app_src, taskid_value, taskid_name);// 根据task_id得到任务详细记录
		String taskid = task.getTask_id();
		String sql = "update cinda_task.TASK_TODOLIST set TASK_STATUS=? " + updateSql
				+ " where task_id=?";
		log.debug("更新状态SQL语句" + sql);
		con = dbconn.getConnection();
		try {
			pstmt = con.prepareStatement(sql);

			pstmt.setInt(1, state);// 更新状态
			pstmt.setString(2, taskid);// 任务Id

			pstmt.executeUpdate();
			log.debug("SQL更新任务状态信息成功");
			return true; // 更新成功，返回true
		} catch (SQLException ex) {
			ex.printStackTrace();
			log.error("SQL更新任务状态信息失败");
			try {
				con.rollback();
				log.debug("数据库回滚");
			} catch (SQLException ex2) {
				ex2.printStackTrace();
				log.error("数据库回滚操作失败");
			}
			return false;// 更新失败,返回false
		} finally {
			try {
				if (pstmt != null) {
					pstmt.close();
				}
				if (con != null) {
					con.close();
				}
				log.debug("成功关闭连接");
			} catch (SQLException ex1) {
				ex1.printStackTrace();
				log.error("关闭连接失败");
			}
		}

	}

	public static boolean updateTaskMessage(String taskID, String messageID)
			throws Exception {
		boolean flag = false;
		DbConnection dbconn = new DbConnection();
		Connection con = null;
		con = dbconn.getConnection();
		PreparedStatement pstmt = null;
		String updateSql = "";
		updateSql = "update cinda_task.TASK_TODOLIST set TASK_MSG_ID= '" + messageID
				+ "'where TASK_ID='" + taskID + "'";// 更新数据库"
		log.debug("update messageID SQL=" + updateSql);
		try {
			pstmt = con.prepareStatement(updateSql);
			pstmt.executeUpdate();
			flag = true;
		} catch (Exception e) {
			log.error("update messageID appear error taskID=" + taskID);
			e.printStackTrace();
			throw e;
		} finally {
			try {
				if (pstmt != null) {
					pstmt.close();
				}
				if (con != null) {
					con.close();
				}
				log.debug("成功关闭连接");
			} catch (SQLException ex1) {
				ex1.printStackTrace();
				log.error("关闭连接失败");
			}
		}
		return flag;

	}

	/**
	 * 根据appTaskId更新任务表（默认使用app_var_1字段）
	 * 
	 * @param String
	 *            appTaskId 应用的标识
	 * @param int
	 *            state 更新状态
	 * @return boolean 最终返回更新结果
	 */
	public static boolean updateTaskState_appTaskId(String appTaskId, int state) {
		DbConnection dbconn = new DbConnection();
		Connection con = null;
		PreparedStatement pstmt = null;

		String updateSql = "";

		// 得到TASK_STATUS的状态，判断是分配、申领、完成，更新数据库中相应的分配、申领、完成的时间值
		// 生成当前时间
		Calendar cd = Calendar.getInstance();// 获取服务器的当前时间
		java.util.Date startDate = cd.getTime();// 格式化时间的格式
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String now = formatter.format(startDate).toString();// 把java.util.Date
		// 类型转化成String类型的
		if (state == GloabVar.TASK_STATUS_ASSIGNED) { // 已分配
			updateSql = ", TASK_ASSIGNEE_TIME = '" + now.trim() + "'  ";
		} else if (state == GloabVar.TASK_STATUS_APPED) { // 已申领
			updateSql = ", TASK_CONFIRM_TIME = '" + now.trim() + "'  ";
		} else if (state == GloabVar.TASK_STATUS_FINISHED) { // 已申领
			updateSql = ", TASK_SUBMIT_TIME = '" + now.trim() + "'  ";
		}

		String sql = "update cinda_task.TASK_TODOLIST set TASK_STATUS=? " + updateSql
				+ " where app_var_1=?";// 更新数据库，默认使用app_var_1字段
		log.debug("更新状态SQL语句" + sql);
		con = dbconn.getConnection();
		try {
			pstmt = con.prepareStatement(sql);

			pstmt.setInt(1, state);

			pstmt.setString(2, appTaskId);

			pstmt.executeUpdate();
			log.debug("SQL更新任务状态信息成功");
			return true;
		} catch (SQLException ex) {
			ex.printStackTrace();
			log.error("SQL更新任务状态信息失败");
			try {
				con.rollback();
				log.debug("数据库回滚");
			} catch (SQLException ex2) {
				ex2.printStackTrace();
				log.error("数据库回滚操作失败");
			}
			return false;
		} finally {
			try {
				if (pstmt != null) {
					pstmt.close();
				}
				if (con != null) {
					con.close();
				}
				log.debug("成功关闭连接");
			} catch (SQLException ex1) {
				ex1.printStackTrace();
				log.error("关闭连接失败");
			}
		}

	}

	/**
	 * 根据HashMap appVar更新任务表（默认使用app_var_1字段）
	 * 
	 * @param HashMap
	 *            appVar应用的标识
	 * @param int
	 *            state 更新状态
	 * @return boolean 最终返回更新结果
	 */
	public static boolean updateTaskState(HashMap appVar, int state) {

		DbConnection dbconn = new DbConnection();
		Connection con = null;
		PreparedStatement pstmt = null;
		String updateSql = "";
		// 得到TASK_STATUS的状态，判断是分配、申领、完成，更新数据库中相应的分配、申领、完成的时间值
		// 生成当前时间
		Calendar cd = Calendar.getInstance();// 获取服务器的当前时间
		java.util.Date startDate = cd.getTime();// 格式化时间的格式
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String now = formatter.format(startDate).toString();// 把java.util.Date
		// 类型转化成String类型的

		if (state == GloabVar.TASK_STATUS_ASSIGNED) { // 已分配
			updateSql = ", TASK_ASSIGNEE_TIME = '" + now.trim() + "'  ";
		} else if (state == GloabVar.TASK_STATUS_APPED) { // 已申领
			updateSql = ", TASK_CONFIRM_TIME = '" + now.trim() + "'  ";
		} else if (state == GloabVar.TASK_STATUS_FINISHED) { // 已申领
			updateSql = ", TASK_SUBMIT_TIME = '" + now.trim() + "'  ";
		}

		String app_Var_i;
		Set set = appVar.keySet();// 获取全部键
		Iterator iterator = set.iterator();
		String sqlWhere = " where 1=1 "; // 更新语句的条件

		for (int i = 0; iterator.hasNext(); i++) {
			app_Var_i = (String) iterator.next(); // 将获取的key赋值给变量appVar_i
			sqlWhere += " and " + app_Var_i + " = '"
					+ ((String) appVar.get(app_Var_i)).trim() + "'"; // 拼接SQL语句
		}

		String sql = "update cinda_task.TASK_TODOLIST set TASK_STATUS= '" + state
				+ updateSql + "'" + sqlWhere;// 更新数据库
		log.debug("更新状态SQL语句" + sql);
		con = dbconn.getConnection();
		try {
			pstmt = con.prepareStatement(sql);
			pstmt.executeUpdate();// 执行更新语句
			log.debug("SQL更新任务状态信息成功");
			return true;
		} catch (SQLException ex) {
			ex.printStackTrace();
			log.error("SQL更新任务状态信息失败");
			try {
				con.rollback();
				log.debug("数据库回滚");
			} catch (SQLException ex2) {
				ex2.printStackTrace();
				log.error("数据库回滚操作失败");
			}
			return false;
		} finally {
			try {
				if (pstmt != null) {
					pstmt.close();
				}
				if (con != null) {
					con.close();
				}
				log.debug("成功关闭连接");
			} catch (SQLException ex1) {
				ex1.printStackTrace();
				log.error("关闭连接失败");
			}

		}

	}

	/**
	 * 更新任务表（根据app_var_2字段批量更新task_subject字段）
	 * 
	 * @param String
	 *            app_var_2 WorkFlowID
	 * @return boolean 最终返回更新结果
	 */
	public static boolean UpdateTaskSubject(String task_subject,
			String app_var_2) {

		DbConnection dbconn = new DbConnection();
		Connection con = null;
		PreparedStatement pstmt = null;

		String sql = "update cinda_task.TASK_TODOLIST set TASK_SUBJECT = '" + task_subject
				+ "' where APP_VAR_2 = '" + app_var_2 + "'";

		log.debug("更新任务主题SQL语句" + sql);
		con = dbconn.getConnection();
		try {
			pstmt = con.prepareStatement(sql);
			pstmt.executeUpdate();// 执行更新语句
			log.debug("SQL更新任务主题成功");
			return true;
		} catch (SQLException ex) {
			ex.printStackTrace();
			log.error("SQL更新任务主题失败");
			try {
				con.rollback();
				log.debug("数据库回滚");
			} catch (SQLException ex2) {
				ex2.printStackTrace();
				log.error("数据库回滚操作失败");
			}
			return false;
		} finally {
			try {
				if (pstmt != null) {
					pstmt.close();
				}
				if (con != null) {
					con.close();
				}
				log.debug("成功关闭连接");
			} catch (SQLException ex1) {
				ex1.printStackTrace();
				log.error("关闭连接失败");
			}

		}

	}

	public static boolean removeTask(String task_app_src, String app_var_name,
			String app_var_Value) throws Exception {

		DbConnection dbconn = new DbConnection();
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = "delete from cinda_task.TASK_TODOLIST  where " + app_var_name
				+ " = '" + app_var_Value + "' and TASK_APP_SRC = '"
				+ task_app_src.trim() + "'";
		;
		log.debug("删除任务SQL语句" + sql);
		con = dbconn.getConnection();
		try {
			pstmt = con.prepareStatement(sql);
			pstmt.executeUpdate();// 执行更新语句
			log.debug("SQL删除任务成功");
			return true;
		} catch (SQLException ex) {
			ex.printStackTrace();
			log.error("SQL更新任务主题失败");
			throw new Exception();
		} finally {
			try {
				if (pstmt != null) {
					pstmt.close();
				}
				if (con != null) {
					con.close();
				}
				log.debug("成功关闭连接");
			} catch (SQLException ex1) {
				ex1.printStackTrace();
				log.error("关闭连接失败");
			}

		}

	}

	/**
	 * 更新任务表（根据app_var_2字段批量更新task_subject字段）
	 * 
	 * @param String
	 *            app_var_2 WorkFlowID
	 * @return boolean 最终返回更新结果
	 */
	public static boolean UpdateTaskSubject(String task_app_src,
			String workFlowid_value, String workFlowid_name, String task_subject) {

		DbConnection dbconn = new DbConnection();
		Connection con = null;
		PreparedStatement pstmt = null;
		// TaskDAO taskdao = new TaskDAO();
		// Task task =
		// taskdao.get_taskVO(task_app_src,workFlowid_value,workFlowid_name);//根据task_id得到任务详细记录
		// String task_id = task.getTask_id();
		String sql = "update cinda_task.TASK_TODOLIST set TASK_SUBJECT = '" + task_subject
				+ "' where " + workFlowid_name + " = " + "'" + workFlowid_value
				+ "'" + " and TASK_APP_SRC = '" + task_app_src.trim() + "'";

		log.debug("更新任务主题SQL语句" + sql);
		con = dbconn.getConnection();
		try {
			pstmt = con.prepareStatement(sql);
			pstmt.executeUpdate();// 执行更新语句
			log.debug("SQL更新任务主题成功");
			return true;
		} catch (SQLException ex) {
			ex.printStackTrace();
			log.error("SQL更新任务主题失败");
			try {
				con.rollback();
				log.debug("数据库回滚");
			} catch (SQLException ex2) {
				ex2.printStackTrace();
				log.error("数据库回滚操作失败");
			}
			return false;
		} finally {
			try {
				if (pstmt != null) {
					pstmt.close();
				}
				if (con != null) {
					con.close();
				}
				log.debug("成功关闭连接");
			} catch (SQLException ex1) {
				ex1.printStackTrace();
				log.error("关闭连接失败");
			}

		}

	}

	public static boolean UpdateTaskBatchState(String task_app_src,
			String app_var_name, String app_var_value, String task_Batch)
			throws Exception {

		DbConnection dbconn = new DbConnection();
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = "update cinda_task.TASK_TODOLIST set TASK_BATCH_NAME = '"
				+ task_Batch + "' where " + app_var_name + " = " + "'"
				+ app_var_value.trim() + "'" + " and TASK_APP_SRC = '"
				+ task_app_src.trim() + "'";

		log.debug("更新任务批次SQL语句" + sql);
		con = dbconn.getConnection();
		try {
			pstmt = con.prepareStatement(sql);
			pstmt.executeUpdate();// 执行更新语句
			log.debug("SQL更新任务主题成功");

		} catch (SQLException ex) {
			throw new Exception(ex);

		} finally {
			try {
				if (pstmt != null) {
					pstmt.close();
				}
				if (con != null) {
					con.close();
				}
				log.debug("成功关闭连接");
			} catch (SQLException ex1) {
				ex1.printStackTrace();
				log.error("关闭连接失败");
			}

		}
		return true;

	}

	/**
	 * 更新任务表（根据task_id字段更新task_executor字段）
	 * 
	 * @param String
	 *            task_id 任务ID
	 * @return boolean 最终返回更新结果
	 */
	public static boolean UpdateTaskExecutor(String task_app_src,
			String taskid_value, String taskid_name, String task_executor) {

		DbConnection dbconn = new DbConnection();
		Connection con = null;
		PreparedStatement pstmt = null;

		TaskDAO taskdao = new TaskDAO();
		Task task = taskdao.get_taskVO(task_app_src, taskid_value, taskid_name);// 根据task_id得到任务详细记录
		String task_id = task.getTask_id();
		String task_deliver = task.getTask_executor();// 获得任务的转交者
		boolean insertJudge = false;
		try {
			insertJudge = taskdao.InsertTask_deliver(task_id, task_deliver,
					task_executor);
		} catch (Exception e) {
			System.out.println("插入任务日志表的返回结果是：" + insertJudge + "，插入有误！");
			e.printStackTrace();
		}
		// -----------更新TASK_TODOLIST表的SQL语句
		String sqlUpdate = "update cinda_task.TASK_TODOLIST set TASK_EXECUTOR ='"
				+ task_executor.trim() + "' where TASK_ID = '" + task_id.trim()
				+ "'";
		log.debug("更新任务主题SQL语句" + sqlUpdate);

		con = dbconn.getConnection();// 获得数据库的链接
		try {
			pstmt = con.prepareStatement(sqlUpdate);
			pstmt.executeUpdate();// 执行更新语句
			log.debug("SQL更新任务执行者成功");

			return true;
		} catch (SQLException ex) {
			ex.printStackTrace();
			log.error("SQL更新任务action code 失败");
			try {
				con.rollback();
				log.debug("数据库回滚");
			} catch (SQLException ex2) {
				ex2.printStackTrace();
				log.error("数据库回滚操作失败");
			}
			return false;
		} finally {
			try {
				if (pstmt != null) {
					pstmt.close();
				}
				if (con != null) {
					con.close();
				}
				log.debug("成功关闭连接");
			} catch (SQLException ex1) {
				ex1.printStackTrace();
				log.error("关闭连接失败");
			}

		}

	}

	public static boolean InsertTask_deliver(String task_id,
			String task_deliver, String task_executor) {
		DbConnection dbconn = new DbConnection();
		Connection con = null;
		PreparedStatement pstmt1 = null;
		UUID id = new UUID();
		String task_deliver_num = id.toString();// 获取唯一的主键
		TaskDAO taskdao = new TaskDAO();

		Date time = new Date(System.currentTimeMillis());
		String task_deliver_time = formatter.format(time).toString(); // 获得当前时间---转交时间

		// 插入TASK_DELIVER表的SQL语句
		String sqlInsert = "insert info cinda_task.TASK_DELIVER (TASK_DELIVER_NUM,TASK_ID,TASK_DELIVER,TASK_ASSIGNEER,TASK_DELIVER_TIME) values(?,?,?,?,?)";
		log.debug("更新任务主题SQL语句" + sqlInsert);

		con = dbconn.getConnection();// 获得数据库的链接
		try {

			pstmt1 = con.prepareStatement(sqlInsert);
			pstmt1.setString(1, task_deliver_num);
			pstmt1.setString(2, task_id);
			pstmt1.setString(3, task_deliver);
			pstmt1.setString(4, task_executor);
			pstmt1.setString(5, task_deliver_time);
			pstmt1.executeUpdate();// 执行插入语句
			log.debug("*****SQL插入日志表成功********");
			return true;
		} catch (SQLException ex) {
			ex.printStackTrace();
			log.error("SQL更新任务action code 失败");
			try {
				con.rollback();
				log.debug("数据库回滚");
			} catch (SQLException ex2) {
				ex2.printStackTrace();
				log.error("数据库回滚操作失败");
			}
			return false;
		} finally {
			try {
				if (pstmt1 != null) {
					pstmt1.close();
				}
				if (con != null) {
					con.close();
				}
				log.debug("成功关闭连接");
			} catch (SQLException ex1) {
				ex1.printStackTrace();
				log.error("关闭连接失败");
			}

		}

	}

	/**
	 * 更新任务表（根据task_id字段更新app_var_4字段）
	 * 
	 * @param String
	 *            app_var_4 action code
	 * @return boolean 最终返回更新结果
	 */
	public static boolean UpdateTaskApp_var_4(String task_app_src,
			String taskid_value, String taskid_name, String app_var_4) {

		DbConnection dbconn = new DbConnection();
		Connection con = null;
		PreparedStatement pstmt = null;
		TaskDAO taskdao = new TaskDAO();
		Task task = taskdao.get_taskVO(task_app_src, taskid_value, taskid_name);// 根据task_id得到任务详细记录
		String task_id = task.getTask_id();
		String sql = "update cinda_task.TASK_TODOLIST set APP_VAR_4 = '"
				+ app_var_4.trim() + "' where TASK_ID = '" + task_id + "'";

		log.debug("更新任务的action code 的SQL语句" + sql);
		con = dbconn.getConnection();
		try {
			pstmt = con.prepareStatement(sql);
			pstmt.executeUpdate();// 执行更新语句
			log.debug("SQL更新任务的action code 成功");
			return true;
		} catch (SQLException ex) {
			ex.printStackTrace();
			log.error("SQL更新任务状态信息失败");
			try {
				con.rollback();
				log.debug("数据库回滚");
			} catch (SQLException ex2) {
				ex2.printStackTrace();
				log.error("数据库回滚操作失败");
			}
			return false;
		} finally {
			try {
				if (pstmt != null) {
					pstmt.close();
				}
				if (con != null) {
					con.close();
				}
				log.debug("成功关闭连接");
			} catch (SQLException ex1) {
				ex1.printStackTrace();
				log.error("关闭连接失败");
			}

		}

	}

	/**
	 * 更新任务表（根据task_id字段更新app_var_4字段）
	 * 
	 * @param String
	 *            app_var_4 action code
	 * @return boolean 最终返回更新结果
	 */
	public static boolean UpdateTaskDesignator(String task_app_src,
			String taskid_value, String taskid_name, String task_designator) {

		DbConnection dbconn = new DbConnection();
		Connection con = null;
		PreparedStatement pstmt = null;
		TaskDAO taskdao = new TaskDAO();
		Task task = taskdao.get_taskVO(task_app_src, taskid_value, taskid_name);// 根据task_id得到任务详细记录
		String task_id = task.getTask_id();
		String sql = "update cinda_task.TASK_TODOLIST set TASK_DESIGNATOR = '"
				+ task_designator.trim() + "' where TASK_ID = '" + task_id
				+ "'";

		log.debug("更新任务的action code 的SQL语句" + sql);
		con = dbconn.getConnection();
		try {
			pstmt = con.prepareStatement(sql);
			pstmt.executeUpdate();// 执行更新语句
			log.debug("SQL更新任务的action code 成功");
			return true;
		} catch (SQLException ex) {
			ex.printStackTrace();
			log.error("SQL更新任务状态信息失败");
			try {
				con.rollback();
				log.debug("数据库回滚");
			} catch (SQLException ex2) {
				ex2.printStackTrace();
				log.error("数据库回滚操作失败");
			}
			return false;
		} finally {
			try {
				if (pstmt != null) {
					pstmt.close();
				}
				if (con != null) {
					con.close();
				}
				log.debug("成功关闭连接");
			} catch (SQLException ex1) {
				ex1.printStackTrace();
				log.error("关闭连接失败");
			}

		}

	}

	/**
	 * 更新任务表（根据task_id字段更新app_var_4字段）
	 * 
	 * @param String
	 *            app_var_4 action code
	 * @return boolean 最终返回更新结果
	 */
	public static boolean UpdateTaskAssigneer(String task_app_src,
			String taskid_value, String taskid_name, String task_assigneer) {

		DbConnection dbconn = new DbConnection();
		Connection con = null;
		PreparedStatement pstmt = null;
		TaskDAO taskdao = new TaskDAO();
		Task task = taskdao.get_taskVO(task_app_src, taskid_value, taskid_name);// 根据task_id得到任务详细记录
		String task_id = task.getTask_id();
		String sql = "update cinda_task.TASK_TODOLIST set TASK_ASSIGNEER = '"
				+ task_assigneer.trim() + "' where TASK_ID = '" + task_id + "'";

		log.debug("更新任务的action code 的SQL语句" + sql);
		con = dbconn.getConnection();
		try {
			pstmt = con.prepareStatement(sql);
			pstmt.executeUpdate();// 执行更新语句
			log.debug("SQL更新任务的action code 成功");
			return true;
		} catch (SQLException ex) {
			ex.printStackTrace();
			log.error("SQL更新任务状态信息失败");
			try {
				con.rollback();
				log.debug("数据库回滚");
			} catch (SQLException ex2) {
				ex2.printStackTrace();
				log.error("数据库回滚操作失败");
			}
			return false;
		} finally {
			try {
				if (pstmt != null) {
					pstmt.close();
				}
				if (con != null) {
					con.close();
				}
				log.debug("成功关闭连接");
			} catch (SQLException ex1) {
				ex1.printStackTrace();
				log.error("关闭连接失败");
			}

		}

	}

	/**
	 * 更新任务表（根据task_id字段更新app_var_4字段）
	 * 
	 * @param String
	 *            app_var_4 action code
	 * @return boolean 最终返回更新结果
	 */
	public static boolean UpdateTaskConfirmor(String task_app_src,
			String taskid_value, String taskid_name, String task_confirmor) {

		DbConnection dbconn = new DbConnection();
		Connection con = null;
		PreparedStatement pstmt = null;
		TaskDAO taskdao = new TaskDAO();
		Task task = taskdao.get_taskVO(task_app_src, taskid_value, taskid_name);// 根据task_id得到任务详细记录
		String task_id = task.getTask_id();
		String sql = "update cinda_task.TASK_TODOLIST set TASK_CONFIRMOR = '"
				+ task_confirmor.trim() + "' where TASK_ID = '" + task_id + "'";

		log.debug("更新任务的action code 的SQL语句" + sql);
		con = dbconn.getConnection();
		try {
			pstmt = con.prepareStatement(sql);
			pstmt.executeUpdate();// 执行更新语句
			log.debug("SQL更新任务的action code 成功");
			return true;
		} catch (SQLException ex) {
			ex.printStackTrace();
			log.error("SQL更新任务状态信息失败");
			try {
				con.rollback();
				log.debug("数据库回滚");
			} catch (SQLException ex2) {
				ex2.printStackTrace();
				log.error("数据库回滚操作失败");
			}
			return false;
		} finally {
			try {
				if (pstmt != null) {
					pstmt.close();
				}
				if (con != null) {
					con.close();
				}
				log.debug("成功关闭连接");
			} catch (SQLException ex1) {
				ex1.printStackTrace();
				log.error("关闭连接失败");
			}

		}

	}

	/**
	 * 更新任务表（根据task_id字段更新app_var_4字段）
	 * 
	 * @param String
	 *            app_var_4 action code
	 * @return boolean 最终返回更新结果
	 */
	public static boolean UpdateTaskSubmit(String task_app_src,
			String taskid_value, String taskid_name, String task_submit) {

		DbConnection dbconn = new DbConnection();
		Connection con = null;
		PreparedStatement pstmt = null;
		TaskDAO taskdao = new TaskDAO();
		Task task = taskdao.get_taskVO(task_app_src, taskid_value, taskid_name);// 根据task_id得到任务详细记录
		String task_id = task.getTask_id();
		String sql = "update cinda_task.TASK_TODOLIST set TASK_SUBMIT = '"
				+ task_submit.trim() + "' where TASK_ID = '" + task_id + "'";

		log.debug("更新任务的action code 的SQL语句" + sql);
		con = dbconn.getConnection();
		try {
			pstmt = con.prepareStatement(sql);
			pstmt.executeUpdate();// 执行更新语句
			log.debug("SQL更新任务的action code 成功");
			return true;
		} catch (SQLException ex) {
			ex.printStackTrace();
			log.error("SQL更新任务状态信息失败");
			try {
				con.rollback();
				log.debug("数据库回滚");
			} catch (SQLException ex2) {
				ex2.printStackTrace();
				log.error("数据库回滚操作失败");
			}
			return false;
		} finally {
			try {
				if (pstmt != null) {
					pstmt.close();
				}
				if (con != null) {
					con.close();
				}
				log.debug("成功关闭连接");
			} catch (SQLException ex1) {
				ex1.printStackTrace();
				log.error("关闭连接失败");
			}

		}

	}

	// ******************************添加发送消息的方法
	// ***************************************************
	/**
	 * 向消息中心发送消息 更新数据库task_todolist表
	 * 
	 * @return String
	 */
	public String sendMessage(Task task) {
		return null;/*
		// 调用消息中心的接口
		MsgService msgService = MsgServiceFactory.getMsgService();// 返回工厂中定义的接口实现
		Integer msg_status = task.getTask_msg_status();// 获取发送消息的状态
		// 获取发送消息的各项参数
		String Messageid = "";// 消息ID
		String sendUser = task.getTask_designator();
		String receiveUser = task.getTask_executor();
		String title = task.getTask_subject();
		String app = task.getTask_app_src();
		String recordMessage = task.getTask_content();
		String url = "";
		// 判断消息状态的值，是否发送消息
		if (msg_status.equals(GloabVar.TASK_MSG_STATUS_SEND)) {

			try {
				// 发送消息
				Messageid = msgService.sendMsg(sendUser, receiveUser, title,
						app, recordMessage, url);
				if ((!Messageid.equals("")) && (!Messageid.equals(null))) {
					log.info("返回的messageId的值是：" + Messageid);
				}
				log.info("发送消息成功");

				// 更新消息状态－从发送改为已发送
				msg_status = GloabVar.TASK_MSG_STATUS_SENDED;

				// 把消息ID和消息状态放入taskVO中
				task.setTask_msg_id(Messageid);
				task.setTask_msg_status(msg_status);

				// 更新数据库task_todolist表
				TaskDAO.updateTask_Msg(task);

			} catch (Exception ex) {
				ex.printStackTrace();
				log.error("发送消息失败");
			}
		}

		return Messageid;
	*/}

	/**
	 * 更新数据库中TASK_TODOLIST表中的消息
	 * 
	 * @param Task
	 *            task应用的标识
	 * @return Task 最终返回更新结果
	 */
	public static Task updateTask_Msg(Task task) {
		DbConnection dbconn = new DbConnection();
		Connection con = null;
		PreparedStatement pstmt = null;
		// 从taskVO中获得任务ID、消息ID、消息状态
		String task_id = task.getTask_id();
		String Messageid = task.getTask_msg_id();
		Integer msg_status = task.getTask_msg_status();
		// 判断消息状态是已发送的－执行数据库更新的方法
		if (msg_status.equals(GloabVar.TASK_MSG_STATUS_SENDED)) {
			String sql = "update cinda_task.TASK_TODOLIST set TASK_MSG_ID=? , TASK_MSG_STATUS=? where Task_id=?";// 更新数据库，默认使用app_var_1字段
			log.debug("更新状态SQL语句" + sql);
			con = dbconn.getConnection();
			try {
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, Messageid);
				pstmt.setInt(2, msg_status.intValue());
				pstmt.setString(3, task_id);
				pstmt.executeUpdate();
				log.debug("SQL更新任务状态信息成功");
				return task;
			} catch (SQLException ex) {
				ex.printStackTrace();
				log.error("SQL更新任务状态信息失败");
				try {
					con.rollback();
					log.debug("数据库回滚");
				} catch (SQLException ex2) {
					ex2.printStackTrace();
					log.error("数据库回滚操作失败");
				}
				return task;
			} finally {
				try {
					if (pstmt != null) {
						pstmt.close();
					}
					if (con != null) {
						con.close();
					}
					log.debug("成功关闭连接");
				} catch (SQLException ex1) {
					ex1.printStackTrace();
					log.error("关闭连接失败");
				}
			}
		}
		return task;

	}

	// ********************************任务中心负责操作************************************

	/**
	 * 用户可以按照分类（TASK_APP_SRC）查看自己的待办的事情 查询条件：1 用户 task_executor 执行人从安全获得 2 待办事情
	 * TASK_STATUS = '11'、"12"、"21" 任务状态 3 分类名称 TASK_APP_SRC(有一级和二级两种分类)
	 * 
	 * @return String
	 */
	public String get_Todo_TaskList(String uid) {
		String Abeyance_Task = "";
		log.debug("待办事宜中task_executor是：" + uid);
		//Abeyance_Task = "where 1=1 " + " and TASK_STATUS in " + "('"
		//		+ GloabVar.TASK_STATUS_ASSIGNED + "','"
		//		+ GloabVar.TASK_STATUS_READED + "','"
		//		+ GloabVar.TASK_STATUS_APPED + "')  "
		//		+ " and  (TASK_ASSIGNEER  like '%" + uid.trim()
		//		+ "%' or TASK_CONFIRMOR like '%" + uid.trim() + "%')";
		
		Abeyance_Task = "where ((TASK_STATUS ='" +
		GloabVar.TASK_STATUS_ASSIGNED+"'or TASK_STATUS ='"+ GloabVar.TASK_STATUS_READED + "') and TASK_ASSIGNEER  like '%" + uid.trim()+"%') " +
				"or (TASK_STATUS ='" +GloabVar.TASK_STATUS_APPED + "' and  TASK_CONFIRMOR like '%" + uid.trim() + "%')"; 
		
		
		
		
		log.debug("*******************待办页面的SQL语句是：" + Abeyance_Task);
		return Abeyance_Task;

	}

	/**
	 * 用户可以按照分类（TASK_APP_SRC）查看自己的待办的事情 查询条件：1 用户 task_executor 执行人从安全获得 2 待办事情
	 * TASK_STATUS = '11'、"12"、"21" 任务状态 3 分类名称 TASK_APP_SRC(有一级和二级两种分类)
	 * 
	 * @return String
	 */
	public String get_Todo_TaskList2(String uid) {
		String Abeyance_Task = "";
		log.debug("待办事宜中task_executor是：" + uid);
		Abeyance_Task = "where 1=1 "
				+ " and TASK_STATUS = "
				+ "'"
				+ GloabVar.TASK_STATUS_FINISHED
				+ "' "
				+ "and ((task_batch_name<>'完成' or task_batch_name is NULL)) and  task_executor = '"
				+ uid.trim() + "'";
		return Abeyance_Task;

	}

	/**
	 * 显示用户已经办理的事情 1 每个用户可以查询已经办理的工作 2 查看自己的工作情况统计 3 需要调用QueryResult中的分页方法
	 * 
	 * @return String 返回已经办理的事情的列表
	 */
	public String get_Hasdo_TaskList(Task task) {
		String Done_Task = "";
		String startTime = " 00:00:00";// 精确到秒
		String endTime = " 23:59:59";// 精确到秒
		String task_app_src = task.getTask_app_src();
		String task_subject = task.getTask_subject();
		String task_designator = task.getTask_designator();
		String task_status = task.getTask_status();
		Integer task_kind = task.getTask_kind();
		String date1 = task.getDate1();
		String date2 = task.getDate2();
		String task_executor = task.getTask_executor();
		String depCode = task.getDept_code();

		/*
		 * 拼接查询语句 taskVO.getTask_app_src() taskVO.getTask_subject()
		 * taskVO.getTask_designator() taskVO.getTask_assignee_time()
		 * taskVO.getTask_status()
		 */
		//Done_Task = "where 1=1 ";
		Done_Task="";
		if (task_app_src != null && task_app_src.trim().length() > 0
				&& !task_app_src.equalsIgnoreCase("null")
				&& !task_app_src.equals("0")) {
			Done_Task += " and TASK_APP_SRC = '" + task_app_src.trim() + "'  ";

		}

		if (task_subject != null && task_subject.trim().length() > 0
				&& !task_subject.equalsIgnoreCase("null")) {
			Done_Task += " and TASK_SUBJECT like '%" + task_subject.trim()
					+ "%'  ";

		}
		if (task_designator != null && task_designator.trim().length() > 0
				&& !task_designator.equalsIgnoreCase("null")) {
			Done_Task += " and TASK_DESIGNATOR like '%"
					+ task_designator.trim() + "%'  ";

		}

		if (task.getTask_kind().equals(GloabVar.TASK_KIND_APP)
				|| task.getTask_kind().equals(GloabVar.TASK_KIND_OTHER)
				|| task.getTask_kind().equals(GloabVar.TASK_KIND_MANAGE)) {
			Done_Task += " and TASK_KIND = " + task_kind.intValue();

		}
		if (depCode != null && depCode.trim().length() > 0
				&& !depCode.equalsIgnoreCase("null") && !depCode.equals("0")) {
			Done_Task += " and DEPT_CODE = '" + depCode.trim() + "'  ";

		}

		// ----------时间匹配查询
		// date1 and date2 非空
		if (((date1.trim()).length() > 0) && (date2.trim()).length() > 0) {
			date1 = date1.trim() + startTime;
			date2 = date2.trim() + endTime;
			Done_Task += "   and (Task_submit_time between '" + date1
					+ "' and '" + date2 + "')";
		}
		// date1 非空 ， date2为空
		else if ((date1.trim()).length() > 0 && (date2.trim()).length() == 0) {
			date2 = date1.trim() + endTime;
			date1 = date1.trim() + startTime;
			Done_Task += "   and (Task_submit_time between '" + date1
					+ "' and '" + date2 + "')";
		}
		// date1 为空 ， date2非空
		else if ((date1.trim()).length() == 0 && (date2.trim()).length() > 0) {
			date1 = date2.trim() + startTime;
			date2 = date2.trim() + endTime;
			Done_Task += "   and (Task_submit_time between '" + date1
					+ "' and '" + date2 + "')";
		}

		// QueryTaskList(int page,int pageSize,String whereStr,String orderStr)
		// throws UnsupportedEncodingException {
		Done_Task += "  and TASK_STATUS = '" + GloabVar.TASK_STATUS_FINISHED
				+ "' " + " and  task_executor = '" + task_executor.trim()
				+ "' ";
		return Done_Task;
	}

	/**
	 * 个人统计查询 1 统计分类 2 统计待办事宜 3 统计已办事情 4 统计时间 统计页面使用
	 * 
	 * @return ArrayList 返回统计的数据
	 */
	public static ArrayList get_Task_count_no_use(String uid) {
		ArrayList Result = new ArrayList();
		Connection con = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		String sql = "select task_app_src ,task_app_moudle, "
				+ "count(*) as countA, "
				+ "sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_READED
				+ "'  then 1 else 0 end) as countB, "
				+ "sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_ASSIGNED
				+ "' then 1 else 0 end) as countC, "
				+ "sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_APPED
				+ "'  then 1 else 0 end) as countD, "
				+ "sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_FINISHED
				+ "'  then 1 else 0 end) as countE,  "
				+ "sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_READED
				+ "' then 1 else 0 end) + sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_ASSIGNED
				+ "' then 1 else 0 end)+sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_APPED
				+ "' then 1 else 0 end) as countF"
				+ " from cinda_task.TASK_TODOLIST where 1=1 "
				+ " and  task_executor = '"
				+ uid.trim()
				+ "' group by  task_app_src  ,task_app_moudle  order by task_app_src ";
		log.debug("统计任务数量的SQL是：" + sql);
		try {
			psdSelect = con.prepareStatement(sql);
			rs = psdSelect.executeQuery();
			while (rs.next()) {
				Task p = new Task();
				p.setTask_app_src(rs.getString("task_app_src"));
				p.setTask_app_moudle(rs.getString("task_app_moudle"));
				p.setCountA(rs.getInt("countA"));// 共计
				p.setCountB(rs.getInt("countB"));// 已读任务
				p.setCountC(rs.getInt("countC"));// 已分配任务
				p.setCountD(rs.getInt("countD"));// 已申请
				p.setCountE(rs.getInt("countE"));// 已完成－已办事宜
				p.setCount(rs.getInt("countF"));// 待办事宜
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
	 * 对task_todolist表中Task_App_Src进行分组排序查询
	 * 
	 * @param String
	 *            uid当前用户
	 * @return ArrayList 最终返回更新结果
	 */
	public static ArrayList get_Task_App_Src_List() {
		ArrayList Result = new ArrayList();
		Connection con = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		String sql = "select task_app_src  " + " from cinda_task.TASK_TODOLIST where 1=1 "
				+ " group by  task_app_src   order by task_app_src ";
		log.debug("统计任务数量的SQL是：" + sql);
		try {
			psdSelect = con.prepareStatement(sql);
			rs = psdSelect.executeQuery();
			while (rs.next()) {
				Task p = new Task();
				p.setTask_app_src(rs.getString("task_app_src"));
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
	 * 对task_todolist表中Task_App_Src进行分组排序查询
	 * 
	 * @param String
	 *            uid当前用户
	 * @return ArrayList 最终返回更新结果
	 */
	public static ArrayList get_Task_App_Src_List(String uid) {
		ArrayList Result = new ArrayList();
		Connection con = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		String sql = "select task_app_src  " + " from cinda_task.TASK_TODOLIST where 1=1 "
				+ " and  task_executor = '" + uid.trim()
				+ "' group by  task_app_src   order by task_app_src ";
		log.debug("统计任务数量的SQL是：" + sql);
		try {
			psdSelect = con.prepareStatement(sql);
			rs = psdSelect.executeQuery();
			while (rs.next()) {
				Task p = new Task();
				p.setTask_app_src(rs.getString("task_app_src"));
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
	 * 对task_todolist表中Task_App_Src进行分组排序查询
	 * 
	 * @param String
	 *            uid当前用户
	 * @param String
	 *            dep_code部门编码
	 * @return ArrayList 最终返回更新结果
	 */
	public static ArrayList get_Task_App_Src_List2(String dep_code) {
		ArrayList Result = new ArrayList();
		Connection con = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		String sql = "select task_app_src  " + " from cinda_task.TASK_TODOLIST "
				+ " where 1=1  " + "and  DEPT_CODE='" + dep_code.trim()
				+ "' group by  task_app_src   order by task_app_src ";
		log.debug("统计任务数量的SQL是：" + sql);
		try {
			psdSelect = con.prepareStatement(sql);
			rs = psdSelect.executeQuery();
			while (rs.next()) {
				Task p = new Task();
				p.setTask_app_src(rs.getString("task_app_src"));
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
	 * 对task_todolist表中按照TASK_STATUS进行统计、求和
	 * 
	 * @param String
	 *            uid当前用户
	 * @return ArrayList 最终返回更新结果
	 */
	public static ArrayList get_Task_count() {
		ArrayList Result = new ArrayList();
		Connection con = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		String sql = "select task_app_src ,APP_VAR_5, "
				+ "count(*) as countA, "
				+ "sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_READED
				+ "'   then 1 else 0 end) as countB, "// 12已读
				+ "sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_ASSIGNED
				+ "' then 1 else 0 end) as countC, "// 11已分配
				+ "sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_APPED
				+ "'    then 1 else 0 end) as countD, "// 21已申请
				+ "sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_FINISHED
				+ "' then 1 else 0 end) as countE,  "// 31以完成
				+ "sum(case TASK_STATUS when '" + GloabVar.TASK_STATUS_READED
				+ "'   then 1 else 0 end) + sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_ASSIGNED
				+ "' then 1 else 0 end)+sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_APPED
				+ "' then 1 else 0 end) as countF, "
				+ "sum(case TASK_STATUS when '" + GloabVar.TASK_STATUS_READED
				+ "'   then 1 else 0 end) + sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_ASSIGNED
				+ "' then 1 else 0 end)+sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_APPED
				+ "' then 1 else 0 end)+ sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_FINISHED
				+ "' then 1 else 0 end)  as count " + " from cinda_task.TASK_TODOLIST  "
				+ " group by  task_app_src  ,APP_VAR_5  order by task_app_src ";
		log.debug("系统管理员统计任务数量的SQL是：" + sql);
		try {
			psdSelect = con.prepareStatement(sql);
			rs = psdSelect.executeQuery();
			while (rs.next()) {
				Task p = new Task();
				p.setTask_app_src(rs.getString("task_app_src"));
				p.setApp_var_5(rs.getString("app_var_5"));
				p.setCountA(rs.getInt("countA"));// 共计
				p.setCountB(rs.getInt("countB"));// 已读任务
				p.setCountC(rs.getInt("countC"));// 已分配任务
				p.setCountD(rs.getInt("countD"));// 已申请
				p.setCountE(rs.getInt("countE"));// 已完成－已办事宜共计
				p.setCountF(rs.getInt("countF"));// 待办事宜共计
				p.setCount(rs.getInt("count"));// 待办＋已办共计

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
	 * 对task_todolist表中按照TASK_STATUS进行统计、求和
	 * 
	 * @param String
	 *            uid当前用户
	 * @return ArrayList 最终返回更新结果
	 */
	public static ArrayList get_Task_count(String uid) {
		ArrayList Result = new ArrayList();
		Connection con = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		String sql = "select task_app_src ,APP_VAR_5, "
				+ "count(*) as countA, "
				+ "sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_READED
				+ "'    then 1 else 0 end) as countB, "
				+ "sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_ASSIGNED
				+ "'  then 1 else 0 end) as countC, "
				+ "sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_APPED
				+ "'     then 1 else 0 end) as countD, "
				+ "sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_FINISHED
				+ "'  then 1 else 0 end) as countE,  "
				+ "sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_READED
				+ "'    then 1 else 0 end) + sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_ASSIGNED
				+ "' then 1 else 0 end)+sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_APPED
				+ "' then 1 else 0 end) as countF, "
				+ "sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_READED
				+ "'    then 1 else 0 end) + sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_ASSIGNED
				+ "' then 1 else 0 end)+sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_APPED
				+ "' then 1 else 0 end)+ sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_FINISHED
				+ "' then 1 else 0 end)  as count "
				+ " from cinda_task.TASK_TODOLIST where 1=1 "
				+ " and  task_executor = '"
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
				p.setCountA(rs.getInt("countA"));// 共计
				p.setCountB(rs.getInt("countB"));// 已读任务
				p.setCountC(rs.getInt("countC"));// 已分配任务
				p.setCountD(rs.getInt("countD"));// 已申请
				p.setCountE(rs.getInt("countE"));// 已完成－已办事宜共计
				p.setCountF(rs.getInt("countF"));// 待办事宜共计
				p.setCount(rs.getInt("count"));// 待办＋已办共计

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
	 * 对task_todolist表中按照TASK_STATUS进行统计、求和
	 * 
	 * @param String
	 *            uid当前用户
	 * @param String
	 *            String dep_code
	 * @return ArrayList 最终返回更新结果
	 */

	public static ArrayList get_Task_count2(String dep_code) {
		ArrayList Result = new ArrayList();
		Connection con = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		String sql = "select task_app_src ,APP_VAR_5, "
				+ "count(*) as countA, "
				+ "sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_READED
				+ "'   then 1 else 0 end) as countB, "// 12已读
				+ "sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_ASSIGNED
				+ "' then 1 else 0 end) as countC, "// 11已分配
				+ "sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_APPED
				+ "'    then 1 else 0 end) as countD, "// 21已申请
				+ "sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_FINISHED
				+ "' then 1 else 0 end) as countE,  "// 31以完成
				+ "sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_READED
				+ "'   then 1 else 0 end) + sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_ASSIGNED
				+ "' then 1 else 0 end)+sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_APPED
				+ "' then 1 else 0 end) as countF, "
				+ "sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_READED
				+ "' then 1 else 0 end) + sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_ASSIGNED
				+ "' then 1 else 0 end)+sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_APPED
				+ "' then 1 else 0 end)+ sum(case TASK_STATUS when '"
				+ GloabVar.TASK_STATUS_FINISHED
				+ "' then 1 else 0 end)  as count "
				+ " from cinda_task.TASK_TODOLIST where 1=1 "
				+ " and  DEPT_CODE='"
				+ dep_code.trim()
				+ "' group by  task_app_src  ,APP_VAR_5  order by task_app_src ";
		log.debug("部门管理员统计任务数量的SQL是：" + sql);
		try {
			psdSelect = con.prepareStatement(sql);
			rs = psdSelect.executeQuery();
			while (rs.next()) {
				Task p = new Task();
				p.setTask_app_src(rs.getString("task_app_src"));
				p.setApp_var_5(rs.getString("app_var_5"));
				p.setCountA(rs.getInt("countA"));// 共计
				p.setCountB(rs.getInt("countB"));// 已读任务
				p.setCountC(rs.getInt("countC"));// 已分配任务
				p.setCountD(rs.getInt("countD"));// 已申请
				p.setCountE(rs.getInt("countE"));// 已完成－已办事宜共计
				p.setCountF(rs.getInt("countF"));// 待办事宜共计
				p.setCount(rs.getInt("count"));// 待办＋已办共计

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
	 * 统计（待办和已办）任务数量 统计页面使用
	 * 
	 * @return Task 返回VO
	 */
	public Task get_Task_count_num(String sqlCount) {
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
				p.setCount(rs.getInt("a"));

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
				p.setCount(rs.getInt("s"));
				p.setCountA(rs.getInt("a"));

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

	// **************************************************************************
	/**
	 * 根据部门编码，分组查询统计任务，统计页面用
	 * 
	 * @return ArrayList 最终返回更新结果
	 */
	public static ArrayList get_Task_Dep_code(String sql) {
		ArrayList Result = new ArrayList();
		Connection con = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		log.debug("统计任务数量的SQL是：" + sql);
		try {
			psdSelect = con.prepareStatement(sql);
			rs = psdSelect.executeQuery();
			while (rs.next()) {
				Task p = new Task();
				p.setDept_code(rs.getString("dept_code"));
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
	 * 根据分类名称，分组查询统计任务，统计页面用
	 * 
	 * @return ArrayList 最终返回更新结果
	 */
	public static ArrayList get_Task_app_src(String sql) {
		ArrayList Result = new ArrayList();
		Connection con = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		log.debug("统计任务数量的SQL是：" + sql);
		try {
			psdSelect = con.prepareStatement(sql);
			rs = psdSelect.executeQuery();
			while (rs.next()) {
				Task p = new Task();
				p.setTask_app_src(rs.getString("task_app_src"));
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
	 * 根据分类名称，分组查询统计任务，统计页面用
	 * 
	 * @return ArrayList 最终返回更新结果
	 */
	public static ArrayList get_Task_executors(String sql) {
		ArrayList Result = new ArrayList();
		Connection con = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		log.debug("统计任务数量的SQL是：" + sql);
		try {
			psdSelect = con.prepareStatement(sql);
			rs = psdSelect.executeQuery();
			while (rs.next()) {
				Task p = new Task();
				p.setTask_executor(rs.getString("task_executor"));
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
	 * 根据应用名称，分组查询统计任务，统计页面用
	 * 
	 * @return ArrayList 最终返回更新结果
	 */
	public static ArrayList get_App_var_5(String sql) {
		ArrayList Result = new ArrayList();
		Connection con = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		log.debug("统计任务数量的SQL是：" + sql);
		try {
			psdSelect = con.prepareStatement(sql);
			rs = psdSelect.executeQuery();
			while (rs.next()) {
				Task p = new Task();
				p.setApp_var_5(rs.getString("app_var_5"));
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
	 * 根据环节阶段，分组查询统计任务，统计页面用
	 * 
	 * @return ArrayList 最终返回更新结果
	 */
	public static ArrayList get_Task_stage_name(String sql) {
		ArrayList Result = new ArrayList();
		Connection con = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		log.debug("统计任务数量的SQL是：" + sql);
		try {
			psdSelect = con.prepareStatement(sql);
			rs = psdSelect.executeQuery();
			while (rs.next()) {
				Task p = new Task();
				p.setTask_stage_name(rs.getString("task_stage_name"));
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
	 * 对task_todolist表中按照TASK_STATUS进行统计、求和
	 * 
	 * @param String
	 *            uid当前用户
	 * @return ArrayList 最终返回更新结果
	 */
	public static ArrayList get_Task_kind_statistics(String sql) {
		ArrayList Result = new ArrayList();
		Connection con = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();

		log.debug("统计任务数量的SQL是：" + sql);
		try {
			psdSelect = con.prepareStatement(sql);
			rs = psdSelect.executeQuery();
			while (rs.next()) {
				Task p = new Task();
				p.setCountA(rs.getInt("countA"));// 共计
				p.setCountB(rs.getInt("countB"));// 待办
				p.setCountC(rs.getInt("countC"));// 已办
				p.setCountD(rs.getInt("countD"));// 待办＋已办
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

	public Task get_Task_kind_statistics2(String sql) {
		DbConnection dbconn = new DbConnection();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Task p = null;
		con = dbconn.getConnection();
		log.debug("统计所有任务数量的SQL语句是：" + sql);
		try {
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				p = new Task();
				p.setCountA(rs.getInt("countA"));// 共计
				p.setCountB(rs.getInt("countB"));// 待办
				p.setCountC(rs.getInt("countC"));// 已办
				p.setCountD(rs.getInt("countD"));// 待办＋已办

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
	 * 查询表中的相关字段，用于统计页面的详细列表显示，查询条件：部门编码
	 * 
	 * @return ArrayList 最终返回更新结果
	 */
	public static ArrayList get_Task_Dep_code_List(String dep_code) {
		ArrayList Result = new ArrayList();
		Connection con = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		String sql = "select  * "
				+ " from cinda_task.TASK_TODOLIST where 1=1 and DEPT_CODE= '"
				+ dep_code.trim() + "'order by TASK_APP_SRC";
		log.debug("统计任务数量的SQL是：" + sql);
		try {
			psdSelect = con.prepareStatement(sql);
			rs = psdSelect.executeQuery();
			while (rs.next()) {
				Task p = new Task();

				p.setDelflag(new Integer(rs.getInt("delflag")));
				p.setDept_code(rs.getString("dept_code"));
				p.setTask_allow_deliver(new Integer(rs
						.getInt("task_allow_deliver")));
				p.setTask_app_src(rs.getString("task_app_src"));
				p.setTask_app_moudle(rs.getString("TASK_APP_MOUDLE"));

				p.setTask_assignee_rule(rs.getString("task_assignee_rule"));
				p.setTask_assignee_time(rs.getString("task_assignee_time"));
				p.setTask_assigneer(rs.getString("task_assigneer"));
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
				p.setTask_msg_id(rs.getString("task_msg_id"));
				p.setTask_msg_status(new Integer(rs.getInt("task_msg_status")));
				p.setTask_result_code(rs.getString("task_result_code"));
				p.setTask_stage_name(rs.getString("task_stage_name"));
				p.setTask_status(rs.getString("task_status"));
				p.setTask_subject(rs.getString("task_subject"));
				p.setTask_submit(rs.getString("task_submit"));
				p.setTask_submit_time(rs.getString("task_submit_time"));

				p.setApp_var_1(rs.getString("app_var_1"));
				p.setApp_var_2(rs.getString("app_var_2"));
				p.setApp_var_3(rs.getString("app_var_3"));
				p.setApp_var_4(rs.getString("app_var_4"));
				p.setApp_var_5(rs.getString("app_var_5"));
				p.setApp_var_6(rs.getString("app_var_6"));
				p.setApp_var_7(rs.getString("app_var_7"));
				p.setApp_var_8(rs.getString("app_var_8"));
				p.setApp_var_9(rs.getString("app_var_9"));

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
	 * 分组统计任务分类－统计页面用
	 * 
	 * @return ArrayList 最终返回更新结果
	 */
	public static ArrayList get_Task_App_src(String sql) {
		ArrayList Result = new ArrayList();
		Connection con = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		log.debug("统计任务数量的SQL是：" + sql);
		try {
			psdSelect = con.prepareStatement(sql);
			rs = psdSelect.executeQuery();
			while (rs.next()) {
				Task p = new Task();
				p.setTask_app_src(rs.getString("TASK_APP_SRC"));
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
	 * 通过任务分类查询任务的子分类，并对自分类进行分组统计
	 * 
	 * @return ArrayList 最终返回更新结果
	 */
	public static ArrayList get_Task_App_moudle(String task_app_src) {
		ArrayList Result = new ArrayList();
		Connection con = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		String sql = "select   APP_VAR_5"
				+ " from cinda_task.TASK_TODOLIST where 1=1 and TASK_APP_SRC ='"
				+ task_app_src.trim()
				+ "'  group by  APP_VAR_5   order by  APP_VAR_5";
		log.debug("统计任务数量的SQL是：" + sql);
		try {
			psdSelect = con.prepareStatement(sql);
			rs = psdSelect.executeQuery();
			while (rs.next()) {
				Task p = new Task();
				p.setApp_var_5(rs.getString("APP_VAR_5"));
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
	 * 通过任务分类查询任务的子分类，并对自分类进行分组统计
	 * 
	 * @return ArrayList 最终返回更新结果
	 */
	public static ArrayList get_Task_App_moudle(String task_app_src,
			String dep_code) {
		ArrayList Result = new ArrayList();
		Connection con = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		String sql = "select   APP_VAR_5"
				+ " from cinda_task.TASK_TODOLIST where 1=1 and TASK_APP_SRC ='"
				+ task_app_src.trim() + "' and DEPT_CODE =  '"
				+ dep_code.trim()
				+ "'  group by  APP_VAR_5   order by  APP_VAR_5";
		log.debug("统计任务数量的SQL是：" + sql);
		try {
			psdSelect = con.prepareStatement(sql);
			rs = psdSelect.executeQuery();
			while (rs.next()) {
				Task p = new Task();
				p.setApp_var_5(rs.getString("APP_VAR_5"));
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
	 * 查询详细信息，统计页面的列表显示（通过子分类的中文名字查询）
	 * 
	 * @return ArrayList 最终返回更新结果
	 */
	public static ArrayList get_Task_App_moudle_List(String app_var_5,
			String task_app_src) {
		ArrayList Result = new ArrayList();
		Connection con = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		String sql = "select  * "
				+ " from cinda_task.TASK_TODOLIST where 1=1 and  app_var_5= '"
				+ app_var_5.trim() + "'and task_app_src ='"
				+ task_app_src.trim() + "'  order by TASK_STAGE_NAME";
		log.debug("统计任务数量的SQL是：" + sql);
		try {
			psdSelect = con.prepareStatement(sql);
			rs = psdSelect.executeQuery();
			while (rs.next()) {
				Task p = new Task();

				p.setDelflag(new Integer(rs.getInt("delflag")));
				p.setDept_code(rs.getString("dept_code"));
				p.setTask_allow_deliver(new Integer(rs
						.getInt("task_allow_deliver")));
				p.setTask_app_src(rs.getString("task_app_src"));
				p.setTask_app_moudle(rs.getString("TASK_APP_MOUDLE"));
				p.setTask_assignee_rule(rs.getString("task_assignee_rule"));
				p.setTask_assignee_time(rs.getString("task_assignee_time"));
				p.setTask_assigneer(rs.getString("task_assigneer"));
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
				p.setTask_msg_id(rs.getString("task_msg_id"));
				p.setTask_msg_status(new Integer(rs.getInt("task_msg_status")));
				p.setTask_result_code(rs.getString("task_result_code"));
				p.setTask_stage_name(rs.getString("task_stage_name"));
				p.setTask_status(rs.getString("task_status"));
				p.setTask_subject(rs.getString("task_subject"));
				p.setTask_submit(rs.getString("task_submit"));
				p.setTask_submit_time(rs.getString("task_submit_time"));
				p.setApp_var_1(rs.getString("app_var_1"));
				p.setApp_var_2(rs.getString("app_var_2"));
				p.setApp_var_3(rs.getString("app_var_3"));
				p.setApp_var_4(rs.getString("app_var_4"));
				p.setApp_var_5(rs.getString("app_var_5"));
				p.setApp_var_6(rs.getString("app_var_6"));
				p.setApp_var_7(rs.getString("app_var_7"));
				p.setApp_var_8(rs.getString("app_var_8"));
				p.setApp_var_9(rs.getString("app_var_9"));

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
	 * 查询详细信息，统计页面的列表显示（通过子分类的中文名字查询）
	 * 
	 * @return ArrayList 最终返回更新结果
	 */
	public static ArrayList get_Task_App_moudle_List(String app_var_5,
			String dep_code, String task_app_src) {
		ArrayList Result = new ArrayList();
		Connection con = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		String sql = "select  * "
				+ " from cinda_task.TASK_TODOLIST where 1=1 and  app_var_5= '"
				+ app_var_5.trim() + "' and DEPT_CODE = '" + dep_code.trim()
				+ "' and TASK_APP_SRC = '" + task_app_src.trim()
				+ "' order by TASK_STAGE_NAME";
		log.debug("统计任务数量的SQL是：" + sql);
		try {
			psdSelect = con.prepareStatement(sql);
			rs = psdSelect.executeQuery();
			while (rs.next()) {
				Task p = new Task();

				p.setDelflag(new Integer(rs.getInt("delflag")));
				p.setDept_code(rs.getString("dept_code"));
				p.setTask_allow_deliver(new Integer(rs
						.getInt("task_allow_deliver")));
				p.setTask_app_src(rs.getString("task_app_src"));
				p.setTask_app_moudle(rs.getString("TASK_APP_MOUDLE"));
				p.setTask_assignee_rule(rs.getString("task_assignee_rule"));
				p.setTask_assignee_time(rs.getString("task_assignee_time"));
				p.setTask_assigneer(rs.getString("task_assigneer"));
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
				p.setTask_msg_id(rs.getString("task_msg_id"));
				p.setTask_msg_status(new Integer(rs.getInt("task_msg_status")));
				p.setTask_result_code(rs.getString("task_result_code"));
				p.setTask_stage_name(rs.getString("task_stage_name"));
				p.setTask_status(rs.getString("task_status"));
				p.setTask_subject(rs.getString("task_subject"));
				p.setTask_submit(rs.getString("task_submit"));
				p.setTask_submit_time(rs.getString("task_submit_time"));
				p.setApp_var_1(rs.getString("app_var_1"));
				p.setApp_var_2(rs.getString("app_var_2"));
				p.setApp_var_3(rs.getString("app_var_3"));
				p.setApp_var_4(rs.getString("app_var_4"));
				p.setApp_var_5(rs.getString("app_var_5"));
				p.setApp_var_6(rs.getString("app_var_6"));
				p.setApp_var_7(rs.getString("app_var_7"));
				p.setApp_var_8(rs.getString("app_var_8"));
				p.setApp_var_9(rs.getString("app_var_9"));

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
	 * 对task_todolist表中统计字段进行分组排序查询
	 * 
	 * @return ArrayList 最终返回更新结果
	 */
	public static ArrayList get_Task_executor(String dept_code) {
		ArrayList Result = new ArrayList();
		Connection con = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		String sql = "select   TASK_EXECUTOR "
				+ " from cinda_task.TASK_TODOLIST where 1=1 and dept_code ='"
				+ dept_code.trim()
				+ "' group by TASK_EXECUTOR  order by  TASK_EXECUTOR";
		log.debug("统计任务数量的SQL是：" + sql);
		try {
			psdSelect = con.prepareStatement(sql);
			rs = psdSelect.executeQuery();
			while (rs.next()) {
				Task p = new Task();
				p.setTask_executor(rs.getString("task_executor"));
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
	 * 对task_todolist表中统计字段进行分组排序查询
	 * 
	 * @return ArrayList 最终返回更新结果
	 */
	public static ArrayList get_Task_executor_List(String task_executor) {
		ArrayList Result = new ArrayList();
		Connection con = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		String sql = "select  * "
				+ " from cinda_task.TASK_TODOLIST where 1=1 and  TASK_EXECUTOR = '"
				+ task_executor.trim() + "'";
		log.debug("统计任务数量的SQL是：" + sql);
		try {
			psdSelect = con.prepareStatement(sql);
			rs = psdSelect.executeQuery();
			while (rs.next()) {
				Task p = new Task();

				p.setDelflag(new Integer(rs.getInt("delflag")));
				p.setDept_code(rs.getString("dept_code"));
				p.setTask_allow_deliver(new Integer(rs
						.getInt("task_allow_deliver")));
				p.setTask_app_src(rs.getString("task_app_src"));
				p.setTask_app_moudle(rs.getString("TASK_APP_MOUDLE"));
				p.setTask_assignee_rule(rs.getString("task_assignee_rule"));
				p.setTask_assignee_time(rs.getString("task_assignee_time"));
				p.setTask_assigneer(rs.getString("task_assigneer"));
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
				p.setTask_msg_id(rs.getString("task_msg_id"));
				p.setTask_msg_status(new Integer(rs.getInt("task_msg_status")));
				p.setTask_result_code(rs.getString("task_result_code"));
				p.setTask_stage_name(rs.getString("task_stage_name"));
				p.setTask_status(rs.getString("task_status"));
				p.setTask_subject(rs.getString("task_subject"));
				p.setTask_submit(rs.getString("task_submit"));
				p.setTask_submit_time(rs.getString("task_submit_time"));
				p.setApp_var_1(rs.getString("app_var_1"));
				p.setApp_var_2(rs.getString("app_var_2"));
				p.setApp_var_3(rs.getString("app_var_3"));
				p.setApp_var_4(rs.getString("app_var_4"));
				p.setApp_var_5(rs.getString("app_var_5"));
				p.setApp_var_6(rs.getString("app_var_6"));
				p.setApp_var_7(rs.getString("app_var_7"));
				p.setApp_var_8(rs.getString("app_var_8"));
				p.setApp_var_9(rs.getString("app_var_9"));

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
	 * 对task_todolist表中统计字段进行分组排序查询
	 * 
	 * @return ArrayList 最终返回更新结果
	 */
	public static ArrayList get_Task_executor_List(String task_executor,
			String dep_code) {
		ArrayList Result = new ArrayList();
		Connection con = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		String sql = "select  * "
				+ " from cinda_task.TASK_TODOLIST where 1=1 and  TASK_EXECUTOR = '"
				+ task_executor.trim() + "' and DEPT_CODE = '"
				+ dep_code.trim() + "' order by TASK_APP_SRC";
		log.debug("统计任务数量的SQL是：" + sql);
		try {
			psdSelect = con.prepareStatement(sql);
			rs = psdSelect.executeQuery();
			while (rs.next()) {
				Task p = new Task();

				p.setDelflag(new Integer(rs.getInt("delflag")));
				p.setDept_code(rs.getString("dept_code"));
				p.setTask_allow_deliver(new Integer(rs
						.getInt("task_allow_deliver")));
				p.setTask_app_src(rs.getString("task_app_src"));
				p.setTask_app_moudle(rs.getString("TASK_APP_MOUDLE"));
				p.setTask_assignee_rule(rs.getString("task_assignee_rule"));
				p.setTask_assignee_time(rs.getString("task_assignee_time"));
				p.setTask_assigneer(rs.getString("task_assigneer"));
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
				p.setTask_msg_id(rs.getString("task_msg_id"));
				p.setTask_msg_status(new Integer(rs.getInt("task_msg_status")));
				p.setTask_result_code(rs.getString("task_result_code"));
				p.setTask_stage_name(rs.getString("task_stage_name"));
				p.setTask_status(rs.getString("task_status"));
				p.setTask_subject(rs.getString("task_subject"));
				p.setTask_submit(rs.getString("task_submit"));
				p.setTask_submit_time(rs.getString("task_submit_time"));
				p.setApp_var_1(rs.getString("app_var_1"));
				p.setApp_var_2(rs.getString("app_var_2"));
				p.setApp_var_3(rs.getString("app_var_3"));
				p.setApp_var_4(rs.getString("app_var_4"));
				p.setApp_var_5(rs.getString("app_var_5"));
				p.setApp_var_6(rs.getString("app_var_6"));
				p.setApp_var_7(rs.getString("app_var_7"));
				p.setApp_var_8(rs.getString("app_var_8"));
				p.setApp_var_9(rs.getString("app_var_9"));

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

	// *************************************************************************************
	/**
	 * 系统管理员可以查询，统计，监控所有的任务列表 查询条件：1 all查询 2 all统计 任务监控页面所用
	 * 
	 * @return String
	 */
	public String get_All_Task(Task task) {
		// QueryTaskList(int page,int pageSize,String whereStr,String orderStr)
		// throws UnsupportedEncodingException {
		String All_Task = "";
		String startTime = " 00:00:00";// 精确到秒
		String endTime = " 23:59:59";// 精确到秒
		String task_app_src = task.getTask_app_src();
		String task_subject = task.getTask_subject();
		String task_designator = task.getTask_designator();
		String task_status = task.getTask_status();
		Integer task_kind = task.getTask_kind();
		String date1 = task.getDate1();
		String date2 = task.getDate2();
		String dep_code = task.getDept_code();

		/*
		 * 拼接查询语句 taskVO.getTask_app_src() taskVO.getTask_subject()
		 * taskVO.getTask_designator() taskVO.getTask_assignee_time()
		 * taskVO.getTask_status()
		 */
		All_Task = "where 1=1 ";
		if (dep_code != null && dep_code.trim().length() > 0
				&& !dep_code.equalsIgnoreCase("null")) {
			All_Task += "and dept_code = '" + dep_code.trim() + "'  ";

		}
		if (task_app_src != null && task_app_src.trim().length() > 0
				&& !task_app_src.equalsIgnoreCase("null")
				&& !task_app_src.equals("0")) {
			log.debug("task_app_src 在监控页面的值是：" + task_app_src);
			All_Task += "and TASK_APP_SRC like '%" + task_app_src.trim()
					+ "%'  ";

		}
		if (task_subject != null && task_subject.trim().length() > 0
				&& !task_subject.equalsIgnoreCase("null")) {
			All_Task += "and TASK_SUBJECT like '%" + task_subject.trim()
					+ "%'  ";

		}
		if (task_designator != null && task_designator.trim().length() > 0
				&& !task_designator.equalsIgnoreCase("null")) {
			All_Task += "and TASK_DESIGNATOR like '%" + task_designator.trim()
					+ "%'  ";

		}

		if (task_status != null && task_status.trim().length() > 0
				&& !task_status.equalsIgnoreCase("null")
				&& !task_status.equals("0")) {
			All_Task += "and TASK_STATUS = '" + task_status.trim() + "'  ";

		}
		if (task.getTask_kind().equals(GloabVar.TASK_KIND_APP)
				|| task.getTask_kind().equals(GloabVar.TASK_KIND_OTHER)
				|| task.getTask_kind().equals(GloabVar.TASK_KIND_MANAGE)) {
			All_Task += "and TASK_KIND = " + task_kind.intValue();

		}

		// ----------时间匹配查询
		// date1 and date2 非空
		if (((date1.trim()).length() > 0) && (date2.trim()).length() > 0) {
			date1 = date1.trim() + startTime;
			date2 = date2.trim() + endTime;
			All_Task += "   and (TASK_ASSIGNEE_TIME  between '" + date1
					+ "' and '" + date2 + "')";
		}
		// date1 非空 ， date2为空
		else if ((date1.trim()).length() > 0 && (date2.trim()).length() == 0) {
			date2 = date1.trim() + endTime;
			date1 = date1.trim() + startTime;
			All_Task += "   and (TASK_ASSIGNEE_TIME  between '" + date1
					+ "' and '" + date2 + "')";
		}
		// date1 为空 ， date2非空
		else if ((date1.trim()).length() == 0 && (date2.trim()).length() > 0) {
			date1 = date2.trim() + startTime;
			date2 = date2.trim() + endTime;
			All_Task += "   and (TASK_ASSIGNEE_TIME between '" + date1
					+ "' and '" + date2 + "')";
		}

		return All_Task;

	}

	/**
	 * 各个机构部门的管理员可以查询，统计本部门的任务状况 查询条件：1 按照部门查询 3 按照部门统计 部门任务监控页面所用
	 * 
	 * @return String
	 */
	public String get_Dep_Task(Task task) {
		// QueryTaskList(int page,int pageSize,String whereStr,String orderStr)
		// throws UnsupportedEncodingException {
		String Dep_Task = "";
		String startTime = " 00:00:00";// 精确到秒
		String endTime = " 23:59:59";// 精确到秒
		String task_app_src = task.getTask_app_src();
		String task_subject = task.getTask_subject();
		String task_designator = task.getTask_designator();
		String task_status = task.getTask_status();
		Integer task_kind = task.getTask_kind();
		String date1 = task.getDate1();
		String date2 = task.getDate1();
		String dept_Code = task.getDept_code();

		/*
		 * 拼接查询语句 taskVO.getTask_app_src() taskVO.getTask_subject()
		 * taskVO.getTask_designator() taskVO.getTask_assignee_time()
		 * taskVO.getTask_status()
		 */
		Dep_Task = "where 1=1 ";
		if (task_app_src != null && task_app_src.trim().length() > 0
				&& !task_app_src.equalsIgnoreCase("null")) {
			Dep_Task += "and TASK_APP_SRC like '%" + task_app_src.trim()
					+ "%'  ";

		}
		if (task_subject != null && task_subject.trim().length() > 0
				&& !task_subject.equalsIgnoreCase("null")) {
			Dep_Task += "and TASK_SUBJECT like '%" + task_subject.trim()
					+ "%'  ";

		}
		if (task_designator != null && task_designator.trim().length() > 0
				&& !task_designator.equalsIgnoreCase("null")) {
			Dep_Task += "and TASK_DESIGNATOR like '%" + task_designator.trim()
					+ "%'  ";

		}

		if (task_status != null && task_status.trim().length() > 0
				&& !task_status.equalsIgnoreCase("null")) {
			Dep_Task += "and TASK_STATUS = '" + task_status.trim() + "'  ";

		}
		if (task.getTask_kind().equals(GloabVar.TASK_KIND_APP)
				|| task.getTask_kind().equals(GloabVar.TASK_KIND_OTHER)
				|| task.getTask_kind().equals(GloabVar.TASK_KIND_MANAGE)) {
			Dep_Task += "and TASK_KIND = " + task_kind.intValue();

		}

		// ----------时间匹配查询
		// date1 and date2 非空
		if (((date1.trim()).length() > 0) && (date2.trim()).length() > 0) {
			date1 = date1.trim() + startTime;
			date2 = date2.trim() + endTime;
			Dep_Task += "   and (TASK_ASSIGNEE_TIME  between '" + date1
					+ "' and '" + date2 + "')";
		}
		// date1 非空 ， date2为空
		else if ((date1.trim()).length() > 0 && (date2.trim()).length() == 0) {
			date2 = date1.trim() + endTime;
			date1 = date1.trim() + startTime;
			Dep_Task += "   and (TASK_ASSIGNEE_TIME  between '" + date1
					+ "' and '" + date2 + "')";
		}
		// date1 为空 ， date2非空
		else if ((date1.trim()).length() == 0 && (date2.trim()).length() > 0) {
			date1 = date2.trim() + startTime;
			date2 = date2.trim() + endTime;
			Dep_Task += "   and (TASK_ASSIGNEE_TIME between '" + date1
					+ "' and '" + date2 + "')";
		}

		Dep_Task += "  and DEPT_CODE = '" + dept_Code.trim() + "'";
		return Dep_Task;

	}

	/**
	 * 根据任务ID查询数据库，得到任务的详细信息
	 * 
	 * @param String
	 *            task_id 任务id
	 * @return Task 最终返回VO
	 */
	public static Task get_taskParticular(String task_id) {
		DbConnection dbconn = new DbConnection();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList list = new ArrayList();
		Task p = null;
		String sql = "select * from cinda_task.TASK_TODOLIST  where task_id='" + task_id
				+ "'";
		con = dbconn.getConnection();
		try {
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				p = new Task();
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
				p.setTask_assignee_time(rs.getString("task_assignee_time"));
				p.setTask_assigneer(rs.getString("task_assigneer"));
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
				p.setTask_subject(rs.getString("task_subject"));
				p.setTask_submit(rs.getString("task_submit"));
				p.setTask_submit_time(rs.getString("task_submit_time"));

				list.add(p);
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

	// 链接查询
	/**
	 * 链接查询的方法 待办页面使用
	 * 
	 * task_Link_code：链接模块 task_Link_status：链接状态（待办－0还是已办－1）
	 * 
	 * @return Task 返回VO 待办、已办页面的链接查询方法
	 */
	public Task get_Link(String task_Link_code, String task_Link_status) {
		DbConnection dbconn = new DbConnection();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sqlWhere = " where  TASK_LINKTYPE_CODE || TASK_LINK_STATUS "
				+ " in ( '" + task_Link_code.trim() + "'||'"
				+ task_Link_status.trim() + "'  )";// 条件语句
		String sql = "select * from cinda_task.TASK_LINK_TYPE " + sqlWhere;// SQL语句
		log.debug("获得链接sql语句是：" + sql);
		Task p = null;
		con = dbconn.getConnection();
		log.debug("查询链接的SQL语句是：" + sql);
		try {
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				log.debug("*****************");
				p = new Task();
				p.setTask_linkType_code(rs.getString("task_linkType_code"));// 流程名称
				p.setTask_link_status(rs.getString("TASK_LINK_STATUS"));// 任务状态
				p.setTask_link_format(rs.getString("task_link_format"));// 任务链接
				log.debug("*****************链接是：" + p.getTask_link_format());
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

	// 应用分类名称查询
	/**
	 * 查询应用的中文名称
	 * 
	 * @return Task 返回VO
	 */
	public Task get_Task_app_src_Name(String task_app_src) {
		DbConnection dbconn = new DbConnection();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sqlWhere = " where 1=1 and TASK_APP_CODE = '"
				+ task_app_src.trim() + "'";
		String sql = "select * from cinda_task.TASK_APP " + sqlWhere;

		Task p = null;
		con = dbconn.getConnection();
		log.debug("查询链接的SQL语句是：" + sql);
		try {
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				p = new Task();
				p.setTask_app_code(rs.getString("TASK_APP_CODE"));
				p.setTask_app_name(rs.getString("TASK_APP_NAME"));

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
	 * 对task_todolist表中统计字段进行分组排序查询
	 * 
	 * @return ArrayList 最终返回更新结果
	 */
	public static ArrayList get_Task_app_src_List() {
		ArrayList Result = new ArrayList();
		Connection con = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		String sql = "select  *  from cinda_task.TASK_APP where 1=1 ";
		log.debug("统计任务数量的SQL是：" + sql);
		try {
			psdSelect = con.prepareStatement(sql);
			rs = psdSelect.executeQuery();
			while (rs.next()) {
				Task p = new Task();
				p.setTask_app_code(rs.getString("task_app_code"));
				p.setTask_app_name(rs.getString("task_app_name"));
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
	 * 对task_todolist表中统计字段进行分组排序查询
	 * 
	 * @return ArrayList 最终返回更新结果
	 */
	public static ArrayList get_depCode_List() {
		ArrayList Result = new ArrayList();
		Connection con = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		String sql = "select  DEPT_CODE  from cinda_task.TASK_TODOLIST where 1=1 group by DEPT_CODE order by DEPT_CODE";
		log.debug("统计任务数量的SQL是：" + sql);
		try {
			psdSelect = con.prepareStatement(sql);
			rs = psdSelect.executeQuery();
			while (rs.next()) {
				Task p = new Task();
				p.setDept_code(rs.getString("dept_code"));
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

	// 应用分类名称查询
	/**
	 * 查询应用的中文名称
	 * 
	 * @return Task 返回VO
	 */
	public Task get_Task_app_src_Code(String task_app_src_name) {
		DbConnection dbconn = new DbConnection();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sqlwhere = "";
		sqlwhere = "where 1=1 and TASK_APP_NAME = '" + task_app_src_name + "'";

		String sql = "select TASK_APP_CODE  from cinda_task.TASK_APP " + sqlwhere;

		Task p = null;
		con = dbconn.getConnection();
		log.debug("查询链接的SQL语句是：" + sql);
		try {
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				p = new Task();
				p.setTask_app_code(rs.getString("TASK_APP_CODE"));

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
	 * 根据任务ID查询数据库，得到任务的详细信息
	 * 
	 * @param String
	 *            task_id 任务id
	 * @return Task 最终返回VO
	 */
	public static Task get_taskVO(String task_app_src, String taskid_value,
			String taskid_name) {
		DbConnection dbconn = new DbConnection();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Task p = null;
		String sql = "select * from cinda_task.TASK_TODOLIST  where TASK_APP_SRC='"
				+ task_app_src.trim() + "' and " + taskid_name.trim() + " = '"
				+ taskid_value.trim() + "'";
		con = dbconn.getConnection();
		try {
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				p = new Task();
				p.setDelflag(new Integer(rs.getInt("delflag")));
				p.setDept_code(rs.getString("dept_code"));
				p.setTask_allow_deliver(new Integer(rs
						.getInt("task_allow_deliver")));
				p.setTask_app_src(rs.getString("task_app_src"));
				p.setTask_app_moudle(rs.getString("TASK_APP_MOUDLE"));
				p.setTask_assignee_rule(rs.getString("task_assignee_rule"));
				p.setTask_assignee_time(rs.getString("task_assignee_time"));
				p.setTask_assigneer(rs.getString("task_assigneer"));
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
				p.setTask_msg_id(rs.getString("task_msg_id"));
				p.setTask_msg_status(new Integer(rs.getInt("task_msg_status")));
				p.setTask_result_code(rs.getString("task_result_code"));
				p.setTask_stage_name(rs.getString("task_stage_name"));
				p.setTask_status(rs.getString("task_status"));
				p.setTask_subject(rs.getString("task_subject"));
				p.setTask_submit(rs.getString("task_submit"));
				p.setTask_submit_time(rs.getString("task_submit_time"));
				p.setApp_var_1(rs.getString("app_var_1"));
				p.setApp_var_2(rs.getString("app_var_2"));
				p.setApp_var_3(rs.getString("app_var_3"));
				p.setApp_var_4(rs.getString("app_var_4"));
				p.setApp_var_5(rs.getString("app_var_5"));
				p.setApp_var_6(rs.getString("app_var_6"));
				p.setApp_var_7(rs.getString("app_var_7"));
				p.setApp_var_8(rs.getString("app_var_8"));
				p.setApp_var_9(rs.getString("app_var_9"));

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

}
