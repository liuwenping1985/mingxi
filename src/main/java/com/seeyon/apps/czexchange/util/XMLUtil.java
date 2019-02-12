package com.seeyon.apps.czexchange.util;

import java.io.StringWriter;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import www.seeyon.com.utils.FileUtil;

import com.seeyon.apps.czexchange.bo.Elecdocument;
import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.annotations.XStreamOmitField;
import com.thoughtworks.xstream.io.xml.CompactWriter;
import com.thoughtworks.xstream.io.xml.DomDriver;
import com.thoughtworks.xstream.io.xml.XmlFriendlyNameCoder;

public class XMLUtil {
	
	@XStreamOmitField //隐藏属性
	private static Log log = LogFactory.getLog(XMLUtil.class);
	@XStreamOmitField //隐藏属性
	private static final String xmlHead = "<?xml version=\"1.0\" encoding=\"GBK\"?>";
	private static XStream xstream =   new XStream(new DomDriver("gbk"));  
	public static String toXml(Object obj){
		
    xstream.processAnnotations(obj.getClass()); // 识别obj类中的注解
    
    // 以压缩的方式输出XML
    StringWriter sw = new StringWriter();
    //new XmlFriendlyNameCoder("_-", "_")去掉多余的下滑线
    xstream.marshal(obj, new CompactWriter(sw,new XmlFriendlyNameCoder("_-", "_")));
    
    String  xml = xmlHead+ sw.toString();
     
    // 以格式化的方式输出XML
//        xml = xml+xstream.toXML(obj);
    log.info("sms对象转xml="+xml);
    return xml;
}

public static <T> T toBean(String xmlStr, Class<T> cls) {
    xstream.processAnnotations(cls);
    @SuppressWarnings("unchecked")
    T t = (T) xstream.fromXML(xmlStr);
    return t;
}

   public static void main(String [] args){
	   String xml = FileUtil.readTextFile("/Users/mac/Downloads/element(tree).xml","gbk");
	   String xml2 = FileUtil.readTextFile("/Users/mac/Downloads/element_err.xml","gbk");
	   Elecdocument bean = toBean(xml, Elecdocument.class);
	   String out = toXml(bean);
	   System.out.println(out);
   }
}
