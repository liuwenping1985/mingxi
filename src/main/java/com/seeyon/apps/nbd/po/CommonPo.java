package com.seeyon.apps.nbd.po;

import com.seeyon.apps.nbd.core.db.DataBaseHelper;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.ctp.util.UUIDLong;

import java.util.Date;

/**
 * Created by liuwenping on 2018/10/29.
 */
public class CommonPo {

    private Long id;

    private String sid;

    private String sLinkId;

    private String name;

    private Date createTime;

    private Date updateTime;

    private Integer status;

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setIdIfNew(){
        if(this.id==null){
            this.id = UUIDLong.longUUID();
        }

    }
    public void setDefaultValueIfNull(){
        setIdIfNew();
        if(this.createTime==null){
            this.createTime = new Date();
        }
        if(this.status==null){
            this.status = 0;
        }
        if(this.updateTime==null){
            this.updateTime = this.createTime;
        }

    }

    public void saveOrUpdate(DataLink dl){
        DataBaseHelper.persistCommonVo(dl,this);
    }
    public void updateBySample(DataLink dl,CommonPo vo){
        vo.setId(this.getId());
        DataBaseHelper.persistCommonVo(dl,vo);
    }
    public void delete(DataLink dl){
        String table = CommonUtils.camelToUnderline(this.getClass().getSimpleName());
        DataBaseHelper.executeUpdateBySQLAndLink(dl,"delete from "+table+" where id="+this.getId());
        DataBaseHelper.persistCommonVo(dl,this);
    }

    public String getSid() {
        return sid;
    }

    public String getsLinkId() {
        return sLinkId;
    }

    public void setsLinkId(String sLinkId) {
        this.sLinkId = sLinkId;
    }

    public void setSid(String sid) {
        this.sid = sid;
    }
}
