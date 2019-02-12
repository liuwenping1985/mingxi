package cn.com.cinda.taskcenter.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;

import org.apache.log4j.Logger;

import cn.com.cinda.taskcenter.common.ConnectionPool;
import cn.com.cinda.taskcenter.common.TaskInfor;

/**
 * 终止任务
 * 
 * @author hkgt
 * 
 */
public class CancelTaskDao {

	private static final SimpleDateFormat FORMAT = new SimpleDateFormat(
			"yyyy-MM-dd HH:mm:ss");

	private Logger log = Logger.getLogger(this.getClass());

	/**
	 * 终止任务
	 * 
	 * @param key
	 *            记录id
	 * @param taskState
	 *            任务状态 具体值要引用常量类TaskInfor中定义的
	 * @return
	 * @throws Exception
	 */
	public boolean cancelTask(String key, int taskState) throws Exception {
		Connection con = null;
		PreparedStatement pstmt = null;

		// sql语句
		String sql = "update cinda_task.TASK_TODOLIST set task_status= ? where task_id=? ";

		try {
			con = ConnectionPool.getConnection();
			pstmt = con.prepareStatement(sql);
			// 如果任务已经终止，则恢复
			if (taskState == TaskInfor.TASK_STATUS_CANCEL) {
				taskState = TaskInfor.TASK_STATUS_ASSIGNED;
			} else {
				taskState = TaskInfor.TASK_STATUS_CANCEL;
			}

			// 
			pstmt.setString(1, taskState + "");
			pstmt.setString(2, key);

			// 执行SQL语句
			pstmt.executeUpdate();

			log.debug("任务中心：更新任务成功！");

			return true;
		} catch (SQLException ex) {
			log.error("任务中心:更新任务失败::" + sql, ex);
			throw new Exception(ex);
		} finally {
			ConnectionPool.release(null, null, pstmt, con);
		}
	}

}
