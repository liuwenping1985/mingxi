package cn.com.cinda.taskcenter.common;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.sql.DataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

import com.seeyon.ctp.common.AppContext;

public class ConnectionPool {
	private static final Log log = LogFactory.getLog(ConnectionPool.class);


	private static DataSource ds = null;

	public ConnectionPool() {
		ds = (DataSource) AppContext.getBean("taksconterDataSource");
		
	}

	private static void init() {
		ds = (DataSource) AppContext.getBean("taksconterDataSource");

	}

	public static Connection getConnection() {
		if (ds == null) {
			init();
		}

		try {
			return ds.getConnection();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return null;
	}

	public static void release(ResultSet rs, Statement stmt,
			PreparedStatement pstmt, Connection con) {
		try {
			if (rs != null) {
				rs.close();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		try {
			if (stmt != null) {
				stmt.close();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		try {
			if (pstmt != null) {
				pstmt.close();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		try {
			if (con != null) {
				con.close();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}

	}

}