package com.seeyon.apps.kdXdtzXc.base.util;

import com.seeyon.apps.kdXdtzXc.KimdeConstant;
import com.seeyon.apps.kdXdtzXc.base.mapper.MapperManager;
import com.seeyon.apps.kdXdtzXc.base.mapper.entity.MapperEntity;
import com.seeyon.apps.kdXdtzXc.base.mapper.entity.SqlObj;
import com.seeyon.apps.kdXdtzXc.base.model.Field;
import com.seeyon.apps.kdXdtzXc.base.model.Table;
import com.seeyon.ctp.common.AppContext;

import java.util.List;
import java.util.Map;

/**
 * Created by taoan on 2016-7-25.
 */
public class SqlUtil {

    private static FormMainTable formMainTable = (FormMainTable) AppContext.getBean(KimdeConstant.FORM_MAIN_TABLE);
    private static MapperManager mapperManager = (MapperManager) AppContext.getBean(KimdeConstant.MAPPER_MANAGER);


    public static String getFilterSql(String xmlId, String sqlId) {
        return getSqlStr(xmlId, sqlId);
    }

    public static String getFilterSql(String xmlId, String sqlId, String className) throws Exception {
        String sqltemp = getSqlStr(xmlId, sqlId);
        String sql = getFilterSqlByClassName(sqltemp, className);
        if (!sqlId.contains("NoSql")) {
            System.out.println(sql);
        }
        return sql;
    }


    public static Table getTable(String className) throws Exception {

        String tableName = "";
        Map<String, String> mp = formMainTable.getModelsClassTableNameMap();


        tableName = mp.get(className);
        if (StringUtilsExt.isNullOrNone(tableName)) {
            throw new Exception("className=" + className + "未查询到对应的tableName" + tableName + "。" + (mp.toString()));
        }

        try {
            Map<String, Table> tableMap = formMainTable.getClassNameTablesMap();
            Table table = tableMap.get(className);
            return table;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private static String getFilterSqlByClassName(String sql, String className) throws Exception {
        if (StringUtilsExt.isNullOrNone(sql)) {
            throw new Exception("sql不能为null");
        }
        String wfn = "${" + className + "}";
        String tableName = "";
        Map<String, String> mp = formMainTable.getModelsClassTableNameMap();


        tableName = mp.get(className);
        if (StringUtilsExt.isNullOrNone(tableName)) {
            throw new Exception("className=" + className + "未查询到对应的tableName" + tableName + "。" + (mp.toString()));
        }

        String s = sql.replace(wfn, tableName);
        try {
            Map<String, Table> tableMap = formMainTable.getClassNameTablesMap();
            Table table = tableMap.get(className);
            List<Field> fields = table.getFieldList();
            for (int i = fields.size(); i > 0; i--) {
                Field f = fields.get(i - 1);
                s = s.replace("[" + f.getDisplay() + "]", f.getName());
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return s;
    }


    /**
     * 得到sql语句字符串
     *
     * @param xmlId
     * @param sqlId
     * @return
     */
    private static String getSqlStr(String xmlId, String sqlId) {
        StringBuffer sb = new StringBuffer("mapperEntityMap具有的ID=");
        try {
            Map<String, MapperEntity> mapperEntityMap = mapperManager.getMapperEntityMap();
            for (String s : mapperEntityMap.keySet()) {
                sb.append(s + ",");
            }
//            System.out.println(sb.toString());
//            System.out.println("需要查询的XMLID=" + xmlId + ",SQLID=" + sqlId);

            MapperEntity mapperEntity = mapperEntityMap.get(xmlId);
            if (mapperEntity == null) {
                throw new Exception("出现严重故障，" + "需要查询的XMLID=" + xmlId + "在系统中没有找到！");
            }
            Map<String, SqlObj> sqlObjMap = mapperEntity.getSqlObjMap();

            SqlObj sqlObj = sqlObjMap.get(sqlId);
            if (sqlObj == null) {
                throw new Exception("出现严重故障，" + "XMLID=" + xmlId + "中的“" + sqlId + "对象未找到," + sqlObjMap.toString());
            }
            String sql = sqlObj.getSqlStr();

            if (StringUtilsExt.isNullOrNone(sql)) {
                throw new Exception("出现严重故障，" + "XMLID=" + xmlId + "中的“" + sqlId + "”在系统中没有找到！");

            }
            return sql;
        } catch (Exception e) {
            System.out.println("正在处理XMLID=" + xmlId + ",SQLID=" + sqlId + "出现故障");
            System.out.println("mapperEntityMap信息=" + sb.toString());

            e.printStackTrace();
        }
        return null;
    }
}
