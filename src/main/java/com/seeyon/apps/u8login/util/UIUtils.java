package com.seeyon.apps.u8login.util;

import com.seeyon.ctp.util.json.JSONUtil;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Created by liuwenping on 2018/6/15.
 */
public class UIUtils {

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
}
