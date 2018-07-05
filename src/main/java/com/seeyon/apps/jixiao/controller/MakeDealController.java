package com.seeyon.apps.jixiao.controller;

import com.seeyon.apps.collaboration.event.CollaborationFinishEvent;
import com.seeyon.apps.jixiao.po.Formmain0638;
import com.seeyon.apps.jixiao.po.Formmain0651;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.annotation.ListenEvent;
import edu.emory.mathcs.backport.java.util.Collections;
import org.springframework.util.CollectionUtils;
import java.util.Comparator;
import java.util.List;

public class MakeDealController extends BaseController {

    private long templateId = 6196498814069326934L;

    @ListenEvent(event = CollaborationFinishEvent.class,async = true)
    public void syncForm0651(CollaborationFinishEvent event){
        Long affairId = event.getAffairId();
        System.out.println("---触发---:"+affairId);
        List<CtpAffair> affairList =  DBAgent.find("from CtpAffair where id="+affairId);
        System.out.println("---触发---:"+affairList.size());
        if(!CollectionUtils.isEmpty(affairList)){
            CtpAffair affair = affairList.get(0);
            Long templateId = affair.getTempleteId();
            if(templateId != null && this.templateId == templateId.longValue()){
                 Long formRecordId =  affair.getFormRecordid();
                System.out.println("---触发---formRecordId:"+formRecordId);
                 if(formRecordId != null){
                  List<Formmain0638> dataList =   DBAgent.find("from Formmain0638 where id="+formRecordId);
                     System.out.println("---触发---List<Formmain0638>:"+dataList.size());
                  if(CollectionUtils.isEmpty(dataList)){
                      return;
                  }
                  Formmain0638 formmain0638 = dataList.get(0);

                  String khzq =  formmain0638.getField0001();
                  System.out.println("---触发---formmain0638:"+khzq);
                  List<Formmain0651> data2List =  DBAgent.find("from Formmain0651 where field0001='"+khzq+"'");
                  // 20优秀 70 合格 10 不合格
                     if(data2List==null||data2List.isEmpty()){
                         return;
                     }
                     Collections.sort(data2List, new Comparator<Formmain0651>() {
                         public int compare(Formmain0651 o1, Formmain0651 o2) {
                             Float val1 = o1.getField0006();
                             Float val2 = o2.getField0006();
                             if(val1 == null){
                                 val1 = 0f;
                             }
                             if(val2==null){
                                 val2 = 0f;
                             }
                             return val2-val1>=0f?1:-1;
                         }
                     });
                     int len = data2List.size();
                     if(len<5){
                         return ;
                     }
                     int tag =1;
                     for(Formmain0651 data:data2List){

                         int temp = tag*10/len;
                         if(temp<=2){
                             data.setField0017("优秀");

                         } else if(temp>2&&temp<=9){
                             data.setField0017("合格");
                         }else if(temp>9){
                             data.setField0017("不合格");
                         }
                         tag++;
                     }
                     DBAgent.updateAll(data2List);
                 }
            }
        }
    }
}
