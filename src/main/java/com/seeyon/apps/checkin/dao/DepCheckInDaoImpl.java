package com.seeyon.apps.checkin.dao;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.hibernate.Session;

//import com.seeyon.v3x.common.authenticate.domain.User;
//import com.seeyon.v3x.common.web.login.CurrentUser;
import com.seeyon.apps.checkin.client.CheckUtils;
import com.seeyon.apps.checkin.domain.Department;
import com.seeyon.apps.checkin.domain.ManagerDetail;
import com.seeyon.apps.checkin.domain.PostionLevel;
import com.seeyon.apps.checkin.domain.depCheckIn;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.dao.BaseHibernateDao;
import static com.seeyon.ctp.common.AppContext.getCurrentUser;

public class DepCheckInDaoImpl extends BaseHibernateDao<depCheckIn> implements DepCheckInDao{
	
	// 把没有打卡的人员信息，插入到异常打卡表中，用来统计数据
	@SuppressWarnings("rawtypes")
	public void setCheckInList(HashMap<String, String> noCheckMember) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		Set set = noCheckMember.keySet();
		Iterator iterator = set.iterator();
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		String dateBefore = df.format(new Date().getTime() - 24 * 60 * 60 * 1000);// 2013/06/13

		Session session = super.getSession();
		conn = session.connection();
		while (iterator.hasNext()) {
			String userid = (String) iterator.next();
			String code = noCheckMember.get(userid);
			UUID uuid = UUID.randomUUID();
			String insertCheck = "insert into depcheck (ID,USERID,BUGNUM,LATENUM,SICKNUM,ABSENCENUM,ANNUALNUM,PUBLICNUM,FUNERALNUM,TRAVELNUM,MATERNITYNUM,ISFINISH,USERCODE,CHECKDATE,GOHOMENUM) VALUES('"
					+ uuid.toString()+ "','"+ userid+ "',"+ 1+ ","+ 0+ ","+ 0 + ","+ 0+ ","+ 0+ ","+ 0+ ","+ 0+ ","+ 0+ ","+ 0+ ","+ "'0','"+ code+ "','"	+ dateBefore+ "',"+ 0+ ")";
			try {
				ps = conn.prepareStatement(insertCheck);
				rs = ps.executeQuery();
			} catch (SQLException e) {
				e.printStackTrace();
			}finally {
				destroyDBObj(rs, ps, conn);
				super.releaseSession(session);
		    }
		}
	}
	
	/**
	 * 查询员工的副岗编号
	 * @param userid
	 * @return
	 */
	public String getpostcode(String userid){
		String methodName = Thread.currentThread().getStackTrace()[1].getMethodName();
		System.out.println("methodName:" + methodName);
		
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		String ret = "";
		String postcode = "";
		// ============================================
		// org_member表的字段org_post_id位主岗ID
		// ============================================
//		String sql = "select distinct p.code from org_relationship t,org_post p  where to_char(t.source_id) = to_char(p.org_account_id)  and (code='01' or code='02' or code='03') " +
//								   " and to_char(t.source_id) = '" + userid + "'"; 
//		String sql = "select distinct p.code from org_post p,org_member m where to_char(p.org_account_id) = to_char(m.org_account_id) and to_char(m.id)='" + userid + "' and p.code is not null";
		String sql = "select distinct m.code from org_relationship r,org_post m " +
				" where r.source_id='" + userid + "' and r.type='Member_Post' and r.objective5_id='Second' and to_char(r.objective1_id) = to_char(m.id) order by m.code";
		
		//System.out.println("sql:" + sql);
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			while(rs.next()){
				//System.out.println("while");
				postcode = rs.getString("code");
				if(ret.isEmpty()) {
					if(null == postcode){
						ret = "";
						//System.out.println("null == postcode");
					}
					else if(postcode.trim().equals("01")){
						ret = "01";
						//System.out.println("ret = 01");
					}
					else if(postcode.trim().equals("02")){
						ret = "02";
						//System.out.println("ret = 02");
					}
					else if(postcode.trim().equals("03")){
						ret = "03";
						//System.out.println("ret = 03");
					}
				}
			}
			//System.out.println("ret:" + ret);
			return ret;
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(rs, ps, conn);
		    super.releaseSession(session);
	    }
		return ret;
	}
	
	/**
	 * 查询员工的副岗id
	 * @param userid
	 * @return
	 */
	public String getpostid(String postcode){
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		Session session = super.getSession();
		conn = session.connection();
		
		String id= "";
		
		String sql = "select t.id from org_post t where t.code='" + postcode + "'"; 
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			if(rs.next()){
				id = rs.getString("id");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(rs, ps, conn);
		    super.releaseSession(session);
	    }
		return id;
	}
	
	/**
	 * 根据用户id和岗位id查询副岗位对应的部门id
	 * @param userid
	 * @param postId
	 * @return
	 */
	public List<String> postOrgId(String userid,String postId){
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		List<String> orgIdList= new ArrayList<String>();
		
//		orgId = mainpostOrgId(userid,postId);
		
		Session session = super.getSession();
		conn = session.connection();
//		if(!orgId.equals("")) return orgId;
		
//		String sql = "select to_char(t.objective0_id) orgId from org_relationship t , org_post tt where to_char(t.source_id) = to_char(p.org_account_id)  and (code='01' or code='02' or code='03') " +
//					" and to_char(t.source_id)='" + userid + "'" +
//					"   and to_char(tt.id)='" + postId + "'";
//		String sql = "select to_char(t.objective0_id) orgId from org_relationship t , org_post tt where to_char(t.objective1_id) = to_char(tt.id)  and (code='01' or code='02' or code='03') " +
//				" and to_char(t.source_id)='" + userid + "'" +
//				"   and to_char(tt.id)='" + postId + "'"; 
		
		
		String sql = "select objective0_id as orgId from org_relationship where type='Member_Post' " +
						"and to_char(source_id) ='" + userid + "' and to_char(objective1_id) = '" + postId + "'";
		
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			while(rs.next()){
				String orgId = rs.getString("orgId");
				orgIdList.add(orgId);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(rs, ps, conn);
		    super.releaseSession(session);
	    }
		return orgIdList;
	}
	
	/**
	 * 查询部门path
	 * @param orgId
	 * @return
	 */
	public List<String> getOrgPath(List<String> orgId) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		List<String> pathList = new ArrayList<String>();

		String orgIdString = getListToString(orgId);

		Session session = super.getSession();
		conn = session.connection();

		String sql = "";
		if (orgIdString != null && !orgIdString.equals(""))
		{
			sql = "select t.path from org_unit t";
		}
		else
		{
			sql = "select t.path from org_unit t where t.id in (" + orgIdString + ")";
		}
		
		try 
		{
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			while (rs.next()) 
			{
				String pathStr = rs.getString("path");
				pathList.add(pathStr);
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
		return pathList;
	}
	
	public static void main(String[] args) {
		List<String> ss = new ArrayList<String>();
		ss.add("aaa");
		ss.add("bbb");
		ss.add("ccc");
//		System.out.println(getOrgString(ss));
	}
	
	/**
	 * 把List转换成字符串
	 * @param orgIdList
	 * @return
	 */
	public String getListToString(List<String> orgIdList){
		String orgIdStr = "";
		for(String orgId : orgIdList) {
			orgIdStr = orgIdStr + "'" + orgId + "',";
		}
		if(!orgIdStr.isEmpty()) {
			orgIdStr = orgIdStr.substring(0, orgIdStr.length()-1);
		}
		return orgIdStr;
	}
	
	/**
	 * 取得部门Id
	 * @param userid
	 * @return
	 */
	public String getOrgId(String userid){
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		String orgId= "";
		String sql = "select t.org_department_id orgId from org_member t where t.id = '" + userid + "'";
		
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			if(rs.next()){
				orgId = rs.getString("orgId");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(rs, ps, conn);
		    super.releaseSession(session);
	    }
		return orgId;
	}
	
	/**
	 * 根据用户id和岗位id查询副岗位对应的部门id
	 * @param userid
	 * @param postId
	 * @return
	 */
	public String mainpostOrgId(String userid,String postId){
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		String orgId= "";
		// ============================================
		// org_member表的字段org_post_id位主岗ID
		// ============================================
//		String sql = "select to_char(t.org_department_id) orgId from org_member t " +
//					" where t.id='" + userid + "'" +
//					"   and t.org_post_id='" + postId + "'"; 
		
		String sql = "select to_char(p.source_id) orgId from org_relationship p,org_unit u where (p.source_id) = to_char(u.id) and p.type='Department_Post' and to_char(p.objective0_id)='" + postId + "'";
		
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			if(rs.next()){
				orgId = rs.getString("orgId");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(rs, ps, conn);
		    super.releaseSession(session);
	    }
		return orgId;
	}
	
	/**
	 * 查询考勤管理
	 */
	public List<depCheckIn> getdepCheckInManage(String stime, String etime,String name, String gender, String usercode, String positionlevel, String department, String cdepartment) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		// 获取当前登录用户
		User user = getCurrentUser();
		//获取当前用户的所属单位
		String accountid = (user.getAccountId()+"").trim();
		String sqlwhere = "";
		// 开始时间
		if (stime != null && !stime.equals("")) {
			sqlwhere += " and to_char(d.checkdate,'yyyy-MM-dd') >= '" + stime + "'";
		}
		// 结束时间
		if (etime != null && !etime.equals("")) {
			sqlwhere += " and to_char(d.checkdate,'yyyy-MM-dd') <= '" + etime + "'";
		}
		// 姓名
		if (name != null && !name.equals("")) {
			sqlwhere += " and m.name like '%" + name + "%'";
		}
		// 性别
		if (gender != null && !gender.equals("")) {
			sqlwhere += " and m.ext_attr_11 = '" + gender + "'";
		}
		// 员工编号
		if (usercode != null && !usercode.equals("")) {
			String[] codeArr = usercode.trim().split(",");
			String codestr = "";
			for(String code:codeArr){
				codestr = codestr + "'" + code.trim() + "',";
			}
			codestr = codestr.substring(0, codestr.length()-1);
			sqlwhere += " and m.code in(" + codestr + ")";
		}
		// 职务级别
		if (positionlevel != null && !positionlevel.equals("")) {
			sqlwhere += " and l.name like '%" + positionlevel + "%'";
		}
		// 二级部门
		if (cdepartment != null && !cdepartment.equals("")) {
			sqlwhere += " and de.name = '" + cdepartment + "'";
		} else if (department != null && !department.equals("")){// 一级部门
			sqlwhere += " and (de.path='" + department + "' or de.path like '" + department + "%')";
		}

		//岗位编号
		String postcode = getpostcode(Long.toString(user.getId()));
		//岗位id
		String postId = getpostid(postcode);
		
		//部门id
		List<String> orgIdList = postOrgId(Long.toString(user.getId()),postId);
		
		// 取得部门path
		List<String> orgPathList = getOrgPath(orgIdList);
		
		List<depCheckIn> alldepCheckList = new ArrayList<depCheckIn>();
		Session session = super.getSession();
		conn = session.connection();
		
		try{
			// 岗位为：人力考勤员
			if (postcode.equals("01")) {
				// 查询当前登录用户所属单位下面的部门名称和路径
//				String fathernamesql = "select d.name,d.path from org_unit d where d.type='Department' and d.org_account_id = '"+accountid+"' and d.is_deleted = 0 and d.is_enable = 1 and d.status = 1";
				String fathernamesql = "select d.name,d.path from org_unit d where d.type='Department' and d.is_deleted = 0 and d.is_enable = 1 and d.status = 1";
				List<depCheckIn> dep = null;
				//System.out.println("===================================================");
				ps = conn.prepareStatement(fathernamesql);
				rs = ps.executeQuery();
				dep = new ArrayList<depCheckIn>();
				while (rs.next()) {
					depCheckIn d = new depCheckIn();
					d.setDepartment(rs.getString("name"));// 部门名称
					d.setPath(rs.getString("path"));// 路径
					dep.add(d);
				}
				// ============================================
				// org_member表的字段org_post_id位主岗ID
				// ============================================
				// 属于人力资源考勤员可查询所有部门及所有员工的记录
				String queryalldepartsql = " select m.id as userid, m.name as mname, m.code, m.ext_attr_11, de.name as dname, de.path, l.name as lname,sum(bugnum) as bugnum, sum(latenum) as latenum, sum(sicknum) as sicknum, sum(absencenum) as absencenum,sum(annualnum) as annualnum, sum(publicnum) as publicnum, sum(funeralnum) as funeralnum,sum(travelnum) as travelnum, sum(maternitynum) as maternitynum, sum(gohomenum) as gohomenum from  org_member m, depcheck d,org_unit de, org_level l where de.type='Department'and m.id = d.userid and m.org_department_id =de.id and m.org_level_id=l.id and m.is_deleted = 0   and m.state = 1 and m.is_enable = 1 and m.status = 1 " + sqlwhere + " group by m.id,m.name,m.code,m.ext_attr_11,de.name,de.path,l.name order by de.name";
				ps = conn.prepareStatement(queryalldepartsql);
				rs = ps.executeQuery();
					
				while (rs.next()) {
					/*员工性别*/
					String sex = rs.getString("ext_attr_11");
					String sexValue = "";
					if (sex.equals("1")) {sexValue = "男";} else if (sex.equals("2")) {sexValue ="女";}
					
					String parentDepartName = "";// 一级部门
					String childDepartName = "";// 二级部门
					
					String tempdepartyname = rs.getString("dname"); // 部门名称
					String depPath = rs.getString("path");
					int len = depPath.toString().length();
					
					// 如果本条数据的path长度为16 ,则说明此部门是二级部门,然后通过二级部门 取到相应的一级部门。
					if (len == 16) {
						for (depCheckIn d : dep) {
							String depname = d.getDepartment();
							String tmppath = d.getPath();
							if (depPath.equals(tmppath)) {
								childDepartName = tempdepartyname;
							} else if (depPath.indexOf(tmppath) >=0 && depPath.length() > tmppath.length()) {
								parentDepartName = depname;
							}
							
							if(!childDepartName.isEmpty() && !parentDepartName.isEmpty()){
								break;
							}
						}
					} else if (len == 12){// 否则就属于一级部门 二级部门为无
						parentDepartName = tempdepartyname;
						childDepartName = "";
						
						for (depCheckIn d : dep) {
							String depname = d.getDepartment();
							String tmppath = d.getPath();
							if (tmppath.indexOf(depPath) >=0 && tmppath.length() > depPath.length()) {
								parentDepartName = depname;
							}
							
							if(!childDepartName.isEmpty() && !parentDepartName.isEmpty()){
								break;
							}
						}
					}
					
					depCheckIn depCheck = new depCheckIn();
					depCheck.setGender(sexValue); // 性别
					depCheck.setName(rs.getString("mname"));// 姓名
					depCheck.setUserid(rs.getString("userid")); // 获取员工id
					depCheck.setUsercode(rs.getString("code")); // 员工编号
					depCheck.setDepartment(parentDepartName);// 部门
					depCheck.setCdepartment(childDepartName);// 二级部门
					depCheck.setPostionlevel(rs.getString("lname"));// 职务级别
					depCheck.setBugNum(Integer.toString(rs.getInt("bugNum")));// 异常次数
					depCheck.setLateNum(Integer.toString(rs.getInt("lateNum")));// 迟到早退次数
					depCheck.setSickNum(Double.toString(rs.getDouble("sicknum")));// 病假
					depCheck.setAbsenceNum(Double.toString(rs.getDouble("absenceNum")));// 事假
					depCheck.setAnnualNum(Double.toString(rs.getDouble("annualNum")));// 年休假
					depCheck.setPublicNum(Double.toString(rs.getDouble("publicNum")));// 公假
					depCheck.setFuneralNum(Double.toString(rs.getDouble("funeralNum")));// 婚丧假
					depCheck.setTravelNum(Double.toString(rs.getDouble("travelNum")));// 探亲假
					depCheck.setMaternityNum(Double.toString(rs.getDouble("maternityNum")));// 产假
					depCheck.setGohomenum(Double.toString(rs.getDouble("gohomenum")));// 探亲假
					alldepCheckList.add(depCheck);
				}
				return alldepCheckList;
			} else if (postcode.equals("02") || postcode.equals("03")) {
				
				List<depCheckIn> dep = new ArrayList<depCheckIn>();
				List<String> sss = new ArrayList<String>();//临时用
				
				// 遍历部门path
				for(String path : orgPathList) {
					// 属于 部门考勤员 该考勤员功能 查询 当前部门下的员工记录 如果 该员工在一级部门 就可以查询
					// 查询部门 并判断是几级部门 两种情况 一级 二级
					String selectdepartsql = "select t.name as departname,length(t.path) as len,t.path as departpath from org_unit t where t.type='Department' and t.path like '" + path.trim() + "%' and t.is_deleted = 0 and t.is_enable = 1 and t.status = 1";
					ps = conn.prepareStatement(selectdepartsql);
					rs = ps.executeQuery();
					while (rs.next()) {
						depCheckIn d = new depCheckIn();
						d.setDepartment(rs.getString("departname"));// 部门名称
						d.setPath(rs.getString("departpath"));// 路径
						dep.add(d);
						sss.add(rs.getString("departpath"));
					}
				}
				
				System.out.println("pathList:" + orgPathList);
				System.out.println("sss:" + sss);
				
				// 返回的结果List
				List<depCheckIn> departchecklist = new ArrayList<depCheckIn>();
				for(String path : orgPathList) {
					System.out.println("进入path循环中");
					String departcheckinsql = "select m.id as userid,m.name as mname,m.code,m.ext_attr_11,de.name as dname,de.path,l.name as lname,sum(bugnum) as bugnum,sum(latenum) as latenum,sum(sicknum) as sicknum,sum(absencenum) as absencenum,sum(annualnum) as annualnum,sum(publicnum) as publicnum,sum(funeralnum) as funeralnum,sum(travelnum) as travelnum,sum(maternitynum) as maternitynum,sum(gohomenum) as gohomenum from org_member m,depcheck d,org_unit de,org_level l where de.type='Department' and m.id = d.userid and m.org_department_id =de.id and m.org_LEVEL_id=l.id and m.is_deleted = 0 and m.state = 1 and m.is_enable = 1 and m.status = 1 and de.path like '" + path + "%' " + sqlwhere + " group by m.id,m.name,m.code,m.ext_attr_11,de.name,de.path,l.name";
					ps = conn.prepareStatement(departcheckinsql);
					rs = ps.executeQuery();
					System.out.println("sql:" + departcheckinsql);
					while (rs.next()) {
						System.out.println("进入内部循环中。。。");
						depCheckIn departOBJ = new depCheckIn();
						departOBJ.setName(rs.getString("mname"));// 员工姓名
						String temppath = rs.getString("path"); // path
						int pathLen = temppath.trim().length(); // path的长度
						
						if (pathLen > 12) {
							System.out.println("当前部门=====path:" + temppath + ";orgname:" + rs.getString("dname"));
							departOBJ.setCdepartment(rs.getString("dname")); // 该员工在二级部门
							int i = 0;
							for(depCheckIn d: dep) {
								String orgName = d.getDepartment();
								String orgPath = d.getPath();
								System.out.println((++i) + "-----" + orgPath);
								System.out.println(i + "-----" + orgName);
								if(orgPath.trim().length() == 12 && temppath.startsWith(orgPath.trim())) {
									departOBJ.setDepartment(orgName); // 一级部门名称
									System.out.println("匹配成功！");
									break;
								}
							}
							System.out.println("结束部门=====path:" + temppath + ";orgname:" + rs.getString("mname"));
						} else if (pathLen == 12){
							departOBJ.setDepartment(rs.getString("dname")); // 一级部门名称
							departOBJ.setCdepartment(""); // 该员工在二级部门
						}

						String sex = rs.getString("ext_attr_11");
						if (sex.equals("1")) {
							departOBJ.setGender("男"); // 性别
						} else if (sex.equals("2")) {
							departOBJ.setGender("女"); // 性别
						}
						departOBJ.setUserid(rs.getString("userid")); // 获取员工id
						departOBJ.setUsercode(rs.getString("code")); // 员工编号
						departOBJ.setPostionlevel(rs.getString("lname"));// 职务级别
						departOBJ.setBugNum(Integer.toString(rs.getInt("bugNum")));// 异常次数
						departOBJ.setLateNum(Integer.toString(rs.getInt("lateNum")));// 迟到早退次数
						departOBJ.setSickNum(Double.toString(rs.getDouble("sicknum")));// 病假
						departOBJ.setAbsenceNum(Double.toString(rs.getDouble("absenceNum")));// 事假
						departOBJ.setAnnualNum(Double.toString(rs.getDouble("annualNum")));// 年休假
						departOBJ.setPublicNum(Double.toString(rs.getDouble("publicNum")));// 公假
						departOBJ.setFuneralNum(Double.toString(rs.getDouble("funeralNum")));// 婚丧假
						departOBJ.setTravelNum(Double.toString(rs.getDouble("travelNum")));// 探亲假
						departOBJ.setMaternityNum(Double.toString(rs.getDouble("maternityNum")));// 产假
						departOBJ.setGohomenum(Double.toString(rs.getDouble("gohomenum")));// 探亲假
						
						departchecklist.add(departOBJ);
					} 
				}
				return departchecklist;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			destroyDBObj(rs, ps, conn);
			super.releaseSession(session);
		}
		return null;

	}

	/**
	 * 查询所有的职务级别
	 * 
	 * @return
	 */
	public List<PostionLevel> selectlevels() {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		User user = getCurrentUser();
		//获取该用户所属单位
		String accountid = Long.toString(user.getAccountId());
		String levelssql = "select l.name as lname from org_level l " 
							+ " where l.org_account_id = '"+accountid+"' "
							+ " and l.is_deleted = 0 and l.is_enable = 1 " 
							+ " and l.status = 1";
		List<PostionLevel> levellist = new ArrayList<PostionLevel>();
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(levelssql);
			rs = ps.executeQuery();
			while (rs.next()) {
				PostionLevel plevel = new PostionLevel();
				plevel.setLevelname(rs.getString("lname"));
				levellist.add(plevel);
			}

			return levellist;
		} catch (SQLException e) {
			e.printStackTrace();

			return null;
		}finally {
			destroyDBObj(rs, ps, conn);
			super.releaseSession(session);
	    }

	}

	/**
	 * 查询部门
	 * 
	 * @return
	 */
	public List<Department> selectDeparts() {
		System.out.println("查询部门=========================");
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		User user = getCurrentUser();
		Long userid = user.getId();
		System.out.println("userid=>" + String.valueOf(userid));
		//获取当前用户所属单位
		String accountid = Long.toString(user.getAccountId());
		System.out.println("accountid=>" + accountid);
		//岗位编号
		String postcode = getpostcode(Long.toString(user.getId()));
		System.out.println("postcode=>" + postcode);
		//岗位id
		String postId = getpostid(postcode);
		System.out.println("postId=>" + postId);
		//部门id
		List<String> orgIdList = postOrgId(Long.toString(user.getId()),postId);
		System.out.println("orgId=>" + orgIdList);
		//部门path
		List<String> pathList = getOrgPath(orgIdList);
		System.out.println("path:" + pathList);
//		// 查询岗位角色
//		String pcode = getpostcode(Long.toString(user.getId()));
//		System.out.println("pcode=>" + pcode);
		List<Department> dmplist = null;
		
		try {
			Session session = super.getSession();
			conn = session.connection();
			if (postcode.equals("01")) {
				System.out.println("查询部门->人力考勤员=========================");
				// 人力考勤员
				// 查询 部门 path
				String dpathlensql = "select t.name as dname,t.id as dmid,t.path from org_unit t"
						+ " where t.is_deleted = 0 and t.type='Department' and t.is_enable = 1 and t.status = 1";

				ps = conn.prepareStatement(dpathlensql);
				rs = ps.executeQuery();
				dmplist = new ArrayList<Department>();
				//System.out.println("sql1:" + dpathlensql);
				while (rs.next()) {
					int pathlen = rs.getString("path").toString().length();
					// 长度是12，表示一级部门。
					// 长度是16，表示二级部门。
					if (pathlen == 12) {
						Department dpmobj = new Department();
						dpmobj.setDmid(rs.getString("dmid"));
						dpmobj.setDmname(rs.getString("dname"));
						dpmobj.setPath(rs.getString("path"));
						dmplist.add(dpmobj);
					}
				}
				return dmplist;
			} else if (postcode.equals("02") || postcode.equals("03")) {
				System.out.println("查询部门->部门考勤员=========================");
				List<Department> dmponelist = new ArrayList<Department>();
				for(String path : pathList) {
					// 部门 考勤员
					// 查询 用用户所在部门
					String deprtoneortwo = "select t.name as departname,t.path as departpath from org_unit t "
							+ " where t.path like '" + path + "%'"
//							+ " and t.org_account_id = '" + accountid + "'"
							+ " and t.is_deleted = 0 and t.type='Department' and t.is_enable = 1  and t.status = 1";
					String departname = "";
					String departpath = "";
					int pathlen = 0;
					ps = conn.prepareStatement(deprtoneortwo);
					rs = ps.executeQuery();
					while (rs.next()) {
						// 获取部门名称
						departname = rs.getString("departname");
						// 获取部门 path
						departpath = rs.getString("departpath");
						// 获取 部门path 长度
						pathlen = rs.getString("departpath").toString().length();
						
						if (pathlen == 12) {
							Department depmone = new Department();
							depmone.setDmname(departname);
							depmone.setPath(departpath);
							dmponelist.add(depmone);
						} 
					}
				}
				
				return dmponelist;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			destroyDBObj(rs, ps, conn);
		}
		return null;
	}

	/**
	 * 查询子部门
	 * 
	 * @return
	 */
	public List<Department> selectchilddepart() {
		System.out.println("查询子部门=========================");
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		User user = getCurrentUser();
		// 获取当前用户所属单位
		String accountid = Long.toString(user.getAccountId());
		System.out.println("accountid:" + accountid);
		// 岗位编号
		String postcode = getpostcode(Long.toString(user.getId()));
		System.out.println("postcode:" + postcode);
		// 岗位id
		String postId = getpostid(postcode);
		System.out.println("postId:" + postId);
		// 部门id
		List<String> orgIdList = postOrgId(Long.toString(user.getId()),postId);
		System.out.println("orgId:" + orgIdList);
		
		List<String> pathList = getOrgPath(orgIdList);
		System.out.println("path:" + pathList);
		
		Session session = super.getSession();
		conn = session.connection();
		try {
			if (postcode.equals("01")) {
				// 人力考勤员 显示全部子部门
				String departssql = "select t.name as dname,t.id as dmid,t.path from org_unit t "
						+ " where t.is_deleted = 0 and t.is_enable = 1 and t.type='Department'";
				//System.out.println("sql1:" + departssql);
				List<Department> dmplist = new ArrayList<Department>();
				ps = conn.prepareStatement(departssql);
				rs = ps.executeQuery();
				while (rs.next()) {
					// 长度12表示一级部门，16表示二级部门
					int pathlen = rs.getString("path").toString().length();
					if (pathlen == 16) {
						Department dpmobj = new Department();
						dpmobj.setDmid("dmid");
						dpmobj.setDmname(rs.getString("dname"));
						dpmobj.setPath(rs.getString("path"));
						dmplist.add(dpmobj);
					}
				}

				return dmplist;
			} else if (postcode.equals("02") || postcode.equals("03")) {
				List<Department> dmponechildlist = new ArrayList<Department>();
				for(String path : pathList) {
					// 为部门考勤员
					// 查询 用用户所在部门
					String deprtoneortwo = "select t.name as departname,t.path as departpath from org_unit t "
							+ " where t.is_deleted = 0 and t.is_enable = 1 and t.type='Department' "
							+ " and t.status = 1 and t.path like '" + path + "%'";
					//System.out.println("sql2:" + deprtoneortwo);
					int pathlen = 0;
					ps = conn.prepareStatement(deprtoneortwo);
					rs = ps.executeQuery();
					while (rs.next()) {
						// 获取部门 path
						String departpath = rs.getString("departpath");
						// 获取 部门path 长度(12表示一级部门，16表示二级部门)
						pathlen = departpath.length();
						if (pathlen == 16) {//二级部门
							// 二级部门只显示二级部门
							Department dmpchild = new Department();
							dmpchild.setDmname(rs.getString("departname"));
							dmpchild.setPath(departpath);
							dmponechildlist.add(dmpchild);
						}
					}
				}
				return dmponechildlist;
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			destroyDBObj(rs, ps, conn);
			super.releaseSession(session);
		}
		return null;
	}

	/**
	 * 查询迟到或者早退的详细信息
	 * 
	 * @param userid
	 * @return
	 */
	public List<ManagerDetail> getLateDetail(String startdate,String enddate,String userid) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		String sqlwhe="";
		if(null==startdate){}
		else if("".equals(startdate)){}
		else{
			sqlwhe += " and to_char(t.checkdate,'yyyy-MM-dd') >='" + startdate + "'";
		}
		if(null==enddate){}
		else if("".equals(enddate)){}
		else{
			sqlwhe += " and to_char(t.checkdate,'yyyy-MM-dd') <='" + enddate + "'";
		}
		
		String detaillatesql = "select to_char(t.amchecktime, 'HH24:MI:SS') as amchecktime, to_char(t.pmchecktime, 'HH24:MI:SS') as pmchecktime, t.week, t.checkdate  from initcheckin t where t.lateflag =1 and t.userid='" + userid +"'" + sqlwhe + " order by t.checkdate desc";

		List<ManagerDetail> latedetaillist = new ArrayList<ManagerDetail>();
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(detaillatesql);
			rs = ps.executeQuery();
			
			while (rs.next()) {
				String amchecktime = rs.getString("amchecktime");
				String pmchecktime = rs.getString("pmchecktime");
				java.sql.Date checkdate = rs.getDate("checkdate");
				java.util.Date checkd = new Date(checkdate.getTime());
				String week = rs.getString("week");
			
				ManagerDetail mDetail = new ManagerDetail();
				if(null==amchecktime){
					mDetail.setAmtime("");
				}else{						
					mDetail.setAmtime(amchecktime);
				}
				if(null==pmchecktime){
					mDetail.setPmtime("");
				}else{						
					mDetail.setPmtime(pmchecktime);
				}
				mDetail.setCurrentdate(sdf.format(checkd));
				mDetail.setCurrentweek(CheckUtils.getWeekNameOfWeekCode(week));
				latedetaillist.add(mDetail);
			}
			return latedetaillist;
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(rs, ps, conn);
		    super.releaseSession(session);
	    }
		return null;
	}

	
	/**
	 * 判断是否迟到早退
	 * @param amtime 上午时间
	 * @param pmtime 下午时间
	 * @param checkdate 异常打卡日期
	 * @return true 迟到或者早退
	 *         false 没有迟到早退
	 */
	public boolean getleavetypenum(Timestamp amtime,Timestamp pmtime,Date checkdate){
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		// 上午打卡时间（开始）上午打卡时间（结束）下午打卡时间（开始）下午打卡时间（结束）
		String sql = " select t.amstarttime, t.amendtime, t.pmstarttime, t.pmendtime from checkininstall t"; 
		String amstarttime = "";//上午打卡有效开始
		String amendtime = "";//上午打卡有效结束
		String pmstarttime = "";//下午打卡有效开始
		String pmendtime = "";//下午打卡有效结束
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
				String pmend = debugdate + " " + pmendtime;// 下午有效开始
				Date amstartd = sdf1.parse(amstart); // 上午有效开始		
				Date amendd = sdf1.parse(amend); // 上午有效结束		
				Date pmstartd = sdf1.parse(pmstart);// 下午有效开始
				Date pmendd = sdf1.parse(pmend);// 下午有效结束
				//判断上午是否迟到
				if(null==amtime){//
					// 判断下午是否早退
					if (null == pmtime) {
						return false;
					} else {
						Date ddp = new Date(pmtime.getTime());
						if (ddp.before(pmendd) && ddp.compareTo(pmstartd) >= 0) {
							return true;
						} else {
							return false;
						}
					}
				}else {
					Date dd = new Date(amtime.getTime());
					if(dd.after(amstartd) && dd.compareTo(amendd)<=0){
						return true;
					}else{
						//判断下午是否早退
						if(null==pmtime){
							return false;
						}else {
							Date ddp = new Date(pmtime.getTime()); 
							if(ddp.before(pmendd) && ddp.compareTo(pmstartd)>=0){
								return true;
							}else{
								return false;
							}
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(rs, ps, conn);
		    super.releaseSession(session);
	    }
		return false;
	}
	
	
	/**
	 * 查询异常的详细信息列表
	 * 
	 * @param userid
	 * @return
	 */
	public List<ManagerDetail> getbugdetails(String startdate,String enddate,String userid) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		String sqlwhe="";
		if(null==startdate){}
		else if("".equals(startdate)){}
		else{
			sqlwhe += " and to_char(t.checkdate,'yyyy-MM-dd') >='" + startdate + "'";
		}
		if(null==enddate){}
		else if("".equals(enddate)){}
		else{
			sqlwhe += " and to_char(t.checkdate,'yyyy-MM-dd') <='" + enddate + "'";
		}
		
		String bugdetailssql = "select t.week,to_char(t.amchecktime, 'HH24:MI:SS') as atime, to_char(t.pmchecktime, 'HH24:MI:SS') as ptime,to_char(T.CHECKDATE,'yyyy-MM-dd') as checkdate,T.CHECKDATE as cdate from initcheckin t where  t.userid='"
				+ userid + "' and t.flag='1'" + sqlwhe + " order by t.checkdate desc";
		List<ManagerDetail> bugdetaillist = new ArrayList<ManagerDetail>();
		Session session = super.getSession();
		conn = session.connection();
		try {
			ps = conn.prepareStatement(bugdetailssql);
			rs = ps.executeQuery();
			while (rs.next()) {
				ManagerDetail mDetail = new ManagerDetail();
				mDetail.setAmtime(rs.getString("atime"));
				mDetail.setPmtime(rs.getString("ptime"));
				mDetail.setCurrentdate(rs.getString("CHECKDATE"));
				mDetail.setCurrentweek(CheckUtils.getWeekNameOfWeekCode(rs.getString("week")));
				bugdetaillist.add(mDetail);
			}
			return bugdetaillist;
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			destroyDBObj(rs, ps, conn);
			super.releaseSession(session);
	    }
		return null;
	}

	
	/**
	 * 查询相对应的请假明细
	 * 
	 * @param userid
	 * @param type
	 * @return
	 */
	public List<ManagerDetail> getleavedetails(String startdate,
			String enddate, String userid, String type) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		String leavetype = "";
		if (type.equals("1")) {
			leavetype = "1";
		} else if (type.equals("2")) {
			leavetype = "2";
		} else if (type.equals("3")) {
			leavetype = "3";
		} else if (type.equals("4")) {
			leavetype = "4";
		} else if (type.equals("5")) {
			leavetype = "5";
		} else if (type.equals("6")) {
			leavetype = "6";
		} else if (type.equals("7")) {
			leavetype = "7";
		} else if (type.equals("10")) {
			leavetype = "10";
		}
		String sqlwhere = "";
		if (null == startdate) {

		} else if ("".equals(startdate)) {

		} else {
			sqlwhere = " and to_char(checkdate,'yyyy-MM-dd') >= '" + startdate
					+ "'";
		}
		if (null == enddate) {

		} else if ("".equals(enddate)) {

		} else {
			sqlwhere += " and to_char(checkdate,'yyyy-MM-dd') <= '" + enddate
					+ "'";
		}

		String leavedetailssql = "select to_char(t.amchecktime, 'HH24:MI:SS') as atime, "
				+ "to_char(t.pmchecktime, 'HH24:MI:SS') as ptime,"
				+ "to_char(t.checkdate,'yyyy-MM-dd') as checkdate,"
				+ "t.checkdate as cdate,t.week,j.field0008,k.field0006 "
				+ "  from initcheckin t left join formmain_0201 j on t.userid = to_char(j.start_member_id) and to_char(t.checkdate,'yyyy-MM-dd')=to_char(j.field0004,'yyyy-MM-dd') "//and t.leavetype=j.field0007 " 
				+ " left join formmain_0203 k on t.userid = to_char(k.start_member_id) and t.checkdate >= k.field0003 and t.checkdate <= k.field0004 "//and t.leavetype=k.field0005 "
				+ " where t.userid='" + userid + "'"
				+ " and t.leavetype ='" + leavetype + "'" 
				+ sqlwhere + " order by t.checkdate desc";
		List<ManagerDetail> leavedetaillist = new ArrayList<ManagerDetail>();
		Session session = super.getSession();
		conn = session.connection();
		try 
		{
			ps = conn.prepareStatement(leavedetailssql);
			rs = ps.executeQuery();
			while (rs.next()) 
			{
				ManagerDetail mDetail = new ManagerDetail();
				mDetail.setAmtime(rs.getString("atime"));
				mDetail.setPmtime(rs.getString("ptime"));
				mDetail.setCurrentdate(rs.getString("CHECKDATE"));
				mDetail.setCurrentweek(CheckUtils.getWeekNameOfWeekCode(rs.getString("week")));
				String field0008 = rs.getString("field0008");
				String field0006 = rs.getString("field0006");
				String message = "";
				if(null==field0008 || "".equals(field0008))
				{
				}
				else
				{
					message=field0008;
				}
				if(null==field0006 || "".equals(field0006))
				{
				}
				else
				{
					message=field0006;
				}
				mDetail.setMessage(message);
				leavedetaillist.add(mDetail);
			}
			return leavedetaillist;
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
		return null;
	}

	
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
			String dienum, String gohomenum,OutputStream os) {
		HSSFWorkbook book = new HSSFWorkbook(); // 创建文档

		HSSFSheet sheet = book.createSheet(); // 创建工作薄
		if (department.equals("1")) {
			department = "部门";
		}
		if (cdepartment.equals("2")) {
			cdepartment = "二级部门";
		}
		if (name.equals("3")) {
			name = "姓名";
		}
		if (gender.equals("4")) {
			gender = "性别";
		}
		if (code.equals("5")) {
			code = "员工编号";
		}
		if (leavel.equals("6")) {
			leavel = "职务级别";
		}
		if (bugnum.equals("7")) {
			bugnum = "异常次数";
		}
		if (latenum.equals("8")) {
			latenum = "迟到早退次数";
		}
		if (illnum.equals("9")) {
			illnum = "病假";
		}
		if (thingnum.equals("10")) {
			thingnum = "事假";
		}
		if (yearnum.equals("11")) {
			yearnum = "年休假";
		}
		if (other.equals("12")) {
			other = "其他";
		}
		if (marry.equals("13")) {
			marry = "婚假";
		}
		if (dienum.equals("14")) {
			dienum = "丧假";
		}
//		if (babynum.equals("15")) {
//			babynum = "产假";
//		}
		if (gohomenum.equals("16")) {
			gohomenum = "探亲假";
		}
		// 填写列名
		String layarr[] = { department, cdepartment, name, gender, code,
				leavel, bugnum, latenum, illnum, thingnum, yearnum, 
				marry, dienum,gohomenum,other};

		HSSFRow onerow = sheet.createRow(0);
		for (int i = 0; i < layarr.length; i++) {
			HSSFCell cell = onerow.createCell(i); // 创建单元格

			cell.setCellValue(layarr[i]); // 在单元格里填充内容
		}
		for (int j = 1; j <= datalist.size(); j++) {
			HSSFRow row = sheet.createRow(j);

			int temp = j - 1;
			int ctemp = 0;
			depCheckIn tempdep = datalist.get(temp);
			HSSFCell lcell1 = row.createCell(ctemp); // 创建单元格
			lcell1.setCellValue(tempdep.getDepartment()); // 在单元格里填充内容 部门
			ctemp = ctemp + 1;
			HSSFCell lcell2 = row.createCell(ctemp); // 创建单元格
			lcell2.setCellValue(tempdep.getCdepartment()); // 在单元格里填充内容 二级部门
			ctemp = ctemp + 1;
			HSSFCell lcell3 = row.createCell(ctemp); // 创建单元格
			lcell3.setCellValue(tempdep.getName()); // 在单元格里填充内容 姓名
			ctemp = ctemp + 1;
			HSSFCell lcell4 = row.createCell(ctemp); // 创建单元格
			lcell4.setCellValue(tempdep.getGender()); // 在单元格里填充内容 性别
			ctemp = ctemp + 1;
			HSSFCell lcell5 = row.createCell(ctemp); // 创建单元格
			lcell5.setCellValue(tempdep.getUsercode()); // 在单元格里填充内容 员工编号
			ctemp = ctemp + 1;
			HSSFCell lcell6 = row.createCell(ctemp); // 创建单元格
			lcell6.setCellValue(tempdep.getPostionlevel()); // 在单元格里填充内容 职务级别
			ctemp = ctemp + 1;
			HSSFCell lcell7 = row.createCell(ctemp); // 创建单元格
			lcell7.setCellValue(tempdep.getBugNum()); // 在单元格里填充内容 异常次数
			ctemp = ctemp + 1;
			HSSFCell lcell8 = row.createCell(ctemp); // 创建单元格
			lcell8.setCellValue(tempdep.getLateNum()); // 在单元格里填充内容 迟到次数
			ctemp = ctemp + 1;
			HSSFCell lcell9 = row.createCell(ctemp); // 创建单元格
			lcell9.setCellValue(tempdep.getSickNum()); // 在单元格里填充内容 病假
			ctemp = ctemp + 1;
			HSSFCell lcell10 = row.createCell(ctemp); // 创建单元格
			lcell10.setCellValue(tempdep.getAbsenceNum()); // 在单元格里填充内容 事假
			ctemp = ctemp + 1;
			HSSFCell lcell11 = row.createCell(ctemp); // 创建单元格
			lcell11.setCellValue(tempdep.getAnnualNum()); // 在单元格里填充内容 年休假
			ctemp = ctemp + 1;
			HSSFCell lcell12 = row.createCell(ctemp); // 创建单元格
			lcell12.setCellValue(tempdep.getFuneralNum()); // 在单元格里填充内容 婚假
			
			ctemp = ctemp + 1;
			HSSFCell lcell13 = row.createCell(ctemp); // 创建单元格
			lcell13.setCellValue(tempdep.getMaternityNum()); // 在单元格里填充内容 产假
			
			ctemp = ctemp + 1;
			HSSFCell lcell14 = row.createCell(ctemp); // 创建单元格
			lcell14.setCellValue(tempdep.getTravelNum()); // 在单元格里填充内容 丧假
//			ctemp = ctemp + 1;
//			HSSFCell lcell15 = row.createCell(ctemp); // 创建单元格
//			lcell15.setCellValue(tempdep.getGohomenum()); // 在单元格里填充内容 探亲假
			
			ctemp = ctemp + 1;
			HSSFCell lcell16 = row.createCell(ctemp); // 创建单元格
			lcell16.setCellValue(tempdep.getPublicNum()); // 在单元格里填充内容 其他
		
		}

		try {
			book.write(os);// 使用输出流将文件生成到指定位置
			os.flush();
			os.close();
		} catch (FileNotFoundException e) {
		} catch (IOException e) {
		}
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
