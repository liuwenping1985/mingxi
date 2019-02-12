package com.seeyon.apps.kdXdtzXc.po;

import java.io.Serializable;
import java.util.Date;

/**
 * Created by tap-pcng43 on 2017-10-12.
 * 征求意见
 */
public class ZongCaiZqyj implements Serializable {
    private Long id;
    private Long formmain_id;
    private String zb;//总部各部室
    private String zb_gfgs;//总部各部室-各分公司
    private String zb_gzgs;//总部各部室- 各子公司
    private String zb_djs;//总部各部室-董监事

    private String gsfgld;//公司分管领导
    private String gsfgld_xgfgs;//公司分管领导- 相关分公司
    private String gsfgld_xgzgs;//公司分管领导- 相关子公司
    private String gsfgld_bsjdjs;//公司分管领导- 不涉及董监事

    private String qtgsld;// 其他公司领导
    private String qtgsld_bsjfgs;// 其他公司领导-不涉及分公司
    private String qtgsld_bsjzgs;// 其他公司领导-不涉及子公司

    private String tsqk;// 特殊情况

    private Date insert_date;
    private Date update_date;


    private String idStr;
    private String formmain_idStr;

    public void initStr() {
        if (id != null) {
            idStr = id.toString();
        }
        if (formmain_id != null) {
            formmain_idStr = formmain_id.toString();
        }
    }

    public String getIdStr() {
        return idStr;
    }

    public void setIdStr(String idStr) {
        this.idStr = idStr;
    }

    public String getFormmain_idStr() {
        return formmain_idStr;
    }

    public void setFormmain_idStr(String formmain_idStr) {
        this.formmain_idStr = formmain_idStr;
    }

    public Date getInsert_date() {
        return insert_date;
    }

    public void setInsert_date(Date insert_date) {
        this.insert_date = insert_date;
    }

    public Date getUpdate_date() {
        return update_date;
    }

    public void setUpdate_date(Date update_date) {
        this.update_date = update_date;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getFormmain_id() {
        return formmain_id;
    }

    public void setFormmain_id(Long formmain_id) {
        this.formmain_id = formmain_id;
    }

    public String getZb() {
        return zb;
    }

    public void setZb(String zb) {
        this.zb = zb;
    }

    public String getZb_gfgs() {
        return zb_gfgs;
    }

    public void setZb_gfgs(String zb_gfgs) {
        this.zb_gfgs = zb_gfgs;
    }

    public String getZb_djs() {
        return zb_djs;
    }

    public void setZb_djs(String zb_djs) {
        this.zb_djs = zb_djs;
    }

    public String getZb_gzgs() {
        return zb_gzgs;
    }

    public void setZb_gzgs(String zb_gzgs) {
        this.zb_gzgs = zb_gzgs;
    }

    public String getGsfgld() {
        return gsfgld;
    }

    public void setGsfgld(String gsfgld) {
        this.gsfgld = gsfgld;
    }

    public String getGsfgld_xgfgs() {
        return gsfgld_xgfgs;
    }

    public void setGsfgld_xgfgs(String gsfgld_xgfgs) {
        this.gsfgld_xgfgs = gsfgld_xgfgs;
    }

    public String getGsfgld_xgzgs() {
        return gsfgld_xgzgs;
    }

    public void setGsfgld_xgzgs(String gsfgld_xgzgs) {
        this.gsfgld_xgzgs = gsfgld_xgzgs;
    }

    public String getGsfgld_bsjdjs() {
        return gsfgld_bsjdjs;
    }

    public void setGsfgld_bsjdjs(String gsfgld_bsjdjs) {
        this.gsfgld_bsjdjs = gsfgld_bsjdjs;
    }

    public String getQtgsld() {
        return qtgsld;
    }

    public void setQtgsld(String qtgsld) {
        this.qtgsld = qtgsld;
    }

    public String getQtgsld_bsjfgs() {
        return qtgsld_bsjfgs;
    }

    public void setQtgsld_bsjfgs(String qtgsld_bsjfgs) {
        this.qtgsld_bsjfgs = qtgsld_bsjfgs;
    }

    public String getQtgsld_bsjzgs() {
        return qtgsld_bsjzgs;
    }

    public void setQtgsld_bsjzgs(String qtgsld_bsjzgs) {
        this.qtgsld_bsjzgs = qtgsld_bsjzgs;
    }

    public String getTsqk() {
        return tsqk;
    }

    public void setTsqk(String tsqk) {
        this.tsqk = tsqk;
    }

    @Override
    public String toString() {
        return "ZongCaiZqyj{" +
                "id=" + id +
                ", formmain_id=" + formmain_id +
                ", zb='" + zb + '\'' +
                ", zb_gfgs='" + zb_gfgs + '\'' +
                ", zb_djs='" + zb_djs + '\'' +
                ", zb_gzgs='" + zb_gzgs + '\'' +
                ", gsfgld='" + gsfgld + '\'' +
                ", gsfgld_xgfgs='" + gsfgld_xgfgs + '\'' +
                ", gsfgld_xgzgs='" + gsfgld_xgzgs + '\'' +
                ", gsfgld_bsjdjs='" + gsfgld_bsjdjs + '\'' +
                ", qtgsld='" + qtgsld + '\'' +
                ", qtgsld_bsjfgs='" + qtgsld_bsjfgs + '\'' +
                ", qtgsld_bsjzgs='" + qtgsld_bsjzgs + '\'' +
                ", tsqk='" + tsqk + '\'' +
                ", insert_date=" + insert_date +
                ", update_date=" + update_date +
                ", idStr='" + idStr + '\'' +
                ", formmain_idStr='" + formmain_idStr + '\'' +
                '}';
    }
}
