package com.seeyon.apps.kdXdtzXc.dao;

import com.seeyon.apps.kdXdtzXc.po.ZongCaiShyy;
import com.seeyon.ctp.common.dao.BaseHibernateDao;

/**
 * Created by tap-pcng43 on 2017-10-12.
 */
public class ZongCaiShyyDaoImpl extends BaseHibernateDao<ZongCaiShyy> implements ZongCaiShyyDao {

    @Override
    public void save(ZongCaiShyy zongCaiShyy) {
        this.getHibernateTemplate().saveOrUpdate(zongCaiShyy);
    }

    @Override
    public void delete(Long id) {
        super.delete(id);
    }

    @Override
    public ZongCaiShyy getZongCaiShyy(Long id) {
        return super.get(id);
    }

}
