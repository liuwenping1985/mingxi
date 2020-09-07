package com.xad.bullfly.organization.rbac.domain;

import com.xad.bullfly.core.common.base.domain.BaseManagedObjectDomain;
import lombok.Data;

import javax.persistence.Column;
import javax.persistence.MappedSuperclass;

/**
 * Created by liuwenping on 2020/9/4.
 */
@MappedSuperclass
@Data
public abstract class XpfAbstractRelation extends BaseManagedObjectDomain<Long> {
    /**
     * 关联id
     */
    private Long reference;
    /**
     * 关联id
     */
    @Column(name="sub_reference")
    private Long subReference;
    /**
     * 关联的对象id
     */
    @Column(name="reference_object")
    private Long referenceObject;

    /**
     * 关联的对象id
     */
    @Column(name="sub_reference_object")
    private Long subReferenceObject;
    /**
     * 扩展ext_reference
     */
    @Column(name="ext_reference")
    private String extReference;
    /**
     * 扩展ext_reference_object
     */
    @Column(name="ext_reference_object")
    private String extReferenceObject;
}
