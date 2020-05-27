package com.seeyon.apps.duban.po;

import com.seeyon.ctp.common.po.BasePO;

/**
 * Created by liuwenping on 2020/5/26.
 */
public class DubanScoreRecord extends BasePO {

    private String taskId;

    private String score;

    private String kgScore;

    private String zgScore;

    private Long memberId;

    private Long affairId;

    private String extVal;

    public Long getAffairId() {
        return affairId;
    }

    public void setAffairId(Long affairId) {
        this.affairId = affairId;
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

    public String getKgScore() {
        return kgScore;
    }

    public void setKgScore(String kgScore) {
        this.kgScore = kgScore;
    }

    public String getZgScore() {
        return zgScore;
    }

    public void setZgScore(String zgScore) {
        this.zgScore = zgScore;
    }

    public Long getMemberId() {
        return memberId;
    }

    public void setMemberId(Long memberId) {
        this.memberId = memberId;
    }
}
