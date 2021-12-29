package com.seeyon.apps.edocduban.vo;

import com.seeyon.v3x.edoc.domain.EdocOpinion;
import com.seeyon.v3x.edoc.domain.EdocSummary;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

public class DubanInfoVo {
    private Long id;
    private Long summaryId;
    private Long dubanState;
    private Long affairId;
    private Timestamp createTime;
    private String docMark;
    private String subject;
    private int edocState;
    private String sendUnit;
    private EdocSummary summary;
    private String nibanOpinion;
    private String leaderOpinion;
    private String transactionOpinion;
    private String workableOpinion;
    private List<EdocOpinion> opinions=new ArrayList<>();
    private  static SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");

    public  DubanInfoVo(EdocSummary summary) {
        this.setCreateTime(summary.getCreateTime());
        this.setDocMark(summary.getDocMark());
        this.setSubject(summary.getSubject());
        this.setSummaryId(summary.getId());
        this.setEdocState(summary.getState());
        this.setSendUnit(summary.getSendUnit().isEmpty()?summary.getSendUnit2():summary.getSendUnit());
    }

    public String getSendUnit() {
        return sendUnit;
    }

    public void setSendUnit(String sendUnit) {
        this.sendUnit = sendUnit;
    }

    public int getEdocState() {
        return edocState;
    }

    public void setEdocState(int edocState) {
        this.edocState = edocState;
    }

    public Long getSummaryId() {
        return summaryId;
    }

    public void setSummaryId(Long summaryId) {
        this.summaryId = summaryId;
    }

    public Timestamp getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Timestamp createTime) {
        this.createTime = createTime;
    }

    public String getDocMark() {
        return docMark;
    }

    public void setDocMark(String docMark) {
        this.docMark = docMark;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getAffairId() {
        return affairId;
    }

    public void setAffairId(Long affairId) {
        this.affairId = affairId;
    }

    public Long getDubanState() {
        return dubanState;
    }

    public void setDubanState(Long dubanState) {
        this.dubanState = dubanState;
    }

    public EdocSummary getSummary() {
        return summary;
    }

    public void setSummary(EdocSummary summary) {
        this.summary = summary;
    }

    public List<EdocOpinion> getOpinions() {
        return opinions;
    }

    public void setOpinions(List<EdocOpinion> opinions) {
        this.opinions = opinions;
    }

    public String getNibanOpinion() {
        return nibanOpinion;
    }

    public void setNibanOpinion(String nibanOpinion) {
        this.nibanOpinion = nibanOpinion;
    }

    public String getLeaderOpinion() {
        return leaderOpinion;
    }

    public void setLeaderOpinion(String leaderOpinion) {
        this.leaderOpinion = leaderOpinion;
    }

    public String getTransactionOpinion() {
        return transactionOpinion;
    }

    public void setTransactionOpinion(String transactionOpinion) {
        this.transactionOpinion = transactionOpinion;
    }

    public String getWorkableOpinion() {
        return workableOpinion;
    }

    public void setWorkableOpinion(String workableOpinion) {
        this.workableOpinion = workableOpinion;
    }
}
