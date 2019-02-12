package com.seeyon.v3x.bulletin.dao;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;

import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.dao.BaseHibernateDao;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.v3x.bulletin.domain.BulData;
import com.seeyon.v3x.bulletin.util.Constants;

/**
 * 公告Dao，继承自稍作扩展的ExtendedHibernateDao
 * @author <a href="mailto:yangm@seeyon.com">Rookie Young</a> 2010-7-30
 */
public class BulDataDaoImpl extends BaseHibernateDao<BulData> implements BulDataDao{
	
	private static final Log logger = LogFactory.getLog(BulDataDaoImpl.class);
	
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
	public void transfer2NewAuditor(Long bulTypeId, Long oldAuditorId, Long newAuditorId) {
		String hql = "update " + CtpAffair.class.getName() + " as af set af.memberId=:newAuditorId, af.createDate=:now, af.receiveTime=:now where af.app=:bulletin and " +
					 "af.memberId=:oldAuditorId and af.objectId in (select bul.id from " + BulData.class.getName() + " as bul " +
					 "where bul.typeId=:bulTypeId and bul.state=:wait4Audit)";
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("newAuditorId", newAuditorId);
		params.put("bulletin", ApplicationCategoryEnum.bulletin.key());
		params.put("oldAuditorId", oldAuditorId);
		params.put("bulTypeId", bulTypeId);
		params.put("wait4Audit", Constants.DATA_STATE_ALREADY_CREATE);
		params.put("now", new Timestamp(System.currentTimeMillis()));
		
		super.bulkUpdate(hql, params);
	}
	
	//客开 start 将原先的待排版公告转给新的排版员
    public void transfer2NewTypesettingStaff(Long bulTypeId, Long oldTypesettingStaff, Long typesettingStaff) {
      String hql = "update " + CtpAffair.class.getName() + " as af set af.memberId=:typesettingStaff, af.createDate=:now, af.receiveTime=:now where af.app=:bulletin and " +
          "af.memberId=:oldTypesettingStaff and af.objectId in (select bul.id from " + BulData.class.getName() + " as bul " +
          "where bul.typeId=:bulTypeId and bul.state=:wait4Audit)";
      
      Map<String, Object> params = new HashMap<String, Object>();
      params.put("typesettingStaff", typesettingStaff);
      params.put("bulletin", ApplicationCategoryEnum.bulletin.key());
      params.put("oldTypesettingStaff", oldTypesettingStaff);
      params.put("bulTypeId", bulTypeId);
      params.put("wait4Audit", Constants.DATA_STATE_TYPESETTING_CREATE);
      params.put("now", new Timestamp(System.currentTimeMillis()));
      
      super.bulkUpdate(hql, params);
    }
    //客开 end

	/** 按照不同统计类型(阅读数量、公告发布人、发布月份、状态)，获取公告统计结果  */
	public List<Object[]> getStatisticInfo(String type, long bulTypeId) {
		if(Constants.Statistic_By_Read_Count.equals(type)) {
			return this.statisticByReadCount(bulTypeId);
		}
		else if(Constants.Statistic_By_Publish_User.equals(type)) {
			return this.statisticByCreator(bulTypeId);
		}
		else if(Constants.Statistic_By_Publish_Month.equals(type)) {
			return this.statisticByPublishDate(bulTypeId);
		}
		else if(Constants.Statistic_By_Status.equals(type)){
			return this.statisticByStatus(bulTypeId);
		}
		else {
			logger.warn("不合法的统计类型[" + type + "]");
			return null;
		}
	}
	
	//private static final int Month_Total = 12;
	/** 按照发布日期进行统计，从当前日期所在月份开始，往前推共12个月  */
	public List<Object[]> statisticByPublishDate(long bulTypeId) {
		List<Object[]> result = new ArrayList<Object[]>(Month_Total);
		Date date = Datetimes.getFirstDayInMonth(new Date());
		for(int i=0; i<Month_Total; i++) {
			Date beginDate = date;
			Date endDate = Datetimes.getLastDayInMonth(date);
			int sum = this.getSumInPeriod(beginDate, endDate, bulTypeId);
			result.add(new Object[]{beginDate, sum});
			
			date = Datetimes.addMonth(date, -1);
		}
		return result;
	}
	
	/** 获取在某一段时期内，某一板块下已发布的公告总数  */
	public int getSumInPeriod(Date beginDate, Date endDate, Long bulTypeId) {
		String hql = "select count(b.id) from " + BulData.class.getName() + " as b where b.typeId=? " +
					 " and b.publishDate >= ? and b.publishDate <= ? and b.deletedFlag=false";
		Long result = (Long)this.findUnique(hql, null, bulTypeId, beginDate, endDate);
		return result == null ? 0 : result.intValue();
	}
	/**
     * yangwulin Sprint4  全文检索
     * 获取在某一段时期内，某一板块下已发布的公告总数
     * @param beginDate 
     * @param endDate 
     * @return
     */
    public Integer findIndexByDate(Date beginDate, Date endDate){
        StringBuilder sbHql = new StringBuilder("select count(b.id) from ");
        sbHql.append(BulData.class.getName());
        sbHql.append(" as b where b.publishDate >= ? and b.publishDate <= ?");
        Number result = (Number) this.findUnique(sbHql.toString(), null, beginDate,endDate);
        return result==null?0:result.intValue();
    }
    
    /**
     * yangwulin Sprint4  全文检索
     */
    @SuppressWarnings("unchecked")
    public List<Long> findDocSourcesList(final Date starDate, final Date endDate, final Integer firstRow,final Integer pageSize){
        return (List<Long>) getHibernateTemplate().execute(new HibernateCallback() {
              public Object doInHibernate(Session session) throws HibernateException, SQLException {
                  String hql = "select id  from " + BulData.class.getName() + " as b where b.publishDate >=? and b.publishDate <=? order by publishDate desc";
          Query query = null;     
          query = session.createQuery(hql);
          query.setParameter(0, starDate);
          query.setParameter(1, endDate);
          query.setFirstResult(firstRow);
          query.setMaxResults(pageSize);
          
          return query.list();
              }
          });
    }

	//private static Object[] No_Published = {Constants.DATA_STATE_ALREADY_PUBLISH, 0};
	//private static Object[] No_Pigeonholed = {Constants.DATA_STATE_ALREADY_PIGEONHOLE, 0};
	
	/** 按照公告状态（已发布、归档）及其总数排列 */
	@SuppressWarnings("unchecked")
	public List<Object[]> statisticByStatus(long bulTypeId) {
		String hql = " select b.state, count(b.state) from " + BulData.class.getName() + " as b where b.typeId=? " +
		 			 " and (b.state=? or b.state=?) and b.deletedFlag=false group by b.state order by b.state asc";
		List<Object[]> result = super.find(hql, -1, -1, null, bulTypeId, Constants.DATA_STATE_ALREADY_PUBLISH, Constants.DATA_STATE_ALREADY_PIGEONHOLE);
		
		//处理板块下面无任何公告、或只有一种状态类型的公告，需补上缺少的状态类型统计信息
		if(CollectionUtils.isEmpty(result)) {
			result.add(No_Published);
			result.add(No_Pigeonholed);
		}
		else if(result.size() < 2) {
			Integer status = (Integer)result.get(0)[0];
			result.add(status == Constants.DATA_STATE_ALREADY_PUBLISH ? No_Pigeonholed : No_Published);
		}
		return result;
	}

	/** 按照公告发布人及其所发的公告数量进行统计，按公告数量降序排列 */
	@SuppressWarnings("unchecked")
	public List<Object[]> statisticByCreator(long bulTypeId) {
		String hql = " select b.publishUserId, count(b.publishUserId) from " + BulData.class.getName() + " as b where b.typeId=? " +
					 " and (b.state=? or b.state=?) and b.deletedFlag=false group by b.publishUserId order by count(b.publishUserId) desc";
		
		String countHql = "select count(distinct b.publishUserId) from " + BulData.class.getName() + " as b where b.typeId=? " +
		 				  " and (b.state=? or b.state=?) and b.deletedFlag=false";
		return super.findWithCount(hql, countHql, null, bulTypeId, Constants.DATA_STATE_ALREADY_PUBLISH, Constants.DATA_STATE_ALREADY_PIGEONHOLE);
	}

	/** 按照公告阅读数量降序排列 */
	@SuppressWarnings("unchecked")
	public List<Object[]> statisticByReadCount(long bulTypeId) {
		String hql = " select b.title, b.publishUserId, b.readCount from " + BulData.class.getName() + " as b where b.typeId=? " +
					 " and (b.state=? or b.state=?) and b.deletedFlag=false order by b.readCount desc";
		return super.find(hql, null, bulTypeId, Constants.DATA_STATE_ALREADY_PUBLISH, Constants.DATA_STATE_ALREADY_PIGEONHOLE);
	}
	
	/** 批量逻辑删除：将删除标识标记为true，并非真实删除   */
	public void delete(List<Long> ids) {
		if (ids != null && ids.size() > 0) {
			String hql = "update " + BulData.class.getName() + " as b set b.deletedFlag=true, b.topOrder=0 where b.id in (:ids)";
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("ids", ids);
			this.bulkUpdate(hql, params);
		}
	}
	
	/**
	 * 取得某一个公告板块下已发布、被置顶的公告
	 * @param typeId	公告板块ID
	 */
	public List<BulData> getTopedBulDatas(Long typeId) {
		String hql = "from BulData as data where data.typeId=? and data.topOrder>0 and data.state=? and data.deletedFlag=false order by data.topOrder desc";
		return this.findVarargs(hql, typeId, Constants.DATA_STATE_ALREADY_PUBLISH);
	}
	
	public List<BulData> getBulDatas(Long typeId) {
		String hql = "from BulData as data where data.typeId=? ";
		return this.findVarargs(hql, typeId);
	}
	
	/**
	 * 获得某个公告板块下已经置顶的记录个数
	 * @param typeId 公告板块ID
	 */
	public int getTopedCount(Long typeId) {
		List<BulData> buls = this.getTopedBulDatas(typeId);
		return CollectionUtils.isNotEmpty(buls) ? buls.size() : 0;
	}
	
	/**
	 * 查看某个公告板块下是否存在未归档、不是暂存并且没有删除的公告
	 * @param typeId
	 * @return
	 */
	public int findAllWithOutFilterTotal(Long typeId) {
		String hql = " from " + BulData.class.getName() + " as bulData " +
				"where bulData.typeId=? and bulData.deletedFlag=false and bulData.state!=? and bulData.state!=?";
		List<BulData> bulDatas = this.findVarargs(hql, typeId, Constants.DATA_STATE_ALREADY_PIGEONHOLE, Constants.DATA_STATE_NO_SUBMIT);
		return bulDatas != null ? bulDatas.size() : 0;
	}
}