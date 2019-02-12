package com.seeyon.apps.kdXdtzXc.base.util;

import javax.servlet.ServletContext;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.net.URLEncoder;
import java.sql.Blob;
import java.sql.Clob;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.*;
import java.util.regex.Pattern;

/**
 * @author binge
 * @time 2010-8-20 12:03:25
 * @todo:
 */
public class StringUtilsExt extends StringUtils {

    public static String randomUUID() {
        return UUID.randomUUID().toString().replace("-", "");
    }

    public static boolean isWindows() {
        boolean flag = false;
        if (System.getProperties().getProperty("os.name").toUpperCase().indexOf("WINDOWS") != -1) {
            flag = true;
        }
        return flag;
    }

    public static String getSafeValue(String value) {
        return getSafeValue(value, "");
    }

    public static String getSafeValue(String value, String defalutValue) {
        if (value == null)
            return defalutValue;
        return value;
    }

    public static String getRealFilePath(String resourcePath) {
        java.net.URL inputURL = StringUtilsExt.class.getResource(resourcePath);
        String filePath = inputURL.getFile();
        if (filePath.startsWith("/")) {
            filePath = filePath.substring(1);
        }
        return filePath;
    }

    public static String formatDateToHMSString(Date date) {
        if (date == null) {
            return "";
        }

        java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("HH:mm:ss");

        return dateFormat.format(date);

    }

    public static Date parseHMSStringToDate(String input) {
        java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("HH:mm:ss");

        try {
            return dateFormat.parse(input);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        return null;
    }

    public static String formatDateToMysqlString(Date date) {
        if (date == null) {
            return "";
        }

        java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        return dateFormat.format(date);

    }

    public static Date parseStringToMysqlDate(String input) {
        java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        try {
            return dateFormat.parse(input);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        return null;
    }

    public static String formatDateToMMddHHmm(Date date) {
        if (date == null) {
            return "";
        }

        java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("MM月dd日 HH:mm");

        return dateFormat.format(date);
    }

    public static String formatDateToyyMMddHHmm(Date date) {
        if (date == null) {
            return "";
        }

        java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yy年MM月dd日HH:mm");

        return dateFormat.format(date);
    }

    public static String genTimeStampString(Date date) {
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyyMMddHHmmss.SSS");
        return df.format(date);
    }

    // 相当于javascript里的escape
    public static String escape(String src) {
        int i;
        char j;
        StringBuffer tmp = new StringBuffer();
        tmp.ensureCapacity(src.length() * 6);
        for (i = 0; i < src.length(); i++) {
            j = src.charAt(i);
            if (Character.isDigit(j) || Character.isLowerCase(j) || Character.isUpperCase(j))
                tmp.append(j);
            else if (j < 256) {
                tmp.append("%");
                if (j < 16)
                    tmp.append("0");
                tmp.append(Integer.toString(j, 16));
            } else {
                tmp.append("%u");
                tmp.append(Integer.toString(j, 16));
            }
        }
        return tmp.toString();
    }

    // 相当于javascript里的unescape,此方法用户对中文escape编码后使用
    public static String unescape(String src) {
        if (StringUtilsExt.isNullOrNone(src))
            return null;
        StringBuffer tmp = new StringBuffer();
        tmp.ensureCapacity(src.length());
        int lastPos = 0, pos = 0;
        char ch;
        while (lastPos < src.length()) {
            pos = src.indexOf("%", lastPos);
            if (pos == lastPos) {
                if (src.charAt(pos + 1) == 'u') {
                    ch = (char) Integer.parseInt(src.substring(pos + 2, pos + 6), 16);
                    tmp.append(ch);
                    lastPos = pos + 6;
                } else {
                    ch = (char) Integer.parseInt(src.substring(pos + 1, pos + 3), 16);
                    tmp.append(ch);
                    lastPos = pos + 3;
                }
            } else {
                if (pos == -1) {
                    tmp.append(src.substring(lastPos));
                    lastPos = src.length();
                } else {
                    tmp.append(src.substring(lastPos, pos));
                    lastPos = pos;
                }
            }
        }
        return tmp.toString();
    }

    /**
     * 字符串转换unicode
     */
    public static String string2Unicode(String string) {
        StringBuffer unicode = new StringBuffer();
        for (int i = 0; i < string.length(); i++) {
            // 取出每一个字符
            char c = string.charAt(i);
            // 转换为unicode
            unicode.append("\\u" + Integer.toHexString(c));
        }
        return unicode.toString();
    }

    /**
     * unicode 转字符串
     */
    public static String unicode2String(String unicode) {
        StringBuffer string = new StringBuffer();
        String[] hex = unicode.split("\\\\u");
        for (int i = 1; i < hex.length; i++) {
            // 转换出每一个代码点
            int data = Integer.parseInt(hex[i], 16);
            // 追加成string
            string.append((char) data);
        }
        return string.toString();
    }

    /**
     * URLEncoder.encode(s, "UTF-8")
     */
    public static String toURLEncoderUtf8(String s) {
        if (s == null || s.length() == 0)
            return "";
        String utf8Str = null;
        try {
            utf8Str = URLEncoder.encode(s, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            utf8Str = s;
        }
        return utf8Str;
    }

    /**
     * 功能: 对中文进行编码，此方法可以对URL包括斜线例如/aaa/中文/bbb进行编码，斜线不会被编码 此方法相当于URLEncoder.encode(s, "UTF-8")，但这个方法不能使用在URL，斜线会被编码 此法编码后使用URLDecoder.decode(s, "UTF-8")进行解码
     */
    public static String toUtf8String(String s) {
        if (s == null || s.length() == 0)
            return "";
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c >= 0 && c <= 255) {
                sb.append(c);
            } else {
                byte[] b;
                try {
                    b = Character.toString(c).getBytes("utf-8");
                } catch (Exception ex) {
                    b = new byte[0];
                }
                for (int j = 0; j < b.length; j++) {
                    int k = b[j];
                    if (k < 0)
                        k += 256;
                    sb.append("%" + Integer.toHexString(k).toUpperCase());
                }
            }
        }
        return sb.toString();
    }

    public static String replace(String source, String oldStr, String newStr) {
        return replace(source, oldStr, newStr, true);
    }

    public static String replace(String source, String oldStr, String newStr, boolean matchCase) {
        if (source == null) {
            return null;
        }
        if (source.toLowerCase().indexOf(oldStr.toLowerCase()) == -1) {
            return source;
        }
        int findStartPos = 0;
        int a = 0;
        while (a > -1) {
            int b = 0;
            String str1, str2, str3, str4, strA, strB;
            str1 = source;
            str2 = str1.toLowerCase();
            str3 = oldStr;
            str4 = str3.toLowerCase();
            if (matchCase) {
                strA = str1;
                strB = str3;
            } else {
                strA = str2;
                strB = str4;
            }
            a = strA.indexOf(strB, findStartPos);
            if (a > -1) {
                b = oldStr.length();
                findStartPos = a + b;
                StringBuffer bbuf = new StringBuffer(source);
                source = bbuf.replace(a, a + b, newStr) + "";
                findStartPos = findStartPos + newStr.length() - b;
            }
        }
        return source;
    }

    public static String trimHeadSpaces(String input) {
        if (isEmpty(input)) {
            return "";
        }
        String trimedString = input.trim();
        if (trimedString.length() == input.length()) {
            return input;
        }
        return input.substring(input.indexOf(trimedString) + trimedString.length(), input.length());
    }

    /**
     * 去掉所有空格
     *
     * @param input
     * @return
     */
    public static String trimAllSpaces(String input) {
        if (isEmpty(input)) {
            return "";
        }
        return input.replaceAll("( )+", " ");
    }

    public static String trimTailSpaces(String input) {
        if (isEmpty(input)) {
            return "";
        }

        String trimedString = input.trim();

        if (trimedString.length() == input.length()) {
            return input;
        }

        return input.substring(0, input.indexOf(trimedString) + trimedString.length());
    }

    public static String clearNull(String input) {
        return isEmpty(input) ? "" : input;
    }

    public static String slitString(String input, int maxLength) {
        if (isEmpty(input))
            return "";

        if (input.length() <= maxLength) {
            return input;
        } else {
            return input.substring(0, maxLength - 3) + "...";
        }

    }

    public static String replaceHtmlToText(String input) {
        if (isEmpty(input)) {
            return "";
        }
        return setBr(setTag(input));
    }

    public static String setTag(String s) {
        int j = s.length();
        StringBuffer stringbuffer = new StringBuffer(j + 500);
        char ch;
        for (int i = 0; i < j; i++) {
            ch = s.charAt(i);
            if (ch == '<') {
                stringbuffer.append("&lt");
            } else if (ch == '>') {
                stringbuffer.append("&gt");
            } else if (ch == '&') {
                stringbuffer.append("&amp");
            } else if (ch == '%') {
                stringbuffer.append("%%");
            } else {
                stringbuffer.append(ch);
            }
        }

        return stringbuffer.toString();
    }

    public static String setBr(String s) {
        int j = s.length();
        StringBuffer stringbuffer = new StringBuffer(j + 500);
        for (int i = 0; i < j; i++) {

            if (s.charAt(i) == '\n' || s.charAt(i) == '\r') {
                continue;
            }
            stringbuffer.append(s.charAt(i));
        }

        return stringbuffer.toString();
    }

    public static String setNbsp(String s) {
        int j = s.length();
        StringBuffer stringbuffer = new StringBuffer(j + 500);
        for (int i = 0; i < j; i++) {
            if (s.charAt(i) == ' ') {
                stringbuffer.append("&nbsp;");
            } else {
                stringbuffer.append(s.charAt(i) + "");
            }
        }
        return stringbuffer.toString();
    }

    public static boolean isNumeric(String input) {
        if (isEmpty(input)) {
            return false;
        }
        for (int i = 0; i < input.length(); i++) {
            char charAt = input.charAt(i);

            if (!Character.isDigit(charAt)) {
                return false;
            }
        }
        return true;
    }

    public static String toChi(String input) {
        try {
            byte[] bytes = input.getBytes("ISO8859-1");
            return new String(bytes, "GBK");
        } catch (Exception ex) {
        }
        return input;
    }

    public static String toISO(String input) {
        return changeEncoding(input, "GBK", "ISO8859-1");
    }

    public static String changeEncoding(String input, String sourceEncoding, String targetEncoding) {
        if (input == null || input.equals("")) {
            return input;
        }

        try {
            byte[] bytes = input.getBytes(sourceEncoding);
            return new String(bytes, targetEncoding);
        } catch (Exception ex) {
        }
        return input;
    }

    public static String replaceQuota(String input) {
        return replace(input, "'", "''");
    }

    public static String encode(String value, String encoding) {
        if (isEmpty(value)) {
            return "";
        }
        String _encoding = "UTF-8";
        if (!isEmpty(encoding))
            _encoding = encoding;
        try {
            value = URLEncoder.encode(value, _encoding);
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return value;
    }

    /**
     * (1)javascript url&name=encodeURIComponent("中文") 解码new String(request.getParameter("fileName").getBytes("ISO8859-1"), "utf-8") (2)javascript url&name=encodeURIComponent(encodeURIComponent("中文")) 解码java.net.URLDecoder.decode(request.getParameter("name"), "UTF-8")
     */
    public static String decode(String value, String encoding) {
        if (isEmpty(value)) {
            return "";
        }
        String _encoding = "GBK";
        if (isEmpty(encoding))
            encoding = _encoding;
        try {
            return java.net.URLDecoder.decode(value, encoding);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return value;
    }

    public static boolean isEmpty(String input) {
        return (input == null || input.length() == 0);
    }

    public static boolean isEmpty(String[] source) {
        return source == null || source.length == 0;
    }

    public static boolean isEmpty(List<Object> items) {
        return items == null || items.size() == 0;
    }

    public static String isEmpty(String input, String errorMsg) {
        if (isEmpty(input)) {
            return errorMsg;
        }
        return "";
    }

    public static int getBytesLength(String input) {
        if (input == null) {
            return 0;
        }
        int bytesLength = input.getBytes().length;
        return bytesLength;
    }

    public static String getCookieValue(HttpServletRequest request, String name) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) {
            return "";
        }
        for (int i = 0; i < cookies.length; i++) {
            Cookie cookie = cookies[i];
            if (cookie.getName().equals(name)) {
                return decode(cookie.getValue(), request.getCharacterEncoding());
            }
        }
        return "";
    }

    /**
     * 把传进来的数组参数值,进行ISO8859-1到encoding的转换
     *
     * @param request
     * @param name
     * @param encoding
     * @return
     */
    public static String[] getParameterValuesWithEncoding(HttpServletRequest request, String name, String encoding) {
        String _encoding = request.getCharacterEncoding();
        if (encoding.equalsIgnoreCase(_encoding) || encoding.equalsIgnoreCase(_encoding))
            return request.getParameterValues(name);
        String values[] = request.getParameterValues(name);
        if (values != null && values.length > 0) {
            for (int i = 0; i < values.length; i++) {
                values[i] = changeEncoding(values[i], "ISO8859-1", encoding);
            }
        }
        return values;
    }

    /**
     * 把传进来的参数值,进行ISO8859-1到encoding的转换
     *
     * @param request
     * @param name
     * @param encoding
     * @return
     */
    public static String getParameterWithEncoding(HttpServletRequest request, String name, String encoding) {
        String value = request.getParameter(name);
        if (value != null)
            value = changeEncoding(value, "ISO8859-1", encoding);
        return value;
    }

    /**
     * 把传进来的参数值,进行ISO8859-1到encoding的转换
     *
     * @param request
     * @param name
     * @param encoding
     * @return
     */
    public static String getAttributeWithEncoding(HttpServletRequest request, String name, String encoding) {
        String value = (String) request.getAttribute(name);
        if (value != null)
            value = changeEncoding(value, "ISO8859-1", encoding);
        return value;
    }

    /**
     * 把传进来的参数值,进行ISO8859-1到encoding的转换，如果返回是null，则变成空字符串""返回
     *
     * @param request
     * @param name
     * @param encoding
     * @return
     */
    public static String getParameterSafeToStrWithEncoding(HttpServletRequest request, String name, String encoding) {
        String value = request.getParameter(name);
        if (value != null) {
            value = changeEncoding(value, "ISO8859-1", encoding);
        } else {
            value = "";
        }
        return value;
    }

    /**
     * 把传进来的参数值,进行ISO8859-1到encoding的转换，如果返回是null，则变成空字符串""返回
     *
     * @param request
     * @param name
     * @param encoding
     * @return
     */
    public static String getAttributeSafeToStrWithEncoding(HttpServletRequest request, String name, String encoding) {
        String value = (String) request.getAttribute(name);
        if (value != null) {
            value = changeEncoding(value, "ISO8859-1", encoding);
        } else {
            value = "";
        }
        return value;
    }

    /**
     * 如果getParameter返回的是null值，则返回空字符串""
     *
     * @param request
     * @param name
     * @return
     */
    public static String getParameterSafeToStr(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        if (value == null) {
            return "";
        } else {
            return value;
        }
    }

    /**
     * 如果getParameter返回的是null值，则返回空字符串""
     *
     * @param request
     * @param name
     * @return
     */
    public static String getAttributeSafeToStr(HttpServletRequest request, String name) {
        String value = (String) request.getAttribute(name);
        if (value == null) {
            return "";
        } else {
            return value;
        }
    }

    public static boolean checkFileExists(ServletContext application, String filePath) {
        if (!isEmpty(filePath)) {
            String physicalFilePath = application.getRealPath(filePath);
            if (!isEmpty(physicalFilePath)) {
                File file = new File(physicalFilePath);
                return file.exists();
            }
        }

        return false;
    }

    public static String textToHtml(String input) {
        if (isEmpty(input))
            return "";
        input = replace(input, "<", "&#60;");
        input = replace(input, ">", "&#62;");
        input = replace(input, "\n", "<br>\n");
        input = replace(input, "\t", "&nbsp;&nbsp;&nbsp;&nbsp;");
        input = replace(input, "  ", "&nbsp;&nbsp;");
        return input;
    }

    public static String toQuoteMark(String s) {
        s = replaceString(s, "'", "&#39;");
        s = replaceString(s, "\"", "&#34;");
        s = replaceString(s, "\r\n", "\n");
        return s;
    }

    public static String replaceChar(String s, char c, char c1) {
        if (s == null) {
            return "";
        }
        return s.replace(c, c1);
    }

    public static String replaceString(String s, String s1, String s2) {
        if (s == null || s1 == null || s2 == null) {
            return "";
        }
        return s.replaceAll(s1, s2);
    }

    public static String toHtml(String s) {
        s = replaceString(s, "<", "&#60;");
        s = replaceString(s, ">", "&#62;");
        return s;
    }

    public static String toBR(String s) {
        s = replaceString(s, "\n", "<br>\n");
        s = replaceString(s, "\t", "&nbsp;&nbsp;&nbsp;&nbsp;");
        s = replaceString(s, "  ", "&nbsp;&nbsp;");
        return s;
    }

    public static String toSQL(String s) {
        s = replaceString(s, "\r\n", "\n");
        return s;
    }

    public static String replaceEnter(String s) throws NullPointerException {
        return s.replaceAll("\n", "<br>");
    }

    public static String replacebr(String s) throws NullPointerException {
        return s.replaceAll("<br>", "\n");
    }

    public static String replaceQuote(String s) throws NullPointerException {
        return s.replaceAll("'", "''");
    }

    /**
     * 多个空格处理为一个空格
     *
     * @param s
     * @return
     * @throws NullPointerException
     */
    public static String replaceOneSpace(String s) throws NullPointerException {
        if (s == null)
            return null;
        return s.replaceAll("( )+", " ");
    }

    public static String changePackagePathToFilePath(String packagePath) {
        if (StringUtilsExt.isEmpty(packagePath) || StringUtilsExt.isBlank(packagePath))
            return "";
        String newStr = StringUtilsExt.isWindows() ? "/" : File.separator;
        String[] strs = StringUtilsExt.split(packagePath, ".");
        for (int i = 0; i < strs.length; i++) {
            String s = strs[i];
            if (!StringUtilsExt.isEmpty(s) && !StringUtilsExt.isBlank(s))
                newStr += s;
            if (i < strs.length - 1)
                newStr += (StringUtilsExt.isWindows() ? "/" : File.separator);
        }
        return newStr;
    }

    public static String changePackagePathToFilePath2(String packagePath) {
        if (StringUtilsExt.isEmpty(packagePath) || StringUtilsExt.isBlank(packagePath))
            return "";
        String newStr = StringUtilsExt.isWindows() ? "/" : File.separator;
        String[] strs = StringUtilsExt.split(packagePath, ".");
        for (int i = 0; i < strs.length; i++) {
            String s = strs[i];
            if (!StringUtilsExt.isEmpty(s) && !StringUtilsExt.isBlank(s))
                newStr += s;
            if (i < strs.length - 1)
                newStr += StringUtilsExt.isWindows() ? "/" : File.separator;
        }
        return newStr;
    }

    public static boolean isExist(String searchStr, String separator, String searchChar) {
        if (StringUtils.isEmpty(searchStr))
            return false;
        if (searchStr.indexOf(separator) != -1) {
            String tempStr = searchStr;
            while (tempStr.indexOf(separator) > 0) {
                String oneItemStr = tempStr.substring(0, tempStr.indexOf(separator));
                if (oneItemStr != null && oneItemStr.equals(searchChar)) {
                    return true;
                } else {
                    tempStr = tempStr.substring(tempStr.indexOf(separator) + 1);
                }
            }
        } else {
            return searchStr.equals(searchChar);
        }
        return false;
    }

    public static String joinStr(String... strs) {
        return StringUtilsExt.join(strs);
    }

    public static String join(String[] array, String separator) {
        String s = "";
        if (array == null || array.length == 0)
            return s;
        for (int i = 0; i < array.length; i++) {
            String str = array[i];
            if (str == null || str.length() == 0)
                continue;
            s += str;
            if (i < array.length - 1)
                s += separator;
        }
        return s;
    }

    public static String joinStr(String[] array, String separator) {
        String s = "";
        if (array == null || array.length == 0)
            return s;
        for (int i = 0; i < array.length; i++) {
            String str = array[i];
            if (str == null || str.length() == 0)
                continue;
            s += "'" + str + "'";
            if (i < array.length - 1)
                s += separator;
        }
        return s;
    }
//
//	public static String join(List<?> dataList, String fieldName, String separator) {
//		String s = "";
//		if (dataList != null && dataList.size() > 0) {
//			for (int i = 0; i < dataList.size(); i++) {
//				Object obj = dataList.get(i);
//				Object result = ReflectionUtils.getFieldValueByCascade(obj, fieldName);
//				if (result == null)
//					continue;
//				s += result.toString();
//				if (i < dataList.size() - 1)
//					s += separator;
//			}
//		}
//		return s;
//	}
//
//	public static String joinStr(List<?> dataList, String fieldName, String separator) {
//		String s = "";
//		if (dataList != null && dataList.size() > 0) {
//			for (int i = 0; i < dataList.size(); i++) {
//				Object obj = dataList.get(i);
//				Object result = ReflectionUtils.invokeGetterMethod(obj, fieldName);
//				if (result == null)
//					continue;
//				s += "'" + result.toString() + "'";
//				if (i < dataList.size() - 1)
//					s += separator;
//			}
//		}
//		return s;
//	}

    public static List<String> splitStrToList(String joinStr, String separator) {
        if (StringUtils.isEmpty(joinStr))
            return null;
        String[] strAry = org.apache.commons.lang.StringUtils.split(joinStr, separator);
        List<String> strList = new ArrayList<String>();
        for (int i = 0; i < strAry.length; i++) {
            String s = strAry[i];
            if (org.apache.commons.lang.StringUtils.isEmpty(s))
                continue;
            if (s.startsWith("'"))
                s = s.substring(1, s.length());
            if (s.endsWith("'"))
                s = s.substring(0, s.length() - 1);
            if (org.apache.commons.lang.StringUtils.isEmpty(s))
                continue;
            strList.add(s);
        }
        return strList;
    }

    public static String lowerFirstCharAndWipeUnderline(String s) {
        if (s == null)
            return null;
        String newStr = "";
        String[] str = StringUtils.split(s, "_");
        for (int i = 0; i < str.length; i++) {
            String _s = str[i];
            if (i == 0)
                _s = StringUtils.lowerCase(_s);
            else
                _s = upperFirstCharAndLowerOtherChars(_s);

            newStr += _s;
        }
        return newStr;
    }

    public static String upperFirstCharAndWipeUnderline(String s) {
        if (s == null)
            return null;
        String newStr = "";
        String[] str = StringUtils.split(s, "_");
        for (int i = 0; i < str.length; i++) {
            String _s = str[i];
            newStr += upperFirstCharAndLowerOtherChars(_s);
        }
        return newStr;
    }

    public static String upperFirstCharAndLowerOtherChars(String s) {
        if (StringUtils.isEmpty(s) || StringUtils.isBlank(s))
            return "";
        String firS = s.substring(0, 1);
        return StringUtils.upperCase(firS) + StringUtils.lowerCase(s.substring(1, s.length()));
    }

    public static String lowerOnlyFirstChar(String s) {
        if (StringUtils.isEmpty(s) || StringUtils.isBlank(s))
            return "";
        String firS = s.substring(0, 1);
        return StringUtils.lowerCase(firS) + s.substring(1, s.length());
    }

    public static String upperOnlyFirstChar(String s) {
        if (StringUtils.isEmpty(s) || StringUtils.isBlank(s))
            return "";
        String firS = s.substring(0, 1);
        return StringUtils.upperCase(firS) + s.substring(1, s.length());
    }

    /**
     * 删除input字符串中的html格式
     *
     * @param input
     * @param length
     * @return
     */
    public static String splitAndFilterString(String input, int length) {
        if (input == null || input.trim().equals("")) {
            return "";
        }
        // 去掉所有html元素,
        String str = input.replaceAll("\\&[a-zA-Z]{1,10};", "").replaceAll("<[^>]*>", "");
        str = str.replaceAll("[(/>)<]", "");
        int len = str.length();
        if (len <= length) {
            return str;
        } else {
            str = str.substring(0, length);
            str += "....";
        }
        return str;
    }

    /**
     * 大字段转字符串
     *
     * @param clob
     * @return
     */
    public static String clobToString(Clob clob) {
        if (clob == null)
            return "";
        String reString = null;
        try {
            Reader is = clob.getCharacterStream();
            BufferedReader br = new BufferedReader(is);
            String s = br.readLine();
            StringBuffer sb = new StringBuffer();
            while (s != null) {
                sb.append(s);
                s = br.readLine();
            }
            reString = sb.toString();
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return reString;
    }

    public static String blobToString(Blob blob) {
        String newStr = "";
        try {
            byte[] msgContent = blob.getBytes(1, (int) blob.length()); // BLOB转换为字节数组
            long BlobLength = blob.length(); // 获取BLOB长度
            if (msgContent == null || BlobLength == 0) { // 如果为空，返回空值
                return "";
            } else {
                int i = 1; // 循环变量
                while (i < BlobLength) // 循环处理字符串转换，每次1024；Oracle字符串限制最大4k
                {
                    byte[] bytes = blob.getBytes(i, 1024);
                    i = i + 1024;
                    newStr = newStr + new String(bytes, "gb2312");
                }
            }
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return newStr;
    }

    public static String byteAryToString(byte[] byteAry) {
        String newStr = "";
        try {
            newStr = new String(byteAry, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return newStr;
    }

//	public static String blobToEncodeBase64Str(Blob blob) {
//		String newStr = "";
//		try {
//			byte[] binaryData = blob.getBytes(1, (int) blob.length());
//			newStr = Base64.encodeBase64String(binaryData);
//		} catch (SQLException e) {
//			e.printStackTrace();
//		}
//		return newStr;
//	}

    public static void main(String[] args) {
        Set s=new HashSet();
//        s.add("aa");
//        s.add("bb");
      String ss=  setToStr(s,"");
        System.out.println(ss);
    }

    public static String setToStr(Set set, String sep) {
        StringBuilder sb = new StringBuilder();
        if (StringUtilsExt.isNullOrNone(sep)) {
            sep = ",";
        }
        if (set != null) {
            for (Object o : set) {
                sb.append(o).append(sep);
            }
        }
        if (sb.length() > 0) {
            sb = sb.replace(sb.length() - 1, sb.length(), "");
        }
        return sb.toString();
    }

    public static String htmlRemoveTag(String inputString) {
        if (inputString == null)
            return null;
        String htmlStr = inputString; // 含html标签的字符串
        String textStr = "";
        java.util.regex.Pattern p_script;
        java.util.regex.Matcher m_script;
        java.util.regex.Pattern p_style;
        java.util.regex.Matcher m_style;
        java.util.regex.Pattern p_html;
        java.util.regex.Matcher m_html;
        try {
            //定义script的正则表达式{或<script[^>]*?>[\\s\\S]*?<\\/script>
            String regEx_script = "<[\\s]*?script[^>]*?>[\\s\\S]*?<[\\s]*?\\/[\\s]*?script[\\s]*?>";
            //定义style的正则表达式{或<style[^>]*?>[\\s\\S]*?<\\/style>
            String regEx_style = "<[\\s]*?style[^>]*?>[\\s\\S]*?<[\\s]*?\\/[\\s]*?style[\\s]*?>";
            String regEx_html = "<[^>]+>"; // 定义HTML标签的正则表达式
            p_script = Pattern.compile(regEx_script, Pattern.CASE_INSENSITIVE);
            m_script = p_script.matcher(htmlStr);
            htmlStr = m_script.replaceAll(""); // 过滤script标签
            p_style = Pattern.compile(regEx_style, Pattern.CASE_INSENSITIVE);
            m_style = p_style.matcher(htmlStr);
            htmlStr = m_style.replaceAll(""); // 过滤style标签
            p_html = Pattern.compile(regEx_html, Pattern.CASE_INSENSITIVE);
            m_html = p_html.matcher(htmlStr);
            htmlStr = m_html.replaceAll(""); // 过滤html标签
            textStr = htmlStr;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return textStr;// 返回文本字符串
    }


}
