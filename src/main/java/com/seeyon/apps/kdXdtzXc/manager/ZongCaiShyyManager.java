package com.seeyon.apps.kdXdtzXc.manager;

import com.seeyon.apps.kdXdtzXc.po.ZongCaiShyy;

/**
 * Created by tap-pcng43 on 2017-10-14.
 */
public interface ZongCaiShyyManager {
    void save(ZongCaiShyy zongCaiShyy);

    void delete(Long id);

    ZongCaiShyy getZongCaiShyy(Long id);
}
