package com.seeyon.apps.duban.po;

import com.seeyon.ctp.common.po.BasePO;

/**
 * Created by liuwenping on 2020/5/24.
 */
public class DubanConfigItem extends BasePO {

    private String name;
    private Long enumId;
    private String itemValue;
    private Long accountId;
    private Integer state = 1;

    private String extValue1;
    private String extValue2;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Long getEnumId() {
        return enumId;
    }

    public void setEnumId(Long enumId) {
        this.enumId = enumId;
    }

    public String getItemValue() {
        return itemValue;
    }

    public void setItemValue(String itemValue) {
        this.itemValue = itemValue;
    }

    public Long getAccountId() {
        return accountId;
    }

    public void setAccountId(Long accountId) {
        this.accountId = accountId;
    }

    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
    }

    public String getExtValue1() {
        return extValue1;
    }

    public void setExtValue1(String extValue1) {
        this.extValue1 = extValue1;
    }

    public String getExtValue2() {
        return extValue2;
    }

    public void setExtValue2(String extValue2) {
        this.extValue2 = extValue2;
    }
}
