package com.seeyon.apps.nbd.po;

/**
 * Created by liuwenping on 2018/11/5.
 */
public class OtherToA8ConfigEntity extends A8ToOtherConfigEntity {

    private String tableName;


    private String period;

    private String triggerProcess;


    public String getPeriod() {
        return period;
    }

    public void setPeriod(String period) {
        this.period = period;
    }

    public String getTriggerProcess() {
        return triggerProcess;
    }

    public void setTriggerProcess(String triggerProcess) {
        this.triggerProcess = triggerProcess;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

}
