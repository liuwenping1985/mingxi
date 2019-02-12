/**
 * 
 * Author: xiaolin
 * Date: 2016年12月6日
 *
 * Copyright (C) 2016 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
package com.seeyon.apps.attendance.manager;

import java.text.ParseException;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.seeyon.apps.attendance.AttendanceConstants.AttendanceType;
import com.seeyon.apps.attendance.exceptions.ValidateException;
import com.seeyon.apps.attendance.po.AttendanceInfo;
import com.seeyon.apps.attendance.po.AttendanceRemind;
import com.seeyon.apps.attendance.po.AttendanceSetting;
import com.seeyon.apps.attendance.vo.AttendanceInfoVO;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.annotation.AjaxAccess;

/**
 * <p>Title:考勤签到manager业务层 </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2016</p>
 * <p>Company: com.seeyon.apps.attendance.manager</p>
 * <p>since Seeyon V6.1</p>
 */
public interface AttendanceManager {
	
	@AjaxAccess
    String isCheckSignout() throws BusinessException;
	 /**
     * 保存打卡数据
     * @param remark 备注
     * @param fromSource 来源
     * @return
     */
    @AjaxAccess
    Map<String, Object> savePunchcardData(String remark, int fromSource) throws BusinessException;
	/**
	 *<b>保存签到信息(PC&Mobile统一入口) 包含上传的文件信息</b><br>
	 *@param params	{fileJson:附件JSON字符串}
	 *@param currentUser 当前操作人的信息
	 *@return
	 *@throws BusinessException
	 *(注意：M1直接调用的接口)
	 */
	public AttendanceInfo saveAttendance(Map<String, Object> params, User currentUser) throws BusinessException,ValidateException;
	/**
	 * 更新签到信息
	 * @param 
	 * @return
	 */
	public AttendanceInfo updateAttendance(Map<String, Object> params, User currentUser) throws BusinessException,ValidateException,CloneNotSupportedException;
	/**
	 * 批量存储签到数据
	 * @param 
	 * @return
	 */
	public void saveAttendance(List<AttendanceInfo> data);
	
	/**
	 * 根据参数条件获取考勤数据(不分页)
	 * @param 时间段,人员等
	 * @return
	 * (注意：M1直接调用的接口)
	 */
	public List<AttendanceInfo> findAttendanceInfo(Map<String, Object> params);
	/**
	 * <p>员工考勤-根据参数条件获取考勤VO数据(分页)</p>
	 * @param 
	 * @return
	 */
	@AjaxAccess
	FlipInfo findStaffAttendanceInfoData(FlipInfo fi, Map<String, Object> params) throws BusinessException, ParseException;
	
	/**
	 * <p>个人明细-根据参数条件获取考勤VO数据(分页)</p>
	 * @param 
	 * @return
	 */
	@AjaxAccess
	FlipInfo findPersonAttendanceInfoData(FlipInfo fi, Map<String, Object> params) throws BusinessException, ParseException;
	/**
	 * 获取当前登录人当天的打卡记录
	 * @param flipInfo	分页信息
	 * @return	List<AttendanceInfoVO>
	 */
	List<AttendanceInfoVO> getCurrentAttendance(FlipInfo flipInfo) throws BusinessException;

	/**
	 * 分页查询我的签到记录
	 * @param flipInfo
	 * @return
	 * @throws BusinessException
	 * (注意：M1直接调用的接口)
	 */
	List<AttendanceInfoVO> getMyAttendance(Map<String, Object> params, FlipInfo flipInfo) throws BusinessException;
	/**
	 *<p>根据时间范围清理考勤签到数据和调度数据</p>
	 * @param  
	 * @return
	 * @throws
	 */
	@AjaxAccess
	public boolean deleteDateByRangeDate(String date);
	/**
	 * 获取删除范围的结束时间
	 * @param 
	 * @return
	 */
	@AjaxAccess
	public String getDeleteEndTime(int range);

	/**
	 * 分页查询at我的签到记录
	 * @param flipInfo
	 * @return
	 * @throws BusinessException
	 * (注意：M1直接调用的接口)
	 */
	@AjaxAccess
	public FlipInfo findMentionedMeAttendance(FlipInfo flipInfo, Map<String, Object> params) throws BusinessException;
	/**
	 * 存储考勤提醒
	 * @param 
	 * @return
	 */
	@AjaxAccess
	void saveAttendanceRemind(int remindAttend, int remindLeave);
	/**
	 * 查询各单位的考勤提醒设置
	 * @param 
	 * @return
	 */
	List<AttendanceRemind> findAttendanceRemind(Map<String, Object> params);
	/**
	 * 检测是否存在删除范围之间得数据
	 * @param 
	 * @return
	 */
	@AjaxAccess
	public Map<String,Object> checkDeleteRange(int range);

	/**
	 * 检查我的当天的签到情况
	 * @return 返回是否签到，签退
	 * @throws BusinessException
	 */
	public Map<String,Object> checkAuthForAttendance() throws BusinessException;

	/**
	 * 根据id获取签到记录
	 * @param attendanceId
	 * @return
	 * @throws BusinessException
	 */
	public AttendanceInfoVO getAttendanceById(Long attendanceId) throws BusinessException;

	/**
	 * 根据id删除签到记录（M1需要）
	 * @param attendanceId
	 * @return true(删除成功)
	 * @throws BusinessException
	 * (注意：M1直接调用的接口)
	 */
	public boolean removeAttendaceById(Long attendanceId) throws BusinessException;
	
	/**
	 *<b>获取今天的签到记录</b><br>
	 *@since 6.1
	 *@date  2016年12月28日
	 *@param ownerId
	 *@param type
	 *@param whichDay
	 *@return
	 *@throws BusinessException
	 */
	public List<AttendanceInfo> getTodayAttendanceInfo(Long ownerId, AttendanceType type) throws BusinessException;
	
	/**
	 *<b>为大数据做准备，造3年的签到数据</b><br>
	 *@since 6.1
	 *@date  2017年2月18日
	 *@return
	 *@throws BusinessException
	 */
	@AjaxAccess
	public String doRunBigData() throws BusinessException;

	/**
	 * 获取授权我的人员列表
	 * @return
	 * @throws BusinessException
	 */
	@AjaxAccess
	List<Map<String,Object>> getAuthScopeMembers(/*FlipInfo fi, Map<String, Object> params*/) throws BusinessException;

	/**
	 * 检查当前人是否有授权我的数据
	 * @return
	 * @throws BusinessException
	 */
	@AjaxAccess
	Map<String,Object> checkAuthScope() throws BusinessException;
	
	/**
	 *<b>获取第一次考勤的时间</b><br>
	 *@since 6.1
	 *@date  2017年2月22日
	 *@param accountId 指定单位的第一次数据，如果为null则是全系统的数据
	 *@return
	 *@throws BusinessException
	 */
	public Date getEarliestSigntime(Long accountId) throws BusinessException;

	/**
	 * 查询当天某些人的最新签到记录
	 * @return
	 */
	public List<Map<String,Object>> getTodayAttendanceByMemberIds(Map<String, Object> params) throws BusinessException;

	/**
	 * 分页查询授权我的签到记录
	 * @param flipInfo
	 * @param params
	 * @return
	 * @throws BusinessException
	 */
	public List<Map<String,Object>> getAuthorizeAttendance(FlipInfo flipInfo, Map<String, Object> params) throws BusinessException;

	/**
	 * 保存签到应用设置
	 * @param params
	 * @return
	 * @throws BusinessException
	 */
	public boolean saveOrUpdateAttendanceSetting(Map<String, Object> params) throws BusinessException;

	/**
	 * 查询所有应用设置
	 * @param flipInfo
	 * @return
	 * @throws BusinessException
	 */
	public List<AttendanceSetting> findSettings(FlipInfo flipInfo) throws BusinessException;

	/**
	 * 通过id查询签到设置
	 * @param id
	 * @return
	 * @throws BusinessException
	 */
	public AttendanceSetting findSettingById(Long id) throws BusinessException;

	/**
	 * 根据id删除签到设置
	 * @param id
	 * @return
	 * @throws BusinessException
	 */
	public boolean removeSettingById(Long id) throws BusinessException;

	/**
	 * 查询启用中的签到设置
	 * @return
	 * @throws BusinessException
	 */
	public List<AttendanceSetting> findAvailableSettings() throws BusinessException;
	/**
	 * 根据签到id和人员id,判断是否拥有at权限
	 * @param 
	 * @return
	 */
	@AjaxAccess
	public boolean checkAttendanceAtByUser(Long attendanceId, Long memberId);
}
