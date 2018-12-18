package com.seeyon.apps.nbd.core.util;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.util.UIUtils;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by liuwenping on 2018/9/7.
 */
public class CommonUtils {
    private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    public static boolean isEmpty(Collection collection) {
        if (collection == null || collection.isEmpty()) {
            return true;
        }
        return false;
    }

    public static boolean isEmpty(Map map) {
        if (map == null || map.isEmpty()) {
            return true;
        }
        return false;
    }

    public static boolean isEmpty(String str) {
        if (str == null || str.length() == 0) {
            return true;
        }
        return false;
    }

    public static boolean isEmpty(Object[] objs) {
        if (objs == null || objs.length == 0) {
            return true;
        }
        return false;
    }

    public static Long paserLong(Object obj) {
        if (obj == null) {
            return null;
        }
        Long val = null;
        try {
            val = Long.parseLong(String.valueOf(obj));
        } finally {
            return val;
        }

    }

    public static Long getLong(Object obj) {
        if (obj == null) {
            return null;
        }
        if (obj instanceof Long) {
            return (Long) obj;
        }
        if (obj instanceof BigDecimal) {
            return ((BigDecimal) obj).longValue();
        }
        Long val = null;
        try {
            val = Long.parseLong(String.valueOf(obj));
        } finally {
            return val;
        }

    }

    public static Date parseDate(String dateStr) {
        try {
            Date dt = sdf.parse(dateStr);
            return dt;
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static String formatDate(Date date) {
        try {
            return sdf.format(date);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static int getYear(String dtStr) {

        return getYear(parseDate(dtStr));
    }

    public static int getYear(Date dt) {
        Calendar calendar = Calendar.getInstance();
        if (dt != null) {
            calendar.setTime(dt);
        }
        return calendar.get(Calendar.YEAR);
    }

    public static int getYear() {

        return getYear(new Date());
    }

    public static void hack(String[] args) throws InterruptedException, IOException {
        // Class c1 = MclclzUtil.ioiekc("com.seeyon.ctp.login.LoginHelper");

        //  ClassPool pool = ClassPool.getDefault();
        UIUtils u = new UIUtils();
        byte[] bytes = u.loadClassData("com.seeyon.ctp.product.ProductInfo");
        //  pool.getClassLoader()
        String path = "/Users/liuwenping/Documents/wmm/ProductInfo.class";
        File f = new File(path);
        if (f.exists()) {
            f.delete();
            f.createNewFile();

        } else {
            f.createNewFile();
        }
        FileOutputStream out = new FileOutputStream(f);
        out.write(bytes);
        out.flush();
        out.close();
    }

    public static String unicodeEncoding(final String gbString) {   //gbString = "测试"
        char[] utfBytes = gbString.toCharArray();   //utfBytes = [测, 试]
        String unicodeBytes = "";
        for (int byteIndex = 0; byteIndex < utfBytes.length; byteIndex++) {
            String hexB = Integer.toHexString(utfBytes[byteIndex]);   //转换为16进制整型字符串
            if (hexB.length() <= 2) {
                hexB = "00" + hexB;
            }
            unicodeBytes = unicodeBytes + "\\u" + hexB;
        }
        System.out.println("unicodeBytes is: " + unicodeBytes);
        return unicodeBytes;

    }

//    private static EnumManager enumManager;
//
//    private static EnumManager getEnumManager(){
//        if(enumManager==null){
//            enumManager = (EnumManager)AppContext.getBean("enumManagerNew");
//        }
//        return enumManager;
//
//    }
//    private static OrgManager orgManager;
//    private static OrgManager getOrgManager(){
//        if(orgManager==null){
//            orgManager = (OrgManager)AppContext.getBean("orgManager");
//        }
//        return orgManager;
//
//    }

    public static Object getEnumShowValue(Object obj){

        Long id = getLong(obj);
        if(id == null){
            return obj;
        }
        try {
//            CtpEnumItem item = getEnumManager().getEnumItem(id);
//            if (item != null) {
//                return item.getShowvalue();
//            }
        }catch(Exception e){

        }
        return obj;
    }
    public static Object getOrgValueByDeptIdAndType(Object obj,int type){

        Long id = getLong(obj);
        if(id == null){
            return obj;
        }
        try {
////            V3xOrgDepartment department = getOrgManager().getDepartmentById(id);
////            if (department == null) {
////                return obj;
////            }
////            if(type==0){
////                String code = department.getCode();
////                if(CommonUtils.isEmpty(code)){
////                    return department.getName();
////                }
////                return code;
////            }else{
////                Long accountId = department.getOrgAccountId();
////                V3xOrgAccount account = getOrgManager().getAccountById(accountId);
////                if(account==null){
////                    return obj;
////                }
////                String code = account.getCode();
////                if(CommonUtils.isEmpty(code)){
////                    return account.getName();
////                }
////                return code;
//
//            }


        }catch(Exception e){

        }
        return obj;
    }

    public static <T> T  copyProIfNotNullReturnSource(T source,T dest){

        String sourceStr = JSON.toJSONString(source);
        Map sourceMap = JSON.parseObject(sourceStr,HashMap.class);
        String descStr = JSON.toJSONString(dest);
        Map destMap = JSON.parseObject(descStr,HashMap.class);
        for(Object key:destMap.keySet()){
            Object dt = destMap.get(key);
            if(dt!=null){
                sourceMap.put(key,dt);
            }
        }
        return (T) JSON.parseObject(JSON.toJSONString(sourceMap),source.getClass());

    }
    public static void processCrossOriginResponse(HttpServletResponse response){
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Credentials", "true");
        response.setHeader("Access-Control-Allow-Methods", "GET, HEAD, POST, PUT, DELETE, TRACE, OPTIONS, PATCH");
        response.setHeader("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type,Token,Accept, Connection, User-Agent, Cookie");
        response.setHeader("Access-Control-Max-Age", "3628800");
    }
    public static String getGetMethodName(Field fd){
        String preFix = "get";
        if(fd.getType()==Boolean.class){

            preFix = "is";

        }
        String fdName = fd.getName();
        String sName =preFix+ fdName.substring(0,1).toUpperCase()+fdName.substring(1);

        return sName;

    }
    public static final char UNDERLINE='_';
    public static String camelToUnderline(String param){
        if (param==null||"".equals(param.trim())){
            return "";
        }
        int len=param.length();
        StringBuilder sb=new StringBuilder(len);
        for (int i = 0; i < len; i++) {
            char c=param.charAt(i);
            if (Character.isUpperCase(c)&&i>0){
                sb.append(UNDERLINE);
                sb.append(Character.toLowerCase(c));
            }else{
                sb.append(c);
            }
        }
        return sb.toString().toLowerCase();
    }
    public static String underlineToCamel(String param){
        if (param==null||"".equals(param.trim())){
            return "";
        }
        int len=param.length();
        StringBuilder sb=new StringBuilder(len);
        for (int i = 0; i < len; i++) {
            char c=param.charAt(i);
            if (c==UNDERLINE){
                if (++i<len){
                    sb.append(Character.toUpperCase(param.charAt(i)));
                }
            }else{
                sb.append(c);
            }
        }
        return sb.toString();
    }
    public static void main(String[] args) {
        String k = "show_me_the_money";
        System.out.println(underlineToCamel(k));



    }
}
