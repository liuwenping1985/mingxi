package com.seeyon.apps.checkin.dao;

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
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintStream;
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
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.hibernate.Session;

public class CheckInInstallDaoImpl_OLD extends BaseHibernateDao<CheckInInstall>
  implements CheckInInstallDao_OLD
{
  private String filenameTemp;

  public void checkYesterdayCheckin()
  {
    System.out.println("checkYesterdayCheckin start============================" + new java.util.Date());
    SimpleDateFormat sdfd = new SimpleDateFormat("yyyy-MM-dd");

    List<User> userlist = selectAllUsers();
    String userid = "";
    String accountId = "";
    String orgId = "";

    List<CheckInInstall> rsset = selectffectivect();
    String processstarttime = "";
    String approvaltime = "";

    List<User> loginlist = getLoginno();

    boolean yesterdayworkneed = false;

    String yesterday = yesterday();
    String year = yesterday.substring(0, 4);
    String month = yesterday.substring(5, 7);
    String week = "";
    try
    {
      week = CheckUtils.getWeekCodeOfDate(sdfd.parse(yesterday));
    } catch (ParseException e1) {
      e1.printStackTrace();
    }

    if (("0".equals(week)) || ("6".equals(week)))
      yesterdayworkneed = false;
    else {
      yesterdayworkneed = true;
    }

    List<WorkDaySet> rsspecialday = getspecialday(toDate1(yesterday));

    List<WorkDaySet>  rscurrency = getcurrency(yesterday);

    List<InitCheckIn> personcheck = selectinitcheckin(yesterday);

    Timestamp amtime = null;
    Timestamp pmtime = null;
    String flag = "";
    String lateflag = "";
    java.util.Date yesterdayCheckDate = null;

    List<User>  noCheckinUsers = selectnockusers();

    List<Department> noCheckinDepartments = selectnockdepartment();

    List depcheck = new ArrayList();

    List checkinins = new ArrayList();

    List initListU = new ArrayList();

    List initListI = new ArrayList();
    try
    {
      if (rsset != null)
        for (CheckInInstall check : rsset) {
          processstarttime = check.getProcessStartTime();
          approvaltime = check.getApprovalTime();
        }
      else {
        return;
      }

      label1442: for (User user : userlist)
      {
        if (("0".equals(week)) || ("6".equals(week)))
          yesterdayworkneed = false;
        else {
          yesterdayworkneed = true;
        }

        boolean needCheckin = true;

        userid = user.getUserId();

        accountId = user.getAccountId();
        orgId = user.getOrgId();

        for (User u : loginlist) {
          String userid1 = u.getUserId();

          if ((userid == null) || (userid1 == null)) {
            break;
          }
          if (userid.equals(userid1))
          {
            break;
          }
        }
        for (WorkDaySet wds : rscurrency) {
          String org_account_id1 = wds.getOrg_account_id();
          String week_day_name = wds.getWeek_num();
          String is_work = wds.getIs_work();
          String year1 = wds.getYear();
          if ((year.equals(year1)) && (accountId.equals(org_account_id1)) && (week.equals(week_day_name))) {
            if ("0".equals(is_work)) {
              yesterdayworkneed = false;
              break;
            }
            yesterdayworkneed = true;
            break;
          }
        }
        String org_account_id;
        for (WorkDaySet wds : rsspecialday) {
          org_account_id = wds.getOrg_account_id();
          String date_num = wds.getDate_num();
          String is_rest = wds.getIs_rest();

          String year1 = wds.getYear();
          String month1 = wds.getMonth();
          if ((accountId.equals(org_account_id)) && 
            (date_num.equals(toDate1(yesterday))) && 
            (year.equals(year1)) && 
            (month.equals(toMonth(month1))))
          {
            if (is_rest.equals("0")) {
              yesterdayworkneed = true;
              break;
            }if (is_rest.equals("1")) {
              yesterdayworkneed = false;
              break label1442;
            }
            yesterdayworkneed = false;
            break label1442;
          }

        }

        if (yesterdayworkneed)
        {
          for (User u : noCheckinUsers) {
            if ((u.getUserId() != null) && (userid != null))
            {
              if (u.getUserId().equals(userid)) {
                needCheckin = false;
                break;
              }
            }
          }
          for (Department de : noCheckinDepartments) {
            if (de.getDmid().trim().equals(orgId.trim())) {
              needCheckin = false;
              break;
            }

          }

          if (needCheckin)
          {
            boolean yescheck = false;

            for (InitCheckIn init : personcheck) {
              String uid = init.getUserId();
              amtime = init.getCheckStartTime();
              pmtime = init.getCheckEndTime();
              flag = init.getFlag();
              week = init.getWeek();
              yesterdayCheckDate = init.getCheckdate();
              lateflag = init.getLateflag();
              if ((uid != null) && (userid != null))
              {
                if (uid.equals(userid)) {
                  yescheck = true;
                  break;
                }
              }
            }

            if (yescheck)
            {
              if ("1".equals(flag))
              {
                int lateNum = getlatenum(amtime, pmtime, yesterdayCheckDate);

                lateflag = "0";
                if (lateNum > 0) {
                  lateflag = "1";
                }

                double leavenum = getleavetypenum(amtime, pmtime, yesterdayCheckDate);

                InitCheckIn initb = new InitCheckIn();
                initb.setUserId(userid);
                initb.setCheckdate(yesterdayCheckDate);
                initb.setDebugday(leavenum);
                initb.setLateflag(lateflag);
                initb.setLateNum(lateNum);
                initListU.add(initb);

                if (!existsDepCheck(userid, yesterday)) {
                  depCheckIn dep = new depCheckIn();
                  dep.setUserid(userid);
                  dep.setCheckDate(yesterdayCheckDate);
                  dep.setLateNum(Integer.toString(lateNum));
                  depcheck.add(dep);
                }

                if (!existsCheckBug(userid, yesterday)) {
                  CheckInInstall inins = new CheckInInstall();
                  inins.setUserId(userid);
                  inins.setCheckStartTime(amtime);
                  inins.setCheckEndTime(pmtime);
                  inins.setAppFlg("0");
                  inins.setProcessStartTime(processstarttime);
                  inins.setApprovalTime(approvaltime);
                  inins.setCheckDate(yesterdayCheckDate);
                  checkinins.add(inins);
                }
              }
            }
            else
            {
              yesterdayCheckDate = sdfd.parse(yesterday);
              amtime = null;
              pmtime = null;

              List checkList = selectinitcheckin(userid, yesterday);
              Iterator it = checkList.iterator();
              if (!it.hasNext()) {
                InitCheckIn initb = new InitCheckIn();
                initb.setCheckStartTime(amtime);
                initb.setCheckEndTime(pmtime);
                initb.setFlag("1");
                initb.setUserId(userid);
                initb.setLeaveType("");
                initb.setWeek(week);
                initb.setCheckdate(yesterdayCheckDate);
                initb.setDebugday(1.0D);
                initListI.add(initb);
              }

              if (!existsDepCheck(userid, yesterday)) {
                depCheckIn dep = new depCheckIn();
                dep.setUserid(userid);
                dep.setCheckDate(yesterdayCheckDate);
                dep.setLateNum("0");
                depcheck.add(dep);
              }

              if (!existsCheckBug(userid, yesterday)) {
                CheckInInstall inins = new CheckInInstall();
                inins.setUserId(userid);
                inins.setCheckStartTime(amtime);
                inins.setCheckEndTime(pmtime);
                inins.setAppFlg("0");
                inins.setProcessStartTime(processstarttime);
                inins.setApprovalTime(approvaltime);
                inins.setCheckDate(yesterdayCheckDate);
                checkinins.add(inins);
              }
            }
          }
        }

      }

      insertcheckin(initListI);

      updateinitcheckin(initListU);

      insertdepcheck(depcheck);

      insertde(checkinins);
    }
    catch (Exception e) {
      e.printStackTrace();
    }

    System.out.println("checkYesterdayCheckin end============================" + new java.util.Date());
  }

  public void startUpForm()
  {
    System.out.println("startUpForm start============================" + new java.util.Date());
    String[] usermessage = new String[7];
    SimpleDateFormat sdft = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    SimpleDateFormat sdfd = new SimpleDateFormat("yyyy-MM-dd");

    List lis = selectabnormal("");
    Iterator debugrs = lis.iterator();

    Map userMap = getLoginNameMap();

    boolean startflag = false;
    try
    {
      while (debugrs.hasNext())
      {
        CheckInInstall checkb = (CheckInInstall)debugrs.next();

        String orgname = checkb.getOrgName();
        usermessage[2] = orgname;
        String userid = checkb.getUserId();

        java.util.Date checkdate = checkb.getCheckDate();
        String strckdate = sdfd.format(checkdate);
        usermessage[3] = strckdate;

        boolean ret = isStartUp(userid, strckdate);
        if (ret) {
          System.out.println("cccc============================");

          deletecheckabnormal(userid, strckdate);
        }
        else
        {
          String loginCode = (String)userMap.get(userid);
          System.out.println(loginCode);

          usermessage[6] = loginCode;

          String username = checkb.getUserName();
          usermessage[0] = username;

          Timestamp errordate = checkb.getCreateTime();

          String usercode = checkb.getUserCode();
          usermessage[1] = usercode;

          Timestamp amchecktime = checkb.getCheckStartTime();
          if (amchecktime == null)
            usermessage[4] = "";
          else if ("".equals(amchecktime))
            usermessage[4] = "";
          else {
            usermessage[4] = sdft.format(amchecktime);
          }

          Timestamp pmchecktime = checkb.getCheckEndTime();
          if (pmchecktime == null)
            usermessage[5] = "";
          else {
            usermessage[5] = sdft.format(pmchecktime);
          }

          String strstartdays = checkb.getProcessStartTime();
          int startdays = 0;
          if ((strstartdays != null) && 
            (!"".equals(strstartdays)))
          {
            startdays = Integer.parseInt(strstartdays);
          }

          java.util.Date nowdate = new java.util.Date();
          if (nowdate.getTime() - errordate.getTime() > startdays * 24 * 60 * 60 * 1000L) {
            System.out.println("ddd============================");
            startflag = true;
          } else {
            System.out.println("eee============================");
            startflag = false;
          }

          System.out.println("需要发起异常的信息：" + Arrays.asList(usermessage));

          if (startflag)
          {
            boolean bstartup = lauchForm(usermessage);
            System.out.println("已经发起异常的信息：" + Arrays.asList(usermessage));
            if (bstartup)
            {
              updatecheckabnormal(userid, strckdate);

              updatedepcheck(userid, checkdate);
            }
          }
        }
      }
    }
    catch (Exception e) {
      e.printStackTrace();
    }

    System.out.println("startUpForm end============================" + new java.util.Date());
  }

  public boolean checkvalid(String userid, String amtime, String pmtime)
  {
    PreparedStatement ps = null;
    ResultSet rs = null;

    String sql = "select t.amstarttime,t.amendtime,t.pmstarttime,t.pmendtime from checkininstall t ";

    Session session = super.getSession();
    Connection conn = session.connection();
    try {
      ps = conn.prepareStatement(sql);
      rs = ps.executeQuery();

      SimpleDateFormat sdft = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
      SimpleDateFormat sdfd = new SimpleDateFormat("yyyy-MM-dd");

      java.util.Date date = new java.util.Date();
      String nowdate = sdfd.format(date);

      if (rs.next()) {
        String amstarttime = nowdate + " " + rs.getString("amstarttime").toString();
        String pmendtime = nowdate + " " + rs.getString("pmendtime").toString();

        if (amtime == null);
        while (pmtime == null) {
          return false;
        }

        java.util.Date amdat = sdft.parse(amtime);
        java.util.Date pmdat = sdft.parse(pmtime);

        java.util.Date amstartdat = sdft.parse(amstarttime);
        java.util.Date pmenddat = sdft.parse(pmendtime);

        if ((amdat.before(amstartdat)) && (pmdat.after(pmenddat))) {
          return true;
        }
        return false;
      }

      return false;
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }

    return false;
  }

  public int updatedepcheck(String approval, String userid, String checkdate, String leavetype, double debugnum)
  {
    PreparedStatement ps = null;
    ResultSet rs = null;

    int rsnum = 0;

    Session session = super.getSession();
    Connection conn = session.connection();
    try {
      String sql = "";
      if (leavetype.equals("1")) {
        if ("0".equals(approval)) {
          sql = " update depcheck set sicknum = ?,bugnum = 0,latenum = 0,isfinish= 2 where userid  ='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";
          ps = conn.prepareStatement(sql);
          ps.setDouble(1, debugnum);
        } else if ("1".equals(approval)) {
          sql = " update depcheck set isfinish=3 where userid  ='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";
          ps = conn.prepareStatement(sql);
        }
      } else if (leavetype.equals("2")) {
        if ("0".equals(approval)) {
          sql = " update depcheck set absencenum = ?,bugnum = 0,latenum = 0,isfinish= 2 where userid  ='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";
          ps = conn.prepareStatement(sql);
          ps.setDouble(1, debugnum);
        } else if ("1".equals(approval)) {
          sql = " update depcheck set isfinish=3 where userid  ='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";
          ps = conn.prepareStatement(sql);
        }
      } else if (leavetype.equals("3")) {
        if ("0".equals(approval)) {
          sql = " update depcheck set annualnum = ?,bugnum = 0,latenum = 0,isfinish= 2 where userid  ='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";
          ps = conn.prepareStatement(sql);
          ps.setDouble(1, debugnum);
        } else if ("1".equals(approval)) {
          sql = " update depcheck set isfinish=3 where userid  ='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";
          ps = conn.prepareStatement(sql);
        }
      } else if (leavetype.equals("4")) {
        if ("0".equals(approval)) {
          sql = " update depcheck set funeralnum = ?,bugnum = 0,latenum = 0,isfinish= 2 where userid  ='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";
          ps = conn.prepareStatement(sql);
          ps.setDouble(1, debugnum);
        } else if ("1".equals(approval)) {
          sql = " update depcheck set isfinish=3 where userid  ='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";
          ps = conn.prepareStatement(sql);
        }
      } else if (leavetype.equals("5")) {
        if ("0".equals(approval)) {
          sql = " update depcheck set travelnum = ?,bugnum = 0,latenum = 0,isfinish= 2 where userid  ='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";
          ps = conn.prepareStatement(sql);
          ps.setDouble(1, debugnum);
        } else if ("1".equals(approval)) {
          sql = " update depcheck set isfinish=3 where userid  ='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";
          ps = conn.prepareStatement(sql);
        }
      } else if (leavetype.equals("6")) {
        if ("0".equals(approval)) {
          sql = " update depcheck set maternitynum = ?,bugnum = 0,latenum = 0,isfinish= 2  where userid  ='" + userid + "' and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";
          ps = conn.prepareStatement(sql);
          ps.setDouble(1, debugnum);
        } else if ("1".equals(approval)) {
          sql = " update depcheck     set isfinish=3   where userid  ='" + 
            userid + "' " + 
            "    and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";
          ps = conn.prepareStatement(sql);
        }
      } else if (leavetype.equals("7")) {
        if ("0".equals(approval)) {
          sql = " update depcheck     set publicnum = ?,\t\t   bugnum = 0,        latenum = 0,        isfinish= 2   where userid  ='" + 
            userid + "'" + 
            "    and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";
          ps = conn.prepareStatement(sql);
          ps.setDouble(1, debugnum);
        } else if ("1".equals(approval)) {
          sql = " update depcheck     set isfinish=3   where userid  ='" + 
            userid + "' " + 
            "    and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";
          ps = conn.prepareStatement(sql);
        }
      } else if (leavetype.equals("10")) {
        if ("0".equals(approval)) {
          sql = " update depcheck     set gohomenum = ?,\t\t   bugnum = 0,        latenum = 0,        isfinish= 2   where userid  ='" + 
            userid + "'" + 
            "    and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";
          ps = conn.prepareStatement(sql);
          ps.setDouble(1, debugnum);
        } else if ("1".equals(approval)) {
          sql = " update depcheck     set isfinish=3   where userid  ='" + 
            userid + "' " + 
            "    and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";
          ps = conn.prepareStatement(sql);
        }
      }

      rsnum = ps.executeUpdate();
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }

    return rsnum;
  }

  public int updatedepcheck(String userid, java.util.Date checkdate)
  {
    Session session = super.getSession();
    Connection conn = session.connection();
    PreparedStatement ps = null;
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String sql = "update depcheck    set isfinish = '1'  where userid='" + 
      userid + "' " + 
      "   and to_char(checkdate,'yyyy-MM-dd')='" + sdf.format(checkdate) + "'";
    int rsnum = 0;
    try {
      ps = conn.prepareStatement(sql);
      rsnum = ps.executeUpdate();
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      destroyDBObj(null, ps, conn);
      super.releaseSession(session);
    }
    return rsnum;
  }

  public int updatecheckabnormal(String userid, String checkdate)
  {
    Connection conn = null;
    PreparedStatement ps = null;
    String sql = "update checkabnormal  set flag = 1 where userid ='" + 
      userid + "'" + 
      " and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";
    int rsnum = 0;
    Session session = super.getSession();
    conn = session.connection();
    try {
      ps = conn.prepareStatement(sql);
      rsnum = ps.executeUpdate();
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      destroyDBObj(null, ps, conn);
      super.releaseSession(session);
    }
    return rsnum;
  }

  public int deletecheckabnormal(String userid, String checkdate)
  {
    Connection conn = null;
    PreparedStatement ps = null;

    String sql = "delete from checkabnormal  where userid ='" + userid + "'" + 
      " and to_char(checkdate,'yyyy-mm-dd')='" + checkdate + "'";

    System.out.println(sql);
    int rsnum = 0;
    Session session = super.getSession();
    conn = session.connection();
    try {
      ps = conn.prepareStatement(sql);
      rsnum = ps.executeUpdate();
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      destroyDBObj(null, ps, conn);
      super.releaseSession(session);
    }

    return rsnum;
  }

  public void insertdepcheck(List<depCheckIn> depcheck)
  {
    PreparedStatement ps = null;
    Session session = super.getSession();
    Connection conn = session.connection();
    try {
      String sql = "insert into depcheck (id,userid,bugnum,latenum,sicknum,absencenum,annualnum,publicnum,funeralnum,travelnum,maternitynum,checkdate,isfinish,gohomenum) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
      ps = conn.prepareStatement(sql.toString());
      for (depCheckIn dep : depcheck) {
        String userid = dep.getUserid();
        java.util.Date date = dep.getCheckDate();
        int latenum = Integer.parseInt(dep.getLateNum());
        ps.setString(1, UUID.randomUUID().toString());
        ps.setString(2, userid);
        ps.setInt(3, 1);
        ps.setInt(4, latenum);
        ps.setDouble(5, 0.0D);
        ps.setDouble(6, 0.0D);
        ps.setDouble(7, 0.0D);
        ps.setDouble(8, 0.0D);
        ps.setDouble(9, 0.0D);
        ps.setDouble(10, 0.0D);
        ps.setDouble(11, 0.0D);
        java.sql.Date ud = new java.sql.Date(date.getTime());
        ps.setDate(12, ud);
        ps.setString(13, "0");
        ps.setDouble(14, 0.0D);
        ps.executeUpdate();
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      destroyDBObj(null, ps, conn);
      super.releaseSession(session);
    }
  }

  public int insertdepcheck(String userid, java.util.Date date, String approve, String leavetype, double debugnum)
  {
    Connection conn = null;
    PreparedStatement ps = null;
    double debugnum1 = 0.0D;
    double debugnum2 = 0.0D;
    double debugnum3 = 0.0D;
    double debugnum4 = 0.0D;
    double debugnum5 = 0.0D;
    double debugnum6 = 0.0D;
    double debugnum7 = 0.0D;
    double debugnum8 = 0.0D;
    if (leavetype.equals("1"))
      debugnum1 = debugnum;
    else if (leavetype.equals("2"))
      debugnum2 = debugnum;
    else if (leavetype.equals("3"))
      debugnum3 = debugnum;
    else if (leavetype.equals("4"))
      debugnum4 = debugnum;
    else if (leavetype.equals("5"))
      debugnum5 = debugnum;
    else if (leavetype.equals("6"))
      debugnum6 = debugnum;
    else if (leavetype.equals("7"))
      debugnum7 = debugnum;
    else if (leavetype.equals("10")) {
      debugnum8 = debugnum;
    }
    if ("1".equals(approve)) {
      debugnum1 = debugnum2 = debugnum3 = debugnum4 = debugnum5 = debugnum6 = debugnum7 = 0.0D;
    }
    String sql = "insert into depcheck (id,userid,bugnum,latenum,sicknum,absencenum,annualnum,publicnum,funeralnum,travelnum,maternitynum,checkdate,isfinish,gohomenum) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    int rsnum = 0;
    String isfinish = "";
    Session session = super.getSession();
    conn = session.connection();
    try {
      ps = conn.prepareStatement(sql.toString());
      ps.setString(1, UUID.randomUUID().toString());
      ps.setString(2, userid);
      if (approve.equals("0")) { ps.setInt(3, 0); isfinish = "2"; } else { ps.setInt(3, 1); isfinish = "3"; }
      ps.setInt(4, 0);
      ps.setDouble(5, debugnum1);
      ps.setDouble(6, debugnum2);
      ps.setDouble(7, debugnum3);
      ps.setDouble(8, debugnum7);
      ps.setDouble(9, debugnum4);
      ps.setDouble(10, debugnum5);
      ps.setDouble(11, debugnum6);
      java.sql.Date ud = new java.sql.Date(date.getTime());
      ps.setDate(12, ud);
      ps.setString(13, isfinish);
      ps.setDouble(14, debugnum8);
      rsnum = ps.executeUpdate();
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      destroyDBObj(null, ps, conn);
      super.releaseSession(session);
    }
    return rsnum;
  }

  public List<CheckInInstall> selectabnormal(String userid)
  {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    List listcheck = new ArrayList();
    String sqlwhe = "";
    if (userid == null)
      sqlwhe = " and 1==1 ";
    else if ("".equals(userid))
      sqlwhe = " and 1=1 ";
    else {
      sqlwhe = "  and t.userid='" + userid + "'";
    }

    String sql = "select to_char(m.id) userid,amchecktime,pmchecktime,t.flag,userid,checkdate,createtime,startdays,approvaldays, m.code,m.name as username,d.name as orgname from checkabnormal t ,      org_member m,      org_unit d where t.userid = m.id  and d.type='Department'   and m.org_department_id=d.id " + 
      sqlwhe + 
      "  and t.flag = 0 and m.is_deleted = 0";

    System.out.println("查询异常SQL:" + sql);
    Session session = super.getSession();
    conn = session.connection();
    try {
      ps = conn.prepareStatement(sql);
      rs = ps.executeQuery();
      while (rs.next()) {
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
    } finally {
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }
    return listcheck;
  }

  public void insertde(List<CheckInInstall> checkinins)
  {
    Connection conn = null;
    PreparedStatement ps = null;
    Session session = super.getSession();
    conn = session.connection();
    try
    {
      String sql = "insert into checkabnormal(id,amchecktime,pmchecktime,flag,userid,checkdate,createtime, startdays,approvaldays) values(?,?,?,?,?,?,?,?,?)";
      ps = conn.prepareStatement(sql);
      for (CheckInInstall inin : checkinins) {
        String userid = inin.getUserId();
        Timestamp amTime = inin.getCheckStartTime();
        Timestamp pmTime = inin.getCheckEndTime();
        String startdays = inin.getProcessStartTime();
        String approvaldays = inin.getApprovalTime();
        java.util.Date checkd = inin.getCheckDate();
        ps.setString(1, UUID.randomUUID().toString());
        ps.setTimestamp(2, amTime);
        ps.setTimestamp(3, pmTime);
        ps.setString(4, "0");
        ps.setString(5, userid);

        java.sql.Date ud = new java.sql.Date(checkd.getTime());
        ps.setDate(6, ud);

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date now = new java.util.Date();
        String nowdate = sdf.format(now);
        String nowtime = nowdate + " 0:00:00";
        Timestamp bugtime = new Timestamp(sdf1.parse(nowtime).getTime());
        ps.setTimestamp(7, bugtime);
        ps.setString(8, startdays);
        ps.setString(9, approvaldays);
        ps.executeUpdate();
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      destroyDBObj(null, ps, conn);
      super.releaseSession(session);
    }
  }

  public List<CheckInInstall> selectffectivect()
  {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    List checkset = null;
    String sql = " select  t.amstarttime,  t.amendtime,  t.pmstarttime,  t.pmendtime,  t.errortime,  t.processstarttime,  t.approvaltime  from checkininstall t ";

    Session session = super.getSession();
    conn = session.connection();
    try {
      ps = conn.prepareStatement(sql);
      rs = ps.executeQuery();
      checkset = new ArrayList();
      while (rs.next()) {
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
    } finally {
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }
    return checkset;
  }

  public void deletedepcheck(String userid, String checkdate)
  {
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
    } finally {
      destroyDBObj(null, ps, conn);
      super.releaseSession(session);
    }
  }

  public boolean updateinitcheck(String userid, String checkDate, String flag, String leavetype)
  {
    Connection conn = null;
    PreparedStatement ps = null;
    String tmp = "";
    if (flag.equals("0")) {
      tmp = "t.lateflag=0,t.latenum=0,";
    }
    String sql = " update initcheckin t set t.flag='" + flag + "'," + tmp + " t.leavetype ='" + leavetype + "' where t.userid= '" + userid + "' and to_char(t.checkdate,'yyyy-MM-dd') ='" + checkDate + "'";
    Session session = super.getSession();
    conn = session.connection();
    try {
      ps = conn.prepareStatement(sql);
      int upnum = ps.executeUpdate();
      if (upnum > 0)
        return true;
    }
    catch (Exception e) {
      e.printStackTrace();
    } finally {
      destroyDBObj(null, ps, conn);
      super.releaseSession(session);
    }
    destroyDBObj(null, ps, conn);
    super.releaseSession(session);

    return false;
  }

  public int updatedepcheck(String userid, String checkdate, String approve)
  {
    Connection conn = null;
    PreparedStatement ps = null;
    String sql = "";

    if (approve.equals("0"))
      sql = " update depcheck set bugnum=0,latenum=0,isfinish = 2 where userid='" + userid + "' and to_char(checkdate,'yyyy-MM-dd') ='" + checkdate + "'";
    else {
      sql = " update depcheck set isfinish = 2 where userid='" + userid + "' and to_char(checkdate,'yyyy-MM-dd') ='" + checkdate + "'";
    }
    int rows = 0;
    Session session = super.getSession();
    conn = session.connection();
    try {
      ps = conn.prepareStatement(sql);
      rows = ps.executeUpdate();
      return rows;
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      destroyDBObj(null, ps, conn);
      super.releaseSession(session);
    }
    return rows;
  }

  public boolean checkOKFlase(String amTime, String pmTime)
  {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String sql = "select t. from checkininstall t where t.amstarttime <= '" + amTime + "' and t.amendtime >= '" + amTime + "' and t.pmstarttime <= '" + pmTime + "' and t.pmendtime >= '" + pmTime + "'";
    Session session = super.getSession();
    conn = session.connection();
    try {
      ps = conn.prepareStatement(sql);
      rs = ps.executeQuery();
      if (rs.next())
        return true;
    }
    catch (Exception e) {
      e.printStackTrace();
    } finally {
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }
    destroyDBObj(rs, ps, conn);
    super.releaseSession(session);

    return false;
  }

  public String yesterday()
  {
    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    java.util.Date d = new java.util.Date();
    Calendar now = Calendar.getInstance();
    now.setTime(d);
    now.set(5, now.get(5) - 1);

    String dateBefore = df.format(now.getTime());
    return dateBefore;
  }

  public String today()
  {
    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    java.util.Date d = new java.util.Date();
    Calendar now = Calendar.getInstance();
    now.setTime(d);
    now.set(5, now.get(5));

    String todaydate = df.format(now.getTime());
    return todaydate;
  }

  public String selectOrgId(String userid)
  {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String sql = "select t.org_account_id from org_member t where t.id =" + userid;
    String orgid = "";
    Session session = super.getSession();
    conn = session.connection();
    try {
      ps = conn.prepareStatement(sql);
      rs = ps.executeQuery();
      if (rs.next())
        orgid = rs.getString("org_account_id");
    }
    catch (Exception e) {
      e.printStackTrace();
    } finally {
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }
    return orgid;
  }

  public List<User> selectAllUsers()
  {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    List userList = new ArrayList();

    String sql = "select t.id,t.name as username,t.code,to_char(t.org_account_id) as org_account_id,m.name as orgname,to_char(m.id) as orgId,m.path from org_member t,org_unit m where t.org_department_id = m.id and m.type='Department' and t.is_enable=1 and t.is_loginable=1 and m.is_deleted = 0 and m.is_enable = 1 and m.status = 1";

    Session session = super.getSession();
    conn = session.connection();
    try {
      ps = conn.prepareStatement(sql);
      rs = ps.executeQuery();
      while (rs.next()) {
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
    } finally {
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }
    return userList;
  }

  public List<User> getLoginno()
  {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    List userlist = new ArrayList();

    String sql = "select t.login_name,t.member_id from org_principal t";

    Session session = super.getSession();
    conn = session.connection();
    try
    {
      ps = conn.prepareStatement(sql);
      rs = ps.executeQuery();
      while (rs.next())
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
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }
    return userlist;
  }

  public Map<String, String> getLoginNameMap()
  {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    List userlist = new ArrayList();

    String sql = "select t.login_name,t.member_id from org_principal t";
    String loginName = "";
    Session session = super.getSession();
    conn = session.connection();
    Map map = new HashMap();
    try
    {
      ps = conn.prepareStatement(sql);
      rs = ps.executeQuery();
      while (rs.next())
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
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }
    return map;
  }

  public List<User> selectnockusers()
  {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    List userList = new ArrayList();
    String sql = "select u.userid from nocheckuser u";
    Session session = super.getSession();
    conn = session.connection();
    try {
      ps = conn.prepareStatement(sql);
      rs = ps.executeQuery();
      while (rs.next()) {
        User u = new User();
        u.setUserId(rs.getString("userid"));
        userList.add(u);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }
    return userList;
  }

  public List<Department> selectnockdepartment()
  {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    List departments = new ArrayList();
    String sql = "select nd.orgid,d.path from nocheckdepartment nd, org_unit d where nd.orgid = d.id and d.type='Department'";
    Session session = super.getSession();
    conn = session.connection();
    try {
      ps = conn.prepareStatement(sql);
      rs = ps.executeQuery();
      while (rs.next()) {
        Department d = new Department();
        d.setDmid(rs.getString("orgid"));
        d.setPath(rs.getString("path"));
        departments.add(d);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }
    return departments;
  }

  public String isweek(String yester)
  {
    java.util.Date date = new java.util.Date();
    Calendar now = Calendar.getInstance();
    now.setTime(date);
    now.set(5, now.get(5) - 1);

    String week = new SimpleDateFormat("EEEE").format(now.getTime());

    return week;
  }

  public List<WorkDaySet> getspecialday(String yesterday)
  {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    List worddayset = new ArrayList();

    String sql = " select to_char(org_account_id) as org_account_id,date_num,is_rest,week_num,year,month from worktime_specialday t  where t.date_num='" + 
      yesterday + "'";
    Session session = super.getSession();
    conn = session.connection();
    try {
      ps = conn.prepareStatement(sql);
      rs = ps.executeQuery();
      while (rs.next()) {
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
    } finally {
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }

    return worddayset;
  }

  public List<WorkDaySet> getcurrency(String dateBefore)
  {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    List worddayset = new ArrayList();
    Session session = super.getSession();
    conn = session.connection();
    try
    {
      String year = dateBefore.substring(0, 4);
      String sql = " select to_char(org_account_id) as org_account_id,week_day_name,is_work,year from worktime_currency t where t.year ='" + 
        year + "'";
      ps = conn.prepareStatement(sql);
      rs = ps.executeQuery();
      while (rs.next()) {
        WorkDaySet wds = new WorkDaySet();
        wds.setOrg_account_id(rs.getString("org_account_id"));
        wds.setWeek_num(rs.getString("week_day_name"));
        wds.setIs_work(rs.getString("is_work"));
        wds.setYear(rs.getString("year"));
        worddayset.add(wds);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }

    return worddayset;
  }

  public List<InitCheckIn> selectinitcheckin(String date)
  {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    List initcheckin = new ArrayList();

    String sql = "select t.amchecktime,t.pmchecktime,t.flag,t.userid,t.leavetype,t.week,t.checkdate,t.lateflag from initcheckin t where to_char(t.checkdate,'yyyy-mm-dd') ='" + 
      date + "'";

    Session session = super.getSession();
    conn = session.connection();
    try {
      ps = conn.prepareStatement(sql);
      rs = ps.executeQuery();
      while (rs.next()) {
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
    } finally {
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }
    return initcheckin;
  }

  public List<InitCheckIn> selectinitcheckin(String userid, String date)
  {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    List initcheckin = new ArrayList();

    String sql = " select t.amchecktime,t.pmchecktime,t.flag,t.userid,t.leavetype,t.week,t.checkdate,debugday  from initcheckin t  where to_char(t.checkdate,'yyyy-mm-dd') ='" + 
      date + "'" + 
      "  and t.userid = '" + userid + "'";

    Session session = super.getSession();
    conn = session.connection();
    try {
      ps = conn.prepareStatement(sql);
      rs = ps.executeQuery();
      while (rs.next()) {
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
    } finally {
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }
    return initcheckin;
  }

  public void insertcheckin(List<InitCheckIn> initListI)
  {
    Connection conn = null;
    PreparedStatement ps = null;

    StackTraceElement[] temp = Thread.currentThread().getStackTrace();
    StackTraceElement b = temp[1];
    StackTraceElement a = temp[2];
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
      String sql = "insert into initcheckin (id,amchecktime,pmchecktime,flag,userid,leavetype,week,checkdate,debugday) values (?,?,?,?,?,?,?,?,?)";

      ps = conn.prepareStatement(sql);
      for (InitCheckIn init : initListI) {
        Timestamp amTime = init.getCheckStartTime();
        Timestamp pmTime = init.getCheckEndTime();
        String flag = init.getFlag();
        String userid = init.getUserId();
        String leaveType = init.getLeaveType();
        String week = init.getWeek();
        java.util.Date checkdate = init.getCheckdate();
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

        if (userid == null) {
          StringBuffer value = new StringBuffer();
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
      destroyDBObj(null, ps, conn);
      super.releaseSession(session);
    }
  }

  public String getTime() {
    Calendar c = Calendar.getInstance();
    StringBuffer timesb = new StringBuffer();
    timesb.append(c.get(1) + "年");
    timesb.append(c.get(2) + 1 + "月");
    timesb.append(c.get(5) + "日");
    timesb.append(c.get(11) + "时");
    timesb.append(c.get(12) + "分");
    timesb.append(c.get(13) + "秒");
    timesb.append(c.get(14) + "毫秒");
    return timesb.toString();
  }

  public boolean checkischeck(String userid, String checkdate)
  {
    boolean cboo = false;
    PreparedStatement ps = null;
    ResultSet rs = null;
    Session session = super.getSession();
    Connection conn = session.connection();
    try {
      String sqlmember = "select t.id from initcheckin t where t.userid='" + userid + "' and to_char(t.checkdate,'yyyy-MM-dd') ='" + checkdate + "'";
      System.out.println(sqlmember);
      ps = conn.prepareStatement(sqlmember);
      rs = ps.executeQuery();
      if (rs.next()) {
        return true;
      }
      return false;
    }
    catch (SQLException e) {
      e.printStackTrace();
    } finally {
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }
    return cboo;
  }

  public HashMap<String, String> checkInJudge()
  {
    PreparedStatement ps = null;
    ResultSet rs = null;

    HashMap noCheckMember = new HashMap();
    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");

    String dateBefore = df.format(Long.valueOf(new java.util.Date().getTime() - 86400000L));

    Session session = super.getSession();
    Connection conn = session.connection();
    try
    {
      String sqlmember = "select t.id,t.code,t.org_account_id from org_unit t where t.type='Department'";
      ps = conn.prepareStatement(sqlmember);
      rs = ps.executeQuery();

      while (rs.next())
      {
        String userid = rs.getString("id");

        String code = rs.getString("code");

        String userorg = rs.getString("org_account_id");

        String sqlcheckin = "select t.userid from initcheckin t where userid=" + userid + " and to_char(t.checktime,'yyyy-MM-dd') =" + dateBefore;

        ps = conn.prepareStatement(sqlcheckin);
        rs = ps.executeQuery();

        if (!rs.next())
        {
          String sqlcheck = "select t.id from worktime_specialday t where (t.is_rest='1' or t.is_rest='2') and t.org_account_id=" + 
            userorg + 
            "and t.date_num=" + dateBefore;

          ps = conn.prepareStatement(sqlcheck);
          rs = ps.executeQuery();
          HashMap localHashMap1;
          if (rs.next()) {
            localHashMap1 = noCheckMember; return localHashMap1;
          }

          String sqlDug = "select t.id from depcheck t where t.usercode='" + 
            code + 
            "' and t.checkdate = '" + 
            dateBefore + 
            "'";

          ps = conn.prepareStatement(sqlDug);
          rs = ps.executeQuery();

          if (rs.next())
          {
            localHashMap1 = noCheckMember; return localHashMap1;
          }

          noCheckMember.put(userid, code);
        }
      }
    }
    catch (SQLException e)
    {
      e.printStackTrace();
    } finally {
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }

    return noCheckMember;
  }

  public void saveUpdateCheckinSet(CheckInInstall install)
  {
    PreparedStatement ps = null;
    ResultSet rs = null;

    String sqlcount = "select * from  checkininstall";
    Session session = super.getSession();
    Connection conn = session.connection();
    try {
      ps = conn.prepareStatement(sqlcount);
      rs = ps.executeQuery();
      ps = null;
      if (rs.next())
      {
        String updatesql = " update checkininstall set amstarttime=?,amendtime=?,pmstarttime=?,pmendtime=?,errortime=?,processstarttime=?,approvaltime=?";

        ps = conn.prepareStatement(updatesql);

        ps.setString(1, install.getAmStartTime());

        ps.setString(2, install.getAmEndTime());

        ps.setString(3, install.getPmStartTime());

        ps.setString(4, install.getPmEndTime());

        ps.setString(5, install.getErrorTime());

        ps.setString(6, install.getProcessStartTime());

        ps.setString(7, install.getApprovalTime());
        ps.executeUpdate();
      }
      else {
        String saveinstallsql = "insert into checkininstall(id,amstarttime,amendtime,pmstarttime,pmendtime,errortime,processstarttime,approvaltime) values(?,?,?,?,?,?,?,?)";

        ps = conn.prepareStatement(saveinstallsql);
        ps.setString(1, UUID.randomUUID().toString());

        ps.setString(2, install.getAmStartTime());

        ps.setString(3, install.getAmEndTime());

        ps.setString(4, install.getPmStartTime());

        ps.setString(5, install.getPmEndTime());

        ps.setString(6, install.getErrorTime());

        ps.setString(7, install.getProcessStartTime());

        ps.setString(8, install.getApprovalTime());
        ps.executeUpdate();
      }

      String departmentids = install.getNotCheckInDepartmentId();

      session = super.getSession();
      conn = session.connection();
      if ((departmentids != null) && 
        (!"".equals(departmentids)))
      {
        String[] depArr = departmentids.split(",");

        List nodepartments = searchNoCheckinDepartments();
        String sqli = "insert into nocheckdepartment(id,orgid) values(?,?)";
        session = super.getSession();
        conn = session.connection();
        ps = conn.prepareStatement(sqli);

        for (int i = 0; i < depArr.length; i++) {
          boolean exists = false;
          if (!"".equals(depArr[i].trim()))
          {
            for (int index = 0; index < nodepartments.size(); index++) {
              NoCheckinDepart nd = (NoCheckinDepart)nodepartments.get(index);
              String orgid = nd.getDeid();
              if (orgid.trim().equals(depArr[i].trim())) {
                exists = true;
                break;
              }
            }
            if (!exists) {
              ps.setString(1, UUID.randomUUID().toString());

              ps.setString(2, depArr[i].trim());
              ps.executeUpdate();
            }
          }
        }
      }
      String userids = install.getNotCheckInPersonId();
      if ((userids != null) && 
        (!"".equals(userids)))
      {
        String[] userArr = userids.split(",");

        List nousers = searchNoCheckinUsers();
        session = super.getSession();
        conn = session.connection();
        String sqlInsetUser = "insert into nocheckuser(id,userid) values (?,?)";
        ps = conn.prepareStatement(sqlInsetUser);
        for (int i = 0; i < userArr.length; i++) {
          boolean exists = false;
          String userid = userArr[i];
          if ("".equals(userid.trim())) {
            break;
          }
          for (int index = 0; index < nousers.size(); index++) {
            NoCheckinUser nextUser = (NoCheckinUser)nousers.get(index);
            String uid = nextUser.getUid();
            if (uid.trim().equals(userid.trim())) {
              exists = true;
              break;
            }
          }
          if (!exists) {
            ps.setString(1, UUID.randomUUID().toString());
            ps.setString(2, userid.trim());
            ps.executeUpdate();
          }
        }
      }
    } catch (SQLException e1) {
      e1.printStackTrace();
    } finally {
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }
  }

  public CheckInInstall searchCheckinSet()
  {
    deleteDisableDep();

    deleteDisableUser();
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    List nousers = searchNoCheckinUsers();
    Iterator itr = nousers.iterator();

    String nouserids = "";

    String nousernames = "";
    while (itr.hasNext()) {
      NoCheckinUser nextUser = (NoCheckinUser)itr.next();
      nouserids = nouserids + nextUser.getUid() + ",";
      nousernames = nousernames + nextUser.getUsername() + ",";
    }
    if (!nouserids.equals(""))
    {
      nouserids = nouserids.substring(0, nouserids.length() - 1);
    }
    if (!nousernames.equals(""))
    {
      nousernames = nousernames.substring(0, nousernames.length() - 1);
    }

    List nodepartments = searchNoCheckinDepartments();
    Iterator itrde = nodepartments.iterator();

    String nodepartmentids = "";

    String nodepartmentnames = "";
    while (itrde.hasNext()) {
      NoCheckinDepart nextdepart = (NoCheckinDepart)itrde.next();
      nodepartmentids = nodepartmentids + nextdepart.getDeid() + ",";
      nodepartmentnames = nodepartmentnames + nextdepart.getDepartname() + ",";
    }
    if (!nodepartmentids.equals(""))
    {
      nodepartmentids = nodepartmentids.substring(0, nodepartmentids.length() - 1);
    }
    if (!nodepartmentnames.equals(""))
    {
      nodepartmentnames = nodepartmentnames.substring(0, nodepartmentnames.length() - 1);
    }
    String searchinstallsql = "select * from checkininstall";
    Session session = super.getSession();
    conn = session.connection();
    try {
      ps = conn.prepareStatement(searchinstallsql);
      rs = ps.executeQuery();
      CheckInInstall checkInInstall = new CheckInInstall();

      checkInInstall.setNotCheckInDepartmentId(nodepartmentids);

      checkInInstall.setNotCheckInDepartment(nodepartmentnames);

      checkInInstall.setNotCheckInPersonId(nouserids);

      checkInInstall.setNotCheckInPerson(nousernames);
      while (rs.next())
      {
        checkInInstall.setAmStartTime(rs.getString("amstarttime"));

        checkInInstall.setAmEndTime(rs.getString("amendtime"));

        checkInInstall.setPmStartTime(rs.getString("pmstarttime"));

        checkInInstall.setPmEndTime(rs.getString("pmendtime"));

        checkInInstall.setErrorTime(rs.getString("errortime"));

        checkInInstall.setProcessStartTime(rs.getString("processStartTime"));

        checkInInstall.setApprovalTime(rs.getString("approvalTime"));
      }
      return checkInInstall;
    } catch (SQLException e) {
      e.printStackTrace();
      return null;
    } finally {
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }
  }

  public List<NoCheckinUser> searchNoCheckinUsers()
  {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String usersql = "select m.id as nid ,m.name as mname from nocheckuser n ,org_member m where n.userid=m.id order by m.name";
    List ulist = new ArrayList();
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
    } finally {
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }
  }

  public void deleteNoCheckinUsers(String uids)
  {
    Connection conn = null;
    PreparedStatement ps = null;
    String[] userids = uids.split(",");
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

  public List<NoCheckinDepart> searchNoCheckinDepartments()
  {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String sql = "select d.id as cid,d.name as dname from nocheckdepartment c,org_unit d where d.type='Department' and d.id=c.orgid order by d.name";
    List dlist = new ArrayList();
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
    } finally {
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }
  }

  public void deleteNoCheckInDepartments(String dids)
  {
    Connection conn = null;
    PreparedStatement ps = null;
    String[] departids = dids.split(",");
    Session session = super.getSession();
    conn = session.connection();
    try {
      String delsql = "delete from nocheckdepartment where orgid =?";
      ps = conn.prepareStatement(delsql);
      for (int i = 0; i < departids.length; i++) {
        ps.setString(1, departids[i].trim());
        ps.executeUpdate();
      }
    } catch (SQLException e) {
      e.printStackTrace();
    } finally {
      destroyDBObj(null, ps, conn);
      super.releaseSession(session);
    }
  }

  public boolean lauchForm(String[] usermessage)
  {
    BPMUtils utils = new BPMUtils();
    try
    {
      String loginName = usermessage[6];

      String templateCode = "A001";

      String xml = utils.getTemplateDefinition(templateCode);

      FormExport export = utils.xmlTOFormExport(xml);

      export = utils.setValue2(export, usermessage);

      xml = utils.toString(export);
      StringBuffer sb = new StringBuffer();
      sb.append("<?xml version=\"1.0\" encoding=\"GBK\"?>\n");
      sb.append(xml);
      xml = sb.toString();

      utils.lauchFormCollaboration(utils.getTokenId(), loginName, templateCode, xml, "1");
      return true;
    } catch (Exception e) {
      e.printStackTrace();
    }return false;
  }

  public String getuserid(String usercode)
  {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String userid = "";
    Session session = super.getSession();
    conn = session.connection();
    try
    {
      String sql = "select id from org_member m  where m.code = '" + usercode + "'";
      ps = conn.prepareStatement(sql);
      rs = ps.executeQuery();
      if (rs.next())
        userid = rs.getString("id");
    }
    catch (SQLException e) {
      e.printStackTrace();
    } finally {
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }
    return userid;
  }

  public boolean checkisok(String userid, String checkdate)
  {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    Session session = super.getSession();
    conn = session.connection();
    try {
      String sql = "select t.flag from initcheckin t where t.userid='" + userid + "' and to_char(t.checkdate,'yyyy-MM-dd') ='" + checkdate + "'";
      ps = conn.prepareStatement(sql);
      rs = ps.executeQuery();
      if (rs == null);
      while (!rs.next()) {
        return false;
      }

      String flag = rs.getString("flag");
      if ("0".equals(flag))
        return true;
      if ("1".equals(flag)) {
        return false;
      }

    }
    catch (SQLException e)
    {
      e.printStackTrace();
    } finally {
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }
    destroyDBObj(rs, ps, conn);
    super.releaseSession(session);

    return false;
  }

  public double getleavetypenum(Timestamp amtime, Timestamp pmtime, java.util.Date checkdate)
  {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String sql = " select  t.amstarttime, t.amendtime, t.pmstarttime, t.pmendtime from checkininstall t";

    String amstarttime = "";
    String pmendtime = "";
    Session session = super.getSession();
    conn = session.connection();
    try {
      ps = conn.prepareStatement(sql);
      rs = ps.executeQuery();
      if (rs.next()) {
        amstarttime = rs.getString("amstarttime");
        pmendtime = rs.getString("pmendtime");

        SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String debugdate = sdf.format(checkdate);

        String amstart = debugdate + " " + amstarttime;
        String pmend = debugdate + " " + pmendtime;

        java.util.Date amstartd = sdf1.parse(amstart);
        java.util.Date pmendd = sdf1.parse(pmend);

        double intam = 0.0D;
        double intpm = 0.0D;

        if (amtime == null) {
          intam = 0.5D;
        } else {
          java.util.Date dd = new java.util.Date(amtime.getTime());
          if (dd.after(amstartd)) {
            intam = 0.5D;
          }
        }

        if (pmtime == null) {
          intpm = 0.5D;
        } else {
          java.util.Date dd = new java.util.Date(pmtime.getTime());
          if (dd.before(pmendd)) {
            intpm = 0.5D;
          }
        }

        double debugnum = intam + intpm;
        return debugnum;
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }
    destroyDBObj(rs, ps, conn);
    super.releaseSession(session);

    return 0.0D;
  }

  public int getlatenum(Timestamp amtime, Timestamp pmtime, java.util.Date checkdate)
  {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String sql = " select  t.amstarttime, t.amendtime, t.pmstarttime, t.pmendtime from checkininstall t";

    String amstarttime = "";
    String amendtime = "";
    String pmstarttime = "";
    String pmendtime = "";
    Session session = super.getSession();
    conn = session.connection();
    try {
      ps = conn.prepareStatement(sql);
      rs = ps.executeQuery();
      if (rs.next()) {
        amstarttime = rs.getString("amstarttime");
        amendtime = rs.getString("amendtime");
        pmstarttime = rs.getString("pmstarttime");
        pmendtime = rs.getString("pmendtime");

        SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String debugdate = sdf.format(checkdate);
        String amstart = debugdate + " " + amstarttime;
        String amend = debugdate + " " + amendtime;
        String pmstart = debugdate + " " + pmstarttime;
        String pmend = debugdate + " " + pmendtime;

        java.util.Date amstartd = sdf1.parse(amstart);
        java.util.Date amendd = sdf1.parse(amend);
        java.util.Date pmstartd = sdf1.parse(pmstart);
        java.util.Date pmendd = sdf1.parse(pmend);

        int intam = 0;
        int intpm = 0;

        if (amtime != null)
        {
          if (((amtime.after(amstartd)) && (amtime.before(amendd))) || (amtime.compareTo(amendd) == 0)) {
            intam = 1;
          }
        }

        if (pmtime != null)
        {
          if (((pmtime.after(pmstartd)) || (pmtime.compareTo(pmstartd) == 0)) && (pmtime.before(pmendd))) {
            intpm = 1;
          }
        }

        int debugnum = intam + intpm;
        return debugnum;
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }
    destroyDBObj(rs, ps, conn);
    super.releaseSession(session);

    return 0;
  }

  public void updateinitcheckin(List<InitCheckIn> initList)
  {
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

  public boolean creatTxtFile(String name)
  {
    boolean flag = false;

    this.filenameTemp = (name + ".txt");
    File filename = new File(this.filenameTemp);
    System.out.println("filename:" + this.filenameTemp);
    if ((!filename.getParentFile().exists()) && 
      (!filename.getParentFile().mkdirs())) {
      return false;
    }

    System.out.println("文件名称：" + this.filenameTemp);

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

  public boolean writeTxtFile(String newStr)
  {
    String fileEncode = System.getProperty("file.encoding");
    boolean flag = false;
    String filein = newStr + "\r\n";
    String temp = "";
    StringBuffer buf = new StringBuffer();

    FileInputStream fis = null;
    InputStreamReader isr = null;
    BufferedReader br = null;
    FileOutputStream fos = null;
    OutputStreamWriter pw = null;
    try
    {
      File file = new File(this.filenameTemp);

      fis = new FileInputStream(file);
      isr = new InputStreamReader(fis);
      br = new BufferedReader(isr);

      while ((temp = br.readLine()) != null) {
        buf = buf.append(temp);

        buf = buf.append(System.getProperty("line.separator"));
      }
      buf.append(filein);

      fos = new FileOutputStream(file, true);
      pw = new OutputStreamWriter(fos, fileEncode);
      pw.write(buf.toString().toCharArray());
      pw.flush();
      flag = true;
    } catch (IOException e1) {
      e1.printStackTrace();

      if (pw != null) {
        try {
          pw.close();
          pw = null;
        } catch (IOException e) {
          e.printStackTrace();
        }
      }
      if (fos != null) {
        try {
          fos.close();
          fos = null;
        } catch (IOException e) {
          e.printStackTrace();
        }
      }
      if (br != null) {
        try {
          br.close();
          br = null;
        } catch (IOException e) {
          e.printStackTrace();
        }
      }
      if (isr != null) {
        try {
          isr.close();
          isr = null;
        } catch (IOException e) {
          e.printStackTrace();
        }
      }
      if (fis != null)
        try {
          fis.close();
          fis = null;
        } catch (IOException e) {
          e.printStackTrace();
        }
    }
    finally
    {
      if (pw != null) {
        try {
          pw.close();
          pw = null;
        } catch (IOException e) {
          e.printStackTrace();
        }
      }
      if (fos != null) {
        try {
          fos.close();
          fos = null;
        } catch (IOException e) {
          e.printStackTrace();
        }
      }
      if (br != null) {
        try {
          br.close();
          br = null;
        } catch (IOException e) {
          e.printStackTrace();
        }
      }
      if (isr != null) {
        try {
          isr.close();
          isr = null;
        } catch (IOException e) {
          e.printStackTrace();
        }
      }
      if (fis != null) {
        try {
          fis.close();
          fis = null;
        } catch (IOException e) {
          e.printStackTrace();
        }
      }
    }
    return flag;
  }

  public String getAccountId(String userId)
  {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String orgid = "";

    String sql = "select to_char(t.org_account_id) orgid from org_member t where to_char(t.id)='" + userId + "'";
    Session session = super.getSession();
    conn = session.connection();
    try {
      ps = conn.prepareStatement(sql);
      rs = ps.executeQuery();
      while (rs.next()) {
        orgid = rs.getString("orgid");
      }
      return orgid;
    } catch (SQLException e) {
      e.printStackTrace();
    } finally {
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }

    return orgid;
  }

  public boolean existsCheckBug(String userId, String checkDate)
  {
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
      if (rs.next())
        return checkbug = true;
    }
    catch (SQLException e) {
      e.printStackTrace();
    } finally {
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }
    destroyDBObj(rs, ps, conn);
    super.releaseSession(session);

    return checkbug;
  }

  public boolean existsDepCheck(String userId, String checkDate)
  {
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
      if (rs.next())
        return checkbug = true;
    }
    catch (SQLException e) {
      e.printStackTrace();
    } finally {
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }
    destroyDBObj(rs, ps, conn);
    super.releaseSession(session);

    return checkbug;
  }

  public boolean isStartUp(String userId, String checkDate)
  {
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
      if (rs.next())
        return checkbug = true;
    }
    catch (SQLException e) {
      e.printStackTrace();
    } finally {
      destroyDBObj(rs, ps, conn);
      super.releaseSession(session);
    }
    destroyDBObj(rs, ps, conn);
    super.releaseSession(session);

    return checkbug;
  }

  public void deleteDisableDep()
  {
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
    } finally {
      destroyDBObj(null, ps, conn);
      super.releaseSession(session);
    }
  }

  public void deleteDisableUser()
  {
    Connection conn = null;
    PreparedStatement ps = null;

    String sql = "delete from nocheckuser t where t.userid not in (select x.id from org_member x where x.is_enable=1 and x.is_loginable=1)";
    Session session = super.getSession();
    conn = session.connection();
    try {
      ps = conn.prepareStatement(sql);
      ps.executeQuery();
    } catch (SQLException e) {
      e.printStackTrace();
    } finally {
      destroyDBObj(null, ps, conn);
      super.releaseSession(session);
    }
  }

  public String toDate1(String s)
  {
    return s.substring(0, 4) + "/" + s.substring(5, 7) + "/" + s.substring(8, 10);
  }

  public String toDate2(String s)
  {
    return s.substring(0, 4) + "-" + s.substring(5, 7) + "-" + s.substring(8, 10);
  }

  public String toMonth(String month)
  {
    if (month.length() == 1)
      month = "0" + month;
    return month;
  }

  public void destroyDBObj(ResultSet rs, PreparedStatement ps, Connection conn)
  {
    if (rs != null) {
      try {
        rs.close();
        rs = null;
      } catch (SQLException e) {
        e.printStackTrace();

        if (ps == null) return;
        try {
          ps.close();
          ps = null;
        } catch (SQLException e1) {
          e1.printStackTrace();

          if (conn == null) return;
          try {
            conn.close();
            conn = null;
          } catch (SQLException e2) {
            e2.printStackTrace();
          }
        }
        finally
        {
          if (conn != null)
            try {
              conn.close();
              conn = null;
            } catch (SQLException e3) {
              e3.printStackTrace();
            }
        }
        try
        {
          conn.close();
          conn = null;
        } catch (SQLException e4) {
          e4.printStackTrace();
        }
      }
      finally
      {
        if (ps != null) {
          try {
            ps.close();
            ps = null;
          } catch (SQLException e) {
            e.printStackTrace();

            if (conn != null)
              try {
                conn.close();
                conn = null;
              } catch (SQLException e5) {
                e5.printStackTrace();
              }
          }
          finally
          {
            if (conn != null) {
              try {
                conn.close();
                conn = null;
              } catch (SQLException e) {
                e.printStackTrace();
              }
            }
          }
        }

      }

    }
    else if (ps != null)
      try {
        ps.close();
        ps = null;
      } catch (SQLException e) {
        e.printStackTrace();

        if (conn != null)
          try {
            conn.close();
            conn = null;
          } catch (SQLException e1) {
            e1.printStackTrace();
          }
      }
      finally
      {
        if (conn != null)
          try {
            conn.close();
            conn = null;
          } catch (SQLException e) {
            e.printStackTrace();
          }
      }
  }
}