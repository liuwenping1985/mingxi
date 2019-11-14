package com.seeyon.apps.duban.po;

import java.util.Date;

/**
 * 督办确认信息
 * Created by liuwenping on 2019/11/5.
 */
public class DubanTaskAffirm extends FormMappingPO{

    private Long taskId;

    private Date createDate;

    private Long userId;

    private String deptName;

    private String deptId;

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }

    public String getDeptId() {
        return deptId;
    }

    public void setDeptId(String deptId) {
        this.deptId = deptId;
    }

    public Long getTaskId() {
        return taskId;
    }

    public void setTaskId(Long taskId) {
        this.taskId = taskId;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }
}
