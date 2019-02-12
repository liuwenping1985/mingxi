package com.seeyon.apps.checkin.dao;

import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import com.seeyon.apps.checkin.domain.Department;
import com.seeyon.apps.checkin.domain.ManagerDetail;
import com.seeyon.apps.checkin.domain.PostionLevel;
import com.seeyon.apps.checkin.domain.depCheckIn;

public interface DepCheckInDao {
	
	// 把没有打卡的人员信息，插入到异常打卡表中，用来统计数据
	public void setCheckInList(HashMap<String, String> noCheckMember);
	
	/**
	 * 查询员工的副岗编号
	 * @param userid
	 * @return
	 */
	public String getpostcode(String userid);
	
	/**
	 * 查询员工的副岗id
	 * @param userid
	 * @return
	 */
	public String getpostid(String postcode);
	
	/**
	 * 根据用户id和岗位id查询副岗位对应的部门id
	 * @param userid
	 * @param postId
	 * @return
	 */
	public List<String> postOrgId(String userid,String postId);
	
	/**
	 * 根据用户id和岗位id查询副岗位对应的部门id
	 * @param userid
	 * @param postId
	 * @return
	 */
	public String mainpostOrgId(String userid,String postId);
	
	/**
	 * 查询考勤管理
	 */
	public List<depCheckIn> getdepCheckInManage(String stime, String etime,String name, String gender, String usercode, String positionlevel, String department, String cdepartment);
	
	/**
	 * 查询所有的职务级别
	 * 
	 * @return
	 */
	public List<PostionLevel> selectlevels() ;
	
	/**
	 * 查询部门
	 * 
	 * @return
	 */
	public List<Department> selectDeparts() ;
	
	/**
	 * 查询子部门
	 * 
	 * @return
	 */
	public List<Department> selectchilddepart() ;
	
	/**
	 * 查询迟到或者早退的详细信息
	 * 
	 * @param userid
	 * @return
	 */
	public List<ManagerDetail> getLateDetail(String startdate,String enddate,String userid) ;
	
	/**
	 * 判断是否迟到早退
	 * @param amtime 上午时间
	 * @param pmtime 下午时间
	 * @param checkdate 异常打卡日期
	 * @return true 迟到或者早退
	 *         false 没有迟到早退
	 */
	public boolean getleavetypenum(Timestamp amtime,Timestamp pmtime,Date checkdate);
	
	/**
	 * 查询异常的详细信息列表
	 * 
	 * @param userid
	 * @return
	 */
	public List<ManagerDetail> getbugdetails(String startdate,String enddate,String userid) ;
	
	/**
	 * 查询相对应的请假明细
	 * 
	 * @param userid
	 * @param type
	 * @return
	 */
	public List<ManagerDetail> getleavedetails(String startdate, String enddate, String userid, String type) ;
	
	/**
	 * 根据相应内容将数据导出到excel
	 * 
	 * @param datalist
	 * @param department
	 * @param cdepartment
	 * @param name
	 * @param gender
	 * @param code
	 * @param leavel
	 * @param bugnum
	 * @param latenum
	 * @param illnum
	 * @param thingnum
	 * @param yearnum
	 * @param other
	 * @param marry
	 * @param dienum
	 * @param babynum
	 */
	public void toExcel(List<depCheckIn> datalist, String department,
			String cdepartment, String name, String gender, String code,
			String leavel, String bugnum, String latenum, String illnum,
			String thingnum, String yearnum, String other, String marry,
			String dienum, String gohomenum,OutputStream os) ;
	
	/**
	 * 销毁连接数据库对象
	 * @param rs
	 */
	public void destroyDBObj(ResultSet rs,PreparedStatement ps,Connection conn) ;
}
