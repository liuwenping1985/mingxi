package com.seeyon.apps.nbd.core.vo;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by liuwenping on 2018/8/20.
 */
public class NbdResponseEntity {

    private boolean result=false;

    private String msg="";

    private Map data = new HashMap();

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

    public Map getData() {
        return data;
    }

    public void setData(Map data) {
        this.data = data;
    }
}
