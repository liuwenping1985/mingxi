package com.seeyon.apps.nbd.util;

/**
 * Created by liuwenping on 2018/9/7.
 */
public class StringUtils {

    public static final boolean isEmpty(String msg){

        if(msg == null ||"".equals(msg)){
            return true;

        }
        return false;

    }
}
