package com.seeyon.apps.nbd.core.entity;

/**
 * Created by liuwenping on 2018/8/22.
 */
public class ServiceAffair {

    private String type;

    private String name;

    private Mapping maping;

    private String formTempleteCode;

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Mapping getMaping() {
        return maping;
    }

    public void setMaping(Mapping maping) {
        this.maping = maping;
    }

    public String getFormTempleteCode() {
        return formTempleteCode;
    }

    public void setFormTempleteCode(String formTempleteCode) {
        this.formTempleteCode = formTempleteCode;
    }
}
