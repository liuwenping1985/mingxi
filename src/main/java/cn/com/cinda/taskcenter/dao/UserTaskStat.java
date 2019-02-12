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
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;

import cn.com.cinda.taskclient.service.impl.TaskServiceImpl;
import cn.com.cinda.taskclient.service.impl.UserServiceImpl;

import cn.com.cinda.taskcenter.common.ConnectionPool;
import cn.com.cinda.taskcenter.common.TaskInfor;
import cn.com.cinda.taskcenter.common.UrlHelp;
import cn.com.cinda.taskcenter.util.TaskStatUtil;
import cn.com.cinda.taskcenter.util.TaskUtil;

/**
 * 个人待办、已办任务统计
 * 
 * @author hkgt
 * 
 */
public class UserTaskStat {

	private static final SimpleDateFormat FORMAT = new SimpleDateFormat(
			"yyyy-MM-dd HH:mm:ss");

	private Logger log = Logger.getLogger(this.getClass());

	/**
	 * 根据用户id统计待办、已办统计信息
	 * 
	 * @param userId
	 *            用户id
	 * @return
	 */
	public List getTaskStatTree(String userId) {
		List taskList = getTaskStatList(userId);
		// 待办
		//System.out.println("/////////////////" + userId);
		//System.out.println("/////////////////" + taskList.size());
		HashMap todoMap = (HashMap) taskList.get(0);
		HashMap todoMapAll = (HashMap) taskList.get(1);

		// 已办
		HashMap doneMap = (HashMap) taskList.get(2);
		HashMap doneMapAll = (HashMap) taskList.get(3);
		
		
        //System.out.println("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy");
		
		//System.out.println(doneMap.toString());  

		// 所有任务的待办、已办、合计
		String taskAllSum = (String) taskList.get(4);
		// 所有任务的待办、已办的时间统计
		String taskTimeSum = (String) taskList.get(5);
		String taskfpcountTime = (String) taskList.get(6);
		String taskzbcountTime = (String) taskList.get(7);

		List taskDetail = getTaskListDetail(todoMap, doneMap);
		//System.out.println(taskDetail.toString());
		List taskSum = getTaskList(todoMapAll, doneMapAll);

		List ret = new ArrayList();
		ret.add(taskSum);
		ret.add(taskDetail);
		ret.add(taskAllSum);
		ret.add(taskTimeSum);
		ret.add(taskfpcountTime);
		ret.add(taskzbcountTime);

		return ret;
	}

	/**
	 * 根据用户id统计待办、已办任务
	 * 
	 * @param userId
	 *            用户id
	 * @return
	 */
	public List getTaskStatList(String userId) {
		List taskList = new ArrayList();
		// 待办
		HashMap todoMap = new LinkedHashMap();
		HashMap todoMapAll = new LinkedHashMap();

		// 已办
		HashMap doneMap = new LinkedHashMap();
		
		HashMap doneMapAll = new LinkedHashMap();

		// 所有任务的待办、已办、合计
		String taskSum = "";
		// 所有任务的待办、已办的时间统计
		String taskTimeSum = "";
		// 已分配任务的总数和时间
		String taskfpcountTime = "";
		// 在办任务的总数和时间
		String taskzbcountTime = "";

		//
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = ConnectionPool.getConnection();
//			con = JdbcHelper.getConn();
			
			// 待办任务统计（应用编码、任务来源）
			//获取分类
//		    String groups=UrlHelp.getVal("GROUP","groups");
//		    
//		    String[] groupArr = QueryTodolistNew.getGroups(groups);
			List<String> listapps = UrlHelp.getAllGroupApps();
		    String[] groupArr = listapps.toArray(new String[listapps.size()]);
			String sqlUserStatTodo = "select t.task_app_src task_app_src, t.app_var_5 app_var_5, count(*) count from cinda_task.TASK_TODOLIST t, COPY_TODOLIST c " +
					"where t.task_assigneer=? and (t.task_status=? or t.task_status=? or t.task_status=?) " +
					"and t.TASK_ID = c.TASK_ID " +
					"group by t.task_app_src, t.app_var_5 order by t.task_app_src, t.app_var_5";
			if(groupArr!=null) {
				sqlUserStatTodo = "select tt.task_app_src task_app_src, tt.app_var_5 app_var_5, tt.count count from (" + sqlUserStatTodo + ")tt where tt.TASK_APP_SRC in("; 
				for(int i=0; i<groupArr.length; i++) {
					if(i==0) {
						sqlUserStatTodo += "?";
					} else {
						sqlUserStatTodo += ",?";
					}
				}
				sqlUserStatTodo += ")";
			}
			pstmt = con.prepareStatement(sqlUserStatTodo);
			pstmt.setString(1, userId);
			pstmt.setString(2, TaskInfor.TASK_STATUS_ASSIGNED + "");
			pstmt.setString(3, TaskInfor.TASK_STATUS_READED + "");
		    pstmt.setString(4, TaskInfor.TASK_STATUS_APPED + "");
		    for(int i=0; groupArr!=null&&i<groupArr.length; i++) {
		    	pstmt.setString(5+i, groupArr[i]);
		    }
			
//			pstmt.setString(3, "%," + userId + "%");
//			pstmt.setString(4, "%" + userId + ",%");
//			pstmt.setString(5, userId);
//			pstmt.setString(6, TaskInfor.TASK_STATUS_APPED + "");
//			pstmt.setString(7, userId);

			rs = pstmt.executeQuery();
			//System.out.println("***************111111111111111111111111111");
			// System.out.println("\\\\\\\\\\\\\\\\\\\\\\\\");
			while (rs.next()) {
				// 应用编码
				String appSrc = rs.getString("task_app_src");
				// System.out.println("\\\\\\\\\\\\\\\\"+appSrc);
				// 任务来源名称
				String taskName = rs.getString("app_var_5");
				// 任务数
				String count = rs.getString("count");

				todoMap.put(appSrc + "," + taskName, appSrc + "," + taskName
						+ "," + count);
			}

			// 待办任务统计（应用编码）
			String sqlUserStatTodo2 = "select t.task_app_src, count(*) count from cinda_task.TASK_TODOLIST t, COPY_TODOLIST c " +
					"where t.task_assigneer=? and (t.task_status=? or t.task_status=? or t.task_status=?) " +
					"and t.TASK_ID = c.TASK_ID group by t.task_app_src order by t.task_app_src";
			if(groupArr!=null) {
				sqlUserStatTodo2 = "select tt.task_app_src task_app_src, tt.count count from (" + sqlUserStatTodo2 + ")tt where tt.TASK_APP_SRC in("; 
				for(int i=0; i<groupArr.length; i++) {
					if(i==0) {
						sqlUserStatTodo2 += "?";
					} else {
						sqlUserStatTodo2 += ",?";
					}
				}
				sqlUserStatTodo2 += ")";
			}
			pstmt = con.prepareStatement(sqlUserStatTodo2);
			pstmt.setString(1, userId);
			pstmt.setString(2, TaskInfor.TASK_STATUS_ASSIGNED + "");
			pstmt.setString(3, TaskInfor.TASK_STATUS_READED + "");
		    pstmt.setString(4, TaskInfor.TASK_STATUS_APPED + "");
		    for(int i=0; groupArr!=null&&i<groupArr.length; i++) {
		    	pstmt.setString(5+i, groupArr[i]);
		    }
			rs = pstmt.executeQuery();
			//System.out.println("2222222222222222222222222222");
			long total = 0;
			while (rs.next()) {
				// 应用编码
				String appSrc = rs.getString("task_app_src");
				// 任务数
				String count = rs.getString("count");

				todoMapAll.put(appSrc, count);
				total = total + Long.parseLong(count);
			}

			taskSum = taskSum + total;

			// 已办任务统计（应用编码、任务来源）
			pstmt = con.prepareStatement(TaskStatUtil.sqlUserStatDone);

			pstmt.setString(1, userId);
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
			pstmt = con.prepareStatement(TaskStatUtil.sqlUserStatDone2);

			pstmt.setString(1, userId);
			pstmt.setString(2, TaskInfor.TASK_STATUS_FINISHED + "");

			rs = pstmt.executeQuery();
			long total2 = 0;
			while (rs.next()) {
				// 应用编码
				String appSrc = rs.getString("task_app_src");
				// 任务数
				String count = rs.getString("count");

				doneMapAll.put(appSrc, count);
				total2 = total2 + Long.parseLong(count);
			}

			long t = total + total2;
			taskSum = taskSum + "," + total2 + "," + t;

			// 个人已办任务时间统计(任务执行人存在时，任务已经完成)
			pstmt = con.prepareStatement(TaskStatUtil.userTaskStaTime);

			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				// 总的时间
				float sumv = rs.getFloat("sumv");
				// 平均时间
				float avgv = rs.getFloat("avgv");
				taskTimeSum = sumv + "," + avgv;
			}

			// insert by fjh 20070613,增加对已分配和在办的统计
			String sqlUserStatTodo3 = "select sum(count) count from (" + sqlUserStatTodo2 + ")";
			pstmt = con.prepareStatement(sqlUserStatTodo3);
			
//			pstmt = con.prepareStatement(TaskStatUtil.sqlUserStatTodo5);
			
			pstmt.setString(1, userId);
			pstmt.setString(2, TaskInfor.TASK_STATUS_ASSIGNED + "");
			pstmt.setString(3, TaskInfor.TASK_STATUS_READED + "");
		    pstmt.setString(4, TaskInfor.TASK_STATUS_APPED + "");
		    for(int i=0; groupArr!=null&&i<groupArr.length; i++) {
		    	pstmt.setString(5+i, groupArr[i]);
		    }

//			pstmt.setString(1, TaskInfor.TASK_STATUS_ASSIGNED + "");
//			
//            //修改于20071120，修改了查询条件
//			pstmt.setString(2, (userId.length()+1)+"");
//			pstmt.setString(3,  userId+",");
//			pstmt.setString(4,  userId.length()+"");
//			pstmt.setString(5, ","+userId);
//			pstmt.setString(6, "%,"+userId+",%");
//			pstmt.setString(7, userId);
			
			
			
			
			//pstmt.setString(2, "%," + userId + "%");
			//pstmt.setString(3, "%" + userId + ",%");
			//pstmt.setString(4, userId );

			rs = pstmt.executeQuery();
			//System.out.println("444444444444444444444");
			if (rs.next()) {
				// 已分配总数
				int countfp = rs.getInt("count");
				// 总时间
				//float avgvfp = rs.getFloat("sumv");
				taskfpcountTime = countfp + "," + "";

			}
			pstmt = con.prepareStatement(TaskStatUtil.sqlUserStatTodo4);

			pstmt.setString(1, TaskInfor.TASK_STATUS_APPED + "");
			pstmt.setString(2, userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				// 总的时间
				int countzb = rs.getInt("count");
				// 平均时间
				float avgvzb = rs.getFloat("sumv");
				taskzbcountTime = countzb + "," + avgvzb;
			}
			
			//取得外部应用任务
			List list = getOutTaskStatList(userId);
			todoMap.putAll((Map)list.get(0));
			todoMapAll.putAll((Map)list.get(1));
			doneMap.putAll((Map)list.get(2));
			doneMapAll.putAll((Map)list.get(3));
			String taskSum2 = (String)list.get(4);
//			taskSum = taskSum + "," + total2 + "," + t; + 
//			String taskSum2 = unComplList.get(2) + "," + complList.get(2);
			String[] strArr = null;
			String[] inTaskSum = null;
			String[] OutTaskSum = null;
			if(taskSum!=null) {
				inTaskSum = taskSum.split(",");
				OutTaskSum = taskSum2.split(",");
			}
			if(inTaskSum==null && OutTaskSum!=null) {
				taskSum = OutTaskSum[0] + "," + OutTaskSum[1] + "," + OutTaskSum[0] +  OutTaskSum[1];
			} else if(inTaskSum!=null && OutTaskSum!=null){
				int unCompTaskCount = Integer.parseInt(inTaskSum[0]) + Integer.parseInt(OutTaskSum[0]);
				int compTaskCount = Integer.parseInt(inTaskSum[1]) + Integer.parseInt(OutTaskSum[1]);
				int unAndCompCount = unCompTaskCount + compTaskCount;
				taskSum = unCompTaskCount + "," + compTaskCount + "," + unAndCompCount;
				
			}
			//taskfpcountTime += "," + list.get(6);
			// 处理返回值
			taskList.add(todoMap);
			taskList.add(todoMapAll);
			taskList.add(doneMap);
			taskList.add(doneMapAll);
			taskList.add(taskSum);
			taskList.add(taskTimeSum);

			// insert by fjh 20070613
			taskList.add(taskfpcountTime);
			taskList.add(taskzbcountTime);
		    //System.out.println("*****************"+taskList.size());

			return taskList;
		} catch (SQLException ex) {
			log.error(ex);
		} finally {
			ConnectionPool.release(null, null, pstmt, con);
		}

		return taskList;
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
		// changed by fjh 20070802,当只有已办，没有代办的项目出不来
		//if (todoMap.size() >= doneMap.size()) {
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
					taskDetail.add(TaskUtil.getTaskSourceName2(appSrc) + ","
							+ name + "," + count + "," + "0" + "," + count);
				} else {
					String doneCount = ((String) doneTemp).split(",")[2];
					long total = Long.parseLong(count)
							+ Long.parseLong(doneCount);
					// 保存待办、已办、合计
					taskDetail.add(TaskUtil.getTaskSourceName2(appSrc) + ","
							+ name + "," + count + "," + doneCount + ","
							+ total);
				}
			}
		//}else{
			//System.out.println("uuuuuuuuuuuuuuuuuuuuuuuuuuuu");
			//System.out.println(todoMap.size());
			Set set2 = doneMap.keySet();
			for (Iterator iter = set2.iterator(); iter.hasNext();) {
				String e = (String) iter.next();
				String temp = (String) doneMap.get(e);
				String[] temp2 = temp.split(",");
				String appSrc = temp2[0];
				String name = temp2[1];
				String count = temp2[2];
				Object todoTemp=null;
                if(todoMap.size()>0)
                {
				todoTemp = todoMap.get(e);
                }
				// 有待办，没有对应的已办任务
				if (todoTemp== null) {
					// 保存待办、已办、合计
					taskDetail.add(TaskUtil.getTaskSourceName2(appSrc) + ","
							+ name + "," +"0" + "," + count + "," + count);
					
				 }
				
				/*} else {
					String todoCount = ((String) todoTemp).split(",")[2];
					long total = Long.parseLong(count)
							+ Long.parseLong(todoCount);
					// 保存待办、已办、合计
					taskDetail.add(TaskUtil.getTaskSourceName(appSrc) + ","
							+ name + "," + todoCount + "," + count + ","
							+ total);
				}*/
			//}
			
		}
			//System.out.println("ppppppppppppppppppppppppppppp");
			//System.out.println(taskDetail.toString());
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
		//if(todoMapAll.size()>=doneMapAll.size())
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
				taskList.add(TaskUtil.getTaskSourceName2(appSrc) + "," + count
						+ "," + "0" + "," + count + "," +  appSrc);
			} else {
				String doneCount = (String) doneTemp;
				long total = Long.parseLong(count) + Long.parseLong(doneCount);
				// 保存待办、已办、合计
				taskList.add(TaskUtil.getTaskSourceName2(appSrc) + "," + count
						+ "," + doneCount + "," + total + "," +  appSrc);
			}
		}
		//}else
		//{
			Set set2 = doneMapAll.keySet();
			for (Iterator iter = set2.iterator(); iter.hasNext();) {
				String element = (String) iter.next();
				String count = (String) doneMapAll.get(element);

				String appSrc = element;
				Object todoTemp = todoMapAll.get(element);
				// 有待办，没有对应的已办任务
				if (todoTemp == null) {
					// 保存待办、已办、合计
					taskList.add(TaskUtil.getTaskSourceName2(appSrc) + "," + "0"
							+ "," + count + "," + count + "," +  appSrc);
				}
				/*} else {
					String todoCount = (String) todoTemp;
					long total = Long.parseLong(count) + Long.parseLong(todoCount);
					// 保存待办、已办、合计
					taskList.add(TaskUtil.getTaskSourceName(appSrc) + "," + count
							+ "," + todoCount + "," + total);
				}*/
			}
			
		//}

		return taskList;
	}
	
	
	public List getOutTaskStatList(String userId) {

		List taskList = new ArrayList();
		// 待办
		HashMap todoMap = new LinkedHashMap();
		HashMap todoMapAll = new LinkedHashMap();

		// 已办
		HashMap doneMap = new LinkedHashMap();

		HashMap doneMapAll = new LinkedHashMap();

		// 所有任务的待办、已办、合计
		String taskSum = "";
		// 所有任务的待办、已办的时间统计
		String taskTimeSum = "";
		// 已分配任务的总数和时间
		String taskfpcountTime = "";
		// 在办任务的总数和时间
		String taskzbcountTime = "";


		TaskServiceImpl taskServ = new TaskServiceImpl();
		UserServiceImpl userService = new UserServiceImpl();
		String intUserId = userService.getUserIdByAccount(userId);

		//得到外部应用待办任务
		List unComplList = getUnCompTaskStat(taskServ,intUserId);
		//得到外部应用已办任务
		List complList = getCompTaskStat(taskServ,intUserId);
//		unCompList.add(todoMap);
//		unCompList.add(todoMapAll);
//		unCompList.add(taskSum);
//		unCompList.add(taskfpcountTime);
//		taskSum = taskSum + total;
//		compList.add(doneMap);
//		compList.add(doneMapAll);
//		compList.add(taskSum);
		todoMap = (HashMap)unComplList.get(0);
		todoMapAll = (HashMap)unComplList.get(1);
		doneMap = (HashMap)complList.get(0);;
		doneMapAll = (HashMap)complList.get(1);;
		taskTimeSum = "";
		taskSum = unComplList.get(2) + "," + complList.get(2);
		taskfpcountTime = unComplList.get(3) +"";
		taskzbcountTime="";
		taskList.add(todoMap);
		taskList.add(todoMapAll);
		taskList.add(doneMap);
		taskList.add(doneMapAll);
		taskList.add(taskSum);
		taskList.add(taskTimeSum);

		// insert by fjh 20070613
		taskList.add(taskfpcountTime);
		taskList.add(taskzbcountTime);
	    //System.out.println("*****************"+taskList.size());

		return taskList;
	}

	private List getUnCompTaskStat(TaskServiceImpl taskServ, String userId) {
		
		List unCompList = new ArrayList();
		// 待办
		HashMap todoMap = new LinkedHashMap();
		HashMap todoMapAll = new LinkedHashMap();
		// 已分配任务的总数和时间
		String taskfpcountTime = "";
		
		
		//集团系统任务编码
//		String groups = UrlHelp.getVal("GROUP_OUTAPP2", "group");
		String[] appArr = null;
		List<String> outapps = UrlHelp.getOutSysGroupApp();
		appArr = outapps.toArray(new String[outapps.size()]);
//		if(groups!=null) {
//			appArr = groups.split(",");
//		}
		String[][] gumApp = taskServ.queryTaskCountByApp(appArr, userId, "1");

		//得到每个应用的任务数据
		long total = 0;
		for(int i=0; gumApp!=null&&i<gumApp.length; i++) {
			String appCode = gumApp[i][0];
			//流程名称
			//p.setApp_var_5(TaskAppHelp.getAppNameByCode(ret[i][2]));// 流程名称
			String count = gumApp[i][1];
			if(count==null) {
				count = "0";
			}
			todoMap.put(appCode + "," + "", appCode + "," + ""
					+ "," + count);
			todoMapAll.put(appCode, count+"");
			total = total + Integer.parseInt(count);
		}
		// 把AppCode放入一个map
//		Map appCodeMap = new HashMap();
		//List list = taskServ.queryTaskList(userId, null, 1, 500);
		//taskServ.queryTaskCount(userId, appSysCode);

//		for (int i = 0; list != null && i < list.size(); i++) {
//			Task task = (Task) list.get(i);
//			appCodeMap.put(task.getTask_app_code(), task.getApp_var_5());
//		}

		
//		//得到每个应用的任务数据
//		long total = 0;
//		// 所有任务的待办合计
//		String taskSum = "";
//		Set set = appCodeMap.keySet();
//		for (Iterator iterator = set.iterator(); iterator.hasNext();) {
//			String obj = (String) iterator.next();
//			// 应用编码
//			String appSrc = (String) appCodeMap.get(obj);
//
//			int count = 0;
//
//			for (int i = 0; list != null && i < list.size(); i++) {
//				Task task = (Task) list.get(i);
//				String appCode = task.getTask_app_code();
//				// 任务来源名称
//				String taskName = task.getApp_var_5();
//				if (obj != null && obj.equals(appCode)) {
//					// 任务数
//					count++;
//				}
//				todoMap.put(appCode + "," + "", appCode + "," + ""
//						+ "," + count);
//				todoMapAll.put(appCode, count+"");
//				total = total + count;
//			}
//		}
		
		//得到待办数量
		taskfpcountTime = total + "";
		
		String taskSum = total +"";
		unCompList.add(todoMap);
		unCompList.add(todoMapAll);
		unCompList.add(taskSum);
		unCompList.add(taskfpcountTime);
		
		return unCompList;
	}
	
	private List getCompTaskStat(TaskServiceImpl taskServ, String userId) {
		
		List compList = new ArrayList();
		
		// 已办
		HashMap doneMap = new LinkedHashMap();
		
		HashMap doneMapAll = new LinkedHashMap();
		// 已分配任务的总数和时间
		String taskfpcountTime = "";
		
		//调用外部接口，查询已办任务
		//List list = taskServ.queryTaskListByStatus(userId, null, "3", 1, 500);
//		String groups = UrlHelp.getVal("GROUP_OUTAPP2", "group");
		String[] appArr = null;
		List<String> outapps = UrlHelp.getOutSysGroupApp();
		appArr = outapps.toArray(new String[outapps.size()]);
//		if(groups!=null) {
//			appArr = groups.split(",");
//		}
		String[][] gumApp = taskServ.queryTaskCountByApp(appArr, userId, "3");
		
		//得到每个应用的任务数据
		long total = 0;
		for(int i=0; gumApp!=null&&i<gumApp.length; i++) {
			String appCode = gumApp[i][0];
			//流程名称
			//p.setApp_var_5(TaskAppHelp.getAppNameByCode(ret[i][2]));// 流程名称
			String count = gumApp[i][1];
			if(count==null) {
				count = "0";
			}
			doneMap.put(appCode + "," + "", appCode + "," + ""
					+ "," + count);
			doneMapAll.put(appCode, count+"");
			total = total + Integer.parseInt(count);
		}

//		for (int i = 0; list != null && i < list.size(); i++) {
//			Task task = (Task) list.get(i);
//			appCodeMap.put(task.getTask_app_src(), task.getApp_var_5());
//		}

//		//得到每个应用的任务数据
//		long total = 0;
//		// 所有任务的待办合计
//		String taskSum = "";
//		Set set = appCodeMap.keySet();
//		for (Iterator iterator = set.iterator(); iterator.hasNext();) {
//			String obj = (String) iterator.next();
//			// 应用编码
//			String appSrc = (String) appCodeMap.get(obj);
//
//			int count = 0;
//
//			for (int i = 0; list != null && i < list.size(); i++) {
//				Task task = (Task) list.get(i);
//				String appCode = task.getTask_app_src();
//				// 任务来源名称
//				String taskName = task.getApp_var_5();
//				if (obj != null && obj.equals(appCode)) {
//					// 任务数
//					count++;
//				}
//
//				doneMap.put(appCode + "," + "", appCode + "," + null
//						+ "," + count);
//				doneMapAll.put(appCode, count+"");
//				total = total + count;
//			}
//		}
		
		//得到已办数量
		String taskSum = total+"";
		compList.add(doneMap);
		compList.add(doneMapAll);
		compList.add(taskSum);
		
		return compList;
	}
}
