package com.seeyon.apps.datakit.util;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.datakit.controller.DataKitAffairController;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.util.json.JSONUtil;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

public class DataKitSupporter {

    public static void responseJSON(Object data, HttpServletResponse response)
    {
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control",
                "no-store, max-age=0, no-cache, must-revalidate");
        response.addHeader("Cache-Control", "post-check=0, pre-check=0");
        response.setHeader("Pragma", "no-cache");
        PrintWriter out = null;
        try
        {
            out = response.getWriter();
            out.write(JSONUtil.toJSONString(data));
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }finally{
            try {
                if (out != null) {
                    out.close();
                }
            }finally {

            }

        }
    }
    public static void getFormData(HttpServletRequest request){
        Enumeration<String> names = request.getParameterNames();
        while (names.hasMoreElements()) {
            String strings = (String) names.nextElement();
            String[] parameterValues = request.getParameterValues(strings);
            for (int i = 0;parameterValues!=null&&i < parameterValues.length; i++) {
                /**
                 * items[0][senderName]:oa1
                 * items[0][receiverName]:liuman
                 * items[0][orgName]:中海晟融（北京）资本管理有限公司
                 * items[0][subject]:标题111222333
                 * items[0][linkAddress]:http://www.google.com
                 */
                System.out.println(strings+":"+parameterValues[i]+"\t");


            }
        }

    }
    public static String getPostDataAsString(HttpServletRequest request) throws IOException {
        String jsonString = request.getParameter("items");
        if(!org.springframework.util.StringUtils.isEmpty(jsonString)){
            Map data = new HashMap();
            data.put("items",jsonString);
            return JSON.toJSONString(data);
        }
        String str, wholeStr = "";
        try {
            BufferedReader br = request.getReader();

            while ((str = br.readLine()) != null) {
                wholeStr += str;
            }
            if (br != null) {
                try {
                    br.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }finally {

        }

        return wholeStr;
    }
    public static void main(String[] arhs){

        System.out.println("show me the body");

    }
}
