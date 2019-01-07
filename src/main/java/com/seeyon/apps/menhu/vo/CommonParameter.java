package com.seeyon.apps.menhu.vo;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.menhu.util.CommonUtils;
import org.apache.http.entity.ContentType;

import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.net.URLDecoder;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by liuwenping on 2019/1/7.
 */
public class CommonParameter extends HashMap {


    public static CommonParameter parseParameter(HttpServletRequest request) {
        // boolean isMultipart = ServletFileUpload.isMultipartContent(request);
        CommonParameter parameter = new CommonParameter();

//        List<Attachment> list = null;
//        if (isMultipart) {
//
//        }
        try {
            Enumeration<String> ps = request.getParameterNames();
            while (ps.hasMoreElements()) {
                String psCode = ps.nextElement();
                parameter.put(psCode, URLDecoder.decode(request.getParameter(psCode), "utf-8"));
            }
            if (parameter.isEmpty()) {
                Map<String, String[]> pMap = request.getParameterMap();
                for (Entry<String, String[]> entry : pMap.entrySet()) {

                    String key = entry.getKey();
                    String[] values = entry.getValue();
                    if (values != null) {
                        if (values.length == 1) {
                            parameter.put(key, URLDecoder.decode(values[0], "UTF-8"));
                        } else {
                            parameter.put(key, values);
                        }

                    } else {
                        parameter.put(key, null);
                    }
                }

            }

            ServletInputStream inputStream = request.getInputStream();
            int i = 1;
            byte[] bs = new byte[1024];
            StringBuilder stb = new StringBuilder();
            while ((i = inputStream.read(bs)) != -1) {
                String lens = new String(bs, 0, i);
                lens = new String(lens.getBytes(), "utf-8");
                stb.append(lens);
            }
            // System.out.println(stb.toString());
            String contentType = request.getContentType() + "";
            contentType = contentType.toLowerCase();
            if (contentType.contains(ContentType.APPLICATION_JSON.getMimeType())) {
                if (!CommonUtils.isEmpty(stb.toString())) {
                    try {
                        Map map = JSON.parseObject(stb.toString(), HashMap.class);
                        if (map != null) {
                            parameter.putAll(map);
                        }

                    } catch (Exception e) {
                        System.out.println("error");

                    }

                }

            } else {
                if (!CommonUtils.isEmpty(stb.toString())) {
                    String[] vals = stb.toString().split("&");
                    for (String val : vals) {
                        String[] subVals = val.split("=");
                        if (subVals.length != 2) {
                            parameter.put(subVals[0], "");
                        } else {
                            //\b 去掉
                            parameter.put(subVals[0], URLDecoder.decode(subVals[1], "UTF-8"));
                        }
                    }
                }
            }


        } catch (IOException e) {
            e.printStackTrace();
        }

        return parameter;

    }

    public String $(String key) {
        Object val = this.get(key);
        return val == null ? null : val.toString();
    }

    public CommonParameter $(String key, Object val) {
        this.put(key, val);
        return this;
    }


}
