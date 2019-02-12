package com.seeyon.apps.kdXdtzXc.util;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Created by tap-pcng43 on 2017-10-15.
 */
public class WriteUtil {
    public static void write(String str, HttpServletResponse response) throws IOException {
        response.setContentType("text/html;charset=utf-8");
        response.getWriter().write(str);
        response.getWriter().flush();
        response.getWriter().close();
    }



}
