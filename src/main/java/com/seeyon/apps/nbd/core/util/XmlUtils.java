package com.seeyon.apps.nbd.core.util;

import com.seeyon.ctp.common.init.Xcyskm;
import net.sf.json.xml.XMLSerializer;
import org.apache.commons.io.IOUtils;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.input.SAXBuilder;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.XML;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2018/8/21.
 */
public class XmlUtils {

    public static String xml2jsonString(String file) throws JSONException, IOException {
        InputStream in = new FileInputStream(file);
        String xml = IOUtils.toString(in);
        JSONObject xmlJSONObj = XML.toJSONObject(xml);
        return xmlJSONObj.toString();
    }

    public static String xml2jsonString(InputStream ins) throws JSONException, IOException {

        String xml = IOUtils.toString(ins);
        JSONObject xmlJSONObj = XML.toJSONObject(xml);
        // JSONObject xmlJSONObj = JSON.parseObject(xml);
      //  ProductInfo info;
        return xmlJSONObj.toString();
    }

    public static String xml2jsonString(File f) throws JSONException, IOException {
        FileInputStream ins = new FileInputStream(f);
        String xml = IOUtils.toString(ins);
        System.out.println(f.getPath());
        Xcyskm skd;
        try {
            JSONObject xmlJSONObj = XML.toJSONObject(xml);
            return xmlJSONObj.toString();
        }catch(Exception e){
            String jsonPath = f.getPath().split("mapping.xml")[0]+"json";
            String jsonString = IOUtils.toString(new FileInputStream(jsonPath));
            System.out.println(jsonString);
            return jsonString;
        }
    }

}

