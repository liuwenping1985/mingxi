package com.xad.bullfly.organization.domain;

import com.xad.bullfly.core.common.base.domain.BaseTenantDomain;
import lombok.Data;

import javax.persistence.Column;
import javax.persistence.Entity;

/**
 * Created by liuwenping on 2020/9/4.
 */
@Data
@Entity
public class JoinRelation extends BaseTenantDomain<Long> {

    //对象id
    @Column(name="object_id")
    private Long objectId;

    //挂载的是谁
    private Long reference;

    /**
     * V_D_M
     * V_U_D
     */
    @Column(name="relation_meta")
    private String relationMeta;





}
