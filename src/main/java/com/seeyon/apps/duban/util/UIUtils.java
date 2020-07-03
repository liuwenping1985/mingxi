package com.seeyon.apps.duban.util;

import com.alibaba.fastjson.JSON;
import com.seeyon.ctp.util.Base64;
import com.seeyon.ctp.util.IOUtility;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.CoreConnectionPNames;
import org.apache.http.util.EntityUtils;
import www.seeyon.com.mocnoyees.RSMocnoyees;
import www.seeyon.com.utils.Base64Util;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by liuwenping on 2018/8/17.
 */
public class UIUtils {
    public static void processCrossOriginResponse(HttpServletResponse response) {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Credentials", "true");
        response.setHeader("Access-Control-Allow-Methods", "GET, HEAD, POST, PUT, DELETE, TRACE, OPTIONS, PATCH");
        response.setHeader("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type,Token,Accept, Connection, User-Agent, Cookie");
        response.setHeader("Access-Control-Max-Age", "3628800");
    }
    public static void responseJSON(Object data, HttpServletResponse response) {
        processCrossOriginResponse(response);
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control",
                "no-store, max-age=0, no-cache, must-revalidate");
        response.addHeader("Cache-Control", "post-check=0, pre-check=0");
        response.setHeader("Pragma", "no-cache");
        PrintWriter out = null;

        try {
            out = response.getWriter();
            out.write(JSON.toJSONString(data));
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (out != null) {
                    out.close();
                }
            } finally {

            }

        }
    }

//    public static SignFileItem fileDownloadByUrl(String wjurl) throws Exception {
//        FileOutputStream out =null;
//        InputStream inputStream = null;
//        try {
//            URL url = new URL(wjurl);
//            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
//            //得到输入流
//            inputStream = conn.getInputStream();
//            byte[] fileData = readInputStream(inputStream);
//            if(fileData==null||fileData.length==0){
//                return null;
//
//            }
//           // FileNameMap fileNameMap = URLConnection.getFileNameMap();
//            //String contentType = fileNameMap.getContentTypeFor("E:\\static\\bg.jpg");
//            String suffix = getFileSuffix(wjurl);
//            String path = UIUtils.class.getResource("").getPath() + "/" + System.currentTimeMillis() + "."+suffix;
//            File file = new File(path);
//            file.createNewFile();
//            out = new FileOutputStream(file);
//            out.write(fileData);
////            if(CommonUtils.isNotEmpty(suffix)){
////                suffix = suffix.toLowerCase();
//////                if("doc".equals(suffix)||"docx".equals(suffix)){
//////                    String outputFile = UIUtils.class.getResource("").getPath() + "/" + System.currentTimeMillis() + ".pdf";
//////                    file =  PdfService.getInstance().word2pdf(path,outputFile);
//////                }
////            }
//            Long size = file.length();
//            SignFileItem sfi = new SignFileItem(file.getName(),size,file);
//
//            return sfi;
//        }catch(Exception e){
//            e.printStackTrace();
//        }finally {
//            try{
//                if(out !=null){
//                    out.flush();
//                    out.close();
//                }
//            }catch (Exception e){
//
//            }
//            try {
//                if (inputStream != null) {
//                    inputStream.close();
//                }
//            }catch(Exception e){
//
//            }
//        }
//        return null;
//    }

    public static byte[] readInputStream(InputStream inputStream) throws IOException {
        byte[] buffer = new byte[1024];
        int len = 0;
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        while ((len = inputStream.read(buffer)) != -1) {
            bos.write(buffer, 0, len);
        }
        bos.close();
        return bos.toByteArray();
    }

    public static Map httpGetInvoke(String url) throws IOException {
        HttpClient httpClient = new DefaultHttpClient();
        // 设置超时时间
        httpClient.getParams().setParameter(CoreConnectionPNames.CONNECTION_TIMEOUT, 2000);
        httpClient.getParams().setParameter(CoreConnectionPNames.SO_TIMEOUT, 2000);
        HttpGet post = new HttpGet(url);
        // 构造消息头
        post.setHeader("Content-type", "application/json;charset=utf-8");
        post.setHeader("Connection", "Close");
        // 构建消息实体


        //StringEntity f_entity = new StringEntity(JSON.toJSONString(param), Charset.forName("UTF-8"));

        //UrlEncodedFormEntity f_entity = new UrlEncodedFormEntity(BrNameValuePair.toNameValuePairList(param), Charset.forName("UTF-8"));
        //f_entity.setContentEncoding("UTF-8");
        // 发送Json格式的数据请求
        //f_entity.setContentType("application/json;charset=utf-8");
        //post.setEntity(f_entity);
        HttpResponse response = null;
        try {
            response = httpClient.execute(post);
        } catch (IOException e) {
            e.printStackTrace();
        }

        // 检验返回码
        int statusCode = response.getStatusLine().getStatusCode();
        //System.out.println("statusCode:"+statusCode);
        if (statusCode == HttpStatus.SC_OK) {
            String str = EntityUtils.toString(response.getEntity(), "UTF-8");
            // System.out.println("content:"+str);
            return JSON.parseObject(str, HashMap.class);

        } else {
            String str = EntityUtils.toString(response.getEntity(), "UTF-8");
            //System.out.println("content:"+str);
            return JSON.parseObject(str, HashMap.class);

        }

    }

    public static Map post(String url, Map param) throws IOException {
        HttpClient httpClient = new DefaultHttpClient();
        // 设置超时时间
        httpClient.getParams().setParameter(CoreConnectionPNames.CONNECTION_TIMEOUT, 2000);
        httpClient.getParams().setParameter(CoreConnectionPNames.SO_TIMEOUT, 2000);
        HttpPost post = new HttpPost(url);
        // 构造消息头
        post.setHeader("Content-type", "application/json;charset=utf-8");
        post.setHeader("Connection", "Close");
        // 构建消息实体


        StringEntity f_entity = new StringEntity(JSON.toJSONString(param), Charset.forName("UTF-8"));

        //UrlEncodedFormEntity f_entity = new UrlEncodedFormEntity(BrNameValuePair.toNameValuePairList(param), Charset.forName("UTF-8"));
        f_entity.setContentEncoding("UTF-8");
        // 发送Json格式的数据请求
        f_entity.setContentType("application/json;charset=utf-8");
        post.setEntity(f_entity);
        HttpResponse response = null;
        try {
            response = httpClient.execute(post);
        } catch (IOException e) {
            e.printStackTrace();
        }

        // 检验返回码
        int statusCode = response.getStatusLine().getStatusCode();
        //System.out.println("statusCode:"+statusCode);
        if (statusCode == HttpStatus.SC_OK) {
            String str = EntityUtils.toString(response.getEntity(), "UTF-8");
            // System.out.println("content:"+str);
            return JSON.parseObject(str, HashMap.class);

        } else {
            String str = EntityUtils.toString(response.getEntity(), "UTF-8");
            //System.out.println("content:"+str);
            return JSON.parseObject(str, HashMap.class);

        }

    }
    public static String getFileSuffix(String url){

        if(CommonUtils.isNotEmpty(url)){
            int index = url.lastIndexOf(".");
            if(index>-1){
                return url.substring(index+1,url.length());
            }
        }

        return null;

    }
    public static void main(String[] args) throws InterruptedException, IOException {
        //Class c1 = MclclzUtil.ioiekc("com.seeyon.ctp.product.ProductInfo");
        //http://hzvendor.dnd8.com/SupplierUploads/702bf492-de68-48c2-80bb-be07ef60986b.pdf
        //  ClassPool pool = ClassPool.getDefault();
//        UIUtils u = new UIUtils();
//        byte[] bytes = u.loadClassData("com.seeyon.ctp.product.ProductInfo");
//
//        //byte[] bytes = u.loadClassData("com.seeyon.ctp.login.LoginHelper");
//        // pool.getClassLoader()
//        //      PortalMenuManagerImpl impl;
//        System.out.println("1");
//        String path = "/Users/liuwenping/Documents/wmm/ProductInfo.class";
//        File f = new File(path);
//        if (f.exists()) {
//            f.delete();
//            f.createNewFile();
//
//        } else {
//            f.createNewFile();
//        }
//        FileOutputStream out = new FileOutputStream(f);
//        out.write(bytes);
//        out.flush();
//        out.close();

//        String url = "http://hzvendor.dnd8.com/SupplierUploads/702bf492-de68-48c2-80bb-be07ef60986b.pdf";
//        try {
//            fileDownloadByUrl(url);
//        } catch (Exception e) {
//            e.printStackTrace();
//        }

    }

    public byte[] loadClassData(String className) throws IOException {
        String res = className.replace('.', '/').concat(".class");
        InputStream is = this.getClass().getClassLoader().getResourceAsStream(res);
        byte[] classData = IOUtility.toByteArray(is);

        try {
            byte[] datas = Base64.decodeBase64(classData);
            classData = RSMocnoyees.decode(RSMocnoyees.getPublicKey("65537", Base64Util.decode("Nzg4NDM2MTAxMzc1NzA0MDQ1Nzc3ODQ3MzM0OTg2NzgxNjEzNDM5Mzg5OTMyODA2ODcwNDQ0Nzk4NDIyODE2MTk0MTEzMzA2NDcyNjkzNTQzMDg4NjUyODc4NDA0NjUwMDEwMDAyNjI0ODQ4NjMxMzA3MjgzMTc4NzE1ODYzMjE1OTYzMDY3NDkwNTYzNDc1NTg0ODM0NzU1NzQ5MDI2NDkyMDk5NTUyMTIzNDAyOTA2NDIyMzgzMTQ1ODUzMjc3OTM4MDQxMDQ5MTU5NzczOTk0ODY3NzA5NzYwMjQzMDcwNTQzMjA3")), datas, 96);
        } catch (Throwable var6) {
            return null;
        }


        return classData;

    }
}