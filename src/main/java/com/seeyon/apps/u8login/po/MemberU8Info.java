package com.seeyon.apps.u8login.po;

import com.seeyon.ctp.common.po.BasePO;

/**
 * Created by liuwenping on 2018/6/15.
 */
public class MemberU8Info extends BasePO{


    private String userCode;
    private String password;


    public String getUserCode() {
        return userCode;
    }

    public void setUserCode(String userCode) {
        this.userCode = userCode;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }


}
