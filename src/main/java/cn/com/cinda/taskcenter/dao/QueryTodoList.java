package cn.com.cinda.taskcenter.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.log4j.Logger;

import cn.com.cinda.taskcenter.common.CommonPara;
import cn.com.cinda.taskcenter.common.ConnectionPool;
import cn.com.cinda.taskcenter.common.TaskInfor;
import cn.com.cinda.taskcenter.common.UserInfor;
import cn.com.cinda.taskcenter.model.Task;
import cn.com.cinda.taskcenter.util.TaskLinkUtil;
import cn.com.cinda.taskcenter.util.TaskUtil;

/**
 * 查询待办列表
 * 
 * @author hkgt
 * 
 */
public class QueryTodoList {

	private static final SimpleDateFormat FORMAT = new SimpleDateFormat(
			"yyyy-MM-dd HH:mm:ss");

	private Logger log = Logger.getLogger(this.getClass());

	/**
	 * 查询待办列表
	 * 
	 * @param common
	 *            分页信息
	 * @param sql
	 *            查询语句
	 * @param userId
	 *            用户id
	 * @return
	 */
	public List getTodoList(CommonPara common, String sql, String userId) {
		List taskList = new ArrayList();

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
			pstmt = con.prepareStatement(TaskUtil.sqlCountTodo);

			pstmt.setString(1, TaskInfor.TASK_STATUS_ASSIGNED + "");
			pstmt.setString(2, TaskInfor.TASK_STATUS_READED + "");
			pstmt.setString(3, (userId.length()+1)+"");
			pstmt.setString(4,  userId+",");
			pstmt.setString(5,  userId.length()+"");
			pstmt.setString(6, ","+userId );
			pstmt.setString(7, "%,"+userId+",%");
			pstmt.setString(8, userId);
			pstmt.setString(9, TaskInfor.TASK_STATUS_APPED + "");
			pstmt.setString(10,userId );
			
			//pstmt.setString(3, "%," + userId + "%");
			//pstmt.setString(4, "%" + userId + ",%");
			//pstmt.setString(5,  userId );
			//pstmt.setString(6, TaskInfor.TASK_STATUS_APPED + "");
			//pstmt.setString(7,  userId );

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

			
			pstmt = con.prepareStatement(sql);

			pstmt.setString(1, TaskInfor.TASK_STATUS_ASSIGNED + "");
			pstmt.setString(2, TaskInfor.TASK_STATUS_READED + "");
			//insert by fjh ,20071116,修改了查询语句
			pstmt.setString(3, (userId.length()+1)+"");
			pstmt.setString(4,  userId+",");
			pstmt.setString(5,  userId.length()+"");
			pstmt.setString(6, ","+userId);
			pstmt.setString(7, "%,"+userId+",%");
			pstmt.setString(8, userId);
			pstmt.setString(9, TaskInfor.TASK_STATUS_APPED + "");
			pstmt.setString(10,userId );
			pstmt.setInt(11, minRow);
			pstmt.setInt(12, maxRow);
			
			//pstmt.setString(3, "%," + userId + "%");
			//pstmt.setString(4, "%" + userId + ",%");
			//pstmt.setString(5, userId );
			//pstmt.setString(6, TaskInfor.TASK_STATUS_APPED + "");
			//pstmt.setString(7,   userId );
			//pstmt.setInt(8, minRow);
			//pstmt.setInt(9, maxRow);

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
//				changed by fjh 20070614,因为任务的分配人可能是多个，多个是用','隔开的
				String userids=rs.getString("task_assigneer");
				String useridch="";
				if((userids!=null)&&(userids.length()>0))
				{
					String[] userIds=userids.split(",");
					for(int i=0;i<userIds.length;i++)
					{
						if(userIds[i].equals("weblogic")||(userIds[i].equals("taskcenter")))
						{
							continue;
						}
						else{
							String name=UserInfor.getUserNameById(userIds[i]);
							if(name!=null)
							{
							useridch=useridch+UserInfor.getUserNameById(userIds[i])+",";
							}else{
								useridch=useridch+userIds[i]+",";
								
							}
						}
					}
				}
				//p.setTask_assigneer(TaskUtil.replaceNull(UserInfor
				//		.getUserNameById(rs.getString("task_assigneer"))));
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

				p.setTask_designator(TaskUtil.replaceNull(UserInfor.getUserNameById(rs.getString("task_designator"))));
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
				//其他连接
				String linkType2=rs.getString("task_link2_type");
				//System.out.println("linkType2://///////////////="+linkType2);
				String task_link_format2 = TaskLinkUtil.getTaskLink(linkType2,
						hm, p);
			    //System.out.println("//////////////////////task_link_format2"+task_link_format2);
				p.setTask_link_format2(task_link_format2);
				//System.out.println("get="+p.getTask_link_format2());
				//taskList.add(p);
				String linkType3=rs.getString("task_link3_type");
				String task_link_format3 = TaskLinkUtil.getTaskLink(linkType3,
						hm, p);
				p.setTask_link_format3(task_link_format3);
				//taskList.add(p);
				String linkType4=rs.getString("task_link4_type");
				String task_link_format4 = TaskLinkUtil.getTaskLink(linkType4,
						hm, p);
				p.setTask_link_format4(task_link_format4);
				//taskList.add(p);
				String linkType5=rs.getString("task_link5_type");
				String task_link_format5= TaskLinkUtil.getTaskLink(linkType5,
						hm, p);
				p.setTask_link_format5(task_link_format5);
				taskList.add(p);
			}

			return taskList;
		} catch (SQLException ex) {
			log.error(ex);
		} finally {
			ConnectionPool.release(null, null, pstmt, con);
		}

		return taskList;
	}

}
