package com.seeyon.apps.ztask.vo;

import java.util.List;

/**
 * Created by liuwenping on 2019/1/22.
 */
public class ResponseJsonData {

    private boolean result;

    private String msg;

    private Object data;

    private List items;

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

    public List getItems() {
        return items;
    }

    public void setItems(List items) {
        this.items = items;
    }
}
