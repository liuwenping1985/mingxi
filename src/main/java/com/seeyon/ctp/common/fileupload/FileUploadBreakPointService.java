package com.seeyon.ctp.common.fileupload;

import com.seeyon.apps.nbd.config.Hook;
import com.seeyon.apps.nbd.core.db.DataBaseHandler;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.filemanager.manager.PartitionManager;
import www.seeyon.com.utils.MD5Util;

import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.io.UnsupportedEncodingException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Created by liuwenping on 2018/11/25.
 */
public class FileUploadBreakPointService {

    private PartitionManager partitionManager;


    private PartitionManager getPartitionManager(){
        if(partitionManager == null){
            partitionManager = (PartitionManager)AppContext.getBean("partitionManager");
        }

        return partitionManager;
    }
    public File getCommonFile(String fName,String fSize,Long userId){
        String md5 = userId+"_"+fName+"_"+fSize;
        try {
            String md5Name = MD5Util.MD5(md5);
            String filePath = Hook.class.getResource("").getPath();
            File file = new File(filePath+md5Name);
            return file;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;

    }
//RandomAccessFile raf=new RandomAccessFile(path, "r");
    public RandomAccessFile getBrFile(String fName,String fSize,Long userId){

        String md5 = userId+"_"+fName+"_"+fSize;
        try {
            String md5Name = MD5Util.MD5(md5);
            String filePath = Hook.class.getResource("").getPath();
            //System.out.println(filePath+md5Name);
            File file = new File(filePath+md5Name);
            if(!file.exists()){
                file.createNewFile();
            }
            RandomAccessFile raf = new RandomAccessFile(file,"rw");
            return raf;
        } catch (UnsupportedEncodingException e) {

        } catch (IOException e) {
            e.printStackTrace();
        }


        return null;
    }
    public void deleteFile(String fName,String fSize,Long userId) throws Exception {
        String md5 = userId+"_"+fName+"_"+fSize;
        String md5Name = MD5Util.MD5(md5);
        String filePath = Hook.class.getResource("").getPath();
        //System.out.println(filePath+md5Name);
        File file = new File(filePath+md5Name);
        if(file.exists()){
            file.delete();
        }
        DataBaseHandler.getInstance().removeDataByKey("FILE_UPLOAD",md5Name);


    }
    public static String getFileContentType(String fName){
        Path path = Paths.get(fName);

        try {
            return  Files.probeContentType(path);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }





}
