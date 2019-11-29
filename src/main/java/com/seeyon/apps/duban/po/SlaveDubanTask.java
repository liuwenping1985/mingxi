package com.seeyon.apps.duban.po;

import java.util.Date;

/**
 * 配合部门任务
 * Created by liuwenping on 2019/11/28.
 */
public class SlaveDubanTask {

    private String taskId;
    /**
     * 序号
     */
    private String no;
    /**
     * 配合部门名称
     */
    private String deptName;

    /**
     * 配合部门责任人
     */
    private String leader;

    private  String weight;

    private String finishDate;

    private String taskStatus;

    private String process;

    private String sign;

    private String signDepartmentId;

    private String signMemberId;

    private Date signDate;

    public String getSign() {
        return sign;
    }

    public void setSign(String sign) {
        this.sign = sign;
    }

    public String getSignDepartmentId() {
        return signDepartmentId;
    }

    public void setSignDepartmentId(String signDepartmentId) {
        this.signDepartmentId = signDepartmentId;
    }

    public String getSignMemberId() {
        return signMemberId;
    }

    public void setSignMemberId(String signMemberId) {
        this.signMemberId = signMemberId;
    }

    public Date getSignDate() {
        return signDate;
    }

    public void setSignDate(Date signDate) {
        this.signDate = signDate;
    }

    public String getProcess() {
        return process;
    }

    public void setProcess(String process) {
        this.process = process;
    }

    public String getNo() {
        return no;
    }

    public void setNo(String no) {
        this.no = no;
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }

    public String getLeader() {
        return leader;
    }

    public void setLeader(String leader) {
        this.leader = leader;
    }

    public String getWeight() {
        return weight;
    }

    public void setWeight(String weight) {
        this.weight = weight;
    }

    public String getFinishDate() {
        return finishDate;
    }

    public void setFinishDate(String finishDate) {
        this.finishDate = finishDate;
    }

    public String getTaskStatus() {
        return taskStatus;
    }

    public void setTaskStatus(String taskStatus) {
        this.taskStatus = taskStatus;
    }

    public String getTaskId() {
        return taskId;
    }

    public void setTaskId(String taskId) {
        this.taskId = taskId;
    }
}
