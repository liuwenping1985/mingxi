package com.seeyon.apps.zqmenhu.vo;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by liuwenping on 2018/10/23.
 */
public class CommonResultVo {

    private List items = new ArrayList(0);
    private String msg="";
    private Object data;
    private boolean result = true;

    public List getItems() {
        return items;
    }

    public void setItems(List items) {
        this.items = items;
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

    public boolean isResult() {
        return result;
    }

    public void setResult(boolean result) {
        this.result = result;
    }
}
