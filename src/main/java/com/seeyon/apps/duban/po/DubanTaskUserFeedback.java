package com.seeyon.apps.duban.po;

import com.seeyon.ctp.common.po.BasePO;

import java.util.Date;

/**
 * 用户任务反馈
 * Created by liuwenping on 2019/11/5.
 */
public class DubanTaskUserFeedback extends FormMappingPO {

    private String taskId;

    private String opinion;

    private Date createDate;

    private Long userId;

    public String getTaskId() {
        return taskId;
    }

    public void setTaskId(String taskId) {
        this.taskId = taskId;
    }

    public String getOpinion() {
        return opinion;
    }

    public void setOpinion(String opinion) {
        this.opinion = opinion;
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
