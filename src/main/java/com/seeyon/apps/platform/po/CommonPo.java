package com.seeyon.apps.platform.po;

import com.alibaba.fastjson.annotation.JSONField;
import com.alibaba.fastjson.serializer.ToStringSerializer;

import javax.persistence.Id;
import java.util.Date;

/**
 * Created by liuwenping on 2019/1/18.
 */
public class CommonPo {

    private String name;

    @Id
    @JSONField(serializeUsing = ToStringSerializer.class)
    private Long id;

    private String type;

    private String uuid;

    private Date createDate;

    private Date updateDate;

    /**
     * 扩展字段群
     */
    @JSONField(serializeUsing = ToStringSerializer.class)
    private Long extLong1;
    @JSONField(serializeUsing = ToStringSerializer.class)
    private Long extLong2;
    private String extString1;
    private String extString2;
    private String extString3;
    private String extString4;
    private String extString5;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public Date getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(Date updateDate) {
        this.updateDate = updateDate;
    }

    public Long getExtLong1() {
        return extLong1;
    }

    public void setExtLong1(Long extLong1) {
        this.extLong1 = extLong1;
    }

    public Long getExtLong2() {
        return extLong2;
    }

    public void setExtLong2(Long extLong2) {
        this.extLong2 = extLong2;
    }

    public String getExtString1() {
        return extString1;
    }

    public void setExtString1(String extString1) {
        this.extString1 = extString1;
    }

    public String getExtString2() {
        return extString2;
    }

    public void setExtString2(String extString2) {
        this.extString2 = extString2;
    }

    public String getExtString3() {
        return extString3;
    }

    public void setExtString3(String extString3) {
        this.extString3 = extString3;
    }

    public String getExtString4() {
        return extString4;
    }

    public void setExtString4(String extString4) {
        this.extString4 = extString4;
    }

    public String getExtString5() {
        return extString5;
    }

    public void setExtString5(String extString5) {
        this.extString5 = extString5;
    }
    public void save(){
        saveOrUpdate(null);
    }

    public void saveOrUpdate(CommonPo po){



    }

    /**
     * update by sample
     * @param po
     */
    public void update(CommonPo po){
        saveOrUpdate(po);
    }

    public void delete(){


    }
}
