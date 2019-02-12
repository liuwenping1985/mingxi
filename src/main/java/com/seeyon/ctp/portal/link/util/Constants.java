package com.seeyon.ctp.portal.link.util;

public class Constants {
    public static final byte   IS_SYSTEM                     = 1;                                      //是否是系统默认
    public static final byte   LINK_STATUS                   = 1;                                      //状态
    //表示对公司所有人员进行授权
    public static final byte   ALL_USER_TYPE                 = 5;
    public static final long   ALL_USER_ID                   = 5;

    public static final int    LINK_COMMON                   = 1;                                      //常用链接
    public static final int    LINK_IN                       = 2;                                      //内部系统
    public static final int    LINK_OUT                      = 3;                                      //外部系统
    public static final int    LINK_KNOWLEDGE                = 4;                                      //知识链接

    public static final byte   PARAM_TRUE                    = 1;                                      //参数是默认的
    public static final byte   PARAM_FALSE                   = 0;                                      //非默认的

    public static final byte   LINK_USER                     = 1;                                      //人员
    public static final byte   LINK_DEPT                     = 2;                                      //部门
    public static final byte   LINK_POST                     = 3;                                      //岗位
    public static final byte   LINK_TEAM                     = 4;                                      //组

    public static final String LINK_CATEGORY_COMMON_KEY      = "link.category.common";
    public static final String LINK_CATEGORY_IN_KEY          = "link.category.in";
    public static final String LINK_CATEGORY_OUT_KEY         = "link.category.out";
    public static final String LINK_CATEGORY_KNOWLEDGE_KEY   = "link.category.knowledge";

    public static final String LINK_CATEGORY_COMMON_NAME     ="常用链接";
    public static final String LINK_CATEGORY_IN_NAME     	 ="内部系统";
    public static final String LINK_CATEGORY_OUT_NAME     	 ="外部系统";
    public static final String LINK_CATEGORY_KNOWLEDGE_NAME  ="知识链接";
    
    public static final long   LINK_CATEGORY_COMMON_ID       = 1;
    public static final long   LINK_CATEGORY_IN_ID           = 2;
    public static final long   LINK_CATEGORY_OUT_ID          = 3;
    public static final long   LINK_CATEGORY_KNOWLEDGE_ID    = 4;

    public static final String LINK_RESOURCE_BASENAME        = "com.seeyon.v3x.link.i18n.LinkResource";

    public static final int    LIST_MORE_TYPE_ALL            = 0;                                      //更多链接所有关联系统
    public static final int    LIST_MORE_TYPE_COMMON         = 1;                                      //更多链接常用链接
    public static final int    LIST_MORE_TYPE_KNOWLEDGE      = 2;                                      //更多链接知识管理
    public static final int    LIST_SYSTEM_SHARE_KNOWLEDGE   = 3;                                      //系统管理员共享知识链接
    public static final int    LIST_MEMBER_SHARE_KNOWLEDGE   = 4;                                      //个人分享知识链接
    public static final int    LIST_SELFCRETE_KNOWLEDGE      = 5;                                      //我新建的知识链接

    public static final int    LINK_CREATOR_TYPE_SYSTEMADMIN = 0;                                      //关联系统系统自定义
    public static final int    LINK_CREATOR_TYPE_MEMBER      = 1;                                      //关联系统人员自定义
}
