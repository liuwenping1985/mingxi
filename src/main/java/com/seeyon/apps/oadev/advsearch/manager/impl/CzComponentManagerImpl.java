package com.seeyon.apps.oadev.advsearch.manager.impl;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.oadev.advsearch.AdvSearchBean;
import com.seeyon.apps.oadev.advsearch.CzSimpleObjectBean;
import com.seeyon.apps.oadev.advsearch.FieldTypeEnum;
import com.seeyon.apps.oadev.advsearch.manager.CzComponentManager;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.AjaxAccess;
import com.seeyon.apps.syncorg.enums.*;

public class CzComponentManagerImpl implements CzComponentManager {

	private static final Log log = LogFactory
			.getLog(CzComponentManagerImpl.class);

	@AjaxAccess
	@Override
	public List<String[]> getFormConditionHTML(String tableBeanName,
			List<String> fieldNames, List<String> operations,
			List<Object> values) {
		if (Strings.isBlank(tableBeanName) || fieldNames == null
				|| fieldNames.size() == 0) {
			List<String[]> conditionHtmlList = new ArrayList();
			conditionHtmlList.add(new String[0]);
			return conditionHtmlList;
		} else {
			String fieldBeanName = fieldNames.get(0);
			CzSimpleObjectBean sb = AdvSearchBean.getFieldMapByTableName(
					tableBeanName).get(fieldBeanName);
			String[] ss = new String[2];
			if (sb != null) {
				switch (FieldTypeEnum.getEnumByKey(sb.getType())) {

				case ObjectTypeEnum:
					ss = HtmlObjectTypeEnum(sb);
					break;
				case Subject:
					ss = HtmlText(sb);
					break;
				case ActionTypeEnum:
					ss = HtmlActionTypeEnum(sb);
					break;
				case SyncStatusEnum:
					ss = HtmlSyncStatusEnum(sb);
					break;

				}

			}

			List<String[]> retval = new ArrayList();
			retval.add(ss);
			return retval;
		}

	}


	private String[] HtmlDate(CzSimpleObjectBean sb) {
		String[] ss = new String[2];
		ss[0] = "<select id='operation' class='operation  w100b'>"
				+ "<option  value='>='>>=</option>"
				+ "<option  value='<='><=</option>" + "</select>";
		ss[1] = "<input type='hidden' id='fieldValue' name='fieldValue' class='fieldValue' inputType='date'>"
				+ "<DIV class='common_txtbox_wrap'><span  id=\""
				+ sb.getName()
				+ "_span\" "
				+ "class=\"edit_class\""
				+ " fieldVal='{name:\""
				+ sb.getName()
				+ "\",isMasterFiled:\"true\","
				+ "displayName:\""
				+ sb.getDisplay()
				+ "\",fieldType:\"TIMESTAMP\",inputType:\"date\",value:\"\"}'>"
				+ "<input readOnly='readOnly' type=\"text\"   id='"
				+ sb.getName()
				+ "' comp='type:\"calendar\","
				+ "cache:false,isOutShow:false,ifFormat:\"%Y-%m-%d\"''' unique='false'"
				+ " inCalculate='false' name='"
				+ sb.getName()
				+ "' value='' validate='name:\""
				+ sb.getDisplay()
				+ "\","
				+ "fieldType:\"TIMESTAMP\",notNull:false,errorMsg:\""
				+ sb.getDisplay()
				+ "为日期类型，格式不正确\","
				+ "errorAlert:true,errorIcon:false,func:validateDataTime' inCondition='false' "
				+ " class=\"validate xdRichTextBox comp\"></span></DIV>";
		return ss;
	}


	private String[] HtmlText(CzSimpleObjectBean sb) {
		String[] ss = new String[2];
		ss[0] = "<select id='operation' class='operation  w100b'>"
				+ "<option  value='='>=</option><option  value='<>'><></option>"
				+ "<option selected value='like'>包含</option>"
				+ "<option  value='not_like'>不包含</option>" + "</select>";
		ss[1] = "<input type='hidden' id='fieldValue' name='fieldValue' "
				+ "class='fieldValue' inputType='text'>"
				+ "<div class='common_txtbox_wrap'>"
				+ "<span  id=\""
				+ sb.getName()
				+ "_span\" class=\"edit_class\" "
				+ "fieldVal='{name:\""
				+ sb.getName()
				+ "\",isMasterFiled:\"true\",displayName:\""
				+ sb.getDisplay()
				+ "\","
				+ "fieldType:\"VARCHAR\",inputType:\"text\",value:\"\"}'>"
				+ "<input  id='"
				+ sb.getName()
				+ "' unique='false' inCalculate='false' name='"
				+ sb.getName()
				+ "' value='' class='xdTextBox validate' type='text' "
				+ "validate='name:\""
				+ sb.getDisplay()
				+ "\",type:\"string\",china3char:true,maxLength:255,notNull:false' "
				+ "inCondition='false'   /></span></div>";
		return ss;
	}

	
	private String[] HtmlActionTypeEnum(CzSimpleObjectBean sb) {	
		return HtmlEnum_name(sb, ActionTypeEnum.values());
	}
	
	private String[] HtmlSyncStatusEnum(CzSimpleObjectBean sb) {	
		return HtmlEnum_name(sb, SyncStatusEnum.values());
	}
	private String[] HtmlObjectTypeEnum(CzSimpleObjectBean sb) {	
		return HtmlEnum_name(sb, ObjectTypeEnum.values());
	}
	
	
	private String [] HtmlEnum_name(CzSimpleObjectBean sb, Object [] objs){
		String[] ss = new String[2];
		ss[0] = "<select id='operation' class='operation  w100b'>"
				+ "<option  value='='>=</option>"
				+ "<option  value='<>'><></option>" + "</select>";
		ss[1] = "<input type='hidden' id='fieldValue' name='fieldValue' class='fieldValue' inputType='select'>"
				+ "<div class='common_selectbox_wrap'>" + "<span  id=\""
				+ sb.getName()
				+ "_span\" class=\"edit_class\" "
				+ "fieldVal='{name:\""
				+ sb.getName()
				+ "\",isMasterFiled:\"true\","
				+ "displayName:\""
				+ sb.getDisplay()
				+ "\",fieldType:\"VARCHAR\",inputType:\"select\",value:\"\"}'><select level=\"0\" "
				+ " id=\""
				+ sb.getName()
				+ "\" name=\""
				+ sb.getName()
				+ "\"  class=\"validate comp enumselect common_drop_down\" "
				+ "comp=\"type:'autocomplete',autoSize:true\"  id=' "
				+ sb.getName()
				+ "' unique='false' "
				+ "inCalculate='false' name='"
				+ sb.getName()
				+ "' "
				+ "validate='name:\""
				+ sb.getDisplay()
				+ "\",type:\"string\",maxLength:255,notNull:false,"
				+ "errorMsg:\""
				+ sb.getDisplay()
				+ "不允许为空\",func:validateSelect' inCondition='false' >"
				+ "<option val4cal=\"0\" value=\"\" ></option>";
		String options = "";
		if (objs.length > 0) {
			Class clazz = objs[0].getClass();

			try {
				Field mKey = clazz.getSuperclass().getDeclaredField("name");
				mKey.setAccessible(true);
				Method mText = clazz.getDeclaredMethod("getText");
				for (Object obj : objs) {
					String key = String.valueOf(mKey.get(obj));
					String text = String.valueOf(mText.invoke(obj));
					
					options = options + "<option val4cal=\"" + key
							+ "\" value=\"" + key + "\" >" + text + "</option>";
				}
			} catch (Exception e) {
				log.error("", e);
			}
		}
		ss[1] = ss[1] + options;
		ss[1] = ss[1] + "</select></span></div>";
		return ss;

	}


}
