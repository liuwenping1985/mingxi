package com.seeyon.apps.kdXdtzXc.vo;

import java.io.Serializable;

/**
 * Created by tap-pcng43 on 2017-8-15.
 * 账套
 */
public class NcAccountingModeVo  implements Serializable {
    private String	account;//账套编码
    private String	accountname;//账套名称

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    public String getAccountname() {
        return accountname;
    }

    public void setAccountname(String accountname) {
        this.accountname = accountname;
    }

    @Override
    public String toString() {
        return "NcAccountingModeVo{" +
                "account='" + account + '\'' +
                ", accountname='" + accountname + '\'' +
                '}';
    }
}
