package com.seeyon.apps.taskcenter.util;

import java.lang.reflect.Field;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import cn.com.hkgt.um.interfaces.OutServiceFactory;
import cn.com.hkgt.um.interfaces.exports.ExportService;

public class TaskCenterUtil {
	private static final Log log = LogFactory.getLog(TaskCenterUtil.class);
	/**
	 *物理拷贝一个实体中数据到另一个实体
	 * @param clazz
	 * @param po
	 * @return
	 */
	public static  Object copyToNewObject(Object newObj,Object oldObj) {

			Class oClass = oldObj.getClass();
			Class nClass = newObj.getClass();

			// 获取新类型的所有属性
			Field [] nFieldList =nClass.getDeclaredFields();

			for (Field newfield : nFieldList) {
				if(newfield.getName().equals("id"))continue;
				newfield.setAccessible(true);
				try {
					Field oField = oClass.getDeclaredField(newfield.getName());
					if(oField !=null){
						oField.setAccessible(true);
						newfield.set(newObj, oField.get(oldObj));
					}
				} catch (Exception e) {
					log.info("",e);
				} 
			}

		return newObj;
	}
	public static void getAuthorityListOfUser(java.lang.String loginName){
		ExportService out  = OutServiceFactory.getExportService();
		out.getAuthorityListOfUser("");
	}
}
