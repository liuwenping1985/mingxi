package com.seeyon.apps.checkin.dao;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import com.seeyon.apps.checkin.domain.CheckInInstall;
import com.seeyon.apps.checkin.domain.Department;
import com.seeyon.apps.checkin.domain.InitCheckIn;
import com.seeyon.apps.checkin.domain.NoCheckinDepart;
import com.seeyon.apps.checkin.domain.NoCheckinUser;
import com.seeyon.apps.checkin.domain.User;
import com.seeyon.apps.checkin.domain.WorkDaySet;
import com.seeyon.apps.checkin.domain.depCheckIn;

public interface CheckInInstallDao {
	
	/**
	 * 检查前一天的考勤信息(TimerTask任务处理)
	 */
	public void checkYesterdayCheckin();
	
	/**
	 * 监听发起表单
	 * @param userid
	 */
	public void startUpForm();
	
	/**
	 * 判断员工的的打卡是否正常
	 * @param userid
	 * @param amtime上午打卡时间
	 * @param pmtime下午打卡时间
	 * @return true:正常；false:异常
	 */
	public boolean checkvalid(String userid,String amtime, String pmtime);
	
	/**
	 * 修改考勤查询表(考勤异常审批后使用)
	 * @param approval 0:审批通过 1:审批不通过
	 * @param userid 用户id
	 * @param checkdate 考勤日期
	 * @param leavetype 请假类型
	 * @param debugnum 请假天数(0.5/1)
	 * @return
	 */
	public int updatedepcheck(String approval,String userid, String checkdate, String leavetype, double debugnum);
	
	/**
	 * 修改考勤查询表(考勤异常表单发起后使用)
	 * @param userid
	 * @param checkdate
	 * @return
	 */
	public int updatedepcheck(String userid,Date checkdate);
	
	/**
	 * 修改异常待处理表(考勤异常表单发起后使用)
	 * 
	 * @param userid
	 * @param checkdate
	 * @return
	 */
	public int updatecheckabnormal(String userid, String checkdate) ;
	
	/**
	 * 删除异常待处理表的
	 * 
	 * @param userid
	 * @param checkdate
	 * @return
	 */
	public int deletecheckabnormal(String userid, String checkdate) ;
	
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
	public void insertdepcheck(List<depCheckIn> depcheck) ;
	
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
	public int insertdepcheck(String userid, Date date, String approve, String leavetype, double debugnum) ;
	
	/**
	 * 查询员工异常待处理表的未发起数据(当userid==""时，查询全部用户)
	 * 
	 * @return
	 */
	public List<CheckInInstall> selectabnormal(String userid) ;
	
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
	public void insertde(List<CheckInInstall> checkinins) ;
	
	/**
	 * 查询考勤设置表
	 * 
	 * @return
	 */
	public List<CheckInInstall> selectffectivect() ;
	
	/**
	 * 删除考勤查询表
	 * @param userid
	 * @param checkdate
	 */
	public void deletedepcheck(String userid,String checkdate) ;
	
	/**
	 * 修改个人打卡时间表结果为0:正常,1:异常(表单审批完成后使用)
	 * 
	 * @param userid
	 * @param checkDate
	 * @param flag 0:正常 1:异常
	 * @param leavetype 请假类型
	 * @return
	 */
	public boolean updateinitcheck(String userid, String checkDate, String flag, String leavetype) ;
	
	/**
	 * 修改考勤查询表（告知公出审批结束后使用）
	 * @param userid
	 * @param checkdate
	 * @param approve 0:审批通过 1：审批不通过
	 * @return
	 */
	public int updatedepcheck(String userid,String checkdate,String approve);
	
	/**
	 * 判断是否正常打卡
	 * 
	 * @param amTime
	 * @param pmTime
	 * @return
	 */
	public boolean checkOKFlase(String amTime, String pmTime) ;
	
	/**
	 * ①.取得前一天日期
	 * 
	 * @return
	 */
	public String yesterday() ;
	
	/**
	 * ②.取得当天日期
	 * 
	 * @return
	 */
	public String today() ;
	
	/**
	 * ③.取得用户对应的部门
	 * 
	 * @param userid
	 * @return
	 */
	public String selectOrgId(String userid) ;
	
	/**
	 * 1.取得所有系统用户部分相关信息
	 * 
	 * @return
	 */
	public List<User> selectAllUsers() ;
	
	/**
	 * 查询所有员工的登录名
	 * @return
	 */
	public List<User> getLoginno ();
	
	/**
	 * 查询不打卡人信息
	 * 
	 * @return
	 */
	public List<User> selectnockusers() ;
	
	/**
	 * 取的不打卡部门信息
	 * 
	 * @return
	 */
	public List<Department> selectnockdepartment() ;
	
	//判断前一日是否需要打卡
	public String isweek(String yester) ;
	
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
	 * 查询个人打卡时间表
	 * 
	 * @param date
	 *            (2013-06-19)
	 * @return
	 */
	public List<InitCheckIn> selectinitcheckin(String date) ;
	
	/**
	 * 查询个人打卡时间表
	 * 
	 * @param date
	 *            (2013-06-19)
	 * @return
	 */
	public List<InitCheckIn> selectinitcheckin(String userid,String date) ;
	
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
	public void insertcheckin(List<InitCheckIn> initListI) ;
	
	public String getTime();
	
	/**
	 * true:昨天已经打卡；false:昨天没有打卡
	 */
	public boolean checkischeck(String userid, String checkdate);
	
	/**
	 * 判断员工昨天是否打卡(休息日不需要打卡)
	 * 
	 * @return
	 */
	public HashMap<String, String> checkInJudge() ;
	
	/**
	 * 保存或更新考勤设置信息
	 * 
	 * @param install
	 */
	public void saveUpdateCheckinSet(CheckInInstall install) ;
	
	/**
	 * 查询考勤设置信息
	 * 
	 * @return
	 */
	public CheckInInstall searchCheckinSet() ;
	
	/**
	 * 查询不打卡人信息
	 * 
	 * @return
	 */
	public List<NoCheckinUser> searchNoCheckinUsers();

	/**
	 * 删除不打卡人信息
	 * 
	 * @param uids
	 */
	public void deleteNoCheckinUsers(String uids) ;
	
	/**
	 * 查询不打卡部门信息
	 * 
	 * @return
	 */
	public List<NoCheckinDepart> searchNoCheckinDepartments() ;
	
	/**
	 * 删除不打卡部门信息
	 * 
	 * @param uids
	 */
	public void deleteNoCheckInDepartments(String dids) ;
	
	/**
	 * 发起表单流程
	 * return true:发起成功；false:发起失败
	 */
	public boolean lauchForm(String[] usermessage) ;
	
	/**
	 * 通过员工编号，查询出员工id
	 * @param usercode
	 * @return
	 */
	public String getuserid(String usercode);
	
	/**
	 * 判断员工当天的考勤是否为正常
	 * @param userid
	 * @param checkdate
	 * @return  true:正常；false:异常
	 */
	public boolean checkisok(String userid,String checkdate);
	
	/**
	 * 查询当天考勤异常请假类型的次数(上午打卡迟到、上午旷工都算0.5天；下午打卡早退、下午旷工都算0.5天；同时存在则相加)
	 * @param amtime 上午时间
	 * @param pmtime 下午时间
	 * @param checkdate 异常打卡日期
	 * @return
	 */
	public double getleavetypenum(Timestamp amtime,Timestamp pmtime,Date checkdate) ;
	
	/**
	 * 取得个人考勤迟到早退次数
	 * @param amtime
	 * @param pmtime
	 * @param checkdate
	 * @return
	 */
	public int getlatenum(Timestamp amtime,Timestamp pmtime,Date checkdate) ;
	
	/**
	 * 修改个人打卡时间表的异常天数(0.5/1)[考勤异常判定结束后使用]
	 * @param userid
	 * @param checkdate
	 * @param debugnum 考勤异常天数(0.5/1)
	 */
	public void updateinitcheckin(List<InitCheckIn> initList) ;
	
	/**
	 * 创建文件(存在则继续执行下面)
	 * 
	 * @throws IOException
	 */
	public boolean creatTxtFile(String name) ;
	
	/**
	 * 写文件
	 * 
	 * @param newStr
	 *            新内容
	 * @throws IOException
	 */
	public boolean writeTxtFile(String newStr) ;
	
	/**
	 * 返回单位id
	 * @param userId
	 * @return
	 */
	public String getAccountId(String userId);

	/**
	 * 判断考勤异常表中是否有数据存在
	 * @param userId
	 * @param checkDate
	 * @return
	 * 			true:有数据
	 * 			false:没有数据
	 */
	public boolean existsCheckBug(String userId,String checkDate) ;
	
	/**
	 * 判断考勤查询表中是否有数据存在
	 * @param userId
	 * @param checkDate
	 * @return
	 * 			true:有数据
	 * 			false:没有数据
	 */
	public boolean existsDepCheck(String userId,String checkDate);
	
	/**
	 * 判断考勤查询表中的数据是否已经发起
	 * @param userId
	 * @param checkDate
	 * @return
	 * 			true:已经发起
	 * 			false:没有发起
	 */
	public boolean isStartUp(String userId,String checkDate);
	
	/**
	 * 删除无效的部门
	 */
	public void deleteDisableDep();
	
	/**
	 * 删除无效的人员
	 */
	public void deleteDisableUser();
	
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
	 * 销毁连接数据库对象
	 * @param rs
	 */
	public void destroyDBObj(ResultSet rs,PreparedStatement ps,Connection conn) ;
}
