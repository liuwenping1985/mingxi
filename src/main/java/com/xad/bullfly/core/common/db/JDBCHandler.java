package com.xad.bullfly.core.common.db;

import com.xad.bullfly.core.common.AppContextUtil;
import com.xad.bullfly.core.common.base.domain.BaseDomain;

import javax.persistence.EntityManager;
import javax.persistence.Query;
import java.util.List;

/**
 * Created by liuwenping on 2019/8/27.
 */

public final class JDBCHandler {

    public static <T extends BaseDomain>  List<T> findBySql(String sql, Class<T> cls){

            return null;
    }
    public static List findRawDataBySql(String sql){

        EntityManager em = (EntityManager) AppContextUtil.getBean("entityManager");
        Query query = em.createNativeQuery(sql);

        List list = query.getResultList();
        return list;
    }

}
