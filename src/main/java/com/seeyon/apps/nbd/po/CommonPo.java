package com.seeyon.apps.nbd.po;

import com.seeyon.apps.nbd.core.config.ConfigService;
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

    private String extString1;
    private String extString2;
    private String extString3;
    private String extString4;
    private String extString5;
    private String extString6;
    private String extString7;
    private String extString8;

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
    public void saveOrUpdate(){

        saveOrUpdate(ConfigService.getA8DefaultDataLink());
    }
    public void saveOrUpdate(DataLink dl){
        if(this.getUpdateTime()==null){
            this.setUpdateTime(new Date());
        }
        DataBaseHelper.persistCommonVo(dl,this);
    }
    public void updateBySample(CommonPo vo){
        updateBySample(ConfigService.getA8DefaultDataLink(),vo);
        //DataBaseHelper.persistCommonVo(ConfigService.getA8DefaultDataLink(),vo);
    }
    public void updateBySample(DataLink dl,CommonPo vo){
        vo.setId(this.getId());
        DataBaseHelper.persistCommonVo(dl,vo);
    }
    public void delete(){

        delete(ConfigService.getA8DefaultDataLink());
    }
    public void delete(DataLink dl){
        String table = CommonUtils.camelToUnderline(this.getClass().getSimpleName());
        String sql = "delete from "+table+" where id="+this.getId();
        if("1".equals(dl.getDbType())){
            sql = "delete from \""+table+"\" where \"id\"="+this.getId();
        }
        DataBaseHelper.executeUpdateBySQLAndLink(dl,sql);
       // DataBaseHelper.persistCommonVo(dl,this);
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

    public String getExtString6() {
        return extString6;
    }

    public void setExtString6(String extString6) {
        this.extString6 = extString6;
    }

    public String getExtString7() {
        return extString7;
    }

    public void setExtString7(String extString7) {
        this.extString7 = extString7;
    }

    public String getExtString8() {
        return extString8;
    }

    public void setExtString8(String extString8) {
        this.extString8 = extString8;
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
