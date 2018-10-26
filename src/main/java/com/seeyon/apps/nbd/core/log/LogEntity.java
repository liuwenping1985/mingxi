package com.seeyon.apps.nbd.core.log;

import java.util.Date;

/**
 * Created by liuwenping on 2018/10/26.
 */
public class LogEntity {
    private String type;
    private Date time;
    private String msg;

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Date getTime() {
        return time;
    }

    public void setTime(Date time) {
        this.time = time;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public String toString(){
        return "["+type+"]"+msg;
    }
}
