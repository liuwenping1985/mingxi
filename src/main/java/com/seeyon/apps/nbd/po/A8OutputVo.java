package com.seeyon.apps.nbd.po;

import com.seeyon.ctp.common.po.BasePO;

import java.util.Date;

/**
 * Created by liuwenping on 2018/9/6.
 */
public class A8OutputVo extends BasePO {

    private Long id;

    private String data;

    private Date createDate;

    private Date updateDate;

    @Override
    public Long getId() {
        return id;
    }

    @Override
    public void setId(Long id) {
        this.id = id;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
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

    public String getYear() {
        return year;
    }

    public void setYear(String year) {
        this.year = year;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    private String year;

    private Integer status;


}
