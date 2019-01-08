package com.seeyon.apps.datakit.util;

import org.apache.commons.io.IOUtils;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.XML;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

/**
 * Created by liuwenping on 2018/8/21.
 */
public class XmlUtils {

    public static String xml2jsonString(String file) throws JSONException, IOException {
        InputStream in = new FileInputStream(file);
        String xml = IOUtils.toString(in,"utf-8");
        JSONObject xmlJSONObj = XML.toJSONObject(xml);
        return xmlJSONObj.toString();
    }

    public static String xml2jsonString(InputStream ins) throws JSONException, IOException {

        String xml = IOUtils.toString(ins,"utf-8");
        JSONObject xmlJSONObj = XML.toJSONObject(xml);
        // JSONObject xmlJSONObj = JSON.parseObject(xml);
      //  ProductInfo info;
        return xmlJSONObj.toString();
    }

    public static String xml2jsonString(File f) throws JSONException, IOException {
        FileInputStream ins = new FileInputStream(f);
        String xml = IOUtils.toString(ins,"UTF-8");
        System.out.println(f.getPath());
        try {
            JSONObject xmlJSONObj = XML.toJSONObject(xml);
            return xmlJSONObj.toString();
        }catch(Exception e){
            String jsonPath = f.getPath().split("mapping.xml")[0]+"json";
            String jsonString = IOUtils.toString(new FileInputStream(jsonPath),"UTF-8");
            //System.out.println(CommonUtils.unicodeEncoding(jsonString));
            return jsonString;
        }
    }
    public static String xmlString2jsonString(String xml) throws JSONException, IOException {

        try {

            JSONObject xmlJSONObj = XML.toJSONObject(xml);
            return xmlJSONObj.toString();
        }catch(Exception e){

        }
        return null;
    }

}

