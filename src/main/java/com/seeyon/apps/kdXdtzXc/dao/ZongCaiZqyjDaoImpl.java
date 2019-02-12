package com.seeyon.apps.kdXdtzXc.dao;

import com.seeyon.apps.kdXdtzXc.po.ZongCaiShyy;
import com.seeyon.apps.kdXdtzXc.po.ZongCaiZqyj;
import com.seeyon.ctp.common.dao.BaseHibernateDao;

/**
 * Created by tap-pcng43 on 2017-10-12.
 */
public class ZongCaiZqyjDaoImpl extends BaseHibernateDao<ZongCaiZqyj> implements ZongCaiZqyjDao {

    @Override
    public void save(ZongCaiZqyj zongCaiZqyj) {
        this.getHibernateTemplate().saveOrUpdate(zongCaiZqyj);
    }

    @Override
    public void delete(Long id) {
        super.delete(id);
    }

    @Override
    public ZongCaiZqyj getZongCaiZqyj(Long id) {
        return super.get(id);
    }


}
