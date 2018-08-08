package com.seeyon.apps.datakit.util;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.datakit.po.*;
import com.seeyon.ctp.util.json.JSONUtil;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.lang.reflect.Field;
import java.text.SimpleDateFormat;
import java.util.*;

public class DataKitSupporter {

    public static void responseJSON(Object data, HttpServletResponse response)
    {
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control",
                "no-store, max-age=0, no-cache, must-revalidate");
        response.addHeader("Cache-Control", "post-check=0, pre-check=0");
        response.setHeader("Pragma", "no-cache");
        PrintWriter out = null;
        try
        {
            out = response.getWriter();
            out.write(JSONUtil.toJSONString(data));
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }finally{
            try {
                if (out != null) {
                    out.close();
                }
            }finally {

            }

        }
    }
    public static void getFormData(HttpServletRequest request){
        Enumeration<String> names = request.getParameterNames();
        while (names.hasMoreElements()) {
            String strings = (String) names.nextElement();
            String[] parameterValues = request.getParameterValues(strings);
            for (int i = 0;parameterValues!=null&&i < parameterValues.length; i++) {
                /**
                 * items[0][senderName]:oa1
                 * items[0][receiverName]:liuman
                 * items[0][orgName]:中海晟融（北京）资本管理有限公司
                 * items[0][subject]:标题111222333
                 * items[0][linkAddress]:http://www.google.com
                 */
                System.out.println(strings+":"+parameterValues[i]+"\t");


            }
        }

    }
    public static String getPostDataAsString(HttpServletRequest request) throws IOException {
        String jsonString = request.getParameter("items");
        if(!org.springframework.util.StringUtils.isEmpty(jsonString)){
            Map data = new HashMap();
            data.put("items",jsonString);
            return JSON.toJSONString(data);
        }
        String str, wholeStr = "";
        try {
            BufferedReader br = request.getReader();

            while ((str = br.readLine()) != null) {
                wholeStr += str;
            }
            if (br != null) {
                try {
                    br.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }finally {

        }

        return wholeStr;
    }

    public static String genHbmXML() throws IOException {

        Class [] cls = new Class[]{
                Formmain0246.class,
                Formmain0247.class,
                Formmain0248.class,
                Formmain0250.class,
                JQJX.class,
                SPFL.class,
                PPB.class,
                DQXX.class
        };
        //List<String> xmlFileLocation = new ArrayList<String>();
        //filledXmlLocations(cls,xmlFileLocation);


        genXML(cls);

        return "";
    }
    private static String getXmlPath(Class  cls){
        String xmlLocation="D:\\workspace\\mingxi\\src\\main\\java\\com\\seeyon\\apps\\datakit\\po\\xml\\";

        return xmlLocation+cls.getSimpleName()+".hbm.xml";

    }

    /**
     *      <property
     *                 name="startDate"
     *                 column="start_date"
     *                 type="timestamp"
     *                 not-null="false"
     *                 length="256"
     *         />
     * @param clses
     * @param
     */
    private static  void genXML(Class [] clses) throws IOException {

        for(Class cls:clses){
            Field[] fields = cls.getDeclaredFields();
            String tableName = "";
            List<String> propertiesList = new ArrayList<String>();
            for(Field field:fields){
                String name = field.getName();
                if("TABLENAME".equals(name)){
                    try {
                        tableName=(String)field.get(null);
                    } catch (IllegalAccessException e) {
                        tableName= cls.getSimpleName().toLowerCase();
                    }
                    continue;
                }
                propertiesList.add(toFieldColumn(field).toXML());
            }
            if(StringUtils.isEmpty(tableName)){
                tableName = cls.getSimpleName();
            }
            String prefix1="<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
                    "<!DOCTYPE hibernate-mapping PUBLIC\n" +
                    "        \"-//Hibernate/Hibernate Mapping DTD 3.0//EN\"\n" +
                    "        \"http://hibernate.sourceforge.net/hibernate-mapping-3.0.dtd\">\n";
            String prefix2 = "<hibernate-mapping package=\"com.seeyon.apps.datakit.po\">\n";

            String prefix3=" \n<class name=\""+cls.getSimpleName()+"\" table=\""+tableName+"\">";

            StringBuilder stb = new StringBuilder();
            stb.append(prefix1).append(prefix2).append(prefix3);
            for(String pro:propertiesList){
                stb.append(pro).append("\n");
            }

            String tail="    </class>\n" +
                    "</hibernate-mapping>";

            stb.append(tail);
           String filePath =  getXmlPath(cls);
           File f = new File(filePath);
           if(!f.exists()){
               f.createNewFile();
           }
            FileWriter writer = new FileWriter(f);
            writer.write(stb.toString());
            writer.flush();
            writer.close();

        }

    }
    private static FieldColumn toFieldColumn(Field field){
        FieldColumn column = new FieldColumn();
        Class typeCls = field.getType();
        String type="string";
        String length="";
        if(typeCls == String.class){
            length=" length=\"256\"";
        }
        if(typeCls == Date.class){
            type="timestamp";
            length=" length=\"256\"";
        }
        if(typeCls==Integer.class){
            type="integer";
            length=" length=\"16\"";
        }
        if(typeCls==Float.class){
            type="float";
            length="length=\"16\"";
        }
        if(typeCls==Double.class){
            type="double";
            length=" length=\"32\"";
        }
        if(typeCls==Long.class){
            type="long";
            length=" length=\"20\"";
        }
        column.name = field.getName();
        column.column = column.name;
        column.type = type;
        if(column.name.toLowerCase().equals("id")){
            column.length="";
        }else{
            column.length=length;
        }
        column.notNull="false";
        return column;
    }
    static class FieldColumn{
        public String name;
        public String column;
        public String notNull;
        public String type;
        public String length="";
        public String toXML(){
            StringBuilder stb = new StringBuilder();
            if(name.equalsIgnoreCase("id")){
                stb.append("\n<id").append("\n");
            }else{
                stb.append("<property").append("\n");
            }

            stb.append("            name=\""+name+"\"").append("\n");
            stb.append("            column=\""+column+"\"").append("\n");
            stb.append("            type=\""+type+"\"").append("\n");
            if(!name.equalsIgnoreCase("id")){
                stb.append("not-null=\""+notNull+"\"").append("\n");
            }

            stb.append(length).append("\n");
            stb.append(" />");
            return stb.toString();
        }
    }

    public static void main(String[] arhs) throws IOException {
       // System.out.println(genHbmXML());
        Date dt = new Date();
        SimpleDateFormat format = new SimpleDateFormat("YYYYMMddHHmmssSSSFFF");
        System.out.println(format.format(dt));
    }
}
