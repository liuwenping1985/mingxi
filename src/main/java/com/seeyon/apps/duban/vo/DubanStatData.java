package com.seeyon.apps.duban.vo;

public class DubanStatData {


    private String deptName;
    private String deptId;

    private String taskCount;
    private String taskScore;
    private String dateParams;
    private String taskParams;
    private String summaryParams;

    public String getDeptId() {
        return deptId;
    }

    public void setDeptId(String deptId) {
        this.deptId = deptId;
    }

    public String getTaskParams() {
        return taskParams;
    }

    public void setTaskParams(String taskParams) {
        this.taskParams = taskParams;
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }

    public String getTaskCount() {
        return taskCount;
    }

    public void setTaskCount(String taskCount) {
        this.taskCount = taskCount;
    }

    public String getTaskScore() {
        return taskScore;
    }

    public void setTaskScore(String taskScore) {
        this.taskScore = taskScore;
    }

    public String getDateParams() {
        return dateParams;
    }

    public void setDateParams(String dateParams) {
        this.dateParams = dateParams;
    }

    public String getSummaryParams() {
        return summaryParams;
    }

    public void setSummaryParams(String summaryParams) {
        this.summaryParams = summaryParams;
    }
}
