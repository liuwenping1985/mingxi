package com.seeyon.apps.kdXdtzXc.base.mapper.entity;


import com.seeyon.apps.kdXdtzXc.base.mapper.baseenum.SqlType;

/**
 * Created by taoanping on 14-8-27.
 */
public class SqlObj {
    private String id;
    private String sqlStr;
    private SqlType sqlType;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public SqlType getSqlType() {
        return sqlType;
    }

    public void setSqlType(SqlType sqlType) {
        this.sqlType = sqlType;
    }

    public String getSqlStr() {
        return sqlStr;
    }

    public void setSqlStr(String sqlStr) {
        this.sqlStr = sqlStr;
    }
}
