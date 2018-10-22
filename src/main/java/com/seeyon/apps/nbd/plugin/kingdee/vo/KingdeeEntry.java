package com.seeyon.apps.nbd.plugin.kingdee.vo;

/**
 * Created by liuwenping on 2018/10/17.
 */
public class KingdeeEntry {

    private Double amount;

    private Double localAmt;

    private String remark;

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public Double getAmount() {
        return amount;
    }

    public void setAmount(Double amount) {
        this.amount = amount;
    }

    public Double getLocalAmt() {
        return localAmt;
    }

    public void setLocalAmt(Double localAmt) {
        this.localAmt = localAmt;
    }
}
