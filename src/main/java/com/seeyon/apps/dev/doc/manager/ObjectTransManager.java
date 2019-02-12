package com.seeyon.apps.dev.doc.manager;

import java.lang.reflect.Field;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.tools.ant.util.ReflectUtil;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ctpenumnew.EnumNameEnum;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.i18n.ResourceBundleUtil;
import com.seeyon.ctp.common.po.BasePO;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.Strings;
import com.seeyon.oainterface.exportData.document.DocumentFormExport;
import com.seeyon.v3x.edoc.domain.EdocForm;
import com.seeyon.v3x.edoc.domain.EdocSummary;
import com.seeyon.v3x.edoc.manager.EdocElementManager;
import com.seeyon.v3x.edoc.manager.EdocFormManager;


public class ObjectTransManager {
	private static Log logger = LogFactory.getLog(ObjectTransManager.class);
	private EdocElementManager edocElementManager;
	private EdocFormManager edocFormManager;
	
	public void setEdocFormManager(EdocFormManager edocFormManager) {
		this.edocFormManager = edocFormManager;
	}
	public void setEdocElementManager(EdocElementManager edocElementManager) {
		this.edocElementManager = edocElementManager;
	}
	private static final Map<String ,Map<String,String>> config = new HashMap<String ,Map<String,String>> ();
	
	public void setConfig(Map<String ,Map<String,String>> map){
		config.putAll(map);
	}
	/**
	 * 
	 * @param list-->
	 * @param type -->ElementName OR AttributeName
	 * @param name -->name
	 * @return
	 */
	private DocumentFormExport foundByNameinList(List<DocumentFormExport> list ,String name){
		if("urgent_level".equals(name)){
			name = "urgentLevel";
		}
		if(list!=null && list.size()>0 && Strings.isNotBlank(name)){
			for (DocumentFormExport edocElement : list) {
				if(edocElement.getElementName().equals(name)||name.equals(edocElement.getAttributeName())){//ElementName公文元素的中文名称
					return edocElement;
				}
			}
		}
		return null;
	}
	public <T> T listFormExportTrans2transSummary(Class<T> cls,Object obj ,List<DocumentFormExport> list,EdocSummary summary){
			if(obj==null){
				try {
					obj = cls.newInstance();
				} catch (Exception e) {
					logger.error("",e);
					return null;
				}
			}
			Map<String, String> cfg = config.get(cls.getSimpleName());
			Field[] fields = cls.getDeclaredFields();
			for (Field field : fields) {
				String name = cfg.get(field.getName());
				if(Strings.isBlank(name)){
					logger.warn("没有找到field.Name="+field.getName()+"的配置信息！");
					continue;
				}
				DocumentFormExport element = foundByNameinList(list, name);
				if(element==null){
					logger.warn("通过field.Name="+field.getName()+"没有找到name="+name+"公文元素，请检查配置！");
					continue;
				}
				String val = element.getValue();
				if(Strings.isBlank(val)){
					logger.warn("field.Name="+field.getName()+" name="+name+"的公文元素值为空！");
					continue;
				}
				Object value = null;
				try {
					value = this.getShowValue(summary, element.getAttributeName(), val,field.getType());
				} catch (Exception e) {
					logger.error("field.Name="+field.getName()+" name="+name+"的公文元素值="+val+"转换为"+field.getType()+"类型失败");
				}
				if(field.getType().equals(int.class)||field.getType().equals(Integer.class)){
					value = Integer.parseInt(val);
				}else if (field.getType().equals(Date.class)) {
					value = Datetimes.parse(val);
				}
				if(value==null){
					continue;
				}
				field.setAccessible(true);
				try {
					field.set(obj, value);
				} catch (Exception e) {
					logger.error("field.Name="+field.getName()+"赋值失败",e);
				}
			}
			return (T) obj;
	}
	public <T> T objectTrans2Object(Class<T> cls,Object transObj ,BasePO oaPO){
		try {
			if(transObj==null){
				transObj = cls.newInstance();
			}
			Map<String,String> map = config.get(cls.getSimpleName());
			Field[] fields = cls.getDeclaredFields();
			for (Field field : fields) {
				field.setAccessible(true);
				String pofiledName = map.get(field.getName());
				if(Strings.isNotBlank(pofiledName)){
					Object val = ReflectUtil.getField(oaPO, pofiledName);
					if(val!=null && val!=""){
						if(val.getClass().equals(field.getType())){
							field.set(transObj, val);
						}else{
							if(val instanceof Date){
								field.set(transObj, Datetimes.format((Date)val, "yyyy-MM-dd"));
							}
							if(field.getType().equals(Integer.class)){
								field.set(transObj, Integer.parseInt(String.valueOf(val)));
							}
							if(field.getType().equals(String.class)){
								field.set(transObj, String.valueOf(val));
							}
						}
					}
				}
			}
			return (T) transObj;
		} catch (Exception e) {
			logger.error("数据转换错误"+oaPO.getClass()+" id="+oaPO.getId(),e);
		}
		
		
		return null;
		
	}
	private String getShowValue(EdocSummary summary,String fieldName,String value,Class valType) throws Exception{
		if("urgentLevel".equals(fieldName)){
			fieldName = "urgent_level";
		}
		if("secretLevel".equals(fieldName)){
			fieldName = "secret_level";
		}
//		com.seeyon.apps.archive.api.ArchiveApi api;
//		api.updatePigeonholeArchive(arg0)
//		com.seeyon.apps.archive.manager.IArchiveSync s;
//		s.syncBefore(arg0)
//		DocHierarchyManager m ;m.updatePigeonholeArchive(arg0, arg1)
		EdocForm form =  edocFormManager.getEdocForm(summary.getFormId());
//		EdocForm form = edocFormManager.getEdocForm(summary.getFormId());
//		List<EdocElement> list =edocFormManager.getEdocFormElementByFormIdAndFieldName(summary.getFormId(), fieldName);
//		for (EdocElement edocElement : list) {
//			
//		}
		return value;
		
	}
	private EnumManager enumManager = AppContext.getBeansOfType(EnumManager.class).get(EnumManager.class);
	public String getEnumValue(EdocSummary summary,String fieldName,String value,Class valType) throws Exception{
		List<CtpEnumItem> metaItem = null;
		CtpEnumItem metaDataItem = null;
		 String name="";
             CtpEnumItem newItem = enumManager.getEnumItem(EnumNameEnum.edoc_doc_type, value);
             if (null != newItem) {
               name = ResourceBundleUtil.getString("com.seeyon.v3x.edoc.resources.i18n.EdocResource", newItem.getLabel(), new Object[0]);

            }
           
		return name;
		
	}
	public static void main(String[] args) {

	}
}
