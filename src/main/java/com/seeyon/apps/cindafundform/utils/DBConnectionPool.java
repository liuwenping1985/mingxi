package com.seeyon.apps.cindafundform.utils;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.seeyon.apps.cindafundform.manager.ConnectionManager;


public class DBConnectionPool {
  public DBConnectionPool() {}

  /**
   * 创建连接
   * @return
   */
  public Connection getConnection() {

    Connection conn = null;
    conn = createConnection();
    return conn;
  }

  @SuppressWarnings("static-access")
  private Connection createConnection() {
    ConnectionManager connectionManager = ConnectionManager.getInstance();
    return connectionManager.getConnection();
  }

  /**
   * 释放连接
   * @param con
   * @param prst
   * @param rs
   */
  public void closeConnection(ResultSet rs, Statement statement, Connection conn) {
    try {
      if (rs != null) {
        rs.close();
      }
      if (statement != null) {
        statement.close();
      }
      if (conn != null) {
        conn.close();
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
  }
}
