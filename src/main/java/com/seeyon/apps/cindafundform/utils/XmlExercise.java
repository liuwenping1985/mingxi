package com.seeyon.apps.cindafundform.utils;

import org.jdom.Document;

import net.sf.json.JSON;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import net.sf.json.xml.XMLSerializer;

public class XmlExercise {

	/**
	 * 将xml字符串<STRONG>转换</STRONG>为JSON字符串
	 * 
	 * @param xmlString
	 *            xml字符串
	 * @return JSON<STRONG>对象</STRONG>
	 */
	public static String xml2json(String xmlString) {
		XMLSerializer xmlSerializer = new XMLSerializer();
		JSON json = xmlSerializer.read(xmlString);
		return json.toString(1);
	}

	/**
	 * 将xmlDocument<STRONG>转换</STRONG>为JSON<STRONG>对象</STRONG>
	 * 
	 * @param xmlDocument
	 *            XML Document
	 * @return JSON<STRONG>对象</STRONG>
	 */
	public static String xml2json(Document xmlDocument) {
		return xml2json(xmlDocument.toString());
	}

	/**
	 * JSON(数组)字符串<STRONG>转换</STRONG>成XML字符串
	 * 
	 * @param jsonString
	 * @return
	 */
	public static String json2xml(String jsonString) {
		XMLSerializer xmlSerializer = new XMLSerializer();
		return xmlSerializer.write(JSONSerializer.toJSON(jsonString));
		// return xmlSerializer.write(JSONArray.fromObject(jsonString));//这种方式只支持JSON数组
	}

	public static void main(String[] args) {
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("username", "horizon");
		JSONArray jsonArray = new JSONArray();
		JSONObject dataJson = new JSONObject();
		jsonArray.add(jsonObject);
		// jsonArray.add(jsonObject);
		dataJson.put("data", jsonArray);
		System.out.println(dataJson.toString());

		String xml = json2xml(dataJson.toString());
		System.out.println("xml:" + xml);
		String str = xml2json(xml);
		System.out.println("to_json" + str);
		
		xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><ApprovalStatus><APPLYCODE>dvdvdvd </APPLYCODE><RACSTATE>2</RACSTATE><RACSTATEMESS></RACSTATEMESS></ApprovalStatus>";
		str = xml2json(xml);
		System.out.println("to_json" + str);
		
		com.alibaba.fastjson.JSONObject resultStr = com.alibaba.fastjson.JSONObject.parseObject(str);
		Object a = resultStr.get("RACSTATE");
		System.out.println(a);
		
		JSONObject job =JSONObject.fromObject(str);
		Object b = job.get("RACSTATE");
		System.out.println(b);
	}
}
