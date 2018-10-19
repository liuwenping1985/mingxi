package com.seeyon.apps.nbd.util;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

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

    private static List<String> AFFAIR_TYPE_LIST = new ArrayList<String>();
        static{
        AFFAIR_TYPE_LIST.add("HTFKSQD_GZFY");
        AFFAIR_TYPE_LIST.add("KJLHTFKSQD_GLFY1");
        AFFAIR_TYPE_LIST.add("KJLHTFKSQD_GLFY2");
        AFFAIR_TYPE_LIST.add("KJLHTFKSQD_YXFY");
        AFFAIR_TYPE_LIST.add("HTFKSQB_FGCL");
        AFFAIR_TYPE_LIST.add("FKSQB_FHTL");
        AFFAIR_TYPE_LIST.add("GLFYBXD1");
        AFFAIR_TYPE_LIST.add("GLFYBXD2");
        AFFAIR_TYPE_LIST.add("FYBXD1");
        AFFAIR_TYPE_LIST.add("FYBXD2");
        AFFAIR_TYPE_LIST.add("YXFYBXD1");
        AFFAIR_TYPE_LIST.add("YXFYBXD2");
        AFFAIR_TYPE_LIST.add("YXFYBXD3");

        AFFAIR_TYPE_LIST.add("GDZCFYBXD1");
        AFFAIR_TYPE_LIST.add("GDZCFYBXD2");
        AFFAIR_TYPE_LIST.add("JKSPD1");
        AFFAIR_TYPE_LIST.add("JKSPD2");
        AFFAIR_TYPE_LIST.add("CLFBXD1");
        AFFAIR_TYPE_LIST.add("CLFBXD2");
        AFFAIR_TYPE_LIST.add("YXCLFBXD1");
        AFFAIR_TYPE_LIST.add("YXCLFBXD2");
        }
    public static void main(String[] args){
        String path = "/Users/liuwenping/Documents/wmm/mingxi/src/main/java/com/seeyon/apps/nbd/plugin/kingdee/po/mapping";
        for(String f:AFFAIR_TYPE_LIST){
            File file = new File(path+"/"+f+".mapping.xml");
            if(!file.exists()){
                try {
                    file.createNewFile();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
