package com.test.uitl;


/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: </p>
 * @author not attributable
 * @version 1.0
 */
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.security.KeyStore;
import java.security.MessageDigest;
import java.security.cert.Certificate;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Random;
import java.util.StringTokenizer;
import java.util.TimeZone;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.apache.log4j.Logger;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.XMLWriter;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;


public class CommonUtil {
	static Logger logger = Logger.getLogger(CommonUtil.class);
	
	private static final String DEFAULT_CHAR_SET = "GBK";
	
	public static String stringTrim(String str){
		String strRe=null;
		if(str!=null){
			strRe=str.trim();
		}
		return strRe;
	}
	
	public static String getBase64String(String value, String charSet) {
		String encodeValue = "";
		if (value != null && value.length() > 0) {
			try {
				encodeValue = new sun.misc.BASE64Encoder().encode(value.getBytes(charSet));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return encodeValue;
	}
	

	
	
	/**
	 * 根据组织机构编码获取顶级机构的组织编码(机构编码的前八位)  李谢
	 * @return 
	 */
	public static String getRootCode(String orgCode) {
		if(orgCode.contains(";")) {
			// 不是顶级机构
			int start = orgCode.indexOf(";");
			return orgCode.substring(0, start);
		} else {
			// 是顶级机构
			return orgCode;
		}
	}

	/**
	 * 获取当前月第一天      李谢
	 */
	public static Date getFirstDayOfThisMonth() {
	    Calendar c = Calendar.getInstance();    
	    c.add(Calendar.MONTH, 0);
	    c.set(Calendar.DAY_OF_MONTH,1);
	    c.set(Calendar.HOUR_OF_DAY, 0);
	    c.set(Calendar.MINUTE, 0);
	    c.set(Calendar.SECOND, 0);
	    return c.getTime();
	}
	/**
	 * 获取当前月最后一天   李谢
	 */
	public static Date getLastDayOfThisMonth() {
		 //获取当前月最后一天
	    Calendar ca = Calendar.getInstance();    
	    ca.set(Calendar.DAY_OF_MONTH, ca.getActualMaximum(Calendar.DAY_OF_MONTH));  
	    ca.set(Calendar.HOUR_OF_DAY, 0);
	    ca.set(Calendar.MINUTE, 0);
	    ca.set(Calendar.SECOND, 0);
	    return ca.getTime();
	}
	public static String genCode(String head, int count) {
		// XD-集团，XEMC-股份。
		StringBuffer sb = new StringBuffer();
		sb.append(head);
		sb.append(CommonUtil.getStringByDateFormat(new Date(), "yyyyMM"));
		String countStr = String.valueOf(count + 1);
		for (int i = 0; i < countStr.length(); i++) {
			if(countStr.length() <4){
				countStr = "0" + countStr;
			}
		}
		sb.append(countStr);
		
		return sb.toString();
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	public CommonUtil() {
	}

	/**
	 * String 转 long
	 * 
	 * @param str
	 * @return
	 */
	public static long getLong(String str) {
		long result = 0;
		try {
			if (str != null) {
				str = str.trim();
				if (str.length() > 0) {
					result = Long.parseLong(str);
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return result;
	}

	/**
	 * String 转 int
	 * 
	 * @param str
	 * @return
	 */

	public static int getInt(String str) {
		int result = 0;
		try {
			if (str != null) {
				str = str.trim();
				if (str.length() > 0) {
					result = Integer.parseInt(str);
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return result;
	}

	// 此类检查输入字符是否为空值，如果不空将input输出，否则将output输出 同时去除2边空格
	public static String getInString(String input, String out) {
		if (input == null) {
			input = out;
		} else if (input.equals("null") || input.equals("NULL")) {
			input = out;
		}
		return input.trim();
	}

	public static int getNumber(String input, int defaultNum) {
		int num;
		if (input != null && !"".equals(input)) {
			num = Integer.parseInt(input.trim());
		} else {
			num = defaultNum;
		}
		return num;
	}

	/**
	 * 将input空字符转换成 html 中的空字符
	 * 
	 * @param input
	 * @return
	 */
	public static String getHTMLString(String input) {
		String str = getInString(input, "&nbsp;");
		if (str.equals("")) {
			str = "&nbsp;";
		}
		return str;
	}

	/**
	 * 替换字符串中的最后一个指定子串
	 * 
	 * @param source
	 *            原字串
	 * @param oldStr
	 *            要被替换的字串
	 * @param newStr
	 *            要替换为的自创
	 * @return 替换过的新串
	 */
	public static String replaceString(String source, String oldStr, String newStr) {
		if (source == null || source.length() < 1)
			return "";
		String instr = source;
		String returnValue = "";
		int pos;
        int start = instr.lastIndexOf(oldStr);
        if(start > 0) {
            int end = start + oldStr.length();
            String head = source.substring(0, start);
            String tail = source.substring(end, source.length());
            returnValue = head + newStr + tail;
        }

		return returnValue;
	}

    /**
     * 替换字符串中的全部的指定的字符串
     *
     * @param source
     *            原字串
     * @param oldStr
     *            要被替换的字串
     * @param newStr
     *            要替换为的自创
     * @return 替换过的新串
     */
    public static String replacAllString(String source, String oldStr, String newStr) {
        if (source == null || source.length() < 1)
            return "";
        String instr = source;
        String returnValue = "";
        int pos;
        for (; instr.indexOf(oldStr) >= 0; instr = instr.substring(pos + oldStr.length())) {
            pos = instr.indexOf(oldStr);
            returnValue = String.valueOf(returnValue)
                    + String.valueOf(String.valueOf(instr.substring(0, pos)) + String.valueOf(newStr));
        }

        return String.valueOf(returnValue) + String.valueOf(instr);
    }


    /***************************************************************************
	 * 检查source是否为空串或空值，如果为空，将转换成target
	 * 
	 * @param source
	 * @param target
	 * @return
	 */
	public static String replaceBlankString(String source, String target) {
		String str = "";
		str = getInString(source, "");// 检查输入参数是否为空，如果为空换成空字符串
		if (str.equals("")) {
			str = target;
		}
		return str;
	}

	public static String getFileType(String filepath) {
		String filetype = "bak";
		if (filepath != null) {
			int dot = filepath.indexOf('.');
			if (dot > 0) {
				filetype = filepath.substring(dot + 1);
			}
		}
		return filetype;
	}

	/** **************** ended define function*************** */
	/**
	 * name : getCurrTimestamp parameter : void. function : get current system
	 * current date and change it into a string. return : String.
	 */
	public static String getCurrTimeString() {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ssa", Locale.US); // yyyyMMddddhhmmssSSS
		formatter.setTimeZone(TimeZone.getTimeZone("GMT+8"));
		Date currentTime = new Date();

		String dateString = formatter.format(currentTime);
		return dateString;
	}

	/** **************** ended define function*************** */
	/**
	 * name : getCurrTimestamp parameter : void. function : get current system
	 * current date and change it into a string. return : String.
	 */
	public static String getCurrTimestamp() {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ssa", Locale.US); // yyyyMMddddhhmmssSSS
		formatter.setTimeZone(TimeZone.getTimeZone("GMT+8"));
		Date currentTime = new Date();

		String dateString = formatter.format(currentTime);
		return dateString;
	}

	// public void

	public static java.util.Date getCurrTimeDate() {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ssa", Locale.US); // yyyyMMddddhhmmssSSS
		formatter.setTimeZone(TimeZone.getTimeZone("GMT+8"));
		Date currentTime = null;
		try {
			currentTime = formatter.parse(getCurrTimeString());
		} catch (ParseException e) {
			e.printStackTrace();
		}

		return currentTime;
	}

	/**
	 * 返回中文格式的当前时间
	 * 
	 * @return
	 */
	public static String getCurrTimeChina() {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy年MM月dd日 星期", Locale.US);
		formatter.setTimeZone(TimeZone.getTimeZone("GMT+8"));
		Date curTime = new Date();

		String dateStr = formatter.format(curTime);
		String w = "";
		switch (curTime.getDay()) {
		case 1:
			w = "一";
			break;

		case 2:
			w = "二";
			break;

		case 3:
			w = "三";
			break;

		case 4:
			w = "四";
			break;

		case 5:
			w = "五";
			break;

		case 6:
			w = "六";
			break;

		case 0:
			w = "天";
			break;
		}

		return dateStr.replaceFirst("星期", "星期" + w);
	}

	/**
	 * 字符串转时间转型
	 * 
	 * @param time
	 * @return
	 */
	public static java.util.Date getDateByDateFormat(String time, String formate) {
		SimpleDateFormat formatter = new SimpleDateFormat(formate);

		// java.util.Date bdate = formatter.parse("2009-11-10");
		java.util.Date date = null;
		try {
			date = formatter.parse(time);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return date;
	}

	public static String getCurrTimeName() {
		// Format the current time.
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddddhhmmssSSS"); // yyyyMMddddhhmmssSSS
		Date currentTime = new Date();
		String dateString = formatter.format(currentTime);
		return dateString;
	}
	
	public static String getCurrTimeName(Date date) {
		// Format the current time.
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
		String dateString = formatter.format(date);
		return dateString;
	}

	public static String getFormatDateTime(Date date) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US);
		sdf.setTimeZone(TimeZone.getTimeZone("GMT+8"));
		return sdf.format(date);
	}

	/***************************************************************************
	 * fn-hd fun:从指定的串中取指定标志后的数字,为数据传输做标志 par:date 需要处理的字符串 par:len 需要得到的字符串数组指针
	 * par:dFlag 标志 ret: thr:ServletException, IOException rem: exm: sep: pub:
	 * log: aut:chenqiang 2003年10月23日
	 */
	public static String readFlag(String date, int len, char dFlag) {
		if (len < 0 || date == null)
			return "";
		int flag = 0;

		char[] ch;
		ch = new char[len + 1];
		ch = date.toCharArray();
		String out = "";
		for (int i = 0; i < date.length(); i++) {
			if (ch[i] == dFlag) {
				flag++;
				continue;
			}
			if (flag == len) {
				out += ch[i];
			}
		}
		return out;
	}

	public static byte[] transInputstreamToBytes1(InputStream in) {
		byte[] b = null;
		try {
			b = new byte[in.available()];
			while (in.read(b) != -1) {

			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return b;

	}

	/**
	 * 将 InputStream 转化为 byte[]
	 * @param in 待转化的 InputStream
	 * @return 转化后的 byte[]
	 */
	public static byte[] transInputstreamToBytes(InputStream in) {
		byte[] in2b = null;
		ByteArrayOutputStream baos = null;
		try {
			baos = new ByteArrayOutputStream();
			byte[] buff = new byte[4096];
			int len = 0;
			while ((len = in.read(buff, 0, 4096)) > 0) {
				baos.write(buff, 0, len);
				baos.flush();
			}
			in2b = baos.toByteArray();
		} catch (IOException e) {
			logger.error(CommonUtil.getErrorInfoFromException(e));
		} finally {
			try {
				if (baos != null)
					baos.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return in2b;
	}

	// public static String converEncode(String str) {
	// String encode = SysConstant.get("ConverEncode", "");
	// String temp = str;
	//		
	// if (encode.length() > 0) {
	// String code[] = encode.split(";");
	//			
	// if (str == null || "".equals(str))
	// return "";
	// if (System.getProperty("os.name").startsWith("Windows"))
	// return str;
	// try {
	// return new String(str.getBytes(code[0]), code[1]);
	// } catch (Exception e) {
	// }
	// }
	// return temp;
	// }

	/**
	 * 产生一个随机编号时间+3位随机码
	 * 
	 * @return
	 */
	public static String getRecordId() {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmssSSS");
		Date currentTime = new Date();
		String dateString = formatter.format(currentTime);
		Random random = new Random();
		int z = 1000 + random.nextInt(1000);
		String s = String.valueOf(z).substring(1);
		dateString += s;
		return dateString;
	}

	/**
	 * 是否失效
	 * 
	 * @param startdate
	 *            起始日期
	 * @param enddate
	 *            结束日期
	 * @return
	 */
	public static boolean isExpired(Date startdate, Date enddate) {
		Date nowdate = new Date();
		if (nowdate.after(enddate)&&nowdate.before(startdate)) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * UtilDateToSqlDate
	 * 
	 * @param udate
	 * @return
	 */
	public static java.sql.Date transUtilDateToSqlDate(java.util.Date udate) {
		java.sql.Date sdate = new java.sql.Date(udate.getTime());
		return sdate;
	}

	/**
	 * 获得操作权限码
	 * 
	 * @param powercode
	 *            权限码操作规则
	 * @param orgcode
	 *            组织机构号
	 * @return
	 */
	public static String getPowercode(String powercode, String orgcode) {
		String returnstr = "";
		if (powercode != null && powercode.length() > 0) {
			String str[] = powercode.split("-");

			if ("*".equals(str[0])) {
				returnstr = orgcode.substring(0, Integer.parseInt(str[1]));
			} else {
				returnstr = str[0].substring(0, Integer.parseInt(str[1]));
			}
		}
		return returnstr;
	}

	public static boolean isBlankorNull(Object o) {
		if ("".equals(o) || o == null || "null".equals(o)) {// 如果是空
			return true;
		} else {
			return false;
		}
	}

	public static boolean isNotNull(String input) {
		if (input != null && input.trim().length() > 0) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean isNotNull(byte[] input) {
		if (input != null && input.length > 0) {
			return true;
		} else {
			return false;
		}
	}
	
	public static boolean isNotNull(Integer input) {
		if (input != null) {
			return true;
		} else {
			return false;
		}
	}
	
	public static boolean isNotNull(Object input) {
		if (input != null) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean isNotNull(Date input) {
		if (input != null) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean isNotNull(List input) {
		if (input != null && input.size() > 0) {
			return true;
		} else {
			return false;
		}
	}
	
	
	/**
	 * yyyy-MM-dd-HH:mm:ss 时间格式转换成一个字符串
	 * 
	 * @param currentTime
	 * @param formate
	 * @return
	 */
	public static String getStringByDateFormat(java.util.Date currentTime, String formate) {
		Date currentTimec = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat(formate);
		return formatter.format(currentTimec);

	}

	public static byte[] getBASE64Bytes(byte[] input) {
		byte[] b = null;
		try {
			if (input != null && input.length > 0) {
				BASE64Encoder bd = new BASE64Encoder();
				String output = bd.encode(input);
				b = output.getBytes();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return b;
	}

	public static byte[] getUnBASE64Bytes(byte[] input) {
		byte[] b = null;
		try {
			if (input != null && input.length > 0) {
				BASE64Decoder bd = new BASE64Decoder();
				b = bd.decodeBuffer(new String(input));
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return b;
	}

	/**
	 * @param value
	 *            需加密的串
	 * @return 加密后的串
	 */
	public static String getBase64String(String value) {
		String encodeValue = "";
		if (value != null && value.length() > 0) {
			encodeValue = new sun.misc.BASE64Encoder().encode(value.getBytes());
		}
		return encodeValue;
	}
	
	/**
	 * @param value
	 *            需加密的串
	 * @return 加密后的串
	 */
	public static String getBase64String(byte[] value) {
		String encodeValue = "";
		if (value != null && value.length > 0) {
			encodeValue = new sun.misc.BASE64Encoder().encode(value);
		}
		return encodeValue;
	}


	/*public static void main(String[] args) {
		String str1 = "5paH5qGj5LqM";
		System.out.println(getUnbase64String(str1));
	}*/
	/**
	 * @param value
	 *            要解密的串
	 * @return 解密后的串
	 */
	public static String getUnbase64String(String value) {
		
		
		String decodeValue = "";
		if (value != null && value.length() > 0) {
			try {
				BASE64Decoder decoder = new BASE64Decoder();
				ByteArrayInputStream bis = new ByteArrayInputStream(value.getBytes());
				decodeValue = new String(decoder.decodeBuffer(bis),"UTF-8");
				bis.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return decodeValue;
	}
	
	/**
	 * @param value
	 *            要解密的串
	 * @return 解密后的串
	 */
	public static byte[] getUnbase64Byte(String value) {
		
		byte[] decodeValue = null;
		if (value != null && value.length() > 0) {
			try {
				BASE64Decoder decoder = new BASE64Decoder();
				ByteArrayInputStream bis = new ByteArrayInputStream(value.getBytes());
				decodeValue = decoder.decodeBuffer(bis);
				bis.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return decodeValue;
	}
	
	public static byte[] getNewUnBASE64String(byte[] input) {
		try {
			if (input != null && input.length > 0) {
				BASE64Decoder bd = new BASE64Decoder();
				ByteArrayInputStream bis = new ByteArrayInputStream(input);
				input = bd.decodeBuffer(bis);
				bis.close();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return input;
	}

	/**
	 * java MD5运算
	 * 
	 * @param pwd
	 * @return
	 */
	public final static String getMD5String(String pwd) {
		char hexDigits[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };
		try {
			byte[] strTemp = pwd.getBytes();
			MessageDigest mdTemp = MessageDigest.getInstance("MD5");
			mdTemp.update(strTemp);
			byte[] md = mdTemp.digest();
			int j = md.length;
			char str[] = new char[j * 2];
			int k = 0;
			for (int i = 0; i < j; i++) {
				byte byte0 = md[i];
				str[k++] = hexDigits[byte0 >>> 4 & 0xf];
				str[k++] = hexDigits[byte0 & 0xf];
			}
			return new String(str);
		} catch (Exception e) {
			return null;
		}
	}

	/**
	 * 将源文件拷贝到目标文件
	 * 
	 * @param src
	 *            源文件
	 * @param target
	 *            目标文件
	 */
	private static void copy(File src, File target) {
		InputStream in = null;
		OutputStream out = null;
		int bufferSize = 4096;
		try {
			in = new BufferedInputStream(new FileInputStream(src), bufferSize);
			out = new BufferedOutputStream(new FileOutputStream(target), bufferSize);
			byte[] bs = new byte[bufferSize];
			int i;
			while ((i = in.read(bs)) > 0) {
				out.write(bs, 0, i);
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				if (in != null)
					in.close();
				if (out != null)
					out.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * 验证证书密码是否正确
	 * 
	 * @param is
	 *            证书内容文件流
	 * @param passWord
	 *            证书密码
	 * @return
	 */
	public static Certificate validateCertificate(InputStream is, String passWord) {
		Certificate cert = null;
		try {
			KeyStore ks = KeyStore.getInstance("PKCS12");
			char[] nPassword = null;
			if ((passWord == null) || passWord.trim().equals("")) {
				nPassword = null;
			} else {
				nPassword = passWord.toCharArray();
			}
			ks.load(is, nPassword);
			Enumeration enumas = ks.aliases();
			String keyAlias = null;
			if (enumas.hasMoreElements())// we are readin just one
				keyAlias = (String) enumas.nextElement();
			cert = ks.getCertificate(keyAlias);
		} catch (Exception e) {
			e.printStackTrace();
			// 出现异常则密码错误
		}
		return cert;
	}

	/**
	 * 获取证书信息中的CN信息
	 * 
	 * @param certInfo
	 * @param InfoType
	 *            信息类型
	 * @return
	 */
	public static String getCN(String certInfo, String InfoType) {
		Map map = new HashMap();
		String[] sub = certInfo.split(",");
		for (int i = 0, len = sub.length; i < len; i++) {
			String[] temp = sub[i].split("=");
			map.put(temp[0].trim(), temp[1]);
		}
		return (String) map.get(InfoType);
	}


	public static boolean IsBlankorNull(Object o) {
		if ("".equals(o) || o == null || "null".equals(o)) {// 如果是空
			return true;
		} else {
			return false;
		}
	}


	
	/**
	 * 设置权限
	 * 
	 * @param permission
	 * @param yes
	 *            true 设置权限 false取消权限
	 */
	public static int setPermission(int permission, int aclState, boolean yes) {
		int temp = 1;
		temp = temp << permission;
		if (yes) {
			aclState |= temp;
		} else {
			aclState &= ~temp;
		}
		return aclState;
	}
	
	/**
	 * MD5字符串
	 * 
	 * @param input
	 * @return
	 */
	public final static String MD5String(String input) {
		char hexDigits[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };
		try {
			byte[] strTemp = input.getBytes();
			MessageDigest mdTemp = MessageDigest.getInstance("MD5");
			mdTemp.update(strTemp);
			byte[] md = mdTemp.digest();
			int j = md.length;
			char str[] = new char[j * 2];
			int k = 0;
			for (int i = 0; i < j; i++) {
				byte byte0 = md[i];
				str[k++] = hexDigits[byte0 >>> 4 & 0xf];
				str[k++] = hexDigits[byte0 & 0xf];
			}
			return new String(str).toLowerCase();
		} catch (Exception e) {
			return "";
		}
	}
	
	/**
	 * 
	 * @param permission
	 *            操作
	 * @return 1有权限 0无权限
	 */
	public static int getPermission(int permission, int aclState) {
		int temp = 1;
		temp = temp << permission;
		temp &= aclState;
		if (temp != 0) {
			return 1;
		}
		return 0;
	}
	
	/**
	 * 按 公安 的方式生成组织机构码，前十位表示机构，后三位表示部门，如果不是部门，后三位为空
	 * @param parentCode 父机构代码
	 * @param index 父机构下的所有机构数量
	 * @param isOrg 是否是机构，true是机构，false是部门
	 * @return
	 */
	public static String generateOrgCode(String parentCode, int index, boolean isOrg) {
		String code = "";
		if(isOrg) {
			// 如果是机构取到第一个00的位置，把00换成index
			int posOf00 = parentCode.indexOf("00");
			String codeBefor = parentCode.substring(0, posOf00);
			String codeBetween = parentCode.substring(posOf00, posOf00+2);
			String codeAfter = parentCode.substring(posOf00+2, parentCode.length());
			if(index < 10) {
				codeBetween = "0"+ String.valueOf(index);
			} else {
				codeBetween = String.valueOf(index);
			}
			code = codeBefor + codeBetween + codeAfter;
		} else {
			// 如果是部门，则直接在部门后面添加三位数
			String codeAfter = "";
			if(index < 10) {
				codeAfter = "00"+ String.valueOf(index);
			} else {
				codeAfter = "0"+ String.valueOf(index);
			}
			code = parentCode + codeAfter;
		}
		return code;
	}
	

	
	//随机生成密码
	public static String getRandPass(){
		Random random = new Random();
		String[] ss = {"a","b","c","d","e","f","g","h","i","J","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9"};
		String pass = "";
		for (int i = 0; i < 10; i++) {
			pass +=ss[random.nextInt(62)];
		}
		return pass ;
	}
	
	//随机生成密码
	public static String getRandEncrypt(){
		Random random = new Random();
		String[] ss = {"a","b","c","d","e","f","g","h","i","J","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9"};
		String pass = "";
		for (int i = 0; i < 16; i++) {
			pass +=ss[random.nextInt(62)];
		}
		return pass ;
	}

	
	
	public static void printXml(org.dom4j.Document dataDocument) {
		OutputFormat format = OutputFormat.createPrettyPrint();
		try {
			OutputStream os = new ByteArrayOutputStream();
			XMLWriter xMLWriter = new XMLWriter(os, format);
			xMLWriter.write(dataDocument);
			xMLWriter.close();
			
			System.out.println(getCurrTimeString() + " : " + os.toString());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public static void writeXML(org.dom4j.Document dataDocument, OutputStream os) {
		OutputFormat format = OutputFormat.createPrettyPrint();
		try {
			XMLWriter xMLWriter = new XMLWriter(os, format);
			xMLWriter.write(dataDocument);
			xMLWriter.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	

//	public static byte[] getBASE64Bytes(byte[] input) {
//		byte[] b = null;
//		try {
//			if (input != null && input.length > 0) {
//				BASE64Encoder bd = new BASE64Encoder();
//				String output = bd.encode(input);
//				b = output.getBytes();
//			}
//		} catch (Exception ex) {
//			ex.printStackTrace();
//		}
//		return b;
//	}
//
//	public static byte[] getUnBASE64Bytes(byte[] input) {
//		byte[] b = null;
//		try {
//			if (input != null && input.length > 0) {
//				BASE64Decoder bd = new BASE64Decoder();
//				b = bd.decodeBuffer(new String(input, "UTF-8"));
//			}
//		} catch (Exception ex) {
//			ex.printStackTrace();
//		}
//		return b;
//	}
//
//	/**
//	 * @param value
//	 *                ܵĴ 
//	 * @return    ܺ Ĵ 
//	 */
//	public static String getBase64String(String value) {
//		String encodeValue = "";
//		if (value != null && value.length() > 0) {
//			try {
//				encodeValue = new sun.misc.BASE64Encoder().encode(value.getBytes("UTF-8"));
//			} catch (UnsupportedEncodingException e) {
//				e.printStackTrace();
//			}
//		}
//		return encodeValue;
//	}
	
	/**
	 * @param cert
	 * @return
	 */
	public static byte[] makeCert(String cert) {
		// Vector data = new Vector(1024);
		StringTokenizer st = new StringTokenizer(cert, " ");
		int nSize = 0;
		while (st.hasMoreTokens()) {
			nSize++;
			st.nextToken();
		}
		byte[] datas = new byte[nSize];
		st = new StringTokenizer(cert, " ");
		int nCounter = 0;
		while (st.hasMoreTokens()) {
			String sData = st.nextToken();
			datas[nCounter] = (byte) Integer.parseInt(sData);
			nCounter++;
		}
		return datas;
	}
	
	/**
	 * 将字节数组写到文件中
	 * @param b 字节数组
	 * @param outputFile 文件名称
	 * @return
	 */
	public static File writeBytesToFile(byte[] b, String outputFile) {
		File file = null;
		OutputStream os = null;
		try {
			file = new File(outputFile);
			os = new FileOutputStream(file);
			os.write(b);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (os != null) {
					os.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return file;
	}
	public static byte[] readBytesFromFile(File file) {
		byte[] bytes = null;
		try {
			InputStream is = new FileInputStream(file);
			bytes = CommonUtil.transInputstreamToBytes(is);
			is.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return bytes; 
	}
	
	
	
	//获取当前时间一周前的时间
	public static Date lastWeek() {
		Date date = new Date();
		int year = Integer.parseInt(new SimpleDateFormat("yyyy").format(date));
		int month = Integer.parseInt(new SimpleDateFormat("MM").format(date));
		int day = Integer.parseInt(new SimpleDateFormat("dd").format(date)) - 7;

		if (day < 1) {
			month -= 1;
			if (month == 0) {
				year -= 1;
				month = 12;
			}
			if (month == 4 || month == 6 || month == 9 || month == 11) {
				day = 30 + day;
			} else if (month == 1 || month == 3 || month == 5 || month == 7
					|| month == 8 || month == 10 || month == 12) {
				day = 31 + day;
			} else if (month == 2) {
				if (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0))
					day = 29 + day;
				else
					day = 28 + day;
			}
		}
		String y = year + "";
		String m = "";
		String d = "";
		if (month < 10)
			m = "0" + month;
		else
			m = month + "";
		if (day < 10)
			d = "0" + day;
		else
			d = day + "";
		
		String strDate = y + "-" + m + "-" + d+" 00:00:00";
		
		//System.out.println("qqq:"+strDate);
		
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date newdate=null;
		try {
			newdate = sdf.parse(strDate);
		}
		catch (ParseException e) {
			e.printStackTrace();
		}
		
		return newdate;
	}
	
	
	public static void deleteFile(String path) {
		File file = new File(path);
		if(file.exists()) {
			file.delete();	
		}
	}
	/**
	 * @param value 需加密的串
	 * @return 加密后的串
	 */
	public static String base64String(String value) {
		String encodeValue = "";
		if (value != null && value.length() > 0) {
			encodeValue = new sun.misc.BASE64Encoder().encode(value.getBytes());
		}
		return encodeValue;
	}
	public static byte[] getBASE64String(byte[] input) {
		byte[] b = null;
		try {
			if (input != null && input.length > 0) {
				BASE64Encoder base64 = new BASE64Encoder();
				b = base64.encodeBuffer(input).trim().getBytes();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return b;

	}
	
	public static byte[] upload(URL url) throws Exception{
		byte[] tytes = null;
		//	URL url = new URL(requestUrl);  
		HttpURLConnection httpUrlConn = (HttpURLConnection) url.openConnection();

		httpUrlConn.setDoOutput(true);
		httpUrlConn.setDoInput(true);
		httpUrlConn.setUseCaches(false);
		// 设置请求方式（GET/POST）  

		httpUrlConn.setRequestMethod("POST");

		httpUrlConn.connect();

		// 将返回的输入流转换成字符串  
		InputStream inputStream = httpUrlConn.getInputStream();
		tytes = CommonUtil.transInputstreamToBytes(inputStream);
		return tytes;
	}
	

//	public static void writeExcelToResponse(HttpServletResponse response, byte[] excelBytes, String fileName) {
//		OutputStream os  = null;
//		try {
//			response.setContentType("text/xml;charset=utf-8");
//			response.setContentType("application/xls");
//			response.addHeader("Content-Disposition", "attachment; filename=" + URLEncoder.encode(fileName, "UTF-8") +".xls");
//			response.setCharacterEncoding("utf-8");
//			os = response.getOutputStream();
//			os.write(excelBytes);
//			os.flush();
//		} catch (Exception e) {
//			e.printStackTrace();
//		} finally {
//			try {
//				if(os != null) {
//					os.close();
//				}
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//		}
//	}
	
	/**
	 * @param value
	 *            需加密的串
	 * @return 加密后的串
	 */
	public static String getUnbase64StringByDefaultCharSet(String value) {
		return getUnbase64String(value, DEFAULT_CHAR_SET);
	}
	
	/**
	 * @param value
	 *            要解密的串
	 * @return 解密后的串
	 */
	public static String getUnbase64String(String value, String charSet) {
		String decodeValue = "";
		if (value != null && value.length() > 0) {
			try {
				BASE64Decoder decoder = new BASE64Decoder();
				ByteArrayInputStream bis = new ByteArrayInputStream(value.getBytes());
				decodeValue = new String(decoder.decodeBuffer(bis), charSet);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return decodeValue;
	}


	private static int getRowNum(String[] texts) {
		int rowNum = 1;
		if(texts != null && texts.length > 0) {
			rowNum =texts.length;
		}
		return rowNum;
	}

	private static int getRowHeight(String[] texts) {
		int textLength = 0;
		if(texts != null && texts.length > 0) {
			for (int i = 0; i < texts.length; i++) {
				String txt = texts[i];
				// 原长度
				int lenInText = txt.getBytes().length;
				if(textLength < lenInText) {
					textLength = lenInText;
				}

				// 数字的数量
				int digitNum = getDigitNum(txt);
				if(digitNum != 0) {
					textLength += digitNum / 4;
				}
			}
		}
		return textLength;
	}

	private static int getDigitNum(String txt) {
		int len = 0;
		for (int i = 0; i < txt.length(); i++) {
			if(txt.charAt(i) >= 48 && txt.charAt(i) <= 57) {
				len ++;
			}
		}
		return len;
	}

	public static String getErrorInfoFromException(Exception e) {
		try {
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			PrintStream ps = new PrintStream(baos);
			e.printStackTrace(ps);
			String info = baos.toString();
			ps.close();
			baos.close();
			return "\r\n" + info + "\r\n";
		} catch (Exception e2) {
			return "bad getErrorInfoFromException";
		}
	}
	
	/**
	 * 对字符串进行Base64编码
	 *
	 * @param value
	 *            需编码的字符串
	 * @param charSet
	 *            编码格式
	 * @return 编码后的字符串
	 */
	public static String base64EncodeString(String value, String charSet) {
		String encodeValue = null;
		if (value != null) {
			try {
				encodeValue = new BASE64Encoder().encode(value.getBytes(charSet));
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		}
		return encodeValue;
	}
	
	/**
	 * 对字符串进行Base64解码
	 * 
	 * @param value
	 *            要编码的字符串
	 * @param charSet
	 *            编码格式
	 * @return 编码后的字符串
	 */
	public static String base64DecodeString(String value, String charSet) {
		String decodeValue = null;
		if (value != null) {
			try {
				BASE64Decoder decoder = new BASE64Decoder();
				decodeValue = new String(decoder.decodeBuffer(value), charSet);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return decodeValue;
	}
	
	public static void main(String[] args){
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd000000");
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.YEAR, 1);
		System.out.println(formatter.format(calendar.getTime()));
//		try{
//			//byte[] bst = CommonUtil.transInputstreamToBytes(new FileInputStream("c:\\1.dat"));
//			String ss = CommonUtil.getUnbase64String("saO05takyunKsbryt6LJ+tLss6OjrNLss6PQxc+io7pjb3VsZCBub3QgZXhlY3V0ZSBzdGF0ZW1l bnQ=","GBK");
//			System.out.println(ss);
//		}catch(Exception e){
//			
//		}
		
	}
	
	public static String getExceptionInfo(Exception e) {
		StringWriter stringWriter = new StringWriter();
		PrintWriter writer = new PrintWriter(stringWriter);
		e.printStackTrace(writer);
		StringBuffer buffer = stringWriter.getBuffer();
		return buffer.toString();
	}
	
	public static byte[] hexStringToBytes(String hexString) {
		if (hexString == null || hexString.equals("")) {
			return null;
		}
		hexString = hexString.toUpperCase();
		int length = hexString.length() / 2;
		char[] hexChars = hexString.toCharArray();
		byte[] d = new byte[length];
		for (int i = 0; i < length; i++) {
			int pos = i * 2;
			d[i] = (byte) (charToByte(hexChars[pos]) << 4 | charToByte(hexChars[pos + 1]));
		}
		return d;
	}
	private static byte charToByte(char c) {
		return (byte) "0123456789ABCDEF".indexOf(c);
	}
	/**
	 * 对字节数组进行Base64解码
	 * 
	 * @param input
	 *            要编码的字节数组
	 * @return 编码后的字节数组
	 */
	public static byte[] base64DecodeByte(byte[] input) {
		byte[] b = null;
		try {
			if (input != null && input.length > 0) {
				BASE64Decoder bd = new BASE64Decoder();
				b = bd.decodeBuffer(new ByteArrayInputStream(input));
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return b;
	}

	/**
	 * 将InputStream中的内容读取出来，转为字节数据 InputStream --> byte[]
	 * 
	 * @param is
	 * @return
	 */
	public static byte[] transIsToBytes(InputStream is) {
		int BUFF_SIZE = 1024;
		byte[] in2b = null;
		ByteArrayOutputStream baos = null;
		try {
			baos = new ByteArrayOutputStream();
			byte[] buff = new byte[BUFF_SIZE];
			int len = 0;
			while ((len = is.read(buff, 0, BUFF_SIZE)) > 0) {
				baos.write(buff, 0, len);
				baos.flush();
			}
			in2b = baos.toByteArray();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				if (baos != null)
					baos.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return in2b;
	}
	
	public static boolean verificationNum(String dateTime){
		boolean flag = false;
		try {
			String[] dateArr = dateTime.split("-");
			if(dateArr.length != 3)
				return false;
			
			if(dateArr[0].length() != 4 && dateArr[1].length() != 2 && dateArr[2].length() != 2)
				return false;
			
			for (int i = 0; i < dateArr.length; i++) {
				flag = isNumeric(dateArr[i]);
				if(!flag)
					break;
			}
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return flag;
	}
	
	public static String getDateToString(Date date) {
		String str = null;
		if (CommonUtil.isNotNull(date)) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			str = sdf.format(date);
		}
		return str;
	}
	
	public static boolean isNumeric(String str){ 
	   Pattern pattern = Pattern.compile("[0-9]*"); 
	   Matcher isNum = pattern.matcher(str);
	   if(!isNum.matches()){
	       return false; 
	   } 
	   return true; 
	}
}


