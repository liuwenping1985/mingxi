package com.xad.bullfly.organization.rbac.enums;

/**
 * 主要承载 API授权，数据授权，页面授权
 * 强掉一下数据授权，这里退化处理数据授权（即具象化到api）
 * Created by liuwenping on 2020/9/2.
 */
public enum EnumPermissionType {
    API_USER,
    API_USER_GROUP,
    API_ROLE,
    API_ROLE_GROUP,
    PAGE_USER,
    PAGE_USER_GROUP,
    PAGE_ROLE,
    PAGE_ROLE_GROUP
}
