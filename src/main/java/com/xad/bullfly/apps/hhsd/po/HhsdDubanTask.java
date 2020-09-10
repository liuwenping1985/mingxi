package com.xad.bullfly.apps.hhsd.po;

import com.xad.bullfly.core.common.base.domain.BaseTenantDomain;
import com.xad.bullfly.core.common.base.domain.mo.ManagedObject;
import lombok.Data;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.util.Date;

/**
 * 督办任务
 * Created by liuwenping on 2020/9/7.
 */
@Data
@Entity
@Table(name = "hhsd_duban_task")
public class HhsdDubanTask extends BaseTenantDomain<Long> implements ManagedObject {
    @Column(name="task_id")
    private String taskId;
    @Column(name="task_source")
    private Long taskSource;
    @Column(name="task_type")
    private Long taskType;
    private String name;
    @Column(name="descrption")
    private String desc;
    @Column(name="task_attachment")
    private String taskAttachment;
    @Column(name="dead_line")
    private Date deadLine;
    @Column(name="finish_date")
    private Date finishDate;
    private Long period;
    @Column(name="leader_id")
    private Long leaderId;
    @Column(name="leader_name")
    private String leaderName;
    @Column(name="view_leader_ids")
    private String viewLeaderIds;
    @Column(name="view_leader_names")
    private String viewLeaderNames;
    private Long supervisor;
    @Column(name="supervisor_name")
    private String supervisorName;
    private Float process;
    @Column(name="task_status")
    private Integer taskStatus;
    @Column(name="feedback_status")
    private Long feedbackStatus;
    @Column(name="feedback_status_name")
    private String feedbackStatusName;
    @Column(name="task_amount_score")
    private Float taskAmountScore;
    @Column(name="task_feedback_Score")
    private Float taskFeedbackScore;
    @Column(name="task_finish_score")
    private Float taskFinishScore;
    @Column(name="task_score")
    private Float taskScore;
    @Column(name="primary_dept_id")
    private Long primaryDeptId;
    @Column(name="primary_dept_name")
    private String primaryDeptName;
    @Column(name="secondary_dept_ids")
    private String secondaryDeptIds;
    @Column(name="secondary_dept_names")
    private String secondaryDeptNames;

    @Override
    public String getMoId() {
        return String.valueOf(this.getId());
    }

    @Override
    public String getMoReference() {
        return null;
    }
}
