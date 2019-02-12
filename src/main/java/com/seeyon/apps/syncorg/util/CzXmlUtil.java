package com.seeyon.apps.syncorg.util;

import java.io.StringWriter;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.annotations.XStreamOmitField;
import com.thoughtworks.xstream.io.xml.CompactWriter;
import com.thoughtworks.xstream.io.xml.DomDriver;

public class CzXmlUtil {

	@XStreamOmitField //隐藏属性
	private static final Log log = LogFactory.getLog(CzXmlUtil.class);
	@XStreamOmitField //隐藏属性
	private static final String xmlHead = "<?xml version=\"1.0\" encoding=\"utf-8\"?>";
    public static <T> T toBean(String xmlStr, Class<T> cls) {
        XStream xstream = new XStream(new DomDriver());
        xstream.processAnnotations(cls);
        @SuppressWarnings("unchecked")
        T t = (T) xstream.fromXML(xmlStr);
        return t;
    }
    
    public static String toXml(Object obj){
            XStream xstream = new XStream(new DomDriver("utf8"));
            xstream.processAnnotations(obj.getClass()); // 识别obj类中的注解
            
             // 以压缩的方式输出XML
             StringWriter sw = new StringWriter();
             xstream.marshal(obj, new CompactWriter(sw));
            // String  xml = xmlHead+ sw.toString();
             
            // 以格式化的方式输出XML
            String xml = xstream.toXML(obj);
            return xml;
        }
}
