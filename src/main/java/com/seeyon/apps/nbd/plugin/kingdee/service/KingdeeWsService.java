package com.seeyon.apps.nbd.plugin.kingdee.service;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.db.DataBaseHandler;
import com.seeyon.apps.nbd.core.db.DataBaseHelper;
import com.seeyon.apps.nbd.core.form.entity.FormField;
import com.seeyon.apps.nbd.core.form.entity.FormTable;
import com.seeyon.apps.nbd.core.form.entity.FormTableDefinition;
import com.seeyon.apps.nbd.core.form.entity.SimpleFormField;
import com.seeyon.apps.nbd.core.service.ServicePlugin;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.core.vo.CommonDataVo;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.plugin.PluginDefinition;
import com.seeyon.apps.nbd.plugin.als.po.A8OutputVo;
import com.seeyon.apps.nbd.plugin.kingdee.vo.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2018/10/17.
 */
public class KingdeeWsService implements ServicePlugin {

    private PluginDefinition pluginDefinition;
    private KingdeeWebServiceProvider provider = new KingdeeWebServiceProvider();

    private DataTransferService dataTransferService = new DataTransferService();

    private Map<String, FormTableDefinition> fdMaps = new HashMap<String, FormTableDefinition>();

    public KingdeeWsService(PluginDefinition pluginDefinition) {
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
        fdMaps.put(key, definition);
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
        String afType = parameter.$("affairType");
        String rdId = parameter.$("form_record_id");
        FormTableDefinition ftd = this.getFormTableDefinition(afType);
        String sql = ftd.genQueryById(Long.parseLong(rdId));
        System.out.println("sql:" + sql);
        Map<String,Object> objectMap = new HashMap<String, Object>();

        CommonDataVo vo = new CommonDataVo();
        try {
          // Map mockData =  DataBaseHandler.getInstance().getDataAll("mock");
            //List<Map> list = new ArrayList<Map>();
            List<Map> list = DataBaseHelper.executeQueryByNativeSQL(sql);
            List<FormTable> slaveTables = ftd.getFormTable().getSlaveTableList();
            //list.add(mockData);
            if(!CommonUtils.isEmpty(slaveTables)){
                for(FormTable ft:slaveTables){
                    if(ft.getNeedquery()!=null&&"1".equals(ft.getNeedquery())){
                        String sTable = "select * from "+ft.getName()+" where formmain_id="+rdId;
                        List<Map> slaveList = DataBaseHelper.executeQueryByNativeSQL(sTable);
                        List<FormField> ffsList = ft.getFormFieldList();
                        for(Map sdata:slaveList){
                            for(FormField ff:ffsList){
                                if(CommonUtils.isEmpty(ff.getBarcode())){
                                    continue;
                                }
                                if("amount".equals(ff.getBarcode())){
                                   Double ddd =  (Double)objectMap.get("amount");
                                   if(ddd == null){
                                       objectMap.put("amount",0d);
                                       ddd=0d;
                                   }
                                   Double newddd = CommonUtils.getDouble(sdata.get(ff.getName()));
                                    if(newddd!=null){
                                        objectMap.put("amount",ddd+newddd);
                                    }

                                }
                                if("remark".equals(ff.getBarcode())){
                                    String oldRemark = ""+objectMap.get("remark");
                                    if(CommonUtils.isEmpty(oldRemark)){
                                        oldRemark = "";
                                    }
                                    if(sdata.get(ff.getName())!=null){
                                        objectMap.put("remark",oldRemark+String.valueOf(sdata.get(ff.getName())));
                                    }

                                }
                            }
                        }
                    }
                }
            }

            DataParser dt = dataTransferService.getDataParaserByAffairType(afType);

            if (dt != null) {
                KingDeeBill bill = genDefaultBill();

                //field0018
                //number
                List<KingDeeBill> billList = new ArrayList<KingDeeBill>();
                for (Map data : list) {
                    //收款人名称
                    bill = dt.parse(bill,data,ftd);
                    billList.add(bill);
                }
                if(!CommonUtils.isEmpty(objectMap)){
                    for(String key:objectMap.keySet()){
                        if("amount".equals(key)){
                            Double amount = (Double)objectMap.get("amount");
                            if(amount==null){
                                amount = 0d;
                            }
                            bill.setAmount(amount);
                            bill.setLocalAmt(amount);
                            List<KingdeeEntry> entryList =  bill.getEntries();
                            entryList.get(0).setAmount(amount);
                            entryList.get(0).setLocalAmt(amount);
                        }
                        if("remark".equals(key)){
                            bill.setDescription(objectMap.get("remark")+"");
                        }
                    }

                }
               // System.out.println(JSON.toJSONString(billList));
                String ret =  provider.importBill(billList);
               // System.out.println(JSON.toJSONString(billList));
                vo.setResult(true);
                try {
                    vo.setData(JSON.parseObject(ret, HashMap.class));
                }catch(Exception e){

                }
                vo.setMsg(ret);
            }
        } catch (Exception e) {
            vo.setResult(false);
            vo.setMsg(e.getMessage());
            e.printStackTrace();
        }

        return vo;
    }

    private KingDeeBill genDefaultBill() {
        KingDeeBill bill = new KingDeeBill();
        PayBillType payBillType = new PayBillType();
        payBillType.setNumber("999");
        bill.setPayBillType(payBillType);
        PayerAccount payerAccount = new PayerAccount();
        payerAccount.setNumber("1002");
        bill.setPayerAccount(payerAccount);
        SettlementType st = new SettlementType();
        st.setNumber("02");
        bill.setSettlementType(st);
        bill.setExchangeRate(1);
        PayerAccount pa = new PayerAccount();
        pa.setNumber("1002");
        pa.setCu(new CommonKingDeeVo("1000"));
        bill.setPayerAccount(pa);
        bill.setPayeeType(new CommonKingDeeVo("002"));
        //bill.setLocalAmt();
        //currency
        bill.setCurrency(new CommonKingDeeVo("BB01"));
        //bill.setBizDate(new Date());
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
