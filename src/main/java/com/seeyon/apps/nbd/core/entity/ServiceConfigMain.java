package com.seeyon.apps.nbd.core.entity;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by liuwenping on 2018/8/22.
 */
public class ServiceConfigMain {

    private String id;

    private String name;

    private List<ServiceAffairs> affairsList = new ArrayList<ServiceAffairs>();

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<ServiceAffairs> getAffairsList() {
        return affairsList;
    }

    public void setAffairsList(List<ServiceAffairs> affairsList) {
        this.affairsList = affairsList;
    }
}
