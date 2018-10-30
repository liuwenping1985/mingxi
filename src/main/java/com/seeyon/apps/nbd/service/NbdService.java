package com.seeyon.apps.nbd.service;

import com.seeyon.apps.nbd.core.db.DataBaseHandler;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.core.vo.NbdResponseEntity;
import com.seeyon.apps.nbd.vo.CommonVo;
import com.seeyon.apps.nbd.vo.Test;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * Created by liuwenping on 2018/10/29.
 */
public class NbdService {

    private DataBaseHandler handler = DataBaseHandler.getInstance();

    public NbdResponseEntity postAdd(CommonParameter p) {
        NbdResponseEntity entity = preProcess(p);
        if (!entity.isResult()) {
            return entity;
        }
        String type = p.$("type");
        handler.createNewDataBaseByNameIfNotExist(type);
        CommonVo cVo = TransferService.getInstance().transData(type, p);
        if (cVo == null) {
            entity.setResult(false);
            entity.setMsg(" data transfer error");
        } else {
            cVo.setId(UUID.randomUUID().toString());
            handler.putData(type, cVo.getId(), cVo);
            entity.setData(cVo);
        }

        return entity;
    }

    public NbdResponseEntity postUpdate(CommonParameter p) {
        NbdResponseEntity entity = preProcess(p);
        String type = p.$("type");
        CommonVo cVo = TransferService.getInstance().transData(type, p);
        Class cls = TransferService.getInstance().getTransferClass(type);
        CommonVo vo2 = (CommonVo) handler.getDataByKeyAndClassType(type, cVo.getId(), cls);
        vo2 = CommonUtils.copyProIfNotNullReturnSource(vo2, cVo);
        handler.putData(type, vo2.getId(), vo2);
        entity.setData(vo2);
        entity.setResult(true);
        return entity;
    }

    public NbdResponseEntity postDelete(CommonParameter p) {
        NbdResponseEntity entity = preProcess(p);
        String type = p.$("type");
        String id = p.$("id");
        if (CommonUtils.isEmpty(id)) {
            entity.setResult(false);
            entity.setMsg("id not present!");
            return entity;
        }
        Object data = handler.removeDataByKey(type, id);
        if (data != null) {
            entity.setData(data);
            entity.setResult(true);
        }else{
            entity.setResult(false);
            entity.setData(id);
        }
        return entity;
    }

    public NbdResponseEntity getDataList(CommonParameter p){
        NbdResponseEntity entity = preProcess(p);
        String type = p.$("type");
        Map map = handler.getDataAll(type);
        List dataList = new ArrayList();
        if(map == null){
            entity.setItems(new ArrayList());
        }else{
            dataList.addAll(map.values());
            entity.setItems(dataList);
        }
        return entity;
    }

    private NbdResponseEntity preProcess(CommonParameter cp) {
        NbdResponseEntity entity = new NbdResponseEntity();
        entity.setResult(true);
        String type = cp.$("data_type");
        if (CommonUtils.isEmpty(type)) {
            entity.setResult(false);
            entity.setMsg("unknown data_type");
            entity.setData(cp);
        }
        return entity;
    }


    public static void main(String[] args) {
        NbdService nbds = new NbdService();
        CommonParameter p = new CommonParameter();
        p.$("type", 123);
        p.$("type2", "66we");
        p.$("data_type", "3474646");

        nbds.handler.createNewDataBaseByNameIfNotExist("test");


//        String json = JSON.toJSONString(p);
        // Test t = JSON.parseObject(json,Test.class);
        Test t = (Test) nbds.handler.getDataByKeyAndClassType("test", "123", Test.class);
        System.out.println(t.getType());
    }
}
