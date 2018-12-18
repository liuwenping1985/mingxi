package com.seeyon.apps.nbd.service;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.bulletin.bo.BulDataBO;
import com.seeyon.apps.nbd.constant.NbdConstant;
import com.seeyon.apps.nbd.core.config.ConfigService;
import com.seeyon.apps.nbd.core.db.DataBaseHelper;
import com.seeyon.apps.nbd.core.db.link.ConnectionBuilder;
import com.seeyon.apps.nbd.core.entity.*;
import com.seeyon.apps.nbd.core.form.entity.FormField;
import com.seeyon.apps.nbd.core.form.entity.FormTable;
import com.seeyon.apps.nbd.core.form.entity.FormTableDefinition;
import com.seeyon.apps.nbd.core.service.CustomExportProcess;
import com.seeyon.apps.nbd.core.service.MappingServiceManager;
import com.seeyon.apps.nbd.core.service.NbdBpmnService;
import com.seeyon.apps.nbd.core.service.impl.MappingServiceManagerImpl;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.core.util.XmlUtils;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.core.vo.NbdResponseEntity;
import com.seeyon.apps.nbd.platform.oa.SubEntityFieldParser;
import com.seeyon.apps.nbd.po.*;
import com.seeyon.apps.nbd.util.UIUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.template.manager.CollaborationTemplateManager;
import com.seeyon.ctp.login.LoginControlImpl;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.v3x.bulletin.controller.BulDataController;
import com.seeyon.v3x.bulletin.domain.BulData;
import com.seeyon.v3x.bulletin.manager.BulDataManagerImpl;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.URLDecoder;
import java.util.*;

/**
 * Created by liuwenping on 2018/10/29.
 */
public class NbdService {

    // private DataBaseHandler handler = DataBaseHandler.getInstance();
    private MappingServiceManager mappingServiceManager = new MappingServiceManagerImpl();
    private TransferService transferService = TransferService.getInstance();
    private CollaborationTemplateManager collaborationTemplateManager;
    private NbdBpmnService nbdBpmnService;
    private NbdBpmnService getNbdBpmnService() {
        if (nbdBpmnService == null) {
            nbdBpmnService = new NbdBpmnService();
        }
        return nbdBpmnService;
    }

    private CollaborationTemplateManager getCollaborationTemplateManager() {
        if (collaborationTemplateManager == null) {
            collaborationTemplateManager = (CollaborationTemplateManager) AppContext.getBean("collaborationTemplateManager");
        }
        return collaborationTemplateManager;
    }

    private LoginControlImpl loginControl;

    private HttpServletRequest request;
    private HttpServletResponse response;

    private OrgManager orgManager;

    private OrgManager getOrgManager() {
        if (orgManager == null) {
            orgManager = (OrgManager) AppContext.getBean("orgManager");
        }
        return orgManager;
    }

    public void setRequest(HttpServletRequest request) {
        this.request = request;
    }

    public void setResponse(HttpServletResponse response) {
        this.response = response;
    }

    private LoginControlImpl getLoginControl() {
        if (loginControl == null) {
            loginControl = (LoginControlImpl) AppContext.getBean("loginControl");
            if (loginControl == null) {
                loginControl = (LoginControlImpl) AppContext.getBean("loginControlImpl");
            }
        }
        return loginControl;
    }

        public NbdResponseEntity lanchForm(CommonParameter p){
            NbdResponseEntity entity = new NbdResponseEntity();
            entity.setResult(false);
            String affairType = p.$("affairType");
            if(CommonUtils.isEmpty(affairType)){
                affairType = "GYSDJB";
            }
            DataLink dl = ConfigService.getA8DefaultDataLink();
            String sql ="select * from "+DataBaseHelper.getTableName(OtherToA8ConfigEntity.class)+" where affairType='"+affairType+"'";
            try {
                List<OtherToA8ConfigEntity> otaceList = DataBaseHelper.executeObjectQueryBySQLAndLink(dl,OtherToA8ConfigEntity.class,sql);
                if(CommonUtils.isEmpty(otaceList)){
                    entity.setMsg("接受失败，没有找到对应的配置项："+affairType);
                    entity.setResult(false);
                    entity.setData(p);
                    return entity;
                }
                //这里分为两段逻辑
                //从外部接受存入底表和表单,先写表单的
               for(OtherToA8ConfigEntity otace:otaceList){
                    if("1".equals(otace.getTriggerProcess())){
                        otace =  DataBaseHelper.getDataByTypeAndId(dl,OtherToA8ConfigEntity.class,otace.getId());
                        FormTableDefinition ftd = otace.getFtd();
                        Map<String, Object> params = genCollData(p,ftd);
                        Long summaryId = getNbdBpmnService().sendCollaboration(affairType,params);
                        entity.setResult(true);
                        entity.setData(summaryId);
                    }
               }

            } catch (Exception e) {
                e.printStackTrace();
                entity.setMsg("发起流程失败:"+e.getMessage());
                entity.setResult(false);
            }
           // entity.setMsg("发起流程失败");
            entity.setData(p);
            return entity;


        }
    private void setData(FormField meta,Map dataMap,Map inputData){
        String barCode = meta.getBarcode();
        String name = meta.getName();
        if(!StringUtils.isEmpty(barCode)&&!StringUtils.isEmpty(name)){

            dataMap.put(name,inputData.get(barCode));
        }
    }
    private Map<String,Object> genCollData(CommonParameter inputData,FormTableDefinition ftd){

        Map<String,Object> param = new HashMap<String,Object>();
        FormTable entity = ftd.getFormTable();
        List<FormField> fields = entity.getFormFieldList();
        if(!CollectionUtils.isEmpty(fields)){
            for(FormField meta:fields){
                setData(meta,param,inputData);
            }
        }
        // System.out.println("parse--sub-entity");
        List<FormTable> slaveFtList = entity.getSlaveTableList();

        if(!CollectionUtils.isEmpty(slaveFtList)){
            //   System.out.println("parse--sub2-entity");


        }

        return param;
    }

    public NbdResponseEntity postAdd(CommonParameter p) {
        //System.out.println(p);
        NbdResponseEntity entity = preProcess(p);
        if (!entity.isResult()) {
            return entity;
        }
        String type = p.$("data_type");
        DataLink dataLink = ConfigService.getA8DefaultDataLink();
        //handler.createNewDataBaseByNameIfNotExist(type);
        CommonPo cVo = transferService.transData(type, p);
        if (cVo == null) {
            entity.setResult(false);
            entity.setMsg(" data transfer error");
        } else {
            cVo.setDefaultValueIfNull();
            p.$("id", cVo.getId());
            if (NbdConstant.A8_TO_OTHER.equals(type)) {
                Ftd ftd = mappingServiceManager.saveFormTableDefinition(p);
                A8ToOtherConfigEntity a82Otherentity = (A8ToOtherConfigEntity) cVo;
                a82Otherentity.setFtdId(ftd.getId());
            }
            if (NbdConstant.OTHER_TO_A8.equals(type)) {
                Ftd ftd = mappingServiceManager.saveFormTableDefinition(p);
                OtherToA8ConfigEntity otherToA8 = (OtherToA8ConfigEntity) cVo;
                otherToA8.setFtdId(ftd.getId());
            }
            cVo.saveOrUpdate(dataLink);
            entity.setData(cVo);
        }

        return entity;
    }

    public NbdResponseEntity postUpdate(CommonParameter p) {
        NbdResponseEntity entity = preProcess(p);
        String type = p.$("data_type");
       // System.out.println("post--->>>>" + p.$("id"));
        Long id = Long.parseLong("" + p.$("id"));
        CommonPo cVo = transferService.transData(type, p);
        if (id != null) {
            cVo.setId(id);
        } else {
            entity.setResult(false);
            entity.setMsg("id is not presented!");
        }
        DataLink dataLink = ConfigService.getA8DefaultDataLink();
        //System.out.println("post--->>>>" + cVo.getId());
        Class cls = transferService.getTransferClass(type);
        CommonPo vo2 = (CommonPo) DataBaseHelper.getDataByTypeAndId(dataLink, cls, id);
        // CommonPo vo2 = (CommonPo) handler.getDataByKeyAndClassType(type, ""+cVo.getId(), cls);
        //System.out.println("post2--->>>>" + vo2.getId());
        //handler.removeDataByKey(type,vo2.getId());
        vo2 = CommonUtils.copyProIfNotNullReturnSource(vo2, cVo);

        entity.setData(vo2);
        if (NbdConstant.A8_TO_OTHER.equals(type) || NbdConstant.OTHER_TO_A8.equals(type)) {
            //CommonParameter ftdP = new CommonParameter();
            A8ToOtherConfigEntity a82Otherentity = (A8ToOtherConfigEntity) vo2;
            p.$("id", a82Otherentity.getFtdId());
            mappingServiceManager.updateFormTableDefinition(p);
        }
        vo2.saveOrUpdate(dataLink);
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
        Class cls = transferService.getTransferClass(type);
        DataLink dataLink = ConfigService.getA8DefaultDataLink();

        CommonPo commonPo = (CommonPo) DataBaseHelper.getDataByTypeAndId(dataLink, cls, Long.parseLong(id));

        //Object data = handler.removeDataByKey(type, id);
        if (commonPo != null) {
            entity.setData(commonPo);
            entity.setResult(true);
        } else {
            entity.setResult(false);
            entity.setData(id);
        }
        if (NbdConstant.A8_TO_OTHER.equals(type)) {
            A8ToOtherConfigEntity a8ToOtherConfigEntity = (A8ToOtherConfigEntity) entity.getData();
            CommonParameter ftdP = new CommonParameter();
            ftdP.$("id", a8ToOtherConfigEntity.getFtdId());
            mappingServiceManager.deleteFormTableDefinition(ftdP);
        }
        if (NbdConstant.OTHER_TO_A8.equals(type)) {
            // mappingServiceManager.deleteFormTableDefinition(p);

            OtherToA8ConfigEntity otherToA8 = (OtherToA8ConfigEntity) entity.getData();
            CommonParameter ftdP = new CommonParameter();
            ftdP.$("id", otherToA8.getFtdId());
            mappingServiceManager.deleteFormTableDefinition(ftdP);


        }
        commonPo.delete(dataLink);
        return entity;
    }

    public NbdResponseEntity getDataList(CommonParameter p) {
        NbdResponseEntity entity = preProcess(p);
        String type = p.$("data_type");
        DataLink dataLink = ConfigService.getA8DefaultDataLink();
        Class cls = transferService.getTransferClass(type);
        String sql = DataBaseHelper.genSelectAllSQL(cls);

        List dataList = DataBaseHelper.executeObjectQueryBySQLAndLink(dataLink, cls, sql);


        if (dataList == null) {
            entity.setItems(new ArrayList());
        } else {
            for (Object obj : dataList) {
                if (obj instanceof CommonPo) {
                    CommonPo cp = (CommonPo) obj;
                    cp.setSid(String.valueOf(cp.getId()));
                }
                if (obj instanceof A8ToOtherConfigEntity) {
                    A8ToOtherConfigEntity cp = (A8ToOtherConfigEntity) obj;
                    cp.setsLinkId(String.valueOf(cp.getLinkId()));
                }
                if (obj instanceof OtherToA8ConfigEntity) {
                    OtherToA8ConfigEntity cp = (OtherToA8ConfigEntity) obj;
                    cp.setsLinkId(String.valueOf(cp.getLinkId()));
                }

            }
            entity.setItems(dataList);
        }
        return entity;
    }

    public NbdResponseEntity getDataById(CommonParameter p) {
        NbdResponseEntity entity = preProcess(p);
        String type = p.$("data_type");
        String id = String.valueOf(p.$("id"));
        if (CommonUtils.isEmpty(id)) {
            entity.setResult(false);
            entity.setMsg("id not present!");
            return entity;
        }
        Class cls = TransferService.getInstance().getTransferClass(type);
        DataLink dl = ConfigService.getA8DefaultDataLink();
        Object obj = DataBaseHelper.getDataByTypeAndId(dl, cls, Long.parseLong(id));
        if (NbdConstant.A8_TO_OTHER.equals(type)) {
            A8ToOtherConfigEntity a8toOther = (A8ToOtherConfigEntity) obj;
            Long ftdId = a8toOther.getFtdId();
            Ftd ftd = DataBaseHelper.getDataByTypeAndId(dl, Ftd.class, ftdId);
            FormTableDefinition formDef = Ftd.getFormTableDefinition(ftd);
            a8toOther.setFormTableDefinition(formDef);
            a8toOther.setsLinkId(String.valueOf(a8toOther.getLinkId()));
        }
        if (NbdConstant.OTHER_TO_A8.equals(type)) {

            OtherToA8ConfigEntity otherToA8ConfigEntity = (OtherToA8ConfigEntity) obj;
            Long ftdId = otherToA8ConfigEntity.getFtdId();
            Ftd ftd = DataBaseHelper.getDataByTypeAndId(dl, Ftd.class, ftdId);
            FormTableDefinition formDef = Ftd.getFormTableDefinition(ftd);
            otherToA8ConfigEntity.setFormTableDefinition(formDef);
            otherToA8ConfigEntity.setsLinkId(String.valueOf(otherToA8ConfigEntity.getLinkId()));
        }
        if (obj instanceof CommonPo) {
            CommonPo cp = (CommonPo) obj;
            cp.setSid(String.valueOf(cp.getId()));
        }
        entity.setData(obj);
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
            if (!CommonUtils.isEmpty(linkId)) {

                DataLink dfl = ConfigService.getA8DefaultDataLink();
                dl = DataBaseHelper.getDataByTypeAndId(dfl, DataLink.class, Long.parseLong(linkId));
                if (dl == null) {
                    dl = ConfigService.getA8DefaultDataLink();
                }
            } else {
                dl = ConfigService.getA8DefaultDataLink();
            }
            boolean isOk = ConnectionBuilder.testConnection(dl);
            if (isOk) {
                entity.setResult(true);
                String sql = "select * from " + getTableName("CTP_TEMPLATE") + " where state=0 and is_delete=0";
                List<Map> items = DataBaseHelper.executeQueryBySQLAndLink(dl, sql);
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

    private String getTableName(String tableName) {



            return tableName.toUpperCase();

    }

    public NbdResponseEntity getFormByTemplateNumber(CommonParameter p) {
        NbdResponseEntity entity = new NbdResponseEntity();
        //String tablePrefix = ConfigService.getPropertyByName("local_db_prefix","");
        //  String dbType = ConfigService.getPropertyByName("local_db_type","0");

        String affairType = p.$("affairType");
        // DataLink dl = ConfigService.getA8DefaultDataLink();
        String sql = " select * from " + getTableName("FORM_DEFINITION") + " where ID = (select  CONTENT_TEMPLATE_ID from " + getTableName("CTP_CONTENT_ALL") + " where ID =(select BODY from " + getTableName("CTP_TEMPLATE") + " where TEMPLETE_NUMBER='" + affairType + "'))";

        List<Map> items = null;
        try {
            items = DataBaseHelper.executeQueryByNativeSQL(sql);
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (CommonUtils.isEmpty(items)) {
            entity.setResult(false);
            entity.setMsg("根据模板编号无法找到对应的表单");
            return entity;
        }
        String xml = String.valueOf(items.get(0).get("field_info"));
        try {
            String jsonString = XmlUtils.xmlString2jsonString(xml);
            Map data = JSON.parseObject(jsonString, HashMap.class);
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

    public NbdResponseEntity dbConsole(CommonParameter p) {
        NbdResponseEntity entity = new NbdResponseEntity();

        String linkId = p.$("linkId");
        String sql = p.$("sql");
        if (CommonUtils.isEmpty(sql)) {
            entity.setResult(false);
            entity.setData("empty sql or link");
            return entity;
        } else {
            if (sql.toLowerCase().contains("delete")) {
                entity.setResult(false);
                entity.setData("delete关键字不允许输入!");
                return entity;
            }
            if (sql.toLowerCase().contains("update")&&sql.toLowerCase().contains("set")) {
                entity.setResult(false);
                entity.setData("想update?搞事情啊？给你个病毒压压惊?");
                return entity;
            }
            if (sql.toLowerCase().contains("drop")) {
                entity.setResult(false);
                entity.setData("drop关键字不允许输入！");
                return entity;
            }
            if (!sql.toLowerCase().startsWith("select")) {
                entity.setResult(false);
                entity.setData("不支持的sql语句，解锁完整版请联系商务");
                return entity;
            }
        }

        DataLink dl = DataBaseHelper.getDataByTypeAndId(ConfigService.getA8DefaultDataLink(), DataLink.class, Long.parseLong(linkId));
        List<Map> items = DataBaseHelper.executeQueryBySQLAndLink(dl, sql);
        if (CommonUtils.isEmpty(items)) {
            entity.setResult(false);
            entity.setMsg("无数据");
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

    public void transA8Output(CtpAffair affair, A8ToOtherConfigEntity a8ToOtherConfigEntity) {

        String expType = a8ToOtherConfigEntity.getExportType();
        Long formRecordId = affair.getFormRecordid();
        Map masterRecord = null;
        if ("mid_table".equals(expType)) {
            try {

                masterRecord = exportMasterData(formRecordId, a8ToOtherConfigEntity, false);
                //List<List<SimpleFormField>> retList = ftd.filledValue(dataMapList);
                A8ToOther a8OutputVo = new A8ToOther();
                a8OutputVo.setCreateTime(new Date());
                a8OutputVo.setData(JSON.toJSONString(masterRecord));
                a8OutputVo.setId(UUIDLong.longUUID());
                a8OutputVo.setSourceId(formRecordId);
                a8OutputVo.setStatus(0);
                a8OutputVo.setUpdateTime(new Date());
                a8OutputVo.setName(a8ToOtherConfigEntity.getAffairType());
                System.out.println("to_be_saved:" + JSON.toJSONString(a8OutputVo));
                Long linkId = a8ToOtherConfigEntity.getLinkId();
                DataLink link = DataBaseHelper.getDataByTypeAndId(ConfigService.getA8DefaultDataLink(), DataLink.class, linkId);
                DataBaseHelper.persistCommonVo(link, a8OutputVo);

            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("[ERROR]EXECUTE ERROR:" + e.getMessage());
                return;
            } catch (Error error) {
                error.printStackTrace();
            }


        } else if ("http".equals(expType)) {
            // UIUtils.post()
            try {
                masterRecord = exportMasterData(formRecordId, a8ToOtherConfigEntity, false);
                String exportUrl = a8ToOtherConfigEntity.getExportUrl();
                if(CommonUtils.isEmpty(exportUrl)||CommonUtils.isEmpty(masterRecord)){
                    return;
                }
                UIUtils.post(exportUrl,masterRecord);

            } catch (Exception e) {
                e.printStackTrace();
            }

        } else if ("custom".equals(expType)) {

            try {
                Map data = exportMasterData(formRecordId, a8ToOtherConfigEntity, true);
                String exportUrl = a8ToOtherConfigEntity.getExportUrl();
                if (!CommonUtils.isEmpty(exportUrl)) {
                    Class cls = Class.forName(exportUrl);
                    Object obj = cls.newInstance();
                    if (obj instanceof CustomExportProcess) {
                        CustomExportProcess cep = (CustomExportProcess) obj;
                        cep.process(a8ToOtherConfigEntity, data);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

        } else if ("formmain".equals(expType)) {
            String exportUrl = a8ToOtherConfigEntity.getExportUrl();
            if (!CommonUtils.isEmpty(exportUrl)) {
                try {
                    Map data = exportMasterData(formRecordId, a8ToOtherConfigEntity, true);

                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

        }

    }

    public Map exportMasterData(Long formRecordId, FormTableDefinition ftd, boolean usingName) throws Exception {
        Map masterRecord = new HashMap();
        String sql = ftd.genQueryById(formRecordId);
        System.out.println(sql);

        List<Map> dataMapList = DataBaseHelper.executeQueryByNativeSQL(sql);
        if (CommonUtils.isEmpty(dataMapList)) {
            System.out.println("[ERROR]DATA NOT FOUND:" + formRecordId);
            return masterRecord;
        }

        List<Map> retList = ftd.filled2ValueMap(ftd.getFormTable(), dataMapList, !usingName);

        //只会有一条
        masterRecord = retList.get(0);
        System.out.println("master_record:" + masterRecord);
        //处理子表
        List<FormTable> slaveTables = ftd.getFormTable().getSlaveTableList();
        if (!CommonUtils.isEmpty(slaveTables)) {

            for (FormTable ft : slaveTables) {

                String slaveSql = ftd.genSelectSQLByProp(ft, "formmain_id", formRecordId);
                List<Map> slaveDataMapList = DataBaseHelper.executeQueryByNativeSQL(slaveSql);
                List<Map> slaveRet = ftd.filled2ValueMap(ft, slaveDataMapList, !usingName);
                if (usingName) {
                    masterRecord.put(ft.getName(), slaveRet);
                } else {
                    masterRecord.put(ft.getDisplay(), slaveRet);
                }

            }
        }

        return masterRecord;

    }

    private Map exportMasterData(Long formRecordId, A8ToOtherConfigEntity a8ToOtherConfigEntity, boolean usingName) throws Exception {
        Map masterRecord = new HashMap();

        Long ftdId = a8ToOtherConfigEntity.getFtdId();
        Ftd ftdHandler = DataBaseHelper.getDataByTypeAndId(ConfigService.getA8DefaultDataLink(), Ftd.class, ftdId);
        FormTableDefinition ftd = Ftd.getFormTableDefinition(ftdHandler);
        // FormTableDefinition ftd =
        if (ftd == null) {
            System.out.println("[ERROR]FTD NOT FOUND:" + a8ToOtherConfigEntity.getId());
            return masterRecord;
        }
        return exportMasterData(formRecordId, ftd, usingName);
    }

    public static void main(String[] args) {
        NbdService nbds = new NbdService();
        CommonParameter p = new CommonParameter();
        p.$("type", 123);
        p.$("type2", "66we");
        p.$("data_type", "3474646");

        //nbds.handler.createNewDataBaseByNameIfNotExist("test");


//        String json = JSON.toJSONString(p);
        // Test t = JSON.parseObject(json,Test.class);
        //Test t = (Test) nbds.handler.getDataByKeyAndClassType("test", "123", Test.class);
        //System.out.println(t.getType());
    }
}
