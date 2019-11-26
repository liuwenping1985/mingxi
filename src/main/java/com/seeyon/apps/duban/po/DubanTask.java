package com.seeyon.apps.duban.po;

import java.util.Date;

/**
 * 督办任务主类
 * Created by liuwenping on 2019/11/5.
 */
public class DubanTask extends FormMappingPO {

    private String uuid;

    private String taskId;

    private String name;

    private String pid;

    private String taskSource;

    private String taskLevel;

    private String taskStatus;

    private Date startDate;

    private Date endDate;

    private Long createUserId;
    private String period;
    private String process;
    private String mainLeader;
    private String viewLeaderName;
    private String supervisor;
    private String deptName;

    private String taskDescription;

    private String attListString;

    public String getViewLeaderName() {
        return viewLeaderName;
    }

    public void setViewLeaderName(String viewLeaderName) {
        this.viewLeaderName = viewLeaderName;
    }

    public String getPeriod() {
        return period;
    }

    public void setPeriod(String period) {
        this.period = period;
    }

    public String getProcess() {
        return process;
    }

    public void setProcess(String process) {
        this.process = process;
    }

    public String getMainLeader() {
        return mainLeader;
    }

    public void setMainLeader(String mainLeader) {
        this.mainLeader = mainLeader;
    }

    public String getSupervisor() {
        return supervisor;
    }

    public void setSupervisor(String supervisor) {
        this.supervisor = supervisor;
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }

    public String getAttListString() {
        return attListString;
    }

    public void setAttListString(String attListString) {
        this.attListString = attListString;
    }

    public String getTaskDescription() {
        return taskDescription;
    }

    public void setTaskDescription(String taskDescription) {
        this.taskDescription = taskDescription;
    }

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
    }

    public String getTaskId() {
        return taskId;
    }

    public void setTaskId(String taskId) {
        this.taskId = taskId;
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
