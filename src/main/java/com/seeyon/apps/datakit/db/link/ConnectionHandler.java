package com.seeyon.apps.datakit.db.link;

import com.seeyon.apps.datakit.db.driver.DriverConstant;
import com.seeyon.apps.datakit.po.DataLink;
import com.seeyon.apps.datakit.util.CommonUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.JDBCAgent;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.SessionFactoryUtils;
import org.springframework.orm.hibernate3.support.CTPHibernateDaoSupport;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by liuwenping on 2018/11/3.
 */
public class ConnectionHandler {
    /**
     * jdbc:sqlserver://localhost:1433;DatabaseName=People
     * jdbc:mysql://127.0.0.1:3306/imooc
     * jdbc:oracle:thin:@localhost:1521:bjpowernode
     *
     * @param link
     * @return
     */
    private static String getLinkUrl(DataLink link) {
        String host = link.getHost();
        String port = link.getPort();
        String type = link.getDbType();
        if ("0".equals(type)) {
            return "jdbc:mysql://" + host + ":" + port + "/" + link.getDataBaseName() + "?characterEncoding=UTF-8";
        }
        if ("1".equals(type)) {
            return "jdbc:oracle:thin:@" + host + ":" + port + ":" + link.getDataBaseName();

        }
        if ("2".equals(type)) {
            return "jdbc:sqlserver://" + host + ":" + port + ";DatabaseName=" + link.getDataBaseName();
        }

        return null;

    }

    public static boolean testConnection(DataLink link) throws SQLException, ClassNotFoundException {
        Connection conn = openConnection(link);
        if (conn == null) {
            return false;
        } else {
            try {
                if (!conn.isClosed()) {
                    conn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return true;
    }

    private static Map<String, String> connMap = new HashMap<String, String>();

    public static void closeConnection(Connection conn) {
        try {
            String having = connMap.get(conn.toString());
            if (!"YES".equals(having)) {

                if (conn != null) {
                    conn.close();
                }
            }
        } catch (Exception e) {

        }

    }

    private static CTPHibernateDaoSupport currentHibernateDaoSupport() {
        CTPHibernateDaoSupport dao = (CTPHibernateDaoSupport) AppContext.getThreadContext("SPRING_HIBERNATE_DAO_SUPPORT");
        if (dao == null) {
            dao = (CTPHibernateDaoSupport) AppContext.getBean("hibernateDaoSupport");
        }
        return dao;
    }

    public static Connection openConnection(DataLink link) throws ClassNotFoundException, SQLException {
        if ("local".equals(link.getLinkType())) {
            CTPHibernateDaoSupport dao = currentHibernateDaoSupport();
            Connection conn = dao.currentConnection();
            connMap.put(conn.toString(), "YES");
            return conn;

        }
        String type = link.getDbType();
        String dbClass = DriverConstant.MYSQL_JDBC_URL;

        if ("1".equals(type)) {
            dbClass = DriverConstant.ORACLE_JDBC_URL;
        }
        if ("2".equals(type)) {
            dbClass = DriverConstant.SQLSERVER2005_JDBC_URL;
        }
        String url = getLinkUrl(link);
        if (CommonUtils.isEmpty(url)) {
            return null;
        }

        Class.forName(dbClass);
        String user = link.getUserName();
        String password = link.getPassword();
        Connection conn = DriverManager.getConnection(url, user, password);
        return conn;


    }
}
