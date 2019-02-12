package com.seeyon.apps.kdXdtzXc.base.mapper.entity;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by taoanping on 14-8-27.
 */
public class MapperEntity {
    private String id;
    private String namespace;
    private Map<String, SqlObj> sqlObjMap = new HashMap<String, SqlObj>();//sysMeetingStates,update,select,delete 映射

    public void clear() {
        id = null;
        namespace = null;

        if (sqlObjMap != null) {
            sqlObjMap.clear();

        }

    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }


    public String getNamespace() {
        return namespace;
    }

    public void setNamespace(String namespace) {
        this.namespace = namespace;
    }


    public Map<String, SqlObj> getSqlObjMap() {
        return sqlObjMap;
    }

    public void setSqlObjMap(Map<String, SqlObj> sqlObjMap) {
        this.sqlObjMap = sqlObjMap;
    }

    public void addSqlObj(Map<String, SqlObj> map) {
        sqlObjMap.putAll(map);
    }


}
