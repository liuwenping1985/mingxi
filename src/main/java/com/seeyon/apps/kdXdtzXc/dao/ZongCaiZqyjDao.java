package com.seeyon.apps.kdXdtzXc.dao;

import com.seeyon.apps.kdXdtzXc.po.ZongCaiZqyj;

/**
 * Created by tap-pcng43 on 2017-10-12.
 */
public interface ZongCaiZqyjDao {

    void save(ZongCaiZqyj zongCaiZqyj);

    void delete(Long id);

    ZongCaiZqyj getZongCaiZqyj(Long id);
}
