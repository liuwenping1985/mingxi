package com.seeyon.apps.xinjue.vo;

import com.alibaba.fastjson.JSON;
import com.fasterxml.jackson.annotation.JsonIgnore;

import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class HaiXingParameter {

    private String sign;

    private static String APP_SERCRET  = "b9bbea2e8c48dfade3b60d99cc8f7a";
    private static String token = "702e7ecc6e15b6dae6ea7287af2634bd" ;
    private static String app_key = "58b1e737d0194f87855904f181b1b2ab";
    private String timestamp = DATE_FORMAT.format(new Date());
    private String format = "json";
    private String v = "1.0";
    private String method = "oa";
    private Map<String,String> biz_content = new HashMap<String, String>();

    private static SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    public String getSign() {
        return sign;
    }

    public void setSign(String sign) {
        this.sign = sign;
    }



    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getApp_key() {
        return app_key;
    }

    public void setApp_key(String app_key) {
        this.app_key = app_key;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    public String getFormat() {
        return format;
    }

    public void setFormat(String format) {
        this.format = format;
    }

    public String getV() {
        return v;
    }

    public void setV(String v) {
        this.v = v;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public Map<String, String> getBiz_content() {
        return biz_content;
    }

    public void setBiz_content(Map<String, String> biz_content) {
        this.biz_content = biz_content;
    }
    public static String md5(String str) {
        char hexDigits[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};
        MessageDigest md5 ;
        try {
            md5 = MessageDigest.getInstance("MD5");
            md5.update(str.getBytes("UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
        byte[] encodedValue = md5.digest();
        int j = encodedValue.length;
        char finalValue[] = new char[j * 2];
        int k = 0;
        for (byte encoded : encodedValue) {
            finalValue[k++] = hexDigits[encoded >> 4 & 0xf];
            finalValue[k++] = hexDigits[encoded & 0xf];
        }

        return new String(finalValue);
    }

    public String generateSign(){
        String _sign =APP_SERCRET+ "app_key="+this.getApp_key()+"&biz_content="+ JSON.toJSONString(this.getBiz_content())+"&format=json&method=oa&timestamp="+this.getTimestamp()+"&token="+this.getToken()+"&v=1.0"+APP_SERCRET;
        try {
            String md5String = md5(_sign);
            String sign=  new String(com.seeyon.apps.cloudapp.util.Base64.encode(md5String.getBytes()));
            this.setSign(sign);
            return sign;
        } catch (Exception e) {
            e.printStackTrace();
        }
        throw new RuntimeException("can not sign");
    }


    public static void main(String[] args) throws NoSuchAlgorithmException, UnsupportedEncodingException {

        String md = APP_SERCRET+"app_key="+app_key+"&biz_content={\"funcode\":\"1001\"}&format=json&method=oa&timestamp=2018-04-10 13:23:30&token="+token+"&v=1.0"+APP_SERCRET;
        System.out.println(md);
        String md5 = md5(md);
        String sign=  new String(com.seeyon.apps.cloudapp.util.Base64.encode(md5.getBytes()));
        System.out.println(sign);
//        String md = APP_SERCRET+"app_key="+app_key+"&biz_content={\"funcode\":\"1001\"}&format=json&method=oa&timestamp=2018-04-10 13:23:30&token="+token+"&v=1.0"+APP_SERCRET;
//        System.out.println(md);
//        String md5 = md5(md);
//        String sign=  new String(com.seeyon.apps.cloudapp.util.Base64.encode(md5.getBytes()));
//        System.out.println(sign);
    }


}
