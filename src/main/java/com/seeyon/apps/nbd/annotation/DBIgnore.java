package com.seeyon.apps.nbd.annotation;

import java.lang.annotation.*;

/**
 * Created by liuwenping on 2019/1/10.
 */
@Inherited
@Target({ ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
public @interface DBIgnore {
}
