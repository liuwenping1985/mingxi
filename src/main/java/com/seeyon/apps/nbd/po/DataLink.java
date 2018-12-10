package com.seeyon.apps.nbd.po;

/**
 * Created by liuwenping on 2018/10/29.
 */
public class DataLink extends CommonPo {

    private String dataBaseName;
    private String host;
    private String user;
    private String password;
    private String port;
    private String extString1;
    private String extString2;
    private String extString3;
    private String extString4;
    private String extString5;
    private String linkType;
    private String dbType;

    public String getPort() {
        return port;
    }

    public void setPort(String port) {
        this.port = port;
    }

    public String getDbType() {
        return dbType;
    }

    public void setDbType(String dbType) {
        this.dbType = dbType;
    }

    public String getLinkType() {
        return linkType;
    }

    public void setLinkType(String linkType) {
        this.linkType = linkType;
    }

    public String getDataBaseName() {
        return dataBaseName;
    }

    public void setDataBaseName(String dataBaseName) {
        this.dataBaseName = dataBaseName;
    }

    public String getHost() {
        return host;
    }

    public void setHost(String host) {
        this.host = host;
    }

    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
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
}
