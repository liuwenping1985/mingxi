package com.seeyon.apps.datakit.vo;

import com.seeyon.ctp.organization.bo.V3xOrgDepartment;

public class RikazeDeptVo {

    private String accountId;

    private String deptId;

    private String deptName;

    private V3xOrgDepartment v3xOrgDepartment;

    public String getAccountId() {
        return accountId;
    }

    public void setAccountId(String accountId) {
        this.accountId = accountId;
    }

    public String getDeptId() {
        return deptId;
    }

    public void setDeptId(String deptId) {
        this.deptId = deptId;
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }

    public V3xOrgDepartment getV3xOrgDepartment() {
        return v3xOrgDepartment;
    }

    public void setV3xOrgDepartment(V3xOrgDepartment v3xOrgDepartment) {
        this.v3xOrgDepartment = v3xOrgDepartment;
    }
}
