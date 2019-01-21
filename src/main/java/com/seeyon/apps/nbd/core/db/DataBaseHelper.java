package com.seeyon.apps.nbd.core.db;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.annotation.ClobText;
import com.seeyon.apps.nbd.annotation.DBIgnore;
import com.seeyon.apps.nbd.core.config.ConfigService;
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
 * 初步实现一个结合mybatis和hibernate优点的简单DB访问框架
 * 规划功能
 * 1、自动生成建表语句
 * 2、自动生成update语句（智能化，有值更新和全量更新）
 * 3、自动生成insert语句
 * 4、简单的orm（用约定代替配置）
 * 5、各种数据库管理小工具
 * 6、完善的日志
 * 7、方便的适配外部数据库和内部数据库的数据通道
 * 8、加强底层jdbc的理解，复习一下
 * 9、广义数据传输的一部分-http-db-ws 构成闭环
 * 10、规则引擎的设计思想要引入进来
 *
 * 现阶段的实现的是个最最low的版本，连接池没有，日志没有 工具也没有的3无产品
 * 下一步：针对每个连接的连接池的管理，初步拷贝实现一个hibernate的1级缓存
 *       mybatis的定制化sql用注解来实现
 *
 * Created by liuwenping on 2018/9/9.
 */
public final class DataBaseHelper {

    public static List<Map> executeQueryByNativeSQL(String sql) throws Exception {
        JDBCAgent jdbc = new JDBCAgent();
        try {
            jdbc.execute(sql.toString());
            //jdbc.
            List<Map> list = jdbc.resultSetToList();
            return list;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            jdbc.close();
        }
        return new ArrayList<Map>();

    }

    public static Integer executeByConnectionAndVals(Connection conn,String sql,List vals){
        PreparedStatement pst = null;
        try {


            pst = conn.prepareStatement(sql);
            for (int i = 1; i <= vals.size(); i++) {
                pst.setObject(i, vals.get(i - 1));
            }
            return pst.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();

        }finally {
            if (pst != null) {
                try {
                    pst.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        return 0;
    }


    public static Integer executeUpdateByNativeSQLAndLink(DataLink link, String sql, List vals) throws Exception {

        Connection conn = null;
        PreparedStatement pst = null;

        try {

            conn = ConnectionBuilder.openConnection(link);
            pst = conn.prepareStatement(sql);
            for (int i = 1; i <= vals.size(); i++) {
                pst.setObject(i, vals.get(i - 1));
            }
            return pst.executeUpdate();
        } catch (Exception e) {
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
        return 0;


    }

    private static Integer executeUpdateBySQLAndLink(DataLink link, String sql, List<Field> fields, List vals) {
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = ConnectionBuilder.openConnection(link);
            pst = conn.prepareStatement(sql);

            for (int i = 0; i < fields.size(); i++) {

                Field f = fields.get(i);
                Class cls = f.getType();
                Object val = vals.get(i);
                //System.out.println("--------------------");
                ClobText t = f.getAnnotation(ClobText.class);
                if (t != null) {
                    Clob clob = conn.createClob();
                    clob.setString(1, String.valueOf(val));
                    pst.setClob(i + 1, clob);
                } else {

                    if (cls == Date.class || cls == Timestamp.class) {
                        if (val instanceof Date) {
                            Timestamp timestamp = new Timestamp(((Date) val).getTime());
                            pst.setObject(i + 1, timestamp);
                        } else if (val instanceof String) {
                            try {
                                Date dt = new Date(String.valueOf(val));
                                pst.setObject(i + 1, new Timestamp(dt.getTime()));
                            } catch (Exception e) {
                                pst.setObject(i + 1, new Timestamp(new Date().getTime()));
                            }

                        } else {
                            pst.setObject(i + 1, new Timestamp(new Date().getTime()));
                        }


                    } else {
                        //System.out.println(cls+","+val+","+(i+1));
                        pst.setObject(i + 1, val);
                    }

                }

            }
            return pst.executeUpdate();

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        } catch (Error e) {
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
        return 0;
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

    /**
     * 简单的orm
     * @param dl
     * @param cls
     * @param sql
     * @param <T>
     * @return
     */
    public static <T> List<T> executeObjectQueryBySQLAndLink(DataLink dl, Class<T> cls, String sql) {
        List<Map> retMapList = executeQueryBySQLAndLink(dl, sql);
        if (CommonUtils.isEmpty(retMapList)) {
            return new ArrayList<T>();
        }
        List<T> retList = new ArrayList<T>();
        for (Map map : retMapList) {
            Map extendMap = new HashMap();
            for (Object key : map.keySet()) {
                String newKey = CommonUtils.underlineToCamel(String.valueOf(key));
                extendMap.put(newKey, map.get(key));
            }

            // map.putAll(extendMap);
            // System.out.println(extendMap);
            //最简单的orm了吧 艹，效率低了一点
            String json = JSON.toJSONString(extendMap);
            //System.out.println(json);
            try {
                T t = JSON.parseObject(json, cls);
                retList.add(t);
            } catch (Exception e) {
                e.printStackTrace();
                continue;
            }


        }
        return retList;
    }

    public static String getTableName(Class cls) {
        String name = cls.getSimpleName();
        return CommonUtils.camelToUnderline(name);
    }

    public static String genSelectAllSQL(Class cls) {

        String name = getTableName(cls);
        String sql = "select * from " + name;

        return sql;

    }

    public static <T> T getDataByTypeAndId(DataLink dl, Class<T> cls, Long id) {

        String sql = "select * from " + getTableName(cls) + " where id=" + id;
        List<T> dataMap = executeObjectQueryBySQLAndLink(dl, cls, sql);
        if (CommonUtils.isEmpty(dataMap)) {
            return null;
        }
        return dataMap.get(0);
    }

    public static <T> Integer deleteByTypeAndId(DataLink dl, Class<T> cls, Long id) {
        String sql = "delete from " + getTableName(cls) + " where id=" + id;
        return executeUpdateBySQLAndLink(dl, sql);

    }

    public static List<Map> executeQueryBySQLAndLink(DataLink link, String sql) {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            conn = ConnectionBuilder.openConnection(link);
            pst = conn.prepareStatement(sql, 1004, 1007);
            //System.out.println(sql);
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
        tbName = tbName.replaceAll("\"", "");
        // System.out.println(tbName);
        String path = ScriptHook.class.getResource(dbType + File.separator + tbName + ".sql").getPath();

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
            tableName = tableName.replaceAll("\"", "");
            conn = ConnectionBuilder.openConnection(link);

            rs = conn.getMetaData().getTables(null, null, tableName.toUpperCase(), null);
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
            //e.printStackTrace();
        } catch (Exception e) {
            // e.printStackTrace();
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

        String tbName = getTableName(obj.getClass());//CommonUtils.camelToUnderline(obj.getClass().getSimpleName());
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
            Object tempId = filledValues(dl, root, obj, values, fieldNames, insFields);
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
                //判断一下是更新还是新增
                String countSql = "select count(id) as c_count from " + tbName + " where id=" + id;
                List<Map> existData = executeQueryBySQLAndLink(dl, countSql);
                //System.out.println(existData);
                if (!CommonUtils.isEmpty(existData)) {

                    Object count = existData.get(0).get("c_count");
                    if (count != null) {
                        if (Integer.parseInt(String.valueOf(count)) > 0) {
                            isUpdate = true;
                        } else {
                            isUpdate = false;
                        }
                    } else {
                        isUpdate = false;
                    }
                } else {
                    isUpdate = false;

                }
            }
            if (isUpdate) {

                stb.append("UPDATE " + tbName);
                stb.append(" SET ");
                List<String> sqlSequections = toUpdateSQLString(dl, insFields, fieldNames, values);
                if (CommonUtils.isEmpty(sqlSequections)) {
                    return;
                }
                stb.append(join(sqlSequections, ","));
                stb.append(" WHERE id=" + id);
                System.out.println(stb);
                executeUpdateBySQLAndLink(dl, stb.toString(), insFields, values);

//                else {
//                    stb.append("UPDATE " + tbName);
//                    stb.append(" SET ");
//                    List<String> sqlSequections = toUpdateSQLString(dl, insFields, fieldNames, values);
//                    if (CommonUtils.isEmpty(sqlSequections)) {
//                        return;
//                    }
//                    stb.append(join(sqlSequections, ","));
//
//                    stb.append(" WHERE id=" + id);
//                    System.out.println(stb);
//                    executeUpdateBySQLAndLink(dl, stb.toString());
//
//                }

            } else {
//                if ("1".equals(dl.getDbType())) {
                stb.append("INSERT INTO " + tbName);
                //List<String> sqlValueList = toInsertSQLString( dl,insFields, values,true);
                // createTableIfNotExist(tbName, dl);
                //String vals = join(sqlValueList, ",");
                String fils = join(fieldNames, ",");
                stb.append("(").append(fils).append(")");//fils+
                stb.append("VALUES");
                stb.append("(").append(join(genChars("?", fieldNames.size()), ",")).append(")");
                System.out.println(stb);
                executeUpdateBySQLAndLink(dl, stb.toString(), insFields, values);
//                } else {
//                    stb.append("INSERT INTO " + tbName);
//                    List<String> sqlValueList = toInsertSQLString(dl, insFields, values, false);
//                    createTableIfNotExist(tbName, dl);
//                    String vals = join(sqlValueList, ",");
//                    String fils = join(fieldNames, ",");
//                    stb.append("(").append(fils).append(")");//fils+
//                    stb.append("VALUES");
//                    stb.append("(").append(vals).append(")");
//                    System.out.println(stb);
//                    executeUpdateBySQLAndLink(dl, stb.toString());
//                }

            }


        }

    }

    private static List<String> genChars(String charToken, int size) {
        List<String> retList = new ArrayList<String>(size);
        for (int i = 0; i < size; i++) {
            retList.add(charToken);
        }
        return retList;

    }

    private static Object filledValues(DataLink dl, Class cls, Object obj, List<Object> values, List<String> fieldNames, List<Field> insFields) {

        Field[] fields = cls.getDeclaredFields();
        Object id = null;
        for (Field fd : fields) {
            DBIgnore dbIgnore = fd.getAnnotation(DBIgnore.class);
            if(dbIgnore!=null){
                continue;
            }
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

    /**
     * 写的有点啰嗦
     * @param dl
     * @param insFields
     * @param fieldNames
     * @param dataList
     * @return
     */
    private static List<String> toUpdateSQLString(DataLink dl, List<Field> insFields, List<String> fieldNames, List dataList) {
        List<String> updateData = new ArrayList<String>();
        if (CommonUtils.isEmpty(insFields) || CommonUtils.isEmpty(dataList)) {
            throw new RuntimeException("Can not execute insert: field or values is empty");
        }
        if (insFields.size() != dataList.size()) {
            throw new RuntimeException("Can not execute insert: field length not equal values");
        }

        int len = insFields.size();
        int idIndex = -1;
        for (int i = 0; i < len; i++) {
            Field fd = insFields.get(i);
            DBIgnore dbIgnore = fd.getAnnotation(DBIgnore.class);
            if(dbIgnore!=null){
                continue;
            }
            Class type = fd.getType();
            Object val = dataList.get(i);
            if (val == null) {
                throw new RuntimeException("Error:null value is not permitted!!");
            }
            //这里的id跳戏了
            if ("id".equals(fieldNames.get(i))) {
                idIndex = i;
                continue;
            }
            updateData.add(fieldNames.get(i) + "=" + "?");
//            if ("1".equals(dl.getDbType())) {
//                updateData.add(fieldNames.get(i) + "=" + "?");
//            } else {
//                updateData.add(fieldNames.get(i) + "=" + trans2SqlString(dl, type, val, false));
//            }

        }
        //dataList 删除id
        if(idIndex>=0){
            int tag =0;
            Iterator it = dataList.iterator();
            while(it.hasNext()){
                Object obj = it.next();
                if(idIndex==tag){
                    System.out.println("remove id="+idIndex+" and value is "+obj);
                    it.remove();
                    break;
                }
                tag++;
            }
            Iterator fit = insFields.iterator();
            tag=0;
            while(fit.hasNext()){
                Object obj = fit.next();
                if(idIndex==tag){
                    System.out.println("remove id="+idIndex+" and value is "+obj);
                    fit.remove();
                    break;
                }
                tag++;
            }
        }

        return updateData;

    }


    private static List<String> toInsertSQLString(DataLink dl, List<Field> insFields, List dataList, boolean pst) {
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
            data.add(trans2SqlString(dl, type, val, pst));

        }
        return data;

    }

    private static String trans2SqlString(DataLink dl, Class type, Object val, boolean pst) {
        if (type == Boolean.class) {

            if (Boolean.FALSE.equals(val)) {
                return "0";
            } else {
                return "1";
            }
        } else if (Date.class == type || Timestamp.class == type) {
            if ("1".equals(dl.getDbType())) {
                //to_date('2011-2-28 15:42:56','yyyy-mm-dd hh24:mi:ss')
                return "to_date('" + CommonUtils.formatDate((Date) val) + "','yyyy-mm-dd hh24:mi:ss')";
            }
            return "'" + CommonUtils.formatDate((Date) val) + "'";
        } else {
            if (Long.class == type || Float.class == type || Integer.class == type || Double.class == type) {
                return String.valueOf(val);
            } else if (String.class == type) {
                if (pst) {
                    return (String) val;
                } else {
                    return "'" + val + "'";
                }

            } else {
                if (pst) {
                    return JSON.toJSONString(val);
                } else {
                    return "'" + JSON.toJSONString(val) + "'";
                }

            }

        }


    }

    public static String join(List list, String token) {
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

    //反编译的 懒得自己写了
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
                        //System.out.println(columnName+":"+rsmd.getColumnType(j));
                        Object value;
                        if (rsmd.getColumnType(j) == 93) {
                            value = rs.getTimestamp(columnName);
                        } else if (rsmd.getColumnType(j) == 2005 || rsmd.getColumnType(j) == 2011) {
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
            if("1".equals(link.getDbType())){
                rs = dm.getColumns(null, null, table.toUpperCase(), null);

            }else{
                rs = dm.getColumns(null, null, table, null);

            }

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

    public String genCreateSql(DataLink dl, Object cls) {


        return null;

    }

    public static void main(String[] args) {
        DataLink dl = new DataLink();
        dl.setHost("192.168.1.98");
        dl.setUserName("root");
        dl.setName("localhost2");
        dl.setExtString2("3306");
        dl.setPort("3306");
        dl.setPassword("admin123!");
        dl.setDbType("1");
        dl.setDataBaseName("zrzx");
        dl.setUpdateTime(new Date());
        dl.setId(515598634434511623L);

        getCreateTableScript("data_link", dl);
//      System.out.println(queryColumnsByTableAndLink(dl,"ctp_enum"));
//        String json="{\"extString2\":\"3306\",\"dbType\":\"0\",\"updateTime\":1543900217000,\"password\":\"admin123!\",\"createTime\":1543831990000,\"port\":\"3306\",\"name\":\"localhost2\",\"host\":\"192.168.1.98\",\"id\":515598634434511623,\"dataBaseName\":\"zrzx\",\"user\":\"root\",\"status\":0}";
//       // persistCommonVo(dl, dl);
//        DataLink link = JSON.parseObject(json,DataLink.class);
//         System.out.println(dl instanceof CommonPo);
    }


}
