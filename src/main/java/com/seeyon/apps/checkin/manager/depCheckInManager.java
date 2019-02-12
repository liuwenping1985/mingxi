package com.seeyon.apps.checkin.manager;

import java.io.OutputStream;
import java.util.List;

import com.seeyon.apps.checkin.domain.Department;
import com.seeyon.apps.checkin.domain.ManagerDetail;
import com.seeyon.apps.checkin.domain.PostionLevel;
import com.seeyon.apps.checkin.domain.depCheckIn;

public interface depCheckInManager {
	
	// 考勤管理
	public List<depCheckIn> getdepCheckInManage(String stime,String etime,String name,String gender,String usercode, String positionlevel,String department,String cdepartment);
	
	// 职务级别
	public List<PostionLevel> getlevels();
	// 部门
	public List<Department>  getDeparts();
	//子部门
	public List<Department> getchilddeparts();
	// 查询考勤管理迟到的 详细信息
	public List<ManagerDetail> getlateDetails(String startdate,String enddate,String userid);
	// 查询 考勤管理 异常详细列表
	public List<ManagerDetail> getbugdetails(String startdate,String enddate,String userid);
	//查询 考勤管理 请假明细信息
	public List<ManagerDetail> getleavedetails(String startdate,String enddate, String userid,String type);
	// 导出excel
	public void toExcel(List<depCheckIn> datalist,String department,String cdepartment,String name,String gender,String code,String leavel,String bugnum,String latenum,String illnum,String thingnum,String yearnum,String other,String marry,String dienum,String gohomenum,OutputStream os);
}
