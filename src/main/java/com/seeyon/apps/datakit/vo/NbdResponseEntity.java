package com.seeyon.apps.datakit.vo;

import java.util.List;

/**
 * Created by liuwenping on 2018/8/20.
 */
public class NbdResponseEntity<T> {

    private boolean result=false;

    private String msg="";

    private List items;

    private T data;

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

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public List getItems() {
        return items;
    }

    public void setItems(List items) {
        this.items = items;
    }
}
