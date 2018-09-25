//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.apps.u8login.util;

import com.alibaba.fastjson.JSON;
import com.seeyon.ctp.util.json.JSONUtil;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UIUtils {
    static SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    public UIUtils() {
    }

    public static void responseJSON(Object data, HttpServletResponse response) {
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-store, max-age=0, no-cache, must-revalidate");
        response.addHeader("Cache-Control", "post-check=0, pre-check=0");
        response.setHeader("Pragma", "no-cache");
        PrintWriter out = null;

        try {
            out = response.getWriter();
            out.write(JSONUtil.toJSONString(data));
        } catch (IOException var7) {
            var7.printStackTrace();
        } finally {
            if(out != null) {
                out.close();
            }

        }

    }

    public static String getPostDataAsString(HttpServletRequest request) throws IOException {
        String jsonString = request.getParameter("context");
        if(jsonString != null && jsonString.length() > 0) {
            Map data = new HashMap();
            data.put("context", jsonString);
            return JSON.toJSONString(data);
        } else {
            String wholeStr = "";

            String str;
            BufferedReader br;
            for(br = request.getReader(); (str = br.readLine()) != null; wholeStr = wholeStr + str) {
                ;
            }

            if(br != null) {
                try {
                    br.close();
                } catch (Exception var6) {
                    var6.printStackTrace();
                }
            }

            return wholeStr;
        }
    }

    public static void main(String[] args) {
        String key = "123||345||564";
        System.out.println(format.format(new Date()));
    }
}
