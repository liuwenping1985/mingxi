package com.seeyon.apps.meetingroom.manager;

import java.util.List;
import java.util.Map;

import com.seeyon.apps.meetingroom.vo.MeetingRoomListVO;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.FlipInfo;

/**
 * 
 * @author 唐桂林
 *
 */
public interface MeetingRoomListManager {

	/**
	 * 会议室列表
	 * @param conditionMap
	 * @return
	 * @throws BusinessException
	 */
	public List<MeetingRoomListVO> findRoomList(Map<String, Object> conditionMap)throws BusinessException;	
	
	/**
	 * 预订撤销列表
	 * @param conditionMap
	 * @return
	 * @throws BusinessException
	 */
	public List<MeetingRoomListVO> findMyRoomAppList(Map<String, Object> conditionMap,FlipInfo flipInfo) throws BusinessException;

	/**
	 * 会议室审核列表
	 * @param conditionMap
	 * @return
	 * @throws BusinessException
	 */
	public List<MeetingRoomListVO> findRoomPermList(Map<String, Object> conditionMap,FlipInfo flipInfo) throws BusinessException;
	
	/**
	 * 会议室统计列表
	 * @param conditionMap
	 * @return
	 * @throws BusinessException
	 */
	@SuppressWarnings("rawtypes")
	public List findMyRoomStatList(Map<String, Object> conditionMap) throws BusinessException;
	
	/**
	 * 查找所有已预定会议室
	 * @param paramMap
	 * @param paramFlipInfo
	 * @return
	 * @throws BusinessException
	 */
	public List<MeetingRoomListVO> findRoomReservationList(Map<String, Object> paramMap, FlipInfo paramFlipInfo) throws BusinessException;
	
}
