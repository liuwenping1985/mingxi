package com.seeyon.apps.xinjue.vo;

import org.apache.http.NameValuePair;

public class HsNameValuePair implements NameValuePair {
    private String key;
    private String value;
    public HsNameValuePair(){

    }
    public HsNameValuePair(String key,String value){
        this.key = key;
        this.value = value;
    }
    public String getName() {
        return key;
    }

    public String getValue() {
        return value;
    }


}
