package com.seeyon.apps.duban.po;

import com.seeyon.ctp.common.po.BasePO;

import java.util.Date;

/**
 * 督办任务主类
 * Created by liuwenping on 2019/11/5.
 */
public class DubanTask extends BasePO {

    private String uuid;

    private String sId;

    private String name;

    private String pid;

    private String taskSource;

    private String taskLevel;

    private String taskStatus;

    private Date startDate;

    private Date endDate;

    private Long createUserId;



    public Long getCreateUserId() {
        return createUserId;
    }

    public void setCreateUserId(Long createUserId) {
        this.createUserId = createUserId;
    }


    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public void setId(Long id) {
        this.id = id;
        if(id!=null){
            setsId(String.valueOf(id));
        }
    }

    public String getsId() {
        return sId;
    }

    public void setsId(String sId) {
        this.sId = sId;
    }

    public String getTaskStatus() {
        return taskStatus;
    }

    public void setTaskStatus(String taskStatus) {
        this.taskStatus = taskStatus;
    }

    public String getTaskSource() {
        return taskSource;
    }

    public void setTaskSource(String taskSource) {
        this.taskSource = taskSource;
    }

    public String getTaskLevel() {
        return taskLevel;
    }

    public void setTaskLevel(String taskLevel) {
        this.taskLevel = taskLevel;
    }

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPid() {
        return pid;
    }

    public void setPid(String pid) {

        this.pid = pid;
    }


}
