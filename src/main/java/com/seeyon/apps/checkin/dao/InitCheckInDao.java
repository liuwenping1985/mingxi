package com.seeyon.apps.checkin.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.apps.checkin.domain.CheckInInstall;
import com.seeyon.apps.checkin.domain.InitCheckIn;
import com.seeyon.apps.checkin.domain.WorkDaySet;

public interface InitCheckInDao {

	/**
	 * 判断用户是否为不打卡人
	 * @param check
	 * @return  true:不打卡人；false:打卡人
	 */
	public boolean nocheckinuser(InitCheckIn check);
	
	/**
	 * 判断用户是否是为不打卡部门
	 * @param check
	 * @return  true:不打卡部门；false:打卡部门
	 */
	public boolean nocheckindepartmentchild(InitCheckIn check);
	
	/**
	 * 插入打卡明细表
	 * @param check
	 */
	public boolean insertcheckdetail(InitCheckIn check);
	
	/**
	 * 查询用户的请假类型
	 * @return
	 */
	public String queryLeaveType(String userid, String checkdate);
	
	/**
	 * 更新个人打卡表 // 9:上午旷工 0:下午旷工 1:上午正常打卡 2:下午正常打卡 -1:迟到 -2:早退
	 * @param check
	 */
	public void updatecheckin(String leavetype,int checkflag,String userid,String nowdate,Timestamp checkdt,boolean workneed);
	
	/**
	 * 校验上午打卡是否正常
	 * @return 0:正常 1:异常
	 */
	public String checkamtime(String userid,String checkdate);
	
	/**
	 * 查询考勤设置表
	 * 
	 * @return
	 */
	public List<CheckInInstall> selectffectivect() ;
	
	/**
	 * 插入个人打卡表
	 * @param checkflag
	 * @param check
	 * @param nowdd
	 * @param checkdt
	 */
	public void insertcheckin(int checkflag, InitCheckIn check,Date nowdd);
	
	public String getTime();
	
	/**
	 * 判断个人打卡时间表中是否已经有当天的数据
	 * @param userid
	 * @param checkdate
	 * @return
	 */
	public boolean isnot(String userid,String checkdate);
	
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
	public String savecheck(InitCheckIn check) ;
	
	/**
	 * 转化字符串日期的格式
	 * @param s 2013-09-01
	 * @return 2013/09/01
	 */
	public String toDate1(String s);
	
	/**
	 * 转化字符串日期的格式
	 * @param s 2013/09/01
	 * @return 2013-09-01
	 */
	public String toDate2(String s);
	
	/**
	 * 转化字符串月份的格式
	 * @param month
	 * @return
	 */
	public String toMonth(String month) ;
	
	/**
	 * 取得用户对应的部门
	 * 
	 * @param userid
	 * @return
	 */
	public String selectOrgId(String userid) ;
	
	/**
	 * 查询工作日、休息日设置表
	 * @return
	 * 
	 */
	public List<WorkDaySet> getspecialday(String yesterday);
	
	/**
	 * 查询工作时间设置表
	 * 
	 * @param userorgid
	 *            用户所属部门
	 * @param dateBefore
	 *            前一天日期(2013-06-19)
	 * @return boolean true:需要打卡； false:不需要打卡
	 */
	public List<WorkDaySet> getcurrency(String dateBefore) ;
	
	/**
	 * 当天是星期几
	 * @return
	 */
	public String isweek();
	
	/**
	 * 计算日期提前多少天
	 * @param d
	 * @param day
	 * @return
	 */
	public Date getDateBefore(Date d, int day) ;
	
	/**
	 * 计算日期推迟多少天
	 * @param d
	 * @param day
	 * @return
	 */
	public Date getDateAfter(Date d, int day) ;
	
	/**
	 * 查询当前用户所有打卡记录
	 * 
	 * @return
	 */
	public List<InitCheckIn> findCheckInAll(String userid) ;
	
	/**
	 * 根据条件，查询打卡记录
	 * 
	 * @return
	 */
	public List<InitCheckIn> findCheckInAll(String stime,String etime, String flag, String userid, String leaveType) ;
	
	/**
	 * 查询异常类型的名称和值
	 * @return
	 */
	public Map<String,String> getEnumValue();
	
	/**
	 * 查询打卡的详细信息
	 * 
	 * @param checkdate
	 * @return
	 */
	public List<InitCheckIn> findDetail(String checkdate, String userid);
	
	/**
	 * 查询请假类别
	 * 
	 * @return
	 */
	public HashMap<String, String> findLeaveType();
	
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
	public int checkinflag(String userid,Date nowdd);
	
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
	public int checkinstate(Date nowdd);
	
	/**
	 * 判断IP是否为不打卡IP
	 * @param fileNamePath
	 * @param key
	 * @return
	 */
	public boolean chenkIp(String ip) ;
	
	/**
	 * 根据登录名查询用户ID
	 * @param loginName
	 * @return
	 */
	public String findUserIdbyloginName(String loginName) ;
	
	/**
	 * 根据key读取value
	 * @param fileNamePath
	 * @param key
	 * @return
	 */
	public String getValue(String fileNamePath, String key) ;
	
	/**
	 * 删除考勤查询表
	 * @param userid
	 * @param checkdate
	 */
	public void deletedepcheck(String userid,String checkdate);
	
	/**
	 * 销毁连接数据库对象
	 * @param rs
	 * @param ps
	 * @param conn
	 */
	public void destroyDBObj(ResultSet rs,PreparedStatement ps,Connection conn) ;
	
}
