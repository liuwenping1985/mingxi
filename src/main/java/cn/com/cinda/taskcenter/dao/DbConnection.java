package cn.com.cinda.taskcenter.dao;

import java.sql.Connection;

import cn.com.cinda.taskcenter.common.ConnectionPool;

public class DbConnection {

	public static Connection getConnection() {
		return ConnectionPool.getConnection();
	}
}
