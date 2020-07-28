package com.seeyon.apps.duban.po;

import com.seeyon.ctp.common.po.BasePO;

import java.util.Date;

/**
 * Created by liuwenping on 2020/5/26.
 */
public class DubanScoreRecord extends BasePO {

    private String taskId;

    private String score;

    private String keGuanScore;

    private String zhuGuanScore;

    private Long memberId;

    private Long departmentId;

    private Long summaryId;

    private String weight;

    private String extVal;

    private Date createDate;

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public String getWeight() {
        return weight;
    }

    public void setWeight(String weight) {
        this.weight = weight;
    }

    public Long getSummaryId() {
        return summaryId;
    }

    public void setSummaryId(Long summaryId) {
        this.summaryId = summaryId;
    }

    public Long getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(Long departmentId) {
        this.departmentId = departmentId;
    }

    public String getExtVal() {
        return extVal;
    }

    public void setExtVal(String extVal) {
        this.extVal = extVal;
    }

    public String getTaskId() {
        return taskId;
    }

    public void setTaskId(String taskId) {
        this.taskId = taskId;
    }

    public String getScore() {
        return score;
    }

    public void setScore(String score) {
        this.score = score;
    }

    public String getKeGuanScore() {
        return keGuanScore;
    }

    public void setKeGuanScore(String keGuanScore) {
        this.keGuanScore = keGuanScore;
    }

    public String getZhuGuanScore() {
        return zhuGuanScore;
    }

    public void setZhuGuanScore(String zhuGuanScore) {
        this.zhuGuanScore = zhuGuanScore;
    }

    public Long getMemberId() {
        return memberId;
    }

    public void setMemberId(Long memberId) {
        this.memberId = memberId;
    }
}
