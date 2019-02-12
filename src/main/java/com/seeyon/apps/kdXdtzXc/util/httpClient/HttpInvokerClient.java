package com.seeyon.apps.kdXdtzXc.util.httpClient;

import java.io.*;
import java.net.URI;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.http.HttpEntity;
import org.apache.http.HttpHost;
import org.apache.http.NameValuePair;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpDelete;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpRequestBase;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

import com.seeyon.apps.kdXdtzXc.util.TypeCaseHelper;

public class HttpInvokerClient {

    public CloseableHttpClient client = null;
    public HttpRequestBase httpRequest = null;
    public CloseableHttpResponse httpResponse = null;
    public RequestConfig.Builder requestConfigBuilder = null;

    public HttpInvokerClient() {
        this.client = HttpClients.createDefault();
        this.requestConfigBuilder = RequestConfig.custom();
    }

    /**
     * 功能: 设置代理
     *
     * @param proxyHost
     * @param proxyPort
     * @author zongyubing
     * @time: 2017-1-5 上午10:29:39
     */
    public void setProxy(String proxyHost, String proxyPort) {
        if (!StringUtils.isEmpty(proxyHost) && !StringUtils.isEmpty(proxyHost)) {
            HttpHost proxy = new HttpHost(proxyHost, Integer.valueOf(proxyPort));
            this.requestConfigBuilder.setProxy(proxy);
        }
    }

    /**
     * 功能: 设置请求和传输超时时间
     *
     * @param httpSoTimeout
     * @param connectionTimeout
     * @author zongyubing
     * @time: 2017-1-5 上午10:29:08
     */
    public void setConnectionTimeout(int httpSoTimeout, int connectionTimeout) {
        this.requestConfigBuilder.setSocketTimeout(httpSoTimeout).setConnectTimeout(connectionTimeout).build();
    }

    public void open(String url, String method) {
        if ("get".equalsIgnoreCase(method)) {
            this.httpRequest = new HttpGet(url);
        } else if ("post".equalsIgnoreCase(method)) {
            this.httpRequest = new HttpPost(url);
        } else if ("delete".equalsIgnoreCase(method)) {
            this.httpRequest = new HttpDelete(url);
        } else
            throw new IllegalArgumentException("Unsupport method : " + method);
        RequestConfig requestConfig = this.requestConfigBuilder.build();
        this.httpRequest.setConfig(requestConfig);
    }

    public void setRequestHeader(String name, String value) {
        this.httpRequest.setHeader(name, value);
    }

    /**
     * 功能: 一个文本内容提交(POST提交)
     *
     * @param url
     * @param content
     * @param contentCharset
     * @param contentType
     * @return
     * @author zongyubing
     * @time: 2017-1-4 下午07:20:32
     */
    public String post(String url, String content, String contentCharset, String contentType) {
        String returnString = null;
        try {
            this.open(url, "post");
            this.addPostContent(content, contentCharset, contentType);
            returnString = this.send();
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            this.close();
        }
        return returnString;
    }

    /**
     * 功能: 普通属性值(GET提交)
     *
     * @param url
     * @param fieldNameValueMap
     * @return
     * @author zongyubing
     * @time: 2017-1-4 上午11:57:41
     */
    public String get(String url, Map<String, Object> fieldNameValueMap) {
        String returnString = null;
        try {
            this.open(url, "get");
            this.addParameter(fieldNameValueMap);
             returnString = this.send();
         } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            this.close();
        }
        return returnString;
    }

    /**
     * 功能: 普通属性值、带文件属性值(POST提交)
     *
     * @param url
     * @param fieldNameValueMap
     * @return
     * @author zongyubing
     * @time: 2017-1-4 上午11:57:41
     */
    public String post(String url, Map<String, Object> fieldNameValueMap, boolean isMultipart) {
        String returnString = null;
        try {
            this.open(url, "post");
            if (!isMultipart)
                this.addParameter(fieldNameValueMap);
            else
                this.addPostMultipartParameter(fieldNameValueMap);
            returnString = this.send();
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            this.close();
        }
        return returnString;
    }

    /**
     * 功能: 普通属性值(DELETE提交)
     *
     * @param url
     * @param fieldNameValueMap
     * @return
     * @author zongyubing
     * @time: 2017-1-4 上午11:57:41
     */
    public String delete(String url, Map<String, Object> fieldNameValueMap) {
        String returnString = null;
        try {
            this.open(url, "delete");
            this.addParameter(fieldNameValueMap);
            returnString = this.send();
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            this.close();
        }
        return returnString;
    }

    /**
     * 功能: 添加带有文件属性(POST)
     *
     * @param fieldNameValueMap
     * @throws Exception
     * @author zongyubing
     * @time: 2017-1-4 下午01:13:33
     */
    public void addPostMultipartParameter(Map<String, Object> fieldNameValueMap) throws Exception {
        if (fieldNameValueMap != null && fieldNameValueMap.size() > 0) {
            MultipartEntityBuilder multipartEntityBuilder = MultipartEntityBuilder.create();
            for (Map.Entry<String, Object> entry : fieldNameValueMap.entrySet()) {
                String fieldName = entry.getKey();
                Object fieldValue = entry.getValue();
                if (fieldValue instanceof File) {
                    File file = (File) fieldValue;
                    multipartEntityBuilder.addBinaryBody(fieldName, file);
                } else {
                    multipartEntityBuilder.addTextBody(fieldName, TypeCaseHelper.convert2String(fieldValue), ContentType.create("text/plain", Charset.forName("utf-8")));
                }
            }
            HttpEntity httpEntity = multipartEntityBuilder.build();
            ((HttpPost) this.httpRequest).setEntity(httpEntity);
        }
    }

    /**
     * 功能: 添加普通的属性(POST、GET)
     *
     * @param fieldNameValueMap
     * @author zongyubing
     * @time: 2017-1-4 下午01:12:25
     */
    public void addParameter(Map<String, Object> fieldNameValueMap) {
        try {
            List<NameValuePair> qparams = new ArrayList<NameValuePair>();
            if (fieldNameValueMap != null && fieldNameValueMap.size() > 0) {
                for (Map.Entry<String, Object> entry : fieldNameValueMap.entrySet()) {
                    String fieldName = entry.getKey();
                    String fieldValue = TypeCaseHelper.convert2String(entry.getValue());
                    qparams.add(new BasicNameValuePair(fieldName, fieldValue));
                }
            }
            if (this.httpRequest instanceof HttpGet) {
                HttpGet httpGet = ((HttpGet) this.httpRequest);
                String str = EntityUtils.toString(new UrlEncodedFormEntity(qparams, "UTF-8"));
                String url = httpGet.getURI().toString();
                url += url.endsWith("?") ? str : "?" + str;
                httpGet.setURI(new URI(url));
            } else if (this.httpRequest instanceof HttpDelete) {
                HttpDelete httpDelete = ((HttpDelete) this.httpRequest);
                String str = EntityUtils.toString(new UrlEncodedFormEntity(qparams, "UTF-8"));
                String url = httpDelete.getURI().toString();
                url += url.endsWith("?") ? str : "?" + str;
                httpDelete.setURI(new URI(url));
            } else if (this.httpRequest instanceof HttpPost) {
                HttpPost httpPost = ((HttpPost) this.httpRequest);
                UrlEncodedFormEntity uefEntity = new UrlEncodedFormEntity(qparams, "UTF-8"); // 参数转码
                httpPost.setEntity(uefEntity);
            }
        } catch (Exception e) {
            throw new RuntimeException("add parameters errror:" + e.getMessage());
        }
    }

    public void addPostContent(String content, String contentCharset, String contentType) throws Exception {
        StringEntity se = new StringEntity(content);
        se.setContentEncoding(contentCharset);
        se.setContentType(contentType);// application/json :发送json文本
        ((HttpPost) this.httpRequest).setEntity(se);
    }

    public String send() throws Exception {

        this.setRequestHeader("Connection", "close");
         this.httpResponse = this.client.execute(this.httpRequest);
        int statusCode = this.httpResponse.getStatusLine().getStatusCode();
        String responseMessage = EntityUtils.toString(httpResponse.getEntity(), "utf-8");
        if (statusCode != 200)
            throw new RuntimeException("调用失败！错误码[" + statusCode + "]" + responseMessage);
        return responseMessage;
    }

    public void close() {
        if (this.client != null)
            try {
                this.client.close();
            } catch (Exception e) {
            }
        if (this.httpResponse != null)
            try {
                this.httpResponse.close();
            } catch (IOException e) {
            }
    }


}