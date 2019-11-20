package com.seeyon.apps.duban.util;

import com.seeyon.apps.duban.annotaion.ClobText;
import org.springframework.util.CollectionUtils;

import java.io.File;
import java.io.FileFilter;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.sql.Timestamp;
import java.util.*;

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


    private static List<String> toFieldStringList(Class cls) {
        List<String> fList = new ArrayList<String>();
        Field[] fields = cls.getDeclaredFields();


        List<Field> fieldList = new ArrayList<Field>();
        if (fields != null && fields.length > 0) {
            for (Field field : fields) {
                if(havingGetMethod(cls,field)){
                    fieldList.add(field);
                }

            }
        }
        Class superCls;
        while ((superCls = cls.getSuperclass()) != null) {
            fields = superCls.getDeclaredFields();
            if (fields != null && fields.length > 0) {
                for (Field field : fields) {
                    if(havingGetMethod(cls,field)){
                        fieldList.add(field);
                    }

                }
            }
            cls = superCls;
        }

        for(Field fd:fieldList){

            fList.add(getHBMPropertyString(fd));

        }
        return fList;
    }
    private static String getHBMPropertyString(Field fd){
        String name = fd.getName();
        Class type = fd.getType();
        String typeString = "string";
        String length="512";
        String column = CommonUtils.camelToUnderline(name);

        if(type==Long.class){
            typeString =  "long";
        }
        if(type==String.class){
            ClobText text = fd.getAnnotation(ClobText.class);
            if(text!=null){
                length = text.value();
            }
            typeString = "string";
        }
        if(type==Integer.class||type==Short.class||type==Byte.class){
            typeString="integer";
        }
        if(type==Date.class){
            typeString="date";
        }
        if(type== Timestamp.class){
            typeString="timestamp";
        }
        StringBuilder stb = new StringBuilder();
        if("id".equals(name)){
            stb.append("<id ");
        }else{
            stb.append("<property  " +
                    "not-null=\"false\" ");
            if("string".equals(typeString)){
                stb.append(" length=\""+length+"\" ");
            }
        }
        stb.append(" name=\""+name+"\" column=\""+column+"\" type=\""+typeString+"\"");

        stb.append(" />");
        return stb.toString();

    }
    private static boolean havingGetMethod(Class cls, Field field) {

        String name = field.getName();
        String getMethodName = "get" + name.substring(0, 1).toUpperCase() + name.substring(1);
        try {
            Method method = cls.getMethod(getMethodName);
            return method != null;
        } catch (NoSuchMethodException e) {

        }
        if(field.getType()==Boolean.class){
            String isMethodName = "is" + name.substring(0, 1).toUpperCase() + name.substring(1);
            try {
                Method method = cls.getMethod(isMethodName);
                return method != null;
            } catch (NoSuchMethodException e) {

            }
        }

        return false;

    }

    private static String joinListByToken(List<String> rtList, String token) {
        StringBuilder stb = new StringBuilder();
        for (String tk : rtList) {
            stb.append(tk).append(token);
        }
        return stb.toString();
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

    private static String toXML(Class cls) {

        String head = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
                "<!DOCTYPE hibernate-mapping PUBLIC\n" +
                "        \"-//Hibernate/Hibernate Mapping DTD 3.0//EN\"\n" +
                "        \"http://hibernate.sourceforge.net/hibernate-mapping-3.0.dtd\">";
        StringBuilder stb = new StringBuilder(head);
        String pkgNmae = cls.getPackage().getName();
        stb.append("<hibernate-mapping package=\"" + pkgNmae+ "\">\n");
        stb.append("<class name=\"" + cls.getSimpleName() + "\" table=\"" + CommonUtils.camelToUnderline(cls.getSimpleName()) + "\">");

        List<String> retList = toFieldStringList(cls);
        String tk = joinListByToken(retList, "\n");
        stb.append(tk);

        stb.append("\n</class>");
        stb.append("\n</hibernate-mapping>");

        return stb.toString();
    }

    private static Map<Class, String> toHBMXML(List<Class> classesList) {
        Map<Class, String> data = new HashMap<Class, String>();
        if (!CollectionUtils.isEmpty(classesList)) {
            for (Class cls : classesList) {
                String xml = toXML(cls);
                data.put(cls, xml);
            }

        }

        return data;

    }

    private static Map<Class, File> writeToFile(String rootPath, Map<Class, String> xmlList) {
        Map<Class, File> data = new HashMap<Class, File>();
        if (!CollectionUtils.isEmpty(xmlList)) {
            for (Map.Entry<Class, String> entry : xmlList.entrySet()) {
                Class key = entry.getKey();
                String val = entry.getValue();
                String path = rootPath + key.getSimpleName() + ".hbm.xml";
                File file = new File(path);
                try {
                    FileContentUtil.writeContentToFile(file, val);
                } catch (Exception e) {
                    e.printStackTrace();
                }

                data.put(key, file);
            }
        }
        return data;

    }

    public static void genHBMXML(String inputPath, String outputPath) {

        File rootFile = new File(inputPath);
        List<String> classesNameList = toClassesNameList(rootFile);
        List<Class> classesList = toClassesList(classesNameList);
        Map<Class, String> hbmXmlList = toHBMXML(classesList);
        writeToFile(outputPath, hbmXmlList);

    }

    public static void main(String[] args) {

        genHBMXML("/Users/liuwenping/Documents/wmm/mingxi/target/classes/com/seeyon/apps/duban/po/", "/Users/liuwenping/Documents/wmm/mingxi/src/main/java/com/seeyon/apps/duban/po/");

    }


}
