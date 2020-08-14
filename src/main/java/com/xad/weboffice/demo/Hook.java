package com.xad.weboffice.demo;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;

/**
 * Created by liuwenping on 2020/8/12.
 */
public final class Hook {

    private Hook(){


    }

    public static File getFile(String fileName){
        String path = Hook.class.getResource(fileName).getPath();
        return new File(path);

    }
    public static String getCode(String fileName) throws Exception {
        String path = Hook.class.getResource(fileName).getPath();
        InputStream inputStream = new FileInputStream(path);
        byte[] head = new byte[3];
        inputStream.read(head);
        String code = "GBK"; // 或GBK
        if (head[0] == -1 && head[1] == -2)
            code = "UTF-16";
        else if (head[0] == -2 && head[1] == -1)
            code = "Unicode";
        else if (head[0] == -17 && head[1] == -69 && head[2] == -65)
            code = "UTF-8";
        inputStream.close();
        return code;
    }
}
