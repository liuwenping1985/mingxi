package com.xad.bullfly.annotaion;

import javax.annotation.security.PermitAll;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

/**
 * Created by liuwenping on 2020/9/2.
 */
@Retention(RetentionPolicy.RUNTIME)
@PermitAll
public @interface AnonymousPermission {
}
