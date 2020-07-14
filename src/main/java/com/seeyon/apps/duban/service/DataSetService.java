package com.seeyon.apps.duban.service;

import com.seeyon.apps.duban.po.DubanConfigItem;
import com.seeyon.ctp.util.DBAgent;
import org.springframework.util.CollectionUtils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2019/11/7.
 */

public class DataSetService {


    private static DataSetService dataSetService;


    private Map<String, DubanConfigItem> configItemMap = new HashMap<String, DubanConfigItem>();

    public static  DataSetService getInstance() {

        if (dataSetService == null) {

            dataSetService = new DataSetService();

        }

        return dataSetService;

    }

    public DubanConfigItem getDubanConfigItem(String enumnId){

        if(configItemMap.isEmpty()){
            synchronized (configItemMap){

                List<DubanConfigItem> itemList = DBAgent.find("from DubanConfigItem");

                if(!CollectionUtils.isEmpty(itemList)){
                    for(DubanConfigItem item:itemList){
                        configItemMap.put(String.valueOf(item.getEnumId()),item);
                    }
                }
            }
        }

        return configItemMap.get(enumnId);
    }
}
