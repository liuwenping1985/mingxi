package com.seeyon.apps.datakit.dao;


import com.seeyon.apps.datakit.po.OriginalDataObject;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.orm.hibernate3.LocalSessionFactoryBean;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import java.util.ArrayList;
import java.util.List;

public class DataKitDao extends HibernateDaoSupport {
    private SessionFactory dataKitSessionFactory;
    private boolean isSet = false;


    public void setSessionFacotry(SessionFactory dataKitSessionFactory) {
        super.setSessionFactory(dataKitSessionFactory);
        isSet = true;
    }

    public SessionFactory getDataKitSessionFactory() {
        LocalSessionFactoryBean bean;

        return dataKitSessionFactory;
    }

    public void setDataKitSessionFactory(SessionFactory dataKitSessionFactory) {
        this.dataKitSessionFactory = dataKitSessionFactory;
    }
    public void saveOriginalDataObjectList(List<OriginalDataObject> dataList){
        if (!isSet && dataKitSessionFactory != null) {
            setSessionFacotry(dataKitSessionFactory);
        }
        this.getHibernateTemplate().saveOrUpdateAll(dataList);
    }
    public List<OriginalDataObject> getOriginalDataList() {
        if (!isSet && dataKitSessionFactory != null) {
            setSessionFacotry(dataKitSessionFactory);
        }
        Session session = this.getSessionFactory().openSession();
        try {
            String hql = "from OriginalDataObject where syncStatus = ? or updateStatus= ?";
            Query query = session.createQuery(hql);
            query.setString(0, "N");
            query.setString(1, "Y");
            List<OriginalDataObject> list = query.list();
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
        return new ArrayList<OriginalDataObject>();
    }
}

