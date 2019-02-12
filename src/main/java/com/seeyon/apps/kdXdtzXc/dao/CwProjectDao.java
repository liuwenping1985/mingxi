package com.seeyon.apps.kdXdtzXc.dao;

import com.seeyon.apps.kdXdtzXc.po.CwProject;

/**
 * Created by tap-pcng43 on 2017-9-30.
 */
public interface CwProjectDao {
    Long insertCwProject(CwProject m) throws Exception;

    void updateCwProject(CwProject m, Long id) throws Exception;

    public String getCwProject(String projectCode) throws Exception;
}
