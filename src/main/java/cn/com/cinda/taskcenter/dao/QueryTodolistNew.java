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

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.log4j.Logger;

import cn.com.cinda.taskcenter.common.CommonPara;
import cn.com.cinda.taskcenter.common.ConnectionPool;
import cn.com.cinda.taskcenter.common.OutAndInSysTaskHelp;
import cn.com.cinda.taskcenter.common.UrlHelp;
import cn.com.cinda.taskcenter.common.UserInfor;
import cn.com.cinda.taskcenter.model.Task;
import cn.com.cinda.taskcenter.util.TaskLinkUtil;
import cn.com.cinda.taskcenter.util.TaskUtil;
import cn.com.cinda.taskclient.service.impl.TaskServiceImpl;
import cn.com.cinda.taskclient.service.impl.UserServiceImpl;

import com.seeyon.apps.taskcenter.constant.TaskCenterConstant;

public class QueryTodolistNew {

	public List getTodoList(String userId) {
		List taskList;
		Connection con;
		PreparedStatement pstmt;
		ResultSet rs;
		taskList = new ArrayList();
		con = null;
		pstmt = null;
		rs = null;
		try {
			con = ConnectionPool.getConnection();
			// con = JdbcHelper.getConn();
			int count = 0;
			String sql = "select sum(count) as count_sum from ( select count(*) as count from cinda_task.TASK_TODOLIST where task_status='13' and task_confirmor = ? union all select count(*) as count from cinda_task.TASK_TODOLIST where task_id in (select task_id from cinda_task.COPY_TODOLIST where TASK_ASSIGNEER=?) and (task_status='11' or task_status='12')  )";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userId);
			pstmt.setString(2, userId);
			rs = pstmt.executeQuery();
			if (rs.next())
				count = rs.getInt(1);
			String flag = "true";
			int top = count;
			int pageSize = TaskCenterConstant.pageSize;
//			if (UrlHelp.getVal("TODO", "top") != null
//					&& UrlHelp.getVal("TODO", "top").length() > 0)
//				top = Integer.valueOf(UrlHelp.getVal("TODO", "top")).intValue() - 100;
			top = pageSize-100;
			if (count > top)
				flag = "false";
			pstmt = con.prepareStatement("select * from cinda_task.TASK_LINK_TYPE");
			rs = pstmt.executeQuery();
			HashMap hm = new HashMap();
			String appSrc;
			String state;
			String link;
			for (; rs.next(); hm.put(appSrc + "," + state, link)) {
				appSrc = rs.getString("task_linkType_code");
				state = rs.getString("TASK_LINK_STATUS");
				link = rs.getString("task_link_format");
			}

			if ("true".equals(flag)) {
				String sql_todo = "select *  from ( select * from cinda_task.TASK_TODOLIST where task_status='13' and task_confirmor = ? union all select * from cinda_task.TASK_TODOLIST where task_id in (select task_id from cinda_task.COPY_TODOLIST where TASK_ASSIGNEER=?) and (task_status='11' or task_status='12') ) order by task_assignee_time desc";
				pstmt = con.prepareStatement(sql_todo);
				pstmt.setString(1, userId);
				pstmt.setString(2, userId);
			} else {
				pstmt = con
						.prepareStatement("select * from (select rownum,c.*, row_number() over (order by task_assignee_time desc) rk from (  select * from ( select * from cinda_task.TASK_TODOLIST where task_status='13' and task_confirmor =? union all select *  from cinda_task.TASK_TODOLIST where task_id in (select task_id from cinda_task.COPY_TODOLIST where TASK_ASSIGNEER=?)  and (task_status='11' or task_status='12') ))c) where rk between ? and ?");
				pstmt.setString(1, userId);
				pstmt.setString(2, userId);
				pstmt.setInt(3, 0);
				pstmt.setInt(4, top);
			}
			Task p;
			for (rs = pstmt.executeQuery(); rs.next(); taskList.add(p)) {
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
				String time = rs.getString("task_assignee_time");
				time = time.substring(5, 16);
				p.setTask_assignee_time(time);
				String userids = rs.getString("task_assigneer");
				String useridch = "";
				if (userids != null && userids.length() > 0) {
					String userIds[] = userids.split(",");
					for (int i = 0; i < userIds.length; i++)
						if (!userIds[i].equals("weblogic")
								&& !userIds[i].equals("taskcenter")) {
							String name = UserInfor.getUserNameById(userIds[i]);
							if (name != null)
								useridch = useridch
										+ UserInfor.getUserNameById(userIds[i])
										+ ",";
							else
								useridch = useridch + userIds[i] + ",";
						}

				}
				p.setTask_assigneer(useridch);
				p.setTask_batch_id(rs.getString("task_batch_id"));
				p.setTask_batch_name(rs.getString("task_batch_name"));
				p.setTask_cc(rs.getString("task_cc"));
				p.setTask_creator(rs.getString("task_creator"));
				p.setTask_comments(rs.getString("task_comments"));
				p.setTask_confirm_time(rs.getString("task_confirm_time"));
				p.setTask_confirmor(rs.getString("task_confirmor"));
				p.setTask_content(rs.getString("task_content"));
				p.setTask_create_time(rs.getString("task_create_time"));
				p.setTask_designator(TaskUtil.replaceNull(UserInfor
						.getUserNameById(rs.getString("task_designator"))));
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
				if (subject == null)
					subject = "";
				p.setTask_subject(subject);
				p.setTask_submit(rs.getString("task_submit"));
				p.setTask_submit_time(rs.getString("task_submit_time"));
				p.setTask_app_state(rs.getString("task_app_state"));
				String linkType = rs.getString("task_link_type");
				String task_link_format = TaskLinkUtil.getTaskLink(linkType,
						hm, p);
				p.setTask_link_format(task_link_format);
				String linkType2 = rs.getString("task_link2_type");
				String task_link_format2 = TaskLinkUtil.getTaskLink(linkType2,
						hm, p);
				p.setTask_link_format2(task_link_format2);
				String linkType3 = rs.getString("task_link3_type");
				String task_link_format3 = TaskLinkUtil.getTaskLink(linkType3,
						hm, p);
				p.setTask_link_format3(task_link_format3);
				String linkType4 = rs.getString("task_link4_type");
				String task_link_format4 = TaskLinkUtil.getTaskLink(linkType4,
						hm, p);
				p.setTask_link_format4(task_link_format4);
				String linkType5 = rs.getString("task_link5_type");
				String task_link_format5 = TaskLinkUtil.getTaskLink(linkType5,
						hm, p);
				p.setTask_link_format5(task_link_format5);
			}

		} catch (SQLException ex) {
			log.error(ex);
		} finally {
			ConnectionPool.release(rs, null, pstmt, con);
		}
		return taskList;
	}

	/**
	 * 我的工作中分组模式查询待办列表，数量少于200时与首页显示一致，超过200时显示200条记录
	 * 
	 * @param userId
	 *            用户id
	 * @param group
	 *            分组信息
	 * @return
	 */
	public List getTodoList(String userId, String group2) {
		List taskList = new ArrayList();

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			String sql = "select * from (select t.* from (select * from cinda_task.TASK_TODOLIST where task_status=? and task_confirmor=? union all "
					+ " select * from cinda_task.TASK_TODOLIST where task_id in (select task_id from cinda_task.COPY_TODOLIST where task_assigneer=?) "
					+ " and (task_status=? or task_status=?)) t order by t.task_assignee_time desc) where rownum < 501";

			log.info(sql);
			
			con = ConnectionPool.getConnection();
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, "13");
			pstmt.setString(2, userId);
			pstmt.setString(3, userId);
			pstmt.setString(4, "11");
			pstmt.setString(5, "12");

			// 查询待办列表
			rs = pstmt.executeQuery();

			// 应用对应的分类
			Map srcMap = OutAndInSysTaskHelp.getTaskGroupMap();
			while (rs.next()) {
				String src = rs.getString("task_app_src");
				if (!srcMap.containsKey(src)) {
					continue;
				}
				
				Task p = new Task();
				p.setApp_var_1(doRepNull(rs.getString("app_var_1")));
				p.setApp_var_2(doRepNull(rs.getString("app_var_2")));
				p.setApp_var_3(doRepNull(rs.getString("app_var_3")));
				p.setApp_var_4(doRepNull(rs.getString("app_var_4")));
				p.setApp_var_5(doRepNull(rs.getString("app_var_5")));
				p.setApp_var_6(doRepNull(rs.getString("app_var_6")));
				p.setApp_var_7(doRepNull(rs.getString("app_var_7")));
				p.setApp_var_8(doRepNull(rs.getString("app_var_8")));
				p.setApp_var_9(doRepNull(rs.getString("app_var_9")));
				p.setDelflag(new Integer(rs.getInt("delflag")));
				p.setDept_code(rs.getString("dept_code"));
				p.setTask_allow_deliver(new Integer(rs
						.getInt("task_allow_deliver")));
				p.setTask_app_src(src);
				p.setTask_app_moudle(rs.getString("TASK_APP_MOUDLE"));
				p.setTask_assignee_rule(rs.getString("task_assignee_rule"));
				String time = rs.getString("task_assignee_time");
				// time = time.substring(5, 16);
				p.setTask_assignee_time(time);
				String userids = rs.getString("task_assigneer");
				String useridch = "";
				if (userids != null && userids.length() > 0) {
					String userIds[] = userids.split(",");
					for (int i = 0; i < userIds.length; i++) {
						if (!userIds[i].equals("weblogic")
								&& !userIds[i].equals("taskcenter")) {
							String name = UserInfor.getUserNameById(userIds[i]);
							if (name != null) {
								useridch = useridch
										+ UserInfor.getUserNameById(userIds[i])
										+ ",";
							} else {
								useridch = useridch + userIds[i] + ",";
							}
						}
					}
				}
				p.setTask_assigneer(useridch);
				p.setTask_batch_id(rs.getString("task_batch_id"));
				p.setTask_batch_name(rs.getString("task_batch_name"));
				p.setTask_cc(rs.getString("task_cc"));
				p.setTask_creator(rs.getString("task_creator"));
				p.setTask_comments(rs.getString("task_comments"));
				p.setTask_confirm_time(rs.getString("task_confirm_time"));
				p.setTask_confirmor(rs.getString("task_confirmor"));
				p.setTask_content(rs.getString("task_content"));
				p.setTask_create_time(rs.getString("task_create_time"));
				p.setTask_designator(TaskUtil.replaceNull(UserInfor
						.getUserNameById(rs.getString("task_designator"))));
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
				p.setTask_app_state(doRepNull(rs.getString("task_app_state")));
				String linkType = rs.getString("task_link_type");
				String task_link_format = TaskLinkUtil.getTaskLink(linkType,
						LinkHelper.getLinkTypeMap(), p);
				p.setTask_link_format(task_link_format);
				String linkType2 = rs.getString("task_link2_type");
				String task_link_format2 = TaskLinkUtil.getTaskLink(linkType2,
						LinkHelper.getLinkTypeMap(), p);
				p.setTask_link_format2(task_link_format2);
				String linkType3 = rs.getString("task_link3_type");
				String task_link_format3 = TaskLinkUtil.getTaskLink(linkType3,
						LinkHelper.getLinkTypeMap(), p);
				p.setTask_link_format3(task_link_format3);
				String linkType4 = rs.getString("task_link4_type");
				String task_link_format4 = TaskLinkUtil.getTaskLink(linkType4,
						LinkHelper.getLinkTypeMap(), p);
				p.setTask_link_format4(task_link_format4);
				String linkType5 = rs.getString("task_link5_type");
				String task_link_format5 = TaskLinkUtil.getTaskLink(linkType5,
						LinkHelper.getLinkTypeMap(), p);
				p.setTask_link_format5(task_link_format5);

				taskList.add(p);
			}

		} catch (Exception ex) {
			log.error(ex);
			ex.printStackTrace();
		} finally {
			ConnectionPool.release(rs, null, pstmt, con);
		}

//		List ret = new ArrayList();
//		int len = taskList.size();
//		// 取最新200条
//		for (int i = 0; i < len && i < 200; i++) {
//			ret.add(taskList.get(i));
//		}
//
//		return ret;
		return taskList;
	}

	// 查询公司首页待办任务数量w
	public HashMap countTodolistByGroup(String userId, String group2) {
		HashMap ret = new LinkedHashMap();

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			String sql = "select count(task_app_src) as count,min(task_app_src) as appSrc from (select task_app_src from cinda_task.TASK_TODOLIST where task_status=? and task_confirmor=? union all "
					+ " select task_app_src from cinda_task.TASK_TODOLIST where task_id in (select task_id from cinda_task.COPY_TODOLIST where task_assigneer=?) "
					+ " and (task_status=? or task_status=?)) group by task_app_src";

			con = ConnectionPool.getConnection();
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, "13");
			pstmt.setString(2, userId);
			pstmt.setString(3, userId);
			pstmt.setString(4, "11");
			pstmt.setString(5, "12");

			// 应用对应的分类
			Map srcMap = OutAndInSysTaskHelp.getTaskGroupMap();

			// 查询待办任务数
			rs = pstmt.executeQuery();
			while (rs.next()) {
				int count = rs.getInt("count");
				String src = rs.getString("appSrc");
				if (srcMap.containsKey(src)) {
					String n = (String) srcMap.get(src);
					try {
						if (ret.containsKey(n)) {
							int tmp = Integer.parseInt((String) ret.get(n))
									+ count;// 累加
							ret.put(n, tmp + "");
						} else {
							ret.put(n, count + "");
						}
					} catch (Exception exx) {
						log.error("",exx);
					}
				}
			}
		} catch (SQLException ex) {
			log.error(ex);
		} finally {
			ConnectionPool.release(rs, null, pstmt, con);
		}

		Map typeN = OutAndInSysTaskHelp.getGroupTypeName();
		Set set = typeN.keySet();
		for (Iterator iterator = set.iterator(); iterator.hasNext();) {
			String type = (String) iterator.next();
			if (!ret.containsKey(type)) {
				ret.put(type, "0");
			}
		}

		return ret;
	}

	// 公司首页，显示待办任务数量w
	public HashMap getCountByGrours(String userId) {
		TaskServiceImpl taskSeive = new TaskServiceImpl();
		
		// 得到集团userId
		UserServiceImpl userService = new UserServiceImpl();
//		????集团的用户id是个什么鬼
		String jtUserId = userService.getUserIdByAccount(userId);
		log.info("jtUserId=="+jtUserId);
		// 获得资产平台待办数量
		HashMap result = countTodolistByGroup(userId, null);

		// 获得集团平台任务待办数量
//		String groups = UrlHelp.getVal("GROUP_OUTAPP2", "group");
//		String[] appArr = null;
//		if(groups!=null) {
//			appArr = groups.split(",");
//		}
		List<String> groups = UrlHelp.getOutSysGroupApp();
		//获得集团平台除公文阅文以外的任务待办数量
		String[][] gumApp = taskSeive.queryTaskCountByFlag(groups.toArray(new String[groups.size()]), jtUserId, "2", "1");
		Map gumCount = new HashMap();
		for(int i=0; gumApp!=null&&i<gumApp.length; i++) {
			String src = gumApp[i][0];
			String count = gumApp[i][1];
			gumCount.put(src, count);
		}

		// 应用对应的分类
		Map srcMap = OutAndInSysTaskHelp.getTaskGroupMap();
		Set set = gumCount.keySet();
		for (Iterator iterator = set.iterator(); iterator.hasNext();) {
			String t = (String) iterator.next();// MBLC
			String v = (String) gumCount.get(t);// 10

			String typeName = (String) srcMap.get(t);// 业务类
			if (result.containsKey(typeName)) {
				String total = (String) result.get(typeName);
				int count = Integer.parseInt(total) + Integer.parseInt(v);// 两部分相加
				result.put(typeName, +count + "");
			}
		}

		//获得待办任务总数量是否到200条
		int totalCount = 0;
		Set resultkey = result.keySet();
		for (Iterator iterator = resultkey.iterator(); iterator.hasNext();) {
			String typeName = (String) iterator.next();
			String value = (String)result.get(typeName);
			totalCount += Integer.parseInt(value);
		}
		log.info("totalCount=" + totalCount);
		//如果待办任务的总数量不到200条，再次调用接口查询公文阅文待办的数量
		if(totalCount<200){ 
			String[] gumRead = taskSeive.queryYueWenTaskCount(jtUserId, "1");
			if(gumRead!=null && gumRead.length==2){
				String srcName = (String) gumRead[0];
				String value = (String)  gumRead[1];
				int readNumber = Integer.parseInt(value);
				log.info("公文阅文系统代码：" + srcName + "  公文阅文待办数量=" + readNumber);
				
				int number = 0;
				int restValue = 200 - totalCount;
				if(readNumber >= restValue) { 
					number = restValue;
				} else {
					number = readNumber;
				}
				String typeName = (String) srcMap.get(srcName);// 业务类
				if (result.containsKey(typeName)) {
					String total = (String) result.get(typeName);
					int count = Integer.parseInt(total) + number;// 原来的待办数量加上公文阅文待办的数量
					result.put(typeName, +count + "");
				}
			}
		}
		
		return result;
	}

	public List getTodoList(CommonPara common, String sql, String userId) {
		List taskList;
		Connection con;
		PreparedStatement pstmt;
		ResultSet rs;
		label0: {
			taskList = new ArrayList();
			int iPageCountUse = common.iPageCountUse;
			int iCurPageNo = common.iCurPageNo;
			int iTotalRow = 0;
			int iTotalPage = 0;
			int minRow = (iCurPageNo - 1) * iPageCountUse + 1;
			int maxRow = iCurPageNo * iPageCountUse;
			CommonPara resultInfo = new CommonPara();
			resultInfo.iCurPageNo = iCurPageNo;
			resultInfo.iPageCountUse = iPageCountUse;
			con = null;
			pstmt = null;
			rs = null;
			List list;
			try {
				con = ConnectionPool.getConnection();
				String sql_count = "select sum(count) as count_sum from ( select count(*) as count from cinda_task.TASK_TODOLIST where task_status='13' and task_confirmor = ? union all select count(*) as count from cinda_task.TASK_TODOLIST where task_id in (select task_id from cinda_task.COPY_TODOLIST where TASK_ASSIGNEER=?) and (task_status='11' or task_status='12')  )";
				pstmt = con.prepareStatement(sql_count);
				pstmt.setString(1, userId);
				pstmt.setString(2, userId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					iTotalRow = rs.getInt(1);
					if (iTotalRow % iPageCountUse == 0)
						iTotalPage = iTotalRow / iPageCountUse;
					else
						iTotalPage = iTotalRow / iPageCountUse + 1;
				}
				resultInfo.iTotalRow = iTotalRow;
				resultInfo.iTotalPage = iTotalPage;
				taskList.add(resultInfo);
				pstmt = con.prepareStatement("select * from cinda_task.TASK_LINK_TYPE");
				rs = pstmt.executeQuery();
				HashMap hm = new HashMap();
				String appSrc;
				String state;
				String link;
				for (; rs.next(); hm.put(appSrc + "," + state, link)) {
					appSrc = rs.getString("task_linkType_code");
					state = rs.getString("TASK_LINK_STATUS");
					link = rs.getString("task_link_format");
				}

				pstmt = con.prepareStatement(sql);
				System.out.println("************************" + sql);
				pstmt.setString(1, userId);
				pstmt.setString(2, userId);
				pstmt.setInt(3, minRow);
				pstmt.setInt(4, maxRow);
				Task p;
				for (rs = pstmt.executeQuery(); rs.next(); taskList.add(p)) {
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
					String time = rs.getString("task_assignee_time");
					time = time.substring(5, 16);
					p.setTask_assignee_time(time);
					String userids = rs.getString("task_assigneer");
					String useridch = "";
					if (userids != null && userids.length() > 0) {
						String userIds[] = userids.split(",");
						for (int i = 0; i < userIds.length; i++)
							if (!userIds[i].equals("weblogic")
									&& !userIds[i].equals("taskcenter")) {
								String name = UserInfor
										.getUserNameById(userIds[i]);
								if (name != null)
									useridch = useridch
											+ UserInfor
													.getUserNameById(userIds[i])
											+ ",";
								else
									useridch = useridch + userIds[i] + ",";
							}

					}
					p.setTask_assigneer(useridch);
					p.setTask_batch_id(rs.getString("task_batch_id"));
					p.setTask_batch_name(rs.getString("task_batch_name"));
					p.setTask_cc(rs.getString("task_cc"));
					p.setTask_creator(rs.getString("task_creator"));
					p.setTask_comments(rs.getString("task_comments"));
					p.setTask_confirm_time(rs.getString("task_confirm_time"));
					p.setTask_confirmor(rs.getString("task_confirmor"));
					p.setTask_content(rs.getString("task_content"));
					p.setTask_create_time(rs.getString("task_create_time"));
					p.setTask_designator(TaskUtil.replaceNull(UserInfor
							.getUserNameById(rs.getString("task_designator"))));
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
					p.setTask_msg_status(new Integer(rs
							.getInt("task_msg_status")));
					p.setTask_result_code(rs.getString("task_result_code"));
					p.setTask_stage_name(rs.getString("task_stage_name"));
					p.setTask_status(rs.getString("task_status"));
					String subject = rs.getString("task_subject");
					if (subject == null)
						subject = "";
					p.setTask_subject(subject);
					p.setTask_submit(rs.getString("task_submit"));
					p.setTask_submit_time(rs.getString("task_submit_time"));
					p.setTask_app_state(rs.getString("task_app_state"));
					String linkType = rs.getString("task_link_type");
					String task_link_format = TaskLinkUtil.getTaskLink(
							linkType, hm, p);
					p.setTask_link_format(task_link_format);
					String linkType2 = rs.getString("task_link2_type");
					String task_link_format2 = TaskLinkUtil.getTaskLink(
							linkType2, hm, p);
					p.setTask_link_format2(task_link_format2);
					String linkType3 = rs.getString("task_link3_type");
					String task_link_format3 = TaskLinkUtil.getTaskLink(
							linkType3, hm, p);
					p.setTask_link_format3(task_link_format3);
					String linkType4 = rs.getString("task_link4_type");
					String task_link_format4 = TaskLinkUtil.getTaskLink(
							linkType4, hm, p);
					p.setTask_link_format4(task_link_format4);
					String linkType5 = rs.getString("task_link5_type");
					String task_link_format5 = TaskLinkUtil.getTaskLink(
							linkType5, hm, p);
					p.setTask_link_format5(task_link_format5);
				}

				list = taskList;
			} catch (SQLException ex) {
				log.error(ex);
				break label0;
			} finally {
				ConnectionPool.release(rs, null, pstmt, con);
			}
			ConnectionPool.release(rs, null, pstmt, con);
			return list;
		}
		ConnectionPool.release(rs, null, pstmt, con);
		return taskList;
	}

	/**
	 * 我的工作列表模式查询待办列表，数量与首页相符
	 * 
	 * @param common
	 *            分页信息
	 * @param sql
	 *            查询语句
	 * @param userId
	 *            用户id
	 * @param group
	 *            分组信息
	 * @return
	 */
	public List getTodoList(CommonPara common, String sql, String userId,
			String[] group) {
		List taskList = new ArrayList();
		String groups[];

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
			// con = JdbcHelper.getConn();
			groups = getGroups(group);

			// insert by fjh 20081106,增加了修改计算总数的
			String sql_hastodo_cnt = "select count(*) as count from cinda_task.TASK_TODOLIST where task_status='13' and task_confirmor = ? and task_app_src in(";

			if (groups != null) {
				for (int i = 0; i < groups.length; i++) {
					if (i == groups.length - 1) {
						sql_hastodo_cnt = sql_hastodo_cnt + "?)";
					} else {
						sql_hastodo_cnt = sql_hastodo_cnt + "?,";
					}
				}

			}
			String sql_todo_cnt = "select count(*) as count from cinda_task.TASK_TODOLIST where task_id in (select task_id from cinda_task.COPY_TODOLIST where TASK_ASSIGNEER=?) and (task_status='11' or task_status='12') and task_app_src in(";
			if (groups != null) {
				for (int i = 0; i < groups.length; i++) {
					if (i == groups.length - 1) {
						sql_todo_cnt = sql_todo_cnt + "?)";
					} else {
						sql_todo_cnt = sql_todo_cnt + "?,";
					}
				}

			}
			// String sql_count = "select sum(count) as count_sum from ( "
			// + TaskUtilAdd.sqlCountHasdoByUserID + " union all "
			// + TaskUtilAdd.sqlCountTodoByUserID + " )";

			String sql_count = "select sum(count) as count_sum from ( "
					+ sql_hastodo_cnt + " union all " + sql_todo_cnt + ")";
			pstmt = con.prepareStatement(sql_count);

			pstmt.setString(1, userId);
			int t = groups.length;
			for (int i = 0; i < groups.length; i++) {
				pstmt.setString(2 + i, groups[i]);
			}

			// pstmt.setString(2, userId);
			pstmt.setString(1 + t + 1, userId);
			for (int i = 0; i < groups.length; i++) {
				pstmt.setString(2 + t + 1 + i, groups[i]);
			}

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
			// sql =
			// "select * from (select rownum,c.*, row_number() over (order by task_assignee_time desc) rk from (  select * from ( select * from cinda_task.TASK_TODOLIST where task_status='13' and task_confirmor =? union all  select *  from cinda_task.TASK_TODOLIST where task_id in (select task_id from cinda_task.COPY_TODOLIST where TASK_ASSIGNEER=?)  and (task_status='11' or task_status='12') ))c) where rk between ? and ?";
			String sql_hastodo = "select rownum,c.*, row_number() over (order by task_assignee_time desc) rk from (  select * from ( select * from cinda_task.TASK_TODOLIST where task_status='13' and task_confirmor =?  and task_app_src in(";
			if (groups != null) {
				for (int i = 0; i < groups.length; i++) {
					if (i == groups.length - 1) {
						sql_hastodo = sql_hastodo + "?)";
					} else {
						sql_hastodo = sql_hastodo + "?,";
					}
				}

			}
			String sql_todo_2nd = "select *  from cinda_task.TASK_TODOLIST where task_id in (select task_id from cinda_task.COPY_TODOLIST where TASK_ASSIGNEER=?)  and (task_status='11' or task_status='12')  and task_app_src in(";
			if (groups != null) {
				for (int i = 0; i < groups.length; i++) {
					if (i == groups.length - 1) {
						sql_todo_2nd = sql_todo_2nd + "?)";
					} else {
						sql_todo_2nd = sql_todo_2nd + "?,";
					}
				}

			}
			// String sql_todo =
			// "select * from (select rownum,c.*, row_number() over (order by task_assignee_time desc) rk from (  select * from ( select * from cinda_task.TASK_TODOLIST where task_status='13' and task_confirmor =? union all select *  from cinda_task.TASK_TODOLIST where task_id in (select task_id from cinda_task.COPY_TODOLIST where TASK_ASSIGNEER=?)  and (task_status='11' or task_status='12')  and task_app_src in(";
			sql = "select * from (" + sql_hastodo + " union all "
					+ sql_todo_2nd;

			sql += " ))c) where rk between ? and ?";

			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userId);
			for (int i = 0; i < groups.length; i++) {
				pstmt.setString(2 + i, groups[i]);
			}

			// pstmt.setString(2, userId);
			pstmt.setString(1 + t + 1, userId);
			for (int i = 0; i < groups.length; i++) {
				pstmt.setString(2 + t + 1 + i, groups[i]);
			}
			pstmt.setInt((2 + 2 * groups.length + 1), minRow);
			pstmt.setInt((2 + 2 * groups.length + 2), maxRow);

			// pstmt = con.prepareStatement(sql);
			// //System.out.println("************************"+sql);
			//
			// pstmt.setString(1, userId);
			// pstmt.setString(2, userId);
			// pstmt.setInt(3, minRow);
			// pstmt.setInt(4, maxRow);

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
				// changed by fjh 20070614,因为任务的分配人可能是多个，多个是用','隔开的
				String userids = rs.getString("task_assigneer");
				String useridch = "";
				if ((userids != null) && (userids.length() > 0)) {
					String[] userIds = userids.split(",");
					for (int i = 0; i < userIds.length; i++) {
						if (userIds[i].equals("weblogic")
								|| (userIds[i].equals("taskcenter"))) {
							continue;
						} else {
							String name = UserInfor.getUserNameById(userIds[i]);
							if (name != null) {
								useridch = useridch
										+ UserInfor.getUserNameById(userIds[i])
										+ ",";
							} else {
								useridch = useridch + userIds[i] + ",";

							}
						}
					}
				}
				p.setTask_assigneer(useridch);
				p.setTask_batch_id(rs.getString("task_batch_id"));
				p.setTask_batch_name(rs.getString("task_batch_name"));
				p.setTask_cc(rs.getString("task_cc"));

				p.setTask_creator(rs.getString("task_creator"));
				p.setTask_comments(rs.getString("task_comments"));
				p.setTask_confirm_time(rs.getString("task_confirm_time"));
				p.setTask_confirmor(rs.getString("task_confirmor"));
				p.setTask_content(rs.getString("task_content"));
				p.setTask_create_time(rs.getString("task_create_time"));

				p.setTask_designator(TaskUtil.replaceNull(UserInfor
						.getUserNameById(rs.getString("task_designator"))));
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
						hm, p);
				p.setTask_link_format(task_link_format);
				// 其他连接
				String linkType2 = rs.getString("task_link2_type");
				String task_link_format2 = TaskLinkUtil.getTaskLink(linkType2,
						hm, p);
				p.setTask_link_format2(task_link_format2);
				String linkType3 = rs.getString("task_link3_type");
				String task_link_format3 = TaskLinkUtil.getTaskLink(linkType3,
						hm, p);
				p.setTask_link_format3(task_link_format3);
				String linkType4 = rs.getString("task_link4_type");
				String task_link_format4 = TaskLinkUtil.getTaskLink(linkType4,
						hm, p);
				p.setTask_link_format4(task_link_format4);
				String linkType5 = rs.getString("task_link5_type");
				String task_link_format5 = TaskLinkUtil.getTaskLink(linkType5,
						hm, p);
				p.setTask_link_format5(task_link_format5);
				taskList.add(p);
			}

			return taskList;
		} catch (SQLException ex) {
			log.error(ex);
		} finally {
			ConnectionPool.release(rs, null, pstmt, con);
		}

		return taskList;
	}

	static String[] getGroups(String[] groups) {
		List<String> list = new ArrayList<String>();
//		String[] groups = group.split(",");
		int iLen = groups.length;
		int iCnt = 0;
		for (int i = 0; i < iLen; i++) {
			String strGroup = groups[i]; // group1,group2,group3
			List<String> tmps = UrlHelp.getGroupApps(strGroup);
			list.addAll(tmps);
//			String group_src = UrlHelp.getVal("GROUP_APP", strGroup);
//			String[] tmp = group_src.split(",");
//			for (int j = 0; j < tmp.length; j++) {
//				list.add(tmp[j]);
//			}
		}

//		String[] ret = new String[list.size()];
//		for (int i = 0; i < list.size(); i++) {
//			ret[i] = (String) list.get(i);
//		}

		return list.toArray(new String[list.size()]);
	}

	public String doRepNull(String src){
		if(src == null){
			return "";
		}else {
			return src.trim();
		}
	}
	
	private static final SimpleDateFormat FORMAT = new SimpleDateFormat(
			"yyyy-MM-dd HH:mm:ss");
	private static final Log log = LogFactory.getLog(QueryTodolistNew.class);

}