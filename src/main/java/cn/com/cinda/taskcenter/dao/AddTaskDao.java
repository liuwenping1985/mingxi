package cn.com.cinda.taskcenter.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.log4j.Logger;

/*import cn.com.cinda.rtx.impl.MsgService;
import cn.com.cinda.rtx.impl.MsgServiceFactory;*/
import cn.com.cinda.taskcenter.common.ConnectionPool;
import cn.com.cinda.taskcenter.common.TaskInfor;
import cn.com.cinda.taskcenter.model.Task;

/**
 * 添加任务
 * 
 * @author hkgt
 * 
 */
public class AddTaskDao {

	private static final SimpleDateFormat FORMAT = new SimpleDateFormat(
			"yyyy-MM-dd HH:mm:ss");

	private Logger log = Logger.getLogger(this.getClass());

	private boolean init(Task task) throws Exception {
		// 任务id
		String taskId = task.getTask_id();
		// 应用类型
		String appSrc = task.getTask_app_src();
		// 任务状态
		String taskState = task.getTask_status();

		if (taskId == null || "".equals(taskId)) {
			throw new Exception("任务id不能为空。");
		}
		if (appSrc == null || "".equals(appSrc)) {
			throw new Exception("应用类型不能为空。");
		}
		if (taskState == null || "".equals(taskState)) {
			throw new Exception("任务状态不能为空。");
		}
		if (taskId.indexOf(appSrc) == -1) {
			throw new Exception("任务id格式不正确。");
		}

		return true;
	}

	/**
	 * 添加任务
	 * 
	 * @param task
	 *            任务对象
	 * @return 任务对象
	 * @throws Exception
	 */
	public Task addTask(Task task) throws Exception {

		if (!init(task)) {
			throw new Exception("初始化任务对象失败。");
		}

		Connection con = null;
		PreparedStatement pstmt = null;

		// sql语句
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
				+ "TASK_LINK5_TYPE ,DELFLAG,TASK_APP_STATE ) "
				+ "values(?,?,?,?,?,?,?,?,?,?," + "?,?,?,?,?,?,?,?,?,?,"
				+ "?,?,?,?,?,?,?,?,?,?," + "?,?,?,?,?,?,?,?,?,?,"
				+ "?,?,?,?,?,?,?,?)";

		try {
			con = ConnectionPool.getConnection();
			pstmt = con.prepareStatement(sql);

			// 
			pstmt.setString(1, task.getTask_id());
			if (task.getTask_kind() == null) {
				pstmt.setInt(2, TaskInfor.TASK_KIND_OTHER);
			} else {
				pstmt.setInt(2, task.getTask_kind().intValue());
			}
			pstmt.setString(3, task.getTask_batch_id());
			pstmt.setString(4, task.getTask_stage_name());
			pstmt.setString(5, task.getTask_batch_name());
			pstmt.setString(6, task.getTask_subject());

			pstmt.setString(7, task.getTask_content());
			// 默认值是“建立”
			pstmt.setString(8, task.getTask_status());
			pstmt.setString(9, task.getTask_creator());
			pstmt.setString(10, task.getTask_designator());
			pstmt.setString(11, task.getTask_assigneer());
			pstmt.setString(12, task.getTask_assignee_rule());
			pstmt.setString(13, task.getTask_cc());
			if (task.getTask_allow_deliver() == null) {
				//changed by fjh 20070613.默认为不允许转交
				pstmt.setInt(14, TaskInfor.TASK_ALLOW_DELETE_NO);//
			} else {
				pstmt.setInt(14, task.getTask_allow_deliver().intValue());
			}
			pstmt.setString(15, task.getTask_confirmor());
			pstmt.setString(16, task.getTask_executor());
			pstmt.setString(17, task.getTask_submit());

			// 系统时间
			pstmt.setString(18, FORMAT.format(new Date())); // 创建时间
			// 系统时间
			pstmt.setString(19, FORMAT.format(new Date()));
			pstmt.setString(20, task.getTask_confirm_time());
			pstmt.setString(21, task.getTask_submit_time());

			pstmt.setString(22, task.getTask_result_code());// 默认结果
			pstmt.setString(23, task.getDept_code());
			pstmt.setString(24, task.getTask_comments());

			pstmt.setString(25, (task.getTask_app_src()).toUpperCase());

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
			if (task.getTask_msg_status() == null) {
				pstmt.setInt(37, TaskInfor.TASK_MSG_STATUS_NOSEND);
			} else {
				pstmt.setInt(37, task.getTask_msg_status().intValue());
			}
			pstmt.setString(38, task.getTask_link_type());
			pstmt.setString(39, task.getTask_link2_name());
			pstmt.setString(40, task.getTask_link2_type());
			pstmt.setString(41, task.getTask_link3_name());
			pstmt.setString(42, task.getTask_link3_type());
			pstmt.setString(43, task.getTask_link4_name());
			pstmt.setString(44, task.getTask_link4_type());
			pstmt.setString(45, task.getTask_link5_name());
			pstmt.setString(46, task.getTask_link5_type());
			if (task.getDelflag() == null) {
				pstmt.setInt(47, TaskInfor.TASK_ALLOW_DELETE_NO);
			} else {
				pstmt.setInt(47, task.getDelflag().intValue());
			}

			// 应用自定义状态
			pstmt.setString(48, task.getTask_app_state());

			// 执行SQL语句
			pstmt.executeUpdate();

			log.debug("任务中心：添加任务成功！");

		} catch (SQLException ex) {
			log.error("任务中心:添加任务失败::" + sql, ex);
			throw new Exception(ex);
		} finally {
			ConnectionPool.release(null, null, pstmt, con);
		}

		return task;
	}

	/**
	 * 添加任务同时发送消息
	 * 
	 * @param task
	 *            任务对象
	 * @param messageTitle
	 *            消息标题
	 * @param message
	 *            消息内容
	 * @param msgState
	 *            消息状态 具体值要引用常量类TaskInfor中定义的
	 * @return 任务对象
	 * @throws Exception
	 */
	public Task addTask(Task task, String messageTitle, String message,
			int msgState) throws Exception {
		// 添加任务
		System.out.println("addTask");
		addTask(task);
		System.out.println("sucess");

		// 发送消息,消息发送者
		String sender = task.getTask_creator();
		// 应用类型
		String appSrc = task.getTask_app_src();
		// 消息接收者
		String recievers = task.getTask_assigneer();
		String[] recieverArray = recievers.split(",");
		String ids = "";
		for (int i = 0; i < recieverArray.length; i++) {
			String temp = recieverArray[i];
			String ret = sendMessage(sender, temp, messageTitle, appSrc,
					message);
			if (ret != null) {
				ids = ids + "," + ret;
			}
		}

		if (ids.indexOf(",") == 0) {
			ids = ids.substring(1);
		}

		// 更新任务列表中的消息ids
		updateTaskMessage(task.getTask_id(), ids, msgState);

		return task;
	}

	/**
	 * 发送消息
	 * 
	 * @param sender
	 *            发送人
	 * @param reciever
	 *            接收人
	 * @param messageTitle
	 *            标题
	 * @param appSrc
	 *            应用类型
	 * @param message
	 *            消息内容
	 * @return
	 */
	public String sendMessage(String sender, String reciever,
			String messageTitle, String appSrc, String message) {
		try {
			if (sender.equals(reciever)
					|| "weblogic".equalsIgnoreCase(reciever)) {
				return null;
			}

/*			MsgService msgService = MsgServiceFactory.getMsgService();
			String msgId = msgService.sendMsg(sender, reciever, messageTitle,
					appSrc, message, "");*/
			String msgId = null;
//			TODO
			return msgId;
		} catch (Exception ex) {
			log.error(ex);
		}

		return null;
	}

	/**
	 * 更新任务列表中的消息ids
	 * 
	 * @param key
	 *            记录id
	 * @param msgIds
	 *            消息ids
	 * @param msgState
	 *            消息状态
	 * @return
	 * @throws Exception
	 */
	public boolean updateTaskMessage(String key, String msgIds, int msgState)
			throws Exception {

		Connection con = null;
		PreparedStatement pstmt = null;

		// sql语句
		String sql = "update cinda_task.TASK_TODOLIST set task_msg_id= ?, task_msg_status=? where task_id=? ";

		try {
			con = ConnectionPool.getConnection();
			pstmt = con.prepareStatement(sql);

			// 
			pstmt.setString(1, msgIds);
			pstmt.setInt(2, msgState);
			pstmt.setString(3, key);

			// 执行SQL语句
			pstmt.executeUpdate();

			log.debug("任务中心：发送消息成功！");

			return true;
		} catch (SQLException ex) {
			log.error("任务中心:发送消息失败::" + sql, ex);
			throw new Exception(ex);
		} finally {
			ConnectionPool.release(null, null, pstmt, con);
		}

	}
}
