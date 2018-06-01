package com.seeyon.apps.datakit.service;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.collaboration.event.CollaborationFinishEvent;
import com.seeyon.apps.datakit.dao.DataKitNanjingDao;
import com.seeyon.apps.datakit.po.*;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.util.annotation.ListenEvent;
import org.springframework.util.CollectionUtils;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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

    public DataKitNanJingService(){
       // ListenerRegistry.getInstance().getListener

    }
    private static SimpleDateFormat format = new SimpleDateFormat("YYYYMMddHHmmssSSSFFF");

    @ListenEvent(event = CollaborationFinishEvent.class,async = true)
    public void onProcess(CollaborationFinishEvent event) {
        try {
            System.out.println("-------------process finish---------");
            // CtpAffair affair =  event.getAffairId();
            List<CtpAffair> affairList = DBAgent.find("from CtpAffair where id=" + event.getAffairId());
            if (affairList == null) {
                return;
            }
            CtpAffair affair = affairList.get(0);

            Long formId = affair.getFormRecordid();
            System.out.println("-------------process affair---------form--id:" + formId);
            if(formId == null){
                return;
            }
            List<Formson0068> formson68List = DBAgent.find("from Formson0068 where formainId=" + formId);
            System.out.println("formson68List:"+formson68List==null?"null":JSON.toJSONString(formson68List));
            if (!CollectionUtils.isEmpty(formson68List)) {
                List<ZYWLDW> zywldw68List = new ArrayList<ZYWLDW>();
                System.out.println("find record!!!!");
                System.out.println("data will push 2 ZYWLDW-tmp");
                for (Formson0068 fs : formson68List) {
                    System.out.println("data:"+JSON.toJSONString(fs));
                    ZYWLDW dw = new ZYWLDW();
                    Long id = UUIDLong.longUUID();
                    System.out.println("step:1");
                    dw.setID(0L+id.intValue());
                    System.out.println("step:2");
                    try {
                        System.out.println("step:2.1");
                        dw.setWLDW06(fs.getField0011());
                    }catch(Exception e){
                        System.out.println("step:2.2");
                        e.printStackTrace();
                    }
                    try {

                        System.out.println("step:2.3");
                        Float fval = fs.getField0012();
                        System.out.println("step:2.3.1");
                        if(fval== null){
                            fval=0.0f;
                        }
                        System.out.println("step:2.3.2");
                        dw.setJXSL01(fval.floatValue());
                        System.out.println("step:2.3.3");
                    } catch (Exception e) {
                        System.out.println("step:2.4");
                        e.printStackTrace();
                    }catch(Error error){
                        error.printStackTrace();
                    }
                    System.out.println("step:3");
                    dw.setWLDW20(0);
                    System.out.println("step:4");
                    dw.setWLDW11(fs.getField0013());
                    System.out.println("step:5");
                    dw.setWLDW12(fs.getField0014());
                    System.out.println("step:6");
                    dw.setWLDW13(fs.getField0015());
                    System.out.println("step:7");
                    dw.setDWQT06(fs.getField0016());
                    System.out.println("step:8");
                    dw.setDWQT08(fs.getField0017());
                    System.out.println("step:9");
                    dw.setDQXX01(fs.getField0018());
                    System.out.println("step:10");
                    dw.setWLDW02(fs.getField0009());
                    System.out.println("step:11");
                    dw.setTBBJ(0);
                    try {
                        System.out.println("step:12");
                        dw.setBTOBTS01(format.format(new Date()));
                    }catch(Exception e){
                        e.printStackTrace();
                    }
                    System.out.println("step:13");
                    zywldw68List.add(dw);
                }
                System.out.println("save record:"+ JSON.toJSONString(zywldw68List));
                dataKitNanjingDao.saveOrUpdateZYWLDW(zywldw68List);
                //dataKitNanjingDao.getHibernateTemplate().saveOrUpdateAll(zywldwList);
                return;
            }
            List<Formson0070> formson70List = DBAgent.find("from Formson0070 where formainId=" + formId);
            if (!CollectionUtils.isEmpty(formson70List)) {

                List<ZYWLDW> zywldwList = new ArrayList<ZYWLDW>();
                for (Formson0070 son70 : formson70List) {
                    ZYWLDW dw = new ZYWLDW();
                    Long id = UUIDLong.longUUID();
                    dw.setID(0L+id.intValue());
                    dw.setWLDW02(son70.getField0008());
                    dw.setWLDW20(1);
                    dw.setDQXX01(son70.getField0020());
                    dw.setWLDW06(son70.getField0010());
                    dw.setWLDW11(son70.getField0011());
                    dw.setWLDW12(son70.getField0012());
                    dw.setWLDW13(son70.getField0013());
                    dw.setDWQT06(son70.getField0014());
                    dw.setWLDW14(son70.getField0018());
                    dw.setWLDW43(son70.getField0019());
                    dw.setTBBJ(0);
                    dw.setBTOBTS01(format.format(new Date()));
                    zywldwList.add(dw);
                }
                dataKitNanjingDao.saveOrUpdateZYWLDW(zywldwList);
               // dataKitNanjingDao.getHibernateTemplate().saveOrUpdateAll(zywldwList);
                return;
            }
            List<Formmain0061> formmain61List = DBAgent.find("from Formmain0061 where id=" + formId);
            if (!CollectionUtils.isEmpty(formmain61List)) {
                List<ZYPPB> zyppbs = new ArrayList<ZYPPB>();
                for (Formmain0061 main0061 : formmain61List) {
                    ZYPPB ppb = new ZYPPB();
                    Long id = UUIDLong.longUUID();
                    ppb.setID(0L+id.intValue());
                    //ppb.setID(UUIDLong.longUUID());
                    ppb.setPPB02(main0061.getField0001());
                    ppb.setTBBJ(0);
                    ppb.setBTOBTS01(format.format(new Date()));
                    zyppbs.add(ppb);
                }
                dataKitNanjingDao.saveOrUpdateZYPPB(zyppbs);
               // dataKitNanjingDao.getHibernateTemplate().saveOrUpdateAll(zyppbs);
                return;
            }
            List<Formson0064> formson64List = DBAgent.find("from Formson0064 where formainId=" + formId);
            if (!CollectionUtils.isEmpty(formson64List)) {
                List<ZYSPXX> zywldwList = new ArrayList<ZYSPXX>();
                for (Formson0064 son70 : formson64List) {
                    ZYSPXX dw = new ZYSPXX();
                    Long id = UUIDLong.longUUID();
                    dw.setID(0L+id.intValue());
                    dw.setSPXX04(son70.getField0008());
                    dw.setPPB01(son70.getField0023());
                    dw.setSPFL01(son70.getField0024());
                    dw.setZBBJ(son70.getField0025() == null ? null : Integer.parseInt(son70.getField0025()));
                    dw.setSPXX71(son70.getField0012() == null ? null : Integer.parseInt(son70.getField0012()));
                    dw.setJQJX01(son70.getField0026());
                    dw.setSPXX08(son70.getField0014());
                    dw.setJLDW01(son70.getField0015());
                    dw.setSPXX70(son70.getField0016() == null ? null : Float.parseFloat(son70.getField0016()));
                    dw.setSPXX42(son70.getField0017() == null ? null : Float.parseFloat(son70.getField0017()));
                    dw.setSPXX43(son70.getField0018() == null ? null : Float.parseFloat(son70.getField0018()));
                    dw.setSPXX44(son70.getField0019() == null ? null : Float.parseFloat(son70.getField0019()));
                    dw.setSPXX63(son70.getField0020() == null ? null : Float.parseFloat(son70.getField0020()));
                    dw.setSPXX68(son70.getField0021() == null ? null : Float.parseFloat(son70.getField0021()));
                    dw.setSPXX61(son70.getField0022());
                    dw.setTBBJ(0);
                    dw.setBTOBTS01(format.format(new Date()));
                    zywldwList.add(dw);
                }
                dataKitNanjingDao.saveOrUpdateZYSPXX(zywldwList);
                return;
            }
        }catch(Exception e){
            e.printStackTrace();
        }
    }
}
