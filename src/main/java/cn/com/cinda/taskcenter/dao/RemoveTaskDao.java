package cn.com.cinda.taskcenter.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import org.apache.log4j.Logger;

import cn.com.cinda.taskcenter.common.ConnectionPool;

/**
 * 删除任务
 * 
 * @author hkgt
 * 
 */
public class RemoveTaskDao {

	private Logger log = Logger.getLogger(this.getClass());

	/**
	 * 删除任务
	 * 
	 * @param key
	 *            记录id
	 * @return
	 * @throws Exception
	 */
	public boolean removeTaskByKey(String key) throws Exception {
		Connection con = null;
		PreparedStatement pstmt = null;

		// sql语句
		String sql = "delete from cinda_task.TASK_TODOLIST where task_id=? ";

		try {
			con = ConnectionPool.getConnection();
			pstmt = con.prepareStatement(sql);

			// 
			pstmt.setString(1, key);

			// 执行SQL语句
			pstmt.executeUpdate();

			log.debug("任务中心：删除任务成功！");

			return true;
		} catch (SQLException ex) {
			log.error("任务中心:删除任务失败::" + sql, ex);
			throw new Exception(ex);
		} finally {
			ConnectionPool.release(null, null, pstmt, con);
		}
	}
}
