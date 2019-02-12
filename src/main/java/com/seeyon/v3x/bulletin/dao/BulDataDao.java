package com.seeyon.v3x.bulletin.dao;

import java.util.Date;
import java.util.List;

import com.seeyon.ctp.common.dao.CTPBaseHibernateDao;
import com.seeyon.v3x.bulletin.domain.BulData;
import com.seeyon.v3x.bulletin.util.Constants;

/**
 * 公告Dao，继承自稍作扩展的ExtendedHibernateDao
 * @author <a href="mailto:yangm@seeyon.com">Rookie Young</a> 2010-7-30
 */
public interface BulDataDao extends CTPBaseHibernateDao<BulData> {
	
	/**
	 * <pre>
	 * 将某一指定公告板块下待审核的公告对应待办事项转到新审核员名下
	 * 由于旧的待办事项可能是较早以前的，在转移时，将其时间改为当前时间，便于新的审核员在其待办事项最开始几项中看到
	 * 这种情况发生的场景：旧审核员离职了，而其具有审核权的公告板块还有待审核公告
	 * </pre>
	 * @param bulTypeId    公告板块ID
	 * @param oldAuditorId 旧审核员ID
	 * @param newAuditorId 新审核员ID
	 */
	public void transfer2NewAuditor(Long bulTypeId, Long oldAuditorId, Long newAuditorId) ;

	//客开 start
    public abstract void transfer2NewTypesettingStaff(Long bulTypeId, Long oldTypesettingStaff, Long typesettingStaff);
    //客开 end
	
	/** 按照不同统计类型(阅读数量、公告发布人、发布月份、状态)，获取公告统计结果  */
	public List<Object[]> getStatisticInfo(String type, long bulTypeId) ;
	
	public static final int Month_Total = 12;
	/** 按照发布日期进行统计，从当前日期所在月份开始，往前推共12个月  */
	public List<Object[]> statisticByPublishDate(long bulTypeId) ;
	
	/** 获取在某一段时期内，某一板块下已发布的公告总数  */
	public int getSumInPeriod(Date beginDate, Date endDate, Long bulTypeId) ;
	
	/**
	 * yangwulin Sprint4  2012-11-15  全文检索
	 * 获取在某一段时期内，某一板块下已发布的公告总数
	 * @param beginDate 
	 * @param endDate 
	 * @return
	 */
	public Integer findIndexByDate(Date beginDate, Date endDate);
	
	/**
    * yangwulin Sprint4  全文检索
    */
   public List<Long> findDocSourcesList(Date starDate, Date endDate, Integer firstRow, Integer pageSize) ;

	public static Object[] No_Published = {Constants.DATA_STATE_ALREADY_PUBLISH, 0};
	public static Object[] No_Pigeonholed = {Constants.DATA_STATE_ALREADY_PIGEONHOLE, 0};
	
	/** 按照公告状态（已发布、归档）及其总数排列 */
	public List<Object[]> statisticByStatus(long bulTypeId) ;

	/** 按照公告发布人及其所发的公告数量进行统计，按公告数量降序排列 */
	public List<Object[]> statisticByCreator(long bulTypeId) ;

	/** 按照公告阅读数量降序排列 */
	public List<Object[]> statisticByReadCount(long bulTypeId) ;
	
	/** 批量逻辑删除：将删除标识标记为true，并非真实删除   */
	public void delete(List<Long> ids) ;
	
	/**
	 * 取得某一个公告板块下已发布、被置顶的公告
	 * @param typeId	公告板块ID
	 */
	public List<BulData> getTopedBulDatas(Long typeId) ;
	
	public List<BulData> getBulDatas(Long typeId) ;
	
	/**
	 * 获得某个公告板块下已经置顶的记录个数
	 * @param typeId 公告板块ID
	 */
	public int getTopedCount(Long typeId) ;
	
	/**
	 * 查看某个公告板块下是否存在未归档、不是暂存并且没有删除的公告
	 * @param typeId
	 * @return
	 */
	public int findAllWithOutFilterTotal(Long typeId) ;
}