package com.seeyon.apps.nbd.util;

import com.seeyon.apps.nbd.core.entity.Entity;
import com.seeyon.apps.nbd.core.entity.FieldMeta;
import com.seeyon.apps.nbd.platform.oa.SubEntityFieldParser;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2018/8/23.
 */
public class BairongFileParser implements SubEntityFieldParser {
    public void parse(Map dataMap, Map inputDataMap, Entity entity) {

        List<FieldMeta> fieldMetaList = entity.getFields();
        if(CollectionUtils.isEmpty(fieldMetaList)){
            return;
        }
        Map subMapOutside = new HashMap();
        for(FieldMeta meta:fieldMetaList){
            Object data = inputDataMap.get(meta.getSource());
            if("multi".equals(meta.getType())){
                if(data instanceof List){

                    List dataList = (List)data;
                    Object sub = dataMap.get("sub");
                    if(sub == null){
                        sub = new ArrayList<Map>();
                        dataMap.put("sub",sub);
                    }
                    for(Object obj:dataList){
                        Map subMap = new HashMap();
                        subMap.put(meta.getName(),((Map)obj).get("name"));
                        ((List)sub).add(subMap);
                    }


                }else{
                    Map subMap = new HashMap();
                    Object sub = dataMap.get("sub");
                    if(sub == null){
                        sub = new ArrayList<Map>();
                        dataMap.put("sub",sub);
                    }
                    subMap.put(meta.getName(),((Map)data).get("name"));
                    ((List)sub).add(subMap);
                }

            }else{
                Object sub = dataMap.get("sub");
                if(sub == null){
                    sub = new ArrayList<Map>();
                    dataMap.put("sub",sub);
                    ((List)sub).add(subMapOutside);

                }
                subMapOutside.put(meta.getName(),data);

            }
        }



    }
}
