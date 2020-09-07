package com.xad.bullfly.annotaion;

import org.springframework.security.access.prepost.PreAuthorize;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

/**
 * Created by liuwenping on 2020/9/2.
 */

@Retention(RetentionPolicy.RUNTIME)
@PreAuthorize("hasRole('SUPER_POWER')")
public @interface SuperPowerPermission {
}
