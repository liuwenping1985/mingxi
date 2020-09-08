package com.xad.bullfly.apps.hhsd.po;

import com.xad.bullfly.core.common.base.domain.BaseDomain;
import com.xad.bullfly.core.common.base.domain.mo.ManagedObject;
import lombok.Data;

import javax.persistence.Entity;
import javax.persistence.Table;
import java.util.Date;

/**
 * Created by liuwenping on 2020/9/8.
 */
@Entity
@Data
@Table(name="hhsd_duban_task_finish_apply")
public class HhsdDubanTaskFinishApply extends BaseDomain<Long> implements ManagedObject {
    private Long taskId;
    private Long memberId;
    private String memberName;
    private boolean isFinish;
    private String finishContent;
    private Date finishDate;

    @Override
    public String getMoId() {
        return String.valueOf(this.getId());
    }

    @Override
    public String getMoReference() {
        return null;
    }
}
