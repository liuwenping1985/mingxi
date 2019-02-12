package com.seeyon.apps.checkin.dao;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import org.hibernate.Session;

import com.seeyon.apps.checkin.client.CheckUtils;
import com.seeyon.apps.checkin.domain.CheckInInstall;
import com.seeyon.apps.checkin.domain.InitCheckIn;
import com.seeyon.apps.checkin.domain.WorkDaySet;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.dao.BaseHibernateDao;

public class InitCheckInDaoImpl extends BaseHibernateDao<InitCheckIn> implements InitCheckInDao{

	private static SystemProperties sys = SystemProperties.getInstance();	// 获取properties地址内容
	
	/**
	 * 判断用户是否为不打卡人
	 * @param check
	 * @return  true:不打卡人；false:打卡人
	 */
	public boolean nocheckinuser(InitCheckIn check){
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sqlnocheckmem = "select t.id from nocheckuser t where t.userid='" + check.getUserId() + "'";
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sqlnocheckmem);
			rs = ps.executeQuery();
			if(rs.next()){
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			destroyDBObj(rs,ps,conn);
			super.releaseSession(session);
		}
		return false;
	}
	
	/**
	 * 判断用户是否是为不打卡部门
	 * @param check
	 * @return  true:不打卡部门；false:打卡部门
	 */
	public boolean nocheckindepartmentchild(InitCheckIn check){
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		// ============================================
		// org_member表的字段org_post_id位主岗ID
		// ============================================
		String sqlnocheckdep = "select t.id from org_member t ,nocheckdepartment d where t.org_department_id = d.orgid and t.id = '" + check.getUserId() + "'";
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sqlnocheckdep);
			rs = ps.executeQuery();
			if(rs.next()){
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			destroyDBObj(rs,ps,conn);
			super.releaseSession(session);
		}
		return false;
	}
	
	/**
	 * 插入打卡明细表
	 * @param check
	 */
	public boolean insertcheckdetail(InitCheckIn check){
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sqlmx = "insert into checkindetails(id,userid,checktime) values(?,?,?)";
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sqlmx);
			//主键
			ps.setString(1, UUID.randomUUID().toString());
			// 用户id
			ps.setString(2, check.getUserId());
			//当前打卡时间
			ps.setTimestamp(3, check.getCheckTime());
			ps.executeUpdate();
			return true;
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			destroyDBObj(rs,ps,conn);
			super.releaseSession(session);
		}
		return false;
	}
	
	/**
	 * 查询用户的请假类型
	 * @return
	 */
	public String queryLeaveType(String userid, String checkdate){
		String leavetype = null;
		
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "select t.leavetype from initcheckin t where t.userid='" + userid + "' and to_char(t.checkdate,'yyyy-MM-dd')='" + checkdate + "'";
		
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			while(rs.next()){
				return leavetype = rs.getString("leavetype");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			destroyDBObj(rs,ps,conn);
			super.releaseSession(session);
		}
		
		return leavetype;
	}
	
	/**
	 * 更新个人打卡表 // 9:上午旷工 0:下午旷工 1:上午正常打卡 2:下午正常打卡 -1:迟到 -2:早退
	 * @param check
	 */
	public void updatecheckin(String leavetype,int checkflag,String userid,String nowdate,Timestamp checkdt,boolean workneed)
	{
		Connection conn = null;
		PreparedStatement ps = null;
		String sql = "";
		boolean leaveFlg = true;//员工没有请假
		if(null == leavetype || "".equals(leavetype)){} else leaveFlg = false;
		Session session = super.getSession();
		conn = session.connection();
		try {
			if (checkflag==0){
				if(leaveFlg)
					sql = "update initcheckin set pmchecktime = ?,flag='1' where userid='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='" + nowdate + "'";
				else
					sql = "update initcheckin set pmchecktime = ? where userid='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='" + nowdate + "'";
				session = super.getSession();
				conn = session.connection();
				ps = conn.prepareStatement(sql);
				ps.setTimestamp(1, checkdt);
				ps.executeUpdate();
			}
			else if (checkflag == 9){}
			else if (checkflag==1){}
			else if (checkflag ==-1){}
			else if(checkflag==2){//下午正常
				String flg = checkamtime(userid,nowdate);
				if("0".equals(flg)){
					if(leaveFlg)
						sql = "update initcheckin set pmchecktime = ?,flag='0' where userid='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='" + nowdate + "'";
					else
						sql = "update initcheckin set pmchecktime = ? where userid='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='" + nowdate + "'";
					// 删除考勤查询表数据
					session = super.getSession();
					conn = session.connection();
					deletedepcheck(userid,nowdate);
				}else{
					if(leaveFlg)
						sql = "update initcheckin set pmchecktime = ?,flag = '1' where userid='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='" + nowdate + "'";
					else
						sql = "update initcheckin set pmchecktime = ? where userid='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='" + nowdate + "'";
				}
				session = super.getSession();
				conn = session.connection();
				ps = conn.prepareStatement(sql);
				ps.setTimestamp(1, checkdt);
				ps.executeUpdate();
			}else if(checkflag ==-2){//下午早退
				if(leaveFlg)
					sql = "update initcheckin set pmchecktime = ? ,flag = '1' where userid='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='" + nowdate + "'";
				else
					sql = "update initcheckin set pmchecktime = ?  where userid='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='" + nowdate + "'";
				session = super.getSession();
				conn = session.connection();
				ps = conn.prepareStatement(sql);
				ps.setTimestamp(1, checkdt);
				ps.executeUpdate();
			}
			
			if (!workneed)
			{
				sql = "update initcheckin set flag = '0' where userid='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='" + nowdate + "'";
				session = super.getSession();
				conn = session.connection();
				ps = conn.prepareStatement(sql);
				ps.executeUpdate();
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally
		{
			destroyDBObj(null,ps,conn);
			super.releaseSession(session);
		}
	}
	
	/**
	 * 校验上午打卡是否正常
	 * @return 0:正常 1:异常
	 */
	public String checkamtime(String userid,String checkdate){
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		Session session = super.getSession();
		conn = session.connection();
		try {
			String sql = "select t.amchecktime from initcheckin t where t.userid='" + userid + "' and to_char(t.checkdate,'yyyy-MM-dd')='" + checkdate + "'";
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			if(rs.next()){
				Timestamp amchecktime = rs.getTimestamp("amchecktime");
				Date amcheckdate = null;
				if(null == amchecktime){
					amcheckdate = null;
					return "1";
				}else{
					amcheckdate = new Date(amchecktime.getTime());
				}
				int flg = 0;
				//判断今天有没有打卡 true：已经打过卡；false：今天还没有打卡
				boolean ret = this.isnot(userid, checkdate);
				//判断当前打卡的时间段   
				// 9:上午旷工    0:下午旷工   1:上午正常打卡  2:下午正常打卡    -1:迟到    -2:早退
				if(ret){
					flg = checkinflag(userid,amcheckdate);
				}else{
					flg = checkinstate(amcheckdate);
				}
				if(flg == 9){//上午旷工
					return "1";
				}else if(flg == 0){//下午旷工
					return "1";
				}else if(flg == 1){//上午正常打卡
					return "0";
				}else if(flg == 2){//下午正常打卡
					return "1";
				}else if(flg == -1){//迟到
					return "1";
				}else if(flg == -2){//早退
					return "1";
				}
			}else{
				return "1";//上午没有打卡
			}
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			destroyDBObj(rs,ps,conn);
			super.releaseSession(session);
		}
		return "1";
	}
	
	/**
	 * 查询考勤设置表
	 * 
	 * @return
	 */
	public List<CheckInInstall> selectffectivect() {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<CheckInInstall> checkset = null;
		// 上午打卡时间（开始）,上午打卡时间（结束）,下午打卡时间（开始）,下午打卡时间（结束）,异常判定时间点,异常流程发起时间,请假流程审批有效时间段
		String sql = "select t.amstarttime,t.amendtime,t.pmstarttime,t.pmendtime,t.errortime,t.processstarttime,t.approvaltime from checkininstall t"; 
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			checkset = new ArrayList<CheckInInstall>();
			while(rs.next()){
				CheckInInstall check = new CheckInInstall();
				check.setAmStartTime(rs.getString("amstarttime"));
				check.setAmEndTime(rs.getString("amendtime"));
				check.setPmStartTime(rs.getString("pmstarttime"));
				check.setPmEndTime(rs.getString("pmendtime"));
				check.setErrorTime(rs.getString("errortime"));
				check.setProcessStartTime(rs.getString("processstarttime"));
				check.setApprovalTime(rs.getString("approvaltime"));
				checkset.add(check);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(rs,ps,conn);
			super.releaseSession(session);
	    }
		return checkset;
	}
	
	/**
	 * 插入个人打卡表
	 * @param checkflag
	 * @param check
	 * @param nowdd
	 * @param checkdt
	 */
	public void insertcheckin(int checkflag, InitCheckIn check,Date nowdd){
		Connection conn = null;
		PreparedStatement ps = null;
		
		StackTraceElement[] temp = Thread.currentThread().getStackTrace();
		StackTraceElement b = (StackTraceElement) temp[1];
		StackTraceElement a = (StackTraceElement) temp[2];
		
		File file = new File("checkin1.txt");
		if(!file.exists()){
			try {
				file.createNewFile();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		FileOutputStream fos=null;
		try {
			fos = new FileOutputStream(file,true);
		} catch (FileNotFoundException e1) {
			e1.printStackTrace();
		}
		
		String amstarttime = "";// 上午有效时间开始
		String amendtime = "";// 上午有效时间结束
		String pmstarttime = "";// 下午有效时间开始
		String pmendtime = "";// 下午有效时间结束
		// 考勤设置表集合及相关属性
		List<CheckInInstall> rsset = selectffectivect();
		if(null!=rsset){// 考勤设置集合
			for (CheckInInstall checkin : rsset) {
				amstarttime = checkin.getAmStartTime();//上午打卡有效开始时间
				amendtime = checkin.getAmEndTime();//上午打卡有效结束时间
				pmstarttime = checkin.getPmStartTime();//下午打卡有效开始时间
				pmendtime = checkin.getPmEndTime();//下午打卡有效结束时间
			}
		}
		String sql = "insert into initcheckin(id,userid,checkdate,flag,week,amchecktime,pmchecktime,debugday,leavetype,amstarttime,amendtime,pmstarttime,pmendtime,lateflag,latenum,ip,mac) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		Session session = super.getSession();
		conn = session.connection();
		try {
			// 插入用户打卡记录表
			ps = conn.prepareStatement(sql);
			UUID uuid = UUID.randomUUID();
			ps.setString(1, uuid.toString());// 主键
			ps.setString(2, check.getUserId());// 用户id
			java.sql.Date ud = new java.sql.Date(nowdd.getTime());
			ps.setDate(3, ud);// 打卡日期	
			ps.setString(4, "1");// 状态(0:正常；1:异常)
			ps.setString(5, check.getWeek());// 星期
			ps.setLong(8, 0);// 异常天数
			ps.setString(9, "");// 请假类型
			ps.setString(10, amstarttime);//上午打卡时间（开始）
			ps.setString(11, amendtime);//上午打卡时间（结束）
			ps.setString(12, pmstarttime);//下午打卡时间（开始）
			ps.setString(13, pmendtime);//下午打卡时间（结束）
			ps.setString(14, "0");//迟到早退标志
			ps.setString(15, "0");//迟到早退次数
			ps.setString(16, check.getIp());//ip
			ps.setString(17, check.getMac());//mac
			if(checkflag==9){//上午旷工
				ps.setTimestamp(6, check.getCheckTime());// 上午打卡时间
				ps.setTimestamp(7, null);// 下午打卡时间
			}else if(checkflag==0){//下午旷工,
				ps.setTimestamp(6, null);// 上午打卡时间
				ps.setTimestamp(7, check.getCheckTime());// 下午打卡时间
			}else if(checkflag==1){//上午打卡正常
				ps.setTimestamp(6, check.getCheckTime());// 上午打卡时间
				ps.setTimestamp(7, null);// 下午打卡时间
			}else if(checkflag==2){//下午正常打卡
				ps.setTimestamp(6, null);// 上午打卡时间
				ps.setTimestamp(7, check.getCheckTime());// 下午打卡时间
			}else if(checkflag==-1){//上午迟到
				ps.setTimestamp(6, check.getCheckTime());
				ps.setTimestamp(7, null);// 下午打卡时间
			}else if(checkflag==-2){//下午早退
				ps.setTimestamp(6, null);// 上午打卡时间
				ps.setTimestamp(7, check.getCheckTime());// 下午打卡时间
			}
			ps.executeUpdate();
			
			//===================================================
			if(check.getUserId()==null){
				StringBuffer value =  new StringBuffer();
				String time = getTime();
				value.append(time + "=========================\r\n");
				value.append("当前方法名称:" + b.getMethodName()).append("\r\n");
				value.append("上级文件名称:").append(a.getFileName()).append("\r\n");
				value.append("上级类名:").append(a.getClassName()).append("\r\n");
				value.append("上级方法名称:").append(a.getMethodName()).append("\r\n");
				value.append("上级方法行号:").append(a.getLineNumber()).append("\r\n");
				try {
					fos.write(value.toString().getBytes());
					fos.close();
				} catch (FileNotFoundException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			//===================================================
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			destroyDBObj(null,ps,conn);
			super.releaseSession(session);
		}
	}
	
	public String getTime(){
		Calendar c = Calendar.getInstance();
		StringBuffer timesb = new StringBuffer();
		timesb.append(c.get(Calendar.YEAR) + "年");
		timesb.append(c.get(Calendar.MONTH) + 1 + "月");
		timesb.append(c.get(Calendar.DAY_OF_MONTH) + "日");
		timesb.append(c.get(Calendar.HOUR_OF_DAY) + "时");
		timesb.append(c.get(Calendar.MINUTE) + "分");
		timesb.append(c.get(Calendar.SECOND) + "秒");
		timesb.append(c.get(Calendar.MILLISECOND) + "毫秒");
		return timesb.toString();
	}
	
	/**
	 * 判断个人打卡时间表中是否已经有当天的数据
	 * @param userid
	 * @param checkdate
	 * @return
	 */
	public boolean isnot(String userid,String checkdate){
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		Session session = super.getSession();
		conn = session.connection();
		try {
			String sql = "select t.id from  initcheckin t where t.userid='" + userid + "' and to_char(t.checkdate,'yyyy-MM-dd')='" + checkdate + "'";
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			if(rs.next()){
				return true;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			destroyDBObj(rs,ps,conn);
			super.releaseSession(session);
		}
		return false;
	}
	
	/**
	 * 用户打卡信息保存
	 * 
	 * @param check
	 * @return String 
	 * 				打卡完成后，设置打卡状态
	 *		        -1: 打卡失败
	 *		         0: 正常打卡
	 *		         1: 异常打卡
	 *		         2: 不打卡部门
	 *		         3: 不打卡人
	 *               4: 休息日，无需打卡
	 */
	public String savecheck(InitCheckIn check) 
	{
		String methodName = Thread.currentThread().getStackTrace()[1].getMethodName();
		System.out.println("methodName:" + methodName);
		try {
			// 打卡时间
			Date nowdd = new Date(check.getCheckTime().getTime());
			DateFormat ymddf = new SimpleDateFormat("yyyy-MM-dd");
			// 当前打卡时间
			Timestamp checkdt = check.getCheckTime();
			// 判断今天有没有打卡 true：已经打过卡；false：今天还没有打卡
			boolean ret = this.isnot(check.getUserId(), ymddf.format(nowdd));
			// 判断当前打卡的时间段
			// 9:上午旷工 0:下午旷工 1:上午正常打卡 2:下午正常打卡 -1:迟到 -2:早退
			int checkflag = 0;
			if (ret) 
			{
				checkflag = checkinflag(check.getUserId(), nowdd);
			} 
			else 
			{
				checkflag = checkinstate(nowdd);
			}
			String nowdate = ymddf.format(nowdd);
			// 判断用户是否为不打卡人
			if (nocheckinuser(check)) {
				//应赵拥晨要求打卡随便打
//				checkflag=1; 
//				return "3";
			}
			// 判断用户是否是为不打卡部门
			if (nocheckindepartmentchild(check)) {
				//应赵拥晨要求打卡随便打
//				checkflag=1;
//				return "2";
			}
			// 判断今天是星期几(0:星期日1:星期一2:星期二3:星期三4:星期四5:星期五6:星期六)
			String week = CheckUtils.getWeekCodeOfDate(nowdd);
			boolean workneed = false;
			// 判断前一天是休息，还是工作日。
			if ("0".equals(week) || "6".equals(week)) 
			{
//				checkflag = 1;
				workneed = false;
			} 
			else 
			{
				workneed = true;
			}
			// 查询工作时间设置表
			List<WorkDaySet> rsspecialday = getspecialday(toDate1(nowdate));
			// 查询工作日、休息日设置表
			List<WorkDaySet> rscurrency = getcurrency(nowdate);
			String year = nowdate.substring(0, 4);
			String month = nowdate.substring(5, 7);
			String orgid = selectOrgId(check.getUserId());
			for (WorkDaySet wds : rscurrency) 
			{
				String org_account_id1 = wds.getOrg_account_id();// 单位id
				String week_day_name = wds.getWeek_num();// 工作日0,1,2,3,4,5,6
				String is_work = wds.getIs_work();// 是否工作0:休息1:工作
				String year1 = wds.getYear();// 年
				if (year.equals(year1) && orgid.equals(org_account_id1) && week.equals(week_day_name)) 
				{
					if ("0".equals(is_work)) 
					{
						workneed = false;
//						checkflag = 1;
					} 
					else 
					{
						workneed = true;
					}
					break;
				}
			}
			
			for (WorkDaySet wds : rsspecialday) 
			{
				String org_account_id = wds.getOrg_account_id();// 单位id
				String date_num = wds.getDate_num();// 日期2013/06/24
				String is_rest = wds.getIs_rest();// 休息类型0:工作 1:休息 2:法定休息
				String week_num = wds.getWeek_num();// 周几0,1,2,3,4,5,6
				String year1 = wds.getYear();
				String month1 = wds.getMonth();
				if (orgid.equals(org_account_id) && date_num.equals(toDate1(nowdate)) && year.equals(year1) && month.equals(toMonth(month1)) /*&& week.equals(week_num)*/) 
				{
					if (is_rest.equals("0")) 
					{// 工作
						workneed = true;
					} 
					else if (is_rest.equals("1")) 
					{// 休息
						workneed = false;
//						checkflag=1;
					} 
					else 
					{// 法定休息
						workneed = false;
//						checkflag=1;
					}
					break;
				}
			}
			
			//应需求，休息的时间也可以打卡add by tianxufeng
//			workneed = true;
			//end by tianxufeng
			
			
//			if (!workneed) 
//			{// 休息日无需打卡
//				return "4";
//			}
			// 插入打卡明细表
			if (!insertcheckdetail(check)) 
			{
				return "-1";
			}
			// 判断当天是否已经打卡过
//			List<InitCheckIn> checkList = ischeckintoday(check);
//			Iterator<InitCheckIn> itr = checkList.iterator();
			if (ret) 
			{// 已经打卡过，则更新当天打卡数据
				String leavetype = queryLeaveType(check.getUserId(),nowdate);
				// 更新个人打卡时间表
				updatecheckin(leavetype,checkflag, check.getUserId(), nowdate, checkdt,workneed);
			} 
			else 
			{
				insertcheckin(checkflag, check, nowdd);
			}
			return "0";
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return "-1";
		}
	}
	/**
	 * 转化字符串日期的格式
	 * @param s 2013-09-01
	 * @return 2013/09/01
	 */
	public String toDate1(String s){
		return s.substring(0, 4) + "/" + s.substring(5,7) + "/" + s.substring(8,10) ;
	}
	/**
	 * 转化字符串日期的格式
	 * @param s 2013/09/01
	 * @return 2013-09-01
	 */
	public String toDate2(String s){
		return s.substring(0, 4) + "-" + s.substring(5,7) + "-" + s.substring(8,10) ;
	}
	/**
	 * 转化字符串月份的格式
	 * @param month
	 * @return
	 */
	public String toMonth(String month) {
		if(month.length()==1)
			month = "0" + month;
		return month;
	}
	/**
	 * 取得用户对应的部门
	 * 
	 * @param userid
	 * @return
	 */
	public String selectOrgId(String userid) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		// ============================================
		// org_member表的字段org_post_id位主岗ID
		// ============================================
		String sql = "select t.org_account_id from org_member t where t.id = " + userid;
		String orgid = "";
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			if(rs.next()) {
				orgid = rs.getString("org_account_id");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			destroyDBObj(rs,ps,conn);
			super.releaseSession(session);
		}
		return orgid;
	}
	
	/**
	 * 查询工作日、休息日设置表
	 * @return
	 * 
	 */
	public List<WorkDaySet> getspecialday(String yesterday){
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<WorkDaySet> worddayset = new ArrayList<WorkDaySet>();
		//is_rest  0:工作  1:休息  2:法定休息
		String sql = " select to_char(org_account_id) as org_account_id,date_num,is_rest,week_num,year,month from worktime_specialday t where t.date_num='"	+ yesterday + "'";
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			while(rs.next()){
				WorkDaySet wds = new WorkDaySet();
				wds.setOrg_account_id(rs.getString("org_account_id"));
				wds.setDate_num(rs.getString("date_num"));
				wds.setIs_rest(rs.getString("is_rest"));
				wds.setWeek_num(rs.getString("week_num"));
				wds.setYear(rs.getString("year"));
				wds.setMonth(rs.getString("month"));
				worddayset.add(wds);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(rs,ps,conn);
			super.releaseSession(session);
	    }	
		
		return worddayset;
	}
	
	/**
	 * 查询工作时间设置表
	 * 
	 * @param userorgid
	 *            用户所属部门
	 * @param dateBefore
	 *            前一天日期(2013-06-19)
	 * @return boolean true:需要打卡； false:不需要打卡
	 */
	public List<WorkDaySet> getcurrency(String dateBefore) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<WorkDaySet> worddayset = new ArrayList<WorkDaySet>();
		Session session = super.getSession();
		conn = session.connection();
		try {
			//根据工作时间设置表进行判断前一日是否需要打卡 iswork 0:休息  1:工作
			String year = dateBefore.substring(0,4);
			String sql = " select to_char(org_account_id) as org_account_id,week_day_name,is_work,year from worktime_currency t where t.year ='" + year + "'" ;
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			while(rs.next()){
				WorkDaySet wds = new WorkDaySet();
				wds.setOrg_account_id(rs.getString("org_account_id"));
				wds.setWeek_num(rs.getString("week_day_name"));
				wds.setIs_work(rs.getString("is_work"));
				wds.setYear(rs.getString("year"));
				worddayset.add(wds);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(rs,ps,conn);
		    super.releaseSession(session);
	    }
		
		return worddayset;
	}
	
	/**
	 * 当天是星期几
	 * @return
	 */
	public String isweek() {
		// 首先判断前一日是星期几，周六、周日是不需要工作的。
		Date date = new Date();
		Calendar now = Calendar.getInstance();
		now.setTime(date);
		now.set(Calendar.DATE, now.get(Calendar.DATE));
		String week = new SimpleDateFormat("EEEE").format(now.getTime());
		return week;
	}

	/**
	 * 计算日期提前多少天
	 * @param d
	 * @param day
	 * @return
	 */
	public  Date getDateBefore(Date d, int day) {
		Calendar now = Calendar.getInstance();
		now.setTime(d);
		now.set(Calendar.DATE, now.get(Calendar.DATE) - day);
		return now.getTime();
	}
	
	/**
	 * 计算日期推迟多少天
	 * @param d
	 * @param day
	 * @return
	 */
	public  Date getDateAfter(Date d, int day) {
		Calendar now = Calendar.getInstance();
		now.setTime(d);
		now.set(Calendar.DATE, now.get(Calendar.DATE) + day);
		return now.getTime();
	}
	
	/**
	 * 查询当前用户所有打卡记录
	 * 
	 * @return
	 */
	public List<InitCheckIn> findCheckInAll(String userid) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		//查询当前用户自己的打卡记录
		Date date = new Date(); // 新建一个日期
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); // 格式化日期
		String dateBefore = sdf.format(getDateBefore(date, 29));//查询30天记录，包括当天
		String sql = " and to_char(t.checkdate,'YYYY-MM-DD')>= '" + dateBefore + "'";
		// 查询打卡记录
		String queryinit = "select t.userid,t.flag, "
				+ "t.amchecktime, "
				+ "t.pmchecktime, "
				+ "t.checkdate, "
				+ "t.week,"
				+ "t.leavetype, "
				+ "t.amstarttime, "
				+ "t.amendtime, "
				+ "t.pmstarttime, "
				+ "t.pmendtime ,"
				+ "t.leavetype "
				+ " from initcheckin t  " 
				+ " where t.userid ='" + userid + "'";
		String sqlOrder = " order by to_char(t.checkdate, 'yyyy-MM-dd') desc";
		queryinit = queryinit + sql + sqlOrder;
		List<InitCheckIn> inlist = new ArrayList<InitCheckIn>();
		Map<String,String> mp =getEnumValue();
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(queryinit);
			rs = ps.executeQuery();
			while (rs.next()) {
				InitCheckIn initcheckin = new InitCheckIn();
				
				String uid = rs.getString("userid");//用户id
				Timestamp amtime = rs.getTimestamp("amchecktime");//上午打卡时间
				Timestamp pmtime = rs.getTimestamp("pmchecktime");//下午打卡时间
				String intBug = rs.getString("flag");//打卡状态(正常|异常)
				String leavetype = rs.getString("leavetype");//请假类型(0,1,2...)
				String value1 = mp.get(leavetype);//请假类型名称
				if(null == value1) value1 ="";
				
				initcheckin.setUserId(uid);
				initcheckin.setCheckStartTime(amtime);
				initcheckin.setCheckEndTime(pmtime);
				initcheckin.setWeek(CheckUtils.getWeekNameOfWeekCode(rs.getString("week")));
				initcheckin.setCheckdate(rs.getDate("checkdate"));
				initcheckin.setFlag("0".equals(intBug) ? "正常" : "异常");
				initcheckin.setLeaveType(value1);
				
				inlist.add(initcheckin);
			}
			return inlist;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}finally{
			destroyDBObj(rs,ps,conn);
			super.releaseSession(session);
		}
	}

	/**
	 * 根据条件，查询打卡记录
	 * 
	 * @return
	 */
	public List<InitCheckIn> findCheckInAll(String stime,String etime, String flag, String userid, String leaveType) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = " where 1=1 ";
		// 状态
		if (!flag.equals("")) 	
			sql += " and flag = '" + flag + "'";
		// 用户id
		if (!userid.equals("")) 
			sql += " and userid = '" + userid + "'";
		// 请假类型
		if (!leaveType.equals("")) 
//			sql += " and e.showvalue like '" + leaveType + "'";
			sql += " and t.leaveType like '" + leaveType + "'";
		// 打卡开始时间
		if (!stime.equals("")) 
			sql += " and to_char(t.checkdate,'yyyy-MM-dd') >= '" + stime + "'";
		// 打卡结束时间
		if (!etime.equals("")) 
			sql += " and to_char(t.checkdate,'yyyy-MM-dd') <= '" + etime + "'";
		// 查询打卡记录
		String queryinit = "select t.userid, " + "t.flag, "
				+ "t.amchecktime, "
				+ "t.pmchecktime, "
				+ "t.checkdate, "
				+ "t.week , t.leavetype "
				+ " from initcheckin t " ;
		String sqlOrder = " order by to_char(t.checkdate, 'yyyy-MM-dd') desc";
		String sqlwhere = sql;
		queryinit = queryinit + sqlwhere + sqlOrder;
		List<InitCheckIn> inlist = new ArrayList<InitCheckIn>();
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(queryinit);
			rs = ps.executeQuery();
			Map<String,String> mp =getEnumValue();
			while (rs.next()) {
				InitCheckIn initcheckin = new InitCheckIn();
				initcheckin.setUserId(rs.getString("userid"));
				initcheckin.setCheckStartTime(rs.getTimestamp("amchecktime"));
				initcheckin.setCheckEndTime(rs.getTimestamp("pmchecktime"));
				initcheckin.setCheckdate(rs.getDate("checkdate"));
				initcheckin.setWeek(CheckUtils.getWeekNameOfWeekCode(rs.getString("week")));
				String leavetype =  rs.getString("leavetype");
				if (null==leavetype) leavetype = "";
				initcheckin.setFlag("0".equals(rs.getString("flag")) ? "正常" : "异常");
				initcheckin.setLeaveType(null == mp.get(leavetype) ? "" : mp.get(leavetype));
				inlist.add(initcheckin);
			}
			return inlist;
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		}finally{
			destroyDBObj(rs,ps,conn);
			super.releaseSession(session);
		}
	}

	/**
	 * 查询异常类型的名称和值
	 * @return
	 */
	public Map<String,String> getEnumValue(){
		Map<String,String> mp = new HashMap<String, String>();
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		String detailsql = "select enumvalue,showvalue from ctp_enum a, ctp_enum_item b where b.ref_enumid = a.id and b.state = 1 " +
						   "and (a.enumname =  '考勤异常类型' or a.enumname='告知公出')";
		
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(detailsql);
			rs = ps.executeQuery();
			while(rs.next()){
				String enumvalue = rs.getString("enumvalue");
				String showvalue = rs.getString("showvalue");
				mp.put(enumvalue, showvalue);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		}finally{
			destroyDBObj(rs,ps,conn);
			super.releaseSession(session);
		}
		return mp;
	}
	
	/**
	 * 查询打卡的详细信息
	 * 
	 * @param checkdate
	 * @return
	 */
	public List<InitCheckIn> findDetail(String checkdate, String userid) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String detailsql = "select checktime from checkindetails t " +
				"where to_char(checktime,'yyyy-MM-dd') ='"+ checkdate + "'" +
				" and userid ='" + userid + "' order by t.checktime ";
		List<InitCheckIn> initdetail = new ArrayList<InitCheckIn>();
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(detailsql);
			rs = ps.executeQuery();
			if (rs != null) {
				while (rs.next()) {
					InitCheckIn ick = new InitCheckIn();
					ick.setCheckTime(rs.getTimestamp("checktime"));
					initdetail.add(ick);
				}
			}
			return initdetail;
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		}finally{
			destroyDBObj(rs,ps,conn);
			super.releaseSession(session);
		}
	}

	/**
	 * 查询请假类别
	 * 
	 * @return
	 */
	public HashMap<String, String> findLeaveType() {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		// 请假类别的id
		HashMap<String, String> leaveType = new HashMap<String, String>();
		String sql = "select l.showvalue,l.enumvalue from ctp_enum t ,ctp_enum_item l where l.ref_enumid = t.id and (t.enumname='考勤异常类型' or t.enumname='告知公出') and l.state = 1 order by l.enumvalue";
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			while (rs.next()) {
				leaveType.put(rs.getString("enumvalue"), rs.getString("showvalue"));
			}
			return leaveType;
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		}finally{
			destroyDBObj(rs,ps,conn);
			super.releaseSession(session);
		}
	}
	
	/**
	 * 判断当前用户的打卡情况
	 * @return int 
	 * 				9:上午旷工
	 * 	         	0:下午旷工
	 * 				1:上午正常打卡
	 * 				2:下午正常打卡
	 * 			   -1:迟到
	 * 			   -2:早退
	 */				
	public int checkinflag(String userid,Date nowdd){
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		SimpleDateFormat ymdhmsdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Session session = super.getSession();
		conn = session.connection();
		try {
			//查询考勤设置
			String sql = "select t.amstarttime,t.amendtime,t.pmstarttime,t.pmendtime from initcheckin t " +
						" where t.userid='" + userid + "'" +
						"  and to_char(t.checkdate,'yyyy-MM-dd')='" + sdf.format(nowdd) + "'";
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			String amstarttime="";
			String amendtime ="";
			String pmstarttime ="";
			String pmendtime="";
			if(rs.next()){
				amstarttime = rs.getString("amstarttime");//上午打卡有效开始
				amendtime = rs.getString("amendtime");// 上午打卡有效结束
				pmstarttime = rs.getString("pmstarttime");//下午打卡有效开始
				pmendtime = rs.getString("pmendtime");//下午打卡有效结束
			}
			Date amstartdate=null;
			Date amenddate=null;
			Date pmstartdate=null;
			Date pmenddate=null;
			Date midddate = null;
			//中午时间,用来判断上午旷工和下午旷工
			String mid = DateFormat.getDateInstance().format(nowdd)+ " " + "12:00:00";
			midddate = ymdhmsdf.parse(mid);
			//上午开始打卡时间
			if(amstarttime == null || amstarttime.isEmpty()){
				amstartdate = null;
			}else{
				String am1 = DateFormat.getDateInstance().format(nowdd)+ " " + amstarttime;
				amstartdate = ymdhmsdf.parse(am1);
			}
			
			//上午结束打开时间
			if(amendtime == null || amendtime.isEmpty()){
				amenddate = null;
			}else{
				String am2 = DateFormat.getDateInstance().format(nowdd)+ " " +amendtime;
				amenddate = ymdhmsdf.parse(am2);
			}
			
			//下午开始打卡时间
			if(pmstarttime == null || pmstarttime.isEmpty()){
				pmstartdate = null;
			}else{
				String pm1 = DateFormat.getDateInstance().format(nowdd)+ " " +pmstarttime;
				pmstartdate = ymdhmsdf.parse(pm1);
			}
			
			//下午结束打卡时间
			if(pmendtime == null || pmendtime.isEmpty()){
				pmenddate = null;
			}else{
				String pm2 = DateFormat.getDateInstance().format(nowdd)+ " " +pmendtime;
				pmenddate = ymdhmsdf.parse(pm2);
			}
			
			if(nowdd.before(amstartdate) || nowdd.compareTo(amstartdate)==0){//当前时间<上午有效打卡开始
				return 1;//上午正常打卡
			}else if(nowdd.after(pmenddate) || nowdd.compareTo(pmenddate)==0){//当前时间>下午有效打卡结束
				return 2;//下午正常打卡
			}else if ((nowdd.after(amstartdate) && nowdd.before(amenddate)) || nowdd.compareTo(amenddate)==0){//当前时间>上午有效打卡开始   and 当前时间<上午有效打卡结束
				return -1;//迟到
			}else if ((nowdd.after(pmstartdate) && nowdd.before(pmenddate)) || nowdd.compareTo(pmstartdate)==0){
				return -2;//早退
			}else if(nowdd.after(amenddate) && nowdd.before(midddate)){
				return 9;//上午旷工
			}else if(nowdd.after(midddate) && nowdd.before(pmstartdate)){
				return 0;//下午旷工
			}
		} catch (Exception e1) {
			e1.printStackTrace();
		}finally{
			destroyDBObj(rs,ps,conn);
			super.releaseSession(session);
		}
		return 0;
	}

	/**
	 * 判断当前用户的打卡情况
	 * @return int 
	 * 				9:上午旷工
	 * 	         	0:下午旷工
	 * 				1:上午正常打卡
	 * 				2:下午正常打卡
	 * 			   -1:迟到
	 * 			   -2:早退
	 */				
	public int checkinstate(Date nowdd){
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		SimpleDateFormat ymdhmsdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		Session session = super.getSession();
		conn = session.connection();
		try {
			//查询考勤设置
			String sql = "select t.amstarttime,t.amendtime,t.pmstarttime,t.pmendtime from checkininstall t";
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			String amstarttime="";
			String amendtime ="";
			String pmstarttime ="";
			String pmendtime="";
			if(rs.next()){
				amstarttime = rs.getString("amstarttime");//上午打卡有效开始
				amendtime = rs.getString("amendtime");// 上午打卡有效结束
				pmstarttime = rs.getString("pmstarttime");//下午打卡有效开始
				pmendtime = rs.getString("pmendtime");//下午打卡有效结束
			}
			Date amstartdate=null;
			Date amenddate=null;
			Date pmstartdate=null;
			Date pmenddate=null;
			Date midddate = null;
			String mid = DateFormat.getDateInstance().format(nowdd)+ " " + "12:00:00";
			midddate = ymdhmsdf.parse(mid);//中午时间,用来判断上午旷工和下午旷工
			String am1 = DateFormat.getDateInstance().format(nowdd)+ " " + amstarttime;
			amstartdate = ymdhmsdf.parse(am1);
			String am2 = DateFormat.getDateInstance().format(nowdd)+ " " +amendtime;
			amenddate = ymdhmsdf.parse(am2);
			String pm1 = DateFormat.getDateInstance().format(nowdd)+ " " +pmstarttime;
			pmstartdate = ymdhmsdf.parse(pm1);
			String pm2 = DateFormat.getDateInstance().format(nowdd)+ " " +pmendtime;
			pmenddate = ymdhmsdf.parse(pm2);
			if(nowdd.before(amstartdate) || nowdd.compareTo(amstartdate)==0){//当前时间<上午有效打卡开始
				return 1;//上午正常打卡
			}else if(nowdd.after(pmenddate) || nowdd.compareTo(pmenddate)==0){//当前时间>下午有效打卡结束
				return 2;//下午正常打卡
			}else if ((nowdd.after(amstartdate) && nowdd.before(amenddate)) || nowdd.compareTo(amenddate)==0){//当前时间>上午有效打卡开始   and 当前时间<上午有效打卡结束
				return -1;//迟到
			}else if ((nowdd.after(pmstartdate) && nowdd.before(pmenddate)) || nowdd.compareTo(pmstartdate)==0){
				return -2;//早退
			}else if(nowdd.after(amenddate) && nowdd.before(midddate)){
				return 9;//上午旷工
			}else if(nowdd.after(midddate) && nowdd.before(pmstartdate)){
				return 0;//下午旷工
			}
		} catch (Exception e1) {
			e1.printStackTrace();
		}finally{
			destroyDBObj(rs,ps,conn);
			super.releaseSession(session);
		}
		return 0;
	}

	/**
	 * 判断IP是否为不打卡IP
	 * @param fileNamePath
	 * @param key
	 * @return
	 */
	public boolean chenkIp(String ip) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String[] ips = null;
		String selectip = "";
		if(null != ip && !ip.trim().equals("")){
			ips=ip.split("\\.");
			if(ips.length ==4){
				selectip = ips[0]+"."+ips[1];//+"."+ips[2];
			}
		}
		Session session = super.getSession();
		conn = session.connection();
		try {
			//不打卡网段表名
//			String networkname = sys.getProperty("a8.plugin.checkin.networkname");
//			String findipsql = "select t.field0005 as startip,t.field0004 as endip from " + networkname + " t where t.field0005 like '"+selectip+"%'" ;
			String findipsql = "select t.field0005 as startip,t.field0004 as endip from formson_0196 t where t.field0005 like '"+selectip+"%'" ;
			ps = conn.prepareStatement(findipsql);
			rs = ps.executeQuery();
			if (rs != null) {
			   while (rs.next()) {
					String startip = rs.getString("startip");
					String endip = rs.getString("endip");
					if(startip != null && endip != null){
						String[] tmpip = startip.split("\\.");
						if(tmpip!=null){
							if(tmpip.length>=2){
								String strip = tmpip[0]+ "." +tmpip[1];
								String valip = ip.split("\\.")[0] + "." + ip.split("\\.")[1];
								if(strip.equals(valip)){
									
									return true;
								}else{
									return false;
								}
							}else{
								return false;
							}
						}else{
							return false;
						}
					}else{
						return false;
					}
				}
				return false;
			}else{
				return false;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			destroyDBObj(rs,ps,conn);
			super.releaseSession(session);
		}
		return false;
	}

	/**
	 * 根据登录名查询用户ID
	 * @param loginName
	 * @return
	 */
	public String findUserIdbyloginName(String loginName) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		// ============================================
		// org_member表的字段org_post_id位主岗ID
		// ============================================
		String findidsql = "select m.id as userid from security_principal t , org_member m where t.entityinternalid=m.id and t.full_path like '%/"+loginName+"'" ;
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(findidsql);
			rs = ps.executeQuery();
			if (rs != null) {
				if (rs.next()) {
					String userid = rs.getString("userid");
					return userid;
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			destroyDBObj(rs,ps,conn);
			super.releaseSession(session);
		}
		return "";
	}
	
	/**
	 * 根据key读取value
	 * @param fileNamePath
	 * @param key
	 * @return
	 */
	public String getValue(String fileNamePath, String key) {
		Properties props = new Properties();
		InputStream in = null;
		try {
			// 如果将in改为下面的方法，必须要将.Properties文件和此class类文件放在同一个包中
			in = this.getClass().getClassLoader().getResourceAsStream(fileNamePath);
			props.load(in);
			String value = props.getProperty(key);
			return value;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		} finally {
			if (null != in)
				try {
					in.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
		}
	}
	
	/**
	 * 删除考勤查询表
	 * @param userid
	 * @param checkdate
	 */
	public void deletedepcheck(String userid,String checkdate){
		Connection conn = null;
		PreparedStatement ps = null;
		String sql = "delete from depcheck t where t.userid= '" + userid + "' and to_char(t.checkdate,'yyyy-MM-dd')= '" + checkdate + "'"; 
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(null,ps,conn);
		    super.releaseSession(session);
	    }
	}
	
	/**
	 * 销毁连接数据库对象
	 * @param rs
	 * @param ps
	 * @param conn
	 */
	public void destroyDBObj(ResultSet rs,PreparedStatement ps,Connection conn) {
		if (rs != null) {
			try {
				rs.close();
				rs = null;
			} catch (SQLException e) {
				e.printStackTrace();
			} finally{
				if (ps != null) {
					try {
						ps.close();
						ps = null;
					} catch (SQLException e) {
						e.printStackTrace();
					} finally {
						if(conn != null){
							try {
								conn.close();
								conn = null;
							} catch (SQLException e) {
								e.printStackTrace();
							} finally {
//								System.out.println("数据库连接已关闭");
							}
						}
					}
				}
			}
		}else{
			if (ps != null) {
				try {
					ps.close();
					ps = null;
				} catch (SQLException e) {
					e.printStackTrace();
				} finally {
					if(conn != null){
						try {
							conn.close();
							conn = null;
						} catch (SQLException e) {
							e.printStackTrace();
						} finally {
//							System.out.println("数据库连接已关闭");
						}
					}
				}
			}
		}
	}
}
