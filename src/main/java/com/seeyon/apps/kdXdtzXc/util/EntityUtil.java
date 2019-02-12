package com.seeyon.apps.kdXdtzXc.util;
import com.seeyon.apps.kdXdtzXc.base.ann.XmlField;
import com.seeyon.apps.kdXdtzXc.base.util.ToolkitUtil;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by tap-pcng43 on 2017-10-1.
 */
public class EntityUtil {
    private static Map<Class, Map<String, String>> class_xmlelement_entityField_map = new HashMap<Class, Map<String, String>>();


    public static String getEntityField(Class clazz, String xmlElement) {
        return getXmlEelAdnJfieldMap(clazz).get(xmlElement);
    }

    private static Map<String, String> getXmlEelAdnJfieldMap(Class clazz) {
        Map<String, String> xmlelement_entityField_map = class_xmlelement_entityField_map.get(clazz);

        if (xmlelement_entityField_map == null) {
            xmlelement_entityField_map = new HashMap<String, String>();
            Field[] fields = clazz.getDeclaredFields();
            for (Field field : fields) {
                String javaField = field.getName();
                XmlField xmlField = field.getAnnotation(XmlField.class);
                if (xmlField != null) {
                    String xmlElement = xmlField.value();
                    if (ToolkitUtil.isNull(xmlElement)) {
                        xmlElement = javaField;
                        if (xmlField.toUpper()) {
                            xmlElement = xmlElement.toUpperCase();
                        }
                        xmlelement_entityField_map.put(xmlElement, javaField);
                    } else {
                        xmlelement_entityField_map.put(xmlElement, javaField);
                    }
                }
            }
            class_xmlelement_entityField_map.put(clazz, xmlelement_entityField_map);

        }
        return xmlelement_entityField_map;
    }

}
