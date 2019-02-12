package com.seeyon.apps.checkin.dao;

import com.seeyon.apps.checkin.domain.CheckInInstall;
import com.seeyon.apps.checkin.domain.Department;
import com.seeyon.apps.checkin.domain.InitCheckIn;
import com.seeyon.apps.checkin.domain.NoCheckinDepart;
import com.seeyon.apps.checkin.domain.NoCheckinUser;
import com.seeyon.apps.checkin.domain.User;
import com.seeyon.apps.checkin.domain.WorkDaySet;
import com.seeyon.apps.checkin.domain.depCheckIn;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

public abstract interface CheckInInstallDao_OLD
{
  public abstract void checkYesterdayCheckin();

  public abstract void startUpForm();

  public abstract boolean checkvalid(String paramString1, String paramString2, String paramString3);

  public abstract int updatedepcheck(String paramString1, String paramString2, String paramString3, String paramString4, double paramDouble);

  public abstract int updatedepcheck(String paramString, Date paramDate);

  public abstract int updatecheckabnormal(String paramString1, String paramString2);

  public abstract int deletecheckabnormal(String paramString1, String paramString2);

  public abstract void insertdepcheck(List<depCheckIn> paramList);

  public abstract int insertdepcheck(String paramString1, Date paramDate, String paramString2, String paramString3, double paramDouble);

  public abstract List<CheckInInstall> selectabnormal(String paramString);

  public abstract void insertde(List<CheckInInstall> paramList);

  public abstract List<CheckInInstall> selectffectivect();

  public abstract void deletedepcheck(String paramString1, String paramString2);

  public abstract boolean updateinitcheck(String paramString1, String paramString2, String paramString3, String paramString4);

  public abstract int updatedepcheck(String paramString1, String paramString2, String paramString3);

  public abstract boolean checkOKFlase(String paramString1, String paramString2);

  public abstract String yesterday();

  public abstract String today();

  public abstract String selectOrgId(String paramString);

  public abstract List<User> selectAllUsers();

  public abstract List<User> getLoginno();

  public abstract List<User> selectnockusers();

  public abstract List<Department> selectnockdepartment();

  public abstract String isweek(String paramString);

  public abstract List<WorkDaySet> getspecialday(String paramString);

  public abstract List<WorkDaySet> getcurrency(String paramString);

  public abstract List<InitCheckIn> selectinitcheckin(String paramString);

  public abstract List<InitCheckIn> selectinitcheckin(String paramString1, String paramString2);

  public abstract void insertcheckin(List<InitCheckIn> paramList);

  public abstract String getTime();

  public abstract boolean checkischeck(String paramString1, String paramString2);

  public abstract HashMap<String, String> checkInJudge();

  public abstract void saveUpdateCheckinSet(CheckInInstall paramCheckInInstall);

  public abstract CheckInInstall searchCheckinSet();

  public abstract List<NoCheckinUser> searchNoCheckinUsers();

  public abstract void deleteNoCheckinUsers(String paramString);

  public abstract List<NoCheckinDepart> searchNoCheckinDepartments();

  public abstract void deleteNoCheckInDepartments(String paramString);

  public abstract boolean lauchForm(String[] paramArrayOfString);

  public abstract String getuserid(String paramString);

  public abstract boolean checkisok(String paramString1, String paramString2);

  public abstract double getleavetypenum(Timestamp paramTimestamp1, Timestamp paramTimestamp2, Date paramDate);

  public abstract int getlatenum(Timestamp paramTimestamp1, Timestamp paramTimestamp2, Date paramDate);

  public abstract void updateinitcheckin(List<InitCheckIn> paramList);

  public abstract boolean creatTxtFile(String paramString);

  public abstract boolean writeTxtFile(String paramString);

  public abstract String getAccountId(String paramString);

  public abstract boolean existsCheckBug(String paramString1, String paramString2);

  public abstract boolean existsDepCheck(String paramString1, String paramString2);

  public abstract boolean isStartUp(String paramString1, String paramString2);

  public abstract void deleteDisableDep();

  public abstract void deleteDisableUser();

  public abstract String toDate1(String paramString);

  public abstract String toDate2(String paramString);

  public abstract String toMonth(String paramString);

  public abstract void destroyDBObj(ResultSet paramResultSet, PreparedStatement paramPreparedStatement, Connection paramConnection);
}