package com.seeyon.apps.kdXdtzXc.util;

import org.apache.commons.lang.math.NumberUtils;

import java.text.DecimalFormat;
import java.text.NumberFormat;

public class NumberUtilsExt extends NumberUtils {
	private static String HanDigiStr[] = new String[] { "零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖" };

	private static String HanDiviStr[] = new String[] { "", "拾", "佰", "仟", "万", "拾", "佰", "仟", "亿", "拾", "佰", "仟", "万", "拾", "佰", "仟", "亿", "拾", "佰", "仟", "万", "拾", "佰", "仟" };

	public static String numberFormat(int formatNum, char append, int length) {
		String result = "";
		StringBuffer format = new StringBuffer();
		for (int i = 0; i < length; i++) {
			format.append(String.valueOf(append));
		}
		DecimalFormat decimalFormat = new DecimalFormat(format.toString());
		result = decimalFormat.format(formatNum);
		return result;
	}

	/**
	 * @param value
	 * @param format
	 *            #0.00
	 * @return
	 */
	public static String decimalFormat(Object value, String format) {
		DecimalFormat df = null;
		if (format != null && format.length() > 0) {
			df = new DecimalFormat(format);
		} else {
			df = new DecimalFormat();
		}
		return df.format(value);
	}

	/**
	 * 数字转为字符型
	 * 
	 * @param value
	 * @param isGroupingUsed
	 *            如果数据大，是否用逗号隔开
	 * @return
	 */
	public static String numberFormat(Object value, boolean isGroupingUsed) {
		if (value == null)
			return null;
		String result = null;
		if (value instanceof String) {
			String vStr = (String) value;
			return vStr;
		} else if (value instanceof Integer) {
			Integer vInteger = (Integer) value;
			NumberFormat format = NumberFormat.getInstance();
			format.setGroupingUsed(isGroupingUsed);
			result = format.format(vInteger.intValue());
		} else if (value instanceof Long) {
			Long vLong = (Long) value;
			NumberFormat format = NumberFormat.getInstance();
			format.setGroupingUsed(isGroupingUsed);
			result = format.format(vLong.longValue());
		} else if (value instanceof Double) {
			Double vDouble = (Double) value;
			NumberFormat format = NumberFormat.getInstance();
			format.setGroupingUsed(isGroupingUsed);
			result = format.format(vDouble.doubleValue());
		}

		return result;
	}

	/**
	 * 安全转换，如果是null值，则返回字符""值
	 * 
	 * @param value
	 * @param isGroupingUsed
	 * @param defaultValue
	 * @return
	 */
	public static String numberSafeFormat(Object value, boolean isGroupingUsed, String defaultValue) {
		if (value == null) {
			if (defaultValue != null)
				return defaultValue;
			else
				return "";
		} else {
			return NumberUtilsExt.numberFormat(value, isGroupingUsed);
		}
	}

	public static String numberFormat(Object value) {
		return NumberUtilsExt.numberFormat(value, false);
	}

	public static String numberSafeFormat(Object value) {
		return NumberUtilsExt.numberSafeFormat(value, false, "");
	}

	public static double getDouble(String s) {
		double d = 0.0D;
		NumberFormat nf = NumberFormat.getInstance();
		try {
			if (s.indexOf("%") >= 0)
				d = NumberFormat.getPercentInstance().parse(s).doubleValue();
			else if (s.indexOf("\uFFE5") >= 0)
				d = NumberFormat.getCurrencyInstance().parse(s).doubleValue();
			else
				d = nf.parse(s).doubleValue();
		} catch (Exception ex2) {
			ex2.printStackTrace();
		}

		return d;
	}

	/**
	 * 将货币转换为大写形式(类内部调用)
	 * 
	 * @param
	 * @return String
	 */
	private static String PositiveIntegerToHanStr(String NumStr) {
		// 输入字符串必须正整数，只允许前导空格(必须右对齐)，不宜有前导零
		String RMBStr = "";
		boolean lastzero = false;
		boolean hasvalue = false; // 亿、万进位前有数值标记
		int len, n;
		len = NumStr.length();
		if (len > 15)
			return "数值过大!";
		for (int i = len - 1; i >= 0; i--) {
			if (NumStr.charAt(len - i - 1) == ' ')
				continue;
			n = NumStr.charAt(len - i - 1) - '0';
			if (n < 0 || n > 9)
				return "输入含非数字字符!";

			if (n != 0) {
				if (lastzero)
					RMBStr += HanDigiStr[0]; // 若干零后若跟非零值，只显示一个零
				// 除了亿万前的零不带到后面
				// if( !( n==1 && (i%4)==1 && (lastzero || i==len-1) ) )
				// 如十进位前有零也不发壹音用此行
				if (!(n == 1 && (i % 4) == 1 && i == len - 1)) // 十进位处于第一位不发壹音
					RMBStr += HanDigiStr[n];
				RMBStr += HanDiviStr[i]; // 非零值后加进位，个位为空
				hasvalue = true; // 置万进位前有值标记

			} else {
				if ((i % 8) == 0 || ((i % 8) == 4 && hasvalue)) // 亿万之间必须有非零值方显示万
					RMBStr += HanDiviStr[i]; // “亿”或“万”
			}
			if (i % 8 == 0)
				hasvalue = false; // 万进位前有值标记逢亿复位
			lastzero = (n == 0) && (i % 4 != 0);
		}

		if (RMBStr.length() == 0)
			return HanDigiStr[0]; // 输入空字符或"0"，返回"零"
		return RMBStr;
	}

	/**
	 * 将货币转换为大写形式
	 * 
	 * @param val
	 *            传入的数据
	 * @return String 返回的人民币大写形式字符串
	 */
	public static String numToRMBStr(double val) {
		String SignStr = "";
		String TailStr = "";
		long fraction, integer;
		int jiao, fen;

		if (val < 0) {
			val = -val;
			SignStr = "负";
		}
		if (val > 99999999999999.999 || val < -99999999999999.999)
			return "数值位数过大!";
		// 四舍五入到分
		long temp = Math.round(val * 100);
		integer = temp / 100;
		fraction = temp % 100;
		jiao = (int) fraction / 10;
		fen = (int) fraction % 10;
		if (jiao == 0 && fen == 0) {
			TailStr = "整";
		} else {
			TailStr = HanDigiStr[jiao];
			if (jiao != 0)
				TailStr += "角";
			// 零元后不写零几分
			if (integer == 0 && jiao == 0)
				TailStr = "";
			if (fen != 0)
				TailStr += HanDigiStr[fen] + "分";
		}
		// 下一行可用于非正规金融场合，0.03只显示“叁分”而不是“零元叁分”
		// if( !integer ) return SignStr+TailStr;
		return SignStr + PositiveIntegerToHanStr(String.valueOf(integer)) + "元" + TailStr;
	}

	public static String format(double d, int places) {
		NumberFormat nf = NumberFormat.getInstance();
		nf.setMinimumFractionDigits(places);
		nf.setMaximumFractionDigits(places);
		return nf.format(d);
	}

	public static String format(Double d, int places) {
		return format(d.doubleValue(), places);
	}

	public static String format(String d, int places) {
		return format(Double.parseDouble(d), places);
	}

	public static String getPrecent(float a, float b, int cnt) {
		String Precent = "";
		if (b == 0.0F) {
			Precent = "0";
			Precent = Precent + ".";
			Precent = Precent + "0";
			Precent = Precent + "%";
			return Precent;
		}
		if (a == b) {
			Precent = "100";
			Precent = Precent + "%";
			return Precent;
		}
		float result = (a * 100F) / b;
		String vresult = String.valueOf(result);
		int nn = vresult.indexOf(".");
		if (vresult.length() >= nn + cnt + 1) {
			Precent = vresult.substring(0, nn + cnt + 1);
			Precent = format(Precent, cnt);
		} else {
			Precent = vresult;
			String pointStr = Precent.substring(Precent.lastIndexOf(".") + 1, Precent.length());
			for (int i = 0; i < cnt - pointStr.length(); i++)
				Precent = Precent + 0;

		}
		Precent = Precent + "%";
		return Precent;
	}


}