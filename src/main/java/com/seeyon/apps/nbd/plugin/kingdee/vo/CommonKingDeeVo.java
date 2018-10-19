package com.seeyon.apps.nbd.plugin.kingdee.vo;

/**
 * Created by liuwenping on 2018/10/17.
 */
public class CommonKingDeeVo {

    public CommonKingDeeVo(){

    }
    public CommonKingDeeVo(String number){
        this.setNumber(number);
    }
    private String number;

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }
}
