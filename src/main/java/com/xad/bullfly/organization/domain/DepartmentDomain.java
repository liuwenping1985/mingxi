package com.xad.bullfly.organization.domain;

import com.xad.bullfly.core.common.base.domain.BaseManagedObjectDomain;
import lombok.Data;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * 部门，虚拟部门不能直接创建用户 只能拉人即所有的关系都在JoinRelation
 * Created by liuwenping on 2019/9/2.
 */
@Data
@Entity
@Table(name = "pf_department")
public class DepartmentDomain extends BaseManagedObjectDomain<Long> {

    /**
     * 实体组织id
     */
    @Column(name = "unit_id")
    private Long unitId;

    private String name;

    private String level;

    private String path;

    private String code;

    @Column(name = "type_name")
    private String typeName;
    /**
     * 是实体还是虚拟组织
     */
    private String type;

    @Column(name="is_virtual")
    private boolean isVirtual;


}
