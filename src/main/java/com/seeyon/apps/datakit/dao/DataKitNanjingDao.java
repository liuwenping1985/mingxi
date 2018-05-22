package com.seeyon.apps.datakit.dao;

import com.seeyon.apps.datakit.po.*;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import java.util.ArrayList;
import java.util.List;

public class DataKitNanjingDao extends HibernateDaoSupport {
    private SessionFactory dataKitSessionFactory;
    private boolean isSet = false;

    public void setDataKitSessionFactory(SessionFactory dataKitSessionFactory) {
        this.dataKitSessionFactory = dataKitSessionFactory;
    }
    public void setSessionFacotry(SessionFactory dataKitSessionFactory) {
        super.setSessionFactory(dataKitSessionFactory);
        isSet = true;
    }

    public SessionFactory getDataKitSessionFactory() {
        return dataKitSessionFactory;
    }
    private void checkSession(){
        if (!isSet && dataKitSessionFactory != null) {
            setSessionFacotry(dataKitSessionFactory);
        }
    }
    public List<ZYPPB> saveOrUpdateZYPPB(List<ZYPPB> list){
        checkSession();
        this.getHibernateTemplate().saveOrUpdateAll(list);
        return list;
    }
    public List<ZYSPXX> saveOrUpdateZYSPXX(List<ZYSPXX> list){
        checkSession();
        this.getHibernateTemplate().saveOrUpdateAll(list);
        return list;
    }
    public List<ZYWLDW> saveOrUpdateZYWLDW(List<ZYWLDW> list){
        checkSession();
        this.getHibernateTemplate().saveOrUpdateAll(list);
        return list;
    }
    public int getCountByTableName(String tableName){
        checkSession();
        Session session = this.getSessionFactory().openSession();
        try {
            String hqlString = "select count(*) from "+tableName;
            Query query = session.createQuery(hqlString);
            return ((Number)query.uniqueResult()).intValue();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null) {
                try {
                    session.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        return 0;
    }



    public <T> List<T> getListByTableName(String tableName){
        checkSession();
        Session session = this.getSessionFactory().openSession();
        try {
               String hql = "from "+tableName;
               Query query = session.createQuery(hql);
               List<T> list = query.list();
               return list;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null) {
                try {
                    session.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        return new ArrayList<T>();
    }

}
