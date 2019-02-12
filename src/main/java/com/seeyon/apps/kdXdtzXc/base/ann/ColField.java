package com.seeyon.apps.kdXdtzXc.base.ann;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target({java.lang.annotation.ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
public @interface ColField {

    public abstract boolean pk() default false;

    public abstract String name();

    /**
     * 对应数据库中的表字段
     *
     * @return
     */
    public abstract String colCode() default "";


    /**
     * 格式化
     *
     * @return
     */
    public abstract String format() default "";


}