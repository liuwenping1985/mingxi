package com.seeyon.apps.datakit.db.dialect;

import org.hibernate.dialect.*;

/**
 * Created by liuwenping on 2018/9/18.
 */
public final class DialectConstant {

    public static Dialect MYSQL = new MySQLDialect();

    public static Dialect MYSQL5 = new MySQL5Dialect();

    public static Dialect MYSQL5_INNODB = new MySQL5InnoDBDialect();

    public static Dialect MYSQL_INNODB = new MySQLInnoDBDialect();

    public static Dialect MYSQL_MYISAM = new MySQLMyISAMDialect();

    public static Dialect SQL_SERVER = new SQLServerDialect();

    public static Dialect ORACLE_8I = new Oracle8iDialect();

    public static Dialect ORACLE_9I = new Oracle9iDialect();

    public static Dialect ORACLE_10G = new Oracle10gDialect();

    public static Dialect ORACLE_UNKNOWN = new OracleDialect();





}
