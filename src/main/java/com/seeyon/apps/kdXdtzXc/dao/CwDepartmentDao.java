package com.seeyon.apps.kdXdtzXc.dao;

import com.seeyon.apps.kdXdtzXc.po.CwDepartment;

/**
 * Created by tap-pcng43 on 2017-9-30.
 */
public interface CwDepartmentDao   {


    Long insertCwDepartment(CwDepartment m) throws Exception;

    void updateCwDepartment(CwDepartment m, Long id) throws Exception;

    public String getCwDepartment(String deptCode) throws Exception;
}
