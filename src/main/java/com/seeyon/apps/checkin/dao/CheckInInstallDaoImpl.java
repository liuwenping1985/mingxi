package com.seeyon.apps.checkin.dao;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Session;

import com.seeyon.apps.checkin.aberrant.BPMUtils;
import com.seeyon.apps.checkin.client.CheckUtils;
import com.seeyon.apps.checkin.domain.CheckInInstall;
import com.seeyon.apps.checkin.domain.Department;
import com.seeyon.apps.checkin.domain.InitCheckIn;
import com.seeyon.apps.checkin.domain.NoCheckinDepart;
import com.seeyon.apps.checkin.domain.NoCheckinUser;
import com.seeyon.apps.checkin.domain.User;
import com.seeyon.apps.checkin.domain.WorkDaySet;
import com.seeyon.apps.checkin.domain.depCheckIn;
import com.seeyon.ctp.common.dao.BaseHibernateDao;
import com.seeyon.oainterface.exportData.form.FormExport;

import edu.emory.mathcs.backport.java.util.Arrays;
//import com.seeyon.apps.checkin.domain.NoStaticCheckinDept;
//import com.seeyon.apps.checkin.domain.NoStaticCheckinUser;

public class CheckInInstallDaoImpl extends BaseHibernateDao<CheckInInstall> implements CheckInInstallDao {
	
	private String filenameTemp;
	
    private static Log log = LogFactory.getLog(CheckInInstallDaoImpl.class);
	
	/**
	 * 检查前一天的考勤信息(TimerTask任务处理)
	 */
	public void checkYesterdayCheckin() 
	{
		log.info("checkYesterdayCheckin start============================"+new Date());
		System.out.println("checkYesterdayCheckin start============================" + new Date());
		SimpleDateFormat sdfd = new SimpleDateFormat("yyyy-MM-dd");
		// 员工表集合及相关属性
		List<User> userlist = selectAllUsers();
		String userid = "";// 用户id
		String accountId = "";// 单位id
		String orgId = "";// 部门ID
		// 考勤设置表集合及相关属性
		List<CheckInInstall> rsset = selectffectivect();
		String processstarttime = "";// 异常流程发起时间
		String approvaltime = "";// 请假流程有效审批时间
		// 所有用户的登录帐号集合
		List<User> loginlist = getLoginno();

		// 前一日是否需要打卡 true:需要;false:不需要
		boolean yesterdayworkneed = false;
		
		String yesterday= yesterday();//前一日日期2013-06-25
		String year = yesterday.substring(0,4);//前一日年份2013
		String month = yesterday.substring(5,7);//前一日月份06
		String week = "";// 前一日是星期几(0:星期日1:星期一2:星期二3:星期三4:星期四5:星期五6:星期六)
		//判断前一日是星期几(0:星期日1:星期一2:星期二3:星期三4:星期四5:星期五6:星期六)
		try 
		{
			week = CheckUtils.getWeekCodeOfDate(sdfd.parse(yesterday));
		} 
		catch (ParseException e1) 
		{
			log.error(e1.getStackTrace());
			e1.printStackTrace();
		}
		//判断前一天是休息，还是工作日。
		if ("0".equals(week) || "6".equals(week)) {
			yesterdayworkneed = false;
		} else {
			yesterdayworkneed = true;
		}
		//查询工作时间设置表
		List<WorkDaySet> rsspecialday = getspecialday(toDate1(yesterday));
		
		//查询工作日、休息日设置表
		List<WorkDaySet>  rscurrency = getcurrency(yesterday);
		
		// 查询前一日所有员工打卡时间表
		List<InitCheckIn> personcheck = selectinitcheckin(yesterday);

		Timestamp amtime = null;// 上午打卡时间
		Timestamp pmtime = null;// 下午打卡时间
		String flag = "";// 状态
		String lateflag = "";//迟到早退标志  1：迟到早退  0：非迟到早退
		Date yesterdayCheckDate = null;// 前一日打卡日期
		// 查询不打卡人
		List<User> noCheckinUsers = selectnockusers();
		// 查询不打卡部门
		List<Department> noCheckinDepartments = selectnockdepartment();
		
		// 插入考勤查询表使用
		List<depCheckIn> depcheck = new ArrayList<depCheckIn>();
		// 插入考勤异常表使用
		List<CheckInInstall> checkinins = new ArrayList<CheckInInstall>();
		// 考勤打卡更新用
		List<InitCheckIn> initListU = new ArrayList<InitCheckIn>();
		// 考勤打卡插入用
		List<InitCheckIn> initListI = new ArrayList<InitCheckIn>();
		try {
			//创建打卡异常文件
//			filenameTemp ="/usr/local/UFSeeyon/A8/Group/ApacheJetspeed/webapps/seeyon/logs/dklogs/" +sdfd.format(new Date());
//			filenameTemp ="c:/" +sdfd.format(new Date());
//			creatTxtFile(filenameTemp);
//			writeTxtFile(yesterday + "异常判定处理开始==========================================================");
			
			//考勤设置集合
			if(null!=rsset){
				for (CheckInInstall check : rsset) {
					processstarttime = check.getProcessStartTime();//异常发起天数
					approvaltime = check.getApprovalTime();//异常审批天数
				}
			}else{
				return ;
			}
			
outside:			
			// for循环全部用户
			for (User user :userlist) {

				//判断前一天是休息，还是工作日。
				if ("0".equals(week) || "6".equals(week)) {
					yesterdayworkneed = false;
				} else {
					yesterdayworkneed = true;
				}
				
				//是否需要打卡 true:需要打卡；false:不需要打卡
				boolean needCheckin = true;
				
				userid = user.getUserId();// 用户id
//				if("-5826626455431528410".equals(userid)) 
//					System.out.println("李想");
				accountId = user.getAccountId();//单位id
				orgId = user.getOrgId(); //部门id
//				if("-4370320462860435400".equals(orgId) || "-5768158426063156824".equals(orgId) || "-8734378992199578267".equals(orgId) || "-8548684497528467516".equals(orgId)) 
//					System.out.println("信息管理中心");
				//取得员工登录帐号
				for(User u :loginlist){					
					String userid1 =u.getUserId();//用户id
					
					if (userid == null || userid1 == null) {
						break;
					}
					if(userid.equals(userid1)){						
						break;
					}
				}
				//查询工作日、休息日设置表
				for(WorkDaySet wds:rscurrency){
					String org_account_id1 = wds.getOrg_account_id();//单位id
					String week_day_name = wds.getWeek_num();//工作日0,1,2,3,4,5,6
					String is_work = wds.getIs_work();//是否工作0:休息1:工作
					String year1 = wds.getYear();//年	
					if(year.equals(year1) && accountId.equals(org_account_id1) && week.equals(week_day_name)){
						if("0".equals(is_work)){
							yesterdayworkneed = false;
							break ;
						}else{
							yesterdayworkneed = true;
							break;
						}
					}
				}
				//查询工作时间设置表
				for(WorkDaySet wds:rsspecialday){
					String org_account_id = wds.getOrg_account_id();//单位id
					String date_num = wds.getDate_num();//日期2013/06/24
					String is_rest = wds.getIs_rest();//休息类型0:工作 1:休息 2:法定休息
//					String week_num = wds.getWeek_num();//周几0,1,2,3,4,5,6
					String year1 = wds.getYear();
					String month1 = wds.getMonth();
					if(accountId.equals(org_account_id) && //单位id
							date_num.equals(toDate1(yesterday)) && //日期date_num(2013/06/24)yesterday(2013-06-24)
							year.equals(year1) && //年
							month.equals(toMonth(month1)) /*&& //月month(09) month1(9)
							week.equals(week_num)*/){//周几0,1,2,3,4,5,6
						if(is_rest.equals("0")){//工作
							yesterdayworkneed = true;
							break;
						}else if(is_rest.equals("1")){//休息
							yesterdayworkneed = false;
							continue outside ;
						}else{//法定休息
							yesterdayworkneed = false;
							continue outside;
						}
					}
				}
				//------------------------------------
				// 前一日需要打卡
				if (yesterdayworkneed) {
					//判断当前用户是否是不打卡人
					for(User u:noCheckinUsers){
						if(u.getUserId() == null || userid == null) {
							continue;
						}
						if(u.getUserId().equals(userid)){
							needCheckin = false;
							continue outside;
						}
					}
					//判断当前用户所在部门是否是不打卡部门
					for(Department de:noCheckinDepartments){
						if(de.getDmid().trim().equals(orgId.trim())){
							needCheckin = false;
							continue outside;
						}
					}
					
					//必须打卡
					if(needCheckin)
					{
						//前一日是否已经打卡 true:已经打卡 false：没有打卡
						boolean yescheck = false;
						for(InitCheckIn init:personcheck)
						{
							String uid = init.getUserId();
							amtime = init.getCheckStartTime();
							pmtime = init.getCheckEndTime();
							flag = init.getFlag();//0：正常；1：异常
							week = init.getWeek();//星期一，星期二，星期三。。。星期日
							yesterdayCheckDate = init.getCheckdate();
							lateflag = init.getLateflag();//迟到早退标志
							if(uid == null || userid == null) 
							{
								continue;
							}
							if(uid.equals(userid))
							{
								yescheck = true;
								break;
							}
						}
						
						// 前一日已经打卡
						if (yescheck) 
						{
							// 前一日打卡状态为异常
							if ("1".equals(flag)) 
							{
								//取得迟到早退次数
								int lateNum = getlatenum(amtime,pmtime,yesterdayCheckDate);
								// 迟到早退标志 0:非迟到早退 1：迟到早退
								lateflag = "0";
								if(lateNum > 0){
									lateflag = "1";
								}
								// 请假类型异常天数
								double leavenum = getleavetypenum(amtime,pmtime,yesterdayCheckDate);
								
								InitCheckIn initb = new InitCheckIn();
								initb.setUserId(userid);
								initb.setCheckdate(yesterdayCheckDate);
								initb.setDebugday(leavenum);
								initb.setLateflag(lateflag);
								initb.setLateNum(lateNum);
								initListU.add(initb);
								
								// 考勤查询表中没有数据
								if(!existsDepCheck(userid,yesterday)){
									depCheckIn dep = new depCheckIn();
									dep.setUserid(userid);
									dep.setCheckDate(yesterdayCheckDate);
									dep.setLateNum(Integer.toString(lateNum));
									depcheck.add(dep);
								}
								
								// 考勤异常表中没有数据
								if(!existsCheckBug(userid,yesterday))
								{
									if (!alreadyApply(userid,yesterday))
									{
										CheckInInstall inins = new CheckInInstall();
										inins.setUserId(userid);
										inins.setCheckStartTime(amtime);
										inins.setCheckEndTime(pmtime);
										inins.setAppFlg("0");
										inins.setProcessStartTime(processstarttime);
										inins.setApprovalTime(approvaltime);
										inins.setCheckDate(yesterdayCheckDate);
										checkinins.add(inins);
									}//txf //txf 已经请过假的就不写异常表了
									
								}
							}
						}
						// 前一日没有打卡
						else 
						{						
							yesterdayCheckDate = sdfd.parse(yesterday);
							amtime = null;
							pmtime = null;

							List<InitCheckIn> checkList = selectinitcheckin(userid,yesterday);
							Iterator<InitCheckIn> it = checkList.iterator();
							if(!it.hasNext()){
								InitCheckIn initb = new InitCheckIn();
								initb.setCheckStartTime(amtime);
								initb.setCheckEndTime(pmtime);
								initb.setFlag("1");
								initb.setUserId(userid);
								initb.setLeaveType("");
								initb.setWeek(week);
								initb.setCheckdate(yesterdayCheckDate);
								initb.setDebugday(1);
								initListI.add(initb);
							}
							
							// 考勤查询表中没有数据
							if(!existsDepCheck(userid,yesterday)){
								depCheckIn dep = new depCheckIn();
								dep.setUserid(userid);
								dep.setCheckDate(yesterdayCheckDate);
								dep.setLateNum("0");
								depcheck.add(dep);
							}
							// 考勤异常表中没有数据
							if(!existsCheckBug(userid,yesterday)){
								if (!alreadyApply(userid,yesterday))
								{
									CheckInInstall inins = new CheckInInstall();
									inins.setUserId(userid);
									inins.setCheckStartTime(amtime);
									inins.setCheckEndTime(pmtime);
									inins.setAppFlg("0");
									inins.setProcessStartTime(processstarttime);
									inins.setApprovalTime(approvaltime);
									inins.setCheckDate(yesterdayCheckDate);
									checkinins.add(inins);
								}//txf 已经请过假的就不写异常表了
							}
						}
					}
				}
			}
			
			// 插入个人打卡时间表
			insertcheckin(initListI);
			
			//修改个人打卡时间表
			updateinitcheckin(initListU);
			
			// 插入考勤查询表
			insertdepcheck(depcheck);
			
			// 写入考勤异常表
			insertde(checkinins);
			
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			log.error(e.getStackTrace());
		}
		log.info("checkYesterdayCheckin end============================" + new Date());
		System.out.println("checkYesterdayCheckin end============================" + new Date());
	}
	
	/**
	 * 监听发起表单
	 * @param userid
	 */
	public void startUpForm(){
		System.out.println("startUpForm start============================" + new Date());
		String[] usermessage = new String[7];//最后一个为登录帐号
		SimpleDateFormat sdft = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat sdfd = new SimpleDateFormat("yyyy-MM-dd");
		
		// 查询所有未发起表单的异常打卡的用户数据
		List<CheckInInstall> lis = selectabnormal("");
		Iterator<CheckInInstall> debugrs = lis.iterator();
		
		
		
		Map<String,String> userMap  = getLoginNameMap();
		
		boolean startflag = false;//发起状态
	
		try 
		{
			while (debugrs.hasNext()) 
			{
				CheckInInstall checkb = debugrs.next();
				
//				if (!checkb.getUserId().equals("4978101965625183539") &&
//						!checkb.getUserId().equals("4123367025117775914") &&
//						!checkb.getUserId().equals("-5826626455431528410")&&
//						!checkb.getUserId().equals("-7424050502133004101"))
//				{
//					continue;
//				}
				
				String orgname = checkb.getOrgName();   //debugrs.getString("orgname");// 用户部门
				usermessage[2] = orgname;
				String userid =checkb.getUserId(); // debugrs.getString("id");// 用户id
				// 考勤打卡日期
				Date checkdate = checkb.getCheckDate();//debugrs.getDate("checkdate");
				String strckdate = sdfd.format(checkdate);
				usermessage[3] = strckdate;
				
				//判断考勤查询表中，是否有当天的数据。有的话，就不要发起表单了；然后删除考勤异常表的数据。
				// 判断考勤查询表是否有数据
				boolean ret = isStartUp(userid, strckdate);
				if(ret) {
					System.out.println("cccc============================");
					// 删除考勤异常表的数据
					deletecheckabnormal(userid, strckdate);
					continue ;
				}
				//登录帐号
				String loginCode = userMap.get(userid);
				System.out.println(loginCode);
		
//				for (User u : userlist) 
//				{
//					String userid1 = u.getUserId().trim();// 用户id
//					String tmploginno = u.getFullPath().trim();
////					String[] tmp = fullpath.split("/");
////					String tmploginno = tmp[tmp.length - 1];
//					if (userid.equals(userid1)) 
//					{
//						loginCode = tmploginno;
//						break;
//					}
//				}
				usermessage[6] = loginCode;
				// 姓名
				String username = checkb.getUserName();//debugrs.getString("username");
				usermessage[0] = username;
				// 异常发现时间
				Timestamp errordate = checkb.getCreateTime(); //debugrs.getTimestamp("createtime");
				// 员工编号
				String usercode = checkb.getUserCode();//debugrs.getString("code");
				usermessage[1] = usercode;
				// 上午打卡时间
				Timestamp amchecktime = checkb.getCheckStartTime(); //debugrs.getTimestamp("amchecktime");
				if (null == amchecktime) {
					usermessage[4] = "";
				} else if ("".equals(amchecktime)) {
					usermessage[4] = "";
				} else {
					usermessage[4] = sdft.format(amchecktime);
				}
				// 下午打卡时间
				Timestamp pmchecktime = checkb.getCheckEndTime(); //debugrs.getTimestamp("pmchecktime");
				if (null == pmchecktime) {
					usermessage[5] = "";
				} else {
					usermessage[5] = sdft.format(pmchecktime);
				}
				// 审批天数
				String strstartdays = checkb.getProcessStartTime(); //debugrs.getString("startdays");
				int startdays = 0;
				if (null == strstartdays) {
				} else if ("".equals(strstartdays)) {
				} else {
					startdays = Integer.parseInt(strstartdays);
				}
				
				Date nowdate = new Date();// 当前时间
				if (nowdate.getTime() - errordate.getTime() > startdays * 24 * 60 * 60 * 1000L) {
					System.out.println("ddd============================");
					startflag = true;
				} else {
					System.out.println("eee============================");
					startflag = false;
				}
				
				System.out.println("需要发起异常的信息：" + Arrays.asList(usermessage));
				
				// 当前时间超过发起时间
				if (startflag) 
				{
					// 发起表单  true:发起成功；false:发起失败
					boolean bstartup = lauchForm(usermessage);
					System.out.println("已经发起异常的信息：" + Arrays.asList(usermessage));
					if(bstartup)
					{						
						// 修改异常处理表
						updatecheckabnormal(userid, strckdate);
						// 修改考勤查询表
						updatedepcheck(userid,checkdate);
					}
				}
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		
		System.out.println("startUpForm end============================" + new Date());
	}
	
	/**
	 * 判断员工的的打卡是否正常
	 * @param userid
	 * @param amtime上午打卡时间
	 * @param pmtime下午打卡时间
	 * @return true:正常；false:异常
	 */
	public boolean checkvalid(String userid,String amtime, String pmtime){
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		String sql = "select t.amstarttime,t.amendtime,t.pmstarttime,t.pmendtime from checkininstall t ";
		
		Session session = super.getSession();
		Connection conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			
			SimpleDateFormat sdft = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat sdfd=new SimpleDateFormat("yyyy-MM-dd");
			
			Date date = new Date();
			String nowdate = sdfd.format(date);//2013-06-22
			
			if(rs.next()){
				String amstarttime = nowdate + " " + rs.getString("amstarttime").toString();
				String pmendtime = nowdate + " " + rs.getString("pmendtime").toString();
				
				if (null == amtime){
					return false;
				}
				if (null == pmtime){
					return false;
				}
				
				Date amdat = sdft.parse(amtime);
				Date pmdat = sdft.parse(pmtime);
				
				Date amstartdat = sdft.parse(amstarttime);
				Date pmenddat = sdft.parse(pmendtime);
				
				if(amdat.before(amstartdat) && pmdat.after(pmenddat)){
					return true;
				}else{
					return false;
				}
			}
			return false;
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(rs,ps,conn);
		    super.releaseSession(session);
	    }

		return false;
	}
	
	/**
	 * 修改考勤查询表(考勤异常审批后使用)
	 * @param approval 0:审批通过 1:审批不通过
	 * @param userid 用户id
	 * @param checkdate 考勤日期
	 * @param leavetype 请假类型
	 * @param debugnum 请假天数(0.5/1)
	 * @return
	 */
	public int updatedepcheck(String approval,String userid, String checkdate, String leavetype, double debugnum) {
		PreparedStatement ps = null;
		ResultSet rs = null;

		int rsnum = 0;
		
		Session session = super.getSession();
		Connection conn = session.connection();
		try {
			String sql = "";
			if (leavetype.equals("1")) {//病假
				if("0".equals(approval)){
					sql = " update depcheck set sicknum = ?,bugnum = 0,latenum = 0,isfinish= 2 where userid  ='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";		
					ps = conn.prepareStatement(sql);
					ps.setDouble(1, debugnum);
				}else if("1".equals(approval)){				
					sql = " update depcheck set isfinish=3 where userid  ='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='"	+ checkdate + "'";
					ps = conn.prepareStatement(sql);
				}
			} else if (leavetype.equals("2")) {//事假
				if("0".equals(approval)){
					sql = " update depcheck set absencenum = ?,bugnum = 0,latenum = 0,isfinish= 2 where userid  ='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";	
					ps = conn.prepareStatement(sql);
					ps.setDouble(1, debugnum);
				}else if("1".equals(approval)){				
					sql = " update depcheck set isfinish=3 where userid  ='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";
					ps = conn.prepareStatement(sql);
				}
			} else if (leavetype.equals("3")) {//年休假
				if("0".equals(approval)){
					sql = " update depcheck set annualnum = ?,bugnum = 0,latenum = 0,isfinish= 2 where userid  ='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";	
					ps = conn.prepareStatement(sql);
					ps.setDouble(1, debugnum);
				}else if("1".equals(approval)){				
					sql = " update depcheck set isfinish=3 where userid  ='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='"	+ checkdate + "'";
					ps = conn.prepareStatement(sql);
				}
			} else if (leavetype.equals("4")) {//婚假
				if("0".equals(approval)){
					sql = " update depcheck set funeralnum = ?,bugnum = 0,latenum = 0,isfinish= 2 where userid  ='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";	
					ps = conn.prepareStatement(sql);
					ps.setDouble(1, debugnum);
				}else if("1".equals(approval)){				
					sql = " update depcheck set isfinish=3 where userid  ='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='"	+ checkdate + "'";
					ps = conn.prepareStatement(sql);
				}
			} else if (leavetype.equals("5")) {//丧假
				if("0".equals(approval)){
					sql = " update depcheck set travelnum = ?,bugnum = 0,latenum = 0,isfinish= 2 where userid  ='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";
					ps = conn.prepareStatement(sql);
					ps.setDouble(1, debugnum);
				}else if("1".equals(approval)){				
					sql = " update depcheck set isfinish=3 where userid  ='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='"	+ checkdate + "'";
					ps = conn.prepareStatement(sql);
				}
			} else if (leavetype.equals("6")) {//产假
				if("0".equals(approval)){
					sql = " update depcheck set maternitynum = ?,bugnum = 0,latenum = 0,isfinish= 2  where userid  ='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";		
					ps = conn.prepareStatement(sql);
					ps.setDouble(1, debugnum);
				}else if("1".equals(approval)){				
					sql = " update depcheck " +
						  "    set isfinish=3 " +
						  "  where userid  ='" + userid + "' " +
						  "    and to_char(checkdate,'yyyy-mm-dd')='"	+ checkdate + "'";
					ps = conn.prepareStatement(sql);
				}
			} else if (leavetype.equals("7")) {//其它
				if("0".equals(approval)){
					sql = " update depcheck " +
					      "    set publicnum = ?," +
					      "		   bugnum = 0," +
						  "        latenum = 0," +
						  "        isfinish= 2 " +
						  "  where userid  ='" + userid + "'" +
						  "    and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";	
					ps = conn.prepareStatement(sql);
					ps.setDouble(1, debugnum);
				}else if("1".equals(approval)){				
					sql = " update depcheck " +
						  "    set isfinish=3 " +
						  "  where userid  ='" + userid + "' " +
						  "    and to_char(checkdate,'yyyy-mm-dd')='"	+ checkdate + "'";
					ps = conn.prepareStatement(sql);
				}
			} else if (leavetype.equals("10")) {//探亲假
				if("0".equals(approval)){
					sql = " update depcheck " +
					      "    set gohomenum = ?," +
					      "		   bugnum = 0," +
						  "        latenum = 0," +
						  "        isfinish= 2 " +
						  "  where userid  ='" + userid + "'" +
						  "    and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";	
					ps = conn.prepareStatement(sql);
					ps.setDouble(1, debugnum);
				}else if("1".equals(approval)){				
					sql = " update depcheck " +
						  "    set isfinish=3 " +
						  "  where userid  ='" + userid + "' " +
						  "    and to_char(checkdate,'yyyy-mm-dd')='"	+ checkdate + "'";
					ps = conn.prepareStatement(sql);
				}
			}
			
			rsnum = ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(rs,ps,conn);
		    super.releaseSession(session);
	    }

		return rsnum;
	}

	/**
	 * 修改考勤查询表(考勤异常表单发起后使用)
	 * @param userid
	 * @param checkdate
	 * @return
	 */
	public int updatedepcheck(String userid,Date checkdate){
		Session session = super.getSession();
		Connection conn = session.connection();
		PreparedStatement ps = null;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String sql = "update depcheck " +
					 "   set isfinish = '1' " +
					 " where userid='" + userid + "' " +
					 "   and to_char(checkdate,'yyyy-MM-dd')='" + sdf.format(checkdate) + "'";
		int rsnum = 0;
		try {
			ps = conn.prepareStatement(sql);
			rsnum = ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(null,ps,conn);
		   super.releaseSession(session);
	    }
		return rsnum;
	}
	
	/**
	 * 修改异常待处理表(考勤异常表单发起后使用)
	 * 
	 * @param userid
	 * @param checkdate
	 * @return
	 */
	public int updatecheckabnormal(String userid, String checkdate) {
		Connection conn = null;
		PreparedStatement ps = null;
		String sql = "update checkabnormal " + " set flag = 1"
				+ " where userid ='" + userid + "'"
				+ " and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";
		int rsnum = 0;
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			rsnum = ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(null,ps,conn);
			super.releaseSession(session);
	    }
		return rsnum;
	}

	/**
	 * 删除异常待处理表的
	 * 
	 * @param userid
	 * @param checkdate
	 * @return
	 */
	public int deletecheckabnormal(String userid, String checkdate) {
		Connection conn = null;
		PreparedStatement ps = null;

		String sql = "delete from checkabnormal " + " where userid ='" + userid + "'" 
				+ " and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";
		
		System.out.println(sql);
		int rsnum = 0;
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			rsnum = ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(null, ps, conn);
			super.releaseSession(session);
	    }

		return rsnum;
	}

	/**
	 * 将数据写入考勤查询表(考勤异常判定处理后使用)
	 * 
	 * @param userid
	 *            用户id
	 * @param date
	 *            考勤异常日期
	 * @param latenum
	 *            迟到早退次数    
	 * @return
	 */
	public void insertdepcheck(List<depCheckIn> depcheck) {
		PreparedStatement ps = null;
		Session session = super.getSession();
		Connection conn = session.connection();
		try {
			String sql = "insert into depcheck (id,userid,bugnum,latenum,sicknum,absencenum,annualnum,publicnum,funeralnum,travelnum,maternitynum,checkdate,isfinish,gohomenum) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			ps = conn.prepareStatement(sql.toString());
			for (depCheckIn dep : depcheck) {
				String userid = dep.getUserid();
				Date date = dep.getCheckDate();
				int latenum = Integer.parseInt(dep.getLateNum());
				ps.setString(1, UUID.randomUUID().toString());// 主键
				ps.setString(2, userid);// 用户id
				ps.setInt(3, 1);// 异常次数
				ps.setInt(4, latenum);// 迟到早退次数
				ps.setDouble(5, 0);// 病假
				ps.setDouble(6, 0);// 事假
				ps.setDouble(7, 0);// 年休假
				ps.setDouble(8, 0);// 其它
				ps.setDouble(9, 0);// 婚假
				ps.setDouble(10, 0);// 丧假
				ps.setDouble(11, 0);// 产假
				java.sql.Date ud = new java.sql.Date(date.getTime());
				ps.setDate(12, ud);// 打卡日期
				ps.setString(13, "0");// 0：未发起；1：已发起；2：已审批
				ps.setDouble(14, 0);// 探亲假
				ps.executeUpdate();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			destroyDBObj(null,ps,conn);
			super.releaseSession(session);
		}
	}
	
	/**
	 * 将数据写入考勤查询表(审批结束后使用)
	 * 
	 * @param userid
	 *            用户id
	 * @param date
	 *            考勤异常日期
	 * @param approve 
	 * 			  审批状态 0:审批通过  1:审批不通过
	 * @param leavetype
	 * 			  请假类型
	 * @param debugnum
	 *            请假类型次数    
	 * @return
	 */
	public int insertdepcheck(String userid, Date date, String approve, String leavetype, double debugnum) {
		Connection conn = null;
		PreparedStatement ps = null;
		double debugnum1=0;
		double debugnum2=0;
		double debugnum3=0;
		double debugnum4=0;
		double debugnum5=0;
		double debugnum6=0;
		double debugnum7=0;
		double debugnum8=0;
		if (leavetype.equals("1")) {//病假
			debugnum1=debugnum;
		} else if (leavetype.equals("2")) {//事假
			debugnum2=debugnum;
		} else if (leavetype.equals("3")) {//年休假
			debugnum3=debugnum;
		} else if (leavetype.equals("4")) {//婚假
			debugnum4=debugnum;
		} else if (leavetype.equals("5")) {//丧假
			debugnum5=debugnum;
		} else if (leavetype.equals("6")) {//产假
			debugnum6=debugnum;
		} else if (leavetype.equals("7")) {//其它
			debugnum7=debugnum;
		} else if (leavetype.equals("10")) {//探亲假
			debugnum8=debugnum;
		}
		if("1".equals(approve)){
			debugnum1 = debugnum2 = debugnum3 = debugnum4 = debugnum5 = debugnum6 = debugnum7 = 0;
		}
		String sql = "insert into depcheck (id,userid,bugnum,latenum,sicknum,absencenum,annualnum,publicnum,funeralnum,travelnum,maternitynum,checkdate,isfinish,gohomenum) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		int rsnum = 0;
		String isfinish = "";
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql.toString());
			ps.setString(1, UUID.randomUUID().toString());// 主键
			ps.setString(2, userid);//用户id
			if(approve.equals("0")){ps.setInt(3,  0);/*异常次数*/isfinish = "2";	}else{ps.setInt(3,  1);/*异常次数*/isfinish = "3";}
			ps.setInt(4, 0);// 迟到早退次数
			ps.setDouble(5, debugnum1);// 病假
			ps.setDouble(6, debugnum2);// 事假
			ps.setDouble(7, debugnum3);// 年休假
			ps.setDouble(8, debugnum7);// 其它
			ps.setDouble(9, debugnum4);// 婚假
			ps.setDouble(10, debugnum5);// 丧假
			ps.setDouble(11, debugnum6);// 产假
			java.sql.Date ud = new java.sql.Date(date.getTime());
			ps.setDate(12, ud );// 打卡日期
			ps.setString(13, isfinish);// 0：未发起/1：已发起/2：审批通过 /3：审批不通过
			ps.setDouble(14, debugnum8);// 探亲假
			rsnum = ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(null,ps,conn);
		    super.releaseSession(session);
	    }
		return rsnum;
	}
	
	/**
	 * 查询员工异常待处理表的未发起数据(当userid==""时，查询全部用户)
	 * 
	 * @return
	 */
	public List<CheckInInstall> selectabnormal(String userid) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<CheckInInstall> listcheck = new ArrayList<CheckInInstall>();
		String sqlwhe = "";
		if(null==userid){
			sqlwhe = " and 1==1 ";
		}else if("".equals(userid)){
			sqlwhe = " and 1=1 " ;
		}else{
			sqlwhe = "  and t.userid='" + userid + "'";			
		}
		// ============================================
		// org_member表的字段org_post_id位主岗ID
		// ============================================
		String sql = "select to_char(m.id) userid," +//员工id
							"amchecktime,"+ // 上午打卡时间
							"pmchecktime,"+ // 下午打卡时间
							"t.flag,"+ // 类型
							"userid,"+ // 用户id
							"checkdate,"+ // 打卡日期
							"createtime,"+ // 异常发现时间
							"startdays,"+ // 发起天数
							"approvaldays, "+ // 审批天数
							"m.code,"+ // 员工编号
							"m.name as username,"+ // 姓名
							"d.name as orgname"+ //部门
					" from checkabnormal t ," + 
					"      org_member m," + 
					"      org_unit d" + 
					" where t.userid = m.id " + 
					" and d.type='Department'" +
					"   and m.org_department_id=d.id " + 
					sqlwhe +
					"  and t.flag = 0 and m.is_deleted = 0"; //未发起
//		and m.id in (4978101965625183539,4123367025117775914,-5826626455431528410,-7424050502133004101)
		System.out.println("查询异常SQL:" + sql);
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			while(rs.next()){
				CheckInInstall ininstall = new CheckInInstall();
				ininstall.setOrgName(rs.getString("orgname"));
				ininstall.setUserId(rs.getString("userid"));
				ininstall.setUserName(rs.getString("username"));
				ininstall.setCreateTime(rs.getTimestamp("createtime"));
				ininstall.setCheckDate(rs.getDate("checkdate"));
				ininstall.setUserCode(rs.getString("code"));
				ininstall.setCheckStartTime(rs.getTimestamp("amchecktime"));
				ininstall.setCheckEndTime(rs.getTimestamp("pmchecktime"));
				ininstall.setProcessStartTime(rs.getString("startdays"));
				listcheck.add(ininstall);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(rs,ps,conn);
		    super.releaseSession(session);
	    }
		return listcheck;
	}

	/**
	 * 向异常待处理表中写入数据
	 * 
	 * @param userid
	 *            用户id
	 * @param amTime
	 *            上午打卡时间
	 * @param pmTime
	 *            下午打卡时间
	 * @param flag
	 *            类型 -1:审批不通过 0：待审批；1：审批通过
	 * @param startdays
	 *            发起天数
	 * @param approvaldays
	 *            审批天数
	 * @return
	 */
	public void insertde(List<CheckInInstall> checkinins) {
		Connection conn = null;
		PreparedStatement ps = null;
		Session session = super.getSession();
		conn = session.connection();
		try {
			// 主键,上午打卡时间,下午打卡时间,状态,用户id,异常记录时间，以发现之日的0:00:00时间记录, 发起天数,审批天数,
			String sql = "insert into checkabnormal(id,amchecktime,pmchecktime,flag,userid,checkdate,createtime, startdays,approvaldays) values(?,?,?,?,?,?,?,?,?)";
			ps = conn.prepareStatement(sql);
			for (CheckInInstall inin : checkinins) {
				String userid = inin.getUserId();
				Timestamp amTime = inin.getCheckStartTime();
				Timestamp pmTime = inin.getCheckEndTime();
				String startdays = inin.getProcessStartTime();
				String approvaldays = inin.getApprovalTime();
				Date checkd = inin.getCheckDate();
				ps.setString(1, UUID.randomUUID().toString());
				ps.setTimestamp(2, amTime);
				ps.setTimestamp(3, pmTime);
				ps.setString(4, "0");
				ps.setString(5, userid);
				// 打卡日期
				java.sql.Date ud = new java.sql.Date(checkd.getTime());
				ps.setDate(6, ud);
				// 异常记录时间
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date now = new Date();
				String nowdate = sdf.format(now);// 2013-07-01
				String nowtime = nowdate + " 0:00:00"; // 2013-07-01 0:00:00
				Timestamp bugtime = new Timestamp(sdf1.parse(nowtime).getTime());
				ps.setTimestamp(7, bugtime);
				ps.setString(8, startdays);
				ps.setString(9, approvaldays);
				ps.executeUpdate();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			destroyDBObj(null,ps,conn);
			super.releaseSession(session);
		}

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
		String sql = " select " +
							" t.amstarttime, " + 		// 上午打卡时间（开始）
							" t.amendtime, " +		// 上午打卡时间（结束）
							" t.pmstarttime, " +		// 下午打卡时间（开始）
							" t.pmendtime, " +		// 下午打卡时间（结束）
							" t.errortime, " +		// 异常判定时间点
							" t.processstarttime, " +	// 异常流程发起时间
							" t.approvaltime " +		// 请假流程审批有效时间段
					" from checkininstall t "; 
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
	 * 删除考勤查询表
	 * @param userid
	 * @param checkdate
	 */
	public void deletedepcheck(String userid,String checkdate){
		Connection conn = null;
		PreparedStatement ps = null;
		
		String sql = " delete from depcheck t where t.userid= '" + userid + "' and to_char(t.checkdate,'yyyy-MM-dd')= '" + checkdate + "'"; 
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
	 * 修改个人打卡时间表结果为0:正常,1:异常(表单审批完成后使用)
	 * 
	 * @param userid
	 * @param checkDate
	 * @param flag 0:正常 1:异常
	 * @param leavetype 请假类型
	 * @return
	 */
	public boolean updateinitcheck(String userid, String checkDate, String flag,
			String leavetype) {
		Connection conn = null;
		PreparedStatement ps = null;
		String tmp = "";
		if(flag.equals("0")){
			tmp ="t.lateflag=0,t.latenum=0,";
		}
		String sql = " update initcheckin t set t.flag='" + flag + "'," + tmp + " t.leavetype ='" + leavetype + "' where t.userid= '" + userid + "' and to_char(t.checkdate,'yyyy-MM-dd') ='" + checkDate + "'";
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			int upnum = ps.executeUpdate();
			if (upnum > 0) {
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(null,ps,conn);
		    super.releaseSession(session);
	    }
		return false;
	}

	/**
	 * 修改考勤查询表（告知公出审批结束后使用）
	 * @param userid
	 * @param checkdate
	 * @param approve 0:审批通过 1：审批不通过
	 * @return
	 */
	public int updatedepcheck(String userid,String checkdate,String approve){
		Connection conn = null;
		PreparedStatement ps = null;
		String sql="";
		
		if(approve.equals("0")){
			sql = " update depcheck set bugnum=0,latenum=0,isfinish = 2 where userid='" + userid + "' and to_char(checkdate,'yyyy-MM-dd') ='" + checkdate + "'";			
		}else{
			sql = " update depcheck set isfinish = 2 where userid='" + userid + "' and to_char(checkdate,'yyyy-MM-dd') ='" + checkdate + "'";
		}
		int rows=0;
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			rows = ps.executeUpdate();
			return rows;
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(null,ps,conn);
		    super.releaseSession(session);
	    }
		return rows;
	}
	
	
	/**
	 * 判断是否正常打卡
	 * 
	 * @param amTime
	 * @param pmTime
	 * @return
	 */
	public boolean checkOKFlase(String amTime, String pmTime) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "select t. from checkininstall t where t.amstarttime <= '" + amTime + "' and t.amendtime >= '" + amTime + "' and t.pmstarttime <= '" + pmTime + "' and t.pmendtime >= '" + pmTime + "'";
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			if (rs.next()) {
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(rs,ps,conn);
			super.releaseSession(session);
	    }

		return false;
	}

	/**
	 * ①.取得前一天日期
	 * 
	 * @return
	 */
	public String yesterday() {
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		Date d = new Date();
		Calendar now = Calendar.getInstance();
		now.setTime(d);
		now.set(Calendar.DATE, now.get(Calendar.DATE) - 1);
		// 前一天日期
		String dateBefore = df.format(now.getTime());// 2013-06-13
		return dateBefore;
	}

	/**
	 * ②.取得当天日期
	 * 
	 * @return
	 */
	public String today() {
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		Date d = new Date();
		Calendar now = Calendar.getInstance();
		now.setTime(d);
		now.set(Calendar.DATE, now.get(Calendar.DATE));
		// 当天日期
		String todaydate = df.format(now.getTime());// 2013/06/13
		return todaydate;
	}

	/**
	 * ③.取得用户对应的部门
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
		String sql = "select t.org_account_id from org_member t where t.id ="+ userid;
		String orgid = "";
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			if (rs.next()) {
				orgid = rs.getString("org_account_id");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			destroyDBObj(rs,ps,conn);
			super.releaseSession(session);
	    }
		return orgid;
	}

	/**
	 * 1.取得所有系统用户部分相关信息
	 * 
	 * @return
	 */
	public List<User> selectAllUsers() {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		List<User> userList = new ArrayList<User>();
		// ============================================
		// org_member表的字段org_post_id位主岗ID
		// ============================================
		String sql = "select t.id,t.name as username,t.code,to_char(t.org_account_id) as org_account_id,m.name as orgname,to_char(m.id) as orgId,m.path " +
				"from org_member t,org_unit m " +
				"where t.org_department_id = m.id" +
				" and m.type='Department'" + 
				" and t.is_enable=1" +// 是否有效(有效)
				" and t.is_loginable=1" +// 是否可登录(可以登录)
				" and m.is_deleted = 0" +// 是否已删除(未删除)
				" and m.is_enable = 1" +// 是否有效(有效)
				" and m.status = 1";// 部门状态(正常)
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			while(rs.next()){
				User user = new User();
				user.setUserId(Long.toString(rs.getLong("id")));
				user.setUserName(rs.getString("username"));
				user.setCode(rs.getString("code"));
				user.setAccountId(rs.getString("org_account_id"));
				user.setOrgName(rs.getString("orgname"));
				user.setOrgId(rs.getString("orgId"));
				user.setPath(rs.getString("path"));
				userList.add(user);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(rs,ps,conn);
			super.releaseSession(session);
	    }
		return userList;
	}
	
	/**
	 * 查询所有员工的登录名
	 * @return
	 */
	public List<User> getLoginno ()
	{
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
	
		List<User> userlist = new ArrayList<User>();
//		String sql="select t.full_path,t.entityinternalid as userid from security_principal t ";
		String sql ="select t.login_name,t.member_id from org_principal t";
		
		Session session = super.getSession();
		conn = session.connection();
		try 
		{
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			while(rs.next())
			{
				User u = new User();
				u.setFullPath(rs.getString("login_name"));
				u.setUserId(Long.toString(rs.getLong("member_id")));
				userlist.add(u);
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			destroyDBObj(rs,ps,conn);
			super.releaseSession(session);
	    }
		return userlist;
	}
	
	
	public Map<String,String> getLoginNameMap ()
	{
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
	
		List<User> userlist = new ArrayList<User>();
//		String sql="select t.full_path,t.entityinternalid as userid from security_principal t ";
		String sql ="select t.login_name,t.member_id from org_principal t";
		String loginName = "";
		Session session = super.getSession();
		conn = session.connection();
		Map<String,String> map = new HashMap<String,String>();
		try 
		{
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			while(rs.next())
			{
				map.put(Long.toString(rs.getLong("member_id")), rs.getString("login_name"));
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			destroyDBObj(rs,ps,conn);
			super.releaseSession(session);
	    }
		return map;
	}

	/**
	 * 查询不打卡人信息
	 * 
	 * @return
	 */
	public List<User> selectnockusers() {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<User> userList = new ArrayList<User>();
		String sql = "select u.userid from nocheckuser u";
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			while(rs.next()){
				User u = new User();
				u.setUserId(rs.getString("userid"));
				userList.add(u);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(rs,ps,conn);
			super.releaseSession(session);
	    }
		return userList;
	}

	/**
	 * 取的不打卡部门信息
	 * 
	 * @return
	 */
	public List<Department> selectnockdepartment() {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<Department> departments = new ArrayList<Department>();
		String sql = "select nd.orgid,d.path from nocheckdepartment nd, org_unit d where nd.orgid = d.id and d.type='Department'";
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			while(rs.next()){
				Department d = new Department();
				d.setDmid(rs.getString("orgid"));
				d.setPath(rs.getString("path"));
				departments.add(d);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			destroyDBObj(rs,ps,conn);
			super.releaseSession(session);
	    }
		return departments;
	}
	
	//判断前一日是否需要打卡
	public String isweek(String yester){
		//首先判断前一日是星期几，周六、周日是不需要工作的。
		Date date = new Date();
		Calendar now = Calendar.getInstance();
		now.setTime(date);
		now.set(Calendar.DATE, now.get(Calendar.DATE) - 1);
		// 前一天是星期几
		String week = new SimpleDateFormat("EEEE").format(now.getTime());

		return week;
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
		String sql = " select to_char(org_account_id) as org_account_id,date_num,is_rest,week_num,year,month from worktime_specialday t "+ 
			  	" where t.date_num='"	+ yesterday + "'";
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
			String sql = " select to_char(org_account_id) as org_account_id,week_day_name,is_work,year from worktime_currency t" +
					" where t.year ='" + year + "'" ;
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
			destroyDBObj(rs, ps, conn);
			super.releaseSession(session);
	    }
		
		return worddayset;
	}

	/**
	 * 查询个人打卡时间表
	 * 
	 * @param date
	 *            (2013-06-19)
	 * @return
	 */
	public List<InitCheckIn> selectinitcheckin(String date) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		List<InitCheckIn> initcheckin = new ArrayList<InitCheckIn>();
		
		String sql = "select t.amchecktime,t.pmchecktime,t.flag,t.userid,t.leavetype,t.week,t.checkdate,t.lateflag "
				+ "from initcheckin t where to_char(t.checkdate,'yyyy-mm-dd') ='" + date + "'" ;
		
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			while(rs.next()){
				InitCheckIn init = new InitCheckIn();
				init.setCheckStartTime(rs.getTimestamp("amchecktime"));
				init.setCheckEndTime(rs.getTimestamp("pmchecktime"));
				init.setFlag(rs.getString("flag"));
				init.setUserId(rs.getString("userid"));
				init.setLeaveType(rs.getString("leavetype"));
				init.setWeek(rs.getString("week"));
				init.setCheckdate(rs.getDate("checkdate"));
				init.setLateflag(rs.getString("lateflag"));
				initcheckin.add(init);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(rs, ps, conn);
			super.releaseSession(session);
	    }
		return initcheckin;
	}

	
	/**
	 * 查询个人打卡时间表
	 * 
	 * @param date
	 *            (2013-06-19)
	 * @return
	 */
	public List<InitCheckIn> selectinitcheckin(String userid,String date) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		List<InitCheckIn> initcheckin = new ArrayList<InitCheckIn>();
		
		String sql = " select t.amchecktime,t.pmchecktime,t.flag,t.userid,t.leavetype,t.week,t.checkdate,debugday "
					+ " from initcheckin t "
					+ " where to_char(t.checkdate,'yyyy-mm-dd') ='" + date + "'" 
					+ "  and t.userid = '" + userid + "'";
		
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			while(rs.next()){
				InitCheckIn init = new InitCheckIn();
				init.setCheckStartTime(rs.getTimestamp("amchecktime"));
				init.setCheckEndTime(rs.getTimestamp("pmchecktime"));
				init.setFlag(rs.getString("flag"));
				init.setUserId(rs.getString("userid"));
				init.setLeaveType(rs.getString("leavetype"));
				init.setWeek(rs.getString("week"));
				init.setCheckdate(rs.getDate("checkdate"));
				init.setDebugday(rs.getDouble("debugday"));
				initcheckin.add(init);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(rs, ps, conn);
			super.releaseSession(session);
	    }
		return initcheckin;
	}
	
	/**
	 * 向个人打卡时间表中写入数据
	 * 
	 * @param amTime
	 *            上午打卡时间
	 * @param pmTime
	 *            下午打卡时间
	 * @param flag
	 *            类型（-1:待处理 0：正常；1：异常）
	 * @param userid
	 *            用户id
	 * @param leaveType
	 *            请假类型
	 * @param week
	 *            星期
	 * @param checkdate
	 *            打卡日期
	 * @param debugday 请假类型异常天数
	 * @return
	 */
	public void insertcheckin(List<InitCheckIn> initListI) {
		Connection conn = null;
		PreparedStatement ps = null;
		
		StackTraceElement[] temp = Thread.currentThread().getStackTrace();
		StackTraceElement b = (StackTraceElement) temp[1];
		StackTraceElement a = (StackTraceElement) temp[2];
		File file = new File("checkin.txt");
		if (!file.exists()) {
			try {
				file.createNewFile();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		FileOutputStream fos = null;
		try {
			fos = new FileOutputStream(file, true);
		} catch (FileNotFoundException e1) {
			e1.printStackTrace();
		}

		Session session = super.getSession();
		conn = session.connection();
		try {
			String sql = "insert into initcheckin (" + "id," + // 主键
					"amchecktime," + // 上午打卡时间
					"pmchecktime," + // 下午打卡时间
					"flag," + // 类型（-1:待处理 0：正常；1：异常）
					"userid," + // 用户id
					"leavetype," + // 请假类型
					"week," + // 星期（星期一）
					"checkdate," + // 打卡日期（2013/06/20）
					"debugday" + // 请假类型异常天数
					") values (?,?,?,?,?,?,?,?,?)";
			
			ps = conn.prepareStatement(sql);
			for (InitCheckIn init : initListI) {
				Timestamp amTime = init.getCheckStartTime();
				Timestamp pmTime = init.getCheckEndTime();
				String flag = init.getFlag();
				String userid = init.getUserId();
				String leaveType = init.getLeaveType();
				String week = init.getWeek();
				Date checkdate = init.getCheckdate();
				double debugday = init.getDebugday();
				ps.setString(1, UUID.randomUUID().toString());
				ps.setTimestamp(2, amTime);
				ps.setTimestamp(3, pmTime);
				ps.setString(4, flag);
				ps.setString(5, userid);
				ps.setString(6, leaveType);
				ps.setString(7, week);
				java.sql.Date checkdd = new java.sql.Date(checkdate.getTime());
				ps.setDate(8, checkdd);
				ps.setDouble(9, debugday);
				ps.executeUpdate();
				
				if(userid==null){
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
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
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
	 * true:昨天已经打卡；false:昨天没有打卡
	 */
	public boolean checkischeck(String userid, String checkdate){
		boolean cboo = false;
		PreparedStatement ps = null;
		ResultSet rs = null;
		Session session = super.getSession();
		Connection conn = session.connection();
		try {
			String sqlmember = "select t.id from initcheckin t where t.userid='" + userid + "' and to_char(t.checkdate,'yyyy-MM-dd') ='" + checkdate +"'";
			System.out.println(sqlmember);
			ps = conn.prepareStatement(sqlmember);
			rs = ps.executeQuery();
			if(rs.next()){
				return true;
			}else{
				return false;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(rs, ps, conn);
			super.releaseSession(session);
	    }
		return cboo;
	}
	
	/**
	 * 判断员工昨天是否打卡(休息日不需要打卡)
	 * 
	 * @return
	 */
	public HashMap<String, String> checkInJudge() {
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		// 未打卡人集合
		HashMap<String, String> noCheckMember = new HashMap<String, String>();
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		// 前一天日期
		String dateBefore = df.format(new Date().getTime() - 24 * 60 * 60 * 1000);// 2013/06/13

		Session session = super.getSession();
		Connection conn = session.connection();
		try {
			// 1.查询全部员工
			String sqlmember = "select t.id,t.code,t.org_account_id from org_unit t where t.type='Department'";
			ps = conn.prepareStatement(sqlmember);
			rs = ps.executeQuery();
			
			while (rs.next()) {
				// 员工id
				String userid = rs.getString("id");
				// 员工编号
				String code = rs.getString("code");
				// 所属单位
				String userorg = rs.getString("org_account_id");
				// 2.判断员工是否打卡
				String sqlcheckin = "select t.userid from initcheckin t where userid=" + userid + " and to_char(t.checktime,'yyyy-MM-dd') =" + dateBefore;
		
				ps = conn.prepareStatement(sqlcheckin);
				rs = ps.executeQuery();
				
				// 如果有人没有打卡
				if (!rs.next()) {
					// 3.判断前一天是否为休息日
					String sqlcheck = "select t.id from worktime_specialday t "
							+ "where (t.is_rest='1' or t.is_rest='2') "
							+ "and t.org_account_id="
							+ userorg
							+ "and t.date_num=" + dateBefore;
					
					ps = conn.prepareStatement(sqlcheck);
					rs = ps.executeQuery();
					
					// 如果，前一天是休息日，或法定休息日，则不执行后面的判断。
					if (rs.next()) {
						return noCheckMember;
					} else {
						// 4.判断该员工昨天的异常是否已经写入到异常打卡信息表
						String sqlDug = "select t.id from depcheck t where t.usercode='"
								+ code
								+ "' and t.checkdate = '"
								+ dateBefore
								+ "'";
						
						ps = conn.prepareStatement(sqlDug);
						rs = ps.executeQuery();
						
						if (rs.next()) {
							// 已经写入异常打卡表，直接返回空的集合。
							return noCheckMember;
						} else {
							// 把没有打卡的人放到集合中
							noCheckMember.put(userid, code);
						}
					}
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(rs, ps, conn);
			super.releaseSession(session);
	    }

		return noCheckMember;
	}

	/**
	 * 保存或更新考勤设置信息
	 * 
	 * @param install
	 */
	public void saveUpdateCheckinSet(CheckInInstall install) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		// 查询数据库中是否有数据
		String sqlcount = "select * from checkininstall";
		Session session = super.getSession();
		Connection conn = session.connection();
		try {
			ps = conn.prepareStatement(sqlcount);
			rs = ps.executeQuery();
			ps = null;
			if (rs.next()) {
				// 数据更新sql
				String updatesql = " update checkininstall set "
						+ "amstarttime=?," + // 上午打卡开始时间
						"amendtime=?," + // 上午打卡结束时间
						"pmstarttime=?," + // 下午打卡开始时间
						"pmendtime=?," + // 下午打卡结束时间
						"errortime=?," + // 异常处理时间
						"processstarttime=?," + // 流程发起时间
						"approvaltime=?";  // 流程审批时间
				ps = conn.prepareStatement(updatesql);
				// 上午打卡开始时间
				ps.setString(1, install.getAmStartTime());
				// 上午打卡结束时间
				ps.setString(2, install.getAmEndTime());
				// 下午打卡开始时间
				ps.setString(3, install.getPmStartTime());
				// 下午打卡结束时间
				ps.setString(4, install.getPmEndTime());
				// 异常处理时间
				ps.setString(5, install.getErrorTime());
				// 流程发起时间
				ps.setString(6, install.getProcessStartTime());
				// 流程审批时间
				ps.setString(7, install.getApprovalTime());
				ps.executeUpdate();
			} else {
				// 否则就插入新数据
				String saveinstallsql = "insert into checkininstall(" + "id," + // 主键
						"amstarttime," + // 上午打卡开始时间
						"amendtime," + // 上午打卡结束时间
						"pmstarttime," + // 下午打卡开始时间
						"pmendtime," + // 下午打卡结束时间
						"errortime," + // 异常处理时间
						"processstarttime," + // 流程发起时间
						"approvaltime" + // 流程审批时间
						") values(?,?,?,?,?,?,?,?)";
				ps = conn.prepareStatement(saveinstallsql);
				ps.setString(1, UUID.randomUUID().toString());
				// 上午打卡开始时间
				ps.setString(2, install.getAmStartTime());
				// 上午打卡结束时间
				ps.setString(3, install.getAmEndTime());
				// 下午打卡开始时间
				ps.setString(4, install.getPmStartTime());
				// 下午打卡结束时间
				ps.setString(5, install.getPmEndTime());
				// 异常处理时间
				ps.setString(6, install.getErrorTime());
				// 流程发起时间
				ps.setString(7, install.getProcessStartTime());
				// 流程审批时间
				ps.setString(8, install.getApprovalTime());
				ps.executeUpdate();
			}
			
			
			// 不打卡部门id
			String departmentids = install.getNotCheckInDepartmentId();
			session = super.getSession();
			conn = session.connection();
			if (null == departmentids) 
			{
			} 
			else if ("".equals(departmentids)) 
			{
			} 
			else 
			{				
				String depArr[] = departmentids.split(",");
				// 查询不打卡部门的字符串
				List<NoCheckinDepart> nodepartments = searchNoCheckinDepartments();
				String sqli = "insert into nocheckdepartment(id,orgid) values(?,?)";
				session = super.getSession();
				conn = session.connection();
				ps = conn.prepareStatement(sqli);

				for (int i = 0; i < depArr.length; i++) 
				{
					boolean exists = false;//当前部门是否在不打卡部门表
					if("".equals(depArr[i].trim()))
					{
						continue;
					}
					for(int index=0; index<nodepartments.size(); index++)
					{
						NoCheckinDepart nd = nodepartments.get(index);
						String orgid = nd.getDeid();
						if(orgid.trim().equals(depArr[i].trim()))
						{
							exists = true;
							break;
						}
					}
					if(!exists)
					{
						ps.setString(1, UUID.randomUUID().toString());
						// 上午打卡开始时间
						ps.setString(2, depArr[i].trim());
						ps.executeUpdate();
					}
				}	
			}
			
			// 不打卡人id
			String userids = install.getNotCheckInPersonId();
			if (null == userids) 
			{
			} 
			else if ("".equals(userids)) 
			{
			} 
			else 
			{				
				// 插入人员
				String userArr[] = userids.split(",");
				// 查询不打卡人的字符串
				List<NoCheckinUser> nousers = searchNoCheckinUsers();
				session = super.getSession();
				conn = session.connection();
				String sqlInsetUser = "insert into nocheckuser(id,userid) values (?,?)";
				ps = conn.prepareStatement(sqlInsetUser);
				for (int i = 0; i < userArr.length; i++) 
				{
					boolean exists = false;
					String userid = userArr[i];
					if("".equals(userid.trim()))
					{
						break;
					}
					for(int index = 0;index<nousers.size();index++)
					{
						NoCheckinUser nextUser = nousers.get(index);
						String uid = nextUser.getUid();
						if(uid.trim().equals(userid.trim()))
						{
							exists = true;
							break;
						}
					}
					if(!exists)
					{			
						ps.setString(1, UUID.randomUUID().toString());
						ps.setString(2, userid.trim());
						ps.executeUpdate();
					}
				}
			}
			
			
			
//			// [nostatic]打卡部门id
//						String noStaticDeptIds = install.getNotStaticCheckInDepartmentId();
//						session = super.getSession();
//						conn = session.connection();
//						if (null == noStaticDeptIds) 
//						{
//						} 
//						else if ("".equals(noStaticDeptIds)) 
//						{
//						} 
//						else 
//						{				
//							String depArr[] = noStaticDeptIds.split(",");
//							// 查询不打卡部门的字符串
//							List<NoStaticCheckinDept> noStaticDepts = searchNoStaticCheckinDepartments();
//							String sqli = "insert into nostaticcheckdepartment(id,orgid) values(?,?)";
//							session = super.getSession();
//							conn = session.connection();
//							ps = conn.prepareStatement(sqli);
//
//							for (int i = 0; i < depArr.length; i++) 
//							{
//								boolean exists = false;//当前部门是否在不打卡部门表
//								if("".equals(depArr[i].trim()))
//								{
//									continue;
//								}
//								for(int index=0; index<noStaticDepts.size(); index++)
//								{
//									NoStaticCheckinDept nd = noStaticDepts.get(index);
//									String orgid = nd.getDeid();
//									if(orgid.trim().equals(depArr[i].trim()))
//									{
//										exists = true;
//										break;
//									}
//								}
//								if(!exists)
//								{
//									ps.setString(1, UUID.randomUUID().toString());
//									// 上午打卡开始时间
//									ps.setString(2, depArr[i].trim());
//									ps.executeUpdate();
//								}
//							}	
//						}
//						
//						// [nostatic]打卡人id
//						String noStaticUserids = install.getNotStaticCheckInPersonId();
//						if (null == userids) 
//						{
//						} 
//						else if ("".equals(userids)) 
//						{
//						} 
//						else 
//						{				
//							// 插入人员
//							String userArr[] = userids.split(",");
//							// 查询不打卡人的字符串
//							List<NoStaticCheckinUser> noStaticUsers = searchNoStaticCheckinUsers();
//							session = super.getSession();
//							conn = session.connection();
//							String sqlInsetUser = "insert into nocheckuser(id,userid) values (?,?)";
//							ps = conn.prepareStatement(sqlInsetUser);
//							for (int i = 0; i < userArr.length; i++) 
//							{
//								boolean exists = false;
//								String userid = userArr[i];
//								if("".equals(userid.trim()))
//								{
//									break;
//								}
//								for(int index = 0;index<noStaticUsers.size();index++)
//								{
//									NoStaticCheckinUser nextUser = noStaticUsers.get(index);
//									String uid = nextUser.getUid();
//									if(uid.trim().equals(userid.trim()))
//									{
//										exists = true;
//										break;
//									}
//								}
//								if(!exists)
//								{			
//									ps.setString(1, UUID.randomUUID().toString());
//									ps.setString(2, userid.trim());
//									ps.executeUpdate();
//								}
//							}
//						}
		} 
		catch (SQLException e1) 
		{
			e1.printStackTrace();
		}
		finally 
		{
			destroyDBObj(rs, ps, conn);
			super.releaseSession(session);
	    }
	}

	/**
	 * 查询考勤设置信息
	 * 
	 * @return
	 */
	public CheckInInstall searchCheckinSet() 
	{
		// 删除无效的部门
		deleteDisableDep();
		// 删除无效的人员
		deleteDisableUser();
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		// 拼接不打卡人的字符串
 		List<NoCheckinUser> nousers = searchNoCheckinUsers();
		Iterator<NoCheckinUser> itr = nousers.iterator();
		// 不打卡人id
		String nouserids = "";
		// 不打卡人姓名
		String nousernames = "";
		while (itr.hasNext()) 
		{
			NoCheckinUser nextUser = itr.next();
			nouserids += nextUser.getUid() + ",";
			nousernames += nextUser.getUsername() + ",";
		}
		
		if (nouserids.equals("")) 
		{
		} 
		else 
		{
			nouserids = nouserids.substring(0, nouserids.length() - 1);
		}
		if (nousernames.equals("")) 
		{
		} 
		else 
		{
			nousernames = nousernames.substring(0, nousernames.length() - 1);
		}
		
		
		// 拼接不打卡部门的字符串
		List<NoCheckinDepart> nodepartments = searchNoCheckinDepartments();
		Iterator<NoCheckinDepart> itrde = nodepartments.iterator();
		// 不打卡部门id
		String nodepartmentids = "";
		// 不打卡部门名称
		String nodepartmentnames = "";
		while (itrde.hasNext()) 
		{
			NoCheckinDepart nextdepart = itrde.next();
			nodepartmentids += nextdepart.getDeid() + ",";
			nodepartmentnames += nextdepart.getDepartname() + ",";
		}
		
		if (nodepartmentids.equals("")) 
		{
		
		} 
		else 
		{
			nodepartmentids = nodepartmentids.substring(0,nodepartmentids.length() - 1);
		}
		
		if (nodepartmentnames.equals("")) 
		{
		
		} 
		else 
		{
			nodepartmentnames = nodepartmentnames.substring(0,nodepartmentnames.length() - 1);
		}
		
		
//		// 拼接nostatic打卡人的字符串
//		 		List<NoStaticCheckinUser> noStaticUsers = searchNoStaticCheckinUsers();
//				Iterator<NoStaticCheckinUser> noStaticIt = noStaticUsers.iterator();
//				// 不打卡人id
//				String noStaticUserIds = "";
//				// 不打卡人姓名
//				String noStaticUserNames = "";
//				while (noStaticIt.hasNext()) 
//				{
//					NoStaticCheckinUser nextUser = noStaticIt.next();
//					noStaticUserIds += nextUser.getUid() + ",";
//					noStaticUserNames += nextUser.getUsername() + ",";
//				}
//				
//				if (noStaticUserIds.equals("")) 
//				{
//				} 
//				else 
//				{
//					noStaticUserIds = noStaticUserIds.substring(0, noStaticUserIds.length() - 1);
//				}
//				if (noStaticUserNames.equals("")) 
//				{
//				} 
//				else 
//				{
//					noStaticUserNames = noStaticUserNames.substring(0, noStaticUserNames.length() - 1);
//				}
//				
//				
//				// 拼接[noStatic]打卡部门的字符串
//				List<NoStaticCheckinDept> noStaticDepts = searchNoStaticCheckinDepartments();
//				Iterator<NoStaticCheckinDept> it = noStaticDepts.iterator();
//				// [nostatic]打卡部门id
//				String noStaticDeptIds = "";
//				// 不打卡部门名称
//				String noStaticDeptNames = "";
//				while (it.hasNext())
//				{
//					NoStaticCheckinDept nextdept = it.next();
//					noStaticDeptIds += nextdept.getDeid() + ",";
//					noStaticDeptNames += nextdept.getDepartname() + ",";
//				}
//				
//				if (noStaticDeptIds.equals("")) 
//				{
//				
//				} 
//				else 
//				{
//					noStaticDeptIds = noStaticDeptIds.substring(0,noStaticDeptIds.length() - 1);
//				}
//				
//				if (noStaticDeptNames.equals("")) 
//				{
//				
//				} 
//				else 
//				{
//					noStaticDeptNames = noStaticDeptNames.substring(0,noStaticDeptNames.length() - 1);
//				}
//		//--------------------------end---------------------
		
		
		String searchinstallsql = "select * from checkininstall";
		Session session = super.getSession();
		conn = session.connection();
		
		try 
		{
			ps = conn.prepareStatement(searchinstallsql);
			rs = ps.executeQuery();
			CheckInInstall checkInInstall = new CheckInInstall();
			// 不打卡部门id
			checkInInstall.setNotCheckInDepartmentId(nodepartmentids);
			// 不打卡部门名称
			checkInInstall.setNotCheckInDepartment(nodepartmentnames);
			// 不打卡人员id
			checkInInstall.setNotCheckInPersonId(nouserids);
			// 不打卡人员名称
			checkInInstall.setNotCheckInPerson(nousernames);
			
			
//			// [nostatic]打卡部门id
//			checkInInstall.setNotStaticCheckInDepartmentId(noStaticDeptIds);
//			// [nostatic]打卡部门名称
//			checkInInstall.setNotStaticCheckInDepartment(noStaticDeptNames);
//			// [nostatic]打卡人员id
//			checkInInstall.setNotStaticCheckInPersonId(noStaticUserIds);
//			// [nostatic]打卡人员名称
//			checkInInstall.setNotStaticCheckInPerson(noStaticUserNames);
						
			
			while (rs.next()) 
			{
				// 上午打卡开始时间
				checkInInstall.setAmStartTime(rs.getString("amstarttime"));
				// 上午打卡结束时间
				checkInInstall.setAmEndTime(rs.getString("amendtime"));
				// 下午打卡开始时间
				checkInInstall.setPmStartTime(rs.getString("pmstarttime"));
				// 下午打卡结束时间
				checkInInstall.setPmEndTime(rs.getString("pmendtime"));
				// 异常处理时间
				checkInInstall.setErrorTime(rs.getString("errortime"));
				// 流程发起时间
				checkInInstall.setProcessStartTime(rs.getString("processStartTime"));
				// 流程审批时间
				checkInInstall.setApprovalTime(rs.getString("approvalTime"));
			}
			return checkInInstall;
		} 
		catch (SQLException e) 
		{
			e.printStackTrace();
			return null;
		}
		finally 
		{
			destroyDBObj(rs, ps, conn);
			super.releaseSession(session);
	    }
	}

	/**
	 * 查询不打卡人信息
	 * 
	 * @return
	 */
	public List<NoCheckinUser> searchNoCheckinUsers() {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		// ============================================
		// org_member表的字段org_post_id位主岗ID
		// ============================================
		String usersql = "select m.id as nid ,m.name as mname from nocheckuser n ,org_member m where n.userid=m.id order by m.name";
		List<NoCheckinUser> ulist = new ArrayList<NoCheckinUser>();
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(usersql);
			rs = ps.executeQuery();
			while (rs.next()) {
				NoCheckinUser nuser = new NoCheckinUser();
				nuser.setUid(rs.getString("nid"));
				nuser.setUsername(rs.getString("mname"));
				ulist.add(nuser);
			}
			return ulist;
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		}finally {
			destroyDBObj(rs, ps, conn);
			super.releaseSession(session);
	    }
	}

	/**
	 * 删除不打卡人信息
	 * 
	 * @param uids
	 */
	public void deleteNoCheckinUsers(String uids) {
		Connection conn = null;
		PreparedStatement ps = null;
		String userids[] = uids.split(",");
		Session session = super.getSession();
		conn = session.connection();
		try {
			String desql = "delete from nocheckuser where userid =?";
			ps = conn.prepareStatement(desql);
			for (int i = 0; i < userids.length; i++) {
				ps.setString(1, userids[i]);
				ps.executeUpdate();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			destroyDBObj(null, ps, conn);
			super.releaseSession(session);
		}
	}

	/**
	 * 查询不打卡部门信息
	 * 
	 * @return
	 */
	public List<NoCheckinDepart> searchNoCheckinDepartments() {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "select d.id as cid,d.name as dname from nocheckdepartment c,org_unit d where d.type='Department' and d.id=c.orgid order by d.name";
		List<NoCheckinDepart> dlist = new ArrayList<NoCheckinDepart>();
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			while (rs.next()) {
				NoCheckinDepart ndepart = new NoCheckinDepart();
				ndepart.setDeid(rs.getString("cid"));
				ndepart.setDepartname(rs.getString("dname"));
				dlist.add(ndepart);
			}
			
			return dlist;
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		}finally {
			destroyDBObj(rs, ps, conn);
			super.releaseSession(session);
	    }
	}

	/**
	 * 删除不打卡部门信息
	 * 
	 * @param uids
	 */
	public void deleteNoCheckInDepartments(String dids) {
		Connection conn = null;
		PreparedStatement ps = null;
		String departids[] = dids.split(",");
		Session session = super.getSession();
		conn = session.connection();
		try {
			String delsql = "delete from nocheckdepartment where orgid =?" ;
			ps = conn.prepareStatement(delsql);
			for (int i = 0; i < departids.length; i++) {
				ps.setString(1, departids[i].trim());
				ps.executeUpdate();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(null, ps, conn);
			super.releaseSession(session);
	    }
	}

	
	
	
	
	//----------------txf add---------
	
	/**
	 * 查询[不统计]打卡人信息
	 * 
	 * @return
	 */
//	public List<NoStaticCheckinUser> searchNoStaticCheckinUsers() 
//	{
//		Connection conn = null;
//		PreparedStatement ps = null;
//		ResultSet rs = null;
//		// ============================================
//		// org_member表的字段org_post_id位主岗ID
//		// ============================================
//		String usersql = "select m.id as nid ,m.name as mname from nostaticcheckuser n ,org_member m where n.userid=m.id order by m.name";
//		List<NoStaticCheckinUser> ulist = new ArrayList<NoStaticCheckinUser>();
//		Session session = super.getSession();
//		conn = session.connection();
//		try 
//		{
//			ps = conn.prepareStatement(usersql);
//			rs = ps.executeQuery();
//			while (rs.next()) 
//			{
//				NoStaticCheckinUser nuser = new NoStaticCheckinUser();
//				nuser.setUid(rs.getString("nid"));
//				nuser.setUsername(rs.getString("mname"));
//				ulist.add(nuser);
//			}
//			return ulist;
//		}
//		catch (SQLException e) 
//		{
//			e.printStackTrace();
//			return null;
//		}
//		finally 
//		{
//			destroyDBObj(rs, ps, conn);
//			super.releaseSession(session);
//	    }
//	}

	/**
	 * 删除[不统计]打卡人信息
	 * 
	 * @param uids
	 */
	public void deleteNoStaticCheckinUsers(String uids) 
	{
		Connection conn = null;
		PreparedStatement ps = null;
		String userids[] = uids.split(",");
		Session session = super.getSession();
		conn = session.connection();
		try 
		{
			String desql = "delete from nostaticcheckuser where userid =?";
			ps = conn.prepareStatement(desql);
			for (int i = 0; i < userids.length; i++) 
			{
				ps.setString(1, userids[i]);
				ps.executeUpdate();
			}
		} 
		catch (SQLException e) 
		{
			e.printStackTrace();
		} 
		finally 
		{
			destroyDBObj(null, ps, conn);
			super.releaseSession(session);
		}
	}

	
	/**
	 * 查询[不统计]打卡部门信息
	 * 
	 * @return
	 */
//	public List<NoStaticCheckinDept> searchNoStaticCheckinDepartments() 
//	{
//		Connection conn = null;
//		PreparedStatement ps = null;
//		ResultSet rs = null;
//		String sql = "select d.id as cid,d.name as dname from nostaticcheckdepartment c,org_unit d where d.type='Department' and d.id=c.orgid order by d.name";
//		List<NoStaticCheckinDept> list = new ArrayList<NoStaticCheckinDept>();
//		Session session = super.getSession();
//		conn = session.connection();
//		try 
//		{
//			ps = conn.prepareStatement(sql);
//			rs = ps.executeQuery();
//			while (rs.next()) 
//			{
//				NoStaticCheckinDept dept = new NoStaticCheckinDept();
//				dept.setDeid(rs.getString("cid"));
//				dept.setDepartname(rs.getString("dname"));
//				list.add(dept);
//			}
//			return list;
//		} 
//		catch (SQLException e) 
//		{
//			e.printStackTrace();
//			return null;
//		}
//		finally 
//		{
//			destroyDBObj(rs, ps, conn);
//			super.releaseSession(session);
//	    }
//	}

	/**
	 * 删除[[不统计]]打卡部门信息
	 * 
	 * @param uids
	 */
	public void deleteNoStaitcCheckInDepartments(String dids) 
	{
		Connection conn = null;
		PreparedStatement ps = null;
		String departids[] = dids.split(",");
		Session session = super.getSession();
		conn = session.connection();
		try 
		{
			String delsql = "delete from nostaticcheckdepartment where orgid =?" ;
			ps = conn.prepareStatement(delsql);
			for (int i = 0; i < departids.length; i++) 
			{
				ps.setString(1, departids[i].trim());
				ps.executeUpdate();
			}
		} 
		catch (SQLException e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			destroyDBObj(null, ps, conn);
			super.releaseSession(session);
	    }
	}
	
	//----------------txf end---------
	
	
	/**
	 * 发起表单流程
	 * return true:发起成功；false:发起失败
	 */
	public boolean lauchForm(String[] usermessage) {
		BPMUtils utils = new BPMUtils();
		try {
			// 发起人登录名
			String loginName = usermessage[6];
			// 模板参数
			String templateCode = "A001";
			// 获取表单模板定义,传入要获取的模板的参数
			String xml = utils.getTemplateDefinition(templateCode);
			// 将xml文件转换成FormExport类
			FormExport export = utils.xmlTOFormExport(xml);
			// 为表单赋值
			export = utils.setValue2(export, usermessage);
			// 将复制后的表单对象转换为xml串
			xml = utils.toString(export);
			StringBuffer sb = new StringBuffer();
			sb.append("<?xml version=\"1.0\" encoding=\"GBK\"?>\n");
			sb.append(xml);
			xml = sb.toString();
			// 发起表单流程
			utils.lauchFormCollaboration(utils.getTokenId(), loginName,templateCode, xml, "1");
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	/**
	 * 通过员工编号，查询出员工id
	 * @param usercode
	 * @return
	 */
	public String getuserid(String usercode){
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String userid = "";
		Session session = super.getSession();
		conn = session.connection();
		try {
			// ============================================
			// org_member表的字段org_post_id位主岗ID
			// ============================================
			String sql = "select id from org_member m " + " where m.code = '" + usercode + "'";
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			if(rs.next()){
				userid = rs.getString("id");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			destroyDBObj(rs, ps, conn);
			super.releaseSession(session);
		}
		return userid;
	}

	/**
	 * 判断员工当天的考勤是否为正常
	 * @param userid
	 * @param checkdate
	 * @return  true:正常；false:异常
	 */
	public boolean checkisok(String userid,String checkdate){
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		Session session = super.getSession();
		conn = session.connection();
		try {
			String sql = "select t.flag from initcheckin t where t.userid='" + userid + "' and to_char(t.checkdate,'yyyy-MM-dd') ='" + checkdate + "'";
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			if(null==rs){
				return false;
			}else{
				if(rs.next()){
					String flag = rs.getString("flag");
					if("0".equals(flag)){
						return true;
					}else if("1".equals(flag)){
						return false;
					}
				}else{
					return false;
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			destroyDBObj(rs, ps, conn);
			super.releaseSession(session);
		}
		return false;
	}

	/**
	 * 查询当天考勤异常请假类型的次数(上午打卡迟到、上午旷工都算0.5天；下午打卡早退、下午旷工都算0.5天；同时存在则相加)
	 * @param amtime 上午时间
	 * @param pmtime 下午时间
	 * @param checkdate 异常打卡日期
	 * @return
	 */
	public double getleavetypenum(Timestamp amtime,Timestamp pmtime,Date checkdate){
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = " select " +
							" t.amstarttime," + 		// 上午打卡时间（开始）
							" t.amendtime," +		// 上午打卡时间（结束）
							" t.pmstarttime," +		// 下午打卡时间（开始）
							" t.pmendtime" +		    // 下午打卡时间（结束）
					" from checkininstall t"; 
		
		String amstarttime = "";//上午打卡有效开始
		String pmendtime = "";//下午打卡有效结束
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			if(rs.next()){
				amstarttime = rs.getString("amstarttime");
				pmendtime = rs.getString("pmendtime");
				
				SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				String debugdate = sdf.format(checkdate);// 2013-06-21
				
				String amstart = debugdate + " " + amstarttime;// 上午有效开始
				String pmend = debugdate + " " + pmendtime;// 下午有效开始
				
				Date amstartd = sdf1.parse(amstart); // 上午有效开始		
				Date pmendd = sdf1.parse(pmend);// 下午有效结束
				
				double intam = 0;// 上午异常次数
				double intpm = 0;// 下午异常次数
				
				//判断上午打卡异常次数
				if(null==amtime){
					intam = 0.5;
				}else {
					Date dd = new Date(amtime.getTime());
					if(dd.after(amstartd)){//迟到和早上旷工
						intam = 0.5;
					}
				}
				//判断下午打卡次数
				if(null==pmtime){
					intpm = 0.5;
				}else {
					Date dd = new Date(pmtime.getTime()); 
					if(dd.before(pmendd)){
						intpm = 0.5;
					}
				}
				// 总的迟到早退次数
				double debugnum = intam + intpm;
				return debugnum;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			destroyDBObj(rs, ps, conn);
			super.releaseSession(session);
	    }
		return 0;
	}

	/**
	 * 取得个人考勤迟到早退次数
	 * @param amtime
	 * @param pmtime
	 * @param checkdate
	 * @return
	 */
	public int getlatenum(Timestamp amtime,Timestamp pmtime,Date checkdate){
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		String sql = " select " +
							" t.amstarttime," + 	// 上午打卡时间（开始）
							" t.amendtime," +		// 上午打卡时间（结束）
							" t.pmstarttime," +		// 下午打卡时间（开始）
							" t.pmendtime" +		// 下午打卡时间（结束）
					" from checkininstall t"; 
		String amstarttime = "";
		String amendtime = "";
		String pmstarttime = "";
		String pmendtime = "";
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			if(rs.next()){
				amstarttime = rs.getString("amstarttime");
				amendtime = rs.getString("amendtime");
				pmstarttime = rs.getString("pmstarttime");
				pmendtime = rs.getString("pmendtime");
				
				SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				String debugdate = sdf.format(checkdate);// 2013-06-21
				String amstart = debugdate + " " + amstarttime;// 上午有效开始
				String amend = debugdate + " " + amendtime;// 上午有效结束
				String pmstart = debugdate + " " + pmstarttime;// 下午有效开始
				String pmend = debugdate + " " + pmendtime;// 下午有效结束
				
				Date amstartd = sdf1.parse(amstart);// 上午有效开始
				Date amendd = sdf1.parse(amend); // 上午有效结束		
				Date pmstartd = sdf1.parse(pmstart);// 下午有效开始
				Date pmendd = sdf1.parse(pmend);// 下午有效结束
				
				int intam = 0;// 上午异常次数
				int intpm = 0;// 下午异常次数
				
				//判断上午打卡异常次数
				if(null==amtime){
				}else {
					if((amtime.after(amstartd) && (amtime.before(amendd)) || amtime.compareTo(amendd)==0)){
						intam = 1;
					}
				}
				//判断下午打卡次数
				if(null==pmtime){
				}else {
					if(((pmtime.after(pmstartd) || pmtime.compareTo(pmstartd)==0) && pmtime.before(pmendd))){
						intpm = 1;
					}
				}
				// 总的迟到早退次数
				int debugnum = intam + intpm;
				return debugnum;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(rs, ps, conn);
		    super.releaseSession(session);
	    }
		return 0;
	}

	/**
	 * 修改个人打卡时间表的异常天数(0.5/1)[考勤异常判定结束后使用]
	 * @param userid
	 * @param checkdate
	 * @param debugnum 考勤异常天数(0.5/1)
	 */
	public void updateinitcheckin(List<InitCheckIn> initList){
		Connection conn = null;
		PreparedStatement ps = null;
		DateFormat ymddf = new SimpleDateFormat("yyyy-MM-dd");
		
		Session session = super.getSession();
		conn = session.connection();
		try {
			String sql = "update initcheckin t set t.debugday =?,t.lateflag =?,t.latenum =?  where t.userid =? and to_char(t.checkdate,'yyyy-MM-dd')=?";
			ps = conn.prepareStatement(sql);
			for (InitCheckIn init : initList) {
				String userid = init.getUserId();
				String checkdate = ymddf.format(init.getCheckdate());
				double debugnum = init.getDebugday();
				String lateflag = init.getLateflag();
				int lateNum = init.getLateNum();
				
				ps.setDouble(1, debugnum);
				ps.setString(2, lateflag);
				ps.setInt(3, lateNum);
				ps.setString(4, userid);
				ps.setString(5, checkdate);
				ps.executeUpdate();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			destroyDBObj(null, ps, conn);
			super.releaseSession(session);
		}
	}
	
	/**
	 * 创建文件(存在则继续执行下面)
	 * 
	 * @throws IOException
	 */
	public boolean creatTxtFile(String name) {
		boolean flag = false;
		
		filenameTemp = name + ".txt";
		File filename = new File(filenameTemp);
		System.out.println("filename:" +filenameTemp);
		if (!filename.getParentFile().exists()) {
			if (!filename.getParentFile().mkdirs()) {
				return false;
			}
		}
		System.out.println("文件名称：" + filenameTemp);
		
		if (!filename.exists()) {
			try {
				System.out.println("开始创建文件");
				filename.createNewFile();
				System.out.println("成功创建文件");
			} catch (IOException e) {
				e.printStackTrace();
			}
			flag = true;
		}
		return flag;
	}

	/**
	 * 写文件
	 * 
	 * @param newStr
	 *            新内容
	 * @throws IOException
	 */
	public boolean writeTxtFile(String newStr) {
		// 先读取原有文件内容，然后进行写入操作
		String fileEncode = System.getProperty("file.encoding"); 
		boolean flag = false;
		String filein = newStr + "\r\n";
		String temp = "";
		StringBuffer buf = new StringBuffer();

		FileInputStream fis = null;
		InputStreamReader isr = null;
		BufferedReader br = null;
		FileOutputStream fos = null;
		OutputStreamWriter  pw = null;
		try {
			// 文件路径
			File file = new File(filenameTemp);
			// 将文件读入输入流
			fis = new FileInputStream(file);
			isr = new InputStreamReader(fis);
			br = new BufferedReader(isr);

			// 保存该文件原有的内容
			for (;(temp = br.readLine())!= null;) {
				buf = buf.append(temp);
				// System.getProperty("line.separator")
				// 行与行之间的分隔符 相当于“\n”
				buf = buf.append(System.getProperty("line.separator"));
			}
			buf.append(filein);

			fos = new FileOutputStream(file,true);
			pw = new OutputStreamWriter(fos,fileEncode);
			pw.write(buf.toString().toCharArray());
			pw.flush();
			flag = true;
		} catch (IOException e1) {
			e1.printStackTrace();
		} finally {
			if (pw != null) {
				try {
					pw.close();
					pw=null;
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			if (fos != null) {
				try {
					fos.close();
					fos=null;
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			if (br != null) {
				try {
					br.close();
					br=null;
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			if (isr != null) {
				try {
					isr.close();
					isr=null;
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			if (fis != null) {
				try {
					fis.close();
					fis=null;
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		return flag;
	}
	
	/**
	 * 返回单位id
	 * @param userId
	 * @return
	 */
	public String getAccountId(String userId){
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String orgid="";
		// ============================================
		// org_member表的字段org_post_id位主岗ID
		// ============================================
		String sql = "select to_char(t.org_account_id) orgid from org_member t where to_char(t.id)='" + userId + "'";
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			while(rs.next()){
				orgid = rs.getString("orgid");
			}
			return orgid;
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(rs, ps, conn);
			super.releaseSession(session);
	    }
		
		return orgid;
	}

	/**
	 * 判断考勤异常表中是否有数据存在
	 * @param userId
	 * @param checkDate
	 * @return
	 * 			true:有数据
	 * 			false:没有数据
	 */
	public boolean existsCheckBug(String userId,String checkDate){
		boolean checkbug = false;
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		String sql = "select t.id from checkabnormal t where t.userid= '" + userId + "' and to_char(t.checkdate,'yyyy-MM-dd')='" + checkDate + "'";
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			while(rs.next()){
				return checkbug=true;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(rs, ps, conn);
		    super.releaseSession(session);
	    }
		
		return checkbug;
	} 
	
	//txf 判读一下是否请过假没
	public boolean alreadyApply(String userId,String checkDate)
	{
		boolean checkbug = false;
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		String sql = "select t.leavetype from initcheckin t where t.userid= '" + userId + "' and to_char(t.checkdate,'yyyy-MM-dd')='" + checkDate + "'";
		Session session = super.getSession();
		conn = session.connection();
		try 
		{
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			while(rs.next())
			{
				String leavetype = rs.getString("leavetype");
				
				if (leavetype == null)
				{
					return false;
				}
				if (leavetype.equals(""))
				{
					return false;
				}
				return true;
			}
		} 
		catch (SQLException e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			destroyDBObj(rs, ps, conn);
		    super.releaseSession(session);
	    }
		
		return checkbug;
	} 
	
	/**
	 * 判断考勤查询表中是否有数据存在
	 * @param userId
	 * @param checkDate
	 * @return
	 * 			true:有数据
	 * 			false:没有数据
	 */
	public boolean existsDepCheck(String userId,String checkDate){
		boolean checkbug = false;
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		String sql = "select t.id from depcheck t where t.userid= '" + userId + "' and to_char(t.checkdate,'yyyy-MM-dd')='" + checkDate + "'";
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			while(rs.next()){
				return checkbug=true;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(rs, ps, conn);
			super.releaseSession(session);
	    }
		
		return checkbug;
	} 
	/**
	 * 判断考勤查询表中的数据是否已经发起
	 * @param userId
	 * @param checkDate
	 * @return
	 * 			true:已经发起
	 * 			false:没有发起
	 */
	public boolean isStartUp(String userId,String checkDate){
		boolean checkbug = false;
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		String sql = "select t.id from depcheck t where t.userid= '" + userId + "' and to_char(t.checkdate,'yyyy-MM-dd')='" + checkDate + "' and t.isfinish!='0'";
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			while(rs.next()){
				return checkbug=true;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(rs, ps, conn);
			super.releaseSession(session);
	    }
		
		return checkbug;
	} 
	
	/**
	 * 删除无效的部门
	 */
	public void deleteDisableDep(){
		Connection conn = null;
		PreparedStatement ps = null;
		String sql = "delete from nocheckdepartment t where t.orgid not in (select nd.id from org_unit nd where nd.type='Department' and nd.is_deleted = 0 and nd.is_enable = 1 and nd.status = 1)";
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			ps.executeQuery();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(null, ps, conn);
			super.releaseSession(session);
	    }
	}
	
	/**
	 * 删除无效的人员
	 */
	public void deleteDisableUser(){
		Connection conn = null;
		PreparedStatement ps = null;
		// ============================================
		// org_member表的字段org_post_id位主岗ID
		// ============================================
		String sql = "delete from nocheckuser t where t.userid not in (select x.id from org_member x where x.is_enable=1 and x.is_loginable=1)";
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			ps.executeQuery();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(null, ps, conn);
			super.releaseSession(session);
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
	 * 销毁连接数据库对象
	 * @param rs
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
