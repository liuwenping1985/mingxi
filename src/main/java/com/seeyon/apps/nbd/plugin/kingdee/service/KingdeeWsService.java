package com.seeyon.apps.nbd.plugin.kingdee.service;

import com.seeyon.apps.nbd.core.db.DataBaseHelper;
import com.seeyon.apps.nbd.core.form.entity.FormTableDefinition;
import com.seeyon.apps.nbd.core.service.ServicePlugin;
import com.seeyon.apps.nbd.core.vo.CommonDataVo;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.plugin.PluginDefinition;
import com.seeyon.apps.nbd.plugin.als.po.A8OutputVo;
import com.seeyon.apps.nbd.plugin.kingdee.vo.KingDeeBill;
import com.seeyon.apps.nbd.plugin.kingdee.vo.PayBillType;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2018/10/17.
 */
public class KingdeeWsService implements ServicePlugin{

    private PluginDefinition pluginDefinition;

    private DataTransferService dataTransferService;

    private Map<String,FormTableDefinition> fdMaps = new HashMap<String, FormTableDefinition>();

    public KingdeeWsService(PluginDefinition pluginDefinition){
        this.pluginDefinition = pluginDefinition;
    }
    public PluginDefinition getPluginDefinition() {
        return this.pluginDefinition;
    }

    public FormTableDefinition getFormTableDefinition(String affairType) {
        return fdMaps.get(affairType);
    }

    public void addFormTableDefinition(FormTableDefinition definition) {
        String key = definition.getAffairType();
        fdMaps.put(key,definition);
    }

    public void addPluginDefinition(PluginDefinition definition) {
        this.pluginDefinition = definition;
    }

    public CommonDataVo receiveAffair(CommonParameter parameter) {
        return null;
    }

    public CommonDataVo getAffair(CommonParameter parameter) {
        return null;
    }

    public CommonDataVo deleteAffair(CommonParameter parameter) {
        return null;
    }

    public CommonDataVo processAffair(CommonParameter parameter) {
       String afType =  parameter.$("affairType");
       String rdId =  parameter.$("form_record_id");
       FormTableDefinition ftd =  this.getFormTableDefinition(afType);
       String sql = ftd.genQueryById(Long.parseLong(rdId));
       System.out.println("sql:"+sql);
        try {
            List<Map> list =  DataBaseHelper.executeQueryByNativeSQL(sql);

            DataParaser dt = dataTransferService.getDataParaserByAffairType(afType);
            if(dt!=null){
                for(Map data:list){
                  KingDeeBill bill = dt.parse(data);

                }

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        CommonDataVo vo = new CommonDataVo();
        return null;
    }

    private KingDeeBill genDefaultBill(){
        KingDeeBill bill = new KingDeeBill();
        PayBillType payBillType = new PayBillType();
        payBillType.setNumber("202");
        bill.setPayBillType(payBillType);
        return bill;

    }

    public List<String> getSupportAffairTypes() {
        return this.getPluginDefinition().getSupportAffairTypes();
    }

    public boolean containAffairType(String affairType) {
        return this.getPluginDefinition().containAffairType(affairType);
    }

    public Map<String, List<A8OutputVo>> exportAllData() {
        return null;
    }

    public List<A8OutputVo> exportData(String affairType) {
        return null;
    }

    public List<A8OutputVo> exportData(String affairType, CommonParameter parameter) {
        return null;
    }
}
