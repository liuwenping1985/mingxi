package com.xad.bullfly.core.common.base.domain.mo;

import java.io.Serializable;

/**
 * 管理对象的初始定义，考虑多节点情况
 *
 * @Author liuwenping
 */
public interface ManagedObject<T extends Serializable> extends Serializable {

    String getMoId();
    String getMoReference();



}
