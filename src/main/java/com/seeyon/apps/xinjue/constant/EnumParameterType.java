package com.seeyon.apps.xinjue.constant;

import com.seeyon.apps.xinjue.po.*;

/**

 * 1101	批发销售
 * 	批发销售明细
 * 1201   批发销售数据回传
 * 001-销售出货
 * 002-销售退货
 * 003-无批发单退货
 * 004-赠送单
 * 005-赠送单退货；
 * 006-临时额度申请单
 * 007-自动发票申请
 * 008-特殊发票申请
 * 009-内部领用单
 * 010-配送单
 * 011-配送退货
 * 012-物流移库
 * 013-连锁移库
 * 014-报损单
 * 015-报溢单
 * 016-采购合同
 * 017-采购单
 * 018-采购退货
 * 019-锁定库存
 * 100-税控相关
 */
public enum EnumParameterType {

    BILL("1001",Formmain1465.class),
    WAREHOUSE("1002",Formmain1464.class),
    ORG("1003",Formmain1468.class),
    CUSTOM("1004",Formmain1466.class),
    COMMODITY("1007",Formmain1467.class);
    private String code;
    private Class cls;
    public String getCode(){
        return this.code;
    }
    public Class getCls(){
        return this.cls;
    }
    private EnumParameterType(String code,Class cls){
        this.code = code;
        this.cls = cls;
    }

}
