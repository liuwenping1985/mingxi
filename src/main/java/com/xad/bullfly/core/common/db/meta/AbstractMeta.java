package com.xad.bullfly.core.common.db.meta;

import com.xad.bullfly.core.common.base.domain.BaseManagedObjectDomain;
import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;

/**
 * Created by liuwenping on 2019/8/19.
 * @Author liuwenpping
 */
@Data
@MappedSuperclass
public abstract class AbstractMeta<T extends Serializable> extends BaseManagedObjectDomain<T> {

    @Column(name = "meta_name")
    private String metaName;
    @Column(name = "meta_type")
    private String metaType;
    @Column(name = "meta_rule")
    private String metaRule;


}
