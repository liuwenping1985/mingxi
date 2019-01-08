package com.seeyon.apps.datakit.db;

/**
 * Created by liuwenping on 2018/9/18.
 */
public enum EnumDataBaseType {

    MYSQL("MYSQL"),
    MYSQL5("MYSQL5"),
    MYSQL5_INNODB("MYSQL5_INNODB"),
    MYSQL_INNODB("MYSQL_INNODB"),
    MYSQL_MYISAM("MYSQL_MYISAM"),
    ORACLE_8I("ORACLE_8I"),
    ORACLE_9I("ORACLE_9I"),
    ORACLE_10G("ORACLE_10G"),
    ORACLE_UNKNOWN("ORACLE_UNKNOWN"),
    SQL_SERVER("SQL_SERVER");

    private String key;

    EnumDataBaseType(String key){
        this.key = key;
    }

    public String getKey() {
        return key;
    }
}
