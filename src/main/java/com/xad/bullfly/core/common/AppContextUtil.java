package com.xad.bullfly.core.common;

import com.xad.bullfly.ApplicationStarter;
import org.springframework.context.ApplicationContext;
import org.springframework.core.env.Environment;

/**
 * Created by liuwenping on 2019/9/2.
 */
public final class AppContextUtil {

    public static ApplicationContext getApplicationContext() {
        return ApplicationStarter.getApplicationContext();
    }

    public static <T>  T getBean(String s) {
        return (T)getApplicationContext().getBean(s);
    }

    public static <T> T getBean(Class<T> cls) {

        return getApplicationContext().getBean(cls);
    }

    public String getApplicationName() {
        return getApplicationContext().getApplicationName();
    }

    public Environment getEnvironment() {
        return getApplicationContext().getEnvironment();
    }

}
