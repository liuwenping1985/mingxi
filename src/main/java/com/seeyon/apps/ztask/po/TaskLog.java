package com.seeyon.apps.ztask.po;

import com.alibaba.fastjson.annotation.JSONField;
import com.alibaba.fastjson.serializer.ToStringSerializer;
import com.seeyon.apps.platform.po.CommonPo;

/**
 * Created by liuwenping on 2019/1/22.
 */
public class TaskLog extends CommonPo {
    @JSONField(serializeUsing = ToStringSerializer.class)
    private Long taskId;

    private String msg;

    public Long getTaskId() {
        return taskId;
    }

    public void setTaskId(Long taskId) {
        this.taskId = taskId;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }
}
