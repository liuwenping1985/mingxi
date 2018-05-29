package com.seeyon.apps.datakit.service;

import com.seeyon.apps.collaboration.event.CollaborationFinishEvent;
import com.seeyon.apps.collaboration.event.CollaborationProcessEvent;
import com.seeyon.apps.datakit.dao.DataKitNanjingDao;
import com.seeyon.apps.datakit.po.*;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.util.annotation.ListenEvent;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.List;

public class DataKitNanJingService {

    private DataKitNanjingDao dataKitNanjingDao;

    public DataKitNanjingDao getDataKitNanjingDao() {
        return dataKitNanjingDao;
    }

    public void setDataKitNanjingDao(DataKitNanjingDao dataKitNanjingDao) {
        this.dataKitNanjingDao = dataKitNanjingDao;
    }

    private final String templateId = "";

    @ListenEvent(event = CollaborationFinishEvent.class)
    public void onProcess(CollaborationProcessEvent event) {
        System.out.println("-------------process finish---------");
       CtpAffair affair =  event.getAffair();

       if(affair == null){
           return;
       }
        Long formId = affair.getFormId();
        System.out.println("-------------process affair---------form--id:"+affair.getFormId());
        List<Formson0068> formson68List = DBAgent.find("from Formson0068 where formainId="+formId);
        System.out.println("-------------process affair---------formson68List:"+formson68List);
        if(!CollectionUtils.isEmpty(formson68List)){
            List<ZYWLDW> zywldwList = new ArrayList<ZYWLDW>();
            for(Formson0068 fs:formson68List){
                ZYWLDW dw = new ZYWLDW();
                dw.setID(UUIDLong.longUUID());
                dw.setWLDW06(fs.getField0011());
                try {
                    dw.setJXSL01(fs.getField0012() == null ? null : Double.parseDouble(fs.getField0012()));
                }catch(Exception e){
                    e.printStackTrace();
                }
                dw.setWLDW11(fs.getField0013());
                dw.setWLDW12(fs.getField0014());
                dw.setWLDW13(fs.getField0015());
                dw.setDWQT06(fs.getField0016());
                dw.setDWQT08(fs.getField0017());
                dw.setDQXX01(fs.getField0018());
                dw.setWLDW02(fs.getField0009());
                zywldwList.add(dw);
            }
            dataKitNanjingDao.getHibernateTemplate().saveOrUpdateAll(zywldwList);
            return;
        }
        List<Formson0070> formson70List = DBAgent.find("from Formson0070 where formainId="+formId);
        if(!CollectionUtils.isEmpty(formson70List)){
            List<ZYWLDW> zywldwList = new ArrayList<ZYWLDW>();
            for(Formson0070 son70:formson70List){
                ZYWLDW dw = new ZYWLDW();
                dw.setID(UUIDLong.longUUID());
                dw.setWLDW02(son70.getField0008());
                dw.setDQXX01(son70.getField0020());
                dw.setWLDW06(son70.getField0010());
                dw.setWLDW11(son70.getField0011());
                dw.setWLDW12(son70.getField0012());
                dw.setWLDW13(son70.getField0013());
                dw.setDWQT06(son70.getField0014());
                dw.setWLDW14(son70.getField0018());
                dw.setWLDW43(son70.getField0019());
                zywldwList.add(dw);
            }
            dataKitNanjingDao.getHibernateTemplate().saveOrUpdateAll(zywldwList);
            return;
        }
        List<Formmain0061> formmain61List = DBAgent.find("from Formmain0061 where id="+formId);
        if(!CollectionUtils.isEmpty(formmain61List)){
            List<ZYPPB>zyppbs = new ArrayList<ZYPPB>();
            for(Formmain0061 main0061:formmain61List){
               ZYPPB ppb  = new ZYPPB();
               ppb.setID(UUIDLong.longUUID());
               ppb.setPPB02(main0061.getField0001());
                zyppbs.add(ppb);
            }
            dataKitNanjingDao.getHibernateTemplate().saveOrUpdateAll(zyppbs);
            return;
        }
        List<Formson0064> formson64List = DBAgent.find("from Formson0064 where formainId="+formId);
        if(!CollectionUtils.isEmpty(formson64List)){
            List<ZYSPXX> zywldwList = new ArrayList<ZYSPXX>();
            for(Formson0064 son70:formson64List){
                ZYSPXX dw  = new ZYSPXX();
                dw.setID(UUIDLong.longUUID());
                dw.setSPXX04(son70.getField0008());
                dw.setPPB01(son70.getField0023());
                dw.setSPFL01(son70.getField0024());
                dw.setZBBJ(son70.getField0025()==null?null:Integer.parseInt(son70.getField0025()));
                dw.setSPXX71(son70.getField0012()==null?null:Float.parseFloat(son70.getField0012()));
                dw.setJQJX01(son70.getField0026());
                dw.setSPXX08(son70.getField0014()==null?null:Float.parseFloat(son70.getField0014()));
                dw.setJLDW01(son70.getField0015());
                dw.setSPXX70(son70.getField0016()==null?null:Float.parseFloat(son70.getField0016()));
                dw.setSPXX42(son70.getField0017()==null?null:Float.parseFloat(son70.getField0017()));
                dw.setSPXX43(son70.getField0018()==null?null:Float.parseFloat(son70.getField0018()));
                dw.setSPXX44(son70.getField0019()==null?null:Float.parseFloat(son70.getField0019()));
                dw.setSPXX63(son70.getField0020()==null?null:Float.parseFloat(son70.getField0020()));
                dw.setSPXX68(son70.getField0021()==null?null:Float.parseFloat(son70.getField0021()));
                dw.setSPXX61(son70.getField0022());
                zywldwList.add(dw);
            }
            dataKitNanjingDao.getHibernateTemplate().saveOrUpdateAll(zywldwList);
            return;
        }
    }
}
