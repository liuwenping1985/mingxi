package com.seeyon.apps.nbd.vo;

/**
 * Created by liuwenping on 2018/9/27.
 */
public class CheckResult {

    private boolean result;

    private String msg;


    private Object data;

    public boolean isResult() {
        return result;
    }

    public void setResult(boolean result) {
        this.result = result;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }
}
