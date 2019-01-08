package com.seeyon.apps.datakit.po;

import javax.persistence.Entity;
import javax.persistence.Table;
import java.sql.Timestamp;

/**
 * Created by liuwenping on 2018/9/18.
 */
@Entity
@Table(name = "datasource_config_entity")
public class DataSourceConfigEntity {
    private String name;
    private Long createMemberId;
    private String host;
    private String userName;
    private String dataBaseType;
    private String description;
    private Timestamp createDate;
    private Timestamp updateDate;
    private String databaseName;
    private Integer poolSize = 50;
    private Integer minConn = 5;
    private Integer maxConn = 50;
    private Integer deleted=0;


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Long getCreateMemberId() {
        return createMemberId;
    }

    public void setCreateMemberId(Long createMemberId) {
        this.createMemberId = createMemberId;
    }

    public String getHost() {
        return host;
    }

    public void setHost(String host) {
        this.host = host;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getDataBaseType() {
        return dataBaseType;
    }

    public void setDataBaseType(String dataBaseType) {
        this.dataBaseType = dataBaseType;
    }

    public Timestamp getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Timestamp createDate) {
        this.createDate = createDate;
    }

    public Timestamp getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(Timestamp updateDate) {
        this.updateDate = updateDate;
    }

    public String getDatabaseName() {
        return databaseName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getDeleted() {
        return deleted;
    }

    public void setDeleted(Integer deleted) {
        this.deleted = deleted;
    }

    public void setDatabaseName(String databaseName) {
        this.databaseName = databaseName;
    }

    public Integer getPoolSize() {
        return poolSize;
    }

    public void setPoolSize(Integer poolSize) {
        this.poolSize = poolSize;
    }

    public Integer getMinConn() {
        return minConn;
    }

    public void setMinConn(Integer minConn) {
        this.minConn = minConn;
    }

    public Integer getMaxConn() {
        return maxConn;
    }

    public void setMaxConn(Integer maxConn) {
        this.maxConn = maxConn;
    }

}
