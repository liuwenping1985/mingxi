package com.xad.bullfly.organization.domain;

import com.xad.bullfly.core.common.base.domain.BaseManagedObjectDomain;
import lombok.Data;
import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * 登录的东西
 * Created by liuwenping on 2020/9/4.
 */
@Data
@Entity
@Table(name = "pf_user_principal")
public class UserPrincipalDomain extends BaseManagedObjectDomain<Long> {

    private Long userId;

    private Long loginName;

    private String credentials;



}
