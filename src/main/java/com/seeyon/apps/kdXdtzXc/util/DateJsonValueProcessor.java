package com.seeyon.apps.kdXdtzXc.util;

import net.sf.json.JsonConfig;
import net.sf.json.processors.JsonValueProcessor;

import java.text.DateFormat;
import java.text.SimpleDateFormat;

import org.apache.commons.lang.StringUtils;

public class DateJsonValueProcessor implements JsonValueProcessor {
	/**
	 * logger.
	 */
	//protected Logger logger = LoggerFactory.getLogger(getClass());

	/**
	 * 默认的日期转换格式.
	 */
	public static final String DEFAULT_DATE_PATTERN = "yyyy-MM-dd HH:mm:ss";
	/**
	 * 日期转换器.
	 */
	private DateFormat dateFormat;

	/**
	 * 构造方法 * @param datePattern 日期格式
	 */
	public DateJsonValueProcessor(String datePattern) {
		try {
			if (StringUtils.isEmpty(datePattern))
				datePattern = DEFAULT_DATE_PATTERN;
			dateFormat = new SimpleDateFormat(datePattern);
		} catch (Exception ex) {
			dateFormat = new SimpleDateFormat(DEFAULT_DATE_PATTERN);
		}
	}

	/**
	 * 转换数组 *
	 * 
	 * @param value
	 *            Object
	 * @param jsonConfig
	 *            配置
	 * @return Object
	 */
	public Object processArrayValue(Object value, JsonConfig jsonConfig) {
		if (value == null)
			return null;
		String[] obj = {};
		if (value instanceof java.sql.Timestamp[]) {
			java.sql.Timestamp[] timestamps = (java.sql.Timestamp[]) value;
			for (int i = 0; i < timestamps.length; i++) {
				java.sql.Timestamp timestamp = timestamps[i];
				obj[i] = dateFormat.format(new java.util.Date(timestamp.getTime()));
			}
		} else if (value instanceof java.sql.Date[]) {
			java.sql.Date[] dates = (java.sql.Date[]) value;
			for (int i = 0; i < dates.length; i++) {
				java.sql.Date date = dates[i];
				obj[i] = dateFormat.format(new java.util.Date(date.getTime()));
			}
		} else if (value instanceof java.util.Date[]) {
			java.util.Date[] dates = (java.util.Date[]) value;
			obj = new String[dates.length];
			for (int i = 0; i < dates.length; i++) {
				obj[i] = dateFormat.format(dates[i]);
			}
		}
		return obj;
	}

	/**
	 * 转换对象 * @param String
	 * 
	 * @param value
	 *            Object
	 * @param jsonConfig
	 *            配置
	 * @return Object
	 */
	public Object processObjectValue(String key, Object value, JsonConfig jsonConfig) {
		if (value == null)
			return null;
		if (value instanceof java.sql.Timestamp) {
			java.sql.Timestamp timestamp = (java.sql.Timestamp) value;
			String str = dateFormat.format(new java.util.Date(timestamp.getTime()));
			return str;
		} else if (value instanceof java.sql.Date) {
			java.sql.Date date = (java.sql.Date) value;
			String str = dateFormat.format(new java.util.Date(date.getTime()));
			return str;
		} else if (value instanceof java.util.Date) {
			java.util.Date date = (java.util.Date) value;
			String str = dateFormat.format(date);
			return str;
		}
		return value;
	}

}