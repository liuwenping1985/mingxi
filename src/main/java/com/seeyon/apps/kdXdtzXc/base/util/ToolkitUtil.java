package com.seeyon.apps.kdXdtzXc.base.util;


import javax.servlet.http.HttpServletResponse;

import com.seeyon.ctp.util.UUIDLong;
import ognl.Ognl;
import ognl.OgnlException;
import org.apache.commons.lang.time.DateUtils;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by taoanping on 14-8-27.
 * 工具类方法
 */
public class ToolkitUtil {

    public static Long getNewId() {
        return Long.valueOf(UUIDLong.longUUID());
    }

    public static boolean isEqual(String source1, String source2) {
        return (source1 != null) && (source2 != null) && (!"null".equals(source1)) && (!"null".equals(source2)) && (!"".equals(source1)) && (!"".equals(source2)) && (source1.trim().equals(source2.trim()));
    }

    public static boolean isEqual(Object source1, Object source2) {
        return (source1 != null) && (source2 != null) && (!"null".equals(source1)) && (!"null".equals(source2)) && (!"".equals(source1)) && (!"".equals(source2)) && (source1.equals(source2));
    }

    public static void setFiledValue(String expression, Object root, Object value) {
        try {
            System.out.println("设置值 enteryFiled="+expression+"，value="+value);
            Ognl.setValue(expression, root, value);
        } catch (OgnlException e) {
            System.out.println("设置值出现错误 expression="+expression+"，value="+value+"e="+e.getMessage());
            e.printStackTrace();
        }
    }

    public static Date toDate(Object d) {
        if (d == null) return null;
        if (StringUtilsExt.isEqual("java.sql.Date", d.getClass().getName())) {
            java.sql.Date d1 = (java.sql.Date) d;
            return new Date(d1.getTime());
        } else if (StringUtilsExt.isEqual("java.sql.Timestamp", d.getClass().getName())) {
            java.sql.Timestamp d1 = (java.sql.Timestamp) d;
            return new Date(d1.getTime());
        } else {
            System.out.println("日期转换出现其他类型==" + d.getClass().getName());
        }
        return null;
    }


    public static Double add(Double d1, Double d2) {
        if (d1 == null) d1 = 0.0;
        if (d2 == null) d2 = 0.0;
        return d1 + d2;
    }


    public static Integer parseInt(String s, Integer defaultval) {
        Integer res = defaultval;
        try {
            res = Integer.parseInt(s);
        } catch (Exception e) {
            //e.printStackTrace();
        }
        return res;
    }

    public static Boolean parseBoolean(String s, Boolean defaultval) {
        Boolean res = defaultval;
        try {
            res = Boolean.parseBoolean(s);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return res;
    }

    public static Integer parseInt(BigDecimal bg) {
        if (bg == null) return null;
        return bg.intValue();
    }

    public static Long parseLong(BigDecimal bg) {
        if (bg == null) return null;
        return bg.longValue();
    }

    public static Integer parseInt(String bg) {
        if (bg == null) return null;
        return Integer.parseInt(bg);
    }

    public static Double parseDouble(String s, Double defaultval) {
        if (ToolkitUtil.isNull(s)) return defaultval;
        Double dou = defaultval;
        try {
            dou = Double.parseDouble(s);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dou;
    }

    public static String mapToString(Map map) {
        if (map == null) return null;
        StringBuffer sb = new StringBuffer();
        for (Object o : map.keySet()) {
            sb.append(o).append("=").append(map.get(o)).append(",");
        }
        return sb.toString();
    }

    public static Long parseLong(String s, Long defaultval) {
        Long dou = defaultval;
        try {
            dou = Long.parseLong(s);
        } catch (Exception e) {
            System.out.println("格式化Long错误：" + s);
            e.printStackTrace();
        }
        return dou;
    }


    public static Long parseLong(String s) {
        Long dou = null;
        try {
            dou = Long.parseLong(s);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dou;
    }

    public static boolean isEqual(Long source1, Long source2) {
        return (source1 != null) && (source2 != null) && (source1.longValue() == source2.longValue());
    }

    //    "MM/dd/yyyy hh:mm:ss
    public static String formatDate(Date date, String format) {
        if (ToolkitUtil.isNull(date)) return "";
        SimpleDateFormat sdf = new SimpleDateFormat(format);
        return sdf.format(date);
    }


    public static Date parseDate(String dateString) {
        Date date = null;
        try {
            date = DateUtils.parseDate(dateString, new String[]{"yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd"});
        } catch (Exception var3) {
        }
        return date;
    }

    public static Date parseDate(String dateString, String formate) {
        Date date = null;
        try {
            date = DateUtils.parseDate(dateString, new String[]{formate});
        } catch (Exception var3) {
        }
        return date;
    }


    public static String toOracleDate(Date date) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        String formateDate = sdf.format(date);
        return " to_date('" + formateDate + "','yyyy-mm-dd hh24:mi:ss') ";
    }

    public static String getLocationScript(String url) {
        String str = "<script language='JavaScript'>window.location.href='" + url + "'</script>";
        return str;

    }

    public static String getAlert(String message) {
        String str = "<script language='JavaScript'>alert('" + message + "')</script>";
        return str;

    }

    public static boolean isNull(BigDecimal d1) {
        if (d1 == null || d1.equals(new BigDecimal(0))) return true;
        return false;
    }

    public static boolean isNull(Object d1) {
        return d1 == null || "null".equals(d1) || "".equals(d1);
    }

    public static Object getStr(Object str) {
        if (str == null) return "";
        return "-" + str;
    }

    public static Object trim(Object str, String defaultVal) {
        if (str == null) return defaultVal;
        if ("null".equals(str)) return defaultVal;
        if ("".equals(str)) return defaultVal;
        if (str.getClass().getSimpleName().equals("String")) {
            return ((String) str).trim();
        } else {
            return str;
        }
    }

    public static String trimStr(String str, String defaultVal) {
        return (String) ToolkitUtil.trim(str, defaultVal);
    }

    public static String replaceNull(String src) {
        if (ToolkitUtil.isNull(src)) return "";
        return src.replace("null", "");

    }

    public static void write(String str, HttpServletResponse response) throws IOException {
        response.getWriter().write(str);
        response.getWriter().flush();
        response.getWriter().close();
    }

    public static String getEncodeCharSet(String s, String oldCharset, String newCharSet) {
        if (s == null) return null;
        try {
            return new String(s.getBytes(oldCharset), newCharSet);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static String getUUID() {
        return UUID.randomUUID().toString().replace("-", "").toUpperCase();
    }


    public static String formatNumber(Long num) {
        if (num == null) return "";
        DecimalFormat df1 = new DecimalFormat("####.##");
        return df1.format(num);
    }


    //保留Double类型位数，默认保留1位。
    public static String nWeiDouble(double d, int numer) {
        String s = "######0.0";
        if (numer > 0) {
            s = "######0.";
            for (int i = 0; i < numer; i++) {
                s = s + "0";
            }
        }
        DecimalFormat df = new DecimalFormat(s.toString());
        return df.format(d);
    }

    //发票金额拆分多张开票金额
    public static List<String> getQuZheng(double fapiaojine, double kaipiaojine) {
        List<String> list = new ArrayList<String>();
        int zhengshu = (int) Math.floor(fapiaojine / kaipiaojine);//需要开金额的整张数
        double shengyu = fapiaojine % kaipiaojine;//最后剩余一张需要开票的金额
        for (int i = 0; i < zhengshu; i++) {
            list.add(Double.toString(kaipiaojine));
        }
        if (shengyu > 0) {
            list.add(nWeiDouble(shengyu, 2));
        }
        return list;
    }


    public static String findLetter(String str) {
        if (str == null || str.length() == 0) {
            return str;
        }
        char[] chs = str.toCharArray();
        int k = 0;
        for (int i = 0; i < chs.length; i++) {
            if (!isAsciiLetter(chs[i])) {
                break;
            }
            k++;
        }
        return new String(chs, 0, k);
    }

    private static boolean isAsciiLetter(char c) {
        return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z');
    }

    public static String firstLowerCase(String str) {
        return str.substring(0, 1).toLowerCase() + str.substring(1);
    }
}
















