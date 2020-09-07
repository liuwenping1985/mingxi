package com.xad.bullfly.core.common.base.domain;

import com.xad.bullfly.core.common.base.domain.mo.ManagedObject;
import lombok.Data;

import javax.persistence.Column;
import javax.persistence.MappedSuperclass;
import java.io.Serializable;
import java.util.Date;
import java.util.UUID;

/**
 * 基础管理对象,考虑多节点，多租户的情况，分布式数据更新的问题
 * 但默认大多数情况下 数据都是空的
 * 3个id uuid,moid,id 各自有自己的含义，这里故意复杂化，实际可能用一个就可以了
 * Created by liuwenping on 2019/8/27.
 * @Author liuwenping
 */
@MappedSuperclass
@Data
public abstract class BaseManagedObjectDomain<I extends Serializable> extends BaseTenantDomain <I> implements ManagedObject<I> {

    @Column(name = "uuid")
    private String uuid;

    @Column(name = "create_date")
    private Date createDate;

    @Column(name = "update_date")
    private Date updateDate;

    @Column(name = "mo_id")
    private String moId;

    @Column(name = "mo_reference")
    private String moReference;

    @Column(name = "mo_data_version")
    private String moDataVersion;

    @Column(name = "mo_data")
    private String moData;

    @Column(name = "mo_status")
    private String moStatus;

    @Column(name = "mo_lock_status")
    private String moLockStatus;

    @Column(name = "mo_desc")
    private String moDesc;

    @Column(name = "is_deleted")
    private boolean deleted;

    @Column(name = "is_expired")
    private boolean expired;

    @Column(name = "is_enabled")
    private boolean enabled;


    public void setDefaultValue(){
        createDate = new Date();
        uuid= UUID.randomUUID().toString();
        moId = UUID.randomUUID().toString();
    }


}
