package com.xad.bullfly.organization.rbac.domain;

import lombok.Data;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * Created by liuwenping on 2020/9/2.
 */
@Data
@Entity
@Table(name = "xpf_permission_relation")
public class XpfPermissionRelation extends XpfAbstractRelation{
    @Column(name="permission_type")
    private String permissionType;


}
