package com.seeyon.apps.duban.vo;

import java.util.List;

public class DubanStatData {


    private String deptName;
    private String deptId;
    private String taskATypeCount;
    private String wancheng;
    private String renwuliang;
    private String taskCount;
    private String taskScore;
    private String dateParams;
    private String taskParams;
    private String summaryParams;
    //这里是部门的每个task的信息，每个LineData就是一个task简约信息
    private List<LineData> lineDatas;

    public List<LineData> getLineDatas() {
        return lineDatas;
    }

    public void setLineDatas(List<LineData> lineDatas) {
        this.lineDatas = lineDatas;
    }

    public String getRenwuliang() {
        return renwuliang;
    }

    public void setRenwuliang(String renwuliang) {
        this.renwuliang = renwuliang;
    }

    public String getTaskATypeCount() {
        return taskATypeCount;
    }

    public void setTaskATypeCount(String taskATypeCount) {
        this.taskATypeCount = taskATypeCount;
    }

    public String getWancheng() {
        return wancheng;
    }

    public void setWancheng(String wancheng) {
        this.wancheng = wancheng;
    }

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
