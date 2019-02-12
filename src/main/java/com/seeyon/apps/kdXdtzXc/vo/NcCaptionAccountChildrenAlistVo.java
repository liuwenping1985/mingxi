package com.seeyon.apps.kdXdtzXc.vo;

import java.io.Serializable;

/**
 * Created by tap-pcng43 on 2017-8-14.
 * 会计科目---辅助核算项
 */
public class NcCaptionAccountChildrenAlistVo implements Serializable {
    private Integer id;//序号
    private Boolean isbalancecontrol;//是否余额方向控制
    private String pk_accass;//辅助核算项
     private String valuecode;//辅助项编码
    private String valuename;//辅助项名称

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Boolean getIsbalancecontrol() {
        return isbalancecontrol;
    }

    public void setIsbalancecontrol(Boolean isbalancecontrol) {
        this.isbalancecontrol = isbalancecontrol;
    }

    public String getPk_accass() {
        return pk_accass;
    }

    public void setPk_accass(String pk_accass) {
        this.pk_accass = pk_accass;
    }


    public String getValuecode() {
        return valuecode;
    }

    public void setValuecode(String valuecode) {
        this.valuecode = valuecode;
    }

    public String getValuename() {
        return valuename;
    }

    public void setValuename(String valuename) {
        this.valuename = valuename;
    }

    @Override
    public String toString() {
        return "NcCaptionAccountChildrenAlistVo{" +
                "id=" + id +
                ", isbalancecontrol=" + isbalancecontrol +
                ", pk_accass='" + pk_accass + '\'' +
                 ", valuecode='" + valuecode + '\'' +
                ", valuename='" + valuename + '\'' +
                '}';
    }
}
