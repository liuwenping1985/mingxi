package com.xad.bullfly.organization.rbac.domain;

import com.xad.bullfly.core.common.base.domain.BaseManagedObjectDomain;
import lombok.Data;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * Created by liuwenping on 2020/9/2.
 */
@Data
@Entity
@Table(name = "xpf_resource")
public class XpfResource extends BaseManagedObjectDomain<Long> {

    private String name;
    private String type;
    private String value;

    @Column(name="ext_string")
    private String extString;
    @Column(name="ext_Integer")
    private Integer extInteger;

}
