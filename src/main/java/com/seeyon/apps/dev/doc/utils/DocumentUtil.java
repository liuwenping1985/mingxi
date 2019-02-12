package com.seeyon.apps.dev.doc.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.ObjectInputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FileUtils;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;


public class DocumentUtil {
	

	public static Map<String,String> xml2Map(String pathName,String xmlroot) throws Exception{

			String xml = FileUtils.readFileToString(new File(pathName), "utf-8");
			return xmlToMap(xml, xmlroot);
	}
	public static Map<String,String> xmlToMap(String xml,String rootName) throws Exception{
		Map<String,String> map = new HashMap<String, String>();
		xml = changeXml(xml);
		Document document = DocumentHelper.parseText(xml);
		Element root = document.getRootElement();
		Element docInfo = root.element(rootName);
		List<Element> list = docInfo.content();
		for (Element element : list) {
			String name = element.getName();
			String text = (String) element.getData();
			map.put(name, text);
		}
		return map;
		
	}
	private static String changeXml(String xml){

		xml = xml.replaceAll("[\\s&&[^\r\n]]*(?:[\r\n][\\s&&[^\r\n]]*)+", "");
		return xml;
	}
	public static Object tofile () throws Exception{
		FileInputStream fis = null;
		ObjectInputStream ois =null;
		//反序列化 
		   fis = new FileInputStream("d:/c.txt");
		   ois = new ObjectInputStream(fis);

		   Object obj = ois.readObject();
		return obj;

	}
	/**
	 * @param args
	 * @throws Exception 
	 */
	public static void main(String[] args) throws Exception {
		// TODO Auto-generated method stub
		String xml = FileUtils.readFileToString(new File("D:\\testfile\\test111111.xml"), "utf-8");
		Map map = xmlToMap(xml, "root");
	}
}
