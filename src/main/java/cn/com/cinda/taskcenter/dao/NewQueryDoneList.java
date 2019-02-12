// Decompiled by DJ v3.7.7.81 Copyright 2004 Atanas Neshkov  Date: 2011-3-9 下午 04:49:38
// Home Page : http://members.fortunecity.com/neshkov/dj.html  - Check often for new version!
// Decompiler options: packimports(3) 
// Source File Name:   NewQueryDoneList.java

package cn.com.cinda.taskcenter.dao;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;

import cn.com.cinda.taskcenter.common.CommonPara;
import cn.com.cinda.taskcenter.common.ConnectionPool;
import cn.com.cinda.taskcenter.common.UserInfor;
import cn.com.cinda.taskcenter.model.Task;
import cn.com.cinda.taskcenter.util.TaskLinkUtil;
import cn.com.cinda.taskcenter.util.TaskUtil;
import cn.com.cinda.taskclient.service.impl.TaskServiceImpl;
import cn.com.cinda.taskclient.service.impl.UserServiceImpl;

public class NewQueryDoneList {

	public NewQueryDoneList() {
		log = Logger.getLogger(getClass());
	}

	public List getDoneList(CommonPara common, String sql2, String userId) {
		// 资产平台已办任务
		List zcList = getDoneListOne(null, userId);

		System.out.println("zc um done size=" + zcList.size());

		// 根据用户的账号获得集团版用户id
		UserServiceImpl userService = new UserServiceImpl();
		String gumUserId = userService.getUserIdByAccount(userId);

		// 集团用户管理已办
		TaskServiceImpl taskService = new TaskServiceImpl();
		List gumList = taskService.queryTaskDoneListByStatus(gumUserId, "", "3", 1, 200);

		System.out.println("gum done size=" + gumList.size());

		List allList = new ArrayList();
		allList.addAll(zcList);
		allList.addAll(gumList);

		return allList;
	}

	public List getTotalList(String sql, String useraccount, String userId) {
		List list1 = getDoneListOne(sql, useraccount);
		List list2 = getOtherList(useraccount, userId);
		List totalList = new ArrayList();
		totalList = list1;
		if (null != list2) {
			totalList.addAll(list2);
		}
		int total = totalList.size();
		Task tmp = null;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		Date d1 = null;
		Date d2 = null;
		Task tmp2 = null;
		try {
			for (int i = 0; i < total; ++i) {
				for (int j = 0; j < total - i - 1; ++j) {
					tmp = (Task) totalList.get(j);
					tmp2 = (Task) totalList.get(j + 1);
					d1 = sdf.parse(tmp.getTask_submit_time());
					d2 = sdf.parse(tmp2.getTask_submit_time());
					if (d2.compareTo(d1) > 0) {
						totalList.set(j, tmp2);
						totalList.set(j + 1, tmp);
					}
				}
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return totalList;
	}

	/**
	 * 第一部分所有记录条数
	 * 
	 * @param userId
	 *            用户条数
	 * @return
	 */
	public int getListOneCount(String userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count1 = 0; // 第一部分记录条数
		try {
			con = ConnectionPool.getConnection();
			pstmt = con
					.prepareStatement("select sum(count) as sum from(select count(*) as count  from cinda_task.TASK_TODOLIST where task_executor=? and task_status='14'  and (task_batch_name<>'\u6D41\u7A0B\u7ED3\u675F' or task_batch_name is null) union all select count(*) as count from cinda_task.TASK_TODOLIST where  task_executor=?  and task_status='14'  and (task_batch_name='\u6D41\u7A0B\u7ED3\u675F' ) and ROUND(TO_NUMBER(sysdate -  to_date(task_submit_time,'YYYY-MM-DD   HH24:MI:SS')))<7  )");
			pstmt.setString(1, userId);
			pstmt.setString(2, userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				// 获得总的记录条数
				count1 = rs.getInt(1);
			}
		} catch (Exception ex) {
			log.error(ex);
		} finally {
			ConnectionPool.release(null, null, pstmt, con);
		}
		if (count1 > 100) {
			count1 = 100;
		}
		return count1;
	}

	/**
	 * 第一部分列表（查询资产平台，旧任务中心已办数据列表wd）
	 * 
	 * @param sql
	 *            查询sql
	 * @param userId
	 *            用户ID
	 * @return List
	 */
	private List getDoneListOne(String sql2, String userId) {
		List list = new ArrayList();

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			String sqlStr = "select a.*, rownum rn from (select * from cinda_task.task_todolist "
					+ " where task_status=? and task_executor=? "
					+ " and task_batch_name is not null order by task_submit_time desc) a where rownum<=?";

			log.info(sqlStr);

			con = ConnectionPool.getConnection();
			pstmt = con.prepareStatement(sqlStr);
			pstmt.setString(1, "14");// 已办状态
			pstmt.setString(2, userId);
			pstmt.setInt(3, 200);// max record

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
				//time = time.substring(5, 16);
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
				p.setTask_app_state(rs.getString("task_app_state"));
				String linkType = rs.getString("task_link_type");
				String task_link_format = TaskLinkUtil.getTaskLink(linkType,
						LinkHelper.getLinkTypeMap(), p);
				p.setTask_link_format(task_link_format);

				
				//客开 赵辉  判断 新旧数据问题
				p.setApp_var_9("lowData");
				list.add(p);
			}
		} catch (SQLException ex) {
			log.error(ex);
			ex.printStackTrace();
		} finally {
			ConnectionPool.release(rs, null, pstmt, con);
		}

		return list;
	}

	/**
	 * 获得task已办事务列表
	 * 
	 * @param userid
	 *            用户ID
	 * @return List
	 * @throws IOException
	 */
	private List getOtherList(String account, String userid) {
		// 第二部分记录条数
		int count2 = getOtherListCount(account, userid);
		TaskServiceImpl task = new TaskServiceImpl();
		List list = task.queryTaskListByStatus(userid, "", "3", 1, count2);
		return list;
	}

	/**
	 * 获得用户的已办列表总数
	 * 
	 * @param userid
	 *            用户ID
	 * @return
	 * @throws IOException
	 */
	private int getOtherListCount(String account, String userid) {
		TaskServiceImpl task = new TaskServiceImpl();
		int count2 = task.queryTaskCountByStatus(userid, "", "3");
		int count1 = getListOneCount(account); // 第一部分记录条数
		if (count2 != 0) {
			if (count2 > 100) {
				count2 = 100;
				if (count1 < 100) {
					count2 = 200 - count1;
				}
			}
		}
		return count2;
	}

	private static final SimpleDateFormat FORMAT = new SimpleDateFormat(
			"yyyy-MM-dd HH:mm:ss");
	private Logger log;

}