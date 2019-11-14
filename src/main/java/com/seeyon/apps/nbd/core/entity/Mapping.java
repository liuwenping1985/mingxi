package com.seeyon.apps.nbd.core.entity;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.duban.util.XmlUtils;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2018/8/22.
 */
public class Mapping {

    private Entity entity;

    private String path;



    public void generateEntity(Class pathHook){
        Entity entity = new Entity();
        this.setEntity(entity);
        if(path != null){
            InputStream ins = pathHook.getResourceAsStream(path);
            try {

                String xmlJson = XmlUtils.xml2jsonString(ins);
                //System.out.println(xmlJson);
                Map mappingMap = JSON.parseObject(xmlJson,HashMap.class);
                Map mappingInner = (Map)mappingMap.get("mapping");
                if(mappingInner == null){
                    return;
                }
                Map entityMap = (Map)mappingInner.get("form");
                gen(entityMap,entity);

                // Map
            } catch (Exception e) {
                e.printStackTrace();
            }

        }
    }

    private void gen(Map entityMap,Entity entity){
        if(entityMap == null){
            return;
        }

        entity.setTable((String)entityMap.get("table"));
        Object originalFieldObject = entityMap.get("originalField");
        if(originalFieldObject!=null){
            List<OriginalField> originalFieldList = new ArrayList<OriginalField>();
            if(originalFieldObject instanceof List){
                //多个
                for(Object obj:(List)originalFieldObject) {
                    OriginalField of = toOriginalField((Map)obj);
                    originalFieldList.add(of);
                }
            }
            if(originalFieldObject instanceof Map){
                OriginalField of = toOriginalField((Map)originalFieldObject);
                originalFieldList.add(of);
            }

            entity.setOriginalFields(originalFieldList);
        }
        Map fieldsObjectRaw = (Map)entityMap.get("fields");
        if(fieldsObjectRaw!=null){
            Object fieldsObject = fieldsObjectRaw.get("field");
            List<FieldMeta> fmList = new ArrayList<FieldMeta>();
            if(fieldsObject instanceof List){
                for(Object obj:(List)fieldsObject) {
                    FieldMeta fm = toFieldMeta((Map)obj);
                    fmList.add(fm);
                }
            }
            if(fieldsObject instanceof Map){
                FieldMeta fm = toFieldMeta((Map)fieldsObject);
                fmList.add(fm);
            }
            entity.setFields(fmList);
            // Object
        }
    }
    private FieldMeta toFieldMeta(Map data){
        FieldMeta fm = JSON.parseObject(JSON.toJSONString(data),FieldMeta.class);

        return fm;

    }
    private OriginalField toOriginalField(Map data){
        OriginalField of = JSON.parseObject(JSON.toJSONString(data),OriginalField.class);

        Map childEntityMap = (Map)data.get("form");
        if(childEntityMap!=null){
            Entity childEntity = new Entity();
            of.setEntity(childEntity);
            childEntity.setRefParentField((String)childEntityMap.get("refParentField"));
            gen(childEntityMap,childEntity);
        }
        return of;
    }

    public Entity getEntity() {
        return entity;
    }

    public void setEntity(Entity entity) {
        this.entity = entity;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }
}
