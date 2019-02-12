package com.seeyon.apps.meetingroom.dao;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.apps.meeting.constants.MeetingConstant.RoomDeleteEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.RoomPermDeleteEnum;
import com.seeyon.apps.meeting.util.MeetingHelper;
import com.seeyon.apps.meeting.util.MeetingUtil;
import com.seeyon.apps.meetingroom.po.MeetingRoom;
import com.seeyon.apps.meetingroom.po.MeetingRoomApp;
import com.seeyon.apps.meetingroom.po.MeetingRoomPerm;
import com.seeyon.apps.meetingroom.po.MeetingRoomRecord;
import com.seeyon.ctp.common.dao.BaseDao;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.SQLWildcardUtil;
import com.seeyon.ctp.util.Strings;

/**
 * 
 * @author 唐桂林
 *
 */
public class MeetingRoomListDao extends BaseDao<MeetingRoom> {

	/**
	 * 会议室列表
	 * @param conditionMap
	 * @return
	 * @throws BusinessException
	 */
	@SuppressWarnings("unchecked")
	public List<MeetingRoom> findRoomList(Map<String, Object> conditionMap)throws BusinessException {
		String name = ParamUtil.getString(conditionMap, "name");
		String status = ParamUtil.getString(conditionMap, "status");
		String seatCountCondition = ParamUtil.getString(conditionMap, "seatCountCondition");
		String seatCountStr = ParamUtil.getString(conditionMap, "seatCountStr");
		String adminIds = ParamUtil.getString(conditionMap, "adminIds");
		String mngdepId = ParamUtil.getString(conditionMap, "mngdepId");
		
		Map<String, Object> parameterMap = new HashMap<String, Object>();
		
		StringBuffer buffer = new StringBuffer();
		//buffer.append("select distinct mr from MeetingRoom mr,MeetingRoomAdmin mra");
		buffer.append("select distinct mr from MeetingRoom mr");
		//buffer.append(" where mr.id=mra.roomId");
		buffer.append(" where mr.delFlag = :delFlag");
		buffer.append(" and mr.accountId = :accountId");
		//buffer.append(" and (mra.userId = :userId and mra.userId in (:adminIdList))");
		
		if(Strings.isNotBlank(name)) {
			buffer.append(" and mr.name like :name");
			parameterMap.put("name", "%" + SQLWildcardUtil.escape(name) + "%");
		}
		else if(Strings.isNotBlank(status)) {
			buffer.append(" and mr.status = :status");
			parameterMap.put("status", Integer.parseInt(status));
		}
		else if(Strings.isNotBlank(seatCountStr)) {
			if(Integer.parseInt(seatCountCondition) == 0) {//等于
				buffer.append(" and mr.seatCount = :seatCount");
			} else if(Integer.parseInt(seatCountCondition) == 2) {//大于
				buffer.append(" and mr.seatCount > :seatCount");
			} else if(Integer.parseInt(seatCountCondition) == 4) {//小于
				buffer.append(" and mr.seatCount < :seatCount");
			}
			parameterMap.put("seatCount", Integer.parseInt(seatCountStr));
		}
		else if (Strings.isNotBlank(adminIds)) {
			String[] admins = adminIds.split(",");
			buffer.append(" and (");
			StringBuffer adminbuffer = new StringBuffer();
			for (int i = 0; i < admins.length; i++) {
				String memberid = admins[i];
				adminbuffer.append("(mr.admin like :off_admin" + i + ") or ");
				parameterMap.put("off_admin" + i, "%" + SQLWildcardUtil.escape(memberid) + "%");

			}
			buffer.append(adminbuffer.substring(0, adminbuffer.lastIndexOf("or") - 1));
			buffer.append(" ) ");
		} else if (Strings.isNotBlank(mngdepId)) {
			String[] mngdeps = mngdepId.split(",");
			buffer.append(" and (");
			StringBuffer mngdepsbuffer = new StringBuffer();
			for (int i = 0; i < mngdeps.length; i++) {
				String mngdepid = mngdeps[i];
				mngdepsbuffer.append("(mr.mngdepId like :mngdep" + i + ") or ");
				parameterMap.put("mngdep" + i, "%" + SQLWildcardUtil.escape(mngdepid) + "%");

			}
			buffer.append(mngdepsbuffer.substring(0, mngdepsbuffer.lastIndexOf("or") - 1));
			buffer.append(" ) ");
		}
		
		buffer.append(" order by mr.createDatetime desc");
		
		
		
		parameterMap.put("delFlag", RoomDeleteEnum.no.key());
		parameterMap.put("accountId", conditionMap.get("accountId"));
		//parameterMap.put("userId", conditionMap.get("userId"));
		//parameterMap.put("adminIdList", conditionMap.get("adminIdList"));
		return (List<MeetingRoom>)DBAgent.find(buffer.toString(), parameterMap);
    }
	
	/**
	 * 预订撤销列表
	 * @param conditionMap
	 * @param flipInfo
	 * @return
	 * @throws BusinessException
	 */
	@SuppressWarnings("unchecked")
	public List<MeetingRoomApp> findMyRoomAppList(Map<String, Object> conditionMap,FlipInfo flipInfo) throws BusinessException {		
		String condition = ParamUtil.getString(conditionMap, "condition");
		String textfield = ParamUtil.getString(conditionMap, "textfield");
		String textfield1 = ParamUtil.getString(conditionMap, "textfield1");
		
		Map<String, Object> parameterMap = new HashMap<String, Object>();
		
		StringBuffer buffer = new StringBuffer();
		buffer.append("select distinct mra from MeetingRoomApp mra");
		if("1".equals(condition) && Strings.isNotBlank(textfield)) {
			buffer.append(", MeetingRoom mr");
		}
		buffer.append(" where mra.perId = :userId");
		
		if("1".equals(condition)) {
			if(Strings.isNotBlank(textfield)) {
				buffer.append(" and mr.name like :name and mra.roomId = mr.id");
				parameterMap.put("name", "%" + SQLWildcardUtil.escape(textfield) + "%");
			}
		} else if("3".equals(condition)) {
			if(Strings.isNotBlank(textfield)) {
				String[] statusArr = textfield.split(",");
				List<Integer> statusList = new ArrayList<Integer>();
				for(String status : statusArr) {
					statusList.add(Integer.parseInt(status));
				}
				buffer.append(" and mra.status in (:status)");
				parameterMap.put("status", statusList);
			}
		} else if("2".equals(condition)) {
			if(Strings.isNotBlank(textfield) && Strings.isNotBlank(textfield1)) {
				buffer.append(" and mra.appDatetime between :startDatetime and :endDatetime");
				parameterMap.put("startDatetime", Datetimes.getTodayFirstTime(textfield));
				parameterMap.put("endDatetime", Datetimes.getTodayLastTime(textfield1));
			} else if(Strings.isNotBlank(textfield)) {
				buffer.append(" and mra.appDatetime >= :startDatetime");
				parameterMap.put("startDatetime", Datetimes.getTodayFirstTime(textfield));
			} else if(Strings.isNotBlank(textfield1)) {
				buffer.append(" and mra.appDatetime <= :endDatetime");
				parameterMap.put("endDatetime", Datetimes.getTodayFirstTime(textfield1));
			}
		} else if("4".equals(condition)){  //M3从新建情况页面跳转至已申请页面用
			Integer p_status = ParamUtil.getInt(conditionMap, "status");  //会议室审核状态
			buffer.append(" and mra.status = :status");
			parameterMap.put("status", p_status);
			
			buffer.append(" and mra.startDatetime > :currentDate");
			parameterMap.put("currentDate", DateUtil.currentDate());
			buffer.append(" and mra.meetingId is null");
			buffer.append(" and mra.periodicityId is null");
		}

		buffer.append(" order by mra.appDatetime desc, mra.startDatetime");
		
		parameterMap.put("userId", (Long)conditionMap.get("userId"));
		if (flipInfo != null) {
			return (List<MeetingRoomApp>)DBAgent.find(buffer.toString(), parameterMap,flipInfo);
		} else {
			return (List<MeetingRoomApp>)super.find(buffer.toString(), parameterMap);
		}
		
	}

	/**
	 * 会议室审核列表
	 * @param conditionMap
	 * @param flipInfo
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<MeetingRoomPerm> findRoomPermList(Map<String, Object> conditionMap,FlipInfo flipInfo) throws BusinessException {
		String condition = ParamUtil.getString(conditionMap, "condition");
		String textfield = ParamUtil.getString(conditionMap, "textfield");
		String textfield1 = ParamUtil.getString(conditionMap, "textfield1");
		
		Long userId = (Long)conditionMap.get("userId");
		List<Long> agentToUserIds = MeetingHelper.getMeetingAgentUserIds(userId);
		
		Map<String, Object> parameterMap = new HashMap<String, Object>();
		
		StringBuffer buffer = new StringBuffer();
		buffer.append(" select distinct mrp.roomAppId, mrp.roomId, mrp.meetingId, mrp.isAllowed");
		buffer.append(" , mrp.auditingId, mra.startDatetime, mra.appDatetime");
		buffer.append(" from MeetingRoomPerm mrp, MeetingRoom mr, MeetingRoomApp mra");
		
		if("1".equals(condition)) {//按会议室名称查询
			if(Strings.isNotEmpty(textfield)) {
				buffer.append(", MeetingRoom mr");
			}
		} else if("2".equals(condition)) {//按申请人查询
			if(Strings.isNotEmpty(textfield)) {
				buffer.append(", OrgMember OrgMember");
			}
		} else if("3".equals(condition)) {//按申请部门查询
			if(Strings.isNotEmpty(textfield)) {
				buffer.append(", OrgMember OrgMember, OrgUnit OrgUnit");
			}
		}

		buffer.append(" where mra.id = mrp.roomAppId");
		buffer.append(" and mrp.roomId = mr.id ");
		buffer.append(" and mrp.delFlag = :delFlag");
		buffer.append(" and (mr.admin like :userId");
		if(Strings.isNotEmpty(agentToUserIds)){
			buffer.append(" or mr.admin like :agentToUserIds");
			parameterMap.put("agentToUserIds", "%" +String.valueOf(agentToUserIds.get(0)) + "%");
		}
		buffer.append(")");

		if("1".equals(condition)) {//按会议室名称查询
			if(Strings.isNotEmpty(textfield)) {
				buffer.append(" and mr.name like :name and mrp.roomId = mr.id");
				parameterMap.put("name", "%" + SQLWildcardUtil.escape(textfield) + "%");
			}
		} else if("2".equals(condition)) {//按申请人查询
			if(Strings.isNotEmpty(textfield)) {
				buffer.append(" and OrgMember.name like :name and OrgMember.id=mra.perId");
				parameterMap.put("name", "%" + SQLWildcardUtil.escape(textfield) + "%");
			}
		} else if("3".equals(condition)) {//按申请部门查询
			if(Strings.isNotEmpty(textfield)) {
				buffer.append(" and OrgUnit.name like :name and OrgMember.id=mra.perId and OrgMember.orgDepartmentId=OrgUnit.id");
				parameterMap.put("name", "%" + SQLWildcardUtil.escape(textfield) + "%");
			}
		} else if("4".equals(condition)) {//按申请时间查询
			if(Strings.isNotBlank(textfield)||Strings.isNotBlank(textfield1)) {
				if(Strings.isNotBlank(textfield) && Strings.isNotBlank(textfield1)) {
					buffer.append(" and (:startDatetime <= endDatetime and :endDatetime >= startDatetime)");
					parameterMap.put("startDatetime", Datetimes.getTodayFirstTime(textfield));
					parameterMap.put("endDatetime", Datetimes.getTodayLastTime(textfield1));
				} else if(Strings.isNotBlank(textfield)) {
					buffer.append(" and mra.startDatetime >= :startDatetime");
					parameterMap.put("startDatetime", Datetimes.getTodayFirstTime(textfield));
				} else if(Strings.isNotBlank(textfield1)) {
					buffer.append(" and mra.endDatetime <= :endDatetime");
					parameterMap.put("endDatetime", Datetimes.getTodayFirstTime(textfield1));
				}
			}
		} else if("5".equals(condition)) {//按申请状态查询
			if(Strings.isNotBlank(textfield)) {
				buffer.append(" and mra.status in (:status)");
				parameterMap.put("status", MeetingUtil.getStateList(textfield));
			}
		}
		buffer.append(" order by mrp.isAllowed, mra.startDatetime desc, mra.appDatetime desc ");
		
		parameterMap.put("delFlag", RoomPermDeleteEnum.no.key());
		parameterMap.put("userId", "%" + String.valueOf(userId) + "%");
		
		List<Object[]> tempList = new ArrayList<Object[]>();
		if (flipInfo != null) {
			tempList = DBAgent.find(buffer.toString(), parameterMap, flipInfo);
		} else {
			tempList = super.find(buffer.toString(), parameterMap);
		}
		
		List<MeetingRoomPerm> list = new ArrayList<MeetingRoomPerm>();
		for (Object[] objects : tempList) {
		    int n = 0;
		    
		    MeetingRoomPerm vo = new MeetingRoomPerm();
		    vo.setRoomAppId((Long)objects[n++]);
		    vo.setRoomId((Long)objects[n++]);
		    vo.setMeetingId((Long)objects[n++]);
		    vo.setIsAllowed((Integer)objects[n++]);
		    Long adminId = (Long)objects[n++];
		    vo.setProxyId((userId.equals(adminId) || adminId == null)?-1l:adminId);
		    list.add(vo);
		}
		return list;
    }
	
	/**
	 * 会议室统计列表
	 * @param conditionMap
	 * @return
	 * @throws BusinessException
	 */
	@SuppressWarnings("unchecked")
	public List<MeetingRoomRecord> findMyRoomRecordList(Map<String, Object> conditionMap) throws BusinessException {
		StringBuffer buffer = new StringBuffer();
		buffer.append("select mrr from MeetingRoomRecord mrr, MeetingRoomAdmin admin");
		buffer.append(" where mrr.roomId = admin.roomId");
		buffer.append(" and admin.userId = :userId");
		buffer.append(" and mrr.meetingId is not null");
		
		Map<String, Object> parameterMap = new HashMap<String, Object>();
		parameterMap.put("userId", (Long)conditionMap.get("userId"));
		
		return (List<MeetingRoomRecord>)DBAgent.find(buffer.toString(), parameterMap);
	}
	
	// 客开 SZP  START
	/**
	 * 查找所有已预定会议室
	 * @param conditionMap
	 * @param flipInfo
	 * @return
	 * @throws BusinessException
	 */
	@SuppressWarnings("unchecked")
	public List<MeetingRoomPerm> findRoomReservationList(Map<String, Object> conditionMap, FlipInfo flipInfo) throws BusinessException {

		 String condition = ParamUtil.getString(conditionMap, "condition");
	     String textfield = ParamUtil.getString(conditionMap, "textfield");
	     String textfield1 = ParamUtil.getString(conditionMap, "textfield1");
	 
	     Long userId = (Long)conditionMap.get("userId");
	 
	     Map<String, Object> parameterMap = new HashMap<String, Object>();
	 
	     StringBuffer buffer = new StringBuffer();
	     buffer.append(" select distinct mra.id, mra.roomId, mra.meetingId, mra.status");
	     buffer.append(" , mra.auditingId, to_char(mra.startDatetime,'yyyy-MM-dd'), to_char(mra.endDatetime,'yyyy-MM-dd'), mra.appDatetime");
	     buffer.append(" from MeetingRoom mr, MeetingRoomApp mra");
	 
	     if ("1".equals(condition)) {
	       if (Strings.isNotEmpty(textfield))
	         buffer.append(", MeetingRoom mr");
	     }
	     else if ("2".equals(condition)) {
	       if (Strings.isNotEmpty(textfield))
	         buffer.append(", OrgMember OrgMember");
	     }
	     else if (("3".equals(condition)) && 
	       (Strings.isNotEmpty(textfield))) {
	       buffer.append(", OrgMember OrgMember, OrgUnit OrgUnit");
	     }
	 
	     buffer.append(" where mr.id = mra.roomId");
	 
	     if ("1".equals(condition)) {
	       if (Strings.isNotEmpty(textfield)) {
	         buffer.append(" and mr.name like :name and mra.roomId = mr.id");
	         parameterMap.put("name", "%" + SQLWildcardUtil.escape(textfield) + "%");
	       }
	     } else if ("2".equals(condition)) {
	       if (Strings.isNotEmpty(textfield)) {
	         buffer.append(" and OrgMember.name like :name and OrgMember.id=mra.perId");
	         parameterMap.put("name", "%" + SQLWildcardUtil.escape(textfield) + "%");
	       }
	     } else if ("3".equals(condition)) {
	       if (Strings.isNotEmpty(textfield)) {
	         buffer.append(" and OrgUnit.name like :name and OrgMember.id=mra.perId and OrgMember.orgDepartmentId=OrgUnit.id");
	         parameterMap.put("name", "%" + SQLWildcardUtil.escape(textfield) + "%");
	       }
	     } else if ("4".equals(condition)) {
	       if ((Strings.isNotBlank(textfield)) || (Strings.isNotBlank(textfield1)))
	         if ((Strings.isNotBlank(textfield)) && (Strings.isNotBlank(textfield1))) {
	           buffer.append(" and (:startDatetime <= endDatetime and :endDatetime >= startDatetime)");
	           parameterMap.put("startDatetime", Datetimes.getTodayFirstTime(textfield));
	           parameterMap.put("endDatetime", Datetimes.getTodayLastTime(textfield1));
	         } else if (Strings.isNotBlank(textfield)) {
	           buffer.append(" and mra.startDatetime >= :startDatetime");
	           parameterMap.put("startDatetime", Datetimes.getTodayFirstTime(textfield));
	         } else if (Strings.isNotBlank(textfield1)) {
	           buffer.append(" and mra.endDatetime <= :endDatetime");
	           parameterMap.put("endDatetime", Datetimes.getTodayFirstTime(textfield1));
	         }
	     }
	     else if (("5".equals(condition)) && 
	       (Strings.isNotBlank(textfield))) {
	       buffer.append(" and mra.status in (:status)");
	       parameterMap.put("status", MeetingUtil.getStateList(textfield));
	     }
	 
	     Date systemNowDatetime = DateUtil.currentDate();
	     buffer.append(" and (:currDatetime <= endDatetime or :currDatetime <= startDatetime)");
	     parameterMap.put("currDatetime", systemNowDatetime);
	 
	     buffer.append(" order by mra.startDatetime desc");
	 
	     List<Object[]> tempList = new ArrayList<Object[]>();
	     if (flipInfo != null)
	       tempList = DBAgent.find(buffer.toString(), parameterMap, flipInfo);
	     else {
	       tempList = super.find(buffer.toString(), parameterMap);
	     }
	 
	     List<MeetingRoomPerm> list = new ArrayList<MeetingRoomPerm>();
	     for (Object[] objects : tempList) {
	       int n = 0;
	 
	       MeetingRoomPerm vo = new MeetingRoomPerm();
	       vo.setRoomAppId((Long)objects[(n++)]);
	       vo.setRoomId((Long)objects[(n++)]);
	       vo.setMeetingId((Long)objects[(n++)]);
	       vo.setIsAllowed((Integer)objects[(n++)]);
	       Long adminId = (Long)objects[(n++)];
	       vo.setProxyId(Long.valueOf((userId.equals(adminId)) || (adminId == null) ? -1L : adminId.longValue()));
	       list.add(vo);
	     }
	     return list;
	   }
	// 客开 SZP  END
}
