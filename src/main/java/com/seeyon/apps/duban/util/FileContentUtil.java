package com.seeyon.apps.duban.util;

import com.seeyon.apps.duban.mapping.MappingCodeConstant;
import org.apache.commons.lang.ArrayUtils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * Created by liuwenping on 2019/11/7.
 */
public final class FileContentUtil {

    public static String readFileContent(File file) throws Exception {

        //File file = new File();
        FileInputStream ins = new FileInputStream(file);
        byte[] buffer = new byte[4096];
        int len = -1;
        StringBuilder stb = new StringBuilder();
        try {
            while ((len = ins.read(buffer)) > 0) {
                if (len == 4096) {
                    stb.append(new String(buffer, "utf-8"));
                } else {
                    stb.append(new String(ArrayUtils.subarray(buffer, 0, len)));
                }

            }
        } catch (Exception e) {
            throw new Exception(e);
        } finally {
            try {
                ins.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return stb.toString();


    }

    public static String readFileContent(String filePath) throws Exception {

        File file = new File(filePath);
        if (!file.exists()) {
            throw new IOException("文件不存在");
        }
        if (file.isDirectory()) {
            throw new IOException("不能读取目录型的文件:" + filePath);
        }
        return readFileContent(file);

    }

    public static File writeContentToFile(File file, String content) throws Exception {

        if (file == null) {
            throw new IOException("文件不能为空");
        }
        if(file.exists()){
            file.delete();
        }
        file.createNewFile();
        if(content==null){
            content="";
        }
        FileOutputStream stream = new FileOutputStream(file);
        try{

            stream.write(content.getBytes("utf-8"));
        }finally {
            try{
                stream.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }


        return file;
    }

    //TEST CASE
    public static void main(String[] args) {

        String path = (MappingCodeConstant.class.getResource("DubanTask.xml").getPath());
        try {
            System.out.println(readFileContent(path));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
