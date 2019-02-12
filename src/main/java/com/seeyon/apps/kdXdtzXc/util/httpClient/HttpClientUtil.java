package com.seeyon.apps.kdXdtzXc.util.httpClient;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;


public class HttpClientUtil {


    /**
     * 功能: 一个文本内容POST提交
     *
     * @param url
     * @param content
     * @return
     * @author zongyubing
     * @time: 2017-1-4 下午07:18:56
     */
    public static String post(String url, String contentCharset, String content) {
        HttpInvokerClient httpInvokerClient = new HttpInvokerClient();
        return httpInvokerClient.post(url, content, contentCharset, null);
    }


    public static String post(String url, String content) {
        HttpInvokerClient httpInvokerClient = new HttpInvokerClient();
        return httpInvokerClient.post(url, content, "utf-8", null);
    }

    /**
     * 功能: 一个文本内容POST提交
     *
     * @param url
     * @param content
     * @return
     * @author zongyubing
     * @time: 2017-1-4 下午07:18:56
     */
    public static String post(String url, String content, String contentCharset, String contentType) {
        HttpInvokerClient httpInvokerClient = new HttpInvokerClient();
        return httpInvokerClient.post(url, content, contentCharset, contentType);
    }

    /**
     * 功能: POST提交(普通属性值)
     *
     * @param url
     * @param fieldNameValueMap
     * @return
     * @author zongyubing
     * @time: 2017-1-4 上午11:57:41
     */
    public static String post(String url, Map<String, Object> fieldNameValueMap) {
        HttpInvokerClient httpInvokerClient = new HttpInvokerClient();
        return httpInvokerClient.post(url, fieldNameValueMap, false);
    }

    /**
     * 功能: POST提交(普通属性值、带文件属性值)
     *
     * @param url
     * @param fieldNameValueMap
     * @return
     * @author zongyubing
     * @time: 2017-1-4 上午11:57:41
     */
    public static String post(String url, Map<String, Object> fieldNameValueMap, boolean isMultipart) {
        HttpInvokerClient httpInvokerClient = new HttpInvokerClient();
        return httpInvokerClient.post(url, fieldNameValueMap, isMultipart);
    }

    /**
     * 功能: 普通属性GET提交
     *
     * @param url
     * @param fieldNameValueMap
     * @return
     * @author zongyubing
     * @time: 2017-1-4 下午01:25:06
     */
    public static String get(String url, Map<String, Object> fieldNameValueMap) {
        HttpInvokerClient httpInvokerClient = new HttpInvokerClient();
        return httpInvokerClient.get(url, fieldNameValueMap);
    }


    /**
     * 功能: 普通属性DELETE提交
     *
     * @param url
     * @param fieldNameValueMap
     * @return
     * @author zongyubing
     * @time: 2017-1-4 下午01:25:06
     */
    public static String delete(String url, Map<String, Object> fieldNameValueMap) {
        HttpInvokerClient httpInvokerClient = new HttpInvokerClient();
        return httpInvokerClient.delete(url, fieldNameValueMap);
    }


    public static String sendData(String url, String data) {
        OutputStreamWriter osw = null;
        String senddata = data;
        String backdata = null;
        String oaurl = null;
        try

        {
            oaurl = url;
            URL httpurl = new URL(oaurl);
            HttpURLConnection con = (HttpURLConnection) httpurl.openConnection();

            con.setDoInput(true);
            con.setDoOutput(true);
            con.setRequestMethod("POST");
            con.setUseCaches(false);

            osw = new OutputStreamWriter(con.getOutputStream(), "UTF-8");
            // 判空
            osw.write(senddata);
            osw.flush();
            String str = read(con.getInputStream());
             //		String[] strs = str.split(":");
            backdata = str;

        } catch (Exception e) {

            e.printStackTrace();
        } finally

        {
            if (osw != null) {
                try {
                    osw.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return backdata;
    }

    public static String getJsonByInternet(String path){
        try {
            URL url = new URL(path.trim());
            //打开连接
            HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();

            if(200 == urlConnection.getResponseCode()){
                //得到输入流
                InputStream is =urlConnection.getInputStream();
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                byte[] buffer = new byte[1024];
                int len = 0;
                while(-1 != (len = is.read(buffer))){
                    baos.write(buffer,0,len);
                    baos.flush();
                }
                return baos.toString("utf-8");
            }
        }  catch (IOException e) {
            e.printStackTrace();
        }

        return null;
    }


    public static String read(InputStream inputStream) {
        StringBuilder stringBuilder = new StringBuilder();
        BufferedReader bufferedReader = null;
        try {
            bufferedReader = new BufferedReader(new InputStreamReader(inputStream, "utf8"));
            String line = null;
            while ((line = bufferedReader.readLine()) != null) {
                stringBuilder.append(System.getProperty("line.separator"));
                stringBuilder.append(line);
            }
        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            try {
                if (inputStream != null) {
                    inputStream.close();
                }
            } catch (IOException e1) {
                e1.printStackTrace();
            }
            try {
                if (bufferedReader != null) {
                    bufferedReader.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return stringBuilder.toString();
    }

}