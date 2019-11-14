package com.seeyon.apps.duban.util;

import org.springframework.util.CollectionUtils;

import java.io.File;
import java.io.FileFilter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2019/11/14.
 */
public class HbmUtil {


    private static List<String> toClassesNameList(File rootFile) {
        File[] files = rootFile.listFiles(new FileFilter() {
            public boolean accept(File file1) {
                if (file1.isDirectory()) {
                    return false;
                }
                String[] paths = file1.getPath().split("\\.");
                if (paths.length == 2) {
                    if ("class".equals(paths[1])) {
                        return true;
                    }
                }

                return false;
            }
        });
        List<String> classesList = new ArrayList<String>();
        if (files != null && files.length > 0) {
            for (File file : files) {
                String classPath = file.getPath().split("classes/")[1];
                classPath = classPath.replaceAll("/", ".");
                classPath = classPath.substring(0, classPath.length() - 6);
                classesList.add(classPath);
            }
        }

        return classesList;

    }

    private static List<Class> toClassesList(List<String> classNameList) {

        List<Class> classesList = new ArrayList<Class>();
        for (String className : classNameList) {

            try {
                Class cls = Class.forName(className);
                classesList.add(cls);
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            }

        }

        return classesList;

    }

    private static String toXML(Class cls){
        StringBuilder stb = new StringBuilder();
        stb.append("cls:"+cls.getName());
        return stb.toString();
    }

    private static Map<Class, String> toHBMXML(List<Class> classesList) {
        Map<Class, String> data = new HashMap<Class, String>();
        if(!CollectionUtils.isEmpty(classesList)){
            for(Class cls:classesList ){
                String xml = toXML(cls);
                data.put(cls,xml);
            }

        }

        return data;

    }

    private static Map<Class, File> writeToFile(String rootPath,Map<Class, String> xmlList) {
        Map<Class, File> data = new HashMap<Class, File>();
        if(!CollectionUtils.isEmpty(xmlList)){
            for(Map.Entry<Class,String> entry:xmlList.entrySet()){
                Class key = entry.getKey();
                String val = entry.getValue();
                String path = rootPath+key.getSimpleName()+".hbm.xml";
                File file = new File(path);
                try {
                    FileContentUtil.writeContentToFile(file,val);
                } catch (Exception e) {
                    e.printStackTrace();
                }

                data.put(key,file);
            }
        }
        return data;

    }

    public static void genHBMXML(String inputPath, String outputPath) {

        File rootFile = new File(inputPath);
        List<String> classesNameList = toClassesNameList(rootFile);
        List<Class> classesList = toClassesList(classesNameList);
        Map<Class, String> hbmXmlList = toHBMXML(classesList);
        writeToFile(outputPath,hbmXmlList);

    }

    public static void main(String[] args) {

        genHBMXML("/Users/liuwenping/Documents/wmm/mingxi/target/classes/com/seeyon/apps/duban/po/", "/Users/liuwenping/Documents/wmm/mingxi/src/main/java/com/seeyon/apps/duban/po/");

    }


}
