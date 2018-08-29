package com.seeyon.apps.nbd.core.entity;

import java.util.Map;

/**
 * Created by liuwenping on 2018/8/22.
 */
public class ServiceAffairs {

    private String name;

    private Map<String,ServiceAffair> affairHolder;


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Map<String, ServiceAffair> getAffairHolder() {
        return affairHolder;
    }

    public void setAffairHolder(Map<String, ServiceAffair> affairHolder) {
        this.affairHolder = affairHolder;
    }

}
