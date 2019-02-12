package com.seeyon.apps.kdXdtzXc.rest.util;

/**
 * Created by taoan on 2017-1-15.
 */
public class TempInstance {
    public static Object getTempBean(Class clazz) {
        try {
            return clazz.newInstance();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
        return null;

    }
}
