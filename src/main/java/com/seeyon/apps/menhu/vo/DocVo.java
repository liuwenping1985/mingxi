package com.seeyon.apps.menhu.vo;
import com.seeyon.apps.doc.po.DocResourcePO;


public class DocVo extends DocResourcePO{
    private String v;
    private  String ownerId;
    private String entranceType;
    private  String link;
    private boolean readFlag;
    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }



    public String getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(String ownerId) {
        this.ownerId = ownerId;
    }

    public String getEntranceType() {
        return entranceType;
    }

    public void setEntranceType(String entranceType) {
        this.entranceType = entranceType;
    }

    public String getV() {
        return v;
    }

    public void setV(String v) {
        this.v = v;
    }

    public boolean isReadFlag() {
        return readFlag;
    }

    public void setReadFlag(boolean readFlag) {
        this.readFlag = readFlag;
    }
}