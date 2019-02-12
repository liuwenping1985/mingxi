package com.seeyon.apps.kdXdtzXc.po;

import com.seeyon.apps.kdXdtzXc.base.po.BasePOJO;

import java.util.Date;

/**
 * Created by tap-pcng43 on 2017-8-2.
 * 出差申请审批单-基础信息
 */
public class TravelExpenseJiChu implements BasePOJO {
    public static String className = TravelExpenseJiChu.class.getName();

    private Long id;
    private Long formmain_id;
    private Integer sort;
    private Integer xuHao;
    private String chuCaiRen;
    private String yinWenName;
    private String buMeng;
    private Date chuFaTime;
    private Date fanHuiTime;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getFormmain_id() {
        return formmain_id;
    }

    public void setFormmain_id(Long formmain_id) {
        this.formmain_id = formmain_id;
    }

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }

    public String getChuCaiRen() {
        return chuCaiRen;
    }

    public void setChuCaiRen(String chuCaiRen) {
        this.chuCaiRen = chuCaiRen;
    }

    public String getYinWenName() {
        return yinWenName;
    }

    public void setYinWenName(String yinWenName) {
        this.yinWenName = yinWenName;
    }

    public String getBuMeng() {
        return buMeng;
    }

    public void setBuMeng(String buMeng) {
        this.buMeng = buMeng;
    }

    public Date getChuFaTime() {
        return chuFaTime;
    }

    public void setChuFaTime(Date chuFaTime) {
        this.chuFaTime = chuFaTime;
    }

    public Date getFanHuiTime() {
        return fanHuiTime;
    }

    public void setFanHuiTime(Date fanHuiTime) {
        this.fanHuiTime = fanHuiTime;
    }

    public Integer getXuHao() {
        return xuHao;
    }

    public void setXuHao(Integer xuHao) {
        this.xuHao = xuHao;
    }
}
