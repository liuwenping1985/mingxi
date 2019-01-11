package com.seeyon.apps.nbd.vo;

public class PageResourceVo {

    private String code;

    private String type;

    private String value;

    public PageResourceVo() {

    }

    public PageResourceVo(String code) {
        this.code = code;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public int hashCode(){

        if(this.code==null){
           return  "".hashCode();
        }
        return this.code.hashCode();
    }
    public boolean equals(PageResourceVo vo){
        if(this.code==null&&vo.code==null){
            return true;
        }
        return this.code.equals(vo.getCode());
    }



}
