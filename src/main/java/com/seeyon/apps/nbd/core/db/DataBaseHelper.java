package com.seeyon.apps.nbd.core.db;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.db.link.ConnectionBuilder;
import com.seeyon.apps.nbd.core.db.script.ScriptHook;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.po.CommonPo;
import com.seeyon.apps.nbd.po.DataLink;
import com.seeyon.ctp.util.JDBCAgent;
import org.apache.commons.io.IOUtils;

import java.io.*;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.sql.*;
import java.util.*;
import java.util.Date;


/**
 * Created by liuwenping on 2018/9/9.
 */
public final class DataBaseHelper {

    public static List<Map> executeQueryByNativeSQL(String sql) throws Exception {
        JDBCAgent jdbc = new JDBCAgent();
        try {
            jdbc.execute(sql.toString());
            List<Map> list = jdbc.resultSetToList();
            return list;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            jdbc.close();
        }
        return new ArrayList<Map>();

    }

    public static Integer executeUpdateBySQLAndLink(DataLink link, String sql) {
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = ConnectionBuilder.openConnection(link);
            pst = conn.prepareStatement(sql);
            return pst.executeUpdate();
            //return resultSetToList(rs, true);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (pst != null) {
                try {
                    pst.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            if (conn != null) {
                try {
                    conn.close();
                    ;
                } catch (Exception e) {

                } finally {

                }

            }
        }
        return null;

    }

    public static<T> List<T> executeObjectQueryBySQLAndLink(DataLink dl,Class<T> cls, String sql){
        List<Map> retMapList = executeQueryBySQLAndLink(dl,sql);
        if(CommonUtils.isEmpty(retMapList)){
            return new ArrayList<T>();
        }
        List<T> retList = new ArrayList<T>();
        for(Map map:retMapList){
            Map extendMap = new HashMap();
            for(Object key:map.keySet()){
                String newKey = CommonUtils.underlineToCamel(String.valueOf(key));
                if(newKey.equals(key)){
                    continue;
                }
                extendMap.put(newKey,map.get(key));
            }
            map.putAll(extendMap);
            String json = JSON.toJSONString(map);

            T t = JSON.parseObject(json,cls);
            retList.add(t);

        }
        return retList;
    }
    private static String getTableName(Class cls){

        String name = cls.getSimpleName();
        return CommonUtils.camelToUnderline(name);

    }
    public static <T> T getDataByTypeAndId(DataLink dl,Class<T> cls,Long id){

        String sql = "select * from "+getTableName(cls)+" where id="+id;
        List<T> dataMap = executeObjectQueryBySQLAndLink(dl,cls,sql);
        if(CommonUtils.isEmpty(dataMap)){
            return null;
        }
        return dataMap.get(0);
    }

    public static List<Map> executeQueryBySQLAndLink(DataLink link, String sql) {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            conn = ConnectionBuilder.openConnection(link);
            pst = conn.prepareStatement(sql, 1004, 1007);
            rs = pst.executeQuery();
            return resultSetToList(rs, true);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {


            if (rs != null) {
                try {
                    rs.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }

            }
            if (pst != null) {
                try {
                    pst.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            if (conn != null) {
                try {
                    conn.close();
                    ;
                } catch (Exception e) {

                } finally {

                }

            }
        }
        return null;

    }

    private static File getCreateTableScript(String tbName, DataLink link) {
        String type = link.getDbType();
        String dbType = "mysql";
        if ("1".equals(type)) {
            dbType = "oracle";
        } else if ("2".equals(type)) {
            dbType = "sqlserver";
        }
        String path = ScriptHook.class.getResource(dbType + File.separator + CommonUtils.camelToUnderline(tbName).toLowerCase() + ".sql").getPath();
        System.out.println(path);
        File f = new File(path);

        if (!f.exists()) {
            throw new RuntimeException("create sql is not exist");
        }
        return f;
    }

    /**
     * @param tableName
     * @param link
     */
    public static void createTableIfNotExist(String tableName, DataLink link) {
        Connection conn = null;
        ResultSet rs = null;
        Statement st = null;
        try {
            conn = ConnectionBuilder.openConnection(link);

            rs = conn.getMetaData().getTables(null, null, tableName, null);
            if (rs.next()) {
                //存在
                return;
            } else {
                File file = getCreateTableScript(tableName, link);
                String sql = IOUtils.toString(new FileInputStream(file), "UTF-8");
                st = conn.createStatement();
                st.execute(sql);
            }

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {

            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (st != null) {
                try {
                    st.close();
                } catch (Exception e) {

                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }

            }
        }


    }

    public static void persistCommonVo(DataLink dl, CommonPo obj) {

        persistCommonVo(dl, obj, true);
    }

    public static void persistCommonVo(DataLink dl, Object obj, boolean lowercaseKey) {

        String tbName = CommonUtils.camelToUnderline(obj.getClass().getSimpleName());
        if (!lowercaseKey) {
            tbName = tbName.toUpperCase();
        } else {
            tbName = tbName.toLowerCase();
        }

        StringBuilder stb = new StringBuilder();
        List<Object> values = new ArrayList<Object>();
        List<String> fieldNames = new ArrayList<String>();
        List<Field> insFields = new ArrayList<Field>();
        Object id = null;
        Class root = obj.getClass();
        do {
            Object tempId = filledValues(root, obj, values, fieldNames, insFields);
            if (tempId != null) {
                id = tempId;
            }
            root = root.getSuperclass();
        } while (root != null);

        if (values.size() != 0) {
            //todo 重构一下 太长了
            boolean isUpdate = false;
            if (id != null) {
                System.out.println("id not null:" + id);
                List<Map> existData = executeQueryBySQLAndLink(dl, "select count(*) from " + tbName + " where id=" + id);
                if (!CommonUtils.isEmpty(existData)) {
                    isUpdate = true;
                }
            }
            if (isUpdate) {
                stb.append("UPDATE " + tbName);
                stb.append(" SET ");
                List<String> sqlSequections = toUpdateSQLString(insFields, fieldNames, values);
                if (CommonUtils.isEmpty(sqlSequections)) {
                    return;
                }
                stb.append(join(sqlSequections, ","));
                stb.append(" WHERE id=" + id);
                System.out.println(stb);
                executeUpdateBySQLAndLink(dl, stb.toString());
            } else {
                stb.append("INSERT INTO " + tbName);
                List<String> sqlValueList = toInsertSQLString(insFields, values);
                createTableIfNotExist(tbName, dl);
                String vals = join(sqlValueList, ",");
                String fils = join(fieldNames, ",");
                stb.append("(").append(fils).append(")");//fils+
                stb.append("VALUES");
                stb.append("(").append(vals).append(")");
                System.out.println(stb);
                executeUpdateBySQLAndLink(dl, stb.toString());
            }


        }

    }

    private static Object filledValues(Class cls, Object obj, List<Object> values, List<String> fieldNames, List<Field> insFields) {

        Field[] fields = cls.getDeclaredFields();
        Object id = null;
        for (Field fd : fields) {
            String getMethodName = CommonUtils.getGetMethodName(fd);
            try {
                Method mdd = cls.getMethod(getMethodName, null);
                Object val = mdd.invoke(obj);
                if (val != null) {
                    fieldNames.add(CommonUtils.camelToUnderline(fd.getName()));
                    values.add(val);
                    insFields.add(fd);
                    if (fd.getName().equals("id")) {
                        id = val;
                    }
                }
                //System.out.println(getMethodName);
            } catch (Exception e) {

            }
        }

        return id;

    }

    private static List<String> toUpdateSQLString(List<Field> insFields, List<String> fieldNames, List dataList) {
        List<String> updateData = new ArrayList<String>();
        if (CommonUtils.isEmpty(insFields) || CommonUtils.isEmpty(dataList)) {
            throw new RuntimeException("Can not execute insert: field or values is empty");
        }
        if (insFields.size() != dataList.size()) {
            throw new RuntimeException("Can not execute insert: field length not equal values");
        }

        int len = insFields.size();

        for (int i = 0; i < len; i++) {
            Field fd = insFields.get(i);
            Class type = fd.getType();
            Object val = dataList.get(i);
            if (val == null) {
                throw new RuntimeException("Error:null value is not permitted!!");
            }
            if ("id".equals(fieldNames.get(i))) {
                continue;
            }
            updateData.add(fieldNames.get(i) + "=" + trans2SqlString(type, val));
        }
        return updateData;

    }


    private static List<String> toInsertSQLString(List<Field> insFields, List dataList) {
        List<String> data = new ArrayList<String>();
        if (CommonUtils.isEmpty(insFields) || CommonUtils.isEmpty(dataList)) {
            throw new RuntimeException("Can not execute insert: field or values is empty");
        }
        if (insFields.size() != dataList.size()) {
            throw new RuntimeException("Can not execute insert: field length not equal values");
        }

        int len = insFields.size();

        for (int i = 0; i < len; i++) {
            Field fd = insFields.get(i);
            Class type = fd.getType();
            Object val = dataList.get(i);
            if (val == null) {
                throw new RuntimeException("Error:null value is not permitted!!");
            }
            data.add(trans2SqlString(type, val));

        }
        return data;

    }

    private static String trans2SqlString(Class type, Object val) {
        if (type == Boolean.class) {

            if (Boolean.FALSE.equals(val)) {
                return "0";
            } else {
                return "1";
            }
        } else if (Date.class == type || Timestamp.class == type) {

            return "'" + CommonUtils.formatDate((Date) val) + "'";
        } else {
            if (Long.class == type || Float.class == type || Integer.class == type || Double.class == type) {
                return String.valueOf(val);
            } else if (String.class == type) {
                return "'" + val + "'";
            } else {
                return "'" + JSON.toJSONString(val) + "'";
            }

        }


    }

    private static String join(List list, String token) {
        StringBuilder stb = new StringBuilder();
        for (int i = 0; i < list.size(); i++) {
            if (i == 0) {
                stb.append(list.get(i));
            } else {
                stb.append(token).append(list.get(i));
            }
        }
        return stb.toString();

    }


    private static List resultSetToList(ResultSet rs, boolean lowercaseKey) throws SQLException {
        if (rs == null) {
            throw new RuntimeException("查询结果集对象不能为空！");
        } else {
            boolean var13 = false;

            List var15 = new ArrayList();
            try {
                var13 = true;
                ResultSetMetaData rsmd = rs.getMetaData();
                List dataList = new ArrayList();
                int columns = rsmd.getColumnCount();

                while (rs.next()) {
                    Map map = new LinkedHashMap();

                    for (int j = 1; j <= columns; ++j) {
                        String columnName = lowercaseKey ? rsmd.getColumnLabel(j).toLowerCase() : rsmd.getColumnLabel(j);
                        Object value;
                        if (rsmd.getColumnType(j) == 93) {
                            value = rs.getTimestamp(columnName);
                        } else if (rsmd.getColumnType(j) == 2005) {
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
                if (var13) {
                    if (rs != null) {
                        Statement st = rs.getStatement();
                        rs.close();
                        if (st != null) {
                            st.close();
                        }
                    }

                }
            }

            if (rs != null) {
                Statement st = rs.getStatement();
                rs.close();
                if (st != null) {
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
        if (clob == null) {
            return null;
        } else {
            Reader is = clob.getCharacterStream();
            BufferedReader br = new BufferedReader(is);

            try {
                String s = br.readLine();
                StringBuilder sb = new StringBuilder();

                while (s != null) {
                    sb.append(s);
                    s = br.readLine();
                    if (s != null) {
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

    public static List<Map> queryColumnsByTableAndLink(DataLink link, String table) {
        Connection conn = null;
        DatabaseMetaData dm = null;
        ResultSet rs = null;
        try {
            conn = ConnectionBuilder.openConnection(link);//数据库连接
            dm = conn.getMetaData();
            rs = dm.getColumns(null, null, table, null);

            List<Map> retList = resultSetToList(rs, true);
            List<Map> dataList = new ArrayList<Map>();
            for (Map ret : retList) {
                Map data = new HashMap();
                data.put("column_name", ret.get("column_name"));
                data.put("type_name", ret.get("type_name"));
                data.put("column_size", ret.get("column_size"));
                data.put("table_name", ret.get("table_name"));
                dataList.add(data);
            }
            return dataList;
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {


            if (rs != null) {
                try {
                    rs.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }

            }

            if (conn != null) {
                try {
                    conn.close();
                    ;
                } catch (Exception e) {

                } finally {

                }

            }
        }
        return null;
    }

    public static List<Map> queryAllTableByLink(DataLink link) {
        Connection conn = null;
        DatabaseMetaData dm = null;
        ResultSet rs = null;
        ResultSet rm = null;
        try {
            conn = ConnectionBuilder.openConnection(link);//数据库连接
            dm = conn.getMetaData();
            //rs = dm.getColumns(null, null, null,null);
            rs = dm.getTables(null, null, null, null);


            // return resultSetToList(rs,true);
            List<Map> retList = resultSetToList(rs, true);
            List<Map> dataList = new ArrayList<Map>();
            for (Map ret : retList) {
                Map data = new HashMap();
                data.put("table_cat", ret.get("table_cat"));
                data.put("table_name", ret.get("table_name"));
                data.put("table_type", ret.get("table_type"));
                data.put("remarks", ret.get("remarks"));
                dataList.add(data);
            }
            return dataList;


        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {


            if (rs != null) {
                try {
                    rs.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }

            }

            if (conn != null) {
                try {
                    conn.close();
                } catch (Exception e) {

                } finally {

                }

            }
        }
        return null;
    }

    public String genCreateSql(DataLink dl,Object cls){




        return null;

    }

    public static void main(String[] args) {
        DataLink dl = new DataLink();
        dl.setHost("192.168.1.98");
        dl.setUser("root");
        dl.setName("localhost2");
        dl.setExtString2("3306");
        dl.setPort("3306");
        dl.setPassword("admin123!");
        dl.setDbType("0");
        dl.setDataBaseName("zrzx");
        dl.setUpdateTime(new Date());
        dl.setId(515598634434511623L);
//      System.out.println(queryColumnsByTableAndLink(dl,"ctp_enum"));

        persistCommonVo(dl, dl);

        // System.out.println(JSON.toJSONString(i));
    }

}
