package com.seeyon.apps.nbd.plugin.bairong.config;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.entity.Mapping;
import com.seeyon.apps.nbd.core.entity.ServiceAffair;
import com.seeyon.apps.nbd.core.entity.ServiceAffairs;
import com.seeyon.apps.nbd.core.entity.ServiceConfigMain;
import com.seeyon.apps.nbd.core.service.ServiceHolder;
import com.seeyon.apps.nbd.core.service.ServicePlugin;
import com.seeyon.apps.nbd.core.util.XmlUtils;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.plugin.bairong.service.BairongService;
import org.json.JSONException;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2018/8/21.
 */
public class ServiceApplicationConfig {

    public ServiceApplicationConfig(){

        this.init();

    }
    private ServiceConfigMain cfm;
    private void init(){
        InputStream ins = this.getClass().getResourceAsStream("service.xml");
        String xml = null;
        try {
            xml = XmlUtils.xml2jsonString(ins);
        } catch (Exception e) {
            e.printStackTrace();
            return;
        }
        ServiceConfigMain configMain = this.parseServiceConfigMain(JSON.parseObject(xml,HashMap.class));
        this.cfm = configMain;
        BairongService service = new  BairongService(configMain);
        ServiceHolder.addServicePlugin(service);
    }

    public static void main(String[] args) throws IOException, JSONException {
        ServiceApplicationConfig config = new ServiceApplicationConfig();
       // ServicePlugin sp = ServiceHolder.getService("HT");
        ServiceAffair sa = config.cfm.getAffairsList().get(0).getAffairHolder().get("receive");
        String test1 = JSON.toJSONString(sa.getMaping().getEntity().getOriginalFields());
        // ServiceConfigMain configMain = config.parseServiceConfigMain(JSON.parseObject(xml,HashMap.class));
       System.out.println(test1);
    }


    private ServiceConfigMain parseServiceConfigMain(Map data){
        System.out.println(data);
        ServiceConfigMain config = new ServiceConfigMain();
        if(data == null){
            return config;
        }
        Map<String,Object> serviceMap = (Map)data.get("service");
      //  System.out.println(serviceMap);
        if(serviceMap == null){
            return config;
        }
        config.setName((String)serviceMap.get("name"));
        config.setId((String)serviceMap.get("id"));
        Map affairsMap = (Map)serviceMap.get("service-aspects");
       // System.out.println(affairsMap);
        if(affairsMap == null){
            return config;
        }

        //ServiceAffairs affairs = new ServiceAffairs();
        List<Map> affairs = (List)affairsMap.get("affairs");
        if(affairs == null){
            return config;
        }
        for(Map affs:affairs){
            ServiceAffairs sas = new ServiceAffairs();
            String name = (String)affs.get("name");
            sas.setName(name);
            Map<String,ServiceAffair> affairHolder = new HashMap<String, ServiceAffair>();
            sas.setAffairHolder(affairHolder);
            List<Map> affairList = (List)affs.get("affair");

            if(affairList!=null){
                for(Map afMap:affairList){
                    ServiceAffair sa = new ServiceAffair();
                    String formTempleteCode = (String)afMap.get("formTempleteCode");
                    String type = (String)afMap.get("type");
                    sa.setFormTempleteCode(formTempleteCode);
                    sa.setType(type);

                    Map mapping = (Map)afMap.get("mapping");
                    //System.out.println(afMap);
                    sas.getAffairHolder().put(type,sa);
                    if(mapping==null){
                        continue;
                    }
                    Mapping mpp = new Mapping();
                    sa.setMaping(mpp);
                    String path = (String)mapping.get("path");
                    mpp.setPath(path);
                    mpp.generateEntity(this.getClass());
                }

            }
            config.getAffairsList().add(sas);

        }
        return config;
    }

    private Mapping parseMapping(String jsonString){
        return null;
    }
}
