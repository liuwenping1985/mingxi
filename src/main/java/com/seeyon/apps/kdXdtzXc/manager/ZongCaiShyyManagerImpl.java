package com.seeyon.apps.kdXdtzXc.manager;

import com.seeyon.apps.kdXdtzXc.dao.ZongCaiShyyDao;
import com.seeyon.apps.kdXdtzXc.po.ZongCaiShyy;

/**
 * Created by tap-pcng43 on 2017-10-14.
 */
public class ZongCaiShyyManagerImpl  implements ZongCaiShyyManager{
    private ZongCaiShyyDao zongCaiShyyDao;

    public ZongCaiShyyDao getZongCaiShyyDao() {
        return zongCaiShyyDao;
    }

    public void setZongCaiShyyDao(ZongCaiShyyDao zongCaiShyyDao) {
        this.zongCaiShyyDao = zongCaiShyyDao;
    }

    @Override
    public void save(ZongCaiShyy zongCaiShyy) {
        zongCaiShyyDao.save(zongCaiShyy);
    }

    @Override
    public void delete(Long id) {
        zongCaiShyyDao.delete(id);
    }

    @Override
    public ZongCaiShyy getZongCaiShyy(Long id) {
        return zongCaiShyyDao.getZongCaiShyy(id);
    }
}
