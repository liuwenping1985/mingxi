package com.seeyon.apps.duban.util;

import com.alibaba.fastjson.JSON;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.TextEncoder;


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
    private static SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd");



    public static boolean isEmpty(Collection collection) {
        if (collection == null || collection.isEmpty()) {
            return true;
        }
        return false;
    }

    public static boolean isNotEmpty(Collection collection) {

        return !isEmpty(collection);
    }

    public static boolean isEmpty(Map map) {
        if (map == null || map.isEmpty()) {
            return true;
        }
        return false;
    }

    public static boolean isNotEmpty(Map map) {
        return !isEmpty(map);
    }

    public static boolean isEmpty(String str) {
        if (str == null || str.length() == 0) {
            return true;
        }
        return false;
    }

    public static boolean isNotEmpty(String str) {
        return !isEmpty(str);
    }

    public static boolean isEmpty(Object[] objs) {
        if (objs == null || objs.length == 0) {
            return true;
        }
        return false;
    }

    public static boolean isNotEmpty(Object[] objs) {
        return isEmpty(objs);
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
            if (CommonUtils.isEmpty(dateStr)) {
                return null;
            }
            if (dateStr.trim().length() == "yyyy-MM-dd".length()) {
                return sdf2.parse(dateStr);
            }
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
    public static String formatDateSimple(Date date) {
        try {
            return sdf2.format(date);
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

    private static EnumManager enumManager;

    private static EnumManager getEnumManager() {
        if (enumManager == null) {
            enumManager = (EnumManager) AppContext.getBean("enumManagerNew");
            if (enumManager == null) {
                enumManager = (EnumManager) AppContext.getBean("enumManager");
            }
        }
        return enumManager;

    }


    public static Object getEnumShowValue(Object obj) {

        Long id = getLong(obj);
        if (id == null) {
            return obj;
        }
        try {
            CtpEnumItem item = getEnumManager().getCtpEnumItem(id);
            if (item != null) {
                return item.getShowvalue();
            }
        } catch (Exception e) {

        }
        return obj;
    }

    public static Object getOrgValueByDeptIdAndType(Object obj, int type) {

        Long id = getLong(obj);
        if (id == null) {
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


        } catch (Exception e) {

        }
        return obj;
    }

    public static Map<String, String> genTableDataMapByColumns(List<Map> columnDataList) {
        Map<String, String> dataMap = new HashMap<String, String>();
        for (Map col : columnDataList) {
            dataMap.put("" + col.get("column_name"), "" + col.get("type_name"));
        }
        return dataMap;
    }

    public static OrgManager getOrgManager() {


        return (OrgManager) AppContext.getBean("orgManager");
    }

    public static <T> T copyProIfNotNullReturnSource(T source, T dest) {

        String sourceStr = JSON.toJSONString(source);
        Map sourceMap = JSON.parseObject(sourceStr, HashMap.class);
        String descStr = JSON.toJSONString(dest);
        Map destMap = JSON.parseObject(descStr, HashMap.class);
        for (Object key : destMap.keySet()) {
            Object dt = destMap.get(key);
            if (dt != null) {
                sourceMap.put(key, dt);
            }
        }
        return (T) JSON.parseObject(JSON.toJSONString(sourceMap), source.getClass());

    }



    public static String getGetMethodName(Field fd) {
        String preFix = "get";
        if (fd.getType() == Boolean.class) {

            preFix = "is";

        }
        String fdName = fd.getName();
        String sName = preFix + fdName.substring(0, 1).toUpperCase() + fdName.substring(1);

        return sName;

    }

    public static final char UNDERLINE = '_';

    public static String camelToUnderline(String param) {
        if (param == null || "".equals(param.trim())) {
            return "";
        }
        int len = param.length();
        StringBuilder sb = new StringBuilder(len);
        for (int i = 0; i < len; i++) {
            char c = param.charAt(i);
            if (Character.isUpperCase(c) && i > 0) {
                sb.append(UNDERLINE);
                sb.append(Character.toLowerCase(c));
            } else {
                sb.append(c);
            }
        }
        return sb.toString().toLowerCase();
    }

    public static String underlineToCamel(String param) {
        if (param == null || "".equals(param.trim())) {
            return "";
        }
        int len = param.length();
        StringBuilder sb = new StringBuilder(len);
        for (int i = 0; i < len; i++) {
            char c = param.charAt(i);
            if (c == UNDERLINE) {
                if (++i < len) {
                    sb.append(Character.toUpperCase(param.charAt(i)));
                }
            } else {
                sb.append(c);
            }
        }
        return sb.toString();
    }


    public static String join(List<String> objs,String token){
        if(isEmpty(objs)){
            return "";
        }
        StringBuilder stb = new StringBuilder();
        int index=0;
        for(String obj:objs){
            if(index==0){
                stb.append(obj);
            }else{
                stb.append(token).append(obj);
            }
            index++;

        }
        return stb.toString();
    }
    public static void main(String[] args) {
        String k = "/1.0/R21idGlaZmJzMzEyMSI=";
        System.out.println(TextEncoder.decode(k));


    }
}
