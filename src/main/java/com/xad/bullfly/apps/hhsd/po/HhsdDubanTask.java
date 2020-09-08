package com.xad.bullfly.apps.hhsd.po;

import lombok.Data;

import javax.persistence.Entity;
import javax.persistence.Table;
import java.util.Date;

/**
 * 反馈
 * Created by liuwenping on 2020/9/7.
 */
@Data
@Entity
@Table(name = "hhsd_duban_task")
public class HhsdDubanTask {
    private Long id;
    private String taskId;
    private Long taskSource;
    private Long taskType;
    private String name;
    private String desc;
    private String taskAttachment;
    private Date deadLine;
    private Date finishDate;
    private Long period;
    private Long leaderId;
    private String leaderName;
    private String viewLeaderIds;
    private String viewLeaderNames;
    private Long supervisor;
    private String supervisorName;
    private Float process;
    private Integer taskStatus;
    private Long feedbackStatus;
    private String feedbackStatusName;
    private Float taskAmountScore;
    private Float taskFeedbackScore;
    private Float taskFinishScore;
    private Float taskScore;

    private Long primaryDeptId;
    private String primaryName;
    private String secondaryDeptIds;
    private String secondaryDeptNames;
}
