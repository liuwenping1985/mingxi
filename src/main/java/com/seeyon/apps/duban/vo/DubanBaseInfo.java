package com.seeyon.apps.duban.vo;

import com.seeyon.apps.duban.po.DubanTask;

import java.util.List;

/**
 * Created by liuwenping on 2019/11/27.
 */
public class DubanBaseInfo {

    private List<DubanTask> leaderList;


    private List<DubanTask> supervisorTaskList;

    private List<DubanTask> cengbanTaskList;

    private List<DubanTask> xiebanTaskList;

    public List<DubanTask> getLeaderList() {
        return leaderList;
    }

    public void setLeaderList(List<DubanTask> leaderList) {
        this.leaderList = leaderList;
    }

    public List<DubanTask> getSupervisorTaskList() {
        return supervisorTaskList;
    }

    public void setSupervisorTaskList(List<DubanTask> supervisorTaskList) {
        this.supervisorTaskList = supervisorTaskList;
    }

    public List<DubanTask> getCengbanTaskList() {
        return cengbanTaskList;
    }

    public void setCengbanTaskList(List<DubanTask> cengbanTaskList) {
        this.cengbanTaskList = cengbanTaskList;
    }

    public List<DubanTask> getXiebanTaskList() {
        return xiebanTaskList;
    }

    public void setXiebanTaskList(List<DubanTask> xiebanTaskList) {
        this.xiebanTaskList = xiebanTaskList;
    }
}
