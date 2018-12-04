package com.seeyon.apps.nbd.service;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.constant.NbdConstant;
import com.seeyon.apps.nbd.core.config.ConfigService;
import com.seeyon.apps.nbd.core.db.DataBaseHandler;
import com.seeyon.apps.nbd.core.db.DataBaseHelper;
import com.seeyon.apps.nbd.core.db.link.ConnectionBuilder;
import com.seeyon.apps.nbd.core.form.entity.FormTable;
import com.seeyon.apps.nbd.core.form.entity.FormTableDefinition;
import com.seeyon.apps.nbd.core.service.MappingServiceManager;
import com.seeyon.apps.nbd.core.service.impl.MappingServiceManagerImpl;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.core.util.XmlUtils;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.core.vo.NbdResponseEntity;
import com.seeyon.apps.nbd.po.*;
import com.seeyon.apps.nbd.vo.*;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.UUIDLong;

import java.util.*;

/**
 * Created by liuwenping on 2018/10/29.
 */
public class NbdService {

    private DataBaseHandler handler = DataBaseHandler.getInstance();
    private MappingServiceManager mappingServiceManager = new MappingServiceManagerImpl();
    private TransferService transferService = TransferService.getInstance();
    public NbdResponseEntity postAdd(CommonParameter p) {
        System.out.println(p);
        NbdResponseEntity entity = preProcess(p);
        if (!entity.isResult()) {
            return entity;
        }
        String type = p.$("data_type");
        handler.createNewDataBaseByNameIfNotExist(type);
        CommonPo cVo = transferService.transData(type, p);
        if (cVo == null) {
            entity.setResult(false);
            entity.setMsg(" data transfer error");
        } else {
            cVo.setId(UUIDLong.longUUID());
            p.$("id",cVo.getId());
            handler.putData(type, ""+cVo.getId(), cVo);
            if(NbdConstant.A8_TO_OTHER.equals(type)){
                FormTableDefinition ftd = mappingServiceManager.saveFormTableDefinition(p);
                if(entity.getData() instanceof A8ToOtherConfigEntity){
                    A8ToOtherConfigEntity a8ToOtherConfigEntity =  (A8ToOtherConfigEntity)entity.getData();
                    Ftd ftdEntity = new Ftd();
                   // ftdEntity
                    //a8ToOtherConfigEntity.setFtd(ftd);
                }
            }
            if(NbdConstant.OTHER_TO_A8.equals(type)){
                FormTableDefinition ftd = mappingServiceManager.saveFormTableDefinition(p);
                if(entity.getData() instanceof OtherToA8ConfigEntity){
                    OtherToA8ConfigEntity otherToA8 =  (OtherToA8ConfigEntity)entity.getData();
                   // otherToA8.setFtd(ftd);
                }
            }

            entity.setData(cVo);
        }

        return entity;
    }

    public NbdResponseEntity postUpdate(CommonParameter p) {
        NbdResponseEntity entity = preProcess(p);
        String type = p.$("data_type");
        System.out.println("post--->>>>" + p.$("id"));
        Long id = Long.parseLong(""+p.$("id"));
        CommonPo cVo = TransferService.getInstance().transData(type, p);
        if (id != null) {
            cVo.setId(id);
        }
        System.out.println("post--->>>>" + cVo.getId());
        Class cls = TransferService.getInstance().getTransferClass(type);
        CommonPo vo2 = (CommonPo) handler.getDataByKeyAndClassType(type, ""+cVo.getId(), cls);
        System.out.println("post2--->>>>" + vo2.getId());
        //handler.removeDataByKey(type,vo2.getId());
        vo2 = CommonUtils.copyProIfNotNullReturnSource(vo2, cVo);
        handler.putData(type, ""+vo2.getId(), vo2);
        entity.setData(vo2);
        if(NbdConstant.A8_TO_OTHER.equals(type)){
            FormTableDefinition ftd = mappingServiceManager.updateFormTableDefinition(p);
            if(entity.getData() instanceof A8ToOtherConfigEntity){
                A8ToOtherConfigEntity a8ToOtherConfigEntity =  (A8ToOtherConfigEntity)entity.getData();
                //a8ToOtherConfigEntity.setFtd(ftd);
            }
        }
        if(NbdConstant.OTHER_TO_A8.equals(type)){
            FormTableDefinition ftd = mappingServiceManager.updateFormTableDefinition(p);
            if(entity.getData() instanceof OtherToA8ConfigEntity){
                OtherToA8ConfigEntity otherToA8 =  (OtherToA8ConfigEntity)entity.getData();
                //otherToA8.setFtd(ftd);
            }
        }
        entity.setResult(true);
        return entity;
    }

    public NbdResponseEntity postDelete(CommonParameter p) {
        NbdResponseEntity entity = preProcess(p);
        String type = p.$("data_type");
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
        } else {
            entity.setResult(false);
            entity.setData(id);
        }
        if(NbdConstant.A8_TO_OTHER.equals(type)){
            FormTableDefinition ftd = mappingServiceManager.deleteFormTableDefinition(p);
            if(entity.getData() instanceof A8ToOtherConfigEntity){
                A8ToOtherConfigEntity a8ToOtherConfigEntity =  (A8ToOtherConfigEntity)entity.getData();
               // a8ToOtherConfigEntity.setFtd(ftd);
            }
        }
        if(NbdConstant.OTHER_TO_A8.equals(type)){
            FormTableDefinition ftd = mappingServiceManager.deleteFormTableDefinition(p);
            if(entity.getData() instanceof OtherToA8ConfigEntity){
                OtherToA8ConfigEntity otherToA8 =  (OtherToA8ConfigEntity)entity.getData();
                //otherToA8.setFtd(ftd);
            }
        }
        return entity;
    }

    public NbdResponseEntity getDataList(CommonParameter p) {
        NbdResponseEntity entity = preProcess(p);
        String type = p.$("data_type");
        Map map = handler.getDataAll(type);
        List dataList = new ArrayList();
        if (map == null) {
            entity.setItems(new ArrayList());
        } else {
            dataList.addAll(map.values());
            entity.setItems(dataList);
        }
        return entity;
    }

    public NbdResponseEntity getDataById(CommonParameter p) {
        NbdResponseEntity entity = preProcess(p);
        String type = p.$("data_type");
        String id = p.$("id");
        if (CommonUtils.isEmpty(id)) {
            entity.setResult(false);
            entity.setMsg("id not present!");
            return entity;
        }
        Class cls = TransferService.getInstance().getTransferClass(type);
        Object obj = handler.getDataByKeyAndClassType(type, id, cls);
        entity.setData(obj);

        if(NbdConstant.A8_TO_OTHER.equals(type)){
            System.out.println("wahahahhahaha");
             if(entity.getData() instanceof A8ToOtherConfigEntity){

                 A8ToOtherConfigEntity a8ToOtherConfigEntity =  (A8ToOtherConfigEntity)entity.getData();
                 p.$("affairType", a8ToOtherConfigEntity.getAffairType());
                 FormTableDefinition ftd = mappingServiceManager.getFormTableDefinition(p);
                // a8ToOtherConfigEntity.setFtd(ftd);
            }else{
                 System.out.println("GG LE");
           }
        }
        if(NbdConstant.OTHER_TO_A8.equals(type)){
           if(entity.getData() instanceof OtherToA8ConfigEntity){
                OtherToA8ConfigEntity otherToA8 =  (OtherToA8ConfigEntity)entity.getData();
                p.$("affairType", otherToA8.getAffairType());
               FormTableDefinition ftd = mappingServiceManager.getFormTableDefinition(p);
              // otherToA8.setFtd(ftd);
            }
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

    public NbdResponseEntity testConnection(CommonParameter p) {
        NbdResponseEntity entity = new NbdResponseEntity();
        try {
            DataLink dl = TransferService.getInstance().transData("data_link", p);
            boolean isOk = ConnectionBuilder.testConnection(dl);
            if (isOk) {
                entity.setResult(true);
                entity.setMsg("connection is ok");
            } else {
                entity.setResult(false);
                entity.setData("Error occured ~ when connecting~");
            }

        } catch (Exception e) {
            e.printStackTrace();
            entity.setResult(false);
            entity.setMsg(e.getMessage());
        }

        return entity;
    }
    public NbdResponseEntity getCtpTemplateNumber(CommonParameter p) {
        NbdResponseEntity entity = new NbdResponseEntity();
        try {
            String linkId = p.$("linkId");
            DataLink dl = null;
            if(CommonUtils.isEmpty(linkId)){
                dl = handler.getDataByKeyAndClassType("","",DataLink.class);
                if(dl == null){
                    dl = ConfigService.getA8DefaultDataLink();
                }
            }else{
                dl = ConfigService.getA8DefaultDataLink();
            }

            boolean isOk = ConnectionBuilder.testConnection(dl);
            if (isOk) {
                entity.setResult(true);
                String sql="select * from ctp_template where state=0 and is_delete=0";
                List<Map> items = DataBaseHelper.executeQueryBySQLAndLink(dl,sql);
                entity.setItems(items);
                entity.setMsg("connection is ok");
            } else {
                entity.setResult(false);
                entity.setMsg("数据连接失败");
                entity.setData("Error occured ~ when connecting~");
            }

        } catch (Exception e) {
            e.printStackTrace();
            entity.setResult(false);
            entity.setMsg(e.getMessage());
        }

        return entity;
    }

    public NbdResponseEntity getFormByTemplateNumber(CommonParameter p){
        NbdResponseEntity entity = new NbdResponseEntity();

        String affairType = p.$("affairType");
        String sql = " select * from form_definition where id = (select  CONTENT_TEMPLATE_ID from ctp_content_all where id =(select BODY from ctp_template where TEMPLETE_NUMBER='"+affairType+"'))";
        DataLink dl = ConfigService.getA8DefaultDataLink();
        List<Map> items = DataBaseHelper.executeQueryBySQLAndLink(dl,sql);
        if(CommonUtils.isEmpty(items)){
            entity.setResult(false);
            entity.setMsg("根据模板编号无法找到对应的表单");
            return entity;
        }
        String xml = String.valueOf(items.get(0).get("field_info"));
        try {
            String jsonString = XmlUtils.xmlString2jsonString(xml);
            Map data = JSON.parseObject(jsonString,HashMap.class);
            FormTableDefinition ftd = mappingServiceManager.parseFormTableMapping(data);
            entity.setData(ftd);
            entity.setResult(true);
            return entity;
        } catch (Exception e) {
            e.printStackTrace();
            entity.setResult(false);
            entity.setMsg(e.getMessage());
            return entity;
        }

    }
    public NbdResponseEntity dbConsole(CommonParameter p){
        NbdResponseEntity entity = new NbdResponseEntity();

        String linkId = p.$("linkId");
        String sql = p.$("sql");
        if(CommonUtils.isEmpty(sql)){
            entity.setResult(false);
            entity.setData("empty sql or link");
            return entity;
        }else{
            if(!sql.toLowerCase().startsWith("select")){
                entity.setResult(false);
                entity.setData("不支持的sql语句，解锁完整版请联系商务");
                return entity;
            }
        }

        DataLink dl = handler.getDataByKeyAndClassType("data_link",linkId,DataLink.class);
        List<Map> items = DataBaseHelper.executeQueryBySQLAndLink(dl,sql);
        if(CommonUtils.isEmpty(items)){
            entity.setResult(false);
            entity.setMsg("根据模板编号无法找到对应的表单");
            return entity;
        }
        try {
            entity.setItems(items);
            entity.setResult(true);
            return entity;
        } catch (Exception e) {
            e.printStackTrace();
            entity.setResult(false);
            entity.setMsg(e.getMessage());
            return entity;
        }

    }

    public void transA8Output(CtpAffair affair, A8ToOtherConfigEntity a8ToOtherConfigEntity){

        String expType = a8ToOtherConfigEntity.getExportType();

        if("mid_table".equals(expType)){

            Long formRecordId = affair.getFormRecordid();
            FormTableDefinition ftd = null;//a8ToOtherConfigEntity.getFtd();
            if(ftd==null){
                System.out.println("[ERROR]FTD NOT FOUND:"+ a8ToOtherConfigEntity.getId());
                return;
            }
            String sql = ftd.genQueryById(formRecordId);
            System.out.println(sql);
            try {
                List<Map> dataMapList = DataBaseHelper.executeQueryByNativeSQL(sql);
                if(CommonUtils.isEmpty(dataMapList)){
                    System.out.println("[ERROR]DATA NOT FOUND:"+formRecordId);
                    return;
                }

                List<Map> retList = ftd.filled2ValueMap(ftd.getFormTable(),dataMapList);

                //只会有一条
                Map masterRecord = retList.get(0);
                System.out.println("master_record:"+masterRecord);
                //处理子表
                List<FormTable> slaveTables = ftd.getFormTable().getSlaveTableList();
                if (!CommonUtils.isEmpty(slaveTables)) {

                    for(FormTable ft:slaveTables){

                        String slaveSql = ftd.genSelectSQLByProp(ft,"formmain_id",formRecordId);
                        List<Map> slaveDataMapList = DataBaseHelper.executeQueryByNativeSQL(slaveSql);
                        List<Map> slaveRet = ftd.filled2ValueMap(ft,slaveDataMapList);
                        masterRecord.put(ft.getDisplay(),slaveRet);
                    }
                }
                //List<List<SimpleFormField>> retList = ftd.filledValue(dataMapList);
                A8OutputVo a8OutputVo = new A8OutputVo();
                a8OutputVo.setCreateDate(new Date());
                a8OutputVo.setData(JSON.toJSONString(masterRecord));
                a8OutputVo.setIdIfNew();
                a8OutputVo.setSourceId(formRecordId);
                a8OutputVo.setStatus(0);
                a8OutputVo.setUpdateDate(new Date());

                a8OutputVo.setName(a8ToOtherConfigEntity.getAffairType()+"_"+ftd.getFormTable().getName());
                System.out.println("to_be_saved:"+JSON.toJSONString(a8OutputVo));
//                a8ToOtherConfigEntity.getLinkId();
//                this.getDataById()
               // Long link = a8ToOtherConfigEntity.getLinkId();
             //   CommonParameter p = new CommonParameter();
                //p.$("id",link);
               // DataLink dl = this.getDataById(p).getData();
                DBAgent.save(a8OutputVo);
                DBAgent.commit();
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("[ERROR]EXECUTE ERROR:"+e.getMessage());
                return;
            }catch (Error error){
                error.printStackTrace();
            }


        }else{




        }

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
