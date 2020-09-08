package com.xad.bullfly.apps.hhsd.repository;

import com.xad.bullfly.apps.hhsd.po.HhsdDubanTaskDelayApply;
import com.xad.bullfly.core.common.base.repository.BaseRepository;
import org.springframework.stereotype.Repository;

/**
 * Created by liuwenping on 2020/9/8.
 */
@Repository
public interface HhsdDubanTaskDelayApplyRepository extends BaseRepository<HhsdDubanTaskDelayApply,Long>{

    public HhsdDubanTaskDelayApply findFirstByTaskId(Long taskId);
}
