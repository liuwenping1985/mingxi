package com.seeyon.apps.kdXdtzXc.manager;

import com.seeyon.apps.kdXdtzXc.dao.ZongCaiZqyjDao;
import com.seeyon.apps.kdXdtzXc.po.ZongCaiZqyj;

/**
 * Created by tap-pcng43 on 2017-10-14.
 */
public class ZongCaiZqyjManagerImpl implements ZongCaiZqyjManager {
    private ZongCaiZqyjDao zongCaiZqyjDao;

    public ZongCaiZqyjDao getZongCaiZqyjDao() {
        return zongCaiZqyjDao;
    }

    public void setZongCaiZqyjDao(ZongCaiZqyjDao zongCaiZqyjDao) {
        this.zongCaiZqyjDao = zongCaiZqyjDao;
    }

    @Override
    public void save(ZongCaiZqyj zongCaiZqyj) {
        zongCaiZqyjDao.save(zongCaiZqyj);
    }

    @Override
    public void delete(Long id) {
        zongCaiZqyjDao.delete(id);
    }

    @Override
    public ZongCaiZqyj getZongCaiZqyj(Long id) {
        return zongCaiZqyjDao.getZongCaiZqyj(id);
    }
}
