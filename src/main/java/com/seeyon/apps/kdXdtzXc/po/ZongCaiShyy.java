package com.seeyon.apps.kdXdtzXc.po;

import java.io.Serializable;
import java.util.Date;

/**
 * Created by tap-pcng43 on 2017-10-12.
 * 上会意见
 */
public class ZongCaiShyy implements Serializable {
    private Long id;
    private Long formmain_id;
    private String gszd;//公司制度
    private String jygl;//经验管理重大事项
    private String qt;//其他
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

    public String getGszd() {
        return gszd;
    }

    public void setGszd(String gszd) {
        this.gszd = gszd;
    }

    public String getJygl() {
        return jygl;
    }

    public void setJygl(String jygl) {
        this.jygl = jygl;
    }

    public String getQt() {
        return qt;
    }

    public void setQt(String qt) {
        this.qt = qt;
    }

    @Override
    public String toString() {
        return "ZongCaiShyy{" +
                "id=" + id +
                ", formmain_id=" + formmain_id +
                ", gszd='" + gszd + '\'' +
                ", jygl='" + jygl + '\'' +
                ", qt='" + qt + '\'' +
                '}';
    }
}
