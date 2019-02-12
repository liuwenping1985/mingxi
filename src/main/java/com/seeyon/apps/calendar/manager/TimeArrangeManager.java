/**
 * Author shuqi
 * Rev 
 * Date: Feb 8, 2017 5:41:21 PM
 *
 * Copyright (C) 2017 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 * @since v5 v6.1
 */
package com.seeyon.apps.calendar.manager;

import java.util.Date;
import java.util.List;

import com.seeyon.apps.calendar.enums.ArrangeTimeEnum;
import com.seeyon.apps.calendar.enums.ArrangeTimeStatus;
import com.seeyon.apps.calendar.po.TimeCompare;
import com.seeyon.apps.calendar.vo.SyncTimeArrange;
import com.seeyon.ctp.common.exceptions.BusinessException;

/**
 *时间安排（主要是时间视图、时间线取数据使用）
 * @Copyright 	Copyright (c) 2017
 * @Company 	seeyon.com
 * @since 		v5 v6.1
 * @author		shuqi
 */
public interface TimeArrangeManager {
	
	/**
	 *<p></p>
	 * @param startDate	时间安排的开始时间
	 * @param endDate	时间安排的结束时间
	 * @param userId	获取指定人的时间安排
	 * @param apps		查询那些模块{@link ArrangeTimeEnum}
	 * @param status	查询那些状态{@link ArrangeTimeStatus}
	 * @param isView	是视图。视图上不显示图标
	 * @return
	 * @date   Feb 8, 2017
	 * @author shuqi
	 * @throws BusinessException 
	 * @since  v5 v6.1
	 */
	public List<TimeCompare> findTimeArrange(Date startDate, Date endDate, Long userId, List<ArrangeTimeEnum> apps, List<ArrangeTimeStatus> status, boolean isView) throws BusinessException;

	/**
	 *<p>获取日程同步的数据</p>
	 * @param preSyncTime
	 * @param date
	 * @param currentUserId
	 * @param apps
	 * @param isFirst	是否为第一次同步，如果是则全部都为新增
	 * @return
	 * @date   Feb 22, 2017
	 * @author shuqi
	 * @since  v5 v6.1
	 */
	public List<SyncTimeArrange> syncTimeArrange(Date preSyncTime, Date date, long currentUserId, List<ArrangeTimeEnum> apps, boolean isFirst);

	public List<TimeCompare> findTimeArrange(Date startDate, Date endDate, Long userId, List<ArrangeTimeEnum> apps, List<ArrangeTimeStatus> status, boolean isView,String weekPlanType) throws BusinessException;
	
	
	
}
