package com.seeyon.ctp.common.filemanager.manager;

import com.seeyon.ctp.common.filemanager.event.FileItem;
import org.apache.commons.io.IOUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
/**
 * Created by liuwenping on 2019/1/28.
 */
public class SignFileItem implements FileItem {
    private static final Log log = LogFactory.getLog(SignFileItem.class);
    private String name;
    private long size;
    private final File fileItem;
    private InputStream in = null;
    private List<String> messages = new ArrayList();
    public SignFileItem(String name,long size,File file){
        this.name = name;
        this.size=size;
        this.fileItem = file;
    }
    public String getName() {
        return this.name;
    }

    public String getOriginalFilename() {
        return this.name;
    }

    public String getContentType() {
        return getFileContentType(this.name);
    }

    public long getSize() {
        return this.size;
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
    public InputStream getInputStream() throws IOException {
        FileInputStream ins = new FileInputStream(this.fileItem);
        return ins;
    }

    public void appendMessage(String s) {
        messages.add(s);
    }

    public void setInputStream(InputStream inputStream) throws IOException {
        this.in = inputStream;
    }

    public Collection getMessages() {
        return messages;
    }

    public void saveAs(File file) throws IOException, IllegalStateException {
        if(!file.exists()){
            file.createNewFile();
        }
        FileOutputStream fileOutputStream = new FileOutputStream(file);
        InputStream ins = null;
        try {
            ins = this.getInputStream();
            IOUtils.copy(ins, fileOutputStream);
        } catch (Exception var7) {
            log.error(var7.getLocalizedMessage(), var7);
        } finally {
            try{
                if(ins!=null){
                    ins.close();
                }
            }catch (Exception e){

            }
            fileOutputStream.close();
        }
    }

    public File getFileItem() {
        return fileItem;
    }
}
