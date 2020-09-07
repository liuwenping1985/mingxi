package com.xad.bullfly.core.common.base.domain;

import lombok.Data;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.MappedSuperclass;
import java.io.Serializable;

/**
 * 至少要继承这个类
 * Created by liuwenping on 2019/8/27.
 */
@MappedSuperclass
@Data
public abstract class BaseDomain<I extends Serializable> {

    @Id
    @GeneratedValue(generator = "id")
    @Column(length = 36)
    private I id;


}