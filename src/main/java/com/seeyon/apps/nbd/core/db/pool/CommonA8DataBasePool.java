package com.seeyon.apps.nbd.core.db.pool;

import com.mchange.v2.c3p0.ComboPooledDataSource;

import java.beans.PropertyVetoException;
import java.sql.Connection;
import java.sql.SQLException;

/**
 * Created by liuwenping on 2018/9/13.
 */
public class CommonA8DataBasePool {

    private ComboPooledDataSource source;

    public void sync(){

        ComboPooledDataSource source = new ComboPooledDataSource();

        source.setAcquireIncrement(2);
        try {
            source.setDriverClass("");
        } catch (PropertyVetoException e) {
            e.printStackTrace();
        }
        source.setAutoCommitOnClose(false);
        source.setJdbcUrl("");
        //source.getConnection();
    }

    public Connection getConnection() throws SQLException {

        Connection conn = source.getConnection();

        return conn;

    }
}
