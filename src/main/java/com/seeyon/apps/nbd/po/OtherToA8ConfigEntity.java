package com.seeyon.apps.nbd.po;

/**
 * Created by liuwenping on 2018/11/5.
 */
public class OtherToA8ConfigEntity extends A8ToOtherConfigEntity {

    private String tableName;


    private String period;

    private boolean triggerProcess;


    public String getPeriod() {
        return period;
    }

    public void setPeriod(String period) {
        this.period = period;
    }

    public boolean isTriggerProcess() {
        return triggerProcess;
    }

    public void setTriggerProcess(boolean triggerProcess) {
        this.triggerProcess = triggerProcess;
    }
    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

}
