package com.seeyon.apps.kdXdtzXc.dao;

import com.seeyon.apps.kdXdtzXc.po.CwOrgInfo;

/**
 * Created by tap-pcng43 on 2017-9-30.
 */
public interface CwOrgInfoDao {
    Long insertCwOrgInfo(CwOrgInfo m) throws Exception;

    void updateCwOrgInfo(CwOrgInfo m, Long id) throws Exception;

    public String getCwOrgInfo(String orgCode) throws Exception;
}
