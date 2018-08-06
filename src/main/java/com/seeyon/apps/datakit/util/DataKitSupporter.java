package com.seeyon.apps.datakit.util;

import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.v3x.bulletin.controller.BulDataController;

import javax.servlet.http.HttpServletResponse;
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
    public static void recordLoghin(Long userId,String username){
        com.seeyon.apps.datakit.service.RikazeService.loginRecord(userId,username);
    }
    public static void main(String[] arhs){
        System.out.println("show2 me the body");

        System.out.println();
    }
}
