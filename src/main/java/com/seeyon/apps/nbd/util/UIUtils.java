package com.seeyon.apps.nbd.util;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.config.ConfigService;
import com.seeyon.apps.xinjue.vo.HaiXingParameter;
import com.seeyon.ctp.menu.manager.PortalMenuManagerImpl;
import com.seeyon.ctp.util.Base64;
import com.seeyon.ctp.util.IOUtility;
import com.seeyon.ctp.util.JDBCAgent;
import com.seeyon.ctp.util.json.JSONUtil;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.CoreConnectionPNames;
import org.apache.http.util.EntityUtils;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;
import www.seeyon.com.mocnoyees.RSMocnoyees;
import www.seeyon.com.utils.Base64Util;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.math.BigDecimal;
import java.nio.charset.Charset;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2018/8/17.
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
    public static void responseJSON(Object data,Map param, HttpServletResponse response)
    {

        for(Object key:param.keySet()){
            response.addHeader(String.valueOf(key),String.valueOf(param.get(key)));
        }
        responseJSON(data,response);
    }
    public static Map get(String url) throws IOException {
        HttpClient httpClient = new DefaultHttpClient();
        // 设置超时时间
        httpClient.getParams().setParameter(CoreConnectionPNames.CONNECTION_TIMEOUT, 2000);
        httpClient.getParams().setParameter(CoreConnectionPNames.SO_TIMEOUT, 2000);
        // 构建消息实体
        //UrlEncodedFormEntity f_entity = new UrlEncodedFormEntity(BrNameValuePair.toNameValuePairList(param), Charset.forName("UTF-8"));
        HttpGet httpGet = new HttpGet(url);
        HttpResponse response = null;
        try {
            response = httpClient.execute(httpGet);
        } catch (IOException e) {
            e.printStackTrace();
        }

        // 检验返回码
        int statusCode = response.getStatusLine().getStatusCode();
        System.out.println("statusCode:"+statusCode);
        if(statusCode == HttpStatus.SC_OK){
            String str = EntityUtils.toString(response.getEntity(),"UTF-8");
            // System.out.println("content:"+str);
            return  JSON.parseObject(str,HashMap.class);

        }else {
            String str = EntityUtils.toString(response.getEntity(),"UTF-8");
            System.out.println("content:"+str);
            return  JSON.parseObject(str,HashMap.class);

        }

    }

    public static Map post(String url,Map param) throws IOException {
        HttpClient httpClient = new DefaultHttpClient();
        // 设置超时时间
        httpClient.getParams().setParameter(CoreConnectionPNames.CONNECTION_TIMEOUT, 2000);
        httpClient.getParams().setParameter(CoreConnectionPNames.SO_TIMEOUT, 2000);
        HttpPost post = new HttpPost(url);
        // 构造消息头
        post.setHeader("Content-type", "application/x-www-form-urlencoded;charset=utf-8");
        post.setHeader("Connection", "Close");
        // 构建消息实体


        //StringEntity f_entity = new StringEntity(JSON.toJSONString(param), Charset.forName("UTF-8"));

        UrlEncodedFormEntity f_entity = new UrlEncodedFormEntity(BrNameValuePair.toNameValuePairList(param), Charset.forName("UTF-8"));
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
            String str = EntityUtils.toString(response.getEntity(),"UTF-8");
            // System.out.println("content:"+str);
            return  JSON.parseObject(str,HashMap.class);

        }else {
            String str = EntityUtils.toString(response.getEntity(),"UTF-8");
            System.out.println("content:"+str);
            return  JSON.parseObject(str,HashMap.class);

        }

    }

    public static void main(String[] args) throws InterruptedException, IOException {
       // Class c1 = MclclzUtil.ioiekc("com.seeyon.ctp.login.LoginHelper");

      //  ClassPool pool = ClassPool.getDefault();
//        UIUtils u = new UIUtils();
//        byte[] bytes = u.loadClassData("com.seeyon.ctp.product.ProductInfo");
//      //  pool.getClassLoader()
//        String path = "/Users/liuwenping/Documents/wmm/ProductInfo.class";
//        File f = new File(path);
//        if(f.exists()){
//            f.delete();
//            f.createNewFile();
//
//        }else{
//            f.createNewFile();
//        }
//        FileOutputStream out = new FileOutputStream(f);
//        out.write(bytes);
//        out.flush();
//        out.close();
        System.out.println("test123");

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

    private static SimpleDateFormat year_month_day = new SimpleDateFormat("yyyy-MM-dd");
    private static SimpleDateFormat year_month_day_hour_min_sec = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");

    public static Date parseDateYearMonthDay(String startDate){
        try{
            return year_month_day.parse(startDate);
        }catch(Exception e){
            return null;
        }

    }

    public static Date parseDate(String startDate){
        try{
            return year_month_day_hour_min_sec.parse(startDate);
        }catch(Exception e){
            return null;
        }
    }

    public static String formatDate(Date dt){
        if(dt == null){
            return "";
        }
        return year_month_day_hour_min_sec.format(dt);
    }
    private static Map<String,Long> cacheEnumMap = new HashMap<String, Long>();
    public static String getEnumIdByState(String state){
        String enumId =  ConfigService.getPropertyByName("state_enum_id","");
        //  System.out.println("enumId:"+enumId);
        if(!StringUtils.isEmpty(enumId)){

            Long ret = cacheEnumMap.get(state);
            if(ret!=null){
                return String.valueOf(ret);
            }
            String sql = "select * from ctp_enum_item where ref_enumid="+enumId;
            System.out.println(sql);
            JDBCAgent jdbcAgent = new JDBCAgent();
            try {
                jdbcAgent.execute(sql);
                List<Map> dataList = jdbcAgent.resultSetToList();
                System.out.println(dataList);
                if(!CollectionUtils.isEmpty(dataList)){

                    for(Map data:dataList){
                        Long id = Long.parseLong(String.valueOf(data.get("id")));
                        cacheEnumMap.put(String.valueOf(data.get("showvalue")),id);
                    }
                    //System.out.println(cacheEnumMap);
                    //System.out.println(state);

                    ret = cacheEnumMap.get(state);
                    System.out.println(ret);
                    if(ret!=null){
                        return String.valueOf(ret);
                    }
                }

            }catch(Exception e){
                e.printStackTrace();
            }finally {
                jdbcAgent.close();
            }
        }

        return state;
    }
    public static Long getMemberIdByCode(String code){


        return getIdByCodeAndType(code,"org_member");
    }
    public static Long getDepartmentIdByCode(String code){

        return getIdByCodeAndType(code,"org_unit");
    }

    public static Long getIdByCodeAndType(String code,String tableName){
        JDBCAgent jdbcAgent = new JDBCAgent();
        try {
            String sql ="select * from "+tableName+" where is_enable=1 and is_deleted=0 and code='"+code+"'";
            System.out.println(sql);
            jdbcAgent.execute(sql);

            List<Map> ret = jdbcAgent.resultSetToList();

            if(CollectionUtils.isEmpty(ret)){
                return null;
            }
            Object id =   ret.get(0).get("id");
            if(id instanceof  Long){
                return (Long)id;
            }
            if(id instanceof BigDecimal){
                return ((BigDecimal)id).longValue();
            }
        }catch(Exception e){
            e.printStackTrace();
        }finally {
            jdbcAgent.close();
        }
        return null;

    }
    public static Long getLong(Object obj){

        if(obj instanceof Long){
            return (Long)obj;
        }
        if(obj instanceof BigDecimal){
            return ((BigDecimal)obj).longValue();
        }
        try{

            return Long.parseLong(obj.toString());

        }catch(Exception e){

            return null;
        }





    }
    public static Date getDate(Object obj){

        if(obj instanceof Timestamp){
            return (Timestamp)obj;
        }
        if(obj instanceof Date){
            return ((Date)obj);
        }
        if(obj instanceof String){

            try {
                return year_month_day_hour_min_sec.parse(obj.toString());
            } catch (Exception e) {
                return null;
            }
        }
        if(obj instanceof Long){
            Long sec = (Long)obj;
            if(sec>0){
                return new Date(sec);
            }
        }
        return null;

    }


}
