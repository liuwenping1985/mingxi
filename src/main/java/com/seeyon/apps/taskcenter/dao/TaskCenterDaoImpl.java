package com.seeyon.apps.taskcenter.dao;

import java.sql.SQLException;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;

import com.seeyon.apps.taskcenter.task.domain.TaskApp;
import com.seeyon.apps.taskcenter.task.domain.TaskLinkType;
import com.seeyon.ctp.common.dao.BaseDao;
import com.seeyon.ctp.util.FlipInfo;

public class TaskCenterDaoImpl extends BaseDao implements TaskCenterDao{
	private static final Log log = LogFactory.getLog(TaskCenterDaoImpl.class);
	/**
	 * HQL查询    (博客不让用斜杠星这种注释)
     *@param hql
     *@param agrs 查询条件
     *@return
     */
	@Override
    public List<?> findListByHQL(String hql, Map<String, Object> agrs) {
        return findListByHQL(hql, agrs, -1, -1);
    }
	@Override
    public List<?> findListByHQL(String hql, Map<String, Object> agrs, int start, int size) {
        Query query = this.getSessionFactory().getCurrentSession().createQuery(hql);
        query = setQueryParameter(query, agrs);
        if (size != -1) {
            query.setFirstResult(start);
            query.setMaxResults(size);
        }
        return query.list();
    }
     //设置Query 的参数（Map类型的）
     //@param query
     //@param agrs
     //@return
     //
    private Query setQueryParameter(Query query, Map<String, Object> agrs) {
        if (agrs != null) {
            Iterator<String> keys = agrs.keySet().iterator();
            while (keys.hasNext()) {
                String key = keys.next();
                Object value = agrs.get(key);
                if (value instanceof Collection)
                    query.setParameterList(key, (Collection<?>) value);
                else if (value instanceof Object[])
                    query.setParameterList(key, (Object[]) value);
                else
                    query.setParameter(key, value);
            }
        }
        return query;
    }

	public List getViewRecordByUserAndRandom6(int userId) {  
	    final int userIdf = userId;  
	    List viewRecordList = this.getHibernateTemplate().executeFind(new HibernateCallback() {  
	    public Object doInHibernate(Session session) throws HibernateException, SQLException {  
	         SQLQuery query = session.createSQLQuery("select * from viewrecord where userId=? order by rand() limit 6");    
	    query.setInteger(0, userIdf);  
	    return query.list();  
	            }  
	        });  
	    return viewRecordList;  
	    }
	/**
	 * 没有测试过，只是猜测是这样写
	 * @param sql
	 * @param params
	 * @return
	 */
	@Override
	public List findBysql(String sql,Map<String,Object> params){
		Session session = this.getSessionFactory().getCurrentSession();
		SQLQuery sqlqyery = session.createSQLQuery(sql);
		for (Entry<String,Object> param : params.entrySet()) {
			sqlqyery.setParameter(param.getKey(), param.getValue());
		}
		return sqlqyery.list();
	}
	@Override
	public List<TaskApp> getAllTaskApp(){
		return this.getHibernateTemplate().loadAll(TaskApp.class);
		
	}
	@Override
	public List<TaskLinkType> getAllTAskLinkType(){
		return this.getHibernateTemplate().loadAll(TaskLinkType.class);
	}
	@Override
	public <T> List<T> getAll(Class<T> cls) {
		return this.getHibernateTemplate().loadAll(cls);
	}
	@Override
	public <T> T getById(Class<T> clazz, String id) {
		return this.getHibernateTemplate().load(clazz, id);
	}
	@Override
	public List find(String hql, Object[] params) {
		return this.getHibernateTemplate().find(hql, params);
	}
}
