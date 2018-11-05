package com.seeyon.apps.nbd.core.db;

import com.seeyon.apps.nbd.core.db.link.ConnectionBuilder;
import com.seeyon.apps.nbd.vo.DataLink;
import com.seeyon.ctp.util.JDBCAgent;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.Reader;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


/**
 * Created by liuwenping on 2018/9/9.
 */
public final class DataBaseHelper {

    public static List<Map> executeQueryByNativeSQL(String sql) throws Exception {
        JDBCAgent jdbc = new JDBCAgent();
        try {
            jdbc.execute(sql.toString());
             List<Map> list =  jdbc.resultSetToList();
            return list;
        }catch(Exception e){
            e.printStackTrace();
        }finally {
            jdbc.close();
        }
       return new ArrayList<Map>();

    }

    public static List<Map> executeQueryBySQLAndLink(DataLink link, String sql){
        Connection conn =null;
        PreparedStatement pst =null;
        ResultSet rs = null;
        try {
             conn =  ConnectionBuilder.openConnection(link);
             pst = conn.prepareStatement(sql, 1004, 1007);
             rs = pst.executeQuery();
             return resultSetToList(rs,true);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {


            if(rs!=null){
                try {
                    rs.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }

            }
            if(pst!=null){
                try {
                    pst.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            if(conn!=null){
                try{
                    conn.close();;
                } catch (Exception e) {

                } finally {

                }

            }
        }
        return null;

    }
    private static List resultSetToList(ResultSet rs, boolean lowercaseKey) throws SQLException {
        if(rs == null) {
            throw new RuntimeException("查询结果集对象不能为空！");
        } else {
            boolean var13 = false;

            List var15 = new ArrayList();
            try {
                var13 = true;
                ResultSetMetaData rsmd = rs.getMetaData();
                List dataList = new ArrayList();
                int columns = rsmd.getColumnCount();

                while(rs.next()) {
                    Map map = new LinkedHashMap();

                    for(int j = 1; j <= columns; ++j) {
                        String columnName = lowercaseKey?rsmd.getColumnLabel(j).toLowerCase():rsmd.getColumnLabel(j);
                        Object value;
                        if(rsmd.getColumnType(j) == 93) {
                            value = rs.getTimestamp(columnName);
                        } else if(rsmd.getColumnType(j) == 2005) {
                            value = extractClobString(rs, columnName);
                        } else {
                            value = rs.getObject(columnName);
                        }

                        map.put(columnName, value);
                    }

                    dataList.add(map);
                }

                var15 = dataList;
                var13 = false;
            } finally {
                if(var13) {
                    if(rs != null) {
                        Statement st = rs.getStatement();
                        rs.close();
                        if(st != null) {
                            st.close();
                        }
                    }

                }
            }

            if(rs != null) {
                Statement st = rs.getStatement();
                rs.close();
                if(st != null) {
                    st.close();
                }
            }

            return var15;
        }
    }

    private static String extractClobString(ResultSet rs, String columnName) throws SQLException {
        return clobToString(rs.getClob(columnName));
    }

    public static String clobToString(Clob clob) throws SQLException {
        if(clob == null) {
            return null;
        } else {
            Reader is = clob.getCharacterStream();
            BufferedReader br = new BufferedReader(is);

            try {
                String s = br.readLine();
                StringBuilder sb = new StringBuilder();

                while(s != null) {
                    sb.append(s);
                    s = br.readLine();
                    if(s != null) {
                        sb.append("\n");
                    }
                }

                String var5 = sb.toString();
                return var5;
            } catch (IOException var14) {
                throw new RuntimeException(var14.getMessage(), var14);
            } finally {
                try {
                    br.close();
                    is.close();
                } catch (IOException var13) {
                    ;
                }

            }
        }
    }

}
