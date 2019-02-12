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

import java.text.MessageFormat;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;

import com.seeyon.apps.attendance.AttendanceConstants.AttendanceDateRange;
import com.seeyon.apps.attendance.AttendanceConstants.AttendanceLogAction;
import com.seeyon.apps.attendance.AttendanceConstants.AttendancePersonInfoTable;
import com.seeyon.apps.attendance.AttendanceConstants.AttendanceQueryParam;
import com.seeyon.apps.attendance.AttendanceConstants.AttendanceRemindEnum;
import com.seeyon.apps.attendance.AttendanceConstants.AttendanceRemindTimeEnum;
import com.seeyon.apps.attendance.AttendanceConstants.AttendanceSourceEnum;
import com.seeyon.apps.attendance.AttendanceConstants.AttendanceStaffInfoTable;
import com.seeyon.apps.attendance.AttendanceConstants.AttendanceType;
import com.seeyon.apps.attendance.dao.AttendanceDao;
import com.seeyon.apps.attendance.exceptions.ValidateException;
import com.seeyon.apps.attendance.po.AttendanceAt;
import com.seeyon.apps.attendance.po.AttendanceHistory;
import com.seeyon.apps.attendance.po.AttendanceInfo;
import com.seeyon.apps.attendance.po.AttendanceRemind;
import com.seeyon.apps.attendance.po.AttendanceSetting;
import com.seeyon.apps.attendance.quart.AttendRemindTask;
import com.seeyon.apps.attendance.quart.LeaveRemindTask;
import com.seeyon.apps.attendance.utils.AttendanceUtil;
import com.seeyon.apps.attendance.vo.AttendanceInfoVO;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.log.CtpLogFactory;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.quartz.MutiQuartzJobNameException;
import com.seeyon.ctp.common.quartz.NoSuchQuartzJobBeanException;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.common.usermessage.MessageContent;
import com.seeyon.ctp.common.usermessage.MessageReceiver;
import com.seeyon.ctp.common.usermessage.UserMessageManager;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.v3x.worktimeset.exception.WorkTimeSetExecption;

/**
 * <p>Title:manager层实现 </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2016</p>
 * <p>Company: com.seeyon.apps.attendance.manager</p>
 * <p>since Seeyon V6.1</p>
 */
public class AttendanceManagerImpl implements AttendanceManager{
	private static final Log LOGGER = CtpLogFactory.getLog(AttendanceManagerImpl.class);
	
	private AttendanceDao attendanceDao;
	private AttachmentManager attachmentManager;
	private UserMessageManager userMessageManager;
	private OrgManager orgManager;
	private AttendanceHistoryManager attendanceHistoryManager;
	private AppLogManager appLogManager;
	
	public void setAppLogManager(AppLogManager appLogManager) {
		this.appLogManager = appLogManager;
	}
	public void setAttendanceDao(AttendanceDao attendanceDao) {
		this.attendanceDao = attendanceDao;
	}
	public void setAttachmentManager(AttachmentManager attachmentManager) {
		this.attachmentManager = attachmentManager;
	}
	public void setUserMessageManager(UserMessageManager userMessageManager) {
		this.userMessageManager = userMessageManager;
	}
	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}
	
	public void setAttendanceHistoryManager(
			AttendanceHistoryManager attendanceHistoryManager) {
		this.attendanceHistoryManager = attendanceHistoryManager;
	}
	
	@Override
	// SZP 客开，校验签退时间是否大于工作结束时间
	public String isCheckSignout() throws BusinessException {
		
		// 签退时间
		Date signoutTime = Datetimes.parseNoTimeZone(Datetimes.format(new Date(), Datetimes.datetimeWithoutSecondStyle), Datetimes.datetimeWithoutSecondStyle);
		
		// 工作时间
		String requiredSignin = AttendanceUtil.getWorkEndTime(AppContext.getCurrentUser().getLoginAccount());
        String nowStr = Datetimes.formatNoTimeZone(new Date(),Datetimes.dateStyle);
		Date workEndTime = Datetimes.parseNoTimeZone(nowStr+ " " +requiredSignin, Datetimes.datetimeWithoutSecondStyle);
		
		// 如果签退时间早于下班时间
		if(signoutTime.compareTo(workEndTime) < 0){
			LOGGER.info(String.format("签退打卡: [%s] 下班时间-%s 签退时间-%s", AppContext.getCurrentUser().getLoginName(),workEndTime.toString(),signoutTime.toString()));
			return "0";
		}
		return "1";
	}
	/**
     * {@inheritDoc}
     */
    @Override
    public Map<String, Object> savePunchcardData(String remark, int source) throws BusinessException {

        HashMap<String, Object> params = new HashMap<String, Object>();
        params.put("signTime", Datetimes.parseNoTimeZone(Datetimes.format(new Date(), Datetimes.datetimeStyle), Datetimes.datetimeStyle));
        params.put("remark", remark);
        params.put("sign", AppContext.getRemoteAddr());
        
        // 参数设置打卡来源
        params.put("source", AttendanceSourceEnum.PC);
        
        // 参数设置打卡类型
        params.put("type", AttendanceType.getByKey(source));
        
        // 设置规定打卡时间
        if(source==AttendanceType.attend.getKey()){
            params.put("fixTime", AttendanceUtil.getWorkBeginTime(AppContext.getCurrentUser().getLoginAccount()));
        }else if(source==AttendanceType.leave.getKey()){
            params.put("fixTime", AttendanceUtil.getWorkEndTime(AppContext.getCurrentUser().getLoginAccount()));
        }
        
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            this.saveAttendance(params, AppContext.getCurrentUser());
            result.put("success", true);
        } catch (ValidateException e) {
        	//这是输入有效性的校验异常，直接返回给前台用户即可
            result.put("success", false);
            result.put("error_msg", e.getLocalizedMessage());
        }
        return result;
    }
    
	@Override
	public AttendanceInfo saveAttendance(Map<String, Object> params,User currentUser)
			throws BusinessException,ValidateException {
		//add by wfj 2018-10-22 数据来源为移动端数据   且打卡类型为签到 1  和签退2    则不写入数据库，保留外勤功能 start
		//移动端打卡 屏蔽
				//签到来源 : PC or Mobile
						AttendanceSourceEnum source = null;							
						try {
							source = (AttendanceSourceEnum) params.get("source");
							if(source == AttendanceSourceEnum.mobile){
								AttendanceType  type= (AttendanceType) params.get("type");
								if(type!=AttendanceType.outer) {
									
									throw new ValidateException("移动端不允许执行此操作");
								}
								
							}
						} catch (ClassCastException e) {
							throw new ValidateException(ResourceUtil.getString("attendance.message.ex18"));
						}
													
						// end  wfj 2018-10-22
		AttendanceInfo attend = new AttendanceInfo();
		attend.setNewId();
		/**-------获取参数信息并校验有效性,初始化签到信息并保存------*/
		this.saveAttendanceInfo(params, currentUser, attend);
		/**------------存储At信息 && 发送消息-------------------------*/
		this.saveAttendanceAt(currentUser, attend);
		/**-------保存附件关联（如果上传过附件的话）------*/
		this.saveAttachmentFile(params, attend);
		return attend;
	}
	
	@SuppressWarnings("unchecked")
	private void saveAttachmentFile(Map<String, Object> params,
			AttendanceInfo attend) {
		if(params.containsKey("fileIds")){
			List<Object> files = (List<Object>) params.get("fileIds");
			Long[] arrs = new Long[files.size()];
			for (int i = 0; i < files.size(); i++) {
				arrs[i] = Long.valueOf(files.get(i).toString());
			}
			if(CollectionUtils.isNotEmpty(files)){
	    		attachmentManager.create(arrs, ApplicationCategoryEnum.attendance, attend.getId(), attend.getId());
	    	}
		}
	}
	private void saveAttendanceAt(User currentUser, AttendanceInfo attend)
			throws BusinessException {
		if(StringUtils.isNotBlank(attend.getReceiveIds())){
			/**-------签到＠他人-------*/
			String[] atIds = attend.getReceiveIds().split(",");
			List<AttendanceAt> atList = new ArrayList<AttendanceAt>();
			for (String string : atIds) {
				AttendanceAt at = new AttendanceAt();
				at.setIdIfNew();
				at.setAtOrgId(Long.valueOf(string));
				at.setAttendanceId(attend.getId());
				atList.add(at);
			}
			attendanceDao.saveAllAt(atList);
			
			/**--------发送消息--------*/
			List<Long> sendToIds = new ArrayList<Long>();
			String[]  receviers = attend.getReceiveIds().split(",");
			for(String recevier:receviers){
				sendToIds.add(Long.valueOf(recevier));
			}
			MessageContent messageContent =  MessageContent.get("attendance.message.at", new Object[] { currentUser.getName()});
			Collection<MessageReceiver> msgReceiver = MessageReceiver.getReceivers(attend.getId(),sendToIds,"message.link.attendance.msgAt",attend.getId());
			userMessageManager.sendSystemMessage(messageContent,ApplicationCategoryEnum.attendance,currentUser.getId(),msgReceiver);
		}
	}
	
	@Override
	public AttendanceInfo updateAttendance(Map<String, Object> params,User currentUser)
			throws BusinessException,ValidateException, CloneNotSupportedException {
		//add by wfj 2018-10-22 数据来源为移动端数据   且打卡类型为签到 1  和签退2    则不写入数据库，保留外勤功能 start
		//移动端打卡屏蔽
		//签到来源 : PC or Mobile
				AttendanceSourceEnum source = null;							
				try {
					source = (AttendanceSourceEnum) params.get("source");
					if(source == AttendanceSourceEnum.mobile){
						AttendanceType  type= (AttendanceType) params.get("type");
						if(type!=AttendanceType.outer) {
							
							throw new ValidateException("移动端不允许执行此操作");
						}
						
					}
				} catch (ClassCastException e) {
					throw new ValidateException(ResourceUtil.getString("attendance.message.ex18"));
				}
											
				// end  wfj 2018-10-22
		Long attendanceId = ParamUtil.getLong(params, "attendanceId",0L);
		AttendanceInfo attend = attendanceDao.getAttendanceInfoById(attendanceId);
		//修改签到,存储签到历史记录
		this.saveAttendanceHistory(attend);
		/**------获取参数信息并校验有效性,初始化签到信息------*/
		AttendanceInfo info = this.initAttendanceInfo(params, currentUser, attend);
		attendanceDao.save(info);
		/**删除历史的@at人员信息*/
		attendanceDao.deleteAtByAttendId(attendanceId);
		/**------------存储新的@At人员信息 && 发送消息-------------------------*/
		this.saveAttendanceAt(currentUser, info);
		/**删除历史附件*/
		attachmentManager.deleteByReference(attendanceId);
		/**-------保存附件关联（如果上传过附件的话）------*/
		this.saveAttachmentFile(params, info);
		/**-------删除历史的签到数据,迂回解决签到修改at同一人,历史记录不能穿透的问题*/
		this.deleteAttendanceById(attendanceId);
		AttendanceType t = AttendanceType.getByKey(attend.getType());
		//记录应用日志
		appLogManager.insertLog(currentUser, AttendanceLogAction.Attendance_update.getLogId(),currentUser.getName(),t.getValue());
		return attend;
	}
	
	/**
	 * @param 
	 * @return		
	*/
	private void deleteAttendanceById(Long attendanceId) {
		attendanceDao.deleteAttendanceById(attendanceId);
	}
	/**
	 * 更新签到信息
	 * @param 
	 * @return		
	 * @throws WorkTimeSetExecption 
	 * @throws ValidateException 
	 * @throws CloneNotSupportedException 
	*/
	private AttendanceInfo initAttendanceInfo(Map<String, Object> params,
			User currentUser, AttendanceInfo attend) throws WorkTimeSetExecption, ValidateException, CloneNotSupportedException {
		//签到人
		Long ownerId = currentUser.getId();				
		//签到人所属部门
		Long deptId	 = currentUser.getDepartmentId(); 	
		//签到人登录单位ID
		Long accountId = currentUser.getLoginAccount();	
		//签到时间
		Date signTime = null;							
		try {
			signTime = (Date) params.get("signTime");
			if(signTime == null){
				throw new ValidateException(ResourceUtil.getString("attendance.message.ex13"));
			}
		} catch (ClassCastException e) {
			throw new ValidateException(ResourceUtil.getString("attendance.message.ex14"));
		}
		//签到备注
		String remark = ParamUtil.getString(params, "remark", ""); 	
		if(Strings.isNotBlank(remark) && remark.length() > 140){
			throw new ValidateException(ResourceUtil.getString("attendance.message.ex15", String.valueOf(remark.length())));
		}
		//签到地址：PC为IP，移动为具体地址
		String sign = ParamUtil.getString(params, "sign", null);	
		if(Strings.isBlank(sign)){
			throw new ValidateException(ResourceUtil.getString("attendance.message.ex16"));
		}
		//签到来源 : PC or Mobile
		AttendanceSourceEnum source = null;							
		try {
			source = (AttendanceSourceEnum) params.get("source");
			if(source == null){
				throw new ValidateException(ResourceUtil.getString("attendance.message.ex17"));
			}
		} catch (ClassCastException e) {
			throw new ValidateException(ResourceUtil.getString("attendance.message.ex18"));
		}
		//签到类型 : 外勤、签到、签退
		AttendanceType type = null;									
		try {
			type = (AttendanceType) params.get("type");
		} catch (ClassCastException e) {
			throw new ValidateException(ResourceUtil.getString("attendance.message.ex19"));
		}
		if(type == null){
			throw new ValidateException(ResourceUtil.getString("attendance.message.ex20"));
		}
		//规定打卡时间
		String fixTime = ParamUtil.getString(params, "fixTime", null);
		
		
		if (type.equals(AttendanceType.attend)) {
			//设置规定打卡时间
			if(Strings.isBlank(fixTime)){
				fixTime = AttendanceUtil.getWorkBeginTime(AppContext.getCurrentUser().getLoginAccount());
			}
		}
		if(type.equals(AttendanceType.leave)){
			//设置规定签退时间
			if(Strings.isBlank(fixTime)){
				fixTime = AttendanceUtil.getWorkEndTime(AppContext.getCurrentUser().getLoginAccount());
			}
		}
		
		//经度
		String longitude = ParamUtil.getString(params, "longitude", null); 		
		if(	Strings.isBlank(longitude) && 
			(source.equals(AttendanceSourceEnum.mobile))){
			throw new ValidateException(ResourceUtil.getString("attendance.message.ex24"));
		}
		//纬度
		String latitude = ParamUtil.getString(params, "latitude", null);		
		if(	Strings.isBlank(latitude) && 
				(source.equals(AttendanceSourceEnum.mobile))){
			throw new ValidateException(ResourceUtil.getString("attendance.message.ex25"));
		}
		//定位大陆（洲）
		String continent = ParamUtil.getString(params, "continent", null);		
		//定位国家
		String country = ParamUtil.getString(params, "country", null);			
		//定位省份
		String province = ParamUtil.getString(params, "province", null);		
		//定位城市
		String city = ParamUtil.getString(params, "city", null);				
		//定位区县
		String town = ParamUtil.getString(params, "town", null);				
		//定位街道
		String street = ParamUtil.getString(params, "street", null);			
		//定位附近地址
		String nearAddress = ParamUtil.getString(params, "nearAddress", null);	
		//签到年
		Integer year = MapUtils.getInteger(params, "year");		
		if(year == null){
			year = DateUtil.getYear(signTime);
		}
		//签到月
		Integer month = MapUtils.getInteger(params, "month");  	
		if(month == null){
			month = DateUtil.getMonth(signTime);
		}
		//签到日
		Integer day = MapUtils.getInteger(params, "day");		
		if(day == null){
			day = DateUtil.getDay(signTime);
		}
		//＠他人ID，多人则用","逗号隔开
		String receiveIds = ParamUtil.getString(params, "receiveIds", null); 
		//上传的图片数量
		Integer imgNum = MapUtils.getInteger(params, "imgNum", 0);
		//上传的语音文件数量
		Integer recordNum = MapUtils.getInteger(params, "recordNum", 0);
		//语音信息
		String recordInfo = MapUtils.getString(params,"recordInfo","");
		
		/**-------设置签到对应的值------*/
		AttendanceInfo info = new AttendanceInfo();
		info.setNewId();
		info.setOwnerId(ownerId);
		info.setDeptId(deptId);
		info.setAccountId(accountId);
		info.setSignTime(signTime);
		info.setRemark(remark);
		info.setSign(sign);
		info.setSource(source.getKey());
		info.setLongitude(longitude);
		info.setLatitude(latitude);
		info.setContinent(continent);
		info.setCountry(country);
		info.setProvince(province);
		info.setCity(city);
		info.setTown(town);
		info.setStreet(street);
		info.setNearAddress(nearAddress);
		info.setYear(year);
		info.setMonth(month);
		info.setDay(day);
		info.setFixTime(fixTime);
		info.setType(type.getKey());
		info.setReceiveIds(receiveIds);
		info.setImgNum(imgNum);
		info.setRecordNum(recordNum);
		info.setRecordInfo(recordInfo);
		List<Long> accounts = new ArrayList<Long>();
		accounts.add(accountId);
		//是否是工作日
		info.setWorkDay(AttendanceUtil.isWorkDay(Datetimes.parseNoTimeZone(Datetimes.format(new Date(), Datetimes.datetimeStyle), Datetimes.datetimeStyle),
				accounts).get(accountId));
		//修改次数
		info.setModifyNum(attend.getModifyNum()+1);
		/**----------------更新签到信息-----------------------*/
		attendanceDao.save(info);
		return info;
	}
	private void saveAttendanceInfo(Map<String, Object> params,
			User currentUser, AttendanceInfo attend) throws ValidateException,
			WorkTimeSetExecption {
		//签到人
		Long ownerId = currentUser.getId();				
		//签到人所属部门
		Long deptId	 = currentUser.getDepartmentId(); 	
		//签到人登录单位ID
		Long accountId = currentUser.getLoginAccount();	
		//签到时间
		Date signTime = null;							
		try {
			signTime = (Date) params.get("signTime");
			if(signTime == null){
				throw new ValidateException(ResourceUtil.getString("attendance.message.ex13"));
			}
		} catch (ClassCastException e) {
			throw new ValidateException(ResourceUtil.getString("attendance.message.ex14"));
		}
		//签到备注
		String remark = ParamUtil.getString(params, "remark", ""); 	
		if(Strings.isNotBlank(remark) && remark.length() > 140){
			throw new ValidateException(ResourceUtil.getString("attendance.message.ex15", String.valueOf(remark.length())));
		}
		//签到地址：PC为IP，移动为具体地址
		String sign = ParamUtil.getString(params, "sign", null);	
		if(Strings.isBlank(sign)){
			throw new ValidateException(ResourceUtil.getString("attendance.message.ex16"));
		}
		//签到来源 : PC or Mobile
		AttendanceSourceEnum source = null;							
		try {
			source = (AttendanceSourceEnum) params.get("source");
			if(source == null){
				throw new ValidateException(ResourceUtil.getString("attendance.message.ex17"));
			}
		} catch (ClassCastException e) {
			throw new ValidateException(ResourceUtil.getString("attendance.message.ex18"));
		}
		//签到类型 : 外勤、签到、签退
		AttendanceType type = null;									
		try {
			type = (AttendanceType) params.get("type");
		} catch (ClassCastException e) {
			throw new ValidateException(ResourceUtil.getString("attendance.message.ex19"));
		}
		if(type == null){
			throw new ValidateException(ResourceUtil.getString("attendance.message.ex20"));
		}
		//规定打卡时间
		String fixTime = ParamUtil.getString(params, "fixTime", null);
		
		
		if (type.equals(AttendanceType.attend)) {
			int isAttend = attendanceDao.countByType(currentUser.getId(),AttendanceType.attend, Datetimes.getTodayFirstTimeNoTimeZone(),Datetimes.getTodayLastTimeNoTimeZone());
			if(isAttend > 0){
				throw new ValidateException(ResourceUtil.getString("attendance.message.ex21"));
			}
			int isLeave = attendanceDao.countByType(currentUser.getId(),AttendanceType.leave, Datetimes.getTodayFirstTimeNoTimeZone(),Datetimes.getTodayLastTimeNoTimeZone());
			if (isLeave > 0) {
				throw new ValidateException(ResourceUtil.getString("attendance.message.ex22"));
			}
			//设置规定打卡时间
			if(Strings.isBlank(fixTime)){
				fixTime = AttendanceUtil.getWorkBeginTime(AppContext.getCurrentUser().getLoginAccount());
			}
		}
		if(type.equals(AttendanceType.leave)){
			int isLeave = attendanceDao.countByType(currentUser.getId(),AttendanceType.leave, Datetimes.getTodayFirstTimeNoTimeZone(),Datetimes.getTodayLastTimeNoTimeZone());
			if (isLeave > 0) {
				throw new ValidateException(ResourceUtil.getString("attendance.message.ex23"));
			}
			//设置规定签退时间
			if(Strings.isBlank(fixTime)){
				fixTime = AttendanceUtil.getWorkEndTime(AppContext.getCurrentUser().getLoginAccount());
			}
		}
		
		//经度
		String longitude = ParamUtil.getString(params, "longitude", null); 		
		if(	Strings.isBlank(longitude) && 
			(source.equals(AttendanceSourceEnum.mobile))){
			throw new ValidateException(ResourceUtil.getString("attendance.message.ex24"));
		}
		//纬度
		String latitude = ParamUtil.getString(params, "latitude", null);		
		if(	Strings.isBlank(latitude) && 
				(source.equals(AttendanceSourceEnum.mobile))){
			throw new ValidateException(ResourceUtil.getString("attendance.message.ex25"));
		}
		//定位大陆（洲）
		String continent = ParamUtil.getString(params, "continent", null);		
		//定位国家
		String country = ParamUtil.getString(params, "country", null);			
		//定位省份
		String province = ParamUtil.getString(params, "province", null);		
		//定位城市
		String city = ParamUtil.getString(params, "city", null);				
		//定位区县
		String town = ParamUtil.getString(params, "town", null);				
		//定位街道
		String street = ParamUtil.getString(params, "street", null);			
		//定位附近地址
		String nearAddress = ParamUtil.getString(params, "nearAddress", null);	
		//签到年
		Integer year = MapUtils.getInteger(params, "year");		
		if(year == null){
			year = DateUtil.getYear(signTime);
		}
		//签到月
		Integer month = MapUtils.getInteger(params, "month");  	
		if(month == null){
			month = DateUtil.getMonth(signTime);
		}
		//签到日
		Integer day = MapUtils.getInteger(params, "day");		
		if(day == null){
			day = DateUtil.getDay(signTime);
		}
		//＠他人ID，多人则用","逗号隔开
		String receiveIds = ParamUtil.getString(params, "receiveIds", null); 
		//上传的图片数量
		Integer imgNum = MapUtils.getInteger(params, "imgNum", 0);
		//上传的语音文件数量
		Integer recordNum = MapUtils.getInteger(params, "recordNum", 0);
		//语音信息
		String recordInfo = MapUtils.getString(params,"recordInfo","");
		
		/**-------设置签到对应的值------*/
		attend.setOwnerId(ownerId);
		attend.setDeptId(deptId);
		attend.setAccountId(accountId);
		attend.setSignTime(signTime);
		attend.setRemark(remark);
		attend.setSign(sign);
		attend.setSource(source.getKey());
		attend.setLongitude(longitude);
		attend.setLatitude(latitude);
		attend.setContinent(continent);
		attend.setCountry(country);
		attend.setProvince(province);
		attend.setCity(city);
		attend.setTown(town);
		attend.setStreet(street);
		attend.setNearAddress(nearAddress);
		attend.setYear(year);
		attend.setMonth(month);
		attend.setDay(day);
		attend.setFixTime(fixTime);
		attend.setType(type.getKey());
		attend.setReceiveIds(receiveIds);
		attend.setImgNum(imgNum);
		attend.setRecordNum(recordNum);
		attend.setRecordInfo(recordInfo);
		List<Long> accounts = new ArrayList<Long>();
		accounts.add(accountId);
		//是否是工作日
		attend.setWorkDay(AttendanceUtil.isWorkDay(Datetimes.parseNoTimeZone(Datetimes.format(new Date(), Datetimes.datetimeStyle), Datetimes.datetimeStyle),
				accounts).get(accountId));
		attend.setModifyNum(0);
		attendanceDao.save(attend);
	}
	/**
	 * 修改签到,存储签到历史记录
	 * @param 
	 * @return
	 */
	private void saveAttendanceHistory(AttendanceInfo attend) {
		AttendanceHistory history = new AttendanceHistory();

		/**-------设置签到对应的值------*/
		history.setIdIfNew();
		history.setOwnerId(attend.getOwnerId());
		history.setDeptId(attend.getDeptId());
		history.setAccountId(attend.getAccountId());
		history.setSignTime(attend.getSignTime());
		history.setRemark(attend.getRemark());
		history.setSign(attend.getSign());
		history.setSource(attend.getSource());
		history.setLongitude(attend.getLongitude());
		history.setLatitude(attend.getLatitude());
		history.setContinent(attend.getContinent());
		history.setCountry(attend.getCountry());
		history.setProvince(attend.getProvince());
		history.setCity(attend.getCity());
		history.setTown(attend.getTown());
		history.setStreet(attend.getStreet());
		history.setNearAddress(attend.getNearAddress());
		history.setYear(attend.getYear());
		history.setMonth(attend.getMonth());
		history.setDay(attend.getDay());
		history.setFixTime(attend.getFixTime());
		history.setType(attend.getType());
		history.setReceiveIds(attend.getReceiveIds());
		history.setImgNum(attend.getImgNum());
		history.setRecordNum(attend.getRecordNum());
		history.setRecordInfo(attend.getRecordInfo());
		//存储历史签到记录
		attendanceHistoryManager.saveAttendanceHistory(history);
	}
	
	@Override
	public List<AttendanceInfoVO> getCurrentAttendance(FlipInfo flipInfo) throws BusinessException {
		//组织查询条件
		Map<String,Object> params = new HashMap<String, Object>();
		params.put(AttendanceQueryParam.memberId.name(), AppContext.currentUserId());
		params.put(AttendanceQueryParam.startTime.name(), Datetimes.getTodayFirstTimeNoTimeZone());
		params.put(AttendanceQueryParam.endTime.name(), Datetimes.getTodayLastTimeNoTimeZone());
		flipInfo.setParams(params);
		//查询
		List<AttendanceInfo> attendanceInfos = attendanceDao.findAttenDanceByPage(flipInfo);
		List<AttendanceInfoVO> attendanceInfoVOs = new ArrayList<AttendanceInfoVO>();
		for(AttendanceInfo attendanceInfo : attendanceInfos){
			attendanceInfoVOs.add(AttendanceUtil.convertAttendancePO2VO(attendanceInfo));
		}
		return attendanceInfoVOs;
	}

	@Override
	public List<AttendanceInfoVO> getMyAttendance(Map<String,Object> params,FlipInfo flipInfo) throws BusinessException {
		//查询条件
		String startTime = ParamUtil.getString(params, AttendanceQueryParam.startTime.name());
		String endTime = ParamUtil.getString(params, AttendanceQueryParam.endTime.name());
		Long ownerId = ParamUtil.getLong(params, AttendanceQueryParam.memberId.name());
		Integer type = ParamUtil.getInt(params, AttendanceQueryParam.type.name());
		Map<String,Object> queryParams = new HashMap<String, Object>();
		if(ownerId != null){
			queryParams.put(AttendanceQueryParam.memberId.name(), ownerId);
		}else{
			queryParams.put(AttendanceQueryParam.memberId.name(), AppContext.currentUserId());
		}
		if(startTime != null) queryParams.put(AttendanceQueryParam.startTime.name(), Datetimes.parseNoTimeZone(startTime, Datetimes.datetimeStyle));
		if(endTime != null) queryParams.put(AttendanceQueryParam.endTime.name(), Datetimes.parseNoTimeZone(endTime,Datetimes.datetimeStyle));
		if(type != null) queryParams.put(AttendanceQueryParam.type.name(),type);
		flipInfo.setParams(queryParams);
		//查询
		List<AttendanceInfo> attendanceInfos = attendanceDao.findAttenDanceByPage(flipInfo);
		List<AttendanceInfoVO> attendanceInfoVOs = new ArrayList<AttendanceInfoVO>();
		for(AttendanceInfo attendanceInfo : attendanceInfos){
			attendanceInfoVOs.add(AttendanceUtil.convertAttendancePO2VO(attendanceInfo));
		}
		return attendanceInfoVOs;
	}
	
	@Override
	public List<AttendanceInfo> findAttendanceInfo(Map<String, Object> params) {
		return attendanceDao.findAttenDanceInfoData(new FlipInfo(-1,-1),params);
	}
	@Override
	public FlipInfo findStaffAttendanceInfoData(FlipInfo fi, Map<String, Object> params)
			throws BusinessException, ParseException {
		//默认都是在当前登录单位下
		params.put(AttendanceQueryParam.accountId.name(), AppContext.getCurrentUser().getLoginAccount());
		
		String selectRange = ParamUtil.getString(params, AttendanceQueryParam.selectRange.name());
		params.remove(AttendanceQueryParam.selectRange.name());
		
		/**
		 * 选择的是部门
		 */
		String departmentId = ParamUtil.getString(params,AttendanceQueryParam.departmentId.name());
		OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
		// 客开 赵辉 查询所有子部门并获取所有部门及子部门下的考勤明细 start
//		if(!departmentId.equals("")){
//			List<V3xOrgDepartment> departments = orgManager.getChildDepartments(Long.valueOf(departmentId.split("\\|")[1]),false);
//			for (V3xOrgDepartment v3xOrgDepartment : departments) {
//				departmentId +=","+"Department|"+v3xOrgDepartment.getId();
//			}
//		}
				if(departmentId!=null&&!"".equals(departmentId)){
					String[] deptIdArray = departmentId.split(",");
					List<String> deptIdlist=new ArrayList<String>();
					for (int i = 0; i < deptIdArray.length; i++) {
						String deptId=deptIdArray[i];
						if(!deptIdlist.contains(deptId)) {
							List<V3xOrgDepartment> departments = orgManager.getChildDepartments(Long.valueOf(deptId.split("\\|")[1]),false);
							if(departments!=null&&departments.size()>0) {
								for (V3xOrgDepartment v3xOrgDepartment : departments) {
									if(!deptIdlist.contains("Department|"+v3xOrgDepartment.getId())) {
									deptIdlist.add("Department|"+v3xOrgDepartment.getId());
									}
								}
							}
							deptIdlist.add(deptId);
						}
					}
					if(deptIdlist!=null&&deptIdlist.size()>0) {
						departmentId=deptIdlist.get(0);
						for (int i = 1; i < deptIdlist.size(); i++) {
							departmentId +=","+deptIdlist.get(i);
						}
					}
					
				}
		// 客开 赵辉 查询所有子部门并获取所有部门及子部门下的考勤明细  end
		params.remove(AttendanceQueryParam.departmentId.name());
		if(AttendanceQueryParam.selectDept.name().equals(selectRange)){
			params.put(AttendanceQueryParam.departmentId.name(), AttendanceUtil.parseStringToList(departmentId));
		}
		
		/**
		 * 选择全部,部门管理员
		 */
		boolean isDept = Boolean.parseBoolean(ParamUtil.getString(params,"isDept"));
		if(isDept && AttendanceQueryParam.selectAll.name().equals(selectRange)){
			//部门管理员
			String departmentsEle = ParamUtil.getString(params, "departmentEle");
			params.remove("departmentEle");
			params.remove("isDept");
			List<Long> departmentIds = AttendanceUtil.parseStringToList(departmentsEle);
			/**
			 * 查询所有子部门
			 */
			List<Long> depts = new ArrayList<Long>();
			depts.addAll(departmentIds);
			for(int i = 0;i<departmentIds.size();i++){
				List<V3xOrgDepartment> childDept = orgManager.getChildDepartments(departmentIds.get(i), false);
				if(CollectionUtils.isNotEmpty(childDept)){
					for(int j = 0;j<childDept.size();j++){
						depts.add(childDept.get(j).getId());
					}
				}
			}
			params.put(AttendanceQueryParam.departmentId.name(),depts);
		}
		/**
		 * 选择的是人员
		 */
		String memberId = ParamUtil.getString(params,AttendanceQueryParam.memberId.name());
		params.remove(AttendanceQueryParam.memberId.name());
		if(AttendanceQueryParam.selectMember.name().equals(selectRange)){
			params.put(AttendanceQueryParam.memberId.name(), AttendanceUtil.parseStringToList(memberId));
		}
		//签到类型
		String type = ParamUtil.getString(params,AttendanceQueryParam.type.name());
		params.put(AttendanceQueryParam.type.name(), AttendanceUtil.parseSourceToList(type));
		/**
		 * 开始时间
		 */
		String startTime = ParamUtil.getString(params, AttendanceQueryParam.startTime.name());
		params.put(AttendanceQueryParam.startTime.name(), Datetimes.parseNoTimeZone(Datetimes.getFirstTimeStr(startTime.replaceAll("/", "-")),Datetimes.datetimeStyle));
		/**
		 * 结束时间
		 */
		String endTime = ParamUtil.getString(params, AttendanceQueryParam.endTime.name());
		params.put(AttendanceQueryParam.endTime.name(), Datetimes.parseNoTimeZone(Datetimes.getLastTimeStr(endTime.replaceAll("/", "-")),Datetimes.datetimeStyle));
		
		List<Map<String,Object>> data = attendanceDao.findAttenDanceInfo(fi,params);
		
		if(CollectionUtils.isNotEmpty(data)){
			for(int i = 0;i<data.size();i++){
				Map<String,Object> d = data.get(i);
				Date signTime = (Date) d.get(AttendanceStaffInfoTable.signtime.name());
				//转换处理下时间
				d.put(AttendanceStaffInfoTable.signtime.name(), AttendanceUtil.getClientDayWeek(signTime));
				int signtype = ParamUtil.getInt(d,AttendanceStaffInfoTable.signtype.name());
				d.put(AttendanceStaffInfoTable.signtype.name(),ResourceUtil.getString(AttendanceType.getByKey(signtype).getValue()));
				//转换规定时间
				String fixtime = ParamUtil.getString(d, AttendanceStaffInfoTable.fixtime.name());
				d.put(AttendanceStaffInfoTable.fixtime.name(), fixtime);
				V3xOrgMember member = orgManager.getMemberById(Long.valueOf(d.get("memberid").toString()));
				d.put(AttendanceStaffInfoTable.membername.name(), member.getName());
				//客开  wfj 20180925  部门列只显示一级部门名称 start
				V3xOrgDepartment dept = orgManager.getDepartmentById(member.getOrgDepartmentId());
				V3xOrgAccount account=orgManager.getAccountById(member.getOrgAccountId());
				if(dept != null){
//					account.getPath().length()+4
					if(dept.getPath().length()==(account.getPath().length()+4)) {
						d.put(AttendanceStaffInfoTable.departmentname.name(), OrgHelper.showDepartmentName(member.getOrgDepartmentId()));
					}else {
						if(dept.getPath().length()>(account.getPath().length()+4)) {
							String yjpath=dept.getPath().substring(0, account.getPath().length()+4);
							
							V3xOrgDepartment parentdept=orgManager.getDepartmentByPath(yjpath);
							d.put(AttendanceStaffInfoTable.departmentname.name(), parentdept.getName());

						}
					}
					
				}
//				d.put(AttendanceStaffInfoTable.departmentname.name(), OrgHelper.showDepartmentName(member.getOrgDepartmentId()));
				//客开  wfj 20180925 部门列只显示一级部门名称 end
				convertToStaffRowCells(d);
			}
		}
		fi.setData(data);
		return fi;
	}
	
	/**
	 * 员工考勤-表格数据组装
	 * @param 
	 * @return		
	*/
	private void convertToStaffRowCells(Map<String, Object> map) {
		for(AttendanceStaffInfoTable e:AttendanceStaffInfoTable.values()){
			String displayStr = ParamUtil.getString(map, e.name().toLowerCase());
			String display = StringUtils.defaultString(displayStr, ResourceUtil.getString(e.getDefaultText()));
			map.put(e.name(), display);
		}
	}
	
	@Override
	public FlipInfo findPersonAttendanceInfoData(FlipInfo fi, Map<String, Object> params)
			throws BusinessException, ParseException {
		//当前登录人员
		List<Long> memberIds = new ArrayList<Long>();
		memberIds.add(AppContext.currentUserId());
		params.put(AttendanceQueryParam.memberId.name(), memberIds);
		//签到类型
		String type = ParamUtil.getString(params,AttendanceQueryParam.type.name());
		params.put(AttendanceQueryParam.type.name(), AttendanceUtil.parseSourceToList(type));
		/**
		 * 开始时间
		 */
		String startTime = ParamUtil.getString(params, AttendanceQueryParam.startTime.name());
		params.put(AttendanceQueryParam.startTime.name(), Datetimes.parseNoTimeZone(Datetimes.getFirstTimeStr(startTime.replaceAll("/", "-")),Datetimes.datetimeStyle));
		/**
		 * 结束时间
		 */
		String endTime = ParamUtil.getString(params, AttendanceQueryParam.endTime.name());
		params.put(AttendanceQueryParam.endTime.name(), Datetimes.parseNoTimeZone(Datetimes.getLastTimeStr(endTime.replaceAll("/", "-")),Datetimes.datetimeStyle));
		/**
		 * 授权范围
		 */
		String range = ParamUtil.getString(params, "range");
		if(range != null && "auth".equals(range)){
			List<Long> scope = new ArrayList<Long>();
			List<Map<String,Object>> authScope = (List<Map<String, Object>>) params.get("scope");
			if(authScope != null && authScope.size() > 0){
				for(Map<String,Object> item : authScope){
					scope.add(Long.valueOf((String) item.get("id")));
				}
				params.put(AttendanceQueryParam.memberId.name(), scope);
			}
		}

		List<Map<String,Object>> data = attendanceDao.findAttenDanceInfo(fi,params);
		
		/**
		 * 表格内容
		 */
		if(CollectionUtils.isNotEmpty(data)){
			for(int i = 0;i<data.size();i++){
				Map<String,Object> d = data.get(i);
				Date signTime = (Date) d.get(AttendanceStaffInfoTable.signtime.name());
				//转换处理下时间
				d.put(AttendanceStaffInfoTable.signtime.name(), AttendanceUtil.getClientDayWeek(signTime));
				//签到时间-用于签到更新次数穿透
				d.put("time", Datetimes.formatNoTimeZone(signTime,Datetimes.dateStyle));
				int signtype = ParamUtil.getInt(d,AttendanceStaffInfoTable.signtype.name());
				d.put("type", signtype);
				//TODO
				d.put(AttendanceStaffInfoTable.signtype.name(),ResourceUtil.getString(AttendanceType.getByKey(signtype).getValue()));
				this.convertToPersonRowCells(d, params);
			}
		}
		fi.setData(data);
		return fi;
	}
	
	/**
	 * 个人明细-表格数据组装
	 * @param 
	 * @return		
	*/
	private void convertToPersonRowCells(Map<String, Object> map,
			Map<String, Object> params) {
		for(AttendancePersonInfoTable e:AttendancePersonInfoTable.values()){
			String displayStr = ParamUtil.getString(map, e.name().toLowerCase());
			String display = StringUtils.defaultString(displayStr, ResourceUtil.getString(e.getDefaultText()));
			map.put(e.name(), display);
		}
	}
	
	@Override
	public boolean deleteDateByRangeDate(String date) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(Datetimes.parseNoTimeZone(date, "yyyy-MM"));
		Date startTime = Datetimes.getFirstDayInMonth(cal.getTime(),Locale.getDefault());
		Date endTime = Datetimes.getLastDayInMonth(cal.getTime(),Locale.getDefault());
		return attendanceDao.deleteDateByRangeDate(startTime,endTime,AppContext.getCurrentUser().getLoginAccount());
	}
	
	@Override
	public String getDeleteEndTime(int range){
		AttendanceDateRange rangeDate = AttendanceDateRange.getRange(range);
		Date currentDate = DateUtil.currentDate();
		Date d = null;
		switch(rangeDate){
			case oneMonthBefore:
				//一月前
				d = DateUtil.addMonth(currentDate, -1); 
				break;
			case threeMonthBefore:
				//3月前
				d = DateUtil.addMonth(currentDate, -3); 
				break;
			case sixMonthBefore:
				//6月前
				d = DateUtil.addMonth(currentDate, -6); 
				break;
			case nineMonthBefore:
				d = DateUtil.addMonth(currentDate, -9); 
				break;
			case oneYearBefore:
				d = DateUtil.addYear(currentDate, -1); 
				break;
			case twoYearBefore:
				d = DateUtil.addYear(currentDate, -2);
				break;
			case threeYearBefore:
				d = DateUtil.addYear(currentDate, -3);
				break;
			case fiveYearBefore:
				d = DateUtil.addYear(currentDate, -5);
				break;
		}
		return Datetimes.formatNoTimeZone(d, "yyyy-MM");
	}
	
	@Override
	public Map<String,Object> checkDeleteRange(int range){
		String deleteEndDate = getDeleteEndTime(range);
		Date endTime = Datetimes.parseNoTimeZone(deleteEndDate, "yyyy-MM");
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("endTime", Datetimes.getLastDayInMonth(Datetimes.addMonth(endTime, -1),Locale.getDefault()));
		params.put("accountId", AppContext.getCurrentUser().getLoginAccount());
		Map<String,Object> ret = new HashMap<String,Object>();
		ret.put("exeistDelete", attendanceDao.checkDeleteRange(params));
		ret.put("endTime", deleteEndDate);
		return ret;
	}

	@Override
	public FlipInfo findMentionedMeAttendance(FlipInfo flipInfo,Map<String,Object> params) throws BusinessException {
		//组织查询条件
		Map<String,Object> queryParams = new HashMap<String, Object>();
		String memberName = ParamUtil.getString(params,AttendanceQueryParam.memberName.name());
		String startTime = ParamUtil.getString(params, AttendanceQueryParam.startTime.name());
		if(StringUtils.isNotBlank(startTime)){
			Date startDate = Datetimes.getFirstNoTimeZone(Datetimes.parseNoTimeZone(startTime, Datetimes.dateStyle));
			queryParams.put(AttendanceQueryParam.startTime.name(), startDate);
		}
		String endTime = ParamUtil.getString(params, AttendanceQueryParam.endTime.name());
		if(StringUtils.isNotBlank(endTime)){
			Date endDate = Datetimes.getLastTimeNoTimeZone(Datetimes.parseNoTimeZone(endTime, Datetimes.dateStyle));
			queryParams.put(AttendanceQueryParam.endTime.name(), endDate);
		}
		//默认查询的是当前人员的
		queryParams.put(AttendanceQueryParam.receiveIds.name(), AppContext.currentUserId());
		if(StringUtils.isNotBlank(memberName)){			
			queryParams.put(AttendanceQueryParam.memberName.name(),"%" + memberName + "%");
		}
		flipInfo.setParams(queryParams);
		
		//查询
		List<AttendanceInfo> attendanceInfos = attendanceDao.findAttenDanceByPage(flipInfo);
		List<AttendanceInfoVO> attendanceInfoVOs = new ArrayList<AttendanceInfoVO>();
		for(AttendanceInfo attendanceInfo : attendanceInfos){
			attendanceInfoVOs.add(AttendanceUtil.convertAttendancePO2VO(attendanceInfo));
		}
		flipInfo.setData(attendanceInfoVOs);
		return flipInfo;
	}
	
	@Override
	public void saveAttendanceRemind(int remindAttend,int remindLeave) {
		Long accountId = AppContext.getCurrentUser().getLoginAccount();
		Map<String,Object> params = new HashMap<String,Object>();
		List<Long> ids = new ArrayList<Long>();
		ids.add(accountId);
		params.put(AttendanceQueryParam.accountId.name(), ids);
		List<AttendanceRemind> rm = findAttendanceRemind(params);
		
		/**
		 * 1.不存在该单位的考勤提醒设置,则新创建一个
		 * 2.存在该单位的考勤提醒设置,则更新设置
		 */
		if(CollectionUtils.isEmpty(rm)){
			//新建
			AttendanceRemind remind = new AttendanceRemind();
			setRemind(remindAttend, remindLeave, remind);
			remind.setIdIfNew();
			remind.setAccountId(accountId);
			remind.setCreateId(AppContext.currentUserId());
			remind.setCreateTime(DateUtil.currentDate());
			attendanceDao.saveAttendanceRemind(remind);
			/**
			 * 上班打卡提醒
			 */
			attendRemindJob(accountId, remind);
			/**
			 * 下班打卡提醒
			 */
			leaveRemindJob(accountId,remind);
		}else{
			//更新
			AttendanceRemind remind = rm.get(0);
			remind.setUpdateId(AppContext.currentUserId());
			remind.setUpdateTime(DateUtil.currentDate());
			setRemind(remindAttend, remindLeave, remind);
			attendanceDao.updateAttendanceRemind(remind);
			/**
			 * 上班打卡提醒
			 */
			attendRemindJob(accountId, remind);
			/**
			 * 下班打卡提醒
			 */
			leaveRemindJob(accountId,remind);
		}
	}
	
	/**
	 * 下班签退消息提醒
	 * @param 
	 * @return		
	*/
	private void leaveRemindJob(Long accountId, AttendanceRemind remind) {
		if(AttendanceRemindEnum.remind.getKey() == remind.getLeaveRemind()){
			int time = remind.getLeaveRemindTime();
			try {
				LeaveRemindTask.createQuartJob(LeaveRemindTask.initRemindTask(time, accountId));
			} catch (MutiQuartzJobNameException e) {
				LOGGER.error("设置消息提醒创建定时任务异常...",e);
			} catch (NoSuchQuartzJobBeanException e) {
				LOGGER.error("设置消息提醒创建定时任务异常...",e);
			}
		}else{
			//删除掉老的提醒任务
			LeaveRemindTask.deleteRemindJob(accountId);
		}
	}
	
	/**
	 * 上班签到消息提醒
	 * @param 
	 * @return
	 */
	private void attendRemindJob(Long accountId, AttendanceRemind remind) {
		if(AttendanceRemindEnum.remind.getKey() == remind.getAttendRemind()){
			int time = remind.getAttendRemindTime();
			try {
				AttendRemindTask.createQuartJob(AttendRemindTask.initRemindTask(time, accountId));
			} catch (MutiQuartzJobNameException e) {
				LOGGER.error("设置消息提醒创建定时任务异常...",e);
			} catch (NoSuchQuartzJobBeanException e) {
				LOGGER.error("设置消息提醒创建定时任务异常...",e);
			}
		}else{
			AttendRemindTask.deleteRemindJob(accountId);
		}
	}
	
	/**
	 * 设置上班签到和下班签退提醒
	 * @param 
	 * @return
	 */
	private void setRemind(int remindAttend, int remindLeave,
			AttendanceRemind remind) {
		/**
		 * 上班签到设置
		 */
		if(AttendanceRemindEnum.noRemind.getKey() == remindAttend){
			//不提醒
			remind.setAttendRemind(remindAttend);
			remind.setAttendRemindTime(AttendanceRemindTimeEnum.before0.getKey());
		}else{
			//提醒
			remind.setAttendRemind(AttendanceRemindEnum.remind.getKey());
			remind.setAttendRemindTime(AttendanceRemindTimeEnum.getByKey(remindAttend).getTime());
		}
		
		/**
		 * 下班签退
		 */
		if(AttendanceRemindEnum.noRemind.getKey() == remindLeave){
			//不提醒
			remind.setLeaveRemind(remindLeave);
			remind.setLeaveRemindTime(AttendanceRemindTimeEnum.before0.getKey());
		}else{
			//提醒
			remind.setLeaveRemind(AttendanceRemindEnum.remind.getKey());
			remind.setLeaveRemindTime(AttendanceRemindTimeEnum.before0.getTime());
		}
	}
	
	@Override
	public List<AttendanceRemind> findAttendanceRemind(Map<String,Object> params) {
		return attendanceDao.findAttendanceRemind(params);
	}

	@Override
	public Map<String, Object> checkAuthForAttendance() throws BusinessException {
		int attendTimes = attendanceDao.countByType(AppContext.currentUserId(),AttendanceType.attend,Datetimes.getTodayFirstTimeNoTimeZone(),Datetimes.getTodayLastTimeNoTimeZone());
		int leaveTimes = attendanceDao.countByType(AppContext.currentUserId(),AttendanceType.leave,Datetimes.getTodayFirstTimeNoTimeZone(),Datetimes.getTodayLastTimeNoTimeZone());
		Map<String,Object> result = new HashMap<String, Object>();
		result.put("attend",attendTimes <= 0);
		result.put("leave",leaveTimes <= 0);
		result.put("showSetting", Functions.isRole(OrgConstants.Role_NAME.AttendanceAdmin.name(),AppContext.getCurrentUser()));
		return result;
	}

	@Override
	public AttendanceInfoVO getAttendanceById(Long attendanceId) throws BusinessException {
		FlipInfo flipInfo = new FlipInfo();
		Map<String,Object> queryParams = new HashMap<String, Object>();
		queryParams.put(AttendanceQueryParam.id.name(),attendanceId);
		flipInfo.setParams(queryParams);
		//查询
		List<AttendanceInfo> attendanceInfos = attendanceDao.findAttenDanceByPage(flipInfo);
		if(attendanceInfos.isEmpty()){
			return null;
		}
		AttendanceInfoVO vo = AttendanceUtil.convertAttendancePO2VO(attendanceInfos.get(0));
		//附件
		List<Attachment> attachments = attachmentManager.getByReference(vo.getId());
		vo.setAttachmentList(attachments);
		return vo;
	}

	@Override
	public boolean removeAttendaceById(Long attendanceId) throws BusinessException {
		return attendanceDao.removeAttendanceById(attendanceId);
	}

	@Override
	public List<AttendanceInfo> getTodayAttendanceInfo(Long ownerId, AttendanceType type) throws BusinessException {
		Date now = new Date();
		String today = Datetimes.format(now, Datetimes.dateStyle);
		String firstTime = today + " 00:00:00";
		String lastTime = today + " 23:59:59";
		return attendanceDao.findByType(ownerId, type, Datetimes.parseNoTimeZone(firstTime, Datetimes.datetimeStyle), Datetimes.parseNoTimeZone(lastTime, Datetimes.datetimeStyle));
	}
	
	@Override
	public void saveAttendance(List<AttendanceInfo> data) {
		attendanceDao.saveAttendance(data);
	}
	
	
	@Override
	public String doRunBigData() throws BusinessException {
		if(StringUtils.isBlank(process)){
			process = ResourceUtil.getString("attendance.message.historydata");
			new Runnable() {
				public void run() {
					try {
						doRun();
					} catch (BusinessException e) {
						LOGGER.error("",e);
					}
				}
			}.run();
		}
		return process;
	}
	
	private String process = "";
	private String PROCESS_FORMATE = ResourceUtil.getString("attendance.message.saving");
	private void doRun() throws BusinessException{
		Long begin = new Date().getTime();
		
		List<V3xOrgMember> members = orgManager.getAllMembers(V3xOrgEntity.VIRTUAL_ACCOUNT_ID);
		int totalMember = members.size();
		
		//创建1年的移动端外勤数据
		if(CollectionUtils.isNotEmpty(members)){
			for(int i=0;i<members.size();i++){
				V3xOrgMember m = members.get(i);
				List<AttendanceInfo> data = new ArrayList<AttendanceInfo>();
				Date t = Datetimes.addYear(new Date(), -1);
				Date startTime = Datetimes.getFirstDayInYear(t,Locale.getDefault());
				Date endTime = Datetimes.getLastDayInYear(t,Locale.getDefault());
				while(startTime.compareTo(endTime) <= 0 ){
					String time = Datetimes.formatNoTimeZone(startTime, DateUtil.YEAR_MONTH_DAY_PATTERN);
					//外勤
					AttendanceInfo info = new AttendanceInfo();
					info.setNewId();
					info.setOwnerId(m.getId());
					info.setSignTime(Datetimes.parseNoTimeZone(time+" 08:50:12", DateUtil.YEAR_MONTH_DAY_HOUR_MINUTE_SECOND_PATTERN));
					info.setSource(AttendanceSourceEnum.mobile.getKey());
					info.setType(AttendanceType.outer.getKey());
					info.setLatitude("64.26");
					info.setLongitude("106.26");
					info.setDeptId(m.getOrgDepartmentId());
					info.setAccountId(m.getOrgAccountId());
					data.add(info);
					startTime = DateUtil.addDay(startTime, 1);
				}
				process = MessageFormat.format(PROCESS_FORMATE, "1",ResourceUtil.getString("attendance.label.fieldData"),i+1,totalMember);
				this.saveAttendance(data);
			}
			
			//创建3年的pc端签到签退数据
			for(int i=0;i<members.size();i++){
				V3xOrgMember m = members.get(i);
				List<AttendanceInfo> data = new ArrayList<AttendanceInfo>();
				Date l = Datetimes.addYear(new Date(), -3);
				Date startTime = Datetimes.getFirstDayInYear(l,Locale.getDefault());
				Date ll = Datetimes.addYear(new Date(), -1);
				Date endTime = Datetimes.getLastDayInYear(ll,Locale.getDefault());
				while(startTime.compareTo(endTime) <= 0 ){
					String time = Datetimes.formatNoTimeZone(startTime, DateUtil.YEAR_MONTH_DAY_PATTERN);
					//签到
					AttendanceInfo info = new AttendanceInfo();
					info.setNewId();
					info.setOwnerId(m.getId());
					info.setSignTime(Datetimes.parseNoTimeZone(time+" 09:50:12", DateUtil.YEAR_MONTH_DAY_HOUR_MINUTE_SECOND_PATTERN));
					info.setSource(AttendanceSourceEnum.PC.getKey());
					info.setType(AttendanceType.attend.getKey());
					info.setFixTime("9:00");
					info.setDeptId(m.getOrgDepartmentId());
					info.setAccountId(m.getOrgAccountId());
					data.add(info);
					
					//签退
					info = new AttendanceInfo();
					info.setNewId();
					info.setOwnerId(m.getId());
					info.setSignTime(Datetimes.parseNoTimeZone(time+" 05:40:12", DateUtil.YEAR_MONTH_DAY_HOUR_MINUTE_SECOND_PATTERN));
					info.setSource(AttendanceSourceEnum.PC.getKey());
					info.setType(AttendanceType.leave.getKey());
					info.setFixTime("6:00");
					info.setDeptId(m.getOrgDepartmentId());
					info.setAccountId(m.getOrgAccountId());
					data.add(info);
					startTime = DateUtil.addDay(startTime, 1);
				}
				process = MessageFormat.format(PROCESS_FORMATE, "3",ResourceUtil.getString("attendance.label.attendanceData"),i+1,totalMember);
				this.saveAttendance(data);
			}
		}
		Long end = new Date().getTime();
		process = ResourceUtil.getString("attendance.message.dispatchEnd",(end-begin)/(1000*60));
	}
	@Override
	public Date getEarliestSigntime(Long accountId) throws BusinessException{
		List result = this.attendanceDao.getEarliestSigntime(accountId);
		if(CollectionUtils.isNotEmpty(result)){
			return (Date) result.get(0);
		}else{			
			return null;
		}
	}

	@Override
	public List<Map<String,Object>> getTodayAttendanceByMemberIds(Map<String,Object> params) throws BusinessException {
		//查询条件
		Map<String,Object> queryParams = new HashMap<String, Object>();
		queryParams.put(AttendanceQueryParam.startTime.name(), Datetimes.getTodayFirstTime());
		queryParams.put(AttendanceQueryParam.endTime.name(), Datetimes.getTodayLastTime());
		List<Long> memberIds = (List<Long>) params.get(AttendanceQueryParam.memberId.name());
		queryParams.put(AttendanceQueryParam.memberId.name(),memberIds);
		List<Map<String,Object>> results = attendanceDao.getTodayAttendanceByMemberIds(queryParams);
		return results;
	}

	@Override
	public List<Map<String,Object>> getAuthorizeAttendance(FlipInfo flipInfo, Map<String, Object> params) throws BusinessException {
		//查询条件
		Map<String,Object> queryParams = new HashMap<String, Object>();
		String startTime = ParamUtil.getString(params, AttendanceQueryParam.startTime.name());
		String endTime = ParamUtil.getString(params, AttendanceQueryParam.endTime.name());
		if(startTime != null){
			queryParams.put(AttendanceQueryParam.startTime.name(), Datetimes.parseNoTimeZone(startTime, Datetimes.datetimeStyle));
		}else{
			queryParams.put(AttendanceQueryParam.startTime.name(), Datetimes.getTodayFirstTime());
		}
		if(endTime != null){
			queryParams.put(AttendanceQueryParam.endTime.name(), Datetimes.parseNoTimeZone(endTime,Datetimes.datetimeStyle));
		}else{
			queryParams.put(AttendanceQueryParam.endTime.name(), Datetimes.getTodayLastTime());
		}

		String signDate = ParamUtil.getString(params, "signDate");
		if(signDate != null){
			queryParams.put(AttendanceQueryParam.startTime.name(), Datetimes.parseNoTimeZone(signDate + " 00:00:00", Datetimes.datetimeStyle));
			queryParams.put(AttendanceQueryParam.endTime.name(), Datetimes.parseNoTimeZone(signDate + " 23:59:59", Datetimes.datetimeStyle));
		}

		String memberName = ParamUtil.getString(params,AttendanceQueryParam.memberName.name());
		if(StringUtils.isNotBlank(memberName)){
			queryParams.put(AttendanceQueryParam.memberName.name(),"%" + memberName + "%");
		}

		List<Long> memberIds = getAuthScopeUserIds();
		if(memberIds != null && memberIds.size() > 0){
			queryParams.put(AttendanceQueryParam.memberId.name(),memberIds);
		}else{
			return null;
		}

		flipInfo.setParams(queryParams);
		List<Map<String,Object>> results = attendanceDao.getAuthorAttendByPage(flipInfo);
		for(Map<String,Object> item : results){
			Long memberId = ParamUtil.getLong(item,"owner_id");
			V3xOrgMember member = orgManager.getMemberById(memberId);
			item.put("owner_name",member.getName());
			item.put("owner_img",OrgHelper.getAvatarImageUrl(memberId));
		}
		return results;
	}

	private List<Long> getAuthScopeUserIds() throws BusinessException{
		List<Long> ids = new ArrayList<Long>();
		User u = AppContext.getCurrentUser();
		Map<String,Object> authorScope = attendanceDao.getAuthorScope(u.getId(),u.getLoginAccount());
		if(authorScope != null && authorScope.get("scopeids") != null){
			Set<V3xOrgMember> scope = orgManager.getMembersByTypeAndIds((String) authorScope.get("scopeids"));
			Iterator<V3xOrgMember> it = scope.iterator();
			while (it.hasNext()){
				V3xOrgMember entry = it.next();
				ids.add(entry.getId());
			}
		}
		return ids;
	}

	@Override
	public List<Map<String,Object>> getAuthScopeMembers(/*FlipInfo fi, Map<String, Object> params*/) throws BusinessException{
		List<Map<String,Object>> results = new ArrayList<Map<String, Object>>();
		User u = AppContext.getCurrentUser();
		Map<String,Object> authorScope = attendanceDao.getAuthorScope(u.getId(),u.getLoginAccount());
		if(authorScope != null && authorScope.get("scopeids") != null){
			Set<V3xOrgMember> scope = orgManager.getMembersByTypeAndIds((String) authorScope.get("scopeids"));
			Iterator<V3xOrgMember> it = scope.iterator();
			while (it.hasNext()){
				V3xOrgMember entry = it.next();
				Map<String,Object> map = new HashMap<String, Object>();
				map.put("id",entry.getId());
				map.put("name",OrgHelper.showMemberName(entry));
				results.add(map);
			}
		}
		/*fi.setData(results);*/
		return results;
	}

	@Override
	public Map<String, Object> checkAuthScope() throws BusinessException {
		Map<String,Object> result = new HashMap<String, Object>();
		User u = AppContext.getCurrentUser();
		Map<String,Object> authorScope = attendanceDao.getAuthorScope(u.getId(),u.getLoginAccount());
		if(authorScope != null && authorScope.get("scopeids") != null){
			result.put("hasAuthScope",true);
		}else {
			result.put("hasAuthScope",false);
		}
		return result;
	}

	@Override
	public boolean saveOrUpdateAttendanceSetting(Map<String, Object> params) throws BusinessException {
		boolean success = true;

		long id = ParamUtil.getLong(params,"id",-1L);
		String name = ParamUtil.getString(params,"name");
		String longitude = ParamUtil.getString(params,"longitude");
		String latitude = ParamUtil.getString(params,"latitude");
		int range = Integer.parseInt(ParamUtil.getString(params, "attendRange"));
		Boolean available = (Boolean) params.get("available");
		String remark = ParamUtil.getString(params,"remark");

		AttendanceSetting setting = new AttendanceSetting();
		if(id != -1L){
			setting = findSettingById(id);
			setting.setLastModify(new Date());
		}else{
			User u = AppContext.getCurrentUser();
			setting.setCreateDate(new Date());
			setting.setLastModify(new Date());
			setting.setCreater(u.getId());
			setting.setAccountId(u.getAccountId());
			setting.setDepartId(u.getDepartmentId());
		}
		setting.setIdIfNew();
		setting.setName(name);
		setting.setLatitude(latitude);
		setting.setLongitude(longitude);
		setting.setAttendRange(range);
		setting.setAvailable(available);
		setting.setRemark(remark);

		attendanceDao.saveOrUpdateAttendanceSetting(setting);
		return success;
	}

	@Override
	public List<AttendanceSetting> findSettings(FlipInfo flipInfo) throws BusinessException {
		Map<String,Object> params = flipInfo.getParams();
		if(params == null) params = new HashMap<String, Object>();
		params.put("accountId",AppContext.currentAccountId());
		flipInfo.setParams(params);
		return attendanceDao.findSettings(flipInfo);
	}

	@Override
	public AttendanceSetting findSettingById(Long id) throws BusinessException{
		FlipInfo flipInfo = new FlipInfo();
		Map<String,Object> params = new HashMap<String, Object>();
		params.put("id",id);
		flipInfo.setParams(params);
		return findSettings(flipInfo).get(0);
	}

	@Override
	public boolean removeSettingById(Long id) throws BusinessException {
		return attendanceDao.removeSettingById(id);
	}

	@Override
	public List<AttendanceSetting> findAvailableSettings() throws BusinessException {
		Map<String,Object> params = new HashMap<String, Object>();
		params.put("available",true);
		params.put("accountId",AppContext.currentAccountId());
		return attendanceDao.findSettings(params);
	}
	@Override
	public boolean checkAttendanceAtByUser(Long attendanceId, Long memberId) {
		return attendanceDao.checkAttendanceAtByUser(attendanceId,memberId);
	}
}
