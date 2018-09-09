package com.seeyon.apps.nbd.core.form.entity;

/**
 * Created by liuwenping on 2018/9/9.
 */
public class NbdExpression {

    private String type;

    private Object[] values;

    public NbdExpression(String type,Object... objs){
        this.type = type;
        this.values = objs;
    }


}
