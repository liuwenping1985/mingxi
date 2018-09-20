package com.seeyon.apps.nbd.core.db;

/**
 * Created by liuwenping on 2018/9/13.
 */
public class DataBaseConnector {

    private String type;

    private String url;

    private String user;

    private Integer port;

    private String password;

    private String databseName;

    private int poolSize = 50;

    private int minConn = 5;

    private int maxConn = 50;

    public Integer getPort() {
        return port;
    }

    public void setPort(Integer port) {
        this.port = port;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
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

    public String getDatabseName() {
        return databseName;
    }

    public void setDatabseName(String databseName) {
        this.databseName = databseName;
    }

    public int getPoolSize() {
        return poolSize;
    }

    public void setPoolSize(int poolSize) {
        this.poolSize = poolSize;
    }

    public int getMinConn() {
        return minConn;
    }

    public void setMinConn(int minConn) {
        this.minConn = minConn;
    }

    public int getMaxConn() {
        return maxConn;
    }

    public void setMaxConn(int maxConn) {
        this.maxConn = maxConn;
    }
}
