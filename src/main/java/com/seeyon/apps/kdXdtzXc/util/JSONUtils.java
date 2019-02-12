package com.seeyon.apps.kdXdtzXc.util;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;
import net.sf.json.util.PropertyFilter;

import java.util.*;

import org.apache.commons.lang.StringUtils;

import com.seeyon.apps.kdXdtzXc.util.json.DateJsonValueProcessor;
import com.seeyon.apps.kdXdtzXc.util.json.DoubleJsonValueProcessor;

public class JSONUtils {
	public static final String DEFAULT_PATTERN_MAP_STR = "{datePattern:'yyyy-MM-dd HH:mm:ss', isDigitNullWithZore:false}";
	
	
	public static JsonConfig newJsonConfig() {
		JsonConfig cfg = new JsonConfig();
		return cfg;
	}
	
	public static JsonConfig getExcludesConfig(String... excludes) {
		return setExcludes(null, excludes);
	}

	public static JsonConfig setExcludes(JsonConfig cfg, String... excludes) {
		if(cfg == null)
			cfg = newJsonConfig();
		if (excludes != null)
			cfg.setExcludes(excludes);
		return cfg;
	}

	public static String string2json(String key, String value) {
		JSONObject object = new JSONObject();
		object.put(key, value);
		return object.toString();
	}

	public static String object2json(Object object) {
		return object2json(object, null, null);
	}
	
	public static String objects2json(Object... objs) {
		return objects2json(objs, "{isDigitNullWithZore:false}");
	}

	public static String objects2json2(Object... objs) {
		return objects2json2(objs, "{isDigitNullWithZore:false}");
	}
	
	public static String objects2json(JsonConfig cfg, Object... objs) {
		return objects2jsonWithPattern(cfg, null, objs);
	}

	public static String object2jsonWithDefaultPattern(Object object) {
		return object2json(object, null, DEFAULT_PATTERN_MAP_STR);
	}

	public static String object2jsonWidthDate(Object object) {
		return object2json(object, null, "{datePattern:'yyyy-MM-dd'}");
	}

	public static String object2jsonWithTime(Object object) {
		return object2json(object, null, "{datePattern:'yyyy-MM-dd HH:mm:ss'}");
	}

	public static String objects2jsonWithPattern(JsonConfig cfg, String patternMapStr, Object... objs) {
		String jsonString = "{}";
		if (objs == null || objs.length == 0) 
			return jsonString;
		if(cfg == null)
			cfg = newJsonConfig();
		Map<Object, Object> map = new HashMap<Object, Object>();
		for (int i = 0; i < objs.length; i = i + 2) {
			map.put(objs[i], objs[i + 1]);
		}
		return object2json(map, cfg, patternMapStr);
	}
	
	/**
	 * 将Object转换成JSON
	 * 
	 * @param object
	 * @param patternMapStr
	 *            格式化 ，例如{datePattern:'yyyy-MM-DD', doublePattern:'##.00', isDigitNullWithZore:false}
	 * @return
	 */
	public static String object2json(Object object, JsonConfig cfg, String patternMapStr) {
		String jsonString = "{}";
		if (object == null) {
			return jsonString;
		}
		if(cfg == null)
			cfg = newJsonConfig();
		cfg.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT); // 防止自循环
		registerCustomJsonValueProcess(cfg, patternMapStr);
		if (object instanceof ArrayList) {
			JSONArray jsonArray = JSONArray.fromObject(object, cfg);
			jsonString = jsonArray.toString();
		} else {
			JSONObject jsonObject = JSONObject.fromObject(object, cfg);
			jsonString = jsonObject.toString();
		}
		return jsonString;
	}

	/**
	 * @param patternMapStr
	 *            格式化 ，例如{datePattern:'yyyy-MM-DD', doublePattern:'##.00',
	 *            isDigitNullWithZore:false}
	 * @return
	 */
	public static String objects2json(Object[] objs, String patternMapStr) {
		String json = "{}";
		if (objs == null || objs.length == 0) {
			return json;
		}
		Map<Object, Object> map = new HashMap<Object, Object>();
		for (int i = 0; i < objs.length; i = i + 2) {
			map.put(objs[i], objs[i + 1]);
		}
		JsonConfig cfg = configJson(patternMapStr);
		JSONObject jsonObject = JSONObject.fromObject(map, cfg);
		return jsonObject.toString();
	}
	
	/**
	 * 
	 * @param json
	 *            例如:{'name':'aaa', 'sex':'1'}
	 * @param beanClass
	 * @return Map m = json2Object(json, Map.class);
	 */
	public static Object json2Object(String json, Class beanClass) {
		JSONObject jsonObject = JSONObject.fromObject(json);
		return JSONObject.toBean(jsonObject, beanClass);
	}

	/**
	 * @param json
	 *            {'name':'aaa', 'sex':'0', testB:{'name':'bbb', 'address':'fdafda'}}<br/>
	 * @param beanClass
	 * @param classMap
	 * @return
	 * @调用 Map<String, Class> classMap = new HashMap<String, Class>(); <br/>
	 *     classMap.put("testB", TestB.class); <br/>
	 *     TestA testA = json2Object(json, TestA.class, classMap);
	 * 
	 */
	public static Object json2Object(String json, Class beanClass, Map classMap) {
		JSONObject jsonObject = JSONObject.fromObject(json);
		return JSONObject.toBean(jsonObject, beanClass, classMap);
	}

	/**
	 * @param json
	 *            例如:[{name:'a', sex:'0'}, {name:'b', sex:'1'}]<br/>
	 * @param beanClass
	 * @return
	 * @调用 TestA testA = json2List(json, TestA.class);
	 */
	public static List json2List(String json, Class beanClass) {
		JSONArray jsonArray = JSONArray.fromObject(json);
		return JSONArray.toList(jsonArray, beanClass);
	}

	public static List json2List(String json, Class beanClass, Map classMap) {
		JSONArray jsonArray = JSONArray.fromObject(json);
		return JSONArray.toList(jsonArray, beanClass, classMap);
	}
	
	public static Object[] json2Array(String json) {
		JSONArray jsonArray = JSONArray.fromObject(json);
		return jsonArray.toArray();
	}
	
	/**
	 * @param json
	 *            例如:[{name:'Java',price:52.3},{name:'C',price:42.3}] Product[]
	 * @param beanClass
	 * @return <br/>
	 *         products=(Product[]) JSONArray.toArray(array,Product.class);
	 */
	public static Object json2Array(String json, Class beanClass) {
		JSONArray jsonArray = JSONArray.fromObject(json);
		return JSONArray.toArray(jsonArray, beanClass);
	}
	
	public static Object json2Array(String json, Class beanClass, Map classMap) {
		JSONArray jsonArray = JSONArray.fromObject(json);
		return JSONArray.toArray(jsonArray, beanClass, classMap);
	}

	public static Map json2Map(String json) {
		return (Map) json2Object(json, Map.class);
	}

	public static Map json2Map(String json, Map classMap) {
		return (Map) json2Object(json, Map.class, classMap);
	}
	
	
	public static String[] json2StringArray(String json) {
		JSONArray jsonArray = JSONArray.fromObject(json);
		String[] stringArray = new String[jsonArray.size()];
		for (int i = 0; i < jsonArray.size(); i++)
			stringArray[i] = jsonArray.getString(i);
		return stringArray;
	}

	public static Long[] json2LongArray(String json) {
		JSONArray jsonArray = JSONArray.fromObject(json);
		Long[] longArray = new Long[jsonArray.size()];
		for (int i = 0; i < jsonArray.size(); i++)
			longArray[i] = jsonArray.getLong(i);
		return longArray;
	}

	public static Integer[] json2IntegerArray(String json) {
		JSONArray jsonArray = JSONArray.fromObject(json);
		Integer[] integerArray = new Integer[jsonArray.size()];
		for (int i = 0; i < jsonArray.size(); i++)
			integerArray[i] = jsonArray.getInt(i);
		return integerArray;
	}

	public static Double[] json2DoubleArray(String json) {
		JSONArray jsonArray = JSONArray.fromObject(json);
		Double[] doubleArray = new Double[jsonArray.size()];
		for (int i = 0; i < jsonArray.size(); i++)
			doubleArray[i] = jsonArray.getDouble(i);
		return doubleArray;
	}


	/**
	 * JSON 时间解析器具
	 * 
	 * @param patternMapStr
	 *            格式化 ，例如{datePattern:'yyyy-MM-DD', doublePattern:'##.00',
	 *            isDigitNullWithZore:false}
	 * @return
	 */

	public static JsonConfig configJson(String patternMapStr) {
		return configJson(new String[] { "" }, patternMapStr);
	}
	
	/**
	 * 
	 * @param excludes
	 *            排除的字段
	 * @param patternMapStr
	 *            格式化 ，例如{datePattern:'yyyy-MM-DD', doublePattern:'##.00',
	 *            isDigitNullWithZore:false}
	 * @return
	 */
	public static JsonConfig configJson(String[] excludes, String patternMapStr) {
		JsonConfig cfg = newJsonConfig();
		if (excludes != null)
			cfg.setExcludes(excludes);
		cfg.setIgnoreDefaultExcludes(false);
		cfg.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);// 防止自包含
		registerCustomJsonValueProcess(cfg, patternMapStr);
		return cfg;
	}

	/**
	 * 
	 * @param fields
	 * @param isExclude
	 * @param patternMapStr
	 *            格式化 ，例如{datePattern:'yyyy-MM-DD', doublePattern:'##.00',
	 *            isDigitNullWithZore:false}
	 * @return
	 */
	public static JsonConfig configJson(final String[] fields, final Boolean isExclude, String patternMapStr) {
		if (StringUtils.isEmpty(patternMapStr))
			patternMapStr = DEFAULT_PATTERN_MAP_STR;
		
		JsonConfig cfg = new JsonConfig();
		cfg.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT); // 防止自包含
		registerCustomJsonValueProcess(cfg, patternMapStr);

		if (fields != null && fields.length != 0) {
			cfg.setJsonPropertyFilter(new PropertyFilter() {
				public boolean apply(Object source, String name, Object value) {
					List<String> filterFieldsList = Arrays.asList(fields);
					if (isExclude) {
						if (filterFieldsList.contains(name)) {
							return true; // 如果是排除和包含这个属性，则排除
						} else {
							return false;
						}
					} else {
						if (filterFieldsList.contains(name)) {
							return false;
						} else {
							return true;
						}
					}
				}
			});
		}
		return cfg;
	}
	
	public static JsonConfig registerCustomJsonValueProcess(JsonConfig cfg, String patternMapStr) {
		if (StringUtils.isEmpty(patternMapStr))
			patternMapStr = DEFAULT_PATTERN_MAP_STR;
		JSONObject jsonObj = JSONObject.fromObject(patternMapStr);
		String datePattern = (String) jsonObj.get("datePattern");
		String doublePattern = (String) jsonObj.get("doublePattern");
		Boolean isDigitNullWithZore = jsonObj.get("isDigitNullWithZore") == null ? true : (Boolean) jsonObj.get("isDigitNullWithZore");
		if (!isDigitNullWithZore) {
		}
		cfg.registerJsonValueProcessor(java.sql.Timestamp.class, new DateJsonValueProcessor(datePattern));
		cfg.registerJsonValueProcessor(java.util.Date.class, new DateJsonValueProcessor(datePattern));
		cfg.registerJsonValueProcessor(java.sql.Date.class, new DateJsonValueProcessor(datePattern));
		cfg.registerJsonValueProcessor(java.lang.Double.class, new DoubleJsonValueProcessor(doublePattern));
		return cfg;
	}
	

	/**
	 * 直接将List转为分页所需要的Json资料格式
	 * 
	 * @param list
	 *            需要编码的List对象
	 * @param totalCount
	 *            记录总数
	 * @param patternMapStr
	 *            格式化 ，例如{datePattern:'yyyy-MM-DD', doublePattern:'##.00',
	 *            isDigitNullWithZore:false}
	 */
	public static final String encodeList2PageJson(List list, Integer totalCount, String patternMapStr) {
		String subJsonString = "";
		subJsonString = object2json(list, null, patternMapStr);
		String json = "{TOTALCOUNT:" + totalCount + ", ROOT:" + subJsonString + "}";
		return json;
	}
}