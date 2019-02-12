package cn.com.cinda.taskcenter.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.log4j.Logger;

import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.dao.OrgHelper;

/*import com.cinda.eoffice.ccds.ccbl.security.SecurityService;
import com.cinda.eoffice.ccds.ccbl.security.SecurityServiceFactory;

import cn.com.cinda.rtx.common.StateEnum;
import cn.com.cinda.rtx.impl.MsgService;
import cn.com.cinda.rtx.impl.MsgServiceFactory;*/
import cn.com.cinda.taskcenter.common.ConnectionPool;
import cn.com.cinda.taskcenter.common.TaskInfor;
import cn.com.cinda.taskcenter.model.Task;
import cn.com.cinda.taskcenter.util.UUID;

/**
 * 更新任务
 * 
 * @author hkgt
 * 
 */
public class UpdateTaskDao {

	private static final SimpleDateFormat FORMAT = new SimpleDateFormat(
			"yyyy-MM-dd HH:mm:ss");

	private Logger log = Logger.getLogger(this.getClass());

	/**
	 * 更新任务状态
	 * 
	 * @param key
	 *            记录id
	 * @param taskState
	 *            任务状态 具体值要引用常量类TaskInfor中定义的
	 * @param appState
	 *            应用自定义状态
	 * @return
	 * @throws Exception
	 */
	public boolean updateStateByKey(String key, int taskState, int appState)
			throws Exception {
		Connection con = null;
		PreparedStatement pstmt = null;

		// sql语句
		String sql = "update cinda_task.TASK_TODOLIST set task_status= ?, task_app_state=? where task_id=? ";

		try {
			con = ConnectionPool.getConnection();
			pstmt = con.prepareStatement(sql);

			// 
			pstmt.setString(1, taskState + "");
			pstmt.setString(2, appState + "");
			pstmt.setString(3, key);

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

	/**
	 * 更新任务状态及任务申领人
	 * 
	 * @param key
	 *            记录id
	 * @param taskState
	 *            任务状态 具体值要引用常量类TaskInfor中定义的
	 * @param appState
	 *            应用自定义状态
	 * @param claimer
	 *            申领人
	 * @return
	 * @throws Exception
	 */
	public boolean updateStateAndClaimerByKey(String key, int taskState,
			int appState, String claimer) throws Exception {
		Connection con = null;
		PreparedStatement pstmt = null;
/*		//初始化信息
		SecurityService securityService=SecurityServiceFactory.getSecurityService();
		String deptcode="";
		try{
		deptcode=securityService.getSegmentByUser(claimer);
		}catch(Exception e)
		{
			e.printStackTrace();
		}*/
		
		V3xOrgMember member = OrgHelper.getOrgManager().getMemberByLoginName(claimer);
		V3xOrgDepartment dept = OrgHelper.getOrgManager().getDepartmentById(member.getOrgDepartmentId());
		String deptcode= dept.getCode();
		
		// sql语句
		String sql = "update cinda_task.TASK_TODOLIST set task_status= ?, task_app_state=?, task_confirmor=?, task_confirm_time=?,dept_code=? where task_id=? ";

		try {
			con = ConnectionPool.getConnection();
			pstmt = con.prepareStatement(sql);

			// 
			pstmt.setString(1, taskState + "");
			pstmt.setString(2, appState + "");
			pstmt.setString(3, claimer);
			pstmt.setString(4, FORMAT.format(new Date()));
			pstmt.setString(5, deptcode);
			
			pstmt.setString(6, key);

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

	/**
	 * 更新任务状态及任务执行人
	 * 
	 * @param key
	 *            记录id
	 * @param taskState
	 *            任务状态 具体值要引用常量类TaskInfor中定义的
	 * @param appState
	 *            应用自定义状态
	 * @param executor
	 *            执行人
	 * @return
	 * @throws Exception
	 */
	public boolean updateStateAndExecutorByKey(String key, int taskState,
			int appState, String executor) throws Exception {
		Connection con = null;
		PreparedStatement pstmt = null;

		// sql语句
		String sql = "update cinda_task.TASK_TODOLIST set task_status= ?, task_app_state=?, task_executor=?, task_submit_time=? where task_id=? ";

		try {
			con = ConnectionPool.getConnection();
			pstmt = con.prepareStatement(sql);

			// 
			pstmt.setString(1, taskState + "");
			pstmt.setString(2, appState + "");
			pstmt.setString(3, executor);
			pstmt.setString(4, FORMAT.format(new Date()));
			pstmt.setString(5, key);

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

	/**
	 * 更新任务申领人
	 * 
	 * @param key
	 *            记录id
	 * @param claimer
	 *            申领人
	 * @return
	 * @throws Exception
	 */
	public boolean updateClaimerByKey(String key, String claimer)
			throws Exception {
		Connection con = null;
		PreparedStatement pstmt = null;

		// sql语句
		String sql = "update cinda_task.TASK_TODOLIST set task_confirmor=? where task_id=? ";

		try {
			con = ConnectionPool.getConnection();
			pstmt = con.prepareStatement(sql);

			// 
			pstmt.setString(1, claimer);
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

	/**
	 * 更新任务申领人及消息中心的消息状态
	 * 
	 * @param key
	 *            记录id
	 * @param claimer
	 *            申领人
	 * @param msgState
	 *            消息状态 具体值要引用消息中心常量类StateEnum中定义的
	 * @return
	 * @throws Exception
	 */
	public boolean updateClaimerByKey(String key, String claimer, int msgState)
			throws Exception {
		Connection con = null;
		PreparedStatement pstmt = null;

		// sql语句
		String sql = "update cinda_task.TASK_TODOLIST set task_confirmor=? where task_id=? ";

		try {
			con = ConnectionPool.getConnection();
			pstmt = con.prepareStatement(sql);

			// 
			pstmt.setString(1, claimer);
			pstmt.setString(2, key);

			// 执行SQL语句
			pstmt.executeUpdate();

			log.debug("任务中心：更新任务成功！");

		} catch (SQLException ex) {
			log.error("任务中心:更新任务失败::" + sql, ex);
			throw new Exception(ex);
		} finally {
			ConnectionPool.release(null, null, pstmt, con);
		}

		// 获得任务对象
		QueryTaskDetail query = new QueryTaskDetail();
		Task task = query.getTaskById(key);

		// 更新消息状态
		String msgIds = task.getTask_msg_id();
		String[] msgIds2 = new String[1];
		if (msgIds != null && !"".equals(msgIds)) {
			msgIds2 = msgIds.split(",");
		}
		for (int i = 0; i < msgIds2.length; i++) {
			boolean b = updateMessageState(msgState, msgIds2[i]);
		}

		return true;
	}

	/**
	 * 更新任务执行人
	 * 
	 * @param key
	 *            记录id
	 * @param executor
	 *            执行人
	 * @return
	 * @throws Exception
	 */
	public boolean updateExecutorByKey(String key, String executor)
			throws Exception {
		Connection con = null;
		PreparedStatement pstmt = null;

		// sql语句
		String sql = "update cinda_task.TASK_TODOLIST set task_executor=? where task_id=? ";

		try {
			con = ConnectionPool.getConnection();
			pstmt = con.prepareStatement(sql);

			// 
			pstmt.setString(1, executor);
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

	/**
	 * 更新应用自定义字段值
	 * 
	 * @param key
	 *            记录id
	 * @param fieldName
	 *            字段名称 具体值要引用常量类TaskInfor中定义的
	 * @param fieldValue
	 *            字段值
	 * @return
	 * @throws Exception
	 */
	public boolean updateCustomFieldByKey(String key, String fieldName,
			String fieldValue) throws Exception {
		Connection con = null;
		PreparedStatement pstmt = null;

		// sql语句
		String sql = "update cinda_task.TASK_TODOLIST set " + fieldName
				+ "=? where task_id=? ";

		try {
			con = ConnectionPool.getConnection();
			pstmt = con.prepareStatement(sql);

			// 
			pstmt.setString(1, fieldValue);
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

	/**
	 * 更新任务主题
	 * 
	 * @param key
	 *            记录id
	 * @param subject
	 *            主题
	 * @return
	 * @throws Exception
	 */
	public boolean updateSubjectByKey(String key, String subject)
			throws Exception {
		Connection con = null;
		PreparedStatement pstmt = null;

		// sql语句
		String sql = "update cinda_task.TASK_TODOLIST set task_subject=? where task_id=? ";

		try {
			con = ConnectionPool.getConnection();
			pstmt = con.prepareStatement(sql);

			// 
			pstmt.setString(1, subject);
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

	/**
	 * 任务转交
	 * 
	 * @param key
	 *            记录id
	 * @param fromUser
	 *            转交来源
	 * @param toUser
	 *            转交目标
	 * @param taskState
	 *            任务状态 具体值要引用常量类TaskInfor中定义的
	 * @param appState
	 *            应用自定义状态
	 * @return
	 * @throws Exception
	 */
	public boolean deliverTaskByKey(String key, String fromUser, String toUser,
			int taskState, int appState) throws Exception {
		Connection con = null;
		PreparedStatement pstmt = null;

		// sql语句
		String sql = "update cinda_task.TASK_TODOLIST set task_designator=?, task_assigneer=?, task_status=?, task_app_state=?, task_assignee_time=? where task_id=? ";

		try {
			con = ConnectionPool.getConnection();
			pstmt = con.prepareStatement(sql);

			// 
			pstmt.setString(1, fromUser);
			pstmt.setString(2, toUser);
			pstmt.setString(3, taskState + "");
			pstmt.setString(4, appState + "");
			pstmt.setString(5, FORMAT.format(new Date()));
			pstmt.setString(6, key);

			// 执行SQL语句
			pstmt.executeUpdate();

			log.debug("任务中心：更新任务成功！");
			//insert by fjh 20070606,转交的同时在TASK_DELIVER表里塞一条记录
			log.debug("任务中心：增加转交日志");
			try{
			addTaskDeliver(key,fromUser,toUser);
			log.debug("任务中心：增加转交日志成功");
			}catch(Exception e)
			{
				e.printStackTrace();
				throw e;
			}
			
			//insert by fjh 20070619,任务转交时，要发消息,并将原来的消息更新为已读状态
//			 发送消息,消息发送者
			QueryTaskDetail query=new QueryTaskDetail();
			AddTaskDao add=new AddTaskDao();
			Task task=query.getTaskById(key);
			String messageIds=task.getTask_msg_id();
			//得到消息ＩＤ，并将其更新成已读
			String[] msgIds2 = new String[1];
			if (messageIds != null && !"".equals(messageIds)) {
					msgIds2 = messageIds.split(",");
		
				for (int i = 0; i < msgIds2.length; i++) {
//					boolean b = updateMessageState(StateEnum.MSG_MOUDLE_READED, msgIds2[i]);
				}
				
			}
			
			String sender = fromUser;
			// 应用类型
			String appSrc =task.getTask_app_src();
			// 消息接收者
			String recievers =toUser;
			String messageTitle=task.getTask_subject();
			String message=task.getTask_content();
			String[] recieverArray = recievers.split(",");
			String ids = "";
			for (int i = 0; i < recieverArray.length; i++) {
				String temp = recieverArray[i];
				String ret = add.sendMessage(sender, temp, messageTitle, appSrc,
						message);
				if (ret != null) {
					ids = ids + "," + ret;
				}
			}

			if (ids.indexOf(",") == 0) {
				ids = ids.substring(1);
			}

			// 更新任务列表中的消息ids
			add.updateTaskMessage(task.getTask_id(), ids, TaskInfor.TASK_MSG_STATUS_SEND);

			

			return true;
		} catch (SQLException ex) {
			log.error("任务中心:更新任务失败::" + sql, ex);
			throw new Exception(ex);
		} finally {
			ConnectionPool.release(null, null, pstmt, con);
		}
	}

	/**
	 * 根据应用自定义字段值批量更新任务批次值
	 * 
	 * @param appSourceCode
	 *            应用编码 具体值要引用常量类TaskInfor中定义的
	 * @param fieldName
	 *            字段名称 具体值要引用常量类TaskInfor中定义的
	 * @param fieldValue
	 *            字段值
	 * @param batchName
	 *            任务批次名称
	 * @return
	 * @throws Exception
	 */
	public boolean batchUpdateBatchName(String appSourceCode, String fieldName,
			String fieldValue, String batchName) throws Exception {
		Connection con = null;
		PreparedStatement pstmt = null;

		// sql语句
		String sql = "update cinda_task.TASK_TODOLIST set task_batch_name=? where task_app_src=? and "
				+ fieldName + "=? ";

		try {
			con = ConnectionPool.getConnection();
			pstmt = con.prepareStatement(sql);

			// 
			pstmt.setString(1, batchName);
			pstmt.setString(2, appSourceCode);
			pstmt.setString(3, fieldValue);

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

	/**
	 * 根据应用自定义字段值批量更新任务主题
	 * 
	 * @param appSourceCode
	 *            应用编码 具体值要引用常量类TaskInfor中定义的
	 * @param fieldName
	 *            字段名称 具体值要引用常量类TaskInfor中定义的
	 * @param fieldValue
	 *            字段值
	 * @param subject
	 *            任务主题
	 * @return
	 * @throws Exception
	 */
	public boolean batchUpdateSubject(String appSourceCode, String fieldName,
			String fieldValue, String subject) throws Exception {
		Connection con = null;
		PreparedStatement pstmt = null;

		// sql语句
		String sql = "update cinda_task.TASK_TODOLIST set task_subject=? where task_app_src=? and "
				+ fieldName + "=? ";

		try {
			con = ConnectionPool.getConnection();
			pstmt = con.prepareStatement(sql);

			// 
			pstmt.setString(1, subject);
			pstmt.setString(2, appSourceCode);
			pstmt.setString(3, fieldValue);

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

	/**
	 * 更新消息状态
	 * 
	 * @param msgState
	 *            消息状态 具体值要引用消息中心常量类StateEnum中定义的
	 * @param msgId
	 *            消息id
	 * @return
	 */
	private boolean updateMessageState(int msgState, String msgId) {
/*		try {
			if (msgId == null || "".equals(msgId)) {
				return false;
			}

			MsgService msgService = MsgServiceFactory.getMsgService();
			return msgService.updateState(msgState, msgId);
		} catch (Exception ex) {
			log.error(ex);
		}*/

		return false;
	}
	
	
	
	/**
	 * 往TASK_DELIVER表里增加一条数据记录
	 * 
	 * @param msgState
	 *            消息状态 具体值要引用消息中心常量类StateEnum中定义的
	 * @param msgId
	 *            消息id
	 * @return
	 */
	private boolean addTaskDeliver(String taskID,String deliver,String assigner) {
		try {
			Connection con = null;
			PreparedStatement pstmt = null;
			UUID id = new UUID();
			String task_deliver_num = id.toString();// 获取唯一的主键
			//TaskDAO taskdao = new TaskDAO();

			String task_deliver_time = FORMAT.format(new Date()); // 获得当前时间---转交时间

			// 插入TASK_DELIVER表的SQL语句
			String sqlInsert = "insert info cinda_task.TASK_DELIVER (TASK_DELIVER_NUM,TASK_ID,TASK_DELIVER,TASK_ASSIGNEER,TASK_DELIVER_TIME) values(?,?,?,?,?)";
			log.debug("更新转交日志SQL语句" + sqlInsert);

			con = ConnectionPool.getConnection();
			pstmt = con.prepareStatement(sqlInsert);
			try {

				pstmt = con.prepareStatement(sqlInsert);
				pstmt.setString(1, task_deliver_num);
				pstmt.setString(2, taskID);
				pstmt.setString(3, deliver);
				pstmt.setString(4, assigner);
				pstmt.setString(5, task_deliver_time);
				pstmt.executeUpdate();// 执行插入语句
				log.debug("*****增加转交日志表成功********");
				return true;
			} catch (SQLException ex) {
				log.error("任务中心::增加转交日志表失败:" + sqlInsert, ex);
				throw new Exception(ex);
				
			} finally {
				ConnectionPool.release(null, null, pstmt, con);
}

			
			

			
		} catch (Exception ex) {
			log.error(ex);
		}

		return false;
	}
	
	public boolean bactchUpdateSatusByKeys(String keys,String status)
	{
		try {
	
			Connection con = null;
			Statement stmt = null;
			String[] key=keys.split(",");
			String load="";
			for(int i=0;i<key.length;i++)
			{
				load=load+"'" +  key[i] + "'," ;
			}
			System.out.println(load);
			load=load.substring(0,load.length()-1);
			String sqlUpates = "update cinda_task.TASK_TODOLIST set task_status="+"'"+status+"' where task_id in("+load+")";
			log.debug("批量更新任务状态的SQL语句" + sqlUpates);

			con = ConnectionPool.getConnection();
			try {

				stmt = con.createStatement();
				stmt.executeUpdate(sqlUpates);
				//pstmt.setString(1, status);
				//pstmt.setString(2, load);
				//pstmt.executeUpdate();// 执行更新语句
				log.debug("*****批量更新任务状态的SQL成功********");
				return true;
			}catch(SQLException ex)
		   {
				log.error("任务中心::批量更新任务状态失败:" + sqlUpates, ex);
				throw new Exception(ex);
		   }finally {
			   stmt.close();
			   con.close();
		   }

		} catch (Exception ex) {
			log.error(ex);
		}

		return false;
	}
}


