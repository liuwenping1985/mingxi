package com.seeyon.apps.kdXdtzXc.vo;

import java.io.Serializable;

/**
 * Created by tap-pcng43 on 2017-8-8.
 */
public class NCZhuangTaoDetailAssid implements Serializable {
    private String code;//
    private String pk_accass;//辅助核算项目
    private String name;//

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getPk_accass() {
        return pk_accass;
    }

    public void setPk_accass(String pk_accass) {
        this.pk_accass = pk_accass;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "NCZhuangTaoDetailAssid{" +
                "code='" + code + '\'' +
                ", pk_accass='" + pk_accass + '\'' +
                ", name='" + name + '\'' +
                '}';
    }
}
