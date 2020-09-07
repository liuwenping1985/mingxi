package com.xad.bullfly.organization.domain;

import com.xad.bullfly.core.common.base.domain.BaseManagedObjectDomain;
import lombok.Data;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * 单位,组织
 * Created by liuwenping on 2019/9/2.
 */
@Data
@Entity
@Table(name = "pf_unit")
public class UnitDomain extends BaseManagedObjectDomain<Long> {
    @Column(name = "type_name")
    private String typeName;
    /**
     * 是实体还是虚拟组织
    */
    private String type;

    private String code;

    private String name;

    @Column(name="is_root")
    private boolean isRoot;

    @Column(name="is_virtual")
    private boolean isVirtual;



}
