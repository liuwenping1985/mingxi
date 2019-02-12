package com.seeyon.apps.kdXdtzXc.po;

import com.seeyon.apps.kdXdtzXc.base.po.BasePOJO;

/**
 * Created by tap-pcng43 on 2017-8-2.
 * 出差申请审批单
 */
public class TravelExpense implements BasePOJO {
    public static String className = TravelExpense.class.getName();
    private Long id;
    private String sqr;//申请人
    private String sqrbm;//申请人所在部门
    private String sqdbh;//申请单编号
    private String xmmc;//项目名称
    private String xmbm;//项目编号
    private String sybm;//受益部门

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getSqr() {
        return sqr;
    }

    public void setSqr(String sqr) {
        this.sqr = sqr;
    }

    public String getSqrbm() {
        return sqrbm;
    }

    public void setSqrbm(String sqrbm) {
        this.sqrbm = sqrbm;
    }

    public String getSqdbh() {
        return sqdbh;
    }

    public void setSqdbh(String sqdbh) {
        this.sqdbh = sqdbh;
    }

    public String getXmmc() {
        return xmmc;
    }

    public void setXmmc(String xmmc) {
        this.xmmc = xmmc;
    }

    public String getXmbm() {
        return xmbm;
    }

    public void setXmbm(String xmbm) {
        this.xmbm = xmbm;
    }

    public String getSybm() {
        return sybm;
    }

    public void setSybm(String sybm) {
        this.sybm = sybm;
    }
}
