package com.xad.bullfly.apps.hhsd.po;

import com.xad.bullfly.core.common.base.domain.BaseTenantDomain;
import com.xad.bullfly.core.common.base.domain.mo.ManagedObject;
import lombok.Data;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.util.Date;

/**
 * Created by liuwenping on 2020/9/7.
 */
@Entity
@Data
@Table(name="hhsd_duban_task_feedback")
public class HhadDubanTaskFeedBack extends BaseTenantDomain<Long> implements ManagedObject {

    @Column(name="task_id")
    private Long taskId;

    @Column(name="member_id")
    private Long memberId;

    @Column(name="member_name")
    private String memberName;

    @Column(name="is_finish")
    private boolean isFinish;

    @Column(name="finish_content")
    private String finishContent;

    @Column(name="finish_date")
    private Date finishDate;
    /**
     * 手动触发，自动触发
     */
    @Column(name="feed_type")
    private String feedType;

    private Float process;

    @Column(name="last_process")
    private Float lastProcess;

    private String status;

    @Column(name="date_time")
    private Date dateTime;

    private String content;

    @Override
    public String getMoId() {
        return String.valueOf(getId());
    }

    @Override
    public String getMoReference() {
        return null;
    }
}
