package com.seeyon.apps.kdXdtzXc.base.mapper;




import com.seeyon.apps.kdXdtzXc.base.mapper.baseenum.SqlType;
import com.seeyon.apps.kdXdtzXc.base.mapper.entity.MapperEntity;
import com.seeyon.apps.kdXdtzXc.base.mapper.entity.SqlObj;
import com.seeyon.apps.kdXdtzXc.base.util.ToolkitUtil;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by taoanping on 14-8-27.
 */
public class MapperManager {
    private static Log log = LogFactory.getLog(MapperManager.class);

    private List<String> mapperxml = new ArrayList<String>();

    private Map<String, MapperEntity> mapperEntityMap = null;

    public Map<String, MapperEntity> getMapperEntityMap() {
        return mapperEntityMap;
    }

    public MapperManager() {

    }


    /**
     * 读取所有的*.map.xml配置文件
     *
     * @return
     * @throws Exception
     */

    public void init() throws Exception {
        mapperEntityMap = new HashMap<String, MapperEntity>();
        for (String mapxml : mapperxml) {
            MapperEntity mapperEntity = new MapperEntity();
            File file = new File(MapperManager.class.getResource("/").getPath() + mapxml);
            SAXReader reader = new SAXReader();
            Document doc = reader.read(file);
            Element root = doc.getRootElement();

            String id = root.attributeValue("id");
            String namespace = root.attributeValue("namespace");
            mapperEntity.setId(id);
            mapperEntity.setNamespace(namespace);
            System.out.println("载入XML文件ID=" + id + ",NAMESPACE=" + namespace);

            mapperEntity.addSqlObj(parseSql(root.elements("select"), SqlType.SELECT));
            mapperEntity.addSqlObj(parseSql(root.elements("insert"), SqlType.INSERT));
            mapperEntity.addSqlObj(parseSql(root.elements("update"), SqlType.UPDATE));
            mapperEntity.addSqlObj(parseSql(root.elements("delete"), SqlType.DELETE));

            mapperEntityMap.put(id, mapperEntity);

        }


    }


    private Map<String, SqlObj> parseSql(List<Element> sqlElements, SqlType sqlType) {
        Map<String, SqlObj> map = new HashMap<String, SqlObj>();
        System.out.println("     " + sqlType + "语句数量=" + sqlElements.size());
        if (sqlElements == null || sqlElements.size() == 0) {
            return map;
        }
        for (Element element : sqlElements) {
            SqlObj sqlObj = new SqlObj();
            String sqlId = element.attributeValue("id");
            if (ToolkitUtil.isNull(sqlId))
                continue;

            String sqlText = element.getText();
            if (!ToolkitUtil.isNull(sqlText)) {
//                System.out.println("    载入sql语句ID=" + sqlId);

                sqlObj.setId(sqlId);
                sqlObj.setSqlStr(sqlText);
                sqlObj.setSqlType(sqlType);
                System.out.println("         载入sql=" + sqlType + "," + sqlId);
                map.put(sqlId, sqlObj);
            }
        }
        return map;

    }


    public void setMapperxml(List<String> mapperxml) {
        this.mapperxml = mapperxml;
    }
}
