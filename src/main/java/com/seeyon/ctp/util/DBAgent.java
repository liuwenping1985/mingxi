/**
 * $Author: wuym $
 * $Rev: 155 $
 * $Date:: 2012-07-09 15:08:37#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
package com.seeyon.ctp.util;

import java.io.Serializable;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
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
import com.seeyon.ctp.common.GlobalNames;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.log.CtpLogFactory;

/**
 * <p>Title: T1开发框架</p>
 * <p>Description: 基于Hibernate的数据库操作工具类。</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @since CTP2.0
 */
public final class DBAgent {
    private final static Log   logger    = CtpLogFactory.getLog(DBAgent.class);

    /**
     * 根据对象主键加载实体对象
     * 
     * @param entityClass 要加载的实体对象类
     * @param id 要加载的实体对象id
     * @return 指定实体类型和id的实体对象
     */
    public static <T> T get(final Class<T> entityClass, final Serializable id) {
        return (T) currentHibernateDaoSupport().getHibernateTpl().get(entityClass, id);
    }

    /**
     * 查询指定实体类型的所有数据对象，出于性能方面考虑，不建议大数据量下使用
     * 
     * @param entityClass 要加载的实体类型
     * @return 指定实体类型的全部数据列表
     */
    public static List loadAll(final Class entityClass) {
        return loadAll(entityClass, null);
    }

    /**
     * 查询指定实体类型的翻页后数据对象列表，
     * 
     * @param entityClass 要加载的实体类型
     * @param fi 翻页信息对象，包括要查询的页和每页条数等信息
     * @return 指定实体类型的翻页查询数据列表
     */
    public static List loadAll(final Class entityClass, FlipInfo fi) {
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

    /**
     * 持久化指定实体对象
     * 
     * @param entity 要持久化的实体对象
     * @return 持久化对象主键
     */
    public static Object save(final Object entity) {
        return currentHibernateDaoSupport().getHibernateTpl().save(entity);
    }
    
    public static int batch_size = 1000;

    /**
     * 批量持久化实体对象，在x201i测试笔记本电脑中的性能数据如下（非并发情况）：满1000条提交一次，不满就不提交
     * <ul>
     * <li>100条 - 178毫秒</li>
     * <li>500条 - 318毫秒</li>
     * <li>1500条 - 518毫秒</li>
     * <li>3000条 - 735毫秒</li>
     * <li>10000条 - 1282毫秒</li>
     * <li>100000条 - 9155毫秒</li>
     * </ul>
     * 
     * @param entities 要批量持久化的实体对象列表
     * @return 批量持久化对象的主键列表
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
    public static List saveAll(final List entities) {
        List results = new ArrayList();
        for (int i = 0; i < entities.size(); i++) {
            results.add(save(entities.get(i)));
            if ((i+1) % 1000 == 0 && i != 0) {
                currentHibernateDaoSupport().getHibernateTpl().flush();
                currentHibernateDaoSupport().getHibernateTpl().clear();
            }
        }
        return results;
    }
    public static List saveAllForceFlush(final List entities) {
        List results = new ArrayList();
        //CTPHibernateTemplate tpl = currentHibernateDaoSupport().getHibernateTpl();
        
        for (int i = 0; i < entities.size(); i++) {
            results.add(save(entities.get(i)));
        	//results.add(tpl.merge(entities.get(i)));
            if (((i+1) % 1000 == 0 && i != 0)||(i==entities.size()-1)) {
                currentHibernateDaoSupport().getHibernateTpl().flush();
                currentHibernateDaoSupport().getHibernateTpl().clear();
            }
        }        
        return results;
    }
    /**
     * 批量保存性能提升。直接修改saveAll为现有的逻辑会引起表单修改保存出错，因此另开一个方法。<br>
     * 注：满1000条提交一次，不满就不提交
     * 
     * @param entities 要批量持久化的实体对象列表
     */
    public static void savePatchAll(final List entities) {
        currentHibernateDaoSupport().getHibernateTpl().execute(new HibernateCallback(){
            public Object doInHibernate(Session session) throws HibernateException, SQLException {
                int i = 0;
                try {
                    for (Object object : entities) {
                        session.save(object);
                        if(++i % batch_size == 0){
                            session.flush();
                            session.clear();
                        }
                    }
                }
                catch (Exception e) {
                    logger.error("批量插入异常", e);
                }
                return null;
            }
        });
    }
    /**
     * 更新指定实体对象，根据主键作为匹配条件
     * 
     * @param entity 要更新的实体对象
     */
    public static void update(final Object entity) {
        CTPHibernateTemplate tpl = currentHibernateDaoSupport().getHibernateTpl();
        tpl.update(entity);
    }
    
    public static void merge(final Object entity) {
        CTPHibernateTemplate tpl = currentHibernateDaoSupport().getHibernateTpl();
        tpl.merge(entity);
    }

    /**
     * @deprecated
     * @see DBAgent#update(Object)
     */
    public static void updateNoMerge(final Object entity) {
        CTPHibernateTemplate tpl = currentHibernateDaoSupport().getHibernateTpl();
        tpl.update(entity);
    }

    /**
     * 批量更新实体对象。在x201i测试笔记本电脑中的性能数据如下（非并发情况）：满1000条提交一次，不满就不提交
     * <ul>
     * <li>100条 - 100毫秒</li>
     * <li>500条 - 192毫秒</li>
     * <li>1500条 - 590毫秒</li>
     * <li>3000条 - 513毫秒</li>
     * <li>10000条 - 1183毫秒</li>
     * <li>100000条 - 11245毫秒</li>
     * </ul>
     * 
     * @param entities 要批量更新的实体对象列表
     */
    @SuppressWarnings({ "rawtypes", "unchecked"})
    public static void updateAll(final List entities) {
        for (int i = 0; i < entities.size(); i++) {
            update(entities.get(i));
            if ((i % 1000 == 0 && i != 0)||(i==entities.size()-1)) {
                currentHibernateDaoSupport().getHibernateTpl().flush();
                currentHibernateDaoSupport().getHibernateTpl().clear();
            }
        }
    }

    /**
     *
      * @param entities 要批量插入/更新的对象列表
     */
    public static void mergeAll(final List entities) {
        for (int i = 0; i < entities.size(); i++) {
            merge(entities.get(i));
            if ((i % 1000 == 0 && i != 0)||(i==entities.size()-1)) {
                currentHibernateDaoSupport().getHibernateTpl().flush();
                currentHibernateDaoSupport().getHibernateTpl().clear();
            }
        }
    }

    /**
     * 删除实体对象
     * 
     * @param entity 要删除的实体对象
     */
    public static void delete(final Object entity) {
        currentHibernateDaoSupport().getHibernateTpl().delete(entity);
    }

    /**
     * 批量删除实体对象。在x201i测试笔记本电脑中的性能数据如下（非并发情况）：
     * <ul>
     * <li>100条 - 82毫秒</li>
     * <li>500条 - 353毫秒</li>
     * <li>1500条 - 842毫秒</li>
     * <li>3000条 - 1575毫秒</li>
     * <li>10000条 - 4750毫秒</li>
     * <li>100000条 - 44919毫秒</li>
     * </ul>
     * 
     * @param entities 要批量删除的实体对象列表
     */
    public static void deleteAll(final List entities) {
        currentHibernateDaoSupport().getHibernateTpl().deleteAll(entities);
    }

    /**
     * 持久化指定实体对象，新增或更新
     * 
     * @param entity 要持久化的实体对象
     */
    public static void saveOrUpdate(final Object entity) {
        currentHibernateDaoSupport().getHibernateTpl().saveOrUpdate(entity);
    }

    /**
     * 从缓存中清除指定持久化实体对象
     * 
     * @param entity 要从缓存中清除的持久化实体对象
     */
    public static void evict(final Object entity) {
        currentHibernateDaoSupport().getHibernateTpl().evict(entity);
    }

    /**
     * 根据Criteria进行查询操作
     * 
     * @param criteria 查询对象
     */
    public static List findByCriteria(final DetachedCriteria criteria) {
        return currentHibernateDaoSupport().getHibernateTpl().findByCriteria(criteria);
    }

    /**
     * 根据Criteria进行查询操作
     * @param criteria 查询对象
     * @param fi 翻页信息对象
     * @return 翻页查询结果集列表
     */
    public static List findByCriteria(final DetachedCriteria criteria, final FlipInfo fi) {
        CTPHibernateTemplate ht = currentHibernateDaoSupport().getHibernateTpl();
        ht.setFlipInfo(fi);
        List l = ht.findByCriteria(criteria);
        fi.setData(l);
        return l;
    }

    /**
     * 根据HQL进行查询操作，查询结果集数据量大时不建议使用
     * 规范规定该方法只能在DAO中调用
     * 
     * @param queryString 查询HQL语句
     * @return 查询结果集列表
     */
    public static List find(final String queryString) {
        return find(queryString, null);
    }

    /**
     * 根据HQL和HQL命名参数查询条件进行查询操作，查询结果集数据量大时不建议使用
     * 规范规定该方法只能在DAO中调用
     * 
     * @param queryString 查询HQL语句
     * @param params 查询参数
     * @return 查询结果集列表
     */
    public static List find(final String queryString, final Map params) {
        return find(queryString, params, null);
    }

    /**
     * 根据HQL和HQL命名参数查询条件进行翻页查询操作
     * 规范规定该方法只能在DAO中调用
     * 
     * @param queryString 查询HQL语句
     * @param params 查询参数
     * @param fi 翻页信息对象
     * @return 查询结果集列表
     */
    public static List find(final String queryString, final Map params, final FlipInfo fi) {
        return findBy(queryString, params, fi, false);
    }

    /**
     * 根据HQL查询语句和指定参数Value Bean进行查询操作，查询结果集数据量大时不建议使用
     * 规范规定该方法只能在DAO中调用
     * 
     * @param queryString 查询HQL语句
     * @param valueBean 查询条件取值对象
     * @return 查询结果集列表
     */
    public static List findByValueBean(final String queryString, final Object valueBean) {
        return findBy(queryString, valueBean, null, false);
    }

    /**
     * 根据HQL查询语句和指定参数Value Bean进行翻页查询操作
     * 规范规定该方法只能在DAO中调用
     * 
     * @param queryString 查询HQL语句
     * @param valueBean 查询条件取值对象
     * @param fi 翻页信息对象
     * @return 查询结果集列表
     */
    public static List findByValueBean(final String queryString, final Object valueBean, final FlipInfo fi) {
        return findBy(queryString, valueBean, fi, false);
    }

    /**
     * 根据hbm中配置的hql查询语句进行查询操作，查询结果集数据量大时不建议使用<p>
     * <code>
     * &lt;hibernate-mapping&gt;<p>
     *     &lt;query name="samples_hibernate_findAll"&gt;&lt;![CDATA[
     *         from Org o
     *     ]]>&lt;/query&gt;<p>
     * &lt;/hibernate-mapping&gt;
     * </code>
     * 
     * @param queryName 查询语句名称，如例子中的“samples_hibernate_findAll”
     * @return 查询结果集列表
     */
    public static List findByNamedQuery(final String queryName) {
        return findByNamedQuery(queryName, null);
    }

    /**
     * 根据hbm中配置的hql查询语句和指定参数进行查询操作。查询结果集数据量大时不建议使用<p>
     * <code>
     * &lt;hibernate-mapping&gt;<p>
     *     &lt;query name="samples_hibernate_findByOrgname"&gt;&lt;![CDATA[
     *         from Org o where orgname like :orgname
     *     ]]>&lt;/query&gt;<p>
     * &lt;/hibernate-mapping&gt;
     * </code>
     * 
     * @param queryString 查询语句名称，如例子中的“samples_hibernate_findByOrgname”
     * @param params 查询参数，如例子中的“orgname”（用“:orgname”表示）
     * @return 查询结果集列表
     */
    public static List findByNamedQuery(final String queryName, final Map params) {
        return findByNamedQuery(queryName, params, null);
    }

    /**
     * 根据hbm中配置的hql查询语句和指定参数进行翻页查询操作。
     * 
     * @param queryString 查询语句名称
     * @param params 查询参数
     * @param fi 翻页信息对象
     * @return 翻页查询结果集列表
     */
    public static List findByNamedQuery(final String queryName, final Map params, final FlipInfo fi) {
        return findBy(queryName, params, fi, true);
    }

    /**
     * 根据hbm中配置的hql查询语句和指定参数Value Bean进行查询操作，查询结果集数据量大时不建议使用
     * 
     * @param queryName 查询语句名称
     * @param valueBean 查询条件取值对象
     * @return 查询结果集对象列表
     */
    public static List findByNamedQueryAndValueBean(final String queryName, final Object valueBean) {
        return findBy(queryName, valueBean, null, true);
    }

    /**
     * 根据hbm中配置的hql查询语句和指定参数Value Bean进行翻页查询操作
     * 
     * @param queryName 查询语句名称
     * @param valueBean 查询条件取值对象
     * @param fi 翻页信息对象
     * @return 翻页查询结果集对象列表
     */
    public static List findByNamedQueryAndValueBean(final String queryName, final Object valueBean, final FlipInfo fi) {
        return findBy(queryName, valueBean, fi, true);
    }

    /**
     * 根据传入的update或delete的HQL进行批量更新和删除操作
     * 规范规定该方法只能在DAO中调用
     * 
     * @param hql update或delete语句
     * @param values 参数对象值
     * @return update或delete的记录数
     */
    public static int bulkUpdate(final String hql, final Object... values) {
        CTPHibernateTemplate ht = currentHibernateDaoSupport().getHibernateTpl();
        return ht.bulkUpdate(hql, values);
    }

    /**
     * 根据传入的update或delete的HQL进行批量更新和删除操作
     * 规范规定该方法只能在DAO中调用
     * 
     * @param hql update或delete语句
     * @param nameParameters 命名（用:name） 的参数
     * @return update或delete的记录数
     */
    public static int bulkUpdate(final String hql, final Map<String, Object> nameParameters) {
        CTPHibernateTemplate ht = currentHibernateDaoSupport().getHibernateTpl();
        return ht.bulkUpdate(hql, nameParameters);
    }

    /**
     * 根据HQL确定是否存在可用数据
     * 
     * @param hql 查询HQL语句
     * @return 当存在可用数据时返回true；否则返回false
     */
    public static boolean exists(final String hql) {
        return exists(hql, null);
    }

    /**
     * 根据HQL和查询条件参数确定是否存在可用数据
     * 
     * @param hql 查询HQL语句
     * @param params 查询条件参数
     * @return 当存在可用数据时返回true；否则返回false
     */
    public static boolean exists(final String hql, final Map params) {
        FlipInfo fi = new FlipInfo(1, 1);
        fi.setNeedTotal(false);
        List result = find(hql, params, fi);
        if (result.size() == 0)
            return false;
        else
            return true;
    }

    /**
     * 根据HQL获取结果集记录数
     * 
     * @param hql 要获取结果集记录数的HQL查询语句
     * @return 结果集记录数
     */
    public static int count(final String hql) {
        return count(hql, null);
    }

    /**
     * 根据Criteria获取结果集记录数
     * @param detachedCriteria 查询对象
     * @return 结果集记录数
     */
    @SuppressWarnings({ "unchecked", "rawtypes" })
    public static int count(final DetachedCriteria detachedCriteria) {
        Integer count = (Integer) currentHibernateDaoSupport().getHibernateTpl().execute(new HibernateCallback() {
            public Object doInHibernate(Session session) throws HibernateException, SQLException {
                DetachedCriteriaConversion.conversion(detachedCriteria);

                Criteria criteria = detachedCriteria.getExecutableCriteria(session);
                criteria.setProjection(Projections.rowCount());
                criteria.setFirstResult(0);
                criteria.setMaxResults(1);

                List<Object> totalCount = (List<Object>) criteria.list();

                return (totalCount == null || totalCount.isEmpty()) ? 0 : totalCount.get(0);
            }
        });

        return count.intValue();
    }

    /**
     * 根据HQL和查询条件参数获取结果集记录数
     * 
     * @param hql 要获取结果集记录数的HQL查询语句
     * @param params 查询条件参数
     * @return 结果集记录数
     */
    public static int count(final String hql, final Map params) {
        String countHql = CTPHibernateTemplate.countSQL(hql);
        List objects = find(countHql, params);
        return (objects == null || objects.isEmpty()) ? 0 : ((Number) objects.get(0)).intValue();
    }

    /**
     * 根据指定数据集合进行内存分页
     * 
     * @param dataList 要进行分页的数据集合
     * @param fi 翻页信息对象
     * @return 内存数据翻页结果集
     */
    public static List memoryPaging(final List dataList, final FlipInfo fi) {
        int size = fi.getSize(), page = fi.getPage(), start = fi.getStartAt();
        List datas = dataList;
        while (start > datas.size()) {
            fi.setPage(--page);
            start = fi.getStartAt();
        }
        fi.setTotal(datas.size());
        int end = (start + size) > fi.getTotal() ? fi.getTotal() : (start + size);
        List resultList = new ArrayList();
        for (; start < end; start++) {
            resultList.add(datas.get(start));
        }

        fi.setData(resultList);
        return fi.getData();
    }

    static CTPHibernateDaoSupport currentHibernateDaoSupport() {
/*        if (!"true".equals(AppContext.getThreadContext(GlobalNames.SPRING_AOP_LOCK)))
            throw new InfrastructureException("当前BS方法未采用Spring管理数据库连接，请检查方法命名是否符合Spring设置！");*/
    	CTPHibernateDaoSupport dao = (CTPHibernateDaoSupport) AppContext.getThreadContext(GlobalNames.SPRING_HIBERNATE_DAO_SUPPORT);
    	if(dao==null){
    		dao =  (CTPHibernateDaoSupport) AppContext
                    .getBean("hibernateDaoSupport");
    	}
    	return dao;
    }

    private static List findBy(final String query, final Object params, final FlipInfo fi, boolean namedQuery) {
        CTPHibernateTemplate ht = currentHibernateDaoSupport().getHibernateTpl();
        String qstring = query;
        if (fi != null) {
            ht.setFlipInfo(fi);
        }
        List result = new ArrayList();
        if (params == null || params instanceof Map) {
            if (namedQuery) {
                result = ht.findByNamedQueryAndNamedParam(qstring, (Map) params);
            } else {
                result = ht.findByNamedParam(qstring, (Map) params);
            }
        } else {
            if (namedQuery) {
                result = ht.findByNamedQueryAndValueBean(qstring, params);
            } else {
                result = ht.findByValueBean(qstring, params);
            }
        }
        if (fi != null) {
            fi.setData(result);
        }
        return result;
    }

    /**
     * 根据Hibernate元数据定义校验PO数据合法性，目前只校验字符串长度。验证失败则返回的List大于0
     * 
     * @param obj 要根据Hibernate元数据进行校验的PO对象
     * @return 失败则返回List大于0
     */
    public static List<String> validateByHibernateModel(Object obj) {
        LocalSessionFactoryBean sf = (LocalSessionFactoryBean) AppContext.getBean("&sessionFactory");
        //通过实体名返回Hibernate的PersistentClass 
        final PersistentClass clazz = sf.getConfiguration().getClassMapping(obj.getClass().getName());

        List<String> errors = new ArrayList<String>();
        //对应的表的元数据 
        final Table table = clazz.getTable();
        final Iterator<Column> iterator = table.getColumnIterator();
        while (iterator.hasNext()) {
            //对应的列的元数据 
            final Column column = iterator.next();
            //列名 
            final String name = column.getName();

            //遍历获取
            Iterator<Property> p = clazz.getPropertyClosureIterator();
            Property property = null;
            while (p.hasNext()) {
                Property prop = p.next();
                Iterator<Column> columns2 = prop.getColumnIterator();
                while (columns2.hasNext()) {
                    Column column2 = columns2.next();
                    if (column2.getName().equals(column.getName())) {
                        property = prop;
                        break;
                    }
                }
                if (property != null)
                    break;
            }
            if (property == null)
                continue;
            //这是数据库列映射到JAVA中的属性 
            //property = clazz.getProperty(name);
            //这是前台表单提交上来的值 
            final Object val = property.getGetter(obj.getClass()).get(obj);
            //如果值为空，跳过该字段的校验 
            if (val == null)
                continue;
            final String value = val.toString();

            //校验非空 
            /*if (!column.isNullable() && "".equals(value.trim())) {
                errors.add("字段" + name + "的值不能为空！");
            }*/
            //校验字符串长度 
            if (property.getType() instanceof StringType) {
                if (value.length() > column.getLength()) {
                    errors.add(ResourceUtil.getString("validate.exceedMaxLength", name, column.getLength()));
                }
            }
            //校验日期类型 
            /*else if (property.getType() instanceof DateType) { 
                final SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd"); 
                try { 
                    format.parse(value); 
                } catch (Exception e){ 
                    errors.put(name, "字段"+name+"必须是日期类型！"); 
                } 
            }  */
            //校验数字类型，包括浮点数 
            /*else if (property.getType() instanceof BigDecimalType) {
                int precision = column.getPrecision();
                int scale = column.getScale();
                int front = precision - scale;
                String patten = "";
                for (int i = 0; i < front; i++) {
                    patten += "#";
                }
                if (scale > 0) {
                    patten += ".";
                    for (int i = 0; i < scale; i++) {
                        patten += "#";
                    }
                }
                final NumberFormat format = new DecimalFormat(patten);
                try {
                    format.parse(value);
                } catch (Exception e) {
                    errors.add("字段" + name + "必须是数字类型(" + patten + ")！");
                }
            }*/
        }
        return errors;
    }
    /**
     * 强制提交当前事务。
     */
    public static void commit(){
    	CTPHibernateTemplate tpl = currentHibernateDaoSupport().getHibernateTpl();
		tpl.flush();
		tpl.clear();
    }    
}