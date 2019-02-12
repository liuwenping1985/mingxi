package com.seeyon.apps.checkin.manager;

import java.io.OutputStream;
import java.util.List;

import com.seeyon.apps.checkin.dao.DepCheckInDao;
import com.seeyon.apps.checkin.domain.Department;
import com.seeyon.apps.checkin.domain.ManagerDetail;
import com.seeyon.apps.checkin.domain.PostionLevel;
import com.seeyon.apps.checkin.domain.depCheckIn;

public class depCheckInManagerImpl implements depCheckInManager{
	
	private DepCheckInDao depDao;
	
	public DepCheckInDao getDepDao() {
		return depDao;
	}

	public void setDepDao(DepCheckInDao depDao) {
		this.depDao = depDao;
	}

	/**
	 * 查询考勤管理
	 */
	public List<depCheckIn> getdepCheckInManage(String stime,String etime,String name,String gender,String usercode, String positionlevel,String department,String cdepartment) {
		
		return this.depDao.getdepCheckInManage(stime, etime, name,gender,usercode,positionlevel,department,cdepartment);
	}
	/**
	 * 查询所有的职务级别	
	 * @return
	 */
	public List<PostionLevel> getlevels(){
		return this.depDao.selectlevels();
	}
	/**
	 * 查询所有部门
	 * @return
	 */
	public List<Department>  getDeparts(){
		return this.depDao.selectDeparts();
	}
	/**
	 * 查询子部门
	 * @param fpath
	 * @return
	 */
	public List<Department> getchilddeparts(){
		return this.depDao.selectchilddepart();
	}
	/**
	 * 查询迟到的详细列表
	 * @param userid
	 * @return
	 */
	public List<ManagerDetail> getlateDetails(String startdate,String enddate,String userid){
		return this.depDao.getLateDetail(startdate,enddate,userid);
	}
	/**
	 * 查询异常信息详细列表	
	 * @param userid
	 * @return
	 */
	public List<ManagerDetail> getbugdetails(String startdate,String enddate,String userid){
		return this.depDao.getbugdetails(startdate,enddate,userid);
	}
	/**
	 * 查询相应请假明细
	 * @param userid
	 * @param type
	 * @return
	 */
	public List<ManagerDetail> getleavedetails(String startdate,String enddate,String userid,String type){
		return  this.depDao.getleavedetails(startdate,enddate,userid, type); 
	}
	/**
	 * 导出excel表格
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
	public void toExcel(List<depCheckIn> datalist,String department,String cdepartment,String name,String gender,String code,String leavel,String bugnum,String latenum,String illnum,String thingnum,String yearnum,String other,String marry,String dienum,String gohomenum,OutputStream os){
		depDao.toExcel(datalist, department, cdepartment, name, gender, code, leavel, bugnum, latenum, illnum, thingnum, yearnum, other, marry, dienum ,gohomenum,os);
	}


}
