package com.xad.bullfly.apps.hhsd.po;

import com.xad.bullfly.core.common.base.domain.BaseTenantDomain;
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
@Table(name="hhsd_duban_task_delay_apply")
public class HhsdDubanTaskDelayApply extends BaseTenantDomain<Long> implements ManagedObject {

    private Long taskId;
    private Long memberId;
    private String memberName;
    private String content;
    private Date finishDate;
    private Date dateTime;

    @Override
    public String getMoId() {
        return String.valueOf(getId());
    }

    @Override
    public String getMoReference() {
        return null;
    }
}
