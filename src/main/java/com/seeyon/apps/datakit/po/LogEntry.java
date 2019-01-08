package com.seeyon.apps.datakit.po;

/**
 * Created by liuwenping on 2018/11/5.
 */
public class LogEntry  extends CommonPo {

    private String msg;

    private String level;

    private boolean success;

    private String data;

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }
}
