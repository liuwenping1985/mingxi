package com.seeyon.apps.kdXdtzXc.base.util;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.StringEscapeUtils;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class StringUtils extends org.apache.commons.lang.StringUtils {
    public static String escape(String src) {
        StringBuffer tmp = new StringBuffer();
        tmp.ensureCapacity(src.length() * 6);

        for (int i = 0; i < src.length(); i++) {
            char j = src.charAt(i);

            if ((Character.isDigit(j)) || (Character.isLowerCase(j)) || (Character.isUpperCase(j))) {
                tmp.append(j);
            } else if (j < 'Ā') {
                tmp.append("%");
                if (j < '\020')
                    tmp.append("0");
                tmp.append(Integer.toString(j, 16));
            } else {
                tmp.append("%u");
                tmp.append(Integer.toString(j, 16));
            }
        }
        return tmp.toString();
    }

    public static String unescape(String src) {
        StringBuffer tmp = new StringBuffer();
        tmp.ensureCapacity(src.length());
        int lastPos = 0;
        int pos = 0;

        while (lastPos < src.length()) {
            pos = src.indexOf("%", lastPos);
            if (pos == lastPos) {
                if (src.charAt(pos + 1) == 'u') {
                    char ch = (char) Integer.parseInt(src.substring(pos + 2, pos + 6), 16);
                    tmp.append(ch);
                    lastPos = pos + 6;
                } else {
                    char ch = (char) Integer.parseInt(src.substring(pos + 1, pos + 3), 16);
                    tmp.append(ch);
                    lastPos = pos + 3;
                }
            } else if (pos == -1) {
                tmp.append(src.substring(lastPos));
                lastPos = src.length();
            } else {
                tmp.append(src.substring(lastPos, pos));
                lastPos = pos;
            }
        }

        return tmp.toString();
    }

    public static String trimPrefix(String toTrim, String trimStr) {
        while (toTrim.startsWith(trimStr)) {
            toTrim = toTrim.substring(trimStr.length());
        }
        return toTrim;
    }

    public static String trimSufffix(String toTrim, String trimStr) {
        while (toTrim.endsWith(trimStr)) {
            toTrim = toTrim.substring(0, toTrim.length() - trimStr.length());
        }
        return toTrim;
    }

    public static String trim(String toTrim, String trimStr) {
        return trimSufffix(trimPrefix(toTrim, trimStr), trimStr);
    }

    public static String escapeHtml(String content) {
        return StringEscapeUtils.escapeHtml(content);
    }

    public static String unescapeHtml(String content) {
        return StringEscapeUtils.unescapeHtml(content);
    }

    public static boolean isEmpty(String str) {
        if (str == null)
            return true;
        if (str.trim().equals(""))
            return true;
        return false;
    }

    public static boolean isNotEmpty(String str) {
        return !isEmpty(str);
    }

    public static String subString(String str, int len) {
        int strLen = str.length();
        if (strLen < len)
            return str;
        char[] chars = str.toCharArray();
        int cnLen = len * 2;
        String tmp = "";
        int iLen = 0;
        for (int i = 0; i < chars.length; i++) {
            int iChar = chars[i];
            if (iChar <= 128)
                iLen++;
            else
                iLen += 2;
            if (iLen >= cnLen)
                break;
            tmp = tmp + String.valueOf(chars[i]);
        }
        return tmp;
    }

    public static boolean isNumberic(String s) {
        if (StringUtils.isEmpty(s))
            return false;
        boolean rtn = validByRegex("^[-+]{0,1}\\d*\\.{0,1}\\d+$", s);
        if (rtn)
            return true;

        return validByRegex("^0[x|X][\\da-eA-E]+$", s);
    }

    public static boolean isInteger(String s) {
        boolean rtn = validByRegex("^[-+]{0,1}\\d*$", s);
        return rtn;
    }

    public static boolean isEmail(String s) {
        boolean rtn = validByRegex("(\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*)*", s);
        return rtn;
    }

    public static boolean isMobile(String s) {
        boolean rtn = validByRegex("^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1}))+\\d{8})$", s);
        return rtn;
    }

    public static boolean isPhone(String s) {
        boolean rtn = validByRegex("(0[0-9]{2,3}\\-)?([2-9][0-9]{6,7})+(\\-[0-9]{1,4})?", s);
        return rtn;
    }

    public static boolean isZip(String s) {
        boolean rtn = validByRegex("^[0-9]{6}$", s);
        return rtn;
    }

    public static boolean isQq(String s) {
        boolean rtn = validByRegex("^[1-9]\\d{4,9}$", s);
        return rtn;
    }

    public static boolean isIp(String s) {
        boolean rtn = validByRegex("^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", s);
        return rtn;
    }

    public static boolean isChinese(String s) {
        boolean rtn = validByRegex("^[一-龥]+$", s);
        return rtn;
    }

    public static boolean isChrNum(String s) {
        boolean rtn = validByRegex("^([a-zA-Z0-9]+)$", s);
        return rtn;
    }

    public static boolean isUrl(String url) {
        return validByRegex("(http://|https://)?([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?", url);
    }

    public static boolean validByRegex(String regex, String input) {
        Pattern p = Pattern.compile(regex, 2);
        Matcher regexMatcher = p.matcher(input);
        return regexMatcher.find();
    }

    public static boolean isNumeric(String str) {
        int i = str.length();
        do {
            if (!Character.isDigit(str.charAt(i)))
                return false;
            i--;
        } while (i >= 0);

        return true;
    }

    public static String makeFirstLetterUpperCase(String newStr) {
        if (newStr.length() == 0) {
            return newStr;
        }
        char[] oneChar = new char[1];
        oneChar[0] = newStr.charAt(0);
        String firstChar = new String(oneChar);
        return firstChar.toUpperCase() + newStr.substring(1);
    }

    public static String makeFirstLetterLowerCase(String newStr) {
        if (newStr.length() == 0) {
            return newStr;
        }
        char[] oneChar = new char[1];
        oneChar[0] = newStr.charAt(0);
        String firstChar = new String(oneChar);
        return firstChar.toLowerCase() + newStr.substring(1);
    }

    public static String formatParamMsg(String message, Object[] args) {
        for (int i = 0; i < args.length; i++) {
            message = message.replace("{" + i + "}", args[i].toString());
        }
        return message;
    }

    public static String formatParamMsg(String message, Map params) {
        if (params == null)
            return message;
        Iterator keyIts = params.keySet().iterator();
        while (keyIts.hasNext()) {
            String key = (String) keyIts.next();
            Object val = params.get(key);
            if (val != null) {
                message = message.replace("${" + key + "}", val.toString());
            }
        }
        return message;
    }

    public static StringBuilder formatMsg(CharSequence msgWithFormat, boolean autoQuote, Object[] args) {
        int argsLen = args.length;
        boolean markFound = false;

        StringBuilder sb = new StringBuilder(msgWithFormat);

        if (argsLen > 0) {
            for (int i = 0; i < argsLen; i++) {
                String flag = "%" + (i + 1);
                int idx = sb.indexOf(flag);

                while (idx >= 0) {
                    markFound = true;
                    sb.replace(idx, idx + 2, toString(args[i], autoQuote));
                    idx = sb.indexOf(flag);
                }
            }

            if ((args[(argsLen - 1)] instanceof Throwable)) {
                StringWriter sw = new StringWriter();
                ((Throwable) args[(argsLen - 1)]).printStackTrace(new PrintWriter(sw));
                sb.append("\n").append(sw.toString());
            } else if ((argsLen == 1) && (!markFound)) {
                sb.append(args[(argsLen - 1)].toString());
            }
        }
        return sb;
    }

    public static StringBuilder formatMsg(String msgWithFormat, Object[] args) {
        return formatMsg(new StringBuilder(msgWithFormat), true, args);
    }

    public static String toString(Object obj, boolean autoQuote) {
        StringBuilder sb = new StringBuilder();
        if (obj == null) {
            sb.append("NULL");
        } else if ((obj instanceof Object[])) {
            for (int i = 0; i < ((Object[]) obj).length; i++) {
                sb.append(((Object[]) obj)[i]).append(", ");
            }
            if (sb.length() > 0)
                sb.delete(sb.length() - 2, sb.length());
        } else {
            sb.append(obj.toString());
        }

        if ((autoQuote) && (sb.length() > 0) && ((sb.charAt(0) != '[') || (sb.charAt(sb.length() - 1) != ']')) && ((sb.charAt(0) != '{') || (sb.charAt(sb.length() - 1) != '}'))) {
            sb.insert(0, "[").append("]");
        }
        return sb.toString();
    }

    public static String returnSpace(String str) {
        String space = "";
        if (!str.isEmpty()) {
            String[] path = str.split("\\.");
            for (int i = 0; i < path.length - 1; i++) {
                space = space + "&nbsp;&emsp;";
            }
        }
        return space;
    }

    public static String addNumStrs(String str, Integer num) {
        if (num == null)
            num = 0;
        String s = "";
        for (int i = 0; i < num; i++) {
            s = s + str;
        }
        return s;
    }

    public static synchronized String encryptSha256(String inputStr) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] digest = md.digest(inputStr.getBytes("UTF-8"));
            return new String(Base64.encodeBase64(digest));
        } catch (Exception e) {
        }
        return null;
    }

    public static synchronized String encryptMd5(String inputStr) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(inputStr.getBytes());
            byte[] digest = md.digest();
            StringBuffer sb = new StringBuffer();
            for (byte b : digest) {
                sb.append(Integer.toHexString(b & 0xFF));
            }

            return sb.toString();
        } catch (Exception e) {
        }
        return null;
    }

    public static String getArrayAsString(List<String> arr) {
        if ((arr == null) || (arr.size() == 0))
            return "";
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < arr.size(); i++) {
            if (i > 0)
                sb.append(",");
            sb.append((String) arr.get(i));
        }
        return sb.toString();
    }

    public static String getArrayAsString(String[] arr) {
        if ((arr == null) || (arr.length == 0))
            return "";
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < arr.length; i++) {
            if (i > 0)
                sb.append(",");
            sb.append(arr[i]);
        }
        return sb.toString();
    }

    public static String getSetAsString(Set set) {
        if ((set == null) || (set.size() == 0))
            return "";
        StringBuffer sb = new StringBuffer();
        int i = 0;
        Iterator it = set.iterator();
        while (it.hasNext()) {
            if (i++ > 0)
                sb.append(",");
            sb.append(it.next().toString());
        }
        return sb.toString();
    }

    public static String hangeToBig(double value) {
        char[] hunit = {'拾', '佰', '仟'};
        char[] vunit = {'万', '亿'};
        char[] digit = {38646, '壹', 36144, '叁', 32902, '伍', 38470, '柒', '捌', '玖'};
        long midVal = Long.parseLong((value * 100.0D) + "");
        String valStr = String.valueOf(midVal);

        String head = valStr.substring(0, valStr.length() - 2);
        String rail = valStr.substring(valStr.length() - 2);

        String prefix = "";
        String suffix = "";

        if (rail.equals("00")) {
            suffix = "整";
        } else {
            suffix = digit[(rail.charAt(0) - '0')] + "角" + digit[(rail.charAt(1) - '0')] + "分";
        }

        char[] chDig = head.toCharArray();
        char zero = '0';
        byte zeroSerNum = 0;
        for (int i = 0; i < chDig.length; i++) {
            int idx = (chDig.length - i - 1) % 4;
            int vidx = (chDig.length - i - 1) / 4;
            if (chDig[i] == '0') {
                zeroSerNum = (byte) (zeroSerNum + 1);
                if (zero == '0') {
                    zero = digit[0];
                } else if ((idx == 0) && (vidx > 0) && (zeroSerNum < 4)) {
                    prefix = prefix + vunit[(vidx - 1)];
                    zero = '0';
                }
            } else {
                zeroSerNum = 0;
                if (zero != '0') {
                    prefix = prefix + zero;
                    zero = '0';
                }
                prefix = prefix + digit[(chDig[i] - '0')];
                if (idx > 0)
                    prefix = prefix + hunit[(idx - 1)];
                if ((idx == 0) && (vidx > 0)) {
                    prefix = prefix + vunit[(vidx - 1)];
                }
            }
        }
        if (prefix.length() > 0)
            prefix = prefix + '圆';
        return prefix + suffix;
    }

    public static String htmlEntityToString(String dataStr) {
        dataStr = dataStr.replace("&apos;", "'").replace("&quot;", "\"").replace("&gt;", ">").replace("&lt;", "<").replace("&amp;", "&");

        int start = 0;
        int end = 0;
        StringBuffer buffer = new StringBuffer();

        while (start > -1) {
            int system = 10;
            if (start == 0) {
                int t = dataStr.indexOf("&#");
                if (start != t) {
                    start = t;
                }
                if (start > 0) {
                    buffer.append(dataStr.substring(0, start));
                }
            }
            end = dataStr.indexOf(";", start + 2);
            String charStr = "";
            if (end != -1) {
                charStr = dataStr.substring(start + 2, end);

                char s = charStr.charAt(0);
                if ((s == 'x') || (s == 'X')) {
                    system = 16;
                    charStr = charStr.substring(1);
                }
            }
            try {
                char letter = (char) Integer.parseInt(charStr, system);
                buffer.append(new Character(letter).toString());
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }

            start = dataStr.indexOf("&#", end);
            if (start - end > 1) {
                buffer.append(dataStr.substring(end + 1, start));
            }

            if (start == -1) {
                int length = dataStr.length();
                if (end + 1 != length) {
                    buffer.append(dataStr.substring(end + 1, length));
                }
            }
        }
        return buffer.toString();
    }

    public static String stringToHtmlEntity(String str) {
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < str.length(); i++) {
            char c = str.charAt(i);

            switch (c) {
                case '\n':
                    sb.append(c);
                    break;
                case '<':
                    sb.append("&lt;");
                    break;
                case '>':
                    sb.append("&gt;");
                    break;
                case '&':
                    sb.append("&amp;");
                    break;
                case '\'':
                    sb.append("&apos;");
                    break;
                case '"':
                    sb.append("&quot;");
                    break;
                default:
                    if ((c < ' ') || (c > '~')) {
                        sb.append("&#x");
                        sb.append(Integer.toString(c, 16));
                        sb.append(';');
                    } else {
                        sb.append(c);
                    }
                    break;
            }
        }
        return sb.toString();
    }

    public static String encodingString(String str, String from, String to) {
        String result = str;
        try {
            result = new String(str.getBytes(from), to);
        } catch (Exception e) {
            result = str;
        }
        return result;
    }

    public static String arrayToString(String[] s) {
        StringBuffer sb = new StringBuffer();
        if (s == null || s.length == 0)
            return "";
        for (String v : s) {
            sb.append(v).append(",");
        }
        return sb.substring(0, sb.length() - 1);

    }

    public static String getDBpassword(String password) {
        String md5 = DigestUtils.md5Hex(password);
        if (md5.length() < 15)
            return "";
        return md5.substring(0, 15).toUpperCase();
    }

    /**
     * + - 查询
     *
     * @param strEnter
     * @return
     */
    public static String getStringSplit(String strEnter) {
        //
        String strAddKey = "";
        String key = "";
        // indexOf(String str) :返回第一次出现的指定子字符串在此字符串中的索引。
        if (strEnter.indexOf("+") >= 0 && strEnter.indexOf("-") >= 0) {

            /**
             * Pattern类 指定为字符串的正则表达式必须首先被编译为此类的实例。 然后，可将得到的模式用于创建 Matcher 对象，依照正则表达式，该对象可以与任意字符序列匹配。 执行匹配所涉及的所有状态都驻留在匹配器中，所以多个匹配器可以共享同一模式。
             *
             * 在regex包中，包括了两个类，Pattern(模式类)和Matcher(匹配器类)。 Pattern类是用来表达和陈述所要搜索模式的对象，Matcher类是真正影响搜索的对象。
             *
             */
            Pattern patAdd = Pattern.compile("[+]");// compile 将给定的正则表达式编译到模式中。
            String[] strAdd = patAdd.split(strEnter);// split围绕此模式的匹配拆分给定输入序列。
            for (int i = 0; i < strAdd.length; i++) {
                if (i == strAdd.length - 1) {
                    strAddKey += strAdd[i].trim();// trim返回字符串的副本，忽略前导空白和尾部空白。
                } else {
                    strAddKey += strAdd[i].trim() + " " + "+" + " ";
                }
            }
            Pattern patMin = Pattern.compile("[-]");
            String[] strMin = patMin.split(strAddKey);

            for (int j = 0; j < strMin.length; j++) {
                if (j == strMin.length - 1) {
                    key += strMin[j].trim();
                } else {
                    key += strMin[j].trim() + " " + "-" + " ";
                }
            }
        } else if (strEnter.indexOf("+") >= 0) {
            Pattern patAdd = Pattern.compile("[+]");
            String[] strAdd = patAdd.split(strEnter);
            for (int i = 0; i < strAdd.length; i++) {
                if (i == strAdd.length - 1) {
                    key += strAdd[i].trim();
                } else {
                    key += strAdd[i].trim() + " " + "+" + " ";
                }
            }
        } else if (strEnter.indexOf("-") >= 0) {
            Pattern patMin = Pattern.compile("[-]");
            String[] strMin = patMin.split(strEnter);

            for (int j = 0; j < strMin.length; j++) {
                if (j == strMin.length - 1) {
                    key += strMin[j].trim();
                } else {
                    key += strMin[j].trim() + " " + "-" + " ";
                }
            }
        } else {
            key = strEnter;
        }
        return key;
    }

    /**
     * 提取文件后缀名称
     *
     * @param fname
     * @return
     */
    public static String getpostfix(String fname) {
        String postfix = null;
        if (fname == null)
            return "";
        if (fname.indexOf(".") != -1) {
            // 从.所在字符串的位置提取子字符串到结尾
            postfix = fname.substring(fname.indexOf("."));
        } else {
            return "是非法文件名";
        }
        return postfix;
    }

    public static String clean(String mes, Integer maxlen) {
        if (mes == null)
            return "";
        return mes.length() < maxlen ? mes : mes.substring(0, 60) + "...";
    }

    public static String printMsg(Object target, String nullprint, String notnullprint) {
        return isNullOrNone(target) ? nullprint : notnullprint;
    }

    public static boolean isNotBlank(String s) {
        return isNullOrNone(s) ? false : s.indexOf(" ") > 0 ? false : true;
    }

    public static String printMsg(Boolean bool, String truepring, String falseprint) {
        return bool ? truepring : falseprint;
    }

    /**
     * 防止sql注入设置及js脚本处理
     *
     * @param s
     * @return
     */
    public static String safeSearchWord(String s) {
        if (StringUtils.isNullOrNone(s))
            return "";
        String result = StringUtils.ignoreCaseReplace(s, "javascript", "");
        // result = StringUtils.ignoreCaseReplace(result, "=", "");
        result = StringUtils.ignoreCaseReplace(result, "vbscript", "");
        result = StringUtils.ignoreCaseReplace(result, "script", "");
        result = StringUtils.ignoreCaseReplace(result, "equal", "");
        result = StringUtils.ignoreCaseReplace(result, "language", "");
        // result = StringUtils.ignoreCaseReplace(result, "and", "");
        // result = StringUtils.ignoreCaseReplace(result, "or", "");
        result = StringUtils.ignoreCaseReplace(result, ">", "&gt;");
        result = StringUtils.ignoreCaseReplace(result, "<", "&lt;");
        result = StringUtils.ignoreCaseReplace(result, "select", "");
        result = StringUtils.ignoreCaseReplace(result, "from", "");
        result = StringUtils.ignoreCaseReplace(result, "where", "");
        result = StringUtils.ignoreCaseReplace(result, "order", "");
        result = StringUtils.ignoreCaseReplace(result, "having", "");
        result = StringUtils.ignoreCaseReplace(result, "sysMeetingStates", "");
        result = StringUtils.ignoreCaseReplace(result, "update", "");
        // result = StringUtils.ignoreCaseReplace(result, "by", "");
        result = StringUtils.ignoreCaseReplace(result, "alert", "");
        result = StringUtils.ignoreCaseReplace(result, "window", "");
        result = StringUtils.ignoreCaseReplace(result, "location", "");
        result = StringUtils.ignoreCaseReplace(result, "href", "");
        // result = StringUtils.ignoreCaseReplace(result, "http", "");
        // result = StringUtils.ignoreCaseReplace(result, "src", "");
        result = StringUtils.ignoreCaseReplace(result, "docuemnt", "");
        // result = StringUtils.ignoreCaseReplace(result, "iframe", "");
        return result;

    }

    public static Boolean isNullOrNone(String source) {
        return source == null || "".equals(source.trim()) || "null".equals(source);
    }

    public static Boolean isAllNullOrNone(String... source) {
        for (String s : source) {
            if (!StringUtils.isNullOrNone(s))
                return false;
        }
        return true;
    }

    public static Boolean isNullOrNone(Object source) {
        return source == null || "".equals(source.toString()) || "null".equals(source.toString());
    }

    public static String ignoreCaseReplace(String source, String oldstring, String newstring) {
        Pattern p = Pattern.compile(oldstring, Pattern.CASE_INSENSITIVE);
        Matcher m = p.matcher(source);
        String ret = m.replaceAll(newstring);
        return ret;
    }

    public static Boolean isNullOrNone(String[] source) {
        return source == null || source.length == 0;
    }

    public static Boolean isNullOrNone(List items) {
        return items == null || items.size() == 0;
    }

    public static Boolean isEqual(String source1, String source2) {
        return (!isNullOrNone(source1)) && (!isNullOrNone(source2)) && source1.equals(source2);
    }

    public static Boolean isEqual(Integer source1, Integer source2) {
        return (!isNullOrNone(source1)) && (!isNullOrNone(source2)) && source1.equals(source2);
    }

    public static String showMessage(String message, boolean isshow) {
        return isshow ? message : "";
    }

    public static String trim(String source) {
        if (isNullOrNone(source))
            return "";
        else
            return source.trim();
    }

    public static String cleanNull(String source) {
        if (isNullOrNone(source))
            return "";
        return source;
    }

    public static String getScript(String outprint) {
        if (isNullOrNone(outprint))
            return "";
        return "<script language=javascript>alert('" + outprint + "');</script>";
    }

    public static String getScript(String outprint, String outhref) {
        if (isNullOrNone(outprint))
            return "<script language=javascript>window.location.href='" + outhref + "';</script>";
        else
            return new StringBuffer().append("<script language=javascript>alert('").append(outprint).append("');window.location.href='").append(outhref).append("';</script>").toString();
    }

    public static String getDateDescribe() {
        String s = "<script type=\"text/javascript\">\n" + "                function getCommDate() {\n" + "                    var today = new Date();\n" + "                    var year_ = today.getFullYear();\n" + "                    var month_ = today.getMonth() + 1;\n" + "                    var date_ = today.getDate();\n" + "                    var day = today.getDay();\n" + "                    var day_;\n" + "                    switch (day) {\n" + "                        case 0:day_ = \"日\";break;\n" + "                        case 1:day_ = \"一\";break;\n" + "                        case 2:day_ = \"二\";break;\n" + "                        case 3:day_ = \"三\";break;\n" + "                        case 4:day_ = \"四\";break;\n" + "                        case 5:day_ = \"五\";break;\n"
                + "                        case 6:day_ = \"六\";break;\n" + "                    }\n" + "                    var str = \"<strong>\" + \"今天是\" + \"<font color=\\\"#FF0000\\\">\" + year_ + \"</font>年<font color=\\\"#FF0000\\\">\" + month_ + \"</font>月<font color=\\\"#FF0000\\\">\" + date_ + \"</font>日&nbsp;&nbsp;星期\" + day_ + \"</strong>\";\n" + "                    return str;\n" + "                }\n" + "                document.write(getCommDate());\n" + "            </script>";
        return s;
    }

    public static String trimEnterAndNewLineChar(String s) {
        if (StringUtils.isNullOrNone(s))
            return "";
        return s.replaceAll("\n", "").replaceAll("\r", "");
        // String result = StringUtils.ignoreCaseReplace(s, "\n", "");
        // result = StringUtils.ignoreCaseReplace(s, "\r", "");
        // return result;
    }

    public static String htmlEncode(String str) {
        if (StringUtils.isEmpty(str))
            return "";
        String s = str;
        s = s.replaceAll("&", "&amp;").replaceAll("\"", "&quot;"); // 替换'&'和'\'
        s = s.replaceAll("<", "&lt;").replaceAll(">", "&gt;"); // 替换'<'和'>'
        s = s.replaceAll("'", "&#39"); // 替换'\s'（空格）和'
        // s = s.replaceAll("\\s", "&nbsp;").replaceAll("'", "&#39");
        // //替换'\s'（空格）和'
        return s;
    }

    public static String decodeHtml(String str) {
        String s = str;
        s = s.replaceAll("&amp;", "&").replaceAll("&quot;", "\""); // 替换'&'和'\'
        s = s.replaceAll("&lt;", "<").replaceAll("&gt;", ">"); // 替换'<'和'>'
        s = s.replaceAll("&#39", "'"); // 替换'\s'（空格）和'
        // s = s.replaceAll("&nbsp;","\\s").replaceAll("&#39","'");
        // //替换'\s'（空格）和'
        return s;
    }

    public static String encodeString(String source, String charset, String toCharset) {
        if (source == null)
            return null;
        if (source == "")
            return "";
        try {
            return new String(source.getBytes(charset), toCharset);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return "Encode error:" + e.getMessage();
        }

    }

    public static Set convertCommaString(String commaString) {
        Set s = new HashSet();

        if (null != commaString) {
            String[] arr = commaString.split(",");
            for (int i = 0; i < arr.length; i++) {
                s.add(arr[i]);
            }
        }
        return s;
    }

    public static Set convertCommaString(String commaString, String split) {
        Set s = new HashSet();

        if (null != commaString) {
            String[] arr = commaString.split(split);
            for (int i = 0; i < arr.length; i++) {
                s.add(arr[i]);
            }
        }
        return s;
    }

    public static boolean in(String str, String target, int pos, char begin, char end) throws Exception {
        int b = str.indexOf(begin);
        int e = str.indexOf(end);
        if ((b < 0) || (e < 0)) {
            return false;
        }

        int len = target.length();
        System.out.println(str.length() + ":" + pos + ":" + len);
        String s = str.substring(pos, pos + len);
        System.out.println("s=[" + s + "]");
        if (!s.equalsIgnoreCase(target)) {
            throw new Exception("\u5B57\u7B26\u4E32['" + target + "\u7684\u4F4D\u7F6E:" + pos + "\u6307\u5B9A\u9519\u8BEF]");
        }

        String frontStr = str.substring(0, pos);
        String backStr = str.substring(pos + len + 1);

        int endCount = 0;
        int beginCount = 0;

        boolean existBegin = false;
        for (int i = 0; i < frontStr.length(); i++) {
            char c = frontStr.charAt(i);
            if (c == begin) {
                beginCount++;
            }
            if (c == end) {
                endCount++;
            }
        }
        System.out.println(beginCount + ":" + endCount);
        if (beginCount - endCount > 0) {
            existBegin = true;
        }

        endCount = 0;
        beginCount = 0;

        boolean existEnd = false;
        for (int i = 0; i < backStr.length(); i++) {
            char c = backStr.charAt(i);
            if (c == begin) {
                beginCount++;
            }
            if (c == end) {
                endCount++;
            }
        }
        System.out.println(beginCount + ":" + endCount);
        if (endCount - beginCount > 0) {
            existEnd = true;
        }
        System.out.println(existBegin + ":" + existEnd);
        return (existBegin) && (existEnd);
    }

    public static int getPosNotIn(String str, String target, char begin, char end) throws Exception {
        String opStr = str;
        int pos = 0;
        int modify = 0;
        boolean inIf = false;
        while (opStr.toLowerCase().indexOf(target.toLowerCase()) >= 0) {
            System.out.println("opStr=[" + opStr + "]");
            pos = opStr.toLowerCase().indexOf(target.toLowerCase());
            if (!in(str, target, pos + modify, begin, end)) {
                inIf = true;
                break;
            }
            opStr = opStr.substring(pos + target.length());
            modify += pos + target.length();
            System.out.println("modify=" + modify);
        }

        if (!inIf) {
            return -1;
        }
        pos = modify + pos;
        System.out.println(str.substring(pos, pos + target.length()) + " found,pos=[" + pos + "],modify=[" + modify + "]");

        return pos;
    }

    public static String replaceBlank(String s) {
        if (null == s) {
            return s;
        }
        Pattern p = Pattern.compile("\t\n|\t|\r|\n");
        Matcher m = p.matcher(s);
        return m.replaceAll(" ");
    }

    public static boolean isNullorBlank(String s) {
        if (null == s) {
            return true;
        }

        return s.trim().length() == 0;
    }

    public static String toCommaString(String[] s) {
        if (s == null) {
            return "";
        }
        String result = s[0];
        if (s.length > 1) {
            for (int i = 1; i < s.length; i++) {
                result = result + "," + s[i];
            }
        }

        return result;
    }

    public static void main(String[] args) throws Exception {
        String judge = "from";
        String str4 = "select a.op_time as op_time,b.termcomp_name as termcomp_name,count(distinct a.user_id) as numbs,count(distinct a.user_id) /(select count(*) from dw_chl_mzone_custinfo_200903) * 100 as percent,count(distinct a.user_id) /(select count(*) from dw_chl_mzone_custinfo_200903) * 100 as percent2 from dw_chl_mzone_custinfo_200903 a left join Dim_Chl_Term_Comp b on a.brand_id = b.term_comp group by a.op_time, b.termcomp_name order by numbs desc";
        String str5 = "SELECT OP_TIME,CITY_ID,COUNTY_ID,AREA_ID,CHANNEL_ID,BRAND_ID,CHANNEL_LEVEL,SUM(NEW_USER_NUMS) NEW_USER_NUMS,SUM(ADD_USER_NUMS) / SUM(NEW_USER_NUMS) IN_RATE,SUM(RENET_USER_NUMS) / SUM(OFF_USER_NUMS) RENET_RATE,SUM(DEVELOP_USER_ARPU) DEVELOP_USER_ARPU,SUM(OFF_USER_NUMS) / SUM(NEW_USER_NUMS) OFF_RATE,SUM(CHL_WEIGHING_SCORE) CHL_WEIGHING_SCORE From Dw_AI_Chl_Phy_Inter_DM WHERE 1 = 1 GROUP BY OP_TIME,   CITY_ID,COUNTY_ID,AREA_ID,CHANNEL_ID,BRAND_ID,CHANNEL_LEVEL";
        StringBuffer sb = new StringBuffer("abcdef;");
        sb.deleteCharAt(sb.length() - 1);
        System.out.println(sb);
        String sb2 = "AB";
        System.out.println(sb2.toLowerCase() + ":" + sb2);

        System.out.println("------------" + str4 + " \nreturn " + getPosNotIn(str4, judge, '(', ')'));
        System.out.println("------------" + str4 + " \nreturn " + getPosNotIn(str4, "join", '(', ')'));
        System.out.println("------------" + str4 + " \nreturn " + getPosNotIn(str5, judge, '(', ')'));

        String str = "${scriptImpl.getStartUserPos(startUser)==\"&#37096;&#38376;&#32463;&#29702;\"}";
        System.out.println(htmlEntityToString(str));
    }


    public static String toUTF8(String isoString) {
        String utf8String = null;
        if ((null != isoString) && (!isoString.equals("")))
            try {
                byte[] stringBytesISO = isoString.getBytes("ISO-8859-1");
                utf8String = new String(stringBytesISO, "UTF-8");
            } catch (UnsupportedEncodingException e) {
                System.out.println("UnsupportedEncodingException is: " + e.getMessage());
                utf8String = isoString;
            }
        else {
            utf8String = isoString;
        }
        return utf8String;
    }

    public static Boolean emprtArray(String source) {
        return source == null || "".equals(source.trim()) || "null".equals(source)||"[ ]".equals(source)||"[]".equals(source);
    }
}