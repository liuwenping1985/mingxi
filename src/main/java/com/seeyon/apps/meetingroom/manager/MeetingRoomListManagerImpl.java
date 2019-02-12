package com.seeyon.apps.meetingroom.manager;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.apps.meeting.constants.MeetingConstant;
import com.seeyon.apps.meeting.constants.MeetingConstant.DateFormatEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.RoomStatusEnum;
import com.seeyon.apps.meeting.manager.MeetingManager;
import com.seeyon.apps.meeting.util.MeetingDateUtil;
import com.seeyon.apps.meeting.util.MeetingHelper;
import com.seeyon.apps.meeting.util.MeetingUtil;
import com.seeyon.apps.meetingroom.dao.MeetingRoomListDao;
import com.seeyon.apps.meetingroom.po.MeetingRoom;
import com.seeyon.apps.meetingroom.po.MeetingRoomApp;
import com.seeyon.apps.meetingroom.po.MeetingRoomPerm;
import com.seeyon.apps.meetingroom.po.MeetingRoomRecord;
import com.seeyon.apps.meetingroom.util.MeetingRoomAdminUtil;
import com.seeyon.apps.meetingroom.util.MeetingRoomRoleUtil;
import com.seeyon.apps.meetingroom.vo.MeetingRoomListVO;
import com.seeyon.ctp.common.dao.paginate.Pagination;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.Strings;

/**
 * 
 * @author 唐桂林
 *
 */
public class MeetingRoomListManagerImpl implements MeetingRoomListManager {
	
	private MeetingRoomListDao meetingRoomListDao;
	private MeetingRoomManager meetingRoomManager;
	private MeetingRoomAppManager meetingRoomAppManager;
	private MeetingManager meetingManager;

	/**
	 * 会议室列表
	 * @param conditionMap
	 * @return
	 * @throws BusinessException
	 */
	@Override
	public List<MeetingRoomListVO> findRoomList(Map<String, Object> conditionMap)throws BusinessException {
		List<MeetingRoomListVO> voList = new ArrayList<MeetingRoomListVO>();
		Long userId = (Long)conditionMap.get("userId");
		Long accountId = (Long)conditionMap.get("accountId");
		
		List<Long> roleAdminIdList = MeetingRoomRoleUtil.getMeetingRoomAdminIdList(accountId);
		V3xOrgMember administrator = MeetingRoomRoleUtil.getAdministrator(accountId);
		roleAdminIdList.add(administrator.getId());
		conditionMap.put("roleAdminIdList", roleAdminIdList);
		
		List<MeetingRoom> results = this.meetingRoomListDao.findRoomList(conditionMap);
		if (results != null) {
			for (MeetingRoom bean : results) {
				if (MeetingRoomAdminUtil.isRoomAdminOrNull(bean, userId)
						|| administrator.getId().longValue() == userId.longValue()) {
					MeetingRoomListVO vo = new MeetingRoomListVO();
					vo.setRoomId(bean.getId());
					vo.setRoomName(bean.getName());
					vo.setRoomPlace(bean.getPlace());
					vo.setRoomSeatCount(bean.getSeatCount());
					vo.setRoomNeedApp(bean.getNeedApp().intValue() == 1);
					vo.setRoomStatus(bean.getStatus());
					vo.setRoomStatusName(bean.getStatus().intValue()== RoomStatusEnum.normal.key() ? ResourceUtil.getString("mr.label.status.normal") : ResourceUtil.getString("mr.label.status.stop"));				
					vo.setAdminIds(bean.getAdmin());
					vo.setMngdepIds(bean.getMngdepId());
					voList.add(vo);
				}
			}
		}
		return voList;
	}

	/**
	 * 预订撤销列表
	 * @param conditionMap
	 * @return
	 * @throws BusinessException
	 */
	@Override
	public List<MeetingRoomListVO> findMyRoomAppList(Map<String, Object> conditionMap,FlipInfo flipInfo) throws BusinessException {
		List<MeetingRoomApp> results = this.meetingRoomListDao.findMyRoomAppList(conditionMap,flipInfo);		
		List<MeetingRoomListVO> voList = new ArrayList<MeetingRoomListVO>();
		if (results != null) {
			
			List<Long> roomIdList = new ArrayList<Long>();
			List<Long> meetingIdList = new ArrayList<Long>();
			List<Long> templateIdList = new ArrayList<Long>();
			
			List<Long> needQueryAppIdList = new ArrayList<Long>();
			List<Long> needQueryRoomIdList = new ArrayList<Long>();
			
			for (MeetingRoomApp bean : results) {
				roomIdList.add(bean.getRoomId());
				if(bean.getMeetingId() != null) {
					meetingIdList.add(bean.getMeetingId());
				} else if(bean.getTemplateId() != null) {//周期会议
					templateIdList.add(bean.getTemplateId());
				}
				
				if(bean.getAuditingId() == null) {
					needQueryAppIdList.add(bean.getId());
				}
				needQueryRoomIdList.add(bean.getRoomId());
			}
			
			//获取所有会议室审核人员
			Map<Long, List<Long>> auditingIdMap = meetingManager.getAffairMemberMap(needQueryAppIdList);
			
			Map<Long, List<Long>> _map = new HashMap<Long, List<Long>>();
			for(MeetingRoomApp bean : results){
				if(bean.getTemplateId() != null){
					if(auditingIdMap.get(bean.getId()) != null){
						if(!_map.containsKey(bean.getTemplateId())){
							_map.put(bean.getTemplateId(),auditingIdMap.get(bean.getId()));
						}
					}
				}
			}
			
			//获取所有会议室管理员
			Map<Long, List<Long>> roomAdminIdsMap = MeetingRoomAdminUtil.getRoomAdminIdsMap(needQueryRoomIdList);
			
			Map<Long, MeetingRoom> roomMap = this.meetingRoomManager.getRoomMap(roomIdList);
			Map<Long, String> meetingNameMap = this.meetingManager.getMeetingNameMap(meetingIdList, templateIdList);
			
			Date currentDate = DateUtil.currentDate();
			
			for (MeetingRoomApp bean : results) {
				MeetingRoomListVO vo = new MeetingRoomListVO();
				vo.setRoomAppId(bean.getId());
				vo.setRoomId(bean.getRoomId());
				vo.setMeetingId(bean.getMeetingId());
				vo.setAppDatetime(Datetimes.format(bean.getAppDatetime(), DateFormatEnum.yyyyMMddHHmm.key()));
				vo.setStartDatetime(Datetimes.format(bean.getStartDatetime(), DateFormatEnum.yyyyMMddHHmm.key()));
				vo.setEndDatetime(Datetimes.format(bean.getEndDatetime(), DateFormatEnum.yyyyMMddHHmm.key()));
				vo.setAppStatus(bean.getStatus());
				vo.setAppStatusName(ResourceUtil.getString("meeting.room.app.status." + bean.getStatus()));
				vo.setUsedStatus(bean.getUsedStatus());
				
				String[] usedstatusArr = MeetingHelper.getRoomAppUsedStateName(bean.getStatus(), bean.getUsedStatus(), currentDate, bean.getStartDatetime(), bean.getEndDatetime());
				vo.setUsedStatusName(usedstatusArr[0]);
				vo.setUsedStatusDisplay(Integer.parseInt(usedstatusArr[1]));
				
				MeetingRoom room = roomMap.get(bean.getRoomId());
				if (room != null) {
					vo.setRoomName(room.getName());
					vo.setRoomSeatCount(room.getSeatCount());
					if(!MeetingUtil.isIdNull(room.getFile_url())){
						vo.setImage(String.valueOf(room.getFile_url()));
					}
				}
				
				if(bean.getMeetingId() != null) {
					vo.setMeetingName(meetingNameMap.get(bean.getMeetingId()));
				}  else if(bean.getTemplateId() != null) {
					vo.setMeetingName(meetingNameMap.get(bean.getTemplateId()));
				}
				
				if(bean.getAuditingId() != null) {
					vo.getAuditingIdList().add(bean.getAuditingId());
				} else {
					List<Long> auditingIdList = auditingIdMap.get(bean.getId());
					List<Long> roomAdminList = roomAdminIdsMap.get(bean.getRoomId());
					
					if(Strings.isNotEmpty(auditingIdList) && Strings.isNotEmpty(roomAdminList)) {
						for(int i=0; i<auditingIdList.size(); i++) {
							if(!roomAdminList.contains(auditingIdList.get(i))) {
								auditingIdList.remove(i);
							}
						}
						for(int a =0 ; a< roomAdminList.size(); a++){
							if(!auditingIdList.contains(roomAdminList.get(a))){
								auditingIdList.add(roomAdminList.get(a));
							}
						}
						auditingIdList =  roomAdminList;
					}
					
					if(bean.getTemplateId() != null && Strings.isEmpty(auditingIdList)){
						auditingIdList=_map.get(bean.getTemplateId());
					}
					
					if(Strings.isNotEmpty(auditingIdList)) {
						vo.getAuditingIdList().addAll(auditingIdList);
					}
				}
				if(vo.getAuditingIdList() != null && vo.getAuditingIdList().isEmpty() && roomAdminIdsMap.get(bean.getRoomId()) != null){
					vo.getAuditingIdList().addAll(roomAdminIdsMap.get(bean.getRoomId()));
				}
				voList.add(vo);
			}
		}
		return voList;
	}
	
	/**
	 * 会议室审核列表
	 * @param conditionMap
	 * @return
	 * @throws BusinessException
	 */
	@Override
	public List<MeetingRoomListVO> findRoomPermList(Map<String, Object> conditionMap,FlipInfo flipInfo) throws BusinessException {
		List<MeetingRoomListVO> voList = new ArrayList<MeetingRoomListVO>();
		List<MeetingRoomPerm> results = meetingRoomListDao.findRoomPermList(conditionMap,flipInfo);
		if(Strings.isNotEmpty(results)) {
			
			Date systemNowDatetime = DateUtil.currentDate();
			
			List<Long> roomAppIdList = new ArrayList<Long>();
			List<Long> roomIdList = new ArrayList<Long>();
			List<Long> meetingIdList = new ArrayList<Long>();
			List<Long> templateIdList = new ArrayList<Long>();
			
			for (MeetingRoomPerm bean : results) {
				roomIdList.add(bean.getRoomId());
				roomAppIdList.add(bean.getRoomAppId());
				if(bean.getMeetingId() != null) {
					meetingIdList.add(bean.getMeetingId());
				}
			}
			Map<Long, MeetingRoom> roomMap = this.meetingRoomManager.getRoomMap(roomIdList);
			Map<Long, MeetingRoomApp> roomAppMap = this.meetingRoomAppManager.getRoomAppMap(roomAppIdList);
			
			for (MeetingRoomPerm bean : results) {
				MeetingRoomListVO vo = new MeetingRoomListVO();
				vo.setRoomAppId(bean.getRoomAppId());
				vo.setRoomId(bean.getRoomId());
				vo.setMeetingId(bean.getMeetingId());
				vo.setAppStatus(bean.getIsAllowed());
				vo.setAppStatusName(ResourceUtil.getString("meeting.room.app.status." + bean.getIsAllowed()));
				
				MeetingRoom room = roomMap.get(bean.getRoomId());
				if(room != null) {
					if(MeetingUtil.isIdNull(bean.getProxyId())){
						vo.setRoomName(room.getName());
					}else{
						vo.setRoomName(room.getName()+"(" + ResourceUtil.getString("meeting.room.app.agent") + Functions.showMemberNameOnly(bean.getProxyId()) +")");
					}
					if(!MeetingUtil.isIdNull(room.getFile_url())){
						vo.setImage(String.valueOf(room.getFile_url()));
					}
				}
				
				MeetingRoomApp roomApp = roomAppMap.get(bean.getRoomAppId());
				if(roomApp != null) {
					vo.setAppDatetime(Datetimes.format(roomApp.getAppDatetime(), DateFormatEnum.yyyyMMddHHmm.key()));
					vo.setStartDatetime(Datetimes.format(roomApp.getStartDatetime(), DateFormatEnum.yyyyMMddHHmm.key()));
					vo.setEndDatetime(Datetimes.format(roomApp.getEndDatetime(), DateFormatEnum.yyyyMMddHHmm.key()));
					vo.setAppPerId(roomApp.getPerId());
					
					String[] usedstatusArr = MeetingHelper.getRoomAppUsedStateName(roomApp.getStatus(), roomApp.getUsedStatus(), systemNowDatetime, roomApp.getStartDatetime(), roomApp.getEndDatetime());
					vo.setUsedStatusName(usedstatusArr[0]);
					vo.setUsedStatusDisplay(Integer.parseInt(usedstatusArr[1]));
					
					if(!MeetingUtil.isIdNull(roomApp.getPeriodicityId())) {
						vo.setTemplateId(roomApp.getTemplateId());
						templateIdList.add(roomApp.getTemplateId());
					}
				}				
				voList.add(vo);
			}
			
			Map<Long, String> meetingNameMap = this.meetingManager.getMeetingNameMap(meetingIdList, templateIdList);
			for(MeetingRoomListVO vo : voList) {
				if(vo.getMeetingId() != null) {
					vo.setMeetingName(meetingNameMap.get(vo.getMeetingId()));
				} else if(vo.getTemplateId() != null) {
					vo.setMeetingName(meetingNameMap.get(vo.getTemplateId()));
				}
			}
		}
		return voList;
	}

	/**
	 * 会议室统计列表
	 * @param conditionMap
	 * @return
	 * @throws BusinessException
	 */
	@Override
	@SuppressWarnings({ "rawtypes", "unchecked", "unused" })
	public List findMyRoomStatList(Map<String, Object> conditionMap) throws BusinessException {
		List<HashMap> list = new ArrayList<HashMap>();
		
		String strStart = ParamUtil.getString(conditionMap, "startDatetime", null);
		String strEnd = ParamUtil.getString(conditionMap, "endDatetime", null);
		
		Date startDatetime = null;
		Date endDatetime = null;
		if(Strings.isNotBlank(strStart) && Strings.isNotBlank(strEnd)) {
			startDatetime = Datetimes.getTodayFirstTime(strStart);
			endDatetime = Datetimes.getTodayLastTime(strEnd);
		} else {
			Date[] dates = MeetingDateUtil.getRoomStatDefaultDates();
			startDatetime = dates[0];
			endDatetime = dates[1];
		}
		
		conditionMap.put("startDatetime", Datetimes.format(startDatetime, DateFormatEnum.yyyyMMdd.key()));
		conditionMap.put("endDatetime", Datetimes.format(endDatetime, DateFormatEnum.yyyyMMdd.key()));
		
		List<MeetingRoomRecord> recordList = this.meetingRoomListDao.findMyRoomRecordList(conditionMap);
		if(Strings.isNotEmpty(recordList)) {
			Calendar sMonth = Calendar.getInstance();
	        Calendar eMonth = Calendar.getInstance();
	        sMonth.set(Calendar.DAY_OF_MONTH, 1);
	        sMonth.set(Calendar.HOUR_OF_DAY, 0);
	        sMonth.set(Calendar.MINUTE, 0);
	        sMonth.set(Calendar.SECOND, 0);
	        sMonth.set(Calendar.MILLISECOND, 0);
	        eMonth.setTime(sMonth.getTime());
	        eMonth.roll(Calendar.DAY_OF_MONTH, -1);
			
			for1 : for(MeetingRoomRecord record : recordList) {
				for2 : for(int j = 0; j < list.size(); j++){
	                HashMap h = list.get(j);
	                MeetingRoomRecord h_Mrr = (MeetingRoomRecord)h.get("MeetingRoomRecord");
	                if(h_Mrr.getRoomId().longValue() == record.getRoomId().longValue()){
	                    Long month = (Long)h.get("MonthTotal");
	                    Long all = (Long)h.get("AllTotal");
	                    Long section = (Long)h.get("SectionTotal");
	                    month = month + this.computeDatetime(record, sMonth.getTime(), eMonth.getTime());
	                    if(record.getEndDatetime().getTime()<new Date().getTime()){
	                    	all = all + ((record.getEndDatetime().getTime() - record.getStartDatetime().getTime()) / 1000 / 60);
	                    }
	                    section = section + this.computeDatetime(record, startDatetime, endDatetime);
	                    
	                    list.get(j).put("MonthTotal", month);
	                    list.get(j).put("AllTotal", all);
	                    list.get(j).put("SectionTotal", section);
	                    list.get(j).put("MeetingRoomRecord", record);
	                    
	                    continue for1;
	                }
				}
				HashMap h = new HashMap();
		        Long month = this.computeDatetime(record, sMonth.getTime(), eMonth.getTime());
		        
		        Long all = 0l ;
		        if(record.getEndDatetime().getTime()<new Date().getTime()){
		        	all = (record.getEndDatetime().getTime() - record.getStartDatetime().getTime()) / 1000 / 60;
		        }
		        
		        Long section = this.computeDatetime(record, startDatetime, endDatetime);
		        h.put("MeetingRoomRecord", record);
		        h.put("MonthTotal", month);
		        h.put("AllTotal", all);
		        h.put("SectionTotal", section);
		        list.add(h);
			}
		}
		
		List<Long> roomIdList = new ArrayList<Long>();
		for(HashMap map : list) {
			MeetingRoomRecord record = (MeetingRoomRecord)map.get("MeetingRoomRecord");
			roomIdList.add(record.getRoomId());
		}
		Map<Long, MeetingRoom> roomMap = meetingRoomManager.getRoomMap(roomIdList);
		
		int count = list.size();
        Pagination.setRowCount(count);
        List<HashMap> resultList = new ArrayList<HashMap>();
        int max = list.size();
        boolean isPage = false;
        if((Pagination.getFirstResult()+Pagination.getMaxResults()) < list.size() && isPage){
            max = Pagination.getFirstResult()+Pagination.getMaxResults();
        }
        if(count > 0){
            for(int i = Pagination.getFirstResult(); i < max; i++){
                HashMap h = list.get(i);
                MeetingRoomRecord record = (MeetingRoomRecord)h.get("MeetingRoomRecord");
                Long month = (Long)h.get("MonthTotal");
                Long all = (Long)h.get("AllTotal");
                Long section = (Long)h.get("SectionTotal");
                if(month != 0){
                    Long h_Month = month / 60;
                    h.put("MonthTotal", h_Month);
                }
                if(all != 0){
                    Long h_All = all / 60;
                    h.put("AllTotal", h_All);
                }
                if(section != 0){
                    Long h_Section = section / 60;
                    h.put("SectionTotal", h_Section);
                }
                h.put("room", roomMap.get(record.getRoomId()));
                resultList.add(h);
            }
        }
        return resultList;
        
	}
	
	private long computeDatetime(MeetingRoomRecord mrr, Date startDatetime, Date endDatetime ){
        long secend = 0;
        if((mrr.getStartDatetime().after(startDatetime)||mrr.getStartDatetime().equals(startDatetime))&&
            mrr.getStartDatetime().before(endDatetime)&&mrr.getEndDatetime().before(new Date())){
            if(mrr.getEndDatetime().before(endDatetime)||mrr.getEndDatetime().equals(endDatetime)){
                secend = (mrr.getEndDatetime().getTime() - mrr.getStartDatetime().getTime());
            }else{
                secend = (endDatetime.getTime() - mrr.getStartDatetime().getTime());
            }
        }
        if(mrr.getEndDatetime().after(startDatetime)&&
            (mrr.getEndDatetime().before(endDatetime)||mrr.getEndDatetime().equals(endDatetime))&&mrr.getEndDatetime().before(new Date())){
            if(mrr.getStartDatetime().after(startDatetime)||mrr.getStartDatetime().equals(startDatetime)){
                secend = (mrr.getEndDatetime().getTime() - mrr.getStartDatetime().getTime());
            }else{
                secend = (mrr.getEndDatetime().getTime() - startDatetime.getTime());
            }
        }
        if((mrr.getStartDatetime().before(startDatetime)||mrr.getStartDatetime().equals(startDatetime))&&
            (mrr.getEndDatetime().after(endDatetime)||mrr.getEndDatetime().equals(endDatetime))&&mrr.getEndDatetime().before(new Date())){
            secend = endDatetime.getTime() - startDatetime.getTime();
        }
        if(secend != 0){
            secend = secend / 1000 / 60;
        }
        return secend;
    }
	
	/****************************** 依赖注入 **********************************/
	public void setMeetingRoomListDao(MeetingRoomListDao meetingRoomListDao) {
		this.meetingRoomListDao = meetingRoomListDao;
	}
	public void setMeetingRoomManager(MeetingRoomManager meetingRoomManager) {
		this.meetingRoomManager = meetingRoomManager;
	}
	public void setMeetingManager(MeetingManager meetingManager) {
		this.meetingManager = meetingManager;
	}
	public void setMeetingRoomAppManager(MeetingRoomAppManager meetingRoomAppManager) {
		this.meetingRoomAppManager = meetingRoomAppManager;
	}

	@Override
	public List<MeetingRoomListVO> findRoomReservationList(Map<String, Object> conditionMap, FlipInfo flipInfo) throws BusinessException {
	  List<MeetingRoomListVO> voList = new ArrayList<MeetingRoomListVO>();
	  List<MeetingRoomPerm> results = this.meetingRoomListDao.findRoomReservationList(conditionMap, flipInfo);
	  if (Strings.isNotEmpty(results))
	  {
	    Date systemNowDatetime = DateUtil.currentDate();
	    
	    List<Long> roomAppIdList = new ArrayList<Long>();
		List<Long> roomIdList = new ArrayList<Long>();
		List<Long> meetingIdList = new ArrayList<Long>();
		List<Long> templateIdList = new ArrayList<Long>();
	
	    for (MeetingRoomPerm bean : results) {
	      roomIdList.add(bean.getRoomId());
	      roomAppIdList.add(bean.getRoomAppId());
	      if (bean.getMeetingId() != null) {
	        meetingIdList.add(bean.getMeetingId());
	      }
	    }
	    Map<Long, MeetingRoom> roomMap = this.meetingRoomManager.getRoomMap(roomIdList);
	    Map<Long, MeetingRoomApp> roomAppMap = this.meetingRoomAppManager.getRoomAppMap(roomAppIdList);
	    for (MeetingRoomPerm bean : results) {
	      MeetingRoomListVO vo = new MeetingRoomListVO();
	      vo.setRoomAppId(bean.getRoomAppId());
	      vo.setRoomId(bean.getRoomId());
	      vo.setMeetingId(bean.getMeetingId());
	      vo.setAppStatus(bean.getIsAllowed());
	      vo.setAppStatusName(ResourceUtil.getString("meeting.room.app.status." + bean.getIsAllowed()));
	
	  MeetingRoom room = (MeetingRoom)roomMap.get(bean.getRoomId());
	  if (room != null) {
	    if (MeetingUtil.isIdNull(bean.getProxyId()).booleanValue())
	      vo.setRoomName(room.getName());
	    else {
	      vo.setRoomName(room.getName() + "(" + ResourceUtil.getString("meeting.room.app.agent") + Functions.showMemberNameOnly(bean.getProxyId()) + ")");
	        }
	        if (!MeetingUtil.isIdNull(room.getFile_url()).booleanValue()) {
	          vo.setImage(String.valueOf(room.getFile_url()));
	        }
	      }
	
	      MeetingRoomApp roomApp = (MeetingRoomApp)roomAppMap.get(bean.getRoomAppId());
	      if (roomApp != null) {
	        vo.setAppDatetime(Datetimes.format(roomApp.getAppDatetime(), MeetingConstant.DateFormatEnum.yyyyMMddHHmm.key()));
	        vo.setStartDatetime(Datetimes.format(roomApp.getStartDatetime(), MeetingConstant.DateFormatEnum.yyyyMMddHHmm.key()));
	        vo.setEndDatetime(Datetimes.format(roomApp.getEndDatetime(), MeetingConstant.DateFormatEnum.yyyyMMddHHmm.key()));
	        vo.setAppPerId(roomApp.getPerId());
	
	        String[] usedstatusArr = MeetingHelper.getRoomAppUsedStateName(roomApp.getStatus(), roomApp.getUsedStatus(), systemNowDatetime, roomApp.getStartDatetime(), roomApp.getEndDatetime());
	        vo.setUsedStatusName(usedstatusArr[0]);
	        vo.setUsedStatusDisplay(Integer.valueOf(Integer.parseInt(usedstatusArr[1])));
	
	        if (!MeetingUtil.isIdNull(roomApp.getPeriodicityId()).booleanValue()) {
	          vo.setTemplateId(roomApp.getTemplateId());
	          templateIdList.add(roomApp.getTemplateId());
	        }
	      }
	      voList.add(vo);
	    }
	
	    Map<Long, String> meetingNameMap = this.meetingManager.getMeetingNameMap(meetingIdList, templateIdList);
	    for (MeetingRoomListVO vo : voList) {
	      if (vo.getMeetingId() != null)
	        vo.setMeetingName((String)meetingNameMap.get(vo.getMeetingId()));
	      else if (vo.getTemplateId() != null) {
	        vo.setMeetingName((String)meetingNameMap.get(vo.getTemplateId()));
	      }
	    }
	  }
	  return voList;
	}
}
