package com.seeyon.apps.kdXdtzXc.base.ann;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target({java.lang.annotation.ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface POJO {
    public abstract String tableName() default "";

    public abstract String desc() default "";
}