package com.xad.bullfly.util;

import com.xad.bullfly.demo.Hook;
import org.springframework.util.StringUtils;

import java.io.*;
import java.nio.charset.Charset;
import java.util.Enumeration;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

/**
 * Created by liuwenping on 2020/8/12.
 */
public class ZipUtil {

    private ZipUtil() {


    }

    public static void unzip(String fileName, String descPath) throws Exception {

        File file = Hook.getFile(fileName);
        if (!file.exists()) {
            throw new FileNotFoundException("找不到文件");
        }
        String code = Hook.getCode(fileName);
        File outputFile = null;

        if (StringUtils.isEmpty(descPath)) {
            String filePath = file.getAbsolutePath();
            if (filePath.lastIndexOf("/") != -1) {
                filePath = filePath.substring(0, filePath.lastIndexOf("/"));
                File f = new File(filePath);
                if (!f.exists() && !f.isDirectory()) {
                    f.mkdirs();
                }
            }
            if (fileName.indexOf(".") > -1) {
                filePath = filePath+File.separator+fileName.substring(0,fileName.indexOf("."));
            }
            outputFile = new File(filePath);
            if (!outputFile.exists()) {
                outputFile.mkdirs();
            }

        } else {
            outputFile = new File(descPath);
            if (!outputFile.exists()) {
                outputFile.mkdirs();
            } else {
                if (!outputFile.isDirectory()) {
                    throw new IllegalArgumentException("输出路径不能为文件");
                }
            }

        }
        String baseOutPath = outputFile.getAbsolutePath();
       // System.out.println("baseOutPath:"+baseOutPath);
        ZipFile zipFile = new ZipFile(file.getAbsolutePath(), Charset.forName(code)); // 处理中文文件名乱码的问题
        Enumeration<? extends ZipEntry> entries = zipFile.entries();
        while (entries.hasMoreElements()) {
            ZipEntry zipEntry = entries.nextElement();
           // System.out.println("zipEntry:"+zipEntry.getName());
            if (zipEntry.isDirectory()) {
                String fPath = baseOutPath + File.separator + zipEntry.getName();
                //System.out.println("zipEntry:"+fPath);
                File f = new File(fPath);
                if (!f.exists() && !f.isDirectory()) {
                    f.mkdirs();
                }

            } else {
                InputStream ins = null;
                BufferedInputStream bis = null;
                FileOutputStream fos = null;
                BufferedOutputStream bos = null;

                try {
                    ins = zipFile.getInputStream(zipEntry);

                    bis = new BufferedInputStream(ins);

                    String path = zipEntry.getName();

                    if (path.lastIndexOf("/") != -1) {
                        path = baseOutPath + File.separator + path.substring(0, path.lastIndexOf("/"));
                        File f = new File(path);
                        if (!f.exists() && !f.isDirectory()) {
                            f.mkdirs();
                        }
                        String fn = zipEntry.getName();
                        fn = fn.substring(fn.lastIndexOf("/"),fn.length());
                        path = path+File.separator+fn;

                    }

                    String fPath = path;
                    fos = new FileOutputStream(fPath);
                    bos = new BufferedOutputStream(fos);
                    byte[] buffer = new byte[2048];
                    int len = -1;
                    while ((len = bis.read(buffer)) > 0) {
                        if (len == 2048) {
                            bos.write(buffer);
                        } else {
                            byte[] tail = new byte[len];
                            System.arraycopy(buffer, 0, tail, 0, len);
                            bos.write(tail);
                        }

                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    closeQuietly(bos, fos, bis, ins);

                }


            }


        }
//        FileOutputStream fos = new FileOutputStream(outputFile);
//        ZipOutputStream zos = new ZipOutputStream(fos);

    }

    private static void closeQuietly(Object... objs) {
        for (Object obj : objs) {
            if (obj instanceof InputStream) {
                closeQuietly((InputStream) obj);
            }
            if (obj instanceof OutputStream) {
                closeQuietly((OutputStream) obj);
            }
        }

    }

    private static void closeQuietly(InputStream ins) {
        try {
            if (ins == null) {
                return;
            }
            ins.close();
        } catch (Exception e) {

        } finally {

        }

    }

    private static void closeQuietly(OutputStream ins) {
        try {
            if (ins == null) {
                return;
            }
            ins.close();
        } catch (Exception e) {

        } finally {

        }

    }

    public static void unzip(String fileName) throws Exception {
        unzip(fileName, null);
    }

    public static void main(String[] args) throws Exception {

         unzip("input.docx");
       // String p = "/Users/liuwenping/Documents/wmm/mingxi/target/classes/com/xad/bullfly/demo/input.docx";
        //System.out.println(p.substring(0, p.lastIndexOf("/")));

    }
}
