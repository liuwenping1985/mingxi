package com.seeyon.apps.kdXdtzXc.base.ann;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
/**
 * Created by tap-pcng43 on 2017-10-1.
 */
@Target(value = {ElementType.FIELD})
@Retention(value = RetentionPolicy.RUNTIME)
public @interface XmlField {
    String value() default "";

    boolean toUpper() default true;
}
