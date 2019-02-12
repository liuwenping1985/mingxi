package com.seeyon.apps.kdXdtzXc.base.util;

/**
 * Created by taoan on 2016-8-6.
 */
public class Tool {
    static int setp = 0;

    public static boolean comp(int[] source, int[] des) {
        setp++;
        return setp % 2 == 0;
    }

    public static void main(String[] args) {
        for (int i = 0; i < 500; i++) {
            System.out.println(comp(null, null) + " ,");
        }
    }
}
