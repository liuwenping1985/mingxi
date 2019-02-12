package com.seeyon.apps.kdXdtzXc.manager;

import com.seeyon.apps.kdXdtzXc.po.ZongCaiZqyj;

/**
 * Created by tap-pcng43 on 2017-10-14.
 */
public interface ZongCaiZqyjManager {
    void save(ZongCaiZqyj zongCaiZqyj);

    void delete(Long id);

    ZongCaiZqyj getZongCaiZqyj(Long id);
}
