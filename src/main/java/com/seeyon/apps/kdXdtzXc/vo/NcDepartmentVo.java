package com.seeyon.apps.kdXdtzXc.vo;

import java.io.Serializable;

/**
 * Created by tap-pcng43 on 2017-8-15.
 */
public class NcDepartmentVo  implements Serializable {

    private String deptcode;//部门编码
    private String account;//账套编码
    private String accountname;//账套名称
    private String deptname;//部门名称
    private String note;//备注（成本中心）

    public String getDeptcode() {
        return deptcode;
    }

    public void setDeptcode(String deptcode) {
        this.deptcode = deptcode;
    }

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    public String getDeptname() {
        return deptname;
    }

    public void setDeptname(String deptname) {
        this.deptname = deptname;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getAccountname() {
        return accountname;
    }

    public void setAccountname(String accountname) {
        this.accountname = accountname;
    }


}
