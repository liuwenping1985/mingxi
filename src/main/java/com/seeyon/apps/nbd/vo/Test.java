package com.seeyon.apps.nbd.vo;

import com.seeyon.ctp.common.security.MessageEncoder;
import com.seeyon.ctp.login.controller.MainController;
import com.seeyon.ctp.organization.manager.OrgManagerImpl;
import com.seeyon.ctp.organization.po.OrgPrincipal;
import com.seeyon.ctp.organization.principal.PrincipalManagerImpl;


import java.security.NoSuchAlgorithmException;

/**
 * Created by liuwenping on 2018/10/29.
 */
public class Test {

    private Long type;

    private String type2;

    public Long getType() {
        return type;
    }

    public void setType(Long type) {
        this.type = type;
    }

    public String getType2() {
        return type2;
    }

    public void setType2(String type2) {
        this.type2 = type2;
    }


    public static void main(String[] args) throws NoSuchAlgorithmException {
        //lishun
        PrincipalManagerImpl impl;
        MessageEncoder encoder = new MessageEncoder();
        String pwdC = encoder.encode("gaotong", "123456");
        System.out.println(pwdC);
        MainController indo;

    }
}
