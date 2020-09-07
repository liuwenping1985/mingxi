package com.xad.bullfly.core.common.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 微服务提供者
 * Created by liuwenping on 2019/8/29.
 */
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.TYPE})
public @interface MicroServiceProvider {

    String name() default "";
    String host() default "";
    String port() default "";
    String configClass() default "";
    String[] apis() default "";
}
