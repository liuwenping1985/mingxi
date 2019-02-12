package cn.com.cinda.taskcenter.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Set;

import org.apache.log4j.Logger;

import cn.com.cinda.taskcenter.common.ConnectionPool;
import cn.com.cinda.taskcenter.common.DeptBean;
import cn.com.cinda.taskcenter.common.TaskInfor;
import cn.com.cinda.taskcenter.util.TaskStatUtil;
import cn.com.cinda.taskcenter.util.TaskUtil;

/**
 * 任务分类统计列表
 * 
 * @author hkgt
 * 
 */
public class QueryTaskStatList {
	private static final SimpleDateFormat FORMAT = new SimpleDateFormat(
			"yyyy-MM-dd HH:mm:ss");

	private Logger log = Logger.getLogger(this.getClass());

	/**
	 * 根据部门编码获得任务分类统计信息
	 * 
	 * @param deptCode
	 *            部门编码
	 * @return
	 */
	public List getTaskStatTree(String deptCode) {
		List taskList = getTaskStatList(deptCode);
		// 待办
		HashMap todoMap = (HashMap) taskList.get(0);
		HashMap todoMapAll = (HashMap) taskList.get(1);

		// 已办
		HashMap doneMap = (HashMap) taskList.get(2);
		HashMap doneMapAll = (HashMap) taskList.get(3);

		List taskDetail = getTaskListDetail(todoMap, doneMap);
		List taskSum = getTaskList(todoMapAll, doneMapAll);

		List ret = new ArrayList();
		ret.add(taskSum);
		ret.add(taskDetail);

		return ret;
	}

	/**
	 * 任务分类统计列表
	 * 
	 * @param sql
	 *            查询语句
	 * @param deptCode
	 *            部门编码
	 * @return
	 */
	public List getTaskStatList(String deptCode) {
		List taskList = new ArrayList();
		// 待办
		HashMap todoMap = new LinkedHashMap();
		HashMap todoMapAll = new LinkedHashMap();

		// 已办
		HashMap doneMap = new LinkedHashMap();
		HashMap doneMapAll = new LinkedHashMap();

		//
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = ConnectionPool.getConnection();

			// 待办任务统计（应用编码、任务来源）
			pstmt = con.prepareStatement(TaskStatUtil.sqlStatTodo);

			pstmt.setString(1, "%"+deptCode+"%");
			pstmt.setString(2, TaskInfor.TASK_STATUS_ASSIGNED + "");
			pstmt.setString(3, TaskInfor.TASK_STATUS_READED + "");
			pstmt.setString(4, TaskInfor.TASK_STATUS_APPED + "");

			rs = pstmt.executeQuery();
			while (rs.next()) {
				// 应用编码
				String appSrc = rs.getString("task_app_src");
				// 任务来源名称
				String taskName = rs.getString("app_var_5");
				// 任务数
				String count = rs.getString("count");

				todoMap.put(appSrc + "," + taskName, appSrc + "," + taskName
						+ "," + count);
			}

			// 待办任务统计（应用编码）
			pstmt = con.prepareStatement(TaskStatUtil.sqlStatTodo2);
			pstmt.setString(1, "%"+deptCode+"%");
			pstmt.setString(2, TaskInfor.TASK_STATUS_ASSIGNED + "");
			pstmt.setString(3, TaskInfor.TASK_STATUS_READED + "");
			pstmt.setString(4, TaskInfor.TASK_STATUS_APPED + "");

			rs = pstmt.executeQuery();
			while (rs.next()) {
				// 应用编码
				String appSrc = rs.getString("task_app_src");
				// 任务数
				String count = rs.getString("count");

				todoMapAll.put(appSrc, count);
			}

			// 已办任务统计（应用编码、任务来源）
			pstmt = con.prepareStatement(TaskStatUtil.sqlStatDone);
			System.out.println(TaskStatUtil.sqlStatDone);

			pstmt.setString(1, "%"+deptCode+"%");
			pstmt.setString(2, TaskInfor.TASK_STATUS_FINISHED + "");

			rs = pstmt.executeQuery();
			while (rs.next()) {
				// 应用编码
				String appSrc = rs.getString("task_app_src");
				// 任务来源名称
				String taskName = rs.getString("app_var_5");
				// 任务数
				String count = rs.getString("count");

				doneMap.put(appSrc + "," + taskName, appSrc + "," + taskName
						+ "," + count);
			}

			// 已办任务统计（应用编码）
			pstmt = con.prepareStatement(TaskStatUtil.sqlStatDone2);
			System.out.println(TaskStatUtil.sqlStatDone2);

			pstmt.setString(1, "%"+deptCode+"%");
			pstmt.setString(2, TaskInfor.TASK_STATUS_FINISHED + "");

			rs = pstmt.executeQuery();
			while (rs.next()) {
				// 应用编码
				String appSrc = rs.getString("task_app_src");
				// 任务数
				String count = rs.getString("count");

				doneMapAll.put(appSrc, count);
			}

			taskList.add(todoMap);
			taskList.add(todoMapAll);
			taskList.add(doneMap);
			taskList.add(doneMapAll);

			return taskList;
		} catch (SQLException ex) {
			log.error(ex);
		} finally {
			ConnectionPool.release(null, null, pstmt, con);
		}

		return taskList;
	}

	/**
	 * 按照部门和部门下的用户进行任务分类统计
	 * 
	 * @param sql
	 *            查询语句
	 * @param deptCode
	 *            部门编码
	 * @return
	 */
	public List getUserTaskStatList(String deptCode) {
		List taskList = new ArrayList();
		// 待办
		List todoList = new ArrayList();

		// 已办
		List doneList = new ArrayList();
		// 待办的任务来源
		List appSrcList = new ArrayList();

		//
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = ConnectionPool.getConnection();

			pstmt = con.prepareStatement(TaskStatUtil.sqlAppSrcList);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				// 应用编码
				String appSrc = rs.getString("task_app_src");
				appSrcList.add(appSrc);
			}

			// 待办任务统计（应用编码）
			pstmt = con.prepareStatement(TaskStatUtil.sqlStatTodo3);
			pstmt.setString(1, "%"+deptCode+"%");
			pstmt.setString(2, TaskInfor.TASK_STATUS_ASSIGNED + "");
			pstmt.setString(3, TaskInfor.TASK_STATUS_READED + "");
			pstmt.setString(4, TaskInfor.TASK_STATUS_APPED + "");

			rs = pstmt.executeQuery();
			while (rs.next()) {
				// 应用编码
				String appSrc = rs.getString("task_app_src");
				// 任务数
				String count = rs.getString("count");
				// 
				String assigneer = rs.getString("task_assigneer");
				// 
				String confirmor = rs.getString("task_confirmor");
				// 不用逗号，因为assigneer、confirmor中可能包含逗号
				todoList.add(appSrc + "=" + count + "=" + assigneer + "="
						+ confirmor);
			}

			// 已办任务统计（应用编码）
			pstmt = con.prepareStatement(TaskStatUtil.sqlStatDone3);

			pstmt.setString(1, "%"+deptCode+"%");
			pstmt.setString(2, TaskInfor.TASK_STATUS_FINISHED + "");

			rs = pstmt.executeQuery();
			while (rs.next()) {
				// 应用编码
				String appSrc = rs.getString("task_app_src");
				// 任务数
				String count = rs.getString("count");
				//
				String executor = rs.getString("task_executor");

				doneList.add(appSrc + "," + count + "," + executor);
			}

			taskList.add(todoList);
			taskList.add(doneList);
			taskList.add(appSrcList);

			return taskList;
		} catch (SQLException ex) {
			log.error(ex);
		} finally {
			ConnectionPool.release(null, null, pstmt, con);
		}

		return taskList;
	}

	/**
	 * 根据部门编码获得所有用户的任务分类统计信息
	 * 
	 * @param deptCode
	 *            部门编码
	 * @return
	 */
	public List getUserTaskStatTree(String deptCode) {
		List ret = new ArrayList();

		DeptBean bean = new DeptBean();
		List users = bean.getUserListByOrganCode(deptCode);

		List taskList = getUserTaskStatList(deptCode);

		// 待办
		List todoList = (List) taskList.get(0);
		// 已办
		List doneList = (List) taskList.get(1);
		// 应用编码
		List appSrcList = (List) taskList.get(2);

		// 页面表头显示
		ret.add(getAppSrcName(appSrcList));

		// 根据用户将待办、已办任务分类
		List userTaskList = getAllUserTaskList(users, todoList, doneList,
				appSrcList);
		List todoListNew = (List) userTaskList.get(0);
		List doneListNew = (List) userTaskList.get(1);

		// 将待办任务、已办任务关联
		for (Iterator iter = users.iterator(); iter.hasNext();) {
			String user = (String) iter.next();
			String userId = user.split("=")[0];
			String userName = user.split("=")[1];
			List taskSum = new ArrayList();
			long allTodo = 0;
			long allDone = 0;
			// long all = 0;
			for (Iterator iterator = appSrcList.iterator(); iterator.hasNext();) {
				String appSrc = (String) iterator.next();
				String t1 = "0";
				String t2 = "0";
				for (Iterator iterator2 = todoListNew.iterator(); iterator2
						.hasNext();) {
					HashMap element = (HashMap) iterator2.next();
					t1 = (String) element.get(appSrc + "," + userId);
					if (t1 != null) {
						break;
					}
				}
				for (Iterator iterator2 = doneListNew.iterator(); iterator2
						.hasNext();) {
					HashMap element = (HashMap) iterator2.next();
					t2 = (String) element.get(appSrc + "," + userId);
					if (t2 != null) {
						break;
					}
				}

				if (t1 == null) {
					t1 = "0";
				}
				if (t2 == null) {
					t2 = "0";
				}

				// 待办合计
				allTodo = allTodo + Long.parseLong(t1);
				// 已办合计
				allDone = allDone + Long.parseLong(t2);
				// all = allTodo + allDone;
				// 待办 已办
				String sum = userName + "," + t1 + "," + t2;
				taskSum.add(sum);
			}
			taskSum.add("total" + "," + allTodo + "," + allDone);
			// taskSum.add(all + "");
			ret.add(taskSum);
		}

		return ret;
	}

	private List getAppSrcName(List appSrcList) {
		List ret = new ArrayList();
		for (Iterator iter = appSrcList.iterator(); iter.hasNext();) {
			String element = (String) iter.next();
			ret.add(TaskUtil.getTaskSourceName(element));
		}

		return ret;
	}

	/**
	 * 根据用户将待办、已办任务分类
	 * 
	 * @param users
	 *            用户列表
	 * @param todoMap
	 *            待办map
	 * @param doneMap
	 *            已办map
	 * @param appSrcList
	 *            应用编码列表
	 * @return
	 */
	private List getAllUserTaskList(List users, List todoList, List doneList,
			List appSrcList) {
		List ret = new ArrayList();
		List todoRet = new ArrayList();
		List doneRet = new ArrayList();
		// 用户列表
		for (Iterator iter = users.iterator(); iter.hasNext();) {
			String element = (String) iter.next();
			String userId = element.split("=")[0];

			HashMap todoMap2 = new LinkedHashMap();
			HashMap doneMap2 = new LinkedHashMap();
			// 应用编码
			for (Iterator iterator = appSrcList.iterator(); iterator.hasNext();) {
				String appSrc = (String) iterator.next();

				long userTodo = 0;
				// 待办
				for (Iterator iterator2 = todoList.iterator(); iterator2
						.hasNext();) {
					String temp = (String) iterator2.next();
					String[] all = temp.split("=");

					String appSrc2 = all[0];
					String count = all[1];
					String assigneer = all[2];
					String confirmor = all[3];

					if (!appSrc2.equals(appSrc)) {
						continue;
					}

					if (assigneer != null && assigneer.indexOf(userId) != -1) {
						userTodo = userTodo + Long.parseLong(count);
					} else if (confirmor != null
							&& confirmor.indexOf(userId) != -1) {
						userTodo = userTodo + Long.parseLong(count);
					}
				}
				//
				todoMap2.put(appSrc + "," + userId, userTodo + "");
			}

			// 已办
			for (Iterator iterator = doneList.iterator(); iterator.hasNext();) {
				String temp = (String) iterator.next();
				String[] all = temp.split(",");

				String appSrc = all[0];
				String count = all[1];
				String executor = all[2];
				if (executor != null && userId.equals(executor)) {
					long userDone = Long.parseLong(count);
					doneMap2.put(appSrc + "," + userId, userDone + "");
				}
			}
			//
			todoRet.add(todoMap2);
			doneRet.add(doneMap2);
		}

		ret.add(todoRet);
		ret.add(doneRet);

		return ret;
	}

	/**
	 * 计算任务来源名称中待办、已办、合计
	 * 
	 * @param todoMap
	 *            待办统计
	 * @param doneMap
	 *            已办统计
	 * @return
	 */
	private List getTaskListDetail(HashMap todoMap, HashMap doneMap) {
		List taskDetail = new ArrayList();
//		changed by fjh 20070702,为了修改关于todo 和　done的合并
		//if(todoMap.size()>doneMap.size())
		//{
		Set set = todoMap.keySet();
		for (Iterator iter = set.iterator(); iter.hasNext();) {
			String e = (String) iter.next();
			String temp = (String) todoMap.get(e);
			String[] temp2 = temp.split(",");
			String appSrc = temp2[0];
			String name = temp2[1];
			String count = temp2[2];

			Object doneTemp = doneMap.get(e);
			// 有待办，没有对应的已办任务
			if (doneTemp == null) {
				// 保存待办、已办、合计
				taskDetail.add(TaskUtil.getTaskSourceName(appSrc) + "," + name
						+ "," + count + "," + "0" + "," + count);
			} else {
				String doneCount = ((String) doneTemp).split(",")[2];
				long total = Long.parseLong(count) + Long.parseLong(doneCount);
				// 保存待办、已办、合计
				taskDetail.add(TaskUtil.getTaskSourceName(appSrc) + "," + name
						+ "," + count + "," + doneCount + "," + total);
			}
		}
		//}else{
			Set set2 = doneMap.keySet();
			for (Iterator iter = set2.iterator(); iter.hasNext();) {
				String e = (String) iter.next();
				String temp = (String) doneMap.get(e);
				String[] temp2 = temp.split(",");
				String appSrc = temp2[0];
				String name = temp2[1];
				String count = temp2[2];

				Object todoTemp = todoMap.get(e);
				// 有待办，没有对应的已办任务
				if (todoTemp == null) {
					// 保存待办、已办、合计
					taskDetail.add(TaskUtil.getTaskSourceName(appSrc) + "," + name
							+ "," + "0" + "," + count + "," + count);
				} 
				/*else {
					String doneCount = ((String) todoTemp).split(",")[2];
					long total = Long.parseLong(count) + Long.parseLong(doneCount);
					// 保存待办、已办、合计
					taskDetail.add(TaskUtil.getTaskSourceName(appSrc) + "," + name
							+ "," + count + "," + doneCount + "," + total);
				}*/
			
			
		//}
		}

		return taskDetail;
	}

	/**
	 * 计算应用编码中待办、已办、合计
	 * 
	 * @param todoMap
	 *            待办统计
	 * @param doneMap
	 *            已办统计
	 * @return
	 */
	private List getTaskList(HashMap todoMapAll, HashMap doneMapAll) {
		List taskList = new ArrayList();
		//changed by fjh 20070702,为了修改关于todo 和　done的合并
		//if(todoMapAll.size()>doneMapAll.size())
		//{
		Set set = todoMapAll.keySet();
		for (Iterator iter = set.iterator(); iter.hasNext();) {
			String element = (String) iter.next();
			String count = (String) todoMapAll.get(element);

			String appSrc = element;
			Object doneTemp = doneMapAll.get(element);
			// 有待办，没有对应的已办任务
			if (doneTemp == null) {
				// 保存待办、已办、合计
				taskList.add(TaskUtil.getTaskSourceName(appSrc) + "," + count
						+ "," + "0" + "," + count);
			} else {
				//insert by fjh 20070702,增加对只有已办没有代办的统计
				if(count==null)
				{
					String doneCount = (String) doneTemp;
					taskList.add(TaskUtil.getTaskSourceName(appSrc) + "," + "0"
							+ "," + doneCount + "," + doneCount);
					
				}
				
				String doneCount = (String) doneTemp;
				long total = Long.parseLong(count) + Long.parseLong(doneCount);
				// 保存待办、已办、合计
				taskList.add(TaskUtil.getTaskSourceName(appSrc) + "," + count
						+ "," + doneCount + "," + total);
			}
		}
		//}
	//else{
			Set set2 = doneMapAll.keySet();
			for (Iterator iter = set2.iterator(); iter.hasNext();) {
				String element = (String) iter.next();
				String count = (String) doneMapAll.get(element);

				String appSrc = element;
				Object todoTemp = todoMapAll.get(element);
				// 有待办，没有对应的已办任务
				if (todoTemp == null) {
					// 保存待办、已办、合计
					taskList.add(TaskUtil.getTaskSourceName(appSrc) + "," + 0
							+ "," + count + "," + count);
				} 
				/*else {
					
					String doneCount = (String) todoTemp;
					long total = Long.parseLong(count) + Long.parseLong(doneCount);
					// 保存待办、已办、合计
					taskList.add(TaskUtil.getTaskSourceName(appSrc) + "," + count
							+ "," + doneCount + "," + total);
				}*/
			}
			
			
			
		//}
		

		return taskList;
	}
}
