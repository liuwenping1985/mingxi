//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.apps.jixiao.controller;

import com.seeyon.apps.collaboration.event.CollaborationFinishEvent;
import com.seeyon.apps.jixiao.po.Formmain0638;
import com.seeyon.apps.jixiao.po.Formmain0651;
import com.seeyon.apps.jixiao.util.Utils;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.annotation.ListenEvent;
import org.springframework.util.CollectionUtils;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

public class MakeDealController extends BaseController {
    private long templateId = 6196498814069326934L;

    public MakeDealController() {
    }

    public ModelAndView fixData(HttpServletRequest request, HttpServletResponse response){

        String section = request.getParameter("section");


        if(section==null||"".equals(section)){

            Utils.responseJSON("error",response);
            return null;
        }
        try {
            List<Formmain0651> data2List = DBAgent.find("from Formmain0651 where field0001='" + section + "'order by field0006 desc");
            System.out.println("---触发---formmain0651:" + data2List.size());
            //来个分组---
            Map<Long, List<Formmain0651>> dataMap = new HashMap<Long, List<Formmain0651>>();
            if (data2List != null && !data2List.isEmpty()) {
                for (Formmain0651 f0651 : data2List) {

                    List<Formmain0651> list = dataMap.get(f0651.getField0028());
                    if (list == null) {
                        list = new ArrayList<Formmain0651>();
                        dataMap.put(f0651.getField0028(), list);
                    }
                    list.add(f0651);
                }
            }
            //分组完毕
            for (List<Formmain0651> data3List : dataMap.values()) {
                syncDataList(data3List);
            }
        }catch(Exception e){
            e.printStackTrace();
            Utils.responseJSON("error",response);
            return null;
        }
        Utils.responseJSON("ok",response);

        return null;



    }

    @ListenEvent(
            event = CollaborationFinishEvent.class,
            async = true
    )
    public void syncForm0651(CollaborationFinishEvent event) {
        Long affairId = event.getAffairId();
        System.out.println("---触发---:" + affairId);
        List<CtpAffair> affairList = DBAgent.find("from CtpAffair where id=" + affairId);
        System.out.println("---触发---:" + affairList.size());

        try {
            System.out.println("---触发延迟8秒---");
            Thread.sleep(8000L);
        } catch (InterruptedException var20) {
            var20.printStackTrace();
        }

        System.out.println("---触发延迟8秒结束---");
        if(!CollectionUtils.isEmpty(affairList)) {
            CtpAffair affair = (CtpAffair)affairList.get(0);
            Long templateId = affair.getTempleteId();
            if(templateId != null && this.templateId == templateId.longValue()) {
                Long formRecordId = affair.getFormRecordid();
                System.out.println("---触发---formRecordId:" + formRecordId);
                if(formRecordId != null) {
                    List<Formmain0638> dataList = null;
                    try {
                         dataList = DBAgent.find("from Formmain0638 where id=" + formRecordId);

                    }catch(Exception e){
                        e.printStackTrace();
                        System.out.println("《《《《---触发---错误----》》》》》");

                    }

                    System.out.println("---触发---List<Formmain0638>:" + dataList.size());
                    if(CollectionUtils.isEmpty(dataList)) {
                        return;
                    }
                    Formmain0638 formmain0638 = (Formmain0638)dataList.get(0);
                    String khzq = formmain0638.getField0001();
                    System.out.println("---触发---formmain0638:" + khzq);
                    List<Formmain0651> data2List = DBAgent.find("from Formmain0651 where field0001='" + khzq + "'order by field0006 desc");
                    System.out.println("---触发---formmain0651:" + data2List.size());
                    //来个分组---
                    Map<Long,List<Formmain0651>> dataMap = new HashMap<Long,List<Formmain0651>>();
                    if(data2List != null && !data2List.isEmpty()){
                        for(Formmain0651 f0651:data2List){

                            List<Formmain0651> list =  dataMap.get(f0651.getField0028());
                            if(list ==null){
                                list = new ArrayList<Formmain0651>();
                                dataMap.put(f0651.getField0028(),list);
                            }
                            list.add(f0651);
                        }
                    }
                    //分组完毕
                    for(List<Formmain0651>data3List:dataMap.values()){
                        syncDataList(data3List);
                    }

                }
            }
        }

    }

    private void syncDataList(List<Formmain0651> data2List){

        if(data2List == null || data2List.isEmpty()) {
            return;
        }
        Collections.sort(data2List, new Comparator<Formmain0651>() {
            public int compare(Formmain0651 o1, Formmain0651 o2) {
                Float of1 = o1.getField0006();
                Float of2 = o2.getField0006();
                if(of1==null){
                    of1=0f;
                }
                if(of2==null){
                    of2=0f;
                }
                Float ret = (of2-of1)*100;
                return ret.intValue();
            }
        });
        int len = data2List.size();
        if(len < 5) {
            return;
        }
        int tag = 1;
        int total = data2List.size();
        Float youxiu = Float.valueOf((float)total * 0.2F);
        Float hege = Float.valueOf((float)total * 0.9F);
        Float buhege = Float.valueOf((float)total * 0.1F);
        StringBuilder stb = new StringBuilder();

        for(Iterator var18 = data2List.iterator(); var18.hasNext(); ++tag) {
            Formmain0651 data = (Formmain0651)var18.next();
            stb.append("【" + data.getId()).append("】:" + data.getField0006()).append(",");
            if(tag <= youxiu.intValue()) {
                data.setField0017("优秀");
            } else if(tag <= hege.intValue()) {
                data.setField0017("合格");
                if(tag >= total - buhege.intValue()) {
                    data.setField0017("不合格");
                }
            } else {
                data.setField0017("不合格");
            }
        }

        System.out.println(stb.toString());
        DBAgent.updateAll(data2List);

    }

    public static void main(String[] args){

        List<Long> list = new ArrayList<Long>();
        list.add(4l);
        list.add(6l);
        list.add(1l);
        list.add(10l);
        list.add(11l);
        list.add(12l);
        list.add(13l);
        list.add(5l);
        list.add(9l);
        list.add(6l);
        StringBuilder stb = new StringBuilder();
        Collections.sort(list, new Comparator<Long>() {
            public int compare(Long o1, Long o2) {
                Long tt = o2-o1;
                return tt.intValue();
            }
        });
        for(Long ll:list){
            stb.append(ll+",");
        }
        System.out.println(stb);

    }
}
