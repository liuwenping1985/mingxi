package com.seeyon.apps.datakit.vo;

import com.seeyon.ctp.organization.bo.V3xOrgAccount;

import java.util.List;

public class RikazeAccountVo {

    private String accountId;

    private List<RikazeDeptVo> depts;

    private V3xOrgAccount v3xOrgAccount;


    public String getAccountId() {
        return accountId;
    }

    public void setAccountId(String accountId) {
        this.accountId = accountId;
    }

    public List<RikazeDeptVo> getDepts() {
        return depts;
    }

    public void setDepts(List<RikazeDeptVo> depts) {
        this.depts = depts;
    }

    public V3xOrgAccount getV3xOrgAccount() {
        return v3xOrgAccount;
    }

    public void setV3xOrgAccount(V3xOrgAccount v3xOrgAccount) {
        this.v3xOrgAccount = v3xOrgAccount;
    }
}
