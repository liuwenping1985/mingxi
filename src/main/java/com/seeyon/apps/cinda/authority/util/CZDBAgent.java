package com.seeyon.apps.cinda.authority.util;


import java.io.Serializable;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.DetachedCriteriaConversion;
import org.hibernate.criterion.Projections;
import org.hibernate.mapping.Column;
import org.hibernate.mapping.PersistentClass;
import org.hibernate.mapping.Property;
import org.hibernate.mapping.Table;
import org.hibernate.type.StringType;
import org.springframework.orm.hibernate3.CTPHibernateTemplate;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.LocalSessionFactoryBean;
import org.springframework.orm.hibernate3.support.CTPHibernateDaoSupport;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.util.FlipInfo;

public final class CZDBAgent
{
  private static  CTPHibernateDaoSupport czdao;
  public static void init(CTPHibernateDaoSupport ctpHibernateDaoSupport){
		czdao = ctpHibernateDaoSupport;
	}
  public static <T> T get(Class<T> entityClass, Serializable id)
  {
    return (T)currentHibernateDaoSupport().getHibernateTpl().get(entityClass, id);
  }
  
  public static List loadAll(Class entityClass)
  {
    return loadAll(entityClass, null);
  }
  
  public static List loadAll(Class entityClass, FlipInfo fi)
  {
    CTPHibernateTemplate ht = currentHibernateDaoSupport().getHibernateTpl();
    if (fi != null) {
      ht.setFlipInfo(fi);
    }
    List result = ht.loadAll(entityClass);
    if (fi != null) {
      fi.setData(result);
    }
    return result;
  }
  
  public static Object save(Object entity)
  {
    return currentHibernateDaoSupport().getHibernateTpl().save(entity);
  }
  
  public static List saveAll(List entities)
  {
    List results = new ArrayList();
    for (int i = 0; i < entities.size(); i++)
    {
      results.add(save(entities.get(i)));
      if (((i + 1) % 1000 == 0) && (i != 0))
      {
        currentHibernateDaoSupport().getHibernateTpl().flush();
        currentHibernateDaoSupport().getHibernateTpl().clear();
      }
    }
    return results;
  }
  
  public static List saveAllForceFlush(List entities)
  {
    List results = new ArrayList();
    for (int i = 0; i < entities.size(); i++)
    {
      results.add(save(entities.get(i)));
      if ((((i + 1) % 1000 == 0) && (i != 0)) || (i == entities.size() - 1))
      {
        currentHibernateDaoSupport().getHibernateTpl().flush();
        currentHibernateDaoSupport().getHibernateTpl().clear();
      }
    }
    return results;
  }
  
  public static void update(Object entity)
  {
    CTPHibernateTemplate tpl = currentHibernateDaoSupport().getHibernateTpl();
    

    tpl.merge(entity);
  }
  
  public static void updateNoMerge(Object entity)
  {
    CTPHibernateTemplate tpl = currentHibernateDaoSupport().getHibernateTpl();
    

    tpl.update(entity);
  }
  
  public static void updateAll(List entities)
  {
    for (int i = 0; i < entities.size(); i++)
    {
      update(entities.get(i));
      if (((i % 1000 == 0) && (i != 0)) || (i == entities.size() - 1))
      {
        currentHibernateDaoSupport().getHibernateTpl().flush();
        currentHibernateDaoSupport().getHibernateTpl().clear();
      }
    }
  }
  
  public static void delete(Object entity)
  {
    currentHibernateDaoSupport().getHibernateTpl().delete(entity);
  }
  
  public static void deleteAll(List entities)
  {
    currentHibernateDaoSupport().getHibernateTpl().deleteAll(entities);
  }
  
  public static void saveOrUpdate(Object entity)
  {
    currentHibernateDaoSupport().getHibernateTpl().saveOrUpdate(entity);
  }
  
  public static void evict(Object entity)
  {
    currentHibernateDaoSupport().getHibernateTpl().evict(entity);
  }
  
  public static List findByCriteria(DetachedCriteria criteria)
  {
    return currentHibernateDaoSupport().getHibernateTpl().findByCriteria(criteria);
  }
  
  public static List findByCriteria(DetachedCriteria criteria, FlipInfo fi)
  {
    CTPHibernateTemplate ht = currentHibernateDaoSupport().getHibernateTpl();
    ht.setFlipInfo(fi);
    List l = ht.findByCriteria(criteria);
    fi.setData(l);
    return l;
  }
  
  public static List find(String queryString)
  {
    return find(queryString, null);
  }
  
  public static List find(String queryString, Map params)
  {
    return find(queryString, params, null);
  }
  
  public static List find(String queryString, Map params, FlipInfo fi)
  {
    return findBy(queryString, params, fi, false);
  }
  
  public static List findByValueBean(String queryString, Object valueBean)
  {
    return findBy(queryString, valueBean, null, false);
  }
  
  public static List findByValueBean(String queryString, Object valueBean, FlipInfo fi)
  {
    return findBy(queryString, valueBean, fi, false);
  }
  
  public static List findByNamedQuery(String queryName)
  {
    return findByNamedQuery(queryName, null);
  }
  
  public static List findByNamedQuery(String queryName, Map params)
  {
    return findByNamedQuery(queryName, params, null);
  }
  
  public static List findByNamedQuery(String queryName, Map params, FlipInfo fi)
  {
    return findBy(queryName, params, fi, true);
  }
  
  public static List findByNamedQueryAndValueBean(String queryName, Object valueBean)
  {
    return findBy(queryName, valueBean, null, true);
  }
  
  public static List findByNamedQueryAndValueBean(String queryName, Object valueBean, FlipInfo fi)
  {
    return findBy(queryName, valueBean, fi, true);
  }
  
  public static int bulkUpdate(String hql, Object... values)
  {
    CTPHibernateTemplate ht = currentHibernateDaoSupport().getHibernateTpl();
    return ht.bulkUpdate(hql, values);
  }
  
  public static int bulkUpdate(String hql, Map<String, Object> nameParameters)
  {
    CTPHibernateTemplate ht = currentHibernateDaoSupport().getHibernateTpl();
    return ht.bulkUpdate(hql, nameParameters);
  }
  
  public static boolean exists(String hql)
  {
    return exists(hql, null);
  }
  
  public static boolean exists(String hql, Map params)
  {
    FlipInfo fi = new FlipInfo(1, 1);
    fi.setNeedTotal(false);
    List result = find(hql, params, fi);
    if (result.size() == 0) {
      return false;
    }
    return true;
  }
  
  public static int count(String hql)
  {
    return count(hql, null);
  }
  
  public static int count(final DetachedCriteria detachedCriteria)
  {
    Integer count = (Integer)currentHibernateDaoSupport().getHibernateTpl().execute(new HibernateCallback()
    {
      public Object doInHibernate(Session session)
        throws HibernateException, SQLException
      {
        DetachedCriteriaConversion.conversion(detachedCriteria);
        
        Criteria criteria = detachedCriteria.getExecutableCriteria(session);
        criteria.setProjection(Projections.rowCount());
        criteria.setFirstResult(0);
        criteria.setMaxResults(1);
        
        List<Object> totalCount = criteria.list();
        
        return (totalCount == null) || (totalCount.isEmpty()) ? Integer.valueOf(0) : totalCount.get(0);
      }
    });
    return count.intValue();
  }
  
  public static int count(String hql, Map params)
  {
    String countHql = CTPHibernateTemplate.countSQL(hql);
    List objects = find(countHql, params);
    return (objects == null) || (objects.isEmpty()) ? 0 : ((Number)objects.get(0)).intValue();
  }
  
  public static List memoryPaging(List dataList, FlipInfo fi)
  {
    int size = fi.getSize();int page = fi.getPage();int start = fi.getStartAt().intValue();
    List datas = dataList;
    while (start > datas.size())
    {
      fi.setPage(--page);
      start = fi.getStartAt().intValue();
    }
    fi.setTotal(datas.size());
    int end = start + size > fi.getTotal() ? fi.getTotal() : start + size;
    List resultList = new ArrayList();
    for (; start < end; start++) {
      resultList.add(datas.get(start));
    }
    fi.setData(resultList);
    return fi.getData();
  }
  
  static CTPHibernateDaoSupport currentHibernateDaoSupport()
  {
//    CTPHibernateDaoSupport dao = (CTPHibernateDaoSupport)AppContext.getThreadContext("SPRING_HIBERNATE_DAO_SUPPORT");
//    if (dao == null) {
//      dao = (CTPHibernateDaoSupport)AppContext.getBean("hibernateDaoSupport");
//    }
//    return dao;
	  return czdao;
  }
  
  private static List findBy(String query, Object params, FlipInfo fi, boolean namedQuery)
  {
    CTPHibernateTemplate ht = currentHibernateDaoSupport().getHibernateTpl();
    String qstring = query;
    if (fi != null) {
      ht.setFlipInfo(fi);
    }
    List result = new ArrayList();
    if ((params == null) || ((params instanceof Map)))
    {
      if (namedQuery) {
        result = ht.findByNamedQueryAndNamedParam(qstring, (Map)params);
      } else {
        result = ht.findByNamedParam(qstring, (Map)params);
      }
    }
    else if (namedQuery) {
      result = ht.findByNamedQueryAndValueBean(qstring, params);
    } else {
      result = ht.findByValueBean(qstring, params);
    }
    if (fi != null) {
      fi.setData(result);
    }
    return result;
  }
  
  public static List<String> validateByHibernateModel(Object obj)
  {
    LocalSessionFactoryBean sf = (LocalSessionFactoryBean)AppContext.getBean("&sessionFactory");
    
    PersistentClass clazz = sf.getConfiguration().getClassMapping(obj.getClass().getName());
    
    List<String> errors = new ArrayList();
    
    Table table = clazz.getTable();
    Iterator<Column> iterator = table.getColumnIterator();
    while (iterator.hasNext())
    {
      Column column = (Column)iterator.next();
      
      String name = column.getName();
      

      Iterator<Property> p = clazz.getPropertyClosureIterator();
      Property property = null;
      while (p.hasNext())
      {
        Property prop = (Property)p.next();
        Iterator<Column> columns2 = prop.getColumnIterator();
        while (columns2.hasNext())
        {
          Column column2 = (Column)columns2.next();
          if (column2.getName().equals(column.getName()))
          {
            property = prop;
            break;
          }
        }
        if (property != null) {
          break;
        }
      }
      if (property != null)
      {
        Object val = property.getGetter(obj.getClass()).get(obj);
        if (val != null)
        {
          String value = val.toString();
          if (((property.getType() instanceof StringType)) && 
            (value.length() > column.getLength())) {
            errors.add(ResourceUtil.getString("validate.exceedMaxLength", name, Integer.valueOf(column.getLength())));
          }
        }
      }
    }
    return errors;
  }
  
  public static void commit()
  {
    CTPHibernateTemplate tpl = currentHibernateDaoSupport().getHibernateTpl();
    tpl.flush();
    tpl.clear();
  }
}
