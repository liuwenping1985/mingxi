package com.seeyon.apps.datakit.service;

import com.seeyon.apps.collaboration.event.CollaborationFinishEvent;
import com.seeyon.apps.datakit.dao.DataKitNanjingDao;
import com.seeyon.apps.datakit.po.*;
import com.seeyon.apps.datakit.util.DataKitSupporter;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.util.annotation.ListenEvent;
import org.springframework.util.CollectionUtils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

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

    public void autoSync(){



    }
    @ListenEvent(event = CollaborationFinishEvent.class,async = true)
    public void onProcess(CollaborationFinishEvent event) {
        try {
           List<CtpAffair> affairList = DBAgent.find("from CtpAffair where id=" + event.getAffairId());
            if (affairList == null) {
                return;
            }
            CtpAffair affair = affairList.get(0);

            Long formId = affair.getFormRecordid();
           if(formId == null){
                return;
            }
            List<Formson0068> formson68List = DBAgent.find("from Formson0068 where formainId=" + formId);
            if (!CollectionUtils.isEmpty(formson68List)) {
                List<ZYWLDW> zywldw68List = new ArrayList<ZYWLDW>();

                for (Formson0068 fs : formson68List) {

                    ZYWLDW dw = new ZYWLDW();
                    Long id = UUIDLong.longUUID();

                    dw.setID(0L+id.intValue());

                    try {

                        dw.setWLDW06(fs.getField0011());
                    }catch(Exception e){

                        e.printStackTrace();
                    }
                    try {

                      //  System.out.println("step:2.3");
                        Float fval = fs.getField0012();
                      //  System.out.println("step:2.3.1");
                        if(fval== null){
                            fval=0.0f;
                        }
                       // System.out.println("step:2.3.2");
                        dw.setJXSL01(fval.floatValue());
                       // System.out.println("step:2.3.3");
                    } catch (Exception e) {
                      //  System.out.println("step:2.4");
                        e.printStackTrace();
                    }catch(Error error){
                        error.printStackTrace();
                    }
                   // System.out.println("step:3");
                    dw.setWLDW20(0);
                  //  System.out.println("step:4");
                    dw.setWLDW11(fs.getField0013());
                   // System.out.println("step:5");
                    dw.setWLDW12(fs.getField0014());
                   // System.out.println("step:6");
                    dw.setWLDW13(fs.getField0015());
                  //  System.out.println("step:7");
                    dw.setDWQT06(fs.getField0016());
                  //  System.out.println("step:8");
                    dw.setDWQT08(fs.getField0017());
                   // System.out.println("step:9");
                    dw.setDQXX01(fs.getField0018());
                  //  System.out.println("step:10");
                    dw.setWLDW02(fs.getField0009());
                 //   System.out.println("step:11");
                    dw.setTBBJ(0);
                    try {
                      //  System.out.println("step:12");
                        dw.setBTOBTS01(format.format(new Date()));
                    }catch(Exception e){
                        e.printStackTrace();
                    }
                   // System.out.println("step:13");
                    zywldw68List.add(dw);
                }
               // System.out.println("save record:"+ JSON.toJSONString(zywldw68List));
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

    public void syncJQJX(boolean isMock){

        List<JQJX> dataList = dataKitNanjingDao.getListByTableName("JQJX");
        if(CollectionUtils.isEmpty(dataList)){
           System.out.println("syncJQJX -- empty to sync");
           return;
        }
        List<Formmain0246> exisitList = DBAgent.find("from Formmain0246");
        Map<String,Formmain0246> formmain0246Map = new HashMap<String,Formmain0246>();
        for(Formmain0246 main:exisitList){
            formmain0246Map.put(main.getField0001(),main);
        }
        List<Formmain0246> saveList = new ArrayList<Formmain0246>();
        for(JQJX jqjx:dataList){
            Formmain0246 exs =  formmain0246Map.get(jqjx.getJQJX01());
            if(exs!=null){
                continue;
            }
            Formmain0246 data = new Formmain0246();
            data.setField0001(jqjx.getJQJX01());
            data.setField0002(jqjx.getJQJX02());
            data.setId(UUIDLong.longUUID());
            data.setStartMemberId("7622275802860113274");
            data.setStartDate(new java.util.Date());
            data.setApproveMemberId("0");
            data.setApproveDate(new java.util.Date());
            data.setState(1);
            data.setFinishedFlag(0);
            data.setRatifyMemberId("0");
            data.setRatifyFlag(0);
            data.setModifyDate(new Date());
            data.setModifyMemberId("7622275802860113274");
            saveList.add(data);
        }
        try {
            System.out.println("syncJQJX size:"+saveList.size());
            if(!CollectionUtils.isEmpty(saveList)){
                if(!isMock){
                    DBAgent.saveAll(saveList);
                }
            }
        }catch(Exception e){
            e.printStackTrace();
        }


    }
    public void syncSPFL(boolean isMock){
        List<SPFL> dataList = new ArrayList<SPFL>();
        SimpleDateFormat format2 = new SimpleDateFormat("YYYYMMddHHmmssSSSFFF");

        //先找OA时间最大的那个
        List<Formmain0248> exisitList = DBAgent.find("from Formmain0248 where startDate=(select max(startDate) from Formmain0248)");
        if(CollectionUtils.isEmpty(exisitList)){
            dataList = dataKitNanjingDao.getListByTableName("SPFL");
        }else{
            Formmain0248 main = exisitList.get(0);
            Date seedDate = main.getStartDate();
            String seedDateString = format2.format(seedDate);
            dataList = dataKitNanjingDao.getListByTableName("SPFL where BTOBTS01 >'"+seedDateString+"'");

        }
        System.out.println("max dataList:"+dataList.size());
      //  List<SPFL> dataList = dataKitNanjingDao.getListByTableName("SPFL");
        if(CollectionUtils.isEmpty(dataList)){
            return ;
        }
        List<Formmain0248> saveList = new ArrayList<Formmain0248>();
        for(SPFL spfl:dataList){
            Formmain0248 data = new Formmain0248();
            data.setId(UUIDLong.longUUID());
            data.setStartMemberId("7622275802860113274");
            try {
                Date dt = format2.parse(spfl.getBTOBTS01());
                data.setStartDate(dt);
            } catch (ParseException e) {
                e.printStackTrace();
                data.setStartDate(new java.util.Date());
            }
            data.setApproveMemberId("0");
            data.setApproveDate(new java.util.Date());
            data.setState(1);
            data.setFinishedFlag(0);
            data.setRatifyMemberId("0");
            data.setRatifyFlag(0);
            data.setModifyDate(new Date());
            data.setModifyMemberId("7622275802860113274");
            data.setField0001(String.valueOf(spfl.getSPFL03()));
            data.setField0002(spfl.getSPFL01());
            data.setField0003(spfl.getSPF_SPFL01());
            data.setField0004(spfl.getSPFL02());
            data.setField0005(String.valueOf(spfl.getSPFL04()));
            saveList.add(data);
        }
        if(!isMock){
            DBAgent.saveAll(saveList);
        }
    }

    public void syncPPB(boolean isMock){
        List<PPB> dataList = new ArrayList<PPB>();
        SimpleDateFormat format2 = new SimpleDateFormat("YYYYMMddHHmmssSSSFFF");

        //先找OA时间最大的那个
        List<Formmain0247> exisitList = DBAgent.find("from Formmain0247 where startDate=(select max(startDate) from Formmain0247)");
        if(CollectionUtils.isEmpty(exisitList)){
            dataList = dataKitNanjingDao.getListByTableName("PPB");
        }else{
            System.out.println("---------syncPPB-----------");
            Formmain0247 main = exisitList.get(0);
            Date seedDate = main.getStartDate();
            String seedDateString = format2.format(seedDate);
            System.out.println("---------syncPPB-----------seedDate");
            dataList = dataKitNanjingDao.getListByTableName("PPB where BTOBTS01 > '"+seedDateString+"'");

        }
       // List<PPB> dataList = dataKitNanjingDao.getListByTableName("PPB");
        if(CollectionUtils.isEmpty(dataList)){
           return;
        }
        List<Formmain0247> saveList = new ArrayList<Formmain0247>();
        for(PPB ppb:dataList){
            Formmain0247 data = new Formmain0247();
            data.setId(UUIDLong.longUUID());
            data.setStartMemberId("7622275802860113274");
            try {
                Date dt = format2.parse(ppb.getBTOBTS01());
                data.setStartDate(dt);
            } catch (ParseException e) {
                e.printStackTrace();
                data.setStartDate(new java.util.Date());
            }

            data.setApproveMemberId("0");
            data.setApproveDate(new java.util.Date());
            data.setState(1);
            data.setFinishedFlag(0);
            data.setRatifyMemberId("0");
            data.setRatifyFlag(0);
            data.setModifyDate(new Date());
            data.setModifyMemberId("7622275802860113274");
            data.setField0001(ppb.getPPB01());
            data.setField0002(ppb.getPPB02());
            saveList.add(data);
        }
        if(!isMock){
            DBAgent.saveAll(saveList);
        }
    }

    public void syncDQXX(boolean isMock){
        List<DQXX> dataList = new ArrayList<DQXX>();
        SimpleDateFormat format2 = new SimpleDateFormat("YYYYMMddHHmmssSSSFFF");

        //先找OA时间最大的那个
        List<Formmain0250> exisitList = DBAgent.find("from Formmain0651 where startDate=(select max(startDate) from Formmain0651)");
        if(CollectionUtils.isEmpty(exisitList)){
            dataList = dataKitNanjingDao.getListByTableName("PPB");
        }else{
            System.out.println("---------syncDQXX-----------");
            Formmain0250 main = exisitList.get(0);
            Date seedDate = main.getStartDate();
            String seedDateString = format2.format(seedDate);
            System.out.println("---------syncDQXX-----------seedDate:"+seedDateString);
            dataList = dataKitNanjingDao.getListByTableName("DQXX where BTOBTS01 > '"+seedDateString+"'");

        }
        // List<PPB> dataList = dataKitNanjingDao.getListByTableName("PPB");
        if(CollectionUtils.isEmpty(dataList)){
            return;
        }
        List<Formmain0250> saveList = new ArrayList<Formmain0250>();
        for(DQXX dqxx:dataList){
            Formmain0250 data = new Formmain0250();
            data.setId(UUIDLong.longUUID());
            data.setStartMemberId("7622275802860113274");
            try {
                Date dt = format2.parse(dqxx.getBTOBTS01());
                data.setStartDate(dt);
            } catch (ParseException e) {
                e.printStackTrace();
                data.setStartDate(new java.util.Date());
            }

            data.setApproveMemberId("0");
            data.setApproveDate(new java.util.Date());
            data.setState(1);
            data.setFinishedFlag(0);
            data.setRatifyMemberId("0");
            data.setRatifyFlag(0);
            data.setModifyDate(new Date());
            data.setModifyMemberId("7622275802860113274");
            data.setField0001(dqxx.getDQXX02());
            data.setField0002(dqxx.getDQXX01());
            data.setField0003(dqxx.getDQX_DQXX01());
            data.setField0004(String.valueOf(dqxx.getDQXX03()));
            data.setField0005(String.valueOf(dqxx.getDQXX04()));
            saveList.add(data);
        }
        if(!isMock){
            DBAgent.saveAll(saveList);
        }

    }

}
