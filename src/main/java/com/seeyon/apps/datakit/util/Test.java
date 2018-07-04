package com.seeyon.apps.datakit.util;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicHeader;
import org.apache.http.protocol.HTTP;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Test {


    public static String post(JSONObject json) throws MalformedURLException {
        System.out.println(json);
        String URL = "http://47.100.181.195:8080/seeyon/datakit/outaffair.do?method=postAffair";
        CloseableHttpClient client = HttpClients.createDefault();
        HttpPost post = new HttpPost(URL);

        post.setHeader("Content-Type", "application/json;charset=utf-8");
       post.addHeader("Authorization", "Basic YWRtaW46");
        String result = "";

        try {

            StringEntity s = new StringEntity(json.toString(), "utf-8");
            s.setContentEncoding(new BasicHeader(HTTP.CONTENT_TYPE,
                    "application/x-www-form-urlencoded;charset=utf-8"));
            post.setEntity(s);

            // 发送请求
            HttpResponse httpResponse = client.execute(post);

            // 获取响应输入流
            InputStream inStream = httpResponse.getEntity().getContent();
            BufferedReader reader = new BufferedReader(new InputStreamReader(
                    inStream, "utf-8"));
            StringBuilder strber = new StringBuilder();
            String line = null;
            while ((line = reader.readLine()) != null)
                strber.append(line + "\n");
            inStream.close();
            result = strber.toString();
            System.out.println(result);
            if (httpResponse.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
                System.out.println("请求服务器成功，做相应处理");
            } else {
                System.out.println("请求服务端失败");
            }
        } catch (Exception e) {
            System.out.println("请求异常");
            throw new RuntimeException(e);
        }

        return result;
    }

    public static void mockPost(){
        // 调用OA接口
        List list = new ArrayList<Map>();
        Map map = new HashMap();
        map.put("senderName", "oa1");
        map.put("receiverName", "liuman");
        map.put("orgName", "中海晟融（北京）资本管理有限公司");
        map.put("subject", "【投资运管】测试标题");
        map.put("linkAddress", "http://www.google.com");
        Map extParam = new HashMap();
        extParam.put("bizId","投管待办的id");
        map.put("extParam",extParam);
        list.add(map);
        JSONObject data = new JSONObject();
        data.put("items", JSON.toJSONString(list));
        try {
            System.out.println(data);
            String post = post(data);

            System.out.println(post);
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args){
        mockPost();
    }
}
