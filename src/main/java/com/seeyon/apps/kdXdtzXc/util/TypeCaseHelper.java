package com.seeyon.apps.kdXdtzXc.util;

import java.math.BigDecimal;
import java.sql.Time;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Locale;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;

public class TypeCaseHelper {

	public static Object convert(Object obj, String type, String format) {
		Locale locale = new Locale("zh", "CN", "");
		if (obj == null)
			return null;
		if (obj.getClass().getName().equals(type) && StringUtils.isEmpty(format))
			return obj;
		if ("Object".equals(type) || "java.lang.Object".equals(type))
			return obj;
		String fromType = null;
		if (obj instanceof String) {
			fromType = "String";
			String str = (String) obj;
			if ("String".equals(type) || "java.lang.String".equals(type)) {
				return obj;
			} else if (str.length() == 0) {
				return null;
			} else if ("Boolean".equals(type) || "java.lang.Boolean".equals(type)) {
				Boolean value = null;
				if (str.equalsIgnoreCase("TRUE"))
					value = new Boolean(true);
				else
					value = new Boolean(false);
				return value;
			} else if ("Double".equals(type) || "java.lang.Double".equals(type)) {
				try {
					Number tempNum = getNf(locale).parse(str);
					return new Double(tempNum.doubleValue());
				} catch (ParseException e) {
					throw new RuntimeException("Could not convert " + str + " to " + type + ": ", e);
				}
			} else if ("BigDecimal".equals(type) || "java.math.BigDecimal".equals(type)) {
				try {
					BigDecimal retBig = new BigDecimal(str);
					int iscale = str.indexOf(".");
					int keylen = str.length();
					if (iscale > -1) {
						iscale = keylen - (iscale + 1);
						return retBig.setScale(iscale, 5);
					} else {
						return retBig.setScale(0, 5);
					}
				} catch (Exception e) {
					throw new RuntimeException("Could not convert " + str + " to " + type + ": ", e);
				}
			} else if ("Float".equals(type) || "java.lang.Float".equals(type)) {
				try {
					Number tempNum = getNf(locale).parse(str);
					return new Float(tempNum.floatValue());
				} catch (ParseException e) {
					throw new RuntimeException("Could not convert " + str + " to " + type + ": ", e);
				}
			} else if ("Long".equals(type) || "java.lang.Long".equals(type)) {
				try {
					NumberFormat nf = getNf(locale);
					nf.setMaximumFractionDigits(0);
					Number tempNum = nf.parse(str);
					return new Long(tempNum.longValue());
				} catch (ParseException e) {
					throw new RuntimeException("Could not convert " + str + " to " + type + ": ", e);
				}
			} else if ("Integer".equals(type) || "java.lang.Integer".equals(type)) {
				try {
					NumberFormat nf = getNf(locale);
					nf.setMaximumFractionDigits(0);
					Number tempNum = nf.parse(str);
					return new Integer(tempNum.intValue());
				} catch (ParseException e) {
					throw new RuntimeException("Could not convert " + str + " to " + type + ": ", e);
				}
			} else if ("Date".equals(type) || "java.sql.Date".equals(type)) {
				try {
					if (format == null || format.length() == 0) {
						String[] pattern = new String[] { "yyyy-MM", "yyyyMM", "yyyy/MM", "yyyyMMdd", "yyyy-MM-dd", "yyyy/MM/dd", "yyyyMMddHHmmss", "yyyy-MM-dd HH:mm:ss", "yyyy/MM/dd HH:mm:ss", "yyyy-MM-dd HH:mm" };
						java.util.Date d = DateUtils.parseDate(str, pattern);
						return new java.sql.Date(d.getTime());
					} else {
						SimpleDateFormat sdf = new SimpleDateFormat(format);
						java.util.Date d = sdf.parse(str);
						return new java.sql.Date(d.getTime());
					}
				} catch (ParseException e) {
					throw new RuntimeException("Could not convert " + str + " to " + type + ": ", e);
				}
			} else if ("java.util.Date".equals(type)) {
				try {
					if (format == null || format.length() == 0) {
						String[] pattern = new String[] { "yyyy-MM", "yyyyMM", "yyyy/MM", "yyyyMMdd", "yyyy-MM-dd", "yyyy/MM/dd", "yyyyMMddHHmmss", "yyyy-MM-dd HH:mm:ss", "yyyy/MM/dd HH:mm:ss", "yyyy-MM-dd HH:mm" };
						java.util.Date d = DateUtils.parseDate(str, pattern);
						return d;
					} else {
						SimpleDateFormat sdf = new SimpleDateFormat(format);
						java.util.Date d = sdf.parse(str);
						return d;
					}
				} catch (ParseException e) {
					throw new RuntimeException("Could not convert " + str + " to " + type + ": ", e);
				}
			} else if ("Timestamp".equals(type) || "java.sql.Timestamp".equals(type)) {
				if (str.length() == 10)
					str = str + " 00:00:00";
				if (format == null || format.length() == 0)
					try {
						return Timestamp.valueOf(str);
					} catch (Exception e) {
						try {
							DateFormat df = null;
							if (locale != null)
								df = DateFormat.getDateTimeInstance(3, 3, locale);
							else
								df = DateFormat.getDateTimeInstance(3, 3);
							java.util.Date fieldDate = df.parse(str);
							return new Timestamp(fieldDate.getTime());
						} catch (ParseException e1) {
							throw new RuntimeException("Could not convert " + str + " to " + type + ": ", e);
						}
					}
				try {
					SimpleDateFormat sdf = new SimpleDateFormat(format);
					java.util.Date fieldDate = sdf.parse(str);
					return new Timestamp(fieldDate.getTime());
				} catch (ParseException e) {
					throw new RuntimeException("Could not convert " + str + " to " + type + ": ", e);
				}
			} else {
				throw new RuntimeException("Conversion from " + fromType + " to " + type + " not currently supported");
			}
		} else if (obj instanceof BigDecimal) {
			fromType = "BigDecimal";
			BigDecimal bigD = (BigDecimal) obj;
			if ("String".equals(type)) {
				if (!StringUtils.isEmpty(format))
					return NumberUtilsExt.decimalFormat(bigD, format);
				else
					return bigD.toString();
			} else if ("BigDecimal".equals(type) || "java.math.BigDecimal".equals(type)) {
				return obj;
			} else if ("Double".equals(type)) {
				return new Double(bigD.doubleValue());
			} else if ("Float".equals(type)) {
				return new Float(bigD.floatValue());
			} else if ("Long".equals(type)) {
				return new Long(Math.round(bigD.doubleValue()));
			} else if ("Integer".equals(type)) {
				return new Integer((int) Math.round(bigD.doubleValue()));
			} else {
				throw new RuntimeException("Conversion from " + fromType + " to " + type + " not currently supported");
			}
		} else if (obj instanceof Double) {
			fromType = "Double";
			Double dbl = (Double) obj;
			if ("String".equals(type) || "java.lang.String".equals(type)) {
				if (StringUtils.isEmpty(format))
					format = "###.#########";
				return NumberUtilsExt.decimalFormat(dbl, format);
			} else if ("Double".equals(type) || "java.lang.Double".equals(type)) {
				if (StringUtils.isEmpty(format))
					return obj;
				java.lang.Double v = (java.lang.Double) obj;
				DecimalFormat df = new DecimalFormat(format);
				String vStr = df.format(v);
				try {
					return df.parse(vStr);
				} catch (ParseException e) {
					throw new RuntimeException("Conversion from " + fromType + " to " + type + " not currently supported");
				}
			} else if ("Float".equals(type) || "java.lang.Float".equals(type)) {
				return new Float(dbl.floatValue());
			} else if ("Long".equals(type) || "java.lang.Long".equals(type)) {
				return new Long(Math.round(dbl.doubleValue()));
			} else if ("Integer".equals(type) || "java.lang.Integer".equals(type)) {
				return new Integer((int) Math.round(dbl.doubleValue()));
			} else if ("BigDecimal".equals(type) || "java.math.BigDecimal".equals(type)) {
				return new BigDecimal(dbl.toString());
			} else {
				throw new RuntimeException("Conversion from " + fromType + " to " + type + " not currently supported");
			}
		} else if (obj instanceof Float) {
			fromType = "Float";
			Float flt = (Float) obj;
			if ("String".equals(type)) {
				if (StringUtils.isEmpty(format))
					format = "###.#########";
				return NumberUtilsExt.decimalFormat(flt, format);
			} else if ("BigDecimal".equals(type) || "java.math.BigDecimal".equals(type)) {
				return new BigDecimal(flt.doubleValue());
			} else if ("Double".equals(type)) {
				return new Double(flt.doubleValue());
			} else if ("Float".equals(type)) {
				return obj;
			} else if ("Long".equals(type)) {
				return new Long(Math.round(flt.doubleValue()));
			} else if ("Integer".equals(type)) {
				return new Integer((int) Math.round(flt.doubleValue()));
			} else {
				throw new RuntimeException("Conversion from " + fromType + " to " + type + " not currently supported");
			}
		} else if (obj instanceof Long) {
			fromType = "Long";
			Long lng = (Long) obj;
			if ("String".equals(type) || "java.lang.String".equals(type)) {
				if (StringUtils.isEmpty(format))
					format = "###";
				return NumberUtilsExt.decimalFormat(lng, format);
			} else if ("Double".equals(type) || "java.lang.Double".equals(type))
				return new Double(lng.doubleValue());
			else if ("Float".equals(type) || "java.lang.Float".equals(type))
				return new Float(lng.floatValue());
			else if ("BigDecimal".equals(type) || "java.math.BigDecimal".equals(type))
				return new BigDecimal(lng.toString());
			else if ("Long".equals(type) || "java.lang.Long".equals(type))
				return obj;
			else if ("Integer".equals(type) || "java.lang.Integer".equals(type))
				return new Integer(lng.intValue());
			else
				throw new RuntimeException("Conversion from " + fromType + " to " + type + " not currently supported");
		} else if (obj instanceof Integer) {
			fromType = "Integer";
			Integer intgr = (Integer) obj;
			if ("String".equals(type) || "java.lang.String".equals(type)) {
				if (StringUtils.isEmpty(format))
					format = "###";
				return NumberUtilsExt.decimalFormat(intgr, format);
			} else if ("Double".equals(type) || "java.lang.Double".equals(type)) {
				return new Double(intgr.doubleValue());
			} else if ("Float".equals(type) || "java.lang.Float".equals(type)) {
				return new Float(intgr.floatValue());
			} else if ("BigDecimal".equals(type) || "java.math.BigDecimal".equals(type)) {
				String str = intgr.toString();
				BigDecimal retBig = new BigDecimal(intgr.doubleValue());
				int iscale = str.indexOf(".");
				int keylen = str.length();
				if (iscale > -1) {
					iscale = keylen - (iscale + 1);
					return retBig.setScale(iscale, 5);
				} else {
					return retBig.setScale(0, 5);
				}
			} else if ("Long".equals(type) || "java.lang.Long".equals(type)) {
				return new Long(intgr.longValue());
			} else if ("Integer".equals(type) || "java.lang.Integer".equals(type)) {
				return obj;
			} else {
				throw new RuntimeException("Conversion from " + fromType + " to " + type + " not currently supported");
			}
		} else if (obj instanceof java.sql.Date) {
			fromType = "java.sql.Date";
			java.sql.Date dte = (java.sql.Date) obj;
			if ("String".equals(type) || "java.lang.String".equals(type)) {
				if (format == null || format.length() == 0) {
					return dte.toString();
				} else {
					SimpleDateFormat sdf = new SimpleDateFormat(format);
					return sdf.format(new java.util.Date(dte.getTime()));
				}
			} else if ("java.sql.Date".equals(type)) {
				return obj;
			} else if ("Time".equals(type) || "java.sql.Time".equals(type)) {
				throw new RuntimeException("Conversion from " + fromType + " to " + type + " not currently supported");
			} else if ("Timestamp".equals(type) || "java.sql.Timestamp".equals(type)) {
				return new Timestamp(dte.getTime());
			} else {
				throw new RuntimeException("Conversion from " + fromType + " to " + type + " not currently supported");
			}
		} else if (obj instanceof java.util.Date) {
			fromType = "java.util.Date";
			java.util.Date tme = (java.util.Date) obj;
			if ("String".equals(type) || "java.lang.String".equals(type)) {
				if (format == null || format.length() == 0) {
					return (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")).format(tme).toString();
				} else {
					SimpleDateFormat sdf = new SimpleDateFormat(format);
					return sdf.format(new java.util.Date(tme.getTime()));
				}
			} else if ("java.util.Date".equals(type)) {
				if (StringUtils.isEmpty(format))
					return obj;
				java.util.Date v = (java.util.Date) obj;
				SimpleDateFormat df = new SimpleDateFormat(format);
				String vStr = df.format(v);
				try {
					return df.parse(vStr);
				} catch (ParseException e) {
					throw new RuntimeException("Conversion from " + fromType + " to " + type + " not currently supported");
				}
			} else if ("java.sql.Date".equals(type)) {
				return new java.sql.Date(tme.getTime());
			} else if ("Time".equals(type) || "java.sql.Time".equals(type)) {
				return new Time(tme.getTime());
			} else if ("Timestamp".equals(type) || "java.sql.Timestamp".equals(type)) {
				return obj;
			} else {
				throw new RuntimeException("Conversion from " + fromType + " to " + type + " not currently supported");
			}
		} else if (obj instanceof Timestamp) {
			fromType = "Timestamp";
			Timestamp tme = (Timestamp) obj;
			if ("String".equals(type) || "java.lang.String".equals(type)) {
				if (format == null || format.length() == 0) {
					return (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")).format(tme).toString();
				} else {
					SimpleDateFormat sdf = new SimpleDateFormat(format);
					return sdf.format(new java.util.Date(tme.getTime()));
				}
			} else if ("java.sql.Date".equals(type)) {
				return new java.sql.Date(tme.getTime());
			} else if ("Time".equals(type) || "java.sql.Time".equals(type)) {
				return new Time(tme.getTime());
			} else if ("Timestamp".equals(type) || "java.sql.Timestamp".equals(type)) {
				return obj;
			} else {
				throw new RuntimeException("Conversion from " + fromType + " to " + type + " not currently supported");
			}
		} else if (obj instanceof Boolean) {
			fromType = "Boolean";
			Boolean bol = (Boolean) obj;
			if ("Boolean".equals(type) || "java.lang.Boolean".equals(type)) {
				return bol;
			} else if ("String".equals(type) || "java.lang.String".equals(type)) {
				return bol.toString();
			} else if ("Integer".equals(type) || "java.lang.Integer".equals(type)) {
				if (bol.booleanValue())
					return new Integer(1);
				else
					return new Integer(0);
			} else {
				throw new RuntimeException("Conversion from " + fromType + " to " + type + " not currently supported");
			}
		}
		if ("String".equals(type) || "java.lang.String".equals(type))
			return obj.toString();
		else
			throw new RuntimeException("Conversion from " + obj.getClass().getName() + " to " + type + " not currently supported");
	}

	private static NumberFormat getNf(Locale locale) {
		NumberFormat nf = null;
		if (locale == null)
			nf = NumberFormat.getNumberInstance();
		else
			nf = NumberFormat.getNumberInstance(locale);
		nf.setGroupingUsed(false);
		return nf;
	}

	public static Boolean convert2Boolean(Object obj) {
		return (Boolean) convert(obj, "Boolean", null);
	}

	public static Integer convert2Integer(Object obj) {
		return (Integer) convert(obj, "Integer", null);
	}

	public static Integer convert2Integer(Object obj, Integer defaultValue) {
		Object value = convert(obj, "Integer", null);
		if (value != null)
			return (Integer) value;
		else
			return defaultValue;
	}

	public static String convert2String(Object obj) {
		return (String) convert(obj, "String", null);
	}

	public static String convert2String(Object obj, String defaultValue) {
		Object value = convert(obj, "String", null);
		if (value != null)
			return (String) value;
		else
			return defaultValue;
	}

	public static Long convert2Long(Object obj) {
		return (Long) convert(obj, "Long", null);
	}

	public static Long convert2Long(Object obj, Long defaultValue) {
		Object value = convert(obj, "Long", null);
		if (value != null)
			return (Long) value;
		else
			return defaultValue;
	}

	public static Double convert2Double(Object obj) {
		return (Double) convert(obj, "Double", null);
	}

	public static Double convert2Double(Object obj, String format) {
		return (Double) convert(obj, "Double", format);
	}

	public static Double convert2Double(Object obj, Double defaultValue) {
		Object value = (Double) convert(obj, "Double", null);
		if (value != null)
			return (Double) value;
		else
			return defaultValue;
	}

	public static BigDecimal convert2BigDecimal(Object obj, int scale) {
		return ((BigDecimal) convert(obj, "BigDecimal", null)).setScale(scale, 5);
	}

	public static BigDecimal convert2BigDecimal(Object obj) {
		return ((BigDecimal) convert(obj, "BigDecimal", null));
	}

	public static BigDecimal convert2BigDecimal(Object obj, BigDecimal defaultValue) {
		Object value = (BigDecimal) convert(obj, "BigDecimal", null);
		if (value != null)
			return (BigDecimal) value;
		else
			return defaultValue;
	}

	public static java.sql.Date convert2SqlDate(Object obj, String format) {
		return (java.sql.Date) convert(obj, "java.sql.Date", format);
	}

	public static java.sql.Date convert2SqlDate(Object obj, String format, java.sql.Date defaultValue) {
		java.sql.Date d = (java.sql.Date) convert(obj, "java.sql.Date", format);
		if (d == null)
			return defaultValue;
		else
			return d;
	}

	public static java.util.Date convert2UtilDate(Object obj, String format) {
		return (java.util.Date) convert(obj, "java.util.Date", format);
	}

	public static java.util.Date convert2UtilDate(Object obj, String format, java.util.Date defaultValue) {
		java.util.Date d = (java.util.Date) convert(obj, "java.util.Date", format);
		if (d == null)
			return defaultValue;
		else
			return d;
	}

	public static Timestamp convert2Timestamp(Object obj, String format) {
		return (Timestamp) convert(obj, "java.sql.Timestamp", format);
	}

	public static Timestamp convert2Timestamp(Object obj, String format, Timestamp defaultValue) {
		Timestamp t = (Timestamp) convert(obj, "java.sql.Timestamp", format);
		if (t == null)
			return defaultValue;
		else
			return t;
	}
}
