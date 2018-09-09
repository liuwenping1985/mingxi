package com.seeyon.apps.nbd.core.db;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.v3x.services.flow.impl.FlowFactoryImpl;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.transform.Transformers;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * Created by liuwenping on 2018/9/9.
 */
public final class DataBaseHelper {

    private static SessionFactory sessionFactory;

    private static Map<String, Boolean> openedSession = new HashMap<String, Boolean>();

    private static SessionFactory getSessionFactory() {
        if (sessionFactory == null) {
            sessionFactory = (SessionFactory) AppContext.getBean("sessionFactory");
        }

        return sessionFactory;
    }

    public static List<Object[]> executeQueryByNativeSQL(String sql) throws Exception {

        Session session = getSession();

        if (session != null) {
            SQLQuery query = session.createSQLQuery(sql);

            query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
            return query.list();
        }
       // FlowFactoryImpl impl;
        //impl.sendCollaboration()
        throw new Exception("不能打开session");


    }

    public static int executeUpdateByNativeSQL(String sql) throws Exception {

        Session session = getSession();
        try {
            if (session != null) {
                SQLQuery query = session.createSQLQuery(sql);
                int result = query.executeUpdate();
                return result;
            }
        } finally {
            if (openedSession.get(session.toString())) {
                try {
                    session.close();
                } finally {

                }
            }
        }
        throw new

                Exception("不能打开session");

    }


    private static Session getSession() {
        Session session = getSessionFactory().openSession();
        openedSession.put(session.toString(), true);
        return session;

    }
}
