package com.seeyon.apps.oadev.advsearch;



import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.ctp.form.bean.FormFieldBean;
import com.seeyon.ctp.form.bean.FormFieldComBean.FormFieldComEnum;
import com.seeyon.ctp.form.util.Enums;


public class AdvSearchBean {

	private static Map<String, Map<String, CzSimpleObjectBean>> map = null;
	
	public AdvSearchBean(){
		init();
	}
	public static  void init() {
		
		map = new HashMap();
		// 年度预算
		Map<String, CzSimpleObjectBean> syncLogMap = new HashMap();
		map.put(TableNameEnum.SyncLog.getKey(), syncLogMap);
		
		syncLogMap.put(FieldNameEnum.Subject.getKey(), createFieldBean(FieldNameEnum.Subject, FieldTypeEnum.Subject, "m.xmlString"));
		syncLogMap.put(FieldNameEnum.ActionTypeEnum.getKey(), createFieldBean(FieldNameEnum.ActionTypeEnum, FieldTypeEnum.ActionTypeEnum, "m.actionTypeEnum"));
		syncLogMap.put(FieldNameEnum.SyncStatusEnum.getKey(), createFieldBean(FieldNameEnum.SyncStatusEnum, FieldTypeEnum.SyncStatusEnum, "m.syncStatusEnum"));
		syncLogMap.put(FieldNameEnum.ObjectTypeEnum.getKey(), createFieldBean(FieldNameEnum.ObjectTypeEnum, FieldTypeEnum.ObjectTypeEnum, "m.objectTypeEnum"));
		}
	
	private static CzSimpleObjectBean createFieldBean(FieldNameEnum fieldNameEnum, FieldTypeEnum fieldTypeEnum, String fieldDBName){
		CzSimpleObjectBean fieldBean = new CzSimpleObjectBean();
		fieldBean.setFieldDBName(fieldDBName);
		fieldBean.setDisplay(fieldNameEnum.getText());
		fieldBean.setName(fieldNameEnum.getKey());
		fieldBean.setType(fieldTypeEnum.getKey());
		return fieldBean;

	}
	
	public static Map<String, CzSimpleObjectBean> getFieldMapByTableName(String tableName){
	//	if(map==null||map.size()==0){
			init();
	//	}
		return map.get(tableName);
	}
	
	
	public static List<FormFieldBean> getSearchField(
			List<CzSimpleObjectBean> showFields) {
		List<FormFieldBean> list = new ArrayList();
		FormFieldBean field = null;
		for (CzSimpleObjectBean showField : showFields) {
			FormFieldBean fb = new FormFieldBean();
			fb.setDisplay(showField.getDisplay());
			fb.setFieldTypeEnum(FormFieldComEnum.TEXT);
			fb.setName(showField.getName());
			fb.setInputType(Enums.FieldType.VARCHAR.getKey());
			fb.setFormatType(Enums.FormatType.FORMAT4OUTWRITEOPTION.getName());
			list.add(fb);
		}
		return list;
	}
	// 高级查询的定义部分
	
	public static LinkedHashMap<String, CzSimpleObjectBean> getMoveLogSearchMap(){
		LinkedHashMap<String, CzSimpleObjectBean> retval = null;
		init();
		retval =  new LinkedHashMap();
		String tableName = TableNameEnum.SyncLog.getKey();

		retval.put(FieldNameEnum.Subject.getKey(), map.get(tableName).get(FieldNameEnum.Subject.getKey()));
		retval.put(FieldNameEnum.ActionTypeEnum.getKey(), map.get(tableName).get(FieldNameEnum.ActionTypeEnum.getKey()));
		retval.put(FieldNameEnum.ObjectTypeEnum.getKey(), map.get(tableName).get(FieldNameEnum.ObjectTypeEnum.getKey()));
		retval.put(FieldNameEnum.SyncStatusEnum.getKey(), map.get(tableName).get(FieldNameEnum.SyncStatusEnum.getKey()));
		return retval;

	}
	
	public static LinkedHashMap<String, CzSimpleObjectBean> getMoveLogCommonSearchMap(){
		LinkedHashMap<String, CzSimpleObjectBean> retval = null;
		init();
		retval =  new LinkedHashMap();
		String tableName = TableNameEnum.SyncLog.getKey();

		retval.put(FieldNameEnum.Subject.getKey(), map.get(tableName).get(FieldNameEnum.Subject.getKey()));
		retval.put(FieldNameEnum.ActionTypeEnum.getKey(), map.get(tableName).get(FieldNameEnum.ActionTypeEnum.getKey()));
		retval.put(FieldNameEnum.ObjectTypeEnum.getKey(), map.get(tableName).get(FieldNameEnum.ObjectTypeEnum.getKey()));
		retval.put(FieldNameEnum.SyncStatusEnum.getKey(), map.get(tableName).get(FieldNameEnum.SyncStatusEnum.getKey()));
		return retval;

	}
	

	public static LinkedHashMap<String, CzSimpleObjectBean> getEmptySearchMap(){
		LinkedHashMap<String, CzSimpleObjectBean> retval = null;
		return retval;

	}	

	
	public static LinkedHashMap<String, CzSimpleObjectBean> getEmptyCommonSearchMap(){
		LinkedHashMap<String, CzSimpleObjectBean> retval = null;
		return retval;

	}
	

}


