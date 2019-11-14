package com.seeyon.apps.duban.util;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import org.apache.commons.io.IOUtils;
import org.dom4j.Attribute;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

/**
 * Created by liuwenping on 2018/8/21.
 */
public class XmlUtils {

    public static String xml2jsonString(String file) throws IOException {
        InputStream in = new FileInputStream(file);
        try {

            String xml = IOUtils.toString(in, "utf-8");
            return xmlString2jsonString(xml);
        } catch (IOException e) {
            throw new IOException(e);
        } finally {
            try {
                in.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

    }

    public static String xml2jsonString(InputStream ins) throws IOException {

        String xml = IOUtils.toString(ins, "utf-8");
        return xmlString2jsonString(xml);
        // JSONObject xmlJSONObj = JSON.parseObject(xml);
        //  ProductInfo info;

    }

    public static String xml2jsonString(File f) throws IOException {
        FileInputStream ins = new FileInputStream(f);
        String xml = IOUtils.toString(ins, "UTF-8");
        //System.out.println(f.getPath());
        try {
            String xmlJSONObj = xmlString2jsonString(xml);
            return xmlJSONObj;
        } catch (Exception e) {
            String jsonPath = f.getPath().split("mapping.xml")[0] + "json";
            String jsonString = IOUtils.toString(new FileInputStream(jsonPath), "UTF-8");
            //System.out.println(CommonUtils.unicodeEncoding(jsonString));
            return jsonString;
        } finally {
            try {
                ins.close();
            } catch (Exception e) {

            }
        }
    }

    public static String xmlString2jsonString(String xml) throws IOException {

        try {

            // JSONObject xmlJSONObj = XML.toJSONObject(xml);
            if (!xml.startsWith("<xml>")) {
                xml = "<xml>" + xml + "</xml>";
            }
            Document document = DocumentHelper.parseText(xml);
            JSONObject xmlJSONObj = elementToJSONObject(document.getRootElement());
            return xmlJSONObj.toString();
        } catch (Exception e) {

        }
        return null;
    }

    public static JSONObject elementToJSONObject(Element node) {
        JSONObject result = new JSONObject();
        // 当前节点的名称、文本内容和属性
        List<Attribute> listAttr = node.attributes();// 当前节点的所有属性的list
        for (Attribute attr : listAttr) {// 遍历当前节点的所有属性
            result.put(attr.getName(), attr.getValue());
        }
        // 递归遍历当前节点所有的子节点
        List<Element> listElement = node.elements();// 所有一级子节点的list
        if (!listElement.isEmpty()) {
            for (Element e : listElement) {// 遍历所有一级子节点
                if (e.attributes().isEmpty() && e.elements().isEmpty()) // 判断一级节点是否有属性和子节点
                    result.put(e.getName(), e.getTextTrim());// 沒有则将当前节点作为上级节点的属性对待
                else {
                    if (!result.containsKey(e.getName())) // 判断父节点是否存在该一级节点名称的属性
                        result.put(e.getName(), new JSONArray());// 没有则创建
                    ((JSONArray) result.get(e.getName())).add(elementToJSONObject(e));// 将该一级节点放入该节点名称的属性对应的值中
                }
            }
        }
        return result;
    }


}

