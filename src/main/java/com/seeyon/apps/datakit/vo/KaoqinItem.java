package com.seeyon.apps.datakit.vo;

/**
 * Created by liuwenping on 2018/10/9.
 */
public class KaoqinItem {
    //事由id
    private Long typeId;
    //事由名字
    private String typeName;
    //天数
    private Float num;

    public Long getTypeId() {
        return typeId;
    }

    public void setTypeId(Long typeId) {
        this.typeId = typeId;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public Float getNum() {
        return num;
    }

    public void setNum(Float num) {
        this.num = num;
    }
}
