package com.seeyon.apps.nbd.core.service.impl;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.form.entity.FormField;
import com.seeyon.apps.nbd.core.form.entity.FormTable;
import com.seeyon.apps.nbd.core.form.entity.FormTableDefinition;
import com.seeyon.apps.nbd.core.service.MappingServiceManager;
import com.seeyon.apps.nbd.core.util.CommonUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2018/9/7.
 */
public class MappingServiceManagerImpl implements MappingServiceManager {
    public FormTableDefinition parseFormTableMapping(Map data) {

        Map tableList = (Map) data.get("TableList");
        if (CommonUtils.isEmpty(tableList)) {
            return null;
        }
        FormTableDefinition definition = JSON.parseObject(JSON.toJSONString(tableList), FormTableDefinition.class);
        List<Map> tables = (List<Map>) tableList.get("Table");
        if (CommonUtils.isEmpty(tables)) {
            return null;
        }

        //Map<String,>
        //分别解析各个table，然后组装关联关系
        List<FormTable> slaveTableList = new ArrayList<FormTable>();
        for (Map table : tables) {
            String jString = JSON.toJSONString(table);
           // System.out.println(table);
            FormTable ft = JSON.parseObject(jString, FormTable.class);
            Map fieldList = (Map) table.get("FieldList");
            if (!CommonUtils.isEmpty(fieldList)) {
                List<Map> fields = (List<Map>) fieldList.get("Field");
                if (!CommonUtils.isEmpty(fields)) {
                    for (Map field : fields) {
                        String fdJson = JSON.toJSONString(field);
                        FormField ff = JSON.parseObject(fdJson, FormField.class);
                        ft.addFieldList(ff);
                    }
                }
            }
            if ("slave".equals(ft.getTabletype())) {
                slaveTableList.add(ft);
            } else {
                ft.setSlaveTableList(slaveTableList);
                definition.setFormTable(ft);
            }
        }
        return definition;
    }
}
