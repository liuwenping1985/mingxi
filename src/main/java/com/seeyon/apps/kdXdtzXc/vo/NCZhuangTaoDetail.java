package com.seeyon.apps.kdXdtzXc.vo;

import java.io.Serializable;
import java.util.List;

/**
 * Created by tap-pcng43 on 2017-8-8.
 */
public class NCZhuangTaoDetail implements Serializable {
    private String pk_accasoa;//科目

    private String explanation;//摘要
    private Double debitamount;//原币借方金额
    private Double creditamount;//原币贷方金额
    private List<NCZhuangTaoDetailAssid> assid;//辅助核算
    private String rate;//税率


    public String getPk_accasoa() {
        return pk_accasoa;
    }

    public void setPk_accasoa(String pk_accasoa) {
        this.pk_accasoa = pk_accasoa;
    }



    public String getExplanation() {
        return explanation;
    }

    public void setExplanation(String explanation) {
        this.explanation = explanation;
    }

    public Double getDebitamount() {
        return debitamount;
    }

    public void setDebitamount(Double debitamount) {
        this.debitamount = debitamount;
    }

    public Double getCreditamount() {
        return creditamount;
    }

    public void setCreditamount(Double creditamount) {
        this.creditamount = creditamount;
    }

    public List<NCZhuangTaoDetailAssid> getAssid() {
        return assid;
    }

    public void setAssid(List<NCZhuangTaoDetailAssid> assid) {
        this.assid = assid;
    }

    public String getRate() {
        return rate;
    }

    public void setRate(String rate) {
        this.rate = rate;
    }

    @Override
    public String toString() {
        return "NCZhuangTaoDetail{" +
                "pk_accasoa='" + pk_accasoa + '\'' +
                 ", explanation='" + explanation + '\'' +
                ", debitamount=" + debitamount +
                ", creditamount=" + creditamount +
                ", assid=" + assid +
                ", rate='" + rate + '\'' +
                '}';
    }
}
