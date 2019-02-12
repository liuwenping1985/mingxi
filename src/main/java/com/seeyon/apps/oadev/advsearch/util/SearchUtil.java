package com.seeyon.apps.oadev.advsearch.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.oadev.advsearch.AdvSearchBean;
import com.seeyon.apps.oadev.advsearch.CzSimpleObjectBean;
import com.seeyon.apps.oadev.advsearch.FieldTypeEnum;
import com.seeyon.apps.syncorg.enums.*;
import com.seeyon.ctp.form.modules.engin.formula.FormulaEnums;
import com.seeyon.ctp.form.modules.engin.formula.FormulaEnums.ConditionSymbol;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgLevel;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.util.Strings;

public class SearchUtil {
	private static final Log log = LogFactory.getLog(SearchUtil.class);
	public static String FIELDNAME = "fieldName";
	public static String LEFTCHAR = "leftChar";
	public static String OPERATION = "operation";
	public static String RIGHTCHAR = "rightChar";
	public static String FIELDVALUE = "fieldValue";
	public static String ROWOPERATION = "rowOperation";

	private static String isNull2Str(Object o) {
		return o == null ? "" : o.toString();
	}

	public static Object[] getHqlString(String tableName,
			List<Map<String, Object>> condition) {
		Map<String, Object> map = new HashMap();
		Object[] result = { "", map };
		StringBuffer sb = new StringBuffer("");
		if (condition != null) {
			List<Map<String, Object>> newCondition = condition;
			if (newCondition.size() > 0) {
				sb.append("(");
				for (int i = 0; i < newCondition.size(); i++) {
					Map<String, Object> m = (Map) newCondition.get(i);
					if ((Strings.isBlank((String) m.get(FIELDVALUE)))
							|| (Strings.isBlank((String) m.get(FIELDNAME)))) { 
							// 针对无效的条件记录的处理
						sb.append(isNull2Str(m.get(LEFTCHAR)));
						sb.append(" 1 = 1 ");
						sb.append(isNull2Str(m.get(RIGHTCHAR))).append(" ");
						if (i < newCondition.size() - 1) {
							sb.append(m.get(ROWOPERATION).toString()).append(
									" ");
						}
					} else {
						// 针对有效的条件记录
						Object o = isNull2Str(m.get(FIELDVALUE));
						if (o != null && !Strings.isBlank(o.toString())) {
							String fieldName = m.get(FIELDNAME).toString();
							sb.append(isNull2Str(m.get(LEFTCHAR)));
							String op = m.get(OPERATION).toString();

							String value = ":" + fieldName + String.valueOf(i);
							StringBuilder valueStr = new StringBuilder();
							String oStr = String.valueOf(o);
							if (oStr.contains(",")) {
								String[] oStrs = oStr.split(",");
								valueStr.append(" (");
								for (int j = 0; j < oStrs.length; j++) {
									valueStr
											.append(
													getFieldDBName(tableName,
															fieldName)).append(
													" ").append(
													getEnumByShowCondition(op)
															.getKey()).append(
													" ").append(value).append(
													" ");
									if (j != oStrs.length - 1) {
										valueStr.append(" and ");
									}

									map
											.put(fieldName + String.valueOf(i),
													getParamValueByFieldType(
															getParamValue(
																	oStrs[j],
																	op),
															tableName,
															fieldName));
								}
								valueStr.append(" )");
							} else {
								valueStr.append(
										getFieldDBName(tableName, fieldName))
										.append(" ").append(
												getEnumByShowCondition(op)
														.getKey()).append(" ")
										.append(value).append(" ");
								map
										.put(
												fieldName + String.valueOf(i),
												getParamValueByFieldType(
														getParamValue(oStr, op),
														tableName, fieldName));
							}
							sb.append(valueStr);

						}
						sb.append(isNull2Str(m.get(RIGHTCHAR))).append(" ");
						if (i < newCondition.size() - 1) {
							sb.append(m.get(ROWOPERATION).toString()).append(
									" ");
						}
					}

				}
			}
			sb.append(") ");
		}
		result[0] = sb.toString();
		return result;
	}

	public static Object[] getHqlString(String tableName, String key,
			String value) {
		Map<String, Object> map = new HashMap();
		Object[] result = { "", map };
		StringBuffer sb = new StringBuffer("");
		if (Strings.isNotBlank(key) && Strings.isNotBlank(value)) {
			CzSimpleObjectBean csb = AdvSearchBean.getFieldMapByTableName(
					tableName).get(key);
			String fieldName = csb.getName();
			String fieldType = csb.getType();
			String op = getOperationByFieldType(fieldType);
			String valueField = ":" + fieldName;
			StringBuilder valueStr = new StringBuilder();
			String likeString = "";
//			if (fieldName.equals(FieldNameEnum.ItemType.getKey())) {
//				likeString = ".name";
//			}
			valueStr.append(getFieldDBName(tableName, fieldName) + likeString)
					.append(" ").append(getEnumByShowCondition(op).getKey())
					.append(" ").append(valueField).append(" ");
			map.put(fieldName, getParamValueByFieldType(
					getParamValue(value, op), tableName, fieldName));
			sb.append(valueStr);
		}

		result[0] = sb.toString();
		return result;
	}
	/*
	 * 根据字段的类型， 判断表达式中是用  = 还是 like
	 */
	private static String getOperationByFieldType(String fieldType) {
		switch (FieldTypeEnum.getEnumByKey(fieldType)) {
		case SyncStatusEnum:
			return FormulaEnums.ConditionSymbol.equal.getKey();
		case Subject:
			return FormulaEnums.ConditionSymbol.like.getKey();	
		case ObjectTypeEnum:
			return FormulaEnums.ConditionSymbol.equal.getKey();
		case ActionTypeEnum:
			return FormulaEnums.ConditionSymbol.equal.getKey();
		}
		return null;
	}

	private static String getParamValue(String value, String operation) {
		switch (getEnumByShowCondition(operation)) {
		case greatAndEqual:
		case equal:
		case greatThan:
		case include:
		case lessAndEqual:
		case lessThan:
		case notEqual:
			break;
		case like:

		case not_like:
			value = "%" + value + "%";
		}

		return value;
	}

	private static Object getParamValueByFieldType(String value,
			String tableName, String fieldName) {
		CzSimpleObjectBean bean = AdvSearchBean.getFieldMapByTableName(
				tableName).get(fieldName);
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");	
		switch (FieldTypeEnum.getEnumByKey(bean.getType())) {
		case SyncStatusEnum:
			return SyncStatusEnum.valueOf(SyncStatusEnum.class, value);
		case ObjectTypeEnum:
			return ObjectTypeEnum.valueOf(ObjectTypeEnum.class, value);
		case ActionTypeEnum:
			return ActionTypeEnum.valueOf(ActionTypeEnum.class, value);
		case Subject:
			return value;
		}
		return value;
	}

	private static String getFieldDBName(String tableName, String fieldName) {
		CzSimpleObjectBean bean = AdvSearchBean.getFieldMapByTableName(
				tableName).get(fieldName);
		return Strings.isBlank(bean.getFieldDBName()) ? fieldName : bean
				.getFieldDBName();
	}

	private static FormulaEnums.ConditionSymbol getEnumByShowCondition(
			String operation) {
		{
			for (ConditionSymbol e : ConditionSymbol.values()) {
				if (e.getShowCondition().equals(operation)) {
					return e;
				}
			}
			return FormulaEnums.ConditionSymbol.getEnumByText(operation);
		}
	}

	public static void main(String[] args) {
		FormulaEnums.ConditionSymbol s = getEnumByShowCondition("like");
		System.out.println(V3xOrgMember.class.getName());
		System.out.println(V3xOrgDepartment.class.getName());
		System.out.println(V3xOrgAccount.class.getName());
		System.out.println(V3xOrgLevel.class.getName());
	}

}
