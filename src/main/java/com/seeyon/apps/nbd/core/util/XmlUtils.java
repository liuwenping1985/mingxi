package com.seeyon.apps.nbd.core.util;

import org.apache.commons.io.IOUtils;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.XML;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

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
        return xmlJSONObj.toString();
    }
}
