package com.seeyon.apps.duban.vo;

import java.util.List;

/**
 * Created by liuwenping on 2019/11/14.
 */
public class CommonJSONResult {

    private String msg;

    private String status;

    private String code;

    private Object data;

    private List items;

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
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
