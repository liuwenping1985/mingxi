package com.seeyon.apps.duban.vo;

/**
 * Created by liuwenping on 2020/10/21.
 */
public class LineData {
    private String taskSourceName;
    private String taskSourceId;
    private String taskLevelName;
    private String taskLevelId;
    private String taskId;
    private String zhuguanScore;
    private String keGuanScore;
    private String wanchengScore;
    private boolean isFinished;
    private boolean isAtype;
    private String score;

    public String getScore() {
        return score;
    }

    public void setScore(String score) {
        this.score = score;
    }

    public boolean isAtype() {
        return isAtype;
    }

    public void setAtype(boolean atype) {
        isAtype = atype;
    }

    public boolean isFinished() {
        return isFinished;
    }

    public void setFinished(boolean finished) {
        isFinished = finished;
    }

    public String getZhuguanScore() {
        return zhuguanScore;
    }

    public void setZhuguanScore(String zhuguanScore) {
        this.zhuguanScore = zhuguanScore;
    }

    public String getKeGuanScore() {
        return keGuanScore;
    }

    public void setKeGuanScore(String keGuanScore) {
        this.keGuanScore = keGuanScore;
    }

    public String getWanchengScore() {
        return wanchengScore;
    }

    public void setWanchengScore(String wanchengScore) {
        this.wanchengScore = wanchengScore;
    }

    public String getTaskSourceName() {
        return taskSourceName;
    }

    public void setTaskSourceName(String taskSourceName) {
        this.taskSourceName = taskSourceName;
    }

    public String getTaskSourceId() {
        return taskSourceId;
    }

    public void setTaskSourceId(String taskSourceId) {
        this.taskSourceId = taskSourceId;
    }

    public String getTaskLevelName() {
        return taskLevelName;
    }

    public void setTaskLevelName(String taskLevelName) {
        this.taskLevelName = taskLevelName;
    }

    public String getTaskLevelId() {
        return taskLevelId;
    }

    public void setTaskLevelId(String taskLevelId) {
        this.taskLevelId = taskLevelId;
    }

    public String getTaskId() {
        return taskId;
    }

    public void setTaskId(String taskId) {
        this.taskId = taskId;
    }
}
