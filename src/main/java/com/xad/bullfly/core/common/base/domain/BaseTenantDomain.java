package com.xad.bullfly.core.common.base.domain;

import lombok.Data;

import javax.persistence.Column;
import javax.persistence.MappedSuperclass;
import java.io.Serializable;

/**
 * 多租户的基础类
 * Created by liuwenping on 2019/8/27.
 */
@MappedSuperclass
@Data
public abstract class BaseTenantDomain<I extends Serializable> extends BaseDomain<I> {

    @Column(updatable = false,name = "tenant")
    private String tenant;

    @Column(name = "tenant_module_name")
    private String tenantModuleName;

    @Column(name = "tenant_node_name")
    private String tenantNodeName;

}
