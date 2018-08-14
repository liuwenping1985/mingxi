package com.seeyon.apps.xinjue.util;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.xinjue.vo.HaiXingParameter;
import com.seeyon.ctp.util.json.JSONUtil;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.CoreConnectionPNames;
import org.apache.http.util.EntityUtils;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;


public class UIUtils {

    private static String url2 = "http://192.168.1.211:8099/hsoaapi.action";
    private static String url3 = "http://180.166.171.138:8087/unwmsrf-server/hsapi.action";
    private static String url = "http://47.104.88.210:8080/unwmsrf-server/hsapi.action";
    public static Map post(HaiXingParameter p) throws IOException {
        HttpClient httpClient = new DefaultHttpClient();
        // 设置超时时间
        httpClient.getParams().setParameter(CoreConnectionPNames.CONNECTION_TIMEOUT, 2000);
        httpClient.getParams().setParameter(CoreConnectionPNames.SO_TIMEOUT, 2000);
        HttpPost post = new HttpPost(url);
        // 构造消息头
        post.setHeader("Content-type", "application/x-www-form-urlencoded;charset=utf-8");
        post.setHeader("Connection", "Close");
        // 构建消息实体

        //StringEntity entity = new StringEntity(JSON.toJSONString(p), Charset.forName("UTF-8"));

        UrlEncodedFormEntity f_entity = new UrlEncodedFormEntity(p.toNameValuePairList(),Charset.forName("UTF-8"));
        f_entity.setContentEncoding("UTF-8");
        // 发送Json格式的数据请求
        f_entity.setContentType("application/x-www-form-urlencoded;charset=utf-8");
        post.setEntity(f_entity);
        HttpResponse response = null;
        try {
            response = httpClient.execute(post);
        } catch (IOException e) {
            e.printStackTrace();
        }

        // 检验返回码
        int statusCode = response.getStatusLine().getStatusCode();
        System.out.println("statusCode:"+statusCode);
        if(statusCode == HttpStatus.SC_OK){
            String str = EntityUtils.toString(response.getEntity());
            System.out.println("content:"+str);
            return  JSON.parseObject(str,HashMap.class);

        }else {
            String str = EntityUtils.toString(response.getEntity());
            System.out.println("content:"+str);
            return  JSON.parseObject(str,HashMap.class);

        }

    }
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
