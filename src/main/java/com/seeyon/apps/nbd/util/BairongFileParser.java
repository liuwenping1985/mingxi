package com.seeyon.apps.nbd.util;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.entity.Entity;
import com.seeyon.apps.nbd.core.entity.FieldMeta;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.platform.oa.SubEntityFieldParser;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2018/8/23.
 */
public class BairongFileParser implements SubEntityFieldParser {
    public void parse(CommonParameter inputParameter, Map dataMap, Map inputDataMap, Entity entity) {
        System.out.println("parse---- start-----");
        List<FieldMeta> fieldMetaList = entity.getFields();
        if (CollectionUtils.isEmpty(fieldMetaList)) {
            return;
        }
        System.out.println("parse---- start-----:" + inputDataMap);
        Map subMapOutside = new HashMap();
        for (FieldMeta meta : fieldMetaList) {
            Object data = inputDataMap.get(meta.getSource());
            if ("multi".equals(meta.getType())) {
                if (data instanceof List) {
                    Object sub = dataMap.get("sub");
                    if (sub == null) {
                        sub = new ArrayList<Map>();
                        dataMap.put("sub", sub);
                    }
                    List<Attachment> attList = inputParameter.getAttachmentList();

                    System.out.println("attList:" + attList.isEmpty() + ",attList-size:" + attList.size());
                    if (!CollectionUtils.isEmpty(attList)) {
                      //  List ll = new ArrayList();
                       // Map subMap = new HashMap();
                       // subMap.put("multi","YES");
                        for (Attachment att : attList) {
                            Map subsubMap = new HashMap();
                            subsubMap.put(meta.getName(), att.getSubReference());
                            ((List)sub).add(subsubMap);
                        }
                        //subMap.put("data",ll);
                        //((List)sub).add(subMap);

                    }
                    System.out.println("<<---------sub--map----------->>" + JSON.toJSONString(sub));


                } else {
                    Map subMap = new HashMap();
                    Object sub = dataMap.get("sub");
                    if (sub == null) {
                        sub = new ArrayList<Map>();
                        dataMap.put("sub", sub);
                    }
                    List<Attachment> attList = inputParameter.getAttachmentList();
                    boolean isFound = false;
                    System.out.println("attList-------------------:" + attList.isEmpty() + ",attList-size:" + attList.size());
                    if (!CollectionUtils.isEmpty(attList)) {
                        int tag = 0;
                        for (Attachment att : attList) {
                            System.out.println("att---:" + att.getFilename() + ",att2:" + ((Map) data).get("name"));
                            if ((((Map) data).get("name")).equals(att.getFilename())) {
                                System.out.println("name---------put" + meta.getName() + "," + att.getId());

                                subMap.put(meta.getName(), att.getSubReference());
                                isFound = true;
                                break;
                            }
                        }
                        if (!isFound) {
                            System.out.println("name3-----put" + meta.getName() + "," + attList.get(tag).getId());

                            subMap.put(meta.getName(), attList.get(tag).getSubReference());
                        }
                        tag++;
                    }
                    // subMap.put(meta.getName(),((Map)data).get("name"));
                    System.out.println("<<||||||---------sub--map-----------|||||||>>" + subMap);
                    ((List) sub).add(subMap);
                }

            } else {
                Object sub = dataMap.get("sub");
                if (sub == null) {
                    sub = new ArrayList<Map>();
                    dataMap.put("sub", sub);
                    ((List) sub).add(subMapOutside);

                }
                subMapOutside.put(meta.getName(), data);

            }
        }


    }
}
