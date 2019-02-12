package com.seeyon.apps.cindafundform.manager;


import java.sql.Connection;
import java.sql.SQLException;

import javax.sql.DataSource;

import com.mchange.v2.c3p0.ComboPooledDataSource;
import com.seeyon.ctp.common.AppContext;

public class ConnectionManager {
  private static ConnectionManager connectionManager = null;
  private static ComboPooledDataSource cpds = null;
  private static DataSource ds = null;

  public static boolean initPool() {
    try {
      cpds = new ComboPooledDataSource();
      cpds.setDriverClass(AppContext.getSystemProperty("cindafundform.driverName"));
      cpds.setJdbcUrl(AppContext.getSystemProperty("cindafundform.dbURL"));
      cpds.setUser(AppContext.getSystemProperty("cindafundform.userName"));
      cpds.setPassword(AppContext.getSystemProperty("cindafundform.userPwd"));
      // 连接池中保留的最大连接数，默认15
      cpds.setMaxPoolSize(50);
      // 初始化获取30个连接，取值应在minPoolSize与maxPoolSize之间。默认3
      cpds.setInitialPoolSize(30);
      // 连接池中保留的最小连接数
      cpds.setMinPoolSize(10);
      // 最大空闲时间,25000秒内未使用则连接被丢弃。若为0则永不丢弃。默认0
      cpds.setMaxIdleTime(25000);
      // 每18000秒检查所有连接池中的空闲连接
      cpds.setIdleConnectionTestPeriod(18000);
      // 因性能消耗大请只在需要的时候使用它。如果设为true那么在每个connection提交的
      // 时候都将校验其有效性。建议使用idleConnectionTestPeriod或automaticTestTable
      // 等方法来提升连接测试的性能。Default: false testConnectionOnCheckout
      cpds.setTestConnectionOnCheckout(true);
      // 如果设为true那么在取得连接的同时将校验连接的有效性
      cpds.setTestConnectionOnCheckin(true);
      cpds.setMaxStatementsPerConnection(0);
      ds = cpds;
      Connection conn = ds.getConnection();
      if (conn != null) {
        conn.close();
        return true;
      }
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return false;
  }

  public ConnectionManager() {}

  public final static ConnectionManager getInstance() {
    if (connectionManager == null) {
      connectionManager = new ConnectionManager();
    }
    return connectionManager;
  }

  public static final Connection getConnection() {
    if (ds == null) {
      ConnectionManager.initPool();
    }
    try {
      return ds.getConnection();
    } catch (SQLException e) {
      throw new RuntimeException("无法从数据源获取连接 ", e);
    }
  }

}
