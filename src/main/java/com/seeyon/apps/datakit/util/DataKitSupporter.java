package com.seeyon.apps.datakit.util;

import com.seeyon.apps.datakit.controller.DataKitAffairController;
import com.seeyon.ctp.util.json.JSONUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
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
    public static String getPostDataAsString(HttpServletRequest request) throws IOException {
        BufferedReader br = request.getReader();
        String str, wholeStr = "";
        while((str = br.readLine()) != null){
            wholeStr += str;
        }
        if(br!=null){
            try {
                br.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return wholeStr;
    }
    public static void main(String[] arhs){
        DataKitAffairController con;
        System.out.println("show me the body");
    }
}
