package com.xad.bullfly.organization.domain;


import com.xad.bullfly.core.common.base.domain.BaseManagedObjectDomain;
import lombok.Data;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * 一个用户只能绑定在一个实体组织，但可以存在于多个虚拟组织（俗称借调，兼职）。
 *
 * Created by liuwenping on 2019/9/2.
 */
@Data
@Entity
@Table(name = "pf_user")
public class UserDomain extends BaseManagedObjectDomain<Long> {

    @Column(name = "user_name")
    private String userName;


    @Column(name = "user_code")
    private String userCode;
    /**
     * 实体组织部门
     */
    @Column(name = "dept_id")
    private String userDepartmentId;
    /**
     * 实体组织
     */
    @Column(name = "unit_id")
    private String unitId;



    @Column(name="unit_ted")
    private String ted;


}
