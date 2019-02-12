package cn.com.cinda.taskcenter.model;

import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.apache.log4j.Logger;
import cn.com.cinda.taskcenter.common.*;
import cn.com.cinda.taskcenter.dao.DbConnection;


/**
 * 任务结果编码表 对应的字段
 *
 * @return 每一个字段
 */

public class QueryResult {
	public QueryResult() {
	}// 构造方法

	private static Logger log = Logger.getLogger(QueryResult.class);

	// QueryResult类中的参数定义

	/**
	 * 查询列表-分页查询-用于一般页面使用
	 *
	 * @param int
	 *            page 页码，如果传零，则表示取所有满足条件的记录
	 * @param int
	 *            pageSize 每页记录条数
	 * @param String
	 *            whereStr 查询条件
	 * @param String
	 *            orderStr 排序字段（按照不同的字段进行降序或者升序的排列）
	 *
	 * @return ArrayList 方法的返回结果(ArrayList)
	 *
	 */

	public static ArrayList QueryTaskList(CommonPara common, String whereStr,
			String orderStr) throws UnsupportedEncodingException {
		// 查询页面的分页查询的方法
		int pageSize = 0; /* 本方法中使用的所需记录条数 */
		int page  = 0; /* 当前页码，如果传零，则表示取所有满足条件的记录 */
		int totalPage = 0; /* 满足条件的记录总页数 */
		int recordNum = 0;// 满足条件的记录总数

		pageSize = common.iPageCountUse;// 获得最大记录条数
		page = common.iCurPageNo;// 获得当前页码

		CommonPara CommonResultInfo = new CommonPara();// 把值放入CommonPara类中
		CommonResultInfo.iCurPageNo = page;
		CommonResultInfo.iPageCountUse = pageSize;

		log.debug("最大记录条数是：" + pageSize);
		log.debug("当前页是：" + page);

		ArrayList taskList = new ArrayList();// 存放页面信息的列表

		Connection con = null;
		PreparedStatement psd = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		log.debug("after getconnection");

		String Sql = "";

		int minRow;// 分页查询的起始行
		int maxRow;// 分页查询的终止行
		minRow = (page - 1) * pageSize + 1; // 起始行的算法
		maxRow = page * pageSize;// 末尾行的算法

		// 分页查询的查询语句
		Sql = "select  c.*  from   (select   rownum ,TASK_TODOLIST.*, row_number()  "
				+ " over (order   by   "
				+ orderStr
				+ ")   rk,TASK_LINK_TYPE.TASK_LINK_FORMAT    from cinda_task.TASK_TODOLIST  , cinda_task.TASK_LINK_TYPE "
				+ whereStr
				+ "  )c  "
				+ " where   rk   between   " + minRow + "   and  " + maxRow;

		log.debug("sql是: " + Sql);
		System.out.println("aaaaaaaaaaaaaasql="+Sql);
		String sqlCount = "select count(*) from cinda_task.TASK_TODOLIST  " + whereStr; // 查询全部消息总条数
		log.debug("任务总条数的sqlCount查询语句是: " + sqlCount);
		try {
			psd = con.prepareStatement(sqlCount);
			rs = psd.executeQuery();
			rs.next();

			recordNum = rs.getInt(1);// 获取当前记录条数
			log.debug("recordNum is" + recordNum);

			/* 如果当前页码为零，表示需要所有记录,否则计算总页数 */
			if (page == 0) {
				log
						.debug("the page is now 0 and will fetch all row which satisfied the condition");
				page = 1;
				if (recordNum != 0) {
					pageSize = recordNum; /* 如果满足条件的记录不为零将每页显示行数设为总行数 */
				}
				log.debug("the pageSize is" + pageSize);
			} else {
				totalPage = recordNum % pageSize == 0 ? recordNum / pageSize
						: recordNum / pageSize + 1;
			}
			/* 添加满足条件的总的记录条数，每页显示的条数和总页数到返回参数Vector对象的第一个类元素CommonPara */
			CommonResultInfo.iTotalRow = recordNum;
			CommonResultInfo.iTotalPage = totalPage;
			taskList.add(CommonResultInfo);// 总页数

			psdSelect = con.prepareStatement(Sql);
			rs = psdSelect.executeQuery();// 查询数据库，执行分页查询
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
				p.setTask_link_format(rs.getString("task_link_format"));
				System.out.println("p.getTask_link_format="+p.getTask_link_format());
				taskList.add(p);
				
				
				

			}

		} catch (SQLException ex) {
			log.error("分页查询的方法出错，错误如下： " + ex.getMessage());
		} finally {
			try {
				rs.close();
				if (psd != null) {
					psd.close();
				}
				if (psdSelect != null) {
					psdSelect.close();
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
		return taskList;
	}

	/**
	 * 查询列表-统计总的分类-用于待办页面使用
	 *
	 * @param int
	 *            page 页码，如果传零，则表示取所有满足条件的记录
	 * @param int
	 *            pageSize 每页记录条数
	 * @param String
	 *            whereStr 查询条件
	 * @param String
	 *            orderStr 排序字段（按照不同的字段进行降序或者升序的排列）
	 * @return ArrayList 方法的返回结果(ArrayList)
	 *
	 */

	public static ArrayList QueryTask_GrouBy_List(int page, int pageSize,
			String whereStr, String orderStr, String groupStr)
			throws UnsupportedEncodingException {
		// 查询页面的分页查询的方法
		int totalPage = 0; /* 满足条件的记录总页数 */
		int recordNum = 0;// 满足条件的记录总数
		// GloabVar CommonResultInfo = new GloabVar();

		log.debug("the pageSize is now=" + pageSize);
		log.debug("the page is now=" + page);

		ArrayList taskList = new ArrayList();// 列表
		Connection con = null;
		PreparedStatement psd = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		log.debug("after getconnection");

		String Sql = "";

		int minRow;// 分页查询的起始行
		int maxRow;// 分页查询的终止行
		minRow = (page - 1) * pageSize + 1; // 起始行的算法
		maxRow = page * pageSize;// 末尾行的算法

		// 分页查询的查询语句
		Sql = "select  task_app_src  from   (select   rownum ,TASK_TODOLIST.*, row_number()  "
				+ " over (order   by   "
				+ orderStr
				+ ")   rk   from cinda_task.TASK_TODOLIST "
				+ whereStr
				+ "  )  "
				+ " where   rk   between   "
				+ minRow
				+ "   and  "
				+ maxRow
				+ groupStr;

		log.debug("sql是: " + Sql);

		String sqlCount = "select count(*) from cinda_task.TASK_TODOLIST  " + whereStr; // 查询全部消息总条数
		log.debug("任务总条数的sqlCount查询语句是: " + sqlCount);
		try {
			psd = con.prepareStatement(sqlCount);
			rs = psd.executeQuery();
			rs.next();
			recordNum = rs.getInt(1);// 获取当前记录条数
			log.debug("recordNum is" + recordNum);
			/* 如果当前页码为零，表示需要所有记录,否则计算总页数 */
			if (page == 0) {
				log
						.debug("the page is now 0 and will fetch all row which satisfied the condition");
				page = 1;
				if (recordNum != 0) {
					pageSize = recordNum; /* 如果满足条件的记录不为零将每页显示行数设为总行数 */
				}
				log.debug("the pageSize is" + pageSize);
			} else {
				totalPage = recordNum % pageSize == 0 ? recordNum / pageSize
						: recordNum / pageSize + 1;
			}

			psdSelect = con.prepareStatement(Sql);
			rs = psdSelect.executeQuery();// 查询数据库，执行分页查询
			while (rs.next()) {
				Task p = new Task();

				p.setTask_app_src(rs.getString("task_app_src"));
				taskList.add(p);

			}

		} catch (SQLException ex) {
			log.error("分页查询的方法出错，错误如下： " + ex.getMessage());
		} finally {
			try {
				rs.close();
				if (psd != null) {
					psd.close();
				}
				if (psdSelect != null) {
					psdSelect.close();
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
		return taskList;
	}

	public static ArrayList QueryTask_GrouBy_Executor(int page, int pageSize,
			String whereStr, String orderStr, String groupStr)
			throws UnsupportedEncodingException {
		// 查询页面的分页查询的方法
		int totalPage = 0; /* 满足条件的记录总页数 */
		int recordNum = 0;// 满足条件的记录总数
		GloabVar CommonResultInfo = new GloabVar();

		log.debug("the pageSize is now=" + pageSize);
		log.debug("the page is now=" + page);

		ArrayList taskList = new ArrayList();// 列表
		Connection con = null;
		PreparedStatement psd = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		log.debug("after getconnection");

		String Sql = "";

		int minRow;// 分页查询的起始行
		int maxRow;// 分页查询的终止行
		minRow = (page - 1) * pageSize + 1; // 起始行的算法
		maxRow = page * pageSize;// 末尾行的算法

		// 分页查询的查询语句
		Sql = "select  Task_executor  from   (select   rownum ,TASK_TODOLIST.*, row_number()  "
				+ " over (order   by   "
				+ orderStr
				+ ")   rk   from cinda_task.TASK_TODOLIST "
				+ whereStr
				+ "  )  "
				+ " where   rk   between   "
				+ minRow
				+ "   and  "
				+ maxRow
				+ groupStr;

		log.debug("sql是: " + Sql);

		String sqlCount = "select count(*) from cinda_task.TASK_TODOLIST  " + whereStr; // 查询全部消息总条数
		log.debug("任务总条数的sqlCount查询语句是: " + sqlCount);
		try {
			psd = con.prepareStatement(sqlCount);
			rs = psd.executeQuery();
			rs.next();
			recordNum = rs.getInt(1);// 获取当前记录条数
			log.debug("recordNum is" + recordNum);
			/* 如果当前页码为零，表示需要所有记录,否则计算总页数 */
			if (page == 0) {
				log
						.debug("the page is now 0 and will fetch all row which satisfied the condition");
				page = 1;
				if (recordNum != 0) {
					pageSize = recordNum; /* 如果满足条件的记录不为零将每页显示行数设为总行数 */
				}
				log.debug("the pageSize is" + pageSize);
			} else {
				totalPage = recordNum % pageSize == 0 ? recordNum / pageSize
						: recordNum / pageSize + 1;
			}

			psdSelect = con.prepareStatement(Sql);
			rs = psdSelect.executeQuery();// 查询数据库，执行分页查询
			while (rs.next()) {
				Task p = new Task();

				p.setTask_executor(rs.getString("task_executor"));
				taskList.add(p);

			}

		} catch (SQLException ex) {
			log.error("分页查询的方法出错，错误如下： " + ex.getMessage());
		} finally {
			try {
				rs.close();
				if (psd != null) {
					psd.close();
				}
				if (psdSelect != null) {
					psdSelect.close();
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
		return taskList;
	}

	public static ArrayList QueryTask_GrouBy_DepCode(int page, int pageSize,
			String whereStr, String orderStr, String groupStr)
			throws UnsupportedEncodingException {
		// 查询页面的分页查询的方法
		int totalPage = 0; /* 满足条件的记录总页数 */
		int recordNum = 0;// 满足条件的记录总数
		GloabVar CommonResultInfo = new GloabVar();

		log.debug("the pageSize is now=" + pageSize);
		log.debug("the page is now=" + page);

		ArrayList taskList = new ArrayList();// 列表
		Connection con = null;
		PreparedStatement psd = null;
		PreparedStatement psdSelect = null;
		ResultSet rs = null;
		DbConnection dbconn = new DbConnection();
		con = dbconn.getConnection();
		log.debug("after getconnection");

		String Sql = "";

		int minRow;// 分页查询的起始行
		int maxRow;// 分页查询的终止行
		minRow = (page - 1) * pageSize + 1; // 起始行的算法
		maxRow = page * pageSize;// 末尾行的算法

		// 分页查询的查询语句
		Sql = "select  dept_code  from   (select   rownum ,TASK_TODOLIST.*, row_number()  "
				+ " over (order   by   "
				+ orderStr
				+ ")   rk   from cinda_task.TASK_TODOLIST "
				+ whereStr
				+ "  )  "
				+ " where   rk   between   "
				+ minRow
				+ "   and  "
				+ maxRow
				+ groupStr;

		log.debug("sql是: " + Sql);

		String sqlCount = "select count(*)  from cinda_task.TASK_TODOLIST  " + whereStr; // 查询全部消息总条数
		log.debug("任务总条数的sqlCount查询语句是: " + sqlCount);
		try {
			psd = con.prepareStatement(sqlCount);
			rs = psd.executeQuery();
			rs.next();
			recordNum = rs.getInt(1);// 获取当前记录条数
			log.debug("recordNum is" + recordNum);
			/* 如果当前页码为零，表示需要所有记录,否则计算总页数 */
			if (page == 0) {
				log
						.debug("the page is now 0 and will fetch all row which satisfied the condition");
				page = 1;
				if (recordNum != 0) {
					pageSize = recordNum; /* 如果满足条件的记录不为零将每页显示行数设为总行数 */
				}
				log.debug("the pageSize is" + pageSize);
			} else {
				totalPage = recordNum % pageSize == 0 ? recordNum / pageSize
						: recordNum / pageSize + 1;
			}

			psdSelect = con.prepareStatement(Sql);
			rs = psdSelect.executeQuery();// 查询数据库，执行分页查询
			while (rs.next()) {
				Task p = new Task();

				p.setDept_code(rs.getString("dept_code"));
				taskList.add(p);

			}

		} catch (SQLException ex) {
			log.error("分页查询的方法出错，错误如下： " + ex.getMessage());
		} finally {
			try {
				rs.close();
				if (psd != null) {
					psd.close();
				}
				if (psdSelect != null) {
					psdSelect.close();
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
		return taskList;
	}

}
