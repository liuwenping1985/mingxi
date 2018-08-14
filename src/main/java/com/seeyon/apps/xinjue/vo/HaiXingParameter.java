package com.seeyon.apps.xinjue.vo;

import com.alibaba.fastjson.JSON;
import com.fasterxml.jackson.annotation.JsonIgnore;
import org.apache.http.NameValuePair;

import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.*;

public class HaiXingParameter {

    private String sign;

    private static String APP_SERCRET  = "f8b9bbea2e8c48dfade3b60d99cc8f7a";
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
        //要排序 - -！ 参数固定写死
        String _sign =APP_SERCRET+ "app_key="+this.getApp_key()+"&biz_content="+ JSON.toJSONString(this.getBiz_content())+"&format=json&method=oa&timestamp="+this.getTimestamp()+"&token="+this.getToken()+"&v=1.0"+APP_SERCRET;
        System.out.println(_sign);
        try {
            String md5String = md5(_sign);
            String sign=  new String(com.seeyon.apps.cloudapp.util.Base64.encode(md5String.getBytes()));
            this.setSign(sign);
            System.out.println(sign);
            return sign;
        } catch (Exception e) {
            e.printStackTrace();
        }
        throw new RuntimeException("can not sign");
    }

    public List<? extends NameValuePair> toNameValuePairList(){
       // HashMap<String,String> data = new HashMap<String, String>();
        List<HsNameValuePair> hsList = new ArrayList<HsNameValuePair>();
        HsNameValuePair appKey = new HsNameValuePair("app_key",app_key);
       // data.put("app_key",app_key);
        hsList.add(appKey);
        HsNameValuePair bizContentKey = new HsNameValuePair("biz_content",JSON.toJSONString(this.getBiz_content()));
       // data.put("biz_content",bizContentKey.getValue());
        hsList.add(bizContentKey);
        HsNameValuePair formatKey = new HsNameValuePair("format","json");
       // data.put("format",formatKey.getValue());
        hsList.add(formatKey);
        HsNameValuePair methodKey = new HsNameValuePair("method","oa");
       // data.put("method",methodKey.getValue());
        hsList.add(methodKey);
        HsNameValuePair timestampKey = new HsNameValuePair("timestamp",timestamp);
        hsList.add(timestampKey);
       // data.put("timestamp",timestampKey.getValue());
        HsNameValuePair tokenKey = new HsNameValuePair("token",this.getToken());
        hsList.add(tokenKey);
      //  data.put("token",tokenKey.getValue());
        HsNameValuePair vKey = new HsNameValuePair("v","1.0");
      //  data.put("v",vKey.getValue());
        hsList.add(vKey);
        HsNameValuePair signKey = new HsNameValuePair("sign",this.getSign());
      //  data.put("sign",signKey.getValue());
        hsList.add(signKey);
       // System.out.println(data);
        return hsList;

    }

    public static void main(String[] args){

        //"funcode":"001","bgnrptdate":"2018-04-20 00:00:00","endrptdate":"2018-04-20 01:00:00"
        HaiXingParameter p = new HaiXingParameter();

        p.getBiz_content().put("funcode","001");
        p.getBiz_content().put("bgnrptdate","2018-04-20 00:00:00");
        p.getBiz_content().put("endrptdate","2018-04-20 01:00:00");
    }



}
